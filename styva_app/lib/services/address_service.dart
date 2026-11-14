import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/address_model.dart';

/// Errors (400 validation, 401, 404 for an address that isn't yours, 5xx)
/// propagate as [DioException]; nothing is swallowed here.
class AddressService {
  AddressService(this._dio);

  final Dio _dio;

  Future<List<AddressModel>> getAddresses() async {
    final response = await _dio.get(ApiConstants.addresses);
    return (response.data as List)
        .map((json) => AddressModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<AddressModel> createAddress(AddressInput input) async {
    final response = await _dio.post(ApiConstants.addresses, data: input.toJson());
    return AddressModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AddressModel> updateAddress(int id, AddressInput input) async {
    final response = await _dio.patch('${ApiConstants.addresses}/$id', data: input.toJson());
    return AddressModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AddressModel> setDefault(int id) async {
    final response = await _dio.patch('${ApiConstants.addresses}/$id', data: {'is_default': true});
    return AddressModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteAddress(int id) async {
    await _dio.delete('${ApiConstants.addresses}/$id');
  }
}
