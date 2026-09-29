from django.contrib import admin

from .models import Order, OrderItem


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    readonly_fields = [
        'variant', 'product_name', 'brand_name', 'size', 'color', 'price', 'quantity', 'subtotal',
    ]
    can_delete = False


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['order_number', 'user', 'total', 'status', 'payment_status', 'created_at']
    list_filter = ['status', 'payment_status']
    search_fields = ['order_number', 'user__email']
    readonly_fields = ['order_number', 'subtotal', 'shipping_fee', 'total', 'created_at', 'updated_at']
    inlines = [OrderItemInline]


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    list_display = ['id', 'order', 'product_name', 'size', 'color', 'quantity', 'price', 'subtotal']
    readonly_fields = [
        'order', 'variant', 'product_name', 'brand_name', 'size', 'color', 'price', 'quantity', 'subtotal',
    ]
