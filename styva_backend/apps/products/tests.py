from decimal import Decimal

from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

from apps.brands.models import Brand
from apps.categories.models import Category

from .models import Product, ProductVariant

User = get_user_model()


class ProductAPITestCase(APITestCase):
    def setUp(self):
        self.brand_uniqlo = Brand.objects.create(name='UNIQLO', slug='uniqlo')
        self.brand_nike = Brand.objects.create(name='Nike', slug='nike')
        self.category_tops = Category.objects.create(name='Tops', slug='tops')
        self.category_footwear = Category.objects.create(name='Footwear', slug='footwear')

        self.cheap_product = Product.objects.create(
            sku='UNQ001', name='Basic Tee', brand=self.brand_uniqlo,
            category=self.category_tops, description='A basic tee.', price=Decimal('29.90'),
        )
        self.expensive_product = Product.objects.create(
            sku='NIK001', name='Running Shoe', brand=self.brand_nike,
            category=self.category_footwear, description='A running shoe.', price=Decimal('299.90'),
        )
        ProductVariant.objects.create(product=self.cheap_product, size='M', color='White', stock=10)
        ProductVariant.objects.create(product=self.expensive_product, size='9', color='Black', stock=5)

        self.admin_user = User.objects.create_superuser(email='admin@styva.test', password='pass12345', full_name='Admin')
        self.regular_user = User.objects.create_user(email='shopper@styva.test', password='pass12345', full_name='Shopper')

    def test_list_products_is_public(self):
        response = self.client.get('/api/products/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['count'], 2)

    def test_retrieve_product_includes_nested_brand_category_variants(self):
        response = self.client.get(f'/api/products/{self.cheap_product.id}/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['brand']['slug'], 'uniqlo')
        self.assertEqual(response.data['category']['slug'], 'tops')
        self.assertEqual(len(response.data['variants']), 1)
        self.assertEqual(response.data['variants'][0]['size'], 'M')

    def test_anonymous_cannot_create_product(self):
        response = self.client.post('/api/products/', {
            'sku': 'NEW001', 'name': 'New', 'brand_id': self.brand_uniqlo.id,
            'category_id': self.category_tops.id, 'price': '10.00',
        })
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_regular_user_cannot_create_product(self):
        self.client.force_authenticate(user=self.regular_user)
        response = self.client.post('/api/products/', {
            'sku': 'NEW001', 'name': 'New', 'brand_id': self.brand_uniqlo.id,
            'category_id': self.category_tops.id, 'price': '10.00',
        })
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_admin_can_create_product_with_variants(self):
        self.client.force_authenticate(user=self.admin_user)
        response = self.client.post('/api/products/', {
            'sku': 'NEW001', 'name': 'New Jacket', 'brand_id': self.brand_uniqlo.id,
            'category_id': self.category_tops.id, 'price': '89.90',
            'variants': [{'size': 'M', 'color': 'Black', 'stock': 20}],
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        product = Product.objects.get(sku='NEW001')
        self.assertEqual(product.variants.count(), 1)

    def test_admin_can_update_product_and_replace_variants(self):
        self.client.force_authenticate(user=self.admin_user)
        response = self.client.patch(f'/api/products/{self.cheap_product.id}/', {
            'name': 'Updated Tee',
            'variants': [{'size': 'L', 'color': 'Black', 'stock': 5}],
        }, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.cheap_product.refresh_from_db()
        self.assertEqual(self.cheap_product.name, 'Updated Tee')
        self.assertEqual(self.cheap_product.variants.count(), 1)
        self.assertEqual(self.cheap_product.variants.first().size, 'L')

    def test_admin_can_delete_product(self):
        self.client.force_authenticate(user=self.admin_user)
        response = self.client.delete(f'/api/products/{self.expensive_product.id}/')
        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Product.objects.filter(id=self.expensive_product.id).exists())


class ProductFilterTestCase(APITestCase):
    def setUp(self):
        brand_a = Brand.objects.create(name='UNIQLO', slug='uniqlo')
        brand_b = Brand.objects.create(name='Nike', slug='nike')
        category_tops = Category.objects.create(name='Tops', slug='tops')
        category_shoes = Category.objects.create(name='Footwear', slug='footwear')

        Product.objects.create(sku='A1', name='Cheap Tee', brand=brand_a, category=category_tops, price=Decimal('20.00'))
        Product.objects.create(sku='A2', name='Mid Tee', brand=brand_a, category=category_tops, price=Decimal('50.00'))
        Product.objects.create(sku='B1', name='Running Shoe', brand=brand_b, category=category_shoes, price=Decimal('150.00'))

    def test_filter_by_brand(self):
        response = self.client.get('/api/products/?brand=uniqlo')
        self.assertEqual(response.data['count'], 2)

    def test_filter_by_category(self):
        response = self.client.get('/api/products/?category=footwear')
        self.assertEqual(response.data['count'], 1)

    def test_filter_by_price_range(self):
        response = self.client.get('/api/products/?min_price=30&max_price=100')
        self.assertEqual(response.data['count'], 1)
        self.assertEqual(response.data['results'][0]['sku'], 'A2')

    def test_search_by_name(self):
        response = self.client.get('/api/products/?search=Running')
        self.assertEqual(response.data['count'], 1)
        self.assertEqual(response.data['results'][0]['sku'], 'B1')

    def test_combined_brand_and_category_filter(self):
        response = self.client.get('/api/products/?brand=uniqlo&category=tops')
        self.assertEqual(response.data['count'], 2)

    def test_ordering_price_low(self):
        response = self.client.get('/api/products/?ordering=price_low')
        prices = [float(item['price']) for item in response.data['results']]
        self.assertEqual(prices, sorted(prices))

    def test_ordering_price_high(self):
        response = self.client.get('/api/products/?ordering=price_high')
        prices = [float(item['price']) for item in response.data['results']]
        self.assertEqual(prices, sorted(prices, reverse=True))


class ProductPaginationTestCase(APITestCase):
    def setUp(self):
        brand = Brand.objects.create(name='UNIQLO', slug='uniqlo')
        category = Category.objects.create(name='Tops', slug='tops')
        for i in range(25):
            Product.objects.create(
                sku=f'SKU{i:03d}', name=f'Product {i}', brand=brand,
                category=category, price=Decimal('10.00'),
            )

    def test_default_page_size_is_ten(self):
        response = self.client.get('/api/products/')
        self.assertEqual(response.data['count'], 25)
        self.assertEqual(len(response.data['results']), 10)
        self.assertIsNotNone(response.data['next'])

    def test_second_page_returns_next_ten(self):
        response = self.client.get('/api/products/?page=2')
        self.assertEqual(len(response.data['results']), 10)
        self.assertIsNotNone(response.data['previous'])

    def test_last_page_returns_remainder(self):
        response = self.client.get('/api/products/?page=3')
        self.assertEqual(len(response.data['results']), 5)
        self.assertIsNone(response.data['next'])
