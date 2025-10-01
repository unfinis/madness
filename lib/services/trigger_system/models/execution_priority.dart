/// Represents the calculated priority for executing a methodology
///
/// Separated from trigger matching - priority is about execution policy,
/// not whether a trigger matches
class ExecutionPriority {
  /// Priority score (0-100, higher = more urgent)
  final int score;

  /// Human-readable explanation of how priority was calculated
  final String reason;

  /// Factors that contributed to the priority score
  final List<PriorityFactor> factors;

  /// Timestamp when priority was calculated
  final DateTime calculatedAt;

  const ExecutionPriority({
    required this.score,
    required this.reason,
    required this.factors,
    required this.calculatedAt,
  });

  /// Create a priority with given score
  factory ExecutionPriority.withScore({
    required int score,
    required String reason,
    List<PriorityFactor>? factors,
  }) {
    return ExecutionPriority(
      score: score.clamp(0, 100),
      reason: reason,
      factors: factors ?? [],
      calculatedAt: DateTime.now(),
    );
  }

  /// Create a low priority
  factory ExecutionPriority.low(String reason) {
    return ExecutionPriority.withScore(
      score: 30,
      reason: reason,
    );
  }

  /// Create a medium priority
  factory ExecutionPriority.medium(String reason) {
    return ExecutionPriority.withScore(
      score: 50,
      reason: reason,
    );
  }

  /// Create a high priority
  factory ExecutionPriority.high(String reason) {
    return ExecutionPriority.withScore(
      score: 70,
      reason: reason,
    );
  }

  /// Create a critical priority
  factory ExecutionPriority.critical(String reason) {
    return ExecutionPriority.withScore(
      score: 90,
      reason: reason,
    );
  }

  /// Whether this priority is higher than another
  bool isHigherThan(ExecutionPriority other) {
    return score > other.score;
  }

  /// Whether this priority is lower than another
  bool isLowerThan(ExecutionPriority other) {
    return score < other.score;
  }

  @override
  String toString() {
    return 'ExecutionPriority(score: $score, reason: $reason)';
  }

  /// Get priority level as a string
  String get level {
    if (score >= 80) return 'Critical';
    if (score >= 60) return 'High';
    if (score >= 40) return 'Medium';
    return 'Low';
  }
}

/// A factor that contributed to priority calculation
class PriorityFactor {
  /// Name of the factor
  final String name;

  /// Points contributed by this factor
  final int points;

  /// Description of this factor
  final String description;

  const PriorityFactor({
    required this.name,
    required this.points,
    required this.description,
  });

  @override
  String toString() {
    return 'PriorityFactor($name: +$points points - $description)';
  }
}

/// Common priority factors used in calculation
class PriorityFactors {
  /// Asset type contributes to priority
  static PriorityFactor assetType(String type, int points) {
    return PriorityFactor(
      name: 'asset_type',
      points: points,
      description: 'Asset type: $type',
    );
  }

  /// Asset is compromised
  static PriorityFactor compromised(int points) {
    return PriorityFactor(
      name: 'compromised',
      points: points,
      description: 'Asset is compromised',
    );
  }

  /// Access level achieved
  static PriorityFactor accessLevel(String level, int points) {
    return PriorityFactor(
      name: 'access_level',
      points: points,
      description: 'Access level: $level',
    );
  }

  /// High-value target
  static PriorityFactor highValue(String reason, int points) {
    return PriorityFactor(
      name: 'high_value',
      points: points,
      description: 'High-value target: $reason',
    );
  }

  /// Methodology priority from definition
  static PriorityFactor methodologyPriority(int basePriority) {
    return PriorityFactor(
      name: 'methodology_priority',
      points: basePriority,
      description: 'Base methodology priority',
    );
  }

  /// Cascade from completed methodology
  static PriorityFactor cascade(String fromMethodology, int points) {
    return PriorityFactor(
      name: 'cascade',
      points: points,
      description: 'Cascaded from: $fromMethodology',
    );
  }
}
