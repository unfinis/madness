// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trigger_evaluation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TriggerMatch _$TriggerMatchFromJson(Map<String, dynamic> json) {
  return _TriggerMatch.fromJson(json);
}

/// @nodoc
mixin _$TriggerMatch {
  /// Unique identifier for this trigger match
  String get id => throw _privateConstructorUsedError;

  /// ID of the trigger that was evaluated
  String get triggerId => throw _privateConstructorUsedError;

  /// ID of the methodology template containing the trigger
  String get templateId => throw _privateConstructorUsedError;

  /// ID of the asset that was evaluated
  String get assetId => throw _privateConstructorUsedError;

  /// Whether the trigger condition matched
  bool get matched => throw _privateConstructorUsedError;

  /// Values extracted from the asset during evaluation
  Map<String, dynamic> get extractedValues =>
      throw _privateConstructorUsedError;

  /// Confidence score of the match (0.0 - 1.0)
  double get confidence => throw _privateConstructorUsedError;

  /// When this evaluation was performed
  DateTime get evaluatedAt => throw _privateConstructorUsedError;

  /// Priority of this trigger (from the trigger definition)
  int get priority => throw _privateConstructorUsedError;

  /// Error message if evaluation failed
  String? get error => throw _privateConstructorUsedError;

  /// Debug information about the evaluation
  Map<String, dynamic> get debugInfo => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerMatchCopyWith<TriggerMatch> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerMatchCopyWith<$Res> {
  factory $TriggerMatchCopyWith(
          TriggerMatch value, $Res Function(TriggerMatch) then) =
      _$TriggerMatchCopyWithImpl<$Res, TriggerMatch>;
  @useResult
  $Res call(
      {String id,
      String triggerId,
      String templateId,
      String assetId,
      bool matched,
      Map<String, dynamic> extractedValues,
      double confidence,
      DateTime evaluatedAt,
      int priority,
      String? error,
      Map<String, dynamic> debugInfo});
}

/// @nodoc
class _$TriggerMatchCopyWithImpl<$Res, $Val extends TriggerMatch>
    implements $TriggerMatchCopyWith<$Res> {
  _$TriggerMatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? triggerId = null,
    Object? templateId = null,
    Object? assetId = null,
    Object? matched = null,
    Object? extractedValues = null,
    Object? confidence = null,
    Object? evaluatedAt = null,
    Object? priority = null,
    Object? error = freezed,
    Object? debugInfo = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      matched: null == matched
          ? _value.matched
          : matched // ignore: cast_nullable_to_non_nullable
              as bool,
      extractedValues: null == extractedValues
          ? _value.extractedValues
          : extractedValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      evaluatedAt: null == evaluatedAt
          ? _value.evaluatedAt
          : evaluatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      debugInfo: null == debugInfo
          ? _value.debugInfo
          : debugInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerMatchImplCopyWith<$Res>
    implements $TriggerMatchCopyWith<$Res> {
  factory _$$TriggerMatchImplCopyWith(
          _$TriggerMatchImpl value, $Res Function(_$TriggerMatchImpl) then) =
      __$$TriggerMatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String triggerId,
      String templateId,
      String assetId,
      bool matched,
      Map<String, dynamic> extractedValues,
      double confidence,
      DateTime evaluatedAt,
      int priority,
      String? error,
      Map<String, dynamic> debugInfo});
}

