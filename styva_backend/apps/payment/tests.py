import json
import threading
from decimal import Decimal

from django.contrib.auth import get_user_model
from django.db import connection
from django.test import TransactionTestCase, override_settings
from rest_framework import status
from rest_framework.test import APIClient, APITestCase
from rest_framework_simplejwt.tokens import RefreshToken

from apps.orders import services as order_services
from apps.orders.models import Order
from apps.orders.tests import SHIPPING_ADDRESS, add_to_cart, make_catalog

from . import services
from .models import Payment, PaymentEvent
from .providers import ProviderEvent
from .providers.mock import SIGNATURE_HEADER, sign

User = get_user_model()

WEBHOOK_SECRET = 'test-only-webhook-secret'
WEBHOOK_URL = '/api/payments/webhook/mock'
SIGNATURE_META = 'HTTP_' + SIGNATURE_HEADER.upper().replace('-', '_')


def make_user(email='buyer@example.com'):
    return User.objects.create_user(email=email, password='CorrectPass123!', full_name='Buyer')


def place_order(user, variant, quantity=1):
    add_to_cart(user, variant, quantity)
    return order_services.checkout(user, SHIPPING_ADDRESS)


def webhook_body(payment, status_, event_id='evt-1', amount=None):
    return json.dumps({
        'event_id': event_id,
        'provider_reference': payment.provider_reference,
        'status': status_,
        'amount': str(payment.amount if amount is None else amount),
    }).encode()


@override_settings(PAYMENT_DEFAULT_PROVIDER='mock', PAYMENT_MOCK_ENABLED=True,
                   MOCK_PAYMENT_WEBHOOK_SECRET=WEBHOOK_SECRET)
class PaymentTestCase(APITestCase):
    def setUp(self):
        self.user = make_user()
        _, _, self.shirt_m, self.tee_l = make_catalog()
        self.order = place_order(self.user, self.shirt_m, 2)
        self.client.force_authenticate(user=self.user)

    def initiate(self, payload=None):
        return self.client.post(
            '/api/payments/initiate',
            {'order_id': self.order.id} if payload is None else payload,
            format='json',
        )

    def simulate(self, payment_id, outcome):
        return self.client.post(
            f'/api/payments/{payment_id}/mock-complete', {'outcome': outcome}, format='json',
        )

    def send_webhook(self, body, signature=None, client=None):
        client = client or APIClient()
        extra = {} if signature is False else {SIGNATURE_META: signature or sign(body, WEBHOOK_SECRET)}
        return client.post(WEBHOOK_URL, data=body, content_type='application/json', **extra)

    def refresh(self, *objects):
        for obj in objects:
            obj.refresh_from_db()


