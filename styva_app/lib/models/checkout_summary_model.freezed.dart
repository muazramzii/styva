// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CheckoutSummaryModel _$CheckoutSummaryModelFromJson(Map<String, dynamic> json) {
  return _CheckoutSummaryModel.fromJson(json);
}

/// @nodoc
mixin _$CheckoutSummaryModel {
  List<CartItemModel> get items => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get shippingFee => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get total => throw _privateConstructorUsedError;

  /// Serializes this CheckoutSummaryModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CheckoutSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CheckoutSummaryModelCopyWith<CheckoutSummaryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutSummaryModelCopyWith<$Res> {
  factory $CheckoutSummaryModelCopyWith(
    CheckoutSummaryModel value,
    $Res Function(CheckoutSummaryModel) then,
  ) = _$CheckoutSummaryModelCopyWithImpl<$Res, CheckoutSummaryModel>;
  @useResult
  $Res call({
    List<CartItemModel> items,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
    @JsonKey(
      name: 'shipping_fee',
      fromJson: _moneyFromJson,
      toJson: _moneyToJson,
    )
    double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double total,
  });
}

/// @nodoc
class _$CheckoutSummaryModelCopyWithImpl<
  $Res,
  $Val extends CheckoutSummaryModel
>
    implements $CheckoutSummaryModelCopyWith<$Res> {
  _$CheckoutSummaryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? subtotal = null,
    Object? shippingFee = null,
    Object? total = null,
  }) {
    return _then(
      _value.copyWith(
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<CartItemModel>,
            subtotal:
                null == subtotal
                    ? _value.subtotal
                    : subtotal // ignore: cast_nullable_to_non_nullable
                        as double,
            shippingFee:
                null == shippingFee
                    ? _value.shippingFee
                    : shippingFee // ignore: cast_nullable_to_non_nullable
                        as double,
            total:
                null == total
                    ? _value.total
                    : total // ignore: cast_nullable_to_non_nullable
                        as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CheckoutSummaryModelImplCopyWith<$Res>
    implements $CheckoutSummaryModelCopyWith<$Res> {
  factory _$$CheckoutSummaryModelImplCopyWith(
    _$CheckoutSummaryModelImpl value,
    $Res Function(_$CheckoutSummaryModelImpl) then,
  ) = __$$CheckoutSummaryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    List<CartItemModel> items,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
    @JsonKey(
      name: 'shipping_fee',
      fromJson: _moneyFromJson,
      toJson: _moneyToJson,
    )
    double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double total,
  });
}

/// @nodoc
class __$$CheckoutSummaryModelImplCopyWithImpl<$Res>
    extends _$CheckoutSummaryModelCopyWithImpl<$Res, _$CheckoutSummaryModelImpl>
    implements _$$CheckoutSummaryModelImplCopyWith<$Res> {
  __$$CheckoutSummaryModelImplCopyWithImpl(
    _$CheckoutSummaryModelImpl _value,
    $Res Function(_$CheckoutSummaryModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? items = null,
    Object? subtotal = null,
    Object? shippingFee = null,
    Object? total = null,
  }) {
    return _then(
      _$CheckoutSummaryModelImpl(
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<CartItemModel>,
        subtotal:
            null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                    as double,
        shippingFee:
            null == shippingFee
                ? _value.shippingFee
                : shippingFee // ignore: cast_nullable_to_non_nullable
                    as double,
        total:
            null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                    as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckoutSummaryModelImpl implements _CheckoutSummaryModel {
  const _$CheckoutSummaryModelImpl({
    final List<CartItemModel> items = const [],
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required this.subtotal,
    @JsonKey(
      name: 'shipping_fee',
      fromJson: _moneyFromJson,
      toJson: _moneyToJson,
    )
    required this.shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required this.total,
  }) : _items = items;

  factory _$CheckoutSummaryModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckoutSummaryModelImplFromJson(json);

  final List<CartItemModel> _items;
  @override
  @JsonKey()
  List<CartItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double subtotal;
  @override
  @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double shippingFee;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double total;

  @override
  String toString() {
    return 'CheckoutSummaryModel(items: $items, subtotal: $subtotal, shippingFee: $shippingFee, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutSummaryModelImpl &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingFee, shippingFee) ||
                other.shippingFee == shippingFee) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(_items),
    subtotal,
    shippingFee,
    total,
  );

  /// Create a copy of CheckoutSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutSummaryModelImplCopyWith<_$CheckoutSummaryModelImpl>
  get copyWith =>
      __$$CheckoutSummaryModelImplCopyWithImpl<_$CheckoutSummaryModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckoutSummaryModelImplToJson(this);
  }
}

abstract class _CheckoutSummaryModel implements CheckoutSummaryModel {
  const factory _CheckoutSummaryModel({
    final List<CartItemModel> items,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required final double subtotal,
    @JsonKey(
      name: 'shipping_fee',
      fromJson: _moneyFromJson,
      toJson: _moneyToJson,
    )
    required final double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required final double total,
  }) = _$CheckoutSummaryModelImpl;

  factory _CheckoutSummaryModel.fromJson(Map<String, dynamic> json) =
      _$CheckoutSummaryModelImpl.fromJson;

  @override
  List<CartItemModel> get items;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal;
  @override
  @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get shippingFee;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get total;

  /// Create a copy of CheckoutSummaryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutSummaryModelImplCopyWith<_$CheckoutSummaryModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
