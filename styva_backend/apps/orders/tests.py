import re
import threading
from decimal import Decimal
from unittest import mock

from django.contrib.auth import get_user_model
from django.db import connection
from django.test import TransactionTestCase, override_settings
from rest_framework import status
from rest_framework.test import APIClient, APITestCase

from apps.brands.models import Brand
from apps.cart.models import Cart, CartItem
from apps.categories.models import Category
from apps.products.models import Product, ProductVariant

from . import services
from .models import Order, OrderItem

User = get_user_model()

SHIPPING_ADDRESS = {
    'full_name': 'Test Buyer',
    'phone': '0123456789',
    'address_line_1': '1 Jalan Ujian',
    'address_line_2': '',
    'city': 'Skudai',
    'state': 'Johor',
    'postcode': '81300',
}


def make_catalog():
    brand = Brand.objects.create(name='UNIQLO', slug='uniqlo')
    category = Category.objects.create(name='Tops', slug='tops')
    shirt = Product.objects.create(
        sku='UNQ001', name='Oversized Cotton Shirt', brand=brand, category=category,
        price=Decimal('89.90'),
    )
    tee = Product.objects.create(
        sku='UNQ002', name='Basic Tee', brand=brand, category=category,
        price=Decimal('29.90'),
    )
    shirt_m = ProductVariant.objects.create(product=shirt, size='M', color='Black', stock=5)
    tee_l = ProductVariant.objects.create(product=tee, size='L', color='White', stock=10)
    return shirt, tee, shirt_m, tee_l


def add_to_cart(user, variant, quantity):
    cart, _ = Cart.objects.get_or_create(user=user)
    return CartItem.objects.create(cart=cart, variant=variant, quantity=quantity)


class CheckoutTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='buyer@example.com', password='CorrectPass123!', full_name='Buyer',
        )
        self.shirt, self.tee, self.shirt_m, self.tee_l = make_catalog()
        self.client.force_authenticate(user=self.user)

    def checkout(self, payload=None):
        return self.client.post(
            '/api/orders/checkout', payload or {'shipping_address': SHIPPING_ADDRESS}, format='json',
        )

    def test_successful_checkout_creates_order_and_items(self):
        add_to_cart(self.user, self.shirt_m, 2)
        add_to_cart(self.user, self.tee_l, 1)

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        order = Order.objects.get(id=response.data['id'])
        self.assertEqual(order.user, self.user)
        self.assertEqual(order.status, Order.Status.PENDING)
        self.assertEqual(order.payment_status, Order.PaymentStatus.PENDING)
        self.assertEqual(order.items.count(), 2)
        self.assertEqual(response.data['shipping_address']['city'], 'Skudai')
        self.assertEqual(len(response.data['items']), 2)

    def test_order_number_is_human_readable_and_not_the_database_id(self):
        add_to_cart(self.user, self.shirt_m, 1)

        response = self.checkout()

        self.assertRegex(response.data['order_number'], r'^STYVA-\d{8}-[A-Z2-9]{6}$')
        suffix = response.data['order_number'].split('-')[-1]
        self.assertNotEqual(suffix, f"{response.data['id']:06d}")

    def test_order_items_snapshot_product_and_variant_details(self):
        add_to_cart(self.user, self.shirt_m, 2)

        response = self.checkout()

        item = response.data['items'][0]
        self.assertEqual(item['product_name'], 'Oversized Cotton Shirt')
        self.assertEqual(item['brand'], 'UNIQLO')
        self.assertEqual(item['size'], 'M')
        self.assertEqual(item['color'], 'Black')
        self.assertEqual(item['unit_price'], '89.90')
        self.assertEqual(item['quantity'], 2)
        self.assertEqual(item['subtotal'], '179.80')

    @override_settings(SHIPPING_FLAT_FEE=Decimal('8.00'))
    def test_subtotal_shipping_fee_and_total_are_calculated_by_the_backend(self):
        add_to_cart(self.user, self.shirt_m, 2)  # 179.80
        add_to_cart(self.user, self.tee_l, 3)    # 89.70

        response = self.checkout()

        self.assertEqual(response.data['subtotal'], '269.50')
        self.assertEqual(response.data['shipping_fee'], '8.00')
        self.assertEqual(response.data['total'], '277.50')

    def test_default_shipping_fee_is_zero(self):
        add_to_cart(self.user, self.tee_l, 1)

        response = self.checkout()

        self.assertEqual(response.data['shipping_fee'], '0.00')
        self.assertEqual(response.data['total'], '29.90')

    def test_stock_is_deducted_on_successful_checkout(self):
        add_to_cart(self.user, self.shirt_m, 2)

        self.checkout()

        self.shirt_m.refresh_from_db()
        self.assertEqual(self.shirt_m.stock, 3)

    def test_purchased_cart_items_are_removed_after_checkout(self):
        add_to_cart(self.user, self.shirt_m, 1)

        self.checkout()

        self.assertFalse(CartItem.objects.filter(cart__user=self.user).exists())

    def test_empty_cart_is_rejected(self):
        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(Order.objects.exists())

    def test_user_without_a_cart_is_rejected_as_empty(self):
        self.assertFalse(Cart.objects.filter(user=self.user).exists())

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_unauthenticated_checkout_is_rejected(self):
        self.client.force_authenticate(user=None)

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_variant_removed_after_being_added_is_not_ordered(self):
        add_to_cart(self.user, self.tee_l, 1)
        self.tee_l.delete()  # cascades away the cart item; nothing left to buy

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(Order.objects.exists())

    def test_insufficient_stock_is_rejected_with_conflict(self):
        add_to_cart(self.user, self.shirt_m, 3)
        self.shirt_m.stock = 2
        self.shirt_m.save(update_fields=['stock'])

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
        self.assertEqual(response.data['items'][0]['available'], 2)
        self.assertEqual(response.data['items'][0]['requested'], 3)

    def test_out_of_stock_variant_is_rejected(self):
        add_to_cart(self.user, self.shirt_m, 1)
        self.shirt_m.stock = 0
        self.shirt_m.save(update_fields=['stock'])

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)

    def test_failed_checkout_leaves_cart_stock_and_orders_untouched(self):
        add_to_cart(self.user, self.shirt_m, 1)
        add_to_cart(self.user, self.tee_l, 99)  # more than stock

        response = self.checkout()

        self.assertEqual(response.status_code, status.HTTP_409_CONFLICT)
        self.assertEqual(CartItem.objects.filter(cart__user=self.user).count(), 2)
        self.shirt_m.refresh_from_db()
        self.assertEqual(self.shirt_m.stock, 5)
        self.assertFalse(Order.objects.exists())
        self.assertFalse(OrderItem.objects.exists())

    def test_invalid_shipping_address_is_rejected(self):
        add_to_cart(self.user, self.shirt_m, 1)

        response = self.checkout({'shipping_address': {**SHIPPING_ADDRESS, 'postcode': 'abc', 'phone': 'x'}})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('postcode', response.data['shipping_address'])
        self.assertIn('phone', response.data['shipping_address'])
        self.assertEqual(CartItem.objects.filter(cart__user=self.user).count(), 1)

    def test_missing_shipping_address_is_rejected(self):
        add_to_cart(self.user, self.shirt_m, 1)

        response = self.checkout({'shipping_address': {}})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_client_cannot_manipulate_prices_totals_or_shipping_fee(self):
        add_to_cart(self.user, self.shirt_m, 1)

        response = self.checkout({
            'shipping_address': SHIPPING_ADDRESS,
            'subtotal': '0.01',
            'total': '0.01',
            'shipping_fee': '-50.00',
            'unit_price': '0.01',
            'product_price': '0.01',
            'items': [{'variant_id': self.shirt_m.id, 'quantity': 1, 'price': '0.01'}],
        })

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['subtotal'], '89.90')
        self.assertEqual(response.data['shipping_fee'], '0.00')
        self.assertEqual(response.data['total'], '89.90')
        self.assertEqual(response.data['items'][0]['unit_price'], '89.90')

    def test_legacy_create_endpoint_that_accepted_client_prices_is_gone(self):
        response = self.client.post('/api/orders', {
            'items': [{'variant_id': self.shirt_m.id, 'quantity': 1, 'price': '0.01'}],
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)
        self.assertFalse(Order.objects.exists())

    def test_checkout_summary_previews_server_calculated_totals(self):
        add_to_cart(self.user, self.shirt_m, 2)

        response = self.client.get('/api/orders/checkout')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['subtotal'], '179.80')
        self.assertEqual(response.data['shipping_fee'], '0.00')
        self.assertEqual(response.data['total'], '179.80')
        self.assertEqual(len(response.data['items']), 1)
        self.assertFalse(Order.objects.exists())


class CheckoutTransactionTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='buyer@example.com', password='CorrectPass123!', full_name='Buyer',
        )
        _, _, self.shirt_m, self.tee_l = make_catalog()

    def test_failure_after_order_creation_rolls_everything_back(self):
        add_to_cart(self.user, self.shirt_m, 2)
        add_to_cart(self.user, self.tee_l, 1)

        with mock.patch.object(services, '_clear_purchased_items', side_effect=RuntimeError('boom')):
            with self.assertRaises(RuntimeError):
                services.checkout(self.user, SHIPPING_ADDRESS)

        self.assertFalse(Order.objects.exists())
        self.assertFalse(OrderItem.objects.exists())
        self.shirt_m.refresh_from_db()
        self.tee_l.refresh_from_db()
        self.assertEqual(self.shirt_m.stock, 5)
        self.assertEqual(self.tee_l.stock, 10)
        self.assertEqual(CartItem.objects.filter(cart__user=self.user).count(), 2)


class PriceSnapshotTestCase(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            email='buyer@example.com', password='CorrectPass123!', full_name='Buyer',
        )
        self.shirt, _, self.shirt_m, _ = make_catalog()
        self.client.force_authenticate(user=self.user)

    def test_order_keeps_its_price_after_the_product_price_changes(self):
        add_to_cart(self.user, self.shirt_m, 1)
        order_id = self.client.post(
            '/api/orders/checkout', {'shipping_address': SHIPPING_ADDRESS}, format='json',
        ).data['id']

        self.shirt.price = Decimal('99.90')
        self.shirt.name = 'Renamed Shirt'
        self.shirt.save(update_fields=['price', 'name'])

        response = self.client.get(f'/api/orders/{order_id}')

        self.assertEqual(response.data['items'][0]['unit_price'], '89.90')
        self.assertEqual(response.data['items'][0]['subtotal'], '89.90')
        self.assertEqual(response.data['items'][0]['product_name'], 'Oversized Cotton Shirt')
        self.assertEqual(response.data['total'], '89.90')


