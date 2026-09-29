import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/orders/widgets/order_payment_section.dart';
import 'package:styva_app/models/order_model.dart';
import 'package:styva_app/models/payment_model.dart';
import 'package:styva_app/providers/order_provider.dart';
import 'package:styva_app/providers/payment_provider.dart';
import 'package:styva_app/services/order_service.dart';
import 'package:styva_app/services/payment_service.dart';

import '../../fixtures/order_fixtures.dart';
import '../../fixtures/payment_fixtures.dart';

class MockPaymentService extends Mock implements PaymentService {}

class MockOrderService extends Mock implements OrderService {}

OrderModel _order({String status = 'pending', String paymentStatus = 'pending'}) =>
    OrderModel.fromJson({...orderDetailJson, 'status': status, 'payment_status': paymentStatus});

void main() {
  late MockPaymentService paymentService;
  late MockOrderService orderService;

  setUp(() {
    paymentService = MockPaymentService();
    orderService = MockOrderService();
    when(() => orderService.getOrder(any())).thenAnswer((_) async => _order());
    when(() => orderService.getOrders()).thenAnswer((_) async => []);
  });

  Future<void> pumpSection(WidgetTester tester, OrderModel order) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => Scaffold(body: OrderPaymentSection(order: order))),
        GoRoute(
          path: '/payments/:id/mock',
          builder: (_, state) => Text('mock payment ${state.pathParameters['id']}'),
        ),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        paymentServiceProvider.overrideWithValue(paymentService),
        orderServiceProvider.overrideWithValue(orderService),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('pending payment shows "Payment Pending" and "Pay Now"', (tester) async {
    await pumpSection(tester, _order());

    expect(find.text('Payment Pending'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Pay Now'), findsOneWidget);
  });

  testWidgets('successful payment shows "Paid" with no pay button', (tester) async {
    await pumpSection(tester, _order(status: 'paid', paymentStatus: 'success'));

    expect(find.text('Paid'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('failed payment shows "Payment Failed" and "Try Again"', (tester) async {
    await pumpSection(tester, _order(paymentStatus: 'failed'));

    expect(find.text('Payment Failed'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Try Again'), findsOneWidget);
  });

  testWidgets('cancelled orders show no payment action', (tester) async {
    await pumpSection(tester, _order(status: 'cancelled'));

    expect(find.byType(FilledButton), findsNothing);
    expect(find.text('Payment Pending'), findsNothing);
  });

  testWidgets('orders past pending offer no pay button even if unpaid', (tester) async {
    await pumpSection(tester, _order(status: 'packing'));

    expect(find.text('Payment Pending'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('Pay Now starts payment once and opens the mock payment page', (tester) async {
    final completer = Completer<PaymentModel>();
    when(() => paymentService.initiatePayment(1)).thenAnswer((_) => completer.future);
    await pumpSection(tester, _order());

    await tester.tap(find.text('Pay Now'));
    await tester.pump();
    // Button is disabled while the request is in flight.
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);
    await tester.tap(find.byType(FilledButton));

    completer.complete(PaymentModel.fromJson(pendingPaymentJson));
    await tester.pumpAndSettle();

    verify(() => paymentService.initiatePayment(1)).called(1);
    expect(find.text('mock payment 5'), findsOneWidget);
  });

  testWidgets('Try Again starts a new payment attempt', (tester) async {
    when(() => paymentService.initiatePayment(1))
        .thenAnswer((_) async => PaymentModel.fromJson(paymentJsonWith(id: 6)));
    await pumpSection(tester, _order(paymentStatus: 'failed'));

    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    verify(() => paymentService.initiatePayment(1)).called(1);
    expect(find.text('mock payment 6'), findsOneWidget);
  });

  testWidgets('shows the backend error when payment cannot start', (tester) async {
    final options = RequestOptions(path: '');
    when(() => paymentService.initiatePayment(1)).thenThrow(DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: options,
        statusCode: 409,
        data: {'detail': 'This order has already been paid.'},
      ),
    ));
    await pumpSection(tester, _order());

    await tester.tap(find.text('Pay Now'));
    await tester.pumpAndSettle();

    expect(find.text('This order has already been paid.'), findsOneWidget);
    expect(find.textContaining('mock payment'), findsNothing);
  });
}
