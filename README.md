# STYVA

STYVA is a curated, single-brand fashion e-commerce platform (not a marketplace) featuring mall fashion brands available in Malaysia — UNIQLO, Padini, H&M, Zara, Cotton On, Nike, Adidas, Puma, Skechers, New Balance, and ASICS.

This repository contains:

- `styva_backend/` — Django REST API (PostgreSQL, JWT auth)
- `styva_app/` — Flutter mobile app (Riverpod, GoRouter, Dio)

- **Phase 1.1** delivered the foundation: project architecture, routing, database models, and scaffolding.
- **Phase 1.2** delivers the Product & Catalog foundation: full product CRUD, filtering/search/ordering, pagination, a seed command, and Flutter data integration (models, services, providers, functional fetch pages). The final shopping UI is still out of scope.

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

5. Seed the catalog with placeholder brands, categories, products, and variants:

   ```bash
   python manage.py seed_products
   ```

   Creates 6 brands, 4 categories, 30 products, and size/color variants for each. Idempotent — safe to re-run. Uses placeholder image filenames only (e.g. `UNQ001.png`), no real image files.

6. Run the test suite:

   ```bash
   python manage.py test
   ```

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
| GET | `/api/brands/{id}/` | No |
| GET | `/api/categories/` | No |
| GET | `/api/categories/{id}/` | No |
| GET | `/api/products/` | No |
| GET | `/api/products/{id}/` | No |
| POST | `/api/products/` | Admin |
| PUT/PATCH | `/api/products/{id}/` | Admin |
| DELETE | `/api/products/{id}/` | Admin |
| GET | `/api/wishlist/` | Yes |
| POST | `/api/wishlist/` | Yes |
| GET | `/api/cart` | Yes |
| POST | `/api/cart/items` | Yes |
| PATCH | `/api/cart/items/{id}` | Yes |
| DELETE | `/api/cart/items/{id}` | Yes |
| GET | `/api/orders` | Yes |
| POST | `/api/orders` | Yes |

### Product filtering, ordering, and pagination

`GET /api/products/` supports:

- **Filters** (combinable): `brand` (slug), `category` (slug), `min_price`, `max_price`, `search` (matches name/description)
- **Ordering**: `?ordering=newest` (default), `price_low`, `price_high`
- **Pagination**: DRF `PageNumberPagination`, `page_size=10`, navigate with `?page=2`

Example: `/api/products/?brand=uniqlo&category=tops&min_price=20&max_price=100&ordering=price_low`

Product create/update accepts a nested `variants` array (`size`, `color`, `stock`); updating a product replaces its full variant set.

## Flutter app setup (`styva_app`)

```bash
cd styva_app
cp .env.example .env
flutter pub get
flutter run
```

`API_BASE_URL` in `.env` should point at the backend (`http://10.0.2.2:8000/api` for the Android emulator, `http://localhost:8000/api` for iOS simulator/web).

Run the test suite:

```bash
flutter analyze
flutter test
```

### App structure

```
styva_app/lib/
├── core/
│   ├── router/       # GoRouter configuration
│   ├── theme/        # AppTheme, AppColors, AppTypography (Material 3)
│   ├── constants/    # App-wide and API constants
│   └── utils/
├── models/            # BrandModel, CategoryModel, ProductModel, VariantModel (Freezed + json_serializable)
├── services/          # API client (Dio), ProductService
├── providers/         # Riverpod providers (productProvider, brandProvider, categoryProvider, ...)
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

## Scope

- Home fetches and lists real products; Product page shows name/price/brand/variants — no styling or final shopping UI
- No product images (placeholder filenames only, e.g. `UNQ001.png`) or hand-written hardcoded products (generated via `seed_products`)
- No AI Virtual Stylist or ML recommendations
- No custom Django admin beyond defaults
- No reviews
