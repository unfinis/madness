import 'dart:async';
import '../models/assets.dart';
import '../models/asset_relationships.dart';
import 'asset_relationship_manager.dart';
import 'asset_update_hooks.dart';
import 'discovery_orchestrator.dart';
import 'trigger_system/execution_policy.dart';
import 'trigger_system/execution_history.dart';
import 'trigger_system/models/execution_decision.dart';
import 'trigger_system/models/trigger_match_result.dart';

/// Smart trigger system that automatically evaluates and executes methodologies
/// based on asset properties, relationships, and state changes
class SmartTriggerSystem {
  final AssetRelationshipManager _relationshipManager;
  final AssetUpdateHooks _updateHooks;
  final DiscoveryOrchestrator _discoveryOrchestrator;

  // Trigger registry and evaluation state
  final Map<String, TriggerDefinition> _triggers = {};
  final Map<String, List<TriggerEvaluation>> _evaluationHistory = {};
  final Map<String, DateTime> _lastEvaluationTime = {};

  // New trigger system components
  late final ExecutionHistory _executionHistory;
  late final ExecutionPolicy _executionPolicy;

  // Event streams
  final StreamController<TriggerEvent> _triggerEventController =
      StreamController<TriggerEvent>.broadcast();

  SmartTriggerSystem(
    this._relationshipManager,
    this._updateHooks,
    this._discoveryOrchestrator,
  ) {
    // Initialize new trigger system
    _executionHistory = ExecutionHistory();
    _executionPolicy = ExecutionPolicy(history: _executionHistory);

    _initializeDefaultTriggers();
    _subscribeToAssetEvents();
  }

  /// Stream of trigger events
  Stream<TriggerEvent> get triggerEvents => _triggerEventController.stream;

  /// Register a new trigger definition
  void registerTrigger(TriggerDefinition trigger) {
    _triggers[trigger.id] = trigger;
    print('Registered trigger: ${trigger.name}');
  }

  /// Evaluate all triggers for a specific asset
  Future<List<TriggerEvaluation>> evaluateTriggersForAsset(String assetId) async {
    final asset = await _relationshipManager.getAsset(assetId);
    if (asset == null) {
      throw TriggerException('Asset not found: $assetId');
    }

    final evaluations = <TriggerEvaluation>[];

    for (final trigger in _triggers.values) {
      try {
        final evaluation = await _evaluateTrigger(trigger, asset);
        if (evaluation != null) {
          evaluations.add(evaluation);

          // Store evaluation history
          if (!_evaluationHistory.containsKey(assetId)) {
            _evaluationHistory[assetId] = [];
          }
          _evaluationHistory[assetId]!.add(evaluation);

          // Execute trigger if conditions are met
          if (evaluation.shouldExecute && !evaluation.alreadyExecuted) {
            await _executeTrigger(evaluation, asset);
          }
        }
      } catch (e) {
        print('Error evaluating trigger ${trigger.name}: $e');
      }
    }

    _lastEvaluationTime[assetId] = DateTime.now();
    return evaluations;
  }

  /// Evaluate triggers based on property combinations
  Future<List<TriggerEvaluation>> evaluatePropertyBasedTriggers(
    Asset asset,
    Map<String, AssetPropertyValue> changedProperties,
  ) async {
    final evaluations = <TriggerEvaluation>[];

    final propertyTriggers = _triggers.values.where(
      (t) => t.type == TriggerType.propertyBased
    );

    for (final trigger in propertyTriggers) {
      try {
        final evaluation = await _evaluatePropertyTrigger(trigger, asset, changedProperties);
        if (evaluation != null && evaluation.shouldExecute) {
          evaluations.add(evaluation);
          await _executeTrigger(evaluation, asset);
        }
      } catch (e) {
        print('Error evaluating property trigger ${trigger.name}: $e');
      }
    }

    return evaluations;
  }

