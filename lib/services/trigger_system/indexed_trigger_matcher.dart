import '../../models/asset.dart';
import '../../models/methodology_trigger.dart' as mt;

/// Fast O(1) trigger lookup using multi-level indexing
///
/// Instead of O(n) scanning through all triggers, this maintains indexes for:
/// - Asset type → triggers
/// - Property key → triggers
/// - Trigger ID → trigger
///
/// This dramatically improves performance for large trigger sets
class IndexedTriggerMatcher {
  /// Multi-level index for fast lookups
  final Map<AssetType, List<mt.MethodologyTrigger>> _byAssetType = {};
  final Map<String, List<mt.MethodologyTrigger>> _byProperty = {};
  final Map<String, mt.MethodologyTrigger> _byId = {};

  /// Statistics
  int _totalTriggers = 0;
  DateTime? _lastIndexTime;

  /// Build indexes from triggers
  void buildIndexes(List<mt.MethodologyTrigger> triggers) {
    _clearIndexes();
    _totalTriggers = triggers.length;
    _lastIndexTime = DateTime.now();

    for (final trigger in triggers) {
      // Index by asset type
      _byAssetType.putIfAbsent(trigger.assetType, () => []).add(trigger);

      // Index by property keys
      _indexPropertyKeys(trigger);

      // Index by ID for direct lookup
      _byId[trigger.id] = trigger;
    }

    // Sort by priority for consistent ordering
    for (final list in _byAssetType.values) {
      list.sort((a, b) => b.priority.compareTo(a.priority));
    }

    for (final list in _byProperty.values) {
      list.sort((a, b) => b.priority.compareTo(a.priority));
    }
  }

  /// Extract and index property keys from trigger conditions
  void _indexPropertyKeys(mt.MethodologyTrigger trigger) {
    final propertyKeys = <String>{};

    // Extract property keys from conditions
    if (trigger.conditions is mt.TriggerCondition) {
      final condition = trigger.conditions as mt.TriggerCondition;
      propertyKeys.add(condition.property);
    } else if (trigger.conditions is mt.TriggerConditionGroup) {
      _extractPropertyKeysFromGroup(
        trigger.conditions as mt.TriggerConditionGroup,
        propertyKeys,
      );
    }

    // Add trigger to each property index
    for (final key in propertyKeys) {
      _byProperty.putIfAbsent(key, () => []).add(trigger);
    }
  }

  /// Recursively extract property keys from condition groups
  void _extractPropertyKeysFromGroup(
    mt.TriggerConditionGroup group,
    Set<String> keys,
  ) {
    for (final condition in group.conditions) {
      if (condition is mt.TriggerCondition) {
        keys.add(condition.property);
      } else if (condition is mt.TriggerConditionGroup) {
        _extractPropertyKeysFromGroup(condition, keys);
      }
    }
  }

  /// Get relevant triggers for an asset (O(1) lookup)
  List<mt.MethodologyTrigger> getRelevantTriggers(Asset asset) {
    // Use a Set to avoid duplicates
    final triggers = <mt.MethodologyTrigger>{};

    // Add type-specific triggers
    triggers.addAll(_byAssetType[asset.type] ?? []);

    // Add property-specific triggers
    for (final propertyKey in asset.properties.keys) {
      triggers.addAll(_byProperty[propertyKey] ?? []);
    }

    // Convert to list and sort by priority
    final result = triggers.toList();
    result.sort((a, b) => b.priority.compareTo(a.priority));

    return result;
  }

  /// Get triggers for a specific asset type
  List<mt.MethodologyTrigger> getTriggersForType(AssetType type) {
    return _byAssetType[type] ?? [];
  }

  /// Get triggers that reference a specific property
  List<mt.MethodologyTrigger> getTriggersForProperty(String propertyKey) {
    return _byProperty[propertyKey] ?? [];
  }

  /// Get trigger by ID (O(1) lookup)
  mt.MethodologyTrigger? getTriggerById(String id) => _byId[id];

  /// Get all indexed triggers
  List<mt.MethodologyTrigger> getAllTriggers() => _byId.values.toList();

