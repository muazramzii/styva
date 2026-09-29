import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/utils/api_error.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/session_expiry_notifier.dart';
import '../services/token_storage.dart';
import 'api_provider.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(UserModel user) = AuthAuthenticated;
  const factory AuthState.error(String message) = AuthError;
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService, this._tokenStorage, SessionExpiryNotifier sessionExpiryNotifier)
      : super(const AuthState.loading()) {
    _sessionExpiryNotifier = sessionExpiryNotifier..addListener(_handleSessionExpired);
    checkAuthStatus();
  }

  final AuthService _authService;
  final TokenStorage _tokenStorage;
  late final SessionExpiryNotifier _sessionExpiryNotifier;

  void _handleSessionExpired() {
    if (state is! AuthUnauthenticated) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> checkAuthStatus() async {
    final accessToken = await _tokenStorage.getAccessToken();
    if (accessToken == null) {
      state = const AuthState.unauthenticated();
      return;
    }
    try {
      final user = await _authService.getCurrentUser();
      state = AuthState.authenticated(user);
    } catch (_) {
      await _tokenStorage.clear();
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      final response = await _authService.login(email: email, password: password);
      await _tokenStorage.saveTokens(access: response.access, refresh: response.refresh);
      state = AuthState.authenticated(response.user);
    } catch (e) {
      state = AuthState.error(extractApiErrorMessage(e));
    }
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final response = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      await _tokenStorage.saveTokens(access: response.access, refresh: response.refresh);
      state = AuthState.authenticated(response.user);
    } catch (e) {
      state = AuthState.error(extractApiErrorMessage(e));
    }
  }

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken != null) {
      try {
        await _authService.logout(refreshToken);
      } catch (_) {
        // Best-effort server-side blacklist; local session is cleared regardless.
      }
    }
    await _tokenStorage.clear();
    state = const AuthState.unauthenticated();
  }

  @override
  void dispose() {
    _sessionExpiryNotifier.removeListener(_handleSessionExpired);
    super.dispose();
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(apiClientProvider).dio);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authServiceProvider),
    ref.watch(tokenStorageProvider),
    ref.watch(sessionExpiryNotifierProvider),
  );
});

final currentUserProvider = Provider<UserModel?>((ref) {
  final state = ref.watch(authProvider);
  return state.maybeWhen(authenticated: (user) => user, orElse: () => null);
});
