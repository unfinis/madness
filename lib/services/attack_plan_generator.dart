import 'dart:async';
import 'dart:math';
import '../models/attack_plan_action.dart';
import '../models/asset.dart';
import '../services/methodology_loader.dart';
import '../services/drift_storage_service.dart';

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

    // Load all methodologies from all subdirectories
    await MethodologyLoader.loadAllMethodologies();
    final allMethodologies = MethodologyLoader.getAllMethodologies();
    print('AttackPlanGenerator: Loaded ${allMethodologies.length} methodologies');

    final generatedActions = <AttackPlanAction>[];

    for (final asset in assets) {
      print('AttackPlanGenerator: Processing asset ${asset.name} (${asset.type.name}) with ${asset.properties.length} properties');

      for (final methodology in allMethodologies) {
        for (final trigger in methodology.triggers) {
          // Check if trigger conditions match asset properties
          final matches = await _doesTriggerMatch(trigger, asset, methodology);
          if (matches) {
            print('AttackPlanGenerator: MATCH! Trigger ${trigger.name} in methodology ${methodology.name} matches asset ${asset.name}');
            // Generate attack plan actions from methodology procedures
            final actions = await _generateActionsFromMethodology(
              methodology,
              trigger,
              asset,
            );
            generatedActions.addAll(actions);
            print('AttackPlanGenerator: Generated ${actions.length} actions from methodology ${methodology.name}');
          }
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

  /// Generate attack plan actions from a methodology's procedures
  Future<List<AttackPlanAction>> _generateActionsFromMethodology(
    MethodologyTemplate methodology,
    MethodologyTrigger trigger,
    Asset asset,
  ) async {
    final actions = <AttackPlanAction>[];
    final now = DateTime.now();

    // Create trigger event data
    final triggerEvent = TriggerEvent(
      triggerId: trigger.name,
      assetId: asset.id,
      assetName: asset.name,
      assetType: asset.type.name,
      matchedConditions: trigger.conditions ?? {},
      extractedValues: _extractValuesFromAsset(asset),
      evaluatedAt: now,
      confidence: 0.9, // High confidence for direct property matches
    );

    // Convert each procedure to an attack plan action
    for (int i = 0; i < methodology.procedures.length; i++) {
      final procedure = methodology.procedures[i];

      final action = AttackPlanAction(
        id: _generateActionId(),
        projectId: _projectId,
        title: '${methodology.name}: ${procedure.name}',
        objective: procedure.description,
        status: ActionStatus.pending,
        priority: _mapPriorityFromRisk(procedure.riskLevel),
        riskLevel: _mapRiskLevel(procedure.riskLevel),
        triggerEvents: [triggerEvent],
        risks: procedure.risks.map((risk) => ActionRisk(
          risk: risk.risk,
          mitigation: risk.mitigation,
          severity: _mapRiskLevel(procedure.riskLevel),
        )).toList(),
        procedure: procedure.commands.asMap().entries.map((entry) {
          final index = entry.key;
          final command = entry.value;
          return ProcedureStep(
            stepNumber: index + 1,
            description: command.description,
            command: _substituteCommandParameters(command.command, asset),
            expectedOutput: 'Command execution output',
            mandatory: true,
          );
        }).toList(),
        tools: procedure.commands.map((cmd) => ActionTool(
          name: cmd.tool,
          description: cmd.description,
          required: true,
        )).toList(),
        equipment: methodology.equipment.map((eq) => ActionEquipment(
          name: eq,
          description: eq,
          required: true,
        )).toList(),
        references: [], // TODO: Map from methodology references if available
        suggestedFindings: methodology.findings.map((finding) => SuggestedFinding(
          title: finding.title,
          description: finding.description,
          severity: _mapSeverity(finding.severity),
        )).toList(),
        cleanupSteps: methodology.cleanup.map((cleanup) =>
          '${cleanup.description}: ${cleanup.command}'
        ).toList(),
        tags: [
          'auto_generated',
          'methodology_${methodology.workstream}',
          'asset_${asset.type.name}',
          'trigger_${trigger.name}',
          ...methodology.tags,
        ],
        createdAt: now,
        templateId: methodology.id,
        metadata: {
          'methodologyId': methodology.id,
          'methodologyName': methodology.name,
          'methodologyWorkstream': methodology.workstream,
          'triggerId': trigger.name,
          'assetId': asset.id,
          'assetName': asset.name,
          'procedureIndex': i,
          'procedureId': procedure.id,
        },
      );

      actions.add(action);
    }

    return actions;
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