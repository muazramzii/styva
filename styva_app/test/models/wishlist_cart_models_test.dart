import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/models/cart_item_model.dart';
import 'package:styva_app/models/cart_model.dart';
import 'package:styva_app/models/variant_model.dart';
import 'package:styva_app/models/wishlist_item_model.dart';

const _productJson = {
  'id': 10,
  'sku': 'UNQ001',
  'name': 'Basic Tee',
  'description': 'A basic tee.',
  'price': '29.90',
  'image': null,
  'brand': {'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'},
  'category': {'id': 2, 'name': 'Tops', 'slug': 'tops'},
  'variants': [],
};

void main() {
  group('WishlistItemModel', () {
    test('fromJson parses id and nested product', () {
      final item = WishlistItemModel.fromJson({
        'id': 1,
        'product': _productJson,
        'created_at': '2026-01-01T00:00:00Z',
      });

      expect(item.id, 1);
      expect(item.product.name, 'Basic Tee');
    });
  });

  group('VariantModel with nested product (cart context)', () {
    test('fromJson parses the nested product summary', () {
      final variant = VariantModel.fromJson({
        'id': 3,
        'size': 'M',
        'color': 'Black',
        'stock': 10,
        'product': {
          'id': 1,
          'name': 'Oversized Cotton Shirt',
          'price': '89.90',
          'brand': 'UNIQLO',
        },
      });

      expect(variant.product, isNotNull);
      expect(variant.product!.name, 'Oversized Cotton Shirt');
      expect(variant.product!.price, 89.90);
      expect(variant.product!.brand, 'UNIQLO');
    });

    test('fromJson leaves product null when absent (product-detail context)', () {
      final variant = VariantModel.fromJson({
        'id': 3,
        'size': 'M',
        'color': 'Black',
        'stock': 10,
      });

      expect(variant.product, isNull);
    });
  });

  group('CartItemModel', () {
    test('fromJson parses quantity and subtotal as a double', () {
      final item = CartItemModel.fromJson({
        'id': 1,
        'variant': {
          'id': 3,
          'size': 'M',
          'color': 'Black',
          'stock': 10,
          'product': {'id': 1, 'name': 'Shirt', 'price': '89.90', 'brand': 'UNIQLO'},
        },
        'quantity': 2,
        'subtotal': '179.80',
      });

      expect(item.quantity, 2);
      expect(item.subtotal, 179.80);
      expect(item.variant.product!.name, 'Shirt');
    });
  });

  group('CartModel', () {
    test('fromJson parses items and total', () {
      final cart = CartModel.fromJson({
        'id': 1,
        'items': [
          {
            'id': 1,
            'variant': {
              'id': 3,
              'size': 'M',
              'color': 'Black',
              'stock': 10,
              'product': {'id': 1, 'name': 'Shirt', 'price': '89.90', 'brand': 'UNIQLO'},
            },
            'quantity': 2,
            'subtotal': '179.80',
          },
        ],
        'total': '179.80',
      });

      expect(cart.items, hasLength(1));
      expect(cart.total, 179.80);
    });

    test('fromJson defaults items to an empty list when absent', () {
      final cart = CartModel.fromJson({'id': 1, 'total': '0.00'});

      expect(cart.items, isEmpty);
      expect(cart.total, 0.0);
    });
  });
}
