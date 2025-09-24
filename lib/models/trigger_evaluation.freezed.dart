// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trigger_evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TriggerMatch {

/// Unique identifier for this trigger match
 String get id;/// ID of the trigger that was evaluated
 String get triggerId;/// ID of the methodology template containing the trigger
 String get templateId;/// ID of the asset that was evaluated
 String get assetId;/// Whether the trigger condition matched
 bool get matched;/// Values extracted from the asset during evaluation
 Map<String, dynamic> get extractedValues;/// Confidence score of the match (0.0 - 1.0)
 double get confidence;/// When this evaluation was performed
 DateTime get evaluatedAt;/// Priority of this trigger (from the trigger definition)
 int get priority;/// Error message if evaluation failed
 String? get error;/// Debug information about the evaluation
 Map<String, dynamic> get debugInfo;
/// Create a copy of TriggerMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerMatchCopyWith<TriggerMatch> get copyWith => _$TriggerMatchCopyWithImpl<TriggerMatch>(this as TriggerMatch, _$identity);

  /// Serializes this TriggerMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerMatch&&(identical(other.id, id) || other.id == id)&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.matched, matched) || other.matched == matched)&&const DeepCollectionEquality().equals(other.extractedValues, extractedValues)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.debugInfo, debugInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,triggerId,templateId,assetId,matched,const DeepCollectionEquality().hash(extractedValues),confidence,evaluatedAt,priority,error,const DeepCollectionEquality().hash(debugInfo));

@override
String toString() {
  return 'TriggerMatch(id: $id, triggerId: $triggerId, templateId: $templateId, assetId: $assetId, matched: $matched, extractedValues: $extractedValues, confidence: $confidence, evaluatedAt: $evaluatedAt, priority: $priority, error: $error, debugInfo: $debugInfo)';
}


}

