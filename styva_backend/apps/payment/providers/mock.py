"""DEVELOPMENT / TEST ONLY. Not a payment gateway -- no money moves.

Stands in for a real provider so the payment flow can be built and tested
end to end. Its webhook is authenticated exactly the way a real one would be
(HMAC-SHA256 over the raw body with a shared secret), and with no secret
configured it accepts no webhooks at all.
"""
import hashlib
import hmac
import json
import secrets
from decimal import Decimal, InvalidOperation

from django.conf import settings

from .base import InvalidWebhookError, PaymentProvider, ProviderEvent, ProviderSession

SIGNATURE_HEADER = 'X-Mock-Signature'
_STATUSES = {'pending', 'success', 'failed'}


def sign(body: bytes, secret: str) -> str:
    return hmac.new(secret.encode(), body, hashlib.sha256).hexdigest()


class MockPaymentProvider(PaymentProvider):
    name = 'mock'

    def create_payment(self, payment):
        return ProviderSession(provider_reference=f'MOCK-{secrets.token_hex(8).upper()}')

    def parse_webhook(self, request):
        secret = settings.MOCK_PAYMENT_WEBHOOK_SECRET
        if not secret:
            raise InvalidWebhookError('Mock provider webhooks are not configured.')

        signature = request.headers.get(SIGNATURE_HEADER, '')
        if not hmac.compare_digest(signature, sign(request.body, secret)):
            raise InvalidWebhookError('Invalid signature.')

        try:
            data = json.loads(request.body)
            event_id = data['event_id']
            provider_reference = data['provider_reference']
            status = data['status']
            amount = Decimal(str(data['amount'])) if data.get('amount') is not None else None
        except (ValueError, KeyError, TypeError, AttributeError, InvalidOperation) as error:
            raise InvalidWebhookError('Malformed event.') from error

        fields = (event_id, provider_reference, status)
        if not all(isinstance(value, str) and value for value in fields) or status not in _STATUSES:
            raise InvalidWebhookError('Malformed event.')

        return ProviderEvent(
            event_id=event_id,
            provider_reference=provider_reference,
            status=status,
            amount=amount,
            raw=data,
        )
