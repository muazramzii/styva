import 'package:flutter_test/flutter_test.dart';
import 'package:styva_app/models/brand_model.dart';
import 'package:styva_app/models/category_model.dart';
import 'package:styva_app/models/product_model.dart';
import 'package:styva_app/models/variant_model.dart';

void main() {
  group('BrandModel', () {
    test('fromJson parses a brand', () {
      final brand = BrandModel.fromJson({'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'});

      expect(brand.id, 1);
      expect(brand.name, 'UNIQLO');
      expect(brand.slug, 'uniqlo');
    });
  });

  group('CategoryModel', () {
    test('fromJson parses a category', () {
      final category = CategoryModel.fromJson({'id': 2, 'name': 'Tops', 'slug': 'tops'});

      expect(category.id, 2);
      expect(category.name, 'Tops');
      expect(category.slug, 'tops');
    });
  });

  group('VariantModel', () {
    test('fromJson parses a variant', () {
      final variant = VariantModel.fromJson({'id': 5, 'size': 'M', 'color': 'Black', 'stock': 12});

      expect(variant.id, 5);
      expect(variant.size, 'M');
      expect(variant.color, 'Black');
      expect(variant.stock, 12);
    });
  });

  group('ProductModel', () {
    final json = {
      'id': 10,
      'sku': 'UNQ001',
      'name': 'Basic Tee',
      'description': 'A basic tee.',
      'price': '29.90',
      'image': 'http://localhost:8000/media/UNQ001.png',
      'brand': {'id': 1, 'name': 'UNIQLO', 'slug': 'uniqlo'},
      'category': {'id': 2, 'name': 'Tops', 'slug': 'tops'},
      'variants': [
        {'id': 1, 'size': 'M', 'color': 'White', 'stock': 10},
      ],
    };

    test('fromJson parses a full product with nested brand, category, and variants', () {
      final product = ProductModel.fromJson(json);

      expect(product.id, 10);
      expect(product.sku, 'UNQ001');
      expect(product.name, 'Basic Tee');
      expect(product.price, 29.90);
      expect(product.brand.name, 'UNIQLO');
      expect(product.category.name, 'Tops');
      expect(product.variants, hasLength(1));
      expect(product.variants.first.size, 'M');
    });

    test('fromJson defaults variants to an empty list when absent', () {
      final withoutVariants = Map<String, dynamic>.from(json)..remove('variants');
      final product = ProductModel.fromJson(withoutVariants);

      expect(product.variants, isEmpty);
    });

    test('price parses correctly whether the API sends a string or a number', () {
      final stringPrice = ProductModel.fromJson({...json, 'price': '99.00'});
      final numericPrice = ProductModel.fromJson({...json, 'price': 99.0});

      expect(stringPrice.price, 99.0);
      expect(numericPrice.price, 99.0);
    });
  });
}
