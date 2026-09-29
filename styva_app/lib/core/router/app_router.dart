import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/register_page.dart';
import '../../features/auth/pages/splash_page.dart';
import '../../features/cart/pages/cart_page.dart';
import '../../features/checkout/pages/checkout_page.dart';
import '../../features/discover/pages/discover_page.dart';
import '../../features/home/pages/home_page.dart';
import '../../features/product/pages/product_page.dart';
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
  static const String profile = '/profile';
}

/// Pure redirect decision, kept separate from GoRouter wiring so it can be
/// unit tested without spinning up a router or widget tree.
String? resolveAuthRedirect({required AuthState authState, required String location}) {
  if (authState is AuthLoading) return null;

  final isAuthenticated = authState is AuthAuthenticated;
  final isAuthRoute = location == AppRoutes.login || location == AppRoutes.register;

  if (location == AppRoutes.home && !isAuthenticated) {
    return AppRoutes.login;
  }
  if (isAuthRoute && isAuthenticated) {
    return AppRoutes.home;
  }
  return null;
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
    refreshListenable: GoRouterRefreshStream(authNotifier.stream),
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
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
});
