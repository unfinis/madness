import 'dart:async';
import 'dart:math';
import '../models/attack_plan_action.dart';
import '../models/asset.dart';
import '../services/methodology_loader.dart';
import '../services/drift_storage_service.dart';
import '../services/memory_attack_plan_storage.dart';

/// Service for generating attack plan actions from methodology triggers and asset properties
class AttackPlanGenerator {
  final DriftStorageService _storage;
  final String _projectId;

  AttackPlanGenerator({
    required DriftStorageService storage,
    required String projectId,
  }) : _storage = storage, _projectId = projectId;

  /// Generate attack plan actions based on current assets and their properties
  Future<List<AttackPlanAction>> generateActionsFromAssets(List<Asset> assets) async {
    print('AttackPlanGenerator: Starting generation with ${assets.length} assets');

    // Clear any previously stored actions to avoid type conflicts
    try {
      // Clear storage for this project to avoid casting issues with old data
      print('AttackPlanGenerator: Clearing existing actions for project $_projectId');
      MemoryAttackPlanStorage.clearActions(_projectId);
    } catch (e) {
      print('AttackPlanGenerator: Warning - could not clear existing actions: $e');
    }

    // Load all methodologies from all subdirectories
    await MethodologyLoader.loadAllMethodologies();
    final allMethodologies = MethodologyLoader.getAllMethodologies();
    print('AttackPlanGenerator: Loaded ${allMethodologies.length} methodologies');

    // Track trigger events by methodology and procedure, plus asset mapping
    final Map<String, Map<int, List<TriggerEvent>>> triggerEventsByMethodology = {};
    final Map<String, Asset> assetMap = {for (final asset in assets) asset.id: asset};

    for (final asset in assets) {
      print('AttackPlanGenerator: Processing asset ${asset.name} (${asset.type.name}) with ${asset.properties.length} properties');

      for (final methodology in allMethodologies) {
        for (final trigger in methodology.triggers) {
          // Check if trigger conditions match asset properties
          final matches = await _doesTriggerMatch(trigger, asset, methodology);
          if (matches) {
            print('AttackPlanGenerator: MATCH! Trigger ${trigger.name} in methodology ${methodology.name} matches asset ${asset.name}');

            // Create trigger event data
            final triggerEvent = TriggerEvent(
              triggerId: trigger.name,
              assetId: asset.id,
              assetName: asset.name,
              assetType: asset.type.name,
              matchedConditions: trigger.conditions ?? {},
              extractedValues: _extractValuesFromAsset(asset),
              evaluatedAt: DateTime.now(),
              confidence: 0.9, // High confidence for direct property matches
            );

            // Group trigger events by methodology and procedure
            final methodologyKey = methodology.id;
            triggerEventsByMethodology[methodologyKey] ??= {};

            // Each procedure gets the same trigger events for this methodology
            for (int i = 0; i < methodology.procedures.length; i++) {
              triggerEventsByMethodology[methodologyKey]![i] ??= [];
              triggerEventsByMethodology[methodologyKey]![i]!.add(triggerEvent);
            }
          }
        }
      }
    }

    // Generate consolidated actions from collected trigger events
    final generatedActions = <AttackPlanAction>[];

    for (final methodologyEntry in triggerEventsByMethodology.entries) {
      final methodologyId = methodologyEntry.key;
      final procedureTriggers = methodologyEntry.value;

      // Find the methodology
      final methodology = allMethodologies.firstWhere((m) => m.id == methodologyId);

      for (final procedureEntry in procedureTriggers.entries) {
        final procedureIndex = procedureEntry.key;
        final triggerEvents = procedureEntry.value;

        // Generate consolidated action for this procedure with all trigger events
        try {
          print('AttackPlanGenerator: Generating action for ${methodology.name}:${methodology.procedures[procedureIndex].name}');
          final action = await _generateConsolidatedAction(
            methodology,
            methodology.procedures[procedureIndex],
            procedureIndex,
            triggerEvents,
            assetMap,
          );

          generatedActions.add(action);
          print('AttackPlanGenerator: Generated consolidated action for ${methodology.name}:${methodology.procedures[procedureIndex].name} with ${triggerEvents.length} trigger events');
        } catch (e, stackTrace) {
          print('AttackPlanGenerator: ERROR generating action for ${methodology.name}:${methodology.procedures[procedureIndex].name}: $e');
          print('AttackPlanGenerator: Stack trace: $stackTrace');
        }
      }
    }

    // Store generated actions in storage
    for (final action in generatedActions) {
      await _storage.storeAttackPlanAction(action, _projectId);
    }

    return generatedActions;
  }

