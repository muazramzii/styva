"""Payment core. Provider-agnostic: every provider goes through the same
initiation and event-processing functions below.

State rules
- Order pending  + Payment pending  -> awaiting payment
- Payment success -> Order paid     (order.payment_status = success)
- Payment failed  -> Order stays pending (order.payment_status = failed), retryable
- A payment leaves ``pending`` exactly once. Events for a payment that is
  already success/failed are recorded but not applied.
- The only code that moves a payment's status is ``_apply_status``, reached
  only from authenticated provider events (or the dev-only mock simulator).

Stock: unchanged from Phase 1.5 -- stock was already deducted when the order
was created. A failed payment does not restore stock; restocking/refunds
belong to a later phase (see ``_apply_status`` for where that hook goes).
"""
import secrets

from django.conf import settings
from django.db import transaction

from apps.orders.models import Order

from .models import Payment, PaymentEvent
from .providers import ProviderEvent, get_default_provider

_REFERENCE_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'


class PaymentError(Exception):
    status_code = 400

    def __init__(self, detail):
        super().__init__(detail)
        self.detail = detail


class OrderNotFoundError(PaymentError):
    status_code = 404

    def __init__(self):
        super().__init__('Order not found.')


class OrderAlreadyPaidError(PaymentError):
    status_code = 409

    def __init__(self):
        super().__init__('This order has already been paid.')


class OrderNotPayableError(PaymentError):
    status_code = 409

    def __init__(self):
        super().__init__('This order can no longer be paid.')


class UnknownPaymentError(PaymentError):
    def __init__(self):
        super().__init__('Unknown payment.')


class AmountMismatchError(PaymentError):
    def __init__(self):
        super().__init__('Event amount does not match the payment amount.')


class MockPaymentsDisabledError(PaymentError):
    status_code = 404

    def __init__(self):
        super().__init__('Not found.')


def generate_payment_reference():
    while True:
        reference = 'PAY-' + ''.join(secrets.choice(_REFERENCE_ALPHABET) for _ in range(10))
        if not Payment.objects.filter(reference=reference).exists():
            return reference


@transaction.atomic
def initiate_payment(user, order_id):
    """Return ``(payment, created)``. Reuses the order's pending payment if
    there is one, so repeated "Pay" taps never pile up payment records."""
    # Locking the order serializes concurrent initiations for the same order;
    # the one-pending-payment DB constraint is the backstop.
    order = Order.objects.select_for_update().filter(id=order_id, user=user).first()
    if order is None:
        raise OrderNotFoundError()
    if order.payment_status == Order.PaymentStatus.SUCCESS or order.status == Order.Status.PAID:
        raise OrderAlreadyPaidError()
    if order.status != Order.Status.PENDING:
        raise OrderNotPayableError()

    existing = order.payments.filter(payment_status=Payment.Status.PENDING).first()
    if existing is not None:
        return existing, False

    provider = get_default_provider()
    payment = Payment.objects.create(
        order=order,
        reference=generate_payment_reference(),
        provider=provider.name,
        amount=order.total,  # always the order's own total, never client input
    )
    session = provider.create_payment(payment)
    payment.provider_reference = session.provider_reference
    payment.save(update_fields=['provider_reference', 'updated_at'])

    if order.payment_status != Order.PaymentStatus.PENDING:
        # Retrying after a failed attempt.
        order.payment_status = Order.PaymentStatus.PENDING
        order.save(update_fields=['payment_status', 'updated_at'])

    return payment, True


@transaction.atomic
def process_provider_event(provider_name, event: ProviderEvent):
    """Apply an authenticated provider event. Return ``(event_record, duplicate)``.

    Idempotent: the same provider event id is only ever applied once, and a
    payment can only transition out of ``pending`` once, so a redelivered
    webhook or a repeated success for the same transaction is a no-op."""
    payment = (
        Payment.objects.select_for_update()
        .filter(provider=provider_name, provider_reference=event.provider_reference)
        .first()
    )
    if payment is None:
        raise UnknownPaymentError()

    # Checked while holding the payment lock, so two concurrent deliveries of
    # the same event serialize here and the second one sees the first.
    existing = PaymentEvent.objects.filter(provider=provider_name, event_id=event.event_id).first()
    if existing is not None:
        return existing, True

    if event.amount is not None and event.amount != payment.amount:
        raise AmountMismatchError()

    applied = _apply_status(payment, event.status)
    record = PaymentEvent.objects.create(
        provider=provider_name,
        event_id=event.event_id,
        payment=payment,
        status=event.status,
        outcome=PaymentEvent.Outcome.APPLIED if applied else PaymentEvent.Outcome.IGNORED,
        payload=event.raw,
    )
    return record, False


def _apply_status(payment, new_status):
    if payment.payment_status != Payment.Status.PENDING or new_status == Payment.Status.PENDING:
        return False

    order = Order.objects.select_for_update().get(pk=payment.order_id)
    payment.payment_status = new_status
    payment.save(update_fields=['payment_status', 'updated_at'])

    if new_status == Payment.Status.SUCCESS:
        order.payment_status = Order.PaymentStatus.SUCCESS
        if order.status == Order.Status.PENDING:
            order.status = Order.Status.PAID
        order.save(update_fields=['payment_status', 'status', 'updated_at'])
    elif order.payment_status != Order.PaymentStatus.SUCCESS:
        # Failed: the order stays pending and can be retried. Stock is not
        # restored here -- a future restock/cancellation policy hooks in here.
        order.payment_status = Order.PaymentStatus.FAILED
        order.save(update_fields=['payment_status', 'updated_at'])
    return True


def simulate_mock_outcome(user, payment_id, outcome):
    """DEVELOPMENT ONLY. Lets the owner of a *mock* payment simulate the
    provider reporting success/failure, through the same event pipeline a real
    webhook uses. Disabled (404) unless PAYMENT_MOCK_ENABLED."""
    if not settings.PAYMENT_MOCK_ENABLED:
        raise MockPaymentsDisabledError()

    payment = Payment.objects.filter(id=payment_id, order__user=user, provider='mock').first()
    if payment is None:
        raise MockPaymentsDisabledError()

    event = ProviderEvent(
        # Deterministic id: repeated "Simulate Success" taps are one event.
        event_id=f'simulated-{payment.reference}-{outcome}',
        provider_reference=payment.provider_reference,
        status=outcome,
        amount=payment.amount,
        raw={'simulated': True, 'outcome': outcome},
    )
    process_provider_event('mock', event)
    payment.refresh_from_db()
    return payment
