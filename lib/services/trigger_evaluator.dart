import '../models/asset.dart';
import '../models/methodology_trigger_builder.dart';
import '../models/methodology_execution.dart' hide AssetType;
import 'trigger_implementation_fix.dart';

/// Enhanced trigger evaluator that works with the comprehensive asset model
class TriggerEvaluator {

  /// Evaluate all assets against methodology triggers to find matches
  static List<MethodologyTriggerMatch> evaluateAssets({
    required List<Asset> assets,
    required List<MethodologyTriggerDefinition> triggers,
    String? projectId,
  }) {
    final matches = <MethodologyTriggerMatch>[];

    for (final trigger in triggers) {
      final matchingAssets = _evaluateTrigger(trigger, assets);

      if (matchingAssets.isNotEmpty) {
        matches.add(MethodologyTriggerMatch(
          trigger: trigger,
          matchingAssets: matchingAssets,
          confidence: _calculateConfidence(trigger, matchingAssets),
          priority: _calculatePriority(trigger, matchingAssets),
          context: _buildExecutionContext(trigger, matchingAssets),
        ));
      }
    }

    // Sort by priority and confidence
    matches.sort((a, b) {
      final priorityComparison = b.priority.compareTo(a.priority);
      if (priorityComparison != 0) return priorityComparison;
      return b.confidence.compareTo(a.confidence);
    });

    return matches;
  }

  /// Evaluate a specific trigger against all assets
  static List<Asset> _evaluateTrigger(
    MethodologyTriggerDefinition trigger,
    List<Asset> assets,
  ) {
    final matchingAssets = <Asset>[];

    for (final asset in assets) {
      if (_evaluateAssetAgainstTrigger(asset, trigger, assets)) {
        matchingAssets.add(asset);
      }
    }

    return matchingAssets;
  }

  /// Evaluate a single asset against a trigger definition
  static bool _evaluateAssetAgainstTrigger(
    Asset asset,
    MethodologyTriggerDefinition trigger,
    List<Asset> allAssets,
  ) {
    try {
      // Convert asset to compatible format for the existing TriggerEvaluatorFixed
      final assetMap = _convertAssetToMap(asset);
      final assetList = [assetMap];

      // Use the existing working evaluation logic from TriggerEvaluatorFixed
      final matches = TriggerEvaluatorFixed.findMatchingAssets(trigger, assetList);
      return matches.isNotEmpty;

    } catch (e) {
      print('Error evaluating asset against trigger: $e');
      return false;
    }
  }

  /// Convert Asset to Map format compatible with TriggerEvaluatorFixed
  static Map<String, dynamic> _convertAssetToMap(Asset asset) {
    final Map<String, dynamic> assetMap = {
      'id': asset.id,
      'type': asset.type.name,
      'name': asset.name,
      'identifier': asset.name,
      'description': asset.description,
      'confidence': asset.confidence,
    };

    // Convert all properties from PropertyValue to basic types
    asset.properties.forEach((key, propertyValue) {
      assetMap[key] = _convertPropertyValue(propertyValue);
    });

    // Add type-specific convenience fields for common trigger patterns
    switch (asset.type) {
      case AssetType.host:
        assetMap['host'] = asset.name;
        break;
      case AssetType.service:
        // Properties should contain service-specific data like port, protocol, etc.
        break;
      case AssetType.credential:
        // Properties should contain username, domain, type, etc.
        break;
      case AssetType.networkSegment:
        assetMap['subnet'] = asset.name;
        break;
      case AssetType.activeDirectoryDomain:
        assetMap['domain'] = asset.name;
        break;
      default:
        // Other types use basic properties
        break;
    }

    return assetMap;
  }

  /// Convert PropertyValue to simple dynamic value
  static dynamic _convertPropertyValue(PropertyValue value) {
    return value.when(
      string: (str) => str,
      integer: (intValue) => intValue,
      boolean: (boolValue) => boolValue,
      stringList: (list) => list,
      map: (map) => map,
      objectList: (objects) => objects,
    );
  }

