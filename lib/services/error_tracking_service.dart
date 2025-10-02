import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/error_report.dart';

/// Error tracking service for monitoring and logging application errors
///
/// This is a singleton service that collects errors from throughout the application,
/// provides a stream of errors for real-time monitoring, and maintains a history
/// of recent errors for debugging.
class ErrorTrackingService {
  static final _instance = ErrorTrackingService._internal();
  factory ErrorTrackingService() => _instance;
  ErrorTrackingService._internal();

  final List<ErrorReport> _errors = [];
  final StreamController<ErrorReport> _errorController = StreamController.broadcast();

  /// Stream of error reports as they occur
  Stream<ErrorReport> get errorStream => _errorController.stream;

  /// Maximum number of errors to keep in memory
  static const int maxErrorHistory = 1000;

  /// Track an error with context and optional additional data
  ///
  /// [context] - A string identifying where the error occurred (e.g., 'trigger_evaluation')
  /// [error] - The error object or message
  /// [stack] - Optional stack trace for debugging
  /// [additionalData] - Optional map of contextual information
  void trackError(
    String context,
    dynamic error,
    StackTrace? stack, {
    Map<String, dynamic>? additionalData,
  }) {
    final errorReport = ErrorReport(
      id: const Uuid().v4(),
      context: context,
      error: error.toString(),
      stackTrace: stack?.toString(),
      timestamp: DateTime.now(),
      additionalData: additionalData ?? {},
    );

    _errors.add(errorReport);
    _errorController.add(errorReport);

    // Limit memory usage by removing old errors
    if (_errors.length > maxErrorHistory) {
      _errors.removeAt(0);
    }

    // Log to console in debug mode
    if (kDebugMode) {
      print('ERROR [$context]: $error');
      if (additionalData != null && additionalData.isNotEmpty) {
        print('  Data: $additionalData');
      }
      if (stack != null) {
        print('  Stack: $stack');
      }
    }
  }

  /// Track an error from a caught exception with automatic context
  ///
  /// This is a convenience method for use in catch blocks
  void trackException(
    String context,
    Object exception,
    StackTrace stackTrace, {
    Map<String, dynamic>? additionalData,
  }) {
    trackError(context, exception, stackTrace, additionalData: additionalData);
  }

  /// Get recent errors within a specified duration
  ///
  /// [within] - Duration to look back (defaults to 24 hours)
  /// Returns list of ErrorReports within the time window
  List<ErrorReport> getRecentErrors([Duration? within]) {
    final cutoff = within != null
        ? DateTime.now().subtract(within)
        : DateTime.now().subtract(const Duration(hours: 24));

    return _errors.where((e) => e.timestamp.isAfter(cutoff)).toList();
  }

  /// Get errors for a specific context
  ///
  /// [context] - The context string to filter by
  /// [within] - Optional duration to limit the time window
  List<ErrorReport> getErrorsByContext(String context, [Duration? within]) {
    final recentErrors = getRecentErrors(within);
    return recentErrors.where((e) => e.context == context).toList();
  }

  /// Get all unique error contexts that have occurred
  Set<String> getErrorContexts([Duration? within]) {
    final recentErrors = getRecentErrors(within);
    return recentErrors.map((e) => e.context).toSet();
  }

  /// Get error count by context
  ///
  /// Returns a map of context names to error counts
  Map<String, int> getErrorCountsByContext([Duration? within]) {
    final recentErrors = getRecentErrors(within);
    final counts = <String, int>{};

    for (final error in recentErrors) {
      counts[error.context] = (counts[error.context] ?? 0) + 1;
    }

    return counts;
  }

  /// Get the most common errors
  ///
  /// [limit] - Maximum number of contexts to return (defaults to 10)
  /// [within] - Optional duration to limit the time window
  List<MapEntry<String, int>> getMostCommonErrors({
    int limit = 10,
    Duration? within,
  }) {
    final counts = getErrorCountsByContext(within);
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).toList();
  }

  /// Clear all tracked errors
  void clearErrors() {
    _errors.clear();
  }

  /// Clear errors for a specific context
  void clearErrorsByContext(String context) {
    _errors.removeWhere((e) => e.context == context);
  }

  /// Get total error count
  int get errorCount => _errors.length;

  /// Get error count within a duration
  int getErrorCount([Duration? within]) {
    return getRecentErrors(within).length;
  }

  /// Check if any errors have occurred in a context
  bool hasErrors(String context, [Duration? within]) {
    return getErrorsByContext(context, within).isNotEmpty;
  }

  /// Get the last error for a specific context
  ErrorReport? getLastError(String context) {
    final contextErrors = _errors.where((e) => e.context == context).toList();
    if (contextErrors.isEmpty) return null;
    return contextErrors.last;
  }

  /// Export errors as JSON for persistence or debugging
  List<Map<String, dynamic>> exportErrors([Duration? within]) {
    return getRecentErrors(within).map((e) => e.toJson()).toList();
  }

  /// Dispose of the service and close streams
  void dispose() {
    _errorController.close();
  }
}
