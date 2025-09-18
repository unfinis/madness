import 'package:flutter/material.dart';

class Finding {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final double cvssScore;
  final String? cvssVector;
  final FindingSeverity severity;
  final FindingStatus status;
  final String? auditSteps;
  final String? automatedScript;
  final String? furtherReading;
  final String? verificationProcedure;
  final int orderIndex;
  final DateTime createdDate;
  final DateTime updatedDate;

  // Sub-finding support
  final bool isMainFinding;
  final String? parentFindingId; // If this is a sub-finding, reference to main finding
  final List<SubFindingData> subFindings; // If this is a main finding, list of sub-findings
  
  // Related data
  final List<FindingComponent> components;
  final List<FindingLink> links;
  final List<String> screenshotIds; // References to screenshot IDs

  Finding({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.cvssScore,
    this.cvssVector,
    required this.severity,
    required this.status,
    this.auditSteps,
    this.automatedScript,
    this.furtherReading,
    this.verificationProcedure,
    this.orderIndex = 0,
    required this.createdDate,
    required this.updatedDate,
    this.isMainFinding = false,
    this.parentFindingId,
    this.subFindings = const [],
    this.components = const [],
    this.links = const [],
    this.screenshotIds = const [],
  });

  // Computed properties
  String get severityDisplay => severity.displayName;
  Color get severityColor => severity.color;
  String get statusDisplay => status.displayName;
  Color get statusColor => status.color;
  bool get isComplete => status == FindingStatus.resolved;
  
  Finding copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    double? cvssScore,
    String? cvssVector,
    FindingSeverity? severity,
    FindingStatus? status,
    String? auditSteps,
    String? automatedScript,
    String? furtherReading,
    String? verificationProcedure,
    int? orderIndex,
    DateTime? createdDate,
    DateTime? updatedDate,
    bool? isMainFinding,
    String? parentFindingId,
    List<SubFindingData>? subFindings,
    List<FindingComponent>? components,
    List<FindingLink>? links,
    List<String>? screenshotIds,
  }) {
    return Finding(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      cvssScore: cvssScore ?? this.cvssScore,
      cvssVector: cvssVector ?? this.cvssVector,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      auditSteps: auditSteps ?? this.auditSteps,
      automatedScript: automatedScript ?? this.automatedScript,
      furtherReading: furtherReading ?? this.furtherReading,
      verificationProcedure: verificationProcedure ?? this.verificationProcedure,
      orderIndex: orderIndex ?? this.orderIndex,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
      isMainFinding: isMainFinding ?? this.isMainFinding,
      parentFindingId: parentFindingId ?? this.parentFindingId,
      subFindings: subFindings ?? this.subFindings,
      components: components ?? this.components,
      links: links ?? this.links,
      screenshotIds: screenshotIds ?? this.screenshotIds,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'title': title,
    'description': description,
    'cvssScore': cvssScore,
    'cvssVector': cvssVector,
    'severity': severity.name,
    'status': status.name,
    'auditSteps': auditSteps,
    'automatedScript': automatedScript,
    'furtherReading': furtherReading,
    'verificationProcedure': verificationProcedure,
    'orderIndex': orderIndex,
    'createdDate': createdDate.toIso8601String(),
    'updatedDate': updatedDate.toIso8601String(),
    'isMainFinding': isMainFinding,
    'parentFindingId': parentFindingId,
    'subFindings': subFindings.map((sf) => sf.toJson()).toList(),
    'components': components.map((c) => c.toJson()).toList(),
    'links': links.map((l) => l.toJson()).toList(),
    'screenshotIds': screenshotIds,
  };

  factory Finding.fromJson(Map<String, dynamic> json) => Finding(
    id: json['id'] ?? '',
    projectId: json['projectId'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    cvssScore: (json['cvssScore'] ?? 0.0).toDouble(),
    cvssVector: json['cvssVector'],
    severity: FindingSeverity.values.firstWhere(
      (s) => s.name == json['severity'],
      orElse: () => FindingSeverity.info,
    ),
    status: FindingStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => FindingStatus.draft,
    ),
    auditSteps: json['auditSteps'],
    automatedScript: json['automatedScript'],
    furtherReading: json['furtherReading'],
    verificationProcedure: json['verificationProcedure'],
    orderIndex: json['orderIndex'] ?? 0,
    createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
    updatedDate: DateTime.tryParse(json['updatedDate'] ?? '') ?? DateTime.now(),
    isMainFinding: json['isMainFinding'] ?? false,
    parentFindingId: json['parentFindingId'],
    subFindings: (json['subFindings'] as List<dynamic>?)
        ?.map((sf) => SubFindingData.fromJson(sf))
        .toList() ?? [],
    components: (json['components'] as List<dynamic>?)
        ?.map((c) => FindingComponent.fromJson(c))
        .toList() ?? [],
    links: (json['links'] as List<dynamic>?)
        ?.map((l) => FindingLink.fromJson(l))
        .toList() ?? [],
    screenshotIds: List<String>.from(json['screenshotIds'] ?? []),
  );
}

