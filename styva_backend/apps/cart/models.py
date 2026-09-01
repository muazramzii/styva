from django.conf import settings
from django.db import models

from apps.products.models import ProductVariant


class Cart(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='cart')
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'carts'

    def __str__(self):
        return f'Cart({self.user.email})'


class CartItem(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, related_name='items')
    variant = models.ForeignKey(ProductVariant, on_delete=models.CASCADE, related_name='cart_items')
    quantity = models.PositiveIntegerField(default=1)

    class Meta:
        db_table = 'cart_items'
        unique_together = ('cart', 'variant')

    def __str__(self):
        return f'{self.cart} - {self.variant} x{self.quantity}'
