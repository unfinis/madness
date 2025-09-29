import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../models/methodology_trigger.dart' as trigger_models;
import 'methodology_service.dart';
import 'trigger_implementation_fix.dart';

// Stub classes to fix compilation
class TriggeredMethodology {
  final String id;
  final String methodologyId;
  final Map<String, dynamic> context;

  TriggeredMethodology({
    required this.id,
    required this.methodologyId,
    required this.context,
  });
}

class BatchedTrigger {
  final String id;
  final List<TriggeredMethodology> triggers;

  BatchedTrigger({
    required this.id,
    required this.triggers,
  });
}

class TriggerResult {
  final bool success;
  final String? error;

  TriggerResult({
    required this.success,
    this.error,
  });
}

/// Simplified Property Driven Engine stub for compilation
class PropertyDrivenEngine {
  static final PropertyDrivenEngine _instance = PropertyDrivenEngine._internal();
  factory PropertyDrivenEngine() => _instance;
  PropertyDrivenEngine._internal();

  final _uuid = const Uuid();
  final MethodologyService _methodologyService = MethodologyService();

  // Asset storage
  final Map<String, List<Asset>> _projectAssets = {};

  // Trigger definitions loaded from methodologies
  final List<trigger_models.MethodologyTrigger> _triggers = [];

  // Trigger execution tracking
  final Map<String, Set<String>> _completedTriggers = {};  // projectId -> Set of dedup keys
  final Map<String, TriggerResult> _triggerResults = {};    // dedup key -> result

  // Pending triggers queue
  final Map<String, List<TriggeredMethodology>> _pendingTriggers = {};

  // Batch processing
  final Map<String, BatchedTrigger> _batchedTriggers = {};

  // Streams for reactive updates
  final StreamController<List<Asset>> _assetsController =
      StreamController<List<Asset>>.broadcast();
  final StreamController<List<TriggeredMethodology>> _triggersController =
      StreamController<List<TriggeredMethodology>>.broadcast();
  final StreamController<List<BatchedTrigger>> _batchesController =
      StreamController<List<BatchedTrigger>>.broadcast();

  Stream<List<Asset>> get assetsStream => _assetsController.stream;
  Stream<List<TriggeredMethodology>> get triggersStream => _triggersController.stream;
  Stream<List<BatchedTrigger>> get batchesStream => _batchesController.stream;

  Future<void> initialize() async {
    await _methodologyService.initialize();
    _loadTriggerDefinitions();
  }

  void _loadTriggerDefinitions() {
    print('Loading trigger definitions with working implementation');

    // Use the new working implementation
    final loader = TriggerLoaderService();
    loader.initialize().then((_) {
      _triggers.clear();
      _triggers.addAll(loader.getTriggers());
      print('Loaded ${_triggers.length} triggers');

      // Re-evaluate all existing assets for new triggers
      for (final projectId in _projectAssets.keys) {
        _evaluateTriggersForProject(projectId);
      }
    }).catchError((error) {
      print('Error loading triggers: $error');
    });
  }

  // Asset management
  Future<void> addAsset(Asset asset) async {
    _projectAssets.putIfAbsent(asset.projectId, () => []).add(asset);
    _assetsController.add(_projectAssets[asset.projectId]!);

    // Evaluate triggers for the new asset
    await _evaluateTriggersForAsset(asset);
  }

  Future<void> updateAsset(Asset asset) async {
    final projectAssets = _projectAssets[asset.projectId];
    if (projectAssets != null) {
      final index = projectAssets.indexWhere((a) => a.id == asset.id);
      if (index != -1) {
        projectAssets[index] = asset;
        _assetsController.add(projectAssets);

        // Re-evaluate triggers for updated asset
        await _evaluateTriggersForAsset(asset);
      }
    }
  }

  List<Asset> getAssets(String projectId) {
    return _projectAssets[projectId] ?? [];
  }

  List<TriggeredMethodology> getPendingTriggers(String projectId) {
    return _pendingTriggers[projectId] ?? [];
  }

  List<BatchedTrigger> getBatchedTriggers() {
    return _batchedTriggers.values.toList();
  }

