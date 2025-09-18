import 'package:flutter/material.dart';

class MethodologyExecution {
  final String id;
  final String methodologyId;
  final String projectId;
  final ExecutionStatus status;
  final int currentStepIndex;
  final double progress;
  final DateTime startedDate;
  final DateTime? completedDate;
  final List<StepExecution> stepExecutions;
  final List<String> discoveredAssetIds;
  final Map<String, dynamic> executionContext;
  final String? suppressionReason;
  final String? errorMessage;

  const MethodologyExecution({
    required this.id,
    required this.methodologyId,
    required this.projectId,
    required this.status,
    this.currentStepIndex = 0,
    this.progress = 0.0,
    required this.startedDate,
    this.completedDate,
    this.stepExecutions = const [],
    this.discoveredAssetIds = const [],
    this.executionContext = const {},
    this.suppressionReason,
    this.errorMessage,
  });

  bool get isCompleted => status == ExecutionStatus.completed;
  bool get isFailed => status == ExecutionStatus.failed;
  bool get isInProgress => status == ExecutionStatus.inProgress;
  bool get isSuppressed => status == ExecutionStatus.suppressed;

  MethodologyExecution copyWith({
    String? id,
    String? methodologyId,
    String? projectId,
    ExecutionStatus? status,
    int? currentStepIndex,
    double? progress,
    DateTime? startedDate,
    DateTime? completedDate,
    List<StepExecution>? stepExecutions,
    List<String>? discoveredAssetIds,
    Map<String, dynamic>? executionContext,
    String? suppressionReason,
    String? errorMessage,
  }) {
    return MethodologyExecution(
      id: id ?? this.id,
      methodologyId: methodologyId ?? this.methodologyId,
      projectId: projectId ?? this.projectId,
      status: status ?? this.status,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      progress: progress ?? this.progress,
      startedDate: startedDate ?? this.startedDate,
      completedDate: completedDate ?? this.completedDate,
      stepExecutions: stepExecutions ?? this.stepExecutions,
      discoveredAssetIds: discoveredAssetIds ?? this.discoveredAssetIds,
      executionContext: executionContext ?? this.executionContext,
      suppressionReason: suppressionReason ?? this.suppressionReason,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'methodologyId': methodologyId,
    'projectId': projectId,
    'status': status.name,
    'currentStepIndex': currentStepIndex,
    'progress': progress,
    'startedDate': startedDate.toIso8601String(),
    'completedDate': completedDate?.toIso8601String(),
    'stepExecutions': stepExecutions.map((s) => s.toJson()).toList(),
    'discoveredAssetIds': discoveredAssetIds,
    'executionContext': executionContext,
    'suppressionReason': suppressionReason,
    'errorMessage': errorMessage,
  };

  factory MethodologyExecution.fromJson(Map<String, dynamic> json) => MethodologyExecution(
    id: json['id'] ?? '',
    methodologyId: json['methodologyId'] ?? '',
    projectId: json['projectId'] ?? '',
    status: ExecutionStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => ExecutionStatus.pending,
    ),
    currentStepIndex: json['currentStepIndex'] ?? 0,
    progress: (json['progress'] ?? 0.0).toDouble(),
    startedDate: DateTime.tryParse(json['startedDate'] ?? '') ?? DateTime.now(),
    completedDate: json['completedDate'] != null 
        ? DateTime.tryParse(json['completedDate']) 
        : null,
    stepExecutions: (json['stepExecutions'] as List<dynamic>?)
        ?.map((s) => StepExecution.fromJson(s))
        .toList() ?? [],
    discoveredAssetIds: List<String>.from(json['discoveredAssetIds'] ?? []),
    executionContext: Map<String, dynamic>.from(json['executionContext'] ?? {}),
    suppressionReason: json['suppressionReason'],
    errorMessage: json['errorMessage'],
  );
}

enum ExecutionStatus {
  pending,
  inProgress,
  completed,
  failed,
  suppressed,
  blocked;

  String get displayName {
    switch (this) {
      case ExecutionStatus.pending:
        return 'Pending';
      case ExecutionStatus.inProgress:
        return 'In Progress';
      case ExecutionStatus.completed:
        return 'Completed';
      case ExecutionStatus.failed:
        return 'Failed';
      case ExecutionStatus.suppressed:
        return 'Suppressed';
      case ExecutionStatus.blocked:
        return 'Blocked';
    }
  }

  String get icon {
    switch (this) {
      case ExecutionStatus.pending:
        return '⏳';
      case ExecutionStatus.inProgress:
        return '🔄';
      case ExecutionStatus.completed:
        return '✅';
      case ExecutionStatus.failed:
        return '❌';
      case ExecutionStatus.suppressed:
        return '🚫';
      case ExecutionStatus.blocked:
        return '🚧';
    }
  }

  Color get color {
    switch (this) {
      case ExecutionStatus.pending:
        return const Color(0xFF6b7280);
      case ExecutionStatus.inProgress:
        return const Color(0xFF3b82f6);
      case ExecutionStatus.completed:
        return const Color(0xFF10b981);
      case ExecutionStatus.failed:
        return const Color(0xFFef4444);
      case ExecutionStatus.suppressed:
        return const Color(0xFF8b5cf6);
      case ExecutionStatus.blocked:
        return const Color(0xFFf59e0b);
    }
  }
}

