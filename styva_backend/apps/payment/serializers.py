from rest_framework import serializers

from .models import Payment


class InitiatePaymentSerializer(serializers.Serializer):
    """Only the order is chosen by the client. Amount, status, provider and
    references are always set by the backend; extra fields are ignored."""
    order_id = serializers.IntegerField(min_value=1)


class MockOutcomeSerializer(serializers.Serializer):
    outcome = serializers.ChoiceField(choices=[Payment.Status.SUCCESS, Payment.Status.FAILED])


class PaymentSerializer(serializers.ModelSerializer):
    order_id = serializers.IntegerField(read_only=True)
    order_number = serializers.CharField(source='order.order_number', read_only=True)
    status = serializers.CharField(source='payment_status', read_only=True)

    class Meta:
        model = Payment
        fields = [
            'id', 'reference', 'order_id', 'order_number', 'amount', 'status',
            'provider', 'provider_reference', 'created_at', 'updated_at',
        ]
        read_only_fields = fields
