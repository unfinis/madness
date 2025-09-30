import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assets.dart';
import '../models/asset_relationships.dart';
import '../repositories/asset_repository.dart';
import '../services/asset_relationship_manager.dart';
import 'database_provider.dart';

/// Provider for AssetRepository instance
///
/// This provider manages the AssetRepository singleton and provides
/// it to other parts of the application that need database access
/// for asset operations.
final assetRepositoryProvider = Provider<AssetRepository>((ref) {
  // Keep the provider alive to prevent multiple instances
  ref.keepAlive();

  final database = ref.watch(databaseProvider);
  return AssetRepository(database);
});

/// Provider for AssetRelationshipManager instance
///
/// This provider manages the AssetRelationshipManager singleton which
/// handles all asset relationship operations, lifecycle state management,
/// and property inheritance.
final assetRelationshipManagerProvider = Provider<AssetRelationshipManager>((ref) {
  // Keep the provider alive to prevent multiple instances
  ref.keepAlive();

  final repository = ref.watch(assetRepositoryProvider);
  return AssetRelationshipManager(repository);
});

/// Provider for asset statistics using the repository
///
/// This provider calculates and provides real-time statistics
/// about assets in a project using the AssetRepository.
final assetStatisticsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, projectId) async {
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getAssetStatistics(projectId);
});

/// Provider for assets by project using the repository
///
/// This provider fetches all assets for a specific project
/// using the AssetRepository and provides reactive updates.
final projectAssetsProvider = FutureProvider.family<List<Asset>, String>((ref, projectId) async {
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getProjectAssets(projectId);
});

/// Provider for assets by type using the repository
///
/// This provider fetches assets filtered by type for a specific project.
final assetsByTypeProvider = FutureProvider.family<List<Asset>, (String, AssetType)>((ref, params) async {
  final (projectId, assetType) = params;
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getAssetsByType(projectId, assetType);
});

/// Provider for assets by lifecycle state using the repository
///
/// This provider fetches assets filtered by their lifecycle state.
final assetsByStateProvider = FutureProvider.family<List<Asset>, (String, String)>((ref, params) async {
  final (projectId, lifecycleState) = params;
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getAssetsByState(projectId, lifecycleState);
});

/// Provider for single asset by ID using the repository
///
/// This provider fetches a single asset by its ID.
final singleAssetProviderNew = FutureProvider.family<Asset?, String>((ref, assetId) async {
  final repository = ref.watch(assetRepositoryProvider);
  return await repository.getAsset(assetId);
});

/// Provider for asset relationships using the relationship manager
///
/// This provider fetches all relationships for a specific asset.
final assetRelationshipsProvider = FutureProvider.family<List<AssetRelationship>, String>((ref, assetId) async {
  final relationshipManager = ref.watch(assetRelationshipManagerProvider);
  return await relationshipManager.getAssetRelationships(assetId);
});

/// Provider for asset hierarchy using the relationship manager
///
/// This provider gets the complete hierarchy (parents and children) for an asset.
final assetHierarchyProviderNew = FutureProvider.family<AssetHierarchy, String>((ref, assetId) async {
  final relationshipManager = ref.watch(assetRelationshipManagerProvider);
  return await relationshipManager.getAssetHierarchy(assetId);
});

/// Provider for compromised assets using the relationship manager
///
/// This provider fetches all assets that are in compromised states.
final compromisedAssetsProvider = FutureProvider<List<Asset>>((ref) async {
  final relationshipManager = ref.watch(assetRelationshipManagerProvider);
  return await relationshipManager.getCompromisedAssets();
});

/// Provider for assets with shared credentials
///
/// This provider finds all assets that share credentials with a given asset.
final sharedCredentialsAssetsProvider = FutureProvider.family<List<Asset>, String>((ref, assetId) async {
  final relationshipManager = ref.watch(assetRelationshipManagerProvider);
  return await relationshipManager.findAssetsWithSharedCredentials(assetId);
});

/// Provider for asset discovery path
///
/// This provider gets the discovery path for an asset showing how it was found.
final assetDiscoveryPathProvider = FutureProvider.family<List<Asset>, String>((ref, assetId) async {
  final relationshipManager = ref.watch(assetRelationshipManagerProvider);
  return await relationshipManager.getDiscoveryPath(assetId);
});