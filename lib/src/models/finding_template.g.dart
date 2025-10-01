// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finding_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FindingTemplate _$FindingTemplateFromJson(Map<String, dynamic> json) =>
    _FindingTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      descriptionTemplate: json['descriptionTemplate'] as String,
      remediationTemplate: json['remediationTemplate'] as String,
      defaultSeverity: json['defaultSeverity'] as String?,
      defaultCvssScore: json['defaultCvssScore'] as String?,
      defaultCweId: json['defaultCweId'] as String?,
      variables:
          (json['variables'] as List<dynamic>?)
              ?.map((e) => TemplateVariable.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      customFields:
          (json['customFields'] as List<dynamic>?)
              ?.map((e) => CustomField.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isCustom: json['isCustom'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$FindingTemplateToJson(_FindingTemplate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category,
      'descriptionTemplate': instance.descriptionTemplate,
      'remediationTemplate': instance.remediationTemplate,
      'defaultSeverity': instance.defaultSeverity,
      'defaultCvssScore': instance.defaultCvssScore,
      'defaultCweId': instance.defaultCweId,
      'variables': instance.variables,
      'customFields': instance.customFields,
      'isCustom': instance.isCustom,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_TemplateVariable _$TemplateVariableFromJson(Map<String, dynamic> json) =>
    _TemplateVariable(
      name: json['name'] as String,
      label: json['label'] as String,
      type: $enumDecode(_$VariableTypeEnumMap, json['type']),
      defaultValue: json['defaultValue'] as String?,
      placeholder: json['placeholder'] as String?,
      required: json['required'] as bool? ?? false,
      options: (json['options'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TemplateVariableToJson(_TemplateVariable instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'type': _$VariableTypeEnumMap[instance.type]!,
      'defaultValue': instance.defaultValue,
      'placeholder': instance.placeholder,
      'required': instance.required,
      'options': instance.options,
    };

const _$VariableTypeEnumMap = {
  VariableType.text: 'text',
  VariableType.multiline: 'multiline',
  VariableType.number: 'number',
  VariableType.date: 'date',
  VariableType.dropdown: 'dropdown',
  VariableType.ipAddress: 'ipAddress',
  VariableType.url: 'url',
};

_CustomField _$CustomFieldFromJson(Map<String, dynamic> json) => _CustomField(
  name: json['name'] as String,
  label: json['label'] as String,
  type: $enumDecode(_$CustomFieldTypeEnumMap, json['type']),
  defaultValue: json['defaultValue'] as String?,
  required: json['required'] as bool? ?? false,
  options: (json['options'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$CustomFieldToJson(_CustomField instance) =>
    <String, dynamic>{
      'name': instance.name,
      'label': instance.label,
      'type': _$CustomFieldTypeEnumMap[instance.type]!,
      'defaultValue': instance.defaultValue,
      'required': instance.required,
      'options': instance.options,
    };

const _$CustomFieldTypeEnumMap = {
  CustomFieldType.text: 'text',
  CustomFieldType.number: 'number',
  CustomFieldType.date: 'date',
  CustomFieldType.checkbox: 'checkbox',
  CustomFieldType.dropdown: 'dropdown',
};
