import 'package:flutter/material.dart';

enum ProjectStatus {
  planning,
  active,
  onHold,
  completed,
  archived;

  String get displayName {
    switch (this) {
      case ProjectStatus.planning:
        return 'Planning';
      case ProjectStatus.active:
        return 'Active';
      case ProjectStatus.onHold:
        return 'On Hold';
      case ProjectStatus.completed:
        return 'Completed';
      case ProjectStatus.archived:
        return 'Archived';
    }
  }

  Color get color {
    switch (this) {
      case ProjectStatus.planning:
        return Colors.orange;
      case ProjectStatus.active:
        return Colors.green;
      case ProjectStatus.onHold:
        return Colors.grey;
      case ProjectStatus.completed:
        return Colors.blue;
      case ProjectStatus.archived:
        return Colors.grey;
    }
  }

  static ProjectStatus fromString(String status) {
    return ProjectStatus.values.firstWhere(
      (e) => e.displayName == status,
      orElse: () => ProjectStatus.planning,
    );
  }
}

class Project {
  final String id;
  final String name;
  final String reference;
  final String clientName;
  final String projectType;
  final ProjectStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final String? contactPerson;
  final String? contactEmail;
  final String? description;
  final String constraints;
  final List<String> rules;
  final String scope;
  final Map<String, bool> assessmentScope;
  final DateTime createdDate;
  final DateTime updatedDate;

  const Project({
    required this.id,
    required this.name,
    required this.reference,
    required this.clientName,
    required this.projectType,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.contactPerson,
    this.contactEmail,
    this.description,
    required this.constraints,
    required this.rules,
    required this.scope,
    required this.assessmentScope,
    required this.createdDate,
    required this.updatedDate,
  });

  Project copyWith({
    String? id,
    String? name,
    String? reference,
    String? clientName,
    String? projectType,
    ProjectStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? contactPerson,
    String? contactEmail,
    String? description,
    String? constraints,
    List<String>? rules,
    String? scope,
    Map<String, bool>? assessmentScope,
    DateTime? createdDate,
    DateTime? updatedDate,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      reference: reference ?? this.reference,
      clientName: clientName ?? this.clientName,
      projectType: projectType ?? this.projectType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      contactPerson: contactPerson ?? this.contactPerson,
      contactEmail: contactEmail ?? this.contactEmail,
      description: description ?? this.description,
      constraints: constraints ?? this.constraints,
      rules: rules ?? this.rules,
      scope: scope ?? this.scope,
      assessmentScope: assessmentScope ?? this.assessmentScope,
      createdDate: createdDate ?? this.createdDate,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'reference': reference,
      'client_name': clientName,
      'project_type': projectType,
      'status': status.displayName,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'contact_person': contactPerson,
      'contact_email': contactEmail,
      'description': description,
      'constraints': constraints,
      'rules': rules.join('|'),
      'scope': scope,
      'assessment_scope': _encodeAssessmentScope(assessmentScope),
      'created_date': createdDate.toIso8601String(),
      'updated_date': updatedDate.toIso8601String(),
    };
  }

  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      reference: map['reference'] ?? '',
      clientName: map['client_name'] ?? '',
      projectType: map['project_type'] ?? '',
      status: ProjectStatus.fromString(map['status'] ?? 'Planning'),
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      contactPerson: map['contact_person'],
      contactEmail: map['contact_email'],
      description: map['description'],
      constraints: map['constraints'] ?? '',
      rules: (map['rules'] ?? '').isEmpty ? <String>[] : (map['rules'] as String).split('|'),
      scope: map['scope'] ?? '',
      assessmentScope: _decodeAssessmentScope(map['assessment_scope'] ?? ''),
      createdDate: DateTime.parse(map['created_date']),
      updatedDate: DateTime.parse(map['updated_date']),
    );
  }

  static String _encodeAssessmentScope(Map<String, bool> scope) {
    return scope.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .join(',');
  }

  static Map<String, bool> _decodeAssessmentScope(String encoded) {
    if (encoded.isEmpty) return {};
    
    final scopeItems = encoded.split(',');
    return {
      'physicalAccess': scopeItems.contains('physicalAccess'),
      'remoteAccess': scopeItems.contains('remoteAccess'),
      'wirelessAssessment': scopeItems.contains('wirelessAssessment'),
      'socialEngineering': scopeItems.contains('socialEngineering'),
    };
  }

  bool get isOverdue {
    return DateTime.now().isAfter(endDate) && status != ProjectStatus.completed;
  }

  double get progress {
    if (status == ProjectStatus.completed) return 1.0;
    if (status == ProjectStatus.planning) return 0.1;
    if (status == ProjectStatus.active) {
      // Calculate progress based on time elapsed
      final totalDuration = endDate.difference(startDate).inDays;
      final elapsed = DateTime.now().difference(startDate).inDays;
      return (elapsed / totalDuration).clamp(0.0, 0.9);
    }
    return 0.5; // On hold or other statuses
  }

  String get dateRange {
    final start = '${startDate.day}/${startDate.month}/${startDate.year}';
    final end = '${endDate.day}/${endDate.month}/${endDate.year}';
    return '$start - $end';
  }

  IconData get icon {
    switch (projectType.toLowerCase()) {
      case 'internal network assessment':
        return Icons.router;
      case 'external network assessment':
        return Icons.public;
      case 'web application assessment':
        return Icons.web;
      case 'mobile application assessment':
        return Icons.phone_android;
      case 'wireless assessment':
        return Icons.wifi;
      case 'social engineering assessment':
        return Icons.people;
      case 'physical assessment':
        return Icons.security;
      case 'red team exercise':
        return Icons.bug_report;
      case 'vulnerability assessment':
        return Icons.shield;
      case 'compliance assessment':
        return Icons.verified_user;
      default:
        return Icons.assignment;
    }
  }

  Color get themeColor {
    switch (projectType.toLowerCase()) {
      case 'internal network assessment':
        return Colors.blue;
      case 'external network assessment':
        return Colors.green;
      case 'web application assessment':
        return Colors.orange;
      case 'mobile application assessment':
        return Colors.purple;
      case 'wireless assessment':
        return Colors.teal;
      case 'social engineering assessment':
        return Colors.red;
      case 'physical assessment':
        return Colors.brown;
      case 'red team exercise':
        return Colors.deepOrange;
      case 'vulnerability assessment':
        return Colors.indigo;
      case 'compliance assessment':
        return Colors.cyan;
      default:
        return Colors.grey;
    }
  }

  // Legacy compatibility
  bool get hasTransferLink => false;
  String? get transferLink => null;
  String? get transferWorkspaceName => null;
  DateTime get dateCreated => createdDate;
  DateTime get dateModified => updatedDate;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Project && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Project{id: $id, name: $name, client: $clientName}';
  }
}

