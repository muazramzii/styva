import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000/api';

  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authRefresh = '/auth/refresh';
  static const String authMe = '/auth/me';

  static const String brands = '/brands/';
  static const String categories = '/categories/';
  static const String products = '/products/';

  static const String wishlist = '/wishlist/';

  static const String cart = '/cart';
  static const String cartItems = '/cart/items';

  static const String orders = '/orders';
}
