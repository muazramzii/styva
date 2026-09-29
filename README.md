# STYVA

STYVA is a curated, single-brand fashion e-commerce platform (not a marketplace) featuring mall fashion brands available in Malaysia — UNIQLO, Padini, H&M, Zara, Cotton On, Nike, Adidas, Puma, Skechers, New Balance, and ASICS.

This repository contains:

- `styva_backend/` — Django REST API (PostgreSQL, JWT auth)
- `styva_app/` — Flutter mobile app (Riverpod, GoRouter, Dio)

- **Phase 1.1** delivered the foundation: project architecture, routing, database models, and scaffolding.
- **Phase 1.2** delivered the Product & Catalog foundation: full product CRUD, filtering/search/ordering, pagination, a seed command, and Flutter data integration (models, services, providers, functional fetch pages).
- **Phase 1.3** delivered Authentication & User Session: JWT register/login/refresh/logout (with blacklisting), secure token persistence and auto-login in Flutter, route guards, and functional Login/Register screens.
- **Phase 1.4** delivered Wishlist & Cart Foundation: authenticated wishlist and cart APIs with server-authoritative pricing/stock, and functional Flutter Wishlist/Cart screens with variant selection on Product Detail.
- **Phase 1.5** delivers Checkout & Order Foundation: transactional checkout with stock locking and deduction, price-snapshotted orders, order history, and the Flutter checkout → confirmation → orders flow. A real payment gateway is still out of scope.

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
| POST | `/api/auth/logout` | Yes |
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
| DELETE | `/api/wishlist/{product_id}/` | Yes |
| GET | `/api/cart` | Yes |
| POST | `/api/cart/items` | Yes |
| PATCH | `/api/cart/items/{id}` | Yes |
| DELETE | `/api/cart/items/{id}` | Yes |
| GET | `/api/orders/checkout` | Yes (server-computed checkout preview) |
| POST | `/api/orders/checkout` | Yes |
| GET | `/api/orders` | Yes |
| GET | `/api/orders/{id}` | Yes |

### Product filtering, ordering, and pagination

`GET /api/products/` supports:

- **Filters** (combinable): `brand` (slug), `category` (slug), `min_price`, `max_price`, `search` (matches name/description)
- **Ordering**: `?ordering=newest` (default), `price_low`, `price_high`
- **Pagination**: DRF `PageNumberPagination`, `page_size=10`, navigate with `?page=2`

Example: `/api/products/?brand=uniqlo&category=tops&min_price=20&max_price=100&ordering=price_low`

Product create/update accepts a nested `variants` array (`size`, `color`, `stock`); updating a product replaces its full variant set.

### Authentication

- Registration/login accept email case-insensitively (`Jane@x.com` and `jane@x.com` are the same account) and never return the password.
- Login and registration errors don't reveal whether an email is registered (both return the same generic "No active account found" message).
- `/api/auth/logout` blacklists the given refresh token via SimpleJWT's token blacklist — it can never be used again, including to obtain a new access token.
- Refresh tokens rotate on every use (`ROTATE_REFRESH_TOKENS` + `BLACKLIST_AFTER_ROTATION`), so a stolen refresh token stops working the moment the legitimate client refreshes.

### Wishlist & Cart

