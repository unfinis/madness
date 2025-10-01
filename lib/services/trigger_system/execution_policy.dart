import '../../models/asset.dart';
import '../../models/methodology_trigger.dart' as mt;
import 'models/execution_decision.dart';
import 'trigger_matcher.dart';
import 'execution_prioritizer.dart';
import 'trigger_deduplication.dart';
import 'execution_history.dart';

/// Enforces execution policy for triggers
///
/// Combines matching, priority, history, and deduplication to decide
/// whether a methodology should execute.
class ExecutionPolicy {
  final ExecutionHistory history;
  final Map<String, DateTime> _lastEvaluationTime = {};

  ExecutionPolicy({required this.history});

  /// Evaluate whether a trigger should execute for an asset
  ///
  /// This is the main entry point that combines:
  /// 1. Boolean matching (does it match?)
  /// 2. Priority calculation (how important?)
  /// 3. Deduplication check (already done?)
  /// 4. Cooldown check (too soon?)
  /// 5. History analysis (likely to succeed?)
  ExecutionDecision evaluate({
    required mt.MethodologyTrigger trigger,
    required Asset asset,
    List<Asset>? allAssets,
  }) {
    // Step 1: Boolean matching
    final match = TriggerMatcher.evaluateTrigger(
      trigger: trigger,
      asset: asset,
      allAssets: allAssets,
    );

    if (!match.matched) {
      return ExecutionDecision.noMatch(
        match: match,
        reason: match.reason,
      );
    }

    // Step 2: Calculate priority
    final priority = ExecutionPrioritizer.calculatePriority(
      match: match,
      trigger: trigger,
      asset: asset,
      allAssets: allAssets,
    );

    // Step 3: Generate deduplication key
    final dedupKey = TriggerDeduplication.generateKey(
      match: match,
      trigger: trigger,
      asset: asset,
    );

    // Step 4: Check if already executed
    if (TriggerDeduplication.wasAlreadyExecuted(
      deduplicationKey: dedupKey,
      asset: asset,
    )) {
      return ExecutionDecision.skip(
        match: match,
        priority: priority,
        reason: 'Already executed (dedup key: $dedupKey)',
        alreadyExecuted: true,
        deduplicationKey: dedupKey,
      );
    }

    // Step 5: Check cooldown period
    if (trigger.cooldownPeriod != null) {
      final cooldownRemaining = _checkCooldown(
        triggerId: trigger.id,
        assetId: asset.id,
        cooldownPeriod: trigger.cooldownPeriod!,
      );

      if (cooldownRemaining != null) {
        return ExecutionDecision.skip(
          match: match,
          priority: priority,
          reason: 'Cooldown period: ${cooldownRemaining.inMinutes} minutes remaining',
          cooldownRemaining: cooldownRemaining,
          deduplicationKey: dedupKey,
        );
      }
    }

    // Step 6: Check execution history for repeated failures
    if (_shouldSkipDueToFailures(trigger.id, dedupKey)) {
      return ExecutionDecision.skip(
        match: match,
        priority: priority,
        reason: 'Skipping due to repeated failures',
        deduplicationKey: dedupKey,
      );
    }

    // All checks passed - should execute
    return ExecutionDecision.execute(
      match: match,
      priority: priority,
      reason: 'Trigger matched and passed all policy checks',
      deduplicationKey: dedupKey,
    );
  }

  /// Evaluate multiple triggers against an asset
  ///
  /// Returns all decisions sorted by priority
  List<ExecutionDecision> evaluateMultiple({
    required List<mt.MethodologyTrigger> triggers,
    required Asset asset,
    List<Asset>? allAssets,
  }) {
    final decisions = <ExecutionDecision>[];

    for (final trigger in triggers) {
      if (!trigger.enabled) continue;

      final decision = evaluate(
        trigger: trigger,
        asset: asset,
        allAssets: allAssets,
      );

      decisions.add(decision);
    }

    // Sort by priority (highest first)
    decisions.sort((a, b) => b.priority.score.compareTo(a.priority.score));

    return decisions;
  }