  /// Calculate confidence score for a trigger match
  static double _calculateConfidence(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    // Base confidence based on number of matching assets
    double confidence = 0.5;

    // Increase confidence for high-value assets
    for (final asset in matchingAssets) {
      if (asset.type == AssetType.activeDirectoryDomain ||
          asset.type == AssetType.domainController ||
          asset.type == AssetType.azureTenant) {
        confidence += 0.1;
      }
    }

    // Increase confidence based on asset confidence scores
    if (matchingAssets.isNotEmpty) {
      final avgAssetConfidence = matchingAssets.fold<double>(
        0.0, (sum, asset) => sum + (asset.confidence ?? 0.5)) / matchingAssets.length;
      confidence *= avgAssetConfidence;
    }

    // Cap confidence at 1.0
    return confidence.clamp(0.0, 1.0);
  }

  /// Calculate priority for methodology execution
  static int _calculatePriority(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    int priority = 50; // Base priority

    // Check for compromised status in asset properties
    final compromisedCount = matchingAssets.where((asset) {
      final statusProp = asset.properties['status'] ?? asset.properties['compromised'];
      return statusProp != null && _convertPropertyValue(statusProp) == true;
    }).length;
    priority += compromisedCount * 20;

    // Increase priority for high-value assets (based on type)
    for (final asset in matchingAssets) {
      switch (asset.type) {
        case AssetType.host:
          priority += 10;
          break;
        case AssetType.activeDirectoryDomain:
          priority += 15;
          break;
        case AssetType.domainController:
          priority += 15;
          break;
        case AssetType.azureTenant:
          priority += 12;
          break;
        case AssetType.credential:
          priority += 8;
          break;
        default:
          priority += 5;
          break;
      }
    }

    // Check for access level in asset properties
    for (final asset in matchingAssets) {
      final accessLevelProp = asset.properties['access_level'] ?? asset.properties['accessLevel'];
      if (accessLevelProp != null) {
        final accessLevel = _convertPropertyValue(accessLevelProp)?.toString().toLowerCase();
        switch (accessLevel) {
          case 'full':
            priority += 20;
            break;
          case 'partial':
            priority += 15;
            break;
          case 'limited':
            priority += 10;
            break;
          case 'blocked':
            priority += 5;
            break;
          default:
            priority += 1;
            break;
        }
      }
    }

    // Cap priority at 100
    return priority.clamp(0, 100);
  }

  /// Build execution context from trigger and matching assets
  static Map<String, dynamic> _buildExecutionContext(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    final context = <String, dynamic>{};

    // Add asset information
    context['asset_ids'] = matchingAssets.map((a) => a.id).toList();
    context['asset_names'] = matchingAssets.map((a) => a.name).toList();
    context['asset_types'] = matchingAssets.map((a) => a.type.name).toList();

    // Add first asset's properties as primary context
    if (matchingAssets.isNotEmpty) {
      final primaryAsset = matchingAssets.first;
      context['primary_asset_id'] = primaryAsset.id;
      context['primary_asset_name'] = primaryAsset.name;
      context['primary_asset_type'] = primaryAsset.type.name;

      // Add properties based on type
      if (primaryAsset.properties.isNotEmpty) {
        context.addAll(primaryAsset.properties.map(
          (key, value) => MapEntry('asset_$key', value)
        ));
      }
    }

    // Add trigger information
    context['trigger_id'] = trigger.id;
    context['trigger_name'] = trigger.name;
    context['trigger_priority'] = trigger.priority;

    return context;
  }

  /// Legacy compatibility method for finding matching assets
  static List<Map<String, dynamic>> findMatchingAssets(
    dynamic trigger,
    List<Map<String, dynamic>> assets,
  ) {
    // Use the fixed implementation from trigger_implementation_fix.dart
    return TriggerEvaluatorFixed.findMatchingAssets(trigger, assets);
  }
}

/// Result of evaluating triggers against assets
class MethodologyTriggerMatch {
  final MethodologyTriggerDefinition trigger;
  final List<Asset> matchingAssets;
  final double confidence;
  final int priority;
  final Map<String, dynamic> context;

  MethodologyTriggerMatch({
    required this.trigger,
    required this.matchingAssets,
    required this.confidence,
    required this.priority,
    required this.context,
  });

  /// Generate a methodology execution from this match
  MethodologyExecution toExecution(String projectId) {
    return MethodologyExecution(
      id: 'exec_${trigger.id}_${DateTime.now().millisecondsSinceEpoch}',
      projectId: projectId,
      methodologyId: trigger.id,
      status: ExecutionStatus.pending,
      progress: 0.0,
      startedDate: DateTime.now(),
      stepExecutions: [],
      executionContext: context,
    );
  }
}