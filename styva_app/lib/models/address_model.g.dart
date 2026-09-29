// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AddressModelImpl _$$AddressModelImplFromJson(Map<String, dynamic> json) =>
    _$AddressModelImpl(
      id: (json['id'] as num).toInt(),
      recipientName: json['recipient_name'] as String,
      phone: json['phone'] as String,
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String? ?? '',
      city: json['city'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
      country: json['country'] as String? ?? 'Malaysia',
      isDefault: json['is_default'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AddressModelImplToJson(_$AddressModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'address_line_1': instance.addressLine1,
      'address_line_2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
      'country': instance.country,
      'is_default': instance.isDefault,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$AddressInputImpl _$$AddressInputImplFromJson(Map<String, dynamic> json) =>
    _$AddressInputImpl(
      recipientName: json['recipient_name'] as String,
      phone: json['phone'] as String,
      addressLine1: json['address_line_1'] as String,
      addressLine2: json['address_line_2'] as String? ?? '',
      city: json['city'] as String,
      state: json['state'] as String,
      postcode: json['postcode'] as String,
      country: json['country'] as String? ?? 'Malaysia',
      isDefault: json['is_default'] as bool? ?? false,
    );

Map<String, dynamic> _$$AddressInputImplToJson(_$AddressInputImpl instance) =>
    <String, dynamic>{
      'recipient_name': instance.recipientName,
      'phone': instance.phone,
      'address_line_1': instance.addressLine1,
      'address_line_2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'postcode': instance.postcode,
      'country': instance.country,
      'is_default': instance.isDefault,
    };
