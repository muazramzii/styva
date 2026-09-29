from rest_framework import generics, status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response

from .models import Address
from .serializers import AddressSerializer
from .services import create_address, delete_address, update_address


class OwnAddressesMixin:
    serializer_class = AddressSerializer
    permission_classes = [IsAuthenticated]

    def get_queryset(self):
        # Scoped at the queryset: another user's address id is simply a 404.
        return Address.objects.filter(user=self.request.user)


class AddressListCreateView(OwnAddressesMixin, generics.ListCreateAPIView):
    pagination_class = None

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        address = create_address(request.user, dict(serializer.validated_data))
        return Response(self.get_serializer(address).data, status=status.HTTP_201_CREATED)


class AddressDetailView(OwnAddressesMixin, generics.RetrieveUpdateDestroyAPIView):
    http_method_names = ['get', 'patch', 'delete', 'head', 'options']

    def update(self, request, *args, **kwargs):
        address = self.get_object()
        serializer = self.get_serializer(address, data=request.data, partial=True)
        serializer.is_valid(raise_exception=True)
        address = update_address(address, dict(serializer.validated_data))
        return Response(self.get_serializer(address).data)

    def perform_destroy(self, instance):
        delete_address(instance)
