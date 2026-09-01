# STYVA

STYVA is a curated, single-brand fashion e-commerce platform (not a marketplace) featuring mall fashion brands available in Malaysia — UNIQLO, Padini, H&M, Zara, Cotton On, Nike, Adidas, Puma, Skechers, New Balance, and ASICS.

This repository contains:

- `styva_backend/` — Django REST API (PostgreSQL, JWT auth)
- `styva_app/` — Flutter mobile app (Riverpod, GoRouter, Dio)

This phase (1.1) delivers the foundation only: project architecture, routing, database models, and scaffolding. No shopping UI, product images, or dummy data are included.

## Prerequisites

- Python 3.11+
- PostgreSQL 14+
- Flutter 3.29+ (stable channel)

## Backend setup (`styva_backend`)

```bash
cd styva_backend
python -m venv venv
source venv/Scripts/activate   # Windows Git Bash; use venv\Scripts\activate.bat on cmd
pip install -r requirements.txt
```

1. Create a PostgreSQL database:

   ```sql
   CREATE DATABASE styva;
   ```

2. Copy the environment template and fill in your values:

   ```bash
   cp .env.example .env
   ```

3. Apply migrations and create an admin user:

   ```bash
   python manage.py migrate
   python manage.py createsuperuser
   ```

4. Run the dev server:

   ```bash
   python manage.py runserver
   ```

API is available at `http://localhost:8000/api/`, Django admin at `http://localhost:8000/admin/`.

### Backend structure

```
styva_backend/
├── config/                 # Django project settings, root URLs
├── apps/
│   ├── authentication/     # JWT register/login/refresh/me
│   ├── users/               # Custom User model
│   ├── brands/
│   ├── categories/
│   ├── products/            # Product, ProductVariant
│   ├── wishlist/
│   ├── cart/                 # Cart, CartItem
│   ├── orders/                # Order, OrderItem
│   └── payment/
├── manage.py
└── requirements.txt
```

### API endpoints

| Method | Endpoint | Auth |
| --- | --- | --- |
| POST | `/api/auth/register` | No |
| POST | `/api/auth/login` | No |
| POST | `/api/auth/refresh` | No |
| GET | `/api/auth/me` | Yes |
| GET | `/api/brands/` | No |
| GET | `/api/categories/` | No |
| GET | `/api/products/` | No |
| GET | `/api/products/{id}/` | No |
| GET | `/api/wishlist/` | Yes |
| POST | `/api/wishlist/` | Yes |
| GET | `/api/cart` | Yes |
| POST | `/api/cart/items` | Yes |
| PATCH | `/api/cart/items/{id}` | Yes |
| DELETE | `/api/cart/items/{id}` | Yes |
| GET | `/api/orders` | Yes |
| POST | `/api/orders` | Yes |

## Flutter app setup (`styva_app`)

```bash
cd styva_app
cp .env.example .env
flutter pub get
flutter run
```

`API_BASE_URL` in `.env` should point at the backend (`http://10.0.2.2:8000/api` for the Android emulator, `http://localhost:8000/api` for iOS simulator/web).

### App structure

```
styva_app/lib/
├── core/
│   ├── router/       # GoRouter configuration
│   ├── theme/        # AppTheme, AppColors, AppTypography (Material 3)
│   ├── constants/    # App-wide and API constants
│   └── utils/
├── models/            # Data models (Freezed + json_serializable)
├── services/          # API client (Dio)
├── providers/         # Riverpod providers
├── features/
│   ├── auth/          # Splash, Login
│   ├── home/
│   ├── discover/
│   ├── product/
│   ├── wishlist/
│   ├── cart/
│   ├── checkout/
│   └── profile/
├── shared/
│   ├── widgets/
│   └── components/
└── main.dart
```

### Routes

| Path | Page |
| --- | --- |
| `/` | SplashPage |
| `/login` | LoginPage |
| `/home` | HomePage |
| `/discover` | DiscoverPage |
| `/product/:id` | ProductPage |
| `/wishlist` | WishlistPage |
| `/cart` | CartPage |
| `/checkout` | CheckoutPage |
| `/profile` | ProfilePage |

## Scope of this phase

- No shopping UI beyond empty, centered-title pages
- No product images or hardcoded products
- No AI Virtual Stylist or ML recommendations
- No custom Django admin beyond defaults
- No reviews
