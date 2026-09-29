import 'package:freezed_annotation/freezed_annotation.dart';

import 'variant_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

double _moneyFromJson(dynamic value) => double.parse(value.toString());

String _moneyToJson(double value) => value.toStringAsFixed(2);

@freezed
class CartItemModel with _$CartItemModel {
  const factory CartItemModel({
    required int id,
    required VariantModel variant,
    required int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double subtotal,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);
}
