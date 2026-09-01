from django.db.models import ProtectedError
from rest_framework import serializers

from apps.brands.models import Brand
from apps.brands.serializers import BrandSerializer
from apps.categories.models import Category
from apps.categories.serializers import CategorySerializer

from .models import Product, ProductVariant


class ProductVariantSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=False)

    class Meta:
        model = ProductVariant
        fields = ['id', 'size', 'color', 'stock']


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
        existing_by_id = {variant.id: variant for variant in product.variants.all()}
        seen_ids = set()

        for variant_data in variants_data:
            variant_id = variant_data.pop('id', None)
            existing = existing_by_id.get(variant_id)
            if existing is not None:
                for attr, value in variant_data.items():
                    setattr(existing, attr, value)
                existing.save()
                seen_ids.add(variant_id)
            else:
                ProductVariant.objects.create(product=product, **variant_data)

        stale_ids = set(existing_by_id) - seen_ids
        if stale_ids:
            try:
                ProductVariant.objects.filter(id__in=stale_ids).delete()
            except ProtectedError:
                raise serializers.ValidationError(
                    'Cannot remove a variant that already has order history.'
                )
