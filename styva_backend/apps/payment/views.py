from rest_framework import generics, status
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Payment
from .providers import InvalidWebhookError, UnknownProviderError, get_provider
from .serializers import InitiatePaymentSerializer, MockOutcomeSerializer, PaymentSerializer
from .services import PaymentError, initiate_payment, process_provider_event, simulate_mock_outcome


def _error_response(error):
    return Response({'detail': error.detail}, status=error.status_code)


class InitiatePaymentView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = InitiatePaymentSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            payment, created = initiate_payment(request.user, serializer.validated_data['order_id'])
        except PaymentError as error:
            return _error_response(error)
        return Response(
            PaymentSerializer(payment).data,
            status=status.HTTP_201_CREATED if created else status.HTTP_200_OK,
        )


class PaymentDetailView(generics.RetrieveAPIView):
    serializer_class = PaymentSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Payment.objects.filter(order__user=self.request.user).select_related('order')


class MockPaymentCompleteView(APIView):
    """DEVELOPMENT ONLY -- see services.simulate_mock_outcome."""
    permission_classes = [IsAuthenticated]

    def post(self, request, pk):
        serializer = MockOutcomeSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            payment = simulate_mock_outcome(request.user, pk, serializer.validated_data['outcome'])
        except PaymentError as error:
            return _error_response(error)
        return Response(PaymentSerializer(payment).data)


class PaymentWebhookView(APIView):
    """Provider → backend notifications. Trust comes only from the provider's
    own verification (signature/secret) in ``parse_webhook``; user
    authentication is deliberately disabled, so a customer's JWT grants
    nothing here."""
    authentication_classes = []
    permission_classes = [AllowAny]

    def post(self, request, provider):
        try:
            payment_provider = get_provider(provider)
        except UnknownProviderError:
            return Response({'detail': 'Not found.'}, status=status.HTTP_404_NOT_FOUND)

        try:
            event = payment_provider.parse_webhook(request)
        except InvalidWebhookError as error:
            return Response({'detail': str(error)}, status=status.HTTP_400_BAD_REQUEST)

        try:
            record, duplicate = process_provider_event(payment_provider.name, event)
        except PaymentError as error:
            return _error_response(error)

        result = 'duplicate' if duplicate else record.outcome
        return Response({'result': result})
