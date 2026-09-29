from django.urls import path

from .views import InitiatePaymentView, MockPaymentCompleteView, PaymentDetailView, PaymentWebhookView

# Mounted directly in config/urls.py with no trailing slash, same convention as
# apps/cart/urls.py and apps/orders/urls.py.
urlpatterns = [
    path('api/payments/initiate', InitiatePaymentView.as_view(), name='payment-initiate'),
    path('api/payments/<int:pk>', PaymentDetailView.as_view(), name='payment-detail'),
    path('api/payments/<int:pk>/mock-complete', MockPaymentCompleteView.as_view(), name='payment-mock-complete'),
    path('api/payments/webhook/<str:provider>', PaymentWebhookView.as_view(), name='payment-webhook'),
]
