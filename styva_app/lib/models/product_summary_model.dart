import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_summary_model.freezed.dart';
part 'product_summary_model.g.dart';

double _priceFromJson(dynamic value) => double.parse(value.toString());

String _priceToJson(double value) => value.toStringAsFixed(2);

/// Lightweight product representation nested under a cart item's variant
/// (id, name, price, brand name) -- not the full [ProductModel] shape.
@freezed
class ProductSummaryModel with _$ProductSummaryModel {
  const factory ProductSummaryModel({
    required int id,
    required String name,
    @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson) required double price,
    required String brand,
  }) = _ProductSummaryModel;

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProductSummaryModelFromJson(json);
}
