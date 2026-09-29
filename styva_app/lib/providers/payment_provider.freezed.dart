// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PaymentState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PaymentStateCopyWith<$Res> {
  factory $PaymentStateCopyWith(
    PaymentState value,
    $Res Function(PaymentState) then,
  ) = _$PaymentStateCopyWithImpl<$Res, PaymentState>;
}

/// @nodoc
class _$PaymentStateCopyWithImpl<$Res, $Val extends PaymentState>
    implements $PaymentStateCopyWith<$Res> {
  _$PaymentStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PaymentIdleImplCopyWith<$Res> {
  factory _$$PaymentIdleImplCopyWith(
    _$PaymentIdleImpl value,
    $Res Function(_$PaymentIdleImpl) then,
  ) = __$$PaymentIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentIdleImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentIdleImpl>
    implements _$$PaymentIdleImplCopyWith<$Res> {
  __$$PaymentIdleImplCopyWithImpl(
    _$PaymentIdleImpl _value,
    $Res Function(_$PaymentIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentIdleImpl implements PaymentIdle {
  const _$PaymentIdleImpl();

  @override
  String toString() {
    return 'PaymentState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
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
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PaymentIdle implements PaymentState {
  const factory PaymentIdle() = _$PaymentIdleImpl;
}

/// @nodoc
abstract class _$$PaymentLoadingImplCopyWith<$Res> {
  factory _$$PaymentLoadingImplCopyWith(
    _$PaymentLoadingImpl value,
    $Res Function(_$PaymentLoadingImpl) then,
  ) = __$$PaymentLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PaymentLoadingImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentLoadingImpl>
    implements _$$PaymentLoadingImplCopyWith<$Res> {
  __$$PaymentLoadingImplCopyWithImpl(
    _$PaymentLoadingImpl _value,
    $Res Function(_$PaymentLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PaymentLoadingImpl implements PaymentLoading {
  const _$PaymentLoadingImpl();

  @override
  String toString() {
    return 'PaymentState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PaymentLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
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
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PaymentLoading implements PaymentState {
  const factory PaymentLoading() = _$PaymentLoadingImpl;
}

/// @nodoc
abstract class _$$PaymentPendingImplCopyWith<$Res> {
  factory _$$PaymentPendingImplCopyWith(
    _$PaymentPendingImpl value,
    $Res Function(_$PaymentPendingImpl) then,
  ) = __$$PaymentPendingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaymentModel payment});

  $PaymentModelCopyWith<$Res> get payment;
}

/// @nodoc
class __$$PaymentPendingImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentPendingImpl>
    implements _$$PaymentPendingImplCopyWith<$Res> {
  __$$PaymentPendingImplCopyWithImpl(
    _$PaymentPendingImpl _value,
    $Res Function(_$PaymentPendingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? payment = null}) {
    return _then(
      _$PaymentPendingImpl(
        null == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                as PaymentModel,
      ),
    );
  }

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentModelCopyWith<$Res> get payment {
    return $PaymentModelCopyWith<$Res>(_value.payment, (value) {
      return _then(_value.copyWith(payment: value));
    });
  }
}

/// @nodoc

class _$PaymentPendingImpl implements PaymentPending {
  const _$PaymentPendingImpl(this.payment);

  @override
  final PaymentModel payment;

  @override
  String toString() {
    return 'PaymentState.pending(payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentPendingImpl &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, payment);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentPendingImplCopyWith<_$PaymentPendingImpl> get copyWith =>
      __$$PaymentPendingImplCopyWithImpl<_$PaymentPendingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) {
    return pending(payment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) {
    return pending?.call(payment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending(payment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) {
    return pending(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) {
    return pending?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (pending != null) {
      return pending(this);
    }
    return orElse();
  }
}

abstract class PaymentPending implements PaymentState {
  const factory PaymentPending(final PaymentModel payment) =
      _$PaymentPendingImpl;

  PaymentModel get payment;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentPendingImplCopyWith<_$PaymentPendingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentSuccessImplCopyWith<$Res> {
  factory _$$PaymentSuccessImplCopyWith(
    _$PaymentSuccessImpl value,
    $Res Function(_$PaymentSuccessImpl) then,
  ) = __$$PaymentSuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaymentModel payment});

  $PaymentModelCopyWith<$Res> get payment;
}

/// @nodoc
class __$$PaymentSuccessImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentSuccessImpl>
    implements _$$PaymentSuccessImplCopyWith<$Res> {
  __$$PaymentSuccessImplCopyWithImpl(
    _$PaymentSuccessImpl _value,
    $Res Function(_$PaymentSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? payment = null}) {
    return _then(
      _$PaymentSuccessImpl(
        null == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                as PaymentModel,
      ),
    );
  }

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentModelCopyWith<$Res> get payment {
    return $PaymentModelCopyWith<$Res>(_value.payment, (value) {
      return _then(_value.copyWith(payment: value));
    });
  }
}

/// @nodoc

class _$PaymentSuccessImpl implements PaymentSuccess {
  const _$PaymentSuccessImpl(this.payment);

  @override
  final PaymentModel payment;

  @override
  String toString() {
    return 'PaymentState.success(payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentSuccessImpl &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, payment);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentSuccessImplCopyWith<_$PaymentSuccessImpl> get copyWith =>
      __$$PaymentSuccessImplCopyWithImpl<_$PaymentSuccessImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) {
    return success(payment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) {
    return success?.call(payment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(payment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class PaymentSuccess implements PaymentState {
  const factory PaymentSuccess(final PaymentModel payment) =
      _$PaymentSuccessImpl;

  PaymentModel get payment;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentSuccessImplCopyWith<_$PaymentSuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentFailedImplCopyWith<$Res> {
  factory _$$PaymentFailedImplCopyWith(
    _$PaymentFailedImpl value,
    $Res Function(_$PaymentFailedImpl) then,
  ) = __$$PaymentFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({PaymentModel payment});

  $PaymentModelCopyWith<$Res> get payment;
}

/// @nodoc
class __$$PaymentFailedImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentFailedImpl>
    implements _$$PaymentFailedImplCopyWith<$Res> {
  __$$PaymentFailedImplCopyWithImpl(
    _$PaymentFailedImpl _value,
    $Res Function(_$PaymentFailedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? payment = null}) {
    return _then(
      _$PaymentFailedImpl(
        null == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                as PaymentModel,
      ),
    );
  }

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PaymentModelCopyWith<$Res> get payment {
    return $PaymentModelCopyWith<$Res>(_value.payment, (value) {
      return _then(_value.copyWith(payment: value));
    });
  }
}

/// @nodoc

class _$PaymentFailedImpl implements PaymentFailed {
  const _$PaymentFailedImpl(this.payment);

  @override
  final PaymentModel payment;

  @override
  String toString() {
    return 'PaymentState.failed(payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentFailedImpl &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @override
  int get hashCode => Object.hash(runtimeType, payment);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentFailedImplCopyWith<_$PaymentFailedImpl> get copyWith =>
      __$$PaymentFailedImplCopyWithImpl<_$PaymentFailedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) {
    return failed(payment);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) {
    return failed?.call(payment);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(payment);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) {
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) {
    return failed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class PaymentFailed implements PaymentState {
  const factory PaymentFailed(final PaymentModel payment) = _$PaymentFailedImpl;

  PaymentModel get payment;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentFailedImplCopyWith<_$PaymentFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PaymentErrorImplCopyWith<$Res> {
  factory _$$PaymentErrorImplCopyWith(
    _$PaymentErrorImpl value,
    $Res Function(_$PaymentErrorImpl) then,
  ) = __$$PaymentErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$PaymentErrorImplCopyWithImpl<$Res>
    extends _$PaymentStateCopyWithImpl<$Res, _$PaymentErrorImpl>
    implements _$$PaymentErrorImplCopyWith<$Res> {
  __$$PaymentErrorImplCopyWithImpl(
    _$PaymentErrorImpl _value,
    $Res Function(_$PaymentErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$PaymentErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$PaymentErrorImpl implements PaymentError {
  const _$PaymentErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'PaymentState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PaymentErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PaymentErrorImplCopyWith<_$PaymentErrorImpl> get copyWith =>
      __$$PaymentErrorImplCopyWithImpl<_$PaymentErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function(PaymentModel payment) pending,
    required TResult Function(PaymentModel payment) success,
    required TResult Function(PaymentModel payment) failed,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function(PaymentModel payment)? pending,
    TResult? Function(PaymentModel payment)? success,
    TResult? Function(PaymentModel payment)? failed,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function(PaymentModel payment)? pending,
    TResult Function(PaymentModel payment)? success,
    TResult Function(PaymentModel payment)? failed,
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
    required TResult Function(PaymentIdle value) idle,
    required TResult Function(PaymentLoading value) loading,
    required TResult Function(PaymentPending value) pending,
    required TResult Function(PaymentSuccess value) success,
    required TResult Function(PaymentFailed value) failed,
    required TResult Function(PaymentError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PaymentIdle value)? idle,
    TResult? Function(PaymentLoading value)? loading,
    TResult? Function(PaymentPending value)? pending,
    TResult? Function(PaymentSuccess value)? success,
    TResult? Function(PaymentFailed value)? failed,
    TResult? Function(PaymentError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PaymentIdle value)? idle,
    TResult Function(PaymentLoading value)? loading,
    TResult Function(PaymentPending value)? pending,
    TResult Function(PaymentSuccess value)? success,
    TResult Function(PaymentFailed value)? failed,
    TResult Function(PaymentError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PaymentError implements PaymentState {
  const factory PaymentError(final String message) = _$PaymentErrorImpl;

  String get message;

  /// Create a copy of PaymentState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PaymentErrorImplCopyWith<_$PaymentErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
