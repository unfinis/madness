import '../../models/asset.dart';
import '../../models/methodology_trigger.dart' as mt;
import 'models/trigger_match_result.dart';

/// Generates and manages deduplication keys for trigger executions
///
/// Extracted from smart_triggers.dart - prevents redundant executions
/// of the same trigger+asset+conditions combination.
class TriggerDeduplication {
  /// Generate a deduplication key for a trigger match
  ///
  /// The key uniquely identifies this trigger+asset+conditions combination
  /// to prevent executing the same thing multiple times.
  static String generateKey({
    required TriggerMatchResult match,
    required mt.MethodologyTrigger trigger,
    required Asset asset,
  }) {
    // Use the trigger's template if provided
    if (trigger.deduplicationKeyTemplate.isNotEmpty) {
      return _applyTemplate(
        template: trigger.deduplicationKeyTemplate,
        match: match,
        trigger: trigger,
        asset: asset,
      );
    }

    // Default key format
    return _generateDefaultKey(
      triggerId: trigger.id,
      assetId: asset.id,
      conditions: trigger.conditions,
    );
  }

  /// Generate default deduplication key
  static String _generateDefaultKey({
    required String triggerId,
    required String assetId,
    required dynamic conditions,
  }) {
    final components = <String>[
      assetId,
      triggerId,
    ];

    // Add condition hash if conditions exist
    if (conditions != null) {
      final conditionHash = _hashConditions(conditions);
      components.add(conditionHash);
    }

    return components.join(':');
  }

  /// Apply a deduplication key template
  ///
  /// Templates can use placeholders like:
  /// - {asset.id}
  /// - {asset.name}
  /// - {asset.property_name}
  /// - {trigger.id}
  /// - {methodology}
  static String _applyTemplate({
    required String template,
    required TriggerMatchResult match,
    required mt.MethodologyTrigger trigger,
    required Asset asset,
  }) {
    String result = template;

    // Replace asset placeholders
    result = result.replaceAll('{asset.id}', asset.id);
    result = result.replaceAll('{asset.name}', asset.name);
    result = result.replaceAll('{asset.type}', asset.type.name);

    // Replace asset property placeholders
    final propertyPattern = RegExp(r'\{asset\.([^}]+)\}');
    result = result.replaceAllMapped(propertyPattern, (match) {
      final propertyName = match.group(1)!;
      final propertyValue = asset.properties[propertyName];

      if (propertyValue == null) return '';

      return _extractSimpleValue(propertyValue);
    });

    // Replace trigger placeholders
    result = result.replaceAll('{trigger.id}', trigger.id);
    result = result.replaceAll('{trigger.name}', trigger.name);
    result = result.replaceAll('{methodology}', trigger.methodologyId);

    // Replace hash placeholder
    if (result.contains('{hash}')) {
      final conditionHash = _hashConditions(trigger.conditions);
      result = result.replaceAll('{hash}', conditionHash);
    }

    // Replace credentials hash placeholder
    if (result.contains('{creds_hash}')) {
      final credsHash = _hashCredentials(asset);
      result = result.replaceAll('{creds_hash}', credsHash);
    }

    return result;
  }

  /// Hash conditions for deduplication
  static String _hashConditions(dynamic conditions) {
    if (conditions == null) return 'nocond';

    // Convert conditions to a stable string representation
    final condStr = conditions.toString();
    return condStr.hashCode.abs().toRadixString(36);
  }

  /// Hash credentials for deduplication
  static String _hashCredentials(Asset asset) {
    final credsList = asset.properties['credentials'] ??
                      asset.properties['credentials_available'];

    if (credsList == null) return 'nocreds';

    return credsList.toString().hashCode.abs().toRadixString(36);
  }

  /// Extract a simple string value from PropertyValue for template substitution
  static String _extractSimpleValue(PropertyValue value) {
    return value.when(
      string: (v) => v,
      integer: (v) => v.toString(),
      boolean: (v) => v.toString(),
      stringList: (v) => v.join(','),
      map: (v) => v.toString().hashCode.abs().toRadixString(36),
      objectList: (v) => v.toString().hashCode.abs().toRadixString(36),
    );
  }

  /// Check if a deduplication key was already used
  ///
  /// Checks against the asset's completedTriggers list
  static bool wasAlreadyExecuted({
    required String deduplicationKey,
    required Asset asset,
  }) {
    return asset.completedTriggers.contains(deduplicationKey);
  }

  /// Generate batch deduplication keys
  ///
  /// For batch operations, generates keys for all assets in the batch
  static List<String> generateBatchKeys({
    required List<TriggerMatchResult> matches,
    required mt.MethodologyTrigger trigger,
    required List<Asset> assets,
  }) {
    final keys = <String>[];

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final asset = assets[i];

      keys.add(generateKey(
        match: match,
        trigger: trigger,
        asset: asset,
      ));
    }

    return keys;
  }

  /// Group assets by batch criteria for batch execution
  ///
  /// Groups assets by a specific property (e.g., nac_type, service_name)
  static Map<String, List<Asset>> groupForBatch({
    required List<Asset> assets,
    required String batchCriteria,
  }) {
    final groups = <String, List<Asset>>{};

    for (final asset in assets) {
      final criteriaValue = asset.properties[batchCriteria];

      String groupKey;
      if (criteriaValue == null) {
        groupKey = 'null';
      } else {
        groupKey = _extractSimpleValue(criteriaValue);
      }

      if (!groups.containsKey(groupKey)) {
        groups[groupKey] = [];
      }
      groups[groupKey]!.add(asset);
    }

    return groups;
  }
}
