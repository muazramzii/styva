from django.contrib import admin

from .models import Product, ProductVariant


class ProductVariantInline(admin.TabularInline):
    model = ProductVariant
    extra = 1


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['id', 'name', 'sku', 'brand', 'category', 'price', 'created_at']
    list_filter = ['brand', 'category']
    search_fields = ['name', 'sku']
    inlines = [ProductVariantInline]


@admin.register(ProductVariant)
class ProductVariantAdmin(admin.ModelAdmin):
    list_display = ['id', 'product', 'size', 'color', 'stock']
    list_filter = ['size', 'color']
