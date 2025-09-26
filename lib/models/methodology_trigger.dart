import 'package:freezed_annotation/freezed_annotation.dart';
import 'asset.dart';

part 'methodology_trigger.freezed.dart';
part 'methodology_trigger.g.dart';

// Trigger condition operators
enum TriggerOperator {
  equals,
  notEquals,
  contains,
  notContains,
  exists,
  notExists,
  greaterThan,
  lessThan,
  inList,
  notInList,
  matches,  // regex
}

// Logical operators for combining conditions
enum LogicalOperator {
  and,
  or,
  not,
}

// A single trigger condition
@freezed
sealed class TriggerCondition with _$TriggerCondition {
  const factory TriggerCondition({
    required String property,
    required TriggerOperator operator,
    dynamic value,  // Can be string, int, bool, list, etc.
    String? description,
  }) = _TriggerCondition;

  factory TriggerCondition.fromJson(Map<String, dynamic> json) =>
      _$TriggerConditionFromJson(json);
}

// Group of conditions with logical operator
@freezed
sealed class TriggerConditionGroup with _$TriggerConditionGroup {
  const factory TriggerConditionGroup({
    required LogicalOperator operator,
    required List<dynamic> conditions,  // Can be TriggerCondition or nested TriggerConditionGroup
  }) = _TriggerConditionGroup;

  factory TriggerConditionGroup.fromJson(Map<String, dynamic> json) =>
      _$TriggerConditionGroupFromJson(json);
}

// Complete trigger definition for a methodology
@freezed
sealed class MethodologyTrigger with _$MethodologyTrigger {
  const factory MethodologyTrigger({
    required String id,
    required String methodologyId,
    required String name,
    String? description,

    // Asset type this trigger applies to
    required AssetType assetType,

    // Trigger conditions (can be simple or complex)
    required dynamic conditions,  // TriggerCondition or TriggerConditionGroup

    // Priority for ordering triggers
    required int priority,

    // Batch processing configuration
    required bool batchCapable,
    String? batchCriteria,  // Property to group by for batching
    String? batchCommand,    // Template for batch command
    int? maxBatchSize,

    // Deduplication
    required String deduplicationKeyTemplate,  // e.g., "{asset.id}:{methodology}:{hash}"
    Duration? cooldownPeriod,  // Don't retrigger within this period

    // Command templates
    String? individualCommand,  // Command for single asset
    Map<String, String>? commandVariants,  // Different commands for different conditions

    // Expected outcomes
    List<String>? expectedPropertyUpdates,  // Properties that should be updated
    List<AssetType>? expectedAssetDiscovery,  // Types of assets that might be discovered

    // Metadata
    required List<String> tags,
    required bool enabled,
  }) = _MethodologyTrigger;

  factory MethodologyTrigger.fromJson(Map<String, dynamic> json) =>
      _$MethodologyTriggerFromJson(json);
}

// Represents a triggered methodology ready for execution
@freezed
sealed class TriggeredMethodology with _$TriggeredMethodology {
  const factory TriggeredMethodology({
    required String id,
    required String methodologyId,
    required String triggerId,
    required Asset asset,
    required String deduplicationKey,

    // Execution context
    required Map<String, dynamic> variables,  // Variables extracted from asset properties
    String? command,  // Resolved command with variables substituted

    // Batch information
    bool? isPartOfBatch,
    String? batchId,
    List<Asset>? batchAssets,  // Other assets in the same batch

    // Status
    required DateTime triggeredAt,
    DateTime? executedAt,
    DateTime? completedAt,
    String? status,  // "pending", "executing", "completed", "failed", "skipped"

    // Priority
    required int priority,
  }) = _TriggeredMethodology;

  factory TriggeredMethodology.fromJson(Map<String, dynamic> json) =>
      _$TriggeredMethodologyFromJson(json);
}

// Batch of triggered methodologies that can be executed together
@freezed
sealed class BatchedTrigger with _$BatchedTrigger {
  const factory BatchedTrigger({
    required String id,
    required String methodologyId,
    required List<TriggeredMethodology> triggers,
    required String batchCommand,
    required Map<String, dynamic> batchVariables,
    required int priority,
    DateTime? scheduledFor,
  }) = _BatchedTrigger;

  factory BatchedTrigger.fromJson(Map<String, dynamic> json) =>
      _$BatchedTriggerFromJson(json);
}

