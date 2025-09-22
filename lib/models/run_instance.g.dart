// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run_instance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RunInstanceImpl _$$RunInstanceImplFromJson(Map<String, dynamic> json) =>
    _$RunInstanceImpl(
      runId: json['runId'] as String,
      templateId: json['templateId'] as String,
      templateVersion: json['templateVersion'] as String,
      triggerId: json['triggerId'] as String,
      assetId: json['assetId'] as String,
      matchedValues: json['matchedValues'] as Map<String, dynamic>,
      parameters: json['parameters'] as Map<String, dynamic>,
      status: $enumDecode(_$RunInstanceStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String,
      evidenceIds: (json['evidenceIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      findingIds: (json['findingIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      history: (json['history'] as List<dynamic>?)
              ?.map((e) => HistoryEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: json['notes'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      priority: (json['priority'] as num?)?.toInt() ?? 5,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$RunInstanceImplToJson(_$RunInstanceImpl instance) =>
    <String, dynamic>{
      'runId': instance.runId,
      'templateId': instance.templateId,
      'templateVersion': instance.templateVersion,
      'triggerId': instance.triggerId,
      'assetId': instance.assetId,
      'matchedValues': instance.matchedValues,
      'parameters': instance.parameters,
      'status': _$RunInstanceStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
      'evidenceIds': instance.evidenceIds,
      'findingIds': instance.findingIds,
      'history': instance.history,
      'notes': instance.notes,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'priority': instance.priority,
      'tags': instance.tags,
    };

const _$RunInstanceStatusEnumMap = {
  RunInstanceStatus.pending: 'pending',
  RunInstanceStatus.inProgress: 'inProgress',
  RunInstanceStatus.completed: 'completed',
  RunInstanceStatus.blocked: 'blocked',
  RunInstanceStatus.failed: 'failed',
};

_$HistoryEntryImpl _$$HistoryEntryImplFromJson(Map<String, dynamic> json) =>
    _$HistoryEntryImpl(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      performedBy: json['performedBy'] as String,
      action: $enumDecode(_$HistoryActionTypeEnumMap, json['action']),
      description: json['description'] as String,
      previousValue: json['previousValue'] as String?,
      newValue: json['newValue'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$$HistoryEntryImplToJson(_$HistoryEntryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'performedBy': instance.performedBy,
      'action': _$HistoryActionTypeEnumMap[instance.action]!,
      'description': instance.description,
      'previousValue': instance.previousValue,
      'newValue': instance.newValue,
      'metadata': instance.metadata,
    };

const _$HistoryActionTypeEnumMap = {
  HistoryActionType.created: 'created',
  HistoryActionType.statusChanged: 'statusChanged',
  HistoryActionType.parameterUpdated: 'parameterUpdated',
  HistoryActionType.evidenceAdded: 'evidenceAdded',
  HistoryActionType.findingGenerated: 'findingGenerated',
  HistoryActionType.noteAdded: 'noteAdded',
  HistoryActionType.priorityChanged: 'priorityChanged',
  HistoryActionType.tagAdded: 'tagAdded',
  HistoryActionType.tagRemoved: 'tagRemoved',
};
