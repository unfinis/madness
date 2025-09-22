import 'dart:async';
import 'dart:math';
import '../models/run_instance.dart';
import '../models/methodology_execution.dart';
import '../models/methodology.dart';
import '../services/drift_storage_service.dart';
import '../services/methodology_engine.dart';
import '../services/methodology_loader.dart' as loader;

/// Orchestrates automatic execution of methodologies when triggers fire
/// Bridges the gap between trigger evaluation and methodology execution
class MethodologyExecutionOrchestrator {
  final DriftStorageService _storage;
  final MethodologyEngine _methodologyEngine;
  final String _projectId;

  // Execution control
  Timer? _monitoringTimer;
  bool _autoExecutionEnabled = true;
  int _maxConcurrentExecutions = 3;
  final Set<String> _activeExecutions = <String>{};

  // Stream controllers for notifications
  final StreamController<ExecutionEvent> _executionEventsController =
      StreamController<ExecutionEvent>.broadcast();

  // Execution statistics
  int _totalExecutions = 0;
  int _successfulExecutions = 0;
  int _failedExecutions = 0;

  MethodologyExecutionOrchestrator({
    required DriftStorageService storage,
    required MethodologyEngine methodologyEngine,
    required String projectId,
  }) : _storage = storage,
       _methodologyEngine = methodologyEngine,
       _projectId = projectId;

  /// Stream of execution events
  Stream<ExecutionEvent> get executionEvents => _executionEventsController.stream;

  /// Whether auto-execution is enabled
  bool get autoExecutionEnabled => _autoExecutionEnabled;

  /// Number of currently active executions
  int get activeExecutionCount => _activeExecutions.length;

  /// Execution statistics
  Map<String, dynamic> get executionStats => {
    'totalExecutions': _totalExecutions,
    'successfulExecutions': _successfulExecutions,
    'failedExecutions': _failedExecutions,
    'successRate': _totalExecutions > 0 ? (_successfulExecutions / _totalExecutions) : 0.0,
    'activeExecutions': _activeExecutions.length,
    'maxConcurrentExecutions': _maxConcurrentExecutions,
    'autoExecutionEnabled': _autoExecutionEnabled,
  };

