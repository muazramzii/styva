// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return _AddressModel.fromJson(json);
}

/// @nodoc
mixin _$AddressModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'recipient_name')
  String get recipientName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_1')
  String get addressLine1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_2')
  String get addressLine2 => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get postcode => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AddressModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
    AddressModel value,
    $Res Function(AddressModel) then,
  ) = _$AddressModelCopyWithImpl<$Res, AddressModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'recipient_name') String recipientName,
    String phone,
    @JsonKey(name: 'address_line_1') String addressLine1,
    @JsonKey(name: 'address_line_2') String addressLine2,
    String city,
    String state,
    String postcode,
    String country,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipientName = null,
    Object? phone = null,
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
    Object? country = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            recipientName:
                null == recipientName
                    ? _value.recipientName
                    : recipientName // ignore: cast_nullable_to_non_nullable
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
            country:
                null == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            updatedAt:
                null == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
    _$AddressModelImpl value,
    $Res Function(_$AddressModelImpl) then,
  ) = __$$AddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'recipient_name') String recipientName,
    String phone,
    @JsonKey(name: 'address_line_1') String addressLine1,
    @JsonKey(name: 'address_line_2') String addressLine2,
    String city,
    String state,
    String postcode,
    String country,
    @JsonKey(name: 'is_default') bool isDefault,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
    _$AddressModelImpl _value,
    $Res Function(_$AddressModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? recipientName = null,
    Object? phone = null,
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
    Object? country = null,
    Object? isDefault = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$AddressModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        recipientName:
            null == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
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
        country:
            null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        updatedAt:
            null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressModelImpl implements _AddressModel {
  const _$AddressModelImpl({
    required this.id,
    @JsonKey(name: 'recipient_name') required this.recipientName,
    required this.phone,
    @JsonKey(name: 'address_line_1') required this.addressLine1,
    @JsonKey(name: 'address_line_2') this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postcode,
    this.country = 'Malaysia',
    @JsonKey(name: 'is_default') this.isDefault = false,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$AddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'recipient_name')
  final String recipientName;
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
  @JsonKey()
  final String country;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AddressModel(id: $id, recipientName: $recipientName, phone: $phone, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postcode: $postcode, country: $country, isDefault: $isDefault, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    recipientName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postcode,
    country,
    isDefault,
    createdAt,
    updatedAt,
  );

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressModelImplToJson(this);
  }
}

abstract class _AddressModel implements AddressModel {
  const factory _AddressModel({
    required final int id,
    @JsonKey(name: 'recipient_name') required final String recipientName,
    required final String phone,
    @JsonKey(name: 'address_line_1') required final String addressLine1,
    @JsonKey(name: 'address_line_2') final String addressLine2,
    required final String city,
    required final String state,
    required final String postcode,
    final String country,
    @JsonKey(name: 'is_default') final bool isDefault,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$AddressModelImpl;

  factory _AddressModel.fromJson(Map<String, dynamic> json) =
      _$AddressModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'recipient_name')
  String get recipientName;
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
  @override
  String get country;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AddressInput _$AddressInputFromJson(Map<String, dynamic> json) {
  return _AddressInput.fromJson(json);
}

/// @nodoc
mixin _$AddressInput {
  @JsonKey(name: 'recipient_name')
  String get recipientName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_1')
  String get addressLine1 => throw _privateConstructorUsedError;
  @JsonKey(name: 'address_line_2')
  String get addressLine2 => throw _privateConstructorUsedError;
  String get city => throw _privateConstructorUsedError;
  String get state => throw _privateConstructorUsedError;
  String get postcode => throw _privateConstructorUsedError;
  String get country => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;

  /// Serializes this AddressInput to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AddressInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressInputCopyWith<AddressInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressInputCopyWith<$Res> {
  factory $AddressInputCopyWith(
    AddressInput value,
    $Res Function(AddressInput) then,
  ) = _$AddressInputCopyWithImpl<$Res, AddressInput>;
  @useResult
  $Res call({
    @JsonKey(name: 'recipient_name') String recipientName,
    String phone,
    @JsonKey(name: 'address_line_1') String addressLine1,
    @JsonKey(name: 'address_line_2') String addressLine2,
    String city,
    String state,
    String postcode,
    String country,
    @JsonKey(name: 'is_default') bool isDefault,
  });
}

/// @nodoc
class _$AddressInputCopyWithImpl<$Res, $Val extends AddressInput>
    implements $AddressInputCopyWith<$Res> {
  _$AddressInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientName = null,
    Object? phone = null,
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
    Object? country = null,
    Object? isDefault = null,
  }) {
    return _then(
      _value.copyWith(
            recipientName:
                null == recipientName
                    ? _value.recipientName
                    : recipientName // ignore: cast_nullable_to_non_nullable
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
            country:
                null == country
                    ? _value.country
                    : country // ignore: cast_nullable_to_non_nullable
                        as String,
            isDefault:
                null == isDefault
                    ? _value.isDefault
                    : isDefault // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AddressInputImplCopyWith<$Res>
    implements $AddressInputCopyWith<$Res> {
  factory _$$AddressInputImplCopyWith(
    _$AddressInputImpl value,
    $Res Function(_$AddressInputImpl) then,
  ) = __$$AddressInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'recipient_name') String recipientName,
    String phone,
    @JsonKey(name: 'address_line_1') String addressLine1,
    @JsonKey(name: 'address_line_2') String addressLine2,
    String city,
    String state,
    String postcode,
    String country,
    @JsonKey(name: 'is_default') bool isDefault,
  });
}

/// @nodoc
class __$$AddressInputImplCopyWithImpl<$Res>
    extends _$AddressInputCopyWithImpl<$Res, _$AddressInputImpl>
    implements _$$AddressInputImplCopyWith<$Res> {
  __$$AddressInputImplCopyWithImpl(
    _$AddressInputImpl _value,
    $Res Function(_$AddressInputImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AddressInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? recipientName = null,
    Object? phone = null,
    Object? addressLine1 = null,
    Object? addressLine2 = null,
    Object? city = null,
    Object? state = null,
    Object? postcode = null,
    Object? country = null,
    Object? isDefault = null,
  }) {
    return _then(
      _$AddressInputImpl(
        recipientName:
            null == recipientName
                ? _value.recipientName
                : recipientName // ignore: cast_nullable_to_non_nullable
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
        country:
            null == country
                ? _value.country
                : country // ignore: cast_nullable_to_non_nullable
                    as String,
        isDefault:
            null == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressInputImpl implements _AddressInput {
  const _$AddressInputImpl({
    @JsonKey(name: 'recipient_name') required this.recipientName,
    required this.phone,
    @JsonKey(name: 'address_line_1') required this.addressLine1,
    @JsonKey(name: 'address_line_2') this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postcode,
    this.country = 'Malaysia',
    @JsonKey(name: 'is_default') this.isDefault = false,
  });

  factory _$AddressInputImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressInputImplFromJson(json);

  @override
  @JsonKey(name: 'recipient_name')
  final String recipientName;
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
  @JsonKey()
  final String country;
  @override
  @JsonKey(name: 'is_default')
  final bool isDefault;

  @override
  String toString() {
    return 'AddressInput(recipientName: $recipientName, phone: $phone, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, state: $state, postcode: $postcode, country: $country, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressInputImpl &&
            (identical(other.recipientName, recipientName) ||
                other.recipientName == recipientName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.addressLine1, addressLine1) ||
                other.addressLine1 == addressLine1) &&
            (identical(other.addressLine2, addressLine2) ||
                other.addressLine2 == addressLine2) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postcode, postcode) ||
                other.postcode == postcode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    recipientName,
    phone,
    addressLine1,
    addressLine2,
    city,
    state,
    postcode,
    country,
    isDefault,
  );

  /// Create a copy of AddressInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressInputImplCopyWith<_$AddressInputImpl> get copyWith =>
      __$$AddressInputImplCopyWithImpl<_$AddressInputImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressInputImplToJson(this);
  }
}

abstract class _AddressInput implements AddressInput {
  const factory _AddressInput({
    @JsonKey(name: 'recipient_name') required final String recipientName,
    required final String phone,
    @JsonKey(name: 'address_line_1') required final String addressLine1,
    @JsonKey(name: 'address_line_2') final String addressLine2,
    required final String city,
    required final String state,
    required final String postcode,
    final String country,
    @JsonKey(name: 'is_default') final bool isDefault,
  }) = _$AddressInputImpl;

  factory _AddressInput.fromJson(Map<String, dynamic> json) =
      _$AddressInputImpl.fromJson;

  @override
  @JsonKey(name: 'recipient_name')
  String get recipientName;
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
  @override
  String get country;
  @override
  @JsonKey(name: 'is_default')
  bool get isDefault;

  /// Create a copy of AddressInput
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressInputImplCopyWith<_$AddressInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
