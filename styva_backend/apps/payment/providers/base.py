from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from decimal import Decimal


class InvalidWebhookError(Exception):
    """The request did not come from the provider, or is malformed."""


@dataclass(frozen=True)
class ProviderSession:
    """What a provider returns when a payment is started with it."""
    provider_reference: str
    # Where the customer completes payment, for redirect-style providers
    # (ToyyibPay/Billplz bill URLs, Stripe Checkout, ...). None for the mock.
    redirect_url: str | None = None


@dataclass(frozen=True)
class ProviderEvent:
    """A provider notification, already authenticated and normalised."""
    event_id: str
    provider_reference: str
    status: str  # one of Payment.Status values
    amount: Decimal | None = None
    raw: dict = field(default_factory=dict)


class PaymentProvider(ABC):
    """Everything provider-specific lives behind this interface, so adding
    ToyyibPay, Billplz, Stripe, iPay88 or an FPX provider means adding one
    subclass and a settings entry -- the order and payment core never changes."""

    name: str

    @abstractmethod
    def create_payment(self, payment) -> ProviderSession:
        """Register the payment with the provider (create a bill / intent)."""

    @abstractmethod
    def parse_webhook(self, request) -> ProviderEvent:
        """Authenticate an incoming provider notification (signature, shared
        secret, ...) and normalise it. Raise InvalidWebhookError otherwise.
        This is the only way an external party can move a payment's status."""
