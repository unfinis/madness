import '../../models/asset.dart';
import '../../models/methodology_trigger.dart' as mt;
import 'models/trigger_match_result.dart';
import 'indexed_trigger_matcher.dart';

/// Pure boolean trigger matching - no confidence scores
///
/// Evaluates whether a trigger's conditions match an asset's properties.
/// Returns only true/false with detailed reasoning.
class TriggerMatcher {
  /// Indexed matcher for O(1) trigger lookups
  static final IndexedTriggerMatcher _indexedMatcher = IndexedTriggerMatcher();
  /// Evaluate a trigger against an asset
  ///
  /// Returns a [TriggerMatchResult] indicating whether the trigger matched
  /// and providing detailed context for execution if it did.
  static TriggerMatchResult evaluateTrigger({
    required mt.MethodologyTrigger trigger,
    required Asset asset,
    List<Asset>? allAssets,
  }) {
    final conditionChecks = <ConditionCheckResult>[];

    // Check asset type first - must match
    if (asset.type.name != trigger.assetType.name) {
      conditionChecks.add(ConditionCheckResult(
        property: 'type',
        operator: 'equals',
        expectedValue: trigger.assetType.name,
        actualValue: asset.type.name,
        passed: false,
        description: 'Asset type mismatch',
      ));

      return TriggerMatchResult.notMatched(
        triggerId: trigger.id,
        assetId: asset.id,
        reason: 'Asset type ${asset.type.name} does not match required type ${trigger.assetType.name}',
        conditionChecks: conditionChecks,
      );
    }

    conditionChecks.add(ConditionCheckResult(
      property: 'type',
      operator: 'equals',
      expectedValue: trigger.assetType.name,
      actualValue: asset.type.name,
      passed: true,
      description: 'Asset type matches',
    ));

    // If no conditions specified, match all assets of this type
    if (trigger.conditions == null || (trigger.conditions is Map && (trigger.conditions as Map).isEmpty)) {
      return TriggerMatchResult.matched(
        triggerId: trigger.id,
        assetId: asset.id,
        context: _buildContext(asset, trigger),
        reason: 'Matches all assets of type ${asset.type.name}',
        conditionChecks: conditionChecks,
      );
    }

    // Evaluate all conditions
    final conditionsMatched = _evaluateConditions(
      conditions: trigger.conditions,
      asset: asset,
      conditionChecks: conditionChecks,
    );

    if (conditionsMatched) {
      return TriggerMatchResult.matched(
        triggerId: trigger.id,
        assetId: asset.id,
        context: _buildContext(asset, trigger),
        reason: 'All conditions satisfied: ${_summarizeChecks(conditionChecks)}',
        conditionChecks: conditionChecks,
      );
    } else {
      return TriggerMatchResult.notMatched(
        triggerId: trigger.id,
        assetId: asset.id,
        reason: 'Conditions not met: ${_summarizeChecks(conditionChecks)}',
        conditionChecks: conditionChecks,
      );
    }
  }

  /// Evaluate trigger conditions against asset properties
  ///
  /// Returns true only if ALL conditions are satisfied
  static bool _evaluateConditions({
    required dynamic conditions,
    required Asset asset,
    required List<ConditionCheckResult> conditionChecks,
  }) {
    if (conditions == null) return true;

    if (conditions is Map<String, dynamic>) {
      // Simple property-value conditions
      return _evaluateMapConditions(
        conditions: conditions,
        asset: asset,
        conditionChecks: conditionChecks,
      );
    }

    // Unsupported condition format
    conditionChecks.add(ConditionCheckResult(
      property: 'unknown',
      operator: 'unknown',
      expectedValue: conditions,
      actualValue: null,
      passed: false,
      description: 'Unsupported condition format',
    ));
    return false;
  }

  /// Evaluate map-based conditions (property: expected_value)
  static bool _evaluateMapConditions({
    required Map<String, dynamic> conditions,
    required Asset asset,
    required List<ConditionCheckResult> conditionChecks,
  }) {
    bool allConditionsMet = true;

    for (final entry in conditions.entries) {
      final property = entry.key;
      final expectedValue = entry.value;

      // Get actual value from asset properties
      final actualProperty = asset.properties[property];

      final checkResult = _evaluateSingleCondition(
        property: property,
        expectedValue: expectedValue,
        actualProperty: actualProperty,
      );

      conditionChecks.add(checkResult);

      if (!checkResult.passed) {
        allConditionsMet = false;
      }
    }

    return allConditionsMet;
  }

  /// Evaluate a single condition
  static ConditionCheckResult _evaluateSingleCondition({
    required String property,
    required dynamic expectedValue,
    required PropertyValue? actualProperty,
  }) {
    // Handle operator-based conditions
    if (expectedValue is Map<String, dynamic>) {
      return _evaluateOperatorCondition(
        property: property,
        operatorSpec: expectedValue,
        actualProperty: actualProperty,
      );
    }

    // Simple equality check
    final actualValue = _extractPropertyValue(actualProperty);
    final matches = _compareValues(actualValue, expectedValue);

    return ConditionCheckResult(
      property: property,
      operator: 'equals',
      expectedValue: expectedValue,
      actualValue: actualValue,
      passed: matches,
      description: matches
          ? '$property equals $expectedValue'
          : '$property ($actualValue) does not equal $expectedValue',
    );
  }