  /// Check if a trigger matches an asset's current properties
  Future<bool> _doesTriggerMatch(
    MethodologyTrigger trigger,
    Asset asset,
    MethodologyTemplate methodology,
  ) async {
    print('AttackPlanGenerator: Checking trigger ${trigger.name} against asset ${asset.name} (${asset.type.name})');

    // Check asset type compatibility first
    if (trigger.conditions == null) {
      print('AttackPlanGenerator: Trigger ${trigger.name} has no conditions');
      return false;
    }

    final conditions = trigger.conditions!;
    print('AttackPlanGenerator: Trigger conditions: $conditions');

    // Handle asset_type condition
    if (conditions.containsKey('asset_type')) {
      final requiredType = conditions['asset_type'] as String;
      print('AttackPlanGenerator: Required asset type: $requiredType, actual: ${asset.type.name}');
      if (asset.type.name != requiredType) {
        print('AttackPlanGenerator: Asset type mismatch');
        return false;
      }
    }

    // Handle properties conditions
    if (conditions.containsKey('properties')) {
      final propertyConditions = conditions['properties'] as Map<String, dynamic>;
      print('AttackPlanGenerator: Checking property conditions: $propertyConditions');
      print('AttackPlanGenerator: Asset properties: ${asset.properties.keys.toList()}');

      for (final entry in propertyConditions.entries) {
        final propertyName = entry.key;
        final expectedValue = entry.value;
        print('AttackPlanGenerator: Checking property $propertyName, expected: "$expectedValue"');

        final assetProperty = asset.properties[propertyName];
        print('AttackPlanGenerator: Asset property value: $assetProperty');

        // Special case: Check for empty string (Unknown state)
        if (expectedValue == '') {
          // Match if property is empty/unknown
          final isEmpty = assetProperty?.when(
            string: (v) => v.isEmpty,
            integer: (v) => false,
            boolean: (v) => false,
            stringList: (v) => v.isEmpty,
            map: (v) => v.isEmpty,
            objectList: (v) => v.isEmpty,
          ) ?? true;

          print('AttackPlanGenerator: Property $propertyName isEmpty: $isEmpty (null property = true)');
          if (!isEmpty) {
            print('AttackPlanGenerator: Property $propertyName is not empty, trigger fails');
            return false;
          }
        } else {
          // Standard equality check
          final matches = assetProperty?.when(
            string: (v) => v == expectedValue,
            integer: (v) => v == expectedValue,
            boolean: (v) => v == expectedValue,
            stringList: (v) => v.contains(expectedValue),
            map: (v) => v[expectedValue] != null,
            objectList: (v) => v.any((obj) => obj.containsValue(expectedValue)),
          ) ?? false;

          print('AttackPlanGenerator: Property $propertyName matches: $matches');
          if (!matches) {
            print('AttackPlanGenerator: Property $propertyName does not match, trigger fails');
            return false;
          }
        }
      }
    }

    print('AttackPlanGenerator: Trigger ${trigger.name} MATCHES asset ${asset.name}!');
    return true;
  }

  /// Generate consolidated action for a procedure with multiple trigger events
  Future<AttackPlanAction> _generateConsolidatedAction(
    MethodologyTemplate methodology,
    dynamic procedure,
    int procedureIndex,
    List<TriggerEvent> triggerEvents,
    Map<String, Asset> assetMap,
  ) async {
    final now = DateTime.now();

    // Use the first trigger event's asset for command substitution
    final firstTriggerEvent = triggerEvents.first;
    final firstAsset = assetMap[firstTriggerEvent.assetId]!;

    // Consolidate tags from all trigger events
    final allTags = <String>{'auto_generated', 'methodology_${methodology.workstream}'};
    for (final trigger in triggerEvents) {
      allTags.add('asset_${trigger.assetType}');
      allTags.add('trigger_${trigger.triggerId}');
    }
    allTags.addAll(methodology.tags);

    // Create title with trigger count if multiple
    final titleSuffix = triggerEvents.length > 1 ? ' (${triggerEvents.length} triggers)' : '';

    print('AttackPlanGenerator: Creating ActionRisk objects from ${procedure.risks.length} methodology risks');
    final actionRisks = _createActionRisks(procedure.risks, procedure.riskLevel);
    print('AttackPlanGenerator: Created ${actionRisks.length} ActionRisk objects');

    print('AttackPlanGenerator: Creating AttackPlanAction object');
    final action = AttackPlanAction(
      id: _generateActionId(),
      projectId: _projectId,
      title: '${methodology.name}: ${procedure.name}$titleSuffix',
      objective: procedure.description,
      status: ActionStatus.pending,
      priority: _mapPriorityFromRisk(procedure.riskLevel),
      riskLevel: _mapRiskLevel(procedure.riskLevel),
      triggerEvents: triggerEvents, // All trigger events consolidated here
      risks: actionRisks,
      procedure: _createProcedureSteps(procedure.commands, firstAsset),
      tools: _createActionTools(procedure.commands),
      equipment: _createActionEquipment(methodology.equipment),
      references: [], // TODO: Map from methodology references if available
      suggestedFindings: _createSuggestedFindings(methodology.findings),
      cleanupSteps: methodology.cleanup.map((cleanup) =>
        '${cleanup.description}: ${cleanup.command}'
      ).toList(),
      tags: allTags.toList(),
      createdAt: now,
      templateId: methodology.id,
      metadata: {
        'methodologyId': methodology.id,
        'methodologyName': methodology.name,
        'methodologyWorkstream': methodology.workstream,
        'procedureIndex': procedureIndex,
        'procedureId': procedure.id,
        'triggerCount': triggerEvents.length,
        'consolidatedTriggers': triggerEvents.map((t) => t.triggerId).toList(),
        'affectedAssets': triggerEvents.map((t) => '${t.assetName} (${t.assetId})').toList(),
      },
    );

    return action;
  }

