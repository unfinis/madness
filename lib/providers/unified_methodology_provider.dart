import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/unified_methodology_loader.dart';
import '../services/drift_storage_service.dart';
import '../services/methodology_loader.dart' as loader;
import '../providers/database_provider.dart';

/// Provider for the unified methodology loader instance
final unifiedMethodologyLoaderProvider = Provider<UnifiedMethodologyLoader>((ref) {
  final loader = UnifiedMethodologyLoader();

  // Get database and storage service
  final database = ref.read(databaseProvider);
  final storageService = DriftStorageService(database);

  // Inject storage into loader
  loader.setStorage(storageService);

  return loader;
});

/// Provider that ensures methodologies are loaded from YAML assets
/// This will automatically load YAML methodologies into the database on first run
final methodologyInitializationProvider = FutureProvider<void>((ref) async {
  final loader = ref.read(unifiedMethodologyLoaderProvider);
  await loader.loadMethodologies();
});

/// Provider for all methodology templates
/// This replaces the old methodology loading system
final allMethodologyTemplatesProvider = FutureProvider<List<loader.MethodologyTemplate>>((ref) async {
  // Ensure methodologies are loaded first
  await ref.read(methodologyInitializationProvider.future);

  final loader = ref.read(unifiedMethodologyLoaderProvider);
  return loader.getAllMethodologies();
});

/// Provider for a specific methodology by ID
final methodologyByIdProvider = FutureProvider.family<loader.MethodologyTemplate?, String>((ref, id) async {
  // Ensure methodologies are loaded first
  await ref.read(methodologyInitializationProvider.future);

  final loader = ref.read(unifiedMethodologyLoaderProvider);
  return loader.getMethodology(id);
});

/// Provider for methodology search
/// Parameters: query, tags, riskLevel, workstream
final methodologySearchProvider = FutureProvider.family<List<loader.MethodologyTemplate>, Map<String, dynamic>>((ref, params) async {
  // Ensure methodologies are loaded first
  await ref.read(methodologyInitializationProvider.future);

  final loader = ref.read(unifiedMethodologyLoaderProvider);
  return loader.searchMethodologies(
    query: params['query'] as String?,
    tags: params['tags'] as List<String>?,
    riskLevel: params['riskLevel'] as String?,
    workstream: params['workstream'] as String?,
  );
});

/// Provider for methodology statistics
final methodologyStatisticsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  // Ensure methodologies are loaded first
  await ref.read(methodologyInitializationProvider.future);

  final loader = ref.read(unifiedMethodologyLoaderProvider);
  return loader.getStatistics();
});

/// Provider for methodologies by workstream
final methodologiesByWorkstreamProvider = FutureProvider.family<List<loader.MethodologyTemplate>, String>((ref, workstream) async {
  // Ensure methodologies are loaded first
  await ref.read(methodologyInitializationProvider.future);

  final loader = ref.read(unifiedMethodologyLoaderProvider);
  return loader.searchMethodologies(workstream: workstream);
});

/// Provider for available workstreams
final availableWorkstreamsProvider = FutureProvider<List<String>>((ref) async {
  final stats = await ref.read(methodologyStatisticsProvider.future);
  final workstreams = stats['workstreams'] as Map<String, int>;
  return workstreams.keys.toList()..sort();
});

/// Provider for available risk levels
final availableRiskLevelsProvider = FutureProvider<List<String>>((ref) async {
  final stats = await ref.read(methodologyStatisticsProvider.future);
  final riskLevels = stats['risk_levels'] as Map<String, int>;
  return riskLevels.keys.toList()..sort();
});

/// Provider to reload methodologies (for development/testing)
final reloadMethodologiesProvider = FutureProvider<void>((ref) async {
  final loader = ref.read(unifiedMethodologyLoaderProvider);
  await loader.reloadMethodologies();

  // Invalidate all dependent providers to force refresh
  ref.invalidate(allMethodologyTemplatesProvider);
  ref.invalidate(methodologyStatisticsProvider);
});

/// State provider for search filters (UI state)
final methodologySearchFiltersProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'query': '',
    'tags': <String>[],
    'riskLevel': null,
    'workstream': null,
  };
});

/// Simplified filtered provider that doesn't cause rebuilds
final filteredMethodologiesProvider = Provider<List<loader.MethodologyTemplate>>((ref) {
  final allMethodologiesAsync = ref.watch(allMethodologyTemplatesProvider);
  final filters = ref.watch(methodologySearchFiltersProvider);

  // Return empty list while loading
  if (!allMethodologiesAsync.hasValue) {
    return [];
  }

  final allMethodologies = allMethodologiesAsync.value!;
  var filtered = allMethodologies;

  // Apply filters synchronously
  final query = (filters['query'] as String? ?? '').toLowerCase();
  if (query.isNotEmpty) {
    filtered = filtered.where((m) =>
      m.name.toLowerCase().contains(query) ||
      m.description.toLowerCase().contains(query) ||
      m.tags.any((t) => t.toLowerCase().contains(query))
    ).toList();
  }

  final tags = filters['tags'] as List<String>? ?? [];
  if (tags.isNotEmpty) {
    filtered = filtered.where((m) =>
      tags.any((tag) => m.tags.contains(tag))
    ).toList();
  }

  final riskLevel = filters['riskLevel'] as String?;
  if (riskLevel != null && riskLevel != 'all') {
    filtered = filtered.where((m) => m.riskLevel == riskLevel).toList();
  }

  return filtered;
});

/// Provider for methodology categories/workstreams
final methodologyWorkstreamsProvider = FutureProvider<List<String>>((ref) async {
  final methodologies = await ref.watch(allMethodologyTemplatesProvider.future);
  final workstreams = methodologies.map((m) => m.workstream).toSet().toList();
  workstreams.sort();
  return workstreams;
});

/// Provider for all unique tags
final allMethodologyTagsProvider = FutureProvider<List<String>>((ref) async {
  final methodologies = await ref.watch(allMethodologyTemplatesProvider.future);
  final allTags = <String>{};
  for (final m in methodologies) {
    allTags.addAll(m.tags);
  }
  return allTags.toList()..sort();
});