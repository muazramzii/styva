"""Checkout: turn the authenticated user's cart into an Order.

Stock policy: stock is deducted at the moment the order is created (status
``pending``, payment ``pending``). There is no reservation/expiry yet, so an
order that is later cancelled or never paid does not return its stock
automatically -- that belongs with the payment phase.
"""
import secrets
from decimal import Decimal
from zoneinfo import ZoneInfo

from django.conf import settings
from django.db import IntegrityError, transaction
from django.db.models import F
from django.utils import timezone

from apps.cart.models import Cart, CartItem
from apps.products.models import ProductVariant

from .models import Order, OrderItem

_ORDER_NUMBER_ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'  # no 0/O/1/I lookalikes


class CheckoutError(Exception):
    status_code = 400

    def __init__(self, detail, items=None):
        super().__init__(detail)
        self.detail = detail
        self.items = items or []


class EmptyCartError(CheckoutError):
    def __init__(self):
        super().__init__('Your cart is empty.')


class InsufficientStockError(CheckoutError):
    status_code = 409

    def __init__(self, items):
        super().__init__('Some items in your cart are no longer available in that quantity.', items)


def calculate_shipping_fee(subtotal):
    """Project-wide shipping rule. A real calculation (weight, region, free
    shipping thresholds, ...) replaces this single function later."""
    return settings.SHIPPING_FLAT_FEE


def generate_order_number(now=None):
    # Use the store's local date, not UTC: an order placed at 03:00 in Malaysia
    # is still 19:00 the previous day in UTC, and the customer should see
    # today's date in their order number.
    local_now = timezone.localtime(now or timezone.now(), ZoneInfo(settings.STORE_TIME_ZONE))
    suffix = ''.join(secrets.choice(_ORDER_NUMBER_ALPHABET) for _ in range(6))
    return f'STYVA-{local_now:%Y%m%d}-{suffix}'


def build_checkout_summary(cart_items):
    """Server-side totals for the given cart items, using current prices."""
    subtotal = sum(
        (item.variant.product.price * item.quantity for item in cart_items),
        Decimal('0.00'),
    )
    shipping_fee = calculate_shipping_fee(subtotal)
    return {
        'subtotal': subtotal,
        'shipping_fee': shipping_fee,
        'total': subtotal + shipping_fee,
    }


@transaction.atomic
def checkout(user, shipping_address):
    # Locking the cart row serializes concurrent checkouts by the same user,
    # so a double-tapped "Place Order" can't create two orders from one cart.
    cart = Cart.objects.select_for_update().filter(user=user).first()
    if cart is None:
        raise EmptyCartError()

    cart_items = list(cart.items.order_by('variant_id'))
    if not cart_items:
        raise EmptyCartError()

    # Lock every variant being purchased (ascending id to avoid deadlocks
    # between concurrent checkouts). Stock is read *after* the lock is held,
    # so two buyers of the last units can't both pass validation.
    variants = {
        variant.id: variant
        for variant in ProductVariant.objects.select_for_update(of=('self',))
        .select_related('product__brand')
        .filter(id__in=[item.variant_id for item in cart_items])
        .order_by('id')
    }

    problems = []
    for item in cart_items:
        variant = variants.get(item.variant_id)
        if variant is None:
            problems.append({'cart_item_id': item.id, 'variant_id': item.variant_id, 'available': 0})
        elif item.quantity > variant.stock:
            problems.append({
                'cart_item_id': item.id,
                'variant_id': variant.id,
                'requested': item.quantity,
                'available': variant.stock,
            })
    if problems:
        raise InsufficientStockError(problems)

    for item in cart_items:
        item.variant = variants[item.variant_id]
    totals = build_checkout_summary(cart_items)

    order = _create_order(user, shipping_address, totals)

    OrderItem.objects.bulk_create([
        OrderItem(
            order=order,
            variant=item.variant,
            product_name=item.variant.product.name,
            brand_name=item.variant.product.brand.name,
            size=item.variant.size,
            color=item.variant.color,
            price=item.variant.product.price,
            quantity=item.quantity,
            subtotal=item.variant.product.price * item.quantity,
        )
        for item in cart_items
    ])

    for item in cart_items:
        ProductVariant.objects.filter(id=item.variant_id).update(stock=F('stock') - item.quantity)

    _clear_purchased_items(cart_items)
    return order


def _create_order(user, shipping_address, totals):
    fields = dict(
        user=user,
        subtotal=totals['subtotal'],
        shipping_fee=totals['shipping_fee'],
        total=totals['total'],
        shipping_full_name=shipping_address['full_name'],
        shipping_phone=shipping_address['phone'],
        shipping_address_line_1=shipping_address['address_line_1'],
        shipping_address_line_2=shipping_address.get('address_line_2', ''),
        shipping_city=shipping_address['city'],
        shipping_state=shipping_address['state'],
        shipping_postcode=shipping_address['postcode'],
    )
    for _ in range(5):
        try:
            # Savepoint so a (vanishingly unlikely) order-number collision only
            # rolls back this insert, not the whole checkout transaction.
            with transaction.atomic():
                return Order.objects.create(order_number=generate_order_number(), **fields)
        except IntegrityError:
            continue
    raise CheckoutError('Could not generate a unique order number. Please try again.')


def _clear_purchased_items(cart_items):
    # Delete only the items that were actually purchased, so anything added to
    # the cart concurrently (after we read it) survives.
    CartItem.objects.filter(id__in=[item.id for item in cart_items]).delete()
