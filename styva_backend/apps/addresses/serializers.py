from rest_framework import serializers

from .models import Address


class AddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        fields = [
            'id', 'recipient_name', 'phone', 'address_line_1', 'address_line_2',
            'city', 'state', 'postcode', 'country', 'is_default', 'created_at', 'updated_at',
        ]
        # The owner always comes from the authenticated request, never the body.
        read_only_fields = ['id', 'created_at', 'updated_at']
        extra_kwargs = {'address_line_2': {'required': False}}
