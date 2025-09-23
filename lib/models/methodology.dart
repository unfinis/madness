import 'package:flutter/material.dart';

class Methodology {
  final String id;
  final String name;
  final String version;
  final String projectId;
  final MethodologyCategory category;
  final String description;
  final String rationale;
  final MethodologyRiskLevel riskLevel;
  final StealthLevel stealthLevel;
  final Duration estimatedDuration;
  final List<MethodologyTrigger> triggers;
  final List<MethodologyStep> steps;
  final List<String> expectedAssetTypes;
  final List<SuppressionOption> suppressionOptions;
  final List<String> nextMethodologyIds;
  final DateTime createdDate;
  final DateTime updatedDate;

  const Methodology({
    required this.id,
    required this.name,
    required this.version,
    required this.projectId,
    required this.category,
    required this.description,
    required this.rationale,
    required this.riskLevel,
    required this.stealthLevel,
    required this.estimatedDuration,
    this.triggers = const [],
    this.steps = const [],
    this.expectedAssetTypes = const [],
    this.suppressionOptions = const [],
    this.nextMethodologyIds = const [],
    required this.createdDate,
    required this.updatedDate,
  });

  Methodology copyWith({
    String? id,
    String? name,
    String? version,
    String? projectId,
    MethodologyCategory? category,
    String? description,
    String? rationale,
    MethodologyRiskLevel? riskLevel,
    StealthLevel? stealthLevel,
    Duration? estimatedDuration,
    List<MethodologyTrigger>? triggers,
    List<MethodologyStep>? steps,
    List<String>? expectedAssetTypes,
    List<SuppressionOption>? suppressionOptions,
    List<String>? nextMethodologyIds,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Methodology(
      id: id ?? this.id,
      name: name ?? this.name,
      version: version ?? this.version,
      projectId: projectId ?? this.projectId,
      category: category ?? this.category,
      description: description ?? this.description,
      rationale: rationale ?? this.rationale,
      riskLevel: riskLevel ?? this.riskLevel,
      stealthLevel: stealthLevel ?? this.stealthLevel,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      triggers: triggers ?? this.triggers,
      steps: steps ?? this.steps,
      expectedAssetTypes: expectedAssetTypes ?? this.expectedAssetTypes,
      suppressionOptions: suppressionOptions ?? this.suppressionOptions,
      nextMethodologyIds: nextMethodologyIds ?? this.nextMethodologyIds,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'version': version,
    'projectId': projectId,
    'category': category.name,
    'description': description,
    'rationale': rationale,
    'riskLevel': riskLevel.name,
    'stealthLevel': stealthLevel.name,
    'estimatedDuration': estimatedDuration.inSeconds,
    'triggers': triggers.map((t) => t.toJson()).toList(),
    'steps': steps.map((s) => s.toJson()).toList(),
    'expectedAssetTypes': expectedAssetTypes,
    'suppressionOptions': suppressionOptions.map((s) => s.toJson()).toList(),
    'nextMethodologyIds': nextMethodologyIds,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate.toIso8601String(),
  };

  factory Methodology.fromJson(Map<String, dynamic> json) => Methodology(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    version: json['version'] ?? '1.0.0',
    projectId: json['projectId'] ?? '',
    category: MethodologyCategory.values.firstWhere(
      (c) => c.name == json['category'],
      orElse: () => MethodologyCategory.reconnaissance,
    ),
    description: json['description'] ?? '',
    rationale: json['rationale'] ?? '',
    riskLevel: MethodologyRiskLevel.values.firstWhere(
      (r) => r.name == json['riskLevel'],
      orElse: () => MethodologyRiskLevel.medium,
    ),
    stealthLevel: StealthLevel.values.firstWhere(
      (s) => s.name == json['stealthLevel'],
      orElse: () => StealthLevel.active,
    ),
    estimatedDuration: Duration(seconds: json['estimatedDuration'] ?? 0),
    triggers: (json['triggers'] as List<dynamic>?)
        ?.map((t) => MethodologyTrigger.fromJson(t))
        .toList() ?? [],
    steps: (json['steps'] as List<dynamic>?)
        ?.map((s) => MethodologyStep.fromJson(s))
        .toList() ?? [],
    expectedAssetTypes: List<String>.from(json['expectedAssetTypes'] ?? []),
    suppressionOptions: (json['suppressionOptions'] as List<dynamic>?)
        ?.map((s) => SuppressionOption.fromJson(s))
        .toList() ?? [],
    nextMethodologyIds: List<String>.from(json['nextMethodologyIds'] ?? []),
    createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
    updatedDate: DateTime.tryParse(json['updatedDate'] ?? '') ?? DateTime.now(),
  );
}

enum MethodologyCategory {
  reconnaissance,
  scanning,
  enumeration,
  exploitation,
  postExploitation;

  String get displayName {
    switch (this) {
      case MethodologyCategory.reconnaissance:
        return 'Reconnaissance';
      case MethodologyCategory.scanning:
        return 'Scanning';
      case MethodologyCategory.enumeration:
        return 'Enumeration';
      case MethodologyCategory.exploitation:
        return 'Exploitation';
      case MethodologyCategory.postExploitation:
        return 'Post-Exploitation';
    }
  }

  IconData get icon {
    switch (this) {
      case MethodologyCategory.reconnaissance:
        return Icons.search;
      case MethodologyCategory.scanning:
        return Icons.radar;
      case MethodologyCategory.enumeration:
        return Icons.list;
      case MethodologyCategory.exploitation:
        return Icons.flash_on;
      case MethodologyCategory.postExploitation:
        return Icons.rocket_launch;
    }
  }

  Color get color {
    switch (this) {
      case MethodologyCategory.reconnaissance:
        return const Color(0xFF3b82f6);
      case MethodologyCategory.scanning:
        return const Color(0xFF10b981);
      case MethodologyCategory.enumeration:
        return const Color(0xFFf59e0b);
      case MethodologyCategory.exploitation:
        return const Color(0xFFef4444);
      case MethodologyCategory.postExploitation:
        return const Color(0xFF8b5cf6);
    }
  }
}

enum MethodologyRiskLevel {
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case MethodologyRiskLevel.low:
        return 'Low';
      case MethodologyRiskLevel.medium:
        return 'Medium';
      case MethodologyRiskLevel.high:
        return 'High';
      case MethodologyRiskLevel.critical:
        return 'Critical';
    }
  }

