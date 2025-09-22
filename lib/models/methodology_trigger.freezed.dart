// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'methodology_trigger.dart';

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
  String get property => throw _privateConstructorUsedError;
  TriggerOperator get operator => throw _privateConstructorUsedError;
  dynamic get value =>
      throw _privateConstructorUsedError; // Can be string, int, bool, list, etc.
  String? get description => throw _privateConstructorUsedError;

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
      {String property,
      TriggerOperator operator,
      dynamic value,
      String? description});
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
    Object? property = null,
    Object? operator = null,
    Object? value = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as TriggerOperator,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
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
      {String property,
      TriggerOperator operator,
      dynamic value,
      String? description});
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
    Object? property = null,
    Object? operator = null,
    Object? value = freezed,
    Object? description = freezed,
  }) {
    return _then(_$TriggerConditionImpl(
      property: null == property
          ? _value.property
          : property // ignore: cast_nullable_to_non_nullable
              as String,
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as TriggerOperator,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as dynamic,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerConditionImpl implements _TriggerCondition {
  const _$TriggerConditionImpl(
      {required this.property,
      required this.operator,
      this.value,
      this.description});

  factory _$TriggerConditionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerConditionImplFromJson(json);

  @override
  final String property;
  @override
  final TriggerOperator operator;
  @override
  final dynamic value;
// Can be string, int, bool, list, etc.
  @override
  final String? description;

  @override
  String toString() {
    return 'TriggerCondition(property: $property, operator: $operator, value: $value, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerConditionImpl &&
            (identical(other.property, property) ||
                other.property == property) &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, property, operator,
      const DeepCollectionEquality().hash(value), description);

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
      {required final String property,
      required final TriggerOperator operator,
      final dynamic value,
      final String? description}) = _$TriggerConditionImpl;

  factory _TriggerCondition.fromJson(Map<String, dynamic> json) =
      _$TriggerConditionImpl.fromJson;

  @override
  String get property;
  @override
  TriggerOperator get operator;
  @override
  dynamic get value;
  @override // Can be string, int, bool, list, etc.
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$TriggerConditionImplCopyWith<_$TriggerConditionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggerConditionGroup _$TriggerConditionGroupFromJson(
    Map<String, dynamic> json) {
  return _TriggerConditionGroup.fromJson(json);
}

/// @nodoc
mixin _$TriggerConditionGroup {
  LogicalOperator get operator => throw _privateConstructorUsedError;
  List<dynamic> get conditions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerConditionGroupCopyWith<TriggerConditionGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerConditionGroupCopyWith<$Res> {
  factory $TriggerConditionGroupCopyWith(TriggerConditionGroup value,
          $Res Function(TriggerConditionGroup) then) =
      _$TriggerConditionGroupCopyWithImpl<$Res, TriggerConditionGroup>;
  @useResult
  $Res call({LogicalOperator operator, List<dynamic> conditions});
}

/// @nodoc
class _$TriggerConditionGroupCopyWithImpl<$Res,
        $Val extends TriggerConditionGroup>
    implements $TriggerConditionGroupCopyWith<$Res> {
  _$TriggerConditionGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operator = null,
    Object? conditions = null,
  }) {
    return _then(_value.copyWith(
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as LogicalOperator,
      conditions: null == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerConditionGroupImplCopyWith<$Res>
    implements $TriggerConditionGroupCopyWith<$Res> {
  factory _$$TriggerConditionGroupImplCopyWith(
          _$TriggerConditionGroupImpl value,
          $Res Function(_$TriggerConditionGroupImpl) then) =
      __$$TriggerConditionGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({LogicalOperator operator, List<dynamic> conditions});
}

/// @nodoc
class __$$TriggerConditionGroupImplCopyWithImpl<$Res>
    extends _$TriggerConditionGroupCopyWithImpl<$Res,
        _$TriggerConditionGroupImpl>
    implements _$$TriggerConditionGroupImplCopyWith<$Res> {
  __$$TriggerConditionGroupImplCopyWithImpl(_$TriggerConditionGroupImpl _value,
      $Res Function(_$TriggerConditionGroupImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operator = null,
    Object? conditions = null,
  }) {
    return _then(_$TriggerConditionGroupImpl(
      operator: null == operator
          ? _value.operator
          : operator // ignore: cast_nullable_to_non_nullable
              as LogicalOperator,
      conditions: null == conditions
          ? _value._conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerConditionGroupImpl implements _TriggerConditionGroup {
  const _$TriggerConditionGroupImpl(
      {required this.operator, required final List<dynamic> conditions})
      : _conditions = conditions;

  factory _$TriggerConditionGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerConditionGroupImplFromJson(json);

  @override
  final LogicalOperator operator;
  final List<dynamic> _conditions;
  @override
  List<dynamic> get conditions {
    if (_conditions is EqualUnmodifiableListView) return _conditions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conditions);
  }

  @override
  String toString() {
    return 'TriggerConditionGroup(operator: $operator, conditions: $conditions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerConditionGroupImpl &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            const DeepCollectionEquality()
                .equals(other._conditions, _conditions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, operator, const DeepCollectionEquality().hash(_conditions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerConditionGroupImplCopyWith<_$TriggerConditionGroupImpl>
      get copyWith => __$$TriggerConditionGroupImplCopyWithImpl<
          _$TriggerConditionGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerConditionGroupImplToJson(
      this,
    );
  }
}

abstract class _TriggerConditionGroup implements TriggerConditionGroup {
  const factory _TriggerConditionGroup(
      {required final LogicalOperator operator,
      required final List<dynamic> conditions}) = _$TriggerConditionGroupImpl;

  factory _TriggerConditionGroup.fromJson(Map<String, dynamic> json) =
      _$TriggerConditionGroupImpl.fromJson;

  @override
  LogicalOperator get operator;
  @override
  List<dynamic> get conditions;
  @override
  @JsonKey(ignore: true)
  _$$TriggerConditionGroupImplCopyWith<_$TriggerConditionGroupImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MethodologyTrigger _$MethodologyTriggerFromJson(Map<String, dynamic> json) {
  return _MethodologyTrigger.fromJson(json);
}

/// @nodoc
mixin _$MethodologyTrigger {
  String get id => throw _privateConstructorUsedError;
  String get methodologyId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Asset type this trigger applies to
  AssetType get assetType =>
      throw _privateConstructorUsedError; // Trigger conditions (can be simple or complex)
  dynamic get conditions =>
      throw _privateConstructorUsedError; // TriggerCondition or TriggerConditionGroup
// Priority for ordering triggers
  int get priority =>
      throw _privateConstructorUsedError; // Batch processing configuration
  bool get batchCapable => throw _privateConstructorUsedError;
  String? get batchCriteria =>
      throw _privateConstructorUsedError; // Property to group by for batching
  String? get batchCommand =>
      throw _privateConstructorUsedError; // Template for batch command
  int? get maxBatchSize => throw _privateConstructorUsedError; // Deduplication
  String get deduplicationKeyTemplate =>
      throw _privateConstructorUsedError; // e.g., "{asset.id}:{methodology}:{hash}"
  Duration? get cooldownPeriod =>
      throw _privateConstructorUsedError; // Don't retrigger within this period
// Command templates
  String? get individualCommand =>
      throw _privateConstructorUsedError; // Command for single asset
  Map<String, String>? get commandVariants =>
      throw _privateConstructorUsedError; // Different commands for different conditions
// Expected outcomes
  List<String>? get expectedPropertyUpdates =>
      throw _privateConstructorUsedError; // Properties that should be updated
  List<AssetType>? get expectedAssetDiscovery =>
      throw _privateConstructorUsedError; // Types of assets that might be discovered
// Metadata
  List<String> get tags => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MethodologyTriggerCopyWith<MethodologyTrigger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MethodologyTriggerCopyWith<$Res> {
  factory $MethodologyTriggerCopyWith(
          MethodologyTrigger value, $Res Function(MethodologyTrigger) then) =
      _$MethodologyTriggerCopyWithImpl<$Res, MethodologyTrigger>;
  @useResult
  $Res call(
      {String id,
      String methodologyId,
      String name,
      String? description,
      AssetType assetType,
      dynamic conditions,
      int priority,
      bool batchCapable,
      String? batchCriteria,
      String? batchCommand,
      int? maxBatchSize,
      String deduplicationKeyTemplate,
      Duration? cooldownPeriod,
      String? individualCommand,
      Map<String, String>? commandVariants,
      List<String>? expectedPropertyUpdates,
      List<AssetType>? expectedAssetDiscovery,
      List<String> tags,
      bool enabled});
}

/// @nodoc
class _$MethodologyTriggerCopyWithImpl<$Res, $Val extends MethodologyTrigger>
    implements $MethodologyTriggerCopyWith<$Res> {
  _$MethodologyTriggerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? methodologyId = null,
    Object? name = null,
    Object? description = freezed,
    Object? assetType = null,
    Object? conditions = freezed,
    Object? priority = null,
    Object? batchCapable = null,
    Object? batchCriteria = freezed,
    Object? batchCommand = freezed,
    Object? maxBatchSize = freezed,
    Object? deduplicationKeyTemplate = null,
    Object? cooldownPeriod = freezed,
    Object? individualCommand = freezed,
    Object? commandVariants = freezed,
    Object? expectedPropertyUpdates = freezed,
    Object? expectedAssetDiscovery = freezed,
    Object? tags = null,
    Object? enabled = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      assetType: null == assetType
          ? _value.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as AssetType,
      conditions: freezed == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as dynamic,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      batchCapable: null == batchCapable
          ? _value.batchCapable
          : batchCapable // ignore: cast_nullable_to_non_nullable
              as bool,
      batchCriteria: freezed == batchCriteria
          ? _value.batchCriteria
          : batchCriteria // ignore: cast_nullable_to_non_nullable
              as String?,
      batchCommand: freezed == batchCommand
          ? _value.batchCommand
          : batchCommand // ignore: cast_nullable_to_non_nullable
              as String?,
      maxBatchSize: freezed == maxBatchSize
          ? _value.maxBatchSize
          : maxBatchSize // ignore: cast_nullable_to_non_nullable
              as int?,
      deduplicationKeyTemplate: null == deduplicationKeyTemplate
          ? _value.deduplicationKeyTemplate
          : deduplicationKeyTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      cooldownPeriod: freezed == cooldownPeriod
          ? _value.cooldownPeriod
          : cooldownPeriod // ignore: cast_nullable_to_non_nullable
              as Duration?,
      individualCommand: freezed == individualCommand
          ? _value.individualCommand
          : individualCommand // ignore: cast_nullable_to_non_nullable
              as String?,
      commandVariants: freezed == commandVariants
          ? _value.commandVariants
          : commandVariants // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      expectedPropertyUpdates: freezed == expectedPropertyUpdates
          ? _value.expectedPropertyUpdates
          : expectedPropertyUpdates // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      expectedAssetDiscovery: freezed == expectedAssetDiscovery
          ? _value.expectedAssetDiscovery
          : expectedAssetDiscovery // ignore: cast_nullable_to_non_nullable
              as List<AssetType>?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MethodologyTriggerImplCopyWith<$Res>
    implements $MethodologyTriggerCopyWith<$Res> {
  factory _$$MethodologyTriggerImplCopyWith(_$MethodologyTriggerImpl value,
          $Res Function(_$MethodologyTriggerImpl) then) =
      __$$MethodologyTriggerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String methodologyId,
      String name,
      String? description,
      AssetType assetType,
      dynamic conditions,
      int priority,
      bool batchCapable,
      String? batchCriteria,
      String? batchCommand,
      int? maxBatchSize,
      String deduplicationKeyTemplate,
      Duration? cooldownPeriod,
      String? individualCommand,
      Map<String, String>? commandVariants,
      List<String>? expectedPropertyUpdates,
      List<AssetType>? expectedAssetDiscovery,
      List<String> tags,
      bool enabled});
}

/// @nodoc
class __$$MethodologyTriggerImplCopyWithImpl<$Res>
    extends _$MethodologyTriggerCopyWithImpl<$Res, _$MethodologyTriggerImpl>
    implements _$$MethodologyTriggerImplCopyWith<$Res> {
  __$$MethodologyTriggerImplCopyWithImpl(_$MethodologyTriggerImpl _value,
      $Res Function(_$MethodologyTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? methodologyId = null,
    Object? name = null,
    Object? description = freezed,
    Object? assetType = null,
    Object? conditions = freezed,
    Object? priority = null,
    Object? batchCapable = null,
    Object? batchCriteria = freezed,
    Object? batchCommand = freezed,
    Object? maxBatchSize = freezed,
    Object? deduplicationKeyTemplate = null,
    Object? cooldownPeriod = freezed,
    Object? individualCommand = freezed,
    Object? commandVariants = freezed,
    Object? expectedPropertyUpdates = freezed,
    Object? expectedAssetDiscovery = freezed,
    Object? tags = null,
    Object? enabled = null,
  }) {
    return _then(_$MethodologyTriggerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      assetType: null == assetType
          ? _value.assetType
          : assetType // ignore: cast_nullable_to_non_nullable
              as AssetType,
      conditions: freezed == conditions
          ? _value.conditions
          : conditions // ignore: cast_nullable_to_non_nullable
              as dynamic,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      batchCapable: null == batchCapable
          ? _value.batchCapable
          : batchCapable // ignore: cast_nullable_to_non_nullable
              as bool,
      batchCriteria: freezed == batchCriteria
          ? _value.batchCriteria
          : batchCriteria // ignore: cast_nullable_to_non_nullable
              as String?,
      batchCommand: freezed == batchCommand
          ? _value.batchCommand
          : batchCommand // ignore: cast_nullable_to_non_nullable
              as String?,
      maxBatchSize: freezed == maxBatchSize
          ? _value.maxBatchSize
          : maxBatchSize // ignore: cast_nullable_to_non_nullable
              as int?,
      deduplicationKeyTemplate: null == deduplicationKeyTemplate
          ? _value.deduplicationKeyTemplate
          : deduplicationKeyTemplate // ignore: cast_nullable_to_non_nullable
              as String,
      cooldownPeriod: freezed == cooldownPeriod
          ? _value.cooldownPeriod
          : cooldownPeriod // ignore: cast_nullable_to_non_nullable
              as Duration?,
      individualCommand: freezed == individualCommand
          ? _value.individualCommand
          : individualCommand // ignore: cast_nullable_to_non_nullable
              as String?,
      commandVariants: freezed == commandVariants
          ? _value._commandVariants
          : commandVariants // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      expectedPropertyUpdates: freezed == expectedPropertyUpdates
          ? _value._expectedPropertyUpdates
          : expectedPropertyUpdates // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      expectedAssetDiscovery: freezed == expectedAssetDiscovery
          ? _value._expectedAssetDiscovery
          : expectedAssetDiscovery // ignore: cast_nullable_to_non_nullable
              as List<AssetType>?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MethodologyTriggerImpl implements _MethodologyTrigger {
  const _$MethodologyTriggerImpl(
      {required this.id,
      required this.methodologyId,
      required this.name,
      this.description,
      required this.assetType,
      required this.conditions,
      required this.priority,
      required this.batchCapable,
      this.batchCriteria,
      this.batchCommand,
      this.maxBatchSize,
      required this.deduplicationKeyTemplate,
      this.cooldownPeriod,
      this.individualCommand,
      final Map<String, String>? commandVariants,
      final List<String>? expectedPropertyUpdates,
      final List<AssetType>? expectedAssetDiscovery,
      required final List<String> tags,
      required this.enabled})
      : _commandVariants = commandVariants,
        _expectedPropertyUpdates = expectedPropertyUpdates,
        _expectedAssetDiscovery = expectedAssetDiscovery,
        _tags = tags;

  factory _$MethodologyTriggerImpl.fromJson(Map<String, dynamic> json) =>
      _$$MethodologyTriggerImplFromJson(json);

  @override
  final String id;
  @override
  final String methodologyId;
  @override
  final String name;
  @override
  final String? description;
// Asset type this trigger applies to
  @override
  final AssetType assetType;
// Trigger conditions (can be simple or complex)
  @override
  final dynamic conditions;
// TriggerCondition or TriggerConditionGroup
// Priority for ordering triggers
  @override
  final int priority;
// Batch processing configuration
  @override
  final bool batchCapable;
  @override
  final String? batchCriteria;
// Property to group by for batching
  @override
  final String? batchCommand;
// Template for batch command
  @override
  final int? maxBatchSize;
// Deduplication
  @override
  final String deduplicationKeyTemplate;
// e.g., "{asset.id}:{methodology}:{hash}"
  @override
  final Duration? cooldownPeriod;
// Don't retrigger within this period
// Command templates
  @override
  final String? individualCommand;
// Command for single asset
  final Map<String, String>? _commandVariants;
// Command for single asset
  @override
  Map<String, String>? get commandVariants {
    final value = _commandVariants;
    if (value == null) return null;
    if (_commandVariants is EqualUnmodifiableMapView) return _commandVariants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Different commands for different conditions
// Expected outcomes
  final List<String>? _expectedPropertyUpdates;
// Different commands for different conditions
// Expected outcomes
  @override
  List<String>? get expectedPropertyUpdates {
    final value = _expectedPropertyUpdates;
    if (value == null) return null;
    if (_expectedPropertyUpdates is EqualUnmodifiableListView)
      return _expectedPropertyUpdates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Properties that should be updated
  final List<AssetType>? _expectedAssetDiscovery;
// Properties that should be updated
  @override
  List<AssetType>? get expectedAssetDiscovery {
    final value = _expectedAssetDiscovery;
    if (value == null) return null;
    if (_expectedAssetDiscovery is EqualUnmodifiableListView)
      return _expectedAssetDiscovery;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Types of assets that might be discovered
// Metadata
  final List<String> _tags;
// Types of assets that might be discovered
// Metadata
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final bool enabled;

  @override
  String toString() {
    return 'MethodologyTrigger(id: $id, methodologyId: $methodologyId, name: $name, description: $description, assetType: $assetType, conditions: $conditions, priority: $priority, batchCapable: $batchCapable, batchCriteria: $batchCriteria, batchCommand: $batchCommand, maxBatchSize: $maxBatchSize, deduplicationKeyTemplate: $deduplicationKeyTemplate, cooldownPeriod: $cooldownPeriod, individualCommand: $individualCommand, commandVariants: $commandVariants, expectedPropertyUpdates: $expectedPropertyUpdates, expectedAssetDiscovery: $expectedAssetDiscovery, tags: $tags, enabled: $enabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MethodologyTriggerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.methodologyId, methodologyId) ||
                other.methodologyId == methodologyId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.assetType, assetType) ||
                other.assetType == assetType) &&
            const DeepCollectionEquality()
                .equals(other.conditions, conditions) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.batchCapable, batchCapable) ||
                other.batchCapable == batchCapable) &&
            (identical(other.batchCriteria, batchCriteria) ||
                other.batchCriteria == batchCriteria) &&
            (identical(other.batchCommand, batchCommand) ||
                other.batchCommand == batchCommand) &&
            (identical(other.maxBatchSize, maxBatchSize) ||
                other.maxBatchSize == maxBatchSize) &&
            (identical(
                    other.deduplicationKeyTemplate, deduplicationKeyTemplate) ||
                other.deduplicationKeyTemplate == deduplicationKeyTemplate) &&
            (identical(other.cooldownPeriod, cooldownPeriod) ||
                other.cooldownPeriod == cooldownPeriod) &&
            (identical(other.individualCommand, individualCommand) ||
                other.individualCommand == individualCommand) &&
            const DeepCollectionEquality()
                .equals(other._commandVariants, _commandVariants) &&
            const DeepCollectionEquality().equals(
                other._expectedPropertyUpdates, _expectedPropertyUpdates) &&
            const DeepCollectionEquality().equals(
                other._expectedAssetDiscovery, _expectedAssetDiscovery) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        methodologyId,
        name,
        description,
        assetType,
        const DeepCollectionEquality().hash(conditions),
        priority,
        batchCapable,
        batchCriteria,
        batchCommand,
        maxBatchSize,
        deduplicationKeyTemplate,
        cooldownPeriod,
        individualCommand,
        const DeepCollectionEquality().hash(_commandVariants),
        const DeepCollectionEquality().hash(_expectedPropertyUpdates),
        const DeepCollectionEquality().hash(_expectedAssetDiscovery),
        const DeepCollectionEquality().hash(_tags),
        enabled
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MethodologyTriggerImplCopyWith<_$MethodologyTriggerImpl> get copyWith =>
      __$$MethodologyTriggerImplCopyWithImpl<_$MethodologyTriggerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MethodologyTriggerImplToJson(
      this,
    );
  }
}

abstract class _MethodologyTrigger implements MethodologyTrigger {
  const factory _MethodologyTrigger(
      {required final String id,
      required final String methodologyId,
      required final String name,
      final String? description,
      required final AssetType assetType,
      required final dynamic conditions,
      required final int priority,
      required final bool batchCapable,
      final String? batchCriteria,
      final String? batchCommand,
      final int? maxBatchSize,
      required final String deduplicationKeyTemplate,
      final Duration? cooldownPeriod,
      final String? individualCommand,
      final Map<String, String>? commandVariants,
      final List<String>? expectedPropertyUpdates,
      final List<AssetType>? expectedAssetDiscovery,
      required final List<String> tags,
      required final bool enabled}) = _$MethodologyTriggerImpl;

  factory _MethodologyTrigger.fromJson(Map<String, dynamic> json) =
      _$MethodologyTriggerImpl.fromJson;

  @override
  String get id;
  @override
  String get methodologyId;
  @override
  String get name;
  @override
  String? get description;
  @override // Asset type this trigger applies to
  AssetType get assetType;
  @override // Trigger conditions (can be simple or complex)
  dynamic get conditions;
  @override // TriggerCondition or TriggerConditionGroup
// Priority for ordering triggers
  int get priority;
  @override // Batch processing configuration
  bool get batchCapable;
  @override
  String? get batchCriteria;
  @override // Property to group by for batching
  String? get batchCommand;
  @override // Template for batch command
  int? get maxBatchSize;
  @override // Deduplication
  String get deduplicationKeyTemplate;
  @override // e.g., "{asset.id}:{methodology}:{hash}"
  Duration? get cooldownPeriod;
  @override // Don't retrigger within this period
// Command templates
  String? get individualCommand;
  @override // Command for single asset
  Map<String, String>? get commandVariants;
  @override // Different commands for different conditions
// Expected outcomes
  List<String>? get expectedPropertyUpdates;
  @override // Properties that should be updated
  List<AssetType>? get expectedAssetDiscovery;
  @override // Types of assets that might be discovered
// Metadata
  List<String> get tags;
  @override
  bool get enabled;
  @override
  @JsonKey(ignore: true)
  _$$MethodologyTriggerImplCopyWith<_$MethodologyTriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggeredMethodology _$TriggeredMethodologyFromJson(Map<String, dynamic> json) {
  return _TriggeredMethodology.fromJson(json);
}

/// @nodoc
mixin _$TriggeredMethodology {
  String get id => throw _privateConstructorUsedError;
  String get methodologyId => throw _privateConstructorUsedError;
  String get triggerId => throw _privateConstructorUsedError;
  Asset get asset => throw _privateConstructorUsedError;
  String get deduplicationKey =>
      throw _privateConstructorUsedError; // Execution context
  Map<String, dynamic> get variables =>
      throw _privateConstructorUsedError; // Variables extracted from asset properties
  String? get command =>
      throw _privateConstructorUsedError; // Resolved command with variables substituted
// Batch information
  bool? get isPartOfBatch => throw _privateConstructorUsedError;
  String? get batchId => throw _privateConstructorUsedError;
  List<Asset>? get batchAssets =>
      throw _privateConstructorUsedError; // Other assets in the same batch
// Status
  DateTime get triggeredAt => throw _privateConstructorUsedError;
  DateTime? get executedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get status =>
      throw _privateConstructorUsedError; // "pending", "executing", "completed", "failed", "skipped"
// Priority
  int get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggeredMethodologyCopyWith<TriggeredMethodology> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggeredMethodologyCopyWith<$Res> {
  factory $TriggeredMethodologyCopyWith(TriggeredMethodology value,
          $Res Function(TriggeredMethodology) then) =
      _$TriggeredMethodologyCopyWithImpl<$Res, TriggeredMethodology>;
  @useResult
  $Res call(
      {String id,
      String methodologyId,
      String triggerId,
      Asset asset,
      String deduplicationKey,
      Map<String, dynamic> variables,
      String? command,
      bool? isPartOfBatch,
      String? batchId,
      List<Asset>? batchAssets,
      DateTime triggeredAt,
      DateTime? executedAt,
      DateTime? completedAt,
      String? status,
      int priority});

  $AssetCopyWith<$Res> get asset;
}

/// @nodoc
class _$TriggeredMethodologyCopyWithImpl<$Res,
        $Val extends TriggeredMethodology>
    implements $TriggeredMethodologyCopyWith<$Res> {
  _$TriggeredMethodologyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? methodologyId = null,
    Object? triggerId = null,
    Object? asset = null,
    Object? deduplicationKey = null,
    Object? variables = null,
    Object? command = freezed,
    Object? isPartOfBatch = freezed,
    Object? batchId = freezed,
    Object? batchAssets = freezed,
    Object? triggeredAt = null,
    Object? executedAt = freezed,
    Object? completedAt = freezed,
    Object? status = freezed,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as Asset,
      deduplicationKey: null == deduplicationKey
          ? _value.deduplicationKey
          : deduplicationKey // ignore: cast_nullable_to_non_nullable
              as String,
      variables: null == variables
          ? _value.variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String?,
      isPartOfBatch: freezed == isPartOfBatch
          ? _value.isPartOfBatch
          : isPartOfBatch // ignore: cast_nullable_to_non_nullable
              as bool?,
      batchId: freezed == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String?,
      batchAssets: freezed == batchAssets
          ? _value.batchAssets
          : batchAssets // ignore: cast_nullable_to_non_nullable
              as List<Asset>?,
      triggeredAt: null == triggeredAt
          ? _value.triggeredAt
          : triggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $AssetCopyWith<$Res> get asset {
    return $AssetCopyWith<$Res>(_value.asset, (value) {
      return _then(_value.copyWith(asset: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TriggeredMethodologyImplCopyWith<$Res>
    implements $TriggeredMethodologyCopyWith<$Res> {
  factory _$$TriggeredMethodologyImplCopyWith(_$TriggeredMethodologyImpl value,
          $Res Function(_$TriggeredMethodologyImpl) then) =
      __$$TriggeredMethodologyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String methodologyId,
      String triggerId,
      Asset asset,
      String deduplicationKey,
      Map<String, dynamic> variables,
      String? command,
      bool? isPartOfBatch,
      String? batchId,
      List<Asset>? batchAssets,
      DateTime triggeredAt,
      DateTime? executedAt,
      DateTime? completedAt,
      String? status,
      int priority});

  @override
  $AssetCopyWith<$Res> get asset;
}

/// @nodoc
class __$$TriggeredMethodologyImplCopyWithImpl<$Res>
    extends _$TriggeredMethodologyCopyWithImpl<$Res, _$TriggeredMethodologyImpl>
    implements _$$TriggeredMethodologyImplCopyWith<$Res> {
  __$$TriggeredMethodologyImplCopyWithImpl(_$TriggeredMethodologyImpl _value,
      $Res Function(_$TriggeredMethodologyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? methodologyId = null,
    Object? triggerId = null,
    Object? asset = null,
    Object? deduplicationKey = null,
    Object? variables = null,
    Object? command = freezed,
    Object? isPartOfBatch = freezed,
    Object? batchId = freezed,
    Object? batchAssets = freezed,
    Object? triggeredAt = null,
    Object? executedAt = freezed,
    Object? completedAt = freezed,
    Object? status = freezed,
    Object? priority = null,
  }) {
    return _then(_$TriggeredMethodologyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as Asset,
      deduplicationKey: null == deduplicationKey
          ? _value.deduplicationKey
          : deduplicationKey // ignore: cast_nullable_to_non_nullable
              as String,
      variables: null == variables
          ? _value._variables
          : variables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String?,
      isPartOfBatch: freezed == isPartOfBatch
          ? _value.isPartOfBatch
          : isPartOfBatch // ignore: cast_nullable_to_non_nullable
              as bool?,
      batchId: freezed == batchId
          ? _value.batchId
          : batchId // ignore: cast_nullable_to_non_nullable
              as String?,
      batchAssets: freezed == batchAssets
          ? _value._batchAssets
          : batchAssets // ignore: cast_nullable_to_non_nullable
              as List<Asset>?,
      triggeredAt: null == triggeredAt
          ? _value.triggeredAt
          : triggeredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      executedAt: freezed == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggeredMethodologyImpl implements _TriggeredMethodology {
  const _$TriggeredMethodologyImpl(
      {required this.id,
      required this.methodologyId,
      required this.triggerId,
      required this.asset,
      required this.deduplicationKey,
      required final Map<String, dynamic> variables,
      this.command,
      this.isPartOfBatch,
      this.batchId,
      final List<Asset>? batchAssets,
      required this.triggeredAt,
      this.executedAt,
      this.completedAt,
      this.status,
      required this.priority})
      : _variables = variables,
        _batchAssets = batchAssets;

  factory _$TriggeredMethodologyImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggeredMethodologyImplFromJson(json);

  @override
  final String id;
  @override
  final String methodologyId;
  @override
  final String triggerId;
  @override
  final Asset asset;
  @override
  final String deduplicationKey;
// Execution context
  final Map<String, dynamic> _variables;
// Execution context
  @override
  Map<String, dynamic> get variables {
    if (_variables is EqualUnmodifiableMapView) return _variables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_variables);
  }

// Variables extracted from asset properties
  @override
  final String? command;
// Resolved command with variables substituted
// Batch information
  @override
  final bool? isPartOfBatch;
  @override
  final String? batchId;
  final List<Asset>? _batchAssets;
  @override
  List<Asset>? get batchAssets {
    final value = _batchAssets;
    if (value == null) return null;
    if (_batchAssets is EqualUnmodifiableListView) return _batchAssets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Other assets in the same batch
// Status
  @override
  final DateTime triggeredAt;
  @override
  final DateTime? executedAt;
  @override
  final DateTime? completedAt;
  @override
  final String? status;
// "pending", "executing", "completed", "failed", "skipped"
// Priority
  @override
  final int priority;

  @override
  String toString() {
    return 'TriggeredMethodology(id: $id, methodologyId: $methodologyId, triggerId: $triggerId, asset: $asset, deduplicationKey: $deduplicationKey, variables: $variables, command: $command, isPartOfBatch: $isPartOfBatch, batchId: $batchId, batchAssets: $batchAssets, triggeredAt: $triggeredAt, executedAt: $executedAt, completedAt: $completedAt, status: $status, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggeredMethodologyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.methodologyId, methodologyId) ||
                other.methodologyId == methodologyId) &&
            (identical(other.triggerId, triggerId) ||
                other.triggerId == triggerId) &&
            (identical(other.asset, asset) || other.asset == asset) &&
            (identical(other.deduplicationKey, deduplicationKey) ||
                other.deduplicationKey == deduplicationKey) &&
            const DeepCollectionEquality()
                .equals(other._variables, _variables) &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.isPartOfBatch, isPartOfBatch) ||
                other.isPartOfBatch == isPartOfBatch) &&
            (identical(other.batchId, batchId) || other.batchId == batchId) &&
            const DeepCollectionEquality()
                .equals(other._batchAssets, _batchAssets) &&
            (identical(other.triggeredAt, triggeredAt) ||
                other.triggeredAt == triggeredAt) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      methodologyId,
      triggerId,
      asset,
      deduplicationKey,
      const DeepCollectionEquality().hash(_variables),
      command,
      isPartOfBatch,
      batchId,
      const DeepCollectionEquality().hash(_batchAssets),
      triggeredAt,
      executedAt,
      completedAt,
      status,
      priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggeredMethodologyImplCopyWith<_$TriggeredMethodologyImpl>
      get copyWith =>
          __$$TriggeredMethodologyImplCopyWithImpl<_$TriggeredMethodologyImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggeredMethodologyImplToJson(
      this,
    );
  }
}

abstract class _TriggeredMethodology implements TriggeredMethodology {
  const factory _TriggeredMethodology(
      {required final String id,
      required final String methodologyId,
      required final String triggerId,
      required final Asset asset,
      required final String deduplicationKey,
      required final Map<String, dynamic> variables,
      final String? command,
      final bool? isPartOfBatch,
      final String? batchId,
      final List<Asset>? batchAssets,
      required final DateTime triggeredAt,
      final DateTime? executedAt,
      final DateTime? completedAt,
      final String? status,
      required final int priority}) = _$TriggeredMethodologyImpl;

  factory _TriggeredMethodology.fromJson(Map<String, dynamic> json) =
      _$TriggeredMethodologyImpl.fromJson;

  @override
  String get id;
  @override
  String get methodologyId;
  @override
  String get triggerId;
  @override
  Asset get asset;
  @override
  String get deduplicationKey;
  @override // Execution context
  Map<String, dynamic> get variables;
  @override // Variables extracted from asset properties
  String? get command;
  @override // Resolved command with variables substituted
// Batch information
  bool? get isPartOfBatch;
  @override
  String? get batchId;
  @override
  List<Asset>? get batchAssets;
  @override // Other assets in the same batch
// Status
  DateTime get triggeredAt;
  @override
  DateTime? get executedAt;
  @override
  DateTime? get completedAt;
  @override
  String? get status;
  @override // "pending", "executing", "completed", "failed", "skipped"
// Priority
  int get priority;
  @override
  @JsonKey(ignore: true)
  _$$TriggeredMethodologyImplCopyWith<_$TriggeredMethodologyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BatchedTrigger _$BatchedTriggerFromJson(Map<String, dynamic> json) {
  return _BatchedTrigger.fromJson(json);
}

/// @nodoc
mixin _$BatchedTrigger {
  String get id => throw _privateConstructorUsedError;
  String get methodologyId => throw _privateConstructorUsedError;
  List<TriggeredMethodology> get triggers => throw _privateConstructorUsedError;
  String get batchCommand => throw _privateConstructorUsedError;
  Map<String, dynamic> get batchVariables => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  DateTime? get scheduledFor => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BatchedTriggerCopyWith<BatchedTrigger> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BatchedTriggerCopyWith<$Res> {
  factory $BatchedTriggerCopyWith(
          BatchedTrigger value, $Res Function(BatchedTrigger) then) =
      _$BatchedTriggerCopyWithImpl<$Res, BatchedTrigger>;
  @useResult
  $Res call(
      {String id,
      String methodologyId,
      List<TriggeredMethodology> triggers,
      String batchCommand,
      Map<String, dynamic> batchVariables,
      int priority,
      DateTime? scheduledFor});
}

/// @nodoc
class _$BatchedTriggerCopyWithImpl<$Res, $Val extends BatchedTrigger>
    implements $BatchedTriggerCopyWith<$Res> {
  _$BatchedTriggerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? methodologyId = null,
    Object? triggers = null,
    Object? batchCommand = null,
    Object? batchVariables = null,
    Object? priority = null,
    Object? scheduledFor = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      triggers: null == triggers
          ? _value.triggers
          : triggers // ignore: cast_nullable_to_non_nullable
              as List<TriggeredMethodology>,
      batchCommand: null == batchCommand
          ? _value.batchCommand
          : batchCommand // ignore: cast_nullable_to_non_nullable
              as String,
      batchVariables: null == batchVariables
          ? _value.batchVariables
          : batchVariables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BatchedTriggerImplCopyWith<$Res>
    implements $BatchedTriggerCopyWith<$Res> {
  factory _$$BatchedTriggerImplCopyWith(_$BatchedTriggerImpl value,
          $Res Function(_$BatchedTriggerImpl) then) =
      __$$BatchedTriggerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String methodologyId,
      List<TriggeredMethodology> triggers,
      String batchCommand,
      Map<String, dynamic> batchVariables,
      int priority,
      DateTime? scheduledFor});
}

/// @nodoc
class __$$BatchedTriggerImplCopyWithImpl<$Res>
    extends _$BatchedTriggerCopyWithImpl<$Res, _$BatchedTriggerImpl>
    implements _$$BatchedTriggerImplCopyWith<$Res> {
  __$$BatchedTriggerImplCopyWithImpl(
      _$BatchedTriggerImpl _value, $Res Function(_$BatchedTriggerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? methodologyId = null,
    Object? triggers = null,
    Object? batchCommand = null,
    Object? batchVariables = null,
    Object? priority = null,
    Object? scheduledFor = freezed,
  }) {
    return _then(_$BatchedTriggerImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      triggers: null == triggers
          ? _value._triggers
          : triggers // ignore: cast_nullable_to_non_nullable
              as List<TriggeredMethodology>,
      batchCommand: null == batchCommand
          ? _value.batchCommand
          : batchCommand // ignore: cast_nullable_to_non_nullable
              as String,
      batchVariables: null == batchVariables
          ? _value._batchVariables
          : batchVariables // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BatchedTriggerImpl implements _BatchedTrigger {
  const _$BatchedTriggerImpl(
      {required this.id,
      required this.methodologyId,
      required final List<TriggeredMethodology> triggers,
      required this.batchCommand,
      required final Map<String, dynamic> batchVariables,
      required this.priority,
      this.scheduledFor})
      : _triggers = triggers,
        _batchVariables = batchVariables;

  factory _$BatchedTriggerImpl.fromJson(Map<String, dynamic> json) =>
      _$$BatchedTriggerImplFromJson(json);

  @override
  final String id;
  @override
  final String methodologyId;
  final List<TriggeredMethodology> _triggers;
  @override
  List<TriggeredMethodology> get triggers {
    if (_triggers is EqualUnmodifiableListView) return _triggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_triggers);
  }

  @override
  final String batchCommand;
  final Map<String, dynamic> _batchVariables;
  @override
  Map<String, dynamic> get batchVariables {
    if (_batchVariables is EqualUnmodifiableMapView) return _batchVariables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_batchVariables);
  }

  @override
  final int priority;
  @override
  final DateTime? scheduledFor;

  @override
  String toString() {
    return 'BatchedTrigger(id: $id, methodologyId: $methodologyId, triggers: $triggers, batchCommand: $batchCommand, batchVariables: $batchVariables, priority: $priority, scheduledFor: $scheduledFor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BatchedTriggerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.methodologyId, methodologyId) ||
                other.methodologyId == methodologyId) &&
            const DeepCollectionEquality().equals(other._triggers, _triggers) &&
            (identical(other.batchCommand, batchCommand) ||
                other.batchCommand == batchCommand) &&
            const DeepCollectionEquality()
                .equals(other._batchVariables, _batchVariables) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      methodologyId,
      const DeepCollectionEquality().hash(_triggers),
      batchCommand,
      const DeepCollectionEquality().hash(_batchVariables),
      priority,
      scheduledFor);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BatchedTriggerImplCopyWith<_$BatchedTriggerImpl> get copyWith =>
      __$$BatchedTriggerImplCopyWithImpl<_$BatchedTriggerImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BatchedTriggerImplToJson(
      this,
    );
  }
}

abstract class _BatchedTrigger implements BatchedTrigger {
  const factory _BatchedTrigger(
      {required final String id,
      required final String methodologyId,
      required final List<TriggeredMethodology> triggers,
      required final String batchCommand,
      required final Map<String, dynamic> batchVariables,
      required final int priority,
      final DateTime? scheduledFor}) = _$BatchedTriggerImpl;

  factory _BatchedTrigger.fromJson(Map<String, dynamic> json) =
      _$BatchedTriggerImpl.fromJson;

  @override
  String get id;
  @override
  String get methodologyId;
  @override
  List<TriggeredMethodology> get triggers;
  @override
  String get batchCommand;
  @override
  Map<String, dynamic> get batchVariables;
  @override
  int get priority;
  @override
  DateTime? get scheduledFor;
  @override
  @JsonKey(ignore: true)
  _$$BatchedTriggerImplCopyWith<_$BatchedTriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
