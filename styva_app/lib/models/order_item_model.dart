import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_item_model.freezed.dart';
part 'order_item_model.g.dart';

double _moneyFromJson(dynamic value) => double.parse(value.toString());

String _moneyToJson(double value) => value.toStringAsFixed(2);

/// A line on a placed order. All fields are the snapshot taken at checkout,
/// so they don't change when the live product is edited or repriced.
@freezed
class OrderItemModel with _$OrderItemModel {
  const factory OrderItemModel({
    required int id,
    @JsonKey(name: 'variant_id') required int variantId,
    @JsonKey(name: 'product_name') required String productName,
    required String brand,
    required String size,
    required String color,
    @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
    required double unitPrice,
    required int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double subtotal,
  }) = _OrderItemModel;

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);
}
