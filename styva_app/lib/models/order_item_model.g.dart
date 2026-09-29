// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderItemModelImpl _$$OrderItemModelImplFromJson(Map<String, dynamic> json) =>
    _$OrderItemModelImpl(
      id: (json['id'] as num).toInt(),
      variantId: (json['variant_id'] as num).toInt(),
      productName: json['product_name'] as String,
      brand: json['brand'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      unitPrice: _moneyFromJson(json['unit_price']),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: _moneyFromJson(json['subtotal']),
    );

Map<String, dynamic> _$$OrderItemModelImplToJson(
  _$OrderItemModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'variant_id': instance.variantId,
  'product_name': instance.productName,
  'brand': instance.brand,
  'size': instance.size,
  'color': instance.color,
  'unit_price': _moneyToJson(instance.unitPrice),
  'quantity': instance.quantity,
  'subtotal': _moneyToJson(instance.subtotal),
};
