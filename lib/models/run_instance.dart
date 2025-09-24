import 'package:freezed_annotation/freezed_annotation.dart';

part 'run_instance.freezed.dart';
part 'run_instance.g.dart';

/// Status of a methodology run instance
enum RunInstanceStatus {
  pending,
  inProgress,
  completed,
  blocked,
  failed;

  String get displayName {
    switch (this) {
      case RunInstanceStatus.pending:
        return 'Pending';
      case RunInstanceStatus.inProgress:
        return 'In Progress';
      case RunInstanceStatus.completed:
        return 'Completed';
      case RunInstanceStatus.blocked:
        return 'Blocked';
      case RunInstanceStatus.failed:
        return 'Failed';
    }
  }
}

/// A run instance represents an active or completed execution of a methodology
/// against a specific asset with resolved parameters
@freezed
sealed class RunInstance with _$RunInstance {
  const factory RunInstance({
    /// Unique identifier for this run instance (RUN-YYYYMMDD-XXXX)
    required String runId,

    /// ID of the methodology template this instance is based on
    required String templateId,

    /// Version of the methodology template
    required String templateVersion,

    /// ID of the trigger that created this instance
    required String triggerId,

    /// ID of the asset this methodology is running against
    required String assetId,

    /// Values matched from the trigger evaluation
    required Map<String, dynamic> matchedValues,

    /// Resolved parameter values for the methodology
    required Map<String, dynamic> parameters,

    /// Current status of the run instance
    required RunInstanceStatus status,

    /// When this instance was created
    required DateTime createdAt,

    /// Who created this instance
    required String createdBy,

    /// List of evidence item IDs associated with this run
    @Default([]) List<String> evidenceIds,

    /// List of finding IDs generated from this run
    @Default([]) List<String> findingIds,

    /// History of status changes and actions
    @Default([]) List<HistoryEntry> history,

    /// Optional notes about this run instance
    String? notes,

    /// When this instance was last updated
    DateTime? updatedAt,

    /// Priority assigned to this run (1-10, higher = more important)
    @Default(5) int priority,

    /// Tags associated with this run instance
    @Default([]) List<String> tags,
  }) = _RunInstance;

  factory RunInstance.fromJson(Map<String, dynamic> json) =>
      _$RunInstanceFromJson(json);
}

/// History entry for tracking changes to a run instance
@freezed
sealed class HistoryEntry with _$HistoryEntry {
  const factory HistoryEntry({
    /// Unique identifier for this history entry
    required String id,

    /// When this action occurred
    required DateTime timestamp,

    /// Who performed this action
    required String performedBy,

    /// Type of action performed
    required HistoryActionType action,

    /// Description of what happened
    required String description,

    /// Previous value (for change tracking)
    String? previousValue,

    /// New value (for change tracking)
    String? newValue,

    /// Additional metadata about the action
    @Default({}) Map<String, dynamic> metadata,
  }) = _HistoryEntry;

  factory HistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$HistoryEntryFromJson(json);
}

/// Types of actions that can be recorded in history
enum HistoryActionType {
  created,
  statusChanged,
  parameterUpdated,
  evidenceAdded,
  findingGenerated,
  noteAdded,
  priorityChanged,
  tagAdded,
  tagRemoved;

  String get displayName {
    switch (this) {
      case HistoryActionType.created:
        return 'Created';
      case HistoryActionType.statusChanged:
        return 'Status Changed';
      case HistoryActionType.parameterUpdated:
        return 'Parameter Updated';
      case HistoryActionType.evidenceAdded:
        return 'Evidence Added';
      case HistoryActionType.findingGenerated:
        return 'Finding Generated';
      case HistoryActionType.noteAdded:
        return 'Note Added';
      case HistoryActionType.priorityChanged:
        return 'Priority Changed';
      case HistoryActionType.tagAdded:
        return 'Tag Added';
      case HistoryActionType.tagRemoved:
        return 'Tag Removed';
    }
  }
}