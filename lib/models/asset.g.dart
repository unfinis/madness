// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StringPropertyImpl _$$StringPropertyImplFromJson(Map<String, dynamic> json) =>
    _$StringPropertyImpl(
      json['value'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StringPropertyImplToJson(
        _$StringPropertyImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$IntegerPropertyImpl _$$IntegerPropertyImplFromJson(
        Map<String, dynamic> json) =>
    _$IntegerPropertyImpl(
      (json['value'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$IntegerPropertyImplToJson(
        _$IntegerPropertyImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$BooleanPropertyImpl _$$BooleanPropertyImplFromJson(
        Map<String, dynamic> json) =>
    _$BooleanPropertyImpl(
      json['value'] as bool,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$BooleanPropertyImplToJson(
        _$BooleanPropertyImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$StringListPropertyImpl _$$StringListPropertyImplFromJson(
        Map<String, dynamic> json) =>
    _$StringListPropertyImpl(
      (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$StringListPropertyImplToJson(
        _$StringListPropertyImpl instance) =>
    <String, dynamic>{
      'values': instance.values,
      'runtimeType': instance.$type,
    };

_$MapPropertyImpl _$$MapPropertyImplFromJson(Map<String, dynamic> json) =>
    _$MapPropertyImpl(
      json['value'] as Map<String, dynamic>,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$MapPropertyImplToJson(_$MapPropertyImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'runtimeType': instance.$type,
    };

_$ObjectListPropertyImpl _$$ObjectListPropertyImplFromJson(
        Map<String, dynamic> json) =>
    _$ObjectListPropertyImpl(
      (json['objects'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ObjectListPropertyImplToJson(
        _$ObjectListPropertyImpl instance) =>
    <String, dynamic>{
      'objects': instance.objects,
      'runtimeType': instance.$type,
    };

_$AssetImpl _$$AssetImplFromJson(Map<String, dynamic> json) => _$AssetImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AssetTypeEnumMap, json['type']),
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      properties: (json['properties'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, PropertyValue.fromJson(e as Map<String, dynamic>)),
      ),
      completedTriggers: (json['completedTriggers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      triggerResults: (json['triggerResults'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, TriggerResult.fromJson(e as Map<String, dynamic>)),
      ),
      parentAssetIds: (json['parentAssetIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      childAssetIds: (json['childAssetIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      discoveredAt: DateTime.parse(json['discoveredAt'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      discoveryMethod: json['discoveryMethod'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$AssetImplToJson(_$AssetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AssetTypeEnumMap[instance.type]!,
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'properties': instance.properties,
      'completedTriggers': instance.completedTriggers,
      'triggerResults': instance.triggerResults,
      'parentAssetIds': instance.parentAssetIds,
      'childAssetIds': instance.childAssetIds,
      'discoveredAt': instance.discoveredAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'discoveryMethod': instance.discoveryMethod,
      'confidence': instance.confidence,
      'tags': instance.tags,
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

_$TriggerResultImpl _$$TriggerResultImplFromJson(Map<String, dynamic> json) =>
    _$TriggerResultImpl(
      methodologyId: json['methodologyId'] as String,
      executedAt: DateTime.parse(json['executedAt'] as String),
      success: json['success'] as bool,
      output: json['output'] as String?,
      propertyUpdates: (json['propertyUpdates'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, PropertyValue.fromJson(e as Map<String, dynamic>)),
      ),
      discoveredAssets: (json['discoveredAssets'] as List<dynamic>?)
          ?.map((e) => Asset.fromJson(e as Map<String, dynamic>))
          .toList(),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$TriggerResultImplToJson(_$TriggerResultImpl instance) =>
    <String, dynamic>{
      'methodologyId': instance.methodologyId,
      'executedAt': instance.executedAt.toIso8601String(),
      'success': instance.success,
      'output': instance.output,
      'propertyUpdates': instance.propertyUpdates,
      'discoveredAssets': instance.discoveredAssets,
      'error': instance.error,
    };
