// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetRelationship _$AssetRelationshipFromJson(Map<String, dynamic> json) =>
    _AssetRelationship(
      id: json['id'] as String,
      parentAssetId: json['parentAssetId'] as String,
      childAssetId: json['childAssetId'] as String,
      relationshipType: $enumDecode(
        _$AssetRelationshipTypeEnumMap,
        json['relationshipType'],
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AssetRelationshipToJson(_AssetRelationship instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentAssetId': instance.parentAssetId,
      'childAssetId': instance.childAssetId,
      'relationshipType':
          _$AssetRelationshipTypeEnumMap[instance.relationshipType]!,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$AssetRelationshipTypeEnumMap = {
  AssetRelationshipType.contains: 'contains',
  AssetRelationshipType.dependsOn: 'dependsOn',
  AssetRelationshipType.authenticatesTo: 'authenticatesTo',
  AssetRelationshipType.communicatesWith: 'communicatesWith',
};