  /// Evaluate a trigger against multiple assets (batch evaluation)
  ///
  /// Returns decisions for each asset, grouped if batch-capable
  List<ExecutionDecision> evaluateBatch({
    required mt.MethodologyTrigger trigger,
    required List<Asset> assets,
  }) {
    final decisions = <ExecutionDecision>[];

    for (final asset in assets) {
      final decision = evaluate(
        trigger: trigger,
        asset: asset,
        allAssets: assets,
      );

      decisions.add(decision);
    }

    return decisions;
  }

  /// Create batch execution from multiple decisions
  ///
  /// Groups compatible decisions into a single batch execution
  ExecutionBatch createBatch({
    required List<ExecutionDecision> decisions,
    required mt.MethodologyTrigger trigger,
  }) {
    // Filter for executable decisions only
    final executable = decisions.where((d) => d.shouldExecute).toList();

    // Build combined context
    final batchContext = <String, dynamic>{
      'methodology_id': trigger.methodologyId,
      'trigger_id': trigger.id,
      'asset_count': executable.length,
      'dedup_keys': executable.map((d) => d.deduplicationKey).toList(),
    };

    // Add asset-specific context
    final assetIds = executable.map((d) => d.match.assetId).toList();
    batchContext['asset_ids'] = assetIds;

    // If trigger has batch criteria, group by that
    if (trigger.batchCriteria != null) {
      batchContext['batch_criteria'] = trigger.batchCriteria;
    }

    return ExecutionBatch(
      decisions: decisions,
      methodologyId: trigger.methodologyId,
      batchCapable: trigger.batchCapable,
      batchContext: batchContext,
    );
  }

  /// Check cooldown period for a trigger+asset combination
  Duration? _checkCooldown({
    required String triggerId,
    required String assetId,
    required Duration cooldownPeriod,
  }) {
    final key = '$triggerId:$assetId';
    final lastEvaluation = _lastEvaluationTime[key];

    if (lastEvaluation == null) {
      // First evaluation - no cooldown
      _lastEvaluationTime[key] = DateTime.now();
      return null;
    }

    final elapsed = DateTime.now().difference(lastEvaluation);

    if (elapsed < cooldownPeriod) {
      // Still in cooldown
      return cooldownPeriod - elapsed;
    }

    // Cooldown expired
    _lastEvaluationTime[key] = DateTime.now();
    return null;
  }

  /// Check if trigger should be skipped due to repeated failures
  bool _shouldSkipDueToFailures(String triggerId, String dedupKey) {
    final stats = history.getStats(triggerId);

    // Skip if trigger has failed more than 3 times and success rate < 25%
    if (stats.failureCount >= 3 && stats.successRate < 0.25) {
      return true;
    }

    // Check if this specific dedup key has failed before
    final lastExecution = history.getLastExecution(dedupKey);
    if (lastExecution != null && !lastExecution.success) {
      // Failed before - skip it
      return true;
    }

    return false;
  }

  /// Reset cooldown for a trigger+asset combination
  void resetCooldown({required String triggerId, required String assetId}) {
    final key = '$triggerId:$assetId';
    _lastEvaluationTime.remove(key);
  }

  /// Clear all cooldowns
  void clearAllCooldowns() {
    _lastEvaluationTime.clear();
  }

  /// Get remaining cooldown time for a trigger+asset
  Duration? getCooldownRemaining({
    required String triggerId,
    required String assetId,
    required Duration cooldownPeriod,
  }) {
    final key = '$triggerId:$assetId';
    final lastEvaluation = _lastEvaluationTime[key];

    if (lastEvaluation == null) return null;

    final elapsed = DateTime.now().difference(lastEvaluation);
    if (elapsed >= cooldownPeriod) return null;

    return cooldownPeriod - elapsed;
  }
}