  /// Evaluate cascade triggers (when one methodology leads to another)
  Future<List<TriggerEvaluation>> evaluateCascadeTriggers(
    Asset sourceAsset,
    String completedMethodologyId,
  ) async {
    final evaluations = <TriggerEvaluation>[];

    final cascadeTriggers = _triggers.values.where(
      (t) => t.type == TriggerType.cascade &&
             t.conditions['prerequisite_methodology'] == completedMethodologyId
    );

    for (final trigger in cascadeTriggers) {
      try {
        final evaluation = await _evaluateCascadeTrigger(trigger, sourceAsset, completedMethodologyId);
        if (evaluation != null && evaluation.shouldExecute) {
          evaluations.add(evaluation);
          await _executeTrigger(evaluation, sourceAsset);
        }
      } catch (e) {
        print('Error evaluating cascade trigger ${trigger.name}: $e');
      }
    }

    return evaluations;
  }

  /// Get trigger execution history for an asset
  List<TriggerEvaluation> getTriggerHistory(String assetId) {
    return _evaluationHistory[assetId] ?? [];
  }

  /// Get all pending trigger executions
  List<TriggerEvaluation> getPendingExecutions() {
    final pending = <TriggerEvaluation>[];

    for (final evaluations in _evaluationHistory.values) {
      pending.addAll(evaluations.where((e) => e.shouldExecute && !e.alreadyExecuted));
    }

    return pending;
  }

  /// Manually execute a trigger for testing
  Future<TriggerExecutionResult> manuallyExecuteTrigger(
    String triggerId,
    String assetId,
  ) async {
    final trigger = _triggers[triggerId];
    if (trigger == null) {
      throw TriggerException('Trigger not found: $triggerId');
    }

    final asset = await _relationshipManager.getAsset(assetId);
    if (asset == null) {
      throw TriggerException('Asset not found: $assetId');
    }

    final evaluation = TriggerEvaluation(
      id: _generateEvaluationId(),
      triggerId: triggerId,
      assetId: assetId,
      evaluatedAt: DateTime.now(),
      shouldExecute: true,
      alreadyExecuted: false,
      conditions: trigger.conditions,
      confidence: 1.0,
      reason: 'Manual execution',
    );

    return await _executeTrigger(evaluation, asset);
  }

  // Private implementation methods

  void _initializeDefaultTriggers() {
    // Network Access Control (NAC) bypass trigger
    registerTrigger(TriggerDefinition(
      id: 'nac_bypass_available',
      name: 'NAC Bypass Available',
      description: 'Triggers when NAC is enabled but credentials are available',
      type: TriggerType.propertyBased,
      conditions: {
        'nac_enabled': true,
        'credentials_available': 'exists',
        'access_level': ['blocked', 'limited']
      },
      methodologyId: 'nac_credential_testing',
      priority: Priority.high,
      cooldownPeriod: Duration(hours: 1),
    ));

    // Web service discovery trigger
    registerTrigger(TriggerDefinition(
      id: 'web_services_discovered',
      name: 'Web Services Discovered',
      description: 'Triggers when web services are found on a host',
      type: TriggerType.propertyBased,
      conditions: {
        'web_services': 'exists',
        'services_scanned': false,
      },
      methodologyId: 'web_application_testing',
      priority: Priority.medium,
      cooldownPeriod: Duration(minutes: 30),
    ));

    // Domain admin access trigger
    registerTrigger(TriggerDefinition(
      id: 'domain_admin_available',
      name: 'Domain Admin Access Available',
      description: 'Triggers when domain admin credentials are obtained',
      type: TriggerType.propertyBased,
      conditions: {
        'domain_admin_access': true,
        'domain_enumerated': false,
      },
      methodologyId: 'domain_enumeration',
      priority: Priority.critical,
      cooldownPeriod: Duration(minutes: 15),
    ));

    // Host compromise to lateral movement trigger
    registerTrigger(TriggerDefinition(
      id: 'host_compromised_lateral',
      name: 'Host Compromised - Lateral Movement',
      description: 'Triggers lateral movement when a host is compromised',
      type: TriggerType.stateBased,
      conditions: {
        'lifecycle_state': 'compromised',
        'lateral_movement_attempted': false,
      },
      methodologyId: 'lateral_movement',
      priority: Priority.high,
      cooldownPeriod: Duration(minutes: 20),
    ));

    // Trust relationship discovered trigger
    registerTrigger(TriggerDefinition(
      id: 'trust_relationship_discovered',
      name: 'Trust Relationship Discovered',
      description: 'Triggers when trust relationships are found',
      type: TriggerType.cascade,
      conditions: {
        'prerequisite_methodology': 'domain_enumeration',
        'trust_relationships': 'exists',
      },
      methodologyId: 'trust_abuse',
      priority: Priority.high,
      cooldownPeriod: Duration(minutes: 30),
    ));

    // Cloud service discovery trigger
    registerTrigger(TriggerDefinition(
      id: 'cloud_services_discovered',
      name: 'Cloud Services Discovered',
      description: 'Triggers when cloud services are identified',
      type: TriggerType.propertyBased,
      conditions: {
        'cloud_services': 'exists',
        'cloud_enumerated': false,
      },
      methodologyId: 'cloud_enumeration',
      priority: Priority.medium,
      cooldownPeriod: Duration(hours: 2),
    ));
  }

