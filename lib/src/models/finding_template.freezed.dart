// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'finding_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FindingTemplate {

 String get id; String get name; String get category; String get descriptionTemplate;// Markdown with {{variables}}
 String get remediationTemplate; String? get defaultSeverity; String? get defaultCvssScore; String? get defaultCweId; List<TemplateVariable> get variables; List<CustomField> get customFields; bool get isCustom; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of FindingTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FindingTemplateCopyWith<FindingTemplate> get copyWith => _$FindingTemplateCopyWithImpl<FindingTemplate>(this as FindingTemplate, _$identity);

  /// Serializes this FindingTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FindingTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.descriptionTemplate, descriptionTemplate) || other.descriptionTemplate == descriptionTemplate)&&(identical(other.remediationTemplate, remediationTemplate) || other.remediationTemplate == remediationTemplate)&&(identical(other.defaultSeverity, defaultSeverity) || other.defaultSeverity == defaultSeverity)&&(identical(other.defaultCvssScore, defaultCvssScore) || other.defaultCvssScore == defaultCvssScore)&&(identical(other.defaultCweId, defaultCweId) || other.defaultCweId == defaultCweId)&&const DeepCollectionEquality().equals(other.variables, variables)&&const DeepCollectionEquality().equals(other.customFields, customFields)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,descriptionTemplate,remediationTemplate,defaultSeverity,defaultCvssScore,defaultCweId,const DeepCollectionEquality().hash(variables),const DeepCollectionEquality().hash(customFields),isCustom,createdAt,updatedAt);

@override
String toString() {
  return 'FindingTemplate(id: $id, name: $name, category: $category, descriptionTemplate: $descriptionTemplate, remediationTemplate: $remediationTemplate, defaultSeverity: $defaultSeverity, defaultCvssScore: $defaultCvssScore, defaultCweId: $defaultCweId, variables: $variables, customFields: $customFields, isCustom: $isCustom, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FindingTemplateCopyWith<$Res>  {
  factory $FindingTemplateCopyWith(FindingTemplate value, $Res Function(FindingTemplate) _then) = _$FindingTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, String descriptionTemplate, String remediationTemplate, String? defaultSeverity, String? defaultCvssScore, String? defaultCweId, List<TemplateVariable> variables, List<CustomField> customFields, bool isCustom, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$FindingTemplateCopyWithImpl<$Res>
    implements $FindingTemplateCopyWith<$Res> {
  _$FindingTemplateCopyWithImpl(this._self, this._then);

  final FindingTemplate _self;
  final $Res Function(FindingTemplate) _then;

/// Create a copy of FindingTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? descriptionTemplate = null,Object? remediationTemplate = null,Object? defaultSeverity = freezed,Object? defaultCvssScore = freezed,Object? defaultCweId = freezed,Object? variables = null,Object? customFields = null,Object? isCustom = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,descriptionTemplate: null == descriptionTemplate ? _self.descriptionTemplate : descriptionTemplate // ignore: cast_nullable_to_non_nullable
as String,remediationTemplate: null == remediationTemplate ? _self.remediationTemplate : remediationTemplate // ignore: cast_nullable_to_non_nullable
as String,defaultSeverity: freezed == defaultSeverity ? _self.defaultSeverity : defaultSeverity // ignore: cast_nullable_to_non_nullable
as String?,defaultCvssScore: freezed == defaultCvssScore ? _self.defaultCvssScore : defaultCvssScore // ignore: cast_nullable_to_non_nullable
as String?,defaultCweId: freezed == defaultCweId ? _self.defaultCweId : defaultCweId // ignore: cast_nullable_to_non_nullable
as String?,variables: null == variables ? _self.variables : variables // ignore: cast_nullable_to_non_nullable
as List<TemplateVariable>,customFields: null == customFields ? _self.customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<CustomField>,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FindingTemplate].
extension FindingTemplatePatterns on FindingTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FindingTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FindingTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FindingTemplate value)  $default,){
final _that = this;
switch (_that) {
case _FindingTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FindingTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _FindingTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String descriptionTemplate,  String remediationTemplate,  String? defaultSeverity,  String? defaultCvssScore,  String? defaultCweId,  List<TemplateVariable> variables,  List<CustomField> customFields,  bool isCustom,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FindingTemplate() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.descriptionTemplate,_that.remediationTemplate,_that.defaultSeverity,_that.defaultCvssScore,_that.defaultCweId,_that.variables,_that.customFields,_that.isCustom,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String descriptionTemplate,  String remediationTemplate,  String? defaultSeverity,  String? defaultCvssScore,  String? defaultCweId,  List<TemplateVariable> variables,  List<CustomField> customFields,  bool isCustom,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FindingTemplate():
return $default(_that.id,_that.name,_that.category,_that.descriptionTemplate,_that.remediationTemplate,_that.defaultSeverity,_that.defaultCvssScore,_that.defaultCweId,_that.variables,_that.customFields,_that.isCustom,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  String descriptionTemplate,  String remediationTemplate,  String? defaultSeverity,  String? defaultCvssScore,  String? defaultCweId,  List<TemplateVariable> variables,  List<CustomField> customFields,  bool isCustom,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FindingTemplate() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.descriptionTemplate,_that.remediationTemplate,_that.defaultSeverity,_that.defaultCvssScore,_that.defaultCweId,_that.variables,_that.customFields,_that.isCustom,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FindingTemplate implements FindingTemplate {
  const _FindingTemplate({required this.id, required this.name, required this.category, required this.descriptionTemplate, required this.remediationTemplate, this.defaultSeverity, this.defaultCvssScore, this.defaultCweId, final  List<TemplateVariable> variables = const [], final  List<CustomField> customFields = const [], this.isCustom = false, this.createdAt, this.updatedAt}): _variables = variables,_customFields = customFields;
  factory _FindingTemplate.fromJson(Map<String, dynamic> json) => _$FindingTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String category;
@override final  String descriptionTemplate;
// Markdown with {{variables}}
@override final  String remediationTemplate;
@override final  String? defaultSeverity;
@override final  String? defaultCvssScore;
@override final  String? defaultCweId;
 final  List<TemplateVariable> _variables;
@override@JsonKey() List<TemplateVariable> get variables {
  if (_variables is EqualUnmodifiableListView) return _variables;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_variables);
}

 final  List<CustomField> _customFields;
@override@JsonKey() List<CustomField> get customFields {
  if (_customFields is EqualUnmodifiableListView) return _customFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customFields);
}

@override@JsonKey() final  bool isCustom;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of FindingTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FindingTemplateCopyWith<_FindingTemplate> get copyWith => __$FindingTemplateCopyWithImpl<_FindingTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FindingTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FindingTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.descriptionTemplate, descriptionTemplate) || other.descriptionTemplate == descriptionTemplate)&&(identical(other.remediationTemplate, remediationTemplate) || other.remediationTemplate == remediationTemplate)&&(identical(other.defaultSeverity, defaultSeverity) || other.defaultSeverity == defaultSeverity)&&(identical(other.defaultCvssScore, defaultCvssScore) || other.defaultCvssScore == defaultCvssScore)&&(identical(other.defaultCweId, defaultCweId) || other.defaultCweId == defaultCweId)&&const DeepCollectionEquality().equals(other._variables, _variables)&&const DeepCollectionEquality().equals(other._customFields, _customFields)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,descriptionTemplate,remediationTemplate,defaultSeverity,defaultCvssScore,defaultCweId,const DeepCollectionEquality().hash(_variables),const DeepCollectionEquality().hash(_customFields),isCustom,createdAt,updatedAt);

