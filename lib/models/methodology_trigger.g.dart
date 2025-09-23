// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'methodology_trigger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TriggerConditionImpl _$$TriggerConditionImplFromJson(
        Map<String, dynamic> json) =>
    _$TriggerConditionImpl(
      property: json['property'] as String,
      operator: $enumDecode(_$TriggerOperatorEnumMap, json['operator']),
      value: json['value'],
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$TriggerConditionImplToJson(
        _$TriggerConditionImpl instance) =>
    <String, dynamic>{
      'property': instance.property,
      'operator': _$TriggerOperatorEnumMap[instance.operator]!,
      'value': instance.value,
      'description': instance.description,
    };

const _$TriggerOperatorEnumMap = {
  TriggerOperator.equals: 'equals',
  TriggerOperator.notEquals: 'notEquals',
  TriggerOperator.contains: 'contains',
  TriggerOperator.notContains: 'notContains',
  TriggerOperator.exists: 'exists',
  TriggerOperator.notExists: 'notExists',
  TriggerOperator.greaterThan: 'greaterThan',
  TriggerOperator.lessThan: 'lessThan',
  TriggerOperator.inList: 'inList',
  TriggerOperator.notInList: 'notInList',
  TriggerOperator.matches: 'matches',
};

_$TriggerConditionGroupImpl _$$TriggerConditionGroupImplFromJson(
        Map<String, dynamic> json) =>
    _$TriggerConditionGroupImpl(
      operator: $enumDecode(_$LogicalOperatorEnumMap, json['operator']),
      conditions: json['conditions'] as List<dynamic>,
    );

Map<String, dynamic> _$$TriggerConditionGroupImplToJson(
        _$TriggerConditionGroupImpl instance) =>
    <String, dynamic>{
      'operator': _$LogicalOperatorEnumMap[instance.operator]!,
      'conditions': instance.conditions,
    };

const _$LogicalOperatorEnumMap = {
  LogicalOperator.and: 'and',
  LogicalOperator.or: 'or',
  LogicalOperator.not: 'not',
};

_$MethodologyTriggerImpl _$$MethodologyTriggerImplFromJson(
        Map<String, dynamic> json) =>
    _$MethodologyTriggerImpl(
      id: json['id'] as String,
      methodologyId: json['methodologyId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      assetType: $enumDecode(_$AssetTypeEnumMap, json['assetType']),
      conditions: json['conditions'],
      priority: (json['priority'] as num).toInt(),
      batchCapable: json['batchCapable'] as bool,
      batchCriteria: json['batchCriteria'] as String?,
      batchCommand: json['batchCommand'] as String?,
      maxBatchSize: (json['maxBatchSize'] as num?)?.toInt(),
      deduplicationKeyTemplate: json['deduplicationKeyTemplate'] as String,
      cooldownPeriod: json['cooldownPeriod'] == null
          ? null
          : Duration(microseconds: (json['cooldownPeriod'] as num).toInt()),
      individualCommand: json['individualCommand'] as String?,
      commandVariants: (json['commandVariants'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      expectedPropertyUpdates:
          (json['expectedPropertyUpdates'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
      expectedAssetDiscovery: (json['expectedAssetDiscovery'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$AssetTypeEnumMap, e))
          .toList(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      enabled: json['enabled'] as bool,
    );

Map<String, dynamic> _$$MethodologyTriggerImplToJson(
        _$MethodologyTriggerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'methodologyId': instance.methodologyId,
      'name': instance.name,
      'description': instance.description,
      'assetType': _$AssetTypeEnumMap[instance.assetType]!,
      'conditions': instance.conditions,
      'priority': instance.priority,
      'batchCapable': instance.batchCapable,
      'batchCriteria': instance.batchCriteria,
      'batchCommand': instance.batchCommand,
      'maxBatchSize': instance.maxBatchSize,
      'deduplicationKeyTemplate': instance.deduplicationKeyTemplate,
      'cooldownPeriod': instance.cooldownPeriod?.inMicroseconds,
      'individualCommand': instance.individualCommand,
      'commandVariants': instance.commandVariants,
      'expectedPropertyUpdates': instance.expectedPropertyUpdates,
      'expectedAssetDiscovery': instance.expectedAssetDiscovery
          ?.map((e) => _$AssetTypeEnumMap[e]!)
          .toList(),
      'tags': instance.tags,
      'enabled': instance.enabled,
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

_$TriggeredMethodologyImpl _$$TriggeredMethodologyImplFromJson(
        Map<String, dynamic> json) =>
    _$TriggeredMethodologyImpl(
      id: json['id'] as String,
      methodologyId: json['methodologyId'] as String,
      triggerId: json['triggerId'] as String,
      asset: Asset.fromJson(json['asset'] as Map<String, dynamic>),
      deduplicationKey: json['deduplicationKey'] as String,
      variables: json['variables'] as Map<String, dynamic>,
      command: json['command'] as String?,
      isPartOfBatch: json['isPartOfBatch'] as bool?,
      batchId: json['batchId'] as String?,
      batchAssets: (json['batchAssets'] as List<dynamic>?)
          ?.map((e) => Asset.fromJson(e as Map<String, dynamic>))
          .toList(),
      triggeredAt: DateTime.parse(json['triggeredAt'] as String),
      executedAt: json['executedAt'] == null
          ? null
          : DateTime.parse(json['executedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      status: json['status'] as String?,
      priority: (json['priority'] as num).toInt(),
    );

Map<String, dynamic> _$$TriggeredMethodologyImplToJson(
        _$TriggeredMethodologyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'methodologyId': instance.methodologyId,
      'triggerId': instance.triggerId,
      'asset': instance.asset,
      'deduplicationKey': instance.deduplicationKey,
      'variables': instance.variables,
      'command': instance.command,
      'isPartOfBatch': instance.isPartOfBatch,
      'batchId': instance.batchId,
      'batchAssets': instance.batchAssets,
      'triggeredAt': instance.triggeredAt.toIso8601String(),
      'executedAt': instance.executedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'status': instance.status,
      'priority': instance.priority,
    };

_$BatchedTriggerImpl _$$BatchedTriggerImplFromJson(Map<String, dynamic> json) =>
    _$BatchedTriggerImpl(
      id: json['id'] as String,
      methodologyId: json['methodologyId'] as String,
      triggers: (json['triggers'] as List<dynamic>)
          .map((e) => TriggeredMethodology.fromJson(e as Map<String, dynamic>))
          .toList(),
      batchCommand: json['batchCommand'] as String,
      batchVariables: json['batchVariables'] as Map<String, dynamic>,
      priority: (json['priority'] as num).toInt(),
      scheduledFor: json['scheduledFor'] == null
          ? null
          : DateTime.parse(json['scheduledFor'] as String),
    );

Map<String, dynamic> _$$BatchedTriggerImplToJson(
        _$BatchedTriggerImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'methodologyId': instance.methodologyId,
      'triggers': instance.triggers,
      'batchCommand': instance.batchCommand,
      'batchVariables': instance.batchVariables,
      'priority': instance.priority,
      'scheduledFor': instance.scheduledFor?.toIso8601String(),
    };
