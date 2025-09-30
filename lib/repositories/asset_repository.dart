import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/assets.dart';
import '../models/asset_relationships.dart';
import 'dart:convert';

class AssetRepository {
  final MadnessDatabase _db;

  AssetRepository(this._db);

  /// Convert Asset model to database row
  AssetRowsCompanion _assetToCompanion(Asset asset) {
    return AssetRowsCompanion(
      id: Value(asset.id),
      type: Value(asset.type.toString()),
      projectId: Value(asset.projectId),
      name: Value(asset.name),
      description: Value(asset.description),
      properties: Value(jsonEncode(asset.properties.map(
        (k, v) => MapEntry(k, v.toJson())
      ))),
      discoveryStatus: Value(asset.discoveryStatus.toString()),
      discoveredAt: Value(asset.discoveredAt),
      lastUpdated: Value(asset.lastUpdated),
      discoveryMethod: Value(asset.discoveryMethod),
      confidence: Value(asset.confidence),
      parentAssetIds: Value(jsonEncode(asset.parentAssetIds)),
      childAssetIds: Value(jsonEncode(asset.childAssetIds)),
      relatedAssetIds: Value(jsonEncode(asset.relatedAssetIds)),
      completedTriggers: Value(jsonEncode(asset.completedTriggers)),
      triggerResults: Value(jsonEncode(asset.triggerResults.map(
        (k, v) => MapEntry(k, v.toJson())
      ))),
      tags: Value(jsonEncode(asset.tags)),
      metadata: Value(asset.metadata != null ? jsonEncode(asset.metadata) : null),
      accessLevel: Value(asset.accessLevel?.toString()),
      securityControls: Value(asset.securityControls != null
        ? jsonEncode(asset.securityControls) : null),

      // NEW FIELDS:
      relationships: Value(jsonEncode(asset.relationships)),
      inheritedProperties: Value(jsonEncode(asset.inheritedProperties)),
      lifecycleState: Value(asset.lifecycleState),
      stateTransitions: Value(jsonEncode(asset.stateTransitions.map(
        (k, v) => MapEntry(k, v.toIso8601String())
      ))),
      dependencyMap: Value(jsonEncode(asset.dependencyMap)),
      discoveryPath: Value(jsonEncode(asset.discoveryPath)),
      relationshipMetadata: Value(jsonEncode(asset.relationshipMetadata)),
    );
  }

  /// Convert database row to Asset model
  Asset _rowToAsset(AssetRow row) {
    final propertiesJson = jsonDecode(row.properties) as Map<String, dynamic>;
    final properties = propertiesJson.map(
      (k, v) => MapEntry(k, AssetPropertyValue.fromJson(v))
    );

    final triggerResultsJson = jsonDecode(row.triggerResults) as Map<String, dynamic>;
    final triggerResults = triggerResultsJson.map(
      (k, v) => MapEntry(k, TriggerExecutionResult.fromJson(v))
    );

    final stateTransitionsJson = jsonDecode(row.stateTransitions) as Map<String, dynamic>;
    final stateTransitions = stateTransitionsJson.map(
      (k, v) => MapEntry(k, DateTime.parse(v))
    );

    return Asset(
      id: row.id,
      type: AssetType.values.firstWhere(
        (e) => e.toString() == row.type
      ),
      projectId: row.projectId,
      name: row.name,
      description: row.description,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.values.firstWhere(
        (e) => e.toString() == row.discoveryStatus
      ),
      discoveredAt: row.discoveredAt,
      lastUpdated: row.lastUpdated,
      discoveryMethod: row.discoveryMethod,
      confidence: row.confidence,
      parentAssetIds: List<String>.from(jsonDecode(row.parentAssetIds)),
      childAssetIds: List<String>.from(jsonDecode(row.childAssetIds)),
      relatedAssetIds: List<String>.from(jsonDecode(row.relatedAssetIds)),
      completedTriggers: List<String>.from(jsonDecode(row.completedTriggers)),
      triggerResults: triggerResults,
      tags: List<String>.from(jsonDecode(row.tags)),
      metadata: row.metadata != null
        ? Map<String, String>.from(jsonDecode(row.metadata!)) : null,
      accessLevel: row.accessLevel != null
        ? AccessLevel.values.firstWhere((e) => e.toString() == row.accessLevel)
        : null,
      securityControls: row.securityControls != null
        ? List<String>.from(jsonDecode(row.securityControls!))
        : null,

      // NEW FIELDS:
      relationships: Map<String, List<String>>.from(
        jsonDecode(row.relationships).map(
          (k, v) => MapEntry(k, List<String>.from(v))
        )
      ),
      inheritedProperties: Map<String, dynamic>.from(jsonDecode(row.inheritedProperties)),
      lifecycleState: row.lifecycleState,
      stateTransitions: stateTransitions,
      dependencyMap: Map<String, String>.from(jsonDecode(row.dependencyMap)),
      discoveryPath: List<String>.from(jsonDecode(row.discoveryPath)),
      relationshipMetadata: Map<String, dynamic>.from(jsonDecode(row.relationshipMetadata)),
    );
  }