class OrderHistoryTestCase(APITestCase):
    def setUp(self):
        self.user_a = User.objects.create_user(
            email='usera@example.com', password='CorrectPass123!', full_name='User A',
        )
        self.user_b = User.objects.create_user(
            email='userb@example.com', password='CorrectPass123!', full_name='User B',
        )
        _, _, self.shirt_m, self.tee_l = make_catalog()

    def place_order(self, user, variant, quantity=1):
        add_to_cart(user, variant, quantity)
        return services.checkout(user, SHIPPING_ADDRESS)

    def test_unauthenticated_user_cannot_list_orders(self):
        response = self.client.get('/api/orders')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_user_lists_only_their_own_orders_newest_first(self):
        first = self.place_order(self.user_a, self.shirt_m)
        second = self.place_order(self.user_a, self.tee_l)
        self.place_order(self.user_b, self.tee_l)
        self.client.force_authenticate(user=self.user_a)

        response = self.client.get('/api/orders')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['count'], 2)
        self.assertEqual(
            [order['id'] for order in response.data['results']],
            [second.id, first.id],
        )

    def test_user_can_retrieve_their_own_order(self):
        order = self.place_order(self.user_a, self.shirt_m, 2)
        self.client.force_authenticate(user=self.user_a)

        response = self.client.get(f'/api/orders/{order.id}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['order_number'], order.order_number)
        self.assertEqual(response.data['item_count'], 2)
        self.assertNotIn('user', response.data)

    def test_user_a_cannot_access_user_b_order_by_changing_the_id(self):
        order_b = self.place_order(self.user_b, self.shirt_m)
        self.client.force_authenticate(user=self.user_a)

        response = self.client.get(f'/api/orders/{order_b.id}')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_user_a_cannot_modify_user_b_order(self):
        order_b = self.place_order(self.user_b, self.shirt_m)
        self.client.force_authenticate(user=self.user_a)

        patch = self.client.patch(f'/api/orders/{order_b.id}', {'status': 'delivered'}, format='json')
        delete = self.client.delete(f'/api/orders/{order_b.id}')

        self.assertGreaterEqual(patch.status_code, 400)
        self.assertGreaterEqual(delete.status_code, 400)
        order_b.refresh_from_db()
        self.assertEqual(order_b.status, Order.Status.PENDING)
        self.assertTrue(Order.objects.filter(id=order_b.id).exists())

    def test_orders_cannot_be_modified_by_their_owner_either(self):
        order = self.place_order(self.user_a, self.shirt_m)
        self.client.force_authenticate(user=self.user_a)

        response = self.client.patch(
            f'/api/orders/{order.id}', {'status': 'paid', 'total': '0.01'}, format='json',
        )

        self.assertEqual(response.status_code, status.HTTP_405_METHOD_NOT_ALLOWED)
        order.refresh_from_db()
        self.assertEqual(order.status, Order.Status.PENDING)


class ConcurrentCheckoutTestCase(TransactionTestCase):
    """Real concurrent requests on separate DB connections, to prove the row
    locks prevent overselling (a plain TestCase wraps everything in one
    transaction and can't exercise this)."""

    def test_two_buyers_cannot_both_buy_the_last_units(self):
        _, _, shirt_m, _ = make_catalog()
        shirt_m.stock = 2
        shirt_m.save(update_fields=['stock'])

        buyers = [
            User.objects.create_user(email=f'buyer{i}@example.com', password='CorrectPass123!', full_name='B')
            for i in range(2)
        ]
        for buyer in buyers:
            add_to_cart(buyer, shirt_m, 2)

        barrier = threading.Barrier(len(buyers))
        results = []

        def attempt(user):
            try:
                barrier.wait()
                client = APIClient()
                client.force_authenticate(user=user)
                response = client.post(
                    '/api/orders/checkout', {'shipping_address': SHIPPING_ADDRESS}, format='json',
                )
                results.append(response.status_code)
            finally:
                connection.close()

        threads = [threading.Thread(target=attempt, args=(buyer,)) for buyer in buyers]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()

        self.assertEqual(sorted(results), [status.HTTP_201_CREATED, status.HTTP_409_CONFLICT])
        shirt_m.refresh_from_db()
        self.assertEqual(shirt_m.stock, 0)
        self.assertEqual(Order.objects.count(), 1)

    def test_duplicate_submissions_from_the_same_user_create_only_one_order(self):
        _, _, shirt_m, _ = make_catalog()
        buyer = User.objects.create_user(
            email='doubletap@example.com', password='CorrectPass123!', full_name='B',
        )
        add_to_cart(buyer, shirt_m, 1)

        barrier = threading.Barrier(2)
        results = []

        def attempt():
            try:
                barrier.wait()
                client = APIClient()
                client.force_authenticate(user=buyer)
                response = client.post(
                    '/api/orders/checkout', {'shipping_address': SHIPPING_ADDRESS}, format='json',
                )
                results.append(response.status_code)
            finally:
                connection.close()

        threads = [threading.Thread(target=attempt) for _ in range(2)]
        for thread in threads:
            thread.start()
        for thread in threads:
            thread.join()

        self.assertEqual(sorted(results), [status.HTTP_201_CREATED, status.HTTP_400_BAD_REQUEST])
        self.assertEqual(Order.objects.filter(user=buyer).count(), 1)
        shirt_m.refresh_from_db()
        self.assertEqual(shirt_m.stock, 4)


class OrderNumberTestCase(APITestCase):
    def test_generated_order_numbers_match_the_customer_facing_format(self):
        numbers = {services.generate_order_number() for _ in range(50)}
        self.assertTrue(all(re.fullmatch(r'STYVA-\d{8}-[A-Z2-9]{6}', n) for n in numbers))
        self.assertGreater(len(numbers), 45)
