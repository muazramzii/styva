// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CheckoutRequestModelImpl _$$CheckoutRequestModelImplFromJson(
  Map<String, dynamic> json,
) => _$CheckoutRequestModelImpl(
  shippingAddress: ShippingAddressModel.fromJson(
    json['shipping_address'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$$CheckoutRequestModelImplToJson(
  _$CheckoutRequestModelImpl instance,
) => <String, dynamic>{'shipping_address': instance.shippingAddress.toJson()};
