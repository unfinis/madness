import 'dart:async';
import 'dart:math';
import '../models/asset.dart';
import '../models/trigger_evaluation.dart';
import '../models/run_instance.dart';
import '../services/drift_storage_service.dart';
import '../services/methodology_loader.dart' as loader;
import '../services/trigger_dsl_parser.dart';

/// Comprehensive trigger evaluation service that integrates with Drift storage
/// and provides asset-trigger matching with deduplication and batch processing
class ComprehensiveTriggerEvaluator {
  final DriftStorageService _storage;
  final String _projectId;

  ComprehensiveTriggerEvaluator({
    required DriftStorageService storage,
    required String projectId,
  }) : _storage = storage, _projectId = projectId;

  /// Evaluate all triggers against a specific asset
  Future<List<TriggerMatch>> evaluateAsset(Asset asset) async {
    final templates = await _storage.getAllTemplates();
    final results = <TriggerMatch>[];

    for (final template in templates) {
      final triggers = template.triggers;

      for (final triggerData in triggers) {
        final trigger = triggerData is loader.MethodologyTrigger
            ? triggerData
            : loader.MethodologyTrigger.fromJson(triggerData as Map<String, dynamic>);

        // Check if trigger applies to this asset type
        if (!_isAssetTypeCompatible(trigger, asset)) {
          continue;
        }

        // Generate deduplication key
        final dedupKey = _generateDeduplicationKey(trigger, asset, template);

        // Check if this trigger was already executed recently
        if (await _isDeduplicationKeyUsed(dedupKey, trigger)) {
          continue;
        }

        // Evaluate trigger conditions
        final match = await _evaluateTrigger(trigger, asset, template);

        if (match != null) {
          // Store the trigger match
          await _storage.storeTriggerMatch(match, _projectId);
          results.add(match);

          // If successful match, create run instance
          if (match.matched) {
            await _createRunInstance(trigger, asset, template, match);
          }
        }
      }
    }

    return results;
  }

  /// Evaluate all triggers against all assets in the project
  Future<Map<String, List<TriggerMatch>>> evaluateAllAssets() async {
    // Note: This would require access to asset data through a provider
    // For now, return empty map - will be implemented when asset provider is available
    return {};
  }

  /// Evaluate a specific trigger against all compatible assets
  Future<List<TriggerMatch>> evaluateTriggerAcrossAssets(
    loader.MethodologyTrigger trigger,
    loader.MethodologyTemplate template,
  ) async {
    // Note: This would require access to asset data through a provider
    // For now, return empty list - will be implemented when asset provider is available
    return [];
  }

  /// Check if an asset type is compatible with a trigger
  bool _isAssetTypeCompatible(loader.MethodologyTrigger trigger, Asset asset) {
    // For now, accept all asset types until we implement the asset type checking
    // This would check trigger.assetType against asset.type
    return true;
  }

  /// Generate deduplication key for a trigger-asset combination
  String _generateDeduplicationKey(
    loader.MethodologyTrigger trigger,
    Asset asset,
    loader.MethodologyTemplate template,
  ) {
    // Use a simple template since the loader.MethodologyTrigger doesn't have deduplicationKeyTemplate
    var key = '{asset.id}:{trigger.name}:{template.id}';

    // Replace asset properties
    key = key.replaceAll('{asset.id}', asset.id);
    key = key.replaceAll('{asset.type}', asset.type.name);
    key = key.replaceAll('{asset.name}', asset.name);

    // Replace trigger properties
    key = key.replaceAll('{trigger.name}', trigger.name);
    key = key.replaceAll('{template.id}', template.id);

    // Generate hash for complex properties if needed
    if (key.contains('{hash}')) {
      final hashData = '${asset.properties}:${trigger.name}';
      final hash = hashData.hashCode.toRadixString(16);
      key = key.replaceAll('{hash}', hash);
    }

    return key;
  }

  /// Check if a deduplication key was already used within the cooldown period
  Future<bool> _isDeduplicationKeyUsed(String dedupKey, loader.MethodologyTrigger trigger) async {
    final existingInstances = await _storage.getAllRunInstances(_projectId);

    for (final instance in existingInstances) {
      if (instance.parameters.containsKey('deduplicationKey') &&
          instance.parameters['deduplicationKey'] == dedupKey) {

        // Check cooldown period (default to 24 hours since loader.MethodologyTrigger doesn't have cooldownPeriod)
        const cooldown = Duration(hours: 24);
        final timeSinceExecution = DateTime.now().difference(instance.createdAt);

        if (timeSinceExecution < cooldown) {
          return true; // Still in cooldown
        }
      }
    }

    return false;
  }

