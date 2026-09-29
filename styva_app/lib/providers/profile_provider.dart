import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/utils/api_error.dart';
import 'api_provider.dart';
import 'auth_provider.dart';

part 'profile_provider.freezed.dart';

/// State of a one-shot form submission (edit profile, change password).
@freezed
class SubmitState with _$SubmitState {
  const factory SubmitState.idle() = SubmitIdle;
  const factory SubmitState.loading() = SubmitLoading;
  const factory SubmitState.success() = SubmitSuccess;
  const factory SubmitState.error(String message) = SubmitError;
}

class EditProfileNotifier extends AutoDisposeNotifier<SubmitState> {
  @override
  SubmitState build() => const SubmitState.idle();

  /// Ignored while a save is already in flight, so repeated taps on Save
  /// never send a second request.
  Future<void> save({required String fullName, required String phone}) async {
    if (state is SubmitLoading) return;
    state = const SubmitState.loading();
    try {
      final user = await ref
          .read(authServiceProvider)
          .updateProfile(fullName: fullName, phone: phone);
      ref.read(authProvider.notifier).userUpdated(user);
      state = const SubmitState.success();
    } catch (e) {
      state = SubmitState.error(extractApiErrorMessage(e));
    }
  }
}

final editProfileProvider = NotifierProvider.autoDispose<EditProfileNotifier, SubmitState>(
  EditProfileNotifier.new,
);

class ChangePasswordNotifier extends AutoDisposeNotifier<SubmitState> {
  @override
  SubmitState build() => const SubmitState.idle();

  Future<void> change({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    if (state is SubmitLoading) return;
    state = const SubmitState.loading();
    try {
      final tokens = await ref.read(authServiceProvider).changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmNewPassword: confirmNewPassword,
          );
      // Every earlier refresh token was revoked by the backend; keep this
      // device signed in with the fresh pair it returned.
      await ref.read(tokenStorageProvider).saveTokens(access: tokens.access, refresh: tokens.refresh);
      state = const SubmitState.success();
    } catch (e) {
      state = SubmitState.error(extractApiErrorMessage(e));
    }
  }
}

final changePasswordProvider = NotifierProvider.autoDispose<ChangePasswordNotifier, SubmitState>(
  ChangePasswordNotifier.new,
);