  /// Get asset by ID
  Future<Asset?> getAsset(String assetId) async {
    final query = _db.select(_db.assetsTable)
      ..where((a) => a.id.equals(assetId));
    final row = await query.getSingleOrNull();
    return row != null ? _rowToAsset(row) : null;
  }

  /// Create or update asset
  Future<void> saveAsset(Asset asset) async {
    await _db.into(_db.assetsTable).insertOnConflictUpdate(
      _assetToCompanion(asset)
    );
  }

  /// Get all assets for a project
  Future<List<Asset>> getProjectAssets(String projectId) async {
    final query = _db.select(_db.assetsTable)
      ..where((a) => a.projectId.equals(projectId));
    final rows = await query.get();
    return rows.map(_rowToAsset).toList();
  }

  /// Delete asset
  Future<void> deleteAsset(String assetId) async {
    await (_db.delete(_db.assetsTable)
      ..where((a) => a.id.equals(assetId)))
      .go();
  }

  /// Search assets by property
  Future<List<Asset>> searchAssetsByProperty(
    String projectId,
    String propertyKey,
    String propertyValue
  ) async {
    // Use the property index table for efficient search
    final indexQuery = _db.select(_db.assetPropertyIndexTable)
      ..where((idx) =>
        idx.propertyKey.equals(propertyKey) &
        idx.propertyValue.contains(propertyValue)
      );

    final indexRows = await indexQuery.get();
    final assetIds = indexRows.map((r) => r.assetId).toSet();

    if (assetIds.isEmpty) return [];

    final assetQuery = _db.select(_db.assetsTable)
      ..where((a) =>
        a.projectId.equals(projectId) &
        a.id.isIn(assetIds)
      );

    final rows = await assetQuery.get();
    return rows.map(_rowToAsset).toList();
  }

  /// Get assets by lifecycle state
  Future<List<Asset>> getAssetsByState(String projectId, String lifecycleState) async {
    final query = _db.select(_db.assetsTable)
      ..where((a) =>
        a.projectId.equals(projectId) &
        a.lifecycleState.equals(lifecycleState)
      );
    final rows = await query.get();
    return rows.map(_rowToAsset).toList();
  }

  /// Get assets by type
  Future<List<Asset>> getAssetsByType(String projectId, AssetType assetType) async {
    final query = _db.select(_db.assetsTable)
      ..where((a) =>
        a.projectId.equals(projectId) &
        a.type.equals(assetType.toString())
      );
    final rows = await query.get();
    return rows.map(_rowToAsset).toList();
  }

  /// Create asset relationship
  Future<void> createRelationship(
    String parentId,
    String childId,
    String relationshipType,
    {Map<String, dynamic>? metadata}
  ) async {
    await _db.into(_db.assetRelationshipsTable).insert(
      AssetRelationshipRowsCompanion(
        parentAssetId: Value(parentId),
        childAssetId: Value(childId),
        relationshipType: Value(relationshipType),
        createdAt: Value(DateTime.now()),
        metadata: Value(metadata != null ? jsonEncode(metadata) : null),
      ),
    );
  }

  /// Delete asset relationship
  Future<void> deleteRelationship(
    String parentId,
    String childId,
    String relationshipType,
  ) async {
    await (_db.delete(_db.assetRelationshipsTable)
      ..where((r) =>
        r.parentAssetId.equals(parentId) &
        r.childAssetId.equals(childId) &
        r.relationshipType.equals(relationshipType)
      )).go();
  }

  /// Get relationships for an asset
  Future<List<AssetRelationshipRow>> getAssetRelationships(String assetId) async {
    final query = _db.select(_db.assetRelationshipsTable)
      ..where((r) => r.parentAssetId.equals(assetId) | r.childAssetId.equals(assetId));
    return await query.get();
  }

