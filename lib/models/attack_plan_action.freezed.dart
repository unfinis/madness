// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attack_plan_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TriggerEvent _$TriggerEventFromJson(Map<String, dynamic> json) {
  return _TriggerEvent.fromJson(json);
}

/// @nodoc
mixin _$TriggerEvent {
  /// ID of the trigger that fired
  String get triggerId => throw _privateConstructorUsedError;

  /// ID of the asset that triggered this
  String get assetId => throw _privateConstructorUsedError;

  /// Name of the asset for display
  String get assetName => throw _privateConstructorUsedError;

  /// Type of asset (host, service, etc.)
  String get assetType => throw _privateConstructorUsedError;

  /// The conditions that were matched
  Map<String, dynamic> get matchedConditions =>
      throw _privateConstructorUsedError;

  /// Values extracted from the trigger evaluation
  Map<String, dynamic> get extractedValues =>
      throw _privateConstructorUsedError;

  /// When this trigger was evaluated
  DateTime get evaluatedAt => throw _privateConstructorUsedError;

  /// Confidence of the match (0.0 - 1.0)
  double get confidence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerEventCopyWith<TriggerEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerEventCopyWith<$Res> {
  factory $TriggerEventCopyWith(
          TriggerEvent value, $Res Function(TriggerEvent) then) =
      _$TriggerEventCopyWithImpl<$Res, TriggerEvent>;
  @useResult
  $Res call(
      {String triggerId,
      String assetId,
      String assetName,
      String assetType,
      Map<String, dynamic> matchedConditions,
      Map<String, dynamic> extractedValues,
      DateTime evaluatedAt,
      double confidence});
}

/// @nodoc
class _$TriggerEventCopyWithImpl<$Res, $Val extends TriggerEvent>
    implements $TriggerEventCopyWith<$Res> {
  _$TriggerEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? triggerId = null,
    Object? assetId = null,
    Object? assetName = null,
    Object? assetType = null,
    Object? matchedConditions = null,
    Object? extractedValues = null,
    Object? evaluatedAt = null,
    Object? confidence = null,
  }) {
    return _then(_value.copyWith(
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      assetName: null == assetName
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _value.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as String,
      matchedConditions: null == matchedConditions
          ? _value.matchedConditions
          : matchedConditions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      extractedValues: null == extractedValues
          ? _value.extractedValues
          : extractedValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      evaluatedAt: null == evaluatedAt
          ? _value.evaluatedAt
          : evaluatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerEventImplCopyWith<$Res>
    implements $TriggerEventCopyWith<$Res> {
  factory _$$TriggerEventImplCopyWith(
          _$TriggerEventImpl value, $Res Function(_$TriggerEventImpl) then) =
      __$$TriggerEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String triggerId,
      String assetId,
      String assetName,
      String assetType,
      Map<String, dynamic> matchedConditions,
      Map<String, dynamic> extractedValues,
      DateTime evaluatedAt,
      double confidence});
}

/// @nodoc
class __$$TriggerEventImplCopyWithImpl<$Res>
    extends _$TriggerEventCopyWithImpl<$Res, _$TriggerEventImpl>
    implements _$$TriggerEventImplCopyWith<$Res> {
  __$$TriggerEventImplCopyWithImpl(
      _$TriggerEventImpl _value, $Res Function(_$TriggerEventImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? triggerId = null,
    Object? assetId = null,
    Object? assetName = null,
    Object? assetType = null,
    Object? matchedConditions = null,
    Object? extractedValues = null,
    Object? evaluatedAt = null,
    Object? confidence = null,
  }) {
    return _then(_$TriggerEventImpl(
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      assetId: null == assetId
          ? _value.assetId
          : assetId // ignore: cast_nullable_to_non_nullable
              as String,
      assetName: null == assetName
          ? _value.assetName
          : assetName // ignore: cast_nullable_to_non_nullable
              as String,
      assetType: null == assetType
          ? _value.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as String,
      matchedConditions: null == matchedConditions
          ? _value._matchedConditions
          : matchedConditions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      extractedValues: null == extractedValues
          ? _value._extractedValues
          : extractedValues // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      evaluatedAt: null == evaluatedAt
          ? _value.evaluatedAt
          : evaluatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerEventImpl implements _TriggerEvent {
  const _$TriggerEventImpl(
      {required this.triggerId,
      required this.assetId,
      required this.assetName,
      required this.assetType,
      required final Map<String, dynamic> matchedConditions,
      required final Map<String, dynamic> extractedValues,
      required this.evaluatedAt,
      this.confidence = 1.0})
      : _matchedConditions = matchedConditions,
        _extractedValues = extractedValues;

  factory _$TriggerEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerEventImplFromJson(json);

  /// ID of the trigger that fired
  @override
  final String triggerId;

  /// ID of the asset that triggered this
  @override
  final String assetId;

  /// Name of the asset for display
  @override
  final String assetName;

  /// Type of asset (host, service, etc.)
  @override
  final String assetType;

  /// The conditions that were matched
  final Map<String, dynamic> _matchedConditions;

  /// The conditions that were matched
  @override
  Map<String, dynamic> get matchedConditions {
    if (_matchedConditions is EqualUnmodifiableMapView)
      return _matchedConditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_matchedConditions);
  }

  /// Values extracted from the trigger evaluation
  final Map<String, dynamic> _extractedValues;

  /// Values extracted from the trigger evaluation
  @override
  Map<String, dynamic> get extractedValues {
    if (_extractedValues is EqualUnmodifiableMapView) return _extractedValues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extractedValues);
  }

  /// When this trigger was evaluated
  @override
  final DateTime evaluatedAt;

  /// Confidence of the match (0.0 - 1.0)
  @override
  @JsonKey()
  final double confidence;

  @override
  String toString() {
    return 'TriggerEvent(triggerId: $triggerId, assetId: $assetId, assetName: $assetName, assetType: $assetType, matchedConditions: $matchedConditions, extractedValues: $extractedValues, evaluatedAt: $evaluatedAt, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerEventImpl &&
            (identical(other.triggerId, triggerId) ||
                other.triggerId == triggerId) &&
            (identical(other.assetId, assetId) || other.assetId == assetId) &&
            (identical(other.assetName, assetName) ||
                other.assetName == assetName) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            const DeepCollectionEquality()
                .equals(other._matchedConditions, _matchedConditions) &&
            const DeepCollectionEquality()
                .equals(other._extractedValues, _extractedValues) &&
            (identical(other.evaluatedAt, evaluatedAt) ||
                other.evaluatedAt == evaluatedAt) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      triggerId,
      assetId,
      assetName,
      assetType,
      const DeepCollectionEquality().hash(_matchedConditions),
      const DeepCollectionEquality().hash(_extractedValues),
      evaluatedAt,
      confidence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerEventImplCopyWith<_$TriggerEventImpl> get copyWith =>
      __$$TriggerEventImplCopyWithImpl<_$TriggerEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerEventImplToJson(
      this,
    );
  }
}

abstract class _TriggerEvent implements TriggerEvent {
  const factory _TriggerEvent(
      {required final String triggerId,
      required final String assetId,
      required final String assetName,
      required final String assetType,
      required final Map<String, dynamic> matchedConditions,
      required final Map<String, dynamic> extractedValues,
      required final DateTime evaluatedAt,
      final double confidence}) = _$TriggerEventImpl;

  factory _TriggerEvent.fromJson(Map<String, dynamic> json) =
      _$TriggerEventImpl.fromJson;

  @override

  /// ID of the trigger that fired
  String get triggerId;
  @override

  /// ID of the asset that triggered this
  String get assetId;
  @override

  /// Name of the asset for display
  String get assetName;
  @override

  /// Type of asset (host, service, etc.)
  String get assetType;
  @override

  /// The conditions that were matched
  Map<String, dynamic> get matchedConditions;
  @override

  /// Values extracted from the trigger evaluation
  Map<String, dynamic> get extractedValues;
  @override

  /// When this trigger was evaluated
  DateTime get evaluatedAt;
  @override

  /// Confidence of the match (0.0 - 1.0)
  double get confidence;
  @override
  @JsonKey(ignore: true)
  _$$TriggerEventImplCopyWith<_$TriggerEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionTool _$ActionToolFromJson(Map<String, dynamic> json) {
  return _ActionTool.fromJson(json);
}

/// @nodoc
mixin _$ActionTool {
  /// Name of the tool
  String get name => throw _privateConstructorUsedError;

  /// Description of what the tool does
  String get description => throw _privateConstructorUsedError;

  /// Installation command or link
  String? get installation => throw _privateConstructorUsedError;

  /// Whether the tool is required or optional
  bool get required => throw _privateConstructorUsedError;

  /// Alternative tools that can be used
  List<String> get alternatives => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionToolCopyWith<ActionTool> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionToolCopyWith<$Res> {
  factory $ActionToolCopyWith(
          ActionTool value, $Res Function(ActionTool) then) =
      _$ActionToolCopyWithImpl<$Res, ActionTool>;
  @useResult
  $Res call(
      {String name,
      String description,
      String? installation,
      bool required,
      List<String> alternatives});
}

/// @nodoc
class _$ActionToolCopyWithImpl<$Res, $Val extends ActionTool>
    implements $ActionToolCopyWith<$Res> {
  _$ActionToolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? installation = freezed,
    Object? required = null,
    Object? alternatives = null,
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
      installation: freezed == installation
          ? _value.installation
          : installation // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      alternatives: null == alternatives
          ? _value.alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionToolImplCopyWith<$Res>
    implements $ActionToolCopyWith<$Res> {
  factory _$$ActionToolImplCopyWith(
          _$ActionToolImpl value, $Res Function(_$ActionToolImpl) then) =
      __$$ActionToolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      String? installation,
      bool required,
      List<String> alternatives});
}

/// @nodoc
class __$$ActionToolImplCopyWithImpl<$Res>
    extends _$ActionToolCopyWithImpl<$Res, _$ActionToolImpl>
    implements _$$ActionToolImplCopyWith<$Res> {
  __$$ActionToolImplCopyWithImpl(
      _$ActionToolImpl _value, $Res Function(_$ActionToolImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? installation = freezed,
    Object? required = null,
    Object? alternatives = null,
  }) {
    return _then(_$ActionToolImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      installation: freezed == installation
          ? _value.installation
          : installation // ignore: cast_nullable_to_non_nullable
              as String?,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      alternatives: null == alternatives
          ? _value._alternatives
          : alternatives // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionToolImpl implements _ActionTool {
  const _$ActionToolImpl(
      {required this.name,
      required this.description,
      this.installation,
      this.required = true,
      final List<String> alternatives = const []})
      : _alternatives = alternatives;

  factory _$ActionToolImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionToolImplFromJson(json);

  /// Name of the tool
  @override
  final String name;

  /// Description of what the tool does
  @override
  final String description;

  /// Installation command or link
  @override
  final String? installation;

  /// Whether the tool is required or optional
  @override
  @JsonKey()
  final bool required;

  /// Alternative tools that can be used
  final List<String> _alternatives;

  /// Alternative tools that can be used
  @override
  @JsonKey()
  List<String> get alternatives {
    if (_alternatives is EqualUnmodifiableListView) return _alternatives;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alternatives);
  }

  @override
  String toString() {
    return 'ActionTool(name: $name, description: $description, installation: $installation, required: $required, alternatives: $alternatives)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionToolImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.installation, installation) ||
                other.installation == installation) &&
            (identical(other.required, required) ||
                other.required == required) &&
            const DeepCollectionEquality()
                .equals(other._alternatives, _alternatives));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, description, installation,
      required, const DeepCollectionEquality().hash(_alternatives));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionToolImplCopyWith<_$ActionToolImpl> get copyWith =>
      __$$ActionToolImplCopyWithImpl<_$ActionToolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionToolImplToJson(
      this,
    );
  }
}

abstract class _ActionTool implements ActionTool {
  const factory _ActionTool(
      {required final String name,
      required final String description,
      final String? installation,
      final bool required,
      final List<String> alternatives}) = _$ActionToolImpl;

  factory _ActionTool.fromJson(Map<String, dynamic> json) =
      _$ActionToolImpl.fromJson;

  @override

  /// Name of the tool
  String get name;
  @override

  /// Description of what the tool does
  String get description;
  @override

  /// Installation command or link
  String? get installation;
  @override

  /// Whether the tool is required or optional
  bool get required;
  @override

  /// Alternative tools that can be used
  List<String> get alternatives;
  @override
  @JsonKey(ignore: true)
  _$$ActionToolImplCopyWith<_$ActionToolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionEquipment _$ActionEquipmentFromJson(Map<String, dynamic> json) {
  return _ActionEquipment.fromJson(json);
}

/// @nodoc
mixin _$ActionEquipment {
  /// Name of the equipment
  String get name => throw _privateConstructorUsedError;

  /// Description of the equipment
  String get description => throw _privateConstructorUsedError;

  /// Whether the equipment is required or optional
  bool get required => throw _privateConstructorUsedError;

  /// Specifications or model details
  String? get specifications => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionEquipmentCopyWith<ActionEquipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionEquipmentCopyWith<$Res> {
  factory $ActionEquipmentCopyWith(
          ActionEquipment value, $Res Function(ActionEquipment) then) =
      _$ActionEquipmentCopyWithImpl<$Res, ActionEquipment>;
  @useResult
  $Res call(
      {String name, String description, bool required, String? specifications});
}

/// @nodoc
class _$ActionEquipmentCopyWithImpl<$Res, $Val extends ActionEquipment>
    implements $ActionEquipmentCopyWith<$Res> {
  _$ActionEquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? required = null,
    Object? specifications = freezed,
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
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionEquipmentImplCopyWith<$Res>
    implements $ActionEquipmentCopyWith<$Res> {
  factory _$$ActionEquipmentImplCopyWith(_$ActionEquipmentImpl value,
          $Res Function(_$ActionEquipmentImpl) then) =
      __$$ActionEquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String description, bool required, String? specifications});
}

/// @nodoc
class __$$ActionEquipmentImplCopyWithImpl<$Res>
    extends _$ActionEquipmentCopyWithImpl<$Res, _$ActionEquipmentImpl>
    implements _$$ActionEquipmentImplCopyWith<$Res> {
  __$$ActionEquipmentImplCopyWithImpl(
      _$ActionEquipmentImpl _value, $Res Function(_$ActionEquipmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? required = null,
    Object? specifications = freezed,
  }) {
    return _then(_$ActionEquipmentImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      required: null == required
          ? _value.required
          : required // ignore: cast_nullable_to_non_nullable
              as bool,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionEquipmentImpl implements _ActionEquipment {
  const _$ActionEquipmentImpl(
      {required this.name,
      required this.description,
      this.required = true,
      this.specifications});

  factory _$ActionEquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionEquipmentImplFromJson(json);

  /// Name of the equipment
  @override
  final String name;

  /// Description of the equipment
  @override
  final String description;

  /// Whether the equipment is required or optional
  @override
  @JsonKey()
  final bool required;

  /// Specifications or model details
  @override
  final String? specifications;

  @override
  String toString() {
    return 'ActionEquipment(name: $name, description: $description, required: $required, specifications: $specifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionEquipmentImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.required, required) ||
                other.required == required) &&
            (identical(other.specifications, specifications) ||
                other.specifications == specifications));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, description, required, specifications);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionEquipmentImplCopyWith<_$ActionEquipmentImpl> get copyWith =>
      __$$ActionEquipmentImplCopyWithImpl<_$ActionEquipmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionEquipmentImplToJson(
      this,
    );
  }
}

abstract class _ActionEquipment implements ActionEquipment {
  const factory _ActionEquipment(
      {required final String name,
      required final String description,
      final bool required,
      final String? specifications}) = _$ActionEquipmentImpl;

  factory _ActionEquipment.fromJson(Map<String, dynamic> json) =
      _$ActionEquipmentImpl.fromJson;

  @override

  /// Name of the equipment
  String get name;
  @override

  /// Description of the equipment
  String get description;
  @override

  /// Whether the equipment is required or optional
  bool get required;
  @override

  /// Specifications or model details
  String? get specifications;
  @override
  @JsonKey(ignore: true)
  _$$ActionEquipmentImplCopyWith<_$ActionEquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionReference _$ActionReferenceFromJson(Map<String, dynamic> json) {
  return _ActionReference.fromJson(json);
}

/// @nodoc
mixin _$ActionReference {
  /// Title of the reference
  String get title => throw _privateConstructorUsedError;

  /// URL or citation
  String get url => throw _privateConstructorUsedError;

  /// Description of what this reference covers
  String? get description => throw _privateConstructorUsedError;

  /// Type of reference (documentation, blog, paper, etc.)
  String get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionReferenceCopyWith<ActionReference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionReferenceCopyWith<$Res> {
  factory $ActionReferenceCopyWith(
          ActionReference value, $Res Function(ActionReference) then) =
      _$ActionReferenceCopyWithImpl<$Res, ActionReference>;
  @useResult
  $Res call({String title, String url, String? description, String type});
}

/// @nodoc
class _$ActionReferenceCopyWithImpl<$Res, $Val extends ActionReference>
    implements $ActionReferenceCopyWith<$Res> {
  _$ActionReferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? description = freezed,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionReferenceImplCopyWith<$Res>
    implements $ActionReferenceCopyWith<$Res> {
  factory _$$ActionReferenceImplCopyWith(_$ActionReferenceImpl value,
          $Res Function(_$ActionReferenceImpl) then) =
      __$$ActionReferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String url, String? description, String type});
}

/// @nodoc
class __$$ActionReferenceImplCopyWithImpl<$Res>
    extends _$ActionReferenceCopyWithImpl<$Res, _$ActionReferenceImpl>
    implements _$$ActionReferenceImplCopyWith<$Res> {
  __$$ActionReferenceImplCopyWithImpl(
      _$ActionReferenceImpl _value, $Res Function(_$ActionReferenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? url = null,
    Object? description = freezed,
    Object? type = null,
  }) {
    return _then(_$ActionReferenceImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionReferenceImpl implements _ActionReference {
  const _$ActionReferenceImpl(
      {required this.title,
      required this.url,
      this.description,
      this.type = 'documentation'});

  factory _$ActionReferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionReferenceImplFromJson(json);

  /// Title of the reference
  @override
  final String title;

  /// URL or citation
  @override
  final String url;

  /// Description of what this reference covers
  @override
  final String? description;

  /// Type of reference (documentation, blog, paper, etc.)
  @override
  @JsonKey()
  final String type;

  @override
  String toString() {
    return 'ActionReference(title: $title, url: $url, description: $description, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionReferenceImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, title, url, description, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionReferenceImplCopyWith<_$ActionReferenceImpl> get copyWith =>
      __$$ActionReferenceImplCopyWithImpl<_$ActionReferenceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionReferenceImplToJson(
      this,
    );
  }
}

abstract class _ActionReference implements ActionReference {
  const factory _ActionReference(
      {required final String title,
      required final String url,
      final String? description,
      final String type}) = _$ActionReferenceImpl;

  factory _ActionReference.fromJson(Map<String, dynamic> json) =
      _$ActionReferenceImpl.fromJson;

  @override

  /// Title of the reference
  String get title;
  @override

  /// URL or citation
  String get url;
  @override

  /// Description of what this reference covers
  String? get description;
  @override

  /// Type of reference (documentation, blog, paper, etc.)
  String get type;
  @override
  @JsonKey(ignore: true)
  _$$ActionReferenceImplCopyWith<_$ActionReferenceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionRisk _$ActionRiskFromJson(Map<String, dynamic> json) {
  return _ActionRisk.fromJson(json);
}

/// @nodoc
mixin _$ActionRisk {
  /// Description of the risk
  String get risk => throw _privateConstructorUsedError;

  /// How to mitigate this risk
  String get mitigation => throw _privateConstructorUsedError;

  /// Severity of the risk
  ActionRiskLevel get severity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionRiskCopyWith<ActionRisk> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionRiskCopyWith<$Res> {
  factory $ActionRiskCopyWith(
          ActionRisk value, $Res Function(ActionRisk) then) =
      _$ActionRiskCopyWithImpl<$Res, ActionRisk>;
  @useResult
  $Res call({String risk, String mitigation, ActionRiskLevel severity});
}

/// @nodoc
class _$ActionRiskCopyWithImpl<$Res, $Val extends ActionRisk>
    implements $ActionRiskCopyWith<$Res> {
  _$ActionRiskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? risk = null,
    Object? mitigation = null,
    Object? severity = null,
  }) {
    return _then(_value.copyWith(
      risk: null == risk
          ? _value.risk
          : risk // ignore: cast_nullable_to_non_nullable
              as String,
      mitigation: null == mitigation
          ? _value.mitigation
          : mitigation // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ActionRiskLevel,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionRiskImplCopyWith<$Res>
    implements $ActionRiskCopyWith<$Res> {
  factory _$$ActionRiskImplCopyWith(
          _$ActionRiskImpl value, $Res Function(_$ActionRiskImpl) then) =
      __$$ActionRiskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String risk, String mitigation, ActionRiskLevel severity});
}

/// @nodoc
class __$$ActionRiskImplCopyWithImpl<$Res>
    extends _$ActionRiskCopyWithImpl<$Res, _$ActionRiskImpl>
    implements _$$ActionRiskImplCopyWith<$Res> {
  __$$ActionRiskImplCopyWithImpl(
      _$ActionRiskImpl _value, $Res Function(_$ActionRiskImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? risk = null,
    Object? mitigation = null,
    Object? severity = null,
  }) {
    return _then(_$ActionRiskImpl(
      risk: null == risk
          ? _value.risk
          : risk // ignore: cast_nullable_to_non_nullable
              as String,
      mitigation: null == mitigation
          ? _value.mitigation
          : mitigation // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ActionRiskLevel,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionRiskImpl implements _ActionRisk {
  const _$ActionRiskImpl(
      {required this.risk,
      required this.mitigation,
      this.severity = ActionRiskLevel.medium});

  factory _$ActionRiskImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionRiskImplFromJson(json);

  /// Description of the risk
  @override
  final String risk;

  /// How to mitigate this risk
  @override
  final String mitigation;

  /// Severity of the risk
  @override
  @JsonKey()
  final ActionRiskLevel severity;

  @override
  String toString() {
    return 'ActionRisk(risk: $risk, mitigation: $mitigation, severity: $severity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionRiskImpl &&
            (identical(other.risk, risk) || other.risk == risk) &&
            (identical(other.mitigation, mitigation) ||
                other.mitigation == mitigation) &&
            (identical(other.severity, severity) ||
                other.severity == severity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, risk, mitigation, severity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionRiskImplCopyWith<_$ActionRiskImpl> get copyWith =>
      __$$ActionRiskImplCopyWithImpl<_$ActionRiskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionRiskImplToJson(
      this,
    );
  }
}

abstract class _ActionRisk implements ActionRisk {
  const factory _ActionRisk(
      {required final String risk,
      required final String mitigation,
      final ActionRiskLevel severity}) = _$ActionRiskImpl;

  factory _ActionRisk.fromJson(Map<String, dynamic> json) =
      _$ActionRiskImpl.fromJson;

  @override

  /// Description of the risk
  String get risk;
  @override

  /// How to mitigate this risk
  String get mitigation;
  @override

  /// Severity of the risk
  ActionRiskLevel get severity;
  @override
  @JsonKey(ignore: true)
  _$$ActionRiskImplCopyWith<_$ActionRiskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ProcedureStep _$ProcedureStepFromJson(Map<String, dynamic> json) {
  return _ProcedureStep.fromJson(json);
}

/// @nodoc
mixin _$ProcedureStep {
  /// Step number
  int get stepNumber => throw _privateConstructorUsedError;

  /// Description of what this step does
  String get description => throw _privateConstructorUsedError;

  /// Command to execute (with placeholders)
  String? get command => throw _privateConstructorUsedError;

  /// Expected output or results
  String? get expectedOutput => throw _privateConstructorUsedError;

  /// Additional notes for this step
  String? get notes => throw _privateConstructorUsedError;

  /// Whether this step is mandatory
  bool get mandatory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProcedureStepCopyWith<ProcedureStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProcedureStepCopyWith<$Res> {
  factory $ProcedureStepCopyWith(
          ProcedureStep value, $Res Function(ProcedureStep) then) =
      _$ProcedureStepCopyWithImpl<$Res, ProcedureStep>;
  @useResult
  $Res call(
      {int stepNumber,
      String description,
      String? command,
      String? expectedOutput,
      String? notes,
      bool mandatory});
}

/// @nodoc
class _$ProcedureStepCopyWithImpl<$Res, $Val extends ProcedureStep>
    implements $ProcedureStepCopyWith<$Res> {
  _$ProcedureStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stepNumber = null,
    Object? description = null,
    Object? command = freezed,
    Object? expectedOutput = freezed,
    Object? notes = freezed,
    Object? mandatory = null,
  }) {
    return _then(_value.copyWith(
      stepNumber: null == stepNumber
          ? _value.stepNumber
          : stepNumber // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedOutput: freezed == expectedOutput
          ? _value.expectedOutput
          : expectedOutput // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mandatory: null == mandatory
          ? _value.mandatory
          : mandatory // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProcedureStepImplCopyWith<$Res>
    implements $ProcedureStepCopyWith<$Res> {
  factory _$$ProcedureStepImplCopyWith(
          _$ProcedureStepImpl value, $Res Function(_$ProcedureStepImpl) then) =
      __$$ProcedureStepImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int stepNumber,
      String description,
      String? command,
      String? expectedOutput,
      String? notes,
      bool mandatory});
}

/// @nodoc
class __$$ProcedureStepImplCopyWithImpl<$Res>
    extends _$ProcedureStepCopyWithImpl<$Res, _$ProcedureStepImpl>
    implements _$$ProcedureStepImplCopyWith<$Res> {
  __$$ProcedureStepImplCopyWithImpl(
      _$ProcedureStepImpl _value, $Res Function(_$ProcedureStepImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stepNumber = null,
    Object? description = null,
    Object? command = freezed,
    Object? expectedOutput = freezed,
    Object? notes = freezed,
    Object? mandatory = null,
  }) {
    return _then(_$ProcedureStepImpl(
      stepNumber: null == stepNumber
          ? _value.stepNumber
          : stepNumber // ignore: cast_nullable_to_non_nullable
              as int,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String?,
      expectedOutput: freezed == expectedOutput
          ? _value.expectedOutput
          : expectedOutput // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      mandatory: null == mandatory
          ? _value.mandatory
          : mandatory // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProcedureStepImpl implements _ProcedureStep {
  const _$ProcedureStepImpl(
      {required this.stepNumber,
      required this.description,
      this.command,
      this.expectedOutput,
      this.notes,
      this.mandatory = true});

  factory _$ProcedureStepImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProcedureStepImplFromJson(json);

  /// Step number
  @override
  final int stepNumber;

  /// Description of what this step does
  @override
  final String description;

  /// Command to execute (with placeholders)
  @override
  final String? command;

  /// Expected output or results
  @override
  final String? expectedOutput;

  /// Additional notes for this step
  @override
  final String? notes;

  /// Whether this step is mandatory
  @override
  @JsonKey()
  final bool mandatory;

  @override
  String toString() {
    return 'ProcedureStep(stepNumber: $stepNumber, description: $description, command: $command, expectedOutput: $expectedOutput, notes: $notes, mandatory: $mandatory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProcedureStepImpl &&
            (identical(other.stepNumber, stepNumber) ||
                other.stepNumber == stepNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.expectedOutput, expectedOutput) ||
                other.expectedOutput == expectedOutput) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.mandatory, mandatory) ||
                other.mandatory == mandatory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, stepNumber, description, command,
      expectedOutput, notes, mandatory);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProcedureStepImplCopyWith<_$ProcedureStepImpl> get copyWith =>
      __$$ProcedureStepImplCopyWithImpl<_$ProcedureStepImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProcedureStepImplToJson(
      this,
    );
  }
}

abstract class _ProcedureStep implements ProcedureStep {
  const factory _ProcedureStep(
      {required final int stepNumber,
      required final String description,
      final String? command,
      final String? expectedOutput,
      final String? notes,
      final bool mandatory}) = _$ProcedureStepImpl;

  factory _ProcedureStep.fromJson(Map<String, dynamic> json) =
      _$ProcedureStepImpl.fromJson;

  @override

  /// Step number
  int get stepNumber;
  @override

  /// Description of what this step does
  String get description;
  @override

  /// Command to execute (with placeholders)
  String? get command;
  @override

  /// Expected output or results
  String? get expectedOutput;
  @override

  /// Additional notes for this step
  String? get notes;
  @override

  /// Whether this step is mandatory
  bool get mandatory;
  @override
  @JsonKey(ignore: true)
  _$$ProcedureStepImplCopyWith<_$ProcedureStepImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SuggestedFinding _$SuggestedFindingFromJson(Map<String, dynamic> json) {
  return _SuggestedFinding.fromJson(json);
}

/// @nodoc
mixin _$SuggestedFinding {
  /// Title of the finding
  String get title => throw _privateConstructorUsedError;

  /// Description of what this finding represents
  String get description => throw _privateConstructorUsedError;

  /// Severity of the finding
  ActionRiskLevel get severity => throw _privateConstructorUsedError;

  /// CVSS score if applicable
  double? get cvssScore => throw _privateConstructorUsedError;

  /// Category of the finding
  String? get category => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SuggestedFindingCopyWith<SuggestedFinding> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestedFindingCopyWith<$Res> {
  factory $SuggestedFindingCopyWith(
          SuggestedFinding value, $Res Function(SuggestedFinding) then) =
      _$SuggestedFindingCopyWithImpl<$Res, SuggestedFinding>;
  @useResult
  $Res call(
      {String title,
      String description,
      ActionRiskLevel severity,
      double? cvssScore,
      String? category});
}

/// @nodoc
class _$SuggestedFindingCopyWithImpl<$Res, $Val extends SuggestedFinding>
    implements $SuggestedFindingCopyWith<$Res> {
  _$SuggestedFindingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? severity = null,
    Object? cvssScore = freezed,
    Object? category = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ActionRiskLevel,
      cvssScore: freezed == cvssScore
          ? _value.cvssScore
          : cvssScore // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestedFindingImplCopyWith<$Res>
    implements $SuggestedFindingCopyWith<$Res> {
  factory _$$SuggestedFindingImplCopyWith(_$SuggestedFindingImpl value,
          $Res Function(_$SuggestedFindingImpl) then) =
      __$$SuggestedFindingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String description,
      ActionRiskLevel severity,
      double? cvssScore,
      String? category});
}

/// @nodoc
class __$$SuggestedFindingImplCopyWithImpl<$Res>
    extends _$SuggestedFindingCopyWithImpl<$Res, _$SuggestedFindingImpl>
    implements _$$SuggestedFindingImplCopyWith<$Res> {
  __$$SuggestedFindingImplCopyWithImpl(_$SuggestedFindingImpl _value,
      $Res Function(_$SuggestedFindingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = null,
    Object? severity = null,
    Object? cvssScore = freezed,
    Object? category = freezed,
  }) {
    return _then(_$SuggestedFindingImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      severity: null == severity
          ? _value.severity
          : severity // ignore: cast_nullable_to_non_nullable
              as ActionRiskLevel,
      cvssScore: freezed == cvssScore
          ? _value.cvssScore
          : cvssScore // ignore: cast_nullable_to_non_nullable
              as double?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestedFindingImpl implements _SuggestedFinding {
  const _$SuggestedFindingImpl(
      {required this.title,
      required this.description,
      this.severity = ActionRiskLevel.medium,
      this.cvssScore,
      this.category});

  factory _$SuggestedFindingImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestedFindingImplFromJson(json);

  /// Title of the finding
  @override
  final String title;

  /// Description of what this finding represents
  @override
  final String description;

  /// Severity of the finding
  @override
  @JsonKey()
  final ActionRiskLevel severity;

  /// CVSS score if applicable
  @override
  final double? cvssScore;

  /// Category of the finding
  @override
  final String? category;

  @override
  String toString() {
    return 'SuggestedFinding(title: $title, description: $description, severity: $severity, cvssScore: $cvssScore, category: $category)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestedFindingImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.cvssScore, cvssScore) ||
                other.cvssScore == cvssScore) &&
            (identical(other.category, category) ||
                other.category == category));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, title, description, severity, cvssScore, category);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestedFindingImplCopyWith<_$SuggestedFindingImpl> get copyWith =>
      __$$SuggestedFindingImplCopyWithImpl<_$SuggestedFindingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestedFindingImplToJson(
      this,
    );
  }
}

abstract class _SuggestedFinding implements SuggestedFinding {
  const factory _SuggestedFinding(
      {required final String title,
      required final String description,
      final ActionRiskLevel severity,
      final double? cvssScore,
      final String? category}) = _$SuggestedFindingImpl;

  factory _SuggestedFinding.fromJson(Map<String, dynamic> json) =
      _$SuggestedFindingImpl.fromJson;

  @override

  /// Title of the finding
  String get title;
  @override

  /// Description of what this finding represents
  String get description;
  @override

  /// Severity of the finding
  ActionRiskLevel get severity;
  @override

  /// CVSS score if applicable
  double? get cvssScore;
  @override

  /// Category of the finding
  String? get category;
  @override
  @JsonKey(ignore: true)
  _$$SuggestedFindingImplCopyWith<_$SuggestedFindingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ActionExecution _$ActionExecutionFromJson(Map<String, dynamic> json) {
  return _ActionExecution.fromJson(json);
}

/// @nodoc
mixin _$ActionExecution {
  /// When execution started
  DateTime? get startedAt => throw _privateConstructorUsedError;

  /// When execution completed
  DateTime? get completedAt => throw _privateConstructorUsedError;

  /// Who executed this action
  String? get executedBy => throw _privateConstructorUsedError;

  /// Commands that were actually run
  List<String> get executedCommands => throw _privateConstructorUsedError;

  /// Outputs captured from execution
  List<String> get capturedOutputs => throw _privateConstructorUsedError;

  /// Evidence files generated
  List<String> get evidenceFiles => throw _privateConstructorUsedError;

  /// Findings discovered during execution
  List<String> get findingIds => throw _privateConstructorUsedError;

  /// Notes added during execution
  String? get executionNotes => throw _privateConstructorUsedError;

  /// Whether this action was successful
  bool? get successful => throw _privateConstructorUsedError;

  /// Error message if execution failed
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActionExecutionCopyWith<ActionExecution> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActionExecutionCopyWith<$Res> {
  factory $ActionExecutionCopyWith(
          ActionExecution value, $Res Function(ActionExecution) then) =
      _$ActionExecutionCopyWithImpl<$Res, ActionExecution>;
  @useResult
  $Res call(
      {DateTime? startedAt,
      DateTime? completedAt,
      String? executedBy,
      List<String> executedCommands,
      List<String> capturedOutputs,
      List<String> evidenceFiles,
      List<String> findingIds,
      String? executionNotes,
      bool? successful,
      String? errorMessage});
}

/// @nodoc
class _$ActionExecutionCopyWithImpl<$Res, $Val extends ActionExecution>
    implements $ActionExecutionCopyWith<$Res> {
  _$ActionExecutionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? executedBy = freezed,
    Object? executedCommands = null,
    Object? capturedOutputs = null,
    Object? evidenceFiles = null,
    Object? findingIds = null,
    Object? executionNotes = freezed,
    Object? successful = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      executedBy: freezed == executedBy
          ? _value.executedBy
          : executedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      executedCommands: null == executedCommands
          ? _value.executedCommands
          : executedCommands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      capturedOutputs: null == capturedOutputs
          ? _value.capturedOutputs
          : capturedOutputs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      evidenceFiles: null == evidenceFiles
          ? _value.evidenceFiles
          : evidenceFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      findingIds: null == findingIds
          ? _value.findingIds
          : findingIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      executionNotes: freezed == executionNotes
          ? _value.executionNotes
          : executionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      successful: freezed == successful
          ? _value.successful
          : successful // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActionExecutionImplCopyWith<$Res>
    implements $ActionExecutionCopyWith<$Res> {
  factory _$$ActionExecutionImplCopyWith(_$ActionExecutionImpl value,
          $Res Function(_$ActionExecutionImpl) then) =
      __$$ActionExecutionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? startedAt,
      DateTime? completedAt,
      String? executedBy,
      List<String> executedCommands,
      List<String> capturedOutputs,
      List<String> evidenceFiles,
      List<String> findingIds,
      String? executionNotes,
      bool? successful,
      String? errorMessage});
}

/// @nodoc
class __$$ActionExecutionImplCopyWithImpl<$Res>
    extends _$ActionExecutionCopyWithImpl<$Res, _$ActionExecutionImpl>
    implements _$$ActionExecutionImplCopyWith<$Res> {
  __$$ActionExecutionImplCopyWithImpl(
      _$ActionExecutionImpl _value, $Res Function(_$ActionExecutionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startedAt = freezed,
    Object? completedAt = freezed,
    Object? executedBy = freezed,
    Object? executedCommands = null,
    Object? capturedOutputs = null,
    Object? evidenceFiles = null,
    Object? findingIds = null,
    Object? executionNotes = freezed,
    Object? successful = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ActionExecutionImpl(
      startedAt: freezed == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      executedBy: freezed == executedBy
          ? _value.executedBy
          : executedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      executedCommands: null == executedCommands
          ? _value._executedCommands
          : executedCommands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      capturedOutputs: null == capturedOutputs
          ? _value._capturedOutputs
          : capturedOutputs // ignore: cast_nullable_to_non_nullable
              as List<String>,
      evidenceFiles: null == evidenceFiles
          ? _value._evidenceFiles
          : evidenceFiles // ignore: cast_nullable_to_non_nullable
              as List<String>,
      findingIds: null == findingIds
          ? _value._findingIds
          : findingIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      executionNotes: freezed == executionNotes
          ? _value.executionNotes
          : executionNotes // ignore: cast_nullable_to_non_nullable
              as String?,
      successful: freezed == successful
          ? _value.successful
          : successful // ignore: cast_nullable_to_non_nullable
              as bool?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActionExecutionImpl implements _ActionExecution {
  const _$ActionExecutionImpl(
      {this.startedAt,
      this.completedAt,
      this.executedBy,
      final List<String> executedCommands = const [],
      final List<String> capturedOutputs = const [],
      final List<String> evidenceFiles = const [],
      final List<String> findingIds = const [],
      this.executionNotes,
      this.successful,
      this.errorMessage})
      : _executedCommands = executedCommands,
        _capturedOutputs = capturedOutputs,
        _evidenceFiles = evidenceFiles,
        _findingIds = findingIds;

  factory _$ActionExecutionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActionExecutionImplFromJson(json);

  /// When execution started
  @override
  final DateTime? startedAt;

  /// When execution completed
  @override
  final DateTime? completedAt;

  /// Who executed this action
  @override
  final String? executedBy;

  /// Commands that were actually run
  final List<String> _executedCommands;

  /// Commands that were actually run
  @override
  @JsonKey()
  List<String> get executedCommands {
    if (_executedCommands is EqualUnmodifiableListView)
      return _executedCommands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_executedCommands);
  }

  /// Outputs captured from execution
  final List<String> _capturedOutputs;

  /// Outputs captured from execution
  @override
  @JsonKey()
  List<String> get capturedOutputs {
    if (_capturedOutputs is EqualUnmodifiableListView) return _capturedOutputs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_capturedOutputs);
  }

  /// Evidence files generated
  final List<String> _evidenceFiles;

  /// Evidence files generated
  @override
  @JsonKey()
  List<String> get evidenceFiles {
    if (_evidenceFiles is EqualUnmodifiableListView) return _evidenceFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evidenceFiles);
  }

  /// Findings discovered during execution
  final List<String> _findingIds;

  /// Findings discovered during execution
  @override
  @JsonKey()
  List<String> get findingIds {
    if (_findingIds is EqualUnmodifiableListView) return _findingIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_findingIds);
  }

  /// Notes added during execution
  @override
  final String? executionNotes;

  /// Whether this action was successful
  @override
  final bool? successful;

  /// Error message if execution failed
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ActionExecution(startedAt: $startedAt, completedAt: $completedAt, executedBy: $executedBy, executedCommands: $executedCommands, capturedOutputs: $capturedOutputs, evidenceFiles: $evidenceFiles, findingIds: $findingIds, executionNotes: $executionNotes, successful: $successful, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActionExecutionImpl &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.executedBy, executedBy) ||
                other.executedBy == executedBy) &&
            const DeepCollectionEquality()
                .equals(other._executedCommands, _executedCommands) &&
            const DeepCollectionEquality()
                .equals(other._capturedOutputs, _capturedOutputs) &&
            const DeepCollectionEquality()
                .equals(other._evidenceFiles, _evidenceFiles) &&
            const DeepCollectionEquality()
                .equals(other._findingIds, _findingIds) &&
            (identical(other.executionNotes, executionNotes) ||
                other.executionNotes == executionNotes) &&
            (identical(other.successful, successful) ||
                other.successful == successful) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startedAt,
      completedAt,
      executedBy,
      const DeepCollectionEquality().hash(_executedCommands),
      const DeepCollectionEquality().hash(_capturedOutputs),
      const DeepCollectionEquality().hash(_evidenceFiles),
      const DeepCollectionEquality().hash(_findingIds),
      executionNotes,
      successful,
      errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActionExecutionImplCopyWith<_$ActionExecutionImpl> get copyWith =>
      __$$ActionExecutionImplCopyWithImpl<_$ActionExecutionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActionExecutionImplToJson(
      this,
    );
  }
}

abstract class _ActionExecution implements ActionExecution {
  const factory _ActionExecution(
      {final DateTime? startedAt,
      final DateTime? completedAt,
      final String? executedBy,
      final List<String> executedCommands,
      final List<String> capturedOutputs,
      final List<String> evidenceFiles,
      final List<String> findingIds,
      final String? executionNotes,
      final bool? successful,
      final String? errorMessage}) = _$ActionExecutionImpl;

  factory _ActionExecution.fromJson(Map<String, dynamic> json) =
      _$ActionExecutionImpl.fromJson;

  @override

  /// When execution started
  DateTime? get startedAt;
  @override

  /// When execution completed
  DateTime? get completedAt;
  @override

  /// Who executed this action
  String? get executedBy;
  @override

  /// Commands that were actually run
  List<String> get executedCommands;
  @override

  /// Outputs captured from execution
  List<String> get capturedOutputs;
  @override

  /// Evidence files generated
  List<String> get evidenceFiles;
  @override

  /// Findings discovered during execution
  List<String> get findingIds;
  @override

  /// Notes added during execution
  String? get executionNotes;
  @override

  /// Whether this action was successful
  bool? get successful;
  @override

  /// Error message if execution failed
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ActionExecutionImplCopyWith<_$ActionExecutionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AttackPlanAction _$AttackPlanActionFromJson(Map<String, dynamic> json) {
  return _AttackPlanAction.fromJson(json);
}

/// @nodoc
mixin _$AttackPlanAction {
  /// Unique identifier
  String get id => throw _privateConstructorUsedError;

  /// Project this action belongs to
  String get projectId => throw _privateConstructorUsedError;

  /// Title of the action (e.g., "Enumerate Installed Software (Windows)")
  String get title => throw _privateConstructorUsedError;

  /// Short summary of what you are trying to achieve and consequences
  String get objective => throw _privateConstructorUsedError;

  /// Current status of the action
  ActionStatus get status => throw _privateConstructorUsedError;

  /// Priority level
  ActionPriority get priority => throw _privateConstructorUsedError;

  /// Risk level of performing this action
  ActionRiskLevel get riskLevel => throw _privateConstructorUsedError;

  /// Trigger events that led to this action being generated
  List<TriggerEvent> get triggerEvents => throw _privateConstructorUsedError;

  /// Risks and their mitigations
  List<ActionRisk> get risks => throw _privateConstructorUsedError;

  /// Step-by-step procedure
  List<ProcedureStep> get procedure => throw _privateConstructorUsedError;

  /// Tools required
  List<ActionTool> get tools => throw _privateConstructorUsedError;

  /// Equipment needed
  List<ActionEquipment> get equipment => throw _privateConstructorUsedError;

  /// References for further reading
  List<ActionReference> get references => throw _privateConstructorUsedError;

  /// Suggested findings from this action
  List<SuggestedFinding> get suggestedFindings =>
      throw _privateConstructorUsedError;

  /// Cleanup steps required after execution
  List<String> get cleanupSteps => throw _privateConstructorUsedError;

  /// Tags for categorization
  List<String> get tags => throw _privateConstructorUsedError;

  /// Execution tracking data
  ActionExecution? get execution => throw _privateConstructorUsedError;

  /// When this action was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When this action was last updated
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Who created this action
  String get createdBy => throw _privateConstructorUsedError;

  /// Template ID this action was generated from
  String? get templateId => throw _privateConstructorUsedError;

  /// Additional metadata
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AttackPlanActionCopyWith<AttackPlanAction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AttackPlanActionCopyWith<$Res> {
  factory $AttackPlanActionCopyWith(
          AttackPlanAction value, $Res Function(AttackPlanAction) then) =
      _$AttackPlanActionCopyWithImpl<$Res, AttackPlanAction>;
  @useResult
  $Res call(
      {String id,
      String projectId,
      String title,
      String objective,
      ActionStatus status,
      ActionPriority priority,
      ActionRiskLevel riskLevel,
      List<TriggerEvent> triggerEvents,
      List<ActionRisk> risks,
      List<ProcedureStep> procedure,
      List<ActionTool> tools,
      List<ActionEquipment> equipment,
      List<ActionReference> references,
      List<SuggestedFinding> suggestedFindings,
      List<String> cleanupSteps,
      List<String> tags,
      ActionExecution? execution,
      DateTime createdAt,
      DateTime? updatedAt,
      String createdBy,
      String? templateId,
      Map<String, dynamic> metadata});

  $ActionExecutionCopyWith<$Res>? get execution;
}

/// @nodoc
class _$AttackPlanActionCopyWithImpl<$Res, $Val extends AttackPlanAction>
    implements $AttackPlanActionCopyWith<$Res> {
  _$AttackPlanActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? title = null,
    Object? objective = null,
    Object? status = null,
    Object? priority = null,
    Object? riskLevel = null,
    Object? triggerEvents = null,
    Object? risks = null,
    Object? procedure = null,
    Object? tools = null,
    Object? equipment = null,
    Object? references = null,
    Object? suggestedFindings = null,
    Object? cleanupSteps = null,
    Object? tags = null,
    Object? execution = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = null,
    Object? templateId = freezed,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ActionStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ActionPriority,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as ActionRiskLevel,
      triggerEvents: null == triggerEvents
          ? _value.triggerEvents
          : triggerEvents // ignore: cast_nullable_to_non_nullable
              as List<TriggerEvent>,
      risks: null == risks
          ? _value.risks
          : risks // ignore: cast_nullable_to_non_nullable
              as List<ActionRisk>,
      procedure: null == procedure
          ? _value.procedure
          : procedure // ignore: cast_nullable_to_non_nullable
              as List<ProcedureStep>,
      tools: null == tools
          ? _value.tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<ActionTool>,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<ActionEquipment>,
      references: null == references
          ? _value.references
          : references // ignore: cast_nullable_to_non_nullable
              as List<ActionReference>,
      suggestedFindings: null == suggestedFindings
          ? _value.suggestedFindings
          : suggestedFindings // ignore: cast_nullable_to_non_nullable
              as List<SuggestedFinding>,
      cleanupSteps: null == cleanupSteps
          ? _value.cleanupSteps
          : cleanupSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      execution: freezed == execution
          ? _value.execution
          : execution // ignore: cast_nullable_to_non_nullable
              as ActionExecution?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ActionExecutionCopyWith<$Res>? get execution {
    if (_value.execution == null) {
      return null;
    }

    return $ActionExecutionCopyWith<$Res>(_value.execution!, (value) {
      return _then(_value.copyWith(execution: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AttackPlanActionImplCopyWith<$Res>
    implements $AttackPlanActionCopyWith<$Res> {
  factory _$$AttackPlanActionImplCopyWith(_$AttackPlanActionImpl value,
          $Res Function(_$AttackPlanActionImpl) then) =
      __$$AttackPlanActionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String projectId,
      String title,
      String objective,
      ActionStatus status,
      ActionPriority priority,
      ActionRiskLevel riskLevel,
      List<TriggerEvent> triggerEvents,
      List<ActionRisk> risks,
      List<ProcedureStep> procedure,
      List<ActionTool> tools,
      List<ActionEquipment> equipment,
      List<ActionReference> references,
      List<SuggestedFinding> suggestedFindings,
      List<String> cleanupSteps,
      List<String> tags,
      ActionExecution? execution,
      DateTime createdAt,
      DateTime? updatedAt,
      String createdBy,
      String? templateId,
      Map<String, dynamic> metadata});

  @override
  $ActionExecutionCopyWith<$Res>? get execution;
}

/// @nodoc
class __$$AttackPlanActionImplCopyWithImpl<$Res>
    extends _$AttackPlanActionCopyWithImpl<$Res, _$AttackPlanActionImpl>
    implements _$$AttackPlanActionImplCopyWith<$Res> {
  __$$AttackPlanActionImplCopyWithImpl(_$AttackPlanActionImpl _value,
      $Res Function(_$AttackPlanActionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projectId = null,
    Object? title = null,
    Object? objective = null,
    Object? status = null,
    Object? priority = null,
    Object? riskLevel = null,
    Object? triggerEvents = null,
    Object? risks = null,
    Object? procedure = null,
    Object? tools = null,
    Object? equipment = null,
    Object? references = null,
    Object? suggestedFindings = null,
    Object? cleanupSteps = null,
    Object? tags = null,
    Object? execution = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? createdBy = null,
    Object? templateId = freezed,
    Object? metadata = null,
  }) {
    return _then(_$AttackPlanActionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      objective: null == objective
          ? _value.objective
          : objective // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ActionStatus,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as ActionPriority,
      riskLevel: null == riskLevel
          ? _value.riskLevel
          : riskLevel // ignore: cast_nullable_to_non_nullable
              as ActionRiskLevel,
      triggerEvents: null == triggerEvents
          ? _value._triggerEvents
          : triggerEvents // ignore: cast_nullable_to_non_nullable
              as List<TriggerEvent>,
      risks: null == risks
          ? _value._risks
          : risks // ignore: cast_nullable_to_non_nullable
              as List<ActionRisk>,
      procedure: null == procedure
          ? _value._procedure
          : procedure // ignore: cast_nullable_to_non_nullable
              as List<ProcedureStep>,
      tools: null == tools
          ? _value._tools
          : tools // ignore: cast_nullable_to_non_nullable
              as List<ActionTool>,
      equipment: null == equipment
          ? _value._equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<ActionEquipment>,
      references: null == references
          ? _value._references
          : references // ignore: cast_nullable_to_non_nullable
              as List<ActionReference>,
      suggestedFindings: null == suggestedFindings
          ? _value._suggestedFindings
          : suggestedFindings // ignore: cast_nullable_to_non_nullable
              as List<SuggestedFinding>,
      cleanupSteps: null == cleanupSteps
          ? _value._cleanupSteps
          : cleanupSteps // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      execution: freezed == execution
          ? _value.execution
          : execution // ignore: cast_nullable_to_non_nullable
              as ActionExecution?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      templateId: freezed == templateId
          ? _value.templateId
          : templateId // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AttackPlanActionImpl implements _AttackPlanAction {
  const _$AttackPlanActionImpl(
      {required this.id,
      required this.projectId,
      required this.title,
      required this.objective,
      this.status = ActionStatus.pending,
      this.priority = ActionPriority.medium,
      this.riskLevel = ActionRiskLevel.medium,
      final List<TriggerEvent> triggerEvents = const [],
      final List<ActionRisk> risks = const [],
      final List<ProcedureStep> procedure = const [],
      final List<ActionTool> tools = const [],
      final List<ActionEquipment> equipment = const [],
      final List<ActionReference> references = const [],
      final List<SuggestedFinding> suggestedFindings = const [],
      final List<String> cleanupSteps = const [],
      final List<String> tags = const [],
      this.execution,
      required this.createdAt,
      this.updatedAt,
      this.createdBy = 'system',
      this.templateId,
      final Map<String, dynamic> metadata = const {}})
      : _triggerEvents = triggerEvents,
        _risks = risks,
        _procedure = procedure,
        _tools = tools,
        _equipment = equipment,
        _references = references,
        _suggestedFindings = suggestedFindings,
        _cleanupSteps = cleanupSteps,
        _tags = tags,
        _metadata = metadata;

  factory _$AttackPlanActionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AttackPlanActionImplFromJson(json);

  /// Unique identifier
  @override
  final String id;

  /// Project this action belongs to
  @override
  final String projectId;

  /// Title of the action (e.g., "Enumerate Installed Software (Windows)")
  @override
  final String title;

  /// Short summary of what you are trying to achieve and consequences
  @override
  final String objective;

  /// Current status of the action
  @override
  @JsonKey()
  final ActionStatus status;

  /// Priority level
  @override
  @JsonKey()
  final ActionPriority priority;

  /// Risk level of performing this action
  @override
  @JsonKey()
  final ActionRiskLevel riskLevel;

  /// Trigger events that led to this action being generated
  final List<TriggerEvent> _triggerEvents;

  /// Trigger events that led to this action being generated
  @override
  @JsonKey()
  List<TriggerEvent> get triggerEvents {
    if (_triggerEvents is EqualUnmodifiableListView) return _triggerEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggerEvents);
  }

  /// Risks and their mitigations
  final List<ActionRisk> _risks;

  /// Risks and their mitigations
  @override
  @JsonKey()
  List<ActionRisk> get risks {
    if (_risks is EqualUnmodifiableListView) return _risks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_risks);
  }

  /// Step-by-step procedure
  final List<ProcedureStep> _procedure;

  /// Step-by-step procedure
  @override
  @JsonKey()
  List<ProcedureStep> get procedure {
    if (_procedure is EqualUnmodifiableListView) return _procedure;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_procedure);
  }

  /// Tools required
  final List<ActionTool> _tools;

  /// Tools required
  @override
  @JsonKey()
  List<ActionTool> get tools {
    if (_tools is EqualUnmodifiableListView) return _tools;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tools);
  }

  /// Equipment needed
  final List<ActionEquipment> _equipment;

  /// Equipment needed
  @override
  @JsonKey()
  List<ActionEquipment> get equipment {
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipment);
  }

  /// References for further reading
  final List<ActionReference> _references;

  /// References for further reading
  @override
  @JsonKey()
  List<ActionReference> get references {
    if (_references is EqualUnmodifiableListView) return _references;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_references);
  }

  /// Suggested findings from this action
  final List<SuggestedFinding> _suggestedFindings;

  /// Suggested findings from this action
  @override
  @JsonKey()
  List<SuggestedFinding> get suggestedFindings {
    if (_suggestedFindings is EqualUnmodifiableListView)
      return _suggestedFindings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestedFindings);
  }

  /// Cleanup steps required after execution
  final List<String> _cleanupSteps;

  /// Cleanup steps required after execution
  @override
  @JsonKey()
  List<String> get cleanupSteps {
    if (_cleanupSteps is EqualUnmodifiableListView) return _cleanupSteps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cleanupSteps);
  }

  /// Tags for categorization
  final List<String> _tags;

  /// Tags for categorization
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Execution tracking data
  @override
  final ActionExecution? execution;

  /// When this action was created
  @override
  final DateTime createdAt;

  /// When this action was last updated
  @override
  final DateTime? updatedAt;

  /// Who created this action
  @override
  @JsonKey()
  final String createdBy;

  /// Template ID this action was generated from
  @override
  final String? templateId;

  /// Additional metadata
  final Map<String, dynamic> _metadata;

  /// Additional metadata
  @override
  @JsonKey()
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'AttackPlanAction(id: $id, projectId: $projectId, title: $title, objective: $objective, status: $status, priority: $priority, riskLevel: $riskLevel, triggerEvents: $triggerEvents, risks: $risks, procedure: $procedure, tools: $tools, equipment: $equipment, references: $references, suggestedFindings: $suggestedFindings, cleanupSteps: $cleanupSteps, tags: $tags, execution: $execution, createdAt: $createdAt, updatedAt: $updatedAt, createdBy: $createdBy, templateId: $templateId, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AttackPlanActionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.objective, objective) ||
                other.objective == objective) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.riskLevel, riskLevel) ||
                other.riskLevel == riskLevel) &&
            const DeepCollectionEquality()
                .equals(other._triggerEvents, _triggerEvents) &&
            const DeepCollectionEquality().equals(other._risks, _risks) &&
            const DeepCollectionEquality()
                .equals(other._procedure, _procedure) &&
            const DeepCollectionEquality().equals(other._tools, _tools) &&
            const DeepCollectionEquality()
                .equals(other._equipment, _equipment) &&
            const DeepCollectionEquality()
                .equals(other._references, _references) &&
            const DeepCollectionEquality()
                .equals(other._suggestedFindings, _suggestedFindings) &&
            const DeepCollectionEquality()
                .equals(other._cleanupSteps, _cleanupSteps) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.execution, execution) ||
                other.execution == execution) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        projectId,
        title,
        objective,
        status,
        priority,
        riskLevel,
        const DeepCollectionEquality().hash(_triggerEvents),
        const DeepCollectionEquality().hash(_risks),
        const DeepCollectionEquality().hash(_procedure),
        const DeepCollectionEquality().hash(_tools),
        const DeepCollectionEquality().hash(_equipment),
        const DeepCollectionEquality().hash(_references),
        const DeepCollectionEquality().hash(_suggestedFindings),
        const DeepCollectionEquality().hash(_cleanupSteps),
        const DeepCollectionEquality().hash(_tags),
        execution,
        createdAt,
        updatedAt,
        createdBy,
        templateId,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AttackPlanActionImplCopyWith<_$AttackPlanActionImpl> get copyWith =>
      __$$AttackPlanActionImplCopyWithImpl<_$AttackPlanActionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AttackPlanActionImplToJson(
      this,
    );
  }
}

abstract class _AttackPlanAction implements AttackPlanAction {
  const factory _AttackPlanAction(
      {required final String id,
      required final String projectId,
      required final String title,
      required final String objective,
      final ActionStatus status,
      final ActionPriority priority,
      final ActionRiskLevel riskLevel,
      final List<TriggerEvent> triggerEvents,
      final List<ActionRisk> risks,
      final List<ProcedureStep> procedure,
      final List<ActionTool> tools,
      final List<ActionEquipment> equipment,
      final List<ActionReference> references,
      final List<SuggestedFinding> suggestedFindings,
      final List<String> cleanupSteps,
      final List<String> tags,
      final ActionExecution? execution,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final String createdBy,
      final String? templateId,
      final Map<String, dynamic> metadata}) = _$AttackPlanActionImpl;

  factory _AttackPlanAction.fromJson(Map<String, dynamic> json) =
      _$AttackPlanActionImpl.fromJson;

  @override

  /// Unique identifier
  String get id;
  @override

  /// Project this action belongs to
  String get projectId;
  @override

  /// Title of the action (e.g., "Enumerate Installed Software (Windows)")
  String get title;
  @override

  /// Short summary of what you are trying to achieve and consequences
  String get objective;
  @override

  /// Current status of the action
  ActionStatus get status;
  @override

  /// Priority level
  ActionPriority get priority;
  @override

  /// Risk level of performing this action
  ActionRiskLevel get riskLevel;
  @override

  /// Trigger events that led to this action being generated
  List<TriggerEvent> get triggerEvents;
  @override

  /// Risks and their mitigations
  List<ActionRisk> get risks;
  @override

  /// Step-by-step procedure
  List<ProcedureStep> get procedure;
  @override

  /// Tools required
  List<ActionTool> get tools;
  @override

  /// Equipment needed
  List<ActionEquipment> get equipment;
  @override

  /// References for further reading
  List<ActionReference> get references;
  @override

  /// Suggested findings from this action
  List<SuggestedFinding> get suggestedFindings;
  @override

  /// Cleanup steps required after execution
  List<String> get cleanupSteps;
  @override

  /// Tags for categorization
  List<String> get tags;
  @override

  /// Execution tracking data
  ActionExecution? get execution;
  @override

  /// When this action was created
  DateTime get createdAt;
  @override

  /// When this action was last updated
  DateTime? get updatedAt;
  @override

  /// Who created this action
  String get createdBy;
  @override

  /// Template ID this action was generated from
  String? get templateId;
  @override

  /// Additional metadata
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$AttackPlanActionImplCopyWith<_$AttackPlanActionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