/// @nodoc
abstract mixin class $TriggerMatchCopyWith<$Res>  {
  factory $TriggerMatchCopyWith(TriggerMatch value, $Res Function(TriggerMatch) _then) = _$TriggerMatchCopyWithImpl;
@useResult
$Res call({
 String id, String triggerId, String templateId, String assetId, bool matched, Map<String, dynamic> extractedValues, double confidence, DateTime evaluatedAt, int priority, String? error, Map<String, dynamic> debugInfo
});




}
/// @nodoc
class _$TriggerMatchCopyWithImpl<$Res>
    implements $TriggerMatchCopyWith<$Res> {
  _$TriggerMatchCopyWithImpl(this._self, this._then);

  final TriggerMatch _self;
  final $Res Function(TriggerMatch) _then;

/// Create a copy of TriggerMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? triggerId = null,Object? templateId = null,Object? assetId = null,Object? matched = null,Object? extractedValues = null,Object? confidence = null,Object? evaluatedAt = null,Object? priority = null,Object? error = freezed,Object? debugInfo = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,extractedValues: null == extractedValues ? _self.extractedValues : extractedValues // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,debugInfo: null == debugInfo ? _self.debugInfo : debugInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerMatch].
extension TriggerMatchPatterns on TriggerMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerMatch value)  $default,){
final _that = this;
switch (_that) {
case _TriggerMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerMatch value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String triggerId,  String templateId,  String assetId,  bool matched,  Map<String, dynamic> extractedValues,  double confidence,  DateTime evaluatedAt,  int priority,  String? error,  Map<String, dynamic> debugInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerMatch() when $default != null:
return $default(_that.id,_that.triggerId,_that.templateId,_that.assetId,_that.matched,_that.extractedValues,_that.confidence,_that.evaluatedAt,_that.priority,_that.error,_that.debugInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String triggerId,  String templateId,  String assetId,  bool matched,  Map<String, dynamic> extractedValues,  double confidence,  DateTime evaluatedAt,  int priority,  String? error,  Map<String, dynamic> debugInfo)  $default,) {final _that = this;
switch (_that) {
case _TriggerMatch():
return $default(_that.id,_that.triggerId,_that.templateId,_that.assetId,_that.matched,_that.extractedValues,_that.confidence,_that.evaluatedAt,_that.priority,_that.error,_that.debugInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String triggerId,  String templateId,  String assetId,  bool matched,  Map<String, dynamic> extractedValues,  double confidence,  DateTime evaluatedAt,  int priority,  String? error,  Map<String, dynamic> debugInfo)?  $default,) {final _that = this;
switch (_that) {
case _TriggerMatch() when $default != null:
return $default(_that.id,_that.triggerId,_that.templateId,_that.assetId,_that.matched,_that.extractedValues,_that.confidence,_that.evaluatedAt,_that.priority,_that.error,_that.debugInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerMatch implements TriggerMatch {
  const _TriggerMatch({required this.id, required this.triggerId, required this.templateId, required this.assetId, required this.matched, required final  Map<String, dynamic> extractedValues, this.confidence = 1.0, required this.evaluatedAt, this.priority = 5, this.error, final  Map<String, dynamic> debugInfo = const {}}): _extractedValues = extractedValues,_debugInfo = debugInfo;
  factory _TriggerMatch.fromJson(Map<String, dynamic> json) => _$TriggerMatchFromJson(json);

/// Unique identifier for this trigger match
@override final  String id;
/// ID of the trigger that was evaluated
@override final  String triggerId;
/// ID of the methodology template containing the trigger
@override final  String templateId;
/// ID of the asset that was evaluated
@override final  String assetId;
/// Whether the trigger condition matched
@override final  bool matched;
/// Values extracted from the asset during evaluation
 final  Map<String, dynamic> _extractedValues;
/// Values extracted from the asset during evaluation
@override Map<String, dynamic> get extractedValues {
  if (_extractedValues is EqualUnmodifiableMapView) return _extractedValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extractedValues);
}

/// Confidence score of the match (0.0 - 1.0)
@override@JsonKey() final  double confidence;
/// When this evaluation was performed
@override final  DateTime evaluatedAt;
/// Priority of this trigger (from the trigger definition)
@override@JsonKey() final  int priority;
/// Error message if evaluation failed
@override final  String? error;
/// Debug information about the evaluation
 final  Map<String, dynamic> _debugInfo;
/// Debug information about the evaluation
@override@JsonKey() Map<String, dynamic> get debugInfo {
  if (_debugInfo is EqualUnmodifiableMapView) return _debugInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_debugInfo);
}


/// Create a copy of TriggerMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerMatchCopyWith<_TriggerMatch> get copyWith => __$TriggerMatchCopyWithImpl<_TriggerMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerMatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerMatch&&(identical(other.id, id) || other.id == id)&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.matched, matched) || other.matched == matched)&&const DeepCollectionEquality().equals(other._extractedValues, _extractedValues)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._debugInfo, _debugInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,triggerId,templateId,assetId,matched,const DeepCollectionEquality().hash(_extractedValues),confidence,evaluatedAt,priority,error,const DeepCollectionEquality().hash(_debugInfo));

@override
String toString() {
  return 'TriggerMatch(id: $id, triggerId: $triggerId, templateId: $templateId, assetId: $assetId, matched: $matched, extractedValues: $extractedValues, confidence: $confidence, evaluatedAt: $evaluatedAt, priority: $priority, error: $error, debugInfo: $debugInfo)';
}


}

/// @nodoc
abstract mixin class _$TriggerMatchCopyWith<$Res> implements $TriggerMatchCopyWith<$Res> {
  factory _$TriggerMatchCopyWith(_TriggerMatch value, $Res Function(_TriggerMatch) _then) = __$TriggerMatchCopyWithImpl;
@override @useResult
$Res call({
 String id, String triggerId, String templateId, String assetId, bool matched, Map<String, dynamic> extractedValues, double confidence, DateTime evaluatedAt, int priority, String? error, Map<String, dynamic> debugInfo
});




}
/// @nodoc
class __$TriggerMatchCopyWithImpl<$Res>
    implements _$TriggerMatchCopyWith<$Res> {
  __$TriggerMatchCopyWithImpl(this._self, this._then);

  final _TriggerMatch _self;
  final $Res Function(_TriggerMatch) _then;

/// Create a copy of TriggerMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? triggerId = null,Object? templateId = null,Object? assetId = null,Object? matched = null,Object? extractedValues = null,Object? confidence = null,Object? evaluatedAt = null,Object? priority = null,Object? error = freezed,Object? debugInfo = null,}) {
  return _then(_TriggerMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,extractedValues: null == extractedValues ? _self._extractedValues : extractedValues // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,debugInfo: null == debugInfo ? _self._debugInfo : debugInfo // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$ParameterResolution {

/// Name of the parameter
 String get name;/// Type of the parameter
 ParameterType get type;/// Resolved value for the parameter
 dynamic get value;/// Source where the value was resolved from
 ParameterSource get source;/// Whether this parameter is required
 bool get required;/// Whether the parameter was successfully resolved
 bool get resolved;/// Error message if resolution failed
 String? get error;/// When this parameter was resolved
 DateTime get resolvedAt;/// Additional metadata about the resolution
 Map<String, dynamic> get metadata;
/// Create a copy of ParameterResolution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParameterResolutionCopyWith<ParameterResolution> get copyWith => _$ParameterResolutionCopyWithImpl<ParameterResolution>(this as ParameterResolution, _$identity);

  /// Serializes this ParameterResolution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParameterResolution&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.source, source) || other.source == source)&&(identical(other.required, required) || other.required == required)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.error, error) || other.error == error)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(value),source,required,resolved,error,resolvedAt,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'ParameterResolution(name: $name, type: $type, value: $value, source: $source, required: $required, resolved: $resolved, error: $error, resolvedAt: $resolvedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $ParameterResolutionCopyWith<$Res>  {
  factory $ParameterResolutionCopyWith(ParameterResolution value, $Res Function(ParameterResolution) _then) = _$ParameterResolutionCopyWithImpl;
@useResult
$Res call({
 String name, ParameterType type, dynamic value, ParameterSource source, bool required, bool resolved, String? error, DateTime resolvedAt, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$ParameterResolutionCopyWithImpl<$Res>
    implements $ParameterResolutionCopyWith<$Res> {
  _$ParameterResolutionCopyWithImpl(this._self, this._then);

  final ParameterResolution _self;
  final $Res Function(ParameterResolution) _then;

/// Create a copy of ParameterResolution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? value = freezed,Object? source = null,Object? required = null,Object? resolved = null,Object? error = freezed,Object? resolvedAt = null,Object? metadata = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ParameterType,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ParameterSource,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: null == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [ParameterResolution].
extension ParameterResolutionPatterns on ParameterResolution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParameterResolution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParameterResolution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParameterResolution value)  $default,){
final _that = this;
switch (_that) {
case _ParameterResolution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParameterResolution value)?  $default,){
final _that = this;
switch (_that) {
case _ParameterResolution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  ParameterType type,  dynamic value,  ParameterSource source,  bool required,  bool resolved,  String? error,  DateTime resolvedAt,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParameterResolution() when $default != null:
return $default(_that.name,_that.type,_that.value,_that.source,_that.required,_that.resolved,_that.error,_that.resolvedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  ParameterType type,  dynamic value,  ParameterSource source,  bool required,  bool resolved,  String? error,  DateTime resolvedAt,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _ParameterResolution():
return $default(_that.name,_that.type,_that.value,_that.source,_that.required,_that.resolved,_that.error,_that.resolvedAt,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  ParameterType type,  dynamic value,  ParameterSource source,  bool required,  bool resolved,  String? error,  DateTime resolvedAt,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _ParameterResolution() when $default != null:
return $default(_that.name,_that.type,_that.value,_that.source,_that.required,_that.resolved,_that.error,_that.resolvedAt,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParameterResolution implements ParameterResolution {
  const _ParameterResolution({required this.name, required this.type, required this.value, required this.source, this.required = false, this.resolved = true, this.error, required this.resolvedAt, final  Map<String, dynamic> metadata = const {}}): _metadata = metadata;
  factory _ParameterResolution.fromJson(Map<String, dynamic> json) => _$ParameterResolutionFromJson(json);

/// Name of the parameter
@override final  String name;
/// Type of the parameter
@override final  ParameterType type;
/// Resolved value for the parameter
@override final  dynamic value;
/// Source where the value was resolved from
@override final  ParameterSource source;
/// Whether this parameter is required
@override@JsonKey() final  bool required;
/// Whether the parameter was successfully resolved
@override@JsonKey() final  bool resolved;
/// Error message if resolution failed
@override final  String? error;
/// When this parameter was resolved
@override final  DateTime resolvedAt;
/// Additional metadata about the resolution
 final  Map<String, dynamic> _metadata;
/// Additional metadata about the resolution
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of ParameterResolution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParameterResolutionCopyWith<_ParameterResolution> get copyWith => __$ParameterResolutionCopyWithImpl<_ParameterResolution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParameterResolutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParameterResolution&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.source, source) || other.source == source)&&(identical(other.required, required) || other.required == required)&&(identical(other.resolved, resolved) || other.resolved == resolved)&&(identical(other.error, error) || other.error == error)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,const DeepCollectionEquality().hash(value),source,required,resolved,error,resolvedAt,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'ParameterResolution(name: $name, type: $type, value: $value, source: $source, required: $required, resolved: $resolved, error: $error, resolvedAt: $resolvedAt, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$ParameterResolutionCopyWith<$Res> implements $ParameterResolutionCopyWith<$Res> {
  factory _$ParameterResolutionCopyWith(_ParameterResolution value, $Res Function(_ParameterResolution) _then) = __$ParameterResolutionCopyWithImpl;
@override @useResult
$Res call({
 String name, ParameterType type, dynamic value, ParameterSource source, bool required, bool resolved, String? error, DateTime resolvedAt, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$ParameterResolutionCopyWithImpl<$Res>
    implements _$ParameterResolutionCopyWith<$Res> {
  __$ParameterResolutionCopyWithImpl(this._self, this._then);

  final _ParameterResolution _self;
  final $Res Function(_ParameterResolution) _then;

/// Create a copy of ParameterResolution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? value = freezed,Object? source = null,Object? required = null,Object? resolved = null,Object? error = freezed,Object? resolvedAt = null,Object? metadata = null,}) {
  return _then(_ParameterResolution(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ParameterType,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ParameterSource,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,resolved: null == resolved ? _self.resolved : resolved // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,resolvedAt: null == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$TriggerConditionResult {

/// The original condition expression
 String get expression;/// Whether the condition evaluated to true
 bool get result;/// Values used in the evaluation
 Map<String, dynamic> get variables;/// Execution time in milliseconds
 int get executionTimeMs;/// Error message if evaluation failed
 String? get error;/// Debug trace of the evaluation
 List<String> get debugTrace;
/// Create a copy of TriggerConditionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerConditionResultCopyWith<TriggerConditionResult> get copyWith => _$TriggerConditionResultCopyWithImpl<TriggerConditionResult>(this as TriggerConditionResult, _$identity);

  /// Serializes this TriggerConditionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerConditionResult&&(identical(other.expression, expression) || other.expression == expression)&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.executionTimeMs, executionTimeMs) || other.executionTimeMs == executionTimeMs)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.debugTrace, debugTrace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expression,result,const DeepCollectionEquality().hash(variables),executionTimeMs,error,const DeepCollectionEquality().hash(debugTrace));

@override
String toString() {
  return 'TriggerConditionResult(expression: $expression, result: $result, variables: $variables, executionTimeMs: $executionTimeMs, error: $error, debugTrace: $debugTrace)';
}


}

/// @nodoc
abstract mixin class $TriggerConditionResultCopyWith<$Res>  {
  factory $TriggerConditionResultCopyWith(TriggerConditionResult value, $Res Function(TriggerConditionResult) _then) = _$TriggerConditionResultCopyWithImpl;
@useResult
$Res call({
 String expression, bool result, Map<String, dynamic> variables, int executionTimeMs, String? error, List<String> debugTrace
});




}
/// @nodoc
class _$TriggerConditionResultCopyWithImpl<$Res>
    implements $TriggerConditionResultCopyWith<$Res> {
  _$TriggerConditionResultCopyWithImpl(this._self, this._then);

  final TriggerConditionResult _self;
  final $Res Function(TriggerConditionResult) _then;

/// Create a copy of TriggerConditionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expression = null,Object? result = null,Object? variables = null,Object? executionTimeMs = null,Object? error = freezed,Object? debugTrace = null,}) {
  return _then(_self.copyWith(
expression: null == expression ? _self.expression : expression // ignore: cast_nullable_to_non_nullable
as String,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as bool,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,executionTimeMs: null == executionTimeMs ? _self.executionTimeMs : executionTimeMs // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,debugTrace: null == debugTrace ? _self.debugTrace : debugTrace // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerConditionResult].
extension TriggerConditionResultPatterns on TriggerConditionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerConditionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerConditionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerConditionResult value)  $default,){
final _that = this;
switch (_that) {
case _TriggerConditionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerConditionResult value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerConditionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String expression,  bool result,  Map<String, dynamic> variables,  int executionTimeMs,  String? error,  List<String> debugTrace)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerConditionResult() when $default != null:
return $default(_that.expression,_that.result,_that.variables,_that.executionTimeMs,_that.error,_that.debugTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String expression,  bool result,  Map<String, dynamic> variables,  int executionTimeMs,  String? error,  List<String> debugTrace)  $default,) {final _that = this;
switch (_that) {
case _TriggerConditionResult():
return $default(_that.expression,_that.result,_that.variables,_that.executionTimeMs,_that.error,_that.debugTrace);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String expression,  bool result,  Map<String, dynamic> variables,  int executionTimeMs,  String? error,  List<String> debugTrace)?  $default,) {final _that = this;
switch (_that) {
case _TriggerConditionResult() when $default != null:
return $default(_that.expression,_that.result,_that.variables,_that.executionTimeMs,_that.error,_that.debugTrace);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerConditionResult implements TriggerConditionResult {
  const _TriggerConditionResult({required this.expression, required this.result, required final  Map<String, dynamic> variables, this.executionTimeMs = 0, this.error, final  List<String> debugTrace = const []}): _variables = variables,_debugTrace = debugTrace;
  factory _TriggerConditionResult.fromJson(Map<String, dynamic> json) => _$TriggerConditionResultFromJson(json);

/// The original condition expression
@override final  String expression;
/// Whether the condition evaluated to true
@override final  bool result;
/// Values used in the evaluation
 final  Map<String, dynamic> _variables;
/// Values used in the evaluation
@override Map<String, dynamic> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

/// Execution time in milliseconds
@override@JsonKey() final  int executionTimeMs;
/// Error message if evaluation failed
@override final  String? error;
/// Debug trace of the evaluation
 final  List<String> _debugTrace;
/// Debug trace of the evaluation
@override@JsonKey() List<String> get debugTrace {
  if (_debugTrace is EqualUnmodifiableListView) return _debugTrace;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_debugTrace);
}


/// Create a copy of TriggerConditionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerConditionResultCopyWith<_TriggerConditionResult> get copyWith => __$TriggerConditionResultCopyWithImpl<_TriggerConditionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerConditionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerConditionResult&&(identical(other.expression, expression) || other.expression == expression)&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.executionTimeMs, executionTimeMs) || other.executionTimeMs == executionTimeMs)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._debugTrace, _debugTrace));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,expression,result,const DeepCollectionEquality().hash(_variables),executionTimeMs,error,const DeepCollectionEquality().hash(_debugTrace));

@override
String toString() {
  return 'TriggerConditionResult(expression: $expression, result: $result, variables: $variables, executionTimeMs: $executionTimeMs, error: $error, debugTrace: $debugTrace)';
}


}

/// @nodoc
abstract mixin class _$TriggerConditionResultCopyWith<$Res> implements $TriggerConditionResultCopyWith<$Res> {
  factory _$TriggerConditionResultCopyWith(_TriggerConditionResult value, $Res Function(_TriggerConditionResult) _then) = __$TriggerConditionResultCopyWithImpl;
@override @useResult
$Res call({
 String expression, bool result, Map<String, dynamic> variables, int executionTimeMs, String? error, List<String> debugTrace
});




}
/// @nodoc
class __$TriggerConditionResultCopyWithImpl<$Res>
    implements _$TriggerConditionResultCopyWith<$Res> {
  __$TriggerConditionResultCopyWithImpl(this._self, this._then);

  final _TriggerConditionResult _self;
  final $Res Function(_TriggerConditionResult) _then;

/// Create a copy of TriggerConditionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expression = null,Object? result = null,Object? variables = null,Object? executionTimeMs = null,Object? error = freezed,Object? debugTrace = null,}) {
  return _then(_TriggerConditionResult(
expression: null == expression ? _self.expression : expression // ignore: cast_nullable_to_non_nullable
as String,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as bool,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,executionTimeMs: null == executionTimeMs ? _self.executionTimeMs : executionTimeMs // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,debugTrace: null == debugTrace ? _self._debugTrace : debugTrace // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TriggerContext {

/// Variables available in the context
 Map<String, dynamic> get variables;/// Asset being evaluated
 Map<String, dynamic>? get asset;/// Additional context data
 Map<String, dynamic> get metadata;
/// Create a copy of TriggerContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerContextCopyWith<TriggerContext> get copyWith => _$TriggerContextCopyWithImpl<TriggerContext>(this as TriggerContext, _$identity);

  /// Serializes this TriggerContext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerContext&&const DeepCollectionEquality().equals(other.variables, variables)&&const DeepCollectionEquality().equals(other.asset, asset)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(variables),const DeepCollectionEquality().hash(asset),const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'TriggerContext(variables: $variables, asset: $asset, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $TriggerContextCopyWith<$Res>  {
  factory $TriggerContextCopyWith(TriggerContext value, $Res Function(TriggerContext) _then) = _$TriggerContextCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> variables, Map<String, dynamic>? asset, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$TriggerContextCopyWithImpl<$Res>
    implements $TriggerContextCopyWith<$Res> {
  _$TriggerContextCopyWithImpl(this._self, this._then);

  final TriggerContext _self;
  final $Res Function(TriggerContext) _then;

/// Create a copy of TriggerContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? variables = null,Object? asset = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,asset: freezed == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerContext].
extension TriggerContextPatterns on TriggerContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerContext value)  $default,){
final _that = this;
switch (_that) {
case _TriggerContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerContext value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, dynamic> variables,  Map<String, dynamic>? asset,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerContext() when $default != null:
return $default(_that.variables,_that.asset,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, dynamic> variables,  Map<String, dynamic>? asset,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _TriggerContext():
return $default(_that.variables,_that.asset,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, dynamic> variables,  Map<String, dynamic>? asset,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _TriggerContext() when $default != null:
return $default(_that.variables,_that.asset,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerContext implements TriggerContext {
  const _TriggerContext({final  Map<String, dynamic> variables = const {}, final  Map<String, dynamic>? asset, final  Map<String, dynamic> metadata = const {}}): _variables = variables,_asset = asset,_metadata = metadata;
  factory _TriggerContext.fromJson(Map<String, dynamic> json) => _$TriggerContextFromJson(json);

/// Variables available in the context
 final  Map<String, dynamic> _variables;
/// Variables available in the context
@override@JsonKey() Map<String, dynamic> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

/// Asset being evaluated
 final  Map<String, dynamic>? _asset;
/// Asset being evaluated
@override Map<String, dynamic>? get asset {
  final value = _asset;
  if (value == null) return null;
  if (_asset is EqualUnmodifiableMapView) return _asset;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

/// Additional context data
 final  Map<String, dynamic> _metadata;
/// Additional context data
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of TriggerContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerContextCopyWith<_TriggerContext> get copyWith => __$TriggerContextCopyWithImpl<_TriggerContext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerContextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerContext&&const DeepCollectionEquality().equals(other._variables, _variables)&&const DeepCollectionEquality().equals(other._asset, _asset)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_variables),const DeepCollectionEquality().hash(_asset),const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'TriggerContext(variables: $variables, asset: $asset, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$TriggerContextCopyWith<$Res> implements $TriggerContextCopyWith<$Res> {
  factory _$TriggerContextCopyWith(_TriggerContext value, $Res Function(_TriggerContext) _then) = __$TriggerContextCopyWithImpl;
@override @useResult
$Res call({
 Map<String, dynamic> variables, Map<String, dynamic>? asset, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$TriggerContextCopyWithImpl<$Res>
    implements _$TriggerContextCopyWith<$Res> {
  __$TriggerContextCopyWithImpl(this._self, this._then);

  final _TriggerContext _self;
  final $Res Function(_TriggerContext) _then;

/// Create a copy of TriggerContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? variables = null,Object? asset = freezed,Object? metadata = null,}) {
  return _then(_TriggerContext(
variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,asset: freezed == asset ? _self._asset : asset // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
