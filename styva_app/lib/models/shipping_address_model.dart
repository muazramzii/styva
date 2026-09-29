import 'package:freezed_annotation/freezed_annotation.dart';

part 'shipping_address_model.freezed.dart';
part 'shipping_address_model.g.dart';

@freezed
class ShippingAddressModel with _$ShippingAddressModel {
  const factory ShippingAddressModel({
    @JsonKey(name: 'full_name') required String fullName,
    required String phone,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') @Default('') String addressLine2,
    required String city,
    required String state,
    required String postcode,
  }) = _ShippingAddressModel;

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      _$ShippingAddressModelFromJson(json);
}
