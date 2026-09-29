import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/models/order_model.dart';
import 'package:styva_app/models/payment_model.dart';
import 'package:styva_app/providers/order_provider.dart';
import 'package:styva_app/providers/payment_provider.dart';
import 'package:styva_app/services/order_service.dart';
import 'package:styva_app/services/payment_service.dart';

import '../fixtures/order_fixtures.dart';
import '../fixtures/payment_fixtures.dart';

class MockPaymentService extends Mock implements PaymentService {}

class MockOrderService extends Mock implements OrderService {}

DioException _apiError(int statusCode, String detail) {
  final options = RequestOptions(path: '');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: statusCode, data: {'detail': detail}),
  );
}

void main() {
  late MockPaymentService paymentService;
  late MockOrderService orderService;
  late ProviderContainer container;
  const orderId = 1;
  final pending = PaymentModel.fromJson(pendingPaymentJson);
  final succeeded = PaymentModel.fromJson(paymentJsonWith(status: 'success'));
  final failed = PaymentModel.fromJson(paymentJsonWith(status: 'failed'));

  setUp(() {
    paymentService = MockPaymentService();
    orderService = MockOrderService();
    when(() => orderService.getOrder(any()))
        .thenAnswer((_) async => OrderModel.fromJson(orderDetailJson));
    container = ProviderContainer(overrides: [
      paymentServiceProvider.overrideWithValue(paymentService),
      orderServiceProvider.overrideWithValue(orderService),
    ]);
    addTearDown(container.dispose);
    // paymentProvider is autoDispose; keep it alive for the whole test.
    container.listen(paymentProvider(orderId), (_, __) {});
  });

  PaymentNotifier notifier() => container.read(paymentProvider(orderId).notifier);
  PaymentState state() => container.read(paymentProvider(orderId));

  test('starts idle', () {
    expect(state(), const PaymentState.idle());
  });

  test('startPayment goes loading, then pending with the payment', () async {
    final completer = Completer<PaymentModel>();
    when(() => paymentService.initiatePayment(orderId)).thenAnswer((_) => completer.future);

    final future = notifier().startPayment();
    expect(state(), const PaymentState.loading());

    completer.complete(pending);
    expect(await future, pending);
    expect(state(), PaymentState.pending(pending));
  });

  test('repeated startPayment calls while in flight send one request', () async {
    final completer = Completer<PaymentModel>();
    when(() => paymentService.initiatePayment(orderId)).thenAnswer((_) => completer.future);

    final first = notifier().startPayment();
    final second = notifier().startPayment();
    completer.complete(pending);

    expect(await second, isNull);
    expect(await first, pending);
    verify(() => paymentService.initiatePayment(orderId)).called(1);
  });

  test('startPayment surfaces the backend error message', () async {
    when(() => paymentService.initiatePayment(orderId))
        .thenThrow(_apiError(409, 'This order has already been paid.'));

    expect(await notifier().startPayment(), isNull);
    expect(state(), const PaymentState.error('This order has already been paid.'));
  });

  test('startPayment refreshes the order so its payment status is current', () async {
    container.listen(orderDetailProvider(orderId), (_, __) {});
    await container.read(orderDetailProvider(orderId).future);
    when(() => paymentService.initiatePayment(orderId)).thenAnswer((_) async => pending);

    await notifier().startPayment();
    await container.read(orderDetailProvider(orderId).future);

    verify(() => orderService.getOrder(orderId)).called(2);
  });

  test('simulated success ends in the success state', () async {
    when(() => paymentService.simulateMockPayment(5, 'success')).thenAnswer((_) async => succeeded);

    expect(await notifier().simulateMockOutcome(5, 'success'), succeeded);
    expect(state(), PaymentState.success(succeeded));
  });

  test('simulated failure ends in the failed state', () async {
    when(() => paymentService.simulateMockPayment(5, 'failed')).thenAnswer((_) async => failed);

    await notifier().simulateMockOutcome(5, 'failed');
    expect(state(), PaymentState.failed(failed));
  });

  test('repeated simulate calls while in flight send one request', () async {
    final completer = Completer<PaymentModel>();
    when(() => paymentService.simulateMockPayment(5, 'success'))
        .thenAnswer((_) => completer.future);

    final first = notifier().simulateMockOutcome(5, 'success');
    final second = notifier().simulateMockOutcome(5, 'success');
    completer.complete(succeeded);

    expect(await second, isNull);
    expect(await first, succeeded);
    verify(() => paymentService.simulateMockPayment(5, 'success')).called(1);
  });

  test('simulate surfaces errors, e.g. when mock payments are disabled', () async {
    when(() => paymentService.simulateMockPayment(5, 'success'))
        .thenThrow(_apiError(404, 'Not found.'));

    await notifier().simulateMockOutcome(5, 'success');
    expect(state(), const PaymentState.error('Not found.'));
  });
}