enum FindingSeverity {
  critical,
  high,
  medium,
  low,
  info;

  String get displayName {
    switch (this) {
      case FindingSeverity.critical:
        return 'Critical';
      case FindingSeverity.high:
        return 'High';
      case FindingSeverity.medium:
        return 'Medium';
      case FindingSeverity.low:
        return 'Low';
      case FindingSeverity.info:
        return 'Info';
    }
  }

  Color get color {
    switch (this) {
      case FindingSeverity.critical:
        return const Color(0xFFef4444); // --danger
      case FindingSeverity.high:
        return const Color(0xFFf59e0b); // --warning
      case FindingSeverity.medium:
        return const Color(0xFFfbbf24);
      case FindingSeverity.low:
        return const Color(0xFF10b981); // --success
      case FindingSeverity.info:
        return const Color(0xFF6b7280);
    }
  }

  static FindingSeverity fromScore(double score) {
    if (score >= 9.0) return FindingSeverity.critical;
    if (score >= 7.0) return FindingSeverity.high;
    if (score >= 4.0) return FindingSeverity.medium;
    if (score >= 0.1) return FindingSeverity.low;
    return FindingSeverity.info;
  }
}

enum FindingStatus {
  draft,
  active,
  resolved,
  falsePositive;

  String get displayName {
    switch (this) {
      case FindingStatus.draft:
        return 'Draft';
      case FindingStatus.active:
        return 'Active';
      case FindingStatus.resolved:
        return 'Resolved';
      case FindingStatus.falsePositive:
        return 'False Positive';
    }
  }

  Color get color {
    switch (this) {
      case FindingStatus.draft:
        return const Color(0xFF6b7280);
      case FindingStatus.active:
        return const Color(0xFFef4444);
      case FindingStatus.resolved:
        return const Color(0xFF10b981);
      case FindingStatus.falsePositive:
        return const Color(0xFF3b82f6);
    }
  }
}

class FindingComponent {
  final String id;
  final String findingId;
  final ComponentType type;
  final String name;
  final String value;
  final String? description;
  final int orderIndex;
  final DateTime createdDate;

  FindingComponent({
    required this.id,
    required this.findingId,
    required this.type,
    required this.name,
    required this.value,
    this.description,
    this.orderIndex = 0,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'findingId': findingId,
    'type': type.name,
    'name': name,
    'value': value,
    'description': description,
    'orderIndex': orderIndex,
    'createdDate': createdDate.toIso8601String(),
  };

  factory FindingComponent.fromJson(Map<String, dynamic> json) => FindingComponent(
    id: json['id'] ?? '',
    findingId: json['findingId'] ?? '',
    type: ComponentType.values.firstWhere(
      (t) => t.name == json['type'],
      orElse: () => ComponentType.other,
    ),
    name: json['name'] ?? '',
    value: json['value'] ?? '',
    description: json['description'],
    orderIndex: json['orderIndex'] ?? 0,
    createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
  );
}

enum ComponentType {
  hostname,
  ipAddress,
  url,
  port,
  service,
  parameter,
  path,
  other;

  String get displayName {
    switch (this) {
      case ComponentType.hostname:
        return 'Hostname';
      case ComponentType.ipAddress:
        return 'IP Address';
      case ComponentType.url:
        return 'URL';
      case ComponentType.port:
        return 'Port';
      case ComponentType.service:
        return 'Service';
      case ComponentType.parameter:
        return 'Parameter';
      case ComponentType.path:
        return 'Path';
      case ComponentType.other:
        return 'Other';
    }
  }
}

class FindingLink {
  final String id;
  final String findingId;
  final String title;
  final String url;
  final int orderIndex;
  final DateTime createdDate;

  FindingLink({
    required this.id,
    required this.findingId,
    required this.title,
    required this.url,
    this.orderIndex = 0,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'findingId': findingId,
    'title': title,
    'url': url,
    'orderIndex': orderIndex,
    'createdDate': createdDate.toIso8601String(),
  };

  factory FindingLink.fromJson(Map<String, dynamic> json) => FindingLink(
    id: json['id'] ?? '',
    findingId: json['findingId'] ?? '',
    title: json['title'] ?? '',
    url: json['url'] ?? '',
    orderIndex: json['orderIndex'] ?? 0,
    createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
  );
}

// Filter and sort configurations
class FindingFilters {
  final List<FindingSeverity> severities;
  final List<FindingStatus> statuses;
  final double? minCvssScore;
  final double? maxCvssScore;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? searchQuery;

  const FindingFilters({
    this.severities = const [],
    this.statuses = const [],
    this.minCvssScore,
    this.maxCvssScore,
    this.startDate,
    this.endDate,
    this.searchQuery,
  });

