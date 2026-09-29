// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) {
  return _PaymentModel.fromJson(json);
}

/// @nodoc
mixin _$PaymentModel {
  int get id => throw _privateConstructorUsedError;
  String get reference => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_id')
  int get orderId => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_number')
  String get orderNumber => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get amount => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get provider => throw _privateConstructorUsedError;
  @JsonKey(name: 'provider_reference')
  String? get providerReference => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PaymentModelCopyWith<PaymentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentModelCopyWith<$Res> {
  factory $PaymentModelCopyWith(
    PaymentModel value,
    $Res Function(PaymentModel) then,
  ) = _$PaymentModelCopyWithImpl<$Res, PaymentModel>;
  @useResult
  $Res call({
    int id,
    String reference,
    @JsonKey(name: 'order_id') int orderId,
    @JsonKey(name: 'order_number') String orderNumber,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double amount,
    String status,
    String provider,
    @JsonKey(name: 'provider_reference') String? providerReference,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class _$PaymentModelCopyWithImpl<$Res, $Val extends PaymentModel>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? orderId = null,
    Object? orderNumber = null,
    Object? amount = null,
    Object? status = null,
    Object? provider = null,
    Object? providerReference = freezed,
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
            reference:
                null == reference
                    ? _value.reference
                    : reference // ignore: cast_nullable_to_non_nullable
                        as String,
            orderId:
                null == orderId
                    ? _value.orderId
                    : orderId // ignore: cast_nullable_to_non_nullable
                        as int,
            orderNumber:
                null == orderNumber
                    ? _value.orderNumber
                    : orderNumber // ignore: cast_nullable_to_non_nullable
                        as String,
            amount:
                null == amount
                    ? _value.amount
                    : amount // ignore: cast_nullable_to_non_nullable
                        as double,
            status:
                null == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String,
            provider:
                null == provider
                    ? _value.provider
                    : provider // ignore: cast_nullable_to_non_nullable
                        as String,
            providerReference:
                freezed == providerReference
                    ? _value.providerReference
                    : providerReference // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$PaymentModelImplCopyWith<$Res>
    implements $PaymentModelCopyWith<$Res> {
  factory _$$PaymentModelImplCopyWith(
    _$PaymentModelImpl value,
    $Res Function(_$PaymentModelImpl) then,
  ) = __$$PaymentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int id,
    String reference,
    @JsonKey(name: 'order_id') int orderId,
    @JsonKey(name: 'order_number') String orderNumber,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson) double amount,
    String status,
    String provider,
    @JsonKey(name: 'provider_reference') String? providerReference,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
  });
}

/// @nodoc
class __$$PaymentModelImplCopyWithImpl<$Res>
    extends _$PaymentModelCopyWithImpl<$Res, _$PaymentModelImpl>
    implements _$$PaymentModelImplCopyWith<$Res> {
  __$$PaymentModelImplCopyWithImpl(
    _$PaymentModelImpl _value,
    $Res Function(_$PaymentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reference = null,
    Object? orderId = null,
    Object? orderNumber = null,
    Object? amount = null,
    Object? status = null,
    Object? provider = null,
    Object? providerReference = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(
      _$PaymentModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
        reference:
            null == reference
                ? _value.reference
                : reference // ignore: cast_nullable_to_non_nullable
                    as String,
        orderId:
            null == orderId
                ? _value.orderId
                : orderId // ignore: cast_nullable_to_non_nullable
                    as int,
        orderNumber:
            null == orderNumber
                ? _value.orderNumber
                : orderNumber // ignore: cast_nullable_to_non_nullable
                    as String,
        amount:
            null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                    as double,
        status:
            null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String,
        provider:
            null == provider
                ? _value.provider
                : provider // ignore: cast_nullable_to_non_nullable
                    as String,
        providerReference:
            freezed == providerReference
                ? _value.providerReference
                : providerReference // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$PaymentModelImpl implements _PaymentModel {
  const _$PaymentModelImpl({
    required this.id,
    required this.reference,
    @JsonKey(name: 'order_id') required this.orderId,
    @JsonKey(name: 'order_number') required this.orderNumber,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required this.amount,
    required this.status,
    required this.provider,
    @JsonKey(name: 'provider_reference') this.providerReference,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
  });

  factory _$PaymentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PaymentModelImplFromJson(json);

  @override
  final int id;
  @override
  final String reference;
  @override
  @JsonKey(name: 'order_id')
  final int orderId;
  @override
  @JsonKey(name: 'order_number')
  final String orderNumber;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  final double amount;
  @override
  final String status;
  @override
  final String provider;
  @override
  @JsonKey(name: 'provider_reference')
  final String? providerReference;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'PaymentModel(id: $id, reference: $reference, orderId: $orderId, orderNumber: $orderNumber, amount: $amount, status: $status, provider: $provider, providerReference: $providerReference, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reference, reference) ||
                other.reference == reference) &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.orderNumber, orderNumber) ||
                other.orderNumber == orderNumber) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.providerReference, providerReference) ||
                other.providerReference == providerReference) &&
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
    reference,
    orderId,
    orderNumber,
    amount,
    status,
    provider,
    providerReference,
    createdAt,
    updatedAt,
  );

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      __$$PaymentModelImplCopyWithImpl<_$PaymentModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PaymentModelImplToJson(this);
  }
}

abstract class _PaymentModel implements PaymentModel {
  const factory _PaymentModel({
    required final int id,
    required final String reference,
    @JsonKey(name: 'order_id') required final int orderId,
    @JsonKey(name: 'order_number') required final String orderNumber,
    @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
    required final double amount,
    required final String status,
    required final String provider,
    @JsonKey(name: 'provider_reference') final String? providerReference,
    @JsonKey(name: 'created_at') required final DateTime createdAt,
    @JsonKey(name: 'updated_at') required final DateTime updatedAt,
  }) = _$PaymentModelImpl;

  factory _PaymentModel.fromJson(Map<String, dynamic> json) =
      _$PaymentModelImpl.fromJson;

  @override
  int get id;
  @override
  String get reference;
  @override
  @JsonKey(name: 'order_id')
  int get orderId;
  @override
  @JsonKey(name: 'order_number')
  String get orderNumber;
  @override
  @JsonKey(fromJson: _moneyFromJson, toJson: _moneyToJson)
  double get amount;
  @override
  String get status;
  @override
  String get provider;
  @override
  @JsonKey(name: 'provider_reference')
  String? get providerReference;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;

  /// Create a copy of PaymentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentModelImplCopyWith<_$PaymentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
