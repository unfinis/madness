import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'asset_relationships.dart';

part 'assets.freezed.dart';
part 'assets.g.dart';

// =============================================================================
// Core Asset Types and Hierarchical Model
// =============================================================================

/// Asset types supporting multiple entry perspectives
enum AssetType {
  // Core Infrastructure
  environment,        // Top-level container (Physical, Cloud, Hybrid)
  physicalSite,      // Building/Location
  physicalArea,      // Room/Floor within site
  networkSegment,    // Network subnet/VLAN
  host,              // Computer/server
  service,           // Running service on host

  // Identity & Access
  credential,        // Username/password/hash
  identity,          // User/service account
  authenticationSystem, // AD, Entra ID, LDAP

  // Data & Files
  file,              // Files, backups, configs
  database,          // Database instances
  software,          // Installed applications

  // Wireless & Network
  wirelessNetwork,   // WiFi/wireless access point
  wirelessClient,    // Connected wireless device
  networkDevice,     // Router, switch, firewall

  // Cloud & Azure
  cloudTenant,       // Azure tenant, AWS account
  cloudResource,     // VM, storage, service
  cloudIdentity,     // Azure AD user, service principal

  // Security
  vulnerability,     // CVE, security issue
  certificate,       // SSL/TLS certificates

  // Physical Security
  person,            // Individual for social engineering
  accessControl,     // Badge reader, keypad

  // Breakout Testing
  restrictedEnvironment,  // Kiosks, containers, sandboxes
  breakoutAttempt,       // Individual escape attempts
  breakoutTechnique,     // Reusable attack methods
  securityControl,       // Controls preventing breakouts

  // Critical Application Types
  webApplication,    // Web applications
  apiEndpoint,       // API endpoints (REST, GraphQL, SOAP)
  container,         // Docker/K8s containers

  // Comprehensive Azure Resources
  azureResource,           // Generic Azure resource
  azureVM,                 // Azure Virtual Machine
  azureStorageAccount,     // Azure Storage (Blobs, Files, Tables, Queues)
  azureKeyVault,           // Azure Key Vault
  azureSQLDatabase,        // Azure SQL Database
  azureCosmosDB,           // Azure Cosmos DB
  azureFunction,           // Azure Function App
  azureAppService,         // Azure App Service/Web App
  azureAD,                 // Azure Active Directory specific items
  azureNetworking,         // VNets, NSGs, Load Balancers
  azureAKS,                // Azure Kubernetes Service

  // AWS Resources
  awsResource,       // Generic AWS resource
  ec2Instance,       // AWS EC2
  s3Bucket,          // AWS S3
  rdsDatabase,       // AWS RDS
  lambdaFunction,    // AWS Lambda
  iamRole,           // AWS IAM
  awsSecret,         // AWS Secrets Manager

  // GCP Resources
  gcpResource,       // Generic GCP resource
  computeInstance,   // GCP Compute
  cloudStorage,      // GCP Storage
  cloudSQL,          // GCP Cloud SQL
  cloudFunction,     // GCP Cloud Function

  // Supporting Types
  dnsRecord,         // DNS records
  email,             // Email addresses/mailboxes

  // Special
  unknown,           // Unidentified asset
}

/// Asset discovery and access status
enum AssetDiscoveryStatus {
  discovered,   // Found but not accessed
  accessible,   // Can interact with
  compromised,  // Have control over
  analyzed,     // Fully examined
  unknown,      // Status unclear
}

/// Physical or logical access levels
enum AccessLevel {
  none,         // No access
  guest,        // Limited/guest access
  user,         // Standard user access
  admin,        // Administrative access
  system,       // System-level access
}

// =============================================================================
// Network Segment Enhanced Models
// =============================================================================

/// Network Access Control (NAC) implementation types
enum NacType {
  none,         // No NAC implemented
  dot1x,        // 802.1x authentication
  macAuth,      // MAC address authentication
  webAuth,      // Web-based authentication
  hybrid,       // Multiple methods combined
}

/// Types of network access we have for pentesting
enum NetworkAccessType {
  none,         // No access to this network
  external,     // Can scan from internet/external network
  adjacent,     // From adjacent network segment
  internal,     // Direct access within network
  pivoted,      // Access through compromised host
  wireless,     // Access via wireless connection
  physical,     // Physical access to network ports
}

/// Firewall rule action types
enum FirewallAction {
  allow,
  deny,
  log,
  drop,
}

/// Firewall rule for network segments
class NetworkFirewallRule {
  final String id;
  final String name;
  final FirewallAction action;
  final String sourceNetwork;      // CIDR or "any"
  final String destinationNetwork; // CIDR or "any"
  final String protocol;           // tcp/udp/icmp/any
  final String ports;              // "80", "80-443", "any"
  final String? description;
  final bool enabled;
  final DateTime? lastModified;

  const NetworkFirewallRule({
    required this.id,
    required this.name,
    required this.action,
    required this.sourceNetwork,
    required this.destinationNetwork,
    required this.protocol,
    required this.ports,
    this.description,
    this.enabled = true,
    this.lastModified,
  });

  factory NetworkFirewallRule.fromJson(Map<String, dynamic> json) {
    return NetworkFirewallRule(
      id: json['id'] as String,
      name: json['name'] as String,
      action: FirewallAction.values.firstWhere(
        (e) => e.toString().split('.').last == json['action'],
        orElse: () => FirewallAction.deny,
      ),
      sourceNetwork: json['sourceNetwork'] as String,
      destinationNetwork: json['destinationNetwork'] as String,
      protocol: json['protocol'] as String,
      ports: json['ports'] as String,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool? ?? true,
      lastModified: json['lastModified'] != null
        ? DateTime.parse(json['lastModified'] as String)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'action': action.toString().split('.').last,
      'sourceNetwork': sourceNetwork,
      'destinationNetwork': destinationNetwork,
      'protocol': protocol,
      'ports': ports,
      'description': description,
      'enabled': enabled,
      'lastModified': lastModified?.toIso8601String(),
    };
  }

  NetworkFirewallRule copyWith({
    String? id,
    String? name,
    FirewallAction? action,
    String? sourceNetwork,
    String? destinationNetwork,
    String? protocol,
    String? ports,
    String? description,
    bool? enabled,
    DateTime? lastModified,
  }) {
    return NetworkFirewallRule(
      id: id ?? this.id,
      name: name ?? this.name,
      action: action ?? this.action,
      sourceNetwork: sourceNetwork ?? this.sourceNetwork,
      destinationNetwork: destinationNetwork ?? this.destinationNetwork,
      protocol: protocol ?? this.protocol,
      ports: ports ?? this.ports,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      lastModified: lastModified ?? this.lastModified,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NetworkFirewallRule &&
            id == other.id &&
            name == other.name &&
            action == other.action &&
            sourceNetwork == other.sourceNetwork &&
            destinationNetwork == other.destinationNetwork &&
            protocol == other.protocol &&
            ports == other.ports &&
            enabled == other.enabled);
  }

  @override
  int get hashCode => Object.hash(
    id, name, action, sourceNetwork, destinationNetwork, protocol, ports, enabled
  );
}

/// Network route information
class NetworkRoute {
  final String id;
  final String destinationNetwork;  // Target network CIDR
  final String nextHop;            // Gateway IP
  final int metric;
  final bool active;
  final String? description;

  const NetworkRoute({
    required this.id,
    required this.destinationNetwork,
    required this.nextHop,
    required this.metric,
    this.active = true,
    this.description,
  });

  factory NetworkRoute.fromJson(Map<String, dynamic> json) {
    return NetworkRoute(
      id: json['id'] as String,
      destinationNetwork: json['destinationNetwork'] as String,
      nextHop: json['nextHop'] as String,
      metric: json['metric'] as int,
      active: json['active'] as bool? ?? true,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destinationNetwork': destinationNetwork,
      'nextHop': nextHop,
      'metric': metric,
      'active': active,
      'description': description,
    };
  }

  NetworkRoute copyWith({
    String? id,
    String? destinationNetwork,
    String? nextHop,
    int? metric,
    bool? active,
    String? description,
  }) {
    return NetworkRoute(
      id: id ?? this.id,
      destinationNetwork: destinationNetwork ?? this.destinationNetwork,
      nextHop: nextHop ?? this.nextHop,
      metric: metric ?? this.metric,
      active: active ?? this.active,
      description: description ?? this.description,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is NetworkRoute &&
            id == other.id &&
            destinationNetwork == other.destinationNetwork &&
            nextHop == other.nextHop &&
            metric == other.metric &&
            active == other.active);
  }

  @override
  int get hashCode => Object.hash(id, destinationNetwork, nextHop, metric, active);
}

/// Network access point - tracks how we can access this network
@freezed
sealed class NetworkAccessPoint with _$NetworkAccessPoint {
  const factory NetworkAccessPoint({
    required String id,
    required String name,
    required NetworkAccessType accessType,
    String? sourceAssetId,              // Host/device we're accessing from
    String? sourceNetworkId,            // Network segment we're coming from
    String? description,
    @Default(true) bool active,
    String? credentials,                // Reference to credential asset
    Map<String, String>? accessDetails, // Protocol-specific details
    DateTime? discoveredAt,
    DateTime? lastTested,
  }) = _NetworkAccessPoint;

  factory NetworkAccessPoint.fromJson(Map<String, dynamic> json) => _$NetworkAccessPointFromJson(json);
}

/// Host reference within network segment
@freezed
sealed class NetworkHostReference with _$NetworkHostReference {
  const factory NetworkHostReference({
    required String hostAssetId,
    required String ipAddress,
    String? hostname,
    String? macAddress,
    @Default(false) bool isGateway,
    @Default(false) bool isDhcpServer,
    @Default(false) bool isDnsServer,
    @Default(false) bool isCompromised,
    List<String>? openPorts,
    DateTime? lastSeen,
  }) = _NetworkHostReference;

  factory NetworkHostReference.fromJson(Map<String, dynamic> json) => _$NetworkHostReferenceFromJson(json);
}

// =============================================================================
// Breakout Testing Models
// =============================================================================

/// Types of restricted environments for breakout testing
enum EnvironmentType {
  application,      // Application sandboxes, kiosks
  container,        // Docker, LXC containers
  virtualMachine,   // VM escapes
  network,          // Network segmentation
  physical,         // Physical kiosks, terminals
  privilege,        // User context restrictions
  browser,          // Browser sandboxes
  mobile,           // Mobile app sandboxes
}

/// Restriction mechanisms that prevent breakouts
enum RestrictionMechanism {
  sandbox,          // Application sandboxing
  appLocker,        // Windows AppLocker
  selinux,          // SELinux policies
  appArmor,         // AppArmor profiles
  containerRuntime, // Docker/container restrictions
  networkSegmentation, // VLANs, firewalls
  uac,              // Windows UAC
  sudo,             // Linux sudo restrictions
  chroot,           // Chroot jails
  kiosk,            // Kiosk mode restrictions
  codeExecution,    // Code execution prevention
  fileSystem,       // File system restrictions
}

