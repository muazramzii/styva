from django_filters.rest_framework import DjangoFilterBackend
from rest_framework import filters, permissions, viewsets

from .filters import ProductFilter
from .models import Product
from .serializers import ProductSerializer

ORDERING_MAP = {
    'newest': '-created_at',
    'price_low': 'price',
    'price_high': '-price',
}


class ProductViewSet(viewsets.ModelViewSet):
    serializer_class = ProductSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    filterset_class = ProductFilter
    search_fields = ['name', 'description']

    def get_queryset(self):
        queryset = Product.objects.select_related('brand', 'category').prefetch_related('variants')
        ordering = self.request.query_params.get('ordering')
        return queryset.order_by(ORDERING_MAP.get(ordering, ORDERING_MAP['newest']))

    def get_permissions(self):
        if self.action in ('create', 'update', 'partial_update', 'destroy'):
            return [permissions.IsAdminUser()]
        return [permissions.AllowAny()]