  void _subscribeToAssetEvents() {
    _updateHooks.updateEvents.listen((event) {
      switch (event) {
        case AssetStateChangeEvent():
          _handleStateChange(event.asset, event.oldState, event.newState);
          break;
        case AssetPropertyChangeEvent():
          _handlePropertyChange(event.asset, event.propertyKey, event.oldValue, event.newValue);
          break;
        case AssetRelationshipChangeEvent():
          _handleRelationshipChange(event.relationship, event.changeType);
          break;
        case AssetDiscoveryEvent():
          _handleAssetDiscovery(event.asset, event.context);
          break;
      }
    });
  }

  void _handleStateChange(Asset asset, String oldState, String newState) async {
    try {
      await evaluateTriggersForAsset(asset.id);
    } catch (e) {
      print('Error handling state change for ${asset.id}: $e');
    }
  }

  void _handlePropertyChange(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) async {
    try {
      await evaluatePropertyBasedTriggers(asset, {propertyKey: newValue!});
    } catch (e) {
      print('Error handling property change for ${asset.id}: $e');
    }
  }

  void _handleRelationshipChange(
    AssetRelationship relationship,
    RelationshipChangeType changeType,
  ) async {
    try {
      // Evaluate triggers for both source and target assets
      await evaluateTriggersForAsset(relationship.sourceAssetId);
      await evaluateTriggersForAsset(relationship.targetAssetId);
    } catch (e) {
      print('Error handling relationship change: $e');
    }
  }

  void _handleAssetDiscovery(Asset asset, DiscoveryContext context) async {
    try {
      await evaluateTriggersForAsset(asset.id);
    } catch (e) {
      print('Error handling asset discovery for ${asset.id}: $e');
    }
  }

  Future<TriggerEvaluation?> _evaluateTrigger(TriggerDefinition trigger, Asset asset) async {
    // Check cooldown period
    final lastEvaluation = _getLastEvaluationTime(trigger.id, asset.id);
    if (lastEvaluation != null &&
        DateTime.now().difference(lastEvaluation) < trigger.cooldownPeriod) {
      return null; // Still in cooldown
    }

    // Check if already executed
    final alreadyExecuted = _wasAlreadyExecuted(trigger.id, asset.id);

    bool shouldExecute = false;
    double confidence = 0.0;
    String reason = '';

    switch (trigger.type) {
      case TriggerType.propertyBased:
        final result = _evaluatePropertyConditions(trigger.conditions, asset);
        shouldExecute = result.$1;
        confidence = result.$2;
        reason = result.$3;
        break;

      case TriggerType.stateBased:
        final result = _evaluateStateConditions(trigger.conditions, asset);
        shouldExecute = result.$1;
        confidence = result.$2;
        reason = result.$3;
        break;

      case TriggerType.cascade:
        // Cascade triggers are evaluated separately
        return null;
    }

    if (shouldExecute || confidence > 0.0) {
      return TriggerEvaluation(
        id: _generateEvaluationId(),
        triggerId: trigger.id,
        assetId: asset.id,
        evaluatedAt: DateTime.now(),
        shouldExecute: shouldExecute && !alreadyExecuted,
        alreadyExecuted: alreadyExecuted,
        conditions: trigger.conditions,
        confidence: confidence,
        reason: reason,
      );
    }

    return null;
  }