class InitiatePaymentTests(PaymentTestCase):
    def test_initiate_creates_pending_payment_for_order_total(self):
        response = self.initiate()

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        payment = Payment.objects.get(id=response.data['id'])
        self.assertEqual(payment.order, self.order)
        self.assertEqual(payment.amount, self.order.total)
        self.assertEqual(payment.payment_status, Payment.Status.PENDING)
        self.assertEqual(payment.provider, 'mock')
        self.assertRegex(payment.reference, r'^PAY-[A-Z2-9]{10}$')
        self.assertTrue(payment.provider_reference.startswith('MOCK-'))
        self.assertEqual(response.data['amount'], str(self.order.total))
        self.assertEqual(response.data['status'], 'pending')
        self.assertEqual(response.data['order_id'], self.order.id)
        self.assertEqual(response.data['order_number'], self.order.order_number)

    def test_response_exposes_only_public_fields(self):
        response = self.initiate()

        self.assertEqual(set(response.data), {
            'id', 'reference', 'order_id', 'order_number', 'amount', 'status',
            'provider', 'provider_reference', 'created_at', 'updated_at',
        })
        self.assertNotIn(WEBHOOK_SECRET, json.dumps(response.data, default=str))

    def test_requires_authentication(self):
        self.client.force_authenticate(user=None)
        self.assertEqual(self.initiate().status_code, status.HTTP_401_UNAUTHORIZED)
        self.assertFalse(Payment.objects.exists())

    def test_cannot_pay_for_another_users_order(self):
        other = make_user('other@example.com')
        self.client.force_authenticate(user=other)

        response = self.initiate()

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertFalse(Payment.objects.exists())

    def test_unknown_order_returns_404(self):
        response = self.initiate({'order_id': 999999})
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_missing_or_invalid_order_id_is_rejected(self):
        for payload in ({}, {'order_id': 'abc'}, {'order_id': 0}, {'order_id': -1}):
            with self.subTest(payload=payload):
                self.assertEqual(self.initiate(payload).status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(Payment.objects.exists())

    def test_client_supplied_amount_and_status_are_ignored(self):
        response = self.initiate({
            'order_id': self.order.id,
            'amount': '0.01',
            'total': '0.01',
            'order_total': '0.01',
            'payment_status': 'success',
            'status': 'success',
            'provider': 'stripe',
            'provider_reference': 'FAKE-REF',
        })

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        payment = Payment.objects.get()
        self.assertEqual(payment.amount, self.order.total)
        self.assertEqual(payment.payment_status, Payment.Status.PENDING)
        self.assertEqual(payment.provider, 'mock')
        self.assertNotEqual(payment.provider_reference, 'FAKE-REF')
        self.refresh(self.order)
        self.assertEqual(self.order.status, Order.Status.PENDING)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.PENDING)

    def test_repeat_initiation_reuses_the_pending_payment(self):
        first = self.initiate()
        second = self.initiate()

        self.assertEqual(first.status_code, status.HTTP_201_CREATED)
        self.assertEqual(second.status_code, status.HTTP_200_OK)
        self.assertEqual(first.data['id'], second.data['id'])
        self.assertEqual(Payment.objects.count(), 1)

    def test_paid_order_cannot_be_paid_again(self):
        payment_id = self.initiate().data['id']
        self.simulate(payment_id, 'success')

        response = self.initiate()

        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
        self.assertEqual(Payment.objects.count(), 1)

    def test_cancelled_order_cannot_be_paid(self):
        Order.objects.filter(id=self.order.id).update(status=Order.Status.CANCELLED)

        response = self.initiate()

        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
        self.assertFalse(Payment.objects.exists())

    def test_retry_after_failure_creates_a_new_attempt_and_keeps_history(self):
        failed_id = self.initiate().data['id']
        self.simulate(failed_id, 'failed')

        response = self.initiate()

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertNotEqual(response.data['id'], failed_id)
        self.assertEqual(Payment.objects.get(id=failed_id).payment_status, Payment.Status.FAILED)
        self.assertEqual(response.data['status'], 'pending')
        self.refresh(self.order)
        self.assertEqual(self.order.status, Order.Status.PENDING)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.PENDING)


class PaymentDetailTests(PaymentTestCase):
    def setUp(self):
        super().setUp()
        self.payment_id = self.initiate().data['id']

    def test_owner_can_view_payment(self):
        response = self.client.get(f'/api/payments/{self.payment_id}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['id'], self.payment_id)
        self.assertEqual(response.data['status'], 'pending')

    def test_other_user_cannot_view_payment(self):
        self.client.force_authenticate(user=make_user('other@example.com'))
        response = self.client.get(f'/api/payments/{self.payment_id}')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_requires_authentication(self):
        self.client.force_authenticate(user=None)
        response = self.client.get(f'/api/payments/{self.payment_id}')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_status_cannot_be_modified_by_the_client(self):
        url = f'/api/payments/{self.payment_id}'
        for method in (self.client.patch, self.client.put):
            with self.subTest(method=method.__name__):
                response = method(url, {'status': 'success', 'payment_status': 'success'}, format='json')
                self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)
        self.assertEqual(self.client.delete(url).status_code, status.HTTP_405_METHOD_NOT_ALLOWED)

        payment = Payment.objects.get(id=self.payment_id)
        self.assertEqual(payment.payment_status, Payment.Status.PENDING)
        self.refresh(self.order)
        self.assertEqual(self.order.status, Order.Status.PENDING)


