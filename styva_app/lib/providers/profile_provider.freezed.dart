// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SubmitState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubmitIdle value) idle,
    required TResult Function(SubmitLoading value) loading,
    required TResult Function(SubmitSuccess value) success,
    required TResult Function(SubmitError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubmitIdle value)? idle,
    TResult? Function(SubmitLoading value)? loading,
    TResult? Function(SubmitSuccess value)? success,
    TResult? Function(SubmitError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubmitIdle value)? idle,
    TResult Function(SubmitLoading value)? loading,
    TResult Function(SubmitSuccess value)? success,
    TResult Function(SubmitError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubmitStateCopyWith<$Res> {
  factory $SubmitStateCopyWith(
    SubmitState value,
    $Res Function(SubmitState) then,
  ) = _$SubmitStateCopyWithImpl<$Res, SubmitState>;
}

/// @nodoc
class _$SubmitStateCopyWithImpl<$Res, $Val extends SubmitState>
    implements $SubmitStateCopyWith<$Res> {
  _$SubmitStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SubmitIdleImplCopyWith<$Res> {
  factory _$$SubmitIdleImplCopyWith(
    _$SubmitIdleImpl value,
    $Res Function(_$SubmitIdleImpl) then,
  ) = __$$SubmitIdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SubmitIdleImplCopyWithImpl<$Res>
    extends _$SubmitStateCopyWithImpl<$Res, _$SubmitIdleImpl>
    implements _$$SubmitIdleImplCopyWith<$Res> {
  __$$SubmitIdleImplCopyWithImpl(
    _$SubmitIdleImpl _value,
    $Res Function(_$SubmitIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SubmitIdleImpl implements SubmitIdle {
  const _$SubmitIdleImpl();

  @override
  String toString() {
    return 'SubmitState.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SubmitIdleImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
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
    required TResult Function(SubmitIdle value) idle,
    required TResult Function(SubmitLoading value) loading,
    required TResult Function(SubmitSuccess value) success,
    required TResult Function(SubmitError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubmitIdle value)? idle,
    TResult? Function(SubmitLoading value)? loading,
    TResult? Function(SubmitSuccess value)? success,
    TResult? Function(SubmitError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubmitIdle value)? idle,
    TResult Function(SubmitLoading value)? loading,
    TResult Function(SubmitSuccess value)? success,
    TResult Function(SubmitError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class SubmitIdle implements SubmitState {
  const factory SubmitIdle() = _$SubmitIdleImpl;
}

/// @nodoc
abstract class _$$SubmitLoadingImplCopyWith<$Res> {
  factory _$$SubmitLoadingImplCopyWith(
    _$SubmitLoadingImpl value,
    $Res Function(_$SubmitLoadingImpl) then,
  ) = __$$SubmitLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SubmitLoadingImplCopyWithImpl<$Res>
    extends _$SubmitStateCopyWithImpl<$Res, _$SubmitLoadingImpl>
    implements _$$SubmitLoadingImplCopyWith<$Res> {
  __$$SubmitLoadingImplCopyWithImpl(
    _$SubmitLoadingImpl _value,
    $Res Function(_$SubmitLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SubmitLoadingImpl implements SubmitLoading {
  const _$SubmitLoadingImpl();

  @override
  String toString() {
    return 'SubmitState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SubmitLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
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
    required TResult Function(SubmitIdle value) idle,
    required TResult Function(SubmitLoading value) loading,
    required TResult Function(SubmitSuccess value) success,
    required TResult Function(SubmitError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubmitIdle value)? idle,
    TResult? Function(SubmitLoading value)? loading,
    TResult? Function(SubmitSuccess value)? success,
    TResult? Function(SubmitError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubmitIdle value)? idle,
    TResult Function(SubmitLoading value)? loading,
    TResult Function(SubmitSuccess value)? success,
    TResult Function(SubmitError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class SubmitLoading implements SubmitState {
  const factory SubmitLoading() = _$SubmitLoadingImpl;
}

/// @nodoc
abstract class _$$SubmitSuccessImplCopyWith<$Res> {
  factory _$$SubmitSuccessImplCopyWith(
    _$SubmitSuccessImpl value,
    $Res Function(_$SubmitSuccessImpl) then,
  ) = __$$SubmitSuccessImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SubmitSuccessImplCopyWithImpl<$Res>
    extends _$SubmitStateCopyWithImpl<$Res, _$SubmitSuccessImpl>
    implements _$$SubmitSuccessImplCopyWith<$Res> {
  __$$SubmitSuccessImplCopyWithImpl(
    _$SubmitSuccessImpl _value,
    $Res Function(_$SubmitSuccessImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SubmitSuccessImpl implements SubmitSuccess {
  const _$SubmitSuccessImpl();

  @override
  String toString() {
    return 'SubmitState.success()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SubmitSuccessImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return success();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return success?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SubmitIdle value) idle,
    required TResult Function(SubmitLoading value) loading,
    required TResult Function(SubmitSuccess value) success,
    required TResult Function(SubmitError value) error,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubmitIdle value)? idle,
    TResult? Function(SubmitLoading value)? loading,
    TResult? Function(SubmitSuccess value)? success,
    TResult? Function(SubmitError value)? error,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubmitIdle value)? idle,
    TResult Function(SubmitLoading value)? loading,
    TResult Function(SubmitSuccess value)? success,
    TResult Function(SubmitError value)? error,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class SubmitSuccess implements SubmitState {
  const factory SubmitSuccess() = _$SubmitSuccessImpl;
}

/// @nodoc
abstract class _$$SubmitErrorImplCopyWith<$Res> {
  factory _$$SubmitErrorImplCopyWith(
    _$SubmitErrorImpl value,
    $Res Function(_$SubmitErrorImpl) then,
  ) = __$$SubmitErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$SubmitErrorImplCopyWithImpl<$Res>
    extends _$SubmitStateCopyWithImpl<$Res, _$SubmitErrorImpl>
    implements _$$SubmitErrorImplCopyWith<$Res> {
  __$$SubmitErrorImplCopyWithImpl(
    _$SubmitErrorImpl _value,
    $Res Function(_$SubmitErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$SubmitErrorImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                as String,
      ),
    );
  }
}

/// @nodoc

class _$SubmitErrorImpl implements SubmitError {
  const _$SubmitErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'SubmitState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubmitErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubmitErrorImplCopyWith<_$SubmitErrorImpl> get copyWith =>
      __$$SubmitErrorImplCopyWithImpl<_$SubmitErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() loading,
    required TResult Function() success,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? loading,
    TResult? Function()? success,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? loading,
    TResult Function()? success,
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
    required TResult Function(SubmitIdle value) idle,
    required TResult Function(SubmitLoading value) loading,
    required TResult Function(SubmitSuccess value) success,
    required TResult Function(SubmitError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SubmitIdle value)? idle,
    TResult? Function(SubmitLoading value)? loading,
    TResult? Function(SubmitSuccess value)? success,
    TResult? Function(SubmitError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SubmitIdle value)? idle,
    TResult Function(SubmitLoading value)? loading,
    TResult Function(SubmitSuccess value)? success,
    TResult Function(SubmitError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class SubmitError implements SubmitState {
  const factory SubmitError(final String message) = _$SubmitErrorImpl;

  String get message;

  /// Create a copy of SubmitState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubmitErrorImplCopyWith<_$SubmitErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
