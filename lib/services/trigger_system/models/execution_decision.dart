import 'trigger_match_result.dart';
import 'execution_priority.dart';

/// Decision about whether to execute a methodology based on triggers
///
/// Combines boolean matching with execution policy decisions
class ExecutionDecision {
  /// The trigger match result (boolean)
  final TriggerMatchResult match;

  /// Calculated execution priority
  final ExecutionPriority priority;

  /// Whether execution should proceed
  final bool shouldExecute;

  /// Reason for the decision
  final String reason;

  /// Deduplication key to prevent redundant executions
  final String? deduplicationKey;

  /// Whether this trigger+asset combination was already executed
  final bool alreadyExecuted;

  /// Cooldown period remaining (if any)
  final Duration? cooldownRemaining;

  /// Timestamp of the decision
  final DateTime decidedAt;

  const ExecutionDecision({
    required this.match,
    required this.priority,
    required this.shouldExecute,
    required this.reason,
    this.deduplicationKey,
    required this.alreadyExecuted,
    this.cooldownRemaining,
    required this.decidedAt,
  });

  /// Create a decision to execute
  factory ExecutionDecision.execute({
    required TriggerMatchResult match,
    required ExecutionPriority priority,
    required String reason,
    String? deduplicationKey,
  }) {
    return ExecutionDecision(
      match: match,
      priority: priority,
      shouldExecute: true,
      reason: reason,
      deduplicationKey: deduplicationKey,
      alreadyExecuted: false,
      decidedAt: DateTime.now(),
    );
  }

  /// Create a decision to skip execution
  factory ExecutionDecision.skip({
    required TriggerMatchResult match,
    required ExecutionPriority priority,
    required String reason,
    bool alreadyExecuted = false,
    Duration? cooldownRemaining,
    String? deduplicationKey,
  }) {
    return ExecutionDecision(
      match: match,
      priority: priority,
      shouldExecute: false,
      reason: reason,
      deduplicationKey: deduplicationKey,
      alreadyExecuted: alreadyExecuted,
      cooldownRemaining: cooldownRemaining,
      decidedAt: DateTime.now(),
    );
  }

  /// Create a decision for a trigger that didn't match
  factory ExecutionDecision.noMatch({
    required TriggerMatchResult match,
    required String reason,
  }) {
    return ExecutionDecision(
      match: match,
      priority: ExecutionPriority.low('No match'),
      shouldExecute: false,
      reason: reason,
      alreadyExecuted: false,
      decidedAt: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'ExecutionDecision('
        'shouldExecute: $shouldExecute, '
        'matched: ${match.matched}, '
        'priority: ${priority.score}, '
        'reason: $reason'
        ')';
  }

  /// Whether this decision has higher priority than another
  bool hasHigherPriorityThan(ExecutionDecision other) {
    return priority.isHigherThan(other.priority);
  }
}

/// Batch of execution decisions that can be combined
class ExecutionBatch {
  /// All decisions in this batch
  final List<ExecutionDecision> decisions;

  /// Methodology ID for this batch
  final String methodologyId;

  /// Whether this batch can be executed as a single command
  final bool batchCapable;

  /// Combined context for batch execution
  final Map<String, dynamic> batchContext;

  const ExecutionBatch({
    required this.decisions,
    required this.methodologyId,
    required this.batchCapable,
    required this.batchContext,
  });

  /// Get all decisions that should execute
  List<ExecutionDecision> get executableDecisions {
    return decisions.where((d) => d.shouldExecute).toList();
  }

  /// Get highest priority in the batch
  ExecutionPriority get highestPriority {
    if (decisions.isEmpty) {
      return ExecutionPriority.low('Empty batch');
    }

    return decisions
        .map((d) => d.priority)
        .reduce((a, b) => a.isHigherThan(b) ? a : b);
  }

  /// Number of decisions that should execute
  int get executableCount => executableDecisions.length;

  /// Whether this batch has any executable decisions
  bool get hasExecutable => executableCount > 0;

  @override
  String toString() {
    return 'ExecutionBatch('
        'methodology: $methodologyId, '
        'total: ${decisions.length}, '
        'executable: $executableCount, '
        'batchCapable: $batchCapable'
        ')';
  }
}
