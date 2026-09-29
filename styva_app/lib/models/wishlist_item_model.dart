import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_model.dart';

part 'wishlist_item_model.freezed.dart';
part 'wishlist_item_model.g.dart';

@freezed
class WishlistItemModel with _$WishlistItemModel {
  const factory WishlistItemModel({
    required int id,
    required ProductModel product,
  }) = _WishlistItemModel;

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemModelFromJson(json);
}
