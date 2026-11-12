import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/api_provider.dart';
import 'package:styva_app/providers/auth_provider.dart';
import 'package:styva_app/services/auth_service.dart';
import 'package:styva_app/services/token_storage.dart';

class MockAuthService extends Mock implements AuthService {}

class MockTokenStorage extends Mock implements TokenStorage {}

final signedInUser = UserModel(
  id: 1,
  fullName: 'Jane Doe',
  email: 'jane@example.com',
  phone: '0123456789',
  createdAt: DateTime.utc(2026, 1, 1),
);

/// Overrides that make the real [authProvider] restore a signed-in session
/// for [signedInUser] from mocked storage and API.
List<Override> signedInOverrides(MockAuthService authService, MockTokenStorage tokenStorage) {
  when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => 'access-1');
  when(() => tokenStorage.saveTokens(access: any(named: 'access'), refresh: any(named: 'refresh')))
      .thenAnswer((_) async {});
  when(() => tokenStorage.clear()).thenAnswer((_) async {});
  when(() => authService.getCurrentUser()).thenAnswer((_) async => signedInUser);
  return [
    authServiceProvider.overrideWithValue(authService),
    tokenStorageProvider.overrideWithValue(tokenStorage),
  ];
}

/// Waits until [authProvider] has finished restoring the session.
Future<void> waitForSignIn(ProviderContainer container) async {
  while (container.read(authProvider) is! AuthAuthenticated) {
    await Future<void>.delayed(Duration.zero);
  }
}
