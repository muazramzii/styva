import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:styva_app/services/payment_service.dart';

import '../fixtures/payment_fixtures.dart';

class MockDio extends Mock implements Dio {}

Response<T> _response<T>(T data, {int statusCode = 200}) {
  return Response<T>(data: data, requestOptions: RequestOptions(path: ''), statusCode: statusCode);
}

void main() {
  late MockDio dio;

  setUp(() => dio = MockDio());

  test('initiatePayment sends only the order id', () async {
    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => _response(pendingPaymentJson, statusCode: 201));

    final payment = await PaymentService(dio).initiatePayment(1);

    final captured = verify(() => dio.post('/payments/initiate', data: captureAny(named: 'data')))
        .captured
        .single;
    expect(captured, {'order_id': 1});
    expect(payment.id, 5);
    expect(payment.amount, 179.80);
  });

  test('getPayment fetches the payment by id', () async {
    when(() => dio.get(any())).thenAnswer((_) async => _response(pendingPaymentJson));

    final payment = await PaymentService(dio).getPayment(5);

    verify(() => dio.get('/payments/5')).called(1);
    expect(payment.reference, 'PAY-7K3Q9MABCD');
  });

  test('simulateMockPayment posts the outcome to the mock endpoint', () async {
    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => _response(paymentJsonWith(status: 'success')));

    final payment = await PaymentService(dio).simulateMockPayment(5, 'success');

    final captured =
        verify(() => dio.post('/payments/5/mock-complete', data: captureAny(named: 'data')))
            .captured
            .single;
    expect(captured, {'outcome': 'success'});
    expect(payment.status, 'success');
  });

  test('errors propagate to the caller', () async {
    final options = RequestOptions(path: '');
    when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(DioException(
      requestOptions: options,
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: options,
        statusCode: 409,
        data: {'detail': 'This order has already been paid.'},
      ),
    ));

    expect(() => PaymentService(dio).initiatePayment(1), throwsA(isA<DioException>()));
  });
}