  Future<TriggerEvaluation?> _evaluatePropertyTrigger(
    TriggerDefinition trigger,
    Asset asset,
    Map<String, AssetPropertyValue> changedProperties,
  ) async {
    // Check if the changed properties are relevant to this trigger
    final relevantChanges = <String, AssetPropertyValue>{};
    for (final key in trigger.conditions.keys) {
      if (changedProperties.containsKey(key)) {
        relevantChanges[key] = changedProperties[key]!;
      }
    }

    if (relevantChanges.isEmpty) return null;

    return await _evaluateTrigger(trigger, asset);
  }

  Future<TriggerEvaluation?> _evaluateCascadeTrigger(
    TriggerDefinition trigger,
    Asset asset,
    String completedMethodologyId,
  ) async {
    // Verify the prerequisite methodology was completed
    if (trigger.conditions['prerequisite_methodology'] != completedMethodologyId) {
      return null;
    }

    // Evaluate other conditions
    final result = _evaluatePropertyConditions(trigger.conditions, asset);

    if (result.$1) {
      return TriggerEvaluation(
        id: _generateEvaluationId(),
        triggerId: trigger.id,
        assetId: asset.id,
        evaluatedAt: DateTime.now(),
        shouldExecute: true,
        alreadyExecuted: false,
        conditions: trigger.conditions,
        confidence: result.$2,
        reason: 'Cascade trigger from ${completedMethodologyId}: ${result.$3}',
      );
    }

    return null;
  }

  (bool, double, String) _evaluatePropertyConditions(
    Map<String, dynamic> conditions,
    Asset asset,
  ) {
    bool allConditionsMet = true;
    final reasons = <String>[];
    final List<ConditionCheckResult> conditionChecks = [];

    for (final entry in conditions.entries) {
      final key = entry.key;
      final expectedValue = entry.value;

      // Skip non-property conditions
      if (key == 'prerequisite_methodology') continue;

      final actualProperty = asset.properties[key];

      bool conditionMet = false;
      String reason = '';
      dynamic actualValue;

      if (expectedValue == 'exists') {
        conditionMet = actualProperty != null;
        actualValue = actualProperty != null ? 'exists' : 'null';
        reason = conditionMet ? '$key exists' : '$key does not exist';
      } else if (expectedValue is bool) {
        actualValue = actualProperty?.when(
          string: (value) => null,
          integer: (value) => null,
          double: (value) => null,
          boolean: (value) => value,
          stringList: (value) => null,
          dateTime: (value) => null,
          map: (value) => null,
          objectList: (value) => null,
        );
        conditionMet = actualValue == expectedValue;
        reason = conditionMet ? '$key matches $expectedValue' : '$key does not match $expectedValue';
      } else if (expectedValue is String) {
        actualValue = actualProperty?.when(
          string: (value) => value,
          integer: (value) => null,
          double: (value) => null,
          boolean: (value) => null,
          stringList: (value) => null,
          dateTime: (value) => null,
          map: (value) => null,
          objectList: (value) => null,
        );
        conditionMet = actualValue == expectedValue;
        reason = conditionMet ? '$key matches "$expectedValue"' : '$key does not match "$expectedValue"';
      } else if (expectedValue is List) {
        actualValue = actualProperty?.when(
          string: (value) => value,
          integer: (value) => null,
          double: (value) => null,
          boolean: (value) => null,
          stringList: (value) => null,
          dateTime: (value) => null,
          map: (value) => null,
          objectList: (value) => null,
        );
        conditionMet = actualValue != null && expectedValue.contains(actualValue);
        reason = conditionMet ? '$key is in allowed values' : '$key is not in allowed values';
      }

      // Track condition check for new system
      conditionChecks.add(ConditionCheckResult(
        property: key,
        operator: expectedValue == 'exists' ? 'exists' : '==',
        expectedValue: expectedValue,
        actualValue: actualValue,
        passed: conditionMet,
        description: reason,
      ));

      if (!conditionMet) {
        allConditionsMet = false;
      }

      reasons.add(reason);
    }

    // For backward compatibility, return confidence as 1.0 (match) or 0.0 (no match)
    // The new system uses boolean matching + separate priority
    final confidence = allConditionsMet ? 1.0 : 0.0;

    return (allConditionsMet, confidence, reasons.join(', '));
  }

