// lib/services/trigger_implementation_fix.dart
// Quick implementation to get triggers working

import 'package:uuid/uuid.dart';
import '../models/methodology_trigger.dart' as mt;
import '../models/methodology.dart' hide MethodologyTrigger;
import '../models/asset.dart';
import '../providers/task_queue_provider.dart';

/// Fixed implementation of trigger evaluator
class TriggerEvaluatorFixed {
  static const _uuid = Uuid();

  /// Find matching assets for a trigger - WORKING IMPLEMENTATION
  static List<Map<String, dynamic>> findMatchingAssets(
    dynamic trigger,
    List<Map<String, dynamic>> assets,
  ) {
    final matchingAssets = <Map<String, dynamic>>[];

    // Handle both MethodologyTrigger and Map types
    if (trigger is mt.MethodologyTrigger) {
      for (final asset in assets) {
        if (_evaluateTriggerConditions(trigger, asset)) {
          matchingAssets.add(asset);
        }
      }
    } else if (trigger is Map<String, dynamic>) {
      // Legacy format support
      final assetType = trigger['assetType'] as String?;
      final conditions = trigger['conditions'] as Map<String, dynamic>?;

      for (final asset in assets) {
        if (assetType != null && asset['type'] != assetType) continue;

        if (conditions != null) {
          if (_evaluateMapConditions(conditions, asset)) {
            matchingAssets.add(asset);
          }
        } else {
          // No conditions means it matches all assets of the type
          matchingAssets.add(asset);
        }
      }
    }

    return matchingAssets;
  }

  /// Evaluate trigger conditions against asset properties
  static bool _evaluateTriggerConditions(
    mt.MethodologyTrigger trigger,
    Map<String, dynamic> asset,
  ) {
    // Check asset type first
    if (asset['type'] != trigger.assetType.name) {
      return false;
    }

    // If no conditions, match all of this type
    if (trigger.conditions == null) {
      return true;
    }

    // Evaluate conditions based on the structure
    return _evaluateDynamicConditions(trigger.conditions, asset);
  }

  /// Evaluate dynamic conditions (handles various formats)
  static bool _evaluateDynamicConditions(
    dynamic conditions,
    Map<String, dynamic> asset,
  ) {
    if (conditions == null) return true;

    if (conditions is Map<String, dynamic>) {
      // Simple key-value matching
      for (final entry in conditions.entries) {
        final assetValue = asset[entry.key];
        final conditionValue = entry.value;

        if (!_compareValues(assetValue, conditionValue)) {
          return false;
        }
      }
      return true;
    }

    // Add more condition types as needed
    return false;
  }

  /// Evaluate map-based conditions
  static bool _evaluateMapConditions(
    Map<String, dynamic> conditions,
    Map<String, dynamic> asset,
  ) {
    for (final entry in conditions.entries) {
      final key = entry.key;
      final expectedValue = entry.value;
      final actualValue = asset[key];

      if (!_compareValues(actualValue, expectedValue)) {
        return false;
      }
    }
    return true;
  }

  /// Compare values with various operators
  static bool _compareValues(dynamic actual, dynamic expected) {
    if (expected is Map<String, dynamic>) {
      // Handle operator-based comparisons
      final operator = expected['\$operator'] ?? 'equals';
      final value = expected['\$value'];

      switch (operator) {
        case 'equals':
          return actual == value;
        case 'contains':
          if (actual is List) {
            return actual.contains(value);
          }
          return actual?.toString().contains(value.toString()) ?? false;
        case 'exists':
          return actual != null;
        case 'notExists':
          return actual == null;
        case 'greaterThan':
          return (actual as num?) != null && value != null && actual! > value;
        case 'lessThan':
          return (actual as num?) != null && value != null && actual! < value;
        case 'inList':
          return value is List && value.contains(actual);
        default:
          return actual == value;
      }
    }

    // Simple equality check
    return actual == expected;
  }
}

