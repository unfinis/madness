// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trigger_evaluation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TriggerMatch _$TriggerMatchFromJson(Map<String, dynamic> json) =>
    _TriggerMatch(
      id: json['id'] as String,
      triggerId: json['triggerId'] as String,
      templateId: json['templateId'] as String,
      assetId: json['assetId'] as String,
      matched: json['matched'] as bool,
      extractedValues: json['extractedValues'] as Map<String, dynamic>,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      evaluatedAt: DateTime.parse(json['evaluatedAt'] as String),
      priority: (json['priority'] as num?)?.toInt() ?? 5,
      error: json['error'] as String?,
      debugInfo: json['debugInfo'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$TriggerMatchToJson(_TriggerMatch instance) =>
    <String, dynamic>{
      'id': instance.id,
      'triggerId': instance.triggerId,
      'templateId': instance.templateId,
      'assetId': instance.assetId,
      'matched': instance.matched,
      'extractedValues': instance.extractedValues,
      'confidence': instance.confidence,
      'evaluatedAt': instance.evaluatedAt.toIso8601String(),
      'priority': instance.priority,
      'error': instance.error,
      'debugInfo': instance.debugInfo,
    };

_ParameterResolution _$ParameterResolutionFromJson(Map<String, dynamic> json) =>
    _ParameterResolution(
      name: json['name'] as String,
      type: $enumDecode(_$ParameterTypeEnumMap, json['type']),
      value: json['value'],
      source: $enumDecode(_$ParameterSourceEnumMap, json['source']),
      required: json['required'] as bool? ?? false,
      resolved: json['resolved'] as bool? ?? true,
      error: json['error'] as String?,
      resolvedAt: DateTime.parse(json['resolvedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ParameterResolutionToJson(
  _ParameterResolution instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': _$ParameterTypeEnumMap[instance.type]!,
  'value': instance.value,
  'source': _$ParameterSourceEnumMap[instance.source]!,
  'required': instance.required,
  'resolved': instance.resolved,
  'error': instance.error,
  'resolvedAt': instance.resolvedAt.toIso8601String(),
  'metadata': instance.metadata,
};

const _$ParameterTypeEnumMap = {
  ParameterType.ip: 'ip',
  ParameterType.hostname: 'hostname',
  ParameterType.credential: 'credential',
  ParameterType.string: 'string',
  ParameterType.number: 'number',
  ParameterType.boolean: 'boolean',
  ParameterType.port: 'port',
  ParameterType.domain: 'domain',
  ParameterType.url: 'url',
  ParameterType.list: 'list',
};

const _$ParameterSourceEnumMap = {
  ParameterSource.assetField: 'assetField',
  ParameterSource.userInput: 'userInput',
  ParameterSource.credentialStore: 'credentialStore',
  ParameterSource.defaultValue: 'defaultValue',
  ParameterSource.triggerMatch: 'triggerMatch',
  ParameterSource.computed: 'computed',
};

_TriggerConditionResult _$TriggerConditionResultFromJson(
  Map<String, dynamic> json,
) => _TriggerConditionResult(
  expression: json['expression'] as String,
  result: json['result'] as bool,
  variables: json['variables'] as Map<String, dynamic>,
  executionTimeMs: (json['executionTimeMs'] as num?)?.toInt() ?? 0,
  error: json['error'] as String?,
  debugTrace:
      (json['debugTrace'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$TriggerConditionResultToJson(
  _TriggerConditionResult instance,
) => <String, dynamic>{
  'expression': instance.expression,
  'result': instance.result,
  'variables': instance.variables,
  'executionTimeMs': instance.executionTimeMs,
  'error': instance.error,
  'debugTrace': instance.debugTrace,
};

_TriggerContext _$TriggerContextFromJson(Map<String, dynamic> json) =>
    _TriggerContext(
      variables: json['variables'] as Map<String, dynamic>? ?? const {},
      asset: json['asset'] as Map<String, dynamic>?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$TriggerContextToJson(_TriggerContext instance) =>
    <String, dynamic>{
      'variables': instance.variables,
      'asset': instance.asset,
      'metadata': instance.metadata,
    };
