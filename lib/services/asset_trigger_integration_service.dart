import 'dart:async';
import '../models/asset.dart';
import '../models/trigger_evaluation.dart';
import '../services/drift_storage_service.dart';
import '../services/comprehensive_trigger_evaluator.dart';
import '../services/error_tracking_service.dart';
import '../services/performance_monitor.dart';

/// Service responsible for managing automatic trigger evaluation when assets change
/// Provides intelligent re-evaluation, notifications, and batch processing
class AssetTriggerIntegrationService {
  final DriftStorageService _storage;
  final ComprehensiveTriggerEvaluator _triggerEvaluator;
  final String _projectId;

  // Stream controllers for real-time notifications
  final StreamController<TriggerEvaluationEvent> _evaluationEventsController =
      StreamController<TriggerEvaluationEvent>.broadcast();

  final StreamController<List<TriggerMatch>> _triggerMatchesController =
      StreamController<List<TriggerMatch>>.broadcast();

  // Batch processing state
  final Set<String> _pendingAssetEvaluations = <String>{};
  Timer? _batchProcessingTimer;
  static const Duration _batchDelay = Duration(milliseconds: 500);

  AssetTriggerIntegrationService({
    required DriftStorageService storage,
    required ComprehensiveTriggerEvaluator triggerEvaluator,
    required String projectId,
  }) : _storage = storage,
       _triggerEvaluator = triggerEvaluator,
       _projectId = projectId;

  /// Stream of trigger evaluation events
  Stream<TriggerEvaluationEvent> get evaluationEvents => _evaluationEventsController.stream;

  /// Stream of trigger matches
  Stream<List<TriggerMatch>> get triggerMatches => _triggerMatchesController.stream;

  /// Handle asset creation with automatic trigger evaluation
  Future<List<TriggerMatch>> onAssetCreated(Asset asset) async {
    PerformanceMonitor.startTimer('asset_creation_trigger_evaluation',
      metadata: {'assetId': asset.id, 'assetType': asset.type.name});
    _emitEvent(TriggerEvaluationEvent.assetCreated(asset.id));

    try {
      // Perform immediate evaluation for new assets
      final matches = await _triggerEvaluator.evaluateAsset(asset);

      // Store evaluation results
      await _storeTriggerMatches(matches);

      // Check for methodology triggers that might need immediate execution
      await _checkForImmediateExecution(matches, asset);

      _emitEvent(TriggerEvaluationEvent.evaluationCompleted(asset.id, matches.length));
      _triggerMatchesController.add(matches);

      PerformanceMonitor.endTimer('asset_creation_trigger_evaluation',
        metadata: {'assetId': asset.id, 'matchCount': matches.length});
      return matches;
    } catch (e, stack) {
      ErrorTrackingService().trackError(
        'asset_creation_trigger_evaluation',
        e,
        stack,
        additionalData: {'assetId': asset.id, 'assetType': asset.type.name},
      );
      PerformanceMonitor.endTimer('asset_creation_trigger_evaluation',
        metadata: {'assetId': asset.id, 'error': true});
      _emitEvent(TriggerEvaluationEvent.evaluationError(asset.id, e.toString()));
      rethrow;
    }
  }

  /// Handle asset updates with intelligent re-evaluation
  Future<List<TriggerMatch>> onAssetUpdated(Asset oldAsset, Asset newAsset) async {
    PerformanceMonitor.startTimer('asset_update_trigger_evaluation',
      metadata: {'assetId': newAsset.id, 'assetType': newAsset.type.name});
    _emitEvent(TriggerEvaluationEvent.assetUpdated(newAsset.id));

    try {
      // Check if properties changed that might affect trigger evaluation
      final significantChanges = _detectSignificantChanges(oldAsset, newAsset);

      if (significantChanges.isNotEmpty) {
        // Schedule batch evaluation to avoid rapid re-evaluations
        _scheduleBatchEvaluation(newAsset);
        PerformanceMonitor.endTimer('asset_update_trigger_evaluation',
          metadata: {'assetId': newAsset.id, 'changeCount': significantChanges.length, 'batchScheduled': true});
        return [];
      } else {
        // No significant changes, return existing matches
        final existingMatches = await _storage.getTriggerMatchesForAsset(_projectId, newAsset.id);
        PerformanceMonitor.endTimer('asset_update_trigger_evaluation',
          metadata: {'assetId': newAsset.id, 'noChanges': true});
        return existingMatches;
      }
    } catch (e, stack) {
      ErrorTrackingService().trackError(
        'asset_update_trigger_evaluation',
        e,
        stack,
        additionalData: {'assetId': newAsset.id, 'assetType': newAsset.type.name},
      );
      PerformanceMonitor.endTimer('asset_update_trigger_evaluation',
        metadata: {'assetId': newAsset.id, 'error': true});
      _emitEvent(TriggerEvaluationEvent.evaluationError(newAsset.id, e.toString()));
      rethrow;
    }
  }

