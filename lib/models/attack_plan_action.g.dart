// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attack_plan_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TriggerEventImpl _$$TriggerEventImplFromJson(Map<String, dynamic> json) =>
    _$TriggerEventImpl(
      triggerId: json['triggerId'] as String,
      assetId: json['assetId'] as String,
      assetName: json['assetName'] as String,
      assetType: json['assetType'] as String,
      matchedConditions: json['matchedConditions'] as Map<String, dynamic>,
      extractedValues: json['extractedValues'] as Map<String, dynamic>,
      evaluatedAt: DateTime.parse(json['evaluatedAt'] as String),
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$TriggerEventImplToJson(_$TriggerEventImpl instance) =>
    <String, dynamic>{
      'triggerId': instance.triggerId,
      'assetId': instance.assetId,
      'assetName': instance.assetName,
      'assetType': instance.assetType,
      'matchedConditions': instance.matchedConditions,
      'extractedValues': instance.extractedValues,
      'evaluatedAt': instance.evaluatedAt.toIso8601String(),
      'confidence': instance.confidence,
    };

_$ActionToolImpl _$$ActionToolImplFromJson(Map<String, dynamic> json) =>
    _$ActionToolImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      installation: json['installation'] as String?,
      required: json['required'] as bool? ?? true,
      alternatives: (json['alternatives'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ActionToolImplToJson(_$ActionToolImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'installation': instance.installation,
      'required': instance.required,
      'alternatives': instance.alternatives,
    };

_$ActionEquipmentImpl _$$ActionEquipmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ActionEquipmentImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      required: json['required'] as bool? ?? true,
      specifications: json['specifications'] as String?,
    );

Map<String, dynamic> _$$ActionEquipmentImplToJson(
        _$ActionEquipmentImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'required': instance.required,
      'specifications': instance.specifications,
    };

_$ActionReferenceImpl _$$ActionReferenceImplFromJson(
        Map<String, dynamic> json) =>
    _$ActionReferenceImpl(
      title: json['title'] as String,
      url: json['url'] as String,
      description: json['description'] as String?,
      type: json['type'] as String? ?? 'documentation',
    );

Map<String, dynamic> _$$ActionReferenceImplToJson(
        _$ActionReferenceImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': instance.url,
      'description': instance.description,
      'type': instance.type,
    };

_$ActionRiskImpl _$$ActionRiskImplFromJson(Map<String, dynamic> json) =>
    _$ActionRiskImpl(
      risk: json['risk'] as String,
      mitigation: json['mitigation'] as String,
      severity:
          $enumDecodeNullable(_$ActionRiskLevelEnumMap, json['severity']) ??
              ActionRiskLevel.medium,
    );

Map<String, dynamic> _$$ActionRiskImplToJson(_$ActionRiskImpl instance) =>
    <String, dynamic>{
      'risk': instance.risk,
      'mitigation': instance.mitigation,
      'severity': _$ActionRiskLevelEnumMap[instance.severity]!,
    };

const _$ActionRiskLevelEnumMap = {
  ActionRiskLevel.minimal: 'minimal',
  ActionRiskLevel.low: 'low',
  ActionRiskLevel.medium: 'medium',
  ActionRiskLevel.high: 'high',
  ActionRiskLevel.critical: 'critical',
};

_$ProcedureStepImpl _$$ProcedureStepImplFromJson(Map<String, dynamic> json) =>
    _$ProcedureStepImpl(
      stepNumber: (json['stepNumber'] as num).toInt(),
      description: json['description'] as String,
      command: json['command'] as String?,
      expectedOutput: json['expectedOutput'] as String?,
      notes: json['notes'] as String?,
      mandatory: json['mandatory'] as bool? ?? true,
    );

Map<String, dynamic> _$$ProcedureStepImplToJson(_$ProcedureStepImpl instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'description': instance.description,
      'command': instance.command,
      'expectedOutput': instance.expectedOutput,
      'notes': instance.notes,
      'mandatory': instance.mandatory,
    };

_$SuggestedFindingImpl _$$SuggestedFindingImplFromJson(
        Map<String, dynamic> json) =>
    _$SuggestedFindingImpl(
      title: json['title'] as String,
      description: json['description'] as String,
      severity:
          $enumDecodeNullable(_$ActionRiskLevelEnumMap, json['severity']) ??
              ActionRiskLevel.medium,
      cvssScore: (json['cvssScore'] as num?)?.toDouble(),
      category: json['category'] as String?,
    );

Map<String, dynamic> _$$SuggestedFindingImplToJson(
        _$SuggestedFindingImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'severity': _$ActionRiskLevelEnumMap[instance.severity]!,
      'cvssScore': instance.cvssScore,
      'category': instance.category,
    };

_$ActionExecutionImpl _$$ActionExecutionImplFromJson(
        Map<String, dynamic> json) =>
    _$ActionExecutionImpl(
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      executedBy: json['executedBy'] as String?,
      executedCommands: (json['executedCommands'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      capturedOutputs: (json['capturedOutputs'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      evidenceFiles: (json['evidenceFiles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      findingIds: (json['findingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      executionNotes: json['executionNotes'] as String?,
      successful: json['successful'] as bool?,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$$ActionExecutionImplToJson(
        _$ActionExecutionImpl instance) =>
    <String, dynamic>{
      'startedAt': instance.startedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'executedBy': instance.executedBy,
      'executedCommands': instance.executedCommands,
      'capturedOutputs': instance.capturedOutputs,
      'evidenceFiles': instance.evidenceFiles,
      'findingIds': instance.findingIds,
      'executionNotes': instance.executionNotes,
      'successful': instance.successful,
      'errorMessage': instance.errorMessage,
    };

_$AttackPlanActionImpl _$$AttackPlanActionImplFromJson(
        Map<String, dynamic> json) =>
    _$AttackPlanActionImpl(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      title: json['title'] as String,
      objective: json['objective'] as String,
      status: $enumDecodeNullable(_$ActionStatusEnumMap, json['status']) ??
          ActionStatus.pending,
      priority:
          $enumDecodeNullable(_$ActionPriorityEnumMap, json['priority']) ??
              ActionPriority.medium,
      riskLevel:
          $enumDecodeNullable(_$ActionRiskLevelEnumMap, json['riskLevel']) ??
              ActionRiskLevel.medium,
      triggerEvents: (json['triggerEvents'] as List<dynamic>?)
              ?.map((e) => TriggerEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      risks: (json['risks'] as List<dynamic>?)
              ?.map((e) => ActionRisk.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      procedure: (json['procedure'] as List<dynamic>?)
              ?.map((e) => ProcedureStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tools: (json['tools'] as List<dynamic>?)
              ?.map((e) => ActionTool.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => ActionEquipment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      references: (json['references'] as List<dynamic>?)
              ?.map((e) => ActionReference.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suggestedFindings: (json['suggestedFindings'] as List<dynamic>?)
              ?.map((e) => SuggestedFinding.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cleanupSteps: (json['cleanupSteps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      execution: json['execution'] == null
          ? null
          : ActionExecution.fromJson(json['execution'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      createdBy: json['createdBy'] as String? ?? 'system',
      templateId: json['templateId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$AttackPlanActionImplToJson(
        _$AttackPlanActionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'title': instance.title,
      'objective': instance.objective,
      'status': _$ActionStatusEnumMap[instance.status]!,
      'priority': _$ActionPriorityEnumMap[instance.priority]!,
      'riskLevel': _$ActionRiskLevelEnumMap[instance.riskLevel]!,
      'triggerEvents': instance.triggerEvents,
      'risks': instance.risks,
      'procedure': instance.procedure,
      'tools': instance.tools,
      'equipment': instance.equipment,
      'references': instance.references,
      'suggestedFindings': instance.suggestedFindings,
      'cleanupSteps': instance.cleanupSteps,
      'tags': instance.tags,
      'execution': instance.execution,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'templateId': instance.templateId,
      'metadata': instance.metadata,
    };

const _$ActionStatusEnumMap = {
  ActionStatus.pending: 'pending',
  ActionStatus.inProgress: 'inProgress',
  ActionStatus.completed: 'completed',
  ActionStatus.blocked: 'blocked',
  ActionStatus.skipped: 'skipped',
};

const _$ActionPriorityEnumMap = {
  ActionPriority.critical: 'critical',
  ActionPriority.high: 'high',
  ActionPriority.medium: 'medium',
  ActionPriority.low: 'low',
};
