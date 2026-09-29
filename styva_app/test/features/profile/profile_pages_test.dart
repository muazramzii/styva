import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/profile/pages/change_password_page.dart';
import 'package:styva_app/features/profile/pages/edit_profile_page.dart';
import 'package:styva_app/features/profile/pages/profile_page.dart';
import 'package:styva_app/models/user_model.dart';

import '../../helpers/signed_in_container.dart';

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

  setUp(() {
    authService = MockAuthService();
    tokenStorage = MockTokenStorage();
  });

  Future<void> pumpAccount(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/profile',
      routes: [
        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        GoRoute(path: '/profile/edit', builder: (_, __) => const EditProfilePage()),
        GoRoute(path: '/profile/password', builder: (_, __) => const ChangePasswordPage()),
        GoRoute(path: '/addresses', builder: (_, __) => const Text('addresses page')),
        GoRoute(path: '/orders', builder: (_, __) => const Text('orders page')),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: signedInOverrides(authService, tokenStorage),
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  group('Account screen', () {
    testWidgets('shows the profile and every account section', (tester) async {
      await pumpAccount(tester);

      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane@example.com'), findsOneWidget);
      expect(find.text('0123456789'), findsOneWidget);
      for (final label in ['Edit Profile', 'My Orders', 'Saved Addresses', 'Change Password', 'Log out']) {
        expect(find.text(label), findsOneWidget);
      }
    });

    testWidgets('shows "Not set" when there is no phone number', (tester) async {
      final router = GoRouter(routes: [GoRoute(path: '/', builder: (_, __) => const ProfilePage())]);
      final overrides = signedInOverrides(authService, tokenStorage);
      // Replaces the default signed-in user stubbed by signedInOverrides.
      when(() => authService.getCurrentUser()).thenAnswer((_) async => signedInUser.copyWith(phone: ''));

      await tester.pumpWidget(ProviderScope(overrides: overrides, child: MaterialApp.router(routerConfig: router)));
      await tester.pumpAndSettle();

      expect(find.text('Not set'), findsOneWidget);
    });

    testWidgets('Saved Addresses opens the address list', (tester) async {
      await pumpAccount(tester);

      await tester.tap(find.text('Saved Addresses'));
      await tester.pumpAndSettle();

      expect(find.text('addresses page'), findsOneWidget);
    });

    testWidgets('Log out signs out through the auth service', (tester) async {
      when(() => tokenStorage.getRefreshToken()).thenAnswer((_) async => 'refresh-1');
      when(() => authService.logout(any())).thenAnswer((_) async {});
      await pumpAccount(tester);

      await tester.tap(find.text('Log out'));
      await tester.pumpAndSettle();

      verify(() => authService.logout('refresh-1')).called(1);
      verify(() => tokenStorage.clear()).called(1);
    });
  });

  group('Edit Profile', () {
    Future<void> openEdit(WidgetTester tester) async {
      await pumpAccount(tester);
      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();
    }

    FilledButton saveButton(WidgetTester tester) =>
        tester.widget<FilledButton>(find.byKey(const Key('profile_save')));

    testWidgets('is pre-filled with the current profile and email is read-only', (tester) async {
      await openEdit(tester);

      expect(find.widgetWithText(TextFormField, 'Jane Doe'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, '0123456789'), findsOneWidget);
      final email = tester.widget<TextFormField>(find.widgetWithText(TextFormField, 'jane@example.com'));
      expect(email.enabled, isFalse);
    });

    testWidgets('invalid input is caught before any request', (tester) async {
      await openEdit(tester);

      await tester.enterText(find.byKey(const Key('profile_name')), '   ');
      await tester.enterText(find.byKey(const Key('profile_phone')), 'call me');
      await tester.tap(find.byKey(const Key('profile_save')));
      await tester.pumpAndSettle();

      expect(find.text('Full name is required'), findsOneWidget);
      expect(find.text('Enter a valid phone number'), findsOneWidget);
      verifyNever(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')));
    });

    testWidgets('saving updates the Account screen and shows feedback', (tester) async {
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenAnswer((_) async => signedInUser.copyWith(fullName: 'Jane Updated', phone: '0199999999'));
      await openEdit(tester);

      await tester.enterText(find.byKey(const Key('profile_name')), '  Jane Updated ');
      await tester.enterText(find.byKey(const Key('profile_phone')), '0199999999');
      await tester.tap(find.byKey(const Key('profile_save')));
      await tester.pumpAndSettle();

      verify(() => authService.updateProfile(fullName: 'Jane Updated', phone: '0199999999')).called(1);
      expect(find.text('Profile updated'), findsOneWidget);
      expect(find.byType(ProfilePage), findsOneWidget);
      expect(find.text('Jane Updated'), findsOneWidget);
      expect(find.text('0199999999'), findsOneWidget);
      expect(find.text('Jane Doe'), findsNothing);
    });

    testWidgets('Save is disabled while saving, so repeat taps send one request', (tester) async {
      final completer = Completer<UserModel>();
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenAnswer((_) => completer.future);
      await openEdit(tester);

      await tester.tap(find.byKey(const Key('profile_save')));
      await tester.pump();
      expect(saveButton(tester).onPressed, isNull);
      await tester.tap(find.byKey(const Key('profile_save')));

      completer.complete(signedInUser);
      await tester.pumpAndSettle();
      verify(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone'))).called(1);
    });

    testWidgets('an API error is shown and the page stays open', (tester) async {
      when(() => authService.updateProfile(fullName: any(named: 'fullName'), phone: any(named: 'phone')))
          .thenThrow(_apiError({
        'full_name': ['Ensure this field has no more than 255 characters.'],
      }));
      await openEdit(tester);

      await tester.tap(find.byKey(const Key('profile_save')));
      await tester.pumpAndSettle();

      expect(find.text('Ensure this field has no more than 255 characters.'), findsOneWidget);
      expect(find.byType(EditProfilePage), findsOneWidget);
      expect(saveButton(tester).onPressed, isNotNull);
    });
  });

  group('Change Password', () {
    Future<void> openChangePassword(WidgetTester tester) async {
      await pumpAccount(tester);
      await tester.tap(find.text('Change Password'));
      await tester.pumpAndSettle();
    }

    Future<void> fill(WidgetTester tester, {String confirm = 'NewPass456!'}) async {
      await tester.enterText(find.byKey(const Key('password_current')), 'OldPass123!');
      await tester.enterText(find.byKey(const Key('password_new')), 'NewPass456!');
      await tester.enterText(find.byKey(const Key('password_confirm')), confirm);
    }

    void stubChange(Future<({String access, String refresh})> Function() answer) {
      when(() => authService.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          )).thenAnswer((_) => answer());
    }

    testWidgets('mismatched confirmation is caught before any request', (tester) async {
      await openChangePassword(tester);

      await fill(tester, confirm: 'Different789!');
      await tester.tap(find.byKey(const Key('password_submit')));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
      verifyNever(() => authService.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          ));
    });

    testWidgets('empty fields are required', (tester) async {
      await openChangePassword(tester);

      await tester.tap(find.byKey(const Key('password_submit')));
      await tester.pumpAndSettle();

      expect(find.text('Current password is required'), findsOneWidget);
      expect(find.text('New password is required'), findsOneWidget);
    });

    testWidgets('success stores the new tokens and returns to Account', (tester) async {
      stubChange(() async => (access: 'access-2', refresh: 'refresh-2'));
      await openChangePassword(tester);

      await fill(tester);
      await tester.tap(find.byKey(const Key('password_submit')));
      await tester.pumpAndSettle();

      verify(() => tokenStorage.saveTokens(access: 'access-2', refresh: 'refresh-2')).called(1);
      expect(find.text('Password changed. Other devices have been signed out.'), findsOneWidget);
      expect(find.byType(ProfilePage), findsOneWidget);
    });

    testWidgets('an incorrect current password is shown', (tester) async {
      when(() => authService.changePassword(
            currentPassword: any(named: 'currentPassword'),
            newPassword: any(named: 'newPassword'),
            confirmNewPassword: any(named: 'confirmNewPassword'),
          )).thenThrow(_apiError({
        'current_password': ['Current password is incorrect.'],
      }));
      await openChangePassword(tester);

      await fill(tester);
      await tester.tap(find.byKey(const Key('password_submit')));
      await tester.pumpAndSettle();

      expect(find.text('Current password is incorrect.'), findsOneWidget);
      expect(find.byType(ChangePasswordPage), findsOneWidget);
    });

    testWidgets('submit is disabled while in flight', (tester) async {
      final completer = Completer<({String access, String refresh})>();
      stubChange(() => completer.future);
      await openChangePassword(tester);

      await fill(tester);
      await tester.tap(find.byKey(const Key('password_submit')));
      await tester.pump();
      expect(tester.widget<FilledButton>(find.byKey(const Key('password_submit'))).onPressed, isNull);

      completer.complete((access: 'a', refresh: 'r'));
      await tester.pumpAndSettle();
    });
  });
}