  (bool, double, String) _evaluateStateConditions(
    Map<String, dynamic> conditions,
    Asset asset,
  ) {
    final lifecycleCondition = conditions['lifecycle_state'];

    if (lifecycleCondition != null) {
      final stateMatches = asset.lifecycleState == lifecycleCondition;

      // Check other property conditions
      final otherConditions = Map<String, dynamic>.from(conditions);
      otherConditions.remove('lifecycle_state');

      final (othersMet, _, reason) = _evaluatePropertyConditions(otherConditions, asset);

      final allMet = stateMatches && othersMet;
      final stateReason = stateMatches ? 'state is ${asset.lifecycleState}' : 'state is not $lifecycleCondition';

      // Boolean matching: either all conditions met (1.0) or not (0.0)
      final confidence = allMet ? 1.0 : 0.0;

      return (allMet, confidence, '$stateReason, $reason');
    }

    return _evaluatePropertyConditions(conditions, asset);
  }

  Future<TriggerExecutionResult> _executeTrigger(TriggerEvaluation evaluation, Asset asset) async {
    try {
      final trigger = _triggers[evaluation.triggerId];
      if (trigger == null) {
        throw TriggerException('Trigger definition not found: ${evaluation.triggerId}');
      }

      // Generate deduplication key
      final deduplicationKey = _generateDeduplicationKey(evaluation, asset);

      // Check if already executed with this key
      if (asset.completedTriggers.contains(deduplicationKey)) {
        return TriggerExecutionResult(
          evaluation: evaluation,
          executed: false,
          deduplicationKey: deduplicationKey,
          reason: 'Already executed with key: $deduplicationKey',
        );
      }

      // Execute the trigger
      print('Executing trigger: ${trigger.name} for asset: ${asset.name}');
      print('Conditions: ${evaluation.conditions}');
      print('Match: ${evaluation.confidence == 1.0 ? "YES" : "NO"}');
      print('Priority: ${trigger.priority.name}');
      print('Reason: ${evaluation.reason}');

      // TODO: Integrate with actual methodology execution system
      // This would call the methodology execution engine

      // Mark as executed
      final updatedCompletedTriggers = [...asset.completedTriggers, deduplicationKey];
      // TODO: Update asset in database with new completed triggers

      // Emit trigger event
      _triggerEventController.add(TriggerEvent.executed(evaluation, trigger, asset));

      return TriggerExecutionResult(
        evaluation: evaluation,
        executed: true,
        deduplicationKey: deduplicationKey,
        reason: 'Successfully executed methodology: ${trigger.methodologyId}',
        executedAt: DateTime.now(),
      );

    } catch (e) {
      _triggerEventController.add(TriggerEvent.failed(evaluation, e.toString()));

      return TriggerExecutionResult(
        evaluation: evaluation,
        executed: false,
        reason: 'Execution failed: $e',
        error: e.toString(),
      );
    }
  }