class StepExecution {
  final String id;
  final String stepId;
  final String executionId;
  final ExecutionStatus status;
  final String command;
  final String? output;
  final String? errorOutput;
  final int exitCode;
  final DateTime startedDate;
  final DateTime? completedDate;
  final List<String> discoveredAssetIds;
  final Map<String, dynamic> metadata;

  const StepExecution({
    required this.id,
    required this.stepId,
    required this.executionId,
    required this.status,
    required this.command,
    this.output,
    this.errorOutput,
    this.exitCode = 0,
    required this.startedDate,
    this.completedDate,
    this.discoveredAssetIds = const [],
    this.metadata = const {},
  });

  bool get isSuccessful => status == ExecutionStatus.completed && exitCode == 0;
  Duration get duration => (completedDate ?? DateTime.now()).difference(startedDate);

  StepExecution copyWith({
    String? id,
    String? stepId,
    String? executionId,
    ExecutionStatus? status,
    String? command,
    String? output,
    String? errorOutput,
    int? exitCode,
    DateTime? startedDate,
    DateTime? completedDate,
    List<String>? discoveredAssetIds,
    Map<String, dynamic>? metadata,
  }) {
    return StepExecution(
      id: id ?? this.id,
      stepId: stepId ?? this.stepId,
      executionId: executionId ?? this.executionId,
      status: status ?? this.status,
      command: command ?? this.command,
      output: output ?? this.output,
      errorOutput: errorOutput ?? this.errorOutput,
      exitCode: exitCode ?? this.exitCode,
      startedDate: startedDate ?? this.startedDate,
      completedDate: completedDate ?? this.completedDate,
      discoveredAssetIds: discoveredAssetIds ?? this.discoveredAssetIds,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'stepId': stepId,
    'executionId': executionId,
    'status': status.name,
    'command': command,
    'output': output,
    'errorOutput': errorOutput,
    'exitCode': exitCode,
    'startedDate': startedDate.toIso8601String(),
    'completedDate': completedDate?.toIso8601String(),
    'discoveredAssetIds': discoveredAssetIds,
    'metadata': metadata,
  };

  factory StepExecution.fromJson(Map<String, dynamic> json) => StepExecution(
    id: json['id'] ?? '',
    stepId: json['stepId'] ?? '',
    executionId: json['executionId'] ?? '',
    status: ExecutionStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => ExecutionStatus.pending,
    ),
    command: json['command'] ?? '',
    output: json['output'],
    errorOutput: json['errorOutput'],
    exitCode: json['exitCode'] ?? 0,
    startedDate: DateTime.tryParse(json['startedDate'] ?? '') ?? DateTime.now(),
    completedDate: json['completedDate'] != null 
        ? DateTime.tryParse(json['completedDate']) 
        : null,
    discoveredAssetIds: List<String>.from(json['discoveredAssetIds'] ?? []),
    metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
  );
}

class DiscoveredAsset {
  final String id;
  final String projectId;
  final AssetType type;
  final String name;
  final String value;
  final Map<String, dynamic> properties;
  final double confidence;
  final String? sourceStepId;
  final String? sourceExecutionId;
  final List<String> relatedAssetIds;
  final DateTime discoveredDate;
  final bool isVerified;

  const DiscoveredAsset({
    required this.id,
    required this.projectId,
    required this.type,
    required this.name,
    required this.value,
    this.properties = const {},
    this.confidence = 0.8,
    this.sourceStepId,
    this.sourceExecutionId,
    this.relatedAssetIds = const [],
    required this.discoveredDate,
    this.isVerified = false,
  });

  DiscoveredAsset copyWith({
    String? id,
    String? projectId,
    AssetType? type,
    String? name,
    String? value,
    Map<String, dynamic>? properties,
    double? confidence,
    String? sourceStepId,
    String? sourceExecutionId,
    List<String>? relatedAssetIds,
    DateTime? discoveredDate,
    bool? isVerified,
  }) {
    return DiscoveredAsset(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      type: type ?? this.type,
      name: name ?? this.name,
      value: value ?? this.value,
      properties: properties ?? this.properties,
      confidence: confidence ?? this.confidence,
      sourceStepId: sourceStepId ?? this.sourceStepId,
      sourceExecutionId: sourceExecutionId ?? this.sourceExecutionId,
      relatedAssetIds: relatedAssetIds ?? this.relatedAssetIds,
      discoveredDate: discoveredDate ?? this.discoveredDate,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'type': type.name,
    'name': name,
    'value': value,
    'properties': properties,
    'confidence': confidence,
    'sourceStepId': sourceStepId,
    'sourceExecutionId': sourceExecutionId,
    'relatedAssetIds': relatedAssetIds,
    'discoveredDate': discoveredDate.toIso8601String(),
    'isVerified': isVerified,
  };

  factory DiscoveredAsset.fromJson(Map<String, dynamic> json) => DiscoveredAsset(
    id: json['id'] ?? '',
    projectId: json['projectId'] ?? '',
    type: AssetType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => AssetType.other,
    ),
    name: json['name'] ?? '',
    value: json['value'] ?? '',
    properties: Map<String, dynamic>.from(json['properties'] ?? {}),
    confidence: (json['confidence'] ?? 0.8).toDouble(),
    sourceStepId: json['sourceStepId'],
    sourceExecutionId: json['sourceExecutionId'],
    relatedAssetIds: List<String>.from(json['relatedAssetIds'] ?? []),
    discoveredDate: DateTime.tryParse(json['discoveredDate'] ?? '') ?? DateTime.now(),
    isVerified: json['isVerified'] ?? false,
  );
}

