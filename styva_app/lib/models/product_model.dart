import 'package:freezed_annotation/freezed_annotation.dart';

import 'brand_model.dart';
import 'category_model.dart';
import 'variant_model.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

double _priceFromJson(dynamic value) => double.parse(value.toString());

String _priceToJson(double value) => value.toStringAsFixed(2);

@freezed
class ProductModel with _$ProductModel {
  const factory ProductModel({
    required int id,
    required String sku,
    required String name,
    String? description,
    @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson) required double price,
    String? image,
    required BrandModel brand,
    required CategoryModel category,
    @Default([]) List<VariantModel> variants,
  }) = _ProductModel;

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
