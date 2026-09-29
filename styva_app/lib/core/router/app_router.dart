import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/addresses/pages/address_form_page.dart';
import '../../features/addresses/pages/address_list_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/cart/pages/cart_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import '../../features/discover/pages/discover_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/orders/pages/order_confirmation_page.dart';
import '../../features/orders/pages/order_detail_page.dart';
import '../../features/orders/pages/orders_page.dart';
import '../../features/payment/pages/mock_payment_page.dart';
import '../../features/product/pages/product_page.dart';
import '../../features/profile/pages/change_password_page.dart';
import '../../features/profile/pages/edit_profile_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/wishlist/pages/wishlist_page.dart';
import '../../providers/auth_provider.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String discover = '/discover';
  static const String product = '/product/:id';
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String orderConfirmation = '/order-confirmation/:id';
  static const String mockPayment = '/payments/:id/mock';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/password';
  static const String addresses = '/addresses';
  static const String addressNew = '/addresses/new';
  static const String addressEdit = '/addresses/:id/edit';
}

/// Pure redirect decision, kept separate from GoRouter wiring so it can be
/// unit tested without spinning up a router or widget tree.
///
/// Every screen requires authentication except /login and /register; the
/// splash screen ('/') is where the auth-status check runs, so it resolves
/// to /login or /home once that check completes rather than being a
/// destination in its own right. Both branches converge to a stable route
/// (login or home) on the very next evaluation, so this can't redirect-loop.
String? resolveAuthRedirect({required AuthState authState, required String location}) {
  if (authState is AuthLoading) return null;

  final isAuthenticated = authState is AuthAuthenticated;
  final isAuthScreen = location == AppRoutes.login || location == AppRoutes.register;

  if (!isAuthenticated) {
    return isAuthScreen ? null : AppRoutes.login;
  }

  if (isAuthScreen || location == AppRoutes.splash) {
    return AppRoutes.home;
  }
  return null;
}

/// Emits only when the kind of auth state changes (loading → authenticated,
/// authenticated → unauthenticated, ...). The redirect depends on nothing
/// else, and refreshing the router on every emission -- e.g. when a profile
/// update replaces the signed-in user -- would rebuild the route stack
/// mid-navigation and undo a pending pop.
Stream<Type> authStatusChanges(Stream<AuthState> states) {
  return states.map((state) => state.runtimeType).distinct();
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authStatusChanges(authNotifier.stream)),
    redirect: (context, state) {
      return resolveAuthRedirect(
        authState: ref.read(authProvider),
        location: state.matchedLocation,
      );
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.discover,
        name: 'discover',
        builder: (context, state) => const DiscoverPage(),
      ),
      GoRoute(
        path: AppRoutes.product,
        name: 'product',
        builder: (context, state) => ProductPage(
          productId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        name: 'wishlist',
        builder: (context, state) => const WishlistPage(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (context, state) => const OrdersPage(),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'order-detail',
        builder: (context, state) => OrderDetailPage(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.orderConfirmation,
        name: 'order-confirmation',
        builder: (context, state) => OrderConfirmationPage(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        // Development-only mock provider page; see MockPaymentPage.
        path: AppRoutes.mockPayment,
        name: 'mock-payment',
        builder: (context, state) => MockPaymentPage(paymentId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'change-password',
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        builder: (context, state) => const AddressListPage(),
      ),
      GoRoute(
        path: AppRoutes.addressNew,
        name: 'address-new',
        builder: (context, state) => const AddressFormPage(),
      ),
      GoRoute(
        path: AppRoutes.addressEdit,
        name: 'address-edit',
        builder: (context, state) => AddressFormPage(addressId: state.pathParameters['id']!),
      ),
    ],
  );
});
