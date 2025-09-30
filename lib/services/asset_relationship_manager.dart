import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/assets.dart';
import '../models/asset_relationships.dart';
import '../repositories/asset_repository.dart';

/// Service for managing asset relationships and lifecycle states
class AssetRelationshipManager {
  final AssetRepository _repository;
  final Uuid _uuid = const Uuid();

  // In-memory cache for performance
  final Map<String, Asset> _assetCache = {};
  final Map<String, List<AssetRelationship>> _relationshipCache = {};

  // Event streams for reactive updates
  final StreamController<AssetRelationshipEvent> _eventController =
      StreamController<AssetRelationshipEvent>.broadcast();

  AssetRelationshipManager(this._repository);

  /// Stream of relationship events
  Stream<AssetRelationshipEvent> get events => _eventController.stream;

  /// Create a new relationship between two assets
  Future<AssetRelationship> createRelationship({
    required String sourceAssetId,
    required String targetAssetId,
    required AssetRelationshipType relationshipType,
    RelationshipMetadata? metadata,
    bool validateAssets = true,
  }) async {
    if (validateAssets) {
      final sourceAsset = await getAsset(sourceAssetId);
      final targetAsset = await getAsset(targetAssetId);

      if (sourceAsset == null || targetAsset == null) {
        throw AssetRelationshipException(
          'Source or target asset not found: $sourceAssetId -> $targetAssetId'
        );
      }

      // Validate relationship makes sense for asset types
      if (!_isValidRelationshipForAssets(sourceAsset, targetAsset, relationshipType)) {
        throw AssetRelationshipException(
          'Invalid relationship ${relationshipType.name} between ${sourceAsset.type} and ${targetAsset.type}'
        );
      }
    }

    final relationship = AssetRelationship(
      id: _uuid.v4(),
      sourceAssetId: sourceAssetId,
      targetAssetId: targetAssetId,
      relationshipType: relationshipType,
      isBidirectional: RelationshipHelper.isBidirectionalRelationship(relationshipType),
      createdAt: DateTime.now(),
      metadata: metadata,
    );

    // Store in database
    await _storeRelationship(relationship);

    // Update asset relationship maps
    await _updateAssetRelationships(sourceAssetId, targetAssetId, relationshipType);

    // Create inverse relationship if needed
    if (relationship.isBidirectional || RelationshipHelper.getInverseRelationship(relationshipType) != null) {
      await _createInverseRelationship(relationship);
    }

    // Clear cache
    _invalidateCache();

    // Emit event
    _eventController.add(AssetRelationshipEvent.created(relationship));

    return relationship;
  }

  /// Remove a relationship
  Future<void> removeRelationship(String relationshipId) async {
    final relationship = await _getRelationshipById(relationshipId);
    if (relationship == null) {
      throw AssetRelationshipException('Relationship not found: $relationshipId');
    }

    // Remove from database
    await _deleteRelationship(relationshipId);

    // Update asset relationship maps
    await _removeAssetRelationships(
      relationship.sourceAssetId,
      relationship.targetAssetId,
      relationship.relationshipType
    );

    // Remove inverse relationship if it exists
    await _removeInverseRelationship(relationship);

    // Clear cache
    _invalidateCache();

    // Emit event
    _eventController.add(AssetRelationshipEvent.removed(relationship));
  }

  /// Get all relationships for an asset
  Future<List<AssetRelationship>> getAssetRelationships(String assetId) async {
    // Check cache first
    if (_relationshipCache.containsKey(assetId)) {
      return _relationshipCache[assetId]!;
    }

    // Query database
    final relationships = await _queryRelationshipsForAsset(assetId);

    // Cache result
    _relationshipCache[assetId] = relationships;

    return relationships;
  }

  /// Get relationships of a specific type
  Future<List<AssetRelationship>> getRelationshipsByType(
    String assetId,
    AssetRelationshipType type,
  ) async {
    final allRelationships = await getAssetRelationships(assetId);
    return allRelationships.where((r) => r.relationshipType == type).toList();
  }

  /// Get related assets by relationship type
  Future<List<Asset>> getRelatedAssets(
    String assetId,
    AssetRelationshipType relationshipType,
  ) async {
    final relationships = await getRelationshipsByType(assetId, relationshipType);
    final relatedAssets = <Asset>[];

    for (final relationship in relationships) {
      final relatedAssetId = relationship.sourceAssetId == assetId
          ? relationship.targetAssetId
          : relationship.sourceAssetId;

      final asset = await getAsset(relatedAssetId);
      if (asset != null) {
        relatedAssets.add(asset);
      }
    }

    return relatedAssets;
  }

