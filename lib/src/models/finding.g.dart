// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finding.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Finding _$FindingFromJson(Map<String, dynamic> json) => _Finding(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  severity: $enumDecode(_$FindingSeverityEnumMap, json['severity']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  cvssScore: json['cvssScore'] as String?,
  cweId: json['cweId'] as String?,
  affectedSystems: json['affectedSystems'] as String?,
  remediation: json['remediation'] as String?,
  references: json['references'] as String?,
  templateId: json['templateId'] as String?,
  masterFindingId: json['masterFindingId'] as String?,
  subFindingIds:
      (json['subFindingIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  customFields: json['customFields'] as Map<String, dynamic>? ?? const {},
  imageIds:
      (json['imageIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  variables:
      (json['variables'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  status:
      $enumDecodeNullable(_$FindingStatusEnumMap, json['status']) ??
      FindingStatus.draft,
);

Map<String, dynamic> _$FindingToJson(_Finding instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'severity': _$FindingSeverityEnumMap[instance.severity]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'cvssScore': instance.cvssScore,
  'cweId': instance.cweId,
  'affectedSystems': instance.affectedSystems,
  'remediation': instance.remediation,
  'references': instance.references,
  'templateId': instance.templateId,
  'masterFindingId': instance.masterFindingId,
  'subFindingIds': instance.subFindingIds,
  'customFields': instance.customFields,
  'imageIds': instance.imageIds,
  'variables': instance.variables,
  'status': _$FindingStatusEnumMap[instance.status]!,
};

const _$FindingSeverityEnumMap = {
  FindingSeverity.critical: 'critical',
  FindingSeverity.high: 'high',
  FindingSeverity.medium: 'medium',
  FindingSeverity.low: 'low',
  FindingSeverity.informational: 'informational',
};

const _$FindingStatusEnumMap = {
  FindingStatus.draft: 'draft',
  FindingStatus.review: 'review',
  FindingStatus.approved: 'approved',
  FindingStatus.published: 'published',
};
