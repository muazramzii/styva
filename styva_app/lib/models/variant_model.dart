import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_summary_model.dart';

part 'variant_model.freezed.dart';
part 'variant_model.g.dart';

@freezed
class VariantModel with _$VariantModel {
  const factory VariantModel({
    required int id,
    required String size,
    required String color,
    required int stock,
    // Only present when a variant is nested under a cart item; absent (and
    // therefore null) when nested under a product's own variants list.
    ProductSummaryModel? product,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);
}
