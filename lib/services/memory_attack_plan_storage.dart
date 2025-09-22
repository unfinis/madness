import '../models/attack_plan_action.dart';

/// Simple in-memory storage for attack plan actions
/// This is a temporary solution until proper database storage is implemented
class MemoryAttackPlanStorage {
  static final Map<String, List<AttackPlanAction>> _storage = {};

  /// Get all project IDs with stored actions
  static Iterable<String> get projectIds => _storage.keys;

  /// Store an attack plan action
  static void storeAction(AttackPlanAction action, String projectId) {
    _storage.putIfAbsent(projectId, () => []).add(action);
  }

  /// Get all attack plan actions for a project
  static List<AttackPlanAction> getAllActions(String projectId) {
    return List.from(_storage[projectId] ?? []);
  }

  /// Update action status
  static void updateActionStatus(String actionId, ActionStatus newStatus, String projectId) {
    final actions = _storage[projectId] ?? [];
    final actionIndex = actions.indexWhere((action) => action.id == actionId);

    if (actionIndex != -1) {
      final oldAction = actions[actionIndex];
      final updatedAction = oldAction.copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      actions[actionIndex] = updatedAction;
    }
  }

  /// Get action by ID
  static AttackPlanAction? getActionById(String actionId, String projectId) {
    final actions = _storage[projectId] ?? [];
    try {
      return actions.firstWhere((action) => action.id == actionId);
    } catch (e) {
      return null;
    }
  }

  /// Clear all actions for a project
  static void clearActions(String projectId) {
    _storage.remove(projectId);
  }

  /// Get actions count by status
  static Map<ActionStatus, int> getActionCountByStatus(String projectId) {
    final actions = _storage[projectId] ?? [];
    final counts = <ActionStatus, int>{};

    for (final action in actions) {
      counts[action.status] = (counts[action.status] ?? 0) + 1;
    }

    return counts;
  }
}