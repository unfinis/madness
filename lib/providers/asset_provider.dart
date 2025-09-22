import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assets.dart';
import '../database/database.dart';
import 'database_provider.dart';

/// Provider for managing assets with Riverpod state management
final assetProvider = StateNotifierProvider.family<
    AssetNotifier,
    AsyncValue<List<Asset>>,
    String
>((ref, projectId) {
  final database = ref.watch(databaseProvider);
  return AssetNotifier(projectId, database);
});

/// Provider for a single asset by ID
final singleAssetProvider = FutureProvider.family<Asset?, String>((ref, assetId) async {
  final database = ref.watch(databaseProvider);
  final assets = await database.getAssetsForProject(''); // TODO: Get project ID
  return assets.where((asset) => asset.id == assetId).firstOrNull;
});

/// Provider for assets filtered by type
final assetsByTypeProvider = Provider.family<
    AsyncValue<List<Asset>>,
    (String projectId, AssetType type)
>((ref, params) {
  final (projectId, type) = params;
  final assetsAsync = ref.watch(assetProvider(projectId));

  return assetsAsync.whenData((assets) =>
    assets.where((asset) => asset.type == type).toList()
  );
});

/// Provider for asset hierarchy (roots and their children)
final assetHierarchyProvider = Provider.family<
    AsyncValue<List<Asset>>,
    String
>((ref, projectId) {
  final assetsAsync = ref.watch(assetProvider(projectId));

  return assetsAsync.whenData((assets) =>
    assets.where((asset) => asset.parentAssetIds.isEmpty).toList()
  );
});

/// Provider for asset search
final assetSearchProvider = Provider.family<
    AsyncValue<List<Asset>>,
    (String projectId, String query)
>((ref, params) {
  final (projectId, query) = params;
  final assetsAsync = ref.watch(assetProvider(projectId));

  return assetsAsync.whenData((assets) {
    if (query.isEmpty) return assets;

    final lowerQuery = query.toLowerCase();
    return assets.where((asset) {
      final searchableText = [
        asset.name,
        asset.description ?? '',
        asset.type.name,
        ...asset.tags,
        ...asset.properties.values.map((v) => _formatPropertyValue(v)),
      ].join(' ').toLowerCase();

      return searchableText.contains(lowerQuery);
    }).toList();
  });
});

/// Asset statistics provider
final assetStatsProvider = Provider.family<AsyncValue<AssetStatistics>, String>((ref, projectId) {
  final assetsAsync = ref.watch(assetProvider(projectId));

  return assetsAsync.whenData((assets) => AssetStatistics.fromAssets(assets));
});

/// State notifier for managing assets
class AssetNotifier extends StateNotifier<AsyncValue<List<Asset>>> {
  final String projectId;
  final MadnessDatabase _database;

  AssetNotifier(this.projectId, this._database) : super(const AsyncValue.loading()) {
    _initialize();
  }

