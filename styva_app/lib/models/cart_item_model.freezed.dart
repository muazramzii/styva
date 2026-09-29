// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) {
  return _CartItemModel.fromJson(json);
}

/// @nodoc
mixin _$CartItemModel {
  int get id => throw _privateConstructorUsedError;
  VariantModel get variant => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal => throw _privateConstructorUsedError;

  /// Serializes this CartItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartItemModelCopyWith<CartItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemModelCopyWith<$Res> {
  factory $CartItemModelCopyWith(
    CartItemModel value,
    $Res Function(CartItemModel) then,
  ) = _$CartItemModelCopyWithImpl<$Res, CartItemModel>;
  @useResult
  $Res call({
    int id,
    VariantModel variant,
    int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
  });

  $VariantModelCopyWith<$Res> get variant;
}

/// @nodoc
class _$CartItemModelCopyWithImpl<$Res, $Val extends CartItemModel>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variant = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            variant:
                null == variant
                    ? _value.variant
                    : variant // ignore: cast_nullable_to_non_nullable
                        as VariantModel,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
            subtotal:
                null == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $VariantModelCopyWith<$Res> get variant {
    return $VariantModelCopyWith<$Res>(_value.variant, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartItemModelImplCopyWith<$Res>
    implements $CartItemModelCopyWith<$Res> {
  factory _$$CartItemModelImplCopyWith(
    _$CartItemModelImpl value,
    $Res Function(_$CartItemModelImpl) then,
  ) = __$$CartItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    VariantModel variant,
    int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
  });

  @override
  $VariantModelCopyWith<$Res> get variant;
}

/// @nodoc
class __$$CartItemModelImplCopyWithImpl<$Res>
    extends _$CartItemModelCopyWithImpl<$Res, _$CartItemModelImpl>
    implements _$$CartItemModelImplCopyWith<$Res> {
  __$$CartItemModelImplCopyWithImpl(
    _$CartItemModelImpl _value,
    $Res Function(_$CartItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variant = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(
      _$CartItemModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        variant:
            null == variant
                ? _value.variant
                : variant // ignore: cast_nullable_to_non_nullable
                    as VariantModel,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
        subtotal:
            null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartItemModelImpl implements _CartItemModel {
  const _$CartItemModelImpl({
    required this.id,
    required this.variant,
    required this.quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required this.subtotal,
  });

  factory _$CartItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemModelImplFromJson(json);

  @override
  final int id;
  @override
  final VariantModel variant;
  @override
  final int quantity;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double subtotal;

  @override
  String toString() {
    return 'CartItemModel(id: $id, variant: $variant, quantity: $quantity, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, variant, quantity, subtotal);

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      __$$CartItemModelImplCopyWithImpl<_$CartItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemModelImplToJson(this);
  }
}

abstract class _CartItemModel implements CartItemModel {
  const factory _CartItemModel({
    required final int id,
    required final VariantModel variant,
    required final int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required final double subtotal,
  }) = _$CartItemModelImpl;

  factory _CartItemModel.fromJson(Map<String, dynamic> json) =
      _$CartItemModelImpl.fromJson;

  @override
  int get id;
  @override
  VariantModel get variant;
  @override
  int get quantity;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal;

  /// Create a copy of CartItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
