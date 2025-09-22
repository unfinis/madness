import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/run_instance.dart';
import '../models/project.dart';
import '../services/methodology_execution_orchestrator.dart';
import '../services/methodology_engine.dart';
import '../providers/storage_provider.dart';
import '../providers/projects_provider.dart';

/// Provider for methodology execution orchestrator
final methodologyExecutionOrchestratorProvider =
    Provider.family<MethodologyExecutionOrchestrator, String>((ref, projectId) {
  final storage = ref.watch(storageServiceProvider);
  final methodologyEngine = MethodologyEngine();

  return MethodologyExecutionOrchestrator(
    storage: storage,
    methodologyEngine: methodologyEngine,
    projectId: projectId,
  );
});

/// Provider for current project's orchestrator
final currentProjectOrchestratorProvider = Provider<MethodologyExecutionOrchestrator?>((ref) {
  final currentProject = ref.watch(currentProjectProvider);
  if (currentProject == null) return null;

  return ref.watch(methodologyExecutionOrchestratorProvider(currentProject.id));
});

/// Provider for orchestrator status
final orchestratorStatusProvider = StateNotifierProvider<OrchestratorStatusNotifier, OrchestratorStatus>((ref) {
  return OrchestratorStatusNotifier(ref);
});

/// Provider for pending run instances
final pendingRunInstancesProvider =
    FutureProvider.family<List<RunInstance>, String>((ref, projectId) async {
  final orchestrator = ref.watch(methodologyExecutionOrchestratorProvider(projectId));
  return await orchestrator.getPendingRunInstances();
});

/// Provider for current project's pending run instances
final currentProjectPendingRunInstancesProvider = FutureProvider<List<RunInstance>>((ref) async {
  final currentProject = ref.watch(currentProjectProvider);
  if (currentProject == null) return [];

  return await ref.watch(pendingRunInstancesProvider(currentProject.id).future);
});

/// Provider for execution statistics
final executionStatsProvider = Provider.family<Map<String, dynamic>, String>((ref, projectId) {
  final orchestrator = ref.watch(methodologyExecutionOrchestratorProvider(projectId));
  return orchestrator.executionStats;
});

/// Provider for current project's execution statistics
final currentProjectExecutionStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final currentProject = ref.watch(currentProjectProvider);
  if (currentProject == null) return {};

  return ref.watch(executionStatsProvider(currentProject.id));
});

/// State notifier for orchestrator status
class OrchestratorStatusNotifier extends StateNotifier<OrchestratorStatus> {
  final Ref _ref;
  MethodologyExecutionOrchestrator? _currentOrchestrator;

  OrchestratorStatusNotifier(this._ref) : super(const OrchestratorStatus()) {
    // Listen to current project changes
    _ref.listen(currentProjectProvider, (previous, next) {
      _onProjectChanged(next);
    });

    // Initialize with current project
    final currentProject = _ref.read(currentProjectProvider);
    if (currentProject != null) {
      _onProjectChanged(currentProject);
    }
  }

  void _onProjectChanged(Project? project) {
    // Stop previous orchestrator
    if (_currentOrchestrator != null) {
      _currentOrchestrator!.stop();
      _currentOrchestrator = null;
    }

    if (project != null) {
      // Start new orchestrator
      _currentOrchestrator = _ref.read(methodologyExecutionOrchestratorProvider(project.id));
      _startOrchestrator();
    }

    state = state.copyWith(
      isRunning: project != null,
      currentProjectId: project?.id,
    );
  }

  void _startOrchestrator() {
    if (_currentOrchestrator == null) return;

    _currentOrchestrator!.start().then((_) {
      state = state.copyWith(isRunning: true, lastStarted: DateTime.now());

      // Listen to execution events
      _currentOrchestrator!.executionEvents.listen((event) {
        _handleExecutionEvent(event);
      });
    }).catchError((error) {
      state = state.copyWith(
        isRunning: false,
        lastError: error.toString(),
      );
    });
  }

  void _handleExecutionEvent(ExecutionEvent event) {
    state = state.copyWith(
      lastEventType: event.type,
      lastEventTime: event.timestamp,
      activeExecutions: _currentOrchestrator?.activeExecutionCount ?? 0,
    );
  }

  /// Start the orchestrator
  Future<void> start() async {
    if (_currentOrchestrator == null) return;

    try {
      await _currentOrchestrator!.start();
      state = state.copyWith(isRunning: true, lastStarted: DateTime.now());
    } catch (e) {
      state = state.copyWith(lastError: e.toString());
      rethrow;
    }
  }

  /// Stop the orchestrator
  void stop() {
    _currentOrchestrator?.stop();
    state = state.copyWith(isRunning: false, lastStopped: DateTime.now());
  }

  /// Enable or disable auto-execution
  void setAutoExecutionEnabled(bool enabled) {
    _currentOrchestrator?.setAutoExecutionEnabled(enabled);
    state = state.copyWith(autoExecutionEnabled: enabled);
  }

  /// Set maximum concurrent executions
  void setMaxConcurrentExecutions(int max) {
    _currentOrchestrator?.setMaxConcurrentExecutions(max);
    state = state.copyWith(maxConcurrentExecutions: max);
  }

  /// Manually execute a run instance
  Future<bool> executeRunInstance(String runId) async {
    if (_currentOrchestrator == null) return false;

    try {
      return await _currentOrchestrator!.executeRunInstance(runId);
    } catch (e) {
      state = state.copyWith(lastError: e.toString());
      return false;
    }
  }

  @override
  void dispose() {
    _currentOrchestrator?.dispose();
    super.dispose();
  }
}

/// State class for orchestrator status
class OrchestratorStatus {
  final bool isRunning;
  final String? currentProjectId;
  final bool autoExecutionEnabled;
  final int maxConcurrentExecutions;
  final int activeExecutions;
  final DateTime? lastStarted;
  final DateTime? lastStopped;
  final String? lastError;
  final ExecutionEventType? lastEventType;
  final DateTime? lastEventTime;

  const OrchestratorStatus({
    this.isRunning = false,
    this.currentProjectId,
    this.autoExecutionEnabled = true,
    this.maxConcurrentExecutions = 3,
    this.activeExecutions = 0,
    this.lastStarted,
    this.lastStopped,
    this.lastError,
    this.lastEventType,
    this.lastEventTime,
  });

  OrchestratorStatus copyWith({
    bool? isRunning,
    String? currentProjectId,
    bool? autoExecutionEnabled,
    int? maxConcurrentExecutions,
    int? activeExecutions,
    DateTime? lastStarted,
    DateTime? lastStopped,
    String? lastError,
    ExecutionEventType? lastEventType,
    DateTime? lastEventTime,
  }) {
    return OrchestratorStatus(
      isRunning: isRunning ?? this.isRunning,
      currentProjectId: currentProjectId ?? this.currentProjectId,
      autoExecutionEnabled: autoExecutionEnabled ?? this.autoExecutionEnabled,
      maxConcurrentExecutions: maxConcurrentExecutions ?? this.maxConcurrentExecutions,
      activeExecutions: activeExecutions ?? this.activeExecutions,
      lastStarted: lastStarted ?? this.lastStarted,
      lastStopped: lastStopped ?? this.lastStopped,
      lastError: lastError ?? this.lastError,
      lastEventType: lastEventType ?? this.lastEventType,
      lastEventTime: lastEventTime ?? this.lastEventTime,
    );
  }
}