import 'package:freezed_annotation/freezed_annotation.dart';

import 'shipping_address_model.dart';

part 'checkout_request_model.freezed.dart';
part 'checkout_request_model.g.dart';

/// Everything the client is allowed to send at checkout. Prices, totals and
/// the shipping fee are deliberately absent -- the backend calculates them.
@freezed
class CheckoutRequestModel with _$CheckoutRequestModel {
  @JsonSerializable(explicitToJson: true)
  const factory CheckoutRequestModel({
    @JsonKey(name: 'shipping_address') required ShippingAddressModel shippingAddress,
  }) = _CheckoutRequestModel;

  factory CheckoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestModelFromJson(json);
}
