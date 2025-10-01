import '../../models/asset.dart';
import '../../models/methodology_trigger_builder.dart';
import '../trigger_evaluator.dart' show MethodologyTriggerMatch;
import 'execution_policy.dart';
import 'execution_history.dart';

/// Adapter for backward compatibility with old TriggerEvaluator API
///
/// This allows existing code to continue working while using the new
/// refactored trigger system internally.
///
/// OLD API (confidence-based):
/// - TriggerEvaluator.evaluateAssets() returns MethodologyTriggerMatch with confidence
/// - Confidence mixed with boolean matching
/// - Priority calculated inside evaluator
///
/// NEW API (boolean-based):
/// - ExecutionPolicy.evaluate() returns ExecutionDecision
/// - Boolean matching separated from priority
/// - Clear separation of concerns
class TriggerSystemAdapter {
  final ExecutionPolicy _policy;

  TriggerSystemAdapter({ExecutionPolicy? policy})
      : _policy = policy ?? ExecutionPolicy(history: ExecutionHistory());

  /// Evaluate assets against triggers (OLD API compatibility)
  ///
  /// Returns MethodologyTriggerMatch objects that existing code expects
  static List<MethodologyTriggerMatch> evaluateAssets({
    required List<Asset> assets,
    required List<MethodologyTriggerDefinition> triggers,
    String? projectId,
  }) {
    final adapter = TriggerSystemAdapter();
    return adapter._evaluateAssetsInternal(
      assets: assets,
      triggers: triggers,
      projectId: projectId,
    );
  }

  /// Internal implementation using new system
  List<MethodologyTriggerMatch> _evaluateAssetsInternal({
    required List<Asset> assets,
    required List<MethodologyTriggerDefinition> triggers,
    String? projectId,
  }) {
    final matches = <MethodologyTriggerMatch>[];

    // Convert new trigger definitions to old format
    // Note: This is a simplified conversion - full implementation would
    // need to handle all trigger definition formats
    for (final triggerDef in triggers) {
      if (!triggerDef.enabled) continue;

      // For each condition group in the trigger
      for (final group in triggerDef.conditionGroups) {
        // Evaluate against all assets
        final matchingAssets = _findMatchingAssets(
          assets: assets,
          conditionGroup: group,
        );

        if (matchingAssets.isNotEmpty) {
          // Create match using OLD API format but NEW calculation
          matches.add(MethodologyTriggerMatch(
            trigger: triggerDef,
            matchingAssets: matchingAssets,
            // NOTE: Old API expects confidence (0.0-1.0)
            // New system uses boolean matching + priority
            // Map priority (0-100) to confidence (0.0-1.0) for compatibility
            confidence: _convertPriorityToConfidence(triggerDef.priority),
            priority: triggerDef.priority,
            context: _buildContext(triggerDef, matchingAssets),
          ));
        }
      }
    }

    // Sort by priority (old API behavior)
    matches.sort((a, b) {
      final priorityComparison = b.priority.compareTo(a.priority);
      if (priorityComparison != 0) return priorityComparison;
      return b.confidence.compareTo(a.confidence);
    });

    return matches;
  }

  /// Find assets matching a condition group
  List<Asset> _findMatchingAssets({
    required List<Asset> assets,
    required TriggerGroup conditionGroup,
  }) {
    final matching = <Asset>[];

    for (final asset in assets) {
      // Check if asset type matches any condition in the group
      bool assetTypeMatches = false;
      for (final condition in conditionGroup.conditions) {
        if (asset.type == condition.assetType) {
          assetTypeMatches = true;
          break;
        }
      }

      if (!assetTypeMatches) continue;

      // Evaluate conditions based on logical operator
      final allConditionsMet = _evaluateConditionGroup(
        asset: asset,
        group: conditionGroup,
      );

      if (allConditionsMet) {
        matching.add(asset);
      }
    }

    return matching;
  }

  /// Evaluate a condition group against an asset
  bool _evaluateConditionGroup({
    required Asset asset,
    required TriggerGroup group,
  }) {
    final results = <bool>[];

    for (final condition in group.conditions) {
      // Check asset type
      if (asset.type != condition.assetType) {
        results.add(false);
        continue;
      }

      // Get property value
      final propertyValue = asset.properties[condition.property];

      // Evaluate based on operator
      final result = _evaluateCondition(
        operator: condition.operator,
        value: condition.value,
        actualProperty: propertyValue,
      );

      results.add(result);
    }

    // Apply logical operator
    if (results.isEmpty) return false;

    if (group.logicalOperator == 'OR') {
      return results.any((r) => r);
    } else {
      // Default to AND
      return results.every((r) => r);
    }
  }

