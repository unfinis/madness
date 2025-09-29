// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_relationships.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RelationshipMetadata _$RelationshipMetadataFromJson(
  Map<String, dynamic> json,
) => _RelationshipMetadata(
  discoveryMethod: json['discoveryMethod'] as String? ?? '',
  confidence: json['confidence'] as String? ?? '',
  discoveredAt: json['discoveredAt'] == null
      ? null
      : DateTime.parse(json['discoveredAt'] as String),
  validatedAt: json['validatedAt'] == null
      ? null
      : DateTime.parse(json['validatedAt'] as String),
  additionalData: json['additionalData'] as Map<String, dynamic>? ?? const {},
  notes: json['notes'] as String? ?? '',
);

Map<String, dynamic> _$RelationshipMetadataToJson(
  _RelationshipMetadata instance,
) => <String, dynamic>{
  'discoveryMethod': instance.discoveryMethod,
  'confidence': instance.confidence,
  'discoveredAt': instance.discoveredAt?.toIso8601String(),
  'validatedAt': instance.validatedAt?.toIso8601String(),
  'additionalData': instance.additionalData,
  'notes': instance.notes,
};

_AssetRelationship _$AssetRelationshipFromJson(Map<String, dynamic> json) =>
    _AssetRelationship(
      id: json['id'] as String,
      sourceAssetId: json['sourceAssetId'] as String,
      targetAssetId: json['targetAssetId'] as String,
      relationshipType: $enumDecode(
        _$AssetRelationshipTypeEnumMap,
        json['relationshipType'],
      ),
      isBidirectional: json['isBidirectional'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] == null
          ? null
          : RelationshipMetadata.fromJson(
              json['metadata'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$AssetRelationshipToJson(_AssetRelationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceAssetId': instance.sourceAssetId,
      'targetAssetId': instance.targetAssetId,
      'relationshipType':
          _$AssetRelationshipTypeEnumMap[instance.relationshipType]!,
      'isBidirectional': instance.isBidirectional,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$AssetRelationshipTypeEnumMap = {
  AssetRelationshipType.parentOf: 'parent_of',
  AssetRelationshipType.childOf: 'child_of',
  AssetRelationshipType.connectedTo: 'connected_to',
  AssetRelationshipType.routesTo: 'routes_to',
  AssetRelationshipType.bridgedTo: 'bridged_to',
  AssetRelationshipType.vlannedTo: 'vlanned_to',
  AssetRelationshipType.trusts: 'trusts',
  AssetRelationshipType.trustedBy: 'trusted_by',
  AssetRelationshipType.authenticatesTo: 'authenticates_to',
  AssetRelationshipType.authenticatedBy: 'authenticated_by',
  AssetRelationshipType.manages: 'manages',
  AssetRelationshipType.managedBy: 'managed_by',
  AssetRelationshipType.hosts: 'hosts',
  AssetRelationshipType.hostedBy: 'hosted_by',
  AssetRelationshipType.dependsOn: 'depends_on',
  AssetRelationshipType.dependencyOf: 'dependency_of',
  AssetRelationshipType.communicatesWith: 'communicates_with',
  AssetRelationshipType.discoveredVia: 'discovered_via',
  AssetRelationshipType.ledToDiscoveryOf: 'led_to_discovery_of',
  AssetRelationshipType.sharesCredentialsWith: 'shares_credentials_with',
  AssetRelationshipType.vulnerableTo: 'vulnerable_to',
};
