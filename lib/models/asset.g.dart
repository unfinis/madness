// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StringProperty _$StringPropertyFromJson(Map<String, dynamic> json) =>
    StringProperty(json['value'] as String, $type: json['type'] as String?);

Map<String, dynamic> _$StringPropertyToJson(StringProperty instance) =>
    <String, dynamic>{'value': instance.value, 'type': instance.$type};

IntegerProperty _$IntegerPropertyFromJson(Map<String, dynamic> json) =>
    IntegerProperty(
      (json['value'] as num).toInt(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$IntegerPropertyToJson(IntegerProperty instance) =>
    <String, dynamic>{'value': instance.value, 'type': instance.$type};

BooleanProperty _$BooleanPropertyFromJson(Map<String, dynamic> json) =>
    BooleanProperty(json['value'] as bool, $type: json['type'] as String?);

Map<String, dynamic> _$BooleanPropertyToJson(BooleanProperty instance) =>
    <String, dynamic>{'value': instance.value, 'type': instance.$type};

StringListProperty _$StringListPropertyFromJson(Map<String, dynamic> json) =>
    StringListProperty(
      (json['values'] as List<dynamic>).map((e) => e as String).toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$StringListPropertyToJson(StringListProperty instance) =>
    <String, dynamic>{'values': instance.values, 'type': instance.$type};

MapProperty _$MapPropertyFromJson(Map<String, dynamic> json) => MapProperty(
  json['value'] as Map<String, dynamic>,
  $type: json['type'] as String?,
);

Map<String, dynamic> _$MapPropertyToJson(MapProperty instance) =>
    <String, dynamic>{'value': instance.value, 'type': instance.$type};

ObjectListProperty _$ObjectListPropertyFromJson(Map<String, dynamic> json) =>
    ObjectListProperty(
      (json['objects'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$ObjectListPropertyToJson(ObjectListProperty instance) =>
    <String, dynamic>{'objects': instance.objects, 'type': instance.$type};

_Asset _$AssetFromJson(Map<String, dynamic> json) => _Asset(
  id: json['id'] as String,
  type: $enumDecode(_$AssetTypeEnumMap, json['type']),
  projectId: json['projectId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  properties: (json['properties'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, PropertyValue.fromJson(e as Map<String, dynamic>)),
  ),
  completedTriggers: (json['completedTriggers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  triggerResults: (json['triggerResults'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, TriggerResult.fromJson(e as Map<String, dynamic>)),
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

Map<String, dynamic> _$AssetToJson(_Asset instance) => <String, dynamic>{
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

_TriggerResult _$TriggerResultFromJson(Map<String, dynamic> json) =>
    _TriggerResult(
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

Map<String, dynamic> _$TriggerResultToJson(_TriggerResult instance) =>
    <String, dynamic>{
      'methodologyId': instance.methodologyId,
      'executedAt': instance.executedAt.toIso8601String(),
      'success': instance.success,
      'output': instance.output,
      'propertyUpdates': instance.propertyUpdates,
      'discoveredAssets': instance.discoveredAssets,
      'error': instance.error,
    };