class MockCompletionTests(PaymentTestCase):
    def setUp(self):
        super().setUp()
        self.payment = Payment.objects.get(id=self.initiate().data['id'])

    def test_success_marks_payment_success_and_order_paid(self):
        response = self.simulate(self.payment.id, 'success')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['status'], 'success')
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.SUCCESS)
        self.assertEqual(self.order.status, Order.Status.PAID)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.SUCCESS)

    def test_failure_marks_payment_failed_and_leaves_order_pending(self):
        response = self.simulate(self.payment.id, 'failed')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['status'], 'failed')
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.FAILED)
        self.assertEqual(self.order.status, Order.Status.PENDING)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.FAILED)

    def test_stock_is_not_changed_by_payment_outcome(self):
        # Phase 1.5 rule: stock deducted at order creation (5 - 2), never restored.
        self.shirt_m.refresh_from_db()
        self.assertEqual(self.shirt_m.stock, 3)

        self.simulate(self.payment.id, 'failed')

        self.shirt_m.refresh_from_db()
        self.assertEqual(self.shirt_m.stock, 3)

    def test_repeated_success_is_applied_once(self):
        first = self.simulate(self.payment.id, 'success')
        second = self.simulate(self.payment.id, 'success')

        self.assertEqual(first.status_code, status.HTTP_200_OK)
        self.assertEqual(second.status_code, status.HTTP_200_OK)
        self.assertEqual(second.data['status'], 'success')
        self.assertEqual(PaymentEvent.objects.count(), 1)

    def test_success_after_failure_is_ignored(self):
        self.simulate(self.payment.id, 'failed')
        response = self.simulate(self.payment.id, 'success')

        self.assertEqual(response.data['status'], 'failed')
        self.refresh(self.order)
        self.assertEqual(self.order.status, Order.Status.PENDING)
        self.assertEqual(
            PaymentEvent.objects.get(status='success').outcome, PaymentEvent.Outcome.IGNORED,
        )

    def test_invalid_outcome_is_rejected(self):
        for outcome in ('pending', 'paid', 'SUCCESS', ''):
            with self.subTest(outcome=outcome):
                response = self.simulate(self.payment.id, outcome)
                self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.refresh(self.payment)
        self.assertEqual(self.payment.payment_status, Payment.Status.PENDING)

    def test_other_user_cannot_simulate(self):
        self.client.force_authenticate(user=make_user('other@example.com'))

        response = self.simulate(self.payment.id, 'success')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.refresh(self.payment)
        self.assertEqual(self.payment.payment_status, Payment.Status.PENDING)

    def test_requires_authentication(self):
        self.client.force_authenticate(user=None)
        response = self.simulate(self.payment.id, 'success')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_disabled_outside_development(self):
        with override_settings(PAYMENT_MOCK_ENABLED=False):
            response = self.simulate(self.payment.id, 'success')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.PENDING)
        self.assertEqual(self.order.status, Order.Status.PENDING)

    def test_only_mock_payments_can_be_simulated(self):
        Payment.objects.filter(id=self.payment.id).update(provider='toyyibpay')

        response = self.simulate(self.payment.id, 'success')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.refresh(self.payment)
        self.assertEqual(self.payment.payment_status, Payment.Status.PENDING)


