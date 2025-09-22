import 'package:freezed_annotation/freezed_annotation.dart';

part 'attack_plan_action.freezed.dart';
part 'attack_plan_action.g.dart';

/// Status of an attack plan action
enum ActionStatus {
  pending,
  inProgress,
  completed,
  blocked,
  skipped;

  String get displayName {
    switch (this) {
      case ActionStatus.pending:
        return 'Pending';
      case ActionStatus.inProgress:
        return 'In Progress';
      case ActionStatus.completed:
        return 'Completed';
      case ActionStatus.blocked:
        return 'Blocked';
      case ActionStatus.skipped:
        return 'Skipped';
    }
  }
}

/// Priority of an attack plan action
enum ActionPriority {
  critical,
  high,
  medium,
  low;

  String get displayName {
    switch (this) {
      case ActionPriority.critical:
        return 'Critical';
      case ActionPriority.high:
        return 'High';
      case ActionPriority.medium:
        return 'Medium';
      case ActionPriority.low:
        return 'Low';
    }
  }
}

/// Risk level for an action
enum ActionRiskLevel {
  minimal,
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case ActionRiskLevel.minimal:
        return 'Minimal';
      case ActionRiskLevel.low:
        return 'Low';
      case ActionRiskLevel.medium:
        return 'Medium';
      case ActionRiskLevel.high:
        return 'High';
      case ActionRiskLevel.critical:
        return 'Critical';
    }
  }
}

/// A triggered event that led to this action
@freezed
class TriggerEvent with _$TriggerEvent {
  const factory TriggerEvent({
    /// ID of the trigger that fired
    required String triggerId,

    /// ID of the asset that triggered this
    required String assetId,

    /// Name of the asset for display
    required String assetName,

    /// Type of asset (host, service, etc.)
    required String assetType,

    /// The conditions that were matched
    required Map<String, dynamic> matchedConditions,

    /// Values extracted from the trigger evaluation
    required Map<String, dynamic> extractedValues,

    /// When this trigger was evaluated
    required DateTime evaluatedAt,

    /// Confidence of the match (0.0 - 1.0)
    @Default(1.0) double confidence,
  }) = _TriggerEvent;

  factory TriggerEvent.fromJson(Map<String, dynamic> json) =>
      _$TriggerEventFromJson(json);
}

/// A tool required for an action
@freezed
class ActionTool with _$ActionTool {
  const factory ActionTool({
    /// Name of the tool
    required String name,

    /// Description of what the tool does
    required String description,

    /// Installation command or link
    String? installation,

    /// Whether the tool is required or optional
    @Default(true) bool required,

    /// Alternative tools that can be used
    @Default([]) List<String> alternatives,
  }) = _ActionTool;

  factory ActionTool.fromJson(Map<String, dynamic> json) =>
      _$ActionToolFromJson(json);
}

/// Equipment needed for an action
@freezed
class ActionEquipment with _$ActionEquipment {
  const factory ActionEquipment({
    /// Name of the equipment
    required String name,

    /// Description of the equipment
    required String description,

    /// Whether the equipment is required or optional
    @Default(true) bool required,

    /// Specifications or model details
    String? specifications,
  }) = _ActionEquipment;

  factory ActionEquipment.fromJson(Map<String, dynamic> json) =>
      _$ActionEquipmentFromJson(json);
}

/// A reference for further reading
@freezed
class ActionReference with _$ActionReference {
  const factory ActionReference({
    /// Title of the reference
    required String title,

    /// URL or citation
    required String url,

    /// Description of what this reference covers
    String? description,

    /// Type of reference (documentation, blog, paper, etc.)
    @Default('documentation') String type,
  }) = _ActionReference;

  factory ActionReference.fromJson(Map<String, dynamic> json) =>
      _$ActionReferenceFromJson(json);
}

/// A risk associated with an action and its mitigation
@freezed
class ActionRisk with _$ActionRisk {
  const factory ActionRisk({
    /// Description of the risk
    required String risk,

    /// How to mitigate this risk
    required String mitigation,

    /// Severity of the risk
    @Default(ActionRiskLevel.medium) ActionRiskLevel severity,
  }) = _ActionRisk;

