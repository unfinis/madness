// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PropertyValue _$PropertyValueFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'string':
      return StringProperty.fromJson(json);
    case 'integer':
      return IntegerProperty.fromJson(json);
    case 'boolean':
      return BooleanProperty.fromJson(json);
    case 'stringList':
      return StringListProperty.fromJson(json);
    case 'map':
      return MapProperty.fromJson(json);
    case 'objectList':
      return ObjectListProperty.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'PropertyValue',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$PropertyValue {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PropertyValueCopyWith<$Res> {
  factory $PropertyValueCopyWith(
          PropertyValue value, $Res Function(PropertyValue) then) =
      _$PropertyValueCopyWithImpl<$Res, PropertyValue>;
}

/// @nodoc
class _$PropertyValueCopyWithImpl<$Res, $Val extends PropertyValue>
    implements $PropertyValueCopyWith<$Res> {
  _$PropertyValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StringPropertyImplCopyWith<$Res> {
  factory _$$StringPropertyImplCopyWith(_$StringPropertyImpl value,
          $Res Function(_$StringPropertyImpl) then) =
      __$$StringPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$StringPropertyImplCopyWithImpl<$Res>
    extends _$PropertyValueCopyWithImpl<$Res, _$StringPropertyImpl>
    implements _$$StringPropertyImplCopyWith<$Res> {
  __$$StringPropertyImplCopyWithImpl(
      _$StringPropertyImpl _value, $Res Function(_$StringPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$StringPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StringPropertyImpl implements StringProperty {
  const _$StringPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'string';

  factory _$StringPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$StringPropertyImplFromJson(json);

  @override
  final String value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PropertyValue.string(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringPropertyImplCopyWith<_$StringPropertyImpl> get copyWith =>
      __$$StringPropertyImplCopyWithImpl<_$StringPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return string(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return string?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StringPropertyImplToJson(
      this,
    );
  }
}

abstract class StringProperty implements PropertyValue {
  const factory StringProperty(final String value) = _$StringPropertyImpl;

  factory StringProperty.fromJson(Map<String, dynamic> json) =
      _$StringPropertyImpl.fromJson;

  String get value;
  @JsonKey(ignore: true)
  _$$StringPropertyImplCopyWith<_$StringPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IntegerPropertyImplCopyWith<$Res> {
  factory _$$IntegerPropertyImplCopyWith(_$IntegerPropertyImpl value,
          $Res Function(_$IntegerPropertyImpl) then) =
      __$$IntegerPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$IntegerPropertyImplCopyWithImpl<$Res>
    extends _$PropertyValueCopyWithImpl<$Res, _$IntegerPropertyImpl>
    implements _$$IntegerPropertyImplCopyWith<$Res> {
  __$$IntegerPropertyImplCopyWithImpl(
      _$IntegerPropertyImpl _value, $Res Function(_$IntegerPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$IntegerPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntegerPropertyImpl implements IntegerProperty {
  const _$IntegerPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'integer';

  factory _$IntegerPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntegerPropertyImplFromJson(json);

  @override
  final int value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PropertyValue.integer(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegerPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegerPropertyImplCopyWith<_$IntegerPropertyImpl> get copyWith =>
      __$$IntegerPropertyImplCopyWithImpl<_$IntegerPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return integer(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return integer?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) {
    return integer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) {
    return integer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IntegerPropertyImplToJson(
      this,
    );
  }
}

abstract class IntegerProperty implements PropertyValue {
  const factory IntegerProperty(final int value) = _$IntegerPropertyImpl;

  factory IntegerProperty.fromJson(Map<String, dynamic> json) =
      _$IntegerPropertyImpl.fromJson;

  int get value;
  @JsonKey(ignore: true)
  _$$IntegerPropertyImplCopyWith<_$IntegerPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BooleanPropertyImplCopyWith<$Res> {
  factory _$$BooleanPropertyImplCopyWith(_$BooleanPropertyImpl value,
          $Res Function(_$BooleanPropertyImpl) then) =
      __$$BooleanPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$BooleanPropertyImplCopyWithImpl<$Res>
    extends _$PropertyValueCopyWithImpl<$Res, _$BooleanPropertyImpl>
    implements _$$BooleanPropertyImplCopyWith<$Res> {
  __$$BooleanPropertyImplCopyWithImpl(
      _$BooleanPropertyImpl _value, $Res Function(_$BooleanPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$BooleanPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BooleanPropertyImpl implements BooleanProperty {
  const _$BooleanPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'boolean';

  factory _$BooleanPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BooleanPropertyImplFromJson(json);

  @override
  final bool value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PropertyValue.boolean(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BooleanPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BooleanPropertyImplCopyWith<_$BooleanPropertyImpl> get copyWith =>
      __$$BooleanPropertyImplCopyWithImpl<_$BooleanPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return boolean(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return boolean?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) {
    return boolean(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) {
    return boolean?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BooleanPropertyImplToJson(
      this,
    );
  }
}

abstract class BooleanProperty implements PropertyValue {
  const factory BooleanProperty(final bool value) = _$BooleanPropertyImpl;

  factory BooleanProperty.fromJson(Map<String, dynamic> json) =
      _$BooleanPropertyImpl.fromJson;

  bool get value;
  @JsonKey(ignore: true)
  _$$BooleanPropertyImplCopyWith<_$BooleanPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StringListPropertyImplCopyWith<$Res> {
  factory _$$StringListPropertyImplCopyWith(_$StringListPropertyImpl value,
          $Res Function(_$StringListPropertyImpl) then) =
      __$$StringListPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> values});
}

/// @nodoc
class __$$StringListPropertyImplCopyWithImpl<$Res>
    extends _$PropertyValueCopyWithImpl<$Res, _$StringListPropertyImpl>
    implements _$$StringListPropertyImplCopyWith<$Res> {
  __$$StringListPropertyImplCopyWithImpl(_$StringListPropertyImpl _value,
      $Res Function(_$StringListPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_$StringListPropertyImpl(
      null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StringListPropertyImpl implements StringListProperty {
  const _$StringListPropertyImpl(final List<String> values,
      {final String? $type})
      : _values = values,
        $type = $type ?? 'stringList';

  factory _$StringListPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$StringListPropertyImplFromJson(json);

  final List<String> _values;
  @override
  List<String> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PropertyValue.stringList(values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringListPropertyImpl &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringListPropertyImplCopyWith<_$StringListPropertyImpl> get copyWith =>
      __$$StringListPropertyImplCopyWithImpl<_$StringListPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return stringList(values);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return stringList?.call(values);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (stringList != null) {
      return stringList(values);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) {
    return stringList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) {
    return stringList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (stringList != null) {
      return stringList(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StringListPropertyImplToJson(
      this,
    );
  }
}

abstract class StringListProperty implements PropertyValue {
  const factory StringListProperty(final List<String> values) =
      _$StringListPropertyImpl;

  factory StringListProperty.fromJson(Map<String, dynamic> json) =
      _$StringListPropertyImpl.fromJson;

  List<String> get values;
  @JsonKey(ignore: true)
  _$$StringListPropertyImplCopyWith<_$StringListPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MapPropertyImplCopyWith<$Res> {
  factory _$$MapPropertyImplCopyWith(
          _$MapPropertyImpl value, $Res Function(_$MapPropertyImpl) then) =
      __$$MapPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> value});
}

/// @nodoc
class __$$MapPropertyImplCopyWithImpl<$Res>
    extends _$PropertyValueCopyWithImpl<$Res, _$MapPropertyImpl>
    implements _$$MapPropertyImplCopyWith<$Res> {
  __$$MapPropertyImplCopyWithImpl(
      _$MapPropertyImpl _value, $Res Function(_$MapPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$MapPropertyImpl(
      null == value
          ? _value._value
          : value // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MapPropertyImpl implements MapProperty {
  const _$MapPropertyImpl(final Map<String, dynamic> value,
      {final String? $type})
      : _value = value,
        $type = $type ?? 'map';

  factory _$MapPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapPropertyImplFromJson(json);

  final Map<String, dynamic> _value;
  @override
  Map<String, dynamic> get value {
    if (_value is EqualUnmodifiableMapView) return _value;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_value);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PropertyValue.map(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapPropertyImpl &&
            const DeepCollectionEquality().equals(other._value, _value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapPropertyImplCopyWith<_$MapPropertyImpl> get copyWith =>
      __$$MapPropertyImplCopyWithImpl<_$MapPropertyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return map(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return map?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) {
    return map(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) {
    return map?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MapPropertyImplToJson(
      this,
    );
  }
}

abstract class MapProperty implements PropertyValue {
  const factory MapProperty(final Map<String, dynamic> value) =
      _$MapPropertyImpl;

  factory MapProperty.fromJson(Map<String, dynamic> json) =
      _$MapPropertyImpl.fromJson;

  Map<String, dynamic> get value;
  @JsonKey(ignore: true)
  _$$MapPropertyImplCopyWith<_$MapPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ObjectListPropertyImplCopyWith<$Res> {
  factory _$$ObjectListPropertyImplCopyWith(_$ObjectListPropertyImpl value,
          $Res Function(_$ObjectListPropertyImpl) then) =
      __$$ObjectListPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Map<String, dynamic>> objects});
}

/// @nodoc
class __$$ObjectListPropertyImplCopyWithImpl<$Res>
    extends _$PropertyValueCopyWithImpl<$Res, _$ObjectListPropertyImpl>
    implements _$$ObjectListPropertyImplCopyWith<$Res> {
  __$$ObjectListPropertyImplCopyWithImpl(_$ObjectListPropertyImpl _value,
      $Res Function(_$ObjectListPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objects = null,
  }) {
    return _then(_$ObjectListPropertyImpl(
      null == objects
          ? _value._objects
          : objects // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ObjectListPropertyImpl implements ObjectListProperty {
  const _$ObjectListPropertyImpl(final List<Map<String, dynamic>> objects,
      {final String? $type})
      : _objects = objects,
        $type = $type ?? 'objectList';

  factory _$ObjectListPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ObjectListPropertyImplFromJson(json);

  final List<Map<String, dynamic>> _objects;
  @override
  List<Map<String, dynamic>> get objects {
    if (_objects is EqualUnmodifiableListView) return _objects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objects);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'PropertyValue.objectList(objects: $objects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ObjectListPropertyImpl &&
            const DeepCollectionEquality().equals(other._objects, _objects));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_objects));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ObjectListPropertyImplCopyWith<_$ObjectListPropertyImpl> get copyWith =>
      __$$ObjectListPropertyImplCopyWithImpl<_$ObjectListPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return objectList(objects);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return objectList?.call(objects);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (objectList != null) {
      return objectList(objects);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringProperty value) string,
    required TResult Function(IntegerProperty value) integer,
    required TResult Function(BooleanProperty value) boolean,
    required TResult Function(StringListProperty value) stringList,
    required TResult Function(MapProperty value) map,
    required TResult Function(ObjectListProperty value) objectList,
  }) {
    return objectList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringProperty value)? string,
    TResult? Function(IntegerProperty value)? integer,
    TResult? Function(BooleanProperty value)? boolean,
    TResult? Function(StringListProperty value)? stringList,
    TResult? Function(MapProperty value)? map,
    TResult? Function(ObjectListProperty value)? objectList,
  }) {
    return objectList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringProperty value)? string,
    TResult Function(IntegerProperty value)? integer,
    TResult Function(BooleanProperty value)? boolean,
    TResult Function(StringListProperty value)? stringList,
    TResult Function(MapProperty value)? map,
    TResult Function(ObjectListProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (objectList != null) {
      return objectList(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ObjectListPropertyImplToJson(
      this,
    );
  }
}

abstract class ObjectListProperty implements PropertyValue {
  const factory ObjectListProperty(final List<Map<String, dynamic>> objects) =
      _$ObjectListPropertyImpl;

  factory ObjectListProperty.fromJson(Map<String, dynamic> json) =
      _$ObjectListPropertyImpl.fromJson;

  List<Map<String, dynamic>> get objects;
  @JsonKey(ignore: true)
  _$$ObjectListPropertyImplCopyWith<_$ObjectListPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
mixin _$Asset {
  String get id => throw _privateConstructorUsedError;
  AssetType get type => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Rich property system
  Map<String, PropertyValue> get properties =>
      throw _privateConstructorUsedError; // Trigger tracking
  List<String> get completedTriggers =>
      throw _privateConstructorUsedError; // Deduplication keys
  Map<String, TriggerResult> get triggerResults =>
      throw _privateConstructorUsedError; // Relationships
  List<String> get parentAssetIds => throw _privateConstructorUsedError;
  List<String> get childAssetIds =>
      throw _privateConstructorUsedError; // Metadata
  DateTime get discoveredAt => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  String? get discoveryMethod => throw _privateConstructorUsedError;
  double? get confidence =>
      throw _privateConstructorUsedError; // Tags for filtering and grouping
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call(
      {String id,
      AssetType type,
      String projectId,
      String name,
      String? description,
      Map<String, PropertyValue> properties,
      List<String> completedTriggers,
      Map<String, TriggerResult> triggerResults,
      List<String> parentAssetIds,
      List<String> childAssetIds,
      DateTime discoveredAt,
      DateTime? lastUpdated,
      String? discoveryMethod,
      double? confidence,
      List<String> tags});
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? projectId = null,
    Object? name = null,
    Object? description = freezed,
    Object? properties = null,
    Object? completedTriggers = null,
    Object? triggerResults = null,
    Object? parentAssetIds = null,
    Object? childAssetIds = null,
    Object? discoveredAt = null,
    Object? lastUpdated = freezed,
    Object? discoveryMethod = freezed,
    Object? confidence = freezed,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssetType,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, PropertyValue>,
      completedTriggers: null == completedTriggers
          ? _value.completedTriggers
          : completedTriggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      triggerResults: null == triggerResults
          ? _value.triggerResults
          : triggerResults // ignore: cast_nullable_to_non_nullable
              as Map<String, TriggerResult>,
      parentAssetIds: null == parentAssetIds
          ? _value.parentAssetIds
          : parentAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      childAssetIds: null == childAssetIds
          ? _value.childAssetIds
          : childAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discoveredAt: null == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discoveryMethod: freezed == discoveryMethod
          ? _value.discoveryMethod
          : discoveryMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$AssetImplCopyWith(
          _$AssetImpl value, $Res Function(_$AssetImpl) then) =
      __$$AssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AssetType type,
      String projectId,
      String name,
      String? description,
      Map<String, PropertyValue> properties,
      List<String> completedTriggers,
      Map<String, TriggerResult> triggerResults,
      List<String> parentAssetIds,
      List<String> childAssetIds,
      DateTime discoveredAt,
      DateTime? lastUpdated,
      String? discoveryMethod,
      double? confidence,
      List<String> tags});
}

/// @nodoc
class __$$AssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$AssetImpl>
    implements _$$AssetImplCopyWith<$Res> {
  __$$AssetImplCopyWithImpl(
      _$AssetImpl _value, $Res Function(_$AssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? projectId = null,
    Object? name = null,
    Object? description = freezed,
    Object? properties = null,
    Object? completedTriggers = null,
    Object? triggerResults = null,
    Object? parentAssetIds = null,
    Object? childAssetIds = null,
    Object? discoveredAt = null,
    Object? lastUpdated = freezed,
    Object? discoveryMethod = freezed,
    Object? confidence = freezed,
    Object? tags = null,
  }) {
    return _then(_$AssetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssetType,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, PropertyValue>,
      completedTriggers: null == completedTriggers
          ? _value._completedTriggers
          : completedTriggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      triggerResults: null == triggerResults
          ? _value._triggerResults
          : triggerResults // ignore: cast_nullable_to_non_nullable
              as Map<String, TriggerResult>,
      parentAssetIds: null == parentAssetIds
          ? _value._parentAssetIds
          : parentAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      childAssetIds: null == childAssetIds
          ? _value._childAssetIds
          : childAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      discoveredAt: null == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discoveryMethod: freezed == discoveryMethod
          ? _value.discoveryMethod
          : discoveryMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetImpl implements _Asset {
  const _$AssetImpl(
      {required this.id,
      required this.type,
      required this.projectId,
      required this.name,
      this.description,
      required final Map<String, PropertyValue> properties,
      required final List<String> completedTriggers,
      required final Map<String, TriggerResult> triggerResults,
      required final List<String> parentAssetIds,
      required final List<String> childAssetIds,
      required this.discoveredAt,
      this.lastUpdated,
      this.discoveryMethod,
      this.confidence,
      required final List<String> tags})
      : _properties = properties,
        _completedTriggers = completedTriggers,
        _triggerResults = triggerResults,
        _parentAssetIds = parentAssetIds,
        _childAssetIds = childAssetIds,
        _tags = tags;

  factory _$AssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetImplFromJson(json);

  @override
  final String id;
  @override
  final AssetType type;
  @override
  final String projectId;
  @override
  final String name;
  @override
  final String? description;
// Rich property system
  final Map<String, PropertyValue> _properties;
// Rich property system
  @override
  Map<String, PropertyValue> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

// Trigger tracking
  final List<String> _completedTriggers;
// Trigger tracking
  @override
  List<String> get completedTriggers {
    if (_completedTriggers is EqualUnmodifiableListView)
      return _completedTriggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedTriggers);
  }

// Deduplication keys
  final Map<String, TriggerResult> _triggerResults;
// Deduplication keys
  @override
  Map<String, TriggerResult> get triggerResults {
    if (_triggerResults is EqualUnmodifiableMapView) return _triggerResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_triggerResults);
  }

// Relationships
  final List<String> _parentAssetIds;
// Relationships
  @override
  List<String> get parentAssetIds {
    if (_parentAssetIds is EqualUnmodifiableListView) return _parentAssetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parentAssetIds);
  }

  final List<String> _childAssetIds;
  @override
  List<String> get childAssetIds {
    if (_childAssetIds is EqualUnmodifiableListView) return _childAssetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childAssetIds);
  }

// Metadata
  @override
  final DateTime discoveredAt;
  @override
  final DateTime? lastUpdated;
  @override
  final String? discoveryMethod;
  @override
  final double? confidence;
// Tags for filtering and grouping
  final List<String> _tags;
// Tags for filtering and grouping
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'Asset(id: $id, type: $type, projectId: $projectId, name: $name, description: $description, properties: $properties, completedTriggers: $completedTriggers, triggerResults: $triggerResults, parentAssetIds: $parentAssetIds, childAssetIds: $childAssetIds, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated, discoveryMethod: $discoveryMethod, confidence: $confidence, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            const DeepCollectionEquality()
                .equals(other._completedTriggers, _completedTriggers) &&
            const DeepCollectionEquality()
                .equals(other._triggerResults, _triggerResults) &&
            const DeepCollectionEquality()
                .equals(other._parentAssetIds, _parentAssetIds) &&
            const DeepCollectionEquality()
                .equals(other._childAssetIds, _childAssetIds) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.discoveryMethod, discoveryMethod) ||
                other.discoveryMethod == discoveryMethod) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      projectId,
      name,
      description,
      const DeepCollectionEquality().hash(_properties),
      const DeepCollectionEquality().hash(_completedTriggers),
      const DeepCollectionEquality().hash(_triggerResults),
      const DeepCollectionEquality().hash(_parentAssetIds),
      const DeepCollectionEquality().hash(_childAssetIds),
      discoveredAt,
      lastUpdated,
      discoveryMethod,
      confidence,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      __$$AssetImplCopyWithImpl<_$AssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetImplToJson(
      this,
    );
  }
}

abstract class _Asset implements Asset {
  const factory _Asset(
      {required final String id,
      required final AssetType type,
      required final String projectId,
      required final String name,
      final String? description,
      required final Map<String, PropertyValue> properties,
      required final List<String> completedTriggers,
      required final Map<String, TriggerResult> triggerResults,
      required final List<String> parentAssetIds,
      required final List<String> childAssetIds,
      required final DateTime discoveredAt,
      final DateTime? lastUpdated,
      final String? discoveryMethod,
      final double? confidence,
      required final List<String> tags}) = _$AssetImpl;

  factory _Asset.fromJson(Map<String, dynamic> json) = _$AssetImpl.fromJson;

  @override
  String get id;
  @override
  AssetType get type;
  @override
  String get projectId;
  @override
  String get name;
  @override
  String? get description;
  @override // Rich property system
  Map<String, PropertyValue> get properties;
  @override // Trigger tracking
  List<String> get completedTriggers;
  @override // Deduplication keys
  Map<String, TriggerResult> get triggerResults;
  @override // Relationships
  List<String> get parentAssetIds;
  @override
  List<String> get childAssetIds;
  @override // Metadata
  DateTime get discoveredAt;
  @override
  DateTime? get lastUpdated;
  @override
  String? get discoveryMethod;
  @override
  double? get confidence;
  @override // Tags for filtering and grouping
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggerResult _$TriggerResultFromJson(Map<String, dynamic> json) {
  return _TriggerResult.fromJson(json);
}

/// @nodoc
mixin _$TriggerResult {
  String get methodologyId => throw _privateConstructorUsedError;
  DateTime get executedAt => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get output => throw _privateConstructorUsedError;
  Map<String, PropertyValue>? get propertyUpdates =>
      throw _privateConstructorUsedError;
  List<Asset>? get discoveredAssets => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerResultCopyWith<TriggerResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerResultCopyWith<$Res> {
  factory $TriggerResultCopyWith(
          TriggerResult value, $Res Function(TriggerResult) then) =
      _$TriggerResultCopyWithImpl<$Res, TriggerResult>;
  @useResult
  $Res call(
      {String methodologyId,
      DateTime executedAt,
      bool success,
      String? output,
      Map<String, PropertyValue>? propertyUpdates,
      List<Asset>? discoveredAssets,
      String? error});
}

/// @nodoc
class _$TriggerResultCopyWithImpl<$Res, $Val extends TriggerResult>
    implements $TriggerResultCopyWith<$Res> {
  _$TriggerResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? methodologyId = null,
    Object? executedAt = null,
    Object? success = null,
    Object? output = freezed,
    Object? propertyUpdates = freezed,
    Object? discoveredAssets = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyUpdates: freezed == propertyUpdates
          ? _value.propertyUpdates
          : propertyUpdates // ignore: cast_nullable_to_non_nullable
              as Map<String, PropertyValue>?,
      discoveredAssets: freezed == discoveredAssets
          ? _value.discoveredAssets
          : discoveredAssets // ignore: cast_nullable_to_non_nullable
              as List<Asset>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerResultImplCopyWith<$Res>
    implements $TriggerResultCopyWith<$Res> {
  factory _$$TriggerResultImplCopyWith(
          _$TriggerResultImpl value, $Res Function(_$TriggerResultImpl) then) =
      __$$TriggerResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String methodologyId,
      DateTime executedAt,
      bool success,
      String? output,
      Map<String, PropertyValue>? propertyUpdates,
      List<Asset>? discoveredAssets,
      String? error});
}

/// @nodoc
class __$$TriggerResultImplCopyWithImpl<$Res>
    extends _$TriggerResultCopyWithImpl<$Res, _$TriggerResultImpl>
    implements _$$TriggerResultImplCopyWith<$Res> {
  __$$TriggerResultImplCopyWithImpl(
      _$TriggerResultImpl _value, $Res Function(_$TriggerResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? methodologyId = null,
    Object? executedAt = null,
    Object? success = null,
    Object? output = freezed,
    Object? propertyUpdates = freezed,
    Object? discoveredAssets = freezed,
    Object? error = freezed,
  }) {
    return _then(_$TriggerResultImpl(
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      propertyUpdates: freezed == propertyUpdates
          ? _value._propertyUpdates
          : propertyUpdates // ignore: cast_nullable_to_non_nullable
              as Map<String, PropertyValue>?,
      discoveredAssets: freezed == discoveredAssets
          ? _value._discoveredAssets
          : discoveredAssets // ignore: cast_nullable_to_non_nullable
              as List<Asset>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerResultImpl implements _TriggerResult {
  const _$TriggerResultImpl(
      {required this.methodologyId,
      required this.executedAt,
      required this.success,
      this.output,
      final Map<String, PropertyValue>? propertyUpdates,
      final List<Asset>? discoveredAssets,
      this.error})
      : _propertyUpdates = propertyUpdates,
        _discoveredAssets = discoveredAssets;

  factory _$TriggerResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerResultImplFromJson(json);

  @override
  final String methodologyId;
  @override
  final DateTime executedAt;
  @override
  final bool success;
  @override
  final String? output;
  final Map<String, PropertyValue>? _propertyUpdates;
  @override
  Map<String, PropertyValue>? get propertyUpdates {
    final value = _propertyUpdates;
    if (value == null) return null;
    if (_propertyUpdates is EqualUnmodifiableMapView) return _propertyUpdates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Asset>? _discoveredAssets;
  @override
  List<Asset>? get discoveredAssets {
    final value = _discoveredAssets;
    if (value == null) return null;
    if (_discoveredAssets is EqualUnmodifiableListView)
      return _discoveredAssets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? error;

  @override
  String toString() {
    return 'TriggerResult(methodologyId: $methodologyId, executedAt: $executedAt, success: $success, output: $output, propertyUpdates: $propertyUpdates, discoveredAssets: $discoveredAssets, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerResultImpl &&
            (identical(other.methodologyId, methodologyId) ||
                other.methodologyId == methodologyId) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.output, output) || other.output == output) &&
            const DeepCollectionEquality()
                .equals(other._propertyUpdates, _propertyUpdates) &&
            const DeepCollectionEquality()
                .equals(other._discoveredAssets, _discoveredAssets) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      methodologyId,
      executedAt,
      success,
      output,
      const DeepCollectionEquality().hash(_propertyUpdates),
      const DeepCollectionEquality().hash(_discoveredAssets),
      error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerResultImplCopyWith<_$TriggerResultImpl> get copyWith =>
      __$$TriggerResultImplCopyWithImpl<_$TriggerResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerResultImplToJson(
      this,
    );
  }
}

abstract class _TriggerResult implements TriggerResult {
  const factory _TriggerResult(
      {required final String methodologyId,
      required final DateTime executedAt,
      required final bool success,
      final String? output,
      final Map<String, PropertyValue>? propertyUpdates,
      final List<Asset>? discoveredAssets,
      final String? error}) = _$TriggerResultImpl;

  factory _TriggerResult.fromJson(Map<String, dynamic> json) =
      _$TriggerResultImpl.fromJson;

  @override
  String get methodologyId;
  @override
  DateTime get executedAt;
  @override
  bool get success;
  @override
  String? get output;
  @override
  Map<String, PropertyValue>? get propertyUpdates;
  @override
  List<Asset>? get discoveredAssets;
  @override
  String? get error;
  @override
  @JsonKey(ignore: true)
  _$$TriggerResultImplCopyWith<_$TriggerResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
