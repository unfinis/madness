import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../services/drift_storage_service.dart';
import '../services/comprehensive_trigger_evaluator.dart';
import '../services/asset_trigger_integration_service.dart';
import '../providers/storage_provider.dart';

/// Provider for comprehensive trigger evaluator
final triggerEvaluationServiceProvider = Provider.family<ComprehensiveTriggerEvaluator, String>((ref, projectId) {
  final storage = ref.read(storageServiceProvider);
  return ComprehensiveTriggerEvaluator(
    storage: storage,
    projectId: projectId,
  );
});

/// Provider for asset trigger integration service
final assetTriggerIntegrationProvider = Provider.family<AssetTriggerIntegrationService, String>((ref, projectId) {
  final storage = ref.read(storageServiceProvider);
  final triggerEvaluator = ref.read(triggerEvaluationServiceProvider(projectId));
  return AssetTriggerIntegrationService(
    storage: storage,
    triggerEvaluator: triggerEvaluator,
    projectId: projectId,
  );
});

/// Provider for comprehensive asset management with trigger evaluation integration
final assetServiceProvider = Provider.family<AssetService, String>((ref, projectId) {
  final storage = ref.read(storageServiceProvider);
  final triggerEvaluator = ref.read(triggerEvaluationServiceProvider(projectId));
  final integrationService = ref.read(assetTriggerIntegrationProvider(projectId));
  return AssetService(
    storage: storage,
    triggerEvaluator: triggerEvaluator,
    integrationService: integrationService,
    projectId: projectId,
  );
});

/// Provider for all assets in a project
final assetsProvider = FutureProvider.family<List<Asset>, String>((ref, projectId) async {
  final assetService = ref.read(assetServiceProvider(projectId));
  return await assetService.getAllAssets();
});

/// Provider for assets by type
final assetsByTypeProvider = FutureProvider.family<List<Asset>, ({String projectId, AssetType type})>((ref, params) async {
  final assetService = ref.read(assetServiceProvider(params.projectId));
  return await assetService.getAssetsByType(params.type);
});

/// Provider for a specific asset
final assetProvider = FutureProvider.family<Asset?, ({String projectId, String assetId})>((ref, params) async {
  final assetService = ref.read(assetServiceProvider(params.projectId));
  return await assetService.getAsset(params.assetId);
});

/// Provider for asset relationships
final assetRelationshipsProvider = FutureProvider.family<List<AssetRelationship>, ({String projectId, String assetId})>((ref, params) async {
  final assetService = ref.read(assetServiceProvider(params.projectId));
  return await assetService.getAssetRelationships(params.assetId);
});

/// Provider for asset property search
final assetPropertySearchProvider = FutureProvider.family<List<Asset>, ({String projectId, String propertyKey, String propertyValue})>((ref, params) async {
  final assetService = ref.read(assetServiceProvider(params.projectId));
  return await assetService.searchAssetsByProperty(params.propertyKey, params.propertyValue);
});

/// State notifier for managing assets
class AssetNotifier extends StateNotifier<AsyncValue<List<Asset>>> {
  final AssetService _assetService;
  final String _projectId;

