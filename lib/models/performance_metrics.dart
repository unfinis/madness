/// Performance metric model for tracking operation performance
class PerformanceMetric {
  final String operation;
  final Duration duration;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const PerformanceMetric({
    required this.operation,
    required this.duration,
    required this.timestamp,
    this.metadata = const {},
  });

  /// Create a PerformanceMetric from JSON
  factory PerformanceMetric.fromJson(Map<String, dynamic> json) {
    return PerformanceMetric(
      operation: json['operation'] as String,
      duration: Duration(microseconds: json['durationMicros'] as int),
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Convert PerformanceMetric to JSON
  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'durationMicros': duration.inMicroseconds,
      'durationMs': duration.inMilliseconds,
      'timestamp': timestamp.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create a copy with some fields updated
  PerformanceMetric copyWith({
    String? operation,
    Duration? duration,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return PerformanceMetric(
      operation: operation ?? this.operation,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Check if this metric is slow (configurable threshold)
  bool isSlow({Duration threshold = const Duration(seconds: 1)}) {
    return duration > threshold;
  }

  /// Get duration in milliseconds as a double
  double get durationMs => duration.inMicroseconds / 1000.0;

  @override
  String toString() {
    return 'PerformanceMetric(operation: $operation, duration: ${duration.inMilliseconds}ms, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PerformanceMetric &&
      other.operation == operation &&
      other.duration == duration &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return operation.hashCode ^
      duration.hashCode ^
      timestamp.hashCode;
  }
}

/// Statistics for a collection of performance metrics
class PerformanceStats {
  final String operation;
  final int count;
  final Duration min;
  final Duration max;
  final Duration average;
  final Duration median;
  final Duration p95;
  final Duration p99;

  const PerformanceStats({
    required this.operation,
    required this.count,
    required this.min,
    required this.max,
    required this.average,
    required this.median,
    required this.p95,
    required this.p99,
  });

  /// Calculate statistics from a list of metrics
  factory PerformanceStats.fromMetrics(String operation, List<PerformanceMetric> metrics) {
    if (metrics.isEmpty) {
      return PerformanceStats(
        operation: operation,
        count: 0,
        min: Duration.zero,
        max: Duration.zero,
        average: Duration.zero,
        median: Duration.zero,
        p95: Duration.zero,
        p99: Duration.zero,
      );
    }

    final durations = metrics.map((m) => m.duration).toList()..sort();
    final count = durations.length;

    final min = durations.first;
    final max = durations.last;

    final totalMicros = durations.fold<int>(0, (sum, d) => sum + d.inMicroseconds);
    final average = Duration(microseconds: totalMicros ~/ count);

    final median = durations[count ~/ 2];
    final p95 = durations[(count * 0.95).floor().clamp(0, count - 1)];
    final p99 = durations[(count * 0.99).floor().clamp(0, count - 1)];

    return PerformanceStats(
      operation: operation,
      count: count,
      min: min,
      max: max,
      average: average,
      median: median,
      p95: p95,
      p99: p99,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'count': count,
      'minMs': min.inMilliseconds,
      'maxMs': max.inMilliseconds,
      'averageMs': average.inMilliseconds,
      'medianMs': median.inMilliseconds,
      'p95Ms': p95.inMilliseconds,
      'p99Ms': p99.inMilliseconds,
    };
  }

  @override
  String toString() {
    return 'PerformanceStats($operation: count=$count, avg=${average.inMilliseconds}ms, p95=${p95.inMilliseconds}ms)';
  }
}
