// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shipping_address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ShippingAddressModel _$ShippingAddressModelFromJson(Map<String, dynamic> json) {
  return _ShippingAddressModel.fromJson(json);
}

/// @nodoc
mixin _$ShippingAddressModel {
  @JsonKey(name: 'full_name')
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_1')
  String get addressLine1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_2')
  String get addressLine2 => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get postcode => throw _privateConstructorUsedError;

  /// Serializes this ShippingAddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShippingAddressModelCopyWith<ShippingAddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShippingAddressModelCopyWith<$Res> {
  factory $ShippingAddressModelCopyWith(
    ShippingAddressModel value,
    $Res Function(ShippingAddressModel) then,
  ) = _$ShippingAddressModelCopyWithImpl<$Res, ShippingAddressModel>;
  @useResult
  $Res call({
    @JsonKey(name: 'full_name') String fullName,
    String phone,
    @JsonKey(name: 'address_line_1') String addressLine1,
    @JsonKey(name: 'address_line_2') String addressLine2,
    String city,
    String state,
    String postcode,
  });
}

/// @nodoc
class _$ShippingAddressModelCopyWithImpl<
  $Res,
  $Val extends ShippingAddressModel
>
    implements $ShippingAddressModelCopyWith<$Res> {
  _$ShippingAddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? phone = null,
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
  }) {
    return _then(
      _value.copyWith(
            fullName:
                null == fullName
                    ? _value.fullName
                    : fullName // ignore: cast_nullable_to_non_nullable
                        as String,
            phone:
                null == phone
                    ? _value.phone
                    : phone // ignore: cast_nullable_to_non_nullable
                        as String,
            addressLine1:
                null == addressLine1
                    ? _value.addressLine1
                    : addressLine1 // ignore: cast_nullable_to_non_nullable
                        as String,
            addressLine2:
                null == addressLine2
                    ? _value.addressLine2
                    : addressLine2 // ignore: cast_nullable_to_non_nullable
                        as String,
            city:
                null == city
                    ? _value.city
                    : city // ignore: cast_nullable_to_non_nullable
                        as String,
            state:
                null == state
                    ? _value.state
                    : state // ignore: cast_nullable_to_non_nullable
                        as String,
            postcode:
                null == postcode
                    ? _value.postcode
                    : postcode // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShippingAddressModelImplCopyWith<$Res>
    implements $ShippingAddressModelCopyWith<$Res> {
  factory _$$ShippingAddressModelImplCopyWith(
    _$ShippingAddressModelImpl value,
    $Res Function(_$ShippingAddressModelImpl) then,
  ) = __$$ShippingAddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'full_name') String fullName,
    String phone,
    @JsonKey(name: 'address_line_1') String addressLine1,
    @JsonKey(name: 'address_line_2') String addressLine2,
    String city,
    String state,
    String postcode,
  });
}

/// @nodoc
class __$$ShippingAddressModelImplCopyWithImpl<$Res>
    extends _$ShippingAddressModelCopyWithImpl<$Res, _$ShippingAddressModelImpl>
    implements _$$ShippingAddressModelImplCopyWith<$Res> {
  __$$ShippingAddressModelImplCopyWithImpl(
    _$ShippingAddressModelImpl _value,
    $Res Function(_$ShippingAddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? phone = null,
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
  }) {
    return _then(
      _$ShippingAddressModelImpl(
        fullName:
            null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                    as String,
        phone:
            null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                    as String,
        addressLine1:
            null == addressLine1
                ? _value.addressLine1
                : addressLine1 // ignore: cast_nullable_to_non_nullable
                    as String,
        addressLine2:
            null == addressLine2
                ? _value.addressLine2
                : addressLine2 // ignore: cast_nullable_to_non_nullable
                    as String,
        city:
            null == city
                ? _value.city
                : city // ignore: cast_nullable_to_non_nullable
                    as String,
        state:
            null == state
                ? _value.state
                : state // ignore: cast_nullable_to_non_nullable
                    as String,
        postcode:
            null == postcode
                ? _value.postcode
                : postcode // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShippingAddressModelImpl implements _ShippingAddressModel {
  const _$ShippingAddressModelImpl({
    @JsonKey(name: 'full_name') required this.fullName,
    required this.phone,
    @JsonKey(name: 'address_line_1') required this.addressLine1,
    @JsonKey(name: 'address_line_2') this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postcode,
  });

  factory _$ShippingAddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShippingAddressModelImplFromJson(json);

  @override
  @JsonKey(name: 'full_name')
  final String fullName;
  @override
  final String phone;
  @override
  @JsonKey(name: 'address_line_1')
  final String addressLine1;
  @override
  @JsonKey(name: 'address_line_2')
  final String addressLine2;
  @override
  final String city;
  @override
  final String state;
  @override
  final String postcode;

  @override
  String toString() {
    return 'ShippingAddressModel(fullName: $fullName, phone: $phone, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postcode: $postcode)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShippingAddressModelImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postcode,
  );

  /// Create a copy of ShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShippingAddressModelImplCopyWith<_$ShippingAddressModelImpl>
  get copyWith =>
      __$$ShippingAddressModelImplCopyWithImpl<_$ShippingAddressModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ShippingAddressModelImplToJson(this);
  }
}

abstract class _ShippingAddressModel implements ShippingAddressModel {
  const factory _ShippingAddressModel({
    @JsonKey(name: 'full_name') required final String fullName,
    required final String phone,
    @JsonKey(name: 'address_line_1') required final String addressLine1,
    @JsonKey(name: 'address_line_2') final String addressLine2,
    required final String city,
    required final String state,
    required final String postcode,
  }) = _$ShippingAddressModelImpl;

  factory _ShippingAddressModel.fromJson(Map<String, dynamic> json) =
      _$ShippingAddressModelImpl.fromJson;

  @override
  @JsonKey(name: 'full_name')
  String get fullName;
  @override
  String get phone;
  @override
  @JsonKey(name: 'address_line_1')
  String get addressLine1;
  @override
  @JsonKey(name: 'address_line_2')
  String get addressLine2;
  @override
  String get city;
  @override
  String get state;
  @override
  String get postcode;

  /// Create a copy of ShippingAddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShippingAddressModelImplCopyWith<_$ShippingAddressModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
