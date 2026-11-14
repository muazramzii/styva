import 'package:freezed_annotation/freezed_annotation.dart';

part 'checkout_request_model.freezed.dart';
part 'checkout_request_model.g.dart';

/// Everything the client is allowed to send at checkout: which of the user's
/// saved addresses to ship to. Prices, totals and the shipping fee are
/// deliberately absent -- the backend calculates them, checks the address
/// belongs to the user, and copies it into the order.
@freezed
class CheckoutRequestModel with _$CheckoutRequestModel {
  const factory CheckoutRequestModel({
    @JsonKey(name: 'address_id') required int addressId,
  }) = _CheckoutRequestModel;

  factory CheckoutRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CheckoutRequestModelFromJson(json);
}
