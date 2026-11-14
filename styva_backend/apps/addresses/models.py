from django.conf import settings
from django.db import models
from django.db.models import Q

from apps.common.validators import phone_validator, postcode_validator


class MalaysianState(models.TextChoices):
    JOHOR = 'Johor', 'Johor'
    KEDAH = 'Kedah', 'Kedah'
    KELANTAN = 'Kelantan', 'Kelantan'
    MELAKA = 'Melaka', 'Melaka'
    NEGERI_SEMBILAN = 'Negeri Sembilan', 'Negeri Sembilan'
    PAHANG = 'Pahang', 'Pahang'
    PERAK = 'Perak', 'Perak'
    PERLIS = 'Perlis', 'Perlis'
    PULAU_PINANG = 'Pulau Pinang', 'Pulau Pinang'
    SABAH = 'Sabah', 'Sabah'
    SARAWAK = 'Sarawak', 'Sarawak'
    SELANGOR = 'Selangor', 'Selangor'
    TERENGGANU = 'Terengganu', 'Terengganu'
    KUALA_LUMPUR = 'Kuala Lumpur', 'W.P. Kuala Lumpur'
    LABUAN = 'Labuan', 'W.P. Labuan'
    PUTRAJAYA = 'Putrajaya', 'W.P. Putrajaya'


class Address(models.Model):
    """A saved shipping address. Orders never reference this row: checkout
    copies the fields into the order's own shipping snapshot, so editing or
    deleting an address can't change order history."""

    class Country(models.TextChoices):
        # Shipping, postcode validation and pricing are Malaysia-only for now.
        MALAYSIA = 'Malaysia', 'Malaysia'

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='addresses')
    recipient_name = models.CharField(max_length=255)
    phone = models.CharField(max_length=32, validators=[phone_validator])
    address_line_1 = models.CharField(max_length=255)
    address_line_2 = models.CharField(max_length=255, blank=True)
    city = models.CharField(max_length=128)
    state = models.CharField(max_length=32, choices=MalaysianState.choices)
    postcode = models.CharField(max_length=5, validators=[postcode_validator])
    country = models.CharField(max_length=64, choices=Country.choices, default=Country.MALAYSIA)
    is_default = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'addresses'
        ordering = ['-is_default', '-created_at', '-id']
        constraints = [
            models.UniqueConstraint(
                fields=['user'], condition=Q(is_default=True), name='one_default_address_per_user',
            ),
        ]

    def __str__(self):
        return f'{self.recipient_name}, {self.address_line_1}, {self.postcode} {self.city}'
