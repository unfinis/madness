// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'methodology_trigger_builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TriggerCondition _$TriggerConditionFromJson(Map<String, dynamic> json) =>
    _TriggerCondition(
      id: json['id'] as String,
      assetType: $enumDecode(_$AssetTypeEnumMap, json['assetType']),
      property: json['property'] as String,
      operator: $enumDecode(_$TriggerOperatorEnumMap, json['operator']),
      value: TriggerValue.fromJson(json['value'] as Map<String, dynamic>),
      logicalOperator: json['logicalOperator'] as String?,
    );

Map<String, dynamic> _$TriggerConditionToJson(_TriggerCondition instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetType': _$AssetTypeEnumMap[instance.assetType]!,
      'property': instance.property,
      'operator': _$TriggerOperatorEnumMap[instance.operator]!,
      'value': instance.value,
      'logicalOperator': instance.logicalOperator,
    };

const _$AssetTypeEnumMap = {
  AssetType.networkSegment: 'networkSegment',
  AssetType.host: 'host',
  AssetType.service: 'service',
  AssetType.credential: 'credential',
  AssetType.vulnerability: 'vulnerability',
  AssetType.domain: 'domain',
  AssetType.wireless_network: 'wireless_network',
  AssetType.restrictedEnvironment: 'restrictedEnvironment',
  AssetType.securityControl: 'securityControl',
  AssetType.activeDirectoryDomain: 'activeDirectoryDomain',
  AssetType.domainController: 'domainController',
  AssetType.adUser: 'adUser',
  AssetType.adComputer: 'adComputer',
  AssetType.certificateAuthority: 'certificateAuthority',
  AssetType.certificateTemplate: 'certificateTemplate',
  AssetType.sccmServer: 'sccmServer',
  AssetType.smbShare: 'smbShare',
  AssetType.kerberosTicket: 'kerberosTicket',
  AssetType.azureTenant: 'azureTenant',
  AssetType.azureSubscription: 'azureSubscription',
  AssetType.azureStorageAccount: 'azureStorageAccount',
  AssetType.azureVirtualMachine: 'azureVirtualMachine',
  AssetType.azureKeyVault: 'azureKeyVault',
  AssetType.azureWebApp: 'azureWebApp',
  AssetType.azureFunctionApp: 'azureFunctionApp',
  AssetType.azureDevOpsOrganization: 'azureDevOpsOrganization',
  AssetType.azureSqlDatabase: 'azureSqlDatabase',
  AssetType.azureContainerRegistry: 'azureContainerRegistry',
  AssetType.azureLogicApp: 'azureLogicApp',
  AssetType.azureAutomationAccount: 'azureAutomationAccount',
  AssetType.azureServicePrincipal: 'azureServicePrincipal',
  AssetType.azureManagedIdentity: 'azureManagedIdentity',
};

const _$TriggerOperatorEnumMap = {
  TriggerOperator.equals: 'equals',
  TriggerOperator.notEquals: 'notEquals',
  TriggerOperator.contains: 'contains',
  TriggerOperator.notContains: 'notContains',
  TriggerOperator.startsWith: 'startsWith',
  TriggerOperator.endsWith: 'endsWith',
  TriggerOperator.greaterThan: 'greaterThan',
  TriggerOperator.lessThan: 'lessThan',
  TriggerOperator.greaterThanOrEqual: 'greaterThanOrEqual',
  TriggerOperator.lessThanOrEqual: 'lessThanOrEqual',
  TriggerOperator.in_: 'in_',
  TriggerOperator.notIn: 'notIn',
  TriggerOperator.exists: 'exists',
  TriggerOperator.notExists: 'notExists',
  TriggerOperator.isNull: 'isNull',
  TriggerOperator.isNotNull: 'isNotNull',
  TriggerOperator.regex: 'regex',
  TriggerOperator.notRegex: 'notRegex',
};

