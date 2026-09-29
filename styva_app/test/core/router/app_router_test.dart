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

  group('resolveAuthRedirect', () {
    test('redirects /home to /login when unauthenticated', () {
      final redirect = resolveAuthRedirect(
        authState: const AuthState.unauthenticated(),
        location: AppRoutes.home,
      );
      expect(redirect, AppRoutes.login);
    });

    test('redirects /login to /home when authenticated', () {
      final redirect = resolveAuthRedirect(
        authState: AuthState.authenticated(user),
        location: AppRoutes.login,
      );
      expect(redirect, AppRoutes.home);
    });

    test('redirects /register to /home when authenticated', () {
      final redirect = resolveAuthRedirect(
        authState: AuthState.authenticated(user),
        location: AppRoutes.register,
      );
      expect(redirect, AppRoutes.home);
    });

    test('allows /home when authenticated', () {
      final redirect = resolveAuthRedirect(
        authState: AuthState.authenticated(user),
        location: AppRoutes.home,
      );
      expect(redirect, isNull);
    });

    test('allows /login when unauthenticated', () {
      final redirect = resolveAuthRedirect(
        authState: const AuthState.unauthenticated(),
        location: AppRoutes.login,
      );
      expect(redirect, isNull);
    });

    test('does not redirect while auth status is still loading', () {
      final redirect = resolveAuthRedirect(
        authState: const AuthState.loading(),
        location: AppRoutes.home,
      );
      expect(redirect, isNull);
    });

    test('leaves unrelated routes alone', () {
      final redirect = resolveAuthRedirect(
        authState: const AuthState.unauthenticated(),
        location: AppRoutes.discover,
      );
      expect(redirect, isNull);
    });
  });
}
