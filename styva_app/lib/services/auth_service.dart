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

  Future<String> refresh(String refreshToken) async {
    final response = await _dio.post(ApiConstants.authRefresh, data: {
      'refresh': refreshToken,
    });
    return response.data['access'] as String;
  }

  Future<UserModel> me() async {
    final response = await _dio.get(ApiConstants.authMe);
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post(ApiConstants.authLogout, data: {
      'refresh': refreshToken,
    });
  }
}