/// Status of breakout attempts
enum BreakoutStatus {
  notAttempted,     // Haven't tried yet
  inProgress,       // Currently testing
  successful,       // Successfully broke out
  failed,           // Failed to break out
  partialSuccess,   // Partial escape (limited access)
  blocked,          // Blocked by security controls
  requiresPrivilege, // Need higher privileges first
}

/// Categories of breakout techniques
enum TechniqueCategory {
  exploitation,     // Memory corruption, buffer overflows
  configuration,    // Misconfigurations, weak settings
  privilege,        // Privilege escalation
  injection,        // Code/command injection
  social,           // Social engineering
  physical,         // Physical manipulation
  cryptographic,    // Crypto weaknesses
  logic,            // Business logic flaws
  environment,      // Environment manipulation
}

/// Impact levels of successful breakouts
enum BreakoutImpact {
  minimal,          // Limited additional access
  moderate,         // Moderate privilege gain
  significant,      // Major access increase
  critical,         // Full system compromise
  lateral,          // Access to other systems
  persistent,       // Persistent access gained
}

/// Restricted environment asset for breakout testing
@freezed
sealed class RestrictedEnvironment with _$RestrictedEnvironment {
  const factory RestrictedEnvironment({
    required String id,
    required String name,
    required EnvironmentType environmentType,
    required List<RestrictionMechanism> restrictions,
    required String hostAssetId,           // Host where restriction exists
    String? applicationAssetId,            // Specific app if applicable
    String? networkAssetId,                // Network segment if applicable
    String? description,
    @Default([]) List<String> securityControlIds,
    @Default([]) List<String> breakoutAttemptIds,
    Map<String, String>? environmentDetails,
    DateTime? discoveredAt,
    DateTime? lastTested,
  }) = _RestrictedEnvironment;

  factory RestrictedEnvironment.fromJson(Map<String, dynamic> json) => _$RestrictedEnvironmentFromJson(json);
}

/// Individual breakout attempt
@freezed
sealed class BreakoutAttempt with _$BreakoutAttempt {
  const factory BreakoutAttempt({
    required String id,
    required String name,
    required String restrictedEnvironmentId,
    required String techniqueId,
    required BreakoutStatus status,
    required DateTime attemptedAt,
    String? testerAssetId,                 // Person performing test
    String? description,
    String? command,                       // Command/payload used
    String? output,                        // Command output
    String? evidence,                      // Screenshots, logs, etc.
    BreakoutImpact? impact,
    List<String>? assetsGained,            // New assets accessed
    List<String>? credentialsGained,       // New credentials obtained
    Map<String, String>? attemptDetails,   // Tool-specific data
    String? blockedBy,                     // Security control that blocked
    DateTime? completedAt,
    String? notes,
  }) = _BreakoutAttempt;

  factory BreakoutAttempt.fromJson(Map<String, dynamic> json) => _$BreakoutAttemptFromJson(json);
}

/// Reusable breakout technique
@freezed
sealed class BreakoutTechnique with _$BreakoutTechnique {
  const factory BreakoutTechnique({
    required String id,
    required String name,
    required TechniqueCategory category,
    required List<EnvironmentType> applicableEnvironments,
    required List<RestrictionMechanism> targetsRestrictions,
    String? description,
    String? methodology,                   // Step-by-step process
    String? payload,                       // Example command/code
    List<String>? prerequisites,           // Required conditions
    List<String>? indicators,              // Signs of success
    List<String>? mitigations,             // How to prevent
    String? cveReference,                  // CVE if applicable
    String? source,                        // Where technique came from
    Map<String, String>? metadata,         // MITRE ATT&CK, etc.
    DateTime? discoveredAt,
    DateTime? lastUpdated,
  }) = _BreakoutTechnique;

  factory BreakoutTechnique.fromJson(Map<String, dynamic> json) => _$BreakoutTechniqueFromJson(json);
}

/// Security control that prevents breakouts
@freezed
sealed class SecurityControl with _$SecurityControl {
  const factory SecurityControl({
    required String id,
    required String name,
    required String type,                  // "appLocker", "sandbox", etc.
    required String hostAssetId,
    String? description,
    String? version,
    String? configuration,
    @Default(true) bool enabled,
    @Default([]) List<String> protectedAssets,
    @Default([]) List<String> bypassTechniques,
    Map<String, String>? settings,
    DateTime? installedAt,
    DateTime? lastUpdated,
  }) = _SecurityControl;

  factory SecurityControl.fromJson(Map<String, dynamic> json) => _$SecurityControlFromJson(json);
}

// =============================================================================
// Core Property Value System
// =============================================================================

sealed class AssetPropertyValue {
  const AssetPropertyValue();

  const factory AssetPropertyValue.string(String value) = StringAssetProperty;
  const factory AssetPropertyValue.integer(int value) = IntegerAssetProperty;
  const factory AssetPropertyValue.double(double value) = DoubleAssetProperty;
  const factory AssetPropertyValue.boolean(bool value) = BooleanAssetProperty;
  const factory AssetPropertyValue.stringList(List<String> values) = StringListAssetProperty;
  const factory AssetPropertyValue.dateTime(DateTime value) = DateTimeAssetProperty;
  const factory AssetPropertyValue.map(Map<String, dynamic> value) = MapAssetProperty;
  const factory AssetPropertyValue.objectList(List<Map<String, dynamic>> objects) = ObjectListAssetProperty;

  factory AssetPropertyValue.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'string':
        return AssetPropertyValue.string(json['value'] as String);
      case 'integer':
        return AssetPropertyValue.integer(json['value'] as int);
      case 'double':
        return AssetPropertyValue.double((json['value'] as num).toDouble());
      case 'boolean':
        return AssetPropertyValue.boolean(json['value'] as bool);
      case 'stringList':
        return AssetPropertyValue.stringList(List<String>.from(json['value']));
      case 'dateTime':
        return AssetPropertyValue.dateTime(DateTime.parse(json['value'] as String));
      case 'map':
        return AssetPropertyValue.map(Map<String, dynamic>.from(json['value']));
      case 'objectList':
        return AssetPropertyValue.objectList(
          List<Map<String, dynamic>>.from(json['value'])
        );
      default:
        throw ArgumentError('Unknown AssetPropertyValue type: $type');
    }
  }

  Map<String, dynamic> toJson();

  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  });
}

class StringAssetProperty extends AssetPropertyValue {
  final String value;

  const StringAssetProperty(this.value);

