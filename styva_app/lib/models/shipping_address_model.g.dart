// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shipping_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShippingAddressModelImpl _$$ShippingAddressModelImplFromJson(
  Map<String, dynamic> json,
) => _$ShippingAddressModelImpl(
  fullName: json['full_name'] as String,
  phone: json['phone'] as String,
  addressLine1: json['address_line_1'] as String,
  addressLine2: json['address_line_2'] as String? ?? '',
  city: json['city'] as String,
  state: json['state'] as String,
  postcode: json['postcode'] as String,
);

Map<String, dynamic> _$$ShippingAddressModelImplToJson(
  _$ShippingAddressModelImpl instance,
) => <String, dynamic>{
  'full_name': instance.fullName,
  'phone': instance.phone,
  'address_line_1': instance.addressLine1,
  'address_line_2': instance.addressLine2,
  'city': instance.city,
  'state': instance.state,
  'postcode': instance.postcode,
};
