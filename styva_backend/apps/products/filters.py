import django_filters

from .models import Product


class ProductFilter(django_filters.FilterSet):
    brand = django_filters.CharFilter(field_name='brand__slug', lookup_expr='iexact')
    category = django_filters.CharFilter(field_name='category__slug', lookup_expr='iexact')
    min_price = django_filters.NumberFilter(field_name='price', lookup_expr='gte')
    max_price = django_filters.NumberFilter(field_name='price', lookup_expr='lte')

    class Meta:
        model = Product
        fields = ['brand', 'category', 'min_price', 'max_price']
