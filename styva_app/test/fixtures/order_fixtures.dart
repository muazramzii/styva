const orderItemJson = {
  'id': 7,
  'variant_id': 3,
  'product_name': 'Oversized Cotton Shirt',
  'brand': 'UNIQLO',
  'size': 'M',
  'color': 'Black',
  'unit_price': '89.90',
  'quantity': 2,
  'subtotal': '179.80',
};

const shippingAddressJson = {
  'full_name': 'Test Buyer',
  'phone': '0123456789',
  'address_line_1': '1 Jalan Ujian',
  'address_line_2': '',
  'city': 'Skudai',
  'state': 'Johor',
  'postcode': '81300',
};

const orderDetailJson = {
  'id': 1,
  'order_number': 'STYVA-20260930-7K3Q9M',
  'status': 'pending',
  'payment_status': 'pending',
  'subtotal': '179.80',
  'shipping_fee': '0.00',
  'total': '179.80',
  'item_count': 2,
  'created_at': '2026-09-30T10:00:00Z',
  'updated_at': '2026-09-30T10:00:00Z',
  'shipping_address': shippingAddressJson,
  'items': [orderItemJson],
};
