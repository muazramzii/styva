// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductSummaryModel _$ProductSummaryModelFromJson(Map<String, dynamic> json) {
  return _ProductSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$ProductSummaryModel {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  double get price => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;

  /// Serializes this ProductSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductSummaryModelCopyWith<ProductSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSummaryModelCopyWith<$Res> {
  factory $ProductSummaryModelCopyWith(
    ProductSummaryModel value,
    $Res Function(ProductSummaryModel) then,
  ) = _$ProductSummaryModelCopyWithImpl<$Res, ProductSummaryModel>;
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson) double price,
    String brand,
  });
}

/// @nodoc
class _$ProductSummaryModelCopyWithImpl<$Res, $Val extends ProductSummaryModel>
    implements $ProductSummaryModelCopyWith<$Res> {
  _$ProductSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? brand = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            brand:
                null == brand
                    ? _value.brand
                    : brand // ignore: cast_nullable_to_non_nullable
                        as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductSummaryModelImplCopyWith<$Res>
    implements $ProductSummaryModelCopyWith<$Res> {
  factory _$$ProductSummaryModelImplCopyWith(
    _$ProductSummaryModelImpl value,
    $Res Function(_$ProductSummaryModelImpl) then,
  ) = __$$ProductSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String name,
    @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson) double price,
    String brand,
  });
}

/// @nodoc
class __$$ProductSummaryModelImplCopyWithImpl<$Res>
    extends _$ProductSummaryModelCopyWithImpl<$Res, _$ProductSummaryModelImpl>
    implements _$$ProductSummaryModelImplCopyWith<$Res> {
  __$$ProductSummaryModelImplCopyWithImpl(
    _$ProductSummaryModelImpl _value,
    $Res Function(_$ProductSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? brand = null,
  }) {
    return _then(
      _$ProductSummaryModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        brand:
            null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                    as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSummaryModelImpl implements _ProductSummaryModel {
  const _$ProductSummaryModelImpl({
    required this.id,
    required this.name,
    @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
    required this.price,
    required this.brand,
  });

  factory _$ProductSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSummaryModelImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  final double price;
  @override
  final String brand;

  @override
  String toString() {
    return 'ProductSummaryModel(id: $id, name: $name, price: $price, brand: $brand)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSummaryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.brand, brand) || other.brand == brand));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, price, brand);

  /// Create a copy of ProductSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSummaryModelImplCopyWith<_$ProductSummaryModelImpl> get copyWith =>
      __$$ProductSummaryModelImplCopyWithImpl<_$ProductSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSummaryModelImplToJson(this);
  }
}

abstract class _ProductSummaryModel implements ProductSummaryModel {
  const factory _ProductSummaryModel({
    required final int id,
    required final String name,
    @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
    required final double price,
    required final String brand,
  }) = _$ProductSummaryModelImpl;

  factory _ProductSummaryModel.fromJson(Map<String, dynamic> json) =
      _$ProductSummaryModelImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(fromJson: _priceFromJson, toJson: _priceToJson)
  double get price;
  @override
  String get brand;

  /// Create a copy of ProductSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductSummaryModelImplCopyWith<_$ProductSummaryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