  /// Extract values from asset properties for trigger event
  Map<String, dynamic> _extractValuesFromAsset(Asset asset) {
    final extracted = <String, dynamic>{};

    for (final entry in asset.properties.entries) {
      final key = entry.key;
      final value = entry.value;

      extracted[key] = value.when(
        string: (v) => v,
        integer: (v) => v,
        boolean: (v) => v,
        stringList: (v) => v,
        map: (v) => v,
        objectList: (v) => v,
      );
    }

    return extracted;
  }

  /// Substitute command parameters with actual asset values
  String _substituteCommandParameters(String command, Asset asset) {
    var substituted = command;

    // Replace asset-specific placeholders
    substituted = substituted.replaceAll('{asset_id}', asset.id);
    substituted = substituted.replaceAll('{asset_name}', asset.name);
    substituted = substituted.replaceAll('{asset_type}', asset.type.name);

    // Replace property-specific placeholders
    for (final entry in asset.properties.entries) {
      final key = entry.key;
      final value = entry.value;

      final stringValue = value.when(
        string: (v) => v,
        integer: (v) => v.toString(),
        boolean: (v) => v.toString(),
        stringList: (v) => v.join(','),
        map: (v) => v.toString(),
        objectList: (v) => v.toString(),
      );

      substituted = substituted.replaceAll('{$key}', stringValue);
    }

    return substituted;
  }

