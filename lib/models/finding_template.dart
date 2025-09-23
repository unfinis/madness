import 'finding.dart';
class FindingTemplate {
  final String id;
  final String title;
  final String category;
  final String baseDescription;
  final List<SubFinding> subFindings;

  const FindingTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.baseDescription,
    required this.subFindings,
  });

  factory FindingTemplate.fromJson(Map<String, dynamic> json) {
    return FindingTemplate(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      baseDescription: json['baseDescription'] as String,
      subFindings: (json['subFindings'] as List<dynamic>)
          .map((e) => SubFinding.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'baseDescription': baseDescription,
      'subFindings': subFindings.map((e) => e.toJson()).toList(),
    };
  }

  /// Convert this template to a list of Finding objects
  List<Finding> toFindings() {
    return subFindings.map((subFinding) => subFinding.toFinding(
      templateTitle: title,
      templateCategory: category,
    )).toList();
  }
}

class SubFinding {
  final String id;
  final String title;
  final double cvssScore;
  final String cvssVector;
  final String severity;
  final String description;
  final String checkSteps;
  final String recommendation;
  final String? verificationProcedure;
  final List<ScreenshotPlaceholder> screenshotPlaceholders;
  final List<FindingLink> links;

  const SubFinding({
    required this.id,
    required this.title,
    required this.cvssScore,
    required this.cvssVector,
    required this.severity,
    required this.description,
    required this.checkSteps,
    required this.recommendation,
    this.verificationProcedure,
    required this.screenshotPlaceholders,
    required this.links,
  });

  factory SubFinding.fromJson(Map<String, dynamic> json) {
    return SubFinding(
      id: json['id'] as String,
      title: json['title'] as String,
      cvssScore: (json['cvssScore'] as num).toDouble(),
      cvssVector: json['cvssVector'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      checkSteps: json['checkSteps'] as String,
      recommendation: json['recommendation'] as String,
      verificationProcedure: json['verificationProcedure'] as String?,
      screenshotPlaceholders: (json['screenshotPlaceholders'] as List<dynamic>?)
          ?.map((e) => ScreenshotPlaceholder.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => FindingLink.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cvssScore': cvssScore,
      'cvssVector': cvssVector,
      'severity': severity,
      'description': description,
      'checkSteps': checkSteps,
      'recommendation': recommendation,
      'verificationProcedure': verificationProcedure,
      'screenshotPlaceholders': screenshotPlaceholders.map((e) => e.toJson()).toList(),
      'links': links.map((e) => e.toJson()).toList(),
    };
  }

  /// Convert this sub-finding to a Finding object
  Finding toFinding({
    required String templateTitle,
    required String templateCategory,
  }) {
    // Parse severity enum
    FindingSeverity findingSeverity;
    switch (severity.toLowerCase()) {
      case 'critical':
        findingSeverity = FindingSeverity.critical;
        break;
      case 'high':
        findingSeverity = FindingSeverity.high;
        break;
      case 'medium':
        findingSeverity = FindingSeverity.medium;
        break;
      case 'low':
        findingSeverity = FindingSeverity.low;
        break;
      case 'informational':
      case 'info':
        findingSeverity = FindingSeverity.informational;
        break;
      default:
        findingSeverity = FindingSeverity.medium;
    }

    return Finding(
      id: '', // Will be generated when saved
      projectId: '', // Will be set when saved
      title: title,
      description: description,
      severity: findingSeverity,
      status: FindingStatus.draft,
      cvssScore: cvssScore,
      cvssVector: cvssVector,
      auditSteps: checkSteps,
      furtherReading: recommendation,
      verificationProcedure: verificationProcedure,
      components: [],
      links: links,
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      screenshotIds: [],
    );
  }

}

class ScreenshotPlaceholder {
  final String caption;
  final String steps;

  const ScreenshotPlaceholder({
    required this.caption,
    required this.steps,
  });

  factory ScreenshotPlaceholder.fromJson(Map<String, dynamic> json) {
    return ScreenshotPlaceholder(
      caption: json['caption'] as String,
      steps: json['steps'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caption': caption,
      'steps': steps,
    };
  }
}

class TemplateIndex {
  final List<TemplateInfo> templates;
  final String version;
  final String description;

  const TemplateIndex({
    required this.templates,
    required this.version,
    required this.description,
  });

  factory TemplateIndex.fromJson(Map<String, dynamic> json) {
    return TemplateIndex(
      templates: (json['templates'] as List<dynamic>)
          .map((e) => TemplateInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      version: json['version'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'templates': templates.map((e) => e.toJson()).toList(),
      'version': version,
      'description': description,
    };
  }
}

class TemplateInfo {
  final String id;
  final String filename;
  final String title;
  final String category;
  final int findingCount;

  const TemplateInfo({
    required this.id,
    required this.filename,
    required this.title,
    required this.category,
    required this.findingCount,
  });

  factory TemplateInfo.fromJson(Map<String, dynamic> json) {
    return TemplateInfo(
      id: json['id'] as String,
      filename: json['filename'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      findingCount: json['findingCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'title': title,
      'category': category,
      'findingCount': findingCount,
    };
  }
}