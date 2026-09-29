import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/utils/api_error.dart';
import '../models/payment_model.dart';
import '../services/payment_service.dart';
import 'api_provider.dart';
import 'order_provider.dart';

part 'payment_provider.freezed.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return PaymentService(ref.watch(apiClientProvider).dio);
});

final paymentDetailProvider = FutureProvider.autoDispose.family<PaymentModel, int>((ref, id) {
  return ref.watch(paymentServiceProvider).getPayment(id);
});

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.idle() = PaymentIdle;
  const factory PaymentState.loading() = PaymentLoading;
  const factory PaymentState.pending(PaymentModel payment) = PaymentPending;
  const factory PaymentState.success(PaymentModel payment) = PaymentSuccess;
  const factory PaymentState.failed(PaymentModel payment) = PaymentFailed;
  const factory PaymentState.error(String message) = PaymentError;
}

PaymentState _stateFor(PaymentModel payment) {
  switch (payment.status) {
    case PaymentStatus.success:
      return PaymentState.success(payment);
    case PaymentStatus.failed:
      return PaymentState.failed(payment);
    default:
      return PaymentState.pending(payment);
  }
}

/// Payment flow for one order (the family argument is the order id).
///
/// Calls made while a request is already in flight are ignored, so repeated
/// taps on "Pay Now" or "Simulate Success" never send a second request.
/// Payment status itself is always decided by the backend.
class PaymentNotifier extends AutoDisposeFamilyNotifier<PaymentState, int> {
  @override
  PaymentState build(int orderId) => const PaymentState.idle();

  /// Starts payment for the order, or resumes its existing pending payment.
  /// Returns the payment, or null if ignored or it failed ([state] has why).
  Future<PaymentModel?> startPayment() async {
    if (state is PaymentLoading) return null;
    state = const PaymentState.loading();
    try {
      final payment = await ref.read(paymentServiceProvider).initiatePayment(arg);
      _refreshOrder();
      state = _stateFor(payment);
      return payment;
    } catch (e) {
      // e.g. 409 "already paid": refresh so the screen shows the real status.
      _refreshOrder();
      state = PaymentState.error(extractApiErrorMessage(e));
      return null;
    }
  }

  /// DEVELOPMENT ONLY: simulate the mock provider reporting [outcome].
  Future<PaymentModel?> simulateMockOutcome(int paymentId, String outcome) async {
    if (state is PaymentLoading) return null;
    state = const PaymentState.loading();
    try {
      final payment =
          await ref.read(paymentServiceProvider).simulateMockPayment(paymentId, outcome);
      ref.invalidate(paymentDetailProvider(paymentId));
      _refreshOrder();
      state = _stateFor(payment);
      return payment;
    } catch (e) {
      state = PaymentState.error(extractApiErrorMessage(e));
      return null;
    }
  }

  void _refreshOrder() {
    ref.invalidate(orderDetailProvider(arg));
    ref.invalidate(ordersProvider);
  }
}

final paymentProvider =
    NotifierProvider.autoDispose.family<PaymentNotifier, PaymentState, int>(PaymentNotifier.new);
