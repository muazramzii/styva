from rest_framework import viewsets
from rest_framework.permissions import AllowAny

from .models import Brand
from .serializers import BrandSerializer


class BrandViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Brand.objects.all()
    serializer_class = BrandSerializer
    permission_classes = [AllowAny]
