import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/performance_metrics.dart';

/// Performance monitoring service for tracking operation performance
///
/// This service provides timing utilities and performance metrics collection
/// to help identify bottlenecks and track system performance over time.
class PerformanceMonitor {
  static final Map<String, Stopwatch> _activeTimers = {};
  static final List<PerformanceMetric> _metrics = [];
  static final StreamController<PerformanceMetric> _metricsController =
      StreamController.broadcast();

  /// Stream of performance metrics as they are recorded
  static Stream<PerformanceMetric> get metricsStream => _metricsController.stream;

  /// Maximum number of metrics to keep in memory
  static const int maxMetricsHistory = 10000;

  /// Start a performance timer for an operation
  ///
  /// [operation] - Unique identifier for the operation being timed
  /// [metadata] - Optional contextual information
  static void startTimer(String operation, {Map<String, dynamic>? metadata}) {
    _activeTimers[operation] = Stopwatch()..start();

    if (kDebugMode && metadata != null) {
      print('PERF START [$operation]: ${metadata.entries.map((e) => '${e.key}=${e.value}').join(', ')}');
    }
  }

  /// End a performance timer and record the metric
  ///
  /// [operation] - The operation identifier used in startTimer
  /// [logResult] - Whether to log and store the result (defaults to true)
  /// [metadata] - Optional additional metadata to store with the metric
  ///
  /// Returns the elapsed duration, or null if no timer was found
  static Duration? endTimer(
    String operation, {
    bool logResult = true,
    Map<String, dynamic>? metadata,
  }) {
    final timer = _activeTimers.remove(operation);
    if (timer == null) {
      if (kDebugMode) {
        print('PERF WARNING: No timer found for operation: $operation');
      }
      return null;
    }

    timer.stop();
    final duration = timer.elapsed;

    if (logResult) {
      final metric = PerformanceMetric(
        operation: operation,
        duration: duration,
        timestamp: DateTime.now(),
        metadata: metadata ?? {},
      );

      _metrics.add(metric);
      _metricsController.add(metric);

      // Limit memory usage
      if (_metrics.length > maxMetricsHistory) {
        _metrics.removeAt(0);
      }

      if (kDebugMode) {
        final metaStr = metadata != null && metadata.isNotEmpty
            ? ' (${metadata.entries.map((e) => '${e.key}=${e.value}').join(', ')})'
            : '';
        print('PERF END [$operation]: ${duration.inMilliseconds}ms$metaStr');
      }
    }

    return duration;
  }

  /// Convenience method to time an async operation
  ///
  /// Usage:
  /// ```dart
  /// final result = await PerformanceMonitor.timeAsync(
  ///   'my_operation',
  ///   () async => await someAsyncWork(),
  /// );
  /// ```
  static Future<T> timeAsync<T>(
    String operation,
    Future<T> Function() fn, {
    Map<String, dynamic>? metadata,
  }) async {
    startTimer(operation, metadata: metadata);
    try {
      final result = await fn();
      endTimer(operation, metadata: metadata);
      return result;
    } catch (e) {
      endTimer(operation, metadata: {...?metadata, 'error': true});
      rethrow;
    }
  }

  /// Convenience method to time a synchronous operation
  ///
  /// Usage:
  /// ```dart
  /// final result = PerformanceMonitor.timeSync(
  ///   'my_operation',
  ///   () => someWork(),
  /// );
  /// ```
  static T timeSync<T>(
    String operation,
    T Function() fn, {
    Map<String, dynamic>? metadata,
  }) {
    startTimer(operation, metadata: metadata);
    try {
      final result = fn();
      endTimer(operation, metadata: metadata);
      return result;
    } catch (e) {
      endTimer(operation, metadata: {...?metadata, 'error': true});
      rethrow;
    }
  }

  /// Get all metrics for a specific operation
  ///
  /// [operation] - The operation identifier
  /// [within] - Optional duration to limit the time window (defaults to 1 hour)
  static List<PerformanceMetric> getMetrics(
    String operation, [
    Duration? within,
  ]) {
    final cutoff = within != null
        ? DateTime.now().subtract(within)
        : DateTime.now().subtract(const Duration(hours: 1));

    return _metrics
        .where((m) => m.operation == operation && m.timestamp.isAfter(cutoff))
        .toList();
  }

  /// Get all unique operation names
  static Set<String> getOperationNames([Duration? within]) {
    final cutoff = within != null
        ? DateTime.now().subtract(within)
        : DateTime.now().subtract(const Duration(hours: 1));

    return _metrics
        .where((m) => m.timestamp.isAfter(cutoff))
        .map((m) => m.operation)
        .toSet();
  }

