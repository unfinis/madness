// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finding.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Finding {

 String get id; String get title; String get description;// Markdown content
 FindingSeverity get severity; DateTime get createdAt; DateTime get updatedAt; String? get cvssScore; String? get cweId; String? get affectedSystems; String? get remediation;// Markdown content
 String? get references;// Markdown content
 String? get templateId; String? get masterFindingId;// If this is a sub-finding
 List<String> get subFindingIds; Map<String, dynamic> get customFields; List<String> get imageIds; Map<String, String> get variables;// Variable substitutions
 FindingStatus get status;
/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FindingCopyWith<Finding> get copyWith => _$FindingCopyWithImpl<Finding>(this as Finding, _$identity);

  /// Serializes this Finding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Finding&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cvssScore, cvssScore) || other.cvssScore == cvssScore)&&(identical(other.cweId, cweId) || other.cweId == cweId)&&(identical(other.affectedSystems, affectedSystems) || other.affectedSystems == affectedSystems)&&(identical(other.remediation, remediation) || other.remediation == remediation)&&(identical(other.references, references) || other.references == references)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.masterFindingId, masterFindingId) || other.masterFindingId == masterFindingId)&&const DeepCollectionEquality().equals(other.subFindingIds, subFindingIds)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&const DeepCollectionEquality().equals(other.imageIds, imageIds)&&const DeepCollectionEquality().equals(other.variables, variables)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,severity,createdAt,updatedAt,cvssScore,cweId,affectedSystems,remediation,references,templateId,masterFindingId,const DeepCollectionEquality().hash(subFindingIds),const DeepCollectionEquality().hash(customFields),const DeepCollectionEquality().hash(imageIds),const DeepCollectionEquality().hash(variables),status);

@override
String toString() {
  return 'Finding(id: $id, title: $title, description: $description, severity: $severity, createdAt: $createdAt, updatedAt: $updatedAt, cvssScore: $cvssScore, cweId: $cweId, affectedSystems: $affectedSystems, remediation: $remediation, references: $references, templateId: $templateId, masterFindingId: $masterFindingId, subFindingIds: $subFindingIds, customFields: $customFields, imageIds: $imageIds, variables: $variables, status: $status)';
}


}

