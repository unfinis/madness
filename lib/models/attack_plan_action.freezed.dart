// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attack_plan_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TriggerEvent {

/// ID of the trigger that fired
 String get triggerId;/// ID of the asset that triggered this
 String get assetId;/// Name of the asset for display
 String get assetName;/// Type of asset (host, service, etc.)
 String get assetType;/// The conditions that were matched
 Map<String, dynamic> get matchedConditions;/// Values extracted from the trigger evaluation
 Map<String, dynamic> get extractedValues;/// When this trigger was evaluated
 DateTime get evaluatedAt;/// Confidence of the match (0.0 - 1.0)
 double get confidence;
/// Create a copy of TriggerEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerEventCopyWith<TriggerEvent> get copyWith => _$TriggerEventCopyWithImpl<TriggerEvent>(this as TriggerEvent, _$identity);

  /// Serializes this TriggerEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerEvent&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&const DeepCollectionEquality().equals(other.matchedConditions, matchedConditions)&&const DeepCollectionEquality().equals(other.extractedValues, extractedValues)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,triggerId,assetId,assetName,assetType,const DeepCollectionEquality().hash(matchedConditions),const DeepCollectionEquality().hash(extractedValues),evaluatedAt,confidence);

@override
String toString() {
  return 'TriggerEvent(triggerId: $triggerId, assetId: $assetId, assetName: $assetName, assetType: $assetType, matchedConditions: $matchedConditions, extractedValues: $extractedValues, evaluatedAt: $evaluatedAt, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $TriggerEventCopyWith<$Res>  {
  factory $TriggerEventCopyWith(TriggerEvent value, $Res Function(TriggerEvent) _then) = _$TriggerEventCopyWithImpl;
@useResult
$Res call({
 String triggerId, String assetId, String assetName, String assetType, Map<String, dynamic> matchedConditions, Map<String, dynamic> extractedValues, DateTime evaluatedAt, double confidence
});




}
/// @nodoc
class _$TriggerEventCopyWithImpl<$Res>
    implements $TriggerEventCopyWith<$Res> {
  _$TriggerEventCopyWithImpl(this._self, this._then);

  final TriggerEvent _self;
  final $Res Function(TriggerEvent) _then;

/// Create a copy of TriggerEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? triggerId = null,Object? assetId = null,Object? assetName = null,Object? assetType = null,Object? matchedConditions = null,Object? extractedValues = null,Object? evaluatedAt = null,Object? confidence = null,}) {
  return _then(_self.copyWith(
triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as String,matchedConditions: null == matchedConditions ? _self.matchedConditions : matchedConditions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,extractedValues: null == extractedValues ? _self.extractedValues : extractedValues // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerEvent].
extension TriggerEventPatterns on TriggerEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerEvent value)  $default,){
final _that = this;
switch (_that) {
case _TriggerEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerEvent value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String triggerId,  String assetId,  String assetName,  String assetType,  Map<String, dynamic> matchedConditions,  Map<String, dynamic> extractedValues,  DateTime evaluatedAt,  double confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerEvent() when $default != null:
return $default(_that.triggerId,_that.assetId,_that.assetName,_that.assetType,_that.matchedConditions,_that.extractedValues,_that.evaluatedAt,_that.confidence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String triggerId,  String assetId,  String assetName,  String assetType,  Map<String, dynamic> matchedConditions,  Map<String, dynamic> extractedValues,  DateTime evaluatedAt,  double confidence)  $default,) {final _that = this;
switch (_that) {
case _TriggerEvent():
return $default(_that.triggerId,_that.assetId,_that.assetName,_that.assetType,_that.matchedConditions,_that.extractedValues,_that.evaluatedAt,_that.confidence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String triggerId,  String assetId,  String assetName,  String assetType,  Map<String, dynamic> matchedConditions,  Map<String, dynamic> extractedValues,  DateTime evaluatedAt,  double confidence)?  $default,) {final _that = this;
switch (_that) {
case _TriggerEvent() when $default != null:
return $default(_that.triggerId,_that.assetId,_that.assetName,_that.assetType,_that.matchedConditions,_that.extractedValues,_that.evaluatedAt,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerEvent implements TriggerEvent {
  const _TriggerEvent({required this.triggerId, required this.assetId, required this.assetName, required this.assetType, required final  Map<String, dynamic> matchedConditions, required final  Map<String, dynamic> extractedValues, required this.evaluatedAt, this.confidence = 1.0}): _matchedConditions = matchedConditions,_extractedValues = extractedValues;
  factory _TriggerEvent.fromJson(Map<String, dynamic> json) => _$TriggerEventFromJson(json);

/// ID of the trigger that fired
@override final  String triggerId;
/// ID of the asset that triggered this
@override final  String assetId;
/// Name of the asset for display
@override final  String assetName;
/// Type of asset (host, service, etc.)
@override final  String assetType;
/// The conditions that were matched
 final  Map<String, dynamic> _matchedConditions;
/// The conditions that were matched
@override Map<String, dynamic> get matchedConditions {
  if (_matchedConditions is EqualUnmodifiableMapView) return _matchedConditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_matchedConditions);
}

/// Values extracted from the trigger evaluation
 final  Map<String, dynamic> _extractedValues;
/// Values extracted from the trigger evaluation
@override Map<String, dynamic> get extractedValues {
  if (_extractedValues is EqualUnmodifiableMapView) return _extractedValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extractedValues);
}

/// When this trigger was evaluated
@override final  DateTime evaluatedAt;
/// Confidence of the match (0.0 - 1.0)
@override@JsonKey() final  double confidence;

/// Create a copy of TriggerEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerEventCopyWith<_TriggerEvent> get copyWith => __$TriggerEventCopyWithImpl<_TriggerEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerEvent&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&(identical(other.assetName, assetName) || other.assetName == assetName)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&const DeepCollectionEquality().equals(other._matchedConditions, _matchedConditions)&&const DeepCollectionEquality().equals(other._extractedValues, _extractedValues)&&(identical(other.evaluatedAt, evaluatedAt) || other.evaluatedAt == evaluatedAt)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,triggerId,assetId,assetName,assetType,const DeepCollectionEquality().hash(_matchedConditions),const DeepCollectionEquality().hash(_extractedValues),evaluatedAt,confidence);

@override
String toString() {
  return 'TriggerEvent(triggerId: $triggerId, assetId: $assetId, assetName: $assetName, assetType: $assetType, matchedConditions: $matchedConditions, extractedValues: $extractedValues, evaluatedAt: $evaluatedAt, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$TriggerEventCopyWith<$Res> implements $TriggerEventCopyWith<$Res> {
  factory _$TriggerEventCopyWith(_TriggerEvent value, $Res Function(_TriggerEvent) _then) = __$TriggerEventCopyWithImpl;
@override @useResult
$Res call({
 String triggerId, String assetId, String assetName, String assetType, Map<String, dynamic> matchedConditions, Map<String, dynamic> extractedValues, DateTime evaluatedAt, double confidence
});




}
/// @nodoc
class __$TriggerEventCopyWithImpl<$Res>
    implements _$TriggerEventCopyWith<$Res> {
  __$TriggerEventCopyWithImpl(this._self, this._then);

  final _TriggerEvent _self;
  final $Res Function(_TriggerEvent) _then;

/// Create a copy of TriggerEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? triggerId = null,Object? assetId = null,Object? assetName = null,Object? assetType = null,Object? matchedConditions = null,Object? extractedValues = null,Object? evaluatedAt = null,Object? confidence = null,}) {
  return _then(_TriggerEvent(
triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,assetName: null == assetName ? _self.assetName : assetName // ignore: cast_nullable_to_non_nullable
as String,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as String,matchedConditions: null == matchedConditions ? _self._matchedConditions : matchedConditions // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,extractedValues: null == extractedValues ? _self._extractedValues : extractedValues // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,evaluatedAt: null == evaluatedAt ? _self.evaluatedAt : evaluatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ActionTool {

/// Name of the tool
 String get name;/// Description of what the tool does
 String get description;/// Installation command or link
 String? get installation;/// Whether the tool is required or optional
 bool get required;/// Alternative tools that can be used
 List<String> get alternatives;
/// Create a copy of ActionTool
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionToolCopyWith<ActionTool> get copyWith => _$ActionToolCopyWithImpl<ActionTool>(this as ActionTool, _$identity);

  /// Serializes this ActionTool to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionTool&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.installation, installation) || other.installation == installation)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.alternatives, alternatives));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,installation,required,const DeepCollectionEquality().hash(alternatives));

@override
String toString() {
  return 'ActionTool(name: $name, description: $description, installation: $installation, required: $required, alternatives: $alternatives)';
}


}

/// @nodoc
abstract mixin class $ActionToolCopyWith<$Res>  {
  factory $ActionToolCopyWith(ActionTool value, $Res Function(ActionTool) _then) = _$ActionToolCopyWithImpl;
@useResult
$Res call({
 String name, String description, String? installation, bool required, List<String> alternatives
});




}
/// @nodoc
class _$ActionToolCopyWithImpl<$Res>
    implements $ActionToolCopyWith<$Res> {
  _$ActionToolCopyWithImpl(this._self, this._then);

  final ActionTool _self;
  final $Res Function(ActionTool) _then;

/// Create a copy of ActionTool
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? installation = freezed,Object? required = null,Object? alternatives = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,installation: freezed == installation ? _self.installation : installation // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,alternatives: null == alternatives ? _self.alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionTool].
extension ActionToolPatterns on ActionTool {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionTool value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionTool() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionTool value)  $default,){
final _that = this;
switch (_that) {
case _ActionTool():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionTool value)?  $default,){
final _that = this;
switch (_that) {
case _ActionTool() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  String? installation,  bool required,  List<String> alternatives)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionTool() when $default != null:
return $default(_that.name,_that.description,_that.installation,_that.required,_that.alternatives);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  String? installation,  bool required,  List<String> alternatives)  $default,) {final _that = this;
switch (_that) {
case _ActionTool():
return $default(_that.name,_that.description,_that.installation,_that.required,_that.alternatives);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  String? installation,  bool required,  List<String> alternatives)?  $default,) {final _that = this;
switch (_that) {
case _ActionTool() when $default != null:
return $default(_that.name,_that.description,_that.installation,_that.required,_that.alternatives);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionTool implements ActionTool {
  const _ActionTool({required this.name, required this.description, this.installation, this.required = true, final  List<String> alternatives = const []}): _alternatives = alternatives;
  factory _ActionTool.fromJson(Map<String, dynamic> json) => _$ActionToolFromJson(json);

/// Name of the tool
@override final  String name;
/// Description of what the tool does
@override final  String description;
/// Installation command or link
@override final  String? installation;
/// Whether the tool is required or optional
@override@JsonKey() final  bool required;
/// Alternative tools that can be used
 final  List<String> _alternatives;
/// Alternative tools that can be used
@override@JsonKey() List<String> get alternatives {
  if (_alternatives is EqualUnmodifiableListView) return _alternatives;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alternatives);
}


/// Create a copy of ActionTool
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionToolCopyWith<_ActionTool> get copyWith => __$ActionToolCopyWithImpl<_ActionTool>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionToolToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionTool&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.installation, installation) || other.installation == installation)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other._alternatives, _alternatives));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,installation,required,const DeepCollectionEquality().hash(_alternatives));

@override
String toString() {
  return 'ActionTool(name: $name, description: $description, installation: $installation, required: $required, alternatives: $alternatives)';
}


}

/// @nodoc
abstract mixin class _$ActionToolCopyWith<$Res> implements $ActionToolCopyWith<$Res> {
  factory _$ActionToolCopyWith(_ActionTool value, $Res Function(_ActionTool) _then) = __$ActionToolCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, String? installation, bool required, List<String> alternatives
});




}
/// @nodoc
class __$ActionToolCopyWithImpl<$Res>
    implements _$ActionToolCopyWith<$Res> {
  __$ActionToolCopyWithImpl(this._self, this._then);

  final _ActionTool _self;
  final $Res Function(_ActionTool) _then;

/// Create a copy of ActionTool
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? installation = freezed,Object? required = null,Object? alternatives = null,}) {
  return _then(_ActionTool(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,installation: freezed == installation ? _self.installation : installation // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,alternatives: null == alternatives ? _self._alternatives : alternatives // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ActionEquipment {

/// Name of the equipment
 String get name;/// Description of the equipment
 String get description;/// Whether the equipment is required or optional
 bool get required;/// Specifications or model details
 String? get specifications;
/// Create a copy of ActionEquipment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionEquipmentCopyWith<ActionEquipment> get copyWith => _$ActionEquipmentCopyWithImpl<ActionEquipment>(this as ActionEquipment, _$identity);

  /// Serializes this ActionEquipment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionEquipment&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.required, required) || other.required == required)&&(identical(other.specifications, specifications) || other.specifications == specifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,required,specifications);

@override
String toString() {
  return 'ActionEquipment(name: $name, description: $description, required: $required, specifications: $specifications)';
}


}

/// @nodoc
abstract mixin class $ActionEquipmentCopyWith<$Res>  {
  factory $ActionEquipmentCopyWith(ActionEquipment value, $Res Function(ActionEquipment) _then) = _$ActionEquipmentCopyWithImpl;
@useResult
$Res call({
 String name, String description, bool required, String? specifications
});




}
/// @nodoc
class _$ActionEquipmentCopyWithImpl<$Res>
    implements $ActionEquipmentCopyWith<$Res> {
  _$ActionEquipmentCopyWithImpl(this._self, this._then);

  final ActionEquipment _self;
  final $Res Function(ActionEquipment) _then;

/// Create a copy of ActionEquipment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? required = null,Object? specifications = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionEquipment].
extension ActionEquipmentPatterns on ActionEquipment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionEquipment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionEquipment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionEquipment value)  $default,){
final _that = this;
switch (_that) {
case _ActionEquipment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionEquipment value)?  $default,){
final _that = this;
switch (_that) {
case _ActionEquipment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  bool required,  String? specifications)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionEquipment() when $default != null:
return $default(_that.name,_that.description,_that.required,_that.specifications);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  bool required,  String? specifications)  $default,) {final _that = this;
switch (_that) {
case _ActionEquipment():
return $default(_that.name,_that.description,_that.required,_that.specifications);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  bool required,  String? specifications)?  $default,) {final _that = this;
switch (_that) {
case _ActionEquipment() when $default != null:
return $default(_that.name,_that.description,_that.required,_that.specifications);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionEquipment implements ActionEquipment {
  const _ActionEquipment({required this.name, required this.description, this.required = true, this.specifications});
  factory _ActionEquipment.fromJson(Map<String, dynamic> json) => _$ActionEquipmentFromJson(json);

/// Name of the equipment
@override final  String name;
/// Description of the equipment
@override final  String description;
/// Whether the equipment is required or optional
@override@JsonKey() final  bool required;
/// Specifications or model details
@override final  String? specifications;

/// Create a copy of ActionEquipment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionEquipmentCopyWith<_ActionEquipment> get copyWith => __$ActionEquipmentCopyWithImpl<_ActionEquipment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionEquipmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionEquipment&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.required, required) || other.required == required)&&(identical(other.specifications, specifications) || other.specifications == specifications));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,required,specifications);

@override
String toString() {
  return 'ActionEquipment(name: $name, description: $description, required: $required, specifications: $specifications)';
}


}

/// @nodoc
abstract mixin class _$ActionEquipmentCopyWith<$Res> implements $ActionEquipmentCopyWith<$Res> {
  factory _$ActionEquipmentCopyWith(_ActionEquipment value, $Res Function(_ActionEquipment) _then) = __$ActionEquipmentCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, bool required, String? specifications
});




}
/// @nodoc
class __$ActionEquipmentCopyWithImpl<$Res>
    implements _$ActionEquipmentCopyWith<$Res> {
  __$ActionEquipmentCopyWithImpl(this._self, this._then);

  final _ActionEquipment _self;
  final $Res Function(_ActionEquipment) _then;

/// Create a copy of ActionEquipment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? required = null,Object? specifications = freezed,}) {
  return _then(_ActionEquipment(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ActionReference {

/// Title of the reference
 String get title;/// URL or citation
 String get url;/// Description of what this reference covers
 String? get description;/// Type of reference (documentation, blog, paper, etc.)
 String get type;
/// Create a copy of ActionReference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionReferenceCopyWith<ActionReference> get copyWith => _$ActionReferenceCopyWithImpl<ActionReference>(this as ActionReference, _$identity);

  /// Serializes this ActionReference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionReference&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,description,type);

@override
String toString() {
  return 'ActionReference(title: $title, url: $url, description: $description, type: $type)';
}


}

/// @nodoc
abstract mixin class $ActionReferenceCopyWith<$Res>  {
  factory $ActionReferenceCopyWith(ActionReference value, $Res Function(ActionReference) _then) = _$ActionReferenceCopyWithImpl;
@useResult
$Res call({
 String title, String url, String? description, String type
});




}
/// @nodoc
class _$ActionReferenceCopyWithImpl<$Res>
    implements $ActionReferenceCopyWith<$Res> {
  _$ActionReferenceCopyWithImpl(this._self, this._then);

  final ActionReference _self;
  final $Res Function(ActionReference) _then;

/// Create a copy of ActionReference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? url = null,Object? description = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionReference].
extension ActionReferencePatterns on ActionReference {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionReference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionReference() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionReference value)  $default,){
final _that = this;
switch (_that) {
case _ActionReference():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionReference value)?  $default,){
final _that = this;
switch (_that) {
case _ActionReference() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String url,  String? description,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionReference() when $default != null:
return $default(_that.title,_that.url,_that.description,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String url,  String? description,  String type)  $default,) {final _that = this;
switch (_that) {
case _ActionReference():
return $default(_that.title,_that.url,_that.description,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String url,  String? description,  String type)?  $default,) {final _that = this;
switch (_that) {
case _ActionReference() when $default != null:
return $default(_that.title,_that.url,_that.description,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionReference implements ActionReference {
  const _ActionReference({required this.title, required this.url, this.description, this.type = 'documentation'});
  factory _ActionReference.fromJson(Map<String, dynamic> json) => _$ActionReferenceFromJson(json);

/// Title of the reference
@override final  String title;
/// URL or citation
@override final  String url;
/// Description of what this reference covers
@override final  String? description;
/// Type of reference (documentation, blog, paper, etc.)
@override@JsonKey() final  String type;

/// Create a copy of ActionReference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionReferenceCopyWith<_ActionReference> get copyWith => __$ActionReferenceCopyWithImpl<_ActionReference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionReferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionReference&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,url,description,type);

@override
String toString() {
  return 'ActionReference(title: $title, url: $url, description: $description, type: $type)';
}


}

/// @nodoc
abstract mixin class _$ActionReferenceCopyWith<$Res> implements $ActionReferenceCopyWith<$Res> {
  factory _$ActionReferenceCopyWith(_ActionReference value, $Res Function(_ActionReference) _then) = __$ActionReferenceCopyWithImpl;
@override @useResult
$Res call({
 String title, String url, String? description, String type
});




}
/// @nodoc
class __$ActionReferenceCopyWithImpl<$Res>
    implements _$ActionReferenceCopyWith<$Res> {
  __$ActionReferenceCopyWithImpl(this._self, this._then);

  final _ActionReference _self;
  final $Res Function(_ActionReference) _then;

/// Create a copy of ActionReference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? url = null,Object? description = freezed,Object? type = null,}) {
  return _then(_ActionReference(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ActionRisk {

/// Description of the risk
 String get risk;/// How to mitigate this risk
 String get mitigation;/// Severity of the risk
 ActionRiskLevel get severity;
/// Create a copy of ActionRisk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionRiskCopyWith<ActionRisk> get copyWith => _$ActionRiskCopyWithImpl<ActionRisk>(this as ActionRisk, _$identity);

  /// Serializes this ActionRisk to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionRisk&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,risk,mitigation,severity);

@override
String toString() {
  return 'ActionRisk(risk: $risk, mitigation: $mitigation, severity: $severity)';
}


}

/// @nodoc
abstract mixin class $ActionRiskCopyWith<$Res>  {
  factory $ActionRiskCopyWith(ActionRisk value, $Res Function(ActionRisk) _then) = _$ActionRiskCopyWithImpl;
@useResult
$Res call({
 String risk, String mitigation, ActionRiskLevel severity
});




}
/// @nodoc
class _$ActionRiskCopyWithImpl<$Res>
    implements $ActionRiskCopyWith<$Res> {
  _$ActionRiskCopyWithImpl(this._self, this._then);

  final ActionRisk _self;
  final $Res Function(ActionRisk) _then;

/// Create a copy of ActionRisk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? risk = null,Object? mitigation = null,Object? severity = null,}) {
  return _then(_self.copyWith(
risk: null == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as String,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as ActionRiskLevel,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionRisk].
extension ActionRiskPatterns on ActionRisk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionRisk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionRisk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionRisk value)  $default,){
final _that = this;
switch (_that) {
case _ActionRisk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionRisk value)?  $default,){
final _that = this;
switch (_that) {
case _ActionRisk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String risk,  String mitigation,  ActionRiskLevel severity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionRisk() when $default != null:
return $default(_that.risk,_that.mitigation,_that.severity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String risk,  String mitigation,  ActionRiskLevel severity)  $default,) {final _that = this;
switch (_that) {
case _ActionRisk():
return $default(_that.risk,_that.mitigation,_that.severity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String risk,  String mitigation,  ActionRiskLevel severity)?  $default,) {final _that = this;
switch (_that) {
case _ActionRisk() when $default != null:
return $default(_that.risk,_that.mitigation,_that.severity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionRisk implements ActionRisk {
  const _ActionRisk({required this.risk, required this.mitigation, this.severity = ActionRiskLevel.medium});
  factory _ActionRisk.fromJson(Map<String, dynamic> json) => _$ActionRiskFromJson(json);

/// Description of the risk
@override final  String risk;
/// How to mitigate this risk
@override final  String mitigation;
/// Severity of the risk
@override@JsonKey() final  ActionRiskLevel severity;

/// Create a copy of ActionRisk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionRiskCopyWith<_ActionRisk> get copyWith => __$ActionRiskCopyWithImpl<_ActionRisk>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionRiskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionRisk&&(identical(other.risk, risk) || other.risk == risk)&&(identical(other.mitigation, mitigation) || other.mitigation == mitigation)&&(identical(other.severity, severity) || other.severity == severity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,risk,mitigation,severity);

@override
String toString() {
  return 'ActionRisk(risk: $risk, mitigation: $mitigation, severity: $severity)';
}


}

/// @nodoc
abstract mixin class _$ActionRiskCopyWith<$Res> implements $ActionRiskCopyWith<$Res> {
  factory _$ActionRiskCopyWith(_ActionRisk value, $Res Function(_ActionRisk) _then) = __$ActionRiskCopyWithImpl;
@override @useResult
$Res call({
 String risk, String mitigation, ActionRiskLevel severity
});




}
/// @nodoc
class __$ActionRiskCopyWithImpl<$Res>
    implements _$ActionRiskCopyWith<$Res> {
  __$ActionRiskCopyWithImpl(this._self, this._then);

  final _ActionRisk _self;
  final $Res Function(_ActionRisk) _then;

/// Create a copy of ActionRisk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? risk = null,Object? mitigation = null,Object? severity = null,}) {
  return _then(_ActionRisk(
risk: null == risk ? _self.risk : risk // ignore: cast_nullable_to_non_nullable
as String,mitigation: null == mitigation ? _self.mitigation : mitigation // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as ActionRiskLevel,
  ));
}


}


/// @nodoc
mixin _$ProcedureStep {

/// Step number
 int get stepNumber;/// Description of what this step does
 String get description;/// Command to execute (with placeholders)
 String? get command;/// Expected output or results
 String? get expectedOutput;/// Additional notes for this step
 String? get notes;/// Whether this step is mandatory
 bool get mandatory;
/// Create a copy of ProcedureStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProcedureStepCopyWith<ProcedureStep> get copyWith => _$ProcedureStepCopyWithImpl<ProcedureStep>(this as ProcedureStep, _$identity);

  /// Serializes this ProcedureStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProcedureStep&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.description, description) || other.description == description)&&(identical(other.command, command) || other.command == command)&&(identical(other.expectedOutput, expectedOutput) || other.expectedOutput == expectedOutput)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.mandatory, mandatory) || other.mandatory == mandatory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,description,command,expectedOutput,notes,mandatory);

@override
String toString() {
  return 'ProcedureStep(stepNumber: $stepNumber, description: $description, command: $command, expectedOutput: $expectedOutput, notes: $notes, mandatory: $mandatory)';
}


}

/// @nodoc
abstract mixin class $ProcedureStepCopyWith<$Res>  {
  factory $ProcedureStepCopyWith(ProcedureStep value, $Res Function(ProcedureStep) _then) = _$ProcedureStepCopyWithImpl;
@useResult
$Res call({
 int stepNumber, String description, String? command, String? expectedOutput, String? notes, bool mandatory
});




}
/// @nodoc
class _$ProcedureStepCopyWithImpl<$Res>
    implements $ProcedureStepCopyWith<$Res> {
  _$ProcedureStepCopyWithImpl(this._self, this._then);

  final ProcedureStep _self;
  final $Res Function(ProcedureStep) _then;

/// Create a copy of ProcedureStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepNumber = null,Object? description = null,Object? command = freezed,Object? expectedOutput = freezed,Object? notes = freezed,Object? mandatory = null,}) {
  return _then(_self.copyWith(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,command: freezed == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String?,expectedOutput: freezed == expectedOutput ? _self.expectedOutput : expectedOutput // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,mandatory: null == mandatory ? _self.mandatory : mandatory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProcedureStep].
extension ProcedureStepPatterns on ProcedureStep {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProcedureStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProcedureStep() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProcedureStep value)  $default,){
final _that = this;
switch (_that) {
case _ProcedureStep():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProcedureStep value)?  $default,){
final _that = this;
switch (_that) {
case _ProcedureStep() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepNumber,  String description,  String? command,  String? expectedOutput,  String? notes,  bool mandatory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProcedureStep() when $default != null:
return $default(_that.stepNumber,_that.description,_that.command,_that.expectedOutput,_that.notes,_that.mandatory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepNumber,  String description,  String? command,  String? expectedOutput,  String? notes,  bool mandatory)  $default,) {final _that = this;
switch (_that) {
case _ProcedureStep():
return $default(_that.stepNumber,_that.description,_that.command,_that.expectedOutput,_that.notes,_that.mandatory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepNumber,  String description,  String? command,  String? expectedOutput,  String? notes,  bool mandatory)?  $default,) {final _that = this;
switch (_that) {
case _ProcedureStep() when $default != null:
return $default(_that.stepNumber,_that.description,_that.command,_that.expectedOutput,_that.notes,_that.mandatory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProcedureStep implements ProcedureStep {
  const _ProcedureStep({required this.stepNumber, required this.description, this.command, this.expectedOutput, this.notes, this.mandatory = true});
  factory _ProcedureStep.fromJson(Map<String, dynamic> json) => _$ProcedureStepFromJson(json);

/// Step number
@override final  int stepNumber;
/// Description of what this step does
@override final  String description;
/// Command to execute (with placeholders)
@override final  String? command;
/// Expected output or results
@override final  String? expectedOutput;
/// Additional notes for this step
@override final  String? notes;
/// Whether this step is mandatory
@override@JsonKey() final  bool mandatory;

/// Create a copy of ProcedureStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProcedureStepCopyWith<_ProcedureStep> get copyWith => __$ProcedureStepCopyWithImpl<_ProcedureStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProcedureStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProcedureStep&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.description, description) || other.description == description)&&(identical(other.command, command) || other.command == command)&&(identical(other.expectedOutput, expectedOutput) || other.expectedOutput == expectedOutput)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.mandatory, mandatory) || other.mandatory == mandatory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,description,command,expectedOutput,notes,mandatory);

@override
String toString() {
  return 'ProcedureStep(stepNumber: $stepNumber, description: $description, command: $command, expectedOutput: $expectedOutput, notes: $notes, mandatory: $mandatory)';
}


}

/// @nodoc
abstract mixin class _$ProcedureStepCopyWith<$Res> implements $ProcedureStepCopyWith<$Res> {
  factory _$ProcedureStepCopyWith(_ProcedureStep value, $Res Function(_ProcedureStep) _then) = __$ProcedureStepCopyWithImpl;
@override @useResult
$Res call({
 int stepNumber, String description, String? command, String? expectedOutput, String? notes, bool mandatory
});




}
/// @nodoc
class __$ProcedureStepCopyWithImpl<$Res>
    implements _$ProcedureStepCopyWith<$Res> {
  __$ProcedureStepCopyWithImpl(this._self, this._then);

  final _ProcedureStep _self;
  final $Res Function(_ProcedureStep) _then;

/// Create a copy of ProcedureStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepNumber = null,Object? description = null,Object? command = freezed,Object? expectedOutput = freezed,Object? notes = freezed,Object? mandatory = null,}) {
  return _then(_ProcedureStep(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,command: freezed == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String?,expectedOutput: freezed == expectedOutput ? _self.expectedOutput : expectedOutput // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,mandatory: null == mandatory ? _self.mandatory : mandatory // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$SuggestedFinding {

/// Title of the finding
 String get title;/// Description of what this finding represents
 String get description;/// Severity of the finding
 ActionRiskLevel get severity;/// CVSS score if applicable
 double? get cvssScore;/// Category of the finding
 String? get category;
/// Create a copy of SuggestedFinding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuggestedFindingCopyWith<SuggestedFinding> get copyWith => _$SuggestedFindingCopyWithImpl<SuggestedFinding>(this as SuggestedFinding, _$identity);

  /// Serializes this SuggestedFinding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuggestedFinding&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.cvssScore, cvssScore) || other.cvssScore == cvssScore)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,severity,cvssScore,category);

@override
String toString() {
  return 'SuggestedFinding(title: $title, description: $description, severity: $severity, cvssScore: $cvssScore, category: $category)';
}


}

/// @nodoc
abstract mixin class $SuggestedFindingCopyWith<$Res>  {
  factory $SuggestedFindingCopyWith(SuggestedFinding value, $Res Function(SuggestedFinding) _then) = _$SuggestedFindingCopyWithImpl;
@useResult
$Res call({
 String title, String description, ActionRiskLevel severity, double? cvssScore, String? category
});




}
/// @nodoc
class _$SuggestedFindingCopyWithImpl<$Res>
    implements $SuggestedFindingCopyWith<$Res> {
  _$SuggestedFindingCopyWithImpl(this._self, this._then);

  final SuggestedFinding _self;
  final $Res Function(SuggestedFinding) _then;

/// Create a copy of SuggestedFinding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? severity = null,Object? cvssScore = freezed,Object? category = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as ActionRiskLevel,cvssScore: freezed == cvssScore ? _self.cvssScore : cvssScore // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SuggestedFinding].
extension SuggestedFindingPatterns on SuggestedFinding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuggestedFinding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuggestedFinding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuggestedFinding value)  $default,){
final _that = this;
switch (_that) {
case _SuggestedFinding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuggestedFinding value)?  $default,){
final _that = this;
switch (_that) {
case _SuggestedFinding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  ActionRiskLevel severity,  double? cvssScore,  String? category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuggestedFinding() when $default != null:
return $default(_that.title,_that.description,_that.severity,_that.cvssScore,_that.category);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  ActionRiskLevel severity,  double? cvssScore,  String? category)  $default,) {final _that = this;
switch (_that) {
case _SuggestedFinding():
return $default(_that.title,_that.description,_that.severity,_that.cvssScore,_that.category);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  ActionRiskLevel severity,  double? cvssScore,  String? category)?  $default,) {final _that = this;
switch (_that) {
case _SuggestedFinding() when $default != null:
return $default(_that.title,_that.description,_that.severity,_that.cvssScore,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SuggestedFinding implements SuggestedFinding {
  const _SuggestedFinding({required this.title, required this.description, this.severity = ActionRiskLevel.medium, this.cvssScore, this.category});
  factory _SuggestedFinding.fromJson(Map<String, dynamic> json) => _$SuggestedFindingFromJson(json);

/// Title of the finding
@override final  String title;
/// Description of what this finding represents
@override final  String description;
/// Severity of the finding
@override@JsonKey() final  ActionRiskLevel severity;
/// CVSS score if applicable
@override final  double? cvssScore;
/// Category of the finding
@override final  String? category;

/// Create a copy of SuggestedFinding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuggestedFindingCopyWith<_SuggestedFinding> get copyWith => __$SuggestedFindingCopyWithImpl<_SuggestedFinding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SuggestedFindingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuggestedFinding&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.cvssScore, cvssScore) || other.cvssScore == cvssScore)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,severity,cvssScore,category);

@override
String toString() {
  return 'SuggestedFinding(title: $title, description: $description, severity: $severity, cvssScore: $cvssScore, category: $category)';
}


}

/// @nodoc
abstract mixin class _$SuggestedFindingCopyWith<$Res> implements $SuggestedFindingCopyWith<$Res> {
  factory _$SuggestedFindingCopyWith(_SuggestedFinding value, $Res Function(_SuggestedFinding) _then) = __$SuggestedFindingCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, ActionRiskLevel severity, double? cvssScore, String? category
});




}
/// @nodoc
class __$SuggestedFindingCopyWithImpl<$Res>
    implements _$SuggestedFindingCopyWith<$Res> {
  __$SuggestedFindingCopyWithImpl(this._self, this._then);

  final _SuggestedFinding _self;
  final $Res Function(_SuggestedFinding) _then;

/// Create a copy of SuggestedFinding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? severity = null,Object? cvssScore = freezed,Object? category = freezed,}) {
  return _then(_SuggestedFinding(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as ActionRiskLevel,cvssScore: freezed == cvssScore ? _self.cvssScore : cvssScore // ignore: cast_nullable_to_non_nullable
as double?,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ActionExecution {

/// When execution started
 DateTime? get startedAt;/// When execution completed
 DateTime? get completedAt;/// Who executed this action
 String? get executedBy;/// Commands that were actually run
 List<String> get executedCommands;/// Outputs captured from execution
 List<String> get capturedOutputs;/// Evidence files generated
 List<String> get evidenceFiles;/// Findings discovered during execution
 List<String> get findingIds;/// Notes added during execution
 String? get executionNotes;/// Whether this action was successful
 bool? get successful;/// Error message if execution failed
 String? get errorMessage;
/// Create a copy of ActionExecution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActionExecutionCopyWith<ActionExecution> get copyWith => _$ActionExecutionCopyWithImpl<ActionExecution>(this as ActionExecution, _$identity);

  /// Serializes this ActionExecution to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActionExecution&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.executedBy, executedBy) || other.executedBy == executedBy)&&const DeepCollectionEquality().equals(other.executedCommands, executedCommands)&&const DeepCollectionEquality().equals(other.capturedOutputs, capturedOutputs)&&const DeepCollectionEquality().equals(other.evidenceFiles, evidenceFiles)&&const DeepCollectionEquality().equals(other.findingIds, findingIds)&&(identical(other.executionNotes, executionNotes) || other.executionNotes == executionNotes)&&(identical(other.successful, successful) || other.successful == successful)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedAt,completedAt,executedBy,const DeepCollectionEquality().hash(executedCommands),const DeepCollectionEquality().hash(capturedOutputs),const DeepCollectionEquality().hash(evidenceFiles),const DeepCollectionEquality().hash(findingIds),executionNotes,successful,errorMessage);

@override
String toString() {
  return 'ActionExecution(startedAt: $startedAt, completedAt: $completedAt, executedBy: $executedBy, executedCommands: $executedCommands, capturedOutputs: $capturedOutputs, evidenceFiles: $evidenceFiles, findingIds: $findingIds, executionNotes: $executionNotes, successful: $successful, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ActionExecutionCopyWith<$Res>  {
  factory $ActionExecutionCopyWith(ActionExecution value, $Res Function(ActionExecution) _then) = _$ActionExecutionCopyWithImpl;
@useResult
$Res call({
 DateTime? startedAt, DateTime? completedAt, String? executedBy, List<String> executedCommands, List<String> capturedOutputs, List<String> evidenceFiles, List<String> findingIds, String? executionNotes, bool? successful, String? errorMessage
});




}
/// @nodoc
class _$ActionExecutionCopyWithImpl<$Res>
    implements $ActionExecutionCopyWith<$Res> {
  _$ActionExecutionCopyWithImpl(this._self, this._then);

  final ActionExecution _self;
  final $Res Function(ActionExecution) _then;

/// Create a copy of ActionExecution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startedAt = freezed,Object? completedAt = freezed,Object? executedBy = freezed,Object? executedCommands = null,Object? capturedOutputs = null,Object? evidenceFiles = null,Object? findingIds = null,Object? executionNotes = freezed,Object? successful = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,executedBy: freezed == executedBy ? _self.executedBy : executedBy // ignore: cast_nullable_to_non_nullable
as String?,executedCommands: null == executedCommands ? _self.executedCommands : executedCommands // ignore: cast_nullable_to_non_nullable
as List<String>,capturedOutputs: null == capturedOutputs ? _self.capturedOutputs : capturedOutputs // ignore: cast_nullable_to_non_nullable
as List<String>,evidenceFiles: null == evidenceFiles ? _self.evidenceFiles : evidenceFiles // ignore: cast_nullable_to_non_nullable
as List<String>,findingIds: null == findingIds ? _self.findingIds : findingIds // ignore: cast_nullable_to_non_nullable
as List<String>,executionNotes: freezed == executionNotes ? _self.executionNotes : executionNotes // ignore: cast_nullable_to_non_nullable
as String?,successful: freezed == successful ? _self.successful : successful // ignore: cast_nullable_to_non_nullable
as bool?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ActionExecution].
extension ActionExecutionPatterns on ActionExecution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ActionExecution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ActionExecution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ActionExecution value)  $default,){
final _that = this;
switch (_that) {
case _ActionExecution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ActionExecution value)?  $default,){
final _that = this;
switch (_that) {
case _ActionExecution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? startedAt,  DateTime? completedAt,  String? executedBy,  List<String> executedCommands,  List<String> capturedOutputs,  List<String> evidenceFiles,  List<String> findingIds,  String? executionNotes,  bool? successful,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ActionExecution() when $default != null:
return $default(_that.startedAt,_that.completedAt,_that.executedBy,_that.executedCommands,_that.capturedOutputs,_that.evidenceFiles,_that.findingIds,_that.executionNotes,_that.successful,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? startedAt,  DateTime? completedAt,  String? executedBy,  List<String> executedCommands,  List<String> capturedOutputs,  List<String> evidenceFiles,  List<String> findingIds,  String? executionNotes,  bool? successful,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ActionExecution():
return $default(_that.startedAt,_that.completedAt,_that.executedBy,_that.executedCommands,_that.capturedOutputs,_that.evidenceFiles,_that.findingIds,_that.executionNotes,_that.successful,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? startedAt,  DateTime? completedAt,  String? executedBy,  List<String> executedCommands,  List<String> capturedOutputs,  List<String> evidenceFiles,  List<String> findingIds,  String? executionNotes,  bool? successful,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ActionExecution() when $default != null:
return $default(_that.startedAt,_that.completedAt,_that.executedBy,_that.executedCommands,_that.capturedOutputs,_that.evidenceFiles,_that.findingIds,_that.executionNotes,_that.successful,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ActionExecution implements ActionExecution {
  const _ActionExecution({this.startedAt, this.completedAt, this.executedBy, final  List<String> executedCommands = const [], final  List<String> capturedOutputs = const [], final  List<String> evidenceFiles = const [], final  List<String> findingIds = const [], this.executionNotes, this.successful, this.errorMessage}): _executedCommands = executedCommands,_capturedOutputs = capturedOutputs,_evidenceFiles = evidenceFiles,_findingIds = findingIds;
  factory _ActionExecution.fromJson(Map<String, dynamic> json) => _$ActionExecutionFromJson(json);

/// When execution started
@override final  DateTime? startedAt;
/// When execution completed
@override final  DateTime? completedAt;
/// Who executed this action
@override final  String? executedBy;
/// Commands that were actually run
 final  List<String> _executedCommands;
/// Commands that were actually run
@override@JsonKey() List<String> get executedCommands {
  if (_executedCommands is EqualUnmodifiableListView) return _executedCommands;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_executedCommands);
}

/// Outputs captured from execution
 final  List<String> _capturedOutputs;
/// Outputs captured from execution
@override@JsonKey() List<String> get capturedOutputs {
  if (_capturedOutputs is EqualUnmodifiableListView) return _capturedOutputs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_capturedOutputs);
}

/// Evidence files generated
 final  List<String> _evidenceFiles;
/// Evidence files generated
@override@JsonKey() List<String> get evidenceFiles {
  if (_evidenceFiles is EqualUnmodifiableListView) return _evidenceFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceFiles);
}

/// Findings discovered during execution
 final  List<String> _findingIds;
/// Findings discovered during execution
@override@JsonKey() List<String> get findingIds {
  if (_findingIds is EqualUnmodifiableListView) return _findingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_findingIds);
}

/// Notes added during execution
@override final  String? executionNotes;
/// Whether this action was successful
@override final  bool? successful;
/// Error message if execution failed
@override final  String? errorMessage;

/// Create a copy of ActionExecution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActionExecutionCopyWith<_ActionExecution> get copyWith => __$ActionExecutionCopyWithImpl<_ActionExecution>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActionExecutionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActionExecution&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.executedBy, executedBy) || other.executedBy == executedBy)&&const DeepCollectionEquality().equals(other._executedCommands, _executedCommands)&&const DeepCollectionEquality().equals(other._capturedOutputs, _capturedOutputs)&&const DeepCollectionEquality().equals(other._evidenceFiles, _evidenceFiles)&&const DeepCollectionEquality().equals(other._findingIds, _findingIds)&&(identical(other.executionNotes, executionNotes) || other.executionNotes == executionNotes)&&(identical(other.successful, successful) || other.successful == successful)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startedAt,completedAt,executedBy,const DeepCollectionEquality().hash(_executedCommands),const DeepCollectionEquality().hash(_capturedOutputs),const DeepCollectionEquality().hash(_evidenceFiles),const DeepCollectionEquality().hash(_findingIds),executionNotes,successful,errorMessage);

@override
String toString() {
  return 'ActionExecution(startedAt: $startedAt, completedAt: $completedAt, executedBy: $executedBy, executedCommands: $executedCommands, capturedOutputs: $capturedOutputs, evidenceFiles: $evidenceFiles, findingIds: $findingIds, executionNotes: $executionNotes, successful: $successful, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ActionExecutionCopyWith<$Res> implements $ActionExecutionCopyWith<$Res> {
  factory _$ActionExecutionCopyWith(_ActionExecution value, $Res Function(_ActionExecution) _then) = __$ActionExecutionCopyWithImpl;
@override @useResult
$Res call({
 DateTime? startedAt, DateTime? completedAt, String? executedBy, List<String> executedCommands, List<String> capturedOutputs, List<String> evidenceFiles, List<String> findingIds, String? executionNotes, bool? successful, String? errorMessage
});




}
/// @nodoc
class __$ActionExecutionCopyWithImpl<$Res>
    implements _$ActionExecutionCopyWith<$Res> {
  __$ActionExecutionCopyWithImpl(this._self, this._then);

  final _ActionExecution _self;
  final $Res Function(_ActionExecution) _then;

/// Create a copy of ActionExecution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startedAt = freezed,Object? completedAt = freezed,Object? executedBy = freezed,Object? executedCommands = null,Object? capturedOutputs = null,Object? evidenceFiles = null,Object? findingIds = null,Object? executionNotes = freezed,Object? successful = freezed,Object? errorMessage = freezed,}) {
  return _then(_ActionExecution(
startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,executedBy: freezed == executedBy ? _self.executedBy : executedBy // ignore: cast_nullable_to_non_nullable
as String?,executedCommands: null == executedCommands ? _self._executedCommands : executedCommands // ignore: cast_nullable_to_non_nullable
as List<String>,capturedOutputs: null == capturedOutputs ? _self._capturedOutputs : capturedOutputs // ignore: cast_nullable_to_non_nullable
as List<String>,evidenceFiles: null == evidenceFiles ? _self._evidenceFiles : evidenceFiles // ignore: cast_nullable_to_non_nullable
as List<String>,findingIds: null == findingIds ? _self._findingIds : findingIds // ignore: cast_nullable_to_non_nullable
as List<String>,executionNotes: freezed == executionNotes ? _self.executionNotes : executionNotes // ignore: cast_nullable_to_non_nullable
as String?,successful: freezed == successful ? _self.successful : successful // ignore: cast_nullable_to_non_nullable
as bool?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AttackPlanAction {

/// Unique identifier
 String get id;/// Project this action belongs to
 String get projectId;/// Title of the action (e.g., "Enumerate Installed Software (Windows)")
 String get title;/// Short summary of what you are trying to achieve and consequences
 String get objective;/// Current status of the action
 ActionStatus get status;/// Priority level
 ActionPriority get priority;/// Risk level of performing this action
 ActionRiskLevel get riskLevel;/// Trigger events that led to this action being generated
 List<TriggerEvent> get triggerEvents;/// Risks and their mitigations
 List<ActionRisk> get risks;/// Step-by-step procedure
 List<ProcedureStep> get procedure;/// Tools required
 List<ActionTool> get tools;/// Equipment needed
 List<ActionEquipment> get equipment;/// References for further reading
 List<ActionReference> get references;/// Suggested findings from this action
 List<SuggestedFinding> get suggestedFindings;/// Cleanup steps required after execution
 List<String> get cleanupSteps;/// Tags for categorization
 List<String> get tags;/// Execution tracking data
 ActionExecution? get execution;/// When this action was created
 DateTime get createdAt;/// When this action was last updated
 DateTime? get updatedAt;/// Who created this action
 String get createdBy;/// Template ID this action was generated from
 String? get templateId;/// Additional metadata
 Map<String, dynamic> get metadata;
/// Create a copy of AttackPlanAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttackPlanActionCopyWith<AttackPlanAction> get copyWith => _$AttackPlanActionCopyWithImpl<AttackPlanAction>(this as AttackPlanAction, _$identity);

  /// Serializes this AttackPlanAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttackPlanAction&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.objective, objective) || other.objective == objective)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&const DeepCollectionEquality().equals(other.triggerEvents, triggerEvents)&&const DeepCollectionEquality().equals(other.risks, risks)&&const DeepCollectionEquality().equals(other.procedure, procedure)&&const DeepCollectionEquality().equals(other.tools, tools)&&const DeepCollectionEquality().equals(other.equipment, equipment)&&const DeepCollectionEquality().equals(other.references, references)&&const DeepCollectionEquality().equals(other.suggestedFindings, suggestedFindings)&&const DeepCollectionEquality().equals(other.cleanupSteps, cleanupSteps)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.execution, execution) || other.execution == execution)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,projectId,title,objective,status,priority,riskLevel,const DeepCollectionEquality().hash(triggerEvents),const DeepCollectionEquality().hash(risks),const DeepCollectionEquality().hash(procedure),const DeepCollectionEquality().hash(tools),const DeepCollectionEquality().hash(equipment),const DeepCollectionEquality().hash(references),const DeepCollectionEquality().hash(suggestedFindings),const DeepCollectionEquality().hash(cleanupSteps),const DeepCollectionEquality().hash(tags),execution,createdAt,updatedAt,createdBy,templateId,const DeepCollectionEquality().hash(metadata)]);

@override
String toString() {
  return 'AttackPlanAction(id: $id, projectId: $projectId, title: $title, objective: $objective, status: $status, priority: $priority, riskLevel: $riskLevel, triggerEvents: $triggerEvents, risks: $risks, procedure: $procedure, tools: $tools, equipment: $equipment, references: $references, suggestedFindings: $suggestedFindings, cleanupSteps: $cleanupSteps, tags: $tags, execution: $execution, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, templateId: $templateId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $AttackPlanActionCopyWith<$Res>  {
  factory $AttackPlanActionCopyWith(AttackPlanAction value, $Res Function(AttackPlanAction) _then) = _$AttackPlanActionCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String title, String objective, ActionStatus status, ActionPriority priority, ActionRiskLevel riskLevel, List<TriggerEvent> triggerEvents, List<ActionRisk> risks, List<ProcedureStep> procedure, List<ActionTool> tools, List<ActionEquipment> equipment, List<ActionReference> references, List<SuggestedFinding> suggestedFindings, List<String> cleanupSteps, List<String> tags, ActionExecution? execution, DateTime createdAt, DateTime? updatedAt, String createdBy, String? templateId, Map<String, dynamic> metadata
});


$ActionExecutionCopyWith<$Res>? get execution;

}
/// @nodoc
class _$AttackPlanActionCopyWithImpl<$Res>
    implements $AttackPlanActionCopyWith<$Res> {
  _$AttackPlanActionCopyWithImpl(this._self, this._then);

  final AttackPlanAction _self;
  final $Res Function(AttackPlanAction) _then;

/// Create a copy of AttackPlanAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? objective = null,Object? status = null,Object? priority = null,Object? riskLevel = null,Object? triggerEvents = null,Object? risks = null,Object? procedure = null,Object? tools = null,Object? equipment = null,Object? references = null,Object? suggestedFindings = null,Object? cleanupSteps = null,Object? tags = null,Object? execution = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? createdBy = null,Object? templateId = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,objective: null == objective ? _self.objective : objective // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ActionStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ActionPriority,riskLevel: null == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as ActionRiskLevel,triggerEvents: null == triggerEvents ? _self.triggerEvents : triggerEvents // ignore: cast_nullable_to_non_nullable
as List<TriggerEvent>,risks: null == risks ? _self.risks : risks // ignore: cast_nullable_to_non_nullable
as List<ActionRisk>,procedure: null == procedure ? _self.procedure : procedure // ignore: cast_nullable_to_non_nullable
as List<ProcedureStep>,tools: null == tools ? _self.tools : tools // ignore: cast_nullable_to_non_nullable
as List<ActionTool>,equipment: null == equipment ? _self.equipment : equipment // ignore: cast_nullable_to_non_nullable
as List<ActionEquipment>,references: null == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as List<ActionReference>,suggestedFindings: null == suggestedFindings ? _self.suggestedFindings : suggestedFindings // ignore: cast_nullable_to_non_nullable
as List<SuggestedFinding>,cleanupSteps: null == cleanupSteps ? _self.cleanupSteps : cleanupSteps // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,execution: freezed == execution ? _self.execution : execution // ignore: cast_nullable_to_non_nullable
as ActionExecution?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}
/// Create a copy of AttackPlanAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionExecutionCopyWith<$Res>? get execution {
    if (_self.execution == null) {
    return null;
  }

  return $ActionExecutionCopyWith<$Res>(_self.execution!, (value) {
    return _then(_self.copyWith(execution: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttackPlanAction].
extension AttackPlanActionPatterns on AttackPlanAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttackPlanAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttackPlanAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttackPlanAction value)  $default,){
final _that = this;
switch (_that) {
case _AttackPlanAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttackPlanAction value)?  $default,){
final _that = this;
switch (_that) {
case _AttackPlanAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String title,  String objective,  ActionStatus status,  ActionPriority priority,  ActionRiskLevel riskLevel,  List<TriggerEvent> triggerEvents,  List<ActionRisk> risks,  List<ProcedureStep> procedure,  List<ActionTool> tools,  List<ActionEquipment> equipment,  List<ActionReference> references,  List<SuggestedFinding> suggestedFindings,  List<String> cleanupSteps,  List<String> tags,  ActionExecution? execution,  DateTime createdAt,  DateTime? updatedAt,  String createdBy,  String? templateId,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttackPlanAction() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.objective,_that.status,_that.priority,_that.riskLevel,_that.triggerEvents,_that.risks,_that.procedure,_that.tools,_that.equipment,_that.references,_that.suggestedFindings,_that.cleanupSteps,_that.tags,_that.execution,_that.createdAt,_that.updatedAt,_that.createdBy,_that.templateId,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String title,  String objective,  ActionStatus status,  ActionPriority priority,  ActionRiskLevel riskLevel,  List<TriggerEvent> triggerEvents,  List<ActionRisk> risks,  List<ProcedureStep> procedure,  List<ActionTool> tools,  List<ActionEquipment> equipment,  List<ActionReference> references,  List<SuggestedFinding> suggestedFindings,  List<String> cleanupSteps,  List<String> tags,  ActionExecution? execution,  DateTime createdAt,  DateTime? updatedAt,  String createdBy,  String? templateId,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _AttackPlanAction():
return $default(_that.id,_that.projectId,_that.title,_that.objective,_that.status,_that.priority,_that.riskLevel,_that.triggerEvents,_that.risks,_that.procedure,_that.tools,_that.equipment,_that.references,_that.suggestedFindings,_that.cleanupSteps,_that.tags,_that.execution,_that.createdAt,_that.updatedAt,_that.createdBy,_that.templateId,_that.metadata);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String title,  String objective,  ActionStatus status,  ActionPriority priority,  ActionRiskLevel riskLevel,  List<TriggerEvent> triggerEvents,  List<ActionRisk> risks,  List<ProcedureStep> procedure,  List<ActionTool> tools,  List<ActionEquipment> equipment,  List<ActionReference> references,  List<SuggestedFinding> suggestedFindings,  List<String> cleanupSteps,  List<String> tags,  ActionExecution? execution,  DateTime createdAt,  DateTime? updatedAt,  String createdBy,  String? templateId,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _AttackPlanAction() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.objective,_that.status,_that.priority,_that.riskLevel,_that.triggerEvents,_that.risks,_that.procedure,_that.tools,_that.equipment,_that.references,_that.suggestedFindings,_that.cleanupSteps,_that.tags,_that.execution,_that.createdAt,_that.updatedAt,_that.createdBy,_that.templateId,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttackPlanAction implements AttackPlanAction {
  const _AttackPlanAction({required this.id, required this.projectId, required this.title, required this.objective, this.status = ActionStatus.pending, this.priority = ActionPriority.medium, this.riskLevel = ActionRiskLevel.medium, final  List<TriggerEvent> triggerEvents = const [], final  List<ActionRisk> risks = const [], final  List<ProcedureStep> procedure = const [], final  List<ActionTool> tools = const [], final  List<ActionEquipment> equipment = const [], final  List<ActionReference> references = const [], final  List<SuggestedFinding> suggestedFindings = const [], final  List<String> cleanupSteps = const [], final  List<String> tags = const [], this.execution, required this.createdAt, this.updatedAt, this.createdBy = 'system', this.templateId, final  Map<String, dynamic> metadata = const {}}): _triggerEvents = triggerEvents,_risks = risks,_procedure = procedure,_tools = tools,_equipment = equipment,_references = references,_suggestedFindings = suggestedFindings,_cleanupSteps = cleanupSteps,_tags = tags,_metadata = metadata;
  factory _AttackPlanAction.fromJson(Map<String, dynamic> json) => _$AttackPlanActionFromJson(json);

/// Unique identifier
@override final  String id;
/// Project this action belongs to
@override final  String projectId;
/// Title of the action (e.g., "Enumerate Installed Software (Windows)")
@override final  String title;
/// Short summary of what you are trying to achieve and consequences
@override final  String objective;
/// Current status of the action
@override@JsonKey() final  ActionStatus status;
/// Priority level
@override@JsonKey() final  ActionPriority priority;
/// Risk level of performing this action
@override@JsonKey() final  ActionRiskLevel riskLevel;
/// Trigger events that led to this action being generated
 final  List<TriggerEvent> _triggerEvents;
/// Trigger events that led to this action being generated
@override@JsonKey() List<TriggerEvent> get triggerEvents {
  if (_triggerEvents is EqualUnmodifiableListView) return _triggerEvents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_triggerEvents);
}

/// Risks and their mitigations
 final  List<ActionRisk> _risks;
/// Risks and their mitigations
@override@JsonKey() List<ActionRisk> get risks {
  if (_risks is EqualUnmodifiableListView) return _risks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_risks);
}

/// Step-by-step procedure
 final  List<ProcedureStep> _procedure;
/// Step-by-step procedure
@override@JsonKey() List<ProcedureStep> get procedure {
  if (_procedure is EqualUnmodifiableListView) return _procedure;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_procedure);
}

/// Tools required
 final  List<ActionTool> _tools;
/// Tools required
@override@JsonKey() List<ActionTool> get tools {
  if (_tools is EqualUnmodifiableListView) return _tools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tools);
}

/// Equipment needed
 final  List<ActionEquipment> _equipment;
/// Equipment needed
@override@JsonKey() List<ActionEquipment> get equipment {
  if (_equipment is EqualUnmodifiableListView) return _equipment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equipment);
}

/// References for further reading
 final  List<ActionReference> _references;
/// References for further reading
@override@JsonKey() List<ActionReference> get references {
  if (_references is EqualUnmodifiableListView) return _references;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_references);
}

/// Suggested findings from this action
 final  List<SuggestedFinding> _suggestedFindings;
/// Suggested findings from this action
@override@JsonKey() List<SuggestedFinding> get suggestedFindings {
  if (_suggestedFindings is EqualUnmodifiableListView) return _suggestedFindings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedFindings);
}

/// Cleanup steps required after execution
 final  List<String> _cleanupSteps;
/// Cleanup steps required after execution
@override@JsonKey() List<String> get cleanupSteps {
  if (_cleanupSteps is EqualUnmodifiableListView) return _cleanupSteps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cleanupSteps);
}

/// Tags for categorization
 final  List<String> _tags;
/// Tags for categorization
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

/// Execution tracking data
@override final  ActionExecution? execution;
/// When this action was created
@override final  DateTime createdAt;
/// When this action was last updated
@override final  DateTime? updatedAt;
/// Who created this action
@override@JsonKey() final  String createdBy;
/// Template ID this action was generated from
@override final  String? templateId;
/// Additional metadata
 final  Map<String, dynamic> _metadata;
/// Additional metadata
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of AttackPlanAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttackPlanActionCopyWith<_AttackPlanAction> get copyWith => __$AttackPlanActionCopyWithImpl<_AttackPlanAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttackPlanActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttackPlanAction&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.objective, objective) || other.objective == objective)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.riskLevel, riskLevel) || other.riskLevel == riskLevel)&&const DeepCollectionEquality().equals(other._triggerEvents, _triggerEvents)&&const DeepCollectionEquality().equals(other._risks, _risks)&&const DeepCollectionEquality().equals(other._procedure, _procedure)&&const DeepCollectionEquality().equals(other._tools, _tools)&&const DeepCollectionEquality().equals(other._equipment, _equipment)&&const DeepCollectionEquality().equals(other._references, _references)&&const DeepCollectionEquality().equals(other._suggestedFindings, _suggestedFindings)&&const DeepCollectionEquality().equals(other._cleanupSteps, _cleanupSteps)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.execution, execution) || other.execution == execution)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,projectId,title,objective,status,priority,riskLevel,const DeepCollectionEquality().hash(_triggerEvents),const DeepCollectionEquality().hash(_risks),const DeepCollectionEquality().hash(_procedure),const DeepCollectionEquality().hash(_tools),const DeepCollectionEquality().hash(_equipment),const DeepCollectionEquality().hash(_references),const DeepCollectionEquality().hash(_suggestedFindings),const DeepCollectionEquality().hash(_cleanupSteps),const DeepCollectionEquality().hash(_tags),execution,createdAt,updatedAt,createdBy,templateId,const DeepCollectionEquality().hash(_metadata)]);

@override
String toString() {
  return 'AttackPlanAction(id: $id, projectId: $projectId, title: $title, objective: $objective, status: $status, priority: $priority, riskLevel: $riskLevel, triggerEvents: $triggerEvents, risks: $risks, procedure: $procedure, tools: $tools, equipment: $equipment, references: $references, suggestedFindings: $suggestedFindings, cleanupSteps: $cleanupSteps, tags: $tags, execution: $execution, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, templateId: $templateId, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$AttackPlanActionCopyWith<$Res> implements $AttackPlanActionCopyWith<$Res> {
  factory _$AttackPlanActionCopyWith(_AttackPlanAction value, $Res Function(_AttackPlanAction) _then) = __$AttackPlanActionCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String title, String objective, ActionStatus status, ActionPriority priority, ActionRiskLevel riskLevel, List<TriggerEvent> triggerEvents, List<ActionRisk> risks, List<ProcedureStep> procedure, List<ActionTool> tools, List<ActionEquipment> equipment, List<ActionReference> references, List<SuggestedFinding> suggestedFindings, List<String> cleanupSteps, List<String> tags, ActionExecution? execution, DateTime createdAt, DateTime? updatedAt, String createdBy, String? templateId, Map<String, dynamic> metadata
});


@override $ActionExecutionCopyWith<$Res>? get execution;

}
/// @nodoc
class __$AttackPlanActionCopyWithImpl<$Res>
    implements _$AttackPlanActionCopyWith<$Res> {
  __$AttackPlanActionCopyWithImpl(this._self, this._then);

  final _AttackPlanAction _self;
  final $Res Function(_AttackPlanAction) _then;

/// Create a copy of AttackPlanAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? objective = null,Object? status = null,Object? priority = null,Object? riskLevel = null,Object? triggerEvents = null,Object? risks = null,Object? procedure = null,Object? tools = null,Object? equipment = null,Object? references = null,Object? suggestedFindings = null,Object? cleanupSteps = null,Object? tags = null,Object? execution = freezed,Object? createdAt = null,Object? updatedAt = freezed,Object? createdBy = null,Object? templateId = freezed,Object? metadata = null,}) {
  return _then(_AttackPlanAction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,objective: null == objective ? _self.objective : objective // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ActionStatus,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as ActionPriority,riskLevel: null == riskLevel ? _self.riskLevel : riskLevel // ignore: cast_nullable_to_non_nullable
as ActionRiskLevel,triggerEvents: null == triggerEvents ? _self._triggerEvents : triggerEvents // ignore: cast_nullable_to_non_nullable
as List<TriggerEvent>,risks: null == risks ? _self._risks : risks // ignore: cast_nullable_to_non_nullable
as List<ActionRisk>,procedure: null == procedure ? _self._procedure : procedure // ignore: cast_nullable_to_non_nullable
as List<ProcedureStep>,tools: null == tools ? _self._tools : tools // ignore: cast_nullable_to_non_nullable
as List<ActionTool>,equipment: null == equipment ? _self._equipment : equipment // ignore: cast_nullable_to_non_nullable
as List<ActionEquipment>,references: null == references ? _self._references : references // ignore: cast_nullable_to_non_nullable
as List<ActionReference>,suggestedFindings: null == suggestedFindings ? _self._suggestedFindings : suggestedFindings // ignore: cast_nullable_to_non_nullable
as List<SuggestedFinding>,cleanupSteps: null == cleanupSteps ? _self._cleanupSteps : cleanupSteps // ignore: cast_nullable_to_non_nullable
as List<String>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,execution: freezed == execution ? _self.execution : execution // ignore: cast_nullable_to_non_nullable
as ActionExecution?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

/// Create a copy of AttackPlanAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ActionExecutionCopyWith<$Res>? get execution {
    if (_self.execution == null) {
    return null;
  }

  return $ActionExecutionCopyWith<$Res>(_self.execution!, (value) {
    return _then(_self.copyWith(execution: value));
  });
}
}

// dart format on
