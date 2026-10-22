import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/brand_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import 'api_provider.dart';

final productServiceProvider = Provider<ProductService>((ref) {
  return ProductService(ref.watch(apiClientProvider).dio);
});

final productProvider = FutureProvider<List<ProductModel>>((ref) {
  return ref.watch(productServiceProvider).getProducts();
});

/// Filters for a product listing, passed straight through to the API's
/// `category` / `brand` (slugs) and `search` query parameters.
typedef ProductQuery = ({String? category, String? brand, String? search});

const ProductQuery allProducts = (category: null, brand: null, search: null);

/// Products matching [ProductQuery]. Filtering happens on the backend.
final productListProvider = FutureProvider.autoDispose.family<List<ProductModel>, ProductQuery>((ref, query) {
  final search = query.search?.trim();
  return ref.watch(productServiceProvider).getProducts(
        category: query.category,
        brand: query.brand,
        search: (search == null || search.isEmpty) ? null : search,
      );
});

final productDetailProvider =FutureProvider.family<ProductModel, int>((ref, id) {
  return ref.watch(productServiceProvider).getProduct(id);
});

final brandProvider = FutureProvider<List<BrandModel>>((ref) {
  return ref.watch(productServiceProvider).getBrands();
});

final categoryProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(productServiceProvider).getCategories();
});