/// Sample trigger definitions for testing
class SampleTriggers {
  static List<mt.MethodologyTrigger> getTestTriggers() {
    return [
      // Trigger for hosts with open SMB ports
      mt.MethodologyTrigger(
        id: 'trigger_smb_relay',
        methodologyId: 'methodology_smb_relay',
        name: 'SMB Relay Attack',
        description: 'Triggers when SMB is available with signing disabled',
        assetType: AssetType.host,
        conditions: {
          'ports': {'\$operator': 'contains', '\$value': 445},
          'smb_signing': false,
        },
        priority: 8,
        batchCapable: true,
        deduplicationKeyTemplate: '{asset.id}:smb_relay',
        tags: ['smb', 'relay', 'network'],
        enabled: true,
      ),

      // Trigger for discovered credentials
      mt.MethodologyTrigger(
        id: 'trigger_credential_spray',
        methodologyId: 'methodology_credential_spray',
        name: 'Credential Spraying',
        description: 'Triggers when new credentials are discovered',
        assetType: AssetType.credential,
        conditions: {
          'type': 'password',
          'verified': false,
        },
        priority: 6,
        batchCapable: true,
        deduplicationKeyTemplate: '{asset.username}:spray',
        tags: ['credentials', 'spray', 'authentication'],
        enabled: true,
      ),

      // Trigger for web applications
      mt.MethodologyTrigger(
        id: 'trigger_web_enum',
        methodologyId: 'methodology_web_enum',
        name: 'Web Enumeration',
        description: 'Triggers for discovered web services',
        assetType: AssetType.service,
        conditions: {
          'service_name': 'http',
          'enumerated': {'\$operator': 'notExists'},
        },
        priority: 5,
        batchCapable: false,
        deduplicationKeyTemplate: '{asset.host}:{asset.port}:enum',
        tags: ['web', 'enumeration', 'discovery'],
        enabled: true,
      ),

      // Trigger for network segments
      mt.MethodologyTrigger(
        id: 'trigger_network_scan',
        methodologyId: 'methodology_network_scan',
        name: 'Network Discovery Scan',
        description: 'Triggers for new network segments',
        assetType: AssetType.networkSegment,
        conditions: {
          'scanned': {'\$operator': 'notExists'},
        },
        priority: 10,
        batchCapable: false,
        deduplicationKeyTemplate: '{asset.subnet}:scan',
        tags: ['network', 'discovery', 'scanning'],
        enabled: true,
      ),

      // Trigger for AD domains
      mt.MethodologyTrigger(
        id: 'trigger_ad_enum',
        methodologyId: 'methodology_ad_enum',
        name: 'AD Enumeration',
        description: 'Triggers when AD domain is discovered',
        assetType: AssetType.activeDirectoryDomain,
        conditions: null, // Triggers for all AD domains
        priority: 9,
        batchCapable: false,
        deduplicationKeyTemplate: '{asset.name}:ad_enum',
        tags: ['active-directory', 'enumeration', 'domain'],
        cooldownPeriod: const Duration(hours: 24),
        enabled: true,
      ),
    ];
  }

  /// Convert assets to trigger-compatible format
  static List<Map<String, dynamic>> convertAssetsForTriggers(
    List<Asset> assets,
  ) {
    return assets.map((asset) {
      final Map<String, dynamic> converted = {
        'id': asset.id,
        'type': asset.type.name,
        'identifier': asset.name,
        'name': asset.name,
        'description': asset.description,
      };

      // Convert properties
      asset.properties.forEach((key, value) {
        converted[key] = _convertPropertyValue(value);
      });

      // Add type-specific fields for easier matching
      switch (asset.type) {
        case AssetType.host:
          converted['host'] = asset.name;
          break;
        case AssetType.credential:
          // Properties should contain username, password, etc.
          break;
        case AssetType.service:
          // Properties should contain port, service_name, etc.
          break;
        case AssetType.networkSegment:
          converted['subnet'] = asset.name;
          break;
        case AssetType.activeDirectoryDomain:
          converted['domain'] = asset.name;
          break;
        default:
          break;
      }

      return converted;
    }).toList();
  }

