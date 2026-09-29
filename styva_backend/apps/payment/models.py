from django.db import models
from django.db.models import Q

from apps.orders.models import Order


class Payment(models.Model):
    """One payment attempt for an order.

    An order can have several attempts over time (e.g. a failed one followed
    by a retry), but the database guarantees at most one *pending* and at most
    one *successful* payment per order, so there is never more than one active
    attempt and an order can never be paid twice.
    """

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        SUCCESS = 'success', 'Success'
        FAILED = 'failed', 'Failed'

    order = models.ForeignKey(Order, on_delete=models.CASCADE, related_name='payments')
    reference = models.CharField(max_length=32, unique=True, editable=False)
    provider = models.CharField(max_length=32)
    provider_reference = models.CharField(max_length=128, null=True, blank=True)
    method = models.CharField(max_length=64, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    payment_status = models.CharField(max_length=16, choices=Status.choices, default=Status.PENDING)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'payments'
        ordering = ['-created_at', '-id']
        constraints = [
            models.UniqueConstraint(
                fields=['order'],
                condition=Q(payment_status='pending'),
                name='one_pending_payment_per_order',
            ),
            models.UniqueConstraint(
                fields=['order'],
                condition=Q(payment_status='success'),
                name='one_successful_payment_per_order',
            ),
            models.UniqueConstraint(
                fields=['provider', 'provider_reference'],
                condition=Q(provider_reference__isnull=False),
                name='unique_provider_reference',
            ),
        ]

    def __str__(self):
        return f'{self.reference} for {self.order.order_number} ({self.payment_status})'


class PaymentEvent(models.Model):
    """Every provider event we have received, keyed by the provider's own
    event id, so a redelivered webhook is recognised and never re-applied."""

    class Outcome(models.TextChoices):
        APPLIED = 'applied', 'Applied'
        IGNORED = 'ignored', 'Ignored'

    provider = models.CharField(max_length=32)
    event_id = models.CharField(max_length=128)
    payment = models.ForeignKey(Payment, on_delete=models.CASCADE, related_name='events')
    status = models.CharField(max_length=16, choices=Payment.Status.choices)
    outcome = models.CharField(max_length=16, choices=Outcome.choices)
    payload = models.JSONField(default=dict, blank=True)
    received_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'payment_events'
        ordering = ['-received_at', '-id']
        constraints = [
            models.UniqueConstraint(fields=['provider', 'event_id'], name='unique_provider_event'),
        ]

    def __str__(self):
        return f'{self.provider}:{self.event_id} -> {self.status} ({self.outcome})'
