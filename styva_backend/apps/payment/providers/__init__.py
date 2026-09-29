from django.conf import settings
from django.utils.module_loading import import_string

from .base import InvalidWebhookError, PaymentProvider, ProviderEvent, ProviderSession

__all__ = [
    'InvalidWebhookError', 'PaymentProvider', 'ProviderEvent', 'ProviderSession',
    'UnknownProviderError', 'get_provider', 'get_default_provider',
]


class UnknownProviderError(LookupError):
    pass


def get_provider(name) -> PaymentProvider:
    path = settings.PAYMENT_PROVIDERS.get(name)
    if path is None:
        raise UnknownProviderError(name)
    return import_string(path)()


def get_default_provider() -> PaymentProvider:
    return get_provider(settings.PAYMENT_DEFAULT_PROVIDER)