  AssetNotifier(this._assetService, this._projectId) : super(const AsyncValue.loading()) {
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      final assets = await _assetService.getAllAssets();
      state = AsyncValue.data(assets);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Add a new asset and trigger evaluation
  Future<void> addAsset(Asset asset) async {
    try {
      await _assetService.createAsset(asset);
      await _loadAssets(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update an existing asset and trigger re-evaluation
  Future<void> updateAsset(Asset asset) async {
    try {
      await _assetService.updateAsset(asset);
      await _loadAssets(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Delete an asset
  Future<void> deleteAsset(String assetId) async {
    try {
      await _assetService.deleteAsset(assetId);
      await _loadAssets(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh assets
  void refresh() {
    _loadAssets();
  }

  /// Bulk import assets
  Future<void> importAssets(List<Asset> assets) async {
    try {
      await _assetService.bulkImportAssets(assets);
      await _loadAssets(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// Provider for the asset notifier
final assetNotifierProvider = StateNotifierProvider.family<AssetNotifier, AsyncValue<List<Asset>>, String>((ref, projectId) {
  final assetService = ref.read(assetServiceProvider(projectId));
  return AssetNotifier(assetService, projectId);
});

/// Comprehensive asset service with trigger evaluation integration
class AssetService {
  final DriftStorageService _storage;
  final ComprehensiveTriggerEvaluator _triggerEvaluator;
  final AssetTriggerIntegrationService _integrationService;
  final String _projectId;
  final Uuid _uuid = const Uuid();

  AssetService({
    required DriftStorageService storage,
    required ComprehensiveTriggerEvaluator triggerEvaluator,
    required AssetTriggerIntegrationService integrationService,
    required String projectId,
  }) : _storage = storage,
       _triggerEvaluator = triggerEvaluator,
       _integrationService = integrationService,
       _projectId = projectId;

  /// Get all assets for the project
  Future<List<Asset>> getAllAssets() async {
    return await _storage.getAllAssets(_projectId);
  }

  /// Get assets by type
  Future<List<Asset>> getAssetsByType(AssetType type) async {
    return await _storage.getAssetsByType(_projectId, type.name);
  }

  /// Get a specific asset by ID
  Future<Asset?> getAsset(String assetId) async {
    return await _storage.getAsset(assetId);
  }

  /// Create a new asset with automatic trigger evaluation
  Future<Asset> createAsset(Asset asset) async {
    // Ensure the asset has a valid ID and project ID
    final assetToCreate = asset.copyWith(
      id: asset.id.isEmpty ? _uuid.v4() : asset.id,
      projectId: _projectId,
      discoveredAt: asset.discoveredAt,
      lastUpdated: DateTime.now(),
    );

    // Store the asset
    await _storage.storeAsset(assetToCreate);

    // Update property index for efficient searching
    await _updatePropertyIndex(assetToCreate);

    // Use integration service for automatic trigger evaluation
    await _integrationService.onAssetCreated(assetToCreate);

    return assetToCreate;
  }

  /// Update an existing asset and re-evaluate triggers
  Future<Asset> updateAsset(Asset asset) async {
    // Get the old asset for comparison
    final oldAsset = await _storage.getAsset(asset.id);

    final updatedAsset = asset.copyWith(
      lastUpdated: DateTime.now(),
    );

    // Store the updated asset
    await _storage.updateAsset(updatedAsset);

    // Update property index
    await _updatePropertyIndex(updatedAsset);

    // Use integration service for intelligent re-evaluation
    if (oldAsset != null) {
      await _integrationService.onAssetUpdated(oldAsset, updatedAsset);
    } else {
      // If we can't find the old asset, treat as creation
      await _integrationService.onAssetCreated(updatedAsset);
    }

    return updatedAsset;
  }

  /// Delete an asset and related data
  Future<void> deleteAsset(String assetId) async {
    // Delete asset relationships
    await _deleteAssetRelationships(assetId);

    // Delete property index entries
    await _deletePropertyIndex(assetId);

    // Notify integration service about deletion
    await _integrationService.onAssetDeleted(assetId);

    // Delete the asset
    await _storage.deleteAsset(assetId);
  }

  /// Get asset relationships
  Future<List<AssetRelationship>> getAssetRelationships(String assetId) async {
    final rows = await _storage.getAssetRelationships(assetId);
    return rows.map((row) => AssetRelationship(
      parentAssetId: row.parentAssetId,
      childAssetId: row.childAssetId,
      relationshipType: row.relationshipType,
      createdAt: row.createdAt,
      metadata: row.metadata != null ? jsonDecode(row.metadata!) as Map<String, dynamic> : null,
    )).toList();
  }

  /// Create asset relationship
  Future<void> createAssetRelationship(AssetRelationship relationship) async {
    await _storage.storeAssetRelationship(
      relationship.parentAssetId,
      relationship.childAssetId,
      relationship.relationshipType,
    );
  }

  /// Delete asset relationship
  Future<void> deleteAssetRelationship(AssetRelationship relationship) async {
    await _storage.deleteAssetRelationship(
      relationship.parentAssetId,
      relationship.childAssetId,
      relationship.relationshipType,
    );
  }

  /// Search assets by property key-value pair
  Future<List<Asset>> searchAssetsByProperty(String propertyKey, String propertyValue) async {
    final assetIds = await _storage.searchAssetIdsByProperty(_projectId, propertyKey, propertyValue);
    final assets = <Asset>[];

    for (final assetId in assetIds) {
      final asset = await _storage.getAsset(assetId);
      if (asset != null) {
        assets.add(asset);
      }
    }

    return assets;
  }

  /// Search assets by complex property criteria
  Future<List<Asset>> searchAssetsByPropertyCriteria(Map<String, dynamic> criteria) async {
    final allAssets = await getAllAssets();
    return allAssets.where((asset) {
      return criteria.entries.every((criterion) {
        final key = criterion.key;
        final expectedValue = criterion.value;
        final assetProperty = asset.properties[key];

        if (assetProperty == null) return false;

        return assetProperty.when(
          string: (v) => v == expectedValue,
          integer: (v) => v == expectedValue,
          boolean: (v) => v == expectedValue,
          stringList: (v) => v.contains(expectedValue),
          map: (v) => v[expectedValue] != null,
          objectList: (v) => v.any((obj) => obj.containsValue(expectedValue)),
        );
      });
    }).toList();
  }

  /// Bulk import assets with batch trigger evaluation
  Future<List<Asset>> bulkImportAssets(List<Asset> assets) async {
    final createdAssets = <Asset>[];

    for (final asset in assets) {
      try {
        final createdAsset = await createAsset(asset);
        createdAssets.add(createdAsset);
      } catch (e) {
        // Log error but continue with other assets
        // Note: In production, use a proper logging framework
      }
    }

    return createdAssets;
  }

  /// Get asset statistics
  Future<Map<String, dynamic>> getAssetStatistics() async {
    final allAssets = await getAllAssets();
    final byType = <String, int>{};

    for (final asset in allAssets) {
      byType[asset.type.name] = (byType[asset.type.name] ?? 0) + 1;
    }

    return {
      'totalAssets': allAssets.length,
      'byType': byType,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  /// Get assets that have trigger matches
  Future<List<Asset>> getAssetsWithTriggerMatches() async {
    final allAssets = await getAllAssets();
    final assetsWithMatches = <Asset>[];

    for (final asset in allAssets) {
      final matches = await _storage.getTriggerMatchesForAsset(_projectId, asset.id);
      if (matches.isNotEmpty) {
        assetsWithMatches.add(asset);
      }
    }

    return assetsWithMatches;
  }

  /// Export assets to JSON format
  Map<String, dynamic> exportAssetsToJson(List<Asset> assets) {
    return {
      'projectId': _projectId,
      'exportedAt': DateTime.now().toIso8601String(),
      'assetCount': assets.length,
      'assets': assets.map((asset) => asset.toJson()).toList(),
    };
  }

  /// Import assets from JSON format
  List<Asset> importAssetsFromJson(Map<String, dynamic> jsonData) {
    final assetsList = jsonData['assets'] as List<dynamic>;
    return assetsList
        .map((assetJson) => Asset.fromJson(assetJson as Map<String, dynamic>))
        .toList();
  }

  /// Private helper methods

  /// Update property index for efficient searching
  Future<void> _updatePropertyIndex(Asset asset) async {
    // Delete existing index entries for this asset
    await _deletePropertyIndex(asset.id);

    // Create new index entries
    for (final entry in asset.properties.entries) {
      final propertyKey = entry.key;
      final propertyValue = entry.value;

      // Convert property value to string for indexing
      final indexValue = propertyValue.when(
        string: (v) => v,
        integer: (v) => v.toString(),
        boolean: (v) => v.toString(),
        stringList: (v) => v.join(','),
        map: (v) => v.toString(),
        objectList: (v) => v.toString(),
      );

      final propertyType = propertyValue.when(
        string: (_) => 'string',
        integer: (_) => 'integer',
        boolean: (_) => 'boolean',
        stringList: (_) => 'stringList',
        map: (_) => 'map',
        objectList: (_) => 'objectList',
      );

      // Store in property index
      await _storage.storeAssetPropertyIndex(
        asset.id,
        propertyKey,
        indexValue,
        propertyType,
      );
    }
  }

  /// Delete property index entries for an asset
  Future<void> _deletePropertyIndex(String assetId) async {
    await _storage.deleteAssetPropertyIndex(assetId);
  }

  /// Delete asset relationships
  Future<void> _deleteAssetRelationships(String assetId) async {
    await _storage.deleteAssetRelationships(assetId);
  }
}

/// Asset relationship model
class AssetRelationship {
  final String parentAssetId;
  final String childAssetId;
  final String relationshipType;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const AssetRelationship({
    required this.parentAssetId,
    required this.childAssetId,
    required this.relationshipType,
    required this.createdAt,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'parentAssetId': parentAssetId,
      'childAssetId': childAssetId,
      'relationshipType': relationshipType,
      'createdAt': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  factory AssetRelationship.fromJson(Map<String, dynamic> json) {
    return AssetRelationship(
      parentAssetId: json['parentAssetId'] as String,
      childAssetId: json['childAssetId'] as String,
      relationshipType: json['relationshipType'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}

/// Provider for asset statistics
final assetStatisticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, projectId) async {
  final assetService = ref.read(assetServiceProvider(projectId));
  return await assetService.getAssetStatistics();
});

/// Provider for assets with trigger matches
final assetsWithTriggerMatchesProvider = FutureProvider.family<List<Asset>, String>((ref, projectId) async {
  final assetService = ref.read(assetServiceProvider(projectId));
  return await assetService.getAssetsWithTriggerMatches();
});