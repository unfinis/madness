/// Error report model for tracking application errors
class ErrorReport {
  final String id;
  final String context;
  final String error;
  final String? stackTrace;
  final DateTime timestamp;
  final Map<String, dynamic> additionalData;

  const ErrorReport({
    required this.id,
    required this.context,
    required this.error,
    this.stackTrace,
    required this.timestamp,
    this.additionalData = const {},
  });

  /// Create an ErrorReport from JSON
  factory ErrorReport.fromJson(Map<String, dynamic> json) {
    return ErrorReport(
      id: json['id'] as String,
      context: json['context'] as String,
      error: json['error'] as String,
      stackTrace: json['stackTrace'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      additionalData: (json['additionalData'] as Map<String, dynamic>?) ?? {},
    );
  }

  /// Convert ErrorReport to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'context': context,
      'error': error,
      'stackTrace': stackTrace,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  /// Create a copy with some fields updated
  ErrorReport copyWith({
    String? id,
    String? context,
    String? error,
    String? stackTrace,
    DateTime? timestamp,
    Map<String, dynamic>? additionalData,
  }) {
    return ErrorReport(
      id: id ?? this.id,
      context: context ?? this.context,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      timestamp: timestamp ?? this.timestamp,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  @override
  String toString() {
    return 'ErrorReport(id: $id, context: $context, error: $error, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ErrorReport &&
      other.id == id &&
      other.context == context &&
      other.error == error &&
      other.stackTrace == stackTrace &&
      other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      context.hashCode ^
      error.hashCode ^
      stackTrace.hashCode ^
      timestamp.hashCode;
  }
}