  /// Evaluate triggers for a single asset
  Future<void> _evaluateTriggersForAsset(Asset asset) async {
    if (_triggers.isEmpty) return;

    // Convert asset to trigger-compatible format
    final assetMap = SampleTriggers.convertAssetsForTriggers([asset]);
    if (assetMap.isEmpty) return;

    final assetData = assetMap.first;

    for (final trigger in _triggers) {
      if (!trigger.enabled) continue;

      // Check if we've already processed this trigger for this asset
      final dedupKey = _generateDeduplicationKey(trigger, assetData);
      final completedTriggers = _completedTriggers[asset.projectId] ?? <String>{};

      if (completedTriggers.contains(dedupKey)) {
        continue; // Already processed
      }

      // Check if trigger matches this asset
      final matches = TriggerEvaluatorFixed.findMatchingAssets(trigger, [assetData]);
      if (matches.isNotEmpty) {
        // Create triggered methodology
        final triggeredMethodology = TriggeredMethodology(
          id: _uuid.v4(),
          methodologyId: trigger.methodologyId,
          context: {
            'trigger': trigger.toJson(),
            'asset': assetData,
            'dedupKey': dedupKey,
          },
        );

        // Add to pending triggers
        _pendingTriggers.putIfAbsent(asset.projectId, () => []).add(triggeredMethodology);

        print('Triggered: ${trigger.name} for asset ${asset.name}');
      }
    }

    // Notify listeners
    _triggersController.add(_pendingTriggers[asset.projectId] ?? []);
  }

  /// Evaluate triggers for all assets in a project
  void _evaluateTriggersForProject(String projectId) {
    final assets = _projectAssets[projectId] ?? [];
    for (final asset in assets) {
      _evaluateTriggersForAsset(asset);
    }
  }

  /// Generate deduplication key for trigger-asset combination
  String _generateDeduplicationKey(trigger_models.MethodologyTrigger trigger, Map<String, dynamic> asset) {
    final template = trigger.deduplicationKeyTemplate ?? '{trigger.id}:{asset.id}';

    return template
        .replaceAll('{trigger.id}', trigger.id)
        .replaceAll('{asset.id}', asset['id']?.toString() ?? '')
        .replaceAll('{asset.type}', asset['type']?.toString() ?? '')
        .replaceAll('{asset.name}', asset['name']?.toString() ?? '')
        .replaceAll('{asset.identifier}', asset['identifier']?.toString() ?? '')
        .replaceAll('{asset.host}', asset['host']?.toString() ?? '')
        .replaceAll('{asset.subnet}', asset['subnet']?.toString() ?? '')
        .replaceAll('{asset.domain}', asset['domain']?.toString() ?? '')
        .replaceAll('{asset.username}', asset['username']?.toString() ?? '');
  }

  /// Mark a trigger as completed
  void markTriggerCompleted(String projectId, String dedupKey, {bool success = true, String? error}) {
    _completedTriggers.putIfAbsent(projectId, () => <String>{}).add(dedupKey);
    _triggerResults[dedupKey] = TriggerResult(success: success, error: error);

    print('Marked trigger completed: $dedupKey (success: $success)');
  }

  /// Get triggers matching test data (for development/testing)
  List<TriggeredMethodology> evaluateTestTriggers() {
    final testAssets = TriggerTestData.generateTestAssets();
    final triggeredMethodologies = <TriggeredMethodology>[];

    for (final trigger in _triggers) {
      if (!trigger.enabled) continue;

      final matches = TriggerEvaluatorFixed.findMatchingAssets(trigger, testAssets);
      for (final match in matches) {
        triggeredMethodologies.add(TriggeredMethodology(
          id: _uuid.v4(),
          methodologyId: trigger.methodologyId,
          context: {
            'trigger': trigger.toJson(),
            'asset': match,
            'dedupKey': _generateDeduplicationKey(trigger, match),
          },
        ));
      }
    }

    return triggeredMethodologies;
  }

  // Stub methods for other functionality
  void clearProject(String projectId) {
    _projectAssets.remove(projectId);
    _pendingTriggers.remove(projectId);
    _completedTriggers.remove(projectId);
  }

  void dispose() {
    _assetsController.close();
    _triggersController.close();
    _batchesController.close();
  }
}