enum AssetType {
  host,
  service,
  credential,
  file,
  url,
  vulnerability,
  network,
  user,
  domain,
  database,
  other;

  String get displayName {
    switch (this) {
      case AssetType.host:
        return 'Host';
      case AssetType.service:
        return 'Service';
      case AssetType.credential:
        return 'Credential';
      case AssetType.file:
        return 'File';
      case AssetType.url:
        return 'URL';
      case AssetType.vulnerability:
        return 'Vulnerability';
      case AssetType.network:
        return 'Network';
      case AssetType.user:
        return 'User';
      case AssetType.domain:
        return 'Domain';
      case AssetType.database:
        return 'Database';
      case AssetType.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case AssetType.host:
        return '🖥️';
      case AssetType.service:
        return '⚙️';
      case AssetType.credential:
        return '🔑';
      case AssetType.file:
        return '📄';
      case AssetType.url:
        return '🔗';
      case AssetType.vulnerability:
        return '🚨';
      case AssetType.network:
        return '🌐';
      case AssetType.user:
        return '👤';
      case AssetType.domain:
        return '🏷️';
      case AssetType.database:
        return '🗄️';
      case AssetType.other:
        return '📦';
    }
  }

  Color get color {
    switch (this) {
      case AssetType.host:
        return const Color(0xFF3b82f6);
      case AssetType.service:
        return const Color(0xFF10b981);
      case AssetType.credential:
        return const Color(0xFFf59e0b);
      case AssetType.file:
        return const Color(0xFF8b5cf6);
      case AssetType.url:
        return const Color(0xFF06b6d4);
      case AssetType.vulnerability:
        return const Color(0xFFef4444);
      case AssetType.network:
        return const Color(0xFF84cc16);
      case AssetType.user:
        return const Color(0xFFec4899);
      case AssetType.domain:
        return const Color(0xFFf97316);
      case AssetType.database:
        return const Color(0xFF6366f1);
      case AssetType.other:
        return const Color(0xFF6b7280);
    }
  }
}

class MethodologyRecommendation {
  final String id;
  final String methodologyId;
  final String projectId;
  final int priority;
  final double confidence;
  final String reason;
  final List<String> triggeringAssetIds;
  final Map<String, dynamic> context;
  final DateTime createdDate;
  final bool isDismissed;

  const MethodologyRecommendation({
    required this.id,
    required this.methodologyId,
    required this.projectId,
    this.priority = 0,
    this.confidence = 0.8,
    required this.reason,
    this.triggeringAssetIds = const [],
    this.context = const {},
    required this.createdDate,
    this.isDismissed = false,
  });

  MethodologyRecommendation copyWith({
    String? id,
    String? methodologyId,
    String? projectId,
    int? priority,
    double? confidence,
    String? reason,
    List<String>? triggeringAssetIds,
    Map<String, dynamic>? context,
    DateTime? createdDate,
    bool? isDismissed,
  }) {
    return MethodologyRecommendation(
      id: id ?? this.id,
      methodologyId: methodologyId ?? this.methodologyId,
      projectId: projectId ?? this.projectId,
      priority: priority ?? this.priority,
      confidence: confidence ?? this.confidence,
      reason: reason ?? this.reason,
      triggeringAssetIds: triggeringAssetIds ?? this.triggeringAssetIds,
      context: context ?? this.context,
      createdDate: createdDate ?? this.createdDate,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'methodologyId': methodologyId,
    'projectId': projectId,
    'priority': priority,
    'confidence': confidence,
    'reason': reason,
    'triggeringAssetIds': triggeringAssetIds,
    'context': context,
    'createdDate': createdDate.toIso8601String(),
    'isDismissed': isDismissed,
  };

  factory MethodologyRecommendation.fromJson(Map<String, dynamic> json) => MethodologyRecommendation(
    id: json['id'] ?? '',
    methodologyId: json['methodologyId'] ?? '',
    projectId: json['projectId'] ?? '',
    priority: json['priority'] ?? 0,
    confidence: (json['confidence'] ?? 0.8).toDouble(),
    reason: json['reason'] ?? '',
    triggeringAssetIds: List<String>.from(json['triggeringAssetIds'] ?? []),
    context: Map<String, dynamic>.from(json['context'] ?? {}),
    createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
    isDismissed: json['isDismissed'] ?? false,
  );
}