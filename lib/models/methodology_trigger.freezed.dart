// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'methodology_trigger.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TriggerCondition {

 String get property; TriggerOperator get operator; dynamic get value;// Can be string, int, bool, list, etc.
 String? get description;
/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerConditionCopyWith<TriggerCondition> get copyWith => _$TriggerConditionCopyWithImpl<TriggerCondition>(this as TriggerCondition, _$identity);

  /// Serializes this TriggerCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerCondition&&(identical(other.property, property) || other.property == property)&&(identical(other.operator, operator) || other.operator == operator)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,property,operator,const DeepCollectionEquality().hash(value),description);

@override
String toString() {
  return 'TriggerCondition(property: $property, operator: $operator, value: $value, description: $description)';
}


}

/// @nodoc
abstract mixin class $TriggerConditionCopyWith<$Res>  {
  factory $TriggerConditionCopyWith(TriggerCondition value, $Res Function(TriggerCondition) _then) = _$TriggerConditionCopyWithImpl;
@useResult
$Res call({
 String property, TriggerOperator operator, dynamic value, String? description
});




}
/// @nodoc
class _$TriggerConditionCopyWithImpl<$Res>
    implements $TriggerConditionCopyWith<$Res> {
  _$TriggerConditionCopyWithImpl(this._self, this._then);

  final TriggerCondition _self;
  final $Res Function(TriggerCondition) _then;

/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? property = null,Object? operator = null,Object? value = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
property: null == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as String,operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as TriggerOperator,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerCondition].
extension TriggerConditionPatterns on TriggerCondition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerCondition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerCondition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerCondition value)  $default,){
final _that = this;
switch (_that) {
case _TriggerCondition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerCondition value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerCondition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String property,  TriggerOperator operator,  dynamic value,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerCondition() when $default != null:
return $default(_that.property,_that.operator,_that.value,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String property,  TriggerOperator operator,  dynamic value,  String? description)  $default,) {final _that = this;
switch (_that) {
case _TriggerCondition():
return $default(_that.property,_that.operator,_that.value,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String property,  TriggerOperator operator,  dynamic value,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _TriggerCondition() when $default != null:
return $default(_that.property,_that.operator,_that.value,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerCondition implements TriggerCondition {
  const _TriggerCondition({required this.property, required this.operator, this.value, this.description});
  factory _TriggerCondition.fromJson(Map<String, dynamic> json) => _$TriggerConditionFromJson(json);

@override final  String property;
@override final  TriggerOperator operator;
@override final  dynamic value;
// Can be string, int, bool, list, etc.
@override final  String? description;

/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerConditionCopyWith<_TriggerCondition> get copyWith => __$TriggerConditionCopyWithImpl<_TriggerCondition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerConditionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerCondition&&(identical(other.property, property) || other.property == property)&&(identical(other.operator, operator) || other.operator == operator)&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,property,operator,const DeepCollectionEquality().hash(value),description);

@override
String toString() {
  return 'TriggerCondition(property: $property, operator: $operator, value: $value, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TriggerConditionCopyWith<$Res> implements $TriggerConditionCopyWith<$Res> {
  factory _$TriggerConditionCopyWith(_TriggerCondition value, $Res Function(_TriggerCondition) _then) = __$TriggerConditionCopyWithImpl;
@override @useResult
$Res call({
 String property, TriggerOperator operator, dynamic value, String? description
});




}
/// @nodoc
class __$TriggerConditionCopyWithImpl<$Res>
    implements _$TriggerConditionCopyWith<$Res> {
  __$TriggerConditionCopyWithImpl(this._self, this._then);

  final _TriggerCondition _self;
  final $Res Function(_TriggerCondition) _then;

/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? property = null,Object? operator = null,Object? value = freezed,Object? description = freezed,}) {
  return _then(_TriggerCondition(
property: null == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as String,operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as TriggerOperator,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as dynamic,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TriggerConditionGroup {

 LogicalOperator get operator; List<dynamic> get conditions;
/// Create a copy of TriggerConditionGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerConditionGroupCopyWith<TriggerConditionGroup> get copyWith => _$TriggerConditionGroupCopyWithImpl<TriggerConditionGroup>(this as TriggerConditionGroup, _$identity);

  /// Serializes this TriggerConditionGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerConditionGroup&&(identical(other.operator, operator) || other.operator == operator)&&const DeepCollectionEquality().equals(other.conditions, conditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operator,const DeepCollectionEquality().hash(conditions));

@override
String toString() {
  return 'TriggerConditionGroup(operator: $operator, conditions: $conditions)';
}


}

/// @nodoc
abstract mixin class $TriggerConditionGroupCopyWith<$Res>  {
  factory $TriggerConditionGroupCopyWith(TriggerConditionGroup value, $Res Function(TriggerConditionGroup) _then) = _$TriggerConditionGroupCopyWithImpl;
@useResult
$Res call({
 LogicalOperator operator, List<dynamic> conditions
});




}
/// @nodoc
class _$TriggerConditionGroupCopyWithImpl<$Res>
    implements $TriggerConditionGroupCopyWith<$Res> {
  _$TriggerConditionGroupCopyWithImpl(this._self, this._then);

  final TriggerConditionGroup _self;
  final $Res Function(TriggerConditionGroup) _then;

/// Create a copy of TriggerConditionGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? operator = null,Object? conditions = null,}) {
  return _then(_self.copyWith(
operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as LogicalOperator,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerConditionGroup].
extension TriggerConditionGroupPatterns on TriggerConditionGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerConditionGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerConditionGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerConditionGroup value)  $default,){
final _that = this;
switch (_that) {
case _TriggerConditionGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerConditionGroup value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerConditionGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LogicalOperator operator,  List<dynamic> conditions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerConditionGroup() when $default != null:
return $default(_that.operator,_that.conditions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LogicalOperator operator,  List<dynamic> conditions)  $default,) {final _that = this;
switch (_that) {
case _TriggerConditionGroup():
return $default(_that.operator,_that.conditions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LogicalOperator operator,  List<dynamic> conditions)?  $default,) {final _that = this;
switch (_that) {
case _TriggerConditionGroup() when $default != null:
return $default(_that.operator,_that.conditions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerConditionGroup implements TriggerConditionGroup {
  const _TriggerConditionGroup({required this.operator, required final  List<dynamic> conditions}): _conditions = conditions;
  factory _TriggerConditionGroup.fromJson(Map<String, dynamic> json) => _$TriggerConditionGroupFromJson(json);

@override final  LogicalOperator operator;
 final  List<dynamic> _conditions;
@override List<dynamic> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}


/// Create a copy of TriggerConditionGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerConditionGroupCopyWith<_TriggerConditionGroup> get copyWith => __$TriggerConditionGroupCopyWithImpl<_TriggerConditionGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerConditionGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerConditionGroup&&(identical(other.operator, operator) || other.operator == operator)&&const DeepCollectionEquality().equals(other._conditions, _conditions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,operator,const DeepCollectionEquality().hash(_conditions));

@override
String toString() {
  return 'TriggerConditionGroup(operator: $operator, conditions: $conditions)';
}


}

/// @nodoc
abstract mixin class _$TriggerConditionGroupCopyWith<$Res> implements $TriggerConditionGroupCopyWith<$Res> {
  factory _$TriggerConditionGroupCopyWith(_TriggerConditionGroup value, $Res Function(_TriggerConditionGroup) _then) = __$TriggerConditionGroupCopyWithImpl;
@override @useResult
$Res call({
 LogicalOperator operator, List<dynamic> conditions
});




}
/// @nodoc
class __$TriggerConditionGroupCopyWithImpl<$Res>
    implements _$TriggerConditionGroupCopyWith<$Res> {
  __$TriggerConditionGroupCopyWithImpl(this._self, this._then);

  final _TriggerConditionGroup _self;
  final $Res Function(_TriggerConditionGroup) _then;

/// Create a copy of TriggerConditionGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? operator = null,Object? conditions = null,}) {
  return _then(_TriggerConditionGroup(
operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as LogicalOperator,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}


/// @nodoc
mixin _$MethodologyTrigger {

 String get id; String get methodologyId; String get name; String? get description;// Asset type this trigger applies to
 AssetType get assetType;// Trigger conditions (can be simple or complex)
 dynamic get conditions;// TriggerCondition or TriggerConditionGroup
// Priority for ordering triggers
 int get priority;// Batch processing configuration
 bool get batchCapable; String? get batchCriteria;// Property to group by for batching
 String? get batchCommand;// Template for batch command
 int? get maxBatchSize;// Deduplication
 String get deduplicationKeyTemplate;// e.g., "{asset.id}:{methodology}:{hash}"
 Duration? get cooldownPeriod;// Don't retrigger within this period
// Command templates
 String? get individualCommand;// Command for single asset
 Map<String, String>? get commandVariants;// Different commands for different conditions
// Expected outcomes
 List<String>? get expectedPropertyUpdates;// Properties that should be updated
 List<AssetType>? get expectedAssetDiscovery;// Types of assets that might be discovered
// Metadata
 List<String> get tags; bool get enabled;
/// Create a copy of MethodologyTrigger
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MethodologyTriggerCopyWith<MethodologyTrigger> get copyWith => _$MethodologyTriggerCopyWithImpl<MethodologyTrigger>(this as MethodologyTrigger, _$identity);

  /// Serializes this MethodologyTrigger to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MethodologyTrigger&&(identical(other.id, id) || other.id == id)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.batchCapable, batchCapable) || other.batchCapable == batchCapable)&&(identical(other.batchCriteria, batchCriteria) || other.batchCriteria == batchCriteria)&&(identical(other.batchCommand, batchCommand) || other.batchCommand == batchCommand)&&(identical(other.maxBatchSize, maxBatchSize) || other.maxBatchSize == maxBatchSize)&&(identical(other.deduplicationKeyTemplate, deduplicationKeyTemplate) || other.deduplicationKeyTemplate == deduplicationKeyTemplate)&&(identical(other.cooldownPeriod, cooldownPeriod) || other.cooldownPeriod == cooldownPeriod)&&(identical(other.individualCommand, individualCommand) || other.individualCommand == individualCommand)&&const DeepCollectionEquality().equals(other.commandVariants, commandVariants)&&const DeepCollectionEquality().equals(other.expectedPropertyUpdates, expectedPropertyUpdates)&&const DeepCollectionEquality().equals(other.expectedAssetDiscovery, expectedAssetDiscovery)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,methodologyId,name,description,assetType,const DeepCollectionEquality().hash(conditions),priority,batchCapable,batchCriteria,batchCommand,maxBatchSize,deduplicationKeyTemplate,cooldownPeriod,individualCommand,const DeepCollectionEquality().hash(commandVariants),const DeepCollectionEquality().hash(expectedPropertyUpdates),const DeepCollectionEquality().hash(expectedAssetDiscovery),const DeepCollectionEquality().hash(tags),enabled]);

@override
String toString() {
  return 'MethodologyTrigger(id: $id, methodologyId: $methodologyId, name: $name, description: $description, assetType: $assetType, conditions: $conditions, priority: $priority, batchCapable: $batchCapable, batchCriteria: $batchCriteria, batchCommand: $batchCommand, maxBatchSize: $maxBatchSize, deduplicationKeyTemplate: $deduplicationKeyTemplate, cooldownPeriod: $cooldownPeriod, individualCommand: $individualCommand, commandVariants: $commandVariants, expectedPropertyUpdates: $expectedPropertyUpdates, expectedAssetDiscovery: $expectedAssetDiscovery, tags: $tags, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $MethodologyTriggerCopyWith<$Res>  {
  factory $MethodologyTriggerCopyWith(MethodologyTrigger value, $Res Function(MethodologyTrigger) _then) = _$MethodologyTriggerCopyWithImpl;
@useResult
$Res call({
 String id, String methodologyId, String name, String? description, AssetType assetType, dynamic conditions, int priority, bool batchCapable, String? batchCriteria, String? batchCommand, int? maxBatchSize, String deduplicationKeyTemplate, Duration? cooldownPeriod, String? individualCommand, Map<String, String>? commandVariants, List<String>? expectedPropertyUpdates, List<AssetType>? expectedAssetDiscovery, List<String> tags, bool enabled
});




}
/// @nodoc
class _$MethodologyTriggerCopyWithImpl<$Res>
    implements $MethodologyTriggerCopyWith<$Res> {
  _$MethodologyTriggerCopyWithImpl(this._self, this._then);

  final MethodologyTrigger _self;
  final $Res Function(MethodologyTrigger) _then;

/// Create a copy of MethodologyTrigger
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? methodologyId = null,Object? name = null,Object? description = freezed,Object? assetType = null,Object? conditions = freezed,Object? priority = null,Object? batchCapable = null,Object? batchCriteria = freezed,Object? batchCommand = freezed,Object? maxBatchSize = freezed,Object? deduplicationKeyTemplate = null,Object? cooldownPeriod = freezed,Object? individualCommand = freezed,Object? commandVariants = freezed,Object? expectedPropertyUpdates = freezed,Object? expectedAssetDiscovery = freezed,Object? tags = null,Object? enabled = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as AssetType,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as dynamic,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,batchCapable: null == batchCapable ? _self.batchCapable : batchCapable // ignore: cast_nullable_to_non_nullable
as bool,batchCriteria: freezed == batchCriteria ? _self.batchCriteria : batchCriteria // ignore: cast_nullable_to_non_nullable
as String?,batchCommand: freezed == batchCommand ? _self.batchCommand : batchCommand // ignore: cast_nullable_to_non_nullable
as String?,maxBatchSize: freezed == maxBatchSize ? _self.maxBatchSize : maxBatchSize // ignore: cast_nullable_to_non_nullable
as int?,deduplicationKeyTemplate: null == deduplicationKeyTemplate ? _self.deduplicationKeyTemplate : deduplicationKeyTemplate // ignore: cast_nullable_to_non_nullable
as String,cooldownPeriod: freezed == cooldownPeriod ? _self.cooldownPeriod : cooldownPeriod // ignore: cast_nullable_to_non_nullable
as Duration?,individualCommand: freezed == individualCommand ? _self.individualCommand : individualCommand // ignore: cast_nullable_to_non_nullable
as String?,commandVariants: freezed == commandVariants ? _self.commandVariants : commandVariants // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,expectedPropertyUpdates: freezed == expectedPropertyUpdates ? _self.expectedPropertyUpdates : expectedPropertyUpdates // ignore: cast_nullable_to_non_nullable
as List<String>?,expectedAssetDiscovery: freezed == expectedAssetDiscovery ? _self.expectedAssetDiscovery : expectedAssetDiscovery // ignore: cast_nullable_to_non_nullable
as List<AssetType>?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MethodologyTrigger].
extension MethodologyTriggerPatterns on MethodologyTrigger {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MethodologyTrigger value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MethodologyTrigger() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MethodologyTrigger value)  $default,){
final _that = this;
switch (_that) {
case _MethodologyTrigger():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MethodologyTrigger value)?  $default,){
final _that = this;
switch (_that) {
case _MethodologyTrigger() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String methodologyId,  String name,  String? description,  AssetType assetType,  dynamic conditions,  int priority,  bool batchCapable,  String? batchCriteria,  String? batchCommand,  int? maxBatchSize,  String deduplicationKeyTemplate,  Duration? cooldownPeriod,  String? individualCommand,  Map<String, String>? commandVariants,  List<String>? expectedPropertyUpdates,  List<AssetType>? expectedAssetDiscovery,  List<String> tags,  bool enabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MethodologyTrigger() when $default != null:
return $default(_that.id,_that.methodologyId,_that.name,_that.description,_that.assetType,_that.conditions,_that.priority,_that.batchCapable,_that.batchCriteria,_that.batchCommand,_that.maxBatchSize,_that.deduplicationKeyTemplate,_that.cooldownPeriod,_that.individualCommand,_that.commandVariants,_that.expectedPropertyUpdates,_that.expectedAssetDiscovery,_that.tags,_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String methodologyId,  String name,  String? description,  AssetType assetType,  dynamic conditions,  int priority,  bool batchCapable,  String? batchCriteria,  String? batchCommand,  int? maxBatchSize,  String deduplicationKeyTemplate,  Duration? cooldownPeriod,  String? individualCommand,  Map<String, String>? commandVariants,  List<String>? expectedPropertyUpdates,  List<AssetType>? expectedAssetDiscovery,  List<String> tags,  bool enabled)  $default,) {final _that = this;
switch (_that) {
case _MethodologyTrigger():
return $default(_that.id,_that.methodologyId,_that.name,_that.description,_that.assetType,_that.conditions,_that.priority,_that.batchCapable,_that.batchCriteria,_that.batchCommand,_that.maxBatchSize,_that.deduplicationKeyTemplate,_that.cooldownPeriod,_that.individualCommand,_that.commandVariants,_that.expectedPropertyUpdates,_that.expectedAssetDiscovery,_that.tags,_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String methodologyId,  String name,  String? description,  AssetType assetType,  dynamic conditions,  int priority,  bool batchCapable,  String? batchCriteria,  String? batchCommand,  int? maxBatchSize,  String deduplicationKeyTemplate,  Duration? cooldownPeriod,  String? individualCommand,  Map<String, String>? commandVariants,  List<String>? expectedPropertyUpdates,  List<AssetType>? expectedAssetDiscovery,  List<String> tags,  bool enabled)?  $default,) {final _that = this;
switch (_that) {
case _MethodologyTrigger() when $default != null:
return $default(_that.id,_that.methodologyId,_that.name,_that.description,_that.assetType,_that.conditions,_that.priority,_that.batchCapable,_that.batchCriteria,_that.batchCommand,_that.maxBatchSize,_that.deduplicationKeyTemplate,_that.cooldownPeriod,_that.individualCommand,_that.commandVariants,_that.expectedPropertyUpdates,_that.expectedAssetDiscovery,_that.tags,_that.enabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MethodologyTrigger implements MethodologyTrigger {
  const _MethodologyTrigger({required this.id, required this.methodologyId, required this.name, this.description, required this.assetType, required this.conditions, required this.priority, required this.batchCapable, this.batchCriteria, this.batchCommand, this.maxBatchSize, required this.deduplicationKeyTemplate, this.cooldownPeriod, this.individualCommand, final  Map<String, String>? commandVariants, final  List<String>? expectedPropertyUpdates, final  List<AssetType>? expectedAssetDiscovery, required final  List<String> tags, required this.enabled}): _commandVariants = commandVariants,_expectedPropertyUpdates = expectedPropertyUpdates,_expectedAssetDiscovery = expectedAssetDiscovery,_tags = tags;
  factory _MethodologyTrigger.fromJson(Map<String, dynamic> json) => _$MethodologyTriggerFromJson(json);

@override final  String id;
@override final  String methodologyId;
@override final  String name;
@override final  String? description;
// Asset type this trigger applies to
@override final  AssetType assetType;
// Trigger conditions (can be simple or complex)
@override final  dynamic conditions;
// TriggerCondition or TriggerConditionGroup
// Priority for ordering triggers
@override final  int priority;
// Batch processing configuration
@override final  bool batchCapable;
@override final  String? batchCriteria;
// Property to group by for batching
@override final  String? batchCommand;
// Template for batch command
@override final  int? maxBatchSize;
// Deduplication
@override final  String deduplicationKeyTemplate;
// e.g., "{asset.id}:{methodology}:{hash}"
@override final  Duration? cooldownPeriod;
// Don't retrigger within this period
// Command templates
@override final  String? individualCommand;
// Command for single asset
 final  Map<String, String>? _commandVariants;
// Command for single asset
@override Map<String, String>? get commandVariants {
  final value = _commandVariants;
  if (value == null) return null;
  if (_commandVariants is EqualUnmodifiableMapView) return _commandVariants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Different commands for different conditions
// Expected outcomes
 final  List<String>? _expectedPropertyUpdates;
// Different commands for different conditions
// Expected outcomes
@override List<String>? get expectedPropertyUpdates {
  final value = _expectedPropertyUpdates;
  if (value == null) return null;
  if (_expectedPropertyUpdates is EqualUnmodifiableListView) return _expectedPropertyUpdates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Properties that should be updated
 final  List<AssetType>? _expectedAssetDiscovery;
// Properties that should be updated
@override List<AssetType>? get expectedAssetDiscovery {
  final value = _expectedAssetDiscovery;
  if (value == null) return null;
  if (_expectedAssetDiscovery is EqualUnmodifiableListView) return _expectedAssetDiscovery;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Types of assets that might be discovered
// Metadata
 final  List<String> _tags;
// Types of assets that might be discovered
// Metadata
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override final  bool enabled;

/// Create a copy of MethodologyTrigger
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MethodologyTriggerCopyWith<_MethodologyTrigger> get copyWith => __$MethodologyTriggerCopyWithImpl<_MethodologyTrigger>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MethodologyTriggerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MethodologyTrigger&&(identical(other.id, id) || other.id == id)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.batchCapable, batchCapable) || other.batchCapable == batchCapable)&&(identical(other.batchCriteria, batchCriteria) || other.batchCriteria == batchCriteria)&&(identical(other.batchCommand, batchCommand) || other.batchCommand == batchCommand)&&(identical(other.maxBatchSize, maxBatchSize) || other.maxBatchSize == maxBatchSize)&&(identical(other.deduplicationKeyTemplate, deduplicationKeyTemplate) || other.deduplicationKeyTemplate == deduplicationKeyTemplate)&&(identical(other.cooldownPeriod, cooldownPeriod) || other.cooldownPeriod == cooldownPeriod)&&(identical(other.individualCommand, individualCommand) || other.individualCommand == individualCommand)&&const DeepCollectionEquality().equals(other._commandVariants, _commandVariants)&&const DeepCollectionEquality().equals(other._expectedPropertyUpdates, _expectedPropertyUpdates)&&const DeepCollectionEquality().equals(other._expectedAssetDiscovery, _expectedAssetDiscovery)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.enabled, enabled) || other.enabled == enabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,methodologyId,name,description,assetType,const DeepCollectionEquality().hash(conditions),priority,batchCapable,batchCriteria,batchCommand,maxBatchSize,deduplicationKeyTemplate,cooldownPeriod,individualCommand,const DeepCollectionEquality().hash(_commandVariants),const DeepCollectionEquality().hash(_expectedPropertyUpdates),const DeepCollectionEquality().hash(_expectedAssetDiscovery),const DeepCollectionEquality().hash(_tags),enabled]);

@override
String toString() {
  return 'MethodologyTrigger(id: $id, methodologyId: $methodologyId, name: $name, description: $description, assetType: $assetType, conditions: $conditions, priority: $priority, batchCapable: $batchCapable, batchCriteria: $batchCriteria, batchCommand: $batchCommand, maxBatchSize: $maxBatchSize, deduplicationKeyTemplate: $deduplicationKeyTemplate, cooldownPeriod: $cooldownPeriod, individualCommand: $individualCommand, commandVariants: $commandVariants, expectedPropertyUpdates: $expectedPropertyUpdates, expectedAssetDiscovery: $expectedAssetDiscovery, tags: $tags, enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$MethodologyTriggerCopyWith<$Res> implements $MethodologyTriggerCopyWith<$Res> {
  factory _$MethodologyTriggerCopyWith(_MethodologyTrigger value, $Res Function(_MethodologyTrigger) _then) = __$MethodologyTriggerCopyWithImpl;
@override @useResult
$Res call({
 String id, String methodologyId, String name, String? description, AssetType assetType, dynamic conditions, int priority, bool batchCapable, String? batchCriteria, String? batchCommand, int? maxBatchSize, String deduplicationKeyTemplate, Duration? cooldownPeriod, String? individualCommand, Map<String, String>? commandVariants, List<String>? expectedPropertyUpdates, List<AssetType>? expectedAssetDiscovery, List<String> tags, bool enabled
});




}
/// @nodoc
class __$MethodologyTriggerCopyWithImpl<$Res>
    implements _$MethodologyTriggerCopyWith<$Res> {
  __$MethodologyTriggerCopyWithImpl(this._self, this._then);

  final _MethodologyTrigger _self;
  final $Res Function(_MethodologyTrigger) _then;

/// Create a copy of MethodologyTrigger
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? methodologyId = null,Object? name = null,Object? description = freezed,Object? assetType = null,Object? conditions = freezed,Object? priority = null,Object? batchCapable = null,Object? batchCriteria = freezed,Object? batchCommand = freezed,Object? maxBatchSize = freezed,Object? deduplicationKeyTemplate = null,Object? cooldownPeriod = freezed,Object? individualCommand = freezed,Object? commandVariants = freezed,Object? expectedPropertyUpdates = freezed,Object? expectedAssetDiscovery = freezed,Object? tags = null,Object? enabled = null,}) {
  return _then(_MethodologyTrigger(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as AssetType,conditions: freezed == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as dynamic,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,batchCapable: null == batchCapable ? _self.batchCapable : batchCapable // ignore: cast_nullable_to_non_nullable
as bool,batchCriteria: freezed == batchCriteria ? _self.batchCriteria : batchCriteria // ignore: cast_nullable_to_non_nullable
as String?,batchCommand: freezed == batchCommand ? _self.batchCommand : batchCommand // ignore: cast_nullable_to_non_nullable
as String?,maxBatchSize: freezed == maxBatchSize ? _self.maxBatchSize : maxBatchSize // ignore: cast_nullable_to_non_nullable
as int?,deduplicationKeyTemplate: null == deduplicationKeyTemplate ? _self.deduplicationKeyTemplate : deduplicationKeyTemplate // ignore: cast_nullable_to_non_nullable
as String,cooldownPeriod: freezed == cooldownPeriod ? _self.cooldownPeriod : cooldownPeriod // ignore: cast_nullable_to_non_nullable
as Duration?,individualCommand: freezed == individualCommand ? _self.individualCommand : individualCommand // ignore: cast_nullable_to_non_nullable
as String?,commandVariants: freezed == commandVariants ? _self._commandVariants : commandVariants // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,expectedPropertyUpdates: freezed == expectedPropertyUpdates ? _self._expectedPropertyUpdates : expectedPropertyUpdates // ignore: cast_nullable_to_non_nullable
as List<String>?,expectedAssetDiscovery: freezed == expectedAssetDiscovery ? _self._expectedAssetDiscovery : expectedAssetDiscovery // ignore: cast_nullable_to_non_nullable
as List<AssetType>?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$TriggeredMethodology {

 String get id; String get methodologyId; String get triggerId; Asset get asset; String get deduplicationKey;// Execution context
 Map<String, dynamic> get variables;// Variables extracted from asset properties
 String? get command;// Resolved command with variables substituted
// Batch information
 bool? get isPartOfBatch; String? get batchId; List<Asset>? get batchAssets;// Other assets in the same batch
// Status
 DateTime get triggeredAt; DateTime? get executedAt; DateTime? get completedAt; String? get status;// "pending", "executing", "completed", "failed", "skipped"
// Priority
 int get priority;
/// Create a copy of TriggeredMethodology
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggeredMethodologyCopyWith<TriggeredMethodology> get copyWith => _$TriggeredMethodologyCopyWithImpl<TriggeredMethodology>(this as TriggeredMethodology, _$identity);

  /// Serializes this TriggeredMethodology to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggeredMethodology&&(identical(other.id, id) || other.id == id)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.deduplicationKey, deduplicationKey) || other.deduplicationKey == deduplicationKey)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.command, command) || other.command == command)&&(identical(other.isPartOfBatch, isPartOfBatch) || other.isPartOfBatch == isPartOfBatch)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&const DeepCollectionEquality().equals(other.batchAssets, batchAssets)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,methodologyId,triggerId,asset,deduplicationKey,const DeepCollectionEquality().hash(variables),command,isPartOfBatch,batchId,const DeepCollectionEquality().hash(batchAssets),triggeredAt,executedAt,completedAt,status,priority);

@override
String toString() {
  return 'TriggeredMethodology(id: $id, methodologyId: $methodologyId, triggerId: $triggerId, asset: $asset, deduplicationKey: $deduplicationKey, variables: $variables, command: $command, isPartOfBatch: $isPartOfBatch, batchId: $batchId, batchAssets: $batchAssets, triggeredAt: $triggeredAt, executedAt: $executedAt, completedAt: $completedAt, status: $status, priority: $priority)';
}


}

/// @nodoc
abstract mixin class $TriggeredMethodologyCopyWith<$Res>  {
  factory $TriggeredMethodologyCopyWith(TriggeredMethodology value, $Res Function(TriggeredMethodology) _then) = _$TriggeredMethodologyCopyWithImpl;
@useResult
$Res call({
 String id, String methodologyId, String triggerId, Asset asset, String deduplicationKey, Map<String, dynamic> variables, String? command, bool? isPartOfBatch, String? batchId, List<Asset>? batchAssets, DateTime triggeredAt, DateTime? executedAt, DateTime? completedAt, String? status, int priority
});


$AssetCopyWith<$Res> get asset;

}
/// @nodoc
class _$TriggeredMethodologyCopyWithImpl<$Res>
    implements $TriggeredMethodologyCopyWith<$Res> {
  _$TriggeredMethodologyCopyWithImpl(this._self, this._then);

  final TriggeredMethodology _self;
  final $Res Function(TriggeredMethodology) _then;

/// Create a copy of TriggeredMethodology
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? methodologyId = null,Object? triggerId = null,Object? asset = null,Object? deduplicationKey = null,Object? variables = null,Object? command = freezed,Object? isPartOfBatch = freezed,Object? batchId = freezed,Object? batchAssets = freezed,Object? triggeredAt = null,Object? executedAt = freezed,Object? completedAt = freezed,Object? status = freezed,Object? priority = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,deduplicationKey: null == deduplicationKey ? _self.deduplicationKey : deduplicationKey // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,command: freezed == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String?,isPartOfBatch: freezed == isPartOfBatch ? _self.isPartOfBatch : isPartOfBatch // ignore: cast_nullable_to_non_nullable
as bool?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchAssets: freezed == batchAssets ? _self.batchAssets : batchAssets // ignore: cast_nullable_to_non_nullable
as List<Asset>?,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,executedAt: freezed == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of TriggeredMethodology
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssetCopyWith<$Res> get asset {
  
  return $AssetCopyWith<$Res>(_self.asset, (value) {
    return _then(_self.copyWith(asset: value));
  });
}
}


/// Adds pattern-matching-related methods to [TriggeredMethodology].
extension TriggeredMethodologyPatterns on TriggeredMethodology {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggeredMethodology value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggeredMethodology() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggeredMethodology value)  $default,){
final _that = this;
switch (_that) {
case _TriggeredMethodology():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggeredMethodology value)?  $default,){
final _that = this;
switch (_that) {
case _TriggeredMethodology() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String methodologyId,  String triggerId,  Asset asset,  String deduplicationKey,  Map<String, dynamic> variables,  String? command,  bool? isPartOfBatch,  String? batchId,  List<Asset>? batchAssets,  DateTime triggeredAt,  DateTime? executedAt,  DateTime? completedAt,  String? status,  int priority)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggeredMethodology() when $default != null:
return $default(_that.id,_that.methodologyId,_that.triggerId,_that.asset,_that.deduplicationKey,_that.variables,_that.command,_that.isPartOfBatch,_that.batchId,_that.batchAssets,_that.triggeredAt,_that.executedAt,_that.completedAt,_that.status,_that.priority);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String methodologyId,  String triggerId,  Asset asset,  String deduplicationKey,  Map<String, dynamic> variables,  String? command,  bool? isPartOfBatch,  String? batchId,  List<Asset>? batchAssets,  DateTime triggeredAt,  DateTime? executedAt,  DateTime? completedAt,  String? status,  int priority)  $default,) {final _that = this;
switch (_that) {
case _TriggeredMethodology():
return $default(_that.id,_that.methodologyId,_that.triggerId,_that.asset,_that.deduplicationKey,_that.variables,_that.command,_that.isPartOfBatch,_that.batchId,_that.batchAssets,_that.triggeredAt,_that.executedAt,_that.completedAt,_that.status,_that.priority);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String methodologyId,  String triggerId,  Asset asset,  String deduplicationKey,  Map<String, dynamic> variables,  String? command,  bool? isPartOfBatch,  String? batchId,  List<Asset>? batchAssets,  DateTime triggeredAt,  DateTime? executedAt,  DateTime? completedAt,  String? status,  int priority)?  $default,) {final _that = this;
switch (_that) {
case _TriggeredMethodology() when $default != null:
return $default(_that.id,_that.methodologyId,_that.triggerId,_that.asset,_that.deduplicationKey,_that.variables,_that.command,_that.isPartOfBatch,_that.batchId,_that.batchAssets,_that.triggeredAt,_that.executedAt,_that.completedAt,_that.status,_that.priority);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggeredMethodology implements TriggeredMethodology {
  const _TriggeredMethodology({required this.id, required this.methodologyId, required this.triggerId, required this.asset, required this.deduplicationKey, required final  Map<String, dynamic> variables, this.command, this.isPartOfBatch, this.batchId, final  List<Asset>? batchAssets, required this.triggeredAt, this.executedAt, this.completedAt, this.status, required this.priority}): _variables = variables,_batchAssets = batchAssets;
  factory _TriggeredMethodology.fromJson(Map<String, dynamic> json) => _$TriggeredMethodologyFromJson(json);

@override final  String id;
@override final  String methodologyId;
@override final  String triggerId;
@override final  Asset asset;
@override final  String deduplicationKey;
// Execution context
 final  Map<String, dynamic> _variables;
// Execution context
@override Map<String, dynamic> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

// Variables extracted from asset properties
@override final  String? command;
// Resolved command with variables substituted
// Batch information
@override final  bool? isPartOfBatch;
@override final  String? batchId;
 final  List<Asset>? _batchAssets;
@override List<Asset>? get batchAssets {
  final value = _batchAssets;
  if (value == null) return null;
  if (_batchAssets is EqualUnmodifiableListView) return _batchAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Other assets in the same batch
// Status
@override final  DateTime triggeredAt;
@override final  DateTime? executedAt;
@override final  DateTime? completedAt;
@override final  String? status;
// "pending", "executing", "completed", "failed", "skipped"
// Priority
@override final  int priority;

/// Create a copy of TriggeredMethodology
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggeredMethodologyCopyWith<_TriggeredMethodology> get copyWith => __$TriggeredMethodologyCopyWithImpl<_TriggeredMethodology>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggeredMethodologyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggeredMethodology&&(identical(other.id, id) || other.id == id)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.asset, asset) || other.asset == asset)&&(identical(other.deduplicationKey, deduplicationKey) || other.deduplicationKey == deduplicationKey)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.command, command) || other.command == command)&&(identical(other.isPartOfBatch, isPartOfBatch) || other.isPartOfBatch == isPartOfBatch)&&(identical(other.batchId, batchId) || other.batchId == batchId)&&const DeepCollectionEquality().equals(other._batchAssets, _batchAssets)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,methodologyId,triggerId,asset,deduplicationKey,const DeepCollectionEquality().hash(_variables),command,isPartOfBatch,batchId,const DeepCollectionEquality().hash(_batchAssets),triggeredAt,executedAt,completedAt,status,priority);

@override
String toString() {
  return 'TriggeredMethodology(id: $id, methodologyId: $methodologyId, triggerId: $triggerId, asset: $asset, deduplicationKey: $deduplicationKey, variables: $variables, command: $command, isPartOfBatch: $isPartOfBatch, batchId: $batchId, batchAssets: $batchAssets, triggeredAt: $triggeredAt, executedAt: $executedAt, completedAt: $completedAt, status: $status, priority: $priority)';
}


}

/// @nodoc
abstract mixin class _$TriggeredMethodologyCopyWith<$Res> implements $TriggeredMethodologyCopyWith<$Res> {
  factory _$TriggeredMethodologyCopyWith(_TriggeredMethodology value, $Res Function(_TriggeredMethodology) _then) = __$TriggeredMethodologyCopyWithImpl;
@override @useResult
$Res call({
 String id, String methodologyId, String triggerId, Asset asset, String deduplicationKey, Map<String, dynamic> variables, String? command, bool? isPartOfBatch, String? batchId, List<Asset>? batchAssets, DateTime triggeredAt, DateTime? executedAt, DateTime? completedAt, String? status, int priority
});


@override $AssetCopyWith<$Res> get asset;

}
/// @nodoc
class __$TriggeredMethodologyCopyWithImpl<$Res>
    implements _$TriggeredMethodologyCopyWith<$Res> {
  __$TriggeredMethodologyCopyWithImpl(this._self, this._then);

  final _TriggeredMethodology _self;
  final $Res Function(_TriggeredMethodology) _then;

/// Create a copy of TriggeredMethodology
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? methodologyId = null,Object? triggerId = null,Object? asset = null,Object? deduplicationKey = null,Object? variables = null,Object? command = freezed,Object? isPartOfBatch = freezed,Object? batchId = freezed,Object? batchAssets = freezed,Object? triggeredAt = null,Object? executedAt = freezed,Object? completedAt = freezed,Object? status = freezed,Object? priority = null,}) {
  return _then(_TriggeredMethodology(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,asset: null == asset ? _self.asset : asset // ignore: cast_nullable_to_non_nullable
as Asset,deduplicationKey: null == deduplicationKey ? _self.deduplicationKey : deduplicationKey // ignore: cast_nullable_to_non_nullable
as String,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,command: freezed == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String?,isPartOfBatch: freezed == isPartOfBatch ? _self.isPartOfBatch : isPartOfBatch // ignore: cast_nullable_to_non_nullable
as bool?,batchId: freezed == batchId ? _self.batchId : batchId // ignore: cast_nullable_to_non_nullable
as String?,batchAssets: freezed == batchAssets ? _self._batchAssets : batchAssets // ignore: cast_nullable_to_non_nullable
as List<Asset>?,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,executedAt: freezed == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TriggeredMethodology
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AssetCopyWith<$Res> get asset {
  
  return $AssetCopyWith<$Res>(_self.asset, (value) {
    return _then(_self.copyWith(asset: value));
  });
}
}


/// @nodoc
mixin _$BatchedTrigger {

 String get id; String get methodologyId; List<TriggeredMethodology> get triggers; String get batchCommand; Map<String, dynamic> get batchVariables; int get priority; DateTime? get scheduledFor;
/// Create a copy of BatchedTrigger
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatchedTriggerCopyWith<BatchedTrigger> get copyWith => _$BatchedTriggerCopyWithImpl<BatchedTrigger>(this as BatchedTrigger, _$identity);

  /// Serializes this BatchedTrigger to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatchedTrigger&&(identical(other.id, id) || other.id == id)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&const DeepCollectionEquality().equals(other.triggers, triggers)&&(identical(other.batchCommand, batchCommand) || other.batchCommand == batchCommand)&&const DeepCollectionEquality().equals(other.batchVariables, batchVariables)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,methodologyId,const DeepCollectionEquality().hash(triggers),batchCommand,const DeepCollectionEquality().hash(batchVariables),priority,scheduledFor);

@override
String toString() {
  return 'BatchedTrigger(id: $id, methodologyId: $methodologyId, triggers: $triggers, batchCommand: $batchCommand, batchVariables: $batchVariables, priority: $priority, scheduledFor: $scheduledFor)';
}


}

/// @nodoc
abstract mixin class $BatchedTriggerCopyWith<$Res>  {
  factory $BatchedTriggerCopyWith(BatchedTrigger value, $Res Function(BatchedTrigger) _then) = _$BatchedTriggerCopyWithImpl;
@useResult
$Res call({
 String id, String methodologyId, List<TriggeredMethodology> triggers, String batchCommand, Map<String, dynamic> batchVariables, int priority, DateTime? scheduledFor
});




}
/// @nodoc
class _$BatchedTriggerCopyWithImpl<$Res>
    implements $BatchedTriggerCopyWith<$Res> {
  _$BatchedTriggerCopyWithImpl(this._self, this._then);

  final BatchedTrigger _self;
  final $Res Function(BatchedTrigger) _then;

/// Create a copy of BatchedTrigger
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? methodologyId = null,Object? triggers = null,Object? batchCommand = null,Object? batchVariables = null,Object? priority = null,Object? scheduledFor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,triggers: null == triggers ? _self.triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<TriggeredMethodology>,batchCommand: null == batchCommand ? _self.batchCommand : batchCommand // ignore: cast_nullable_to_non_nullable
as String,batchVariables: null == batchVariables ? _self.batchVariables : batchVariables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BatchedTrigger].
extension BatchedTriggerPatterns on BatchedTrigger {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatchedTrigger value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatchedTrigger() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatchedTrigger value)  $default,){
final _that = this;
switch (_that) {
case _BatchedTrigger():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatchedTrigger value)?  $default,){
final _that = this;
switch (_that) {
case _BatchedTrigger() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String methodologyId,  List<TriggeredMethodology> triggers,  String batchCommand,  Map<String, dynamic> batchVariables,  int priority,  DateTime? scheduledFor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatchedTrigger() when $default != null:
return $default(_that.id,_that.methodologyId,_that.triggers,_that.batchCommand,_that.batchVariables,_that.priority,_that.scheduledFor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String methodologyId,  List<TriggeredMethodology> triggers,  String batchCommand,  Map<String, dynamic> batchVariables,  int priority,  DateTime? scheduledFor)  $default,) {final _that = this;
switch (_that) {
case _BatchedTrigger():
return $default(_that.id,_that.methodologyId,_that.triggers,_that.batchCommand,_that.batchVariables,_that.priority,_that.scheduledFor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String methodologyId,  List<TriggeredMethodology> triggers,  String batchCommand,  Map<String, dynamic> batchVariables,  int priority,  DateTime? scheduledFor)?  $default,) {final _that = this;
switch (_that) {
case _BatchedTrigger() when $default != null:
return $default(_that.id,_that.methodologyId,_that.triggers,_that.batchCommand,_that.batchVariables,_that.priority,_that.scheduledFor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatchedTrigger implements BatchedTrigger {
  const _BatchedTrigger({required this.id, required this.methodologyId, required final  List<TriggeredMethodology> triggers, required this.batchCommand, required final  Map<String, dynamic> batchVariables, required this.priority, this.scheduledFor}): _triggers = triggers,_batchVariables = batchVariables;
  factory _BatchedTrigger.fromJson(Map<String, dynamic> json) => _$BatchedTriggerFromJson(json);

@override final  String id;
@override final  String methodologyId;
 final  List<TriggeredMethodology> _triggers;
@override List<TriggeredMethodology> get triggers {
  if (_triggers is EqualUnmodifiableListView) return _triggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_triggers);
}

@override final  String batchCommand;
 final  Map<String, dynamic> _batchVariables;
@override Map<String, dynamic> get batchVariables {
  if (_batchVariables is EqualUnmodifiableMapView) return _batchVariables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_batchVariables);
}

@override final  int priority;
@override final  DateTime? scheduledFor;

/// Create a copy of BatchedTrigger
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatchedTriggerCopyWith<_BatchedTrigger> get copyWith => __$BatchedTriggerCopyWithImpl<_BatchedTrigger>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatchedTriggerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatchedTrigger&&(identical(other.id, id) || other.id == id)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&const DeepCollectionEquality().equals(other._triggers, _triggers)&&(identical(other.batchCommand, batchCommand) || other.batchCommand == batchCommand)&&const DeepCollectionEquality().equals(other._batchVariables, _batchVariables)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,methodologyId,const DeepCollectionEquality().hash(_triggers),batchCommand,const DeepCollectionEquality().hash(_batchVariables),priority,scheduledFor);

@override
String toString() {
  return 'BatchedTrigger(id: $id, methodologyId: $methodologyId, triggers: $triggers, batchCommand: $batchCommand, batchVariables: $batchVariables, priority: $priority, scheduledFor: $scheduledFor)';
}


}

/// @nodoc
abstract mixin class _$BatchedTriggerCopyWith<$Res> implements $BatchedTriggerCopyWith<$Res> {
  factory _$BatchedTriggerCopyWith(_BatchedTrigger value, $Res Function(_BatchedTrigger) _then) = __$BatchedTriggerCopyWithImpl;
@override @useResult
$Res call({
 String id, String methodologyId, List<TriggeredMethodology> triggers, String batchCommand, Map<String, dynamic> batchVariables, int priority, DateTime? scheduledFor
});




}
/// @nodoc
class __$BatchedTriggerCopyWithImpl<$Res>
    implements _$BatchedTriggerCopyWith<$Res> {
  __$BatchedTriggerCopyWithImpl(this._self, this._then);

  final _BatchedTrigger _self;
  final $Res Function(_BatchedTrigger) _then;

/// Create a copy of BatchedTrigger
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? methodologyId = null,Object? triggers = null,Object? batchCommand = null,Object? batchVariables = null,Object? priority = null,Object? scheduledFor = freezed,}) {
  return _then(_BatchedTrigger(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,triggers: null == triggers ? _self._triggers : triggers // ignore: cast_nullable_to_non_nullable
as List<TriggeredMethodology>,batchCommand: null == batchCommand ? _self.batchCommand : batchCommand // ignore: cast_nullable_to_non_nullable
as String,batchVariables: null == batchVariables ? _self._batchVariables : batchVariables // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,scheduledFor: freezed == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
