// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkout_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CheckoutState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(OrderModel order) success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(OrderModel order)? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(OrderModel order)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckoutIdle value) idle,
    required TResult Function(CheckoutLoading value) loading,
    required TResult Function(CheckoutSuccess value) success,
    required TResult Function(CheckoutError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckoutIdle value)? idle,
    TResult? Function(CheckoutLoading value)? loading,
    TResult? Function(CheckoutSuccess value)? success,
    TResult? Function(CheckoutError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckoutIdle value)? idle,
    TResult Function(CheckoutLoading value)? loading,
    TResult Function(CheckoutSuccess value)? success,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckoutStateCopyWith<$Res> {
  factory $CheckoutStateCopyWith(
    CheckoutState value,
    $Res Function(CheckoutState) then,
  ) = _$CheckoutStateCopyWithImpl<$Res, CheckoutState>;
}

/// @nodoc
class _$CheckoutStateCopyWithImpl<$Res, $Val extends CheckoutState>
    implements $CheckoutStateCopyWith<$Res> {
  _$CheckoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$CheckoutIdleImplCopyWith<$Res> {
  factory _$$CheckoutIdleImplCopyWith(
    _$CheckoutIdleImpl value,
    $Res Function(_$CheckoutIdleImpl) then,
  ) = __$$CheckoutIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckoutIdleImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$CheckoutIdleImpl>
    implements _$$CheckoutIdleImplCopyWith<$Res> {
  __$$CheckoutIdleImplCopyWithImpl(
    _$CheckoutIdleImpl _value,
    $Res Function(_$CheckoutIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckoutIdleImpl implements CheckoutIdle {
  const _$CheckoutIdleImpl();

  @override
  String toString() {
    return 'CheckoutState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckoutIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(OrderModel order) success,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(OrderModel order)? success,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(OrderModel order)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckoutIdle value) idle,
    required TResult Function(CheckoutLoading value) loading,
    required TResult Function(CheckoutSuccess value) success,
    required TResult Function(CheckoutError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckoutIdle value)? idle,
    TResult? Function(CheckoutLoading value)? loading,
    TResult? Function(CheckoutSuccess value)? success,
    TResult? Function(CheckoutError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckoutIdle value)? idle,
    TResult Function(CheckoutLoading value)? loading,
    TResult Function(CheckoutSuccess value)? success,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class CheckoutIdle implements CheckoutState {
  const factory CheckoutIdle() = _$CheckoutIdleImpl;
}

/// @nodoc
abstract class _$$CheckoutLoadingImplCopyWith<$Res> {
  factory _$$CheckoutLoadingImplCopyWith(
    _$CheckoutLoadingImpl value,
    $Res Function(_$CheckoutLoadingImpl) then,
  ) = __$$CheckoutLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$CheckoutLoadingImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$CheckoutLoadingImpl>
    implements _$$CheckoutLoadingImplCopyWith<$Res> {
  __$$CheckoutLoadingImplCopyWithImpl(
    _$CheckoutLoadingImpl _value,
    $Res Function(_$CheckoutLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$CheckoutLoadingImpl implements CheckoutLoading {
  const _$CheckoutLoadingImpl();

  @override
  String toString() {
    return 'CheckoutState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$CheckoutLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(OrderModel order) success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(OrderModel order)? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(OrderModel order)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckoutIdle value) idle,
    required TResult Function(CheckoutLoading value) loading,
    required TResult Function(CheckoutSuccess value) success,
    required TResult Function(CheckoutError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckoutIdle value)? idle,
    TResult? Function(CheckoutLoading value)? loading,
    TResult? Function(CheckoutSuccess value)? success,
    TResult? Function(CheckoutError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckoutIdle value)? idle,
    TResult Function(CheckoutLoading value)? loading,
    TResult Function(CheckoutSuccess value)? success,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class CheckoutLoading implements CheckoutState {
  const factory CheckoutLoading() = _$CheckoutLoadingImpl;
}

/// @nodoc
abstract class _$$CheckoutSuccessImplCopyWith<$Res> {
  factory _$$CheckoutSuccessImplCopyWith(
    _$CheckoutSuccessImpl value,
    $Res Function(_$CheckoutSuccessImpl) then,
  ) = __$$CheckoutSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({OrderModel order});

  $OrderModelCopyWith<$Res> get order;
}

/// @nodoc
class __$$CheckoutSuccessImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$CheckoutSuccessImpl>
    implements _$$CheckoutSuccessImplCopyWith<$Res> {
  __$$CheckoutSuccessImplCopyWithImpl(
    _$CheckoutSuccessImpl _value,
    $Res Function(_$CheckoutSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? order = null}) {
    return _then(
      _$CheckoutSuccessImpl(
        null == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                as OrderModel,
      ),
    );
  }

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderModelCopyWith<$Res> get order {
    return $OrderModelCopyWith<$Res>(_value.order, (value) {
      return _then(_value.copyWith(order: value));
    });
  }
}

/// @nodoc

class _$CheckoutSuccessImpl implements CheckoutSuccess {
  const _$CheckoutSuccessImpl(this.order);

  @override
  final OrderModel order;

  @override
  String toString() {
    return 'CheckoutState.success(order: $order)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutSuccessImpl &&
            (identical(other.order, order) || other.order == order));
  }

  @override
  int get hashCode => Object.hash(runtimeType, order);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutSuccessImplCopyWith<_$CheckoutSuccessImpl> get copyWith =>
      __$$CheckoutSuccessImplCopyWithImpl<_$CheckoutSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(OrderModel order) success,
    required TResult Function(String message) error,
  }) {
    return success(order);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(OrderModel order)? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call(order);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(OrderModel order)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(order);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckoutIdle value) idle,
    required TResult Function(CheckoutLoading value) loading,
    required TResult Function(CheckoutSuccess value) success,
    required TResult Function(CheckoutError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckoutIdle value)? idle,
    TResult? Function(CheckoutLoading value)? loading,
    TResult? Function(CheckoutSuccess value)? success,
    TResult? Function(CheckoutError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckoutIdle value)? idle,
    TResult Function(CheckoutLoading value)? loading,
    TResult Function(CheckoutSuccess value)? success,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class CheckoutSuccess implements CheckoutState {
  const factory CheckoutSuccess(final OrderModel order) = _$CheckoutSuccessImpl;

  OrderModel get order;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutSuccessImplCopyWith<_$CheckoutSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CheckoutErrorImplCopyWith<$Res> {
  factory _$$CheckoutErrorImplCopyWith(
    _$CheckoutErrorImpl value,
    $Res Function(_$CheckoutErrorImpl) then,
  ) = __$$CheckoutErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$CheckoutErrorImplCopyWithImpl<$Res>
    extends _$CheckoutStateCopyWithImpl<$Res, _$CheckoutErrorImpl>
    implements _$$CheckoutErrorImplCopyWith<$Res> {
  __$$CheckoutErrorImplCopyWithImpl(
    _$CheckoutErrorImpl _value,
    $Res Function(_$CheckoutErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$CheckoutErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$CheckoutErrorImpl implements CheckoutError {
  const _$CheckoutErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'CheckoutState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckoutErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckoutErrorImplCopyWith<_$CheckoutErrorImpl> get copyWith =>
      __$$CheckoutErrorImplCopyWithImpl<_$CheckoutErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(OrderModel order) success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(OrderModel order)? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(OrderModel order)? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(CheckoutIdle value) idle,
    required TResult Function(CheckoutLoading value) loading,
    required TResult Function(CheckoutSuccess value) success,
    required TResult Function(CheckoutError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(CheckoutIdle value)? idle,
    TResult? Function(CheckoutLoading value)? loading,
    TResult? Function(CheckoutSuccess value)? success,
    TResult? Function(CheckoutError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(CheckoutIdle value)? idle,
    TResult Function(CheckoutLoading value)? loading,
    TResult Function(CheckoutSuccess value)? success,
    TResult Function(CheckoutError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class CheckoutError implements CheckoutState {
  const factory CheckoutError(final String message) = _$CheckoutErrorImpl;

  String get message;

  /// Create a copy of CheckoutState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CheckoutErrorImplCopyWith<_$CheckoutErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
