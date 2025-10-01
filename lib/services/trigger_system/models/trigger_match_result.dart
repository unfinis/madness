/// Result of evaluating a trigger against an asset
///
/// Pure boolean matching - no confidence scores
class TriggerMatchResult {
  /// Whether the trigger conditions matched the asset
  final bool matched;

  /// ID of the trigger that was evaluated
  final String triggerId;

  /// ID of the asset that was evaluated
  final String assetId;

  /// Execution context built from matching asset properties
  /// Contains asset properties and trigger parameters for methodology execution
  final Map<String, dynamic> context;

  /// Human-readable reason explaining why the trigger matched or didn't match
  final String reason;

  /// Timestamp when the evaluation occurred
  final DateTime evaluatedAt;

  /// List of all condition checks performed
  final List<ConditionCheckResult> conditionChecks;

  const TriggerMatchResult({
    required this.matched,
    required this.triggerId,
    required this.assetId,
    required this.context,
    required this.reason,
    required this.evaluatedAt,
    required this.conditionChecks,
  });

  /// Create a successful match result
  factory TriggerMatchResult.matched({
    required String triggerId,
    required String assetId,
    required Map<String, dynamic> context,
    required String reason,
    required List<ConditionCheckResult> conditionChecks,
  }) {
    return TriggerMatchResult(
      matched: true,
      triggerId: triggerId,
      assetId: assetId,
      context: context,
      reason: reason,
      evaluatedAt: DateTime.now(),
      conditionChecks: conditionChecks,
    );
  }

  /// Create a failed match result
  factory TriggerMatchResult.notMatched({
    required String triggerId,
    required String assetId,
    required String reason,
    required List<ConditionCheckResult> conditionChecks,
  }) {
    return TriggerMatchResult(
      matched: false,
      triggerId: triggerId,
      assetId: assetId,
      context: {},
      reason: reason,
      evaluatedAt: DateTime.now(),
      conditionChecks: conditionChecks,
    );
  }

  @override
  String toString() {
    return 'TriggerMatchResult(matched: $matched, trigger: $triggerId, asset: $assetId, reason: $reason)';
  }
}

/// Result of evaluating a single condition within a trigger
class ConditionCheckResult {
  /// The property being checked
  final String property;

  /// The operator used for comparison
  final String operator;

  /// The expected value
  final dynamic expectedValue;

  /// The actual value from the asset
  final dynamic actualValue;

  /// Whether this condition passed
  final bool passed;

  /// Human-readable description of the check
  final String description;

  const ConditionCheckResult({
    required this.property,
    required this.operator,
    required this.expectedValue,
    required this.actualValue,
    required this.passed,
    required this.description,
  });

  @override
  String toString() {
    return 'ConditionCheck($property $operator $expectedValue: ${passed ? "PASS" : "FAIL"} [actual: $actualValue])';
  }
}
