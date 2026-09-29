import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/models/payment_model.dart';

import '../fixtures/payment_fixtures.dart';

void main() {
  group('PaymentModel', () {
    test('parses the backend payment payload', () {
      final payment = PaymentModel.fromJson(pendingPaymentJson);

      expect(payment.id, 5);
      expect(payment.reference, 'PAY-7K3Q9MABCD');
      expect(payment.orderId, 1);
      expect(payment.orderNumber, 'STYVA-20260930-7K3Q9M');
      expect(payment.amount, 179.80);
      expect(payment.status, PaymentStatus.pending);
      expect(payment.provider, 'mock');
      expect(payment.providerReference, 'MOCK-0123456789ABCDEF');
      expect(payment.createdAt, DateTime.utc(2026, 9, 30, 10, 5));
    });

    test('provider reference is optional', () {
      final payment = PaymentModel.fromJson({...pendingPaymentJson, 'provider_reference': null});
      expect(payment.providerReference, isNull);
    });

    test('serializes money back to a two-decimal string', () {
      final json = PaymentModel.fromJson(pendingPaymentJson).toJson();

      expect(json['amount'], '179.80');
      expect(json['order_id'], 1);
      expect(json['status'], 'pending');
    });
  });
}
