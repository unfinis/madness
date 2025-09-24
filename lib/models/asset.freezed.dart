// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
PropertyValue _$PropertyValueFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'string':
          return StringProperty.fromJson(
            json
          );
                case 'integer':
          return IntegerProperty.fromJson(
            json
          );
                case 'boolean':
          return BooleanProperty.fromJson(
            json
          );
                case 'stringList':
          return StringListProperty.fromJson(
            json
          );
                case 'map':
          return MapProperty.fromJson(
            json
          );
                case 'objectList':
          return ObjectListProperty.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'PropertyValue',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$PropertyValue {



  /// Serializes this PropertyValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PropertyValue);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PropertyValue()';
}


}

/// @nodoc
class $PropertyValueCopyWith<$Res>  {
$PropertyValueCopyWith(PropertyValue _, $Res Function(PropertyValue) __);
}


/// Adds pattern-matching-related methods to [PropertyValue].
extension PropertyValuePatterns on PropertyValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StringProperty value)?  string,TResult Function( IntegerProperty value)?  integer,TResult Function( BooleanProperty value)?  boolean,TResult Function( StringListProperty value)?  stringList,TResult Function( MapProperty value)?  map,TResult Function( ObjectListProperty value)?  objectList,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StringProperty() when string != null:
return string(_that);case IntegerProperty() when integer != null:
return integer(_that);case BooleanProperty() when boolean != null:
return boolean(_that);case StringListProperty() when stringList != null:
return stringList(_that);case MapProperty() when map != null:
return map(_that);case ObjectListProperty() when objectList != null:
return objectList(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StringProperty value)  string,required TResult Function( IntegerProperty value)  integer,required TResult Function( BooleanProperty value)  boolean,required TResult Function( StringListProperty value)  stringList,required TResult Function( MapProperty value)  map,required TResult Function( ObjectListProperty value)  objectList,}){
final _that = this;
switch (_that) {
case StringProperty():
return string(_that);case IntegerProperty():
return integer(_that);case BooleanProperty():
return boolean(_that);case StringListProperty():
return stringList(_that);case MapProperty():
return map(_that);case ObjectListProperty():
return objectList(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StringProperty value)?  string,TResult? Function( IntegerProperty value)?  integer,TResult? Function( BooleanProperty value)?  boolean,TResult? Function( StringListProperty value)?  stringList,TResult? Function( MapProperty value)?  map,TResult? Function( ObjectListProperty value)?  objectList,}){
final _that = this;
switch (_that) {
case StringProperty() when string != null:
return string(_that);case IntegerProperty() when integer != null:
return integer(_that);case BooleanProperty() when boolean != null:
return boolean(_that);case StringListProperty() when stringList != null:
return stringList(_that);case MapProperty() when map != null:
return map(_that);case ObjectListProperty() when objectList != null:
return objectList(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  string,TResult Function( int value)?  integer,TResult Function( bool value)?  boolean,TResult Function( List<String> values)?  stringList,TResult Function( Map<String, dynamic> value)?  map,TResult Function( List<Map<String, dynamic>> objects)?  objectList,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StringProperty() when string != null:
return string(_that.value);case IntegerProperty() when integer != null:
return integer(_that.value);case BooleanProperty() when boolean != null:
return boolean(_that.value);case StringListProperty() when stringList != null:
return stringList(_that.values);case MapProperty() when map != null:
return map(_that.value);case ObjectListProperty() when objectList != null:
return objectList(_that.objects);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  string,required TResult Function( int value)  integer,required TResult Function( bool value)  boolean,required TResult Function( List<String> values)  stringList,required TResult Function( Map<String, dynamic> value)  map,required TResult Function( List<Map<String, dynamic>> objects)  objectList,}) {final _that = this;
switch (_that) {
case StringProperty():
return string(_that.value);case IntegerProperty():
return integer(_that.value);case BooleanProperty():
return boolean(_that.value);case StringListProperty():
return stringList(_that.values);case MapProperty():
return map(_that.value);case ObjectListProperty():
return objectList(_that.objects);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  string,TResult? Function( int value)?  integer,TResult? Function( bool value)?  boolean,TResult? Function( List<String> values)?  stringList,TResult? Function( Map<String, dynamic> value)?  map,TResult? Function( List<Map<String, dynamic>> objects)?  objectList,}) {final _that = this;
switch (_that) {
case StringProperty() when string != null:
return string(_that.value);case IntegerProperty() when integer != null:
return integer(_that.value);case BooleanProperty() when boolean != null:
return boolean(_that.value);case StringListProperty() when stringList != null:
return stringList(_that.values);case MapProperty() when map != null:
return map(_that.value);case ObjectListProperty() when objectList != null:
return objectList(_that.objects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class StringProperty implements PropertyValue {
  const StringProperty(this.value, {final  String? $type}): $type = $type ?? 'string';
  factory StringProperty.fromJson(Map<String, dynamic> json) => _$StringPropertyFromJson(json);

 final  String value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringPropertyCopyWith<StringProperty> get copyWith => _$StringPropertyCopyWithImpl<StringProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StringPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PropertyValue.string(value: $value)';
}


}

/// @nodoc
abstract mixin class $StringPropertyCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory $StringPropertyCopyWith(StringProperty value, $Res Function(StringProperty) _then) = _$StringPropertyCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$StringPropertyCopyWithImpl<$Res>
    implements $StringPropertyCopyWith<$Res> {
  _$StringPropertyCopyWithImpl(this._self, this._then);

  final StringProperty _self;
  final $Res Function(StringProperty) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(StringProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class IntegerProperty implements PropertyValue {
  const IntegerProperty(this.value, {final  String? $type}): $type = $type ?? 'integer';
  factory IntegerProperty.fromJson(Map<String, dynamic> json) => _$IntegerPropertyFromJson(json);

 final  int value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntegerPropertyCopyWith<IntegerProperty> get copyWith => _$IntegerPropertyCopyWithImpl<IntegerProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntegerPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntegerProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PropertyValue.integer(value: $value)';
}


}

/// @nodoc
abstract mixin class $IntegerPropertyCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory $IntegerPropertyCopyWith(IntegerProperty value, $Res Function(IntegerProperty) _then) = _$IntegerPropertyCopyWithImpl;
@useResult
$Res call({
 int value
});




}
/// @nodoc
class _$IntegerPropertyCopyWithImpl<$Res>
    implements $IntegerPropertyCopyWith<$Res> {
  _$IntegerPropertyCopyWithImpl(this._self, this._then);

  final IntegerProperty _self;
  final $Res Function(IntegerProperty) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(IntegerProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BooleanProperty implements PropertyValue {
  const BooleanProperty(this.value, {final  String? $type}): $type = $type ?? 'boolean';
  factory BooleanProperty.fromJson(Map<String, dynamic> json) => _$BooleanPropertyFromJson(json);

 final  bool value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BooleanPropertyCopyWith<BooleanProperty> get copyWith => _$BooleanPropertyCopyWithImpl<BooleanProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BooleanPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BooleanProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'PropertyValue.boolean(value: $value)';
}


}

/// @nodoc
abstract mixin class $BooleanPropertyCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory $BooleanPropertyCopyWith(BooleanProperty value, $Res Function(BooleanProperty) _then) = _$BooleanPropertyCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$BooleanPropertyCopyWithImpl<$Res>
    implements $BooleanPropertyCopyWith<$Res> {
  _$BooleanPropertyCopyWithImpl(this._self, this._then);

  final BooleanProperty _self;
  final $Res Function(BooleanProperty) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(BooleanProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StringListProperty implements PropertyValue {
  const StringListProperty(final  List<String> values, {final  String? $type}): _values = values,$type = $type ?? 'stringList';
  factory StringListProperty.fromJson(Map<String, dynamic> json) => _$StringListPropertyFromJson(json);

 final  List<String> _values;
 List<String> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringListPropertyCopyWith<StringListProperty> get copyWith => _$StringListPropertyCopyWithImpl<StringListProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StringListPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringListProperty&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'PropertyValue.stringList(values: $values)';
}


}

/// @nodoc
abstract mixin class $StringListPropertyCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory $StringListPropertyCopyWith(StringListProperty value, $Res Function(StringListProperty) _then) = _$StringListPropertyCopyWithImpl;
@useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class _$StringListPropertyCopyWithImpl<$Res>
    implements $StringListPropertyCopyWith<$Res> {
  _$StringListPropertyCopyWithImpl(this._self, this._then);

  final StringListProperty _self;
  final $Res Function(StringListProperty) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(StringListProperty(
null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MapProperty implements PropertyValue {
  const MapProperty(final  Map<String, dynamic> value, {final  String? $type}): _value = value,$type = $type ?? 'map';
  factory MapProperty.fromJson(Map<String, dynamic> json) => _$MapPropertyFromJson(json);

 final  Map<String, dynamic> _value;
 Map<String, dynamic> get value {
  if (_value is EqualUnmodifiableMapView) return _value;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_value);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapPropertyCopyWith<MapProperty> get copyWith => _$MapPropertyCopyWithImpl<MapProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapProperty&&const DeepCollectionEquality().equals(other._value, _value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_value));

@override
String toString() {
  return 'PropertyValue.map(value: $value)';
}


}

/// @nodoc
abstract mixin class $MapPropertyCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory $MapPropertyCopyWith(MapProperty value, $Res Function(MapProperty) _then) = _$MapPropertyCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> value
});




}
/// @nodoc
class _$MapPropertyCopyWithImpl<$Res>
    implements $MapPropertyCopyWith<$Res> {
  _$MapPropertyCopyWithImpl(this._self, this._then);

  final MapProperty _self;
  final $Res Function(MapProperty) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(MapProperty(
null == value ? _self._value : value // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ObjectListProperty implements PropertyValue {
  const ObjectListProperty(final  List<Map<String, dynamic>> objects, {final  String? $type}): _objects = objects,$type = $type ?? 'objectList';
  factory ObjectListProperty.fromJson(Map<String, dynamic> json) => _$ObjectListPropertyFromJson(json);

 final  List<Map<String, dynamic>> _objects;
 List<Map<String, dynamic>> get objects {
  if (_objects is EqualUnmodifiableListView) return _objects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_objects);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectListPropertyCopyWith<ObjectListProperty> get copyWith => _$ObjectListPropertyCopyWithImpl<ObjectListProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectListPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectListProperty&&const DeepCollectionEquality().equals(other._objects, _objects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_objects));

@override
String toString() {
  return 'PropertyValue.objectList(objects: $objects)';
}


}

/// @nodoc
abstract mixin class $ObjectListPropertyCopyWith<$Res> implements $PropertyValueCopyWith<$Res> {
  factory $ObjectListPropertyCopyWith(ObjectListProperty value, $Res Function(ObjectListProperty) _then) = _$ObjectListPropertyCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> objects
});




}
/// @nodoc
class _$ObjectListPropertyCopyWithImpl<$Res>
    implements $ObjectListPropertyCopyWith<$Res> {
  _$ObjectListPropertyCopyWithImpl(this._self, this._then);

  final ObjectListProperty _self;
  final $Res Function(ObjectListProperty) _then;

/// Create a copy of PropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? objects = null,}) {
  return _then(ObjectListProperty(
null == objects ? _self._objects : objects // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}


/// @nodoc
mixin _$Asset {

 String get id; AssetType get type; String get projectId; String get name; String? get description;// Rich property system
 Map<String, PropertyValue> get properties;// Trigger tracking
 List<String> get completedTriggers;// Deduplication keys
 Map<String, TriggerResult> get triggerResults;// Relationships
 List<String> get parentAssetIds; List<String> get childAssetIds;// Metadata
 DateTime get discoveredAt; DateTime? get lastUpdated; String? get discoveryMethod; double? get confidence;// Tags for filtering and grouping
 List<String> get tags;
/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetCopyWith<Asset> get copyWith => _$AssetCopyWithImpl<Asset>(this as Asset, _$identity);

  /// Serializes this Asset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Asset&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.properties, properties)&&const DeepCollectionEquality().equals(other.completedTriggers, completedTriggers)&&const DeepCollectionEquality().equals(other.triggerResults, triggerResults)&&const DeepCollectionEquality().equals(other.parentAssetIds, parentAssetIds)&&const DeepCollectionEquality().equals(other.childAssetIds, childAssetIds)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.discoveryMethod, discoveryMethod) || other.discoveryMethod == discoveryMethod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,projectId,name,description,const DeepCollectionEquality().hash(properties),const DeepCollectionEquality().hash(completedTriggers),const DeepCollectionEquality().hash(triggerResults),const DeepCollectionEquality().hash(parentAssetIds),const DeepCollectionEquality().hash(childAssetIds),discoveredAt,lastUpdated,discoveryMethod,confidence,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'Asset(id: $id, type: $type, projectId: $projectId, name: $name, description: $description, properties: $properties, completedTriggers: $completedTriggers, triggerResults: $triggerResults, parentAssetIds: $parentAssetIds, childAssetIds: $childAssetIds, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated, discoveryMethod: $discoveryMethod, confidence: $confidence, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $AssetCopyWith<$Res>  {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) _then) = _$AssetCopyWithImpl;
@useResult
$Res call({
 String id, AssetType type, String projectId, String name, String? description, Map<String, PropertyValue> properties, List<String> completedTriggers, Map<String, TriggerResult> triggerResults, List<String> parentAssetIds, List<String> childAssetIds, DateTime discoveredAt, DateTime? lastUpdated, String? discoveryMethod, double? confidence, List<String> tags
});




}
/// @nodoc
class _$AssetCopyWithImpl<$Res>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._self, this._then);

  final Asset _self;
  final $Res Function(Asset) _then;

/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? properties = null,Object? completedTriggers = null,Object? triggerResults = null,Object? parentAssetIds = null,Object? childAssetIds = null,Object? discoveredAt = null,Object? lastUpdated = freezed,Object? discoveryMethod = freezed,Object? confidence = freezed,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, PropertyValue>,completedTriggers: null == completedTriggers ? _self.completedTriggers : completedTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,triggerResults: null == triggerResults ? _self.triggerResults : triggerResults // ignore: cast_nullable_to_non_nullable
as Map<String, TriggerResult>,parentAssetIds: null == parentAssetIds ? _self.parentAssetIds : parentAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,childAssetIds: null == childAssetIds ? _self.childAssetIds : childAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,discoveredAt: null == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,discoveryMethod: freezed == discoveryMethod ? _self.discoveryMethod : discoveryMethod // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Asset].
extension AssetPatterns on Asset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Asset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Asset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Asset value)  $default,){
final _that = this;
switch (_that) {
case _Asset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Asset value)?  $default,){
final _that = this;
switch (_that) {
case _Asset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AssetType type,  String projectId,  String name,  String? description,  Map<String, PropertyValue> properties,  List<String> completedTriggers,  Map<String, TriggerResult> triggerResults,  List<String> parentAssetIds,  List<String> childAssetIds,  DateTime discoveredAt,  DateTime? lastUpdated,  String? discoveryMethod,  double? confidence,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that.id,_that.type,_that.projectId,_that.name,_that.description,_that.properties,_that.completedTriggers,_that.triggerResults,_that.parentAssetIds,_that.childAssetIds,_that.discoveredAt,_that.lastUpdated,_that.discoveryMethod,_that.confidence,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AssetType type,  String projectId,  String name,  String? description,  Map<String, PropertyValue> properties,  List<String> completedTriggers,  Map<String, TriggerResult> triggerResults,  List<String> parentAssetIds,  List<String> childAssetIds,  DateTime discoveredAt,  DateTime? lastUpdated,  String? discoveryMethod,  double? confidence,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Asset():
return $default(_that.id,_that.type,_that.projectId,_that.name,_that.description,_that.properties,_that.completedTriggers,_that.triggerResults,_that.parentAssetIds,_that.childAssetIds,_that.discoveredAt,_that.lastUpdated,_that.discoveryMethod,_that.confidence,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AssetType type,  String projectId,  String name,  String? description,  Map<String, PropertyValue> properties,  List<String> completedTriggers,  Map<String, TriggerResult> triggerResults,  List<String> parentAssetIds,  List<String> childAssetIds,  DateTime discoveredAt,  DateTime? lastUpdated,  String? discoveryMethod,  double? confidence,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that.id,_that.type,_that.projectId,_that.name,_that.description,_that.properties,_that.completedTriggers,_that.triggerResults,_that.parentAssetIds,_that.childAssetIds,_that.discoveredAt,_that.lastUpdated,_that.discoveryMethod,_that.confidence,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Asset implements Asset {
  const _Asset({required this.id, required this.type, required this.projectId, required this.name, this.description, required final  Map<String, PropertyValue> properties, required final  List<String> completedTriggers, required final  Map<String, TriggerResult> triggerResults, required final  List<String> parentAssetIds, required final  List<String> childAssetIds, required this.discoveredAt, this.lastUpdated, this.discoveryMethod, this.confidence, required final  List<String> tags}): _properties = properties,_completedTriggers = completedTriggers,_triggerResults = triggerResults,_parentAssetIds = parentAssetIds,_childAssetIds = childAssetIds,_tags = tags;
  factory _Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

@override final  String id;
@override final  AssetType type;
@override final  String projectId;
@override final  String name;
@override final  String? description;
// Rich property system
 final  Map<String, PropertyValue> _properties;
// Rich property system
@override Map<String, PropertyValue> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

// Trigger tracking
 final  List<String> _completedTriggers;
// Trigger tracking
@override List<String> get completedTriggers {
  if (_completedTriggers is EqualUnmodifiableListView) return _completedTriggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedTriggers);
}

// Deduplication keys
 final  Map<String, TriggerResult> _triggerResults;
// Deduplication keys
@override Map<String, TriggerResult> get triggerResults {
  if (_triggerResults is EqualUnmodifiableMapView) return _triggerResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_triggerResults);
}

// Relationships
 final  List<String> _parentAssetIds;
// Relationships
@override List<String> get parentAssetIds {
  if (_parentAssetIds is EqualUnmodifiableListView) return _parentAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parentAssetIds);
}

 final  List<String> _childAssetIds;
@override List<String> get childAssetIds {
  if (_childAssetIds is EqualUnmodifiableListView) return _childAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childAssetIds);
}

// Metadata
@override final  DateTime discoveredAt;
@override final  DateTime? lastUpdated;
@override final  String? discoveryMethod;
@override final  double? confidence;
// Tags for filtering and grouping
 final  List<String> _tags;
// Tags for filtering and grouping
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetCopyWith<_Asset> get copyWith => __$AssetCopyWithImpl<_Asset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Asset&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._properties, _properties)&&const DeepCollectionEquality().equals(other._completedTriggers, _completedTriggers)&&const DeepCollectionEquality().equals(other._triggerResults, _triggerResults)&&const DeepCollectionEquality().equals(other._parentAssetIds, _parentAssetIds)&&const DeepCollectionEquality().equals(other._childAssetIds, _childAssetIds)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.discoveryMethod, discoveryMethod) || other.discoveryMethod == discoveryMethod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,projectId,name,description,const DeepCollectionEquality().hash(_properties),const DeepCollectionEquality().hash(_completedTriggers),const DeepCollectionEquality().hash(_triggerResults),const DeepCollectionEquality().hash(_parentAssetIds),const DeepCollectionEquality().hash(_childAssetIds),discoveredAt,lastUpdated,discoveryMethod,confidence,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'Asset(id: $id, type: $type, projectId: $projectId, name: $name, description: $description, properties: $properties, completedTriggers: $completedTriggers, triggerResults: $triggerResults, parentAssetIds: $parentAssetIds, childAssetIds: $childAssetIds, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated, discoveryMethod: $discoveryMethod, confidence: $confidence, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$AssetCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$AssetCopyWith(_Asset value, $Res Function(_Asset) _then) = __$AssetCopyWithImpl;
@override @useResult
$Res call({
 String id, AssetType type, String projectId, String name, String? description, Map<String, PropertyValue> properties, List<String> completedTriggers, Map<String, TriggerResult> triggerResults, List<String> parentAssetIds, List<String> childAssetIds, DateTime discoveredAt, DateTime? lastUpdated, String? discoveryMethod, double? confidence, List<String> tags
});




}
/// @nodoc
class __$AssetCopyWithImpl<$Res>
    implements _$AssetCopyWith<$Res> {
  __$AssetCopyWithImpl(this._self, this._then);

  final _Asset _self;
  final $Res Function(_Asset) _then;

/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? properties = null,Object? completedTriggers = null,Object? triggerResults = null,Object? parentAssetIds = null,Object? childAssetIds = null,Object? discoveredAt = null,Object? lastUpdated = freezed,Object? discoveryMethod = freezed,Object? confidence = freezed,Object? tags = null,}) {
  return _then(_Asset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, PropertyValue>,completedTriggers: null == completedTriggers ? _self._completedTriggers : completedTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,triggerResults: null == triggerResults ? _self._triggerResults : triggerResults // ignore: cast_nullable_to_non_nullable
as Map<String, TriggerResult>,parentAssetIds: null == parentAssetIds ? _self._parentAssetIds : parentAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,childAssetIds: null == childAssetIds ? _self._childAssetIds : childAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,discoveredAt: null == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,discoveryMethod: freezed == discoveryMethod ? _self.discoveryMethod : discoveryMethod // ignore: cast_nullable_to_non_nullable
as String?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TriggerResult {

 String get methodologyId; DateTime get executedAt; bool get success; String? get output; Map<String, PropertyValue>? get propertyUpdates; List<Asset>? get discoveredAssets; String? get error;
/// Create a copy of TriggerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerResultCopyWith<TriggerResult> get copyWith => _$TriggerResultCopyWithImpl<TriggerResult>(this as TriggerResult, _$identity);

  /// Serializes this TriggerResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerResult&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.success, success) || other.success == success)&&(identical(other.output, output) || other.output == output)&&const DeepCollectionEquality().equals(other.propertyUpdates, propertyUpdates)&&const DeepCollectionEquality().equals(other.discoveredAssets, discoveredAssets)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,methodologyId,executedAt,success,output,const DeepCollectionEquality().hash(propertyUpdates),const DeepCollectionEquality().hash(discoveredAssets),error);

@override
String toString() {
  return 'TriggerResult(methodologyId: $methodologyId, executedAt: $executedAt, success: $success, output: $output, propertyUpdates: $propertyUpdates, discoveredAssets: $discoveredAssets, error: $error)';
}


}

/// @nodoc
abstract mixin class $TriggerResultCopyWith<$Res>  {
  factory $TriggerResultCopyWith(TriggerResult value, $Res Function(TriggerResult) _then) = _$TriggerResultCopyWithImpl;
@useResult
$Res call({
 String methodologyId, DateTime executedAt, bool success, String? output, Map<String, PropertyValue>? propertyUpdates, List<Asset>? discoveredAssets, String? error
});




}
/// @nodoc
class _$TriggerResultCopyWithImpl<$Res>
    implements $TriggerResultCopyWith<$Res> {
  _$TriggerResultCopyWithImpl(this._self, this._then);

  final TriggerResult _self;
  final $Res Function(TriggerResult) _then;

/// Create a copy of TriggerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? methodologyId = null,Object? executedAt = null,Object? success = null,Object? output = freezed,Object? propertyUpdates = freezed,Object? discoveredAssets = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,executedAt: null == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,propertyUpdates: freezed == propertyUpdates ? _self.propertyUpdates : propertyUpdates // ignore: cast_nullable_to_non_nullable
as Map<String, PropertyValue>?,discoveredAssets: freezed == discoveredAssets ? _self.discoveredAssets : discoveredAssets // ignore: cast_nullable_to_non_nullable
as List<Asset>?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerResult].
extension TriggerResultPatterns on TriggerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerResult value)  $default,){
final _that = this;
switch (_that) {
case _TriggerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerResult value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String methodologyId,  DateTime executedAt,  bool success,  String? output,  Map<String, PropertyValue>? propertyUpdates,  List<Asset>? discoveredAssets,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerResult() when $default != null:
return $default(_that.methodologyId,_that.executedAt,_that.success,_that.output,_that.propertyUpdates,_that.discoveredAssets,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String methodologyId,  DateTime executedAt,  bool success,  String? output,  Map<String, PropertyValue>? propertyUpdates,  List<Asset>? discoveredAssets,  String? error)  $default,) {final _that = this;
switch (_that) {
case _TriggerResult():
return $default(_that.methodologyId,_that.executedAt,_that.success,_that.output,_that.propertyUpdates,_that.discoveredAssets,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String methodologyId,  DateTime executedAt,  bool success,  String? output,  Map<String, PropertyValue>? propertyUpdates,  List<Asset>? discoveredAssets,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _TriggerResult() when $default != null:
return $default(_that.methodologyId,_that.executedAt,_that.success,_that.output,_that.propertyUpdates,_that.discoveredAssets,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerResult implements TriggerResult {
  const _TriggerResult({required this.methodologyId, required this.executedAt, required this.success, this.output, final  Map<String, PropertyValue>? propertyUpdates, final  List<Asset>? discoveredAssets, this.error}): _propertyUpdates = propertyUpdates,_discoveredAssets = discoveredAssets;
  factory _TriggerResult.fromJson(Map<String, dynamic> json) => _$TriggerResultFromJson(json);

@override final  String methodologyId;
@override final  DateTime executedAt;
@override final  bool success;
@override final  String? output;
 final  Map<String, PropertyValue>? _propertyUpdates;
@override Map<String, PropertyValue>? get propertyUpdates {
  final value = _propertyUpdates;
  if (value == null) return null;
  if (_propertyUpdates is EqualUnmodifiableMapView) return _propertyUpdates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<Asset>? _discoveredAssets;
@override List<Asset>? get discoveredAssets {
  final value = _discoveredAssets;
  if (value == null) return null;
  if (_discoveredAssets is EqualUnmodifiableListView) return _discoveredAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? error;

/// Create a copy of TriggerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerResultCopyWith<_TriggerResult> get copyWith => __$TriggerResultCopyWithImpl<_TriggerResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerResult&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.success, success) || other.success == success)&&(identical(other.output, output) || other.output == output)&&const DeepCollectionEquality().equals(other._propertyUpdates, _propertyUpdates)&&const DeepCollectionEquality().equals(other._discoveredAssets, _discoveredAssets)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,methodologyId,executedAt,success,output,const DeepCollectionEquality().hash(_propertyUpdates),const DeepCollectionEquality().hash(_discoveredAssets),error);

@override
String toString() {
  return 'TriggerResult(methodologyId: $methodologyId, executedAt: $executedAt, success: $success, output: $output, propertyUpdates: $propertyUpdates, discoveredAssets: $discoveredAssets, error: $error)';
}


}

/// @nodoc
abstract mixin class _$TriggerResultCopyWith<$Res> implements $TriggerResultCopyWith<$Res> {
  factory _$TriggerResultCopyWith(_TriggerResult value, $Res Function(_TriggerResult) _then) = __$TriggerResultCopyWithImpl;
@override @useResult
$Res call({
 String methodologyId, DateTime executedAt, bool success, String? output, Map<String, PropertyValue>? propertyUpdates, List<Asset>? discoveredAssets, String? error
});




}
/// @nodoc
class __$TriggerResultCopyWithImpl<$Res>
    implements _$TriggerResultCopyWith<$Res> {
  __$TriggerResultCopyWithImpl(this._self, this._then);

  final _TriggerResult _self;
  final $Res Function(_TriggerResult) _then;

/// Create a copy of TriggerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? methodologyId = null,Object? executedAt = null,Object? success = null,Object? output = freezed,Object? propertyUpdates = freezed,Object? discoveredAssets = freezed,Object? error = freezed,}) {
  return _then(_TriggerResult(
methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,executedAt: null == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,propertyUpdates: freezed == propertyUpdates ? _self._propertyUpdates : propertyUpdates // ignore: cast_nullable_to_non_nullable
as Map<String, PropertyValue>?,discoveredAssets: freezed == discoveredAssets ? _self._discoveredAssets : discoveredAssets // ignore: cast_nullable_to_non_nullable
as List<Asset>?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
