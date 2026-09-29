import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/models/checkout_request_model.dart';
import 'package:styva_app/models/checkout_summary_model.dart';
import 'package:styva_app/models/order_item_model.dart';
import 'package:styva_app/models/order_model.dart';
import 'package:styva_app/models/shipping_address_model.dart';

import '../fixtures/order_fixtures.dart';

void main() {
  group('OrderItemModel', () {
    test('fromJson parses the snapshot fields and money as doubles', () {
      final item = OrderItemModel.fromJson(orderItemJson);

      expect(item.variantId, 3);
      expect(item.productName, 'Oversized Cotton Shirt');
      expect(item.brand, 'UNIQLO');
      expect(item.unitPrice, 89.90);
      expect(item.quantity, 2);
      expect(item.subtotal, 179.80);
    });
  });

  group('OrderModel', () {
    test('fromJson parses a full order detail', () {
      final order = OrderModel.fromJson(orderDetailJson);

      expect(order.orderNumber, 'STYVA-20260930-7K3Q9M');
      expect(order.status, 'pending');
      expect(order.paymentStatus, 'pending');
      expect(order.subtotal, 179.80);
      expect(order.shippingFee, 0.0);
      expect(order.total, 179.80);
      expect(order.createdAt, DateTime.parse('2026-09-30T10:00:00Z'));
      expect(order.shippingAddress!.city, 'Skudai');
      expect(order.items.single.productName, 'Oversized Cotton Shirt');
    });

    test('fromJson parses a list entry without items or shipping address', () {
      final listEntry = Map<String, dynamic>.from(orderDetailJson)
        ..remove('items')
        ..remove('shipping_address')
        ..remove('updated_at');

      final order = OrderModel.fromJson(listEntry);

      expect(order.items, isEmpty);
      expect(order.shippingAddress, isNull);
      expect(order.itemCount, 2);
    });
  });

  group('CheckoutRequestModel', () {
    test('toJson produces only the shipping address, nested in snake_case', () {
      const request = CheckoutRequestModel(
        shippingAddress: ShippingAddressModel(
          fullName: 'Test Buyer',
          phone: '0123456789',
          addressLine1: '1 Jalan Ujian',
          city: 'Skudai',
          state: 'Johor',
          postcode: '81300',
        ),
      );

      final json = request.toJson();

      expect(json.keys, ['shipping_address']);
      expect(json['shipping_address'], shippingAddressJson);
    });

    test('fromJson round-trips', () {
      final request = CheckoutRequestModel.fromJson({'shipping_address': shippingAddressJson});

      expect(request.shippingAddress.addressLine1, '1 Jalan Ujian');
      expect(request.shippingAddress.addressLine2, '');
    });
  });

  group('CheckoutSummaryModel', () {
    test('fromJson parses server-computed totals', () {
      final summary = CheckoutSummaryModel.fromJson({
        'items': [
          {
            'id': 1,
            'variant': {
              'id': 3,
              'size': 'M',
              'color': 'Black',
              'stock': 5,
              'product': {'id': 1, 'name': 'Shirt', 'price': '89.90', 'brand': 'UNIQLO'},
            },
            'quantity': 2,
            'subtotal': '179.80',
          },
        ],
        'subtotal': '179.80',
        'shipping_fee': '8.00',
        'total': '187.80',
      });

      expect(summary.items, hasLength(1));
      expect(summary.shippingFee, 8.0);
      expect(summary.total, 187.80);
    });
  });
}
