from django.contrib import admin

from .models import Payment, PaymentEvent


class PaymentEventInline(admin.TabularInline):
    model = PaymentEvent
    extra = 0
    can_delete = False
    readonly_fields = ['provider', 'event_id', 'status', 'outcome', 'payload', 'received_at']


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = ['reference', 'order', 'provider', 'amount', 'payment_status', 'created_at']
    list_filter = ['payment_status', 'provider']
    search_fields = ['reference', 'provider_reference', 'order__order_number']
    # Status changes go through provider events only, never hand edits here.
    readonly_fields = [
        'reference', 'order', 'provider', 'provider_reference', 'amount',
        'payment_status', 'created_at', 'updated_at',
    ]
    inlines = [PaymentEventInline]


@admin.register(PaymentEvent)
class PaymentEventAdmin(admin.ModelAdmin):
    list_display = ['provider', 'event_id', 'payment', 'status', 'outcome', 'received_at']
    list_filter = ['provider', 'status', 'outcome']
    readonly_fields = ['provider', 'event_id', 'payment', 'status', 'outcome', 'payload', 'received_at']
