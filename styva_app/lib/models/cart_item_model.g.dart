// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemModelImpl _$$CartItemModelImplFromJson(Map<String, dynamic> json) =>
    _$CartItemModelImpl(
      id: (json['id'] as num).toInt(),
      variant: VariantModel.fromJson(json['variant'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: _moneyFromJson(json['subtotal']),
    );

Map<String, dynamic> _$$CartItemModelImplToJson(_$CartItemModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'variant': instance.variant,
      'quantity': instance.quantity,
      'subtotal': _moneyToJson(instance.subtotal),
    };
