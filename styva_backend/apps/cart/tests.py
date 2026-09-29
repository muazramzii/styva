from decimal import Decimal

from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

from apps.brands.models import Brand
from apps.categories.models import Category
from apps.products.models import Product, ProductVariant

from .models import Cart, CartItem

User = get_user_model()


class CartTestCase(APITestCase):
    def setUp(self):
        self.user_a = User.objects.create_user(
            email='usera@example.com', password='CorrectPass123!', full_name='User A',
        )
        self.user_b = User.objects.create_user(
            email='userb@example.com', password='CorrectPass123!', full_name='User B',
        )
        brand = Brand.objects.create(name='UNIQLO', slug='uniqlo')
        category = Category.objects.create(name='Tops', slug='tops')
        self.product = Product.objects.create(
            sku='UNQ001', name='Oversized Cotton Shirt', brand=brand, category=category,
            price=Decimal('89.90'),
        )
        self.variant = ProductVariant.objects.create(
            product=self.product, size='M', color='Black', stock=5,
        )

    def _auth(self, user):
        self.client.force_authenticate(user=user)

    def test_unauthenticated_user_cannot_access_cart(self):
        response = self.client.get('/api/cart')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_authenticated_user_can_retrieve_cart(self):
        self._auth(self.user_a)
        response = self.client.get('/api/cart')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['items'], [])
        self.assertEqual(response.data['total'], '0.00')

    def test_add_variant_to_cart(self):
        self._auth(self.user_a)

        response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 3})

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['quantity'], 3)
        self.assertEqual(response.data['variant']['id'], self.variant.id)

    def test_adding_same_variant_again_increases_quantity_instead_of_duplicating(self):
        self._auth(self.user_a)
        self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 2})

        response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 1})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['quantity'], 3)
        self.assertEqual(CartItem.objects.filter(cart__user=self.user_a, variant=self.variant).count(), 1)

    def test_quantity_cannot_be_zero(self):
        self._auth(self.user_a)

        response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 0})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(CartItem.objects.filter(cart__user=self.user_a).exists())

    def test_quantity_cannot_exceed_stock_on_add(self):
        self._auth(self.user_a)

        response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 6})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertFalse(CartItem.objects.filter(cart__user=self.user_a).exists())

    def test_update_quantity(self):
        self._auth(self.user_a)
        create_response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 1})
        item_id = create_response.data['id']

        response = self.client.patch(f'/api/cart/items/{item_id}', {'quantity': 4}, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['quantity'], 4)

    def test_update_quantity_cannot_exceed_stock(self):
        self._auth(self.user_a)
        create_response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 1})
        item_id = create_response.data['id']

        response = self.client.patch(f'/api/cart/items/{item_id}', {'quantity': 6}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_update_quantity_cannot_be_zero(self):
        self._auth(self.user_a)
        create_response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 1})
        item_id = create_response.data['id']

        response = self.client.patch(f'/api/cart/items/{item_id}', {'quantity': 0}, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_delete_cart_item(self):
        self._auth(self.user_a)
        create_response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 1})
        item_id = create_response.data['id']

        response = self.client.delete(f'/api/cart/items/{item_id}')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(CartItem.objects.filter(id=item_id).exists())

    def test_deleting_nonexistent_item_returns_404(self):
        self._auth(self.user_a)
        response = self.client.delete('/api/cart/items/999999')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_user_cannot_update_another_users_cart_item(self):
        cart_b = Cart.objects.create(user=self.user_b)
        item_b = CartItem.objects.create(cart=cart_b, variant=self.variant, quantity=1)
        self._auth(self.user_a)

        response = self.client.patch(f'/api/cart/items/{item_b.id}', {'quantity': 2}, format='json')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        item_b.refresh_from_db()
        self.assertEqual(item_b.quantity, 1)

    def test_user_cannot_delete_another_users_cart_item(self):
        cart_b = Cart.objects.create(user=self.user_b)
        item_b = CartItem.objects.create(cart=cart_b, variant=self.variant, quantity=1)
        self._auth(self.user_a)

        response = self.client.delete(f'/api/cart/items/{item_b.id}')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertTrue(CartItem.objects.filter(id=item_b.id).exists())

    def test_subtotal_is_calculated_from_price_and_quantity(self):
        self._auth(self.user_a)

        response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 2})

        self.assertEqual(response.data['subtotal'], '179.80')

    def test_cart_total_sums_all_item_subtotals(self):
        other_variant = ProductVariant.objects.create(
            product=self.product, size='L', color='Black', stock=5,
        )
        self._auth(self.user_a)
        self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 2})
        self.client.post('/api/cart/items', {'variant_id': other_variant.id, 'quantity': 1})

        response = self.client.get('/api/cart')

        self.assertEqual(response.data['total'], '269.70')

    def test_client_cannot_manipulate_price_or_subtotal(self):
        self._auth(self.user_a)

        response = self.client.post('/api/cart/items', {
            'variant_id': self.variant.id,
            'quantity': 1,
            'subtotal': '0.01',
            'price': '0.01',
        })

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['subtotal'], '89.90')

    def test_product_price_changes_are_reflected_in_cart(self):
        self._auth(self.user_a)
        self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 2})

        self.product.price = Decimal('100.00')
        self.product.save(update_fields=['price'])

        response = self.client.get('/api/cart')

        self.assertEqual(response.data['items'][0]['subtotal'], '200.00')
        self.assertEqual(response.data['total'], '200.00')

    def test_stock_scenarios(self):
        self._auth(self.user_a)

        # Stock = 5, add quantity 3 -> success
        create_response = self.client.post('/api/cart/items', {'variant_id': self.variant.id, 'quantity': 3})
        self.assertEqual(create_response.status_code, status.HTTP_201_CREATED)
        item_id = create_response.data['id']

        # User changes quantity to 5 -> success
        response = self.client.patch(f'/api/cart/items/{item_id}', {'quantity': 5}, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # User changes quantity to 6 -> reject
        response = self.client.patch(f'/api/cart/items/{item_id}', {'quantity': 6}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

        # Stock later becomes 2, user requests quantity 5 -> reject
        self.variant.stock = 2
        self.variant.save(update_fields=['stock'])
        response = self.client.patch(f'/api/cart/items/{item_id}', {'quantity': 5}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
