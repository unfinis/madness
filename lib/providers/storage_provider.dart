import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/drift_storage_service.dart';
import '../providers/database_provider.dart';
import '../models/run_instance.dart';
import '../models/trigger_evaluation.dart';
import '../services/methodology_loader.dart' as loader;

/// Provider for the Drift-based storage service
final storageServiceProvider = Provider<DriftStorageService>((ref) {
  final database = ref.read(databaseProvider);
  return DriftStorageService(database);
});

/// Provider for methodology templates from storage
final templatesProvider = FutureProvider<List<loader.MethodologyTemplate>>((ref) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getAllTemplates();
});

/// Provider for a specific methodology template
final templateProvider = FutureProvider.family<loader.MethodologyTemplate?, String>((ref, templateId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getTemplate(templateId);
});

/// Provider for all run instances (requires project ID)
final runInstancesProvider = FutureProvider.family<List<RunInstance>, String>((ref, projectId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getAllRunInstances(projectId);
});

/// Provider for run instances by status (requires project ID and status)
final runInstancesByStatusProvider = FutureProvider.family<List<RunInstance>, ({String projectId, RunInstanceStatus status})>((ref, params) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getRunInstancesByStatus(params.projectId, params.status);
});

/// Provider for run instances for a specific asset (requires project ID and asset ID)
final runInstancesForAssetProvider = FutureProvider.family<List<RunInstance>, ({String projectId, String assetId})>((ref, params) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getRunInstancesForAsset(params.projectId, params.assetId);
});

/// Provider for run instances for a specific template (requires project ID and template ID)
final runInstancesForTemplateProvider = FutureProvider.family<List<RunInstance>, ({String projectId, String templateId})>((ref, params) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getRunInstancesForTemplate(params.projectId, params.templateId);
});

/// Provider for a specific run instance
final runInstanceProvider = FutureProvider.family<RunInstance?, String>((ref, runId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getRunInstance(runId);
});

/// Provider for trigger matches for an asset (requires project ID and asset ID)
final triggerMatchesForAssetProvider = FutureProvider.family<List<TriggerMatch>, ({String projectId, String assetId})>((ref, params) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getTriggerMatchesForAsset(params.projectId, params.assetId);
});

/// Provider for all successful trigger matches (requires project ID)
final successfulTriggerMatchesProvider = FutureProvider.family<List<TriggerMatch>, String>((ref, projectId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getSuccessfulMatches(projectId);
});

/// Provider for history entries for a run instance
final historyForRunInstanceProvider = FutureProvider.family<List<HistoryEntry>, String>((ref, runId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getHistoryForRunInstance(runId);
});

/// Provider for storage statistics (requires project ID)
final storageStatsProvider = FutureProvider.family<Map<String, int>, String>((ref, projectId) async {
  final storage = ref.read(storageServiceProvider);
  return await storage.getStorageStats(projectId);
});

/// State notifier for managing run instances (requires project ID)
class RunInstanceNotifier extends StateNotifier<AsyncValue<List<RunInstance>>> {
  final DriftStorageService _storage;
  final String _projectId;

  RunInstanceNotifier(this._storage, this._projectId) : super(const AsyncValue.loading()) {
    _loadRunInstances();
  }

  Future<void> _loadRunInstances() async {
    try {
      final instances = await _storage.getAllRunInstances(_projectId);
      state = AsyncValue.data(instances);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addRunInstance(RunInstance instance) async {
    try {
      await _storage.storeRunInstance(instance, _projectId);
      await _loadRunInstances(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateRunInstance(RunInstance instance) async {
    try {
      await _storage.updateRunInstance(instance, _projectId);
      await _loadRunInstances(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteRunInstance(String runId) async {
    try {
      await _storage.deleteRunInstance(runId);
      await _loadRunInstances(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _loadRunInstances();
  }
}

/// Provider for the run instance notifier (requires project ID)
final runInstanceNotifierProvider = StateNotifierProvider.family<RunInstanceNotifier, AsyncValue<List<RunInstance>>, String>((ref, projectId) {
  final storage = ref.read(storageServiceProvider);
  return RunInstanceNotifier(storage, projectId);
});

/// State notifier for managing methodology templates
class TemplateNotifier extends StateNotifier<AsyncValue<List<loader.MethodologyTemplate>>> {
  final DriftStorageService _storage;

  TemplateNotifier(this._storage) : super(const AsyncValue.loading()) {
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final templates = await _storage.getAllTemplates();
      state = AsyncValue.data(templates);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> addTemplate(loader.MethodologyTemplate template) async {
    try {
      await _storage.storeTemplate(template);
      await _loadTemplates(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteTemplate(String templateId) async {
    try {
      await _storage.deleteTemplate(templateId);
      await _loadTemplates(); // Refresh the list
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void refresh() {
    _loadTemplates();
  }
}

/// Provider for the template notifier
final templateNotifierProvider = StateNotifierProvider<TemplateNotifier, AsyncValue<List<loader.MethodologyTemplate>>>((ref) {
  final storage = ref.read(storageServiceProvider);
  return TemplateNotifier(storage);
});