  /// Evaluate operator-based condition (e.g., {$operator: 'contains', $value: 445})
  static ConditionCheckResult _evaluateOperatorCondition({
    required String property,
    required Map<String, dynamic> operatorSpec,
    required PropertyValue? actualProperty,
  }) {
    final operator = operatorSpec['\$operator'] ?? operatorSpec['operator'] ?? 'equals';
    final value = operatorSpec['\$value'] ?? operatorSpec['value'];

    final actualValue = _extractPropertyValue(actualProperty);
    bool passed = false;
    String description = '';

    switch (operator) {
      case 'equals':
        passed = actualValue == value;
        description = passed ? '$property equals $value' : '$property ($actualValue) ≠ $value';
        break;

      case 'notEquals':
        passed = actualValue != value;
        description = passed ? '$property not equals $value' : '$property equals $value unexpectedly';
        break;

      case 'contains':
        if (actualValue is List) {
          passed = actualValue.contains(value);
          description = passed ? '$property list contains $value' : '$property list does not contain $value';
        } else if (actualValue is String) {
          passed = actualValue.contains(value.toString());
          description = passed ? '$property string contains $value' : '$property string does not contain $value';
        } else {
          passed = false;
          description = '$property is not a list or string';
        }
        break;

      case 'exists':
        passed = actualProperty != null;
        description = passed ? '$property exists' : '$property does not exist';
        break;

      case 'notExists':
        passed = actualProperty == null;
        description = passed ? '$property does not exist' : '$property exists unexpectedly';
        break;

      case 'greaterThan':
        if (actualValue is num && value is num) {
          passed = actualValue > value;
          description = passed ? '$property ($actualValue) > $value' : '$property ($actualValue) ≤ $value';
        } else {
          passed = false;
          description = '$property or value is not a number';
        }
        break;

      case 'lessThan':
        if (actualValue is num && value is num) {
          passed = actualValue < value;
          description = passed ? '$property ($actualValue) < $value' : '$property ($actualValue) ≥ $value';
        } else {
          passed = false;
          description = '$property or value is not a number';
        }
        break;

      case 'inList':
        if (value is List) {
          passed = value.contains(actualValue);
          description = passed ? '$property ($actualValue) in allowed values' : '$property ($actualValue) not in allowed values';
        } else {
          passed = false;
          description = 'Expected value is not a list';
        }
        break;

      default:
        passed = actualValue == value;
        description = 'Unknown operator $operator, defaulting to equals';
        break;
    }

    return ConditionCheckResult(
      property: property,
      operator: operator,
      expectedValue: value,
      actualValue: actualValue,
      passed: passed,
      description: description,
    );
  }

  /// Extract the actual value from a PropertyValue union
  static dynamic _extractPropertyValue(PropertyValue? propertyValue) {
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

  /// Compare two values for equality
  static bool _compareValues(dynamic actual, dynamic expected) {
    if (actual == null && expected == null) return true;
    if (actual == null || expected == null) return false;

    // List comparison
    if (actual is List && expected is List) {
      if (actual.length != expected.length) return false;
      for (int i = 0; i < actual.length; i++) {
        if (actual[i] != expected[i]) return false;
      }
      return true;
    }

    // Map comparison
    if (actual is Map && expected is Map) {
      if (actual.length != expected.length) return false;
      for (final key in actual.keys) {
        if (!expected.containsKey(key)) return false;
        if (actual[key] != expected[key]) return false;
      }
      return true;
    }

    // Simple equality
    return actual == expected;
  }

  /// Build execution context from matched asset
  static Map<String, dynamic> _buildContext(Asset asset, mt.MethodologyTrigger trigger) {
    final context = <String, dynamic>{
      'asset_id': asset.id,
      'asset_name': asset.name,
      'asset_type': asset.type.name,
      'trigger_id': trigger.id,
      'trigger_name': trigger.name,
    };

    // Add all asset properties to context
    for (final entry in asset.properties.entries) {
      context['asset_${entry.key}'] = _extractPropertyValue(entry.value);
    }

    return context;
  }

  /// Summarize condition checks for human-readable output
  static String _summarizeChecks(List<ConditionCheckResult> checks) {
    final passed = checks.where((c) => c.passed).length;
    final total = checks.length;
    return '$passed/$total checks passed';
  }

  // ===== OPTIMIZED METHODS FOR LARGE DATASETS =====

  /// Evaluate asset using indexed matching (O(1) lookup)
  ///
  /// Much faster than evaluating all triggers when you have many triggers
  static List<TriggerMatchResult> evaluateAssetOptimized(
    Asset asset,
    List<mt.MethodologyTrigger> allTriggers,
  ) {
    // Build indexes if not already built or stale
    if (_indexedMatcher.isStale() ||
        _indexedMatcher.getIndexStats()['totalTriggers'] != allTriggers.length) {
      _indexedMatcher.buildIndexes(allTriggers);
    }

    // Get only relevant triggers (O(1) instead of O(n))
    final relevantTriggers = _indexedMatcher.getRelevantTriggers(asset);

    final results = <TriggerMatchResult>[];
    for (final trigger in relevantTriggers) {
      if (!trigger.enabled) continue;

      final result = evaluateTrigger(
        trigger: trigger,
        asset: asset,
      );

      if (result.matched) {
        results.add(result);
      }
    }

    return results;
  }

  /// Rebuild trigger indexes
  ///
  /// Call this when triggers are added, removed, or modified
  static void rebuildIndexes(List<mt.MethodologyTrigger> triggers) {
    _indexedMatcher.buildIndexes(triggers);
  }

  /// Get index statistics
  static Map<String, dynamic> getIndexStats() {
    return _indexedMatcher.getIndexStats();
  }

  /// Print debug information about indexes
  static void printIndexDebugInfo() {
    _indexedMatcher.printDebugInfo();
  }

  /// Clear all indexes
  static void clearIndexes() {
    _indexedMatcher.reset();
  }
}