/// @nodoc
abstract mixin class $FindingCopyWith<$Res>  {
  factory $FindingCopyWith(Finding value, $Res Function(Finding) _then) = _$FindingCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description, FindingSeverity severity, DateTime createdAt, DateTime updatedAt, String? cvssScore, String? cweId, String? affectedSystems, String? remediation, String? references, String? templateId, String? masterFindingId, List<String> subFindingIds, Map<String, dynamic> customFields, List<String> imageIds, Map<String, String> variables, FindingStatus status
});




}
/// @nodoc
class _$FindingCopyWithImpl<$Res>
    implements $FindingCopyWith<$Res> {
  _$FindingCopyWithImpl(this._self, this._then);

  final Finding _self;
  final $Res Function(Finding) _then;

/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? severity = null,Object? createdAt = null,Object? updatedAt = null,Object? cvssScore = freezed,Object? cweId = freezed,Object? affectedSystems = freezed,Object? remediation = freezed,Object? references = freezed,Object? templateId = freezed,Object? masterFindingId = freezed,Object? subFindingIds = null,Object? customFields = null,Object? imageIds = null,Object? variables = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as FindingSeverity,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,cvssScore: freezed == cvssScore ? _self.cvssScore : cvssScore // ignore: cast_nullable_to_non_nullable
as String?,cweId: freezed == cweId ? _self.cweId : cweId // ignore: cast_nullable_to_non_nullable
as String?,affectedSystems: freezed == affectedSystems ? _self.affectedSystems : affectedSystems // ignore: cast_nullable_to_non_nullable
as String?,remediation: freezed == remediation ? _self.remediation : remediation // ignore: cast_nullable_to_non_nullable
as String?,references: freezed == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,masterFindingId: freezed == masterFindingId ? _self.masterFindingId : masterFindingId // ignore: cast_nullable_to_non_nullable
as String?,subFindingIds: null == subFindingIds ? _self.subFindingIds : subFindingIds // ignore: cast_nullable_to_non_nullable
as List<String>,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,imageIds: null == imageIds ? _self.imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FindingStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Finding].
extension FindingPatterns on Finding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Finding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Finding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Finding value)  $default,){
final _that = this;
switch (_that) {
case _Finding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Finding value)?  $default,){
final _that = this;
switch (_that) {
case _Finding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description,  FindingSeverity severity,  DateTime createdAt,  DateTime updatedAt,  String? cvssScore,  String? cweId,  String? affectedSystems,  String? remediation,  String? references,  String? templateId,  String? masterFindingId,  List<String> subFindingIds,  Map<String, dynamic> customFields,  List<String> imageIds,  Map<String, String> variables,  FindingStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Finding() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.severity,_that.createdAt,_that.updatedAt,_that.cvssScore,_that.cweId,_that.affectedSystems,_that.remediation,_that.references,_that.templateId,_that.masterFindingId,_that.subFindingIds,_that.customFields,_that.imageIds,_that.variables,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description,  FindingSeverity severity,  DateTime createdAt,  DateTime updatedAt,  String? cvssScore,  String? cweId,  String? affectedSystems,  String? remediation,  String? references,  String? templateId,  String? masterFindingId,  List<String> subFindingIds,  Map<String, dynamic> customFields,  List<String> imageIds,  Map<String, String> variables,  FindingStatus status)  $default,) {final _that = this;
switch (_that) {
case _Finding():
return $default(_that.id,_that.title,_that.description,_that.severity,_that.createdAt,_that.updatedAt,_that.cvssScore,_that.cweId,_that.affectedSystems,_that.remediation,_that.references,_that.templateId,_that.masterFindingId,_that.subFindingIds,_that.customFields,_that.imageIds,_that.variables,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description,  FindingSeverity severity,  DateTime createdAt,  DateTime updatedAt,  String? cvssScore,  String? cweId,  String? affectedSystems,  String? remediation,  String? references,  String? templateId,  String? masterFindingId,  List<String> subFindingIds,  Map<String, dynamic> customFields,  List<String> imageIds,  Map<String, String> variables,  FindingStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Finding() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.severity,_that.createdAt,_that.updatedAt,_that.cvssScore,_that.cweId,_that.affectedSystems,_that.remediation,_that.references,_that.templateId,_that.masterFindingId,_that.subFindingIds,_that.customFields,_that.imageIds,_that.variables,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Finding implements Finding {
  const _Finding({required this.id, required this.title, required this.description, required this.severity, required this.createdAt, required this.updatedAt, this.cvssScore, this.cweId, this.affectedSystems, this.remediation, this.references, this.templateId, this.masterFindingId, final  List<String> subFindingIds = const [], final  Map<String, dynamic> customFields = const {}, final  List<String> imageIds = const [], final  Map<String, String> variables = const {}, this.status = FindingStatus.draft}): _subFindingIds = subFindingIds,_customFields = customFields,_imageIds = imageIds,_variables = variables;
  factory _Finding.fromJson(Map<String, dynamic> json) => _$FindingFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
// Markdown content
@override final  FindingSeverity severity;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override final  String? cvssScore;
@override final  String? cweId;
@override final  String? affectedSystems;
@override final  String? remediation;
// Markdown content
@override final  String? references;
// Markdown content
@override final  String? templateId;
@override final  String? masterFindingId;
// If this is a sub-finding
 final  List<String> _subFindingIds;
// If this is a sub-finding
@override@JsonKey() List<String> get subFindingIds {
  if (_subFindingIds is EqualUnmodifiableListView) return _subFindingIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subFindingIds);
}

 final  Map<String, dynamic> _customFields;
@override@JsonKey() Map<String, dynamic> get customFields {
  if (_customFields is EqualUnmodifiableMapView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customFields);
}

 final  List<String> _imageIds;
@override@JsonKey() List<String> get imageIds {
  if (_imageIds is EqualUnmodifiableListView) return _imageIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_imageIds);
}

 final  Map<String, String> _variables;
@override@JsonKey() Map<String, String> get variables {
  if (_variables is EqualUnmodifiableMapView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_variables);
}

// Variable substitutions
@override@JsonKey() final  FindingStatus status;

/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FindingCopyWith<_Finding> get copyWith => __$FindingCopyWithImpl<_Finding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FindingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Finding&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.cvssScore, cvssScore) || other.cvssScore == cvssScore)&&(identical(other.cweId, cweId) || other.cweId == cweId)&&(identical(other.affectedSystems, affectedSystems) || other.affectedSystems == affectedSystems)&&(identical(other.remediation, remediation) || other.remediation == remediation)&&(identical(other.references, references) || other.references == references)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.masterFindingId, masterFindingId) || other.masterFindingId == masterFindingId)&&const DeepCollectionEquality().equals(other._subFindingIds, _subFindingIds)&&const DeepCollectionEquality().equals(other._customFields, _customFields)&&const DeepCollectionEquality().equals(other._imageIds, _imageIds)&&const DeepCollectionEquality().equals(other._variables, _variables)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,severity,createdAt,updatedAt,cvssScore,cweId,affectedSystems,remediation,references,templateId,masterFindingId,const DeepCollectionEquality().hash(_subFindingIds),const DeepCollectionEquality().hash(_customFields),const DeepCollectionEquality().hash(_imageIds),const DeepCollectionEquality().hash(_variables),status);

