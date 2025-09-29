import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import '../models/methodology_trigger.dart';
import '../models/asset.dart';

/// Service for loading methodology triggers from YAML files
class YamlTriggerLoader {
  static const String _methodologyAssetsPath = 'assets/methodologies';

  /// Load all triggers from YAML files in the methodologies directory
  Future<List<MethodologyTrigger>> loadTriggersFromYaml() async {
    final List<MethodologyTrigger> allTriggers = [];

    try {
      // Get the index file to find all methodology files
      final indexYaml = await _loadYamlFromAssets('$_methodologyAssetsPath/_index.yaml');
      if (indexYaml != null) {
        final index = indexYaml as Map;
        final methodologies = index['methodologies'] as List?;

        if (methodologies != null) {
          for (final methodologyPath in methodologies) {
            final filePath = '$_methodologyAssetsPath/$methodologyPath';
            final triggers = await _loadTriggersFromFile(filePath);
            allTriggers.addAll(triggers);
          }
        }
      }

      // Also scan for all .yaml files if index doesn't exist or is incomplete
      await _scanDirectoryForYamlFiles(allTriggers);

      print('Loaded ${allTriggers.length} triggers from YAML files');
      return allTriggers;

    } catch (e, stackTrace) {
      print('Error loading triggers from YAML: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  /// Load YAML content from Flutter assets
  Future<dynamic> _loadYamlFromAssets(String assetPath) async {
    try {
      final yamlString = await rootBundle.loadString(assetPath);
      return loadYaml(yamlString);
    } catch (e) {
      print('Could not load asset: $assetPath ($e)');
      return null;
    }
  }

  /// Scan directory for YAML files (fallback method)
  Future<void> _scanDirectoryForYamlFiles(List<MethodologyTrigger> allTriggers) async {
    final commonPaths = [
      'reconnaissance/nmap_discovery.yaml',
      'exploitation/smb_relay.yaml',
      'internal_network.yaml',
      'web_application.yaml',
      'active_directory.yaml',
      'database.yaml',
      'wireless.yaml',
    ];

    for (final relativePath in commonPaths) {
      final filePath = '$_methodologyAssetsPath/$relativePath';
      try {
        final triggers = await _loadTriggersFromFile(filePath);
        // Avoid duplicates
        for (final trigger in triggers) {
          if (!allTriggers.any((existing) => existing.id == trigger.id)) {
            allTriggers.add(trigger);
          }
        }
      } catch (e) {
        // File doesn't exist or couldn't be loaded, skip it
      }
    }
  }

  /// Load triggers from a specific YAML file
  Future<List<MethodologyTrigger>> _loadTriggersFromFile(String filePath) async {
    try {
      final yamlContent = await _loadYamlFromAssets(filePath);
      if (yamlContent == null) {
        return [];
      }

      final methodology = yamlContent as Map;
      return _parseTriggersFromMethodology(methodology);

    } catch (e) {
      print('Error loading triggers from $filePath: $e');
      return [];
    }
  }

  /// Parse triggers from a methodology YAML structure
  List<MethodologyTrigger> _parseTriggersFromMethodology(Map methodology) {
    final List<MethodologyTrigger> triggers = [];

    final methodologyId = methodology['id'] as String? ?? 'unknown';
    final methodologyName = methodology['name'] as String? ?? 'Unknown';
    final triggersList = methodology['triggers'] as List?;

    if (triggersList == null) {
      return triggers;
    }

    for (int i = 0; i < triggersList.length; i++) {
      try {
        final triggerData = triggersList[i] as Map;
        final trigger = _parseSingleTrigger(
          triggerData,
          methodologyId,
          methodologyName,
          i,
        );
        if (trigger != null) {
          triggers.add(trigger);
        }
      } catch (e) {
        print('Error parsing trigger $i from $methodologyId: $e');
      }
    }

    return triggers;
  }

  /// Parse a single trigger definition
  MethodologyTrigger? _parseSingleTrigger(
    Map triggerData,
    String methodologyId,
    String methodologyName,
    int index,
  ) {
    try {
      final triggerName = triggerData['name'] as String? ?? 'Unnamed Trigger';
      final conditions = triggerData['conditions'] as Map?;

      // Parse asset type from conditions
      AssetType assetType = AssetType.networkSegment;
      dynamic triggerConditions;

      if (conditions != null) {
        final assetTypeString = conditions['asset_type'] as String?;
        assetType = _parseAssetType(assetTypeString ?? 'network');

        // Parse the conditions structure
        triggerConditions = _parseConditions(conditions);
      }

      // Generate unique trigger ID
      final triggerId = '${methodologyId}_trigger_$index';

      return MethodologyTrigger(
        id: triggerId,
        methodologyId: methodologyId,
        name: triggerName,
        description: triggerData['description'] as String?,
        assetType: assetType,
        conditions: triggerConditions,
        priority: triggerData['priority'] as int? ?? 100,
        batchCapable: triggerData['batch_capable'] as bool? ?? false,
        batchCriteria: triggerData['batch_criteria'] as String?,
        batchCommand: triggerData['batch_command'] as String?,
        maxBatchSize: triggerData['max_batch_size'] as int?,
        deduplicationKeyTemplate: _generateDeduplicationTemplate(triggerId, assetType),
        cooldownPeriod: _parseDuration(triggerData['cooldown_period']),
        individualCommand: triggerData['individual_command'] as String?,
        commandVariants: _parseCommandVariants(triggerData['command_variants']),
        expectedPropertyUpdates: _parseStringList(triggerData['expected_property_updates']),
        expectedAssetDiscovery: _parseAssetTypeList(triggerData['expected_asset_discovery']),
        tags: _parseStringList(triggerData['tags']) ?? ['auto-generated'],
        enabled: triggerData['enabled'] as bool? ?? true,
      );

    } catch (e) {
      print('Error parsing trigger: $e');
      return null;
    }
  }

  /// Parse conditions from YAML structure
  dynamic _parseConditions(Map conditions) {
    // Handle simple property-based conditions
    final properties = conditions['properties'] as Map?;
    if (properties != null) {
      // Convert to TriggerConditionGroup with AND operator
      final List<TriggerCondition> conditionList = [];

      for (final entry in properties.entries) {
        final property = entry.key as String;
        final value = entry.value;

        // Determine operator based on value type and content
        TriggerOperator operator = TriggerOperator.equals;
        dynamic conditionValue = value;

        if (value is bool) {
          operator = value ? TriggerOperator.equals : TriggerOperator.notEquals;
          conditionValue = true;
        } else if (value is String) {
          if (value.contains('*') || value.contains('?')) {
            operator = TriggerOperator.matches;
            conditionValue = value.replaceAll('*', '.*').replaceAll('?', '.');
          }
        }

        conditionList.add(TriggerCondition(
          property: property,
          operator: operator,
          value: conditionValue,
          description: 'Auto-generated from YAML',
        ));
      }

      if (conditionList.isNotEmpty) {
        return TriggerConditionGroup(
          operator: LogicalOperator.and,
          conditions: conditionList,
        );
      }
    }

    // For now, return the raw conditions for backwards compatibility
    return conditions;
  }

  /// Parse asset type from string
  AssetType _parseAssetType(String assetTypeString) {
    switch (assetTypeString.toLowerCase()) {
      case 'network':
      case 'network_segment':
        return AssetType.networkSegment;
      case 'host':
      case 'server':
        return AssetType.host;
      case 'service':
        return AssetType.service;
      case 'credential':
      case 'cred':
        return AssetType.credential;
      case 'vulnerability':
      case 'vuln':
        return AssetType.vulnerability;
      case 'domain':
        return AssetType.domain;
      case 'wireless':
      case 'wifi':
        return AssetType.wireless_network;
      case 'ad':
      case 'active_directory':
        return AssetType.activeDirectoryDomain;
      case 'dc':
      case 'domain_controller':
        return AssetType.domainController;
      default:
        return AssetType.networkSegment;
    }
  }

  /// Generate deduplication template
  String _generateDeduplicationTemplate(String triggerId, AssetType assetType) {
    return '{trigger.id}:{asset.id}:{asset.type}';
  }

  /// Parse duration from various formats
  Duration? _parseDuration(dynamic value) {
    if (value == null) return null;

    if (value is int) {
      return Duration(seconds: value);
    }

    if (value is String) {
      // Parse formats like "5m", "1h", "30s"
      final regex = RegExp(r'^(\d+)([smhd])$');
      final match = regex.firstMatch(value.toLowerCase());
      if (match != null) {
        final amount = int.parse(match.group(1)!);
        final unit = match.group(2)!;

        switch (unit) {
          case 's':
            return Duration(seconds: amount);
          case 'm':
            return Duration(minutes: amount);
          case 'h':
            return Duration(hours: amount);
          case 'd':
            return Duration(days: amount);
        }
      }
    }

    return null;
  }

  /// Parse command variants
  Map<String, String>? _parseCommandVariants(dynamic value) {
    if (value is Map) {
      return Map<String, String>.from(value);
    }
    return null;
  }

  /// Parse string list
  List<String>? _parseStringList(dynamic value) {
    if (value is List) {
      return value.cast<String>();
    }
    return null;
  }

  /// Parse asset type list
  List<AssetType>? _parseAssetTypeList(dynamic value) {
    if (value is List) {
      return value.map((item) => _parseAssetType(item.toString())).toList();
    }
    return null;
  }
}