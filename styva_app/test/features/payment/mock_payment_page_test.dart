import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/payment/pages/mock_payment_page.dart';
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

void main() {
  late MockPaymentService paymentService;
  late MockOrderService orderService;

  setUp(() {
    paymentService = MockPaymentService();
    orderService = MockOrderService();
    when(() => orderService.getOrder(any()))
        .thenAnswer((_) async => OrderModel.fromJson(orderDetailJson));
    when(() => orderService.getOrders()).thenAnswer((_) async => []);
  });

  Future<void> pumpMockPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/payments/5/mock',
      routes: [
        GoRoute(path: '/payments/:id/mock', builder: (_, state) {
          return MockPaymentPage(paymentId: state.pathParameters['id']!);
        }),
        GoRoute(
          path: '/orders/:id',
          builder: (_, state) => Scaffold(body: Text('order ${state.pathParameters['id']}')),
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

  testWidgets('shows a clearly labelled test payment with order and amount', (tester) async {
    when(() => paymentService.getPayment(5))
        .thenAnswer((_) async => PaymentModel.fromJson(pendingPaymentJson));

    await pumpMockPage(tester);

    expect(find.text('STYVA Test Payment'), findsOneWidget);
    expect(find.textContaining('Development only'), findsOneWidget);
    expect(find.text('STYVA-20260930-7K3Q9M'), findsOneWidget);
    expect(find.text('RM 179.80'), findsOneWidget);
    expect(find.text('Simulate Success'), findsOneWidget);
    expect(find.text('Simulate Failure'), findsOneWidget);
    // Not a bank page: nothing asks for card or login details.
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('Simulate Success sends one request and returns to the order', (tester) async {
    when(() => paymentService.getPayment(5))
        .thenAnswer((_) async => PaymentModel.fromJson(pendingPaymentJson));
    final completer = Completer<PaymentModel>();
    when(() => paymentService.simulateMockPayment(5, 'success'))
        .thenAnswer((_) => completer.future);
    await pumpMockPage(tester);

    await tester.tap(find.text('Simulate Success'));
    await tester.pump();
    await tester.tap(find.text('Simulate Success'));
    await tester.tap(find.text('Simulate Failure'));

    completer.complete(PaymentModel.fromJson(paymentJsonWith(status: 'success')));
    await tester.pumpAndSettle();

    verify(() => paymentService.simulateMockPayment(5, 'success')).called(1);
    verifyNever(() => paymentService.simulateMockPayment(5, 'failed'));
    expect(find.text('order 1'), findsOneWidget);
    expect(find.text('Payment successful'), findsOneWidget);
  });

  testWidgets('Simulate Failure reports the failure', (tester) async {
    when(() => paymentService.getPayment(5))
        .thenAnswer((_) async => PaymentModel.fromJson(pendingPaymentJson));
    when(() => paymentService.simulateMockPayment(5, 'failed'))
        .thenAnswer((_) async => PaymentModel.fromJson(paymentJsonWith(status: 'failed')));
    await pumpMockPage(tester);

    await tester.tap(find.text('Simulate Failure'));
    await tester.pumpAndSettle();

    verify(() => paymentService.simulateMockPayment(5, 'failed')).called(1);
    expect(find.text('Payment failed'), findsOneWidget);
  });

  testWidgets('a completed payment cannot be simulated again', (tester) async {
    when(() => paymentService.getPayment(5))
        .thenAnswer((_) async => PaymentModel.fromJson(paymentJsonWith(status: 'success')));

    await pumpMockPage(tester);

    expect(find.text('This test payment has already succeeded.'), findsOneWidget);
    expect(find.text('Simulate Success'), findsNothing);
    expect(find.text('Simulate Failure'), findsNothing);
  });
}
