import '../models/assets.dart';
import '../models/methodology_trigger_builder.dart';
import '../models/methodology_execution.dart';

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
    // Handle different trigger group operators
    switch (trigger.rootGroup.operator) {
      case TriggerGroupOperator.and:
        return _evaluateAndGroup(asset, trigger.rootGroup, allAssets);
      case TriggerGroupOperator.or:
        return _evaluateOrGroup(asset, trigger.rootGroup, allAssets);
      case TriggerGroupOperator.not:
        return !_evaluateAndGroup(asset, trigger.rootGroup, allAssets);
    }
  }

  /// Evaluate AND group - all conditions must be true
  static bool _evaluateAndGroup(
    Asset asset,
    TriggerGroup group,
    List<Asset> allAssets,
  ) {
    // Check all direct conditions
    for (final condition in group.conditions) {
      if (!_evaluateCondition(asset, condition, allAssets)) {
        return false;
      }
    }

    // Check all nested groups
    for (final nestedGroup in group.nestedGroups) {
      if (!_evaluateAssetAgainstGroup(asset, nestedGroup, allAssets)) {
        return false;
      }
    }

    return true;
  }

  /// Evaluate OR group - at least one condition must be true
  static bool _evaluateOrGroup(
    Asset asset,
    TriggerGroup group,
    List<Asset> allAssets,
  ) {
    // Check all direct conditions
    for (final condition in group.conditions) {
      if (_evaluateCondition(asset, condition, allAssets)) {
        return true;
      }
    }

    // Check all nested groups
    for (final nestedGroup in group.nestedGroups) {
      if (_evaluateAssetAgainstGroup(asset, nestedGroup, allAssets)) {
        return true;
      }
    }

    return false;
  }

  /// Evaluate asset against a trigger group
  static bool _evaluateAssetAgainstGroup(
    Asset asset,
    TriggerGroup group,
    List<Asset> allAssets,
  ) {
    switch (group.operator) {
      case TriggerGroupOperator.and:
        return _evaluateAndGroup(asset, group, allAssets);
      case TriggerGroupOperator.or:
        return _evaluateOrGroup(asset, group, allAssets);
      case TriggerGroupOperator.not:
        return !_evaluateAndGroup(asset, group, allAssets);
    }
  }

  /// Evaluate a single condition against an asset
  static bool _evaluateCondition(
    Asset asset,
    TriggerCondition condition,
    List<Asset> allAssets,
  ) {
    // First check if asset type matches
    if (asset.type != _mapLegacyAssetType(condition.assetType)) {
      return false;
    }

    // Get the property value from the asset
    final propertyValue = asset.properties[condition.property];
    if (propertyValue == null) {
      return _handleNullProperty(condition);
    }

    // Evaluate based on operator
    return _evaluatePropertyCondition(propertyValue, condition, allAssets);
  }

  /// Handle conditions where the property is null/missing
  static bool _handleNullProperty(TriggerCondition condition) {
    switch (condition.operator) {
      case TriggerOperator.isNull:
        return true;
      case TriggerOperator.isNotNull:
        return false;
      default:
        return false; // Property doesn't exist, condition fails
    }
  }

  /// Evaluate property condition based on operator
  static bool _evaluatePropertyCondition(
    AssetPropertyValue propertyValue,
    TriggerCondition condition,
    List<Asset> allAssets,
  ) {
    switch (condition.operator) {
      case TriggerOperator.equals:
        return _evaluateEquals(propertyValue, condition.value);
      case TriggerOperator.notEquals:
        return !_evaluateEquals(propertyValue, condition.value);
      case TriggerOperator.contains:
        return _evaluateContains(propertyValue, condition.value);
      case TriggerOperator.notContains:
        return !_evaluateContains(propertyValue, condition.value);
      case TriggerOperator.greaterThan:
        return _evaluateGreaterThan(propertyValue, condition.value);
      case TriggerOperator.lessThan:
        return _evaluateLessThan(propertyValue, condition.value);
      case TriggerOperator.greaterThanOrEqual:
        return _evaluateGreaterThanOrEqual(propertyValue, condition.value);
      case TriggerOperator.lessThanOrEqual:
        return _evaluateLessThanOrEqual(propertyValue, condition.value);
      case TriggerOperator.isNull:
        return false; // Property exists, so not null
      case TriggerOperator.isNotNull:
        return true; // Property exists, so not null
      case TriggerOperator.hasValue:
        return _evaluateHasValue(propertyValue, condition.value);
      case TriggerOperator.inList:
        return _evaluateInList(propertyValue, condition.value);
      case TriggerOperator.notInList:
        return !_evaluateInList(propertyValue, condition.value);
    }
  }

  /// Evaluate equals operator
  static bool _evaluateEquals(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return propertyValue.when(
      string: (v) => triggerValue.whenOrNull(string: (tv) => v == tv) ?? false,
      integer: (v) => triggerValue.whenOrNull(integer: (tv) => v == tv) ?? false,
      double: (v) => triggerValue.whenOrNull(double: (tv) => v == tv) ?? false,
      boolean: (v) => triggerValue.whenOrNull(boolean: (tv) => v == tv) ?? false,
      stringList: (v) => triggerValue.whenOrNull(stringList: (tv) =>
        v.length == tv.length && v.every((item) => tv.contains(item))) ?? false,
      dateTime: (v) => triggerValue.whenOrNull(dateTime: (tv) => v == tv) ?? false,
      map: (v) => false, // Complex comparison not supported
      objectList: (v) => false, // Complex comparison not supported
    );
  }

  /// Evaluate contains operator
  static bool _evaluateContains(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return propertyValue.when(
      string: (v) => triggerValue.whenOrNull(string: (tv) =>
        v.toLowerCase().contains(tv.toLowerCase())) ?? false,
      stringList: (v) => triggerValue.whenOrNull(string: (tv) =>
        v.any((item) => item.toLowerCase().contains(tv.toLowerCase()))) ?? false,
      integer: (v) => false,
      double: (v) => false,
      boolean: (v) => false,
      dateTime: (v) => false,
      map: (v) => false,
      objectList: (v) => false,
    );
  }

  /// Evaluate greater than operator
  static bool _evaluateGreaterThan(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return propertyValue.when(
      integer: (v) => triggerValue.whenOrNull(integer: (tv) => v > tv) ?? false,
      double: (v) => triggerValue.whenOrNull(double: (tv) => v > tv) ?? false,
      dateTime: (v) => triggerValue.whenOrNull(dateTime: (tv) => v.isAfter(tv)) ?? false,
      string: (v) => false,
      boolean: (v) => false,
      stringList: (v) => false,
      map: (v) => false,
      objectList: (v) => false,
    );
  }

  /// Evaluate less than operator
  static bool _evaluateLessThan(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return propertyValue.when(
      integer: (v) => triggerValue.whenOrNull(integer: (tv) => v < tv) ?? false,
      double: (v) => triggerValue.whenOrNull(double: (tv) => v < tv) ?? false,
      dateTime: (v) => triggerValue.whenOrNull(dateTime: (tv) => v.isBefore(tv)) ?? false,
      string: (v) => false,
      boolean: (v) => false,
      stringList: (v) => false,
      map: (v) => false,
      objectList: (v) => false,
    );
  }

  /// Evaluate greater than or equal operator
  static bool _evaluateGreaterThanOrEqual(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return _evaluateGreaterThan(propertyValue, triggerValue) ||
           _evaluateEquals(propertyValue, triggerValue);
  }

  /// Evaluate less than or equal operator
  static bool _evaluateLessThanOrEqual(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return _evaluateLessThan(propertyValue, triggerValue) ||
           _evaluateEquals(propertyValue, triggerValue);
  }

  /// Evaluate has value operator (for lists/arrays)
  static bool _evaluateHasValue(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return propertyValue.when(
      stringList: (v) => triggerValue.whenOrNull(string: (tv) => v.contains(tv)) ?? false,
      objectList: (v) => false, // Would need more complex matching
      string: (v) => false,
      integer: (v) => false,
      double: (v) => false,
      boolean: (v) => false,
      dateTime: (v) => false,
      map: (v) => false,
    );
  }

  /// Evaluate in list operator
  static bool _evaluateInList(AssetPropertyValue propertyValue, TriggerValue triggerValue) {
    return triggerValue.whenOrNull(
      stringList: (triggerList) => propertyValue.when(
        string: (v) => triggerList.contains(v),
        integer: (v) => false,
        double: (v) => false,
        boolean: (v) => false,
        stringList: (v) => false,
        dateTime: (v) => false,
        map: (v) => false,
        objectList: (v) => false,
      ),
    ) ?? false;
  }

  /// Map legacy asset types to comprehensive asset types
  static AssetType _mapLegacyAssetType(AssetType legacyType) {
    switch (legacyType) {
      case AssetType.networkSegment:
        return AssetType.networkSegment;
      case AssetType.host:
        return AssetType.host;
      case AssetType.service:
        return AssetType.service;
      case AssetType.credential:
        return AssetType.credential;
      case AssetType.vulnerability:
        return AssetType.vulnerability;
      case AssetType.domain:
        return AssetType.authenticationSystem;
      case AssetType.wireless_network:
        return AssetType.wirelessNetwork;
    }
  }

  /// Calculate confidence score for a trigger match
  static double _calculateConfidence(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    double confidence = 0.8; // Base confidence

    // Increase confidence based on asset discovery status
    for (final asset in matchingAssets) {
      switch (asset.discoveryStatus) {
        case AssetDiscoveryStatus.analyzed:
          confidence += 0.1;
          break;
        case AssetDiscoveryStatus.accessible:
          confidence += 0.05;
          break;
        case AssetDiscoveryStatus.compromised:
          confidence += 0.15;
          break;
        case AssetDiscoveryStatus.discovered:
          confidence += 0.02;
          break;
        case AssetDiscoveryStatus.unknown:
          confidence -= 0.1;
          break;
      }
    }

    // Increase confidence based on asset confidence scores
    final avgAssetConfidence = matchingAssets.fold<double>(
      0.0, (sum, asset) => sum + asset.confidence) / matchingAssets.length;
    confidence *= avgAssetConfidence;

    // Cap confidence at 1.0
    return confidence.clamp(0.0, 1.0);
  }

  /// Calculate priority for methodology execution
  static int _calculatePriority(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    int priority = 50; // Base priority

    // Increase priority for compromised assets
    final compromisedCount = matchingAssets.where(
      (asset) => asset.discoveryStatus == AssetDiscoveryStatus.compromised
    ).length;
    priority += compromisedCount * 20;

    // Increase priority for high-value assets (based on type)
    for (final asset in matchingAssets) {
      switch (asset.type) {
        case AssetType.host:
          priority += 10;
          break;
        case AssetType.authenticationSystem:
          priority += 15;
          break;
        case AssetType.cloudTenant:
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

    // Increase priority based on access level
    for (final asset in matchingAssets) {
      switch (asset.accessLevel) {
        case AccessLevel.system:
          priority += 25;
          break;
        case AccessLevel.admin:
          priority += 20;
          break;
        case AccessLevel.user:
          priority += 10;
          break;
        case AccessLevel.guest:
          priority += 5;
          break;
        case AccessLevel.none:
        case null:
          break;
      }
    }

    return priority.clamp(0, 100);
  }

  /// Build execution context for methodology
  static Map<String, dynamic> _buildExecutionContext(
    MethodologyTriggerDefinition trigger,
    List<Asset> matchingAssets,
  ) {
    final context = <String, dynamic>{
      'trigger_id': trigger.id,
      'trigger_name': trigger.name,
      'matching_asset_count': matchingAssets.length,
      'matching_asset_ids': matchingAssets.map((a) => a.id).toList(),
      'asset_types': matchingAssets.map((a) => a.type.name).toSet().toList(),
      'discovery_statuses': matchingAssets.map((a) => a.discoveryStatus.name).toSet().toList(),
    };

    // Add asset-specific context
    for (int i = 0; i < matchingAssets.length; i++) {
      final asset = matchingAssets[i];
      context['asset_${i}_id'] = asset.id;
      context['asset_${i}_name'] = asset.name;
      context['asset_${i}_type'] = asset.type.name;

      // Add key properties based on asset type
      switch (asset.type) {
        case AssetType.host:
          context['asset_${i}_ip'] = asset.ipAddress;
          context['asset_${i}_hostname'] = asset.hostname;
          break;
        case AssetType.networkSegment:
          context['asset_${i}_subnet'] = asset.subnet;
          break;
        case AssetType.wirelessNetwork:
          context['asset_${i}_ssid'] = asset.ssid;
          break;
        case AssetType.cloudTenant:
          context['asset_${i}_tenant_id'] = asset.tenantId;
          break;
        default:
          break;
      }
    }

    return context;
  }

  /// Generate methodology recommendations based on asset analysis
  static List<MethodologyRecommendation> generateRecommendations({
    required List<Asset> assets,
    required String projectId,
  }) {
    final recommendations = <MethodologyRecommendation>[];

    // Analyze asset patterns and suggest methodologies
    _analyzeNetworkSegments(assets, projectId, recommendations);
    _analyzeHosts(assets, projectId, recommendations);
    _analyzeCredentials(assets, projectId, recommendations);
    _analyzeCloudAssets(assets, projectId, recommendations);
    _analyzeWirelessNetworks(assets, projectId, recommendations);

    return recommendations;
  }

  /// Analyze network segments for methodology recommendations
  static void _analyzeNetworkSegments(
    List<Asset> assets,
    String projectId,
    List<MethodologyRecommendation> recommendations,
  ) {
    final networks = assets.where((a) => a.type == AssetType.networkSegment);

    for (final network in networks) {
      // Check for NAC bypass opportunities
      final nacEnabled = network.getProperty<bool>('nac_enabled') ?? false;
      if (!nacEnabled) {
        recommendations.add(MethodologyRecommendation(
          id: 'nac_bypass_${network.id}',
          projectId: projectId,
          methodologyId: 'network_access_bypass',
          reason: 'Network Access Control (NAC) is disabled',
          confidence: 0.8,
          createdDate: DateTime.now(),
          isDismissed: false,
          context: {'network_id': network.id, 'subnet': network.subnet},
        ));
      }

      // Check for VLAN hopping opportunities
      final vlanId = network.getProperty<int>('vlan_id');
      if (vlanId != null && vlanId > 1) {
        recommendations.add(MethodologyRecommendation(
          id: 'vlan_hopping_${network.id}',
          projectId: projectId,
          methodologyId: 'vlan_hopping',
          reason: 'VLAN segmentation detected - test for hopping',
          confidence: 0.6,
          createdDate: DateTime.now(),
          isDismissed: false,
          context: {'network_id': network.id, 'vlan_id': vlanId},
        ));
      }
    }
  }

  /// Analyze hosts for methodology recommendations
  static void _analyzeHosts(
    List<Asset> assets,
    String projectId,
    List<MethodologyRecommendation> recommendations,
  ) {
    final hosts = assets.where((a) => a.type == AssetType.host);

    for (final host in hosts) {
      // Check for SMB signing
      final smbSigning = host.getProperty<bool>('smb_signing_required') ?? true;
      if (!smbSigning) {
        recommendations.add(MethodologyRecommendation(
          id: 'smb_relay_${host.id}',
          projectId: projectId,
          methodologyId: 'smb_relay_attack',
          reason: 'SMB signing not required - relay attack possible',
          confidence: 0.9,
          createdDate: DateTime.now(),
          isDismissed: false,
          context: {'host_id': host.id, 'ip': host.ipAddress},
        ));
      }

      // Check for RDP exposure
      final rdpEnabled = host.getProperty<bool>('rdp_enabled') ?? false;
      if (rdpEnabled) {
        recommendations.add(MethodologyRecommendation(
          id: 'rdp_attack_${host.id}',
          projectId: projectId,
          methodologyId: 'rdp_brute_force',
          reason: 'RDP service detected - test for weak credentials',
          confidence: 0.7,
          createdDate: DateTime.now(),
          isDismissed: false,
          context: {'host_id': host.id, 'ip': host.ipAddress},
        ));
      }
    }
  }

  /// Analyze credentials for methodology recommendations
  static void _analyzeCredentials(
    List<Asset> assets,
    String projectId,
    List<MethodologyRecommendation> recommendations,
  ) {
    final credentials = assets.where((a) => a.type == AssetType.credential);

    if (credentials.isNotEmpty) {
      recommendations.add(MethodologyRecommendation(
        id: 'credential_spray_${DateTime.now().millisecondsSinceEpoch}',
        projectId: projectId,
        methodologyId: 'credential_spraying',
        reason: 'Credentials discovered - test across environment',
        confidence: 0.8,
        createdDate: DateTime.now(),
        isDismissed: false,
        context: {'credential_count': credentials.length},
      ));
    }
  }

  /// Analyze cloud assets for methodology recommendations
  static void _analyzeCloudAssets(
    List<Asset> assets,
    String projectId,
    List<MethodologyRecommendation> recommendations,
  ) {
    final cloudAssets = assets.where((a) => [
      AssetType.cloudTenant,
      AssetType.cloudResource,
      AssetType.cloudIdentity,
    ].contains(a.type));

    for (final asset in cloudAssets) {
      if (asset.type == AssetType.cloudTenant) {
        final mfaEnforcement = asset.getProperty<String>('mfa_enforcement') ?? 'none';
        if (mfaEnforcement == 'none') {
          recommendations.add(MethodologyRecommendation(
            id: 'azure_mfa_bypass_${asset.id}',
            projectId: projectId,
            methodologyId: 'azure_mfa_bypass',
            reason: 'MFA not enforced in Azure tenant',
            confidence: 0.8,
            createdDate: DateTime.now(),
            isDismissed: false,
            context: {'tenant_id': asset.tenantId},
          ));
        }
      }
    }
  }

  /// Analyze wireless networks for methodology recommendations
  static void _analyzeWirelessNetworks(
    List<Asset> assets,
    String projectId,
    List<MethodologyRecommendation> recommendations,
  ) {
    final wirelessNetworks = assets.where((a) => a.type == AssetType.wirelessNetwork);

    for (final network in wirelessNetworks) {
      final encryption = network.getProperty<String>('encryption_type') ?? 'unknown';

      if (encryption == 'wep' || encryption == 'open') {
        recommendations.add(MethodologyRecommendation(
          id: 'wireless_attack_${network.id}',
          projectId: projectId,
          methodologyId: 'wireless_exploitation',
          reason: 'Weak or no wireless encryption detected',
          confidence: 0.9,
          createdDate: DateTime.now(),
          isDismissed: false,
          context: {'ssid': network.ssid, 'encryption': encryption},
        ));
      }

      final wpsEnabled = network.getProperty<bool>('wps_enabled') ?? false;
      if (wpsEnabled) {
        recommendations.add(MethodologyRecommendation(
          id: 'wps_attack_${network.id}',
          projectId: projectId,
          methodologyId: 'wps_attack',
          reason: 'WPS enabled - PIN brute force possible',
          confidence: 0.8,
          createdDate: DateTime.now(),
          isDismissed: false,
          context: {'ssid': network.ssid},
        ));
      }
    }
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
      methodologyId: trigger.methodologyId,
      status: ExecutionStatus.pending,
      progress: 0.0,
      startedDate: DateTime.now(),
      stepExecutions: [],
      executionContext: context,
    );
  }
}