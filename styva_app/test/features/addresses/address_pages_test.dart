import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/features/addresses/pages/address_form_page.dart';
import 'package:styva_app/features/addresses/pages/address_list_page.dart';
import 'package:styva_app/models/address_model.dart';
import 'package:styva_app/models/user_model.dart';
import 'package:styva_app/providers/address_provider.dart';
import 'package:styva_app/providers/auth_provider.dart';
import 'package:styva_app/services/address_service.dart';

import '../../fixtures/address_fixtures.dart';

class MockAddressService extends Mock implements AddressService {}

final _user = UserModel(id: 1, fullName: 'Buyer', email: 'buyer@example.com', createdAt: DateTime.utc(2026));

final _home = address(id: 1, isDefault: true, recipientName: 'Ali Home', addressLine1: '123 Jalan ABC');
final _office = address(id: 2, isDefault: false, recipientName: 'Ali Office', addressLine1: '9 Jalan Pejabat');

DioException _apiError(int statusCode, Map<String, dynamic> data) {
  final options = RequestOptions(path: '');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response(requestOptions: options, statusCode: statusCode, data: data),
  );
}

void main() {
  late MockAddressService service;

  setUpAll(() => registerFallbackValue(const AddressInput(
        recipientName: '', phone: '', addressLine1: '', city: '', state: '', postcode: '',
      )));

  setUp(() => service = MockAddressService());

  Future<void> pumpAt(WidgetTester tester, String location) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: location,
      routes: [
        GoRoute(path: '/addresses', builder: (_, __) => const AddressListPage()),
        GoRoute(path: '/addresses/new', builder: (_, __) => const AddressFormPage()),
        GoRoute(
          path: '/addresses/:id/edit',
          builder: (_, state) => AddressFormPage(addressId: state.pathParameters['id']!),
        ),
      ],
    );
    await tester.pumpWidget(ProviderScope(
      overrides: [
        addressServiceProvider.overrideWithValue(service),
        currentUserProvider.overrideWithValue(_user),
      ],
      child: MaterialApp.router(routerConfig: router),
    ));
    await tester.pumpAndSettle();
  }

  group('Saved Addresses list', () {
    testWidgets('shows a loading indicator, then the addresses with the default marked', (tester) async {
      final completer = Completer<List<AddressModel>>();
      when(() => service.getAddresses()).thenAnswer((_) => completer.future);

      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [
          addressServiceProvider.overrideWithValue(service),
          currentUserProvider.overrideWithValue(_user),
        ],
        child: const MaterialApp(home: AddressListPage()),
      ));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([_home, _office]);
      await tester.pumpAndSettle();

      expect(find.text('Ali Home'), findsOneWidget);
      expect(find.text('Ali Office'), findsOneWidget);
      expect(find.text('Default'), findsOneWidget);
      // Only the non-default address offers Set Default.
      expect(find.text('Set Default'), findsOneWidget);
    });

    testWidgets('empty state tells the user they have no saved address', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => []);

      await pumpAt(tester, '/addresses');

      expect(find.text("You haven't saved an address yet."), findsOneWidget);
      expect(find.text('Add Address'), findsOneWidget);
    });

    testWidgets('a load error offers a working retry', (tester) async {
      when(() => service.getAddresses()).thenThrow(_apiError(500, {}));
      await pumpAt(tester, '/addresses');

      expect(find.textContaining('Could not load your addresses.'), findsOneWidget);

      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text('Ali Home'), findsOneWidget);
    });

    testWidgets('Set Default updates the default from the server', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home, _office]);
      await pumpAt(tester, '/addresses');
      when(() => service.setDefault(2)).thenAnswer((_) async => _office.copyWith(isDefault: true));
      when(() => service.getAddresses())
          .thenAnswer((_) async => [_office.copyWith(isDefault: true), _home.copyWith(isDefault: false)]);

      await tester.tap(find.text('Set Default'));
      await tester.pumpAndSettle();

      verify(() => service.setDefault(2)).called(1);
      expect(find.text('Default address updated'), findsOneWidget);
      final officeCard = find.ancestor(of: find.text('Ali Office'), matching: find.byType(Card));
      expect(find.descendant(of: officeCard, matching: find.text('Default')), findsOneWidget);
    });

    testWidgets('actions are disabled while one is in flight', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home, _office]);
      await pumpAt(tester, '/addresses');
      final completer = Completer<AddressModel>();
      when(() => service.setDefault(2)).thenAnswer((_) => completer.future);

      await tester.tap(find.text('Set Default'));
      await tester.pump();
      await tester.tap(find.text('Set Default'));
      await tester.tap(find.text('Delete').first);
      await tester.pump();

      verify(() => service.setDefault(2)).called(1);
      expect(find.byType(AlertDialog), findsNothing);
      completer.complete(_office);
      await tester.pumpAndSettle();
    });

    testWidgets('Delete asks for confirmation, then removes the address', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home, _office]);
      await pumpAt(tester, '/addresses');
      when(() => service.deleteAddress(2)).thenAnswer((_) async {});

      final officeCard = find.ancestor(of: find.text('Ali Office'), matching: find.byType(Card));
      await tester.tap(find.descendant(of: officeCard, matching: find.text('Delete')));
      await tester.pumpAndSettle();
      expect(find.text('Delete address?'), findsOneWidget);

      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text('Delete')));
      await tester.pumpAndSettle();

      verify(() => service.deleteAddress(2)).called(1);
      expect(find.text('Ali Office'), findsNothing);
      expect(find.text('Address deleted'), findsOneWidget);
    });

    testWidgets('cancelling the delete dialog sends nothing', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      await pumpAt(tester, '/addresses');

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => service.deleteAddress(any()));
    });

    testWidgets('a failed mutation is reported and the list is kept', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home, _office]);
      await pumpAt(tester, '/addresses');
      when(() => service.setDefault(2)).thenThrow(_apiError(404, {'detail': 'Not found.'}));

      await tester.tap(find.text('Set Default'));
      await tester.pumpAndSettle();

      expect(find.text('Not found.'), findsOneWidget);
      expect(find.text('Ali Office'), findsOneWidget);
    });
  });

  group('Address form', () {
    Future<void> fillValid(WidgetTester tester) async {
      await tester.enterText(find.byKey(const Key('address_recipient')), 'Ali Bin Abu');
      await tester.enterText(find.byKey(const Key('address_phone')), '0198765432');
      await tester.enterText(find.byKey(const Key('address_line_1')), '123 Jalan ABC');
      await tester.enterText(find.byKey(const Key('address_city')), 'Skudai');
      await tester.enterText(find.byKey(const Key('address_postcode')), '81300');
      await tester.tap(find.byKey(const Key('address_state')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Johor').last);
      await tester.pumpAndSettle();
    }

    SwitchListTile defaultSwitch(WidgetTester tester) =>
        tester.widget<SwitchListTile>(find.byKey(const Key('address_default')));

    testWidgets('invalid input is caught before any request', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      await pumpAt(tester, '/addresses/new');

      await tester.enterText(find.byKey(const Key('address_phone')), 'abc');
      await tester.enterText(find.byKey(const Key('address_postcode')), '8130');
      await tester.tap(find.byKey(const Key('address_save')));
      await tester.pumpAndSettle();

      expect(find.text('Recipient name is required'), findsOneWidget);
      expect(find.text('Enter a valid phone number'), findsOneWidget);
      expect(find.text('Enter a valid 5-digit postcode'), findsOneWidget);
      expect(find.text('State is required'), findsOneWidget);
      verifyNever(() => service.createAddress(any()));
    });

    testWidgets('the first address is always the default', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => []);
      await pumpAt(tester, '/addresses/new');

      expect(defaultSwitch(tester).value, isTrue);
      expect(defaultSwitch(tester).onChanged, isNull);
      expect(find.text('Your first address is your default.'), findsOneWidget);
    });

    testWidgets('creating an address sends the trimmed input', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      when(() => service.createAddress(any())).thenAnswer((_) async => _office);
      await pumpAt(tester, '/addresses/new');

      await fillValid(tester);
      await tester.enterText(find.byKey(const Key('address_recipient')), '  Ali Bin Abu  ');
      await tester.tap(find.byKey(const Key('address_default')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('address_save')));
      await tester.pumpAndSettle();

      final input = verify(() => service.createAddress(captureAny())).captured.single as AddressInput;
      expect(input.recipientName, 'Ali Bin Abu');
      expect(input.state, 'Johor');
      expect(input.postcode, '81300');
      expect(input.country, 'Malaysia');
      expect(input.isDefault, isTrue);
    });

    testWidgets('Save is disabled while saving, so repeat taps create one address', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      final completer = Completer<AddressModel>();
      when(() => service.createAddress(any())).thenAnswer((_) => completer.future);
      await pumpAt(tester, '/addresses/new');

      await fillValid(tester);
      await tester.tap(find.byKey(const Key('address_save')));
      await tester.pump();
      expect(tester.widget<FilledButton>(find.byKey(const Key('address_save'))).onPressed, isNull);
      await tester.tap(find.byKey(const Key('address_save')));

      completer.complete(_office);
      await tester.pumpAndSettle();
      verify(() => service.createAddress(any())).called(1);
    });

    testWidgets('backend validation errors are shown', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);
      when(() => service.createAddress(any())).thenThrow(_apiError(400, {
        'postcode': ['Enter a valid 5-digit postcode.'],
      }));
      await pumpAt(tester, '/addresses/new');

      await fillValid(tester);
      await tester.tap(find.byKey(const Key('address_save')));
      await tester.pumpAndSettle();

      expect(find.text('Enter a valid 5-digit postcode.'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('address_save'))).onPressed, isNotNull);
    });

    testWidgets('editing pre-fills the address and saves changes to it', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home, _office]);
      when(() => service.updateAddress(2, any())).thenAnswer((_) async => _office);
      await pumpAt(tester, '/addresses/2/edit');

      expect(find.widgetWithText(TextFormField, '9 Jalan Pejabat'), findsOneWidget);
      expect(defaultSwitch(tester).value, isFalse);
      expect(defaultSwitch(tester).onChanged, isNotNull);

      await tester.enterText(find.byKey(const Key('address_line_1')), '10 Jalan Baru');
      await tester.tap(find.byKey(const Key('address_save')));
      await tester.pumpAndSettle();

      final input = verify(() => service.updateAddress(2, captureAny())).captured.single as AddressInput;
      expect(input.addressLine1, '10 Jalan Baru');
      expect(input.isDefault, isFalse);
    });

    testWidgets('the current default cannot be switched off', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home, _office]);
      await pumpAt(tester, '/addresses/1/edit');

      expect(defaultSwitch(tester).value, isTrue);
      expect(defaultSwitch(tester).onChanged, isNull);
    });

    testWidgets('an address that is not in your list shows not found', (tester) async {
      when(() => service.getAddresses()).thenAnswer((_) async => [_home]);

      await pumpAt(tester, '/addresses/99/edit');

      expect(find.text('Address not found'), findsOneWidget);
      expect(find.byKey(const Key('address_save')), findsNothing);
    });
  });
}