@override
String toString() {
  return 'FindingTemplate(id: $id, name: $name, category: $category, descriptionTemplate: $descriptionTemplate, remediationTemplate: $remediationTemplate, defaultSeverity: $defaultSeverity, defaultCvssScore: $defaultCvssScore, defaultCweId: $defaultCweId, variables: $variables, customFields: $customFields, isCustom: $isCustom, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FindingTemplateCopyWith<$Res> implements $FindingTemplateCopyWith<$Res> {
  factory _$FindingTemplateCopyWith(_FindingTemplate value, $Res Function(_FindingTemplate) _then) = __$FindingTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, String descriptionTemplate, String remediationTemplate, String? defaultSeverity, String? defaultCvssScore, String? defaultCweId, List<TemplateVariable> variables, List<CustomField> customFields, bool isCustom, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$FindingTemplateCopyWithImpl<$Res>
    implements _$FindingTemplateCopyWith<$Res> {
  __$FindingTemplateCopyWithImpl(this._self, this._then);

  final _FindingTemplate _self;
  final $Res Function(_FindingTemplate) _then;

/// Create a copy of FindingTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? descriptionTemplate = null,Object? remediationTemplate = null,Object? defaultSeverity = freezed,Object? defaultCvssScore = freezed,Object? defaultCweId = freezed,Object? variables = null,Object? customFields = null,Object? isCustom = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_FindingTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,descriptionTemplate: null == descriptionTemplate ? _self.descriptionTemplate : descriptionTemplate // ignore: cast_nullable_to_non_nullable
as String,remediationTemplate: null == remediationTemplate ? _self.remediationTemplate : remediationTemplate // ignore: cast_nullable_to_non_nullable
as String,defaultSeverity: freezed == defaultSeverity ? _self.defaultSeverity : defaultSeverity // ignore: cast_nullable_to_non_nullable
as String?,defaultCvssScore: freezed == defaultCvssScore ? _self.defaultCvssScore : defaultCvssScore // ignore: cast_nullable_to_non_nullable
as String?,defaultCweId: freezed == defaultCweId ? _self.defaultCweId : defaultCweId // ignore: cast_nullable_to_non_nullable
as String?,variables: null == variables ? _self._variables : variables // ignore: cast_nullable_to_non_nullable
as List<TemplateVariable>,customFields: null == customFields ? _self._customFields : customFields // ignore: cast_nullable_to_non_nullable
as List<CustomField>,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TemplateVariable {

 String get name; String get label; VariableType get type; String? get defaultValue; String? get placeholder; bool get required; List<String>? get options;
/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TemplateVariableCopyWith<TemplateVariable> get copyWith => _$TemplateVariableCopyWithImpl<TemplateVariable>(this as TemplateVariable, _$identity);

  /// Serializes this TemplateVariable to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TemplateVariable&&(identical(other.name, name) || other.name == name)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,label,type,defaultValue,placeholder,required,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'TemplateVariable(name: $name, label: $label, type: $type, defaultValue: $defaultValue, placeholder: $placeholder, required: $required, options: $options)';
}


}

/// @nodoc
abstract mixin class $TemplateVariableCopyWith<$Res>  {
  factory $TemplateVariableCopyWith(TemplateVariable value, $Res Function(TemplateVariable) _then) = _$TemplateVariableCopyWithImpl;
@useResult
$Res call({
 String name, String label, VariableType type, String? defaultValue, String? placeholder, bool required, List<String>? options
});




}
/// @nodoc
class _$TemplateVariableCopyWithImpl<$Res>
    implements $TemplateVariableCopyWith<$Res> {
  _$TemplateVariableCopyWithImpl(this._self, this._then);

  final TemplateVariable _self;
  final $Res Function(TemplateVariable) _then;

/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? label = null,Object? type = null,Object? defaultValue = freezed,Object? placeholder = freezed,Object? required = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VariableType,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TemplateVariable].
extension TemplateVariablePatterns on TemplateVariable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TemplateVariable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TemplateVariable value)  $default,){
final _that = this;
switch (_that) {
case _TemplateVariable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TemplateVariable value)?  $default,){
final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String label,  VariableType type,  String? defaultValue,  String? placeholder,  bool required,  List<String>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
return $default(_that.name,_that.label,_that.type,_that.defaultValue,_that.placeholder,_that.required,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String label,  VariableType type,  String? defaultValue,  String? placeholder,  bool required,  List<String>? options)  $default,) {final _that = this;
switch (_that) {
case _TemplateVariable():
return $default(_that.name,_that.label,_that.type,_that.defaultValue,_that.placeholder,_that.required,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String label,  VariableType type,  String? defaultValue,  String? placeholder,  bool required,  List<String>? options)?  $default,) {final _that = this;
switch (_that) {
case _TemplateVariable() when $default != null:
return $default(_that.name,_that.label,_that.type,_that.defaultValue,_that.placeholder,_that.required,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TemplateVariable implements TemplateVariable {
  const _TemplateVariable({required this.name, required this.label, required this.type, this.defaultValue, this.placeholder, this.required = false, final  List<String>? options}): _options = options;
  factory _TemplateVariable.fromJson(Map<String, dynamic> json) => _$TemplateVariableFromJson(json);

@override final  String name;
@override final  String label;
@override final  VariableType type;
@override final  String? defaultValue;
@override final  String? placeholder;
@override@JsonKey() final  bool required;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TemplateVariableCopyWith<_TemplateVariable> get copyWith => __$TemplateVariableCopyWithImpl<_TemplateVariable>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TemplateVariableToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TemplateVariable&&(identical(other.name, name) || other.name == name)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.placeholder, placeholder) || other.placeholder == placeholder)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,label,type,defaultValue,placeholder,required,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'TemplateVariable(name: $name, label: $label, type: $type, defaultValue: $defaultValue, placeholder: $placeholder, required: $required, options: $options)';
}


}

/// @nodoc
abstract mixin class _$TemplateVariableCopyWith<$Res> implements $TemplateVariableCopyWith<$Res> {
  factory _$TemplateVariableCopyWith(_TemplateVariable value, $Res Function(_TemplateVariable) _then) = __$TemplateVariableCopyWithImpl;
@override @useResult
$Res call({
 String name, String label, VariableType type, String? defaultValue, String? placeholder, bool required, List<String>? options
});




}
/// @nodoc
class __$TemplateVariableCopyWithImpl<$Res>
    implements _$TemplateVariableCopyWith<$Res> {
  __$TemplateVariableCopyWithImpl(this._self, this._then);

  final _TemplateVariable _self;
  final $Res Function(_TemplateVariable) _then;

/// Create a copy of TemplateVariable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? label = null,Object? type = null,Object? defaultValue = freezed,Object? placeholder = freezed,Object? required = null,Object? options = freezed,}) {
  return _then(_TemplateVariable(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as VariableType,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,placeholder: freezed == placeholder ? _self.placeholder : placeholder // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$CustomField {

 String get name; String get label; CustomFieldType get type; String? get defaultValue; bool get required; List<String>? get options;
/// Create a copy of CustomField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CustomFieldCopyWith<CustomField> get copyWith => _$CustomFieldCopyWithImpl<CustomField>(this as CustomField, _$identity);

  /// Serializes this CustomField to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CustomField&&(identical(other.name, name) || other.name == name)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,label,type,defaultValue,required,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'CustomField(name: $name, label: $label, type: $type, defaultValue: $defaultValue, required: $required, options: $options)';
}


}

/// @nodoc
abstract mixin class $CustomFieldCopyWith<$Res>  {
  factory $CustomFieldCopyWith(CustomField value, $Res Function(CustomField) _then) = _$CustomFieldCopyWithImpl;
@useResult
$Res call({
 String name, String label, CustomFieldType type, String? defaultValue, bool required, List<String>? options
});




}
/// @nodoc
class _$CustomFieldCopyWithImpl<$Res>
    implements $CustomFieldCopyWith<$Res> {
  _$CustomFieldCopyWithImpl(this._self, this._then);

  final CustomField _self;
  final $Res Function(CustomField) _then;

/// Create a copy of CustomField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? label = null,Object? type = null,Object? defaultValue = freezed,Object? required = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CustomFieldType,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CustomField].
extension CustomFieldPatterns on CustomField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CustomField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CustomField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CustomField value)  $default,){
final _that = this;
switch (_that) {
case _CustomField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CustomField value)?  $default,){
final _that = this;
switch (_that) {
case _CustomField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String label,  CustomFieldType type,  String? defaultValue,  bool required,  List<String>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CustomField() when $default != null:
return $default(_that.name,_that.label,_that.type,_that.defaultValue,_that.required,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String label,  CustomFieldType type,  String? defaultValue,  bool required,  List<String>? options)  $default,) {final _that = this;
switch (_that) {
case _CustomField():
return $default(_that.name,_that.label,_that.type,_that.defaultValue,_that.required,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String label,  CustomFieldType type,  String? defaultValue,  bool required,  List<String>? options)?  $default,) {final _that = this;
switch (_that) {
case _CustomField() when $default != null:
return $default(_that.name,_that.label,_that.type,_that.defaultValue,_that.required,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CustomField implements CustomField {
  const _CustomField({required this.name, required this.label, required this.type, this.defaultValue, this.required = false, final  List<String>? options}): _options = options;
  factory _CustomField.fromJson(Map<String, dynamic> json) => _$CustomFieldFromJson(json);

@override final  String name;
@override final  String label;
@override final  CustomFieldType type;
@override final  String? defaultValue;
@override@JsonKey() final  bool required;
 final  List<String>? _options;
@override List<String>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CustomField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CustomFieldCopyWith<_CustomField> get copyWith => __$CustomFieldCopyWithImpl<_CustomField>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CustomFieldToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CustomField&&(identical(other.name, name) || other.name == name)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.required, required) || other.required == required)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,label,type,defaultValue,required,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'CustomField(name: $name, label: $label, type: $type, defaultValue: $defaultValue, required: $required, options: $options)';
}


}

/// @nodoc
abstract mixin class _$CustomFieldCopyWith<$Res> implements $CustomFieldCopyWith<$Res> {
  factory _$CustomFieldCopyWith(_CustomField value, $Res Function(_CustomField) _then) = __$CustomFieldCopyWithImpl;
@override @useResult
$Res call({
 String name, String label, CustomFieldType type, String? defaultValue, bool required, List<String>? options
});




}
/// @nodoc
class __$CustomFieldCopyWithImpl<$Res>
    implements _$CustomFieldCopyWith<$Res> {
  __$CustomFieldCopyWithImpl(this._self, this._then);

  final _CustomField _self;
  final $Res Function(_CustomField) _then;

/// Create a copy of CustomField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? label = null,Object? type = null,Object? defaultValue = freezed,Object? required = null,Object? options = freezed,}) {
  return _then(_CustomField(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CustomFieldType,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
