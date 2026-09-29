// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VariantModelImpl _$$VariantModelImplFromJson(Map<String, dynamic> json) =>
    _$VariantModelImpl(
      id: (json['id'] as num).toInt(),
      size: json['size'] as String,
      color: json['color'] as String,
      stock: (json['stock'] as num).toInt(),
      product:
          json['product'] == null
              ? null
              : ProductSummaryModel.fromJson(
                json['product'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$$VariantModelImplToJson(_$VariantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'size': instance.size,
      'color': instance.color,
      'stock': instance.stock,
      'product': instance.product,
    };
