import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/comprehensive_trigger_evaluator.dart';
import '../models/asset.dart';
import '../models/trigger_evaluation.dart';
import '../providers/storage_provider.dart';

/// Provider for trigger evaluation service
final triggerEvaluationServiceProvider = Provider.family<ComprehensiveTriggerEvaluator, String>((ref, projectId) {
  final storage = ref.read(storageServiceProvider);
  return ComprehensiveTriggerEvaluator(
    storage: storage,
    projectId: projectId,
  );
});

/// Provider for trigger matches for a specific asset
final triggerMatchesForAssetProvider = FutureProvider.family<List<TriggerMatch>, ({String projectId, String assetId})>((ref, params) async {
  return await ref.read(storageServiceProvider).getTriggerMatchesForAsset(params.projectId, params.assetId);
});

/// Provider for all successful trigger matches in a project
final successfulTriggerMatchesProvider = FutureProvider.family<List<TriggerMatch>, String>((ref, projectId) async {
  return await ref.read(storageServiceProvider).getSuccessfulMatches(projectId);
});

/// Provider for trigger evaluation statistics
final triggerEvaluationStatsProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, projectId) async {
  final evaluationService = ref.read(triggerEvaluationServiceProvider(projectId));
  return await evaluationService.getEvaluationStats();
});

/// State notifier for managing trigger evaluation processes
class TriggerEvaluationNotifier extends StateNotifier<AsyncValue<List<TriggerMatch>>> {
  final ComprehensiveTriggerEvaluator _evaluationService;

  TriggerEvaluationNotifier(this._evaluationService) : super(const AsyncValue.loading());

  /// Evaluate triggers for a specific asset
  Future<void> evaluateAsset(Asset asset) async {
    try {
      state = const AsyncValue.loading();
      final matches = await _evaluationService.evaluateAsset(asset);
      state = AsyncValue.data(matches);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Evaluate all triggers against all assets
  Future<void> evaluateAllAssets() async {
    try {
      state = const AsyncValue.loading();
      final allMatches = await _evaluationService.evaluateAllAssets();

      // Flatten the map of matches into a single list
      final matches = allMatches.values.expand((list) => list).toList();
      state = AsyncValue.data(matches);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh the evaluation state
  void refresh() {
    state = const AsyncValue.loading();
    // Note: This would trigger a re-evaluation if we had access to the assets
    // For now, just reset to loading state
  }
}

/// Provider for the trigger evaluation notifier
final triggerEvaluationNotifierProvider = StateNotifierProvider.family<TriggerEvaluationNotifier, AsyncValue<List<TriggerMatch>>, String>((ref, projectId) {
  final evaluationService = ref.read(triggerEvaluationServiceProvider(projectId));
  return TriggerEvaluationNotifier(evaluationService);
});

/// Provider for batch trigger processing status
class BatchTriggerProcessingNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final ComprehensiveTriggerEvaluator _evaluationService;

  BatchTriggerProcessingNotifier(this._evaluationService) : super(const AsyncValue.data({}));

  /// Start batch processing of triggers
  Future<void> startBatchProcessing() async {
    try {
      state = const AsyncValue.loading();

      // Placeholder for batch processing logic
      final stats = await _evaluationService.getEvaluationStats();

      state = AsyncValue.data({
        'status': 'completed',
        'timestamp': DateTime.now().toIso8601String(),
        'stats': stats,
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Get current batch processing status
  void getStatus() {
    // Return current state - no async operation needed
  }
}

/// Provider for batch trigger processing
final batchTriggerProcessingProvider = StateNotifierProvider.family<BatchTriggerProcessingNotifier, AsyncValue<Map<String, dynamic>>, String>((ref, projectId) {
  final evaluationService = ref.read(triggerEvaluationServiceProvider(projectId));
  return BatchTriggerProcessingNotifier(evaluationService);
});

/// Provider for monitoring trigger evaluation performance
final triggerEvaluationPerformanceProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, projectId) {
  // Create a periodic stream that provides performance metrics
  return Stream.periodic(
    const Duration(seconds: 30),
    (count) => {
      'timestamp': DateTime.now().toIso8601String(),
      'evaluationCycle': count,
      'projectId': projectId,
    },
  );
});

/// Provider for trigger evaluation configuration
class TriggerEvaluationConfig {
  final bool autoEvaluationEnabled;
  final Duration evaluationInterval;
  final int maxConcurrentEvaluations;
  final bool debugMode;

  const TriggerEvaluationConfig({
    this.autoEvaluationEnabled = true,
    this.evaluationInterval = const Duration(minutes: 5),
    this.maxConcurrentEvaluations = 10,
    this.debugMode = false,
  });

  TriggerEvaluationConfig copyWith({
    bool? autoEvaluationEnabled,
    Duration? evaluationInterval,
    int? maxConcurrentEvaluations,
    bool? debugMode,
  }) {
    return TriggerEvaluationConfig(
      autoEvaluationEnabled: autoEvaluationEnabled ?? this.autoEvaluationEnabled,
      evaluationInterval: evaluationInterval ?? this.evaluationInterval,
      maxConcurrentEvaluations: maxConcurrentEvaluations ?? this.maxConcurrentEvaluations,
      debugMode: debugMode ?? this.debugMode,
    );
  }
}

/// Provider for trigger evaluation configuration
final triggerEvaluationConfigProvider = StateProvider<TriggerEvaluationConfig>((ref) {
  return const TriggerEvaluationConfig();
});