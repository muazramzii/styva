from django.contrib import admin

from .models import Address


@admin.register(Address)
class AddressAdmin(admin.ModelAdmin):
    list_display = ['recipient_name', 'user', 'city', 'state', 'postcode', 'is_default', 'created_at']
    list_filter = ['state', 'is_default']
    search_fields = ['recipient_name', 'user__email', 'postcode', 'city']
    raw_id_fields = ['user']
