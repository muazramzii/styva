// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderItemModel _$OrderItemModelFromJson(Map<String, dynamic> json) {
  return _OrderItemModel.fromJson(json);
}

/// @nodoc
mixin _$OrderItemModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'variant_id')
  int get variantId => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  String get brand => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get unitPrice => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal => throw _privateConstructorUsedError;

  /// Serializes this OrderItemModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderItemModelCopyWith<OrderItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderItemModelCopyWith<$Res> {
  factory $OrderItemModelCopyWith(
    OrderItemModel value,
    $Res Function(OrderItemModel) then,
  ) = _$OrderItemModelCopyWithImpl<$Res, OrderItemModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'variant_id') int variantId,
    @JsonKey(name: 'product_name') String productName,
    String brand,
    String size,
    String color,
    @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
    double unitPrice,
    int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
  });
}

/// @nodoc
class _$OrderItemModelCopyWithImpl<$Res, $Val extends OrderItemModel>
    implements $OrderItemModelCopyWith<$Res> {
  _$OrderItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variantId = null,
    Object? productName = null,
    Object? brand = null,
    Object? size = null,
    Object? color = null,
    Object? unitPrice = null,
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
            variantId:
                null == variantId
                    ? _value.variantId
                    : variantId // ignore: cast_nullable_to_non_nullable
                        as int,
            productName:
                null == productName
                    ? _value.productName
                    : productName // ignore: cast_nullable_to_non_nullable
                        as String,
            brand:
                null == brand
                    ? _value.brand
                    : brand // ignore: cast_nullable_to_non_nullable
                        as String,
            size:
                null == size
                    ? _value.size
                    : size // ignore: cast_nullable_to_non_nullable
                        as String,
            color:
                null == color
                    ? _value.color
                    : color // ignore: cast_nullable_to_non_nullable
                        as String,
            unitPrice:
                null == unitPrice
                    ? _value.unitPrice
                    : unitPrice // ignore: cast_nullable_to_non_nullable
                        as double,
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
}

/// @nodoc
abstract class _$$OrderItemModelImplCopyWith<$Res>
    implements $OrderItemModelCopyWith<$Res> {
  factory _$$OrderItemModelImplCopyWith(
    _$OrderItemModelImpl value,
    $Res Function(_$OrderItemModelImpl) then,
  ) = __$$OrderItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'variant_id') int variantId,
    @JsonKey(name: 'product_name') String productName,
    String brand,
    String size,
    String color,
    @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
    double unitPrice,
    int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
  });
}

/// @nodoc
class __$$OrderItemModelImplCopyWithImpl<$Res>
    extends _$OrderItemModelCopyWithImpl<$Res, _$OrderItemModelImpl>
    implements _$$OrderItemModelImplCopyWith<$Res> {
  __$$OrderItemModelImplCopyWithImpl(
    _$OrderItemModelImpl _value,
    $Res Function(_$OrderItemModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? variantId = null,
    Object? productName = null,
    Object? brand = null,
    Object? size = null,
    Object? color = null,
    Object? unitPrice = null,
    Object? quantity = null,
    Object? subtotal = null,
  }) {
    return _then(
      _$OrderItemModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        variantId:
            null == variantId
                ? _value.variantId
                : variantId // ignore: cast_nullable_to_non_nullable
                    as int,
        productName:
            null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                    as String,
        brand:
            null == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                    as String,
        size:
            null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                    as String,
        color:
            null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                    as String,
        unitPrice:
            null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                    as double,
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
class _$OrderItemModelImpl implements _OrderItemModel {
  const _$OrderItemModelImpl({
    required this.id,
    @JsonKey(name: 'variant_id') required this.variantId,
    @JsonKey(name: 'product_name') required this.productName,
    required this.brand,
    required this.size,
    required this.color,
    @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
    required this.unitPrice,
    required this.quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required this.subtotal,
  });

  factory _$OrderItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderItemModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'variant_id')
  final int variantId;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final String brand;
  @override
  final String size;
  @override
  final String color;
  @override
  @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double unitPrice;
  @override
  final int quantity;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double subtotal;

  @override
  String toString() {
    return 'OrderItemModel(id: $id, variantId: $variantId, productName: $productName, brand: $brand, size: $size, color: $color, unitPrice: $unitPrice, quantity: $quantity, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    variantId,
    productName,
    brand,
    size,
    color,
    unitPrice,
    quantity,
    subtotal,
  );

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      __$$OrderItemModelImplCopyWithImpl<_$OrderItemModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderItemModelImplToJson(this);
  }
}

abstract class _OrderItemModel implements OrderItemModel {
  const factory _OrderItemModel({
    required final int id,
    @JsonKey(name: 'variant_id') required final int variantId,
    @JsonKey(name: 'product_name') required final String productName,
    required final String brand,
    required final String size,
    required final String color,
    @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
    required final double unitPrice,
    required final int quantity,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required final double subtotal,
  }) = _$OrderItemModelImpl;

  factory _OrderItemModel.fromJson(Map<String, dynamic> json) =
      _$OrderItemModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'variant_id')
  int get variantId;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  String get brand;
  @override
  String get size;
  @override
  String get color;
  @override
  @JsonKey(name: 'unit_price', fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get unitPrice;
  @override
  int get quantity;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal;

  /// Create a copy of OrderItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderItemModelImplCopyWith<_$OrderItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