  /// Update asset lifecycle state
  Future<Asset> updateAssetState(String assetId, String newState) async {
    final asset = await getAsset(assetId);
    if (asset == null) {
      throw AssetRelationshipException('Asset not found: $assetId');
    }

    // Validate state transition
    if (!AssetLifecycleStates.isValidTransition(asset.type, asset.lifecycleState, newState)) {
      throw AssetRelationshipException(
        'Invalid state transition: ${asset.lifecycleState} -> $newState for ${asset.type}'
      );
    }

    // Update state transitions history
    final updatedTransitions = Map<String, DateTime>.from(asset.stateTransitions);
    updatedTransitions[newState] = DateTime.now();

    final updatedAsset = asset.copyWith(
      lifecycleState: newState,
      stateTransitions: updatedTransitions,
    );

    // Update in database
    await _updateAsset(updatedAsset);

    // Update cache
    _assetCache[assetId] = updatedAsset;

    // Emit event
    _eventController.add(AssetRelationshipEvent.stateChanged(updatedAsset, asset.lifecycleState, newState));

    return updatedAsset;
  }

  /// Inherit properties from parent assets
  Future<Asset> inheritPropertiesFromParents(String assetId) async {
    final asset = await getAsset(assetId);
    if (asset == null) {
      throw AssetRelationshipException('Asset not found: $assetId');
    }

    final parentAssets = await getRelatedAssets(assetId, AssetRelationshipType.childOf);
    final inheritedProperties = <String, dynamic>{};

    // Collect properties from all parents
    for (final parent in parentAssets) {
      inheritedProperties.addAll(parent.properties);
      inheritedProperties.addAll(parent.inheritedProperties);
    }

    final updatedAsset = asset.copyWith(
      inheritedProperties: inheritedProperties,
    );

    // Update in database
    await _updateAsset(updatedAsset);

    // Update cache
    _assetCache[assetId] = updatedAsset;

    return updatedAsset;
  }

  /// Get asset hierarchy (parents and children)
  Future<AssetHierarchy> getAssetHierarchy(String assetId) async {
    final asset = await getAsset(assetId);
    if (asset == null) {
      throw AssetRelationshipException('Asset not found: $assetId');
    }

    final parents = await getRelatedAssets(assetId, AssetRelationshipType.childOf);
    final children = await getRelatedAssets(assetId, AssetRelationshipType.parentOf);

    return AssetHierarchy(
      asset: asset,
      parents: parents,
      children: children,
    );
  }

  /// Get discovery path for an asset
  Future<List<Asset>> getDiscoveryPath(String assetId) async {
    final asset = await getAsset(assetId);
    if (asset == null || asset.discoveryPath.isEmpty) {
      return [];
    }

    final pathAssets = <Asset>[];
    for (final pathAssetId in asset.discoveryPath) {
      final pathAsset = await getAsset(pathAssetId);
      if (pathAsset != null) {
        pathAssets.add(pathAsset);
      }
    }

    return pathAssets;
  }

  /// Find assets that share credentials
  Future<List<Asset>> findAssetsWithSharedCredentials(String assetId) async {
    return await getRelatedAssets(assetId, AssetRelationshipType.sharesCredentialsWith);
  }

  /// Get all assets in compromised states
  Future<List<Asset>> getCompromisedAssets() async {
    final compromisedStates = ['compromised', 'escalated', 'persistent', 'exploited'];
    final allAssets = await _getAllAssets();

    return allAssets.where((asset) =>
      compromisedStates.contains(asset.lifecycleState)
    ).toList();
  }

  /// Get asset by ID with caching
  Future<Asset?> getAsset(String assetId) async {
    // Check cache first
    if (_assetCache.containsKey(assetId)) {
      return _assetCache[assetId];
    }

    // Query database
    final asset = await _queryAsset(assetId);

    // Cache result
    if (asset != null) {
      _assetCache[assetId] = asset;
    }

    return asset;
  }