  /// Start the orchestrator with automatic monitoring
  Future<void> start() async {
    _emitEvent(ExecutionEvent.orchestratorStarted());

    // Check for existing pending run instances
    await _processPendingRunInstances();

    // Start periodic monitoring for new pending instances
    _monitoringTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _processPendingRunInstances(),
    );
  }

  /// Stop the orchestrator
  void stop() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _emitEvent(ExecutionEvent.orchestratorStopped());
  }

  /// Enable or disable auto-execution
  void setAutoExecutionEnabled(bool enabled) {
    _autoExecutionEnabled = enabled;
    _emitEvent(ExecutionEvent.autoExecutionToggled(enabled));
  }

  /// Set maximum concurrent executions
  void setMaxConcurrentExecutions(int max) {
    _maxConcurrentExecutions = max.clamp(1, 10);
    _emitEvent(ExecutionEvent.configurationChanged('maxConcurrentExecutions', _maxConcurrentExecutions));
  }

  /// Manually trigger execution of a specific run instance
  Future<bool> executeRunInstance(String runId) async {
    try {
      final runInstance = await _storage.getRunInstance(runId);
      if (runInstance == null) {
        _emitEvent(ExecutionEvent.executionError(runId, 'Run instance not found'));
        return false;
      }

      if (runInstance.status != RunInstanceStatus.pending) {
        _emitEvent(ExecutionEvent.executionError(runId, 'Run instance is not in pending status'));
        return false;
      }

      return await _executeRunInstance(runInstance);
    } catch (e) {
      _emitEvent(ExecutionEvent.executionError(runId, e.toString()));
      return false;
    }
  }

  /// Get pending run instances that are ready for execution
  Future<List<RunInstance>> getPendingRunInstances() async {
    try {
      final allRunInstances = await _storage.getAllRunInstances(_projectId);
      return allRunInstances
          .where((instance) => instance.status == RunInstanceStatus.pending)
          .toList()
        ..sort((a, b) => b.priority.compareTo(a.priority)); // Sort by priority (high to low)
    } catch (e) {
      _emitEvent(ExecutionEvent.monitoringError(e.toString()));
      return [];
    }
  }

  /// Process all pending run instances
  Future<void> _processPendingRunInstances() async {
    if (!_autoExecutionEnabled) return;

    try {
      final pendingInstances = await getPendingRunInstances();

      if (pendingInstances.isEmpty) return;

      _emitEvent(ExecutionEvent.pendingInstancesFound(pendingInstances.length));

      // Execute instances up to the concurrent limit
      final availableSlots = _maxConcurrentExecutions - _activeExecutions.length;
      final instancesToExecute = pendingInstances.take(availableSlots).toList();

      for (final instance in instancesToExecute) {
        if (_activeExecutions.length >= _maxConcurrentExecutions) break;

        // Execute asynchronously without waiting
        _executeRunInstanceAsync(instance);
      }
    } catch (e) {
      _emitEvent(ExecutionEvent.monitoringError(e.toString()));
    }
  }

  /// Execute a run instance asynchronously
  void _executeRunInstanceAsync(RunInstance instance) {
    _executeRunInstance(instance).then((success) {
      if (success) {
        _successfulExecutions++;
      } else {
        _failedExecutions++;
      }
    }).catchError((e) {
      _failedExecutions++;
      _emitEvent(ExecutionEvent.executionError(instance.runId, e.toString()));
    }).whenComplete(() {
      _activeExecutions.remove(instance.runId);
      _emitEvent(ExecutionEvent.executionCompleted(instance.runId));
    });
  }

  /// Execute a specific run instance
  Future<bool> _executeRunInstance(RunInstance instance) async {
    if (_activeExecutions.contains(instance.runId)) {
      return false; // Already executing
    }

    _activeExecutions.add(instance.runId);
    _totalExecutions++;
    _emitEvent(ExecutionEvent.executionStarted(instance.runId));

    try {
      // Update status to in progress
      await _updateRunInstanceStatus(instance, RunInstanceStatus.inProgress);

      // Load the methodology template
      final template = await _loadMethodologyTemplate(instance.templateId);
      if (template == null) {
        await _updateRunInstanceStatus(instance, RunInstanceStatus.failed);
        _emitEvent(ExecutionEvent.executionError(instance.runId, 'Methodology template not found'));
        return false;
      }

      // Convert template to the format expected by MethodologyEngine
      final methodology = await _convertTemplateToMethodology(template, instance);

      // Prepare execution context
      final executionContext = _prepareExecutionContext(instance);

      // Start methodology execution using the MethodologyEngine
      final execution = await _methodologyEngine.startMethodologyExecution(
        _projectId,
        methodology.id,
        additionalContext: executionContext,
      );

      // Monitor the execution and update run instance accordingly
      await _monitorMethodologyExecution(instance, execution);

      return true;
    } catch (e) {
      await _updateRunInstanceStatus(instance, RunInstanceStatus.failed);
      _emitEvent(ExecutionEvent.executionError(instance.runId, e.toString()));
      return false;
    }
  }

  /// Load methodology template
  Future<loader.MethodologyTemplate?> _loadMethodologyTemplate(String templateId) async {
    try {
      final templates = await _storage.getAllTemplates();
      return templates.firstWhere(
        (template) => template.id == templateId,
        orElse: () => throw Exception('Template not found'),
      );
    } catch (e) {
      return null;
    }
  }

  /// Convert methodology template to the format expected by MethodologyEngine
  Future<Methodology> _convertTemplateToMethodology(
    loader.MethodologyTemplate template,
    RunInstance instance,
  ) async {
    // This is a simplified conversion - in a real implementation,
    // you'd have more sophisticated mapping between template formats
    return Methodology(
      id: template.id,
      name: template.name,
      version: template.templateVersion,
      projectId: _projectId,
      description: template.description,
      category: MethodologyCategory.scanning, // Default category
      rationale: 'Auto-generated from trigger evaluation',
      riskLevel: MethodologyRiskLevel.medium, // Default risk level
      stealthLevel: StealthLevel.active, // Default stealth level
      estimatedDuration: const Duration(minutes: 30), // Default duration
      steps: [], // Would be converted from template.actions
      triggers: [], // Would be converted from template.triggers
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
  }

  /// Prepare execution context from run instance
  Map<String, dynamic> _prepareExecutionContext(RunInstance instance) {
    return {
      'runInstanceId': instance.runId,
      'templateId': instance.templateId,
      'templateVersion': instance.templateVersion,
      'triggerId': instance.triggerId,
      'assetId': instance.assetId,
      'matchedValues': instance.matchedValues,
      'parameters': instance.parameters,
      'priority': instance.priority,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'createdBy': instance.createdBy,
    };
  }

  /// Monitor methodology execution and update run instance
  Future<void> _monitorMethodologyExecution(
    RunInstance instance,
    MethodologyExecution execution,
  ) async {
    // Listen to execution updates
    final subscription = _methodologyEngine.executionsStream.listen((executions) {
      final currentExecution = executions.firstWhere(
        (exec) => exec.id == execution.id,
        orElse: () => execution,
      );

      _updateRunInstanceFromExecution(instance, currentExecution);
    });

    // Wait for execution to complete (simplified approach)
    var currentExecution = execution;
    while (currentExecution.status == ExecutionStatus.pending ||
           currentExecution.status == ExecutionStatus.inProgress) {
      await Future.delayed(const Duration(seconds: 5));

      final updatedExecution = _methodologyEngine.getExecution(execution.id);
      if (updatedExecution != null) {
        currentExecution = updatedExecution;
      }
    }

    subscription.cancel();

    // Final status update
    await _updateRunInstanceFromExecution(instance, currentExecution);
  }

  /// Update run instance based on methodology execution status
  Future<void> _updateRunInstanceFromExecution(
    RunInstance instance,
    MethodologyExecution execution,
  ) async {
    RunInstanceStatus newStatus;

    switch (execution.status) {
      case ExecutionStatus.pending:
        newStatus = RunInstanceStatus.pending;
        break;
      case ExecutionStatus.inProgress:
        newStatus = RunInstanceStatus.inProgress;
        break;
      case ExecutionStatus.completed:
        newStatus = RunInstanceStatus.completed;
        break;
      case ExecutionStatus.failed:
        newStatus = RunInstanceStatus.failed;
        break;
      case ExecutionStatus.suppressed:
        newStatus = RunInstanceStatus.blocked;
        break;
      case ExecutionStatus.blocked:
        newStatus = RunInstanceStatus.blocked;
        break;
    }

    if (instance.status != newStatus) {
      await _updateRunInstanceStatus(instance, newStatus);
    }
  }

  /// Update run instance status in storage
  Future<void> _updateRunInstanceStatus(RunInstance instance, RunInstanceStatus newStatus) async {
    final updatedInstance = instance.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );

    await _storage.updateRunInstance(updatedInstance, _projectId);

    // Add history entry
    final historyEntry = HistoryEntry(
      id: _generateHistoryId(),
      timestamp: DateTime.now(),
      performedBy: 'orchestrator',
      action: HistoryActionType.statusChanged,
      description: 'Status changed from ${instance.status.displayName} to ${newStatus.displayName}',
      previousValue: instance.status.name,
      newValue: newStatus.name,
    );

    await _storage.storeHistoryEntry(historyEntry, instance.runId);
  }

  /// Generate unique ID for history entries
  String _generateHistoryId() {
    return 'hist_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Emit execution event
  void _emitEvent(ExecutionEvent event) {
    if (!_executionEventsController.isClosed) {
      _executionEventsController.add(event);
    }
  }

  /// Dispose resources
  void dispose() {
    stop();
    _executionEventsController.close();
  }
}

