// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssetRelationship {

 String get id; String get parentAssetId; String get childAssetId; AssetRelationshipType get relationshipType; DateTime get createdAt;
/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetRelationshipCopyWith<AssetRelationship> get copyWith => _$AssetRelationshipCopyWithImpl<AssetRelationship>(this as AssetRelationship, _$identity);

  /// Serializes this AssetRelationship to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetRelationship&&(identical(other.id, id) || other.id == id)&&(identical(other.parentAssetId, parentAssetId) || other.parentAssetId == parentAssetId)&&(identical(other.childAssetId, childAssetId) || other.childAssetId == childAssetId)&&(identical(other.relationshipType, relationshipType) || other.relationshipType == relationshipType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentAssetId,childAssetId,relationshipType,createdAt);

@override
String toString() {
  return 'AssetRelationship(id: $id, parentAssetId: $parentAssetId, childAssetId: $childAssetId, relationshipType: $relationshipType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AssetRelationshipCopyWith<$Res>  {
  factory $AssetRelationshipCopyWith(AssetRelationship value, $Res Function(AssetRelationship) _then) = _$AssetRelationshipCopyWithImpl;
@useResult
$Res call({
 String id, String parentAssetId, String childAssetId, AssetRelationshipType relationshipType, DateTime createdAt
});




}
/// @nodoc
class _$AssetRelationshipCopyWithImpl<$Res>
    implements $AssetRelationshipCopyWith<$Res> {
  _$AssetRelationshipCopyWithImpl(this._self, this._then);

  final AssetRelationship _self;
  final $Res Function(AssetRelationship) _then;

/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentAssetId = null,Object? childAssetId = null,Object? relationshipType = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentAssetId: null == parentAssetId ? _self.parentAssetId : parentAssetId // ignore: cast_nullable_to_non_nullable
as String,childAssetId: null == childAssetId ? _self.childAssetId : childAssetId // ignore: cast_nullable_to_non_nullable
as String,relationshipType: null == relationshipType ? _self.relationshipType : relationshipType // ignore: cast_nullable_to_non_nullable
as AssetRelationshipType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetRelationship].
extension AssetRelationshipPatterns on AssetRelationship {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetRelationship value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetRelationship() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetRelationship value)  $default,){
final _that = this;
switch (_that) {
case _AssetRelationship():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetRelationship value)?  $default,){
final _that = this;
switch (_that) {
case _AssetRelationship() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String parentAssetId,  String childAssetId,  AssetRelationshipType relationshipType,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetRelationship() when $default != null:
return $default(_that.id,_that.parentAssetId,_that.childAssetId,_that.relationshipType,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String parentAssetId,  String childAssetId,  AssetRelationshipType relationshipType,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AssetRelationship():
return $default(_that.id,_that.parentAssetId,_that.childAssetId,_that.relationshipType,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String parentAssetId,  String childAssetId,  AssetRelationshipType relationshipType,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AssetRelationship() when $default != null:
return $default(_that.id,_that.parentAssetId,_that.childAssetId,_that.relationshipType,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssetRelationship implements AssetRelationship {
  const _AssetRelationship({required this.id, required this.parentAssetId, required this.childAssetId, required this.relationshipType, required this.createdAt});
  factory _AssetRelationship.fromJson(Map<String, dynamic> json) => _$AssetRelationshipFromJson(json);

@override final  String id;
@override final  String parentAssetId;
@override final  String childAssetId;
@override final  AssetRelationshipType relationshipType;
@override final  DateTime createdAt;

/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetRelationshipCopyWith<_AssetRelationship> get copyWith => __$AssetRelationshipCopyWithImpl<_AssetRelationship>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetRelationshipToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetRelationship&&(identical(other.id, id) || other.id == id)&&(identical(other.parentAssetId, parentAssetId) || other.parentAssetId == parentAssetId)&&(identical(other.childAssetId, childAssetId) || other.childAssetId == childAssetId)&&(identical(other.relationshipType, relationshipType) || other.relationshipType == relationshipType)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentAssetId,childAssetId,relationshipType,createdAt);

@override
String toString() {
  return 'AssetRelationship(id: $id, parentAssetId: $parentAssetId, childAssetId: $childAssetId, relationshipType: $relationshipType, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AssetRelationshipCopyWith<$Res> implements $AssetRelationshipCopyWith<$Res> {
  factory _$AssetRelationshipCopyWith(_AssetRelationship value, $Res Function(_AssetRelationship) _then) = __$AssetRelationshipCopyWithImpl;
@override @useResult
$Res call({
 String id, String parentAssetId, String childAssetId, AssetRelationshipType relationshipType, DateTime createdAt
});




}
/// @nodoc
class __$AssetRelationshipCopyWithImpl<$Res>
    implements _$AssetRelationshipCopyWith<$Res> {
  __$AssetRelationshipCopyWithImpl(this._self, this._then);

  final _AssetRelationship _self;
  final $Res Function(_AssetRelationship) _then;

/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentAssetId = null,Object? childAssetId = null,Object? relationshipType = null,Object? createdAt = null,}) {
  return _then(_AssetRelationship(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentAssetId: null == parentAssetId ? _self.parentAssetId : parentAssetId // ignore: cast_nullable_to_non_nullable
as String,childAssetId: null == childAssetId ? _self.childAssetId : childAssetId // ignore: cast_nullable_to_non_nullable
as String,relationshipType: null == relationshipType ? _self.relationshipType : relationshipType // ignore: cast_nullable_to_non_nullable
as AssetRelationshipType,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
