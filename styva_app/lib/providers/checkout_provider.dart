import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/utils/api_error.dart';
import '../models/checkout_request_model.dart';
import '../models/checkout_summary_model.dart';
import '../models/order_model.dart';
import '../services/checkout_service.dart';
import 'api_provider.dart';
import 'cart_provider.dart';
import 'order_provider.dart';

part 'checkout_provider.freezed.dart';

final checkoutServiceProvider = Provider<CheckoutService>((ref) {
  return CheckoutService(ref.watch(apiClientProvider).dio);
});

final checkoutSummaryProvider = FutureProvider.autoDispose<CheckoutSummaryModel>((ref) {
  return ref.watch(checkoutServiceProvider).getSummary();
});

@freezed
class CheckoutState with _$CheckoutState {
  const factory CheckoutState.idle() = CheckoutIdle;
  const factory CheckoutState.loading() = CheckoutLoading;
  const factory CheckoutState.success(OrderModel order) = CheckoutSuccess;
  const factory CheckoutState.error(String message) = CheckoutError;
}

class CheckoutNotifier extends AutoDisposeNotifier<CheckoutState> {
  @override
  CheckoutState build() => const CheckoutState.idle();

  /// Places the order. A call made while one is already in flight is ignored,
  /// so repeated taps on "Place Order" can never send a second request.
  Future<void> placeOrder(int addressId) async {
    if (state is CheckoutLoading) return;
    state = const CheckoutState.loading();
    try {
      final order = await ref
          .read(checkoutServiceProvider)
          .checkout(CheckoutRequestModel(addressId: addressId));
      ref.invalidate(cartProvider);
      ref.invalidate(checkoutSummaryProvider);
      ref.invalidate(ordersProvider);
      state = CheckoutState.success(order);
    } catch (e) {
      // A 409 means stock changed since the summary was loaded; refresh it so
      // the screen shows current availability alongside the error.
      ref.invalidate(checkoutSummaryProvider);
      state = CheckoutState.error(extractApiErrorMessage(e));
    }
  }

  void reset() => state = const CheckoutState.idle();
}

final checkoutProvider = NotifierProvider.autoDispose<CheckoutNotifier, CheckoutState>(
  CheckoutNotifier.new,
);
