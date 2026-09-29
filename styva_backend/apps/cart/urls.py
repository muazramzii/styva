from django.urls import path

from .views import CartDetailView, CartItemCreateView, CartItemDetailView

# Mounted directly in config/urls.py (not via include()) so these paths can
# match the documented endpoints exactly ("GET /api/cart", not "/api/cart/")
# without Django's include() trailing-slash conventions getting in the way.
urlpatterns = [
    path('api/cart', CartDetailView.as_view(), name='cart-detail'),
    path('api/cart/items', CartItemCreateView.as_view(), name='cart-item-create'),
    path('api/cart/items/<int:pk>', CartItemDetailView.as_view(), name='cart-item-detail'),
]