  /// Validate relationship between asset types
  bool _isValidRelationshipForAssets(Asset source, Asset target, AssetRelationshipType type) {
    // Define valid relationship rules
    final validRules = <AssetType, Map<AssetRelationshipType, List<AssetType>>>{
      AssetType.networkSegment: {
        AssetRelationshipType.parentOf: [AssetType.host, AssetType.networkSegment],
        AssetRelationshipType.connectedTo: [AssetType.networkSegment],
        AssetRelationshipType.routesTo: [AssetType.networkSegment],
      },
      AssetType.host: {
        AssetRelationshipType.childOf: [AssetType.networkSegment],
        AssetRelationshipType.hosts: [AssetType.service],
        AssetRelationshipType.trusts: [AssetType.host],
        AssetRelationshipType.sharesCredentialsWith: [AssetType.host],
      },
      AssetType.service: {
        AssetRelationshipType.hostedBy: [AssetType.host],
        AssetRelationshipType.dependsOn: [AssetType.service],
        AssetRelationshipType.communicatesWith: [AssetType.service],
      },
      AssetType.credential: {
        AssetRelationshipType.authenticatesTo: [AssetType.host, AssetType.service],
      },
      AssetType.vulnerability: {
        AssetRelationshipType.vulnerableTo: [AssetType.host, AssetType.service],
      },
    };

    final sourceRules = validRules[source.type];
    if (sourceRules == null) return true; // Allow if no specific rules

    final validTargetTypes = sourceRules[type];
    if (validTargetTypes == null) return true; // Allow if no specific rules

    return validTargetTypes.contains(target.type);
  }

  /// Create inverse relationship
  Future<void> _createInverseRelationship(AssetRelationship relationship) async {
    final inverseType = RelationshipHelper.getInverseRelationship(relationship.relationshipType);
    if (inverseType == null) return;

    final inverseRelationship = AssetRelationship(
      id: _uuid.v4(),
      sourceAssetId: relationship.targetAssetId,
      targetAssetId: relationship.sourceAssetId,
      relationshipType: inverseType,
      isBidirectional: false, // Only the original is marked as bidirectional
      createdAt: relationship.createdAt,
      metadata: relationship.metadata,
    );

    await _storeRelationship(inverseRelationship);
    await _updateAssetRelationships(
      inverseRelationship.sourceAssetId,
      inverseRelationship.targetAssetId,
      inverseRelationship.relationshipType,
    );
  }

  /// Remove inverse relationship
  Future<void> _removeInverseRelationship(AssetRelationship relationship) async {
    final inverseType = RelationshipHelper.getInverseRelationship(relationship.relationshipType);
    if (inverseType == null) return;

    // Find and remove inverse relationship
    final inverseRelationships = await _queryRelationshipsByAssets(
      relationship.targetAssetId,
      relationship.sourceAssetId,
      inverseType,
    );

    for (final inverse in inverseRelationships) {
      await _deleteRelationship(inverse.id);
      await _removeAssetRelationships(
        inverse.sourceAssetId,
        inverse.targetAssetId,
        inverse.relationshipType,
      );
    }
  }

  /// Clear all caches
  void _invalidateCache() {
    _assetCache.clear();
    _relationshipCache.clear();
  }

  /// Dispose resources
  void dispose() {
    _eventController.close();
  }

  // Database operations (to be implemented with actual database layer)

  Future<void> _storeRelationship(AssetRelationship relationship) async {
    await _repository.createRelationship(
      relationship.sourceAssetId,
      relationship.targetAssetId,
      _relationshipTypeToString(relationship.relationshipType),
      metadata: relationship.metadata?.toJson(),
    );
  }

  Future<void> _deleteRelationship(String relationshipId) async {
    // Get the relationship details first
    final relationship = await _getRelationshipById(relationshipId);
    if (relationship != null) {
      await _repository.deleteRelationship(
        relationship.sourceAssetId,
        relationship.targetAssetId,
        _relationshipTypeToString(relationship.relationshipType),
      );
    }
  }

  Future<AssetRelationship?> _getRelationshipById(String relationshipId) async {
    // Since AssetRepository doesn't have getRelationshipById, we'll need to search through relationships
    // This is a limitation that could be improved by adding this method to AssetRepository
    // For now, we'll return null and handle this case appropriately
    return null;
  }

  Future<List<AssetRelationship>> _queryRelationshipsForAsset(String assetId) async {
    final relationshipRows = await _repository.getAssetRelationships(assetId);

    return relationshipRows.map((row) {
      final relationshipType = _parseRelationshipType(row.relationshipType);
      return AssetRelationship(
        id: '${row.parentAssetId}-${row.childAssetId}-${row.relationshipType}',
        sourceAssetId: row.parentAssetId,
        targetAssetId: row.childAssetId,
        relationshipType: relationshipType,
        isBidirectional: RelationshipHelper.isBidirectionalRelationship(relationshipType),
        createdAt: row.createdAt,
        metadata: row.metadata != null
          ? RelationshipMetadata.fromJson(
              row.metadata is String
                ? jsonDecode(row.metadata as String) as Map<String, dynamic>
                : row.metadata as Map<String, dynamic>
            )
          : null,
      );
    }).toList();
  }

