/// Tracks history of trigger executions for success/failure analysis
///
/// Separated from matching and priority - history helps inform future execution
/// decisions but doesn't determine whether a trigger matches.
class ExecutionHistory {
  final Map<String, List<ExecutionHistoryEntry>> _history = {};

  /// Record a successful execution
  void recordSuccess({
    required String triggerId,
    required String assetId,
    required String deduplicationKey,
    required Duration executionTime,
    Map<String, dynamic>? metadata,
  }) {
    final entry = ExecutionHistoryEntry(
      triggerId: triggerId,
      assetId: assetId,
      deduplicationKey: deduplicationKey,
      success: true,
      executedAt: DateTime.now(),
      executionTime: executionTime,
      metadata: metadata,
    );

    _addEntry(deduplicationKey, entry);
  }

  /// Record a failed execution
  void recordFailure({
    required String triggerId,
    required String assetId,
    required String deduplicationKey,
    required String errorMessage,
    Duration? executionTime,
    Map<String, dynamic>? metadata,
  }) {
    final entry = ExecutionHistoryEntry(
      triggerId: triggerId,
      assetId: assetId,
      deduplicationKey: deduplicationKey,
      success: false,
      errorMessage: errorMessage,
      executedAt: DateTime.now(),
      executionTime: executionTime,
      metadata: metadata,
    );

    _addEntry(deduplicationKey, entry);
  }

  /// Add an entry to history
  void _addEntry(String key, ExecutionHistoryEntry entry) {
    if (!_history.containsKey(key)) {
      _history[key] = [];
    }
    _history[key]!.add(entry);
  }

  /// Check if a trigger+asset combination was already executed
  bool wasExecuted(String deduplicationKey) {
    return _history.containsKey(deduplicationKey) &&
           _history[deduplicationKey]!.isNotEmpty;
  }

  /// Get last execution for a deduplication key
  ExecutionHistoryEntry? getLastExecution(String deduplicationKey) {
    final entries = _history[deduplicationKey];
    if (entries == null || entries.isEmpty) return null;
    return entries.last;
  }

  /// Get all executions for a deduplication key
  List<ExecutionHistoryEntry> getExecutions(String deduplicationKey) {
    return _history[deduplicationKey] ?? [];
  }

  /// Get success rate for a trigger (0.0 to 1.0)
  double getSuccessRate(String triggerId) {
    final allEntries = _history.values.expand((list) => list).toList();
    final triggerEntries = allEntries.where((e) => e.triggerId == triggerId).toList();

    if (triggerEntries.isEmpty) return 0.0;

    final successCount = triggerEntries.where((e) => e.success).length;
    return successCount / triggerEntries.length;
  }

  /// Get total execution count for a trigger
  int getExecutionCount(String triggerId) {
    final allEntries = _history.values.expand((list) => list).toList();
    return allEntries.where((e) => e.triggerId == triggerId).length;
  }

  /// Get all failed executions for analysis
  List<ExecutionHistoryEntry> getFailures({String? triggerId}) {
    final allEntries = _history.values.expand((list) => list).toList();
    final failures = allEntries.where((e) => !e.success);

    if (triggerId != null) {
      return failures.where((e) => e.triggerId == triggerId).toList();
    }

    return failures.toList();
  }

  /// Get execution statistics for a trigger
  ExecutionStats getStats(String triggerId) {
    final allEntries = _history.values.expand((list) => list).toList();
    final triggerEntries = allEntries.where((e) => e.triggerId == triggerId).toList();

    if (triggerEntries.isEmpty) {
      return ExecutionStats(
        triggerId: triggerId,
        totalExecutions: 0,
        successCount: 0,
        failureCount: 0,
        successRate: 0.0,
        averageExecutionTime: Duration.zero,
      );
    }

    final successCount = triggerEntries.where((e) => e.success).length;
    final failureCount = triggerEntries.length - successCount;

    // Calculate average execution time
    final entriesWithTime = triggerEntries.where((e) => e.executionTime != null).toList();
    Duration averageTime = Duration.zero;
    if (entriesWithTime.isNotEmpty) {
      final totalMs = entriesWithTime
          .map((e) => e.executionTime!.inMilliseconds)
          .reduce((a, b) => a + b);
      averageTime = Duration(milliseconds: totalMs ~/ entriesWithTime.length);
    }

    return ExecutionStats(
      triggerId: triggerId,
      totalExecutions: triggerEntries.length,
      successCount: successCount,
      failureCount: failureCount,
      successRate: successCount / triggerEntries.length,
      averageExecutionTime: averageTime,
    );
  }

  /// Clear history for a specific deduplication key
  void clearHistory(String deduplicationKey) {
    _history.remove(deduplicationKey);
  }

  /// Clear all history
  void clearAllHistory() {
    _history.clear();
  }

  /// Get total number of unique deduplication keys
  int get uniqueExecutions => _history.length;

  /// Get total number of execution entries
  int get totalExecutions => _history.values.fold(0, (sum, list) => sum + list.length);
}

/// A single execution history entry
class ExecutionHistoryEntry {
  final String triggerId;
  final String assetId;
  final String deduplicationKey;
  final bool success;
  final String? errorMessage;
  final DateTime executedAt;
  final Duration? executionTime;
  final Map<String, dynamic>? metadata;

  const ExecutionHistoryEntry({
    required this.triggerId,
    required this.assetId,
    required this.deduplicationKey,
    required this.success,
    this.errorMessage,
    required this.executedAt,
    this.executionTime,
    this.metadata,
  });

  @override
  String toString() {
    return 'ExecutionHistoryEntry('
        'trigger: $triggerId, '
        'asset: $assetId, '
        'success: $success, '
        'time: ${executionTime?.inMilliseconds}ms'
        ')';
  }
}

/// Execution statistics for a trigger
class ExecutionStats {
  final String triggerId;
  final int totalExecutions;
  final int successCount;
  final int failureCount;
  final double successRate;
  final Duration averageExecutionTime;

  const ExecutionStats({
    required this.triggerId,
    required this.totalExecutions,
    required this.successCount,
    required this.failureCount,
    required this.successRate,
    required this.averageExecutionTime,
  });

  @override
  String toString() {
    return 'ExecutionStats('
        'trigger: $triggerId, '
        'executions: $totalExecutions, '
        'success rate: ${(successRate * 100).toStringAsFixed(1)}%, '
        'avg time: ${averageExecutionTime.inMilliseconds}ms'
        ')';
  }
}
