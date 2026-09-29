from rest_framework import generics, serializers, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import Cart, CartItem
from .serializers import CartItemSerializer, CartSerializer


class CartDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        return Response(CartSerializer(cart).data)


class CartItemCreateView(generics.CreateAPIView):
    serializer_class = CartItemSerializer
    permission_classes = [IsAuthenticated]

    def create(self, request, *args, **kwargs):
        cart, _ = Cart.objects.get_or_create(user=request.user)
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        variant = serializer.validated_data['variant']
        quantity = serializer.validated_data['quantity']

        existing_item = CartItem.objects.filter(cart=cart, variant=variant).first()
        requested_quantity = (existing_item.quantity if existing_item else 0) + quantity

        if requested_quantity > variant.stock:
            raise serializers.ValidationError({
                'quantity': f'Only {variant.stock} in stock.',
            })

        if existing_item:
            existing_item.quantity = requested_quantity
            existing_item.save(update_fields=['quantity'])
            return Response(CartItemSerializer(existing_item).data, status=status.HTTP_200_OK)

        cart_item = CartItem.objects.create(cart=cart, variant=variant, quantity=quantity)
        return Response(CartItemSerializer(cart_item).data, status=status.HTTP_201_CREATED)


class CartItemDetailView(generics.UpdateAPIView, generics.DestroyAPIView):
    serializer_class = CartItemSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        return CartItem.objects.filter(cart__user=self.request.user)

    def perform_update(self, serializer):
        instance = serializer.instance
        quantity = serializer.validated_data.get('quantity', instance.quantity)

        if quantity > instance.variant.stock:
            raise serializers.ValidationError({
                'quantity': f'Only {instance.variant.stock} in stock.',
            })

        serializer.save()
