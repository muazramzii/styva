import 'package:freezed_annotation/freezed_annotation.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

/// A saved shipping address, as returned by the backend.
@freezed
class AddressModel with _$AddressModel {
  const factory AddressModel({
    required int id,
    @JsonKey(name: 'recipient_name') required String recipientName,
    required String phone,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') @Default('') String addressLine2,
    required String city,
    required String state,
    required String postcode,
    @Default('Malaysia') String country,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);
}

/// The fields a user can write when creating or editing an address. The
/// owner, id and timestamps are always set by the backend.
@freezed
class AddressInput with _$AddressInput {
  const factory AddressInput({
    @JsonKey(name: 'recipient_name') required String recipientName,
    required String phone,
    @JsonKey(name: 'address_line_1') required String addressLine1,
    @JsonKey(name: 'address_line_2') @Default('') String addressLine2,
    required String city,
    required String state,
    required String postcode,
    @Default('Malaysia') String country,
    @JsonKey(name: 'is_default') @Default(false) bool isDefault,
  }) = _AddressInput;

  factory AddressInput.fromJson(Map<String, dynamic> json) => _$AddressInputFromJson(json);
}