  FindingFilters copyWith({
    List<FindingSeverity>? severities,
    List<FindingStatus>? statuses,
    double? minCvssScore,
    double? maxCvssScore,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) {
    return FindingFilters(
      severities: severities ?? this.severities,
      statuses: statuses ?? this.statuses,
      minCvssScore: minCvssScore ?? this.minCvssScore,
      maxCvssScore: maxCvssScore ?? this.maxCvssScore,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get hasActiveFilters =>
      severities.isNotEmpty ||
      statuses.isNotEmpty ||
      minCvssScore != null ||
      maxCvssScore != null ||
      startDate != null ||
      endDate != null ||
      (searchQuery != null && searchQuery!.isNotEmpty);
}

class FindingSortConfig {
  final FindingSortField field;
  final SortDirection direction;

  const FindingSortConfig({
    this.field = FindingSortField.updatedDate,
    this.direction = SortDirection.desc,
  });

  FindingSortConfig copyWith({
    FindingSortField? field,
    SortDirection? direction,
  }) {
    return FindingSortConfig(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }
}

enum FindingSortField {
  title,
  severity,
  cvssScore,
  status,
  createdDate,
  updatedDate;

  String get displayName {
    switch (this) {
      case FindingSortField.title:
        return 'Title';
      case FindingSortField.severity:
        return 'Severity';
      case FindingSortField.cvssScore:
        return 'CVSS Score';
      case FindingSortField.status:
        return 'Status';
      case FindingSortField.createdDate:
        return 'Created Date';
      case FindingSortField.updatedDate:
        return 'Updated Date';
    }
  }
}

enum SortDirection {
  asc,
  desc;

  String get displayName {
    switch (this) {
      case SortDirection.asc:
        return 'Ascending';
      case SortDirection.desc:
        return 'Descending';
    }
  }
}

// Summary statistics
class FindingSummaryStats {
  final int totalFindings;
  final int criticalCount;
  final int highCount;
  final int mediumCount;
  final int lowCount;
  final int infoCount;
  final double highestCvssScore;
  final int resolvedCount;
  final int activeCount;

  FindingSummaryStats({
    required this.totalFindings,
    required this.criticalCount,
    required this.highCount,
    required this.mediumCount,
    required this.lowCount,
    required this.infoCount,
    required this.highestCvssScore,
    required this.resolvedCount,
    required this.activeCount,
  });

  factory FindingSummaryStats.fromFindings(List<Finding> findings) {
    final severityCounts = <FindingSeverity, int>{};
    final statusCounts = <FindingStatus, int>{};
    double highestScore = 0.0;

    for (final finding in findings) {
      severityCounts[finding.severity] = (severityCounts[finding.severity] ?? 0) + 1;
      statusCounts[finding.status] = (statusCounts[finding.status] ?? 0) + 1;
      if (finding.cvssScore > highestScore) {
        highestScore = finding.cvssScore;
      }
    }

    return FindingSummaryStats(
      totalFindings: findings.length,
      criticalCount: severityCounts[FindingSeverity.critical] ?? 0,
      highCount: severityCounts[FindingSeverity.high] ?? 0,
      mediumCount: severityCounts[FindingSeverity.medium] ?? 0,
      lowCount: severityCounts[FindingSeverity.low] ?? 0,
      infoCount: severityCounts[FindingSeverity.info] ?? 0,
      highestCvssScore: highestScore,
      resolvedCount: statusCounts[FindingStatus.resolved] ?? 0,
      activeCount: statusCounts[FindingStatus.active] ?? 0,
    );
  }
}

// Sub-finding data class for hierarchical findings
class SubFindingData {
  final String id;
  final String title;
  final String description;
  final double cvssScore;
  final String? cvssVector;
  final FindingSeverity severity;
  final String? checkSteps;
  final String? recommendation;
  final String? verificationProcedure;
  final List<FindingLink> links;
  final List<String> screenshotIds;

  const SubFindingData({
    required this.id,
    required this.title,
    required this.description,
    required this.cvssScore,
    this.cvssVector,
    required this.severity,
    this.checkSteps,
    this.recommendation,
    this.verificationProcedure,
    this.links = const [],
    this.screenshotIds = const [],
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'cvssScore': cvssScore,
    'cvssVector': cvssVector,
    'severity': severity.name,
    'checkSteps': checkSteps,
    'recommendation': recommendation,
    'verificationProcedure': verificationProcedure,
    'links': links.map((l) => l.toJson()).toList(),
    'screenshotIds': screenshotIds,
  };

  factory SubFindingData.fromJson(Map<String, dynamic> json) => SubFindingData(
    id: json['id'] ?? '',
    title: json['title'] ?? '',
    description: json['description'] ?? '',
    cvssScore: (json['cvssScore'] ?? 0.0).toDouble(),
    cvssVector: json['cvssVector'],
    severity: FindingSeverity.values.firstWhere(
      (s) => s.name == json['severity'],
      orElse: () => FindingSeverity.info,
    ),
    checkSteps: json['checkSteps'],
    recommendation: json['recommendation'],
    verificationProcedure: json['verificationProcedure'],
    links: (json['links'] as List<dynamic>?)
        ?.map((l) => FindingLink.fromJson(l))
        .toList() ?? [],
    screenshotIds: List<String>.from(json['screenshotIds'] ?? []),
  );
}