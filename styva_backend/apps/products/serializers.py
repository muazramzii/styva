from rest_framework import serializers

from apps.brands.models import Brand
from apps.brands.serializers import BrandSerializer
from apps.categories.models import Category
from apps.categories.serializers import CategorySerializer

from .models import Product, ProductVariant


class ProductVariantSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductVariant
        fields = ['id', 'size', 'color', 'stock']
        read_only_fields = ['id']


class ProductSerializer(serializers.ModelSerializer):
    brand = BrandSerializer(read_only=True)
    category = CategorySerializer(read_only=True)
    brand_id = serializers.PrimaryKeyRelatedField(
        queryset=Brand.objects.all(), source='brand', write_only=True,
    )
    category_id = serializers.PrimaryKeyRelatedField(
        queryset=Category.objects.all(), source='category', write_only=True,
    )
    variants = ProductVariantSerializer(many=True, required=False)

    class Meta:
        model = Product
        fields = [
            'id', 'sku', 'name', 'description', 'price', 'image',
            'brand', 'category', 'brand_id', 'category_id', 'variants',
        ]

    def create(self, validated_data):
        variants_data = validated_data.pop('variants', [])
        product = Product.objects.create(**validated_data)
        self._sync_variants(product, variants_data)
        return product

    def update(self, instance, validated_data):
        variants_data = validated_data.pop('variants', None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        if variants_data is not None:
            self._sync_variants(instance, variants_data)
        return instance

    @staticmethod
    def _sync_variants(product, variants_data):
        product.variants.all().delete()
        ProductVariant.objects.bulk_create(
            ProductVariant(product=product, **variant_data) for variant_data in variants_data
        )
