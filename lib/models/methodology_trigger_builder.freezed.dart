// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'methodology_trigger_builder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TriggerCondition _$TriggerConditionFromJson(Map<String, dynamic> json) {
  return _TriggerCondition.fromJson(json);
}

/// @nodoc
mixin _$TriggerCondition {
  String get id => throw _privateConstructorUsedError;
  AssetType get assetType => throw _privateConstructorUsedError;
  String get property => throw _privateConstructorUsedError;
  TriggerOperator get operator => throw _privateConstructorUsedError;
  TriggerValue get value => throw _privateConstructorUsedError;
  String? get logicalOperator => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerConditionCopyWith<TriggerCondition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerConditionCopyWith<$Res> {
  factory $TriggerConditionCopyWith(
          TriggerCondition value, $Res Function(TriggerCondition) then) =
      _$TriggerConditionCopyWithImpl<$Res, TriggerCondition>;
  @useResult
  $Res call(
      {String id,
      AssetType assetType,
      String property,
      TriggerOperator operator,
      TriggerValue value,
      String? logicalOperator});

  $TriggerValueCopyWith<$Res> get value;
}

/// @nodoc
class _$TriggerConditionCopyWithImpl<$Res, $Val extends TriggerCondition>
    implements $TriggerConditionCopyWith<$Res> {
  _$TriggerConditionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetType = null,
    Object? property = null,
    Object? operator = null,
    Object? value = null,
    Object? logicalOperator = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _value.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as AssetType,
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as TriggerOperator,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as TriggerValue,
      logicalOperator: freezed == logicalOperator
          ? _value.logicalOperator
          : logicalOperator // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TriggerValueCopyWith<$Res> get value {
    return $TriggerValueCopyWith<$Res>(_value.value, (value) {
      return _then(_value.copyWith(value: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TriggerConditionImplCopyWith<$Res>
    implements $TriggerConditionCopyWith<$Res> {
  factory _$$TriggerConditionImplCopyWith(_$TriggerConditionImpl value,
          $Res Function(_$TriggerConditionImpl) then) =
      __$$TriggerConditionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AssetType assetType,
      String property,
      TriggerOperator operator,
      TriggerValue value,
      String? logicalOperator});

  @override
  $TriggerValueCopyWith<$Res> get value;
}

/// @nodoc
class __$$TriggerConditionImplCopyWithImpl<$Res>
    extends _$TriggerConditionCopyWithImpl<$Res, _$TriggerConditionImpl>
    implements _$$TriggerConditionImplCopyWith<$Res> {
  __$$TriggerConditionImplCopyWithImpl(_$TriggerConditionImpl _value,
      $Res Function(_$TriggerConditionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assetType = null,
    Object? property = null,
    Object? operator = null,
    Object? value = null,
    Object? logicalOperator = freezed,
  }) {
    return _then(_$TriggerConditionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _value.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as AssetType,
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as TriggerOperator,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as TriggerValue,
      logicalOperator: freezed == logicalOperator
          ? _value.logicalOperator
          : logicalOperator // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerConditionImpl implements _TriggerCondition {
  const _$TriggerConditionImpl(
      {required this.id,
      required this.assetType,
      required this.property,
      required this.operator,
      required this.value,
      this.logicalOperator});

  factory _$TriggerConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerConditionImplFromJson(json);

  @override
  final String id;
  @override
  final AssetType assetType;
  @override
  final String property;
  @override
  final TriggerOperator operator;
  @override
  final TriggerValue value;
  @override
  final String? logicalOperator;

  @override
  String toString() {
    return 'TriggerCondition(id: $id, assetType: $assetType, property: $property, operator: $operator, value: $value, logicalOperator: $logicalOperator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerConditionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            (identical(other.property, property) ||
                other.property == property) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.logicalOperator, logicalOperator) ||
                other.logicalOperator == logicalOperator));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, assetType, property, operator, value, logicalOperator);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerConditionImplCopyWith<_$TriggerConditionImpl> get copyWith =>
      __$$TriggerConditionImplCopyWithImpl<_$TriggerConditionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerConditionImplToJson(
      this,
    );
  }
}

abstract class _TriggerCondition implements TriggerCondition {
  const factory _TriggerCondition(
      {required final String id,
      required final AssetType assetType,
      required final String property,
      required final TriggerOperator operator,
      required final TriggerValue value,
      final String? logicalOperator}) = _$TriggerConditionImpl;

  factory _TriggerCondition.fromJson(Map<String, dynamic> json) =
      _$TriggerConditionImpl.fromJson;

  @override
  String get id;
  @override
  AssetType get assetType;
  @override
  String get property;
  @override
  TriggerOperator get operator;
  @override
  TriggerValue get value;
  @override
  String? get logicalOperator;
  @override
  @JsonKey(ignore: true)
  _$$TriggerConditionImplCopyWith<_$TriggerConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggerValue _$TriggerValueFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'string':
      return StringTriggerValue.fromJson(json);
    case 'boolean':
      return BooleanTriggerValue.fromJson(json);
    case 'number':
      return NumberTriggerValue.fromJson(json);
    case 'list':
      return ListTriggerValue.fromJson(json);
    case 'isNull':
      return NullTriggerValue.fromJson(json);
    case 'notNull':
      return NotNullTriggerValue.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'TriggerValue',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$TriggerValue {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerValueCopyWith<$Res> {
  factory $TriggerValueCopyWith(
          TriggerValue value, $Res Function(TriggerValue) then) =
      _$TriggerValueCopyWithImpl<$Res, TriggerValue>;
}

/// @nodoc
class _$TriggerValueCopyWithImpl<$Res, $Val extends TriggerValue>
    implements $TriggerValueCopyWith<$Res> {
  _$TriggerValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StringTriggerValueImplCopyWith<$Res> {
  factory _$$StringTriggerValueImplCopyWith(_$StringTriggerValueImpl value,
          $Res Function(_$StringTriggerValueImpl) then) =
      __$$StringTriggerValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$StringTriggerValueImplCopyWithImpl<$Res>
    extends _$TriggerValueCopyWithImpl<$Res, _$StringTriggerValueImpl>
    implements _$$StringTriggerValueImplCopyWith<$Res> {
  __$$StringTriggerValueImplCopyWithImpl(_$StringTriggerValueImpl _value,
      $Res Function(_$StringTriggerValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$StringTriggerValueImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StringTriggerValueImpl implements StringTriggerValue {
  const _$StringTriggerValueImpl(this.value, {final String? $type})
      : $type = $type ?? 'string';

  factory _$StringTriggerValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$StringTriggerValueImplFromJson(json);

  @override
  final String value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TriggerValue.string(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringTriggerValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringTriggerValueImplCopyWith<_$StringTriggerValueImpl> get copyWith =>
      __$$StringTriggerValueImplCopyWithImpl<_$StringTriggerValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) {
    return string(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) {
    return string?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
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
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StringTriggerValueImplToJson(
      this,
    );
  }
}

abstract class StringTriggerValue implements TriggerValue {
  const factory StringTriggerValue(final String value) =
      _$StringTriggerValueImpl;

  factory StringTriggerValue.fromJson(Map<String, dynamic> json) =
      _$StringTriggerValueImpl.fromJson;

  String get value;
  @JsonKey(ignore: true)
  _$$StringTriggerValueImplCopyWith<_$StringTriggerValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BooleanTriggerValueImplCopyWith<$Res> {
  factory _$$BooleanTriggerValueImplCopyWith(_$BooleanTriggerValueImpl value,
          $Res Function(_$BooleanTriggerValueImpl) then) =
      __$$BooleanTriggerValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$BooleanTriggerValueImplCopyWithImpl<$Res>
    extends _$TriggerValueCopyWithImpl<$Res, _$BooleanTriggerValueImpl>
    implements _$$BooleanTriggerValueImplCopyWith<$Res> {
  __$$BooleanTriggerValueImplCopyWithImpl(_$BooleanTriggerValueImpl _value,
      $Res Function(_$BooleanTriggerValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$BooleanTriggerValueImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BooleanTriggerValueImpl implements BooleanTriggerValue {
  const _$BooleanTriggerValueImpl(this.value, {final String? $type})
      : $type = $type ?? 'boolean';

  factory _$BooleanTriggerValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$BooleanTriggerValueImplFromJson(json);

  @override
  final bool value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TriggerValue.boolean(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BooleanTriggerValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BooleanTriggerValueImplCopyWith<_$BooleanTriggerValueImpl> get copyWith =>
      __$$BooleanTriggerValueImplCopyWithImpl<_$BooleanTriggerValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) {
    return boolean(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) {
    return boolean?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
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
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) {
    return boolean(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) {
    return boolean?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BooleanTriggerValueImplToJson(
      this,
    );
  }
}

abstract class BooleanTriggerValue implements TriggerValue {
  const factory BooleanTriggerValue(final bool value) =
      _$BooleanTriggerValueImpl;

  factory BooleanTriggerValue.fromJson(Map<String, dynamic> json) =
      _$BooleanTriggerValueImpl.fromJson;

  bool get value;
  @JsonKey(ignore: true)
  _$$BooleanTriggerValueImplCopyWith<_$BooleanTriggerValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NumberTriggerValueImplCopyWith<$Res> {
  factory _$$NumberTriggerValueImplCopyWith(_$NumberTriggerValueImpl value,
          $Res Function(_$NumberTriggerValueImpl) then) =
      __$$NumberTriggerValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$$NumberTriggerValueImplCopyWithImpl<$Res>
    extends _$TriggerValueCopyWithImpl<$Res, _$NumberTriggerValueImpl>
    implements _$$NumberTriggerValueImplCopyWith<$Res> {
  __$$NumberTriggerValueImplCopyWithImpl(_$NumberTriggerValueImpl _value,
      $Res Function(_$NumberTriggerValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$NumberTriggerValueImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NumberTriggerValueImpl implements NumberTriggerValue {
  const _$NumberTriggerValueImpl(this.value, {final String? $type})
      : $type = $type ?? 'number';

  factory _$NumberTriggerValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$NumberTriggerValueImplFromJson(json);

  @override
  final double value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TriggerValue.number(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NumberTriggerValueImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NumberTriggerValueImplCopyWith<_$NumberTriggerValueImpl> get copyWith =>
      __$$NumberTriggerValueImplCopyWithImpl<_$NumberTriggerValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) {
    return number(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) {
    return number?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
    required TResult orElse(),
  }) {
    if (number != null) {
      return number(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) {
    return number(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) {
    return number?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) {
    if (number != null) {
      return number(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NumberTriggerValueImplToJson(
      this,
    );
  }
}

abstract class NumberTriggerValue implements TriggerValue {
  const factory NumberTriggerValue(final double value) =
      _$NumberTriggerValueImpl;

  factory NumberTriggerValue.fromJson(Map<String, dynamic> json) =
      _$NumberTriggerValueImpl.fromJson;

  double get value;
  @JsonKey(ignore: true)
  _$$NumberTriggerValueImplCopyWith<_$NumberTriggerValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ListTriggerValueImplCopyWith<$Res> {
  factory _$$ListTriggerValueImplCopyWith(_$ListTriggerValueImpl value,
          $Res Function(_$ListTriggerValueImpl) then) =
      __$$ListTriggerValueImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> values});
}

/// @nodoc
class __$$ListTriggerValueImplCopyWithImpl<$Res>
    extends _$TriggerValueCopyWithImpl<$Res, _$ListTriggerValueImpl>
    implements _$$ListTriggerValueImplCopyWith<$Res> {
  __$$ListTriggerValueImplCopyWithImpl(_$ListTriggerValueImpl _value,
      $Res Function(_$ListTriggerValueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_$ListTriggerValueImpl(
      null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListTriggerValueImpl implements ListTriggerValue {
  const _$ListTriggerValueImpl(final List<String> values, {final String? $type})
      : _values = values,
        $type = $type ?? 'list';

  factory _$ListTriggerValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListTriggerValueImplFromJson(json);

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
    return 'TriggerValue.list(values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListTriggerValueImpl &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListTriggerValueImplCopyWith<_$ListTriggerValueImpl> get copyWith =>
      __$$ListTriggerValueImplCopyWithImpl<_$ListTriggerValueImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) {
    return list(values);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) {
    return list?.call(values);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(values);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) {
    return list(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) {
    return list?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) {
    if (list != null) {
      return list(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ListTriggerValueImplToJson(
      this,
    );
  }
}

abstract class ListTriggerValue implements TriggerValue {
  const factory ListTriggerValue(final List<String> values) =
      _$ListTriggerValueImpl;

  factory ListTriggerValue.fromJson(Map<String, dynamic> json) =
      _$ListTriggerValueImpl.fromJson;

  List<String> get values;
  @JsonKey(ignore: true)
  _$$ListTriggerValueImplCopyWith<_$ListTriggerValueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NullTriggerValueImplCopyWith<$Res> {
  factory _$$NullTriggerValueImplCopyWith(_$NullTriggerValueImpl value,
          $Res Function(_$NullTriggerValueImpl) then) =
      __$$NullTriggerValueImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NullTriggerValueImplCopyWithImpl<$Res>
    extends _$TriggerValueCopyWithImpl<$Res, _$NullTriggerValueImpl>
    implements _$$NullTriggerValueImplCopyWith<$Res> {
  __$$NullTriggerValueImplCopyWithImpl(_$NullTriggerValueImpl _value,
      $Res Function(_$NullTriggerValueImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$NullTriggerValueImpl implements NullTriggerValue {
  const _$NullTriggerValueImpl({final String? $type})
      : $type = $type ?? 'isNull';

  factory _$NullTriggerValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$NullTriggerValueImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TriggerValue.isNull()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NullTriggerValueImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) {
    return isNull();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) {
    return isNull?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
    required TResult orElse(),
  }) {
    if (isNull != null) {
      return isNull();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) {
    return isNull(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) {
    return isNull?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) {
    if (isNull != null) {
      return isNull(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NullTriggerValueImplToJson(
      this,
    );
  }
}

abstract class NullTriggerValue implements TriggerValue {
  const factory NullTriggerValue() = _$NullTriggerValueImpl;

  factory NullTriggerValue.fromJson(Map<String, dynamic> json) =
      _$NullTriggerValueImpl.fromJson;
}

/// @nodoc
abstract class _$$NotNullTriggerValueImplCopyWith<$Res> {
  factory _$$NotNullTriggerValueImplCopyWith(_$NotNullTriggerValueImpl value,
          $Res Function(_$NotNullTriggerValueImpl) then) =
      __$$NotNullTriggerValueImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotNullTriggerValueImplCopyWithImpl<$Res>
    extends _$TriggerValueCopyWithImpl<$Res, _$NotNullTriggerValueImpl>
    implements _$$NotNullTriggerValueImplCopyWith<$Res> {
  __$$NotNullTriggerValueImplCopyWithImpl(_$NotNullTriggerValueImpl _value,
      $Res Function(_$NotNullTriggerValueImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$NotNullTriggerValueImpl implements NotNullTriggerValue {
  const _$NotNullTriggerValueImpl({final String? $type})
      : $type = $type ?? 'notNull';

  factory _$NotNullTriggerValueImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotNullTriggerValueImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'TriggerValue.notNull()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotNullTriggerValueImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(bool value) boolean,
    required TResult Function(double value) number,
    required TResult Function(List<String> values) list,
    required TResult Function() isNull,
    required TResult Function() notNull,
  }) {
    return notNull();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(bool value)? boolean,
    TResult? Function(double value)? number,
    TResult? Function(List<String> values)? list,
    TResult? Function()? isNull,
    TResult? Function()? notNull,
  }) {
    return notNull?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(bool value)? boolean,
    TResult Function(double value)? number,
    TResult Function(List<String> values)? list,
    TResult Function()? isNull,
    TResult Function()? notNull,
    required TResult orElse(),
  }) {
    if (notNull != null) {
      return notNull();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringTriggerValue value) string,
    required TResult Function(BooleanTriggerValue value) boolean,
    required TResult Function(NumberTriggerValue value) number,
    required TResult Function(ListTriggerValue value) list,
    required TResult Function(NullTriggerValue value) isNull,
    required TResult Function(NotNullTriggerValue value) notNull,
  }) {
    return notNull(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringTriggerValue value)? string,
    TResult? Function(BooleanTriggerValue value)? boolean,
    TResult? Function(NumberTriggerValue value)? number,
    TResult? Function(ListTriggerValue value)? list,
    TResult? Function(NullTriggerValue value)? isNull,
    TResult? Function(NotNullTriggerValue value)? notNull,
  }) {
    return notNull?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringTriggerValue value)? string,
    TResult Function(BooleanTriggerValue value)? boolean,
    TResult Function(NumberTriggerValue value)? number,
    TResult Function(ListTriggerValue value)? list,
    TResult Function(NullTriggerValue value)? isNull,
    TResult Function(NotNullTriggerValue value)? notNull,
    required TResult orElse(),
  }) {
    if (notNull != null) {
      return notNull(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NotNullTriggerValueImplToJson(
      this,
    );
  }
}

abstract class NotNullTriggerValue implements TriggerValue {
  const factory NotNullTriggerValue() = _$NotNullTriggerValueImpl;

  factory NotNullTriggerValue.fromJson(Map<String, dynamic> json) =
      _$NotNullTriggerValueImpl.fromJson;
}

TriggerGroup _$TriggerGroupFromJson(Map<String, dynamic> json) {
  return _TriggerGroup.fromJson(json);
}

/// @nodoc
mixin _$TriggerGroup {
  String get id => throw _privateConstructorUsedError;
  List<TriggerCondition> get conditions => throw _privateConstructorUsedError;
  String get logicalOperator => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerGroupCopyWith<TriggerGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerGroupCopyWith<$Res> {
  factory $TriggerGroupCopyWith(
          TriggerGroup value, $Res Function(TriggerGroup) then) =
      _$TriggerGroupCopyWithImpl<$Res, TriggerGroup>;
  @useResult
  $Res call(
      {String id, List<TriggerCondition> conditions, String logicalOperator});
}

/// @nodoc
class _$TriggerGroupCopyWithImpl<$Res, $Val extends TriggerGroup>
    implements $TriggerGroupCopyWith<$Res> {
  _$TriggerGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conditions = null,
    Object? logicalOperator = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conditions: null == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<TriggerCondition>,
      logicalOperator: null == logicalOperator
          ? _value.logicalOperator
          : logicalOperator // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerGroupImplCopyWith<$Res>
    implements $TriggerGroupCopyWith<$Res> {
  factory _$$TriggerGroupImplCopyWith(
          _$TriggerGroupImpl value, $Res Function(_$TriggerGroupImpl) then) =
      __$$TriggerGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, List<TriggerCondition> conditions, String logicalOperator});
}

/// @nodoc
class __$$TriggerGroupImplCopyWithImpl<$Res>
    extends _$TriggerGroupCopyWithImpl<$Res, _$TriggerGroupImpl>
    implements _$$TriggerGroupImplCopyWith<$Res> {
  __$$TriggerGroupImplCopyWithImpl(
      _$TriggerGroupImpl _value, $Res Function(_$TriggerGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conditions = null,
    Object? logicalOperator = null,
  }) {
    return _then(_$TriggerGroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<TriggerCondition>,
      logicalOperator: null == logicalOperator
          ? _value.logicalOperator
          : logicalOperator // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerGroupImpl implements _TriggerGroup {
  const _$TriggerGroupImpl(
      {required this.id,
      required final List<TriggerCondition> conditions,
      this.logicalOperator = 'AND'})
      : _conditions = conditions;

  factory _$TriggerGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerGroupImplFromJson(json);

  @override
  final String id;
  final List<TriggerCondition> _conditions;
  @override
  List<TriggerCondition> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  @JsonKey()
  final String logicalOperator;

  @override
  String toString() {
    return 'TriggerGroup(id: $id, conditions: $conditions, logicalOperator: $logicalOperator)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerGroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions) &&
            (identical(other.logicalOperator, logicalOperator) ||
                other.logicalOperator == logicalOperator));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id,
      const DeepCollectionEquality().hash(_conditions), logicalOperator);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerGroupImplCopyWith<_$TriggerGroupImpl> get copyWith =>
      __$$TriggerGroupImplCopyWithImpl<_$TriggerGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerGroupImplToJson(
      this,
    );
  }
}

abstract class _TriggerGroup implements TriggerGroup {
  const factory _TriggerGroup(
      {required final String id,
      required final List<TriggerCondition> conditions,
      final String logicalOperator}) = _$TriggerGroupImpl;

  factory _TriggerGroup.fromJson(Map<String, dynamic> json) =
      _$TriggerGroupImpl.fromJson;

  @override
  String get id;
  @override
  List<TriggerCondition> get conditions;
  @override
  String get logicalOperator;
  @override
  @JsonKey(ignore: true)
  _$$TriggerGroupImplCopyWith<_$TriggerGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MethodologyTriggerDefinition _$MethodologyTriggerDefinitionFromJson(
    Map<String, dynamic> json) {
  return _MethodologyTriggerDefinition.fromJson(json);
}

/// @nodoc
mixin _$MethodologyTriggerDefinition {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  List<TriggerGroup> get conditionGroups => throw _privateConstructorUsedError;
  String get groupLogicalOperator => throw _privateConstructorUsedError;
  Map<String, String>? get parameterMappings =>
      throw _privateConstructorUsedError;
  Map<String, dynamic>? get defaultParameters =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MethodologyTriggerDefinitionCopyWith<MethodologyTriggerDefinition>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MethodologyTriggerDefinitionCopyWith<$Res> {
  factory $MethodologyTriggerDefinitionCopyWith(
          MethodologyTriggerDefinition value,
          $Res Function(MethodologyTriggerDefinition) then) =
      _$MethodologyTriggerDefinitionCopyWithImpl<$Res,
          MethodologyTriggerDefinition>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int priority,
      bool enabled,
      List<TriggerGroup> conditionGroups,
      String groupLogicalOperator,
      Map<String, String>? parameterMappings,
      Map<String, dynamic>? defaultParameters});
}

/// @nodoc
class _$MethodologyTriggerDefinitionCopyWithImpl<$Res,
        $Val extends MethodologyTriggerDefinition>
    implements $MethodologyTriggerDefinitionCopyWith<$Res> {
  _$MethodologyTriggerDefinitionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? priority = null,
    Object? enabled = null,
    Object? conditionGroups = null,
    Object? groupLogicalOperator = null,
    Object? parameterMappings = freezed,
    Object? defaultParameters = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      conditionGroups: null == conditionGroups
          ? _value.conditionGroups
          : conditionGroups // ignore: cast_nullable_to_non_nullable
              as List<TriggerGroup>,
      groupLogicalOperator: null == groupLogicalOperator
          ? _value.groupLogicalOperator
          : groupLogicalOperator // ignore: cast_nullable_to_non_nullable
              as String,
      parameterMappings: freezed == parameterMappings
          ? _value.parameterMappings
          : parameterMappings // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      defaultParameters: freezed == defaultParameters
          ? _value.defaultParameters
          : defaultParameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MethodologyTriggerDefinitionImplCopyWith<$Res>
    implements $MethodologyTriggerDefinitionCopyWith<$Res> {
  factory _$$MethodologyTriggerDefinitionImplCopyWith(
          _$MethodologyTriggerDefinitionImpl value,
          $Res Function(_$MethodologyTriggerDefinitionImpl) then) =
      __$$MethodologyTriggerDefinitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      int priority,
      bool enabled,
      List<TriggerGroup> conditionGroups,
      String groupLogicalOperator,
      Map<String, String>? parameterMappings,
      Map<String, dynamic>? defaultParameters});
}

/// @nodoc
class __$$MethodologyTriggerDefinitionImplCopyWithImpl<$Res>
    extends _$MethodologyTriggerDefinitionCopyWithImpl<$Res,
        _$MethodologyTriggerDefinitionImpl>
    implements _$$MethodologyTriggerDefinitionImplCopyWith<$Res> {
  __$$MethodologyTriggerDefinitionImplCopyWithImpl(
      _$MethodologyTriggerDefinitionImpl _value,
      $Res Function(_$MethodologyTriggerDefinitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? priority = null,
    Object? enabled = null,
    Object? conditionGroups = null,
    Object? groupLogicalOperator = null,
    Object? parameterMappings = freezed,
    Object? defaultParameters = freezed,
  }) {
    return _then(_$MethodologyTriggerDefinitionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      conditionGroups: null == conditionGroups
          ? _value._conditionGroups
          : conditionGroups // ignore: cast_nullable_to_non_nullable
              as List<TriggerGroup>,
      groupLogicalOperator: null == groupLogicalOperator
          ? _value.groupLogicalOperator
          : groupLogicalOperator // ignore: cast_nullable_to_non_nullable
              as String,
      parameterMappings: freezed == parameterMappings
          ? _value._parameterMappings
          : parameterMappings // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      defaultParameters: freezed == defaultParameters
          ? _value._defaultParameters
          : defaultParameters // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MethodologyTriggerDefinitionImpl
    implements _MethodologyTriggerDefinition {
  const _$MethodologyTriggerDefinitionImpl(
      {required this.id,
      required this.name,
      required this.description,
      this.priority = 5,
      this.enabled = true,
      required final List<TriggerGroup> conditionGroups,
      this.groupLogicalOperator = 'AND',
      final Map<String, String>? parameterMappings,
      final Map<String, dynamic>? defaultParameters})
      : _conditionGroups = conditionGroups,
        _parameterMappings = parameterMappings,
        _defaultParameters = defaultParameters;

  factory _$MethodologyTriggerDefinitionImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$MethodologyTriggerDefinitionImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey()
  final bool enabled;
  final List<TriggerGroup> _conditionGroups;
  @override
  List<TriggerGroup> get conditionGroups {
    if (_conditionGroups is EqualUnmodifiableListView) return _conditionGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditionGroups);
  }

  @override
  @JsonKey()
  final String groupLogicalOperator;
  final Map<String, String>? _parameterMappings;
  @override
  Map<String, String>? get parameterMappings {
    final value = _parameterMappings;
    if (value == null) return null;
    if (_parameterMappings is EqualUnmodifiableMapView)
      return _parameterMappings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final Map<String, dynamic>? _defaultParameters;
  @override
  Map<String, dynamic>? get defaultParameters {
    final value = _defaultParameters;
    if (value == null) return null;
    if (_defaultParameters is EqualUnmodifiableMapView)
      return _defaultParameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'MethodologyTriggerDefinition(id: $id, name: $name, description: $description, priority: $priority, enabled: $enabled, conditionGroups: $conditionGroups, groupLogicalOperator: $groupLogicalOperator, parameterMappings: $parameterMappings, defaultParameters: $defaultParameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MethodologyTriggerDefinitionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality()
                .equals(other._conditionGroups, _conditionGroups) &&
            (identical(other.groupLogicalOperator, groupLogicalOperator) ||
                other.groupLogicalOperator == groupLogicalOperator) &&
            const DeepCollectionEquality()
                .equals(other._parameterMappings, _parameterMappings) &&
            const DeepCollectionEquality()
                .equals(other._defaultParameters, _defaultParameters));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      priority,
      enabled,
      const DeepCollectionEquality().hash(_conditionGroups),
      groupLogicalOperator,
      const DeepCollectionEquality().hash(_parameterMappings),
      const DeepCollectionEquality().hash(_defaultParameters));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MethodologyTriggerDefinitionImplCopyWith<
          _$MethodologyTriggerDefinitionImpl>
      get copyWith => __$$MethodologyTriggerDefinitionImplCopyWithImpl<
          _$MethodologyTriggerDefinitionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MethodologyTriggerDefinitionImplToJson(
      this,
    );
  }
}

abstract class _MethodologyTriggerDefinition
    implements MethodologyTriggerDefinition {
  const factory _MethodologyTriggerDefinition(
          {required final String id,
          required final String name,
          required final String description,
          final int priority,
          final bool enabled,
          required final List<TriggerGroup> conditionGroups,
          final String groupLogicalOperator,
          final Map<String, String>? parameterMappings,
          final Map<String, dynamic>? defaultParameters}) =
      _$MethodologyTriggerDefinitionImpl;

  factory _MethodologyTriggerDefinition.fromJson(Map<String, dynamic> json) =
      _$MethodologyTriggerDefinitionImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  int get priority;
  @override
  bool get enabled;
  @override
  List<TriggerGroup> get conditionGroups;
  @override
  String get groupLogicalOperator;
  @override
  Map<String, String>? get parameterMappings;
  @override
  Map<String, dynamic>? get defaultParameters;
  @override
  @JsonKey(ignore: true)
  _$$MethodologyTriggerDefinitionImplCopyWith<
          _$MethodologyTriggerDefinitionImpl>
      get copyWith => throw _privateConstructorUsedError;
}

AssetProperty _$AssetPropertyFromJson(Map<String, dynamic> json) {
  return _AssetProperty.fromJson(json);
}

/// @nodoc
mixin _$AssetProperty {
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  PropertyType get type => throw _privateConstructorUsedError;
  List<String>? get allowedValues => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetPropertyCopyWith<AssetProperty> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetPropertyCopyWith<$Res> {
  factory $AssetPropertyCopyWith(
          AssetProperty value, $Res Function(AssetProperty) then) =
      _$AssetPropertyCopyWithImpl<$Res, AssetProperty>;
  @useResult
  $Res call(
      {String name,
      String displayName,
      PropertyType type,
      List<String>? allowedValues,
      String? description});
}

/// @nodoc
class _$AssetPropertyCopyWithImpl<$Res, $Val extends AssetProperty>
    implements $AssetPropertyCopyWith<$Res> {
  _$AssetPropertyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? type = null,
    Object? allowedValues = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PropertyType,
      allowedValues: freezed == allowedValues
          ? _value.allowedValues
          : allowedValues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetPropertyImplCopyWith<$Res>
    implements $AssetPropertyCopyWith<$Res> {
  factory _$$AssetPropertyImplCopyWith(
          _$AssetPropertyImpl value, $Res Function(_$AssetPropertyImpl) then) =
      __$$AssetPropertyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String displayName,
      PropertyType type,
      List<String>? allowedValues,
      String? description});
}

/// @nodoc
class __$$AssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyCopyWithImpl<$Res, _$AssetPropertyImpl>
    implements _$$AssetPropertyImplCopyWith<$Res> {
  __$$AssetPropertyImplCopyWithImpl(
      _$AssetPropertyImpl _value, $Res Function(_$AssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? type = null,
    Object? allowedValues = freezed,
    Object? description = freezed,
  }) {
    return _then(_$AssetPropertyImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PropertyType,
      allowedValues: freezed == allowedValues
          ? _value._allowedValues
          : allowedValues // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetPropertyImpl implements _AssetProperty {
  const _$AssetPropertyImpl(
      {required this.name,
      required this.displayName,
      required this.type,
      final List<String>? allowedValues,
      this.description})
      : _allowedValues = allowedValues;

  factory _$AssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetPropertyImplFromJson(json);

  @override
  final String name;
  @override
  final String displayName;
  @override
  final PropertyType type;
  final List<String>? _allowedValues;
  @override
  List<String>? get allowedValues {
    final value = _allowedValues;
    if (value == null) return null;
    if (_allowedValues is EqualUnmodifiableListView) return _allowedValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? description;

  @override
  String toString() {
    return 'AssetProperty(name: $name, displayName: $displayName, type: $type, allowedValues: $allowedValues, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetPropertyImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._allowedValues, _allowedValues) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, displayName, type,
      const DeepCollectionEquality().hash(_allowedValues), description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetPropertyImplCopyWith<_$AssetPropertyImpl> get copyWith =>
      __$$AssetPropertyImplCopyWithImpl<_$AssetPropertyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetPropertyImplToJson(
      this,
    );
  }
}

abstract class _AssetProperty implements AssetProperty {
  const factory _AssetProperty(
      {required final String name,
      required final String displayName,
      required final PropertyType type,
      final List<String>? allowedValues,
      final String? description}) = _$AssetPropertyImpl;

  factory _AssetProperty.fromJson(Map<String, dynamic> json) =
      _$AssetPropertyImpl.fromJson;

  @override
  String get name;
  @override
  String get displayName;
  @override
  PropertyType get type;
  @override
  List<String>? get allowedValues;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$AssetPropertyImplCopyWith<_$AssetPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggerTemplate _$TriggerTemplateFromJson(Map<String, dynamic> json) {
  return _TriggerTemplate.fromJson(json);
}

/// @nodoc
mixin _$TriggerTemplate {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  MethodologyTriggerDefinition get trigger =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerTemplateCopyWith<TriggerTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerTemplateCopyWith<$Res> {
  factory $TriggerTemplateCopyWith(
          TriggerTemplate value, $Res Function(TriggerTemplate) then) =
      _$TriggerTemplateCopyWithImpl<$Res, TriggerTemplate>;
  @useResult
  $Res call(
      {String name, String description, MethodologyTriggerDefinition trigger});

  $MethodologyTriggerDefinitionCopyWith<$Res> get trigger;
}

/// @nodoc
class _$TriggerTemplateCopyWithImpl<$Res, $Val extends TriggerTemplate>
    implements $TriggerTemplateCopyWith<$Res> {
  _$TriggerTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? trigger = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      trigger: null == trigger
          ? _value.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as MethodologyTriggerDefinition,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $MethodologyTriggerDefinitionCopyWith<$Res> get trigger {
    return $MethodologyTriggerDefinitionCopyWith<$Res>(_value.trigger, (value) {
      return _then(_value.copyWith(trigger: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TriggerTemplateImplCopyWith<$Res>
    implements $TriggerTemplateCopyWith<$Res> {
  factory _$$TriggerTemplateImplCopyWith(_$TriggerTemplateImpl value,
          $Res Function(_$TriggerTemplateImpl) then) =
      __$$TriggerTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String description, MethodologyTriggerDefinition trigger});

  @override
  $MethodologyTriggerDefinitionCopyWith<$Res> get trigger;
}

/// @nodoc
class __$$TriggerTemplateImplCopyWithImpl<$Res>
    extends _$TriggerTemplateCopyWithImpl<$Res, _$TriggerTemplateImpl>
    implements _$$TriggerTemplateImplCopyWith<$Res> {
  __$$TriggerTemplateImplCopyWithImpl(
      _$TriggerTemplateImpl _value, $Res Function(_$TriggerTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? trigger = null,
  }) {
    return _then(_$TriggerTemplateImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      trigger: null == trigger
          ? _value.trigger
          : trigger // ignore: cast_nullable_to_non_nullable
              as MethodologyTriggerDefinition,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerTemplateImpl implements _TriggerTemplate {
  const _$TriggerTemplateImpl(
      {required this.name, required this.description, required this.trigger});

  factory _$TriggerTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerTemplateImplFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final MethodologyTriggerDefinition trigger;

  @override
  String toString() {
    return 'TriggerTemplate(name: $name, description: $description, trigger: $trigger)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerTemplateImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.trigger, trigger) || other.trigger == trigger));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, trigger);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerTemplateImplCopyWith<_$TriggerTemplateImpl> get copyWith =>
      __$$TriggerTemplateImplCopyWithImpl<_$TriggerTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerTemplateImplToJson(
      this,
    );
  }
}

abstract class _TriggerTemplate implements TriggerTemplate {
  const factory _TriggerTemplate(
          {required final String name,
          required final String description,
          required final MethodologyTriggerDefinition trigger}) =
      _$TriggerTemplateImpl;

  factory _TriggerTemplate.fromJson(Map<String, dynamic> json) =
      _$TriggerTemplateImpl.fromJson;

  @override
  String get name;
  @override
  String get description;
  @override
  MethodologyTriggerDefinition get trigger;
  @override
  @JsonKey(ignore: true)
  _$$TriggerTemplateImplCopyWith<_$TriggerTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MethodologyParameter _$MethodologyParameterFromJson(Map<String, dynamic> json) {
  return _MethodologyParameter.fromJson(json);
}

/// @nodoc
mixin _$MethodologyParameter {
  String get name => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  String get source =>
      throw _privateConstructorUsedError; // 'asset_property', 'static_value', 'user_input'
  String? get defaultValue => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MethodologyParameterCopyWith<MethodologyParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MethodologyParameterCopyWith<$Res> {
  factory $MethodologyParameterCopyWith(MethodologyParameter value,
          $Res Function(MethodologyParameter) then) =
      _$MethodologyParameterCopyWithImpl<$Res, MethodologyParameter>;
  @useResult
  $Res call(
      {String name,
      String type,
      String source,
      String? defaultValue,
      String? description});
}

/// @nodoc
class _$MethodologyParameterCopyWithImpl<$Res,
        $Val extends MethodologyParameter>
    implements $MethodologyParameterCopyWith<$Res> {
  _$MethodologyParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? source = null,
    Object? defaultValue = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MethodologyParameterImplCopyWith<$Res>
    implements $MethodologyParameterCopyWith<$Res> {
  factory _$$MethodologyParameterImplCopyWith(_$MethodologyParameterImpl value,
          $Res Function(_$MethodologyParameterImpl) then) =
      __$$MethodologyParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String type,
      String source,
      String? defaultValue,
      String? description});
}

/// @nodoc
class __$$MethodologyParameterImplCopyWithImpl<$Res>
    extends _$MethodologyParameterCopyWithImpl<$Res, _$MethodologyParameterImpl>
    implements _$$MethodologyParameterImplCopyWith<$Res> {
  __$$MethodologyParameterImplCopyWithImpl(_$MethodologyParameterImpl _value,
      $Res Function(_$MethodologyParameterImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? source = null,
    Object? defaultValue = freezed,
    Object? description = freezed,
  }) {
    return _then(_$MethodologyParameterImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      defaultValue: freezed == defaultValue
          ? _value.defaultValue
          : defaultValue // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MethodologyParameterImpl implements _MethodologyParameter {
  const _$MethodologyParameterImpl(
      {required this.name,
      required this.type,
      required this.source,
      this.defaultValue,
      this.description});

  factory _$MethodologyParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$MethodologyParameterImplFromJson(json);

  @override
  final String name;
  @override
  final String type;
  @override
  final String source;
// 'asset_property', 'static_value', 'user_input'
  @override
  final String? defaultValue;
  @override
  final String? description;

  @override
  String toString() {
    return 'MethodologyParameter(name: $name, type: $type, source: $source, defaultValue: $defaultValue, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MethodologyParameterImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.defaultValue, defaultValue) ||
                other.defaultValue == defaultValue) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, type, source, defaultValue, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MethodologyParameterImplCopyWith<_$MethodologyParameterImpl>
      get copyWith =>
          __$$MethodologyParameterImplCopyWithImpl<_$MethodologyParameterImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MethodologyParameterImplToJson(
      this,
    );
  }
}

abstract class _MethodologyParameter implements MethodologyParameter {
  const factory _MethodologyParameter(
      {required final String name,
      required final String type,
      required final String source,
      final String? defaultValue,
      final String? description}) = _$MethodologyParameterImpl;

  factory _MethodologyParameter.fromJson(Map<String, dynamic> json) =
      _$MethodologyParameterImpl.fromJson;

  @override
  String get name;
  @override
  String get type;
  @override
  String get source;
  @override // 'asset_property', 'static_value', 'user_input'
  String? get defaultValue;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$MethodologyParameterImplCopyWith<_$MethodologyParameterImpl>
      get copyWith => throw _privateConstructorUsedError;
}
