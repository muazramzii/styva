// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: (json['id'] as num).toInt(),
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: _priceFromJson(json['price']),
      image: json['image'] as String?,
      brand: BrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      category: CategoryModel.fromJson(
        json['category'] as Map<String, dynamic>,
      ),
      variants:
          (json['variants'] as List<dynamic>?)
              ?.map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'description': instance.description,
      'price': _priceToJson(instance.price),
      'image': instance.image,
      'brand': instance.brand,
      'category': instance.category,
      'variants': instance.variants,
    };
