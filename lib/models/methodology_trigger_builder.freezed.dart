// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'methodology_trigger_builder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TriggerCondition {

 String get id; AssetType get assetType; String get property; TriggerOperator get operator; TriggerValue get value; String? get logicalOperator;
/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerConditionCopyWith<TriggerCondition> get copyWith => _$TriggerConditionCopyWithImpl<TriggerCondition>(this as TriggerCondition, _$identity);

  /// Serializes this TriggerCondition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerCondition&&(identical(other.id, id) || other.id == id)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&(identical(other.property, property) || other.property == property)&&(identical(other.operator, operator) || other.operator == operator)&&(identical(other.value, value) || other.value == value)&&(identical(other.logicalOperator, logicalOperator) || other.logicalOperator == logicalOperator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetType,property,operator,value,logicalOperator);

@override
String toString() {
  return 'TriggerCondition(id: $id, assetType: $assetType, property: $property, operator: $operator, value: $value, logicalOperator: $logicalOperator)';
}


}

/// @nodoc
abstract mixin class $TriggerConditionCopyWith<$Res>  {
  factory $TriggerConditionCopyWith(TriggerCondition value, $Res Function(TriggerCondition) _then) = _$TriggerConditionCopyWithImpl;
@useResult
$Res call({
 String id, AssetType assetType, String property, TriggerOperator operator, TriggerValue value, String? logicalOperator
});


$TriggerValueCopyWith<$Res> get value;

}
/// @nodoc
class _$TriggerConditionCopyWithImpl<$Res>
    implements $TriggerConditionCopyWith<$Res> {
  _$TriggerConditionCopyWithImpl(this._self, this._then);

  final TriggerCondition _self;
  final $Res Function(TriggerCondition) _then;

/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? assetType = null,Object? property = null,Object? operator = null,Object? value = null,Object? logicalOperator = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as AssetType,property: null == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as String,operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as TriggerOperator,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TriggerValue,logicalOperator: freezed == logicalOperator ? _self.logicalOperator : logicalOperator // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TriggerValueCopyWith<$Res> get value {
  
  return $TriggerValueCopyWith<$Res>(_self.value, (value) {
    return _then(_self.copyWith(value: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AssetType assetType,  String property,  TriggerOperator operator,  TriggerValue value,  String? logicalOperator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerCondition() when $default != null:
return $default(_that.id,_that.assetType,_that.property,_that.operator,_that.value,_that.logicalOperator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AssetType assetType,  String property,  TriggerOperator operator,  TriggerValue value,  String? logicalOperator)  $default,) {final _that = this;
switch (_that) {
case _TriggerCondition():
return $default(_that.id,_that.assetType,_that.property,_that.operator,_that.value,_that.logicalOperator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AssetType assetType,  String property,  TriggerOperator operator,  TriggerValue value,  String? logicalOperator)?  $default,) {final _that = this;
switch (_that) {
case _TriggerCondition() when $default != null:
return $default(_that.id,_that.assetType,_that.property,_that.operator,_that.value,_that.logicalOperator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerCondition implements TriggerCondition {
  const _TriggerCondition({required this.id, required this.assetType, required this.property, required this.operator, required this.value, this.logicalOperator});
  factory _TriggerCondition.fromJson(Map<String, dynamic> json) => _$TriggerConditionFromJson(json);

@override final  String id;
@override final  AssetType assetType;
@override final  String property;
@override final  TriggerOperator operator;
@override final  TriggerValue value;
@override final  String? logicalOperator;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerCondition&&(identical(other.id, id) || other.id == id)&&(identical(other.assetType, assetType) || other.assetType == assetType)&&(identical(other.property, property) || other.property == property)&&(identical(other.operator, operator) || other.operator == operator)&&(identical(other.value, value) || other.value == value)&&(identical(other.logicalOperator, logicalOperator) || other.logicalOperator == logicalOperator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,assetType,property,operator,value,logicalOperator);

@override
String toString() {
  return 'TriggerCondition(id: $id, assetType: $assetType, property: $property, operator: $operator, value: $value, logicalOperator: $logicalOperator)';
}


}

/// @nodoc
abstract mixin class _$TriggerConditionCopyWith<$Res> implements $TriggerConditionCopyWith<$Res> {
  factory _$TriggerConditionCopyWith(_TriggerCondition value, $Res Function(_TriggerCondition) _then) = __$TriggerConditionCopyWithImpl;
@override @useResult
$Res call({
 String id, AssetType assetType, String property, TriggerOperator operator, TriggerValue value, String? logicalOperator
});


@override $TriggerValueCopyWith<$Res> get value;

}
/// @nodoc
class __$TriggerConditionCopyWithImpl<$Res>
    implements _$TriggerConditionCopyWith<$Res> {
  __$TriggerConditionCopyWithImpl(this._self, this._then);

  final _TriggerCondition _self;
  final $Res Function(_TriggerCondition) _then;

/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? assetType = null,Object? property = null,Object? operator = null,Object? value = null,Object? logicalOperator = freezed,}) {
  return _then(_TriggerCondition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,assetType: null == assetType ? _self.assetType : assetType // ignore: cast_nullable_to_non_nullable
as AssetType,property: null == property ? _self.property : property // ignore: cast_nullable_to_non_nullable
as String,operator: null == operator ? _self.operator : operator // ignore: cast_nullable_to_non_nullable
as TriggerOperator,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as TriggerValue,logicalOperator: freezed == logicalOperator ? _self.logicalOperator : logicalOperator // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of TriggerCondition
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TriggerValueCopyWith<$Res> get value {
  
  return $TriggerValueCopyWith<$Res>(_self.value, (value) {
    return _then(_self.copyWith(value: value));
  });
}
}

TriggerValue _$TriggerValueFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'string':
          return StringTriggerValue.fromJson(
            json
          );
                case 'boolean':
          return BooleanTriggerValue.fromJson(
            json
          );
                case 'number':
          return NumberTriggerValue.fromJson(
            json
          );
                case 'list':
          return ListTriggerValue.fromJson(
            json
          );
                case 'isNull':
          return NullTriggerValue.fromJson(
            json
          );
                case 'notNull':
          return NotNullTriggerValue.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'TriggerValue',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$TriggerValue {



  /// Serializes this TriggerValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerValue);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TriggerValue()';
}


}

/// @nodoc
class $TriggerValueCopyWith<$Res>  {
$TriggerValueCopyWith(TriggerValue _, $Res Function(TriggerValue) __);
}


/// Adds pattern-matching-related methods to [TriggerValue].
extension TriggerValuePatterns on TriggerValue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StringTriggerValue value)?  string,TResult Function( BooleanTriggerValue value)?  boolean,TResult Function( NumberTriggerValue value)?  number,TResult Function( ListTriggerValue value)?  list,TResult Function( NullTriggerValue value)?  isNull,TResult Function( NotNullTriggerValue value)?  notNull,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StringTriggerValue() when string != null:
return string(_that);case BooleanTriggerValue() when boolean != null:
return boolean(_that);case NumberTriggerValue() when number != null:
return number(_that);case ListTriggerValue() when list != null:
return list(_that);case NullTriggerValue() when isNull != null:
return isNull(_that);case NotNullTriggerValue() when notNull != null:
return notNull(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StringTriggerValue value)  string,required TResult Function( BooleanTriggerValue value)  boolean,required TResult Function( NumberTriggerValue value)  number,required TResult Function( ListTriggerValue value)  list,required TResult Function( NullTriggerValue value)  isNull,required TResult Function( NotNullTriggerValue value)  notNull,}){
final _that = this;
switch (_that) {
case StringTriggerValue():
return string(_that);case BooleanTriggerValue():
return boolean(_that);case NumberTriggerValue():
return number(_that);case ListTriggerValue():
return list(_that);case NullTriggerValue():
return isNull(_that);case NotNullTriggerValue():
return notNull(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StringTriggerValue value)?  string,TResult? Function( BooleanTriggerValue value)?  boolean,TResult? Function( NumberTriggerValue value)?  number,TResult? Function( ListTriggerValue value)?  list,TResult? Function( NullTriggerValue value)?  isNull,TResult? Function( NotNullTriggerValue value)?  notNull,}){
final _that = this;
switch (_that) {
case StringTriggerValue() when string != null:
return string(_that);case BooleanTriggerValue() when boolean != null:
return boolean(_that);case NumberTriggerValue() when number != null:
return number(_that);case ListTriggerValue() when list != null:
return list(_that);case NullTriggerValue() when isNull != null:
return isNull(_that);case NotNullTriggerValue() when notNull != null:
return notNull(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  string,TResult Function( bool value)?  boolean,TResult Function( double value)?  number,TResult Function( List<String> values)?  list,TResult Function()?  isNull,TResult Function()?  notNull,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StringTriggerValue() when string != null:
return string(_that.value);case BooleanTriggerValue() when boolean != null:
return boolean(_that.value);case NumberTriggerValue() when number != null:
return number(_that.value);case ListTriggerValue() when list != null:
return list(_that.values);case NullTriggerValue() when isNull != null:
return isNull();case NotNullTriggerValue() when notNull != null:
return notNull();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  string,required TResult Function( bool value)  boolean,required TResult Function( double value)  number,required TResult Function( List<String> values)  list,required TResult Function()  isNull,required TResult Function()  notNull,}) {final _that = this;
switch (_that) {
case StringTriggerValue():
return string(_that.value);case BooleanTriggerValue():
return boolean(_that.value);case NumberTriggerValue():
return number(_that.value);case ListTriggerValue():
return list(_that.values);case NullTriggerValue():
return isNull();case NotNullTriggerValue():
return notNull();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  string,TResult? Function( bool value)?  boolean,TResult? Function( double value)?  number,TResult? Function( List<String> values)?  list,TResult? Function()?  isNull,TResult? Function()?  notNull,}) {final _that = this;
switch (_that) {
case StringTriggerValue() when string != null:
return string(_that.value);case BooleanTriggerValue() when boolean != null:
return boolean(_that.value);case NumberTriggerValue() when number != null:
return number(_that.value);case ListTriggerValue() when list != null:
return list(_that.values);case NullTriggerValue() when isNull != null:
return isNull();case NotNullTriggerValue() when notNull != null:
return notNull();case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class StringTriggerValue implements TriggerValue {
  const StringTriggerValue(this.value, {final  String? $type}): $type = $type ?? 'string';
  factory StringTriggerValue.fromJson(Map<String, dynamic> json) => _$StringTriggerValueFromJson(json);

 final  String value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringTriggerValueCopyWith<StringTriggerValue> get copyWith => _$StringTriggerValueCopyWithImpl<StringTriggerValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StringTriggerValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringTriggerValue&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TriggerValue.string(value: $value)';
}


}

/// @nodoc
abstract mixin class $StringTriggerValueCopyWith<$Res> implements $TriggerValueCopyWith<$Res> {
  factory $StringTriggerValueCopyWith(StringTriggerValue value, $Res Function(StringTriggerValue) _then) = _$StringTriggerValueCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$StringTriggerValueCopyWithImpl<$Res>
    implements $StringTriggerValueCopyWith<$Res> {
  _$StringTriggerValueCopyWithImpl(this._self, this._then);

  final StringTriggerValue _self;
  final $Res Function(StringTriggerValue) _then;

/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(StringTriggerValue(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BooleanTriggerValue implements TriggerValue {
  const BooleanTriggerValue(this.value, {final  String? $type}): $type = $type ?? 'boolean';
  factory BooleanTriggerValue.fromJson(Map<String, dynamic> json) => _$BooleanTriggerValueFromJson(json);

 final  bool value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BooleanTriggerValueCopyWith<BooleanTriggerValue> get copyWith => _$BooleanTriggerValueCopyWithImpl<BooleanTriggerValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BooleanTriggerValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BooleanTriggerValue&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TriggerValue.boolean(value: $value)';
}


}

/// @nodoc
abstract mixin class $BooleanTriggerValueCopyWith<$Res> implements $TriggerValueCopyWith<$Res> {
  factory $BooleanTriggerValueCopyWith(BooleanTriggerValue value, $Res Function(BooleanTriggerValue) _then) = _$BooleanTriggerValueCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$BooleanTriggerValueCopyWithImpl<$Res>
    implements $BooleanTriggerValueCopyWith<$Res> {
  _$BooleanTriggerValueCopyWithImpl(this._self, this._then);

  final BooleanTriggerValue _self;
  final $Res Function(BooleanTriggerValue) _then;

/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(BooleanTriggerValue(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NumberTriggerValue implements TriggerValue {
  const NumberTriggerValue(this.value, {final  String? $type}): $type = $type ?? 'number';
  factory NumberTriggerValue.fromJson(Map<String, dynamic> json) => _$NumberTriggerValueFromJson(json);

 final  double value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NumberTriggerValueCopyWith<NumberTriggerValue> get copyWith => _$NumberTriggerValueCopyWithImpl<NumberTriggerValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NumberTriggerValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NumberTriggerValue&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'TriggerValue.number(value: $value)';
}


}

/// @nodoc
abstract mixin class $NumberTriggerValueCopyWith<$Res> implements $TriggerValueCopyWith<$Res> {
  factory $NumberTriggerValueCopyWith(NumberTriggerValue value, $Res Function(NumberTriggerValue) _then) = _$NumberTriggerValueCopyWithImpl;
@useResult
$Res call({
 double value
});




}
/// @nodoc
class _$NumberTriggerValueCopyWithImpl<$Res>
    implements $NumberTriggerValueCopyWith<$Res> {
  _$NumberTriggerValueCopyWithImpl(this._self, this._then);

  final NumberTriggerValue _self;
  final $Res Function(NumberTriggerValue) _then;

/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(NumberTriggerValue(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ListTriggerValue implements TriggerValue {
  const ListTriggerValue(final  List<String> values, {final  String? $type}): _values = values,$type = $type ?? 'list';
  factory ListTriggerValue.fromJson(Map<String, dynamic> json) => _$ListTriggerValueFromJson(json);

 final  List<String> _values;
 List<String> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListTriggerValueCopyWith<ListTriggerValue> get copyWith => _$ListTriggerValueCopyWithImpl<ListTriggerValue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListTriggerValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListTriggerValue&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'TriggerValue.list(values: $values)';
}


}

/// @nodoc
abstract mixin class $ListTriggerValueCopyWith<$Res> implements $TriggerValueCopyWith<$Res> {
  factory $ListTriggerValueCopyWith(ListTriggerValue value, $Res Function(ListTriggerValue) _then) = _$ListTriggerValueCopyWithImpl;
@useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class _$ListTriggerValueCopyWithImpl<$Res>
    implements $ListTriggerValueCopyWith<$Res> {
  _$ListTriggerValueCopyWithImpl(this._self, this._then);

  final ListTriggerValue _self;
  final $Res Function(ListTriggerValue) _then;

/// Create a copy of TriggerValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(ListTriggerValue(
null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class NullTriggerValue implements TriggerValue {
  const NullTriggerValue({final  String? $type}): $type = $type ?? 'isNull';
  factory NullTriggerValue.fromJson(Map<String, dynamic> json) => _$NullTriggerValueFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$NullTriggerValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NullTriggerValue);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TriggerValue.isNull()';
}


}




/// @nodoc
@JsonSerializable()

class NotNullTriggerValue implements TriggerValue {
  const NotNullTriggerValue({final  String? $type}): $type = $type ?? 'notNull';
  factory NotNullTriggerValue.fromJson(Map<String, dynamic> json) => _$NotNullTriggerValueFromJson(json);



@JsonKey(name: 'runtimeType')
final String $type;



@override
Map<String, dynamic> toJson() {
  return _$NotNullTriggerValueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotNullTriggerValue);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TriggerValue.notNull()';
}


}





/// @nodoc
mixin _$TriggerGroup {

 String get id; List<TriggerCondition> get conditions; String get logicalOperator;
/// Create a copy of TriggerGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerGroupCopyWith<TriggerGroup> get copyWith => _$TriggerGroupCopyWithImpl<TriggerGroup>(this as TriggerGroup, _$identity);

  /// Serializes this TriggerGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerGroup&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.conditions, conditions)&&(identical(other.logicalOperator, logicalOperator) || other.logicalOperator == logicalOperator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(conditions),logicalOperator);

@override
String toString() {
  return 'TriggerGroup(id: $id, conditions: $conditions, logicalOperator: $logicalOperator)';
}


}

/// @nodoc
abstract mixin class $TriggerGroupCopyWith<$Res>  {
  factory $TriggerGroupCopyWith(TriggerGroup value, $Res Function(TriggerGroup) _then) = _$TriggerGroupCopyWithImpl;
@useResult
$Res call({
 String id, List<TriggerCondition> conditions, String logicalOperator
});




}
/// @nodoc
class _$TriggerGroupCopyWithImpl<$Res>
    implements $TriggerGroupCopyWith<$Res> {
  _$TriggerGroupCopyWithImpl(this._self, this._then);

  final TriggerGroup _self;
  final $Res Function(TriggerGroup) _then;

/// Create a copy of TriggerGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conditions = null,Object? logicalOperator = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<TriggerCondition>,logicalOperator: null == logicalOperator ? _self.logicalOperator : logicalOperator // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerGroup].
extension TriggerGroupPatterns on TriggerGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerGroup value)  $default,){
final _that = this;
switch (_that) {
case _TriggerGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerGroup value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<TriggerCondition> conditions,  String logicalOperator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerGroup() when $default != null:
return $default(_that.id,_that.conditions,_that.logicalOperator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<TriggerCondition> conditions,  String logicalOperator)  $default,) {final _that = this;
switch (_that) {
case _TriggerGroup():
return $default(_that.id,_that.conditions,_that.logicalOperator);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<TriggerCondition> conditions,  String logicalOperator)?  $default,) {final _that = this;
switch (_that) {
case _TriggerGroup() when $default != null:
return $default(_that.id,_that.conditions,_that.logicalOperator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerGroup implements TriggerGroup {
  const _TriggerGroup({required this.id, required final  List<TriggerCondition> conditions, this.logicalOperator = 'AND'}): _conditions = conditions;
  factory _TriggerGroup.fromJson(Map<String, dynamic> json) => _$TriggerGroupFromJson(json);

@override final  String id;
 final  List<TriggerCondition> _conditions;
@override List<TriggerCondition> get conditions {
  if (_conditions is EqualUnmodifiableListView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditions);
}

@override@JsonKey() final  String logicalOperator;

/// Create a copy of TriggerGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerGroupCopyWith<_TriggerGroup> get copyWith => __$TriggerGroupCopyWithImpl<_TriggerGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerGroup&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._conditions, _conditions)&&(identical(other.logicalOperator, logicalOperator) || other.logicalOperator == logicalOperator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_conditions),logicalOperator);

@override
String toString() {
  return 'TriggerGroup(id: $id, conditions: $conditions, logicalOperator: $logicalOperator)';
}


}

/// @nodoc
abstract mixin class _$TriggerGroupCopyWith<$Res> implements $TriggerGroupCopyWith<$Res> {
  factory _$TriggerGroupCopyWith(_TriggerGroup value, $Res Function(_TriggerGroup) _then) = __$TriggerGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, List<TriggerCondition> conditions, String logicalOperator
});




}
/// @nodoc
class __$TriggerGroupCopyWithImpl<$Res>
    implements _$TriggerGroupCopyWith<$Res> {
  __$TriggerGroupCopyWithImpl(this._self, this._then);

  final _TriggerGroup _self;
  final $Res Function(_TriggerGroup) _then;

/// Create a copy of TriggerGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conditions = null,Object? logicalOperator = null,}) {
  return _then(_TriggerGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as List<TriggerCondition>,logicalOperator: null == logicalOperator ? _self.logicalOperator : logicalOperator // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$MethodologyTriggerDefinition {

 String get id; String get name; String get description; int get priority; bool get enabled; List<TriggerGroup> get conditionGroups; String get groupLogicalOperator; Map<String, String>? get parameterMappings; Map<String, dynamic>? get defaultParameters;
/// Create a copy of MethodologyTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MethodologyTriggerDefinitionCopyWith<MethodologyTriggerDefinition> get copyWith => _$MethodologyTriggerDefinitionCopyWithImpl<MethodologyTriggerDefinition>(this as MethodologyTriggerDefinition, _$identity);

  /// Serializes this MethodologyTriggerDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MethodologyTriggerDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.conditionGroups, conditionGroups)&&(identical(other.groupLogicalOperator, groupLogicalOperator) || other.groupLogicalOperator == groupLogicalOperator)&&const DeepCollectionEquality().equals(other.parameterMappings, parameterMappings)&&const DeepCollectionEquality().equals(other.defaultParameters, defaultParameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,priority,enabled,const DeepCollectionEquality().hash(conditionGroups),groupLogicalOperator,const DeepCollectionEquality().hash(parameterMappings),const DeepCollectionEquality().hash(defaultParameters));

@override
String toString() {
  return 'MethodologyTriggerDefinition(id: $id, name: $name, description: $description, priority: $priority, enabled: $enabled, conditionGroups: $conditionGroups, groupLogicalOperator: $groupLogicalOperator, parameterMappings: $parameterMappings, defaultParameters: $defaultParameters)';
}


}

/// @nodoc
abstract mixin class $MethodologyTriggerDefinitionCopyWith<$Res>  {
  factory $MethodologyTriggerDefinitionCopyWith(MethodologyTriggerDefinition value, $Res Function(MethodologyTriggerDefinition) _then) = _$MethodologyTriggerDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, int priority, bool enabled, List<TriggerGroup> conditionGroups, String groupLogicalOperator, Map<String, String>? parameterMappings, Map<String, dynamic>? defaultParameters
});




}
/// @nodoc
class _$MethodologyTriggerDefinitionCopyWithImpl<$Res>
    implements $MethodologyTriggerDefinitionCopyWith<$Res> {
  _$MethodologyTriggerDefinitionCopyWithImpl(this._self, this._then);

  final MethodologyTriggerDefinition _self;
  final $Res Function(MethodologyTriggerDefinition) _then;

/// Create a copy of MethodologyTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? priority = null,Object? enabled = null,Object? conditionGroups = null,Object? groupLogicalOperator = null,Object? parameterMappings = freezed,Object? defaultParameters = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,conditionGroups: null == conditionGroups ? _self.conditionGroups : conditionGroups // ignore: cast_nullable_to_non_nullable
as List<TriggerGroup>,groupLogicalOperator: null == groupLogicalOperator ? _self.groupLogicalOperator : groupLogicalOperator // ignore: cast_nullable_to_non_nullable
as String,parameterMappings: freezed == parameterMappings ? _self.parameterMappings : parameterMappings // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,defaultParameters: freezed == defaultParameters ? _self.defaultParameters : defaultParameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [MethodologyTriggerDefinition].
extension MethodologyTriggerDefinitionPatterns on MethodologyTriggerDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MethodologyTriggerDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MethodologyTriggerDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MethodologyTriggerDefinition value)  $default,){
final _that = this;
switch (_that) {
case _MethodologyTriggerDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MethodologyTriggerDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _MethodologyTriggerDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int priority,  bool enabled,  List<TriggerGroup> conditionGroups,  String groupLogicalOperator,  Map<String, String>? parameterMappings,  Map<String, dynamic>? defaultParameters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MethodologyTriggerDefinition() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.priority,_that.enabled,_that.conditionGroups,_that.groupLogicalOperator,_that.parameterMappings,_that.defaultParameters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  int priority,  bool enabled,  List<TriggerGroup> conditionGroups,  String groupLogicalOperator,  Map<String, String>? parameterMappings,  Map<String, dynamic>? defaultParameters)  $default,) {final _that = this;
switch (_that) {
case _MethodologyTriggerDefinition():
return $default(_that.id,_that.name,_that.description,_that.priority,_that.enabled,_that.conditionGroups,_that.groupLogicalOperator,_that.parameterMappings,_that.defaultParameters);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  int priority,  bool enabled,  List<TriggerGroup> conditionGroups,  String groupLogicalOperator,  Map<String, String>? parameterMappings,  Map<String, dynamic>? defaultParameters)?  $default,) {final _that = this;
switch (_that) {
case _MethodologyTriggerDefinition() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.priority,_that.enabled,_that.conditionGroups,_that.groupLogicalOperator,_that.parameterMappings,_that.defaultParameters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MethodologyTriggerDefinition implements MethodologyTriggerDefinition {
  const _MethodologyTriggerDefinition({required this.id, required this.name, required this.description, this.priority = 5, this.enabled = true, required final  List<TriggerGroup> conditionGroups, this.groupLogicalOperator = 'AND', final  Map<String, String>? parameterMappings, final  Map<String, dynamic>? defaultParameters}): _conditionGroups = conditionGroups,_parameterMappings = parameterMappings,_defaultParameters = defaultParameters;
  factory _MethodologyTriggerDefinition.fromJson(Map<String, dynamic> json) => _$MethodologyTriggerDefinitionFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override@JsonKey() final  int priority;
@override@JsonKey() final  bool enabled;
 final  List<TriggerGroup> _conditionGroups;
@override List<TriggerGroup> get conditionGroups {
  if (_conditionGroups is EqualUnmodifiableListView) return _conditionGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_conditionGroups);
}

@override@JsonKey() final  String groupLogicalOperator;
 final  Map<String, String>? _parameterMappings;
@override Map<String, String>? get parameterMappings {
  final value = _parameterMappings;
  if (value == null) return null;
  if (_parameterMappings is EqualUnmodifiableMapView) return _parameterMappings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _defaultParameters;
@override Map<String, dynamic>? get defaultParameters {
  final value = _defaultParameters;
  if (value == null) return null;
  if (_defaultParameters is EqualUnmodifiableMapView) return _defaultParameters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of MethodologyTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MethodologyTriggerDefinitionCopyWith<_MethodologyTriggerDefinition> get copyWith => __$MethodologyTriggerDefinitionCopyWithImpl<_MethodologyTriggerDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MethodologyTriggerDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MethodologyTriggerDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._conditionGroups, _conditionGroups)&&(identical(other.groupLogicalOperator, groupLogicalOperator) || other.groupLogicalOperator == groupLogicalOperator)&&const DeepCollectionEquality().equals(other._parameterMappings, _parameterMappings)&&const DeepCollectionEquality().equals(other._defaultParameters, _defaultParameters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,priority,enabled,const DeepCollectionEquality().hash(_conditionGroups),groupLogicalOperator,const DeepCollectionEquality().hash(_parameterMappings),const DeepCollectionEquality().hash(_defaultParameters));

@override
String toString() {
  return 'MethodologyTriggerDefinition(id: $id, name: $name, description: $description, priority: $priority, enabled: $enabled, conditionGroups: $conditionGroups, groupLogicalOperator: $groupLogicalOperator, parameterMappings: $parameterMappings, defaultParameters: $defaultParameters)';
}


}

/// @nodoc
abstract mixin class _$MethodologyTriggerDefinitionCopyWith<$Res> implements $MethodologyTriggerDefinitionCopyWith<$Res> {
  factory _$MethodologyTriggerDefinitionCopyWith(_MethodologyTriggerDefinition value, $Res Function(_MethodologyTriggerDefinition) _then) = __$MethodologyTriggerDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, int priority, bool enabled, List<TriggerGroup> conditionGroups, String groupLogicalOperator, Map<String, String>? parameterMappings, Map<String, dynamic>? defaultParameters
});




}
/// @nodoc
class __$MethodologyTriggerDefinitionCopyWithImpl<$Res>
    implements _$MethodologyTriggerDefinitionCopyWith<$Res> {
  __$MethodologyTriggerDefinitionCopyWithImpl(this._self, this._then);

  final _MethodologyTriggerDefinition _self;
  final $Res Function(_MethodologyTriggerDefinition) _then;

/// Create a copy of MethodologyTriggerDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? priority = null,Object? enabled = null,Object? conditionGroups = null,Object? groupLogicalOperator = null,Object? parameterMappings = freezed,Object? defaultParameters = freezed,}) {
  return _then(_MethodologyTriggerDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,conditionGroups: null == conditionGroups ? _self._conditionGroups : conditionGroups // ignore: cast_nullable_to_non_nullable
as List<TriggerGroup>,groupLogicalOperator: null == groupLogicalOperator ? _self.groupLogicalOperator : groupLogicalOperator // ignore: cast_nullable_to_non_nullable
as String,parameterMappings: freezed == parameterMappings ? _self._parameterMappings : parameterMappings // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,defaultParameters: freezed == defaultParameters ? _self._defaultParameters : defaultParameters // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$AssetProperty {

 String get name; String get displayName; PropertyType get type; List<String>? get allowedValues; String? get description;
/// Create a copy of AssetProperty
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetPropertyCopyWith<AssetProperty> get copyWith => _$AssetPropertyCopyWithImpl<AssetProperty>(this as AssetProperty, _$identity);

  /// Serializes this AssetProperty to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetProperty&&(identical(other.name, name) || other.name == name)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other.allowedValues, allowedValues)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,displayName,type,const DeepCollectionEquality().hash(allowedValues),description);

@override
String toString() {
  return 'AssetProperty(name: $name, displayName: $displayName, type: $type, allowedValues: $allowedValues, description: $description)';
}


}

/// @nodoc
abstract mixin class $AssetPropertyCopyWith<$Res>  {
  factory $AssetPropertyCopyWith(AssetProperty value, $Res Function(AssetProperty) _then) = _$AssetPropertyCopyWithImpl;
@useResult
$Res call({
 String name, String displayName, PropertyType type, List<String>? allowedValues, String? description
});




}
/// @nodoc
class _$AssetPropertyCopyWithImpl<$Res>
    implements $AssetPropertyCopyWith<$Res> {
  _$AssetPropertyCopyWithImpl(this._self, this._then);

  final AssetProperty _self;
  final $Res Function(AssetProperty) _then;

/// Create a copy of AssetProperty
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? displayName = null,Object? type = null,Object? allowedValues = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PropertyType,allowedValues: freezed == allowedValues ? _self.allowedValues : allowedValues // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AssetProperty].
extension AssetPropertyPatterns on AssetProperty {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssetProperty value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssetProperty() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssetProperty value)  $default,){
final _that = this;
switch (_that) {
case _AssetProperty():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssetProperty value)?  $default,){
final _that = this;
switch (_that) {
case _AssetProperty() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String displayName,  PropertyType type,  List<String>? allowedValues,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssetProperty() when $default != null:
return $default(_that.name,_that.displayName,_that.type,_that.allowedValues,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String displayName,  PropertyType type,  List<String>? allowedValues,  String? description)  $default,) {final _that = this;
switch (_that) {
case _AssetProperty():
return $default(_that.name,_that.displayName,_that.type,_that.allowedValues,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String displayName,  PropertyType type,  List<String>? allowedValues,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _AssetProperty() when $default != null:
return $default(_that.name,_that.displayName,_that.type,_that.allowedValues,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssetProperty implements AssetProperty {
  const _AssetProperty({required this.name, required this.displayName, required this.type, final  List<String>? allowedValues, this.description}): _allowedValues = allowedValues;
  factory _AssetProperty.fromJson(Map<String, dynamic> json) => _$AssetPropertyFromJson(json);

@override final  String name;
@override final  String displayName;
@override final  PropertyType type;
 final  List<String>? _allowedValues;
@override List<String>? get allowedValues {
  final value = _allowedValues;
  if (value == null) return null;
  if (_allowedValues is EqualUnmodifiableListView) return _allowedValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? description;

/// Create a copy of AssetProperty
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetPropertyCopyWith<_AssetProperty> get copyWith => __$AssetPropertyCopyWithImpl<_AssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssetProperty&&(identical(other.name, name) || other.name == name)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&const DeepCollectionEquality().equals(other._allowedValues, _allowedValues)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,displayName,type,const DeepCollectionEquality().hash(_allowedValues),description);

@override
String toString() {
  return 'AssetProperty(name: $name, displayName: $displayName, type: $type, allowedValues: $allowedValues, description: $description)';
}


}

/// @nodoc
abstract mixin class _$AssetPropertyCopyWith<$Res> implements $AssetPropertyCopyWith<$Res> {
  factory _$AssetPropertyCopyWith(_AssetProperty value, $Res Function(_AssetProperty) _then) = __$AssetPropertyCopyWithImpl;
@override @useResult
$Res call({
 String name, String displayName, PropertyType type, List<String>? allowedValues, String? description
});




}
/// @nodoc
class __$AssetPropertyCopyWithImpl<$Res>
    implements _$AssetPropertyCopyWith<$Res> {
  __$AssetPropertyCopyWithImpl(this._self, this._then);

  final _AssetProperty _self;
  final $Res Function(_AssetProperty) _then;

/// Create a copy of AssetProperty
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? displayName = null,Object? type = null,Object? allowedValues = freezed,Object? description = freezed,}) {
  return _then(_AssetProperty(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PropertyType,allowedValues: freezed == allowedValues ? _self._allowedValues : allowedValues // ignore: cast_nullable_to_non_nullable
as List<String>?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TriggerTemplate {

 String get name; String get description; MethodologyTriggerDefinition get trigger;
/// Create a copy of TriggerTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerTemplateCopyWith<TriggerTemplate> get copyWith => _$TriggerTemplateCopyWithImpl<TriggerTemplate>(this as TriggerTemplate, _$identity);

  /// Serializes this TriggerTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerTemplate&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.trigger, trigger) || other.trigger == trigger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,trigger);

@override
String toString() {
  return 'TriggerTemplate(name: $name, description: $description, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class $TriggerTemplateCopyWith<$Res>  {
  factory $TriggerTemplateCopyWith(TriggerTemplate value, $Res Function(TriggerTemplate) _then) = _$TriggerTemplateCopyWithImpl;
@useResult
$Res call({
 String name, String description, MethodologyTriggerDefinition trigger
});


$MethodologyTriggerDefinitionCopyWith<$Res> get trigger;

}
/// @nodoc
class _$TriggerTemplateCopyWithImpl<$Res>
    implements $TriggerTemplateCopyWith<$Res> {
  _$TriggerTemplateCopyWithImpl(this._self, this._then);

  final TriggerTemplate _self;
  final $Res Function(TriggerTemplate) _then;

/// Create a copy of TriggerTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = null,Object? trigger = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as MethodologyTriggerDefinition,
  ));
}
/// Create a copy of TriggerTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MethodologyTriggerDefinitionCopyWith<$Res> get trigger {
  
  return $MethodologyTriggerDefinitionCopyWith<$Res>(_self.trigger, (value) {
    return _then(_self.copyWith(trigger: value));
  });
}
}


/// Adds pattern-matching-related methods to [TriggerTemplate].
extension TriggerTemplatePatterns on TriggerTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerTemplate value)  $default,){
final _that = this;
switch (_that) {
case _TriggerTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String description,  MethodologyTriggerDefinition trigger)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerTemplate() when $default != null:
return $default(_that.name,_that.description,_that.trigger);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String description,  MethodologyTriggerDefinition trigger)  $default,) {final _that = this;
switch (_that) {
case _TriggerTemplate():
return $default(_that.name,_that.description,_that.trigger);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String description,  MethodologyTriggerDefinition trigger)?  $default,) {final _that = this;
switch (_that) {
case _TriggerTemplate() when $default != null:
return $default(_that.name,_that.description,_that.trigger);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerTemplate implements TriggerTemplate {
  const _TriggerTemplate({required this.name, required this.description, required this.trigger});
  factory _TriggerTemplate.fromJson(Map<String, dynamic> json) => _$TriggerTemplateFromJson(json);

@override final  String name;
@override final  String description;
@override final  MethodologyTriggerDefinition trigger;

/// Create a copy of TriggerTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerTemplateCopyWith<_TriggerTemplate> get copyWith => __$TriggerTemplateCopyWithImpl<_TriggerTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerTemplate&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.trigger, trigger) || other.trigger == trigger));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,trigger);

@override
String toString() {
  return 'TriggerTemplate(name: $name, description: $description, trigger: $trigger)';
}


}

/// @nodoc
abstract mixin class _$TriggerTemplateCopyWith<$Res> implements $TriggerTemplateCopyWith<$Res> {
  factory _$TriggerTemplateCopyWith(_TriggerTemplate value, $Res Function(_TriggerTemplate) _then) = __$TriggerTemplateCopyWithImpl;
@override @useResult
$Res call({
 String name, String description, MethodologyTriggerDefinition trigger
});


@override $MethodologyTriggerDefinitionCopyWith<$Res> get trigger;

}
/// @nodoc
class __$TriggerTemplateCopyWithImpl<$Res>
    implements _$TriggerTemplateCopyWith<$Res> {
  __$TriggerTemplateCopyWithImpl(this._self, this._then);

  final _TriggerTemplate _self;
  final $Res Function(_TriggerTemplate) _then;

/// Create a copy of TriggerTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = null,Object? trigger = null,}) {
  return _then(_TriggerTemplate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,trigger: null == trigger ? _self.trigger : trigger // ignore: cast_nullable_to_non_nullable
as MethodologyTriggerDefinition,
  ));
}

/// Create a copy of TriggerTemplate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MethodologyTriggerDefinitionCopyWith<$Res> get trigger {
  
  return $MethodologyTriggerDefinitionCopyWith<$Res>(_self.trigger, (value) {
    return _then(_self.copyWith(trigger: value));
  });
}
}


/// @nodoc
mixin _$MethodologyParameter {

 String get name; String get type; String get source;// 'asset_property', 'static_value', 'user_input'
 String? get defaultValue; String? get description;
/// Create a copy of MethodologyParameter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MethodologyParameterCopyWith<MethodologyParameter> get copyWith => _$MethodologyParameterCopyWithImpl<MethodologyParameter>(this as MethodologyParameter, _$identity);

  /// Serializes this MethodologyParameter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MethodologyParameter&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,source,defaultValue,description);

@override
String toString() {
  return 'MethodologyParameter(name: $name, type: $type, source: $source, defaultValue: $defaultValue, description: $description)';
}


}

/// @nodoc
abstract mixin class $MethodologyParameterCopyWith<$Res>  {
  factory $MethodologyParameterCopyWith(MethodologyParameter value, $Res Function(MethodologyParameter) _then) = _$MethodologyParameterCopyWithImpl;
@useResult
$Res call({
 String name, String type, String source, String? defaultValue, String? description
});




}
/// @nodoc
class _$MethodologyParameterCopyWithImpl<$Res>
    implements $MethodologyParameterCopyWith<$Res> {
  _$MethodologyParameterCopyWithImpl(this._self, this._then);

  final MethodologyParameter _self;
  final $Res Function(MethodologyParameter) _then;

/// Create a copy of MethodologyParameter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? type = null,Object? source = null,Object? defaultValue = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MethodologyParameter].
extension MethodologyParameterPatterns on MethodologyParameter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MethodologyParameter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MethodologyParameter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MethodologyParameter value)  $default,){
final _that = this;
switch (_that) {
case _MethodologyParameter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MethodologyParameter value)?  $default,){
final _that = this;
switch (_that) {
case _MethodologyParameter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String type,  String source,  String? defaultValue,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MethodologyParameter() when $default != null:
return $default(_that.name,_that.type,_that.source,_that.defaultValue,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String type,  String source,  String? defaultValue,  String? description)  $default,) {final _that = this;
switch (_that) {
case _MethodologyParameter():
return $default(_that.name,_that.type,_that.source,_that.defaultValue,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String type,  String source,  String? defaultValue,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _MethodologyParameter() when $default != null:
return $default(_that.name,_that.type,_that.source,_that.defaultValue,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MethodologyParameter implements MethodologyParameter {
  const _MethodologyParameter({required this.name, required this.type, required this.source, this.defaultValue, this.description});
  factory _MethodologyParameter.fromJson(Map<String, dynamic> json) => _$MethodologyParameterFromJson(json);

@override final  String name;
@override final  String type;
@override final  String source;
// 'asset_property', 'static_value', 'user_input'
@override final  String? defaultValue;
@override final  String? description;

/// Create a copy of MethodologyParameter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MethodologyParameterCopyWith<_MethodologyParameter> get copyWith => __$MethodologyParameterCopyWithImpl<_MethodologyParameter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MethodologyParameterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MethodologyParameter&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.source, source) || other.source == source)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,type,source,defaultValue,description);

@override
String toString() {
  return 'MethodologyParameter(name: $name, type: $type, source: $source, defaultValue: $defaultValue, description: $description)';
}


}

/// @nodoc
abstract mixin class _$MethodologyParameterCopyWith<$Res> implements $MethodologyParameterCopyWith<$Res> {
  factory _$MethodologyParameterCopyWith(_MethodologyParameter value, $Res Function(_MethodologyParameter) _then) = __$MethodologyParameterCopyWithImpl;
@override @useResult
$Res call({
 String name, String type, String source, String? defaultValue, String? description
});




}
/// @nodoc
class __$MethodologyParameterCopyWithImpl<$Res>
    implements _$MethodologyParameterCopyWith<$Res> {
  __$MethodologyParameterCopyWithImpl(this._self, this._then);

  final _MethodologyParameter _self;
  final $Res Function(_MethodologyParameter) _then;

/// Create a copy of MethodologyParameter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? type = null,Object? source = null,Object? defaultValue = freezed,Object? description = freezed,}) {
  return _then(_MethodologyParameter(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