  /// Map risk level string to ActionRiskLevel enum
  ActionRiskLevel _mapRiskLevel(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'critical':
        return ActionRiskLevel.critical;
      case 'high':
        return ActionRiskLevel.high;
      case 'medium':
        return ActionRiskLevel.medium;
      case 'low':
        return ActionRiskLevel.low;
      case 'minimal':
        return ActionRiskLevel.minimal;
      default:
        return ActionRiskLevel.medium;
    }
  }

  /// Map priority from risk level
  ActionPriority _mapPriorityFromRisk(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'critical':
        return ActionPriority.critical;
      case 'high':
        return ActionPriority.high;
      case 'medium':
        return ActionPriority.medium;
      case 'low':
        return ActionPriority.low;
      default:
        return ActionPriority.medium;
    }
  }

  /// Map severity string to ActionRiskLevel
  ActionRiskLevel _mapSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return ActionRiskLevel.critical;
      case 'high':
        return ActionRiskLevel.high;
      case 'medium':
        return ActionRiskLevel.medium;
      case 'low':
        return ActionRiskLevel.low;
      case 'informational':
        return ActionRiskLevel.minimal;
      default:
        return ActionRiskLevel.medium;
    }
  }

  /// Create ActionRisk objects safely from MethodologyRisk objects
  List<ActionRisk> _createActionRisks(List<MethodologyRisk> methodologyRisks, String procedureRiskLevel) {
    try {
      print('AttackPlanGenerator: Converting ${methodologyRisks.length} MethodologyRisk objects to ActionRisk');
      return methodologyRisks.map((risk) => ActionRisk(
        risk: risk.risk,
        mitigation: risk.mitigation,
        severity: _mapRiskLevel(procedureRiskLevel),
      )).toList();
    } catch (e) {
      print('AttackPlanGenerator: Error creating ActionRisk list: $e');
      return [ActionRisk(
        risk: 'Error parsing risks from methodology',
        mitigation: 'Review methodology configuration',
        severity: _mapRiskLevel(procedureRiskLevel),
      )];
    }
  }

  /// Create ProcedureStep objects safely
  List<ProcedureStep> _createProcedureSteps(List<dynamic> commands, Asset firstAsset) {
    try {
      print('AttackPlanGenerator: Creating ProcedureStep objects from ${commands.length} commands');
      return commands.asMap().entries.map((entry) {
        final index = entry.key;
        final command = entry.value;
        return ProcedureStep(
          stepNumber: index + 1,
          description: (command as dynamic).description?.toString() ?? 'Command step',
          command: _substituteCommandParameters((command as dynamic).command?.toString() ?? '', firstAsset),
          expectedOutput: 'Command execution output',
          mandatory: true,
        );
      }).toList();
    } catch (e) {
      print('AttackPlanGenerator: Error creating ProcedureStep list: $e');
      return [];
    }
  }

  /// Create ActionTool objects safely
  List<ActionTool> _createActionTools(List<dynamic> commands) {
    try {
      print('AttackPlanGenerator: Creating ActionTool objects from ${commands.length} commands');
      return commands.map((cmd) => ActionTool(
        name: (cmd as dynamic).tool?.toString() ?? 'Unknown tool',
        description: (cmd as dynamic).description?.toString() ?? 'Tool description',
        required: true,
      )).toList();
    } catch (e) {
      print('AttackPlanGenerator: Error creating ActionTool list: $e');
      return [];
    }
  }

  /// Create ActionEquipment objects safely
  List<ActionEquipment> _createActionEquipment(List<dynamic> equipment) {
    try {
      print('AttackPlanGenerator: Creating ActionEquipment objects from ${equipment.length} equipment items');
      return equipment.map((eq) => ActionEquipment(
        name: eq?.toString() ?? 'Unknown equipment',
        description: eq?.toString() ?? 'Equipment description',
        required: true,
      )).toList();
    } catch (e) {
      print('AttackPlanGenerator: Error creating ActionEquipment list: $e');
      return [];
    }
  }

  /// Create SuggestedFinding objects safely
  List<SuggestedFinding> _createSuggestedFindings(List<dynamic> findings) {
    try {
      print('AttackPlanGenerator: Creating SuggestedFinding objects from ${findings.length} findings');
      return findings.map((finding) => SuggestedFinding(
        title: (finding as dynamic).title?.toString() ?? 'Finding',
        description: (finding as dynamic).description?.toString() ?? 'Finding description',
        severity: _mapSeverity((finding as dynamic).severity?.toString() ?? 'medium'),
      )).toList();
    } catch (e) {
      print('AttackPlanGenerator: Error creating SuggestedFinding list: $e');
      return [];
    }
  }

  /// Generate unique action ID
  String _generateActionId() {
    return 'action_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(10000)}';
  }

  /// Get all generated actions for the project
  Future<List<AttackPlanAction>> getAllActions() async {
    return await _storage.getAllAttackPlanActions(_projectId);
  }

  /// Get actions by status
  Future<List<AttackPlanAction>> getActionsByStatus(ActionStatus status) async {
    final allActions = await getAllActions();
    return allActions.where((action) => action.status == status).toList();
  }

  /// Update action status
  Future<void> updateActionStatus(String actionId, ActionStatus newStatus) async {
    await _storage.updateAttackPlanActionStatus(actionId, newStatus);
  }

  /// Get statistics about generated actions
  Future<Map<String, dynamic>> getActionStats() async {
    final allActions = await getAllActions();

    final statusCounts = <ActionStatus, int>{};
    final priorityCounts = <ActionPriority, int>{};
    final riskCounts = <ActionRiskLevel, int>{};

    for (final action in allActions) {
      statusCounts[action.status] = (statusCounts[action.status] ?? 0) + 1;
      priorityCounts[action.priority] = (priorityCounts[action.priority] ?? 0) + 1;
      riskCounts[action.riskLevel] = (riskCounts[action.riskLevel] ?? 0) + 1;
    }

    return {
      'total': allActions.length,
      'byStatus': statusCounts.map((k, v) => MapEntry(k.name, v)),
      'byPriority': priorityCounts.map((k, v) => MapEntry(k.name, v)),
      'byRisk': riskCounts.map((k, v) => MapEntry(k.name, v)),
      'lastGenerated': allActions.isNotEmpty
        ? allActions.map((a) => a.createdAt).reduce((a, b) => a.isAfter(b) ? a : b).toIso8601String()
        : null,
    };
  }
}