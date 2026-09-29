const pendingPaymentJson = {
  'id': 5,
  'reference': 'PAY-7K3Q9MABCD',
  'order_id': 1,
  'order_number': 'STYVA-20260930-7K3Q9M',
  'amount': '179.80',
  'status': 'pending',
  'provider': 'mock',
  'provider_reference': 'MOCK-0123456789ABCDEF',
  'created_at': '2026-09-30T10:05:00Z',
  'updated_at': '2026-09-30T10:05:00Z',
};

Map<String, dynamic> paymentJsonWith({String status = 'pending', int id = 5}) =>
    {...pendingPaymentJson, 'status': status, 'id': id};