@override
String toString() {
  return 'Finding(id: $id, title: $title, description: $description, severity: $severity, createdAt: $createdAt, updatedAt: $updatedAt, cvssScore: $cvssScore, cweId: $cweId, affectedSystems: $affectedSystems, remediation: $remediation, references: $references, templateId: $templateId, masterFindingId: $masterFindingId, subFindingIds: $subFindingIds, customFields: $customFields, imageIds: $imageIds, variables: $variables, status: $status)';
}


}

/// @nodoc
abstract mixin class _$FindingCopyWith<$Res> implements $FindingCopyWith<$Res> {
  factory _$FindingCopyWith(_Finding value, $Res Function(_Finding) _then) = __$FindingCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description, FindingSeverity severity, DateTime createdAt, DateTime updatedAt, String? cvssScore, String? cweId, String? affectedSystems, String? remediation, String? references, String? templateId, String? masterFindingId, List<String> subFindingIds, Map<String, dynamic> customFields, List<String> imageIds, Map<String, String> variables, FindingStatus status
});




}
/// @nodoc
class __$FindingCopyWithImpl<$Res>
    implements _$FindingCopyWith<$Res> {
  __$FindingCopyWithImpl(this._self, this._then);

  final _Finding _self;
  final $Res Function(_Finding) _then;

/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? severity = null,Object? createdAt = null,Object? updatedAt = null,Object? cvssScore = freezed,Object? cweId = freezed,Object? affectedSystems = freezed,Object? remediation = freezed,Object? references = freezed,Object? templateId = freezed,Object? masterFindingId = freezed,Object? subFindingIds = null,Object? customFields = null,Object? imageIds = null,Object? variables = null,Object? status = null,}) {
  return _then(_Finding(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as FindingSeverity,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,cvssScore: freezed == cvssScore ? _self.cvssScore : cvssScore // ignore: cast_nullable_to_non_nullable
as String?,cweId: freezed == cweId ? _self.cweId : cweId // ignore: cast_nullable_to_non_nullable
as String?,affectedSystems: freezed == affectedSystems ? _self.affectedSystems : affectedSystems // ignore: cast_nullable_to_non_nullable
as String?,remediation: freezed == remediation ? _self.remediation : remediation // ignore: cast_nullable_to_non_nullable
as String?,references: freezed == references ? _self.references : references // ignore: cast_nullable_to_non_nullable
as String?,templateId: freezed == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String?,masterFindingId: freezed == masterFindingId ? _self.masterFindingId : masterFindingId // ignore: cast_nullable_to_non_nullable
as String?,subFindingIds: null == subFindingIds ? _self._subFindingIds : subFindingIds // ignore: cast_nullable_to_non_nullable
as List<String>,customFields: null == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,imageIds: null == imageIds ? _self._imageIds : imageIds // ignore: cast_nullable_to_non_nullable
as List<String>,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as Map<String, String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as FindingStatus,
  ));
}


}

// dart format on
