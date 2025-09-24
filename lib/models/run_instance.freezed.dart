// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_instance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RunInstance {

/// Unique identifier for this run instance (RUN-YYYYMMDD-XXXX)
 String get runId;/// ID of the methodology template this instance is based on
 String get templateId;/// Version of the methodology template
 String get templateVersion;/// ID of the trigger that created this instance
 String get triggerId;/// ID of the asset this methodology is running against
 String get assetId;/// Values matched from the trigger evaluation
 Map<String, dynamic> get matchedValues;/// Resolved parameter values for the methodology
 Map<String, dynamic> get parameters;/// Current status of the run instance
 RunInstanceStatus get status;/// When this instance was created
 DateTime get createdAt;/// Who created this instance
 String get createdBy;/// List of evidence item IDs associated with this run
 List<String> get evidenceIds;/// List of finding IDs generated from this run
 List<String> get findingIds;/// History of status changes and actions
 List<HistoryEntry> get history;/// Optional notes about this run instance
 String? get notes;/// When this instance was last updated
 DateTime? get updatedAt;/// Priority assigned to this run (1-10, higher = more important)
 int get priority;/// Tags associated with this run instance
 List<String> get tags;
/// Create a copy of RunInstance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunInstanceCopyWith<RunInstance> get copyWith => _$RunInstanceCopyWithImpl<RunInstance>(this as RunInstance, _$identity);

  /// Serializes this RunInstance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunInstance&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.templateVersion, templateVersion) || other.templateVersion == templateVersion)&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&const DeepCollectionEquality().equals(other.matchedValues, matchedValues)&&const DeepCollectionEquality().equals(other.parameters, parameters)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other.evidenceIds, evidenceIds)&&const DeepCollectionEquality().equals(other.findingIds, findingIds)&&const DeepCollectionEquality().equals(other.history, history)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,templateId,templateVersion,triggerId,assetId,const DeepCollectionEquality().hash(matchedValues),const DeepCollectionEquality().hash(parameters),status,createdAt,createdBy,const DeepCollectionEquality().hash(evidenceIds),const DeepCollectionEquality().hash(findingIds),const DeepCollectionEquality().hash(history),notes,updatedAt,priority,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'RunInstance(runId: $runId, templateId: $templateId, templateVersion: $templateVersion, triggerId: $triggerId, assetId: $assetId, matchedValues: $matchedValues, parameters: $parameters, status: $status, createdAt: $createdAt, createdBy: $createdBy, evidenceIds: $evidenceIds, findingIds: $findingIds, history: $history, notes: $notes, updatedAt: $updatedAt, priority: $priority, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $RunInstanceCopyWith<$Res>  {
  factory $RunInstanceCopyWith(RunInstance value, $Res Function(RunInstance) _then) = _$RunInstanceCopyWithImpl;