/// @nodoc
class __$$TriggerMatchImplCopyWithImpl<$Res>
    extends _$TriggerMatchCopyWithImpl<$Res, _$TriggerMatchImpl>
    implements _$$TriggerMatchImplCopyWith<$Res> {
  __$$TriggerMatchImplCopyWithImpl(
      _$TriggerMatchImpl _value, $Res Function(_$TriggerMatchImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? triggerId = null,
    Object? templateId = null,
    Object? assetId = null,
    Object? matched = null,
    Object? extractedValues = null,
    Object? confidence = null,
    Object? evaluatedAt = null,
    Object? priority = null,
    Object? error = freezed,
    Object? debugInfo = null,
  }) {
    return _then(_$TriggerMatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: null == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      matched: null == matched
          ? _value.matched
          : matched // ignore: cast_nullable_to_non_nullable
              as bool,
      extractedValues: null == extractedValues
          ? _value._extractedValues
          : extractedValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      evaluatedAt: null == evaluatedAt
          ? _value.evaluatedAt
          : evaluatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      debugInfo: null == debugInfo
          ? _value._debugInfo
          : debugInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerMatchImpl implements _TriggerMatch {
  const _$TriggerMatchImpl(
      {required this.id,
      required this.triggerId,
      required this.templateId,
      required this.assetId,
      required this.matched,
      required final Map<String, dynamic> extractedValues,
      this.confidence = 1.0,
      required this.evaluatedAt,
      this.priority = 5,
      this.error,
      final Map<String, dynamic> debugInfo = const {}})
      : _extractedValues = extractedValues,
        _debugInfo = debugInfo;

  factory _$TriggerMatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerMatchImplFromJson(json);

  /// Unique identifier for this trigger match
  @override
  final String id;

  /// ID of the trigger that was evaluated
  @override
  final String triggerId;

  /// ID of the methodology template containing the trigger
  @override
  final String templateId;

  /// ID of the asset that was evaluated
  @override
  final String assetId;

  /// Whether the trigger condition matched
  @override
  final bool matched;

  /// Values extracted from the asset during evaluation
  final Map<String, dynamic> _extractedValues;

  /// Values extracted from the asset during evaluation
  @override
  Map<String, dynamic> get extractedValues {
    if (_extractedValues is EqualUnmodifiableMapView) return _extractedValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extractedValues);
  }

  /// Confidence score of the match (0.0 - 1.0)
  @override
  @JsonKey()
  final double confidence;

  /// When this evaluation was performed
  @override
  final DateTime evaluatedAt;

  /// Priority of this trigger (from the trigger definition)
  @override
  @JsonKey()
  final int priority;

  /// Error message if evaluation failed
  @override
  final String? error;

  /// Debug information about the evaluation
  final Map<String, dynamic> _debugInfo;

  /// Debug information about the evaluation
  @override
  @JsonKey()
  Map<String, dynamic> get debugInfo {
    if (_debugInfo is EqualUnmodifiableMapView) return _debugInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_debugInfo);
  }

  @override
  String toString() {
    return 'TriggerMatch(id: $id, triggerId: $triggerId, templateId: $templateId, assetId: $assetId, matched: $matched, extractedValues: $extractedValues, confidence: $confidence, evaluatedAt: $evaluatedAt, priority: $priority, error: $error, debugInfo: $debugInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerMatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.triggerId, triggerId) ||
                other.triggerId == triggerId) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.matched, matched) || other.matched == matched) &&
            const DeepCollectionEquality()
                .equals(other._extractedValues, _extractedValues) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.evaluatedAt, evaluatedAt) ||
                other.evaluatedAt == evaluatedAt) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._debugInfo, _debugInfo));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      triggerId,
      templateId,
      assetId,
      matched,
      const DeepCollectionEquality().hash(_extractedValues),
      confidence,
      evaluatedAt,
      priority,
      error,
      const DeepCollectionEquality().hash(_debugInfo));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerMatchImplCopyWith<_$TriggerMatchImpl> get copyWith =>
      __$$TriggerMatchImplCopyWithImpl<_$TriggerMatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerMatchImplToJson(
      this,
    );
  }
}

abstract class _TriggerMatch implements TriggerMatch {
  const factory _TriggerMatch(
      {required final String id,
      required final String triggerId,
      required final String templateId,
      required final String assetId,
      required final bool matched,
      required final Map<String, dynamic> extractedValues,
      final double confidence,
      required final DateTime evaluatedAt,
      final int priority,
      final String? error,
      final Map<String, dynamic> debugInfo}) = _$TriggerMatchImpl;

  factory _TriggerMatch.fromJson(Map<String, dynamic> json) =
      _$TriggerMatchImpl.fromJson;

  @override

  /// Unique identifier for this trigger match
  String get id;
  @override

  /// ID of the trigger that was evaluated
  String get triggerId;
  @override

  /// ID of the methodology template containing the trigger
  String get templateId;
  @override

  /// ID of the asset that was evaluated
  String get assetId;
  @override

  /// Whether the trigger condition matched
  bool get matched;
  @override

  /// Values extracted from the asset during evaluation
  Map<String, dynamic> get extractedValues;
  @override

  /// Confidence score of the match (0.0 - 1.0)
  double get confidence;
  @override

