import 'package:freezed_annotation/freezed_annotation.dart';

part 'finding_template.freezed.dart';
part 'finding_template.g.dart';

@freezed
class FindingTemplate with _$FindingTemplate {
  const factory FindingTemplate({
    required String id,
    required String name,
    required String category,
    required String descriptionTemplate, // Markdown with {{variables}}
    required String remediationTemplate,
    String? defaultSeverity,
    String? defaultCvssScore,
    String? defaultCweId,
    @Default([]) List<TemplateVariable> variables,
    @Default([]) List<CustomField> customFields,
    @Default(false) bool isCustom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _FindingTemplate;

  factory FindingTemplate.fromJson(Map<String, dynamic> json) =>
      _$FindingTemplateFromJson(json);
}

@freezed
class TemplateVariable with _$TemplateVariable {
  const factory TemplateVariable({
    required String name,
    required String label,
    required VariableType type,
    String? defaultValue,
    String? placeholder,
    @Default(false) bool required,
    List<String>? options, // For dropdown type
  }) = _TemplateVariable;

  factory TemplateVariable.fromJson(Map<String, dynamic> json) =>
      _$TemplateVariableFromJson(json);
}

enum VariableType {
  text,
  multiline,
  number,
  date,
  dropdown,
  ipAddress,
  url;

  String get displayName {
    switch (this) {
      case VariableType.text:
        return 'Text';
      case VariableType.multiline:
        return 'Multi-line Text';
      case VariableType.number:
        return 'Number';
      case VariableType.date:
        return 'Date';
      case VariableType.dropdown:
        return 'Dropdown';
      case VariableType.ipAddress:
        return 'IP Address';
      case VariableType.url:
        return 'URL';
    }
  }
}

@freezed
class CustomField with _$CustomField {
  const factory CustomField({
    required String name,
    required String label,
    required CustomFieldType type,
    String? defaultValue,
    @Default(false) bool required,
    List<String>? options, // For dropdown type
  }) = _CustomField;

  factory CustomField.fromJson(Map<String, dynamic> json) =>
      _$CustomFieldFromJson(json);
}

enum CustomFieldType {
  text,
  number,
  date,
  checkbox,
  dropdown;

  String get displayName {
    switch (this) {
      case CustomFieldType.text:
        return 'Text';
      case CustomFieldType.number:
        return 'Number';
      case CustomFieldType.date:
        return 'Date';
      case CustomFieldType.checkbox:
        return 'Checkbox';
      case CustomFieldType.dropdown:
        return 'Dropdown';
    }
  }
}
