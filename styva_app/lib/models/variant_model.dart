import 'package:freezed_annotation/freezed_annotation.dart';

part 'variant_model.freezed.dart';
part 'variant_model.g.dart';

@freezed
class VariantModel with _$VariantModel {
  const factory VariantModel({
    required int id,
    required String size,
    required String color,
    required int stock,
  }) = _VariantModel;

  factory VariantModel.fromJson(Map<String, dynamic> json) =>
      _$VariantModelFromJson(json);
}
