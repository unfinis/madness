import 'package:freezed_annotation/freezed_annotation.dart';

part 'finding.freezed.dart';
part 'finding.g.dart';

@freezed
class Finding with _$Finding {
  const factory Finding({
    required String id,
    required String title,
    required String description, // Markdown content
    required FindingSeverity severity,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? cvssScore,
    String? cweId,
    String? affectedSystems,
    String? remediation, // Markdown content
    String? references, // Markdown content
    String? templateId,
    String? masterFindingId, // If this is a sub-finding
    @Default([]) List<String> subFindingIds,
    @Default({}) Map<String, dynamic> customFields,
    @Default([]) List<String> imageIds,
    @Default({}) Map<String, String> variables, // Variable substitutions
    @Default(FindingStatus.draft) FindingStatus status,
  }) = _Finding;

  factory Finding.fromJson(Map<String, dynamic> json) =>
      _$FindingFromJson(json);
}

enum FindingSeverity {
  critical,
  high,
  medium,
  low,
  informational;

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
      case FindingSeverity.informational:
        return 'Informational';
    }
  }

  int get priorityValue {
    switch (this) {
      case FindingSeverity.critical:
        return 5;
      case FindingSeverity.high:
        return 4;
      case FindingSeverity.medium:
        return 3;
      case FindingSeverity.low:
        return 2;
      case FindingSeverity.informational:
        return 1;
    }
  }
}

enum FindingStatus {
  draft,
  review,
  approved,
  published;

  String get displayName {
    switch (this) {
      case FindingStatus.draft:
        return 'Draft';
      case FindingStatus.review:
        return 'In Review';
      case FindingStatus.approved:
        return 'Approved';
      case FindingStatus.published:
        return 'Published';
    }
  }
}