- Both are scoped to the authenticated user; one user can never see or modify another user's wishlist or cart (enforced at the queryset level, not just in the client).
- Wishlist duplicates are rejected with a clean `400`, backed by a DB-level `unique_together` constraint. `DELETE /api/wishlist/{product_id}/` removes by product id, not the wishlist row's own id.
- Adding a variant already in the cart merges into the existing `CartItem` (quantity accumulates) instead of creating a duplicate row.
- `subtotal`/`total` are always computed server-side from the current `ProductVariant.stock` and `Product.price` — the client cannot influence price, and a later price change is reflected on the next fetch. Quantity must be `> 0` and can never exceed current stock, checked both on add (accounting for an already-existing item's quantity) and on update.

### Checkout & Orders

- `POST /api/orders/checkout` accepts **only** a `shipping_address` (Malaysian 5-digit postcode). Subtotal, shipping fee, total, and unit prices are always calculated by the backend from current database values; any such fields in the request are ignored.
- Checkout runs in a single database transaction. The user's cart row is locked (so a double-tapped "Place Order" can't create two orders), and every purchased variant is locked in id order before stock is read (so two buyers of the last units can't both succeed — the loser gets a `409`). Empty cart → `400`.
- **Stock is deducted when the order is created** (status `pending`, payment `pending`). There is no reservation/expiry yet, so an unpaid or cancelled order does not return stock automatically; that belongs with the payment phase.
- On success the purchased cart items are removed. On any failure nothing is persisted: no order, no items, no stock change, cart intact.
- Each `OrderItem` snapshots product name, brand, size, color, unit price, and line subtotal, so order history never changes when a product is renamed or repriced.
- Orders get a customer-facing number like `STYVA-20260930-7K3Q9M` (store-local date + random suffix, not the database id).
- Shipping fee is a single backend rule: `SHIPPING_FLAT_FEE` (default `0.00`), in `apps/orders/services.py::calculate_shipping_fee`. `STORE_TIME_ZONE` (default `Asia/Kuala_Lumpur`) sets the date used in order numbers.
- Orders are read-only via the API and scoped to their owner (another user's order id returns `404`).

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
│   ├── router/       # GoRouter configuration + auth route guard
│   ├── theme/        # AppTheme, AppColors, AppTypography (Material 3)
│   ├── constants/    # App-wide and API constants
│   └── utils/        # API error message extraction
├── models/            # Product/User/Wishlist/Cart/Order/ShippingAddress/Checkout models (Freezed + json_serializable)
├── services/          # API client (Dio), Product/Auth/Wishlist/Cart/Checkout/Order services, TokenStorage, AuthInterceptor
├── providers/         # Riverpod providers (productProvider, authProvider, wishlistProvider, cartProvider, checkoutProvider, ordersProvider, ...)
├── features/
│   ├── auth/          # Splash, Login, Register
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

| Path | Page | Requires login |
| --- | --- | --- |
| `/` | SplashPage (runs the auth check, then redirects) | — |
| `/login` | LoginPage | No (redirects to `/home` if already logged in) |
| `/register` | RegisterPage | No (redirects to `/home` if already logged in) |
| `/home` | HomePage | Yes |
| `/discover` | DiscoverPage | Yes |
| `/product/:id` | ProductPage | Yes |
| `/wishlist` | WishlistPage | Yes |
| `/cart` | CartPage | Yes |
| `/checkout` | CheckoutPage | Yes |
| `/order-confirmation/:id` | OrderConfirmationPage | Yes |
| `/orders` | OrdersPage | Yes |
| `/orders/:id` | OrderDetailPage | Yes |
| `/profile` | ProfilePage (includes the logout button) | Yes |

### Authentication flow

- Tokens are persisted in `flutter_secure_storage` (never `SharedPreferences`); `TokenStorage` is the single place that reads/writes them.
- On startup, `authProvider` checks for a stored access token and calls `/api/auth/me` to restore the session (`AuthState`: `loading` → `authenticated`/`unauthenticated`). The splash screen is shown while this resolves, so an unauthenticated user is never briefly shown a protected screen.
- `AuthInterceptor` attaches the access token to every request and, on a `401`, transparently refreshes and retries once. Concurrent `401`s share a single in-flight refresh instead of racing each other. If the refresh itself fails, tokens are cleared and the app reactively drops back to `unauthenticated`.
- Logging out calls `/api/auth/logout` (best-effort — the local session is cleared either way) and clears stored tokens.

## Scope

- Home fetches and lists real products; Product Detail supports color/size variant selection, Add to Wishlist, and Add to Cart with success/out-of-stock/invalid-selection/API-failure feedback
- Wishlist, Cart, Checkout, Order Confirmation, Orders, and Order Detail screens are functional; checkout shows a "Payment method — coming in next phase" placeholder and places the order with payment `pending` — no real payment gateway yet
- No saved address book (the shipping address is entered at checkout)
- No product images (placeholder filenames only, e.g. `UNQ001.png`) or hand-written hardcoded products (generated via `seed_products`)
- No social/Google/Apple/biometric login, password reset, email verification, or profile editing yet
- No AI Virtual Stylist or ML recommendations
- No custom Django admin beyond defaults
- No reviews