  Color get color {
    switch (this) {
      case MethodologyRiskLevel.low:
        return const Color(0xFF10b981);
      case MethodologyRiskLevel.medium:
        return const Color(0xFFfbbf24);
      case MethodologyRiskLevel.high:
        return const Color(0xFFf59e0b);
      case MethodologyRiskLevel.critical:
        return const Color(0xFFef4444);
    }
  }
}

enum StealthLevel {
  passive,
  active,
  aggressive;

  String get displayName {
    switch (this) {
      case StealthLevel.passive:
        return 'Passive';
      case StealthLevel.active:
        return 'Active';
      case StealthLevel.aggressive:
        return 'Aggressive';
    }
  }

  Color get color {
    switch (this) {
      case StealthLevel.passive:
        return const Color(0xFF10b981);
      case StealthLevel.active:
        return const Color(0xFFfbbf24);
      case StealthLevel.aggressive:
        return const Color(0xFFef4444);
    }
  }
}

class MethodologyTrigger {
  final String id;
  final TriggerType type;
  final Map<String, dynamic> conditions;
  final int priority;
  final String description;
  final DeduplicationStrategy deduplication;

  const MethodologyTrigger({
    required this.id,
    required this.type,
    required this.conditions,
    this.priority = 0,
    required this.description,
    required this.deduplication,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'conditions': conditions,
    'priority': priority,
    'description': description,
    'deduplication': deduplication.toJson(),
  };

  factory MethodologyTrigger.fromJson(Map<String, dynamic> json) => MethodologyTrigger(
    id: json['id'] ?? '',
    type: TriggerType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => TriggerType.assetDiscovered,
    ),
    conditions: Map<String, dynamic>.from(json['conditions'] ?? {}),
    priority: json['priority'] ?? 0,
    description: json['description'] ?? '',
    deduplication: DeduplicationStrategy.fromJson(json['deduplication'] ?? {}),
  );
}

enum TriggerType {
  assetDiscovered,
  serviceDetected,
  credentialAvailable,
  methodologyCompleted,
  customCondition;

  String get displayName {
    switch (this) {
      case TriggerType.assetDiscovered:
        return 'Asset Discovered';
      case TriggerType.serviceDetected:
        return 'Service Detected';
      case TriggerType.credentialAvailable:
        return 'Credential Available';
      case TriggerType.methodologyCompleted:
        return 'Methodology Completed';
      case TriggerType.customCondition:
        return 'Custom Condition';
    }
  }
}

class DeduplicationStrategy {
  final String strategy;
  final List<String> signatureFields;
  final Duration? cooldownPeriod;
  final int? maxExecutions;

  const DeduplicationStrategy({
    required this.strategy,
    this.signatureFields = const [],
    this.cooldownPeriod,
    this.maxExecutions,
  });

  Map<String, dynamic> toJson() => {
    'strategy': strategy,
    'signatureFields': signatureFields,
    'cooldownPeriod': cooldownPeriod?.inSeconds,
    'maxExecutions': maxExecutions,
  };

  factory DeduplicationStrategy.fromJson(Map<String, dynamic> json) => DeduplicationStrategy(
    strategy: json['strategy'] ?? 'signature_based',
    signatureFields: List<String>.from(json['signatureFields'] ?? []),
    cooldownPeriod: json['cooldownPeriod'] != null 
        ? Duration(seconds: json['cooldownPeriod']) 
        : null,
    maxExecutions: json['maxExecutions'],
  );
}