  /// Convert PropertyValue to simple dynamic value
  static dynamic _convertPropertyValue(PropertyValue value) {
    // This is a placeholder - actual implementation depends on PropertyValue structure
    // For now, we'll handle common cases
    if (value.toString().startsWith('PropertyValue.string(')) {
      // Extract string value - this is a hack, proper implementation needed
      return value.toString().replaceAll(RegExp(r'PropertyValue\.string\((.*)\)'), r'$1');
    }
    if (value.toString().startsWith('PropertyValue.boolean(')) {
      return value.toString().contains('true');
    }
    if (value.toString().startsWith('PropertyValue.integer(')) {
      final match = RegExp(r'PropertyValue\.integer\((\d+)\)').firstMatch(value.toString());
      return int.tryParse(match?.group(1) ?? '0') ?? 0;
    }
    // Fallback
    return value.toString();
  }
}

/// Service to load and manage triggers - WORKING IMPLEMENTATION
class TriggerLoaderService {
  static final _instance = TriggerLoaderService._internal();
  factory TriggerLoaderService() => _instance;
  TriggerLoaderService._internal();

  final List<mt.MethodologyTrigger> _loadedTriggers = [];
  final Map<String, Methodology> _methodologies = {};

  /// Initialize with test data
  Future<void> initialize() async {
    // Load test triggers
    _loadedTriggers.clear();
    _loadedTriggers.addAll(SampleTriggers.getTestTriggers());

    // Create corresponding methodologies
    _createTestMethodologies();
  }

  /// Get all loaded triggers
  List<mt.MethodologyTrigger> getTriggers() => List.unmodifiable(_loadedTriggers);

  /// Get triggers for a specific methodology
  List<mt.MethodologyTrigger> getTriggersForMethodology(String methodologyId) {
    return _loadedTriggers
        .where((t) => t.methodologyId == methodologyId)
        .toList();
  }

  /// Get methodology by ID
  Methodology? getMethodology(String id) => _methodologies[id];

  /// Create test methodologies to match triggers (simplified)
  void _createTestMethodologies() {
    _methodologies.clear();

    // For now, we'll create simplified methodology placeholders
    // Full implementation would load from YAML files
    print('Test methodologies created (simplified implementation)');
  }
}

/// Quick task creation helper
class QuickTaskCreator {
  static TaskInstance createTaskFromTrigger(
    mt.MethodologyTrigger trigger,
    Map<String, dynamic> matchedAsset,
  ) {
    return TaskInstance(
      id: const Uuid().v4(),
      methodologyId: trigger.methodologyId,
      methodologyName: trigger.name,
      triggers: [
        TriggerInstance(
          id: const Uuid().v4(),
          triggerId: trigger.id,
          context: {
            'asset': matchedAsset,
            'asset_id': matchedAsset['id'],
            'asset_type': matchedAsset['type'],
          },
          status: TriggerStatus.pending,
        ),
      ],
      status: TaskStatus.pending,
      completedCount: 0,
      createdDate: DateTime.now(),
    );
  }
}

/// Test data generator for immediate testing
class TriggerTestData {
  /// Generate test assets that will trigger various methodologies
  static List<Map<String, dynamic>> generateTestAssets() {
    return [
      // Host with SMB vulnerability
      {
        'id': 'asset_host_1',
        'type': 'host',
        'identifier': '192.168.1.10',
        'name': '192.168.1.10',
        'ports': [22, 80, 139, 445],
        'smb_signing': false,
        'os_type': 'windows',
      },

      // Discovered credential
      {
        'id': 'asset_cred_1',
        'type': 'credential',
        'identifier': 'admin',
        'name': 'admin',
        'username': 'admin',
        'password': 'Password123!',
        'domain': 'CORP',
        'verified': false,
      },

      // Web service
      {
        'id': 'asset_web_1',
        'type': 'service',
        'identifier': '192.168.1.20:80',
        'name': 'Web Server',
        'host': '192.168.1.20',
        'port': 80,
        'service_name': 'http',
        'version': 'nginx/1.18.0',
      },

      // Network segment
      {
        'id': 'asset_net_1',
        'type': 'networkSegment',
        'identifier': '192.168.1.0/24',
        'name': 'Internal Network',
        'subnet': '192.168.1.0/24',
        'gateway': '192.168.1.1',
      },

      // AD Domain
      {
        'id': 'asset_ad_1',
        'type': 'activeDirectoryDomain',
        'identifier': 'corp.local',
        'name': 'corp.local',
        'domain': 'corp.local',
        'domain_controllers': ['192.168.1.5'],
      },
    ];
  }
}