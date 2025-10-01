import '../../models/asset.dart';
import '../../models/methodology_trigger.dart' as mt;
import 'models/trigger_match_result.dart';
import 'models/execution_priority.dart';

/// Calculates execution priority for methodology triggers
///
/// Separated from boolean matching - priority determines execution order,
/// not whether a trigger matches.
class ExecutionPrioritizer {
  /// Calculate priority for a matched trigger
  ///
  /// Takes a successful match and calculates how urgently it should be executed
  static ExecutionPriority calculatePriority({
    required TriggerMatchResult match,
    required mt.MethodologyTrigger trigger,
    required Asset asset,
    List<Asset>? allAssets,
  }) {
    if (!match.matched) {
      return ExecutionPriority.low('Trigger did not match');
    }

    final factors = <PriorityFactor>[];
    int score = 50; // Base score

    // Add methodology base priority
    final basePriority = trigger.priority;
    final methodologyPoints = basePriority * 5; // Scale 0-10 to 0-50
    score += methodologyPoints;
    factors.add(PriorityFactors.methodologyPriority(methodologyPoints));

    // Add asset type priority
    final assetTypePoints = _getAssetTypePriority(asset.type);
    score += assetTypePoints;
    factors.add(PriorityFactors.assetType(asset.type.name, assetTypePoints));

    // Check for compromised status
    final compromised = _isAssetCompromised(asset);
    if (compromised) {
      const compromisedPoints = 20;
      score += compromisedPoints;
      factors.add(PriorityFactors.compromised(compromisedPoints));
    }

    // Check access level
    final accessLevel = _getAccessLevel(asset);
    if (accessLevel != null) {
      final accessPoints = _getAccessLevelPriority(accessLevel);
      score += accessPoints;
      factors.add(PriorityFactors.accessLevel(accessLevel, accessPoints));
    }

    // Check for high-value targets
    if (_isHighValueTarget(asset)) {
      const highValuePoints = 15;
      score += highValuePoints;
      factors.add(PriorityFactors.highValue(
        'Critical asset type: ${asset.type.name}',
        highValuePoints,
      ));
    }

    // Clamp score to valid range
    score = score.clamp(0, 100);

    // Generate human-readable reason
    final reason = _generatePriorityReason(score, factors);

    return ExecutionPriority(
      score: score,
      reason: reason,
      factors: factors,
      calculatedAt: DateTime.now(),
    );
  }

  /// Get priority points for asset type
  static int _getAssetTypePriority(AssetType type) {
    switch (type) {
      // Critical infrastructure
      case AssetType.domainController:
        return 15;
      case AssetType.activeDirectoryDomain:
        return 15;
      case AssetType.azureTenant:
        return 12;
      case AssetType.certificateAuthority:
        return 12;

      // High-value systems
      case AssetType.host:
        return 10;
      case AssetType.azureKeyVault:
        return 10;
      case AssetType.azureStorageAccount:
        return 9;

      // Important credentials and access
      case AssetType.credential:
        return 8;
      case AssetType.azureServicePrincipal:
        return 8;
      case AssetType.azureManagedIdentity:
        return 8;

      // Services and applications
      case AssetType.service:
        return 7;
      case AssetType.azureWebApp:
        return 7;
      case AssetType.azureFunctionApp:
        return 6;

      // Network infrastructure
      case AssetType.networkSegment:
        return 6;
      case AssetType.wireless_network:
        return 6;

      // Other assets
      case AssetType.vulnerability:
        return 5;
      case AssetType.smbShare:
        return 5;

      default:
        return 3;
    }
  }

  /// Check if asset is compromised
  static bool _isAssetCompromised(Asset asset) {
    // Check 'compromised' property
    final compromisedProp = asset.properties['compromised'] ?? asset.properties['status'];
    if (compromisedProp != null) {
      return compromisedProp.when(
        string: (value) => value.toLowerCase() == 'compromised',
        integer: (_) => false,
        boolean: (value) => value,
        stringList: (_) => false,
        map: (_) => false,
        objectList: (_) => false,
      );
    }

    return false;
  }

