import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/checkout/pages/checkout_page.dart';
import 'package:styva_app/models/address_model.dart';
import 'package:styva_app/models/checkout_request_model.dart';
import 'package:styva_app/models/checkout_summary_model.dart';
import 'package:styva_app/models/order_model.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/address_provider.dart';
import 'package:styva_app/providers/auth_provider.dart';
import 'package:styva_app/providers/checkout_provider.dart';
import 'package:styva_app/services/address_service.dart';
import 'package:styva_app/services/checkout_service.dart';

import '../../fixtures/address_fixtures.dart';
import '../../fixtures/order_fixtures.dart';

class MockCheckoutService extends Mock implements CheckoutService {}

class MockAddressService extends Mock implements AddressService {}

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

final _user = UserModel(id: 1, fullName: 'Buyer', email: 'buyer@example.com', createdAt: DateTime.utc(2026));

final _home = address(id: 1, isDefault: true, recipientName: 'Ali Home', addressLine1: '123 Jalan ABC');
final _office = address(id: 2, isDefault: false, recipientName: 'Ali Office', addressLine1: '9 Jalan Pejabat');

void main() {
  late MockCheckoutService service;
  late MockAddressService addressService;

  setUpAll(() {
    registerFallbackValue(const CheckoutRequestModel(addressId: 0));
  });

  setUp(() {
    service = MockCheckoutService();
    addressService = MockAddressService();
    when(() => addressService.getAddresses()).thenAnswer((_) async => [_home, _office]);
  });

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
        GoRoute(
          path: '/addresses/new',
          builder: (context, __) => Scaffold(
            body: TextButton(
              onPressed: () => context.pop(address(id: 3, isDefault: false, recipientName: 'New Place')),
              child: const Text('save new address'),
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(ProviderScope(
      overrides: [
        checkoutServiceProvider.overrideWithValue(service),
        addressServiceProvider.overrideWithValue(addressService),
        currentUserProvider.overrideWithValue(_user),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  ElevatedButton placeOrderButton(WidgetTester tester) {
    return tester.widget<ElevatedButton>(find.byKey(const Key('place_order_button')));
  }

  RadioListTile<int> addressTile(WidgetTester tester, int id) {
    return tester.widget<RadioListTile<int>>(find.byKey(Key('checkout_address_$id')));
  }

  int placedAddressId() {
    final request = verify(() => service.checkout(captureAny())).captured.single as CheckoutRequestModel;
    return request.addressId;
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

  testWidgets('lists saved addresses with the default pre-selected and marked', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);

    await pumpCheckout(tester);

    expect(find.text('Ali Home'), findsOneWidget);
    expect(find.text('Ali Office'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(addressTile(tester, 1).groupValue, 1);
    expect(placeOrderButton(tester).onPressed, isNotNull);
  });

  testWidgets('Place Order sends the default address id and navigates to confirmation', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => service.checkout(any())).thenAnswer((_) async => OrderModel.fromJson(orderDetailJson));
    await pumpCheckout(tester);

    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();

    expect(placedAddressId(), 1);
    expect(find.text('confirmation 1'), findsOneWidget);
  });

  testWidgets('selecting another saved address sends that address id', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => service.checkout(any())).thenAnswer((_) async => OrderModel.fromJson(orderDetailJson));
    await pumpCheckout(tester);

    await tester.tap(find.text('Ali Office'));
    await tester.pumpAndSettle();
    expect(addressTile(tester, 2).groupValue, 2);

    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();

    expect(placedAddressId(), 2);
  });

  testWidgets('with no saved address, checkout is blocked until one is added', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => addressService.getAddresses()).thenAnswer((_) async => <AddressModel>[]);
    await pumpCheckout(tester);

    expect(find.text('Add a shipping address to continue.'), findsOneWidget);
    expect(placeOrderButton(tester).onPressed, isNull);
    verifyNever(() => service.checkout(any()));
  });

  testWidgets('a newly added address is selected on return', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => service.checkout(any())).thenAnswer((_) async => OrderModel.fromJson(orderDetailJson));
    await pumpCheckout(tester);

    await tester.tap(find.byKey(const Key('checkout_add_address')));
    await tester.pumpAndSettle();
    when(() => addressService.getAddresses()).thenAnswer(
      (_) async => [_home, _office, address(id: 3, isDefault: false, recipientName: 'New Place')],
    );
    await tester.tap(find.text('save new address'));
    await tester.pumpAndSettle();
    // The real address form re-fetches the list; simulate that refresh here.
    final container = ProviderScope.containerOf(tester.element(find.byType(CheckoutPage)));
    container.invalidate(addressesProvider);
    await tester.pumpAndSettle();

    expect(addressTile(tester, 3).groupValue, 3);
    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();
    expect(placedAddressId(), 3);
  });

  testWidgets('an address load failure offers a retry', (tester) async {
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => addressService.getAddresses()).thenThrow(Exception('offline'));
    await pumpCheckout(tester);

    expect(find.textContaining('Could not load your addresses'), findsOneWidget);
    expect(placeOrderButton(tester).onPressed, isNull);

    when(() => addressService.getAddresses()).thenAnswer((_) async => [_home]);
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Ali Home'), findsOneWidget);
    expect(placeOrderButton(tester).onPressed, isNotNull);
  });

  testWidgets('Place Order is disabled while the request is in flight', (tester) async {
    final completer = Completer<OrderModel>();
    when(() => service.getSummary()).thenAnswer((_) async => _summaryWithItem);
    when(() => service.checkout(any())).thenAnswer((_) => completer.future);
    await pumpCheckout(tester);

    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pump();

    expect(placeOrderButton(tester).onPressed, isNull);
    expect(addressTile(tester, 2).onChanged, isNull);

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
        statusCode: 400,
        data: {
          'address_id': ['Address not found.'],
        },
      ),
    ));
    await pumpCheckout(tester);

    await tester.tap(find.byKey(const Key('place_order_button')));
    await tester.pumpAndSettle();

    expect(find.text('Address not found.'), findsWidgets);
    expect(find.byType(CheckoutPage), findsOneWidget);
    expect(placeOrderButton(tester).onPressed, isNotNull);
  });
}