class WebhookTests(PaymentTestCase):
    def setUp(self):
        super().setUp()
        self.payment = Payment.objects.get(id=self.initiate().data['id'])

    def assert_untouched(self):
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.PENDING)
        self.assertEqual(self.order.status, Order.Status.PENDING)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.PENDING)
        self.assertFalse(PaymentEvent.objects.exists())

    def test_signed_success_event_marks_order_paid(self):
        response = self.send_webhook(webhook_body(self.payment, 'success'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data, {'result': 'applied'})
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.SUCCESS)
        self.assertEqual(self.order.status, Order.Status.PAID)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.SUCCESS)

    def test_signed_failure_event_leaves_order_pending(self):
        response = self.send_webhook(webhook_body(self.payment, 'failed'))

        self.assertEqual(response.data, {'result': 'applied'})
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.FAILED)
        self.assertEqual(self.order.status, Order.Status.PENDING)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.FAILED)

    def test_redelivered_event_is_processed_once(self):
        body = webhook_body(self.payment, 'success')

        first = self.send_webhook(body)
        second = self.send_webhook(body)

        self.assertEqual(first.data, {'result': 'applied'})
        self.assertEqual(second.status_code, status.HTTP_200_OK)
        self.assertEqual(second.data, {'result': 'duplicate'})
        self.assertEqual(PaymentEvent.objects.count(), 1)

    def test_second_success_for_same_transaction_is_ignored(self):
        self.send_webhook(webhook_body(self.payment, 'success', event_id='evt-1'))
        response = self.send_webhook(webhook_body(self.payment, 'success', event_id='evt-2'))

        self.assertEqual(response.data, {'result': 'ignored'})
        self.assertEqual(Payment.objects.filter(payment_status='success').count(), 1)

    def test_late_failure_does_not_undo_success(self):
        self.send_webhook(webhook_body(self.payment, 'success', event_id='evt-1'))
        response = self.send_webhook(webhook_body(self.payment, 'failed', event_id='evt-2'))

        self.assertEqual(response.data, {'result': 'ignored'})
        self.refresh(self.payment, self.order)
        self.assertEqual(self.payment.payment_status, Payment.Status.SUCCESS)
        self.assertEqual(self.order.status, Order.Status.PAID)
        self.assertEqual(self.order.payment_status, Order.PaymentStatus.SUCCESS)

    def test_pending_event_does_not_change_anything(self):
        response = self.send_webhook(webhook_body(self.payment, 'pending'))

        self.assertEqual(response.data, {'result': 'ignored'})
        self.refresh(self.payment)
        self.assertEqual(self.payment.payment_status, Payment.Status.PENDING)

    def test_invalid_signature_is_rejected(self):
        body = webhook_body(self.payment, 'success')
        response = self.send_webhook(body, signature=sign(body, 'wrong-secret'))
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_missing_signature_is_rejected(self):
        response = self.send_webhook(webhook_body(self.payment, 'success'), signature=False)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_tampered_body_is_rejected(self):
        original = webhook_body(self.payment, 'failed')
        tampered = webhook_body(self.payment, 'success')
        response = self.send_webhook(tampered, signature=sign(original, WEBHOOK_SECRET))
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_webhooks_rejected_when_no_secret_is_configured(self):
        body = webhook_body(self.payment, 'success')
        with override_settings(MOCK_PAYMENT_WEBHOOK_SECRET=''):
            response = self.send_webhook(body, signature=sign(body, ''))
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_customer_token_cannot_fake_a_callback(self):
        client = APIClient()
        client.credentials(HTTP_AUTHORIZATION=f'Bearer {RefreshToken.for_user(self.user).access_token}')

        response = self.send_webhook(webhook_body(self.payment, 'success'), signature=False, client=client)

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_unknown_provider_returns_404(self):
        body = webhook_body(self.payment, 'success')
        response = APIClient().post(
            '/api/payments/webhook/stripe', data=body, content_type='application/json',
            **{SIGNATURE_META: sign(body, WEBHOOK_SECRET)},
        )
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assert_untouched()

    def test_unknown_provider_reference_is_rejected(self):
        body = json.dumps({
            'event_id': 'evt-1', 'provider_reference': 'MOCK-DOESNOTEXIST',
            'status': 'success', 'amount': str(self.payment.amount),
        }).encode()
        response = self.send_webhook(body)
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_amount_mismatch_is_rejected(self):
        response = self.send_webhook(webhook_body(self.payment, 'success', amount=Decimal('0.01')))
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()

    def test_malformed_events_are_rejected(self):
        bodies = [
            b'not json',
            b'[]',
            json.dumps({'provider_reference': self.payment.provider_reference, 'status': 'success'}).encode(),
            json.dumps({'event_id': 'e', 'provider_reference': self.payment.provider_reference,
                        'status': 'paid'}).encode(),
            json.dumps({'event_id': 'e', 'provider_reference': self.payment.provider_reference,
                        'status': 'success', 'amount': 'lots'}).encode(),
            json.dumps({'event_id': 'e', 'provider_reference': self.payment.provider_reference,
                        'status': ['success']}).encode(),
            json.dumps({'event_id': None, 'provider_reference': self.payment.provider_reference,
                        'status': 'success'}).encode(),
            json.dumps({'event_id': 'e', 'provider_reference': {'ref': 1},
                        'status': 'success'}).encode(),
        ]
        for body in bodies:
            with self.subTest(body=body):
                self.assertEqual(self.send_webhook(body).status_code, status.HTTP_400_BAD_REQUEST)
        self.assert_untouched()


