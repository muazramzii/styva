from rest_framework import serializers

from apps.addresses.models import Address
from apps.cart.serializers import CartItemSerializer
from apps.common.validators import phone_validator, postcode_validator

from .models import Order, OrderItem


class ShippingAddressSerializer(serializers.Serializer):
    full_name = serializers.CharField(max_length=255)
    phone = serializers.CharField(max_length=32, validators=[phone_validator])
    address_line_1 = serializers.CharField(max_length=255)
    address_line_2 = serializers.CharField(max_length=255, required=False, allow_blank=True, default='')
    city = serializers.CharField(max_length=128)
    state = serializers.CharField(max_length=128)
    postcode = serializers.CharField(max_length=16, validators=[postcode_validator])


class CheckoutSerializer(serializers.Serializer):
    """The only thing the client may supply at checkout is where to ship:
    either one of their saved addresses (``address_id``) or an address typed
    in (``shipping_address``) -- exactly one. Any price/total/shipping fields
    in the request are ignored.

    Either way, ``validated_data['shipping_address']`` is a plain dict that
    checkout copies into the order, so the order never depends on the saved
    address afterwards."""
    address_id = serializers.IntegerField(required=False, min_value=1)
    shipping_address = ShippingAddressSerializer(required=False)

    def validate(self, attrs):
        address_id = attrs.pop('address_id', None)
        if (address_id is None) == ('shipping_address' not in attrs):
            raise serializers.ValidationError(
                'Provide either address_id or shipping_address.', code='address_required',
            )
        if address_id is not None:
            # Only the requesting user's own addresses; anyone else's id is
            # indistinguishable from one that doesn't exist.
            address = Address.objects.filter(id=address_id, user=self.context['request'].user).first()
            if address is None:
                raise serializers.ValidationError({'address_id': ['Address not found.']})
            attrs['shipping_address'] = {
                'full_name': address.recipient_name,
                'phone': address.phone,
                'address_line_1': address.address_line_1,
                'address_line_2': address.address_line_2,
                'city': address.city,
                'state': address.state,
                'postcode': address.postcode,
            }
        return attrs


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