StringTriggerValue _$StringTriggerValueFromJson(Map<String, dynamic> json) =>
    StringTriggerValue(
      json['value'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$StringTriggerValueToJson(StringTriggerValue instance) =>
    <String, dynamic>{'value': instance.value, 'runtimeType': instance.$type};

BooleanTriggerValue _$BooleanTriggerValueFromJson(Map<String, dynamic> json) =>
    BooleanTriggerValue(
      json['value'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$BooleanTriggerValueToJson(
  BooleanTriggerValue instance,
) => <String, dynamic>{'value': instance.value, 'runtimeType': instance.$type};

NumberTriggerValue _$NumberTriggerValueFromJson(Map<String, dynamic> json) =>
    NumberTriggerValue(
      (json['value'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$NumberTriggerValueToJson(NumberTriggerValue instance) =>
    <String, dynamic>{'value': instance.value, 'runtimeType': instance.$type};

ListTriggerValue _$ListTriggerValueFromJson(Map<String, dynamic> json) =>
    ListTriggerValue(
      (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$ListTriggerValueToJson(ListTriggerValue instance) =>
    <String, dynamic>{'values': instance.values, 'runtimeType': instance.$type};

NullTriggerValue _$NullTriggerValueFromJson(Map<String, dynamic> json) =>
    NullTriggerValue($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NullTriggerValueToJson(NullTriggerValue instance) =>
    <String, dynamic>{'runtimeType': instance.$type};

NotNullTriggerValue _$NotNullTriggerValueFromJson(Map<String, dynamic> json) =>
    NotNullTriggerValue($type: json['runtimeType'] as String?);

Map<String, dynamic> _$NotNullTriggerValueToJson(
  NotNullTriggerValue instance,
) => <String, dynamic>{'runtimeType': instance.$type};

_TriggerGroup _$TriggerGroupFromJson(Map<String, dynamic> json) =>
    _TriggerGroup(
      id: json['id'] as String,
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => TriggerCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      logicalOperator: json['logicalOperator'] as String? ?? 'AND',
    );

Map<String, dynamic> _$TriggerGroupToJson(_TriggerGroup instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conditions': instance.conditions,
      'logicalOperator': instance.logicalOperator,
    };

_MethodologyTriggerDefinition _$MethodologyTriggerDefinitionFromJson(
  Map<String, dynamic> json,
) => _MethodologyTriggerDefinition(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  priority: (json['priority'] as num?)?.toInt() ?? 5,
  enabled: json['enabled'] as bool? ?? true,
  conditionGroups: (json['conditionGroups'] as List<dynamic>)
      .map((e) => TriggerGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  groupLogicalOperator: json['groupLogicalOperator'] as String? ?? 'AND',
  parameterMappings: (json['parameterMappings'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  defaultParameters: json['defaultParameters'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MethodologyTriggerDefinitionToJson(
  _MethodologyTriggerDefinition instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'priority': instance.priority,
  'enabled': instance.enabled,
  'conditionGroups': instance.conditionGroups,
  'groupLogicalOperator': instance.groupLogicalOperator,
  'parameterMappings': instance.parameterMappings,
  'defaultParameters': instance.defaultParameters,
};

_AssetProperty _$AssetPropertyFromJson(Map<String, dynamic> json) =>
    _AssetProperty(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
      allowedValues: (json['allowedValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$AssetPropertyToJson(_AssetProperty instance) =>
    <String, dynamic>{
      'name': instance.name,
      'displayName': instance.displayName,
      'type': _$PropertyTypeEnumMap[instance.type]!,
      'allowedValues': instance.allowedValues,
      'description': instance.description,
    };

const _$PropertyTypeEnumMap = {
  PropertyType.string: 'string',
  PropertyType.number: 'number',
  PropertyType.boolean: 'boolean',
  PropertyType.list: 'list',
};

_TriggerTemplate _$TriggerTemplateFromJson(Map<String, dynamic> json) =>
    _TriggerTemplate(
      name: json['name'] as String,
      description: json['description'] as String,
      trigger: MethodologyTriggerDefinition.fromJson(
        json['trigger'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$TriggerTemplateToJson(_TriggerTemplate instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'trigger': instance.trigger,
    };

_MethodologyParameter _$MethodologyParameterFromJson(
  Map<String, dynamic> json,
) => _MethodologyParameter(
  name: json['name'] as String,
  type: json['type'] as String,
  source: json['source'] as String,
  defaultValue: json['defaultValue'] as String?,
  description: json['description'] as String?,
);

Map<String, dynamic> _$MethodologyParameterToJson(
  _MethodologyParameter instance,
) => <String, dynamic>{
  'name': instance.name,
  'type': instance.type,
  'source': instance.source,
  'defaultValue': instance.defaultValue,
  'description': instance.description,
};