  /// Get access level from asset properties
  static String? _getAccessLevel(Asset asset) {
    final accessLevelProp = asset.properties['access_level'] ?? asset.properties['accessLevel'];
    if (accessLevelProp != null) {
      return accessLevelProp.when(
        string: (value) => value.toLowerCase(),
        integer: (_) => null,
        boolean: (_) => null,
        stringList: (_) => null,
        map: (_) => null,
        objectList: (_) => null,
      );
    }

    return null;
  }

  /// Get priority points for access level
  static int _getAccessLevelPriority(String level) {
    switch (level) {
      case 'full':
        return 20;
      case 'partial':
        return 15;
      case 'limited':
        return 10;
      case 'blocked':
        return 5;
      default:
        return 1;
    }
  }

  /// Check if asset is a high-value target
  static bool _isHighValueTarget(Asset asset) {
    final highValueTypes = {
      AssetType.domainController,
      AssetType.activeDirectoryDomain,
      AssetType.certificateAuthority,
      AssetType.azureTenant,
      AssetType.azureKeyVault,
    };

    return highValueTypes.contains(asset.type);
  }

  /// Generate human-readable priority reason
  static String _generatePriorityReason(int score, List<PriorityFactor> factors) {
    final level = score >= 80 ? 'Critical' : score >= 60 ? 'High' : score >= 40 ? 'Medium' : 'Low';

    if (factors.isEmpty) {
      return '$level priority (score: $score)';
    }

    // Get top 3 factors
    final topFactors = factors.toList()
      ..sort((a, b) => b.points.compareTo(a.points));

    final topThree = topFactors.take(3).map((f) => f.description).join(', ');

    return '$level priority (score: $score): $topThree';
  }

  /// Calculate priority for a cascade trigger (triggered by methodology completion)
  static ExecutionPriority calculateCascadePriority({
    required TriggerMatchResult match,
    required mt.MethodologyTrigger trigger,
    required Asset asset,
    required String completedMethodologyId,
    List<Asset>? allAssets,
  }) {
    // Start with normal priority calculation
    final basePriority = calculatePriority(
      match: match,
      trigger: trigger,
      asset: asset,
      allAssets: allAssets,
    );

    // Add cascade bonus
    const cascadeBonus = 10;
    final newScore = (basePriority.score + cascadeBonus).clamp(0, 100);

    final cascadeFactor = PriorityFactors.cascade(completedMethodologyId, cascadeBonus);
    final allFactors = [...basePriority.factors, cascadeFactor];

    return ExecutionPriority(
      score: newScore,
      reason: 'Cascade from $completedMethodologyId: ${basePriority.reason}',
      factors: allFactors,
      calculatedAt: DateTime.now(),
    );
  }

  /// Calculate priority for batch execution
  ///
  /// When multiple assets match the same trigger, calculate overall batch priority
  static ExecutionPriority calculateBatchPriority({
    required List<TriggerMatchResult> matches,
    required mt.MethodologyTrigger trigger,
    required List<Asset> assets,
  }) {
    if (matches.isEmpty || assets.isEmpty) {
      return ExecutionPriority.low('No matches in batch');
    }

    // Calculate individual priorities
    final priorities = <ExecutionPriority>[];
    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];
      final asset = assets[i];

      priorities.add(calculatePriority(
        match: match,
        trigger: trigger,
        asset: asset,
      ));
    }

    // Use highest priority in the batch
    final highestPriority = priorities.reduce((a, b) =>
      a.score > b.score ? a : b
    );

    // Add batch execution factor
    final batchCount = matches.length;
    final batchBonus = (batchCount * 2).clamp(0, 15); // Up to +15 for large batches
    final batchScore = (highestPriority.score + batchBonus).clamp(0, 100);

    final batchFactor = PriorityFactor(
      name: 'batch_execution',
      points: batchBonus,
      description: 'Batch of $batchCount items',
    );

    return ExecutionPriority(
      score: batchScore,
      reason: 'Batch ($batchCount items): ${highestPriority.reason}',
      factors: [...highestPriority.factors, batchFactor],
      calculatedAt: DateTime.now(),
    );
  }
}
