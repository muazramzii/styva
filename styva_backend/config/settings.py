"""
Django settings for the STYVA backend.
"""

from datetime import timedelta
from decimal import Decimal
from pathlib import Path

from django.core.exceptions import ImproperlyConfigured
from dotenv import load_dotenv
import os

BASE_DIR = Path(__file__).resolve().parent.parent

load_dotenv(BASE_DIR / '.env')


def env(key, default=None):
    return os.environ.get(key, default)


def env_bool(key, default=False):
    value = os.environ.get(key)
    if value is None:
        return default
    return value.strip().lower() in ('1', 'true', 'yes', 'on')


def env_list(key, default=''):
    value = os.environ.get(key, default)
    return [item.strip() for item in value.split(',') if item.strip()]


_INSECURE_SECRET_KEY = 'django-insecure-change-me-in-production'

SECRET_KEY = env('DJANGO_SECRET_KEY', _INSECURE_SECRET_KEY)

DEBUG = env_bool('DJANGO_DEBUG', True)

if not DEBUG and SECRET_KEY == _INSECURE_SECRET_KEY:
    raise ImproperlyConfigured(
        'DJANGO_SECRET_KEY must be set to a unique, random value when DJANGO_DEBUG is False.'
    )

ALLOWED_HOSTS = env_list('DJANGO_ALLOWED_HOSTS', 'localhost,127.0.0.1')


# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'rest_framework',
    'rest_framework_simplejwt',
    'rest_framework_simplejwt.token_blacklist',
    'corsheaders',
    'django_filters',

    'apps.users',
    'apps.authentication',
    'apps.brands',
    'apps.categories',
    'apps.products',
    'apps.wishlist',
    'apps.cart',
    'apps.orders',
    'apps.payment',
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'


# Database
# https://docs.djangoproject.com/en/stable/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': env('DB_NAME', 'styva'),
        'USER': env('DB_USER', 'postgres'),
        'PASSWORD': env('DB_PASSWORD', 'postgres'),
        'HOST': env('DB_HOST', 'localhost'),
        'PORT': env('DB_PORT', '5432'),
    }
}


# Custom user model

AUTH_USER_MODEL = 'users.User'


# Password validation
# https://docs.djangoproject.com/en/stable/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]


# Internationalization
# https://docs.djangoproject.com/en/stable/topics/i18n/

LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True


# Static & media files

STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

MEDIA_URL = 'media/'
MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'


# Django REST Framework

REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 10,
}


# Simple JWT

SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=int(env('JWT_ACCESS_TOKEN_LIFETIME_MINUTES', 60))),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=int(env('JWT_REFRESH_TOKEN_LIFETIME_DAYS', 7))),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
    'AUTH_HEADER_TYPES': ('Bearer',),
    'USER_ID_FIELD': 'id',
    'USER_ID_CLAIM': 'user_id',
}


# Checkout
# Flat shipping fee (RM) applied to every order. Calculated server-side only;
# see apps.orders.services.calculate_shipping_fee for where a real rule would go.

SHIPPING_FLAT_FEE = Decimal(env('SHIPPING_FLAT_FEE', '0.00'))

# Local time zone of the store. Timestamps are still stored in UTC; this only
# decides which calendar date appears in customer-facing order numbers.
STORE_TIME_ZONE = env('STORE_TIME_ZONE', 'Asia/Kuala_Lumpur')


# Payments
# Real providers (ToyyibPay, Billplz, Stripe, iPay88, FPX) are added here as
# PaymentProvider subclasses; the order/payment core never references one.

PAYMENT_PROVIDERS = {
    'mock': 'apps.payment.providers.mock.MockPaymentProvider',
}
PAYMENT_DEFAULT_PROVIDER = env('PAYMENT_DEFAULT_PROVIDER', 'mock')

# DEVELOPMENT ONLY. Enables POST /api/payments/{id}/mock-complete, which lets
# the owner of a *mock* payment simulate success/failure. Off unless DEBUG.
PAYMENT_MOCK_ENABLED = env_bool('PAYMENT_MOCK_ENABLED', DEBUG)

# Shared secret the mock provider's webhook must be signed with. Empty means
# the mock webhook rejects every request.
MOCK_PAYMENT_WEBHOOK_SECRET = env('MOCK_PAYMENT_WEBHOOK_SECRET', '')


# CORS

CORS_ALLOWED_ORIGINS = env_list('CORS_ALLOWED_ORIGINS', 'http://localhost:3000')
CORS_ALLOW_ALL_ORIGINS = env_bool('CORS_ALLOW_ALL_ORIGINS', DEBUG)
