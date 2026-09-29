// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutRequestModel _$CheckoutRequestModelFromJson(Map<String, dynamic> json) {
  return _CheckoutRequestModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutRequestModel {
  @JsonKey(name: 'address_id')
  int get addressId => throw _privateConstructorUsedError;

  /// Serializes this CheckoutRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutRequestModelCopyWith<CheckoutRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutRequestModelCopyWith<$Res> {
  factory $CheckoutRequestModelCopyWith(
    CheckoutRequestModel value,
    $Res Function(CheckoutRequestModel) then,
  ) = _$CheckoutRequestModelCopyWithImpl<$Res, CheckoutRequestModel>;
  @useResult
  $Res call({@JsonKey(name: 'address_id') int addressId});
}

/// @nodoc
class _$CheckoutRequestModelCopyWithImpl<
  $Res,
  $Val extends CheckoutRequestModel
>
    implements $CheckoutRequestModelCopyWith<$Res> {
  _$CheckoutRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? addressId = null}) {
    return _then(
      _value.copyWith(
            addressId:
                null == addressId
                    ? _value.addressId
                    : addressId // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckoutRequestModelImplCopyWith<$Res>
    implements $CheckoutRequestModelCopyWith<$Res> {
  factory _$$CheckoutRequestModelImplCopyWith(
    _$CheckoutRequestModelImpl value,
    $Res Function(_$CheckoutRequestModelImpl) then,
  ) = __$$CheckoutRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'address_id') int addressId});
}

/// @nodoc
class __$$CheckoutRequestModelImplCopyWithImpl<$Res>
    extends _$CheckoutRequestModelCopyWithImpl<$Res, _$CheckoutRequestModelImpl>
    implements _$$CheckoutRequestModelImplCopyWith<$Res> {
  __$$CheckoutRequestModelImplCopyWithImpl(
    _$CheckoutRequestModelImpl _value,
    $Res Function(_$CheckoutRequestModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? addressId = null}) {
    return _then(
      _$CheckoutRequestModelImpl(
        addressId:
            null == addressId
                ? _value.addressId
                : addressId // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutRequestModelImpl implements _CheckoutRequestModel {
  const _$CheckoutRequestModelImpl({
    @JsonKey(name: 'address_id') required this.addressId,
  });

  factory _$CheckoutRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutRequestModelImplFromJson(json);

  @override
  @JsonKey(name: 'address_id')
  final int addressId;

  @override
  String toString() {
    return 'CheckoutRequestModel(addressId: $addressId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutRequestModelImpl &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, addressId);

  /// Create a copy of CheckoutRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutRequestModelImplCopyWith<_$CheckoutRequestModelImpl>
  get copyWith =>
      __$$CheckoutRequestModelImplCopyWithImpl<_$CheckoutRequestModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutRequestModelImplToJson(this);
  }
}

abstract class _CheckoutRequestModel implements CheckoutRequestModel {
  const factory _CheckoutRequestModel({
    @JsonKey(name: 'address_id') required final int addressId,
  }) = _$CheckoutRequestModelImpl;

  factory _CheckoutRequestModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutRequestModelImpl.fromJson;

  @override
  @JsonKey(name: 'address_id')
  int get addressId;

  /// Create a copy of CheckoutRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutRequestModelImplCopyWith<_$CheckoutRequestModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
