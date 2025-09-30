// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NetworkAccessPoint _$NetworkAccessPointFromJson(Map<String, dynamic> json) =>
    _NetworkAccessPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      accessType: $enumDecode(_$NetworkAccessTypeEnumMap, json['accessType']),
      sourceAssetId: json['sourceAssetId'] as String?,
      sourceNetworkId: json['sourceNetworkId'] as String?,
      description: json['description'] as String?,
      active: json['active'] as bool? ?? true,
      credentials: json['credentials'] as String?,
      accessDetails: (json['accessDetails'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      discoveredAt: json['discoveredAt'] == null
          ? null
          : DateTime.parse(json['discoveredAt'] as String),
      lastTested: json['lastTested'] == null
          ? null
          : DateTime.parse(json['lastTested'] as String),
    );

Map<String, dynamic> _$NetworkAccessPointToJson(_NetworkAccessPoint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'accessType': _$NetworkAccessTypeEnumMap[instance.accessType]!,
      'sourceAssetId': instance.sourceAssetId,
      'sourceNetworkId': instance.sourceNetworkId,
      'description': instance.description,
      'active': instance.active,
      'credentials': instance.credentials,
      'accessDetails': instance.accessDetails,
      'discoveredAt': instance.discoveredAt?.toIso8601String(),
      'lastTested': instance.lastTested?.toIso8601String(),
    };

const _$NetworkAccessTypeEnumMap = {
  NetworkAccessType.none: 'none',
  NetworkAccessType.external: 'external',
  NetworkAccessType.adjacent: 'adjacent',
  NetworkAccessType.internal: 'internal',
  NetworkAccessType.pivoted: 'pivoted',
  NetworkAccessType.wireless: 'wireless',
  NetworkAccessType.physical: 'physical',
};

_NetworkHostReference _$NetworkHostReferenceFromJson(
  Map<String, dynamic> json,
) => _NetworkHostReference(
  hostAssetId: json['hostAssetId'] as String,
  ipAddress: json['ipAddress'] as String,
  hostname: json['hostname'] as String?,
  macAddress: json['macAddress'] as String?,
  isGateway: json['isGateway'] as bool? ?? false,
  isDhcpServer: json['isDhcpServer'] as bool? ?? false,
  isDnsServer: json['isDnsServer'] as bool? ?? false,
  isCompromised: json['isCompromised'] as bool? ?? false,
  openPorts: (json['openPorts'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  lastSeen: json['lastSeen'] == null
      ? null
      : DateTime.parse(json['lastSeen'] as String),
);

Map<String, dynamic> _$NetworkHostReferenceToJson(
  _NetworkHostReference instance,
) => <String, dynamic>{
  'hostAssetId': instance.hostAssetId,
  'ipAddress': instance.ipAddress,
  'hostname': instance.hostname,
  'macAddress': instance.macAddress,
  'isGateway': instance.isGateway,
  'isDhcpServer': instance.isDhcpServer,
  'isDnsServer': instance.isDnsServer,
  'isCompromised': instance.isCompromised,
  'openPorts': instance.openPorts,
  'lastSeen': instance.lastSeen?.toIso8601String(),
};

_RestrictedEnvironment _$RestrictedEnvironmentFromJson(
  Map<String, dynamic> json,
) => _RestrictedEnvironment(
  id: json['id'] as String,
  name: json['name'] as String,
  environmentType: $enumDecode(
    _$EnvironmentTypeEnumMap,
    json['environmentType'],
  ),
  restrictions: (json['restrictions'] as List<dynamic>)
      .map((e) => $enumDecode(_$RestrictionMechanismEnumMap, e))
      .toList(),
  hostAssetId: json['hostAssetId'] as String,
  applicationAssetId: json['applicationAssetId'] as String?,
  networkAssetId: json['networkAssetId'] as String?,
  description: json['description'] as String?,
  securityControlIds:
      (json['securityControlIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  breakoutAttemptIds:
      (json['breakoutAttemptIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  environmentDetails: (json['environmentDetails'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, e as String)),
  discoveredAt: json['discoveredAt'] == null
      ? null
      : DateTime.parse(json['discoveredAt'] as String),
  lastTested: json['lastTested'] == null
      ? null
      : DateTime.parse(json['lastTested'] as String),
);

Map<String, dynamic> _$RestrictedEnvironmentToJson(
  _RestrictedEnvironment instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'environmentType': _$EnvironmentTypeEnumMap[instance.environmentType]!,
  'restrictions': instance.restrictions
      .map((e) => _$RestrictionMechanismEnumMap[e]!)
      .toList(),
  'hostAssetId': instance.hostAssetId,
  'applicationAssetId': instance.applicationAssetId,
  'networkAssetId': instance.networkAssetId,
  'description': instance.description,
  'securityControlIds': instance.securityControlIds,
  'breakoutAttemptIds': instance.breakoutAttemptIds,
  'environmentDetails': instance.environmentDetails,
  'discoveredAt': instance.discoveredAt?.toIso8601String(),
  'lastTested': instance.lastTested?.toIso8601String(),
};

const _$EnvironmentTypeEnumMap = {
  EnvironmentType.application: 'application',
  EnvironmentType.container: 'container',
  EnvironmentType.virtualMachine: 'virtualMachine',
  EnvironmentType.network: 'network',
  EnvironmentType.physical: 'physical',
  EnvironmentType.privilege: 'privilege',
  EnvironmentType.browser: 'browser',
  EnvironmentType.mobile: 'mobile',
};

const _$RestrictionMechanismEnumMap = {
  RestrictionMechanism.sandbox: 'sandbox',
  RestrictionMechanism.appLocker: 'appLocker',
  RestrictionMechanism.selinux: 'selinux',
  RestrictionMechanism.appArmor: 'appArmor',
  RestrictionMechanism.containerRuntime: 'containerRuntime',
  RestrictionMechanism.networkSegmentation: 'networkSegmentation',
  RestrictionMechanism.uac: 'uac',
  RestrictionMechanism.sudo: 'sudo',
  RestrictionMechanism.chroot: 'chroot',
  RestrictionMechanism.kiosk: 'kiosk',
  RestrictionMechanism.codeExecution: 'codeExecution',
  RestrictionMechanism.fileSystem: 'fileSystem',
};

_BreakoutAttempt _$BreakoutAttemptFromJson(Map<String, dynamic> json) =>
    _BreakoutAttempt(
      id: json['id'] as String,
      name: json['name'] as String,
      restrictedEnvironmentId: json['restrictedEnvironmentId'] as String,
      techniqueId: json['techniqueId'] as String,
      status: $enumDecode(_$BreakoutStatusEnumMap, json['status']),
      attemptedAt: DateTime.parse(json['attemptedAt'] as String),
      testerAssetId: json['testerAssetId'] as String?,
      description: json['description'] as String?,
      command: json['command'] as String?,
      output: json['output'] as String?,
      evidence: json['evidence'] as String?,
      impact: $enumDecodeNullable(_$BreakoutImpactEnumMap, json['impact']),
      assetsGained: (json['assetsGained'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      credentialsGained: (json['credentialsGained'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      attemptDetails: (json['attemptDetails'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      blockedBy: json['blockedBy'] as String?,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$BreakoutAttemptToJson(_BreakoutAttempt instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'restrictedEnvironmentId': instance.restrictedEnvironmentId,
      'techniqueId': instance.techniqueId,
      'status': _$BreakoutStatusEnumMap[instance.status]!,
      'attemptedAt': instance.attemptedAt.toIso8601String(),
      'testerAssetId': instance.testerAssetId,
      'description': instance.description,
      'command': instance.command,
      'output': instance.output,
      'evidence': instance.evidence,
      'impact': _$BreakoutImpactEnumMap[instance.impact],
      'assetsGained': instance.assetsGained,
      'credentialsGained': instance.credentialsGained,
      'attemptDetails': instance.attemptDetails,
      'blockedBy': instance.blockedBy,
      'completedAt': instance.completedAt?.toIso8601String(),
      'notes': instance.notes,
    };

const _$BreakoutStatusEnumMap = {
  BreakoutStatus.notAttempted: 'notAttempted',
  BreakoutStatus.inProgress: 'inProgress',
  BreakoutStatus.successful: 'successful',
  BreakoutStatus.failed: 'failed',
  BreakoutStatus.partialSuccess: 'partialSuccess',
  BreakoutStatus.blocked: 'blocked',
  BreakoutStatus.requiresPrivilege: 'requiresPrivilege',
};

const _$BreakoutImpactEnumMap = {
  BreakoutImpact.minimal: 'minimal',
  BreakoutImpact.moderate: 'moderate',
  BreakoutImpact.significant: 'significant',
  BreakoutImpact.critical: 'critical',
  BreakoutImpact.lateral: 'lateral',
  BreakoutImpact.persistent: 'persistent',
};

_BreakoutTechnique _$BreakoutTechniqueFromJson(Map<String, dynamic> json) =>
    _BreakoutTechnique(
      id: json['id'] as String,
      name: json['name'] as String,
      category: $enumDecode(_$TechniqueCategoryEnumMap, json['category']),
      applicableEnvironments: (json['applicableEnvironments'] as List<dynamic>)
          .map((e) => $enumDecode(_$EnvironmentTypeEnumMap, e))
          .toList(),
      targetsRestrictions: (json['targetsRestrictions'] as List<dynamic>)
          .map((e) => $enumDecode(_$RestrictionMechanismEnumMap, e))
          .toList(),
      description: json['description'] as String?,
      methodology: json['methodology'] as String?,
      payload: json['payload'] as String?,
      prerequisites: (json['prerequisites'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      indicators: (json['indicators'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mitigations: (json['mitigations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      cveReference: json['cveReference'] as String?,
      source: json['source'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      discoveredAt: json['discoveredAt'] == null
          ? null
          : DateTime.parse(json['discoveredAt'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$BreakoutTechniqueToJson(_BreakoutTechnique instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': _$TechniqueCategoryEnumMap[instance.category]!,
      'applicableEnvironments': instance.applicableEnvironments
          .map((e) => _$EnvironmentTypeEnumMap[e]!)
          .toList(),
      'targetsRestrictions': instance.targetsRestrictions
          .map((e) => _$RestrictionMechanismEnumMap[e]!)
          .toList(),
      'description': instance.description,
      'methodology': instance.methodology,
      'payload': instance.payload,
      'prerequisites': instance.prerequisites,
      'indicators': instance.indicators,
      'mitigations': instance.mitigations,
      'cveReference': instance.cveReference,
      'source': instance.source,
      'metadata': instance.metadata,
      'discoveredAt': instance.discoveredAt?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

const _$TechniqueCategoryEnumMap = {
  TechniqueCategory.exploitation: 'exploitation',
  TechniqueCategory.configuration: 'configuration',
  TechniqueCategory.privilege: 'privilege',
  TechniqueCategory.injection: 'injection',
  TechniqueCategory.social: 'social',
  TechniqueCategory.physical: 'physical',
  TechniqueCategory.cryptographic: 'cryptographic',
  TechniqueCategory.logic: 'logic',
  TechniqueCategory.environment: 'environment',
};

_SecurityControl _$SecurityControlFromJson(Map<String, dynamic> json) =>
    _SecurityControl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      hostAssetId: json['hostAssetId'] as String,
      description: json['description'] as String?,
      version: json['version'] as String?,
      configuration: json['configuration'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      protectedAssets:
          (json['protectedAssets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      bypassTechniques:
          (json['bypassTechniques'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      settings: (json['settings'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      installedAt: json['installedAt'] == null
          ? null
          : DateTime.parse(json['installedAt'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$SecurityControlToJson(_SecurityControl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'hostAssetId': instance.hostAssetId,
      'description': instance.description,
      'version': instance.version,
      'configuration': instance.configuration,
      'enabled': instance.enabled,
      'protectedAssets': instance.protectedAssets,
      'bypassTechniques': instance.bypassTechniques,
      'settings': instance.settings,
      'installedAt': instance.installedAt?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_SoftwareVersion _$SoftwareVersionFromJson(Map<String, dynamic> json) =>
    _SoftwareVersion(
      major: (json['major'] as num).toInt(),
      minor: (json['minor'] as num).toInt(),
      patch: (json['patch'] as num).toInt(),
      build: json['build'] as String?,
      edition: json['edition'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
    );

Map<String, dynamic> _$SoftwareVersionToJson(_SoftwareVersion instance) =>
    <String, dynamic>{
      'major': instance.major,
      'minor': instance.minor,
      'patch': instance.patch,
      'build': instance.build,
      'edition': instance.edition,
      'releaseDate': instance.releaseDate?.toIso8601String(),
    };

_NetworkAddress _$NetworkAddressFromJson(Map<String, dynamic> json) =>
    _NetworkAddress(
      ip: json['ip'] as String,
      subnet: json['subnet'] as String?,
      gateway: json['gateway'] as String?,
      dnsServers: (json['dnsServers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      macAddress: json['macAddress'] as String?,
      isStatic: json['isStatic'] as bool?,
    );

Map<String, dynamic> _$NetworkAddressToJson(_NetworkAddress instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'subnet': instance.subnet,
      'gateway': instance.gateway,
      'dnsServers': instance.dnsServers,
      'macAddress': instance.macAddress,
      'isStatic': instance.isStatic,
    };

_PhysicalLocation _$PhysicalLocationFromJson(Map<String, dynamic> json) =>
    _PhysicalLocation(
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      room: json['room'] as String?,
    );

Map<String, dynamic> _$PhysicalLocationToJson(_PhysicalLocation instance) =>
    <String, dynamic>{
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'building': instance.building,
      'floor': instance.floor,
      'room': instance.room,
    };

_NetworkInterface _$NetworkInterfaceFromJson(Map<String, dynamic> json) =>
    _NetworkInterface(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      macAddress: json['macAddress'] as String,
      isEnabled: json['isEnabled'] as bool,
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => NetworkAddress.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      vendor: json['vendor'] as String?,
      driver: json['driver'] as String?,
      speedMbps: (json['speedMbps'] as num?)?.toInt(),
      isConnected: json['isConnected'] as bool?,
      connectedSwitchPort: json['connectedSwitchPort'] as String?,
      vlanId: json['vlanId'] as String?,
      driverInfo: (json['driverInfo'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      lastSeen: json['lastSeen'] == null
          ? null
          : DateTime.parse(json['lastSeen'] as String),
    );

Map<String, dynamic> _$NetworkInterfaceToJson(_NetworkInterface instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'macAddress': instance.macAddress,
      'isEnabled': instance.isEnabled,
      'addresses': instance.addresses,
      'description': instance.description,
      'vendor': instance.vendor,
      'driver': instance.driver,
      'speedMbps': instance.speedMbps,
      'isConnected': instance.isConnected,
      'connectedSwitchPort': instance.connectedSwitchPort,
      'vlanId': instance.vlanId,
      'driverInfo': instance.driverInfo,
      'lastSeen': instance.lastSeen?.toIso8601String(),
    };

_HostService _$HostServiceFromJson(Map<String, dynamic> json) => _HostService(
  id: json['id'] as String,
  name: json['name'] as String,
  port: (json['port'] as num).toInt(),
  protocol: json['protocol'] as String,
  state: json['state'] as String,
  version: json['version'] as String?,
  banner: json['banner'] as String?,
  productName: json['productName'] as String?,
  productVersion: json['productVersion'] as String?,
  extraInfo: (json['extraInfo'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  vulnerabilities: (json['vulnerabilities'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  requiresAuthentication: json['requiresAuthentication'] as bool?,
  authenticationMethods: (json['authenticationMethods'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  sslVersion: json['sslVersion'] as String?,
  sslCiphers: (json['sslCiphers'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  lastChecked: json['lastChecked'] == null
      ? null
      : DateTime.parse(json['lastChecked'] as String),
  confidence: json['confidence'] as String?,
);

Map<String, dynamic> _$HostServiceToJson(_HostService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'port': instance.port,
      'protocol': instance.protocol,
      'state': instance.state,
      'version': instance.version,
      'banner': instance.banner,
      'productName': instance.productName,
      'productVersion': instance.productVersion,
      'extraInfo': instance.extraInfo,
      'vulnerabilities': instance.vulnerabilities,
      'requiresAuthentication': instance.requiresAuthentication,
      'authenticationMethods': instance.authenticationMethods,
      'sslVersion': instance.sslVersion,
      'sslCiphers': instance.sslCiphers,
      'lastChecked': instance.lastChecked?.toIso8601String(),
      'confidence': instance.confidence,
    };

_HostApplication _$HostApplicationFromJson(Map<String, dynamic> json) =>
    _HostApplication(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      version: json['version'] as String?,
      vendor: json['vendor'] as String?,
      architecture: json['architecture'] as String?,
      installLocation: json['installLocation'] as String?,
      installDate: json['installDate'] == null
          ? null
          : DateTime.parse(json['installDate'] as String),
      sizeMB: (json['sizeMB'] as num?)?.toInt(),
      configFiles: (json['configFiles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      dataDirectories: (json['dataDirectories'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      registryKeys: (json['registryKeys'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      associatedServices: (json['associatedServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      networkPorts: (json['networkPorts'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      vulnerabilities: (json['vulnerabilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isSystemCritical: json['isSystemCritical'] as bool?,
      hasUpdateAvailable: json['hasUpdateAvailable'] as bool?,
      licenseType: json['licenseType'] as String?,
      licenseKey: json['licenseKey'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$HostApplicationToJson(_HostApplication instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'version': instance.version,
      'vendor': instance.vendor,
      'architecture': instance.architecture,
      'installLocation': instance.installLocation,
      'installDate': instance.installDate?.toIso8601String(),
      'sizeMB': instance.sizeMB,
      'configFiles': instance.configFiles,
      'dataDirectories': instance.dataDirectories,
      'registryKeys': instance.registryKeys,
      'associatedServices': instance.associatedServices,
      'networkPorts': instance.networkPorts,
      'vulnerabilities': instance.vulnerabilities,
      'isSystemCritical': instance.isSystemCritical,
      'hasUpdateAvailable': instance.hasUpdateAvailable,
      'licenseType': instance.licenseType,
      'licenseKey': instance.licenseKey,
      'metadata': instance.metadata,
    };

_HostAccount _$HostAccountFromJson(Map<String, dynamic> json) => _HostAccount(
  id: json['id'] as String,
  username: json['username'] as String,
  type: json['type'] as String,
  isEnabled: json['isEnabled'] as bool,
  fullName: json['fullName'] as String?,
  description: json['description'] as String?,
  groups: (json['groups'] as List<dynamic>?)?.map((e) => e as String).toList(),
  homeDirectory: json['homeDirectory'] as String?,
  shell: json['shell'] as String?,
  lastLogin: json['lastLogin'] == null
      ? null
      : DateTime.parse(json['lastLogin'] as String),
  passwordLastSet: json['passwordLastSet'] == null
      ? null
      : DateTime.parse(json['passwordLastSet'] as String),
  passwordNeverExpires: json['passwordNeverExpires'] as bool?,
  accountLocked: json['accountLocked'] as bool?,
  isAdmin: json['isAdmin'] as bool?,
  privileges: (json['privileges'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  environment: (json['environment'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$HostAccountToJson(_HostAccount instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'type': instance.type,
      'isEnabled': instance.isEnabled,
      'fullName': instance.fullName,
      'description': instance.description,
      'groups': instance.groups,
      'homeDirectory': instance.homeDirectory,
      'shell': instance.shell,
      'lastLogin': instance.lastLogin?.toIso8601String(),
      'passwordLastSet': instance.passwordLastSet?.toIso8601String(),
      'passwordNeverExpires': instance.passwordNeverExpires,
      'accountLocked': instance.accountLocked,
      'isAdmin': instance.isAdmin,
      'privileges': instance.privileges,
      'environment': instance.environment,
    };

_HardwareComponent _$HardwareComponentFromJson(Map<String, dynamic> json) =>
    _HardwareComponent(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      manufacturer: json['manufacturer'] as String?,
      model: json['model'] as String?,
      serialNumber: json['serialNumber'] as String?,
      version: json['version'] as String?,
      specifications: (json['specifications'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      health: json['health'] as String?,
      lastChecked: json['lastChecked'] == null
          ? null
          : DateTime.parse(json['lastChecked'] as String),
    );

Map<String, dynamic> _$HardwareComponentToJson(_HardwareComponent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'name': instance.name,
      'manufacturer': instance.manufacturer,
      'model': instance.model,
      'serialNumber': instance.serialNumber,
      'version': instance.version,
      'specifications': instance.specifications,
      'health': instance.health,
      'lastChecked': instance.lastChecked?.toIso8601String(),
    };

_AuthenticationInfo _$AuthenticationInfoFromJson(Map<String, dynamic> json) =>
    _AuthenticationInfo(
      mechanism: json['mechanism'] as String,
      details: (json['details'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      isMultiFactor: json['isMultiFactor'] as bool?,
      mfaMethods: (json['mfaMethods'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      lastAuthentication: json['lastAuthentication'] == null
          ? null
          : DateTime.parse(json['lastAuthentication'] as String),
      isServiceAccount: json['isServiceAccount'] as bool?,
    );

Map<String, dynamic> _$AuthenticationInfoToJson(_AuthenticationInfo instance) =>
    <String, dynamic>{
      'mechanism': instance.mechanism,
      'details': instance.details,
      'isMultiFactor': instance.isMultiFactor,
      'mfaMethods': instance.mfaMethods,
      'lastAuthentication': instance.lastAuthentication?.toIso8601String(),
      'isServiceAccount': instance.isServiceAccount,
    };
