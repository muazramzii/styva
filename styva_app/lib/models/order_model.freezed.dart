// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) {
  return _OrderModel.fromJson(json);
}

/// @nodoc
mixin _$OrderModel {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'payment_status')
  String get paymentStatus => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get shippingFee => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get total => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_count')
  int get itemCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'shipping_address')
  ShippingAddressModel? get shippingAddress =>
      throw _privateConstructorUsedError;
  List<OrderItemModel> get items => throw _privateConstructorUsedError;

  /// Serializes this OrderModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderModelCopyWith<OrderModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderModelCopyWith<$Res> {
  factory $OrderModelCopyWith(
    OrderModel value,
    $Res Function(OrderModel) then,
  ) = _$OrderModelCopyWithImpl<$Res, OrderModel>;
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'order_number') String orderNumber,
    String status,
    @JsonKey(name: 'payment_status') String paymentStatus,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
    @JsonKey(
      name: 'shipping_fee',
      fromJson: _moneyFromJson,
      toJson: _moneyToJson,
    )
    double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double total,
    @JsonKey(name: 'item_count') int itemCount,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'shipping_address') ShippingAddressModel? shippingAddress,
    List<OrderItemModel> items,
  });

  $ShippingAddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class _$OrderModelCopyWithImpl<$Res, $Val extends OrderModel>
    implements $OrderModelCopyWith<$Res> {
  _$OrderModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? subtotal = null,
    Object? shippingFee = null,
    Object? total = null,
    Object? itemCount = null,
    Object? createdAt = null,
    Object? shippingAddress = freezed,
    Object? items = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
            orderNumber:
                null == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
                        as String,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            paymentStatus:
                null == paymentStatus
                    ? _value.paymentStatus
                    : paymentStatus // ignore: cast_nullable_to_non_nullable
                        as String,
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
            itemCount:
                null == itemCount
                    ? _value.itemCount
                    : itemCount // ignore: cast_nullable_to_non_nullable
                        as int,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            shippingAddress:
                freezed == shippingAddress
                    ? _value.shippingAddress
                    : shippingAddress // ignore: cast_nullable_to_non_nullable
                        as ShippingAddressModel?,
            items:
                null == items
                    ? _value.items
                    : items // ignore: cast_nullable_to_non_nullable
                        as List<OrderItemModel>,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ShippingAddressModelCopyWith<$Res>? get shippingAddress {
    if (_value.shippingAddress == null) {
      return null;
    }

    return $ShippingAddressModelCopyWith<$Res>(_value.shippingAddress!, (
      value,
    ) {
      return _then(_value.copyWith(shippingAddress: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderModelImplCopyWith<$Res>
    implements $OrderModelCopyWith<$Res> {
  factory _$$OrderModelImplCopyWith(
    _$OrderModelImpl value,
    $Res Function(_$OrderModelImpl) then,
  ) = __$$OrderModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    @JsonKey(name: 'order_number') String orderNumber,
    String status,
    @JsonKey(name: 'payment_status') String paymentStatus,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double subtotal,
    @JsonKey(
      name: 'shipping_fee',
      fromJson: _moneyFromJson,
      toJson: _moneyToJson,
    )
    double shippingFee,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double total,
    @JsonKey(name: 'item_count') int itemCount,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'shipping_address') ShippingAddressModel? shippingAddress,
    List<OrderItemModel> items,
  });

  @override
  $ShippingAddressModelCopyWith<$Res>? get shippingAddress;
}

/// @nodoc
class __$$OrderModelImplCopyWithImpl<$Res>
    extends _$OrderModelCopyWithImpl<$Res, _$OrderModelImpl>
    implements _$$OrderModelImplCopyWith<$Res> {
  __$$OrderModelImplCopyWithImpl(
    _$OrderModelImpl _value,
    $Res Function(_$OrderModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? orderNumber = null,
    Object? status = null,
    Object? paymentStatus = null,
    Object? subtotal = null,
    Object? shippingFee = null,
    Object? total = null,
    Object? itemCount = null,
    Object? createdAt = null,
    Object? shippingAddress = freezed,
    Object? items = null,
  }) {
    return _then(
      _$OrderModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        orderNumber:
            null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                    as String,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        paymentStatus:
            null == paymentStatus
                ? _value.paymentStatus
                : paymentStatus // ignore: cast_nullable_to_non_nullable
                    as String,
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
        itemCount:
            null == itemCount
                ? _value.itemCount
                : itemCount // ignore: cast_nullable_to_non_nullable
                    as int,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        shippingAddress:
            freezed == shippingAddress
                ? _value.shippingAddress
                : shippingAddress // ignore: cast_nullable_to_non_nullable
                    as ShippingAddressModel?,
        items:
            null == items
                ? _value._items
                : items // ignore: cast_nullable_to_non_nullable
                    as List<OrderItemModel>,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$OrderModelImpl implements _OrderModel {
  const _$OrderModelImpl({
    required this.id,
    @JsonKey(name: 'order_number') required this.orderNumber,
    required this.status,
    @JsonKey(name: 'payment_status') required this.paymentStatus,
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
    @JsonKey(name: 'item_count') this.itemCount = 0,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'shipping_address') this.shippingAddress,
    final List<OrderItemModel> items = const [],
  }) : _items = items;

  factory _$OrderModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderModelImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  final String status;
  @override
  @JsonKey(name: 'payment_status')
  final String paymentStatus;
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
  @JsonKey(name: 'item_count')
  final int itemCount;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'shipping_address')
  final ShippingAddressModel? shippingAddress;
  final List<OrderItemModel> _items;
  @override
  @JsonKey()
  List<OrderItemModel> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, orderNumber: $orderNumber, status: $status, paymentStatus: $paymentStatus, subtotal: $subtotal, shippingFee: $shippingFee, total: $total, itemCount: $itemCount, createdAt: $createdAt, shippingAddress: $shippingAddress, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.paymentStatus, paymentStatus) ||
                other.paymentStatus == paymentStatus) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.shippingFee, shippingFee) ||
                other.shippingFee == shippingFee) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.shippingAddress, shippingAddress) ||
                other.shippingAddress == shippingAddress) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    orderNumber,
    status,
    paymentStatus,
    subtotal,
    shippingFee,
    total,
    itemCount,
    createdAt,
    shippingAddress,
    const DeepCollectionEquality().hash(_items),
  );

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      __$$OrderModelImplCopyWithImpl<_$OrderModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderModelImplToJson(this);
  }
}

abstract class _OrderModel implements OrderModel {
  const factory _OrderModel({
    required final int id,
    @JsonKey(name: 'order_number') required final String orderNumber,
    required final String status,
    @JsonKey(name: 'payment_status') required final String paymentStatus,
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
    @JsonKey(name: 'item_count') final int itemCount,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'shipping_address')
    final ShippingAddressModel? shippingAddress,
    final List<OrderItemModel> items,
  }) = _$OrderModelImpl;

  factory _OrderModel.fromJson(Map<String, dynamic> json) =
      _$OrderModelImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  String get status;
  @override
  @JsonKey(name: 'payment_status')
  String get paymentStatus;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get subtotal;
  @override
  @JsonKey(name: 'shipping_fee', fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get shippingFee;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get total;
  @override
  @JsonKey(name: 'item_count')
  int get itemCount;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'shipping_address')
  ShippingAddressModel? get shippingAddress;
  @override
  List<OrderItemModel> get items;

  /// Create a copy of OrderModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderModelImplCopyWith<_$OrderModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
