// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

VariantModel _$VariantModelFromJson(Map<String, dynamic> json) {
  return _VariantModel.fromJson(json);
}

/// @nodoc
mixin _$VariantModel {
  int get id => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  int get stock => throw _privateConstructorUsedError;

  /// Serializes this VariantModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariantModelCopyWith<VariantModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariantModelCopyWith<$Res> {
  factory $VariantModelCopyWith(
    VariantModel value,
    $Res Function(VariantModel) then,
  ) = _$VariantModelCopyWithImpl<$Res, VariantModel>;
  @useResult
  $Res call({int id, String size, String color, int stock});
}

/// @nodoc
class _$VariantModelCopyWithImpl<$Res, $Val extends VariantModel>
    implements $VariantModelCopyWith<$Res> {
  _$VariantModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? stock = null,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as int,
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
            stock:
                null == stock
                    ? _value.stock
                    : stock // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VariantModelImplCopyWith<$Res>
    implements $VariantModelCopyWith<$Res> {
  factory _$$VariantModelImplCopyWith(
    _$VariantModelImpl value,
    $Res Function(_$VariantModelImpl) then,
  ) = __$$VariantModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String size, String color, int stock});
}

/// @nodoc
class __$$VariantModelImplCopyWithImpl<$Res>
    extends _$VariantModelCopyWithImpl<$Res, _$VariantModelImpl>
    implements _$$VariantModelImplCopyWith<$Res> {
  __$$VariantModelImplCopyWithImpl(
    _$VariantModelImpl _value,
    $Res Function(_$VariantModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? stock = null,
  }) {
    return _then(
      _$VariantModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as int,
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
        stock:
            null == stock
                ? _value.stock
                : stock // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VariantModelImpl implements _VariantModel {
  const _$VariantModelImpl({
    required this.id,
    required this.size,
    required this.color,
    required this.stock,
  });

  factory _$VariantModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariantModelImplFromJson(json);

  @override
  final int id;
  @override
  final String size;
  @override
  final String color;
  @override
  final int stock;

  @override
  String toString() {
    return 'VariantModel(id: $id, size: $size, color: $color, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariantModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.stock, stock) || other.stock == stock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, size, color, stock);

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariantModelImplCopyWith<_$VariantModelImpl> get copyWith =>
      __$$VariantModelImplCopyWithImpl<_$VariantModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariantModelImplToJson(this);
  }
}

abstract class _VariantModel implements VariantModel {
  const factory _VariantModel({
    required final int id,
    required final String size,
    required final String color,
    required final int stock,
  }) = _$VariantModelImpl;

  factory _VariantModel.fromJson(Map<String, dynamic> json) =
      _$VariantModelImpl.fromJson;

  @override
  int get id;
  @override
  String get size;
  @override
  String get color;
  @override
  int get stock;

  /// Create a copy of VariantModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariantModelImplCopyWith<_$VariantModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
