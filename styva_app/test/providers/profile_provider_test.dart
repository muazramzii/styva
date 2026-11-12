import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/auth_provider.dart';
import 'package:styva_app/providers/profile_provider.dart';

import '../helpers/signed_in_container.dart';

DioException _apiError(Map<String, dynamic> data) {
  final options = RequestOptions(path: '');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: 400, data: data),
  );
}

void main() {
  late MockAuthService authService;
  late MockTokenStorage tokenStorage;
  late ProviderContainer container;

  final updated = signedInUser.copyWith(fullName: 'Jane Updated', phone: '0199999999');

  setUp(() async {
    authService = MockAuthService();
    tokenStorage = MockTokenStorage();
    container = ProviderContainer(overrides: signedInOverrides(authService, tokenStorage));
    addTearDown(container.dispose);
    container.listen(editProfileProvider, (_, __) {});
    container.listen(changePasswordProvider, (_, __) {});
    await waitForSignIn(container);
  });

  group('EditProfileNotifier', () {
    test('saves, then replaces the signed-in user so nothing shows stale data', () async {
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenAnswer((_) async => updated);

      await container.read(editProfileProvider.notifier).save(fullName: 'Jane Updated', phone: '0199999999');

      expect(container.read(editProfileProvider), const SubmitState.success());
      expect(container.read(currentUserProvider), updated);
    });

    test('goes loading while the request is in flight', () async {
      final completer = Completer<UserModel>();
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenAnswer((_) => completer.future);

      final future = container.read(editProfileProvider.notifier).save(fullName: 'X', phone: '');
      expect(container.read(editProfileProvider), const SubmitState.loading());

      completer.complete(updated);
      await future;
    });

    test('repeated saves while in flight send one request', () async {
      final completer = Completer<UserModel>();
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenAnswer((_) => completer.future);
      final notifier = container.read(editProfileProvider.notifier);

      final first = notifier.save(fullName: 'X', phone: '');
      final second = notifier.save(fullName: 'X', phone: '');
      completer.complete(updated);
      await Future.wait([first, second]);

      verify(() => authService.updateProfile(fullName: 'X', phone: '')).called(1);
    });

    test('an API error is shown and the profile is unchanged', () async {
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenThrow(_apiError({
        'phone': ['Enter a valid phone number.'],
      }));

      await container.read(editProfileProvider.notifier).save(fullName: 'X', phone: 'bad');

      expect(container.read(editProfileProvider), const SubmitState.error('Enter a valid phone number.'));
      expect(container.read(currentUserProvider), signedInUser);
    });
  });

  group('ChangePasswordNotifier', () {
    Future<void> change() => container
        .read(changePasswordProvider.notifier)
        .change(currentPassword: 'OldPass123!', newPassword: 'NewPass456!', confirmNewPassword: 'NewPass456!');

    test('stores the fresh token pair returned by the backend', () async {
      when(() => authService.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          )).thenAnswer((_) async => (access: 'access-2', refresh: 'refresh-2'));

      await change();

      expect(container.read(changePasswordProvider), const SubmitState.success());
      verify(() => tokenStorage.saveTokens(access: 'access-2', refresh: 'refresh-2')).called(1);
      expect(container.read(authProvider), isA<AuthAuthenticated>());
    });

    test('an incorrect current password shows the error and keeps the old tokens', () async {
      when(() => authService.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          )).thenThrow(_apiError({
        'current_password': ['Current password is incorrect.'],
      }));

      await change();

      expect(container.read(changePasswordProvider), const SubmitState.error('Current password is incorrect.'));
      verifyNever(() => tokenStorage.saveTokens(access: any(named: 'access'), refresh: any(named: 'refresh')));
    });

    test('repeated submits while in flight send one request', () async {
      final completer = Completer<({String access, String refresh})>();
      when(() => authService.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          )).thenAnswer((_) => completer.future);

      final first = change();
      final second = change();
      completer.complete((access: 'a', refresh: 'r'));
      await Future.wait([first, second]);

      verify(() => authService.changePassword(
            currentPassword: 'OldPass123!',
            newPassword: 'NewPass456!',
            confirmNewPassword: 'NewPass456!',
          )).called(1);
    });
  });
}