  /// Handle asset deletion by cleaning up trigger matches
  Future<void> onAssetDeleted(String assetId) async {
    _emitEvent(TriggerEvaluationEvent.assetDeleted(assetId));

    try {
      // Remove all trigger matches for this asset
      await _storage.deleteTriggerMatchesForAsset(_projectId, assetId);

      // Cancel any pending evaluations
      _pendingAssetEvaluations.remove(assetId);

      _emitEvent(TriggerEvaluationEvent.evaluationCompleted(assetId, 0));
    } catch (e) {
      _emitEvent(TriggerEvaluationEvent.evaluationError(assetId, e.toString()));
      rethrow;
    }
  }

  /// Schedule evaluation of all assets (useful for methodology changes)
  Future<void> scheduleFullEvaluation() async {
    PerformanceMonitor.startTimer('full_evaluation_scheduling');
    _emitEvent(TriggerEvaluationEvent.batchEvaluationStarted());

    try {
      final assets = await _storage.getAllAssets(_projectId);

      for (final asset in assets) {
        _scheduleBatchEvaluation(asset);
      }

      _emitEvent(TriggerEvaluationEvent.batchEvaluationScheduled(assets.length));
      PerformanceMonitor.endTimer('full_evaluation_scheduling',
        metadata: {'assetCount': assets.length});
    } catch (e, stack) {
      ErrorTrackingService().trackError(
        'full_evaluation_scheduling',
        e,
        stack,
        additionalData: {'projectId': _projectId},
      );
      PerformanceMonitor.endTimer('full_evaluation_scheduling',
        metadata: {'error': true});
      _emitEvent(TriggerEvaluationEvent.batchEvaluationError(e.toString()));
      rethrow;
    }
  }

  /// Get current evaluation statistics
  Future<Map<String, dynamic>> getEvaluationStats() async {
    try {
      final totalMatches = await _storage.getTriggerMatchCount(_projectId);
      final successfulMatches = await _storage.getSuccessfulMatchCount(_projectId);
      final recentMatches = await _storage.getRecentTriggerMatches(_projectId, const Duration(hours: 24));

      return {
        'totalMatches': totalMatches,
        'successfulMatches': successfulMatches,
        'successRate': totalMatches > 0 ? (successfulMatches / totalMatches) : 0.0,
        'recentMatches': recentMatches.length,
        'pendingEvaluations': _pendingAssetEvaluations.length,
        'lastEvaluated': DateTime.now().toIso8601String(),
        'activeTriggers': await _getActiveTriggerCount(),
        'runInstances': await _getRunInstanceCount(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'totalMatches': 0,
        'successfulMatches': 0,
        'successRate': 0.0,
        'recentMatches': 0,
        'pendingEvaluations': _pendingAssetEvaluations.length,
      };
    }
  }

  /// Dispose resources
  void dispose() {
    _batchProcessingTimer?.cancel();
    _evaluationEventsController.close();
    _triggerMatchesController.close();
  }

  // Private helper methods

  /// Detect if asset changes are significant enough to trigger re-evaluation
  Set<String> _detectSignificantChanges(Asset oldAsset, Asset newAsset) {
    final changes = <String>{};

    // Check property changes
    for (final key in newAsset.properties.keys) {
      final oldValue = oldAsset.properties[key];
      final newValue = newAsset.properties[key];

      if (oldValue != newValue) {
        changes.add('property:$key');
      }
    }

    // Check for removed properties
    for (final key in oldAsset.properties.keys) {
      if (!newAsset.properties.containsKey(key)) {
        changes.add('property_removed:$key');
      }
    }

    // Check name or description changes
    if (oldAsset.name != newAsset.name) {
      changes.add('name');
    }

    if (oldAsset.description != newAsset.description) {
      changes.add('description');
    }

    return changes;
  }

  /// Schedule batch evaluation to avoid rapid re-evaluations
  void _scheduleBatchEvaluation(Asset asset) {
    _pendingAssetEvaluations.add(asset.id);

    // Cancel existing timer
    _batchProcessingTimer?.cancel();

    // Start new timer
    _batchProcessingTimer = Timer(_batchDelay, _processBatchEvaluations);
  }

  /// Process all pending asset evaluations
  Future<void> _processBatchEvaluations() async {
    if (_pendingAssetEvaluations.isEmpty) return;

    final assetIds = Set<String>.from(_pendingAssetEvaluations);
    _pendingAssetEvaluations.clear();

    PerformanceMonitor.startTimer('batch_trigger_evaluation',
      metadata: {'assetCount': assetIds.length});
    _emitEvent(TriggerEvaluationEvent.batchEvaluationStarted());

    try {
      final allMatches = <TriggerMatch>[];

      for (final assetId in assetIds) {
        final asset = await _storage.getAsset(assetId);
        if (asset != null) {
          final matches = await _triggerEvaluator.evaluateAsset(asset);
          await _storeTriggerMatches(matches);
          allMatches.addAll(matches);

          _emitEvent(TriggerEvaluationEvent.evaluationCompleted(assetId, matches.length));
        }
      }

      _triggerMatchesController.add(allMatches);
      _emitEvent(TriggerEvaluationEvent.batchEvaluationCompleted(assetIds.length));
      PerformanceMonitor.endTimer('batch_trigger_evaluation',
        metadata: {'assetCount': assetIds.length, 'totalMatches': allMatches.length});
    } catch (e, stack) {
      ErrorTrackingService().trackError(
        'batch_trigger_evaluation',
        e,
        stack,
        additionalData: {'assetCount': assetIds.length, 'assetIds': assetIds.toList()},
      );
      PerformanceMonitor.endTimer('batch_trigger_evaluation',
        metadata: {'assetCount': assetIds.length, 'error': true});
      _emitEvent(TriggerEvaluationEvent.batchEvaluationError(e.toString()));
    }
  }

  /// Store trigger matches in the database
  Future<void> _storeTriggerMatches(List<TriggerMatch> matches) async {
    for (final match in matches) {
      await _storage.storeTriggerMatch(match, _projectId);
    }
  }

  /// Check if any triggers require immediate execution
  Future<void> _checkForImmediateExecution(List<TriggerMatch> matches, Asset asset) async {
    for (final match in matches) {
      if (match.matched && match.priority <= 3) { // High priority triggers
        // This could trigger immediate methodology execution
        _emitEvent(TriggerEvaluationEvent.immediateExecutionRequired(
          match.assetId,
          match.triggerId,
          match.priority,
        ));
      }
    }
  }

  /// Get count of active triggers
  Future<int> _getActiveTriggerCount() async {
    try {
      final templates = await _storage.getAllTemplates();
      int count = 0;
      for (final template in templates) {
        count += template.triggers.length;
      }
      return count;
    } catch (e) {
      return 0;
    }
  }

  /// Get count of run instances
  Future<int> _getRunInstanceCount() async {
    try {
      return await _storage.getRunInstanceCount(_projectId);
    } catch (e) {
      return 0;
    }
  }

  /// Emit evaluation event
  void _emitEvent(TriggerEvaluationEvent event) {
    if (!_evaluationEventsController.isClosed) {
      _evaluationEventsController.add(event);
    }
  }
}

/// Event types for trigger evaluation
class TriggerEvaluationEvent {
  final TriggerEventType type;
  final String assetId;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  TriggerEvaluationEvent._({
    required this.type,
    required this.assetId,
    required this.data,
  }) : timestamp = DateTime.now();