  /// Evaluate a single condition
  bool _evaluateCondition({
    required TriggerOperator operator,
    required TriggerValue value,
    required PropertyValue? actualProperty,
  }) {
    final actualValue = _extractPropertyValue(actualProperty);

    return value.when(
      string: (expectedStr) {
        switch (operator) {
          case TriggerOperator.equals:
            return actualValue == expectedStr;
          case TriggerOperator.notEquals:
            return actualValue != expectedStr;
          case TriggerOperator.contains:
            if (actualValue is List) {
              return actualValue.contains(expectedStr);
            }
            if (actualValue is String) {
              return actualValue.contains(expectedStr);
            }
            return false;
          case TriggerOperator.notContains:
            if (actualValue is List) {
              return !actualValue.contains(expectedStr);
            }
            if (actualValue is String) {
              return !actualValue.contains(expectedStr);
            }
            return true;
          default:
            return actualValue == expectedStr;
        }
      },
      boolean: (expectedBool) {
        return actualValue == expectedBool;
      },
      number: (expectedNum) {
        if (actualValue is! num) return false;

        switch (operator) {
          case TriggerOperator.equals:
            return actualValue == expectedNum;
          case TriggerOperator.notEquals:
            return actualValue != expectedNum;
          case TriggerOperator.greaterThan:
            return actualValue > expectedNum;
          case TriggerOperator.lessThan:
            return actualValue < expectedNum;
          case TriggerOperator.greaterThanOrEqual:
            return actualValue >= expectedNum;
          case TriggerOperator.lessThanOrEqual:
            return actualValue <= expectedNum;
          default:
            return actualValue == expectedNum;
        }
      },
      list: (expectedList) {
        switch (operator) {
          case TriggerOperator.in_:
            return expectedList.contains(actualValue?.toString());
          case TriggerOperator.notIn:
            return !expectedList.contains(actualValue?.toString());
          default:
            return false;
        }
      },
      isNull: () {
        return operator == TriggerOperator.isNull && actualProperty == null;
      },
      notNull: () {
        return operator == TriggerOperator.isNotNull && actualProperty != null;
      },
    );
  }

  /// Extract actual value from PropertyValue
  dynamic _extractPropertyValue(PropertyValue? propertyValue) {
    if (propertyValue == null) return null;

    return propertyValue.when(
      string: (value) => value,
      integer: (value) => value,
      boolean: (value) => value,
      stringList: (value) => value,
      map: (value) => value,
      objectList: (value) => value,
    );
  }

  /// Convert priority (0-100) to confidence (0.0-1.0) for OLD API compatibility
  double _convertPriorityToConfidence(int priority) {
    // Map priority range to confidence range
    // Priority 0-100 → Confidence 0.0-1.0
    return (priority / 100.0).clamp(0.0, 1.0);
  }

  /// Build execution context from trigger and matching assets
  Map<String, dynamic> _buildContext(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    final context = <String, dynamic>{};

    // Add asset information
    context['asset_ids'] = matchingAssets.map((a) => a.id).toList();
    context['asset_names'] = matchingAssets.map((a) => a.name).toList();
    context['asset_types'] = matchingAssets.map((a) => a.type.name).toList();

    // Add first asset's properties as primary context
    if (matchingAssets.isNotEmpty) {
      final primaryAsset = matchingAssets.first;
      context['primary_asset_id'] = primaryAsset.id;
      context['primary_asset_name'] = primaryAsset.name;
      context['primary_asset_type'] = primaryAsset.type.name;

      // Add properties
      for (final entry in primaryAsset.properties.entries) {
        context['asset_${entry.key}'] = _extractPropertyValue(entry.value);
      }
    }

    // Add trigger information
    context['trigger_id'] = trigger.id;
    context['trigger_name'] = trigger.name;
    context['trigger_priority'] = trigger.priority;

    return context;
  }

  /// Get the underlying execution policy
  ExecutionPolicy get policy => _policy;

  /// Get execution history
  ExecutionHistory get history => _policy.history;
}