class ProjectStatistics {
  final String projectId;
  final int totalFindings;
  final int criticalIssues;
  final int screenshots;
  final int attackChains;
  final DateTime updatedDate;

  const ProjectStatistics({
    required this.projectId,
    required this.totalFindings,
    required this.criticalIssues,
    required this.screenshots,
    required this.attackChains,
    required this.updatedDate,
  });

  ProjectStatistics copyWith({
    String? projectId,
    int? totalFindings,
    int? criticalIssues,
    int? screenshots,
    int? attackChains,
    DateTime? updatedDate,
  }) {
    return ProjectStatistics(
      projectId: projectId ?? this.projectId,
      totalFindings: totalFindings ?? this.totalFindings,
      criticalIssues: criticalIssues ?? this.criticalIssues,
      screenshots: screenshots ?? this.screenshots,
      attackChains: attackChains ?? this.attackChains,
      updatedDate: updatedDate ?? this.updatedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'project_id': projectId,
      'total_findings': totalFindings,
      'critical_issues': criticalIssues,
      'screenshots': screenshots,
      'attack_chains': attackChains,
      'updated_date': updatedDate.toIso8601String(),
    };
  }

  factory ProjectStatistics.fromMap(Map<String, dynamic> map) {
    return ProjectStatistics(
      projectId: map['project_id'] ?? '',
      totalFindings: map['total_findings'] ?? 0,
      criticalIssues: map['critical_issues'] ?? 0,
      screenshots: map['screenshots'] ?? 0,
      attackChains: map['attack_chains'] ?? 0,
      updatedDate: DateTime.parse(map['updated_date']),
    );
  }

  static ProjectStatistics empty(String projectId) {
    return ProjectStatistics(
      projectId: projectId,
      totalFindings: 0,
      criticalIssues: 0,
      screenshots: 0,
      attackChains: 0,
      updatedDate: DateTime.now(),
    );
  }
}