  /// Update property index for efficient searching
  Future<void> updatePropertyIndex(Asset asset) async {
    // First, remove existing index entries for this asset
    await (_db.delete(_db.assetPropertyIndexTable)
      ..where((idx) => idx.assetId.equals(asset.id)))
      .go();

    // Create new index entries for searchable properties
    final indexEntries = <AssetPropertyIndexRowsCompanion>[];

    for (final entry in asset.properties.entries) {
      final key = entry.key;
      final value = entry.value;

      String stringValue;
      String propertyType;

      value.when(
        string: (v) {
          stringValue = v;
          propertyType = 'string';
        },
        integer: (v) {
          stringValue = v.toString();
          propertyType = 'integer';
        },
        double: (v) {
          stringValue = v.toString();
          propertyType = 'double';
        },
        boolean: (v) {
          stringValue = v.toString();
          propertyType = 'boolean';
        },
        stringList: (v) {
          stringValue = v.join('|');
          propertyType = 'stringList';
        },
        dateTime: (v) {
          stringValue = v.toIso8601String();
          propertyType = 'dateTime';
        },
        map: (v) {
          stringValue = jsonEncode(v);
          propertyType = 'map';
        },
        objectList: (v) {
          stringValue = jsonEncode(v);
          propertyType = 'objectList';
        },
      );

      indexEntries.add(AssetPropertyIndexRowsCompanion(
        assetId: Value(asset.id),
        propertyKey: Value(key),
        propertyValue: Value(stringValue),
        propertyType: Value(propertyType),
        indexedAt: Value(DateTime.now()),
      ));
    }

    // Batch insert index entries
    if (indexEntries.isNotEmpty) {
      await _db.batch((batch) {
        batch.insertAll(_db.assetPropertyIndexTable, indexEntries);
      });
    }
  }

  /// Get asset statistics for a project
  Future<Map<String, dynamic>> getAssetStatistics(String projectId) async {
    final query = _db.select(_db.assetsTable)
      ..where((a) => a.projectId.equals(projectId));
    final assets = await query.get();

    final stats = <String, dynamic>{
      'total': assets.length,
      'by_type': <String, int>{},
      'by_state': <String, int>{},
      'by_discovery_status': <String, int>{},
    };

    for (final asset in assets) {
      // Count by type
      final typeKey = asset.type;
      stats['by_type'][typeKey] = (stats['by_type'][typeKey] ?? 0) + 1;

      // Count by lifecycle state
      final stateKey = asset.lifecycleState;
      stats['by_state'][stateKey] = (stats['by_state'][stateKey] ?? 0) + 1;

      // Count by discovery status
      final discoveryKey = asset.discoveryStatus;
      stats['by_discovery_status'][discoveryKey] = (stats['by_discovery_status'][discoveryKey] ?? 0) + 1;
    }

    return stats;
  }

  /// Bulk update assets (for performance)
  Future<void> bulkSaveAssets(List<Asset> assets) async {
    await _db.batch((batch) {
      for (final asset in assets) {
        batch.insert(
          _db.assetsTable,
          _assetToCompanion(asset),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  /// Get assets with specific properties
  Future<List<Asset>> getAssetsWithProperties(
    String projectId,
    Map<String, dynamic> propertyFilters,
  ) async {
    // This is a complex query - for now, we'll load all assets and filter in memory
    // In production, you might want to optimize this with custom SQL queries
    final allAssets = await getProjectAssets(projectId);

    return allAssets.where((asset) {
      for (final filter in propertyFilters.entries) {
        final key = filter.key;
        final expectedValue = filter.value;
        final actualProperty = asset.properties[key];

        if (actualProperty == null) return false;

        bool matches = false;
        actualProperty.when(
          string: (v) => matches = v == expectedValue,
          integer: (v) => matches = v == expectedValue,
          double: (v) => matches = v == expectedValue,
          boolean: (v) => matches = v == expectedValue,
          stringList: (v) => matches = expectedValue is List ?
            expectedValue.every((item) => v.contains(item)) : v.contains(expectedValue),
          dateTime: (v) => matches = v == expectedValue,
          map: (v) => matches = v.toString() == expectedValue.toString(),
          objectList: (v) => matches = v.toString() == expectedValue.toString(),
        );

        if (!matches) return false;
      }
      return true;
    }).toList();
  }
}