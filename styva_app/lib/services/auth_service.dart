import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

class AuthService {
  AuthService(this._dio);

  final Dio _dio;

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(ApiConstants.authRegister, data: {
      'full_name': fullName,
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(ApiConstants.authLogin, data: {
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _dio.post(ApiConstants.authRefresh, data: {
      'refresh': refreshToken,
    });
    return response.data['access'] as String;
  }

  Future<UserModel> getCurrentUser() async {
    final response = await _dio.get(ApiConstants.authMe);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Updates the editable profile fields. Email is never sent: it's the login
  /// identifier and the backend treats it as read-only.
  Future<UserModel> updateProfile({required String fullName, required String phone}) async {
    final response = await _dio.patch(ApiConstants.authMe, data: {
      'full_name': fullName,
      'phone': phone,
    });
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  /// Changes the password. The backend revokes every existing refresh token
  /// and returns a fresh pair for this device.
  Future<({String access, String refresh})> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final response = await _dio.post(ApiConstants.authChangePassword, data: {
      'current_password': currentPassword,
      'new_password': newPassword,
      'confirm_new_password': confirmNewPassword,
    });
    final data = response.data as Map<String, dynamic>;
    return (access: data['access'] as String, refresh: data['refresh'] as String);
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post(ApiConstants.authLogout, data: {
      'refresh': refreshToken,
    });
  }
}
