from rest_framework import serializers

from apps.products.models import Product
from apps.products.serializers import ProductSerializer

from .models import Wishlist


class WishlistSerializer(serializers.ModelSerializer):
    product = ProductSerializer(read_only=True)
    product_id = serializers.PrimaryKeyRelatedField(
        queryset=Product.objects.all(),
        source='product',
        write_only=True,
    )

    class Meta:
        model = Wishlist
        fields = ['id', 'product', 'product_id', 'created_at']
        read_only_fields = ['id', 'created_at']

    def validate_product_id(self, product):
        request = self.context['request']
        if Wishlist.objects.filter(user=request.user, product=product).exists():
            raise serializers.ValidationError('This product is already in your wishlist.')
        return product