  Future<List<AssetRelationship>> _queryRelationshipsByAssets(
    String sourceAssetId,
    String targetAssetId,
    AssetRelationshipType type,
  ) async {
    // Get all relationships for source asset and filter
    final allRelationships = await _queryRelationshipsForAsset(sourceAssetId);
    return allRelationships.where((r) =>
      r.targetAssetId == targetAssetId && r.relationshipType == type
    ).toList();
  }

  Future<void> _updateAssetRelationships(
    String sourceAssetId,
    String targetAssetId,
    AssetRelationshipType relationshipType,
  ) async {
    // Update source asset relationships map
    final sourceAsset = await getAsset(sourceAssetId);
    if (sourceAsset != null) {
      final updatedRelationships = Map<String, List<String>>.from(sourceAsset.relationships);
      final typeKey = _relationshipTypeToString(relationshipType);

      if (!updatedRelationships.containsKey(typeKey)) {
        updatedRelationships[typeKey] = [];
      }

      if (!updatedRelationships[typeKey]!.contains(targetAssetId)) {
        updatedRelationships[typeKey]!.add(targetAssetId);
      }

      final updatedAsset = sourceAsset.copyWith(relationships: updatedRelationships);
      await _updateAsset(updatedAsset);
    }
  }

  Future<void> _removeAssetRelationships(
    String sourceAssetId,
    String targetAssetId,
    AssetRelationshipType relationshipType,
  ) async {
    // Remove from source asset relationships map
    final sourceAsset = await getAsset(sourceAssetId);
    if (sourceAsset != null) {
      final updatedRelationships = Map<String, List<String>>.from(sourceAsset.relationships);
      final typeKey = _relationshipTypeToString(relationshipType);

      if (updatedRelationships.containsKey(typeKey)) {
        updatedRelationships[typeKey]!.remove(targetAssetId);
        if (updatedRelationships[typeKey]!.isEmpty) {
          updatedRelationships.remove(typeKey);
        }
      }

      final updatedAsset = sourceAsset.copyWith(relationships: updatedRelationships);
      await _updateAsset(updatedAsset);
    }
  }

  Future<Asset?> _queryAsset(String assetId) async {
    return await _repository.getAsset(assetId);
  }

  Future<List<Asset>> _getAllAssets() async {
    // AssetRepository doesn't have getAllAssets method
    // This would need to be added to the repository or we need a different approach
    // For now, return empty list
    return [];
  }

  Future<void> _updateAsset(Asset asset) async {
    await _repository.saveAsset(asset);
    await _repository.updatePropertyIndex(asset);
    _assetCache[asset.id] = asset;
  }

  /// Convert relationship type enum to string
  String _relationshipTypeToString(AssetRelationshipType type) {
    return type.toString().split('.').last;
  }

  /// Parse relationship type string to enum
  AssetRelationshipType _parseRelationshipType(String typeString) {
    return AssetRelationshipType.values.firstWhere(
      (e) => e.toString().split('.').last == typeString,
      orElse: () => AssetRelationshipType.connectedTo,
    );
  }
}

/// Event types for asset relationship changes
sealed class AssetRelationshipEvent {
  const AssetRelationshipEvent();

  factory AssetRelationshipEvent.created(AssetRelationship relationship) =
      RelationshipCreatedEvent;

  factory AssetRelationshipEvent.removed(AssetRelationship relationship) =
      RelationshipRemovedEvent;

  factory AssetRelationshipEvent.stateChanged(Asset asset, String oldState, String newState) =
      AssetStateChangedEvent;
}

class RelationshipCreatedEvent extends AssetRelationshipEvent {
  final AssetRelationship relationship;
  const RelationshipCreatedEvent(this.relationship);
}

class RelationshipRemovedEvent extends AssetRelationshipEvent {
  final AssetRelationship relationship;
  const RelationshipRemovedEvent(this.relationship);
}

class AssetStateChangedEvent extends AssetRelationshipEvent {
  final Asset asset;
  final String oldState;
  final String newState;
  const AssetStateChangedEvent(this.asset, this.oldState, this.newState);
}

/// Asset hierarchy data structure
class AssetHierarchy {
  final Asset asset;
  final List<Asset> parents;
  final List<Asset> children;

  const AssetHierarchy({
    required this.asset,
    required this.parents,
    required this.children,
  });
}

/// Exception for asset relationship operations
class AssetRelationshipException implements Exception {
  final String message;
  const AssetRelationshipException(this.message);

  @override
  String toString() => 'AssetRelationshipException: $message';
}