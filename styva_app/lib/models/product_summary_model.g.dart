// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductSummaryModelImpl _$$ProductSummaryModelImplFromJson(
  Map<String, dynamic> json,
) => _$ProductSummaryModelImpl(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  price: _priceFromJson(json['price']),
  brand: json['brand'] as String,
);

Map<String, dynamic> _$$ProductSummaryModelImplToJson(
  _$ProductSummaryModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': _priceToJson(instance.price),
  'brand': instance.brand,
};
