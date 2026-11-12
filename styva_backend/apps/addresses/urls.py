from django.urls import path

from .views import AddressDetailView, AddressListCreateView

# Mounted directly in config/urls.py with no trailing slash, same convention as
# apps/cart/urls.py and apps/orders/urls.py.
urlpatterns = [
    path('api/addresses', AddressListCreateView.as_view(), name='address-list'),
    path('api/addresses/<int:pk>', AddressDetailView.as_view(), name='address-detail'),
]