  factory ActionRisk.fromJson(Map<String, dynamic> json) =>
      _$ActionRiskFromJson(json);
}

/// A procedure step with commands
@freezed
class ProcedureStep with _$ProcedureStep {
  const factory ProcedureStep({
    /// Step number
    required int stepNumber,

    /// Description of what this step does
    required String description,

    /// Command to execute (with placeholders)
    String? command,

    /// Expected output or results
    String? expectedOutput,

    /// Additional notes for this step
    String? notes,

    /// Whether this step is mandatory
    @Default(true) bool mandatory,
  }) = _ProcedureStep;

  factory ProcedureStep.fromJson(Map<String, dynamic> json) =>
      _$ProcedureStepFromJson(json);
}

/// A suggested finding from this action
@freezed
class SuggestedFinding with _$SuggestedFinding {
  const factory SuggestedFinding({
    /// Title of the finding
    required String title,

    /// Description of what this finding represents
    required String description,

    /// Severity of the finding
    @Default(ActionRiskLevel.medium) ActionRiskLevel severity,

    /// CVSS score if applicable
    double? cvssScore,

    /// Category of the finding
    String? category,
  }) = _SuggestedFinding;

  factory SuggestedFinding.fromJson(Map<String, dynamic> json) =>
      _$SuggestedFindingFromJson(json);
}

/// Execution data for tracking completion
@freezed
class ActionExecution with _$ActionExecution {
  const factory ActionExecution({
    /// When execution started
    DateTime? startedAt,

    /// When execution completed
    DateTime? completedAt,

    /// Who executed this action
    String? executedBy,

    /// Commands that were actually run
    @Default([]) List<String> executedCommands,

    /// Outputs captured from execution
    @Default([]) List<String> capturedOutputs,

    /// Evidence files generated
    @Default([]) List<String> evidenceFiles,

    /// Findings discovered during execution
    @Default([]) List<String> findingIds,

    /// Notes added during execution
    String? executionNotes,

    /// Whether this action was successful
    bool? successful,

    /// Error message if execution failed
    String? errorMessage,
  }) = _ActionExecution;

  factory ActionExecution.fromJson(Map<String, dynamic> json) =>
      _$ActionExecutionFromJson(json);
}

/// Main attack plan action model
@freezed
class AttackPlanAction with _$AttackPlanAction {
  const factory AttackPlanAction({
    /// Unique identifier
    required String id,

    /// Project this action belongs to
    required String projectId,

    /// Title of the action (e.g., "Enumerate Installed Software (Windows)")
    required String title,

    /// Short summary of what you are trying to achieve and consequences
    required String objective,

    /// Current status of the action
    @Default(ActionStatus.pending) ActionStatus status,

    /// Priority level
    @Default(ActionPriority.medium) ActionPriority priority,

    /// Risk level of performing this action
    @Default(ActionRiskLevel.medium) ActionRiskLevel riskLevel,

    /// Trigger events that led to this action being generated
    @Default([]) List<TriggerEvent> triggerEvents,

    /// Risks and their mitigations
    @Default([]) List<ActionRisk> risks,

    /// Step-by-step procedure
    @Default([]) List<ProcedureStep> procedure,

    /// Tools required
    @Default([]) List<ActionTool> tools,

    /// Equipment needed
    @Default([]) List<ActionEquipment> equipment,

    /// References for further reading
    @Default([]) List<ActionReference> references,

    /// Suggested findings from this action
    @Default([]) List<SuggestedFinding> suggestedFindings,

    /// Cleanup steps required after execution
    @Default([]) List<String> cleanupSteps,

    /// Tags for categorization
    @Default([]) List<String> tags,

    /// Execution tracking data
    ActionExecution? execution,

    /// When this action was created
    required DateTime createdAt,

    /// When this action was last updated
    DateTime? updatedAt,

    /// Who created this action
    @Default('system') String createdBy,

    /// Template ID this action was generated from
    String? templateId,

    /// Additional metadata
    @Default({}) Map<String, dynamic> metadata,
  }) = _AttackPlanAction;

  factory AttackPlanAction.fromJson(Map<String, dynamic> json) =>
      _$AttackPlanActionFromJson(json);
}