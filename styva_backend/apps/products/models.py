from django.db import models

from apps.brands.models import Brand
from apps.categories.models import Category


class Product(models.Model):
    sku = models.CharField(max_length=64, unique=True)
    name = models.CharField(max_length=255)
    brand = models.ForeignKey(Brand, on_delete=models.CASCADE, related_name='products')
    category = models.ForeignKey(Category, on_delete=models.CASCADE, related_name='products')
    description = models.TextField(blank=True)
    price = models.DecimalField(max_digits=10, decimal_places=2)
    image = models.ImageField(upload_to='products/', blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'products'
        ordering = ['-created_at']

    def __str__(self):
        return self.name


class ProductVariant(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE, related_name='variants')
    size = models.CharField(max_length=32)
    color = models.CharField(max_length=64)
    stock = models.PositiveIntegerField(default=0)

    class Meta:
        db_table = 'product_variants'
        unique_together = ('product', 'size', 'color')

    def __str__(self):
        return f'{self.product.name} - {self.size}/{self.color}'