  /// When this evaluation was performed
  DateTime get evaluatedAt;
  @override

  /// Priority of this trigger (from the trigger definition)
  int get priority;
  @override

  /// Error message if evaluation failed
  String? get error;
  @override

  /// Debug information about the evaluation
  Map<String, dynamic> get debugInfo;
  @override
  @JsonKey(ignore: true)
  _$$TriggerMatchImplCopyWith<_$TriggerMatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ParameterResolution _$ParameterResolutionFromJson(Map<String, dynamic> json) {
  return _ParameterResolution.fromJson(json);
}

/// @nodoc
mixin _$ParameterResolution {
  /// Name of the parameter
  String get name => throw _privateConstructorUsedError;

  /// Type of the parameter
  ParameterType get type => throw _privateConstructorUsedError;

  /// Resolved value for the parameter
  dynamic get value => throw _privateConstructorUsedError;

  /// Source where the value was resolved from
  ParameterSource get source => throw _privateConstructorUsedError;

  /// Whether this parameter is required
  bool get required => throw _privateConstructorUsedError;

  /// Whether the parameter was successfully resolved
  bool get resolved => throw _privateConstructorUsedError;

  /// Error message if resolution failed
  String? get error => throw _privateConstructorUsedError;

  /// When this parameter was resolved
  DateTime get resolvedAt => throw _privateConstructorUsedError;

  /// Additional metadata about the resolution
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ParameterResolutionCopyWith<ParameterResolution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParameterResolutionCopyWith<$Res> {
  factory $ParameterResolutionCopyWith(
          ParameterResolution value, $Res Function(ParameterResolution) then) =
      _$ParameterResolutionCopyWithImpl<$Res, ParameterResolution>;
  @useResult
  $Res call(
      {String name,
      ParameterType type,
      dynamic value,
      ParameterSource source,
      bool required,
      bool resolved,
      String? error,
      DateTime resolvedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$ParameterResolutionCopyWithImpl<$Res, $Val extends ParameterResolution>
    implements $ParameterResolutionCopyWith<$Res> {
  _$ParameterResolutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? value = freezed,
    Object? source = null,
    Object? required = null,
    Object? resolved = null,
    Object? error = freezed,
    Object? resolvedAt = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ParameterType,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ParameterSource,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: null == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ParameterResolutionImplCopyWith<$Res>
    implements $ParameterResolutionCopyWith<$Res> {
  factory _$$ParameterResolutionImplCopyWith(_$ParameterResolutionImpl value,
          $Res Function(_$ParameterResolutionImpl) then) =
      __$$ParameterResolutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      ParameterType type,
      dynamic value,
      ParameterSource source,
      bool required,
      bool resolved,
      String? error,
      DateTime resolvedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$ParameterResolutionImplCopyWithImpl<$Res>
    extends _$ParameterResolutionCopyWithImpl<$Res, _$ParameterResolutionImpl>
    implements _$$ParameterResolutionImplCopyWith<$Res> {
  __$$ParameterResolutionImplCopyWithImpl(_$ParameterResolutionImpl _value,
      $Res Function(_$ParameterResolutionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? type = null,
    Object? value = freezed,
    Object? source = null,
    Object? required = null,
    Object? resolved = null,
    Object? error = freezed,
    Object? resolvedAt = null,
    Object? metadata = null,
  }) {
    return _then(_$ParameterResolutionImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ParameterType,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as ParameterSource,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      resolved: null == resolved
          ? _value.resolved
          : resolved // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      resolvedAt: null == resolvedAt
          ? _value.resolvedAt
          : resolvedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ParameterResolutionImpl implements _ParameterResolution {
  const _$ParameterResolutionImpl(
      {required this.name,
      required this.type,
      required this.value,
      required this.source,
      this.required = false,
      this.resolved = true,
      this.error,
      required this.resolvedAt,
      final Map<String, dynamic> metadata = const {}})
      : _metadata = metadata;

  factory _$ParameterResolutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParameterResolutionImplFromJson(json);

  /// Name of the parameter
  @override
  final String name;

  /// Type of the parameter
  @override
  final ParameterType type;

  /// Resolved value for the parameter
  @override
  final dynamic value;

  /// Source where the value was resolved from
  @override
  final ParameterSource source;

  /// Whether this parameter is required
  @override
  @JsonKey()
  final bool required;

  /// Whether the parameter was successfully resolved
  @override
  @JsonKey()
  final bool resolved;

  /// Error message if resolution failed
  @override
  final String? error;

  /// When this parameter was resolved
  @override
  final DateTime resolvedAt;

  /// Additional metadata about the resolution
  final Map<String, dynamic> _metadata;

  /// Additional metadata about the resolution
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'ParameterResolution(name: $name, type: $type, value: $value, source: $source, required: $required, resolved: $resolved, error: $error, resolvedAt: $resolvedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParameterResolutionImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.resolved, resolved) ||
                other.resolved == resolved) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      type,
      const DeepCollectionEquality().hash(value),
      source,
      required,
      resolved,
      error,
      resolvedAt,
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParameterResolutionImplCopyWith<_$ParameterResolutionImpl> get copyWith =>
      __$$ParameterResolutionImplCopyWithImpl<_$ParameterResolutionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParameterResolutionImplToJson(
      this,
    );
  }
}

abstract class _ParameterResolution implements ParameterResolution {
  const factory _ParameterResolution(
      {required final String name,
      required final ParameterType type,
      required final dynamic value,
      required final ParameterSource source,
      final bool required,
      final bool resolved,
      final String? error,
      required final DateTime resolvedAt,
      final Map<String, dynamic> metadata}) = _$ParameterResolutionImpl;

  factory _ParameterResolution.fromJson(Map<String, dynamic> json) =
      _$ParameterResolutionImpl.fromJson;

  @override

  /// Name of the parameter
  String get name;
  @override

  /// Type of the parameter
  ParameterType get type;
  @override

  /// Resolved value for the parameter
  dynamic get value;
  @override

  /// Source where the value was resolved from
  ParameterSource get source;
  @override

  /// Whether this parameter is required
  bool get required;
  @override

  /// Whether the parameter was successfully resolved
  bool get resolved;
  @override

  /// Error message if resolution failed
  String? get error;
  @override

  /// When this parameter was resolved
  DateTime get resolvedAt;
  @override

  /// Additional metadata about the resolution
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$ParameterResolutionImplCopyWith<_$ParameterResolutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggerConditionResult _$TriggerConditionResultFromJson(
    Map<String, dynamic> json) {
  return _TriggerConditionResult.fromJson(json);
}

/// @nodoc
mixin _$TriggerConditionResult {
  /// The original condition expression
  String get expression => throw _privateConstructorUsedError;

  /// Whether the condition evaluated to true
  bool get result => throw _privateConstructorUsedError;

  /// Values used in the evaluation
  Map<String, dynamic> get variables => throw _privateConstructorUsedError;

  /// Execution time in milliseconds
  int get executionTimeMs => throw _privateConstructorUsedError;

  /// Error message if evaluation failed
  String? get error => throw _privateConstructorUsedError;

  /// Debug trace of the evaluation
  List<String> get debugTrace => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerConditionResultCopyWith<TriggerConditionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerConditionResultCopyWith<$Res> {
  factory $TriggerConditionResultCopyWith(TriggerConditionResult value,
          $Res Function(TriggerConditionResult) then) =
      _$TriggerConditionResultCopyWithImpl<$Res, TriggerConditionResult>;
  @useResult
  $Res call(
      {String expression,
      bool result,
      Map<String, dynamic> variables,
      int executionTimeMs,
      String? error,
      List<String> debugTrace});
}

/// @nodoc
class _$TriggerConditionResultCopyWithImpl<$Res,
        $Val extends TriggerConditionResult>
    implements $TriggerConditionResultCopyWith<$Res> {
  _$TriggerConditionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expression = null,
    Object? result = null,
    Object? variables = null,
    Object? executionTimeMs = null,
    Object? error = freezed,
    Object? debugTrace = null,
  }) {
    return _then(_value.copyWith(
      expression: null == expression
          ? _value.expression
          : expression // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool,
      variables: null == variables
          ? _value.variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      executionTimeMs: null == executionTimeMs
          ? _value.executionTimeMs
          : executionTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      debugTrace: null == debugTrace
          ? _value.debugTrace
          : debugTrace // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerConditionResultImplCopyWith<$Res>
    implements $TriggerConditionResultCopyWith<$Res> {
  factory _$$TriggerConditionResultImplCopyWith(
          _$TriggerConditionResultImpl value,
          $Res Function(_$TriggerConditionResultImpl) then) =
      __$$TriggerConditionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String expression,
      bool result,
      Map<String, dynamic> variables,
      int executionTimeMs,
      String? error,
      List<String> debugTrace});
}

/// @nodoc
class __$$TriggerConditionResultImplCopyWithImpl<$Res>
    extends _$TriggerConditionResultCopyWithImpl<$Res,
        _$TriggerConditionResultImpl>
    implements _$$TriggerConditionResultImplCopyWith<$Res> {
  __$$TriggerConditionResultImplCopyWithImpl(
      _$TriggerConditionResultImpl _value,
      $Res Function(_$TriggerConditionResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? expression = null,
    Object? result = null,
    Object? variables = null,
    Object? executionTimeMs = null,
    Object? error = freezed,
    Object? debugTrace = null,
  }) {
    return _then(_$TriggerConditionResultImpl(
      expression: null == expression
          ? _value.expression
          : expression // ignore: cast_nullable_to_non_nullable
              as String,
      result: null == result
          ? _value.result
          : result // ignore: cast_nullable_to_non_nullable
              as bool,
      variables: null == variables
          ? _value._variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      executionTimeMs: null == executionTimeMs
          ? _value.executionTimeMs
          : executionTimeMs // ignore: cast_nullable_to_non_nullable
              as int,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      debugTrace: null == debugTrace
          ? _value._debugTrace
          : debugTrace // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerConditionResultImpl implements _TriggerConditionResult {
  const _$TriggerConditionResultImpl(
      {required this.expression,
      required this.result,
      required final Map<String, dynamic> variables,
      this.executionTimeMs = 0,
      this.error,
      final List<String> debugTrace = const []})
      : _variables = variables,
        _debugTrace = debugTrace;

  factory _$TriggerConditionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerConditionResultImplFromJson(json);

  /// The original condition expression
  @override
  final String expression;

  /// Whether the condition evaluated to true
  @override
  final bool result;

  /// Values used in the evaluation
  final Map<String, dynamic> _variables;

  /// Values used in the evaluation
  @override
  Map<String, dynamic> get variables {
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_variables);
  }

  /// Execution time in milliseconds
  @override
  @JsonKey()
  final int executionTimeMs;

  /// Error message if evaluation failed
  @override
  final String? error;

  /// Debug trace of the evaluation
  final List<String> _debugTrace;

  /// Debug trace of the evaluation
  @override
  @JsonKey()
  List<String> get debugTrace {
    if (_debugTrace is EqualUnmodifiableListView) return _debugTrace;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_debugTrace);
  }

  @override
  String toString() {
    return 'TriggerConditionResult(expression: $expression, result: $result, variables: $variables, executionTimeMs: $executionTimeMs, error: $error, debugTrace: $debugTrace)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerConditionResultImpl &&
            (identical(other.expression, expression) ||
                other.expression == expression) &&
            (identical(other.result, result) || other.result == result) &&
            const DeepCollectionEquality()
                .equals(other._variables, _variables) &&
            (identical(other.executionTimeMs, executionTimeMs) ||
                other.executionTimeMs == executionTimeMs) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._debugTrace, _debugTrace));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      expression,
      result,
      const DeepCollectionEquality().hash(_variables),
      executionTimeMs,
      error,
      const DeepCollectionEquality().hash(_debugTrace));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerConditionResultImplCopyWith<_$TriggerConditionResultImpl>
      get copyWith => __$$TriggerConditionResultImplCopyWithImpl<
          _$TriggerConditionResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerConditionResultImplToJson(
      this,
    );
  }
}

abstract class _TriggerConditionResult implements TriggerConditionResult {
  const factory _TriggerConditionResult(
      {required final String expression,
      required final bool result,
      required final Map<String, dynamic> variables,
      final int executionTimeMs,
      final String? error,
      final List<String> debugTrace}) = _$TriggerConditionResultImpl;

  factory _TriggerConditionResult.fromJson(Map<String, dynamic> json) =
      _$TriggerConditionResultImpl.fromJson;

  @override

  /// The original condition expression
  String get expression;
  @override

  /// Whether the condition evaluated to true
  bool get result;
  @override

  /// Values used in the evaluation
  Map<String, dynamic> get variables;
  @override

  /// Execution time in milliseconds
  int get executionTimeMs;
  @override

  /// Error message if evaluation failed
  String? get error;
  @override

  /// Debug trace of the evaluation
  List<String> get debugTrace;
  @override
  @JsonKey(ignore: true)
  _$$TriggerConditionResultImplCopyWith<_$TriggerConditionResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TriggerContext _$TriggerContextFromJson(Map<String, dynamic> json) {
  return _TriggerContext.fromJson(json);
}

/// @nodoc
mixin _$TriggerContext {
  /// Variables available in the context
  Map<String, dynamic> get variables => throw _privateConstructorUsedError;

  /// Asset being evaluated
  Map<String, dynamic>? get asset => throw _privateConstructorUsedError;

  /// Additional context data
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerContextCopyWith<TriggerContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerContextCopyWith<$Res> {
  factory $TriggerContextCopyWith(
          TriggerContext value, $Res Function(TriggerContext) then) =
      _$TriggerContextCopyWithImpl<$Res, TriggerContext>;
  @useResult
  $Res call(
      {Map<String, dynamic> variables,
      Map<String, dynamic>? asset,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$TriggerContextCopyWithImpl<$Res, $Val extends TriggerContext>
    implements $TriggerContextCopyWith<$Res> {
  _$TriggerContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variables = null,
    Object? asset = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      variables: null == variables
          ? _value.variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      asset: freezed == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerContextImplCopyWith<$Res>
    implements $TriggerContextCopyWith<$Res> {
  factory _$$TriggerContextImplCopyWith(_$TriggerContextImpl value,
          $Res Function(_$TriggerContextImpl) then) =
      __$$TriggerContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, dynamic> variables,
      Map<String, dynamic>? asset,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$TriggerContextImplCopyWithImpl<$Res>
    extends _$TriggerContextCopyWithImpl<$Res, _$TriggerContextImpl>
    implements _$$TriggerContextImplCopyWith<$Res> {
  __$$TriggerContextImplCopyWithImpl(
      _$TriggerContextImpl _value, $Res Function(_$TriggerContextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? variables = null,
    Object? asset = freezed,
    Object? metadata = null,
  }) {
    return _then(_$TriggerContextImpl(
      variables: null == variables
          ? _value._variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      asset: freezed == asset
          ? _value._asset
          : asset // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerContextImpl implements _TriggerContext {
  const _$TriggerContextImpl(
      {final Map<String, dynamic> variables = const {},
      final Map<String, dynamic>? asset,
      final Map<String, dynamic> metadata = const {}})
      : _variables = variables,
        _asset = asset,
        _metadata = metadata;

  factory _$TriggerContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerContextImplFromJson(json);

  /// Variables available in the context
  final Map<String, dynamic> _variables;

  /// Variables available in the context
  @override
  @JsonKey()
  Map<String, dynamic> get variables {
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_variables);
  }

  /// Asset being evaluated
  final Map<String, dynamic>? _asset;

  /// Asset being evaluated
  @override
  Map<String, dynamic>? get asset {
    final value = _asset;
    if (value == null) return null;
    if (_asset is EqualUnmodifiableMapView) return _asset;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  /// Additional context data
  final Map<String, dynamic> _metadata;

  /// Additional context data
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'TriggerContext(variables: $variables, asset: $asset, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerContextImpl &&
            const DeepCollectionEquality()
                .equals(other._variables, _variables) &&
            const DeepCollectionEquality().equals(other._asset, _asset) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_variables),
      const DeepCollectionEquality().hash(_asset),
      const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerContextImplCopyWith<_$TriggerContextImpl> get copyWith =>
      __$$TriggerContextImplCopyWithImpl<_$TriggerContextImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerContextImplToJson(
      this,
    );
  }
}

abstract class _TriggerContext implements TriggerContext {
  const factory _TriggerContext(
      {final Map<String, dynamic> variables,
      final Map<String, dynamic>? asset,
      final Map<String, dynamic> metadata}) = _$TriggerContextImpl;

  factory _TriggerContext.fromJson(Map<String, dynamic> json) =
      _$TriggerContextImpl.fromJson;

  @override

  /// Variables available in the context
  Map<String, dynamic> get variables;
  @override

  /// Asset being evaluated
  Map<String, dynamic>? get asset;
  @override

  /// Additional context data
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$TriggerContextImplCopyWith<_$TriggerContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
