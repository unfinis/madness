// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'methodology_trigger_builder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TriggerConditionImpl _$$TriggerConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$TriggerConditionImpl(
      id: json['id'] as String,
      assetType: $enumDecode(_$AssetTypeEnumMap, json['assetType']),
      property: json['property'] as String,
      operator: $enumDecode(_$TriggerOperatorEnumMap, json['operator']),
      value: TriggerValue.fromJson(json['value'] as Map<String, dynamic>),
      logicalOperator: json['logicalOperator'] as String?,
    );

Map<String, dynamic> _$$TriggerConditionImplToJson(
        _$TriggerConditionImpl instance) =>
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

_$StringTriggerValueImpl _$$StringTriggerValueImplFromJson(
        Map<String, dynamic> json) =>
    _$StringTriggerValueImpl(
      json['value'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StringTriggerValueImplToJson(
        _$StringTriggerValueImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$BooleanTriggerValueImpl _$$BooleanTriggerValueImplFromJson(
        Map<String, dynamic> json) =>
    _$BooleanTriggerValueImpl(
      json['value'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BooleanTriggerValueImplToJson(
        _$BooleanTriggerValueImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$NumberTriggerValueImpl _$$NumberTriggerValueImplFromJson(
        Map<String, dynamic> json) =>
    _$NumberTriggerValueImpl(
      (json['value'] as num).toDouble(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NumberTriggerValueImplToJson(
        _$NumberTriggerValueImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$ListTriggerValueImpl _$$ListTriggerValueImplFromJson(
        Map<String, dynamic> json) =>
    _$ListTriggerValueImpl(
      (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ListTriggerValueImplToJson(
        _$ListTriggerValueImpl instance) =>
    <String, dynamic>{
      'values': instance.values,
      'runtimeType': instance.$type,
    };

_$NullTriggerValueImpl _$$NullTriggerValueImplFromJson(
        Map<String, dynamic> json) =>
    _$NullTriggerValueImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NullTriggerValueImplToJson(
        _$NullTriggerValueImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$NotNullTriggerValueImpl _$$NotNullTriggerValueImplFromJson(
        Map<String, dynamic> json) =>
    _$NotNullTriggerValueImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NotNullTriggerValueImplToJson(
        _$NotNullTriggerValueImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$TriggerGroupImpl _$$TriggerGroupImplFromJson(Map<String, dynamic> json) =>
    _$TriggerGroupImpl(
      id: json['id'] as String,
      conditions: (json['conditions'] as List<dynamic>)
          .map((e) => TriggerCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      logicalOperator: json['logicalOperator'] as String? ?? 'AND',
    );

Map<String, dynamic> _$$TriggerGroupImplToJson(_$TriggerGroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conditions': instance.conditions,
      'logicalOperator': instance.logicalOperator,
    };

_$MethodologyTriggerDefinitionImpl _$$MethodologyTriggerDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$MethodologyTriggerDefinitionImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      priority: (json['priority'] as num?)?.toInt() ?? 5,
      enabled: json['enabled'] as bool? ?? true,
      conditionGroups: (json['conditionGroups'] as List<dynamic>)
          .map((e) => TriggerGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupLogicalOperator: json['groupLogicalOperator'] as String? ?? 'AND',
      parameterMappings:
          (json['parameterMappings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      defaultParameters: json['defaultParameters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$MethodologyTriggerDefinitionImplToJson(
        _$MethodologyTriggerDefinitionImpl instance) =>
    <String, dynamic>{
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

_$AssetPropertyImpl _$$AssetPropertyImplFromJson(Map<String, dynamic> json) =>
    _$AssetPropertyImpl(
      name: json['name'] as String,
      displayName: json['displayName'] as String,
      type: $enumDecode(_$PropertyTypeEnumMap, json['type']),
      allowedValues: (json['allowedValues'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$AssetPropertyImplToJson(_$AssetPropertyImpl instance) =>
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

_$TriggerTemplateImpl _$$TriggerTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$TriggerTemplateImpl(
      name: json['name'] as String,
      description: json['description'] as String,
      trigger: MethodologyTriggerDefinition.fromJson(
          json['trigger'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TriggerTemplateImplToJson(
        _$TriggerTemplateImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'trigger': instance.trigger,
    };

_$MethodologyParameterImpl _$$MethodologyParameterImplFromJson(
        Map<String, dynamic> json) =>
    _$MethodologyParameterImpl(
      name: json['name'] as String,
      type: json['type'] as String,
      source: json['source'] as String,
      defaultValue: json['defaultValue'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$MethodologyParameterImplToJson(
        _$MethodologyParameterImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'source': instance.source,
      'defaultValue': instance.defaultValue,
      'description': instance.description,
    };