@override_settings(PAYMENT_DEFAULT_PROVIDER='mock')
class ProcessProviderEventTests(APITestCase):
    def setUp(self):
        self.user = make_user()
        _, _, shirt_m, _ = make_catalog()
        self.order = place_order(self.user, shirt_m)
        self.payment, _ = services.initiate_payment(self.user, self.order.id)

    def event(self, status_, event_id='evt-1'):
        return ProviderEvent(event_id=event_id, provider_reference=self.payment.provider_reference,
                             status=status_, amount=self.payment.amount)

    def test_event_for_another_provider_is_unknown(self):
        with self.assertRaises(services.UnknownPaymentError):
            services.process_provider_event('toyyibpay', self.event('success'))

    def test_duplicate_event_returns_original_record(self):
        record, duplicate = services.process_provider_event('mock', self.event('success'))
        again, duplicate_again = services.process_provider_event('mock', self.event('success'))

        self.assertFalse(duplicate)
        self.assertTrue(duplicate_again)
        self.assertEqual(record.id, again.id)


@override_settings(PAYMENT_DEFAULT_PROVIDER='mock', MOCK_PAYMENT_WEBHOOK_SECRET=WEBHOOK_SECRET)
class ConcurrentPaymentTestCase(TransactionTestCase):
    """Real concurrent requests on separate DB connections, to prove the row
    locks keep initiation and event processing idempotent under races."""

    def setUp(self):
        self.user = make_user()
        _, _, shirt_m, _ = make_catalog()
        self.order = place_order(self.user, shirt_m)

    def run_concurrently(self, action, count=4):
        barrier = threading.Barrier(count)
        results = []

        def attempt():
            try:
                barrier.wait()
                results.append(action())
            finally:
                connection.close()

        threads = [threading.Thread(target=attempt) for _ in range(count)]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()
        return results

    def test_concurrent_initiations_create_one_payment(self):
        def initiate():
            client = APIClient()
            client.force_authenticate(user=self.user)
            return client.post('/api/payments/initiate', {'order_id': self.order.id}, format='json')

        responses = self.run_concurrently(initiate)

        self.assertEqual(sorted(r.status_code for r in responses), [200, 200, 200, 201])
        self.assertEqual(len({r.data['id'] for r in responses}), 1)
        self.assertEqual(Payment.objects.count(), 1)

    def test_concurrent_duplicate_webhooks_apply_once(self):
        payment, _ = services.initiate_payment(self.user, self.order.id)
        body = webhook_body(payment, 'success')
        signature = sign(body, WEBHOOK_SECRET)

        def deliver():
            return APIClient().post(
                WEBHOOK_URL, data=body, content_type='application/json', **{SIGNATURE_META: signature},
            )

        responses = self.run_concurrently(deliver)

        self.assertEqual([r.status_code for r in responses], [200] * 4)
        self.assertEqual(sorted(r.data['result'] for r in responses),
                         ['applied', 'duplicate', 'duplicate', 'duplicate'])
        self.assertEqual(PaymentEvent.objects.count(), 1)
        self.order.refresh_from_db()
        self.assertEqual(self.order.status, Order.Status.PAID)
