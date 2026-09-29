import 'package:freezed_annotation/freezed_annotation.dart';

import 'order_item_model.dart';
import 'shipping_address_model.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

double _moneyFromJson(dynamic value) => double.parse(value.toString());

String _moneyToJson(double value) => value.toStringAsFixed(2);

/// Used for both the order list (no items/address) and order detail.
@freezed
class OrderModel with _$OrderModel {
  @JsonSerializable(explicitToJson: true)
  const factory OrderModel({
    required int id,
    @JsonKey(name: 'order_number') required String orderNumber,
    required String status,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double subtotal,
    @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
    required double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double total,
    @JsonKey(name: 'item_count') @Default(0) int itemCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'shipping_address') ShippingAddressModel? shippingAddress,
    @Default([]) List<OrderItemModel> items,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
}
