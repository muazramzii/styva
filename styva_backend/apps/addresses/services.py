"""Saved-address writes, which own the default-address rule:

- A user with any saved address has exactly one default.
- The first address a user saves becomes the default, whatever the client sent.
- Making an address the default clears the previous default.
- The current default can't be switched off directly -- make another address
  the default instead (so checkout always has an address to pre-select).
- Deleting the default promotes the most recently created remaining address.

Every write locks the user's row first, so concurrent requests for the same
user are serialized; the one-default partial unique constraint is the
database-level backstop.
"""
from django.contrib.auth import get_user_model
from django.db import transaction
from rest_framework.exceptions import ValidationError

from .models import Address

User = get_user_model()


def _lock_user(user):
    User.objects.select_for_update().get(pk=user.pk)


def _clear_default(user, keep=None):
    others = Address.objects.filter(user=user, is_default=True)
    if keep is not None:
        others = others.exclude(pk=keep.pk)
    others.update(is_default=False)


@transaction.atomic
def create_address(user, data):
    _lock_user(user)
    make_default = data.pop('is_default', False)
    if not Address.objects.filter(user=user).exists():
        make_default = True
    if make_default:
        _clear_default(user)
    return Address.objects.create(user=user, is_default=make_default, **data)


@transaction.atomic
def update_address(address, data):
    _lock_user(address.user)
    address = Address.objects.get(pk=address.pk)  # re-read under the lock
    make_default = data.pop('is_default', None)

    if make_default is False and address.is_default:
        raise ValidationError({
            'is_default': ['Your default address is required. Set another address as default instead.'],
        })

    for field, value in data.items():
        setattr(address, field, value)
    if make_default and not address.is_default:
        _clear_default(address.user, keep=address)
        address.is_default = True
    address.save()
    return address


@transaction.atomic
def delete_address(address):
    user = address.user
    _lock_user(user)
    was_default = Address.objects.filter(pk=address.pk, is_default=True).exists()
    Address.objects.filter(pk=address.pk).delete()
    if was_default:
        successor = Address.objects.filter(user=user).order_by('-created_at', '-id').first()
        if successor is not None:
            successor.is_default = True
            successor.save(update_fields=['is_default', 'updated_at'])
