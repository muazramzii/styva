from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.cart.models import CartItem

from .models import Order
from .serializers import (
    CheckoutSerializer,
    CheckoutSummarySerializer,
    OrderDetailSerializer,
    OrderListSerializer,
)
from .services import CheckoutError, build_checkout_summary, checkout


class OrderListView(generics.ListAPIView):
    serializer_class = OrderListSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related('items')


class OrderDetailView(generics.RetrieveAPIView):
    serializer_class = OrderDetailSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return Order.objects.filter(user=self.request.user).prefetch_related('items')


class CheckoutView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """Server-computed preview of what checkout would charge right now,
        so the client never has to add up prices or know the shipping rule."""
        cart_items = list(
            CartItem.objects.filter(cart__user=request.user)
            .select_related('variant__product__brand')
            .order_by('id')
        )
        summary = {'items': cart_items, **build_checkout_summary(cart_items)}
        return Response(CheckoutSummarySerializer(summary).data)

    def post(self, request):
        serializer = CheckoutSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        try:
            order = checkout(request.user, serializer.validated_data['shipping_address'])
        except CheckoutError as error:
            body = {'detail': error.detail}
            if error.items:
                body['items'] = error.items
            return Response(body, status=error.status_code)
        return Response(OrderDetailSerializer(order).data, status=status.HTTP_201_CREATED)
