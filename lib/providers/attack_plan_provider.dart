import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/attack_plan_action.dart';
import '../models/asset.dart';
import '../services/attack_plan_generator.dart';
import '../services/drift_storage_service.dart';
import 'storage_provider.dart';

/// Provider for attack plan actions
final attackPlanActionsProvider = StateNotifierProvider.autoDispose
    .family<AttackPlanActionsNotifier, AsyncValue<List<AttackPlanAction>>, String>(
  (ref, projectId) {
    final storage = ref.watch(storageServiceProvider);
    return AttackPlanActionsNotifier(storage, projectId);
  },
);

/// Provider for attack plan generator
final attackPlanGeneratorProvider = Provider.autoDispose.family<AttackPlanGenerator, String>(
  (ref, projectId) {
    final storage = ref.watch(storageServiceProvider);
    return AttackPlanGenerator(storage: storage, projectId: projectId);
  },
);

/// Provider for attack plan statistics
final attackPlanStatsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>(
  (ref, projectId) async {
    final generator = ref.watch(attackPlanGeneratorProvider(projectId));
    return await generator.getActionStats();
  },
);

/// State notifier for managing attack plan actions
class AttackPlanActionsNotifier extends StateNotifier<AsyncValue<List<AttackPlanAction>>> {
  final DriftStorageService _storage;
  final String _projectId;
  AttackPlanGenerator? _generator;

  AttackPlanActionsNotifier(this._storage, this._projectId) : super(const AsyncValue.loading()) {
    _generator = AttackPlanGenerator(storage: _storage, projectId: _projectId);
    _loadActions();
  }

  /// Load all actions for the project
  Future<void> _loadActions() async {
    try {
      state = const AsyncValue.loading();
      final actions = await _generator!.getAllActions();
      state = AsyncValue.data(actions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Generate new actions from assets
  Future<void> generateActionsFromAssets(List<Asset> assets) async {
    try {
      state = const AsyncValue.loading();
      await _generator!.generateActionsFromAssets(assets);

      // Reload all actions to get the complete list
      final allActions = await _generator!.getAllActions();
      state = AsyncValue.data(allActions);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update action status
  Future<void> updateActionStatus(String actionId, ActionStatus newStatus) async {
    await _generator!.updateActionStatus(actionId, newStatus);
    await _loadActions(); // Reload to reflect changes
  }

  /// Get actions by status
  List<AttackPlanAction> getActionsByStatus(ActionStatus status) {
    return state.maybeWhen(
      data: (actions) => actions.where((action) => action.status == status).toList(),
      orElse: () => [],
    );
  }

  /// Refresh actions
  Future<void> refresh() async {
    await _loadActions();
  }

  /// Search actions by query
  List<AttackPlanAction> searchActions(String query) {
    if (query.isEmpty) {
      return state.maybeWhen(data: (actions) => actions, orElse: () => []);
    }

    return state.maybeWhen(
      data: (actions) => actions.where((action) {
        final searchQuery = query.toLowerCase();
        return action.title.toLowerCase().contains(searchQuery) ||
            action.objective.toLowerCase().contains(searchQuery) ||
            action.tags.any((tag) => tag.toLowerCase().contains(searchQuery));
      }).toList(),
      orElse: () => [],
    );
  }

  /// Filter actions by priority
  List<AttackPlanAction> filterByPriority(ActionPriority? priority) {
    if (priority == null) {
      return state.maybeWhen(data: (actions) => actions, orElse: () => []);
    }

    return state.maybeWhen(
      data: (actions) => actions.where((action) => action.priority == priority).toList(),
      orElse: () => [],
    );
  }

  /// Filter actions by risk level
  List<AttackPlanAction> filterByRiskLevel(ActionRiskLevel? riskLevel) {
    if (riskLevel == null) {
      return state.maybeWhen(data: (actions) => actions, orElse: () => []);
    }

    return state.maybeWhen(
      data: (actions) => actions.where((action) => action.riskLevel == riskLevel).toList(),
      orElse: () => [],
    );
  }

  /// Get action count by status
  Map<ActionStatus, int> getActionCountByStatus() {
    return state.maybeWhen(
      data: (actions) {
        final counts = <ActionStatus, int>{};
        for (final action in actions) {
          counts[action.status] = (counts[action.status] ?? 0) + 1;
        }
        return counts;
      },
      orElse: () => {},
    );
  }
}