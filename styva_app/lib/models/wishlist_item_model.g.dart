// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemModelImpl _$$WishlistItemModelImplFromJson(
  Map<String, dynamic> json,
) => _$WishlistItemModelImpl(
  id: (json['id'] as num).toInt(),
  product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$WishlistItemModelImplToJson(
  _$WishlistItemModelImpl instance,
) => <String, dynamic>{'id': instance.id, 'product': instance.product};