// Service for evaluating trigger conditions
class TriggerEvaluator {
  static bool evaluateCondition(TriggerCondition condition, Map<String, PropertyValue> properties) {
    final property = properties[condition.property];

    switch (condition.operator) {
      case TriggerOperator.exists:
        return property != null;

      case TriggerOperator.notExists:
        return property == null;

      case TriggerOperator.equals:
        if (property == null) return false;
        return property.when(
          string: (v) => v == condition.value,
          integer: (v) => v == condition.value,
          boolean: (v) => v == condition.value,
          stringList: (v) => v == condition.value,
          map: (v) => v == condition.value,
          objectList: (v) => v == condition.value,
        );

      case TriggerOperator.notEquals:
        if (property == null) return true;
        return !evaluateCondition(
          condition.copyWith(operator: TriggerOperator.equals),
          properties,
        );

      case TriggerOperator.contains:
        if (property == null) return false;
        return property.when(
          string: (v) => v.contains(condition.value.toString()),
          integer: (_) => false,
          boolean: (_) => false,
          stringList: (v) => v.contains(condition.value),
          map: (v) => v.containsKey(condition.value),
          objectList: (v) => v.any((obj) => obj.containsValue(condition.value)),
        );

      case TriggerOperator.greaterThan:
        if (property == null) return false;
        return property.when(
          string: (v) => v.compareTo(condition.value.toString()) > 0,
          integer: (v) => v > (condition.value as int),
          boolean: (_) => false,
          stringList: (v) => v.length > (condition.value as int),
          map: (v) => v.length > (condition.value as int),
          objectList: (v) => v.length > (condition.value as int),
        );

      case TriggerOperator.lessThan:
        if (property == null) return false;
        return property.when(
          string: (v) => v.compareTo(condition.value.toString()) < 0,
          integer: (v) => v < (condition.value as int),
          boolean: (_) => false,
          stringList: (v) => v.length < (condition.value as int),
          map: (v) => v.length < (condition.value as int),
          objectList: (v) => v.length < (condition.value as int),
        );

      case TriggerOperator.inList:
        if (property == null) return false;
        final list = condition.value as List;
        return property.when(
          string: (v) => list.contains(v),
          integer: (v) => list.contains(v),
          boolean: (v) => list.contains(v),
          stringList: (_) => false,
          map: (_) => false,
          objectList: (_) => false,
        );

      case TriggerOperator.matches:
        if (property == null) return false;
        final regex = RegExp(condition.value.toString());
        return property.when(
          string: (v) => regex.hasMatch(v),
          integer: (v) => regex.hasMatch(v.toString()),
          boolean: (v) => regex.hasMatch(v.toString()),
          stringList: (v) => v.any((s) => regex.hasMatch(s)),
          map: (_) => false,
          objectList: (_) => false,
        );

      default:
        return false;
    }
  }

  static bool evaluateConditionGroup(
    TriggerConditionGroup group,
    Map<String, PropertyValue> properties,
  ) {
    switch (group.operator) {
      case LogicalOperator.and:
        return group.conditions.every((c) {
          if (c is TriggerCondition) {
            return evaluateCondition(c, properties);
          } else if (c is TriggerConditionGroup) {
            return evaluateConditionGroup(c, properties);
          }
          return false;
        });

      case LogicalOperator.or:
        return group.conditions.any((c) {
          if (c is TriggerCondition) {
            return evaluateCondition(c, properties);
          } else if (c is TriggerConditionGroup) {
            return evaluateConditionGroup(c, properties);
          }
          return false;
        });

      case LogicalOperator.not:
        final firstCondition = group.conditions.first;
        if (firstCondition is TriggerCondition) {
          return !evaluateCondition(firstCondition, properties);
        } else if (firstCondition is TriggerConditionGroup) {
          return !evaluateConditionGroup(firstCondition, properties);
        }
        return false;
    }
  }

  static bool evaluate(dynamic conditions, Map<String, PropertyValue> properties) {
    if (conditions is TriggerCondition) {
      return evaluateCondition(conditions, properties);
    } else if (conditions is TriggerConditionGroup) {
      return evaluateConditionGroup(conditions, properties);
    }
    return false;
  }
}

// Helper class for generating deduplication keys
class DeduplicationKeyGenerator {
  static String generate(
    String template,
    Asset asset,
    MethodologyTrigger trigger,
    Map<String, dynamic> variables,
  ) {
    var key = template;

    // Replace asset properties
    key = key.replaceAll('{asset.id}', asset.id);
    key = key.replaceAll('{asset.type}', asset.type.name);
    key = key.replaceAll('{asset.name}', asset.name);

    // Replace methodology info
    key = key.replaceAll('{methodology}', trigger.methodologyId);
    key = key.replaceAll('{trigger}', trigger.id);

    // Replace variables
    variables.forEach((k, v) {
      key = key.replaceAll('{$k}', v.toString());
    });

    // Generate hash for complex properties
    if (key.contains('{hash}')) {
      final hashData = '${asset.properties}:$variables';
      final hash = hashData.hashCode.toRadixString(16);
      key = key.replaceAll('{hash}', hash);
    }

    return key;
  }
}