  /// Evaluate a specific trigger against an asset
  Future<TriggerMatch?> _evaluateTrigger(
    loader.MethodologyTrigger trigger,
    Asset asset,
    loader.MethodologyTemplate template,
  ) async {
    final matchId = _generateMatchId();
    final evaluatedAt = DateTime.now();

    try {
      // Extract asset properties for evaluation
      final extractedValues = <String, dynamic>{};
      final debugInfo = <String, dynamic>{
        'triggerConditions': trigger.conditions,
        'assetProperties': asset.properties.map((k, v) => MapEntry(k, v.toString())),
        'evaluationStartTime': evaluatedAt.toIso8601String(),
      };

      // Evaluate trigger conditions using the existing TriggerEvaluator
      bool matched = false;

      if (trigger.conditions != null) {
        // Convert the dynamic conditions to the appropriate type
        matched = _evaluateConditions(trigger.conditions, asset, extractedValues, debugInfo);
      }

      // Calculate confidence based on match quality
      double confidence = matched ? 1.0 : 0.0;
      if (matched && extractedValues.isNotEmpty) {
        // Boost confidence if we extracted meaningful values
        confidence = min(1.0, confidence + (extractedValues.length * 0.1));
      }

      debugInfo['matched'] = matched;
      debugInfo['confidence'] = confidence;
      debugInfo['extractedValues'] = extractedValues;

      return TriggerMatch(
        id: matchId,
        triggerId: trigger.name, // Use name as ID since loader.MethodologyTrigger doesn't have id
        templateId: template.id,
        assetId: asset.id,
        matched: matched,
        extractedValues: extractedValues,
        confidence: confidence,
        evaluatedAt: evaluatedAt,
        priority: 5, // Default priority since loader.MethodologyTrigger doesn't have priority
        debugInfo: debugInfo,
      );

    } catch (e, stackTrace) {
      // Return failed match with error information
      return TriggerMatch(
        id: matchId,
        triggerId: trigger.name, // Use name as ID since loader.MethodologyTrigger doesn't have id
        templateId: template.id,
        assetId: asset.id,
        matched: false,
        extractedValues: {},
        confidence: 0.0,
        evaluatedAt: evaluatedAt,
        priority: 5, // Default priority since loader.MethodologyTrigger doesn't have priority
        error: 'Evaluation failed: $e',
        debugInfo: {
          'error': e.toString(),
          'stackTrace': stackTrace.toString(),
          'triggerConditions': trigger.conditions,
        },
      );
    }
  }

  /// Evaluate trigger conditions using DSL parser
  bool _evaluateConditions(
    dynamic conditions,
    Asset asset,
    Map<String, dynamic> extractedValues,
    Map<String, dynamic> debugInfo,
  ) {
    // Handle string expressions using DSL parser
    if (conditions is String) {
      final result = TriggerDslParser.evaluateExpression(conditions, asset.properties);
      extractedValues.addAll(result.variables);
      debugInfo['dslEvaluation'] = {
        'expression': conditions,
        'result': result.result,
        'executionTimeMs': result.executionTimeMs,
        'debugTrace': result.debugTrace,
        'error': result.error,
      };
      return result.result;
    }

    // Handle object-based conditions (legacy format)
    if (conditions is Map<String, dynamic>) {
      // Single condition
      if (conditions.containsKey('property') && conditions.containsKey('operator')) {
        final property = conditions['property'] as String;
        final operator = conditions['operator'] as String;
        final value = conditions['value'];

        return _evaluateSingleCondition(property, operator, value, asset, extractedValues);
      }

      // Handle logical grouping
      if (conditions.containsKey('and')) {
        final andConditions = conditions['and'] as List;
        return andConditions.every((cond) => _evaluateConditions(cond, asset, extractedValues, debugInfo));
      }

      if (conditions.containsKey('or')) {
        final orConditions = conditions['or'] as List;
        return orConditions.any((cond) => _evaluateConditions(cond, asset, extractedValues, debugInfo));
      }

      // Handle condition expression within object
      if (conditions.containsKey('expression')) {
        final expression = conditions['expression'] as String;
        final result = TriggerDslParser.evaluateExpression(expression, asset.properties);
        extractedValues.addAll(result.variables);
        debugInfo['dslEvaluation'] = {
          'expression': expression,
          'result': result.result,
          'executionTimeMs': result.executionTimeMs,
          'debugTrace': result.debugTrace,
        };
        return result.result;
      }
    }

    if (conditions is List) {
      // Treat list as AND by default
      return conditions.every((cond) => _evaluateConditions(cond, asset, extractedValues, debugInfo));
    }

    // Default behavior for unknown condition formats
    debugInfo['conditionWarning'] = 'Unknown condition format, defaulting to true';
    return true;
  }

