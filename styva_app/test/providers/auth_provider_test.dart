import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/auth_response_model.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/auth_provider.dart';
import 'package:styva_app/services/auth_service.dart';
import 'package:styva_app/services/session_expiry_notifier.dart';
import 'package:styva_app/services/token_storage.dart';

class MockAuthService extends Mock implements AuthService {}

class MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  late MockAuthService authService;
  late MockTokenStorage tokenStorage;
  late SessionExpiryNotifier sessionExpiryNotifier;

  final user = UserModel(
    id: 1,
    fullName: 'Jane Doe',
    email: 'jane@example.com',
    createdAt: DateTime(2026, 1, 1),
  );
  final authResponse = AuthResponseModel(access: 'access-1', refresh: 'refresh-1', user: user);

  AuthNotifier buildNotifier() => AuthNotifier(authService, tokenStorage, sessionExpiryNotifier);

  setUp(() {
    authService = MockAuthService();
    tokenStorage = MockTokenStorage();
    sessionExpiryNotifier = SessionExpiryNotifier();
    when(() => tokenStorage.saveTokens(access: any(named: 'access'), refresh: any(named: 'refresh')))
        .thenAnswer((_) async {});
    when(() => tokenStorage.clear()).thenAnswer((_) async {});
  });

  group('checkAuthStatus (runs on construction)', () {
    test('goes straight to unauthenticated when no access token is stored', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);

      final notifier = buildNotifier();
      final state = await notifier.stream.first;

      expect(state, const AuthState.unauthenticated());
      verifyNever(() => authService.getCurrentUser());
    });

    test('becomes authenticated when a stored token is still valid', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => 'valid-token');
      when(() => authService.getCurrentUser()).thenAnswer((_) async => user);

      final notifier = buildNotifier();
      final state = await notifier.stream.first;

      expect(state, AuthState.authenticated(user));
    });

    test('clears storage and becomes unauthenticated when the stored token is rejected', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => 'expired-token');
      when(() => authService.getCurrentUser()).thenThrow(
        DioException(requestOptions: RequestOptions(path: ''), response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 401,
        )),
      );

      final notifier = buildNotifier();
      final state = await notifier.stream.first;

      expect(state, const AuthState.unauthenticated());
      verify(() => tokenStorage.clear()).called(1);
    });
  });

  group('login', () {
    test('sets state to loading immediately, before the request resolves', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => authService.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return authResponse;
      });

      final loginFuture = notifier.login(email: 'jane@example.com', password: 'StrongPass123!');
      expect(notifier.state, const AuthState.loading());

      await loginFuture;
      expect(notifier.state, AuthState.authenticated(user));
    });

    test('success saves tokens and becomes authenticated', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => authService.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => authResponse);

      await notifier.login(email: 'jane@example.com', password: 'StrongPass123!');

      expect(notifier.state, AuthState.authenticated(user));
      verify(() => tokenStorage.saveTokens(access: 'access-1', refresh: 'refresh-1')).called(1);
    });

    test('failure surfaces the error message without saving tokens', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => authService.login(email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 401,
            data: {'detail': 'No active account found with the given credentials'},
          ),
        ),
      );

      await notifier.login(email: 'jane@example.com', password: 'wrong');

      expect(notifier.state, isA<AuthError>());
      expect(
        (notifier.state as AuthError).message,
        'No active account found with the given credentials',
      );
      verifyNever(() => tokenStorage.saveTokens(access: any(named: 'access'), refresh: any(named: 'refresh')));
    });
  });

  group('register', () {
    test('success saves tokens and becomes authenticated', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => authService.register(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => authResponse);

      await notifier.register(fullName: 'Jane Doe', email: 'jane@example.com', password: 'StrongPass123!');

      expect(notifier.state, AuthState.authenticated(user));
    });

    test('failure surfaces validation errors', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => authService.register(
            fullName: any(named: 'fullName'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 400,
            data: {
              'email': ['A user with this email already exists.'],
            },
          ),
        ),
      );

      await notifier.register(fullName: 'Jane Doe', email: 'dupe@example.com', password: 'StrongPass123!');

      expect(notifier.state, isA<AuthError>());
      expect((notifier.state as AuthError).message, contains('already exists'));
    });
  });

  group('logout', () {
    test('clears storage and becomes unauthenticated even when the server call fails', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => 'valid-token');
      when(() => authService.getCurrentUser()).thenAnswer((_) async => user);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => 'refresh-1');
      when(() => authService.logout(any())).thenThrow(
        DioException(requestOptions: RequestOptions(path: '')),
      );

      await notifier.logout();

      expect(notifier.state, const AuthState.unauthenticated());
      verify(() => tokenStorage.clear()).called(1);
    });

    test('does not call the server when there is no stored refresh token', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => null);
      final notifier = buildNotifier();
      await notifier.stream.first;

      when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => null);

      await notifier.logout();

      verifyNever(() => authService.logout(any()));
      expect(notifier.state, const AuthState.unauthenticated());
    });
  });

  group('session expiry', () {
    test('becomes unauthenticated when the interceptor reports a failed refresh', () async {
      when(() => tokenStorage.getAccessToken()).thenAnswer((_) async => 'valid-token');
      when(() => authService.getCurrentUser()).thenAnswer((_) async => user);
      final notifier = buildNotifier();
      await notifier.stream.first;
      expect(notifier.state, AuthState.authenticated(user));

      sessionExpiryNotifier.notifySessionExpired();

      expect(notifier.state, const AuthState.unauthenticated());
    });
  });
}
