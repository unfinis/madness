import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

// Asset types
enum AssetType {
  networkSegment,
  host,
  service,
  credential,
  vulnerability,
  domain,
  wireless_network,
}

// Access levels for network segments
enum AccessLevel {
  blocked,    // No access
  limited,    // Guest/quarantine VLAN
  partial,    // Some access with restrictions
  full,       // Complete network access
}

// Generic property value that can hold different types
@freezed
class PropertyValue with _$PropertyValue {
  const factory PropertyValue.string(String value) = StringProperty;
  const factory PropertyValue.integer(int value) = IntegerProperty;
  const factory PropertyValue.boolean(bool value) = BooleanProperty;
  const factory PropertyValue.stringList(List<String> values) = StringListProperty;
  const factory PropertyValue.map(Map<String, dynamic> value) = MapProperty;
  const factory PropertyValue.objectList(List<Map<String, dynamic>> objects) = ObjectListProperty;

  factory PropertyValue.fromJson(Map<String, dynamic> json) => _$PropertyValueFromJson(json);
}

// Asset model with rich property system
@freezed
class Asset with _$Asset {
  const factory Asset({
    required String id,
    required AssetType type,
    required String projectId,
    required String name,
    String? description,

    // Rich property system
    required Map<String, PropertyValue> properties,

    // Trigger tracking
    required List<String> completedTriggers,  // Deduplication keys
    required Map<String, TriggerResult> triggerResults,

    // Relationships
    required List<String> parentAssetIds,
    required List<String> childAssetIds,

    // Metadata
    required DateTime discoveredAt,
    DateTime? lastUpdated,
    String? discoveryMethod,
    double? confidence,

    // Tags for filtering and grouping
    required List<String> tags,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

// Result of a trigger execution
@freezed
class TriggerResult with _$TriggerResult {
  const factory TriggerResult({
    required String methodologyId,
    required DateTime executedAt,
    required bool success,
    String? output,
    Map<String, PropertyValue>? propertyUpdates,
    List<Asset>? discoveredAssets,
    String? error,
  }) = _TriggerResult;

  factory TriggerResult.fromJson(Map<String, dynamic> json) => _$TriggerResultFromJson(json);
}

// Pre-defined property schemas for different asset types
class AssetPropertySchemas {
  // Network Segment Properties
  static const networkSegmentProperties = {
    'subnet': 'string',              // e.g., "192.168.1.0/24"
    'gateway': 'string',             // e.g., "192.168.1.1"
    'dns_servers': 'stringList',    // e.g., ["8.8.8.8", "8.8.4.4"]
    'domain_name': 'string',         // e.g., "corp.local"
    'vlan_id': 'integer',           // e.g., 100

    // Security controls
    'nac_enabled': 'boolean',
    'nac_type': 'string',           // "802.1x", "mac_auth", etc.
    'firewall_present': 'boolean',
    'ips_ids_present': 'boolean',
    'access_level': 'string',       // AccessLevel enum as string

    // Discovered assets
    'live_hosts': 'stringList',     // IP addresses
    'web_services': 'objectList',   // [{host, port, service, ssl}]
    'smb_hosts': 'stringList',
    'domain_controllers': 'stringList',
    'dhcp_servers': 'stringList',

    // Available resources
    'credentials_available': 'objectList',  // [{username, password/hash, source}]
    'captured_hashes': 'objectList',        // [{username, hash, type}]

    // Attempted bypasses
    'bypass_methods_attempted': 'stringList',  // ["mac_spoofing", "vlan_hopping"]
    'bypass_methods_successful': 'stringList',
  };

  // Host Properties
  static const hostProperties = {
    'ip_address': 'string',
    'ipv6_address': 'string',
    'hostname': 'string',
    'fqdn': 'string',
    'mac_address': 'string',

    // OS Information
    'os_type': 'string',            // "windows", "linux", "macos"
    'os_version': 'string',
    'os_architecture': 'string',    // "x64", "x86"

    // Services
    'open_ports': 'stringList',     // ["22", "80", "445"]
    'services': 'objectList',       // [{port, service, version, banner}]

    // Security status
    'smb_signing': 'boolean',
    'null_sessions': 'boolean',
    'rdp_enabled': 'boolean',
    'ssh_enabled': 'boolean',
    'web_server': 'boolean',

    // Access status
    'credentials_valid': 'objectList',  // [{username, access_type}]
    'shell_access': 'boolean',
    'privilege_level': 'string',        // "none", "user", "admin", "system"

    // Vulnerabilities
    'vulnerabilities': 'objectList',    // [{cve, severity, exploitable}]
  };

  // Service Properties
  static const serviceProperties = {
    'host': 'string',
    'port': 'integer',
    'protocol': 'string',           // "tcp", "udp"
    'service_name': 'string',       // "http", "smb", "ssh"
    'version': 'string',
    'banner': 'string',

    // Web specific
    'web_technology': 'stringList',  // ["nginx", "php", "wordpress"]
    'ssl_enabled': 'boolean',
    'ssl_vulnerabilities': 'stringList',

    // Authentication
    'auth_required': 'boolean',
    'auth_methods': 'stringList',    // ["basic", "ntlm", "kerberos"]
    'default_creds_tested': 'boolean',
    'weak_creds_found': 'boolean',
  };

  // Credential Properties
  static const credentialProperties = {
    'username': 'string',
    'password': 'string',
    'hash': 'string',
    'hash_type': 'string',          // "ntlm", "sha1", "md5"
    'domain': 'string',
    'source': 'string',              // "llmnr_poisoning", "hash_dump", "brute_force"
    'confirmed_hosts': 'stringList', // Hosts where cred is valid
    'privilege_level': 'string',
    'last_tested': 'string',         // ISO timestamp
  };
}

// Helper class for creating assets with proper properties
class AssetFactory {
  static final _uuid = const Uuid();

  static Asset createNetworkSegment({
    required String projectId,
    required String subnet,
    String? name,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'subnet': PropertyValue.string(subnet),
      'access_level': PropertyValue.string(AccessLevel.blocked.name),
      'nac_enabled': const PropertyValue.boolean(false),
      'firewall_present': const PropertyValue.boolean(false),
      'live_hosts': const PropertyValue.stringList([]),
      'web_services': const PropertyValue.objectList([]),
      'smb_hosts': const PropertyValue.stringList([]),
      'credentials_available': const PropertyValue.objectList([]),
      'bypass_methods_attempted': const PropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.networkSegment,
      projectId: projectId,
      name: name ?? 'Network $subnet',
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['network', 'segment'],
    );
  }

  static Asset createHost({
    required String projectId,
    required String ipAddress,
    String? hostname,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'ip_address': PropertyValue.string(ipAddress),
      if (hostname != null) 'hostname': PropertyValue.string(hostname),
      'open_ports': const PropertyValue.stringList([]),
      'services': const PropertyValue.objectList([]),
      'smb_signing': const PropertyValue.boolean(false),
      'shell_access': const PropertyValue.boolean(false),
      'privilege_level': PropertyValue.string('none'),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.host,
      projectId: projectId,
      name: hostname ?? ipAddress,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['host'],
    );
  }

  static Asset createCredential({
    required String projectId,
    required String username,
    String? password,
    String? hash,
    String? domain,
    required String source,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'username': PropertyValue.string(username),
      if (password != null) 'password': PropertyValue.string(password),
      if (hash != null) 'hash': PropertyValue.string(hash),
      if (domain != null) 'domain': PropertyValue.string(domain),
      'source': PropertyValue.string(source),
      'confirmed_hosts': const PropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    final credName = domain != null ? '$domain\\$username' : username;

    return Asset(
      id: _uuid.v4(),
      type: AssetType.credential,
      projectId: projectId,
      name: credName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['credential', source],
    );
  }
}

// Extension methods for easier property access
extension AssetPropertyExtensions on Asset {
  T? getProperty<T>(String key) {
    final prop = properties[key];
    if (prop == null) return null;

    return prop.when(
      string: (v) => v as T,
      integer: (v) => v as T,
      boolean: (v) => v as T,
      stringList: (v) => v as T,
      map: (v) => v as T,
      objectList: (v) => v as T,
    );
  }

  bool hasProperty(String key) => properties.containsKey(key);

  Asset updateProperty(String key, PropertyValue value) {
    return copyWith(
      properties: {...properties, key: value},
      lastUpdated: DateTime.now(),
    );
  }

  Asset updateProperties(Map<String, PropertyValue> updates) {
    return copyWith(
      properties: {...properties, ...updates},
      lastUpdated: DateTime.now(),
    );
  }

  bool hasTriggerCompleted(String deduplicationKey) {
    return completedTriggers.contains(deduplicationKey);
  }

  Asset markTriggerCompleted(String deduplicationKey, TriggerResult result) {
    return copyWith(
      completedTriggers: [...completedTriggers, deduplicationKey],
      triggerResults: {...triggerResults, deduplicationKey: result},
      lastUpdated: DateTime.now(),
    );
  }
}