  @override
  Map<String, dynamic> toJson() => {'type': 'string', 'value': value};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => string(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is StringAssetProperty && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class IntegerAssetProperty extends AssetPropertyValue {
  final int value;

  const IntegerAssetProperty(this.value);

  @override
  Map<String, dynamic> toJson() => {'type': 'integer', 'value': value};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => integer(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is IntegerAssetProperty && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class DoubleAssetProperty extends AssetPropertyValue {
  final double value;

  const DoubleAssetProperty(this.value);

  @override
  Map<String, dynamic> toJson() => {'type': 'double', 'value': value};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => double(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is DoubleAssetProperty && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class BooleanAssetProperty extends AssetPropertyValue {
  final bool value;

  const BooleanAssetProperty(this.value);

  @override
  Map<String, dynamic> toJson() => {'type': 'boolean', 'value': value};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => boolean(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is BooleanAssetProperty && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class StringListAssetProperty extends AssetPropertyValue {
  final List<String> values;

  const StringListAssetProperty(this.values);

  @override
  Map<String, dynamic> toJson() => {'type': 'stringList', 'value': values};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => stringList(values);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is StringListAssetProperty && values == other.values);

  @override
  int get hashCode => values.hashCode;
}

class DateTimeAssetProperty extends AssetPropertyValue {
  final DateTime value;

  const DateTimeAssetProperty(this.value);

  @override
  Map<String, dynamic> toJson() => {'type': 'dateTime', 'value': value.toIso8601String()};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => dateTime(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is DateTimeAssetProperty && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class MapAssetProperty extends AssetPropertyValue {
  final Map<String, dynamic> value;

  const MapAssetProperty(this.value);

  @override
  Map<String, dynamic> toJson() => {'type': 'map', 'value': value};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => map(value);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is MapAssetProperty && value == other.value);

  @override
  int get hashCode => value.hashCode;
}

class ObjectListAssetProperty extends AssetPropertyValue {
  final List<Map<String, dynamic>> objects;

  const ObjectListAssetProperty(this.objects);

  @override
  Map<String, dynamic> toJson() => {'type': 'objectList', 'value': objects};

  @override
  T when<T>({
    required T Function(String value) string,
    required T Function(int value) integer,
    required T Function(double value) double,
    required T Function(bool value) boolean,
    required T Function(List<String> values) stringList,
    required T Function(DateTime value) dateTime,
    required T Function(Map<String, dynamic> value) map,
    required T Function(List<Map<String, dynamic>> objects) objectList,
  }) => objectList(objects);

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ObjectListAssetProperty && objects == other.objects);

  @override
  int get hashCode => objects.hashCode;
}

// =============================================================================
// Core Asset Model
// =============================================================================

class Asset {
  final String id;
  final AssetType type;
  final String projectId;
  final String name;
  final String? description;

  // Rich property system - contains all asset-specific data
  final Map<String, AssetPropertyValue> properties;

  // Discovery and status
  final AssetDiscoveryStatus discoveryStatus;
  final DateTime discoveredAt;
  final DateTime? lastUpdated;
  final String? discoveryMethod;
  final double confidence;

  // Hierarchical relationships
  final List<String> parentAssetIds;
  final List<String> childAssetIds;
  final List<String> relatedAssetIds; // Cross-references

  // Methodology integration
  final List<String> completedTriggers;
  final Map<String, TriggerExecutionResult> triggerResults;

  // Organization and filtering
  final List<String> tags;
  final Map<String, String>? metadata;

  // Security context
  final AccessLevel? accessLevel;
  final List<String>? securityControls;

  // NEW RELATIONSHIP SYSTEM FIELDS:
  final Map<String, List<String>> relationships; // Relationship type -> List of asset IDs
  final Map<String, dynamic> inheritedProperties; // Properties inherited from parent
  final String lifecycleState; // Current state in lifecycle
  final Map<String, DateTime> stateTransitions; // History of state changes
  final Map<String, String> dependencyMap; // Service/asset dependencies
  final List<String> discoveryPath; // How this asset was discovered
  final Map<String, dynamic> relationshipMetadata; // Extra data about relationships

  const Asset({
    required this.id,
    required this.type,
    required this.projectId,
    required this.name,
    this.description,
    required this.properties,
    required this.discoveryStatus,
    required this.discoveredAt,
    this.lastUpdated,
    this.discoveryMethod,
    this.confidence = 1.0,
    required this.parentAssetIds,
    required this.childAssetIds,
    required this.relatedAssetIds,
    required this.completedTriggers,
    required this.triggerResults,
    required this.tags,
    this.metadata,
    this.accessLevel,
    this.securityControls,
    this.relationships = const {},
    this.inheritedProperties = const {},
    this.lifecycleState = 'unknown',
    this.stateTransitions = const {},
    this.dependencyMap = const {},
    this.discoveryPath = const [],
    this.relationshipMetadata = const {},
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    final propertiesJson = json['properties'] as Map<String, dynamic>? ?? {};
    final properties = propertiesJson.map(
      (k, v) => MapEntry(k, AssetPropertyValue.fromJson(v as Map<String, dynamic>))
    );

    final triggerResultsJson = json['triggerResults'] as Map<String, dynamic>? ?? {};
    final triggerResults = triggerResultsJson.map(
      (k, v) => MapEntry(k, TriggerExecutionResult.fromJson(v as Map<String, dynamic>))
    );

    final stateTransitionsJson = json['stateTransitions'] as Map<String, dynamic>? ?? {};
    final stateTransitions = stateTransitionsJson.map(
      (k, v) => MapEntry(k, DateTime.parse(v as String))
    );

    final relationshipsJson = json['relationships'] as Map<String, dynamic>? ?? {};
    final relationships = relationshipsJson.map(
      (k, v) => MapEntry(k, List<String>.from(v))
    );

    return Asset(
      id: json['id'] as String,
      type: AssetType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => AssetType.unknown,
      ),
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['discoveryStatus'],
        orElse: () => AssetDiscoveryStatus.unknown,
      ),
      discoveredAt: DateTime.parse(json['discoveredAt'] as String),
      lastUpdated: json['lastUpdated'] != null
        ? DateTime.parse(json['lastUpdated'] as String)
        : null,
      discoveryMethod: json['discoveryMethod'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 1.0,
      parentAssetIds: List<String>.from(json['parentAssetIds'] ?? []),
      childAssetIds: List<String>.from(json['childAssetIds'] ?? []),
      relatedAssetIds: List<String>.from(json['relatedAssetIds'] ?? []),
      completedTriggers: List<String>.from(json['completedTriggers'] ?? []),
      triggerResults: triggerResults,
      tags: List<String>.from(json['tags'] ?? []),
      metadata: json['metadata'] != null
        ? Map<String, String>.from(json['metadata'])
        : null,
      accessLevel: json['accessLevel'] != null
        ? AccessLevel.values.firstWhere(
            (e) => e.toString().split('.').last == json['accessLevel'],
            orElse: () => AccessLevel.none,
          )
        : null,
      securityControls: json['securityControls'] != null
        ? List<String>.from(json['securityControls'])
        : null,
      relationships: relationships,
      inheritedProperties: Map<String, dynamic>.from(json['inheritedProperties'] ?? {}),
      lifecycleState: json['lifecycleState'] as String? ?? 'unknown',
      stateTransitions: stateTransitions,
      dependencyMap: Map<String, String>.from(json['dependencyMap'] ?? {}),
      discoveryPath: List<String>.from(json['discoveryPath'] ?? []),
      relationshipMetadata: Map<String, dynamic>.from(json['relationshipMetadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.toString().split('.').last,
      'projectId': projectId,
      'name': name,
      'description': description,
      'properties': properties.map((k, v) => MapEntry(k, v.toJson())),
      'discoveryStatus': discoveryStatus.toString().split('.').last,
      'discoveredAt': discoveredAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'discoveryMethod': discoveryMethod,
      'confidence': confidence,
      'parentAssetIds': parentAssetIds,
      'childAssetIds': childAssetIds,
      'relatedAssetIds': relatedAssetIds,
      'completedTriggers': completedTriggers,
      'triggerResults': triggerResults.map((k, v) => MapEntry(k, v.toJson())),
      'tags': tags,
      'metadata': metadata,
      'accessLevel': accessLevel?.toString().split('.').last,
      'securityControls': securityControls,
      'relationships': relationships,
      'inheritedProperties': inheritedProperties,
      'lifecycleState': lifecycleState,
      'stateTransitions': stateTransitions.map((k, v) => MapEntry(k, v.toIso8601String())),
      'dependencyMap': dependencyMap,
      'discoveryPath': discoveryPath,
      'relationshipMetadata': relationshipMetadata,
    };
  }

  Asset copyWith({
    String? id,
    AssetType? type,
    String? projectId,
    String? name,
    String? description,
    Map<String, AssetPropertyValue>? properties,
    AssetDiscoveryStatus? discoveryStatus,
    DateTime? discoveredAt,
    DateTime? lastUpdated,
    String? discoveryMethod,
    double? confidence,
    List<String>? parentAssetIds,
    List<String>? childAssetIds,
    List<String>? relatedAssetIds,
    List<String>? completedTriggers,
    Map<String, TriggerExecutionResult>? triggerResults,
    List<String>? tags,
    Map<String, String>? metadata,
    AccessLevel? accessLevel,
    List<String>? securityControls,
    Map<String, List<String>>? relationships,
    Map<String, dynamic>? inheritedProperties,
    String? lifecycleState,
    Map<String, DateTime>? stateTransitions,
    Map<String, String>? dependencyMap,
    List<String>? discoveryPath,
    Map<String, dynamic>? relationshipMetadata,
  }) {
    return Asset(
      id: id ?? this.id,
      type: type ?? this.type,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      properties: properties ?? this.properties,
      discoveryStatus: discoveryStatus ?? this.discoveryStatus,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      discoveryMethod: discoveryMethod ?? this.discoveryMethod,
      confidence: confidence ?? this.confidence,
      parentAssetIds: parentAssetIds ?? this.parentAssetIds,
      childAssetIds: childAssetIds ?? this.childAssetIds,
      relatedAssetIds: relatedAssetIds ?? this.relatedAssetIds,
      completedTriggers: completedTriggers ?? this.completedTriggers,
      triggerResults: triggerResults ?? this.triggerResults,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
      accessLevel: accessLevel ?? this.accessLevel,
      securityControls: securityControls ?? this.securityControls,
      relationships: relationships ?? this.relationships,
      inheritedProperties: inheritedProperties ?? this.inheritedProperties,
      lifecycleState: lifecycleState ?? this.lifecycleState,
      stateTransitions: stateTransitions ?? this.stateTransitions,
      dependencyMap: dependencyMap ?? this.dependencyMap,
      discoveryPath: discoveryPath ?? this.discoveryPath,
      relationshipMetadata: relationshipMetadata ?? this.relationshipMetadata,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Asset &&
            id == other.id &&
            type == other.type &&
            projectId == other.projectId &&
            name == other.name &&
            lifecycleState == other.lifecycleState);
  }

  @override
  int get hashCode => Object.hash(id, type, projectId, name, lifecycleState);

  // Add helper method for default states
  static String _getDefaultState(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return 'identified';
      case AssetType.host:
        return 'discovered';
      case AssetType.service:
        return 'identified';
      default:
        return 'unknown';
    }
  }
}

class TriggerExecutionResult {
  final String triggerId;
  final String methodologyId;
  final DateTime executedAt;
  final bool success;
  final String? output;
  final String? error;
  final Map<String, AssetPropertyValue>? discoveredProperties;
  final List<Asset>? discoveredAssets;
  final List<String>? triggeredMethodologies;

  const TriggerExecutionResult({
    required this.triggerId,
    required this.methodologyId,
    required this.executedAt,
    required this.success,
    this.output,
    this.error,
    this.discoveredProperties,
    this.discoveredAssets,
    this.triggeredMethodologies,
  });

  factory TriggerExecutionResult.fromJson(Map<String, dynamic> json) {
    final discoveredPropertiesJson = json['discoveredProperties'] as Map<String, dynamic>?;
    final discoveredProperties = discoveredPropertiesJson?.map(
      (k, v) => MapEntry(k, AssetPropertyValue.fromJson(v as Map<String, dynamic>))
    );

    final discoveredAssetsJson = json['discoveredAssets'] as List<dynamic>?;
    final discoveredAssets = discoveredAssetsJson?.map(
      (item) => Asset.fromJson(item as Map<String, dynamic>)
    ).toList();

    return TriggerExecutionResult(
      triggerId: json['triggerId'] as String,
      methodologyId: json['methodologyId'] as String,
      executedAt: DateTime.parse(json['executedAt'] as String),
      success: json['success'] as bool,
      output: json['output'] as String?,
      error: json['error'] as String?,
      discoveredProperties: discoveredProperties,
      discoveredAssets: discoveredAssets,
      triggeredMethodologies: json['triggeredMethodologies'] != null
        ? List<String>.from(json['triggeredMethodologies'])
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'triggerId': triggerId,
      'methodologyId': methodologyId,
      'executedAt': executedAt.toIso8601String(),
      'success': success,
      'output': output,
      'error': error,
      'discoveredProperties': discoveredProperties?.map((k, v) => MapEntry(k, v.toJson())),
      'discoveredAssets': discoveredAssets?.map((asset) => asset.toJson()).toList(),
      'triggeredMethodologies': triggeredMethodologies,
    };
  }

  TriggerExecutionResult copyWith({
    String? triggerId,
    String? methodologyId,
    DateTime? executedAt,
    bool? success,
    String? output,
    String? error,
    Map<String, AssetPropertyValue>? discoveredProperties,
    List<Asset>? discoveredAssets,
    List<String>? triggeredMethodologies,
  }) {
    return TriggerExecutionResult(
      triggerId: triggerId ?? this.triggerId,
      methodologyId: methodologyId ?? this.methodologyId,
      executedAt: executedAt ?? this.executedAt,
      success: success ?? this.success,
      output: output ?? this.output,
      error: error ?? this.error,
      discoveredProperties: discoveredProperties ?? this.discoveredProperties,
      discoveredAssets: discoveredAssets ?? this.discoveredAssets,
      triggeredMethodologies: triggeredMethodologies ?? this.triggeredMethodologies,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TriggerExecutionResult &&
            triggerId == other.triggerId &&
            methodologyId == other.methodologyId &&
            executedAt == other.executedAt &&
            success == other.success);
  }

  @override
  int get hashCode => Object.hash(triggerId, methodologyId, executedAt, success);
}

// =============================================================================
// Specialized Asset Models
// =============================================================================

/// Version information for software
@freezed
sealed class SoftwareVersion with _$SoftwareVersion {
  const factory SoftwareVersion({
    required int major,
    required int minor,
    required int patch,
    String? build,
    String? edition,
    DateTime? releaseDate,
  }) = _SoftwareVersion;

  factory SoftwareVersion.fromJson(Map<String, dynamic> json) => _$SoftwareVersionFromJson(json);
}

/// Network address information
@freezed
sealed class NetworkAddress with _$NetworkAddress {
  const factory NetworkAddress({
    required String ip,
    String? subnet,
    String? gateway,
    List<String>? dnsServers,
    String? macAddress,
    bool? isStatic,
  }) = _NetworkAddress;

  factory NetworkAddress.fromJson(Map<String, dynamic> json) => _$NetworkAddressFromJson(json);
}

/// Geographic location
@freezed
sealed class PhysicalLocation with _$PhysicalLocation {
  const factory PhysicalLocation({
    String? address,
    String? city,
    String? state,
    String? country,
    String? postalCode,
    double? latitude,
    double? longitude,
    String? building,
    String? floor,
    String? room,
  }) = _PhysicalLocation;

  factory PhysicalLocation.fromJson(Map<String, dynamic> json) => _$PhysicalLocationFromJson(json);
}

/// Network interface information for hosts
@freezed
sealed class NetworkInterface with _$NetworkInterface {
  const factory NetworkInterface({
    required String id,
    required String name,                // "eth0", "Ethernet", "Wi-Fi"
    required String type,                // "ethernet", "wireless", "loopback", "virtual"
    required String macAddress,
    required bool isEnabled,
    required List<NetworkAddress> addresses,
    String? description,
    String? vendor,
    String? driver,
    int? speedMbps,
    bool? isConnected,
    String? connectedSwitchPort,
    String? vlanId,
    Map<String, String>? driverInfo,
    DateTime? lastSeen,
  }) = _NetworkInterface;

  factory NetworkInterface.fromJson(Map<String, dynamic> json) => _$NetworkInterfaceFromJson(json);
}

/// Running service on a host
@freezed
sealed class HostService with _$HostService {
  const factory HostService({
    required String id,
    required String name,
    required int port,
    required String protocol,            // "tcp", "udp"
    required String state,               // "open", "filtered", "closed"
    String? version,
    String? banner,
    String? productName,
    String? productVersion,
    Map<String, String>? extraInfo,
    List<String>? vulnerabilities,
    bool? requiresAuthentication,
    List<String>? authenticationMethods,
    String? sslVersion,
    List<String>? sslCiphers,
    DateTime? lastChecked,
    String? confidence,                  // "low", "medium", "high"
  }) = _HostService;

  factory HostService.fromJson(Map<String, dynamic> json) => _$HostServiceFromJson(json);
}

/// Installed application on a host
@freezed
sealed class HostApplication with _$HostApplication {
  const factory HostApplication({
    required String id,
    required String name,
    required String type,                // "system", "user", "service", "driver"
    String? version,
    String? vendor,
    String? architecture,                // "x64", "x86", "any"
    String? installLocation,
    DateTime? installDate,
    int? sizeMB,
    List<String>? configFiles,
    List<String>? dataDirectories,
    List<String>? registryKeys,
    List<String>? associatedServices,    // HostService IDs
    List<String>? networkPorts,
    List<String>? vulnerabilities,
    bool? isSystemCritical,
    bool? hasUpdateAvailable,
    String? licenseType,
    String? licenseKey,
    Map<String, String>? metadata,
  }) = _HostApplication;

  factory HostApplication.fromJson(Map<String, dynamic> json) => _$HostApplicationFromJson(json);
}

/// User account on a host
@freezed
sealed class HostAccount with _$HostAccount {
  const factory HostAccount({
    required String id,
    required String username,
    required String type,                // "local", "domain", "service", "system"
    required bool isEnabled,
    String? fullName,
    String? description,
    List<String>? groups,
    String? homeDirectory,
    String? shell,
    DateTime? lastLogin,
    DateTime? passwordLastSet,
    bool? passwordNeverExpires,
    bool? accountLocked,
    bool? isAdmin,
    List<String>? privileges,
    Map<String, String>? environment,
  }) = _HostAccount;

  factory HostAccount.fromJson(Map<String, dynamic> json) => _$HostAccountFromJson(json);
}

/// Hardware component information
@freezed
sealed class HardwareComponent with _$HardwareComponent {
  const factory HardwareComponent({
    required String id,
    required String type,                // "cpu", "memory", "disk", "gpu", "motherboard"
    required String name,
    String? manufacturer,
    String? model,
    String? serialNumber,
    String? version,
    Map<String, String>? specifications,
    String? health,                      // "good", "warning", "critical", "unknown"
    DateTime? lastChecked,
  }) = _HardwareComponent;

  factory HardwareComponent.fromJson(Map<String, dynamic> json) => _$HardwareComponentFromJson(json);
}

/// Authentication information
@freezed
sealed class AuthenticationInfo with _$AuthenticationInfo {
  const factory AuthenticationInfo({
    required String mechanism, // "password", "certificate", "kerberos", etc.
    Map<String, String>? details,
    bool? isMultiFactor,
    List<String>? mfaMethods,
    DateTime? lastAuthentication,
    bool? isServiceAccount,
  }) = _AuthenticationInfo;

  factory AuthenticationInfo.fromJson(Map<String, dynamic> json) => _$AuthenticationInfoFromJson(json);
}

// =============================================================================
// Asset Property Schemas
// =============================================================================

/// Defines the expected properties for each asset type
class AssetSchemas {

  /// Environment properties (top-level container)
  static const environmentProperties = {
    'environment_type': 'string',        // "physical", "cloud", "hybrid"
    'organization': 'string',
    'classification': 'string',          // "public", "confidential", "secret"
    'compliance_frameworks': 'stringList', // ["SOX", "PCI-DSS", "HIPAA"]
    'primary_domain': 'string',
    'location': 'map',                   // PhysicalLocation as Map
    'network_ranges': 'stringList',      // ["10.0.0.0/8", "192.168.0.0/16"]
    'entry_points': 'objectList',        // Points where testing began
  };

  /// Physical site properties
  static const physicalSiteProperties = {
    'site_type': 'string',              // "office", "datacenter", "warehouse"
    'location': 'map',                  // PhysicalLocation
    'business_hours': 'map',            // Schedule information
    'security_level': 'string',         // "low", "medium", "high", "critical"
    'access_controls': 'stringList',    // ["badge", "biometric", "guard"]
    'surveillance': 'boolean',
    'visitor_policy': 'string',
    'emergency_exits': 'integer',
    'parking_areas': 'stringList',
    'loading_docks': 'integer',
    'employee_count': 'integer',
  };

  /// Physical area properties (rooms, floors)
  static const physicalAreaProperties = {
    'area_type': 'string',              // "office", "server_room", "reception"
    'floor': 'string',
    'room_number': 'string',
    'access_level': 'string',           // AccessLevel enum
    'access_controls': 'stringList',
    'surveillance_coverage': 'boolean',
    'sensitive_equipment': 'stringList',
    'network_outlets': 'integer',
    'wireless_coverage': 'stringList',  // SSID list
    'persons_with_access': 'stringList', // Person asset IDs
  };

  /// Network segment properties
  static const networkSegmentProperties = {
    // === BASIC NETWORK CONFIGURATION ===
    'subnet': 'string',                 // "192.168.1.0/24"
    'vlan_id': 'integer',
    'network_name': 'string',
    'gateway': 'string',
    'dns_servers': 'stringList',
    'dhcp_enabled': 'boolean',
    'dhcp_range_start': 'string',       // "192.168.1.100"
    'dhcp_range_end': 'string',         // "192.168.1.200"
    'domain_name': 'string',

    // === SECURITY CONTROLS ===
    'nac_enabled': 'boolean',
    'nac_type': 'string',               // NacType enum
    'nac_bypass_methods': 'stringList', // Known bypass techniques
    'firewall_rules': 'objectList',     // NetworkFirewallRule objects
    'ips_enabled': 'boolean',
    'ips_signatures': 'stringList',     // IPS signature sets
    'network_monitoring': 'boolean',
    'monitoring_tools': 'stringList',   // SIEM, packet capture, etc.
    'security_policies': 'objectList',  // Applied security policies

    // === PENTESTING ACCESS ===
    'access_points': 'objectList',      // NetworkAccessPoint objects
    'current_access_level': 'string',   // NetworkAccessType enum
    'compromised_hosts': 'stringList',  // Asset IDs of compromised hosts
    'pivot_opportunities': 'stringList', // Potential pivot paths
    'implants_deployed': 'objectList',  // Deployed implants/backdoors

    // === HOST INVENTORY ===
    'network_hosts': 'objectList',      // NetworkHostReference objects
    'network_devices': 'stringList',    // Asset IDs of routers/switches
    'wireless_aps': 'stringList',       // Asset IDs of wireless APs
    'unknown_devices': 'stringList',    // Unidentified MAC addresses

    // === ROUTING & CONNECTIVITY ===
    'routing_table': 'objectList',      // NetworkRoute objects
    'connected_networks': 'stringList', // Asset IDs of connected network segments
    'isolated': 'boolean',
    'internet_access': 'boolean',
    'internet_gateway': 'string',       // IP of internet gateway
    'external_connections': 'stringList', // VPN, WAN links, etc.

    // === TRAFFIC ANALYSIS ===
    'traffic_patterns': 'objectList',   // Network traffic analysis
    'port_usage': 'objectList',         // Common ports and protocols
    'bandwidth_usage': 'string',        // Current utilization
    'peak_traffic_times': 'stringList', // When network is busiest
  };

  /// Host properties - organized by category and OS-specific
  static const hostProperties = {
    // === BASIC IDENTIFICATION ===
    'hostname': 'string',
    'fqdn': 'string',
    'domain_membership': 'string',
    'computer_description': 'string',
    'asset_tag': 'string',

    // === OPERATING SYSTEM ===
    'os_family': 'string',              // "windows", "linux", "macos", "unix"
    'os_name': 'string',                // "Windows Server 2019", "Ubuntu 20.04"
    'os_version': 'string',
    'os_architecture': 'string',        // "x64", "x86", "arm64"
    'os_build': 'string',
    'patch_level': 'string',
    'kernel_version': 'string',
    'last_boot_time': 'dateTime',
    'timezone': 'string',

    // === HARDWARE INFORMATION ===
    'hardware_type': 'string',          // "physical", "virtual", "container"
    'manufacturer': 'string',
    'model': 'string',
    'serial_number': 'string',
    'bios_version': 'string',
    'cpu_cores': 'integer',
    'memory_gb': 'integer',
    'total_disk_space_gb': 'integer',
    'free_disk_space_gb': 'integer',

    // === STRUCTURED COMPONENTS ===
    'network_interfaces': 'objectList', // NetworkInterface objects
    'installed_applications': 'objectList', // HostApplication objects
    'running_services': 'objectList',   // HostService objects
    'user_accounts': 'objectList',      // HostAccount objects
    'hardware_components': 'objectList', // HardwareComponent objects

    // === GENERAL SECURITY ===
    'antivirus_products': 'stringList',
    'host_firewall_enabled': 'boolean',
    'encryption_status': 'string',      // "none", "bitlocker", "filevault", "luks", "dm-crypt"
    'secure_boot_enabled': 'boolean',

    // === ACCESS & CREDENTIALS ===
    'access_level': 'string',           // Current access level
    'privilege_escalation_possible': 'boolean',
    'cached_credentials': 'stringList', // Credential asset IDs
    'stored_passwords': 'stringList',

    // === VULNERABILITIES & COMPLIANCE ===
    'missing_patches': 'objectList',    // {patch_id, description, severity, release_date}
    'vulnerabilities': 'stringList',    // Vulnerability asset IDs
    'configuration_issues': 'stringList',
    'compliance_frameworks': 'stringList', // "CIS", "NIST", "STIG"
    'security_score': 'integer',

    // === MONITORING & LOGGING ===
    'log_sources': 'stringList',
    'monitoring_agents': 'stringList',
    'remote_management_tools': 'stringList',

    // === WINDOWS-SPECIFIC PROPERTIES ===
    'windows_uac_enabled': 'boolean',
    'windows_registry_keys': 'objectList',
    'windows_event_logs': 'stringList',
    'windows_domain_controller': 'boolean',
    'windows_workgroup': 'string',
    'windows_computer_role': 'string',  // "workstation", "server", "domain_controller"
    'windows_defender_enabled': 'boolean',
    'windows_rdp_enabled': 'boolean',
    'windows_admin_shares_enabled': 'boolean',
    'windows_powershell_version': 'string',
    'windows_net_framework_versions': 'stringList',

    // === LINUX-SPECIFIC PROPERTIES ===
    'linux_distribution': 'string',    // "ubuntu", "centos", "rhel", "debian"
    'linux_distribution_version': 'string',
    'linux_package_manager': 'string', // "apt", "yum", "pacman", "zypper"
    'linux_init_system': 'string',     // "systemd", "sysv", "upstart"
    'linux_selinux_status': 'string',  // "enforcing", "permissive", "disabled"
    'linux_sudo_rules': 'objectList',
    'linux_cron_jobs': 'stringList',
    'linux_systemd_services': 'stringList',
    'linux_iptables_rules': 'objectList',
    'linux_mounted_filesystems': 'objectList',

    // === MACOS-SPECIFIC PROPERTIES ===
    'macos_version_name': 'string',     // "Monterey", "Big Sur", "Ventura"
    'macos_sip_enabled': 'boolean',     // System Integrity Protection
    'macos_gatekeeper_enabled': 'boolean',
    'macos_filevault_enabled': 'boolean',
    'macos_xprotect_version': 'string',
    'macos_launch_daemons': 'stringList',
    'macos_launch_agents': 'stringList',

    // === VIRTUALIZATION ===
    'virtualization_platform': 'string', // "vmware", "hyper-v", "kvm", "docker"
    'container_runtime': 'string',      // "docker", "containerd", "podman"
    'hypervisor_version': 'string',
  };

  /// Service properties - organized by service type
  static const serviceProperties = {
    // === BASIC SERVICE INFORMATION ===
    'port': 'integer',
    'protocol': 'string',               // "tcp", "udp"
    'service_name': 'string',           // "http", "smb", "ssh", "rdp"
    'service_version': 'string',
    'service_banner': 'string',
    'state': 'string',                  // "open", "filtered", "closed"
    'process_name': 'string',
    'process_id': 'integer',

    // === AUTHENTICATION & SECURITY ===
    'authentication_required': 'boolean',
    'authentication_methods': 'stringList', // ["basic", "digest", "ntlm", "kerberos", "certificate"]
    'default_credentials': 'boolean',
    'weak_credentials': 'boolean',
    'anonymous_access_allowed': 'boolean',
    'guest_access_allowed': 'boolean',

    // === SSL/TLS CONFIGURATION ===
    'ssl_enabled': 'boolean',
    'ssl_version': 'string',            // "TLS 1.2", "TLS 1.3"
    'ssl_certificate_cn': 'string',
    'ssl_certificate_issuer': 'string',
    'ssl_certificate_expiry': 'dateTime',
    'ssl_ciphers': 'stringList',
    'ssl_vulnerabilities': 'stringList',

    // === WEB SERVICES (HTTP/HTTPS) ===
    'web_server': 'string',             // "Apache", "nginx", "IIS"
    'web_server_version': 'string',
    'web_technologies': 'stringList',   // ["PHP", "ASP.NET", "Node.js"]
    'web_applications': 'stringList',   // ["WordPress", "Drupal", "Joomla"]
    'http_methods_allowed': 'stringList', // ["GET", "POST", "PUT", "DELETE"]
    'http_headers': 'map',              // Custom HTTP headers
    'api_endpoints': 'stringList',
    'web_directories': 'stringList',

    // === SMB/CIFS SERVICES ===
    'smb_version': 'string',            // "SMB1", "SMB2", "SMB3"
    'smb_signing_required': 'boolean',
    'smb_signing_enabled': 'boolean',
    'smb_shares': 'objectList',         // [{name, path, permissions, description}]
    'smb_null_sessions_allowed': 'boolean',
    'smb_message_signing': 'string',    // "required", "enabled", "disabled"

    // === SSH SERVICES ===
    'ssh_version': 'string',            // "OpenSSH 8.0"
    'ssh_host_key_algorithms': 'stringList',
    'ssh_encryption_algorithms': 'stringList',
    'ssh_mac_algorithms': 'stringList',
    'ssh_root_login_allowed': 'boolean',
    'ssh_password_auth_enabled': 'boolean',
    'ssh_key_auth_enabled': 'boolean',
    'ssh_users_allowed': 'stringList',

    // === RDP SERVICES ===
    'rdp_version': 'string',
    'rdp_encryption_level': 'string',   // "None", "Low", "Client Compatible", "High", "FIPS"
    'rdp_nla_enabled': 'boolean',       // Network Level Authentication
    'rdp_security_layer': 'string',     // "RDP", "TLS", "Negotiate"

    // === FTP SERVICES ===
    'ftp_type': 'string',               // "FTP", "FTPS", "SFTP"
    'ftp_anonymous_access': 'boolean',
    'ftp_passive_mode_enabled': 'boolean',
    'ftp_root_directory': 'string',
    'ftp_users_allowed': 'stringList',

    // === DATABASE SERVICES ===
    'database_type': 'string',          // "mysql", "postgresql", "mssql", "oracle"
    'database_version': 'string',
    'database_engine': 'string',
    'database_names': 'stringList',
    'database_users': 'stringList',
    'database_encryption_enabled': 'boolean',

    // === MAIL SERVICES ===
    'mail_service_type': 'string',      // "SMTP", "POP3", "IMAP"
    'mail_server_software': 'string',   // "Exchange", "Postfix", "Sendmail"
    'mail_domains': 'stringList',
    'mail_relay_enabled': 'boolean',
    'mail_authentication_required': 'boolean',

    // === DNS SERVICES ===
    'dns_server_software': 'string',    // "BIND", "Windows DNS", "PowerDNS"
    'dns_zones': 'stringList',
    'dns_recursion_enabled': 'boolean',
    'dns_zone_transfers_allowed': 'boolean',
    'dns_forwarders': 'stringList',

    // === LDAP/AD SERVICES ===
    'ldap_base_dn': 'string',
    'ldap_bind_authentication': 'boolean',
    'ldap_ssl_enabled': 'boolean',
    'ad_domain_name': 'string',
    'ad_forest_level': 'string',
    'ad_domain_controllers': 'stringList',

    // === SNMP SERVICES ===
    'snmp_version': 'string',           // "v1", "v2c", "v3"
    'snmp_community_strings': 'stringList',
    'snmp_users': 'stringList',
    'snmp_oids': 'stringList',

    // === VULNERABILITIES & ISSUES ===
    'service_vulnerabilities': 'stringList', // CVE IDs
    'configuration_issues': 'stringList',
    'security_warnings': 'stringList',
    'compliance_status': 'string',
  };

  /// Software properties
  static const softwareProperties = {
    'vendor': 'string',
    'product_name': 'string',
    'version': 'map',                   // SoftwareVersion object
    'architecture': 'string',           // "x64", "x86", "any"
    'installation_path': 'string',
    'installation_date': 'dateTime',
    'license_type': 'string',
    'configuration_files': 'stringList', // File asset IDs
    'data_directories': 'stringList',
    'log_files': 'stringList',
    'service_accounts': 'stringList',   // Identity asset IDs
    'network_ports': 'stringList',      // Ports used by software
    'dependencies': 'stringList',       // Other software asset IDs
    'vulnerabilities': 'stringList',    // Vulnerability asset IDs
    'patches_available': 'stringList',
    'end_of_life': 'boolean',
  };

  /// File properties
  static const fileProperties = {
    'file_type': 'string',              // "vmdk", "backup", "config", "database"
    'file_path': 'string',
    'file_size_bytes': 'integer',
    'file_hash_md5': 'string',
    'file_hash_sha256': 'string',
    'creation_date': 'dateTime',
    'modification_date': 'dateTime',
    'access_date': 'dateTime',
    'owner': 'string',
    'permissions': 'string',
    'encryption_status': 'string',      // "none", "encrypted", "unknown"
    'compression': 'string',
    'file_format': 'string',
    'contains_credentials': 'boolean',
    'contains_sensitive_data': 'boolean',
    'source_system': 'string',          // Host asset ID
    'backup_date': 'dateTime',          // For backup files
    'mount_point': 'string',            // For disk images
    'file_system': 'string',            // "ntfs", "ext4", "vmfs"
  };

  /// Wireless network properties
  static const wirelessNetworkProperties = {
    'ssid': 'string',
    'bssid': 'string',
    'channel': 'integer',
    'frequency_band': 'string',         // "2.4GHz", "5GHz", "6GHz"
    'signal_strength': 'integer',       // dBm
    'encryption_type': 'string',        // "open", "wep", "wpa2", "wpa3", "enterprise"
    'authentication_method': 'string',  // "psk", "eap", "none"
    'hidden_ssid': 'boolean',
    'captive_portal': 'boolean',
    'max_speed_mbps': 'integer',
    'connected_clients': 'stringList',  // WirelessClient asset IDs
    'access_point_vendor': 'string',
    'access_point_model': 'string',
    'wps_enabled': 'boolean',
    'guest_network': 'boolean',
    'bridges_to_network': 'string',     // NetworkSegment asset ID
  };

  /// Cloud tenant properties (Azure, AWS, etc.)
  static const cloudTenantProperties = {
    'tenant_type': 'string',            // "azure", "aws", "gcp"
    'tenant_id': 'string',
    'tenant_name': 'string',
    'primary_domain': 'string',
    'subscription_ids': 'stringList',
    'billing_account': 'string',
    'licensing_info': 'map',
    'compliance_status': 'map',
    'hybrid_connection': 'boolean',
    'on_premises_sync': 'boolean',
    'federated_domains': 'stringList',
    'conditional_access_policies': 'stringList',
    'security_defaults_enabled': 'boolean',
    'mfa_enforcement': 'string',        // "none", "conditional", "all_users"
    'privileged_roles': 'stringList',
    'service_principals': 'stringList', // CloudIdentity asset IDs
    'applications': 'stringList',       // Application registrations
  };

  /// Cloud identity properties (Azure AD, IAM users)
  static const cloudIdentityProperties = {
    'identity_type': 'string',          // "user", "service_principal", "group", "application"
    'object_id': 'string',
    'upn': 'string',                    // User Principal Name
    'display_name': 'string',
    'email': 'string',
    'department': 'string',
    'job_title': 'string',
    'manager': 'string',                // Another identity asset ID
    'account_enabled': 'boolean',
    'password_never_expires': 'boolean',
    'mfa_registered': 'boolean',
    'mfa_methods': 'stringList',
    'privileged_roles': 'stringList',
    'group_memberships': 'stringList',  // Group asset IDs
    'application_permissions': 'stringList',
    'oauth_permissions': 'stringList',
    'conditional_access_status': 'string',
    'risk_level': 'string',             // "low", "medium", "high"
    'last_sign_in': 'dateTime',
    'sign_in_frequency': 'string',
    'devices_registered': 'stringList', // Device asset IDs
    'synced_from_ad': 'boolean',
    'ad_user_id': 'string',             // On-premises AD user
  };

  /// Restricted Environment properties for breakout testing
  static const restrictedEnvironmentProperties = {
    // === ENVIRONMENT DETAILS ===
    'environment_type': 'string',          // EnvironmentType enum
    'restrictions': 'stringList',          // RestrictionMechanism enum list
    'host_asset_id': 'string',             // Host where restriction exists
    'application_asset_id': 'string',      // App being restricted
    'network_asset_id': 'string',          // Network segment if applicable

    // === CONFIGURATION ===
    'configuration': 'map',                // Environment configuration
    'security_policies': 'stringList',     // Applied policies
    'allowed_executables': 'stringList',   // Whitelisted apps/commands
    'blocked_executables': 'stringList',   // Blacklisted apps/commands
    'allowed_directories': 'stringList',   // Accessible paths
    'restricted_directories': 'stringList', // Blocked paths

    // === NETWORK RESTRICTIONS ===
    'allowed_urls': 'stringList',          // Whitelisted URLs
    'blocked_urls': 'stringList',          // Blacklisted URLs
    'allowed_ports': 'stringList',         // Allowed network ports
    'blocked_ports': 'stringList',         // Blocked network ports
    'proxy_settings': 'map',               // Proxy configuration

    // === USER CONTEXT ===
    'user_context': 'string',              // User running in restriction
    'privilege_level': 'string',           // Current privilege level
    'group_memberships': 'stringList',     // Groups user belongs to

    // === BREAKOUT HISTORY ===
    'breakout_attempts': 'objectList',     // BreakoutAttempt references
    'successful_breakouts': 'integer',     // Count of successful escapes
    'failed_breakouts': 'integer',         // Count of failed attempts
    'last_tested': 'dateTime',             // Last breakout test
    'security_controls': 'stringList',     // SecurityControl asset IDs
  };

  /// Breakout Attempt properties
  static const breakoutAttemptProperties = {
    // === ATTEMPT DETAILS ===
    'restricted_environment_id': 'string', // RestrictedEnvironment asset ID
    'technique_id': 'string',              // BreakoutTechnique asset ID
    'status': 'string',                    // BreakoutStatus enum
    'attempted_at': 'dateTime',
    'completed_at': 'dateTime',
    'duration_minutes': 'integer',

    // === EXECUTION ===
    'command': 'string',                   // Command/payload used
    'command_output': 'string',            // Output from command
    'error_output': 'string',              // Error messages
    'evidence_files': 'stringList',        // Screenshots, logs
    'tools_used': 'stringList',            // Tools/scripts used

    // === RESULTS ===
    'impact': 'string',                    // BreakoutImpact enum
    'assets_gained': 'stringList',         // New assets accessed
    'credentials_gained': 'stringList',    // New credentials obtained
    'privileges_gained': 'stringList',     // New privileges obtained
    'persistence_achieved': 'boolean',     // Persistent access?

    // === BLOCKING ===
    'blocked_by': 'string',                // Security control that blocked
    'block_reason': 'string',              // Why it was blocked
    'bypass_attempted': 'boolean',         // Tried to bypass block?
    'bypass_successful': 'boolean',        // Bypass worked?
  };

  /// Breakout Technique properties
  static const breakoutTechniqueProperties = {
    // === TECHNIQUE DETAILS ===
    'category': 'string',                  // TechniqueCategory enum
    'applicable_environments': 'stringList', // EnvironmentType enums
    'targets_restrictions': 'stringList',  // RestrictionMechanism enums
    'complexity': 'string',                // low, medium, high
    'reliability': 'string',               // Percentage success rate

    // === METHODOLOGY ===
    'methodology': 'string',                // Step-by-step process
    'payload': 'string',                   // Example command/code
    'prerequisites': 'stringList',         // Required conditions
    'indicators': 'stringList',            // Signs of success
    'artifacts': 'stringList',             // What it leaves behind

    // === REFERENCES ===
    'cve_reference': 'string',             // CVE if applicable
    'mitre_attack_id': 'string',          // MITRE ATT&CK reference
    'source': 'string',                    // Where technique came from
    'references': 'stringList',            // External references

    // === MITIGATION ===
    'mitigations': 'stringList',           // How to prevent
    'detection_methods': 'stringList',     // How to detect
    'severity': 'string',                  // Impact severity
  };

  /// Security Control properties
  static const securityControlProperties = {
    // === CONTROL DETAILS ===
    'control_type': 'string',              // Type of control
    'vendor': 'string',                    // Vendor/manufacturer
    'version': 'string',                   // Version number
    'host_asset_id': 'string',             // Host where installed

    // === CONFIGURATION ===
    'configuration': 'map',                // Full configuration
    'enabled': 'boolean',                  // Is it active?
    'enforcement_mode': 'string',          // Block, audit, disabled
    'policy_files': 'stringList',          // Policy file paths

    // === PROTECTION ===
    'protected_assets': 'stringList',      // Assets it protects
    'protected_paths': 'stringList',       // File paths protected
    'protected_processes': 'stringList',   // Processes protected
    'protected_services': 'stringList',    // Services protected

    // === BYPASS ===
    'known_bypasses': 'stringList',        // BreakoutTechnique IDs
    'bypass_attempts': 'integer',          // Times bypass attempted
    'bypass_successes': 'integer',         // Times bypass succeeded
    'last_bypass': 'dateTime',             // Last successful bypass
  };

  /// Person properties (for social engineering)
  static const personProperties = {
    'full_name': 'string',
    'first_name': 'string',
    'last_name': 'string',
    'job_title': 'string',
    'department': 'string',
    'manager_name': 'string',
    'email_address': 'string',
    'phone_number': 'string',
    'employee_id': 'string',
    'hire_date': 'dateTime',
    'security_clearance': 'string',
    'training_completed': 'stringList',
    'security_awareness_level': 'string', // "low", "medium", "high"
    'social_media_profiles': 'stringList',
    'interests': 'stringList',
    'works_remotely': 'boolean',
    'physical_access_areas': 'stringList', // PhysicalArea asset IDs
    'system_access': 'stringList',      // System/application access
    'privileged_access': 'boolean',
    'password_policy_compliant': 'boolean',
    'incident_history': 'stringList',   // Previous security incidents
  };
}

// =============================================================================
// Asset Factory for Creating Assets
// =============================================================================

class AssetFactory {
  static final _uuid = const Uuid();

  /// Create an environment asset (top-level container)
  static Asset createEnvironment({
    required String projectId,
    required String name,
    required String environmentType, // "physical", "cloud", "hybrid"
    String? organization,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'environment_type': AssetPropertyValue.string(environmentType),
      if (organization != null) 'organization': AssetPropertyValue.string(organization),
      'compliance_frameworks': const AssetPropertyValue.stringList([]),
      'network_ranges': const AssetPropertyValue.stringList([]),
      'entry_points': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.environment,
      projectId: projectId,
      name: name,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['environment', environmentType],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: {},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.environment),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.environment): DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  /// Create a network segment asset
  static Asset createNetworkSegment({
    required String projectId,
    required String subnet,
    String? name,
    int? vlanId,
    String? gateway,
    String? environmentId,
    NacType nacType = NacType.none,
    NetworkAccessType accessType = NetworkAccessType.none,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      // Basic network configuration
      'subnet': AssetPropertyValue.string(subnet),
      if (vlanId != null) 'vlan_id': AssetPropertyValue.integer(vlanId),
      if (gateway != null) 'gateway': AssetPropertyValue.string(gateway),
      'dns_servers': const AssetPropertyValue.stringList([]),
      'dhcp_enabled': const AssetPropertyValue.boolean(true),
      'domain_name': const AssetPropertyValue.string(''),

      // Security controls
      'nac_enabled': AssetPropertyValue.boolean(nacType != NacType.none),
      'nac_type': AssetPropertyValue.string(nacType.name),
      'nac_bypass_methods': const AssetPropertyValue.stringList([]),
      'firewall_rules': const AssetPropertyValue.objectList([]),
      'ips_enabled': const AssetPropertyValue.boolean(false),
      'network_monitoring': const AssetPropertyValue.boolean(false),
      'security_policies': const AssetPropertyValue.objectList([]),

      // Pentesting access
      'access_points': const AssetPropertyValue.objectList([]),
      'current_access_level': AssetPropertyValue.string(accessType.name),
      'compromised_hosts': const AssetPropertyValue.stringList([]),
      'pivot_opportunities': const AssetPropertyValue.stringList([]),
      'implants_deployed': const AssetPropertyValue.objectList([]),

      // Host inventory
      'network_hosts': const AssetPropertyValue.objectList([]),
      'network_devices': const AssetPropertyValue.stringList([]),
      'wireless_aps': const AssetPropertyValue.stringList([]),
      'unknown_devices': const AssetPropertyValue.stringList([]),

      // Routing & connectivity
      'routing_table': const AssetPropertyValue.objectList([]),
      'connected_networks': const AssetPropertyValue.stringList([]),
      'isolated': const AssetPropertyValue.boolean(false),
      'internet_access': const AssetPropertyValue.boolean(true),
      'internet_gateway': AssetPropertyValue.string(gateway ?? ''),
      'external_connections': const AssetPropertyValue.stringList([]),

      // Traffic analysis
      'traffic_patterns': const AssetPropertyValue.objectList([]),
      'port_usage': const AssetPropertyValue.objectList([]),
      'bandwidth_usage': const AssetPropertyValue.string('Unknown'),
      'peak_traffic_times': const AssetPropertyValue.stringList([]),

      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.networkSegment,
      projectId: projectId,
      name: name ?? 'Network $subnet',
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: environmentId != null ? [environmentId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['network', 'segment'],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: environmentId != null ? {'childOf': [environmentId]} : {},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.networkSegment),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.networkSegment): DateTime.now()},
      dependencyMap: {},
      discoveryPath: environmentId != null ? [environmentId] : [],
      relationshipMetadata: {},
    );
  }

  /// Create a host asset
  static Asset createHost({
    required String projectId,
    required String ipAddress,
    String? hostname,
    String? networkSegmentId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final address = NetworkAddress(ip: ipAddress);
    final properties = <String, AssetPropertyValue>{
      'addresses': AssetPropertyValue.objectList([address.toJson()]),
      if (hostname != null) 'hostname': AssetPropertyValue.string(hostname),
      'os_family': const AssetPropertyValue.string('unknown'),
      'hardware_type': const AssetPropertyValue.string('unknown'),
      'open_ports': const AssetPropertyValue.objectList([]),
      'running_services': const AssetPropertyValue.stringList([]),
      'access_level': AssetPropertyValue.string(AccessLevel.none.name),
      'vulnerabilities': const AssetPropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.host,
      projectId: projectId,
      name: hostname ?? ipAddress,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: networkSegmentId != null ? [networkSegmentId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['host'],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: networkSegmentId != null ? {'childOf': [networkSegmentId]} : {},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.host),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.host): DateTime.now()},
      dependencyMap: {},
      discoveryPath: networkSegmentId != null ? [networkSegmentId] : [],
      relationshipMetadata: {},
    );
  }

  /// Create a cloud tenant asset
  static Asset createCloudTenant({
    required String projectId,
    required String tenantName,
    required String tenantType, // "azure", "aws", "gcp"
    String? tenantId,
    String? environmentId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'tenant_type': AssetPropertyValue.string(tenantType),
      if (tenantId != null) 'tenant_id': AssetPropertyValue.string(tenantId),
      'tenant_name': AssetPropertyValue.string(tenantName),
      'subscription_ids': const AssetPropertyValue.stringList([]),
      'hybrid_connection': const AssetPropertyValue.boolean(false),
      'security_defaults_enabled': const AssetPropertyValue.boolean(false),
      'privileged_roles': const AssetPropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.cloudTenant,
      projectId: projectId,
      name: tenantName,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: environmentId != null ? [environmentId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['cloud', tenantType],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: environmentId != null ? {'childOf': [environmentId]} : {},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.cloudTenant),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.cloudTenant): DateTime.now()},
      dependencyMap: {},
      discoveryPath: environmentId != null ? [environmentId] : [],
      relationshipMetadata: {},
    );
  }

  /// Create a wireless network asset
  static Asset createWirelessNetwork({
    required String projectId,
    required String ssid,
    String? bssid,
    String? encryptionType,
    String? physicalSiteId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'ssid': AssetPropertyValue.string(ssid),
      if (bssid != null) 'bssid': AssetPropertyValue.string(bssid),
      'encryption_type': AssetPropertyValue.string(encryptionType ?? 'unknown'),
      'hidden_ssid': const AssetPropertyValue.boolean(false),
      'captive_portal': const AssetPropertyValue.boolean(false),
      'connected_clients': const AssetPropertyValue.stringList([]),
      'wps_enabled': const AssetPropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.wirelessNetwork,
      projectId: projectId,
      name: ssid,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: physicalSiteId != null ? [physicalSiteId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['wireless', 'network'],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: physicalSiteId != null ? {'childOf': [physicalSiteId]} : {},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.wirelessNetwork),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.wirelessNetwork): DateTime.now()},
      dependencyMap: {},
      discoveryPath: physicalSiteId != null ? [physicalSiteId] : [],
      relationshipMetadata: {},
    );
  }

  /// Create a restricted environment asset for breakout testing
  static Asset createRestrictedEnvironment({
    required String projectId,
    required String name,
    required EnvironmentType environmentType,
    required List<RestrictionMechanism> restrictions,
    required String hostAssetId,
    String? applicationAssetId,
    String? networkAssetId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'environment_type': AssetPropertyValue.string(environmentType.name),
      'restrictions': AssetPropertyValue.stringList(restrictions.map((r) => r.name).toList()),
      'host_asset_id': AssetPropertyValue.string(hostAssetId),
      if (applicationAssetId != null) 'application_asset_id': AssetPropertyValue.string(applicationAssetId),
      if (networkAssetId != null) 'network_asset_id': AssetPropertyValue.string(networkAssetId),
      'user_context': const AssetPropertyValue.string(''),
      'privilege_level': const AssetPropertyValue.string('user'),
      'breakout_attempts': const AssetPropertyValue.objectList([]),
      'successful_breakouts': const AssetPropertyValue.integer(0),
      'failed_breakouts': const AssetPropertyValue.integer(0),
      'security_controls': const AssetPropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.restrictedEnvironment,
      projectId: projectId,
      name: name,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [hostAssetId],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['breakout', 'restriction', environmentType.name],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: {'childOf': [hostAssetId]},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.restrictedEnvironment),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.restrictedEnvironment): DateTime.now()},
      dependencyMap: {},
      discoveryPath: [hostAssetId],
      relationshipMetadata: {},
    );
  }

  /// Create a breakout attempt asset
  static Asset createBreakoutAttempt({
    required String projectId,
    required String name,
    required String restrictedEnvironmentId,
    required String techniqueId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'restricted_environment_id': AssetPropertyValue.string(restrictedEnvironmentId),
      'technique_id': AssetPropertyValue.string(techniqueId),
      'status': AssetPropertyValue.string(BreakoutStatus.notAttempted.name),
      'attempted_at': AssetPropertyValue.dateTime(DateTime.now()),
      'command': const AssetPropertyValue.string(''),
      'command_output': const AssetPropertyValue.string(''),
      'assets_gained': const AssetPropertyValue.stringList([]),
      'credentials_gained': const AssetPropertyValue.stringList([]),
      'persistence_achieved': const AssetPropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.breakoutAttempt,
      projectId: projectId,
      name: name,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [restrictedEnvironmentId],
      childAssetIds: [],
      relatedAssetIds: [techniqueId],
      completedTriggers: [],
      triggerResults: {},
      tags: ['breakout', 'attempt'],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: {'childOf': [restrictedEnvironmentId], 'relatedTo': [techniqueId]},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.breakoutAttempt),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.breakoutAttempt): DateTime.now()},
      dependencyMap: {},
      discoveryPath: [restrictedEnvironmentId],
      relationshipMetadata: {},
    );
  }

  /// Create a breakout technique asset
  static Asset createBreakoutTechnique({
    required String projectId,
    required String name,
    required TechniqueCategory category,
    required List<EnvironmentType> applicableEnvironments,
    required List<RestrictionMechanism> targetsRestrictions,
    String? methodology,
    String? payload,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'category': AssetPropertyValue.string(category.name),
      'applicable_environments': AssetPropertyValue.stringList(applicableEnvironments.map((e) => e.name).toList()),
      'targets_restrictions': AssetPropertyValue.stringList(targetsRestrictions.map((r) => r.name).toList()),
      if (methodology != null) 'methodology': AssetPropertyValue.string(methodology),
      if (payload != null) 'payload': AssetPropertyValue.string(payload),
      'complexity': const AssetPropertyValue.string('medium'),
      'reliability': const AssetPropertyValue.string('unknown'),
      'prerequisites': const AssetPropertyValue.stringList([]),
      'indicators': const AssetPropertyValue.stringList([]),
      'mitigations': const AssetPropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.breakoutTechnique,
      projectId: projectId,
      name: name,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['breakout', 'technique', category.name],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: {},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.breakoutTechnique),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.breakoutTechnique): DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  /// Create a security control asset
  static Asset createSecurityControl({
    required String projectId,
    required String name,
    required String controlType,
    required String hostAssetId,
    String? vendor,
    String? version,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'control_type': AssetPropertyValue.string(controlType),
      'host_asset_id': AssetPropertyValue.string(hostAssetId),
      if (vendor != null) 'vendor': AssetPropertyValue.string(vendor),
      if (version != null) 'version': AssetPropertyValue.string(version),
      'enabled': const AssetPropertyValue.boolean(true),
      'enforcement_mode': const AssetPropertyValue.string('block'),
      'protected_assets': const AssetPropertyValue.stringList([]),
      'known_bypasses': const AssetPropertyValue.stringList([]),
      'bypass_attempts': const AssetPropertyValue.integer(0),
      'bypass_successes': const AssetPropertyValue.integer(0),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.securityControl,
      projectId: projectId,
      name: name,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [hostAssetId],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['security', 'control', controlType],
      // NEW RELATIONSHIP SYSTEM FIELDS:
      relationships: {'childOf': [hostAssetId]},
      inheritedProperties: {},
      lifecycleState: AssetLifecycleStates.getDefaultState(AssetType.securityControl),
      stateTransitions: {AssetLifecycleStates.getDefaultState(AssetType.securityControl): DateTime.now()},
      dependencyMap: {},
      discoveryPath: [hostAssetId],
      relationshipMetadata: {},
    );
  }

  // =============================================================================
  // Critical Asset Type Factory Methods
  // =============================================================================

  /// Create a Web Application asset
  static Asset createWebApplication({
    required String projectId,
    required String baseUrl,
    String? framework,
    String? authenticationType,
    bool wafPresent = false,
    String? environmentId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final uri = Uri.parse(baseUrl);

    final properties = <String, AssetPropertyValue>{
      'base_url': AssetPropertyValue.string(baseUrl),
      'domain': AssetPropertyValue.string(uri.host),
      'protocol': AssetPropertyValue.string(uri.scheme),
      'ports': AssetPropertyValue.stringList([uri.port.toString()]),
      if (framework != null) 'framework': AssetPropertyValue.string(framework),
      if (authenticationType != null) 'authentication_type': AssetPropertyValue.stringList([authenticationType]),
      'waf_present': AssetPropertyValue.boolean(wafPresent),
      'https_enforced': AssetPropertyValue.boolean(uri.scheme == 'https'),
      'vulnerabilities': const AssetPropertyValue.objectList([]),
      'api_endpoints': const AssetPropertyValue.objectList([]),
      'admin_panels': const AssetPropertyValue.objectList([]),
      'test_coverage': const AssetPropertyValue.string('None'),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.webApplication,
      projectId: projectId,
      name: uri.host,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: environmentId != null ? [environmentId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['web', 'application', framework?.toLowerCase() ?? 'unknown'],
      relationships: {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  /// Create an API Endpoint asset
  static Asset createApiEndpoint({
    required String projectId,
    required String endpointUrl,
    required List<String> methods,
    required String apiType,
    String? parentWebAppId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final uri = Uri.parse(endpointUrl);

    final properties = <String, AssetPropertyValue>{
      'endpoint_url': AssetPropertyValue.string(endpointUrl),
      'base_path': AssetPropertyValue.string(uri.path),
      'methods': AssetPropertyValue.stringList(methods),
      'api_type': AssetPropertyValue.string(apiType),
      'authentication_required': const AssetPropertyValue.boolean(false),
      'rate_limited': const AssetPropertyValue.boolean(false),
      'documented': const AssetPropertyValue.boolean(false),
      'publicly_accessible': const AssetPropertyValue.boolean(true),
      'vulnerabilities': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.apiEndpoint,
      projectId: projectId,
      name: '${methods.join(',')} ${uri.path}',
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: parentWebAppId != null ? [parentWebAppId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['api', apiType.toLowerCase()],
      relationships: parentWebAppId != null ? {
        'childOf': [parentWebAppId]
      } : {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: parentWebAppId != null ? [parentWebAppId] : [],
      relationshipMetadata: {},
    );
  }

  /// Create a Container asset
  static Asset createContainer({
    required String projectId,
    required String containerId,
    required String image,
    String? orchestrator,
    String? hostId,
    bool privileged = false,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'container_id': AssetPropertyValue.string(containerId),
      'image': AssetPropertyValue.string(image),
      if (orchestrator != null) 'orchestrator': AssetPropertyValue.string(orchestrator),
      'privileged': AssetPropertyValue.boolean(privileged),
      'run_as_root': const AssetPropertyValue.boolean(false),
      'exposed_ports': const AssetPropertyValue.objectList([]),
      'environment_variables': const AssetPropertyValue.objectList([]),
      'escape_possible': const AssetPropertyValue.boolean(false),
      'vulnerable_packages': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.container,
      projectId: projectId,
      name: '${image.split(':').first}:${containerId.substring(0, 8)}',
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: hostId != null ? [hostId] : [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['container', orchestrator?.toLowerCase() ?? 'docker'],
      relationships: hostId != null ? {
        'hostedBy': [hostId]
      } : {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: hostId != null ? [hostId] : [],
      relationshipMetadata: {},
    );
  }

  /// Create a Certificate asset
  static Asset createCertificate({
    required String projectId,
    required String fingerprint,
    required String subjectCN,
    required DateTime validFrom,
    required DateTime validTo,
    String? issuerCN,
    bool selfSigned = false,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final now = DateTime.now();
    final expired = now.isAfter(validTo);
    final daysRemaining = expired ? 0 : validTo.difference(now).inDays;

    final properties = <String, AssetPropertyValue>{
      'fingerprint_sha256': AssetPropertyValue.string(fingerprint),
      'subject_cn': AssetPropertyValue.string(subjectCN),
      'valid_from': AssetPropertyValue.dateTime(validFrom),
      'valid_to': AssetPropertyValue.dateTime(validTo),
      'days_remaining': AssetPropertyValue.integer(daysRemaining),
      'expired': AssetPropertyValue.boolean(expired),
      if (issuerCN != null) 'issuer_cn': AssetPropertyValue.string(issuerCN),
      'self_signed': AssetPropertyValue.boolean(selfSigned),
      'weak_signature': const AssetPropertyValue.boolean(false),
      'chain_valid': const AssetPropertyValue.boolean(true),
      'vulnerabilities': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.certificate,
      projectId: projectId,
      name: subjectCN,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['certificate', expired ? 'expired' : 'valid', selfSigned ? 'self-signed' : 'ca-signed'],
      relationships: {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  // =============================================================================
  // Azure Resource Factory Methods
  // =============================================================================

  /// Create an Azure VM asset
  static Asset createAzureVM({
    required String projectId,
    required String resourceId,
    required String vmName,
    required String resourceGroup,
    required String subscriptionId,
    String? osType,
    String? vmSize,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'resource_id': AssetPropertyValue.string(resourceId),
      'resource_name': AssetPropertyValue.string(vmName),
      'resource_group': AssetPropertyValue.string(resourceGroup),
      'subscription_id': AssetPropertyValue.string(subscriptionId),
      'vm_id': AssetPropertyValue.string(resourceId.split('/').last),
      if (osType != null) 'os_type': AssetPropertyValue.string(osType),
      if (vmSize != null) 'vm_size': AssetPropertyValue.string(vmSize),
      'power_state': const AssetPropertyValue.string('Unknown'),
      'managed_identity_enabled': const AssetPropertyValue.boolean(false),
      'disk_encryption_enabled': const AssetPropertyValue.boolean(false),
      'backup_enabled': const AssetPropertyValue.boolean(false),
      'patch_status': const AssetPropertyValue.string('Unknown'),
      'vulnerability_findings': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureVM,
      projectId: projectId,
      name: vmName,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['azure', 'vm', osType?.toLowerCase() ?? 'unknown'],
      relationships: {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  /// Create an Azure Storage Account asset
  static Asset createAzureStorageAccount({
    required String projectId,
    required String resourceId,
    required String accountName,
    required String resourceGroup,
    required String subscriptionId,
    String? accountKind,
    bool publicAccessEnabled = false,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'resource_id': AssetPropertyValue.string(resourceId),
      'resource_name': AssetPropertyValue.string(accountName),
      'resource_group': AssetPropertyValue.string(resourceGroup),
      'subscription_id': AssetPropertyValue.string(subscriptionId),
      if (accountKind != null) 'account_kind': AssetPropertyValue.string(accountKind),
      'public_access_enabled': AssetPropertyValue.boolean(publicAccessEnabled),
      'blob_endpoint': AssetPropertyValue.string('https://$accountName.blob.core.windows.net/'),
      'require_encrypted_transfer': const AssetPropertyValue.boolean(true),
      'containers': const AssetPropertyValue.objectList([]),
      'public_containers': const AssetPropertyValue.objectList([]),
      'sensitive_data_found': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureStorageAccount,
      projectId: projectId,
      name: accountName,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['azure', 'storage', accountKind?.toLowerCase() ?? 'standard'],
      relationships: {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  /// Create an Azure Key Vault asset
  static Asset createAzureKeyVault({
    required String projectId,
    required String resourceId,
    required String vaultName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, AssetPropertyValue>? additionalProperties,
  }) {
    final properties = <String, AssetPropertyValue>{
      'resource_id': AssetPropertyValue.string(resourceId),
      'resource_name': AssetPropertyValue.string(vaultName),
      'resource_group': AssetPropertyValue.string(resourceGroup),
      'subscription_id': AssetPropertyValue.string(subscriptionId),
      'vault_uri': AssetPropertyValue.string('https://$vaultName.vault.azure.net/'),
      'enable_soft_delete': const AssetPropertyValue.boolean(true),
      'rbac_authorization': const AssetPropertyValue.boolean(false),
      'public_network_access': const AssetPropertyValue.string('Enabled'),
      'keys': const AssetPropertyValue.objectList([]),
      'secrets': const AssetPropertyValue.objectList([]),
      'certificates': const AssetPropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureKeyVault,
      projectId: projectId,
      name: vaultName,
      properties: properties,
      discoveryStatus: AssetDiscoveryStatus.discovered,
      discoveredAt: DateTime.now(),
      parentAssetIds: [],
      childAssetIds: [],
      relatedAssetIds: [],
      completedTriggers: [],
      triggerResults: {},
      tags: ['azure', 'keyvault', 'secrets'],
      relationships: {},
      inheritedProperties: {},
      lifecycleState: 'unknown',
      stateTransitions: {'unknown': DateTime.now()},
      dependencyMap: {},
      discoveryPath: [],
      relationshipMetadata: {},
    );
  }

  // Additional AWS/GCP factory methods can be added similarly...
}

// =============================================================================
// Extension Methods for Asset Access
// =============================================================================

extension AssetExtensions on Asset {
  /// Get a typed property value
  T? getProperty<T>(String key) {
    final prop = properties[key];
    if (prop == null) return null;

    return prop.when(
      string: (v) => v as T,
      integer: (v) => v as T,
      double: (v) => v as T,
      boolean: (v) => v as T,
      stringList: (v) => v as T,
      dateTime: (v) => v as T,
      map: (v) => v as T,
      objectList: (v) => v as T,
    );
  }

  /// Check if asset has a property
  bool hasProperty(String key) => properties.containsKey(key);

  /// Update a single property
  Asset updateProperty(String key, AssetPropertyValue value) {
    return copyWith(
      properties: {...properties, key: value},
      lastUpdated: DateTime.now(),
    );
  }

  /// Update multiple properties
  Asset updateProperties(Map<String, AssetPropertyValue> updates) {
    return copyWith(
      properties: {...properties, ...updates},
      lastUpdated: DateTime.now(),
    );
  }

  /// Add a child asset relationship
  Asset addChild(String childAssetId) {
    if (childAssetIds.contains(childAssetId)) return this;
    return copyWith(
      childAssetIds: [...childAssetIds, childAssetId],
      lastUpdated: DateTime.now(),
    );
  }

  /// Add a parent asset relationship
  Asset addParent(String parentAssetId) {
    if (parentAssetIds.contains(parentAssetId)) return this;
    return copyWith(
      parentAssetIds: [...parentAssetIds, parentAssetId],
      lastUpdated: DateTime.now(),
    );
  }

  /// Add a related asset cross-reference
  Asset addRelated(String relatedAssetId) {
    if (relatedAssetIds.contains(relatedAssetId)) return this;
    return copyWith(
      relatedAssetIds: [...relatedAssetIds, relatedAssetId],
      lastUpdated: DateTime.now(),
    );
  }

  /// Check if a trigger has been completed
  bool hasTriggerCompleted(String triggerKey) {
    return completedTriggers.contains(triggerKey);
  }

  /// Mark a trigger as completed with results
  Asset markTriggerCompleted(String triggerKey, TriggerExecutionResult result) {
    return copyWith(
      completedTriggers: [...completedTriggers, triggerKey],
      triggerResults: {...triggerResults, triggerKey: result},
      lastUpdated: DateTime.now(),
    );
  }

  /// Get IP address for host assets
  String? get ipAddress {
    final addresses = getProperty<List<dynamic>>('addresses');
    if (addresses == null || addresses.isEmpty) return null;

    try {
      final firstAddress = addresses.first as Map<String, dynamic>;
      return firstAddress['ip'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// Get hostname for host assets
  String? get hostname => getProperty<String>('hostname');

  /// Get subnet for network segment assets
  String? get subnet => getProperty<String>('subnet');

  /// Get SSID for wireless network assets
  String? get ssid => getProperty<String>('ssid');

  /// Get tenant ID for cloud tenant assets
  String? get tenantId => getProperty<String>('tenant_id');
}