class MethodologyStep {
  final String id;
  final String name;
  final String description;
  final MethodologyStepType type;
  final int orderIndex;
  final String command;
  final List<CommandVariant> commandVariants;
  final List<ExpectedOutput> expectedOutputs;
  final List<AssetDiscoveryRule> assetDiscoveryRules;
  final Map<String, dynamic> parameters;
  final Duration? timeout;

  const MethodologyStep({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.orderIndex = 0,
    required this.command,
    this.commandVariants = const [],
    this.expectedOutputs = const [],
    this.assetDiscoveryRules = const [],
    this.parameters = const {},
    this.timeout,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'type': type.name,
    'orderIndex': orderIndex,
    'command': command,
    'commandVariants': commandVariants.map((v) => v.toJson()).toList(),
    'expectedOutputs': expectedOutputs.map((o) => o.toJson()).toList(),
    'assetDiscoveryRules': assetDiscoveryRules.map((r) => r.toJson()).toList(),
    'parameters': parameters,
    'timeout': timeout?.inSeconds,
  };

  factory MethodologyStep.fromJson(Map<String, dynamic> json) => MethodologyStep(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
    type: MethodologyStepType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => MethodologyStepType.command,
    ),
    orderIndex: json['orderIndex'] ?? 0,
    command: json['command'] ?? '',
    commandVariants: (json['commandVariants'] as List<dynamic>?)
        ?.map((v) => CommandVariant.fromJson(v))
        .toList() ?? [],
    expectedOutputs: (json['expectedOutputs'] as List<dynamic>?)
        ?.map((o) => ExpectedOutput.fromJson(o))
        .toList() ?? [],
    assetDiscoveryRules: (json['assetDiscoveryRules'] as List<dynamic>?)
        ?.map((r) => AssetDiscoveryRule.fromJson(r))
        .toList() ?? [],
    parameters: Map<String, dynamic>.from(json['parameters'] ?? {}),
    timeout: json['timeout'] != null ? Duration(seconds: json['timeout']) : null,
  );
}

enum MethodologyStepType {
  command,
  manual,
  script,
  validation;

  String get displayName {
    switch (this) {
      case MethodologyStepType.command:
        return 'Command';
      case MethodologyStepType.manual:
        return 'Manual';
      case MethodologyStepType.script:
        return 'Script';
      case MethodologyStepType.validation:
        return 'Validation';
    }
  }
}

class CommandVariant {
  final String condition;
  final String command;
  final String description;

  const CommandVariant({
    required this.condition,
    required this.command,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'condition': condition,
    'command': command,
    'description': description,
  };

  factory CommandVariant.fromJson(Map<String, dynamic> json) => CommandVariant(
    condition: json['condition'] ?? '',
    command: json['command'] ?? '',
    description: json['description'] ?? '',
  );
}

class ExpectedOutput {
  final String type;
  final String parser;
  final List<String> successIndicators;
  final List<String> failureIndicators;

  const ExpectedOutput({
    required this.type,
    required this.parser,
    this.successIndicators = const [],
    this.failureIndicators = const [],
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'parser': parser,
    'successIndicators': successIndicators,
    'failureIndicators': failureIndicators,
  };

  factory ExpectedOutput.fromJson(Map<String, dynamic> json) => ExpectedOutput(
    type: json['type'] ?? '',
    parser: json['parser'] ?? '',
    successIndicators: List<String>.from(json['successIndicators'] ?? []),
    failureIndicators: List<String>.from(json['failureIndicators'] ?? []),
  );
}

class AssetDiscoveryRule {
  final String pattern;
  final String assetType;
  final double confidence;
  final Map<String, dynamic> metadata;

  const AssetDiscoveryRule({
    required this.pattern,
    required this.assetType,
    this.confidence = 0.8,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
    'pattern': pattern,
    'assetType': assetType,
    'confidence': confidence,
    'metadata': metadata,
  };

  factory AssetDiscoveryRule.fromJson(Map<String, dynamic> json) => AssetDiscoveryRule(
    pattern: json['pattern'] ?? '',
    assetType: json['assetType'] ?? '',
    confidence: (json['confidence'] ?? 0.8).toDouble(),
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
  );
}

class SuppressionOption {
  final String scope;
  final String description;
  final List<String> conditions;

  const SuppressionOption({
    required this.scope,
    required this.description,
    this.conditions = const [],
  });

  Map<String, dynamic> toJson() => {
    'scope': scope,
    'description': description,
    'conditions': conditions,
  };

  factory SuppressionOption.fromJson(Map<String, dynamic> json) => SuppressionOption(
    scope: json['scope'] ?? '',
    description: json['description'] ?? '',
    conditions: List<String>.from(json['conditions'] ?? []),
  );
}