@useResult
$Res call({
 String runId, String templateId, String templateVersion, String triggerId, String assetId, Map<String, dynamic> matchedValues, Map<String, dynamic> parameters, RunInstanceStatus status, DateTime createdAt, String createdBy, List<String> evidenceIds, List<String> findingIds, List<HistoryEntry> history, String? notes, DateTime? updatedAt, int priority, List<String> tags
});




}
/// @nodoc
class _$RunInstanceCopyWithImpl<$Res>
    implements $RunInstanceCopyWith<$Res> {
  _$RunInstanceCopyWithImpl(this._self, this._then);

  final RunInstance _self;
  final $Res Function(RunInstance) _then;

/// Create a copy of RunInstance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? templateId = null,Object? templateVersion = null,Object? triggerId = null,Object? assetId = null,Object? matchedValues = null,Object? parameters = null,Object? status = null,Object? createdAt = null,Object? createdBy = null,Object? evidenceIds = null,Object? findingIds = null,Object? history = null,Object? notes = freezed,Object? updatedAt = freezed,Object? priority = null,Object? tags = null,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,templateVersion: null == templateVersion ? _self.templateVersion : templateVersion // ignore: cast_nullable_to_non_nullable
as String,triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,matchedValues: null == matchedValues ? _self.matchedValues : matchedValues // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,parameters: null == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RunInstanceStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,evidenceIds: null == evidenceIds ? _self.evidenceIds : evidenceIds // ignore: cast_nullable_to_non_nullable
as List<String>,findingIds: null == findingIds ? _self.findingIds : findingIds // ignore: cast_nullable_to_non_nullable
as List<String>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [RunInstance].
extension RunInstancePatterns on RunInstance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunInstance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunInstance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunInstance value)  $default,){
final _that = this;
switch (_that) {
case _RunInstance():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunInstance value)?  $default,){
final _that = this;
switch (_that) {
case _RunInstance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String templateId,  String templateVersion,  String triggerId,  String assetId,  Map<String, dynamic> matchedValues,  Map<String, dynamic> parameters,  RunInstanceStatus status,  DateTime createdAt,  String createdBy,  List<String> evidenceIds,  List<String> findingIds,  List<HistoryEntry> history,  String? notes,  DateTime? updatedAt,  int priority,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunInstance() when $default != null:
return $default(_that.runId,_that.templateId,_that.templateVersion,_that.triggerId,_that.assetId,_that.matchedValues,_that.parameters,_that.status,_that.createdAt,_that.createdBy,_that.evidenceIds,_that.findingIds,_that.history,_that.notes,_that.updatedAt,_that.priority,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String templateId,  String templateVersion,  String triggerId,  String assetId,  Map<String, dynamic> matchedValues,  Map<String, dynamic> parameters,  RunInstanceStatus status,  DateTime createdAt,  String createdBy,  List<String> evidenceIds,  List<String> findingIds,  List<HistoryEntry> history,  String? notes,  DateTime? updatedAt,  int priority,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _RunInstance():
return $default(_that.runId,_that.templateId,_that.templateVersion,_that.triggerId,_that.assetId,_that.matchedValues,_that.parameters,_that.status,_that.createdAt,_that.createdBy,_that.evidenceIds,_that.findingIds,_that.history,_that.notes,_that.updatedAt,_that.priority,_that.tags);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String templateId,  String templateVersion,  String triggerId,  String assetId,  Map<String, dynamic> matchedValues,  Map<String, dynamic> parameters,  RunInstanceStatus status,  DateTime createdAt,  String createdBy,  List<String> evidenceIds,  List<String> findingIds,  List<HistoryEntry> history,  String? notes,  DateTime? updatedAt,  int priority,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _RunInstance() when $default != null:
return $default(_that.runId,_that.templateId,_that.templateVersion,_that.triggerId,_that.assetId,_that.matchedValues,_that.parameters,_that.status,_that.createdAt,_that.createdBy,_that.evidenceIds,_that.findingIds,_that.history,_that.notes,_that.updatedAt,_that.priority,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RunInstance implements RunInstance {
  const _RunInstance({required this.runId, required this.templateId, required this.templateVersion, required this.triggerId, required this.assetId, required final  Map<String, dynamic> matchedValues, required final  Map<String, dynamic> parameters, required this.status, required this.createdAt, required this.createdBy, final  List<String> evidenceIds = const [], final  List<String> findingIds = const [], final  List<HistoryEntry> history = const [], this.notes, this.updatedAt, this.priority = 5, final  List<String> tags = const []}): _matchedValues = matchedValues,_parameters = parameters,_evidenceIds = evidenceIds,_findingIds = findingIds,_history = history,_tags = tags;
  factory _RunInstance.fromJson(Map<String, dynamic> json) => _$RunInstanceFromJson(json);

/// Unique identifier for this run instance (RUN-YYYYMMDD-XXXX)
@override final  String runId;
/// ID of the methodology template this instance is based on
@override final  String templateId;
/// Version of the methodology template
@override final  String templateVersion;
/// ID of the trigger that created this instance
@override final  String triggerId;
/// ID of the asset this methodology is running against
@override final  String assetId;
/// Values matched from the trigger evaluation
 final  Map<String, dynamic> _matchedValues;
/// Values matched from the trigger evaluation
@override Map<String, dynamic> get matchedValues {
  if (_matchedValues is EqualUnmodifiableMapView) return _matchedValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_matchedValues);
}

/// Resolved parameter values for the methodology
 final  Map<String, dynamic> _parameters;
/// Resolved parameter values for the methodology
@override Map<String, dynamic> get parameters {
  if (_parameters is EqualUnmodifiableMapView) return _parameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_parameters);
}

/// Current status of the run instance
@override final  RunInstanceStatus status;
/// When this instance was created
@override final  DateTime createdAt;
/// Who created this instance
@override final  String createdBy;
/// List of evidence item IDs associated with this run
 final  List<String> _evidenceIds;
/// List of evidence item IDs associated with this run
@override@JsonKey() List<String> get evidenceIds {
  if (_evidenceIds is EqualUnmodifiableListView) return _evidenceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidenceIds);
}

/// List of finding IDs generated from this run
 final  List<String> _findingIds;
/// List of finding IDs generated from this run
@override@JsonKey() List<String> get findingIds {
  if (_findingIds is EqualUnmodifiableListView) return _findingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_findingIds);
}

/// History of status changes and actions
 final  List<HistoryEntry> _history;
/// History of status changes and actions
@override@JsonKey() List<HistoryEntry> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

/// Optional notes about this run instance
@override final  String? notes;
/// When this instance was last updated
@override final  DateTime? updatedAt;
/// Priority assigned to this run (1-10, higher = more important)
@override@JsonKey() final  int priority;
/// Tags associated with this run instance
 final  List<String> _tags;
/// Tags associated with this run instance
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of RunInstance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunInstanceCopyWith<_RunInstance> get copyWith => __$RunInstanceCopyWithImpl<_RunInstance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RunInstanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunInstance&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.templateVersion, templateVersion) || other.templateVersion == templateVersion)&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.assetId, assetId) || other.assetId == assetId)&&const DeepCollectionEquality().equals(other._matchedValues, _matchedValues)&&const DeepCollectionEquality().equals(other._parameters, _parameters)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&const DeepCollectionEquality().equals(other._evidenceIds, _evidenceIds)&&const DeepCollectionEquality().equals(other._findingIds, _findingIds)&&const DeepCollectionEquality().equals(other._history, _history)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.priority, priority) || other.priority == priority)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,templateId,templateVersion,triggerId,assetId,const DeepCollectionEquality().hash(_matchedValues),const DeepCollectionEquality().hash(_parameters),status,createdAt,createdBy,const DeepCollectionEquality().hash(_evidenceIds),const DeepCollectionEquality().hash(_findingIds),const DeepCollectionEquality().hash(_history),notes,updatedAt,priority,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'RunInstance(runId: $runId, templateId: $templateId, templateVersion: $templateVersion, triggerId: $triggerId, assetId: $assetId, matchedValues: $matchedValues, parameters: $parameters, status: $status, createdAt: $createdAt, createdBy: $createdBy, evidenceIds: $evidenceIds, findingIds: $findingIds, history: $history, notes: $notes, updatedAt: $updatedAt, priority: $priority, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$RunInstanceCopyWith<$Res> implements $RunInstanceCopyWith<$Res> {
  factory _$RunInstanceCopyWith(_RunInstance value, $Res Function(_RunInstance) _then) = __$RunInstanceCopyWithImpl;
