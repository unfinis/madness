// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssetRelationshipImpl _$$AssetRelationshipImplFromJson(
        Map<String, dynamic> json) =>
    _$AssetRelationshipImpl(
      id: json['id'] as String,
      parentAssetId: json['parentAssetId'] as String,
      childAssetId: json['childAssetId'] as String,
      relationshipType:
          $enumDecode(_$AssetRelationshipTypeEnumMap, json['relationshipType']),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$AssetRelationshipImplToJson(
        _$AssetRelationshipImpl instance) =>
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