  /// Get triggers matching multiple criteria
  List<mt.MethodologyTrigger> getTriggersMatching({
    AssetType? assetType,
    List<String>? propertyKeys,
    bool enabled = true,
  }) {
    final triggers = <mt.MethodologyTrigger>{};

    if (assetType != null) {
      triggers.addAll(_byAssetType[assetType] ?? []);
    }

    if (propertyKeys != null) {
      for (final key in propertyKeys) {
        triggers.addAll(_byProperty[key] ?? []);
      }
    }

    if (triggers.isEmpty) {
      // No criteria specified, return all
      triggers.addAll(_byId.values);
    }

    // Filter by enabled status
    final result = enabled
        ? triggers.where((t) => t.enabled).toList()
        : triggers.toList();

    // Sort by priority
    result.sort((a, b) => b.priority.compareTo(a.priority));

    return result;
  }

  /// Get statistics
  Map<String, dynamic> getIndexStats() {
    return {
      'totalTriggers': _totalTriggers,
      'assetTypeIndexes': _byAssetType.keys.length,
      'propertyIndexes': _byProperty.keys.length,
      'avgTriggersPerType': _byAssetType.values.isEmpty
          ? 0
          : _byAssetType.values
                  .map((l) => l.length)
                  .reduce((a, b) => a + b) ~/
              _byAssetType.length,
      'avgTriggersPerProperty': _byProperty.values.isEmpty
          ? 0
          : _byProperty.values
                  .map((l) => l.length)
                  .reduce((a, b) => a + b) ~/
              _byProperty.length,
      'lastIndexTime': _lastIndexTime?.toIso8601String() ?? 'never',
      'assetTypes': _byAssetType.keys.map((t) => t.name).toList(),
      'indexedProperties': _byProperty.keys.toList(),
    };
  }

  /// Get detailed breakdown by asset type
  Map<String, int> getAssetTypeBreakdown() {
    final breakdown = <String, int>{};
    for (final entry in _byAssetType.entries) {
      breakdown[entry.key.name] = entry.value.length;
    }
    return breakdown;
  }

  /// Get detailed breakdown by property
  Map<String, int> getPropertyBreakdown() {
    final breakdown = <String, int>{};
    for (final entry in _byProperty.entries) {
      breakdown[entry.key] = entry.value.length;
    }
    return breakdown;
  }

  /// Check if indexes are stale
  bool isStale({Duration maxAge = const Duration(minutes: 5)}) {
    if (_lastIndexTime == null) return true;
    return DateTime.now().difference(_lastIndexTime!) > maxAge;
  }

  /// Get index size estimate in bytes
  int estimateMemoryUsage() {
    var bytes = 0;

    // Estimate trigger objects (rough approximation)
    bytes += _totalTriggers * 500; // ~500 bytes per trigger

    // Index overhead
    bytes += _byAssetType.length * 100; // Map overhead
    bytes += _byProperty.length * 100;
    bytes += _byId.length * 100;

    return bytes;
  }

  /// Clear all indexes
  void _clearIndexes() {
    _byAssetType.clear();
    _byProperty.clear();
    _byId.clear();
  }

  /// Clear indexes and reset stats
  void reset() {
    _clearIndexes();
    _totalTriggers = 0;
    _lastIndexTime = null;
  }

  /// Verify index integrity
  bool verifyIntegrity() {
    // Check all triggers in byId are also in other indexes
    for (final trigger in _byId.values) {
      // Should be in asset type index
      final typeIndex = _byAssetType[trigger.assetType];
      if (typeIndex == null || !typeIndex.contains(trigger)) {
        return false;
      }
    }

    // Check counts match
    final totalInTypeIndex =
        _byAssetType.values.map((l) => l.length).fold(0, (a, b) => a + b);

    // Note: totalInTypeIndex should equal _totalTriggers
    // Property index may have duplicates across properties
    return totalInTypeIndex == _totalTriggers;
  }

  /// Print debug information
  void printDebugInfo() {
    print('=== Indexed Trigger Matcher Stats ===');
    print('Total triggers: $_totalTriggers');
    print('Asset type indexes: ${_byAssetType.keys.length}');
    print('Property indexes: ${_byProperty.keys.length}');
    print('Last index time: $_lastIndexTime');
    print('Memory usage: ~${(estimateMemoryUsage() / 1024).toStringAsFixed(2)} KB');
    print('Integrity check: ${verifyIntegrity() ? "PASS" : "FAIL"}');
    print('\nAsset Type Breakdown:');
    getAssetTypeBreakdown().forEach((type, count) {
      print('  $type: $count triggers');
    });
    print('\nTop Properties:');
    final propBreakdown = getPropertyBreakdown();
    final topProps = propBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    for (final entry in topProps.take(10)) {
      print('  ${entry.key}: ${entry.value} triggers');
    }
    print('=====================================');
  }
}
