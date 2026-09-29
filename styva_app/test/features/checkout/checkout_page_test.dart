import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/checkout/pages/checkout_page.dart';
import 'package:styva_app/models/checkout_request_model.dart';
import 'package:styva_app/models/checkout_summary_model.dart';
import 'package:styva_app/models/order_model.dart';
import 'package:styva_app/models/shipping_address_model.dart';
import 'package:styva_app/providers/checkout_provider.dart';
import 'package:styva_app/services/checkout_service.dart';

import '../../fixtures/order_fixtures.dart';

class MockCheckoutService extends Mock implements CheckoutService {}

final _summaryWithItem = CheckoutSummaryModel.fromJson({
  'items': [
    {
      'id': 1,
      'variant': {
        'id': 3,
        'size': 'M',
        'color': 'Black',
        'stock': 5,
        'product': {'id': 1, 'name': 'Oversized Cotton Shirt', 'price': '89.90', 'brand': 'UNIQLO'},
      },
      'quantity': 2,
      'subtotal': '179.80',
    },
  ],
  'subtotal': '179.80',
  'shipping_fee': '8.00',
  'total': '187.80',
});

const _emptySummary = CheckoutSummaryModel(items: [], subtotal: 0, shippingFee: 0, total: 0);

void main() {
  late MockCheckoutService service;

  setUpAll(() {
    registerFallbackValue(const CheckoutRequestModel(
      shippingAddress: ShippingAddressModel(
        fullName: '', phone: '', addressLine1: '', city: '', state: '', postcode: '',
      ),
    ));
  });

  setUp(() => service = MockCheckoutService());

  Future<void> pumpCheckout(WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: '/checkout',
      routes: [
        GoRoute(path: '/checkout', builder: (_, __) => const CheckoutPage()),
        GoRoute(
          path: '/order-confirmation/:id',
          builder: (_, state) => Text('confirmation ${state.pathParameters['id']}'),
        ),
        GoRoute(path: '/home', builder: (_, __) => const Text('home')),
      ],
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [checkoutServiceProvider.overrideWithValue(service)],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  Future<void> fillValidAddress(WidgetTester tester) async {
    await tester.enterText(find.byKey(const Key('checkout_full_name')), 'Test Buyer');
    await tester.enterText(find.byKey(const Key('checkout_phone')), '0123456789');
    await tester.enterText(find.byKey(const Key('checkout_address_line_1')), '1 Jalan Ujian');
    await tester.enterText(find.byKey(const Key('checkout_city')), 'Skudai');
    await tester.enterText(find.byKey(const Key('checkout_state')), 'Johor');
    await tester.enterText(find.byKey(const Key('checkout_postcode')), '81300');
  }

  ElevatedButton placeOrderButton(WidgetTester tester) {
    return tester.widget<ElevatedButton>(find.byKey(const Key('place_order_button')));
  }

  testWidgets('an empty cart cannot be checked out', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _emptySummary);

    await pumpCheckout(tester);

    expect(placeOrderButton(tester).onPressed, isNull);
    expect(find.text('Your cart is empty'), findsWidgets);
  });

  testWidgets('shows the cart items and server-calculated totals', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);

    await pumpCheckout(tester);

    expect(find.text('Oversized Cotton Shirt'), findsOneWidget);
    expect(find.text('M / Black · 2 × RM 89.90'), findsOneWidget);
    expect(find.text('RM 179.80'), findsNWidgets(2)); // line subtotal + order subtotal
    expect(find.text('RM 8.00'), findsOneWidget);
    expect(find.text('RM 187.80'), findsOneWidget);
    expect(find.text('Coming in next phase'), findsOneWidget);
  });

  testWidgets('invalid address blocks the request', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    await pumpCheckout(tester);

    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();

    expect(find.text('Full name is required'), findsOneWidget);
    verifyNever(() => service.checkout(any()));
  });

  testWidgets('Place Order triggers checkout and navigates to confirmation on success',
      (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => service.checkout(any()))
        .thenAnswer((_) async => OrderModel.fromJson(orderDetailJson));
    await pumpCheckout(tester);

    await fillValidAddress(tester);
    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();

    final request = verify(() => service.checkout(captureAny())).captured.single
        as CheckoutRequestModel;
    expect(request.shippingAddress.postcode, '81300');
    expect(find.text('confirmation 1'), findsOneWidget);
  });

  testWidgets('Place Order is disabled while the request is in flight', (tester) async {
    final completer = Completer<OrderModel>();
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => service.checkout(any())).thenAnswer((_) => completer.future);
    await pumpCheckout(tester);

    await fillValidAddress(tester);
    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pump();

    expect(placeOrderButton(tester).onPressed, isNull);

    completer.complete(OrderModel.fromJson(orderDetailJson));
    await tester.pumpAndSettle();
    verify(() => service.checkout(any())).called(1);
  });

  testWidgets('a failed checkout shows the error and stays on the page', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    final options = RequestOptions(path: '');
    when(() => service.checkout(any())).thenThrow(DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: options,
        statusCode: 409,
        data: {'detail': 'Some items in your cart are no longer available in that quantity.'},
      ),
    ));
    await pumpCheckout(tester);

    await fillValidAddress(tester);
    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Some items in your cart are no longer available in that quantity.'),
      findsWidgets,
    );
    expect(find.byType(CheckoutPage), findsOneWidget);
    expect(placeOrderButton(tester).onPressed, isNotNull);
  });
}
