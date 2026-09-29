from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

from apps.brands.models import Brand
from apps.categories.models import Category
from apps.products.models import Product

from .models import Wishlist

User = get_user_model()


class WishlistTestCase(APITestCase):
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
            sku='UNQ001', name='Basic Tee', brand=brand, category=category, price='29.90',
        )
        self.other_product = Product.objects.create(
            sku='UNQ002', name='Basic Hoodie', brand=brand, category=category, price='89.90',
        )

    def _auth(self, user):
        self.client.force_authenticate(user=user)

    def test_unauthenticated_user_cannot_access_wishlist(self):
        response = self.client.get('/api/wishlist/')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_authenticated_user_can_retrieve_wishlist(self):
        Wishlist.objects.create(user=self.user_a, product=self.product)
        self._auth(self.user_a)

        response = self.client.get('/api/wishlist/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['count'], 1)
        self.assertEqual(response.data['results'][0]['product']['id'], self.product.id)

    def test_user_can_add_product_to_wishlist(self):
        self._auth(self.user_a)

        response = self.client.post('/api/wishlist/', {'product_id': self.product.id})

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(Wishlist.objects.filter(user=self.user_a, product=self.product).exists())

    def test_duplicate_product_cannot_be_added_twice(self):
        self._auth(self.user_a)
        self.client.post('/api/wishlist/', {'product_id': self.product.id})

        response = self.client.post('/api/wishlist/', {'product_id': self.product.id})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(Wishlist.objects.filter(user=self.user_a, product=self.product).count(), 1)

    def test_user_can_remove_product_from_wishlist(self):
        Wishlist.objects.create(user=self.user_a, product=self.product)
        self._auth(self.user_a)

        response = self.client.delete(f'/api/wishlist/{self.product.id}/')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Wishlist.objects.filter(user=self.user_a, product=self.product).exists())

    def test_removing_nonexistent_item_is_handled_safely(self):
        self._auth(self.user_a)

        response = self.client.delete(f'/api/wishlist/{self.product.id}/')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_user_a_cannot_see_user_b_wishlist(self):
        Wishlist.objects.create(user=self.user_b, product=self.product)
        self._auth(self.user_a)

        response = self.client.get('/api/wishlist/')

        self.assertEqual(response.data['count'], 0)

    def test_user_a_cannot_remove_user_b_wishlist_item(self):
        Wishlist.objects.create(user=self.user_b, product=self.product)
        self._auth(self.user_a)

        response = self.client.delete(f'/api/wishlist/{self.product.id}/')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)
        self.assertTrue(Wishlist.objects.filter(user=self.user_b, product=self.product).exists())

    def test_wishlist_item_references_the_correct_product(self):
        Wishlist.objects.create(user=self.user_a, product=self.product)
        Wishlist.objects.create(user=self.user_a, product=self.other_product)
        self._auth(self.user_a)

        response = self.client.get('/api/wishlist/')

        product_ids = {item['product']['id'] for item in response.data['results']}
        self.assertEqual(product_ids, {self.product.id, self.other_product.id})
