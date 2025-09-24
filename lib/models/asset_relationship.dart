import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_relationship.freezed.dart';
part 'asset_relationship.g.dart';

@freezed
sealed class AssetRelationship with _$AssetRelationship {
  const factory AssetRelationship({
    required String id,
    required String parentAssetId,
    required String childAssetId,
    required AssetRelationshipType relationshipType,
    required DateTime createdAt,
  }) = _AssetRelationship;

  factory AssetRelationship.fromJson(Map<String, dynamic> json) =>
      _$AssetRelationshipFromJson(json);
}

enum AssetRelationshipType {
  contains,
  dependsOn,
  authenticatesTo,
  communicatesWith,
}