  /// Initialize the provider and load assets
  Future<void> _initialize() async {
    try {
      await loadAssets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Load all assets for the project
  Future<void> loadAssets() async {
    try {
      print('Loading assets for project: $projectId');
      state = const AsyncValue.loading();
      final assets = await _database.getAssetsForProject(projectId);
      print('Loaded ${assets.length} assets from database');
      state = AsyncValue.data(assets);
    } catch (error, stackTrace) {
      print('Error loading assets: $error');
      // Fall back to mock data on error during development
      try {
        final mockAssets = _generateMockAssets();
        print('Using ${mockAssets.length} mock assets as fallback');
        state = AsyncValue.data(mockAssets);
      } catch (mockError) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  /// Add a new asset
  Future<void> addAsset(Asset asset) async {
    try {
      print('Adding asset: ${asset.name} (${asset.type}) to project ${asset.projectId}');
      await _database.insertAsset(asset);
      print('Asset successfully inserted into database');

      // Update state optimistically
      final currentAssets = state.value ?? [];
      final newAssets = [...currentAssets, asset];
      print('Updated asset list, now has ${newAssets.length} assets');
      state = AsyncValue.data(newAssets);
    } catch (error, stackTrace) {
      print('Error adding asset: $error');
      // Revert optimistic update on error
      await loadAssets();
      rethrow;
    }
  }

  /// Update an existing asset
  Future<void> updateAsset(Asset asset) async {
    try {
      await _database.updateAsset(asset);

      // Update state optimistically
      final currentAssets = state.value ?? [];
      final updatedAssets = currentAssets.map((a) =>
        a.id == asset.id ? asset : a
      ).toList();
      state = AsyncValue.data(updatedAssets);
    } catch (error, stackTrace) {
      // Revert optimistic update on error
      await loadAssets();
      rethrow;
    }
  }

  /// Delete an asset
  Future<void> deleteAsset(String assetId) async {
    try {
      await _database.deleteAsset(assetId);

      // Update state optimistically
      final currentAssets = state.value ?? [];
      final filteredAssets = currentAssets.where((a) => a.id != assetId).toList();
      state = AsyncValue.data(filteredAssets);
    } catch (error, stackTrace) {
      // Revert optimistic update on error
      await loadAssets();
      rethrow;
    }
  }

  /// Get assets by type
  List<Asset> getAssetsByType(AssetType type) {
    final assets = state.value ?? [];
    return assets.where((asset) => asset.type == type).toList();
  }

  /// Get child assets for a parent
  List<Asset> getChildAssets(String parentAssetId) {
    final assets = state.value ?? [];
    return assets.where((asset) =>
      asset.parentAssetIds.contains(parentAssetId)
    ).toList();
  }

  /// Get parent assets for a child
  List<Asset> getParentAssets(String childAssetId) {
    final assets = state.value ?? [];
    final childAsset = assets.where((a) => a.id == childAssetId).firstOrNull;
    if (childAsset == null) return [];

    return assets.where((asset) =>
      childAsset.parentAssetIds.contains(asset.id)
    ).toList();
  }

  /// Get related assets
  List<Asset> getRelatedAssets(String assetId) {
    final assets = state.value ?? [];
    final asset = assets.where((a) => a.id == assetId).firstOrNull;
    if (asset == null) return [];

    return assets.where((a) =>
      asset.relatedAssetIds.contains(a.id)
    ).toList();
  }

  /// Add a relationship between assets
  Future<void> addRelationship(
    String parentAssetId,
    String childAssetId,
    AssetRelationshipType type
  ) async {
    try {
      final assets = state.value ?? [];
      final parentAsset = assets.where((a) => a.id == parentAssetId).firstOrNull;
      final childAsset = assets.where((a) => a.id == childAssetId).firstOrNull;

      if (parentAsset == null || childAsset == null) return;

      Asset updatedParent;
      Asset updatedChild;

      switch (type) {
        case AssetRelationshipType.parentChild:
          updatedParent = parentAsset.addChild(childAssetId);
          updatedChild = childAsset.addParent(parentAssetId);
          break;
        case AssetRelationshipType.related:
          updatedParent = parentAsset.addRelated(childAssetId);
          updatedChild = childAsset.addRelated(parentAssetId);
          break;
      }

      await updateAsset(updatedParent);
      await updateAsset(updatedChild);
    } catch (error) {
      await loadAssets();
      rethrow;
    }
  }

  /// Remove a relationship between assets
  Future<void> removeRelationship(
    String parentAssetId,
    String childAssetId,
    AssetRelationshipType type
  ) async {
    try {
      final assets = state.value ?? [];
      final parentAsset = assets.where((a) => a.id == parentAssetId).firstOrNull;
      final childAsset = assets.where((a) => a.id == childAssetId).firstOrNull;

      if (parentAsset == null || childAsset == null) return;

      Asset updatedParent;
      Asset updatedChild;

      switch (type) {
        case AssetRelationshipType.parentChild:
          final newChildIds = List<String>.from(parentAsset.childAssetIds);
          newChildIds.remove(childAssetId);
          updatedParent = parentAsset.copyWith(childAssetIds: newChildIds);

          final newParentIds = List<String>.from(childAsset.parentAssetIds);
          newParentIds.remove(parentAssetId);
          updatedChild = childAsset.copyWith(parentAssetIds: newParentIds);
          break;
        case AssetRelationshipType.related:
          final newRelatedIds1 = List<String>.from(parentAsset.relatedAssetIds);
          newRelatedIds1.remove(childAssetId);
          updatedParent = parentAsset.copyWith(relatedAssetIds: newRelatedIds1);

          final newRelatedIds2 = List<String>.from(childAsset.relatedAssetIds);
          newRelatedIds2.remove(parentAssetId);
          updatedChild = childAsset.copyWith(relatedAssetIds: newRelatedIds2);
          break;
      }

      await updateAsset(updatedParent);
      await updateAsset(updatedChild);
    } catch (error) {
      await loadAssets();
      rethrow;
    }
  }

  /// Search assets by property
  Future<List<Asset>> searchByProperty(
    String propertyKey,
    String propertyValue
  ) async {
    try {
      return await _database.searchAssetsByProperty(projectId, propertyKey, propertyValue);
    } catch (error) {
      // Fallback to in-memory search
      final assets = state.value ?? [];
      return assets.where((asset) {
        final property = asset.properties[propertyKey];
        if (property == null) return false;

        final value = _formatPropertyValue(property);
        return value.toLowerCase().contains(propertyValue.toLowerCase());
      }).toList();
    }
  }

  /// Update asset discovery status
  Future<void> updateDiscoveryStatus(String assetId, AssetDiscoveryStatus status) async {
    final assets = state.value ?? [];
    final asset = assets.where((a) => a.id == assetId).firstOrNull;

    if (asset != null) {
      final updatedAsset = asset.copyWith(
        discoveryStatus: status,
        lastUpdated: DateTime.now(),
      );
      await updateAsset(updatedAsset);
    }
  }

  /// Bulk update assets
  Future<void> bulkUpdateAssets(List<Asset> assets) async {
    try {
      for (final asset in assets) {
        await _database.updateAsset(asset);
      }

      // Reload from database to ensure consistency
      await loadAssets();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }

  /// Generate mock assets for development/testing
  List<Asset> _generateMockAssets() {
    return [
      AssetFactory.createEnvironment(
        projectId: projectId,
        name: 'Corporate Environment',
        environmentType: 'hybrid',
        organization: 'Acme Corp',
        additionalProperties: {
          'compliance_frameworks': const AssetPropertyValue.stringList(['SOX', 'PCI-DSS']),
          'primary_domain': const AssetPropertyValue.string('acme.local'),
        },
      ),
      AssetFactory.createNetworkSegment(
        projectId: projectId,
        subnet: '192.168.1.0/24',
        name: 'Corporate LAN',
        vlanId: 100,
        additionalProperties: {
          'gateway': const AssetPropertyValue.string('192.168.1.1'),
          'dns_servers': const AssetPropertyValue.stringList(['192.168.1.10', '192.168.1.11']),
          'domain_name': const AssetPropertyValue.string('corp.acme.local'),
          'nac_enabled': const AssetPropertyValue.boolean(true),
          'firewall_present': const AssetPropertyValue.boolean(true),
        },
      ),
      AssetFactory.createHost(
        projectId: projectId,
        ipAddress: '192.168.1.10',
        hostname: 'DC01',
        additionalProperties: {
          'os_family': const AssetPropertyValue.string('windows'),
          'os_name': const AssetPropertyValue.string('Windows Server 2019'),
          'domain_membership': const AssetPropertyValue.string('corp.acme.local'),
          'rdp_enabled': const AssetPropertyValue.boolean(true),
          'smb_signing_required': const AssetPropertyValue.boolean(false),
        },
      ),
      AssetFactory.createCloudTenant(
        projectId: projectId,
        tenantName: 'Acme Azure',
        tenantType: 'azure',
        tenantId: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
        additionalProperties: {
          'primary_domain': const AssetPropertyValue.string('acme.onmicrosoft.com'),
          'security_defaults_enabled': const AssetPropertyValue.boolean(true),
          'mfa_enforcement': const AssetPropertyValue.string('conditional'),
        },
      ),
      AssetFactory.createWirelessNetwork(
        projectId: projectId,
        ssid: 'Acme-Corporate',
        encryptionType: 'wpa3',
        additionalProperties: {
          'frequency_band': const AssetPropertyValue.string('5GHz'),
          'max_speed_mbps': const AssetPropertyValue.integer(1200),
          'guest_network': const AssetPropertyValue.boolean(false),
          'wps_enabled': const AssetPropertyValue.boolean(false),
        },
      ),
    ];
  }
}

/// Asset relationship types
enum AssetRelationshipType {
  parentChild,
  related,
}

/// Asset statistics model
class AssetStatistics {
  final int total;
  final int environments;
  final int networks;
  final int hosts;
  final int services;
  final int credentials;
  final int cloud;
  final int wireless;
  final int physical;
  final int compromised;
  final int accessible;
  final int analyzed;

  const AssetStatistics({
    required this.total,
    required this.environments,
    required this.networks,
    required this.hosts,
    required this.services,
    required this.credentials,
    required this.cloud,
    required this.wireless,
    required this.physical,
    required this.compromised,
    required this.accessible,
    required this.analyzed,
  });

  factory AssetStatistics.fromAssets(List<Asset> assets) {
    return AssetStatistics(
      total: assets.length,
      environments: assets.where((a) => a.type == AssetType.environment).length,
      networks: assets.where((a) => a.type == AssetType.networkSegment).length,
      hosts: assets.where((a) => a.type == AssetType.host).length,
      services: assets.where((a) => a.type == AssetType.service).length,
      credentials: assets.where((a) => a.type == AssetType.credential).length,
      cloud: assets.where((a) => [
        AssetType.cloudTenant,
        AssetType.cloudResource,
        AssetType.cloudIdentity,
      ].contains(a.type)).length,
      wireless: assets.where((a) => [
        AssetType.wirelessNetwork,
        AssetType.wirelessClient,
      ].contains(a.type)).length,
      physical: assets.where((a) => [
        AssetType.physicalSite,
        AssetType.physicalArea,
        AssetType.person,
      ].contains(a.type)).length,
      compromised: assets.where((a) => a.discoveryStatus == AssetDiscoveryStatus.compromised).length,
      accessible: assets.where((a) => a.discoveryStatus == AssetDiscoveryStatus.accessible).length,
      analyzed: assets.where((a) => a.discoveryStatus == AssetDiscoveryStatus.analyzed).length,
    );
  }
}

/// Helper function to format property values for searching
String _formatPropertyValue(AssetPropertyValue value) {
  return value.when(
    string: (v) => v,
    integer: (v) => v.toString(),
    double: (v) => v.toString(),
    boolean: (v) => v.toString(),
    stringList: (v) => v.join(', '),
    dateTime: (v) => v.toString(),
    map: (v) => v.toString(),
    objectList: (v) => '${v.length} item(s)',
  );
}