from django.conf import settings
from django.db import models

from apps.products.models import ProductVariant


class Order(models.Model):
    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        PAID = 'paid', 'Paid'
        PACKING = 'packing', 'Packing'
        SHIPPING = 'shipping', 'Shipping'
        DELIVERED = 'delivered', 'Delivered'
        CANCELLED = 'cancelled', 'Cancelled'

    class PaymentStatus(models.TextChoices):
        PENDING = 'pending', 'Pending'
        SUCCESS = 'success', 'Success'
        FAILED = 'failed', 'Failed'

    order_number = models.CharField(max_length=32, unique=True, editable=False)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='orders')
    status = models.CharField(max_length=16, choices=Status.choices, default=Status.PENDING)
    payment_status = models.CharField(
        max_length=16, choices=PaymentStatus.choices, default=PaymentStatus.PENDING,
    )
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)
    shipping_fee = models.DecimalField(max_digits=10, decimal_places=2)
    total = models.DecimalField(max_digits=10, decimal_places=2)

    # Shipping address snapshot, entered at checkout (no address book yet).
    shipping_full_name = models.CharField(max_length=255)
    shipping_phone = models.CharField(max_length=32)
    shipping_address_line_1 = models.CharField(max_length=255)
    shipping_address_line_2 = models.CharField(max_length=255, blank=True)
    shipping_city = models.CharField(max_length=128)
    shipping_state = models.CharField(max_length=128)
    shipping_postcode = models.CharField(max_length=16)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'orders'
        ordering = ['-created_at', '-id']

    def __str__(self):
        return f'{self.order_number} ({self.user.email})'


class OrderItem(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='items')
    variant = models.ForeignKey(ProductVariant, on_delete=models.PROTECT, related_name='order_items')

    # Snapshot of the product/variant at checkout time, so order history never
    # changes when the live product is renamed, repriced, or its variant edited.
    product_name = models.CharField(max_length=255)
    brand_name = models.CharField(max_length=255)
    size = models.CharField(max_length=32)
    color = models.CharField(max_length=64)
    price = models.DecimalField(
        max_digits=10, decimal_places=2,
        help_text='Unit price snapshot at checkout time (exposed as unit_price in the API).',
    )
    quantity = models.PositiveIntegerField()
    subtotal = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        db_table = 'order_items'
        ordering = ['id']

    def __str__(self):
        return f'{self.order} - {self.product_name} x{self.quantity}'
