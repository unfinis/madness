// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset_relationships.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RelationshipMetadata {

 String get discoveryMethod; String get confidence; DateTime? get discoveredAt; DateTime? get validatedAt; Map<String, dynamic> get additionalData; String get notes;
/// Create a copy of RelationshipMetadata
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelationshipMetadataCopyWith<RelationshipMetadata> get copyWith => _$RelationshipMetadataCopyWithImpl<RelationshipMetadata>(this as RelationshipMetadata, _$identity);

  /// Serializes this RelationshipMetadata to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelationshipMetadata&&(identical(other.discoveryMethod, discoveryMethod) || other.discoveryMethod == discoveryMethod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&const DeepCollectionEquality().equals(other.additionalData, additionalData)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,discoveryMethod,confidence,discoveredAt,validatedAt,const DeepCollectionEquality().hash(additionalData),notes);

@override
String toString() {
  return 'RelationshipMetadata(discoveryMethod: $discoveryMethod, confidence: $confidence, discoveredAt: $discoveredAt, validatedAt: $validatedAt, additionalData: $additionalData, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $RelationshipMetadataCopyWith<$Res>  {
  factory $RelationshipMetadataCopyWith(RelationshipMetadata value, $Res Function(RelationshipMetadata) _then) = _$RelationshipMetadataCopyWithImpl;
@useResult
$Res call({
 String discoveryMethod, String confidence, DateTime? discoveredAt, DateTime? validatedAt, Map<String, dynamic> additionalData, String notes
});




}
/// @nodoc
class _$RelationshipMetadataCopyWithImpl<$Res>
    implements $RelationshipMetadataCopyWith<$Res> {
  _$RelationshipMetadataCopyWithImpl(this._self, this._then);

  final RelationshipMetadata _self;
  final $Res Function(RelationshipMetadata) _then;

/// Create a copy of RelationshipMetadata
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? discoveryMethod = null,Object? confidence = null,Object? discoveredAt = freezed,Object? validatedAt = freezed,Object? additionalData = null,Object? notes = null,}) {
  return _then(_self.copyWith(
discoveryMethod: null == discoveryMethod ? _self.discoveryMethod : discoveryMethod // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,validatedAt: freezed == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,additionalData: null == additionalData ? _self.additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RelationshipMetadata].
extension RelationshipMetadataPatterns on RelationshipMetadata {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RelationshipMetadata value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RelationshipMetadata() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RelationshipMetadata value)  $default,){
final _that = this;
switch (_that) {
case _RelationshipMetadata():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RelationshipMetadata value)?  $default,){
final _that = this;
switch (_that) {
case _RelationshipMetadata() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String discoveryMethod,  String confidence,  DateTime? discoveredAt,  DateTime? validatedAt,  Map<String, dynamic> additionalData,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RelationshipMetadata() when $default != null:
return $default(_that.discoveryMethod,_that.confidence,_that.discoveredAt,_that.validatedAt,_that.additionalData,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String discoveryMethod,  String confidence,  DateTime? discoveredAt,  DateTime? validatedAt,  Map<String, dynamic> additionalData,  String notes)  $default,) {final _that = this;
switch (_that) {
case _RelationshipMetadata():
return $default(_that.discoveryMethod,_that.confidence,_that.discoveredAt,_that.validatedAt,_that.additionalData,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String discoveryMethod,  String confidence,  DateTime? discoveredAt,  DateTime? validatedAt,  Map<String, dynamic> additionalData,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _RelationshipMetadata() when $default != null:
return $default(_that.discoveryMethod,_that.confidence,_that.discoveredAt,_that.validatedAt,_that.additionalData,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RelationshipMetadata implements RelationshipMetadata {
  const _RelationshipMetadata({this.discoveryMethod = '', this.confidence = '', this.discoveredAt, this.validatedAt, final  Map<String, dynamic> additionalData = const {}, this.notes = ''}): _additionalData = additionalData;
  factory _RelationshipMetadata.fromJson(Map<String, dynamic> json) => _$RelationshipMetadataFromJson(json);

@override@JsonKey() final  String discoveryMethod;
@override@JsonKey() final  String confidence;
@override final  DateTime? discoveredAt;
@override final  DateTime? validatedAt;
 final  Map<String, dynamic> _additionalData;
@override@JsonKey() Map<String, dynamic> get additionalData {
  if (_additionalData is EqualUnmodifiableMapView) return _additionalData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_additionalData);
}

@override@JsonKey() final  String notes;

/// Create a copy of RelationshipMetadata
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelationshipMetadataCopyWith<_RelationshipMetadata> get copyWith => __$RelationshipMetadataCopyWithImpl<_RelationshipMetadata>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RelationshipMetadataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RelationshipMetadata&&(identical(other.discoveryMethod, discoveryMethod) || other.discoveryMethod == discoveryMethod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.validatedAt, validatedAt) || other.validatedAt == validatedAt)&&const DeepCollectionEquality().equals(other._additionalData, _additionalData)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,discoveryMethod,confidence,discoveredAt,validatedAt,const DeepCollectionEquality().hash(_additionalData),notes);

@override
String toString() {
  return 'RelationshipMetadata(discoveryMethod: $discoveryMethod, confidence: $confidence, discoveredAt: $discoveredAt, validatedAt: $validatedAt, additionalData: $additionalData, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$RelationshipMetadataCopyWith<$Res> implements $RelationshipMetadataCopyWith<$Res> {
  factory _$RelationshipMetadataCopyWith(_RelationshipMetadata value, $Res Function(_RelationshipMetadata) _then) = __$RelationshipMetadataCopyWithImpl;
@override @useResult
$Res call({
 String discoveryMethod, String confidence, DateTime? discoveredAt, DateTime? validatedAt, Map<String, dynamic> additionalData, String notes
});




}
/// @nodoc
class __$RelationshipMetadataCopyWithImpl<$Res>
    implements _$RelationshipMetadataCopyWith<$Res> {
  __$RelationshipMetadataCopyWithImpl(this._self, this._then);

  final _RelationshipMetadata _self;
  final $Res Function(_RelationshipMetadata) _then;

/// Create a copy of RelationshipMetadata
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? discoveryMethod = null,Object? confidence = null,Object? discoveredAt = freezed,Object? validatedAt = freezed,Object? additionalData = null,Object? notes = null,}) {
  return _then(_RelationshipMetadata(
discoveryMethod: null == discoveryMethod ? _self.discoveryMethod : discoveryMethod // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,validatedAt: freezed == validatedAt ? _self.validatedAt : validatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,additionalData: null == additionalData ? _self._additionalData : additionalData // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AssetRelationship {

 String get id; String get sourceAssetId; String get targetAssetId; AssetRelationshipType get relationshipType; bool get isBidirectional; DateTime? get createdAt; DateTime? get updatedAt; RelationshipMetadata? get metadata;
/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetRelationshipCopyWith<AssetRelationship> get copyWith => _$AssetRelationshipCopyWithImpl<AssetRelationship>(this as AssetRelationship, _$identity);

  /// Serializes this AssetRelationship to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetRelationship&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceAssetId, sourceAssetId) || other.sourceAssetId == sourceAssetId)&&(identical(other.targetAssetId, targetAssetId) || other.targetAssetId == targetAssetId)&&(identical(other.relationshipType, relationshipType) || other.relationshipType == relationshipType)&&(identical(other.isBidirectional, isBidirectional) || other.isBidirectional == isBidirectional)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceAssetId,targetAssetId,relationshipType,isBidirectional,createdAt,updatedAt,metadata);

@override
String toString() {
  return 'AssetRelationship(id: $id, sourceAssetId: $sourceAssetId, targetAssetId: $targetAssetId, relationshipType: $relationshipType, isBidirectional: $isBidirectional, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AssetRelationshipCopyWith<$Res>  {
  factory $AssetRelationshipCopyWith(AssetRelationship value, $Res Function(AssetRelationship) _then) = _$AssetRelationshipCopyWithImpl;
@useResult
$Res call({
 String id, String sourceAssetId, String targetAssetId, AssetRelationshipType relationshipType, bool isBidirectional, DateTime? createdAt, DateTime? updatedAt, RelationshipMetadata? metadata
});


$RelationshipMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class _$AssetRelationshipCopyWithImpl<$Res>
    implements $AssetRelationshipCopyWith<$Res> {
  _$AssetRelationshipCopyWithImpl(this._self, this._then);

  final AssetRelationship _self;
  final $Res Function(AssetRelationship) _then;

/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceAssetId = null,Object? targetAssetId = null,Object? relationshipType = null,Object? isBidirectional = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceAssetId: null == sourceAssetId ? _self.sourceAssetId : sourceAssetId // ignore: cast_nullable_to_non_nullable
as String,targetAssetId: null == targetAssetId ? _self.targetAssetId : targetAssetId // ignore: cast_nullable_to_non_nullable
as String,relationshipType: null == relationshipType ? _self.relationshipType : relationshipType // ignore: cast_nullable_to_non_nullable
as AssetRelationshipType,isBidirectional: null == isBidirectional ? _self.isBidirectional : isBidirectional // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as RelationshipMetadata?,
  ));
}
/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RelationshipMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $RelationshipMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceAssetId,  String targetAssetId,  AssetRelationshipType relationshipType,  bool isBidirectional,  DateTime? createdAt,  DateTime? updatedAt,  RelationshipMetadata? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetRelationship() when $default != null:
return $default(_that.id,_that.sourceAssetId,_that.targetAssetId,_that.relationshipType,_that.isBidirectional,_that.createdAt,_that.updatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceAssetId,  String targetAssetId,  AssetRelationshipType relationshipType,  bool isBidirectional,  DateTime? createdAt,  DateTime? updatedAt,  RelationshipMetadata? metadata)  $default,) {final _that = this;
switch (_that) {
case _AssetRelationship():
return $default(_that.id,_that.sourceAssetId,_that.targetAssetId,_that.relationshipType,_that.isBidirectional,_that.createdAt,_that.updatedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceAssetId,  String targetAssetId,  AssetRelationshipType relationshipType,  bool isBidirectional,  DateTime? createdAt,  DateTime? updatedAt,  RelationshipMetadata? metadata)?  $default,) {final _that = this;
switch (_that) {
case _AssetRelationship() when $default != null:
return $default(_that.id,_that.sourceAssetId,_that.targetAssetId,_that.relationshipType,_that.isBidirectional,_that.createdAt,_that.updatedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssetRelationship implements AssetRelationship {
  const _AssetRelationship({required this.id, required this.sourceAssetId, required this.targetAssetId, required this.relationshipType, this.isBidirectional = false, this.createdAt, this.updatedAt, this.metadata});
  factory _AssetRelationship.fromJson(Map<String, dynamic> json) => _$AssetRelationshipFromJson(json);

@override final  String id;
@override final  String sourceAssetId;
@override final  String targetAssetId;
@override final  AssetRelationshipType relationshipType;
@override@JsonKey() final  bool isBidirectional;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;
@override final  RelationshipMetadata? metadata;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetRelationship&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceAssetId, sourceAssetId) || other.sourceAssetId == sourceAssetId)&&(identical(other.targetAssetId, targetAssetId) || other.targetAssetId == targetAssetId)&&(identical(other.relationshipType, relationshipType) || other.relationshipType == relationshipType)&&(identical(other.isBidirectional, isBidirectional) || other.isBidirectional == isBidirectional)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.metadata, metadata) || other.metadata == metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceAssetId,targetAssetId,relationshipType,isBidirectional,createdAt,updatedAt,metadata);

@override
String toString() {
  return 'AssetRelationship(id: $id, sourceAssetId: $sourceAssetId, targetAssetId: $targetAssetId, relationshipType: $relationshipType, isBidirectional: $isBidirectional, createdAt: $createdAt, updatedAt: $updatedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AssetRelationshipCopyWith<$Res> implements $AssetRelationshipCopyWith<$Res> {
  factory _$AssetRelationshipCopyWith(_AssetRelationship value, $Res Function(_AssetRelationship) _then) = __$AssetRelationshipCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceAssetId, String targetAssetId, AssetRelationshipType relationshipType, bool isBidirectional, DateTime? createdAt, DateTime? updatedAt, RelationshipMetadata? metadata
});


@override $RelationshipMetadataCopyWith<$Res>? get metadata;

}
/// @nodoc
class __$AssetRelationshipCopyWithImpl<$Res>
    implements _$AssetRelationshipCopyWith<$Res> {
  __$AssetRelationshipCopyWithImpl(this._self, this._then);

  final _AssetRelationship _self;
  final $Res Function(_AssetRelationship) _then;

/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceAssetId = null,Object? targetAssetId = null,Object? relationshipType = null,Object? isBidirectional = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? metadata = freezed,}) {
  return _then(_AssetRelationship(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceAssetId: null == sourceAssetId ? _self.sourceAssetId : sourceAssetId // ignore: cast_nullable_to_non_nullable
as String,targetAssetId: null == targetAssetId ? _self.targetAssetId : targetAssetId // ignore: cast_nullable_to_non_nullable
as String,relationshipType: null == relationshipType ? _self.relationshipType : relationshipType // ignore: cast_nullable_to_non_nullable
as AssetRelationshipType,isBidirectional: null == isBidirectional ? _self.isBidirectional : isBidirectional // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as RelationshipMetadata?,
  ));
}

/// Create a copy of AssetRelationship
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RelationshipMetadataCopyWith<$Res>? get metadata {
    if (_self.metadata == null) {
    return null;
  }

  return $RelationshipMetadataCopyWith<$Res>(_self.metadata!, (value) {
    return _then(_self.copyWith(metadata: value));
  });
}
}

// dart format on
