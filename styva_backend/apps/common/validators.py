"""Field validators shared by profiles, saved addresses and checkout, so a
phone number or postcode is judged by the same rule everywhere."""
from django.core.validators import RegexValidator

phone_validator = RegexValidator(r'^\+?[0-9][0-9\s-]{6,19}$', 'Enter a valid phone number.')

# Malaysian postcodes are always exactly five digits (e.g. 01000, 81300, 98000).
postcode_validator = RegexValidator(r'^\d{5}$', 'Enter a valid 5-digit postcode.')