  String _generateDeduplicationKey(TriggerEvaluation evaluation, Asset asset) {
    // Create a unique key based on asset properties and trigger conditions
    final keyComponents = [
      asset.id,
      evaluation.triggerId,
      ...evaluation.conditions.entries.map((e) => '${e.key}:${e.value}'),
    ];

    return keyComponents.join(':');
  }

  DateTime? _getLastEvaluationTime(String triggerId, String assetId) {
    final evaluations = _evaluationHistory[assetId] ?? [];
    final lastEvaluation = evaluations
        .where((e) => e.triggerId == triggerId)
        .lastOrNull;

    return lastEvaluation?.evaluatedAt;
  }

  bool _wasAlreadyExecuted(String triggerId, String assetId) {
    final evaluations = _evaluationHistory[assetId] ?? [];
    return evaluations.any((e) => e.triggerId == triggerId && e.alreadyExecuted);
  }

  String _generateEvaluationId() {
    return 'eval_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Dispose resources
  void dispose() {
    _triggerEventController.close();
  }
}

/// Trigger definition
class TriggerDefinition {
  final String id;
  final String name;
  final String description;
  final TriggerType type;
  final Map<String, dynamic> conditions;
  final String methodologyId;
  final Priority priority;
  final Duration cooldownPeriod;

  const TriggerDefinition({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.conditions,
    required this.methodologyId,
    required this.priority,
    required this.cooldownPeriod,
  });
}

/// Trigger evaluation result
class TriggerEvaluation {
  final String id;
  final String triggerId;
  final String assetId;
  final DateTime evaluatedAt;
  final bool shouldExecute;
  final bool alreadyExecuted;
  final Map<String, dynamic> conditions;
  final double confidence;
  final String reason;

  const TriggerEvaluation({
    required this.id,
    required this.triggerId,
    required this.assetId,
    required this.evaluatedAt,
    required this.shouldExecute,
    required this.alreadyExecuted,
    required this.conditions,
    required this.confidence,
    required this.reason,
  });
}

/// Trigger execution result
class TriggerExecutionResult {
  final TriggerEvaluation evaluation;
  final bool executed;
  final String? deduplicationKey;
  final String reason;
  final DateTime? executedAt;
  final String? error;

  const TriggerExecutionResult({
    required this.evaluation,
    required this.executed,
    this.deduplicationKey,
    required this.reason,
    this.executedAt,
    this.error,
  });
}

/// Trigger events
sealed class TriggerEvent {
  const TriggerEvent();

  factory TriggerEvent.executed(TriggerEvaluation evaluation, TriggerDefinition trigger, Asset asset) = TriggerExecutedEvent;
  factory TriggerEvent.failed(TriggerEvaluation evaluation, String error) = TriggerFailedEvent;
  factory TriggerEvent.evaluated(TriggerEvaluation evaluation) = TriggerEvaluatedEvent;
}

class TriggerExecutedEvent extends TriggerEvent {
  final TriggerEvaluation evaluation;
  final TriggerDefinition trigger;
  final Asset asset;

  const TriggerExecutedEvent(this.evaluation, this.trigger, this.asset);
}

class TriggerFailedEvent extends TriggerEvent {
  final TriggerEvaluation evaluation;
  final String error;

  const TriggerFailedEvent(this.evaluation, this.error);
}

class TriggerEvaluatedEvent extends TriggerEvent {
  final TriggerEvaluation evaluation;

  const TriggerEvaluatedEvent(this.evaluation);
}

/// Supporting enums
enum TriggerType {
  propertyBased,  // Based on asset property combinations
  stateBased,     // Based on asset lifecycle state
  cascade,        // Based on methodology completion
}

/// Exception for trigger operations
class TriggerException implements Exception {
  final String message;
  const TriggerException(this.message);

  @override
  String toString() => 'TriggerException: $message';
}

extension on List<TriggerEvaluation> {
  TriggerEvaluation? get lastOrNull {
    return isEmpty ? null : last;
  }
}