  /// Calculate average execution time for an operation
  ///
  /// [operation] - The operation identifier
  /// [within] - Optional duration to limit the time window
  ///
  /// Returns average time in milliseconds as a double
  static double getAverageTime(String operation, [Duration? within]) {
    final metrics = getMetrics(operation, within);
    if (metrics.isEmpty) return 0.0;

    final total = metrics.fold<int>(
      0,
      (sum, m) => sum + m.duration.inMilliseconds,
    );
    return total / metrics.length;
  }

  /// Get minimum execution time for an operation
  static Duration? getMinTime(String operation, [Duration? within]) {
    final metrics = getMetrics(operation, within);
    if (metrics.isEmpty) return null;

    return metrics.map((m) => m.duration).reduce(
          (a, b) => a < b ? a : b,
        );
  }

  /// Get maximum execution time for an operation
  static Duration? getMaxTime(String operation, [Duration? within]) {
    final metrics = getMetrics(operation, within);
    if (metrics.isEmpty) return null;

    return metrics.map((m) => m.duration).reduce(
          (a, b) => a > b ? a : b,
        );
  }

  /// Get comprehensive statistics for an operation
  static PerformanceStats getStats(String operation, [Duration? within]) {
    final metrics = getMetrics(operation, within);
    return PerformanceStats.fromMetrics(operation, metrics);
  }

  /// Get statistics for all operations
  static Map<String, PerformanceStats> getAllStats([Duration? within]) {
    final operations = getOperationNames(within);
    final stats = <String, PerformanceStats>{};

    for (final operation in operations) {
      stats[operation] = getStats(operation, within);
    }

    return stats;
  }

  /// Get slow operations (above threshold)
  ///
  /// [threshold] - Duration threshold to consider an operation slow
  /// [within] - Optional duration to limit the time window
  ///
  /// Returns list of operations with their average times
  static List<MapEntry<String, double>> getSlowOperations({
    Duration threshold = const Duration(milliseconds: 500),
    Duration? within,
  }) {
    final operations = getOperationNames(within);
    final slowOps = <String, double>{};

    for (final operation in operations) {
      final avgTime = getAverageTime(operation, within);
      if (avgTime > threshold.inMilliseconds) {
        slowOps[operation] = avgTime;
      }
    }

    final sorted = slowOps.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted;
  }

  /// Get metrics that exceeded a threshold
  static List<PerformanceMetric> getSlowMetrics({
    Duration threshold = const Duration(seconds: 1),
    Duration? within,
  }) {
    final cutoff = within != null
        ? DateTime.now().subtract(within)
        : DateTime.now().subtract(const Duration(hours: 1));

    return _metrics
        .where((m) => m.timestamp.isAfter(cutoff) && m.duration > threshold)
        .toList();
  }

  /// Get call count for an operation
  static int getCallCount(String operation, [Duration? within]) {
    return getMetrics(operation, within).length;
  }

  /// Get total count of all metrics
  static int get totalMetrics => _metrics.length;

  /// Clear all metrics
  static void clearMetrics() {
    _metrics.clear();
  }

  /// Clear metrics for a specific operation
  static void clearOperationMetrics(String operation) {
    _metrics.removeWhere((m) => m.operation == operation);
  }

  /// Export metrics as JSON
  static List<Map<String, dynamic>> exportMetrics([Duration? within]) {
    final cutoff = within != null
        ? DateTime.now().subtract(within)
        : DateTime.now().subtract(const Duration(hours: 1));

    return _metrics
        .where((m) => m.timestamp.isAfter(cutoff))
        .map((m) => m.toJson())
        .toList();
  }

  /// Print a summary of all operations to console
  static void printSummary([Duration? within]) {
    if (!kDebugMode) return;

    final stats = getAllStats(within);
    if (stats.isEmpty) {
      print('PERF SUMMARY: No metrics recorded');
      return;
    }

    print('\n=== PERFORMANCE SUMMARY ===');
    final sorted = stats.entries.toList()
      ..sort((a, b) => b.value.average.compareTo(a.value.average));

    for (final entry in sorted) {
      final s = entry.value;
      print('${entry.key}:');
      print('  Count: ${s.count}');
      print('  Avg: ${s.average.inMilliseconds}ms');
      print('  Min: ${s.min.inMilliseconds}ms');
      print('  Max: ${s.max.inMilliseconds}ms');
      print('  P95: ${s.p95.inMilliseconds}ms');
      print('  P99: ${s.p99.inMilliseconds}ms');
    }
    print('===========================\n');
  }

  /// Dispose and close streams
  static void dispose() {
    _metricsController.close();
    _activeTimers.clear();
  }
}
