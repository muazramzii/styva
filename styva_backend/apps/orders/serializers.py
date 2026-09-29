from django.core.validators import RegexValidator
from rest_framework import serializers

from apps.cart.serializers import CartItemSerializer

from .models import Order, OrderItem


class ShippingAddressSerializer(serializers.Serializer):
    full_name = serializers.CharField(max_length=255)
    phone = serializers.CharField(
        max_length=32,
        validators=[RegexValidator(r'^\+?[0-9][0-9\s-]{6,19}$', 'Enter a valid phone number.')],
    )
    address_line_1 = serializers.CharField(max_length=255)
    address_line_2 = serializers.CharField(max_length=255, required=False, allow_blank=True, default='')
    city = serializers.CharField(max_length=128)
    state = serializers.CharField(max_length=128)
    postcode = serializers.CharField(
        max_length=16,
        validators=[RegexValidator(r'^\d{5}$', 'Enter a valid 5-digit postcode.')],
    )


class CheckoutSerializer(serializers.Serializer):
    """The only thing the client may supply at checkout is where to ship.
    Any price/total/shipping fields in the request are ignored."""
    shipping_address = ShippingAddressSerializer()


class OrderItemSerializer(serializers.ModelSerializer):
    unit_price = serializers.DecimalField(source='price', max_digits=10, decimal_places=2, read_only=True)
    brand = serializers.CharField(source='brand_name', read_only=True)

    class Meta:
        model = OrderItem
        fields = [
            'id', 'variant_id', 'product_name', 'brand', 'size', 'color',
            'unit_price', 'quantity', 'subtotal',
        ]
        read_only_fields = fields


class OrderShippingAddressSerializer(serializers.Serializer):
    full_name = serializers.CharField(source='shipping_full_name')
    phone = serializers.CharField(source='shipping_phone')
    address_line_1 = serializers.CharField(source='shipping_address_line_1')
    address_line_2 = serializers.CharField(source='shipping_address_line_2')
    city = serializers.CharField(source='shipping_city')
    state = serializers.CharField(source='shipping_state')
    postcode = serializers.CharField(source='shipping_postcode')


class OrderListSerializer(serializers.ModelSerializer):
    item_count = serializers.SerializerMethodField()

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'status', 'payment_status', 'subtotal',
            'shipping_fee', 'total', 'item_count', 'created_at',
        ]
        read_only_fields = fields

    def get_item_count(self, obj):
        return sum(item.quantity for item in obj.items.all())


class OrderDetailSerializer(OrderListSerializer):
    items = OrderItemSerializer(many=True, read_only=True)
    shipping_address = OrderShippingAddressSerializer(source='*', read_only=True)

    class Meta(OrderListSerializer.Meta):
        fields = OrderListSerializer.Meta.fields + ['updated_at', 'shipping_address', 'items']
        read_only_fields = fields


class CheckoutSummarySerializer(serializers.Serializer):
    items = CartItemSerializer(many=True)
    subtotal = serializers.DecimalField(max_digits=10, decimal_places=2)
    shipping_fee = serializers.DecimalField(max_digits=10, decimal_places=2)
    total = serializers.DecimalField(max_digits=10, decimal_places=2)
