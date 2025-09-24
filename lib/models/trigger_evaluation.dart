import 'package:freezed_annotation/freezed_annotation.dart';

part 'trigger_evaluation.freezed.dart';
part 'trigger_evaluation.g.dart';

/// Result of evaluating a trigger against an asset
@freezed
sealed class TriggerMatch with _$TriggerMatch {
  const factory TriggerMatch({
    /// Unique identifier for this trigger match
    required String id,

    /// ID of the trigger that was evaluated
    required String triggerId,

    /// ID of the methodology template containing the trigger
    required String templateId,

    /// ID of the asset that was evaluated
    required String assetId,

    /// Whether the trigger condition matched
    required bool matched,

    /// Values extracted from the asset during evaluation
    required Map<String, dynamic> extractedValues,

    /// Confidence score of the match (0.0 - 1.0)
    @Default(1.0) double confidence,

    /// When this evaluation was performed
    required DateTime evaluatedAt,

    /// Priority of this trigger (from the trigger definition)
    @Default(5) int priority,

    /// Error message if evaluation failed
    String? error,

    /// Debug information about the evaluation
    @Default({}) Map<String, dynamic> debugInfo,
  }) = _TriggerMatch;

  factory TriggerMatch.fromJson(Map<String, dynamic> json) =>
      _$TriggerMatchFromJson(json);
}

/// Parameter resolution for a methodology instance
@freezed
sealed class ParameterResolution with _$ParameterResolution {
  const factory ParameterResolution({
    /// Name of the parameter
    required String name,

    /// Type of the parameter
    required ParameterType type,

    /// Resolved value for the parameter
    required dynamic value,

    /// Source where the value was resolved from
    required ParameterSource source,

    /// Whether this parameter is required
    @Default(false) bool required,

    /// Whether the parameter was successfully resolved
    @Default(true) bool resolved,

    /// Error message if resolution failed
    String? error,

    /// When this parameter was resolved
    required DateTime resolvedAt,

    /// Additional metadata about the resolution
    @Default({}) Map<String, dynamic> metadata,
  }) = _ParameterResolution;

  factory ParameterResolution.fromJson(Map<String, dynamic> json) =>
      _$ParameterResolutionFromJson(json);
}

/// Types of parameters that can be resolved
enum ParameterType {
  ip,
  hostname,
  credential,
  string,
  number,
  boolean,
  port,
  domain,
  url,
  list;

  String get displayName {
    switch (this) {
      case ParameterType.ip:
        return 'IP Address';
      case ParameterType.hostname:
        return 'Hostname';
      case ParameterType.credential:
        return 'Credential';
      case ParameterType.string:
        return 'String';
      case ParameterType.number:
        return 'Number';
      case ParameterType.boolean:
        return 'Boolean';
      case ParameterType.port:
        return 'Port';
      case ParameterType.domain:
        return 'Domain';
      case ParameterType.url:
        return 'URL';
      case ParameterType.list:
        return 'List';
    }
  }
}

/// Sources where parameter values can be resolved from
enum ParameterSource {
  assetField,
  userInput,
  credentialStore,
  defaultValue,
  triggerMatch,
  computed;

  String get displayName {
    switch (this) {
      case ParameterSource.assetField:
        return 'Asset Field';
      case ParameterSource.userInput:
        return 'User Input';
      case ParameterSource.credentialStore:
        return 'Credential Store';
      case ParameterSource.defaultValue:
        return 'Default Value';
      case ParameterSource.triggerMatch:
        return 'Trigger Match';
      case ParameterSource.computed:
        return 'Computed';
    }
  }
}

/// Trigger condition evaluation result
@freezed
sealed class TriggerConditionResult with _$TriggerConditionResult {
  const factory TriggerConditionResult({
    /// The original condition expression
    required String expression,

    /// Whether the condition evaluated to true
    required bool result,

    /// Values used in the evaluation
    required Map<String, dynamic> variables,

    /// Execution time in milliseconds
    @Default(0) int executionTimeMs,

    /// Error message if evaluation failed
    String? error,

    /// Debug trace of the evaluation
    @Default([]) List<String> debugTrace,
  }) = _TriggerConditionResult;

  factory TriggerConditionResult.fromJson(Map<String, dynamic> json) =>
      _$TriggerConditionResultFromJson(json);
}

/// DSL expression parser state and context
@freezed
sealed class TriggerContext with _$TriggerContext {
  const factory TriggerContext({
    /// Variables available in the context
    @Default({}) Map<String, dynamic> variables,

    /// Asset being evaluated
    Map<String, dynamic>? asset,

    /// Additional context data
    @Default({}) Map<String, dynamic> metadata,
  }) = _TriggerContext;

  factory TriggerContext.fromJson(Map<String, dynamic> json) =>
      _$TriggerContextFromJson(json);
}