@override @useResult
$Res call({
 String runId, String templateId, String templateVersion, String triggerId, String assetId, Map<String, dynamic> matchedValues, Map<String, dynamic> parameters, RunInstanceStatus status, DateTime createdAt, String createdBy, List<String> evidenceIds, List<String> findingIds, List<HistoryEntry> history, String? notes, DateTime? updatedAt, int priority, List<String> tags
});




}
/// @nodoc
class __$RunInstanceCopyWithImpl<$Res>
    implements _$RunInstanceCopyWith<$Res> {
  __$RunInstanceCopyWithImpl(this._self, this._then);

  final _RunInstance _self;
  final $Res Function(_RunInstance) _then;

/// Create a copy of RunInstance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? templateId = null,Object? templateVersion = null,Object? triggerId = null,Object? assetId = null,Object? matchedValues = null,Object? parameters = null,Object? status = null,Object? createdAt = null,Object? createdBy = null,Object? evidenceIds = null,Object? findingIds = null,Object? history = null,Object? notes = freezed,Object? updatedAt = freezed,Object? priority = null,Object? tags = null,}) {
  return _then(_RunInstance(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,templateVersion: null == templateVersion ? _self.templateVersion : templateVersion // ignore: cast_nullable_to_non_nullable
as String,triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,assetId: null == assetId ? _self.assetId : assetId // ignore: cast_nullable_to_non_nullable
as String,matchedValues: null == matchedValues ? _self._matchedValues : matchedValues // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,parameters: null == parameters ? _self._parameters : parameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RunInstanceStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,evidenceIds: null == evidenceIds ? _self._evidenceIds : evidenceIds // ignore: cast_nullable_to_non_nullable
as List<String>,findingIds: null == findingIds ? _self._findingIds : findingIds // ignore: cast_nullable_to_non_nullable
as List<String>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<HistoryEntry>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$HistoryEntry {

/// Unique identifier for this history entry
 String get id;/// When this action occurred
 DateTime get timestamp;/// Who performed this action
 String get performedBy;/// Type of action performed
 HistoryActionType get action;/// Description of what happened
 String get description;/// Previous value (for change tracking)
 String? get previousValue;/// New value (for change tracking)
 String? get newValue;/// Additional metadata about the action
 Map<String, dynamic> get metadata;
/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryEntryCopyWith<HistoryEntry> get copyWith => _$HistoryEntryCopyWithImpl<HistoryEntry>(this as HistoryEntry, _$identity);

  /// Serializes this HistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.action, action) || other.action == action)&&(identical(other.description, description) || other.description == description)&&(identical(other.previousValue, previousValue) || other.previousValue == previousValue)&&(identical(other.newValue, newValue) || other.newValue == newValue)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,performedBy,action,description,previousValue,newValue,const DeepCollectionEquality().hash(metadata));

@override
String toString() {
  return 'HistoryEntry(id: $id, timestamp: $timestamp, performedBy: $performedBy, action: $action, description: $description, previousValue: $previousValue, newValue: $newValue, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $HistoryEntryCopyWith<$Res>  {
  factory $HistoryEntryCopyWith(HistoryEntry value, $Res Function(HistoryEntry) _then) = _$HistoryEntryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime timestamp, String performedBy, HistoryActionType action, String description, String? previousValue, String? newValue, Map<String, dynamic> metadata
});




}
/// @nodoc
class _$HistoryEntryCopyWithImpl<$Res>
    implements $HistoryEntryCopyWith<$Res> {
  _$HistoryEntryCopyWithImpl(this._self, this._then);

  final HistoryEntry _self;
  final $Res Function(HistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? timestamp = null,Object? performedBy = null,Object? action = null,Object? description = null,Object? previousValue = freezed,Object? newValue = freezed,Object? metadata = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,performedBy: null == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as HistoryActionType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,previousValue: freezed == previousValue ? _self.previousValue : previousValue // ignore: cast_nullable_to_non_nullable
as String?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryEntry].
extension HistoryEntryPatterns on HistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _HistoryEntry():
return $default(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  String performedBy,  HistoryActionType action,  String description,  String? previousValue,  String? newValue,  Map<String, dynamic> metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
return $default(_that.id,_that.timestamp,_that.performedBy,_that.action,_that.description,_that.previousValue,_that.newValue,_that.metadata);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime timestamp,  String performedBy,  HistoryActionType action,  String description,  String? previousValue,  String? newValue,  Map<String, dynamic> metadata)  $default,) {final _that = this;
switch (_that) {
case _HistoryEntry():
return $default(_that.id,_that.timestamp,_that.performedBy,_that.action,_that.description,_that.previousValue,_that.newValue,_that.metadata);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime timestamp,  String performedBy,  HistoryActionType action,  String description,  String? previousValue,  String? newValue,  Map<String, dynamic> metadata)?  $default,) {final _that = this;
switch (_that) {
case _HistoryEntry() when $default != null:
return $default(_that.id,_that.timestamp,_that.performedBy,_that.action,_that.description,_that.previousValue,_that.newValue,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryEntry implements HistoryEntry {
  const _HistoryEntry({required this.id, required this.timestamp, required this.performedBy, required this.action, required this.description, this.previousValue, this.newValue, final  Map<String, dynamic> metadata = const {}}): _metadata = metadata;
  factory _HistoryEntry.fromJson(Map<String, dynamic> json) => _$HistoryEntryFromJson(json);

/// Unique identifier for this history entry
@override final  String id;
/// When this action occurred
@override final  DateTime timestamp;
/// Who performed this action
@override final  String performedBy;
/// Type of action performed
@override final  HistoryActionType action;
/// Description of what happened
@override final  String description;
/// Previous value (for change tracking)
@override final  String? previousValue;
/// New value (for change tracking)
@override final  String? newValue;
/// Additional metadata about the action
 final  Map<String, dynamic> _metadata;
/// Additional metadata about the action
@override@JsonKey() Map<String, dynamic> get metadata {
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metadata);
}


/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryEntryCopyWith<_HistoryEntry> get copyWith => __$HistoryEntryCopyWithImpl<_HistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.performedBy, performedBy) || other.performedBy == performedBy)&&(identical(other.action, action) || other.action == action)&&(identical(other.description, description) || other.description == description)&&(identical(other.previousValue, previousValue) || other.previousValue == previousValue)&&(identical(other.newValue, newValue) || other.newValue == newValue)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timestamp,performedBy,action,description,previousValue,newValue,const DeepCollectionEquality().hash(_metadata));

@override
String toString() {
  return 'HistoryEntry(id: $id, timestamp: $timestamp, performedBy: $performedBy, action: $action, description: $description, previousValue: $previousValue, newValue: $newValue, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$HistoryEntryCopyWith<$Res> implements $HistoryEntryCopyWith<$Res> {
  factory _$HistoryEntryCopyWith(_HistoryEntry value, $Res Function(_HistoryEntry) _then) = __$HistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime timestamp, String performedBy, HistoryActionType action, String description, String? previousValue, String? newValue, Map<String, dynamic> metadata
});




}
/// @nodoc
class __$HistoryEntryCopyWithImpl<$Res>
    implements _$HistoryEntryCopyWith<$Res> {
  __$HistoryEntryCopyWithImpl(this._self, this._then);

  final _HistoryEntry _self;
  final $Res Function(_HistoryEntry) _then;

/// Create a copy of HistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? timestamp = null,Object? performedBy = null,Object? action = null,Object? description = null,Object? previousValue = freezed,Object? newValue = freezed,Object? metadata = null,}) {
  return _then(_HistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,performedBy: null == performedBy ? _self.performedBy : performedBy // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as HistoryActionType,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,previousValue: freezed == previousValue ? _self.previousValue : previousValue // ignore: cast_nullable_to_non_nullable
as String?,newValue: freezed == newValue ? _self.newValue : newValue // ignore: cast_nullable_to_non_nullable
as String?,metadata: null == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

// dart format on
