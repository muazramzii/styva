from decimal import Decimal

from rest_framework import serializers

from apps.products.models import Product, ProductVariant

from .models import Cart, CartItem


class CartProductSerializer(serializers.ModelSerializer):
    brand = serializers.CharField(source='brand.name', read_only=True)

    class Meta:
        model = Product
        fields = ['id', 'name', 'price', 'brand']


class CartVariantSerializer(serializers.ModelSerializer):
    product = CartProductSerializer(read_only=True)

    class Meta:
        model = ProductVariant
        fields = ['id', 'size', 'color', 'stock', 'product']


class CartItemSerializer(serializers.ModelSerializer):
    variant = CartVariantSerializer(read_only=True)
    variant_id = serializers.PrimaryKeyRelatedField(
        queryset=ProductVariant.objects.all(),
        source='variant',
        write_only=True,
    )
    quantity = serializers.IntegerField(min_value=1)
    subtotal = serializers.SerializerMethodField()

    class Meta:
        model = CartItem
        fields = ['id', 'variant', 'variant_id', 'quantity', 'subtotal']

    def get_subtotal(self, obj):
        return str(obj.variant.product.price * obj.quantity)


class CartSerializer(serializers.ModelSerializer):
    items = CartItemSerializer(many=True, read_only=True)
    total = serializers.SerializerMethodField()

    class Meta:
        model = Cart
        fields = ['id', 'items', 'total', 'created_at']
        read_only_fields = ['id', 'created_at']

    def get_total(self, obj):
        total = sum(
            (item.variant.product.price * item.quantity for item in obj.items.all()),
            Decimal('0.00'),
        )
        return str(total)
