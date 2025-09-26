import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import '../services/methodology_engine.dart';
import '../services/methodology_service.dart';
import 'projects_provider.dart';

// Methodology service provider
final methodologyServiceProvider = Provider<MethodologyService>((ref) {
  return MethodologyService();
});

// Main methodology engine provider
final methodologyEngineProvider = Provider<MethodologyEngine>((ref) {
  return MethodologyEngine();
});

// Initialize methodology system
final methodologyInitializationProvider = FutureProvider<void>((ref) async {
  final service = ref.read(methodologyServiceProvider);
  final engine = ref.read(methodologyEngineProvider);
  await service.initialize();
  await engine.initialize();
});

// Current project methodology state
class MethodologyState {
  final List<Methodology> availableMethodologies;
  final List<MethodologyExecution> executions;
  final List<MethodologyRecommendation> recommendations;
  final List<DiscoveredAsset> discoveredAssets;
  final bool isLoading;
  final String? error;
  final MethodologyFilters filters;
  final MethodologyCategory? selectedCategory;

  const MethodologyState({
    this.availableMethodologies = const [],
    this.executions = const [],
    this.recommendations = const [],
    this.discoveredAssets = const [],
    this.isLoading = false,
    this.error,
    this.filters = const MethodologyFilters(),
    this.selectedCategory,
  });

