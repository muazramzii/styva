from django.urls import path

from .views import CheckoutView, OrderDetailView, OrderListView

# Mounted directly in config/urls.py (not under an 'api/orders/' include) so the
# paths match the documented endpoints exactly, with no trailing slash --
# same approach as apps/cart/urls.py.
urlpatterns = [
    path('api/orders', OrderListView.as_view(), name='order-list'),
    path('api/orders/checkout', CheckoutView.as_view(), name='order-checkout'),
    path('api/orders/<int:pk>', OrderDetailView.as_view(), name='order-detail'),
]