  factory TriggerEvaluationEvent.assetCreated(String assetId) => TriggerEvaluationEvent._(
    type: TriggerEventType.assetCreated,
    assetId: assetId,
    data: {},
  );

  factory TriggerEvaluationEvent.assetUpdated(String assetId) => TriggerEvaluationEvent._(
    type: TriggerEventType.assetUpdated,
    assetId: assetId,
    data: {},
  );

  factory TriggerEvaluationEvent.assetDeleted(String assetId) => TriggerEvaluationEvent._(
    type: TriggerEventType.assetDeleted,
    assetId: assetId,
    data: {},
  );

  factory TriggerEvaluationEvent.evaluationCompleted(String assetId, int matchCount) => TriggerEvaluationEvent._(
    type: TriggerEventType.evaluationCompleted,
    assetId: assetId,
    data: {'matchCount': matchCount},
  );

  factory TriggerEvaluationEvent.evaluationError(String assetId, String error) => TriggerEvaluationEvent._(
    type: TriggerEventType.evaluationError,
    assetId: assetId,
    data: {'error': error},
  );

  factory TriggerEvaluationEvent.batchEvaluationStarted() => TriggerEvaluationEvent._(
    type: TriggerEventType.batchEvaluationStarted,
    assetId: '',
    data: {},
  );

  factory TriggerEvaluationEvent.batchEvaluationScheduled(int assetCount) => TriggerEvaluationEvent._(
    type: TriggerEventType.batchEvaluationScheduled,
    assetId: '',
    data: {'assetCount': assetCount},
  );

  factory TriggerEvaluationEvent.batchEvaluationCompleted(int assetCount) => TriggerEvaluationEvent._(
    type: TriggerEventType.batchEvaluationCompleted,
    assetId: '',
    data: {'assetCount': assetCount},
  );

  factory TriggerEvaluationEvent.batchEvaluationError(String error) => TriggerEvaluationEvent._(
    type: TriggerEventType.batchEvaluationError,
    assetId: '',
    data: {'error': error},
  );

  factory TriggerEvaluationEvent.immediateExecutionRequired(String assetId, String triggerId, int priority) => TriggerEvaluationEvent._(
    type: TriggerEventType.immediateExecutionRequired,
    assetId: assetId,
    data: {
      'triggerId': triggerId,
      'priority': priority,
    },
  );
}

enum TriggerEventType {
  assetCreated,
  assetUpdated,
  assetDeleted,
  evaluationCompleted,
  evaluationError,
  batchEvaluationStarted,
  batchEvaluationScheduled,
  batchEvaluationCompleted,
  batchEvaluationError,
  immediateExecutionRequired,
}