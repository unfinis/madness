// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AssetRelationship _$AssetRelationshipFromJson(Map<String, dynamic> json) {
  return _AssetRelationship.fromJson(json);
}

/// @nodoc
mixin _$AssetRelationship {
  String get id => throw _privateConstructorUsedError;
  String get parentAssetId => throw _privateConstructorUsedError;
  String get childAssetId => throw _privateConstructorUsedError;
  AssetRelationshipType get relationshipType =>
      throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetRelationshipCopyWith<AssetRelationship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetRelationshipCopyWith<$Res> {
  factory $AssetRelationshipCopyWith(
          AssetRelationship value, $Res Function(AssetRelationship) then) =
      _$AssetRelationshipCopyWithImpl<$Res, AssetRelationship>;
  @useResult
  $Res call(
      {String id,
      String parentAssetId,
      String childAssetId,
      AssetRelationshipType relationshipType,
      DateTime createdAt});
}

/// @nodoc
class _$AssetRelationshipCopyWithImpl<$Res, $Val extends AssetRelationship>
    implements $AssetRelationshipCopyWith<$Res> {
  _$AssetRelationshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentAssetId = null,
    Object? childAssetId = null,
    Object? relationshipType = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentAssetId: null == parentAssetId
          ? _value.parentAssetId
          : parentAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      childAssetId: null == childAssetId
          ? _value.childAssetId
          : childAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as AssetRelationshipType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetRelationshipImplCopyWith<$Res>
    implements $AssetRelationshipCopyWith<$Res> {
  factory _$$AssetRelationshipImplCopyWith(_$AssetRelationshipImpl value,
          $Res Function(_$AssetRelationshipImpl) then) =
      __$$AssetRelationshipImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String parentAssetId,
      String childAssetId,
      AssetRelationshipType relationshipType,
      DateTime createdAt});
}

/// @nodoc
class __$$AssetRelationshipImplCopyWithImpl<$Res>
    extends _$AssetRelationshipCopyWithImpl<$Res, _$AssetRelationshipImpl>
    implements _$$AssetRelationshipImplCopyWith<$Res> {
  __$$AssetRelationshipImplCopyWithImpl(_$AssetRelationshipImpl _value,
      $Res Function(_$AssetRelationshipImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentAssetId = null,
    Object? childAssetId = null,
    Object? relationshipType = null,
    Object? createdAt = null,
  }) {
    return _then(_$AssetRelationshipImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentAssetId: null == parentAssetId
          ? _value.parentAssetId
          : parentAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      childAssetId: null == childAssetId
          ? _value.childAssetId
          : childAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      relationshipType: null == relationshipType
          ? _value.relationshipType
          : relationshipType // ignore: cast_nullable_to_non_nullable
              as AssetRelationshipType,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetRelationshipImpl implements _AssetRelationship {
  const _$AssetRelationshipImpl(
      {required this.id,
      required this.parentAssetId,
      required this.childAssetId,
      required this.relationshipType,
      required this.createdAt});

  factory _$AssetRelationshipImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetRelationshipImplFromJson(json);

  @override
  final String id;
  @override
  final String parentAssetId;
  @override
  final String childAssetId;
  @override
  final AssetRelationshipType relationshipType;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'AssetRelationship(id: $id, parentAssetId: $parentAssetId, childAssetId: $childAssetId, relationshipType: $relationshipType, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetRelationshipImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentAssetId, parentAssetId) ||
                other.parentAssetId == parentAssetId) &&
            (identical(other.childAssetId, childAssetId) ||
                other.childAssetId == childAssetId) &&
            (identical(other.relationshipType, relationshipType) ||
                other.relationshipType == relationshipType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentAssetId, childAssetId,
      relationshipType, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetRelationshipImplCopyWith<_$AssetRelationshipImpl> get copyWith =>
      __$$AssetRelationshipImplCopyWithImpl<_$AssetRelationshipImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetRelationshipImplToJson(
      this,
    );
  }
}

abstract class _AssetRelationship implements AssetRelationship {
  const factory _AssetRelationship(
      {required final String id,
      required final String parentAssetId,
      required final String childAssetId,
      required final AssetRelationshipType relationshipType,
      required final DateTime createdAt}) = _$AssetRelationshipImpl;

  factory _AssetRelationship.fromJson(Map<String, dynamic> json) =
      _$AssetRelationshipImpl.fromJson;

  @override
  String get id;
  @override
  String get parentAssetId;
  @override
  String get childAssetId;
  @override
  AssetRelationshipType get relationshipType;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$AssetRelationshipImplCopyWith<_$AssetRelationshipImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