/// Event types for execution orchestration
class ExecutionEvent {
  final ExecutionEventType type;
  final String? runId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  ExecutionEvent._({
    required this.type,
    this.runId,
    required this.data,
  }) : timestamp = DateTime.now();

  factory ExecutionEvent.orchestratorStarted() => ExecutionEvent._(
    type: ExecutionEventType.orchestratorStarted,
    data: {},
  );

  factory ExecutionEvent.orchestratorStopped() => ExecutionEvent._(
    type: ExecutionEventType.orchestratorStopped,
    data: {},
  );

  factory ExecutionEvent.autoExecutionToggled(bool enabled) => ExecutionEvent._(
    type: ExecutionEventType.autoExecutionToggled,
    data: {'enabled': enabled},
  );

  factory ExecutionEvent.configurationChanged(String setting, dynamic value) => ExecutionEvent._(
    type: ExecutionEventType.configurationChanged,
    data: {'setting': setting, 'value': value},
  );

  factory ExecutionEvent.pendingInstancesFound(int count) => ExecutionEvent._(
    type: ExecutionEventType.pendingInstancesFound,
    data: {'count': count},
  );

  factory ExecutionEvent.executionStarted(String runId) => ExecutionEvent._(
    type: ExecutionEventType.executionStarted,
    runId: runId,
    data: {},
  );

  factory ExecutionEvent.executionCompleted(String runId) => ExecutionEvent._(
    type: ExecutionEventType.executionCompleted,
    runId: runId,
    data: {},
  );

  factory ExecutionEvent.executionError(String runId, String error) => ExecutionEvent._(
    type: ExecutionEventType.executionError,
    runId: runId,
    data: {'error': error},
  );

  factory ExecutionEvent.monitoringError(String error) => ExecutionEvent._(
    type: ExecutionEventType.monitoringError,
    data: {'error': error},
  );
}

enum ExecutionEventType {
  orchestratorStarted,
  orchestratorStopped,
  autoExecutionToggled,
  configurationChanged,
  pendingInstancesFound,
  executionStarted,
  executionCompleted,
  executionError,
  monitoringError,
}

