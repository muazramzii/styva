from django.contrib import admin

from .models import Payment


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ['id', 'order', 'method', 'amount', 'payment_status', 'created_at']
    list_filter = ['payment_status', 'method']
