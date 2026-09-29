import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';
import 'api_provider.dart';

final orderServiceProvider = Provider<OrderService>((ref) {
  return OrderService(ref.watch(apiClientProvider).dio);
});

final ordersProvider = FutureProvider.autoDispose<List<OrderModel>>((ref) {
  return ref.watch(orderServiceProvider).getOrders();
});

final orderDetailProvider = FutureProvider.autoDispose.family<OrderModel, int>((ref, id) {
  return ref.watch(orderServiceProvider).getOrder(id);
});