  MethodologyState copyWith({
    List<Methodology>? availableMethodologies,
    List<MethodologyExecution>? executions,
    List<MethodologyRecommendation>? recommendations,
    List<DiscoveredAsset>? discoveredAssets,
    bool? isLoading,
    String? error,
    MethodologyFilters? filters,
    MethodologyCategory? selectedCategory,
  }) {
    return MethodologyState(
      availableMethodologies: availableMethodologies ?? this.availableMethodologies,
      executions: executions ?? this.executions,
      recommendations: recommendations ?? this.recommendations,
      discoveredAssets: discoveredAssets ?? this.discoveredAssets,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      filters: filters ?? this.filters,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class MethodologyFilters {
  final String searchQuery;
  final List<MethodologyCategory> categories;
  final List<ExecutionStatus> statuses;
  final List<MethodologyRiskLevel> riskLevels;
  final bool showCompleted;
  final bool showRecommendations;

  const MethodologyFilters({
    this.searchQuery = '',
    this.categories = const [],
    this.statuses = const [],
    this.riskLevels = const [],
    this.showCompleted = true,
    this.showRecommendations = true,
  });

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      categories.isNotEmpty ||
      statuses.isNotEmpty ||
      riskLevels.isNotEmpty ||
      !showCompleted ||
      !showRecommendations;

  MethodologyFilters copyWith({
    String? searchQuery,
    List<MethodologyCategory>? categories,
    List<ExecutionStatus>? statuses,
    List<MethodologyRiskLevel>? riskLevels,
    bool? showCompleted,
    bool? showRecommendations,
  }) {
    return MethodologyFilters(
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      statuses: statuses ?? this.statuses,
      riskLevels: riskLevels ?? this.riskLevels,
      showCompleted: showCompleted ?? this.showCompleted,
      showRecommendations: showRecommendations ?? this.showRecommendations,
    );
  }
}

// Methodology state notifier
class MethodologyNotifier extends StateNotifier<MethodologyState> {
  MethodologyNotifier(this._engine, this._service, this._projectId) : super(const MethodologyState()) {
    _initialize();
  }

  final MethodologyEngine _engine;
  final MethodologyService _service;
  final String _projectId;

  void _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      await _engine.initialize();
      await _service.initialize();

      // Load available methodologies from the service
      final availableMethodologies = _service.methodologies;

      // Set up stream listeners
      _engine.executionsStream.listen((executions) {
        final projectExecutions = executions.where((e) => e.projectId == _projectId).toList();
        state = state.copyWith(executions: projectExecutions);
      });

      _engine.recommendationsStream.listen((recommendations) {
        final projectRecommendations = recommendations.where((r) => r.projectId == _projectId).toList();
        state = state.copyWith(recommendations: projectRecommendations);
      });

      _engine.assetsStream.listen((assets) {
        state = state.copyWith(discoveredAssets: assets);
      });

      // Load initial data
      final projectAssets = _engine.getProjectAssets(_projectId);
      state = state.copyWith(
        availableMethodologies: availableMethodologies,
        discoveredAssets: projectAssets,
        isLoading: false,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Filter and search methods
  void updateFilters(MethodologyFilters filters) {
    state = state.copyWith(filters: filters);
  }

  void setSearchQuery(String query) {
    final updatedFilters = state.filters.copyWith(searchQuery: query);
    state = state.copyWith(filters: updatedFilters);
  }

  void setSelectedCategory(MethodologyCategory? category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleCategoryFilter(MethodologyCategory category) {
    final currentCategories = List<MethodologyCategory>.from(state.filters.categories);
    if (currentCategories.contains(category)) {
      currentCategories.remove(category);
    } else {
      currentCategories.add(category);
    }
    
    final updatedFilters = state.filters.copyWith(categories: currentCategories);
    state = state.copyWith(filters: updatedFilters);
  }

  void toggleStatusFilter(ExecutionStatus status) {
    final currentStatuses = List<ExecutionStatus>.from(state.filters.statuses);
    if (currentStatuses.contains(status)) {
      currentStatuses.remove(status);
    } else {
      currentStatuses.add(status);
    }
    
    final updatedFilters = state.filters.copyWith(statuses: currentStatuses);
    state = state.copyWith(filters: updatedFilters);
  }

  void clearFilters() {
    state = state.copyWith(
      filters: const MethodologyFilters(),
      selectedCategory: null,
    );
  }

  // Methodology execution methods
  Future<void> startMethodology(String methodologyId, {Map<String, dynamic>? additionalContext}) async {
    try {
      await _engine.startMethodologyExecution(_projectId, methodologyId, additionalContext: additionalContext);
    } catch (e) {
      state = state.copyWith(error: 'Failed to start methodology: $e');
    }
  }

  void dismissRecommendation(String recommendationId) {
    _engine.dismissRecommendation(recommendationId);
  }

  void suppressRecommendation(String recommendationId, String reason) {
    _engine.suppressRecommendation(recommendationId, reason);
  }

  // Asset management
  void addDiscoveredAsset(DiscoveredAsset asset) {
    _engine.addDiscoveredAsset(_projectId, asset);
  }

  void addDiscoveredAssets(List<DiscoveredAsset> assets) {
    _engine.addDiscoveredAssets(_projectId, assets);
  }

  // Get execution by ID
  MethodologyExecution? getExecution(String executionId) {
    return _engine.getExecution(executionId);
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}

// Provider for methodology state
final methodologyProvider = StateNotifierProvider.family<MethodologyNotifier, MethodologyState, String>((ref, projectId) {
  final engine = ref.read(methodologyEngineProvider);
  final service = ref.read(methodologyServiceProvider);
  return MethodologyNotifier(engine, service, projectId);
});

// Filtered methodologies provider
final filteredMethodologiesProvider = Provider.family<List<Methodology>, String>((ref, projectId) {
  final methodologyState = ref.watch(methodologyProvider(projectId));
  final filters = methodologyState.filters;
  
  // Start with available methodologies - for now, we'll use a mock list
  // In real implementation, this would come from the methodology service
  List<Methodology> methodologies = methodologyState.availableMethodologies;
  
  // Apply search filter
  if (filters.searchQuery.isNotEmpty) {
    final query = filters.searchQuery.toLowerCase();
    methodologies = methodologies.where((m) {
      return m.name.toLowerCase().contains(query) ||
             m.description.toLowerCase().contains(query) ||
             m.category.displayName.toLowerCase().contains(query);
    }).toList();
  }
  
  // Apply category filter
  if (filters.categories.isNotEmpty) {
    methodologies = methodologies.where((m) => filters.categories.contains(m.category)).toList();
  }
  
  // Apply risk level filter
  if (filters.riskLevels.isNotEmpty) {
    methodologies = methodologies.where((m) => filters.riskLevels.contains(m.riskLevel)).toList();
  }
  
  return methodologies;
});

// Filtered executions provider
final filteredExecutionsProvider = Provider.family<List<MethodologyExecution>, String>((ref, projectId) {
  final methodologyState = ref.watch(methodologyProvider(projectId));
  final filters = methodologyState.filters;
  
  List<MethodologyExecution> executions = methodologyState.executions;
  
  // Apply status filter
  if (filters.statuses.isNotEmpty) {
    executions = executions.where((e) => filters.statuses.contains(e.status)).toList();
  }
  
  // Apply completed filter
  if (!filters.showCompleted) {
    executions = executions.where((e) => !e.isCompleted).toList();
  }
  
  return executions;
});

// Filtered recommendations provider
final filteredRecommendationsProvider = Provider.family<List<MethodologyRecommendation>, String>((ref, projectId) {
  final methodologyState = ref.watch(methodologyProvider(projectId));
  final filters = methodologyState.filters;
  
  if (!filters.showRecommendations) return [];
  
  List<MethodologyRecommendation> recommendations = methodologyState.recommendations;
  
  // Filter out dismissed recommendations
  recommendations = recommendations.where((r) => !r.isDismissed).toList();
  
  return recommendations;
});

// Methodology statistics provider
final methodologyStatsProvider = Provider.family<MethodologyStats, String>((ref, projectId) {
  final executions = ref.watch(filteredExecutionsProvider(projectId));
  final recommendations = ref.watch(filteredRecommendationsProvider(projectId));
  final methodologyState = ref.watch(methodologyProvider(projectId));
  
  return MethodologyStats.fromExecutions(executions, recommendations, methodologyState.discoveredAssets);
});

// Methodology statistics class
class MethodologyStats {
  final int totalActions;
  final int pendingCount;
  final int inProgressCount;
  final int completedCount;
  final int failedCount;
  final int recommendationCount;
  final int discoveredAssetsCount;
  final Map<MethodologyCategory, int> categoryStats;
  final Map<AssetType, int> assetTypeStats;

  const MethodologyStats({
    required this.totalActions,
    required this.pendingCount,
    required this.inProgressCount,
    required this.completedCount,
    required this.failedCount,
    required this.recommendationCount,
    required this.discoveredAssetsCount,
    required this.categoryStats,
    required this.assetTypeStats,
  });

  factory MethodologyStats.fromExecutions(
    List<MethodologyExecution> executions,
    List<MethodologyRecommendation> recommendations,
    List<DiscoveredAsset> assets,
  ) {
    final categoryStats = <MethodologyCategory, int>{};
    final assetTypeStats = <AssetType, int>{};
    
    // Count executions by status
    int pendingCount = 0;
    int inProgressCount = 0;
    int completedCount = 0;
    int failedCount = 0;
    
    for (final execution in executions) {
      switch (execution.status) {
        case ExecutionStatus.pending:
          pendingCount++;
          break;
        case ExecutionStatus.inProgress:
          inProgressCount++;
          break;
        case ExecutionStatus.completed:
          completedCount++;
          break;
        case ExecutionStatus.failed:
          failedCount++;
          break;
        case ExecutionStatus.suppressed:
        case ExecutionStatus.blocked:
          // These don't count in the main stats
          break;
      }
    }
    
    // Count assets by type
    for (final asset in assets) {
      assetTypeStats[asset.type] = (assetTypeStats[asset.type] ?? 0) + 1;
    }
    
    return MethodologyStats(
      totalActions: executions.length + recommendations.length,
      pendingCount: pendingCount,
      inProgressCount: inProgressCount,
      completedCount: completedCount,
      failedCount: failedCount,
      recommendationCount: recommendations.length,
      discoveredAssetsCount: assets.length,
      categoryStats: categoryStats,
      assetTypeStats: assetTypeStats,
    );
  }
}

// Individual execution provider
final methodologyExecutionProvider = Provider.family<MethodologyExecution?, String>((ref, executionId) {
  final projectId = ref.watch(currentProjectProvider)?.id;
  if (projectId == null) return null;
  
  final methodologyState = ref.watch(methodologyProvider(projectId));
  return methodologyState.executions.firstWhere(
    (e) => e.id == executionId,
    orElse: () => throw StateError('Execution not found: $executionId'),
  );
});

// Import the current project provider from projects provider
// This assumes the currentProjectProvider is defined in projects_provider.dart