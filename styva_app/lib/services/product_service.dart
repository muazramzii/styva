import 'package:dio/dio.dart';

import '../core/constants/api_constants.dart';
import '../models/brand_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class ProductService {
  ProductService(this._dio);

  final Dio _dio;

  Future<List<ProductModel>> getProducts({
    String? brand,
    String? category,
    double? minPrice,
    double? maxPrice,
    String? search,
    String? ordering,
  }) async {
    final response = await _dio.get(
      ApiConstants.products,
      queryParameters: {
        if (brand != null) 'brand': brand,
        if (category != null) 'category': category,
        if (minPrice != null) 'min_price': minPrice,
        if (maxPrice != null) 'max_price': maxPrice,
        if (search != null) 'search': search,
        if (ordering != null) 'ordering': ordering,
      },
    );
    final results = response.data['results'] as List;
    return results
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProduct(int id) async {
    final response = await _dio.get('${ApiConstants.products}$id/');
    return ProductModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<BrandModel>> getBrands() async {
    final response = await _dio.get(ApiConstants.brands);
    final results = response.data['results'] as List;
    return results
        .map((json) => BrandModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryModel>> getCategories() async {
    final response = await _dio.get(ApiConstants.categories);
    final results = response.data['results'] as List;
    return results
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