  /// Evaluate a single condition
  bool _evaluateSingleCondition(
    String property,
    String operator,
    dynamic value,
    Asset asset,
    Map<String, dynamic> extractedValues,
  ) {
    final assetProperty = asset.properties[property];

    if (assetProperty == null) {
      return operator == 'notExists' || operator == 'not_exists';
    }

    // Extract the value for later use
    extractedValues[property] = assetProperty.when(
      string: (v) => v,
      integer: (v) => v,
      boolean: (v) => v,
      stringList: (v) => v,
      map: (v) => v,
      objectList: (v) => v,
    );

    switch (operator) {
      case 'exists':
        return true;
      case 'equals':
      case 'eq':
        return assetProperty.when(
          string: (v) => v == value,
          integer: (v) => v == value,
          boolean: (v) => v == value,
          stringList: (v) => v.contains(value),
          map: (v) => v[value] != null,
          objectList: (v) => v.any((obj) => obj.containsValue(value)),
        );
      case 'contains':
        return assetProperty.when(
          string: (v) => v.contains(value.toString()),
          integer: (v) => false,
          boolean: (v) => false,
          stringList: (v) => v.contains(value),
          map: (v) => v.containsKey(value),
          objectList: (v) => v.any((obj) => obj.containsValue(value)),
        );
      case 'greaterThan':
      case 'gt':
        return assetProperty.when(
          string: (v) => v.length > (value as int),
          integer: (v) => v > (value as int),
          boolean: (v) => false,
          stringList: (v) => v.length > (value as int),
          map: (v) => v.length > (value as int),
          objectList: (v) => v.length > (value as int),
        );
      default:
        return false;
    }
  }

  /// Create a run instance for a successful trigger match
  Future<void> _createRunInstance(
    loader.MethodologyTrigger trigger,
    Asset asset,
    loader.MethodologyTemplate template,
    TriggerMatch match,
  ) async {
    final runId = _generateRunId();
    final now = DateTime.now();

    final runInstance = RunInstance(
      runId: runId,
      templateId: template.id,
      templateVersion: template.templateVersion,
      triggerId: trigger.name,
      assetId: asset.id,
      matchedValues: match.extractedValues,
      parameters: {
        'deduplicationKey': _generateDeduplicationKey(trigger, asset, template),
        'triggerMatchId': match.id,
        'evaluatedAt': match.evaluatedAt.toIso8601String(),
        'confidence': match.confidence,
      },
      status: RunInstanceStatus.pending,
      createdAt: now,
      createdBy: 'trigger_evaluator',
      evidenceIds: [],
      findingIds: [],
      history: [],
      priority: 5, // Default priority since loader.MethodologyTrigger doesn't have priority
      tags: [
        'auto_triggered',
        'asset_${asset.type.name}',
        'methodology_${template.name.toLowerCase().replaceAll(' ', '_')}',
      ],
    );

    await _storage.storeRunInstance(runInstance, _projectId);

    // Create initial history entry
    final historyEntry = HistoryEntry(
      id: _generateHistoryId(),
      timestamp: now,
      performedBy: 'trigger_evaluator',
      action: HistoryActionType.created,
      description: 'Run instance created from trigger evaluation',
      metadata: {
        'triggerId': trigger.name,
        'assetId': asset.id,
        'confidence': match.confidence,
      },
    );

    await _storage.storeHistoryEntry(historyEntry, runId);
  }

  /// Generate unique ID for trigger matches
  String _generateMatchId() {
    return 'match_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Generate unique ID for run instances
  String _generateRunId() {
    return 'run_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Generate unique ID for history entries
  String _generateHistoryId() {
    return 'hist_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Get statistics about trigger evaluations
  Future<Map<String, dynamic>> getEvaluationStats() async {
    final stats = await _storage.getStorageStats(_projectId);
    final triggerMatches = await _storage.getSuccessfulMatches(_projectId);

    return {
      'totalMatches': stats['triggerMatches'] ?? 0,
      'successfulMatches': triggerMatches.length,
      'runInstances': stats['runInstances'] ?? 0,
      'templates': stats['templates'] ?? 0,
      'lastEvaluated': DateTime.now().toIso8601String(),
    };
  }

  /// Clean up old trigger matches and run instances
  Future<void> cleanupOldData({Duration? maxAge}) async {
    final cutoffDate = DateTime.now().subtract(maxAge ?? Duration(days: 30));

    // Note: This would require additional methods in DriftStorageService
    // to delete old records based on date filters
    // For now, this is a placeholder for future implementation
  }
}