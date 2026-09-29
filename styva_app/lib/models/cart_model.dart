import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

double _totalFromJson(dynamic value) => double.parse(value.toString());

String _totalToJson(double value) => value.toStringAsFixed(2);

@freezed
class CartModel with _$CartModel {
  const factory CartModel({
    required int id,
    @Default([]) List<CartItemModel> items,
    @JsonKey(fromJson: _totalFromJson, toJson: _totalToJson) required double total,
  }) = _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) => _$CartModelFromJson(json);
}
