import 'package:freezed_annotation/freezed_annotation.dart';

import 'cart_item_model.dart';

part 'checkout_summary_model.freezed.dart';
part 'checkout_summary_model.g.dart';

double _moneyFromJson(dynamic value) => double.parse(value.toString());

String _moneyToJson(double value) => value.toStringAsFixed(2);

/// Server-computed preview of what checkout will charge. The app displays
/// these values as-is and never adds up prices itself.
@freezed
class CheckoutSummaryModel with _$CheckoutSummaryModel {
  const factory CheckoutSummaryModel({
    @Default([]) List<CartItemModel> items,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double subtotal,
    @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
    required double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) required double total,
  }) = _CheckoutSummaryModel;

  factory CheckoutSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutSummaryModelFromJson(json);
}
