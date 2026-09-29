import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/core/router/app_router.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/auth_provider.dart';

void main() {
  final user = UserModel(
    id: 1,
    fullName: 'Jane Doe',
    email: 'jane@example.com',
    createdAt: DateTime(2026, 1, 1),
  );

  const unauthenticated = AuthState.unauthenticated();
  final authenticated = AuthState.authenticated(user);
  const loading = AuthState.loading();

  group('resolveAuthRedirect - unauthenticated', () {
    for (final location in [
      AppRoutes.splash,
      AppRoutes.home,
      AppRoutes.discover,
      AppRoutes.wishlist,
      AppRoutes.cart,
      AppRoutes.checkout,
      AppRoutes.profile,
    ]) {
      test('redirects $location to /login', () {
        final redirect = resolveAuthRedirect(authState: unauthenticated, location: location);
        expect(redirect, AppRoutes.login);
      });
    }

    test('allows /login', () {
      final redirect = resolveAuthRedirect(authState: unauthenticated, location: AppRoutes.login);
      expect(redirect, isNull);
    });

    test('allows /register', () {
      final redirect = resolveAuthRedirect(authState: unauthenticated, location: AppRoutes.register);
      expect(redirect, isNull);
    });
  });

  group('resolveAuthRedirect - authenticated', () {
    test('redirects splash to /home', () {
      final redirect = resolveAuthRedirect(authState: authenticated, location: AppRoutes.splash);
      expect(redirect, AppRoutes.home);
    });

    test('redirects /login to /home', () {
      final redirect = resolveAuthRedirect(authState: authenticated, location: AppRoutes.login);
      expect(redirect, AppRoutes.home);
    });

    test('redirects /register to /home', () {
      final redirect = resolveAuthRedirect(authState: authenticated, location: AppRoutes.register);
      expect(redirect, AppRoutes.home);
    });

    for (final location in [
      AppRoutes.home,
      AppRoutes.discover,
      AppRoutes.wishlist,
      AppRoutes.cart,
      AppRoutes.checkout,
      AppRoutes.profile,
    ]) {
      test('allows $location', () {
        final redirect = resolveAuthRedirect(authState: authenticated, location: location);
        expect(redirect, isNull);
      });
    }
  });

  group('resolveAuthRedirect - loading', () {
    test('does not redirect away from splash while the auth check is in flight', () {
      final redirect = resolveAuthRedirect(authState: loading, location: AppRoutes.splash);
      expect(redirect, isNull);
    });

    test('does not redirect a protected route while the auth check is in flight', () {
      final redirect = resolveAuthRedirect(authState: loading, location: AppRoutes.home);
      expect(redirect, isNull);
    });
  });

  group('resolveAuthRedirect - no redirect loops', () {
    test('every redirect target resolves to null on the next evaluation', () {
      // Unauthenticated always converges on /login.
      final loginRedirect = resolveAuthRedirect(authState: unauthenticated, location: AppRoutes.login);
      expect(loginRedirect, isNull);

      // Authenticated always converges on /home.
      final homeRedirect = resolveAuthRedirect(authState: authenticated, location: AppRoutes.home);
      expect(homeRedirect, isNull);
    });

    test('logging out from a protected route redirects to /login, which itself is stable', () {
      final afterLogout = resolveAuthRedirect(authState: unauthenticated, location: AppRoutes.profile);
      expect(afterLogout, AppRoutes.login);

      final stable = resolveAuthRedirect(authState: unauthenticated, location: afterLogout!);
      expect(stable, isNull);
    });
  });
}
