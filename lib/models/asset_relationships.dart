import 'assets.dart';

/// Defines all possible relationship types between assets
enum AssetRelationshipType {
  // Hierarchical relationships
  parentOf,
  childOf,

  // Network relationships
  connectedTo,
  routesTo,
  bridgedTo,
  vlannedTo,

  // Security relationships
  trusts,
  trustedBy,
  authenticatesTo,
  authenticatedBy,
  manages,
  managedBy,

  // Service relationships
  hosts,
  hostedBy,
  dependsOn,
  dependencyOf,
  communicatesWith,

  // Discovery relationships
  discoveredVia,
  ledToDiscoveryOf,
  sharesCredentialsWith,
  vulnerableTo,
}

/// Asset lifecycle states for each asset type
class AssetLifecycleStates {
  // Network Segment States
  static const Map<String, List<String>> networkSegmentStates = {
    'unknown': ['scanning', 'unreachable'],
    'scanning': ['identified', 'unreachable'],
    'identified': ['assessed', 'compromised', 'unreachable'],
    'assessed': ['compromised', 'hardened'],
    'compromised': ['pivoted', 'persistent'],
    'pivoted': ['persistent'],
    'persistent': ['cleaned'],
    'hardened': [],
    'unreachable': ['scanning'], // Can retry
    'cleaned': []
  };

  // Host States
  static const Map<String, List<String>> hostStates = {
    'unknown': ['discovered', 'unreachable'],
    'discovered': ['scanned', 'unreachable'],
    'scanned': ['identified', 'compromised', 'unreachable'],
    'identified': ['compromised', 'hardened'],
    'compromised': ['escalated', 'persistent'],
    'escalated': ['persistent', 'lateral'],
    'persistent': ['lateral', 'cleaned'],
    'lateral': ['cleaned'],
    'hardened': [],
    'unreachable': ['discovered'], // Can retry
    'cleaned': []
  };

  // Service States
  static const Map<String, List<String>> serviceStates = {
    'unknown': ['detected', 'filtered'],
    'detected': ['identified', 'exploited'],
    'identified': ['exploited', 'hardened'],
    'exploited': ['persistent'],
    'persistent': ['cleaned'],
    'hardened': [],
    'filtered': ['detected'], // Can retry
    'cleaned': []
  };

  // Credential States
  static const Map<String, List<String>> credentialStates = {
    'unknown': ['obtained', 'invalid'],
    'obtained': ['validated', 'cracked'],
    'validated': ['used', 'escalated'],
    'cracked': ['validated'],
    'used': ['escalated', 'expired'],
    'escalated': ['persistent'],
    'persistent': ['revoked'],
    'invalid': ['obtained'], // Can retry
    'expired': ['renewed'],
    'renewed': ['validated'],
    'revoked': [],
  };

  // Vulnerability States
  static const Map<String, List<String>> vulnerabilityStates = {
    'unknown': ['identified', 'false_positive'],
    'identified': ['confirmed', 'false_positive'],
    'confirmed': ['exploited', 'patched'],
    'exploited': ['persistent'],
    'persistent': ['patched'],
    'patched': [],
    'false_positive': []
  };

  // Finding States (when finding asset type is added)
  static const Map<String, List<String>> findingStates = {
    'unknown': ['draft', 'invalid'],
    'draft': ['review', 'invalid'],
    'review': ['approved', 'revision'],
    'revision': ['review'],
    'approved': ['reported'],
    'reported': ['remediated'],
    'remediated': [],
    'invalid': []
  };

  // Default 'unknown' state for any asset type
  static const Map<String, List<String>> defaultStates = {
    'unknown': ['identified'],
    'identified': ['assessed'],
    'assessed': ['completed'],
    'completed': []
  };

  // Web Application States
  static const Map<String, List<String>> webApplicationStates = {
    'unknown': ['discovered'],
    'discovered': ['fingerprinted', 'authenticated'],
    'fingerprinted': ['tested', 'authenticated'],
    'authenticated': ['tested'],
    'tested': ['vulnerable', 'secure'],
    'vulnerable': ['exploited', 'remediated'],
    'exploited': ['compromised'],
    'compromised': ['controlled'],
    'controlled': [],
    'secure': [],
    'remediated': ['verified'],
    'verified': []
  };

  // API Endpoint States
  static const Map<String, List<String>> apiEndpointStates = {
    'unknown': ['discovered'],
    'discovered': ['documented', 'tested'],
    'documented': ['tested'],
    'tested': ['vulnerable', 'secure'],
    'vulnerable': ['exploited', 'remediated'],
    'exploited': ['abused'],
    'abused': [],
    'secure': [],
    'remediated': ['verified'],
    'verified': []
  };

  // Container States
  static const Map<String, List<String>> containerStates = {
    'unknown': ['running'],
    'running': ['analyzed', 'stopped'],
    'analyzed': ['vulnerable', 'secure', 'stopped'],
    'vulnerable': ['exploited', 'patched'],
    'exploited': ['escaped', 'contained'],
    'escaped': [],
    'contained': [],
    'stopped': ['removed'],
    'removed': [],
    'secure': [],
    'patched': ['verified'],
    'verified': []
  };

  // Certificate States
  static const Map<String, List<String>> certificateStates = {
    'unknown': ['valid'],
    'valid': ['expiring', 'trusted'],
    'expiring': ['expired', 'renewed'],
    'expired': ['replaced'],
    'trusted': ['compromised'],
    'compromised': ['revoked'],
    'revoked': ['replaced'],
    'replaced': [],
    'renewed': ['valid']
  };

  // Azure Resource States (base for all Azure resources)
  static const Map<String, List<String>> azureResourceStates = {
    'unknown': ['discovered'],
    'discovered': ['enumerated'],
    'enumerated': ['assessed'],
    'assessed': ['vulnerable', 'compliant'],
    'vulnerable': ['exploited', 'remediated'],
    'exploited': ['compromised'],
    'compromised': ['controlled'],
    'controlled': [],
    'compliant': ['monitored'],
    'monitored': [],
    'remediated': ['verified'],
    'verified': []
  };

  // AWS Resource States
  static const Map<String, List<String>> awsResourceStates = {
    'unknown': ['discovered'],
    'discovered': ['enumerated'],
    'enumerated': ['assessed'],
    'assessed': ['vulnerable', 'compliant'],
    'vulnerable': ['exploited', 'remediated'],
    'exploited': ['compromised'],
    'compromised': ['controlled'],
    'controlled': [],
    'compliant': ['monitored'],
    'monitored': [],
    'remediated': ['verified'],
    'verified': []
  };

  // GCP Resource States
  static const Map<String, List<String>> gcpResourceStates = {
    'unknown': ['discovered'],
    'discovered': ['enumerated'],
    'enumerated': ['assessed'],
    'assessed': ['vulnerable', 'compliant'],
    'vulnerable': ['exploited', 'remediated'],
    'exploited': ['compromised'],
    'compromised': ['controlled'],
    'controlled': [],
    'compliant': ['monitored'],
    'monitored': [],
    'remediated': ['verified'],
    'verified': []
  };

  /// Get valid states for an asset type
  static Map<String, List<String>> getValidStates(AssetType assetType) {
    switch (assetType) {
      case AssetType.networkSegment:
        return networkSegmentStates;
      case AssetType.host:
        return hostStates;
      case AssetType.service:
        return serviceStates;
      case AssetType.credential:
        return credentialStates;
      case AssetType.vulnerability:
        return vulnerabilityStates;

      // Critical Asset Types
      case AssetType.webApplication:
        return webApplicationStates;
      case AssetType.apiEndpoint:
        return apiEndpointStates;
      case AssetType.container:
        return containerStates;
      case AssetType.certificate:
        return certificateStates;

      // Azure Resources
      case AssetType.azureResource:
      case AssetType.azureVM:
      case AssetType.azureStorageAccount:
      case AssetType.azureKeyVault:
      case AssetType.azureSQLDatabase:
      case AssetType.azureCosmosDB:
      case AssetType.azureFunction:
      case AssetType.azureAppService:
      case AssetType.azureAD:
      case AssetType.azureNetworking:
      case AssetType.azureAKS:
        return azureResourceStates;

      // AWS Resources
      case AssetType.awsResource:
      case AssetType.ec2Instance:
      case AssetType.s3Bucket:
      case AssetType.rdsDatabase:
      case AssetType.lambdaFunction:
      case AssetType.iamRole:
      case AssetType.awsSecret:
        return awsResourceStates;

      // GCP Resources
      case AssetType.gcpResource:
      case AssetType.computeInstance:
      case AssetType.cloudStorage:
      case AssetType.cloudSQL:
      case AssetType.cloudFunction:
        return gcpResourceStates;

      default:
        return defaultStates;
    }
  }

  /// Get default initial state for an asset type
  static String getDefaultState(AssetType assetType) {
    switch (assetType) {
      case AssetType.networkSegment:
      case AssetType.host:
      case AssetType.service:
      case AssetType.credential:
      case AssetType.vulnerability:
      // case AssetType.finding: (when finding asset type is added)
      //   return 'unknown';
      default:
        return 'unknown';
    }
  }

  /// Validate if a state transition is allowed
  static bool isValidTransition(AssetType assetType, String fromState, String toState) {
    final validStates = getValidStates(assetType);
    final allowedTransitions = validStates[fromState];
    return allowedTransitions?.contains(toState) ?? false;
  }

  /// Get all possible next states for current state
  static List<String> getNextStates(AssetType assetType, String currentState) {
    final validStates = getValidStates(assetType);
    return validStates[currentState] ?? [];
  }

  /// Get all possible states for an asset type
  static List<String> getAllStates(AssetType assetType) {
    final validStates = getValidStates(assetType);
    return validStates.keys.toList();
  }
}

/// Relationship metadata for tracking additional information
class RelationshipMetadata {
  final String discoveryMethod;
  final String confidence;
  final DateTime? discoveredAt;
  final DateTime? validatedAt;
  final Map<String, dynamic> additionalData;
  final String notes;

  const RelationshipMetadata({
    this.discoveryMethod = '',
    this.confidence = '',
    this.discoveredAt,
    this.validatedAt,
    this.additionalData = const {},
    this.notes = '',
  });

  factory RelationshipMetadata.fromJson(Map<String, dynamic> json) {
    return RelationshipMetadata(
      discoveryMethod: json['discoveryMethod'] as String? ?? '',
      confidence: json['confidence'] as String? ?? '',
      discoveredAt: json['discoveredAt'] != null
        ? DateTime.parse(json['discoveredAt'] as String)
        : null,
      validatedAt: json['validatedAt'] != null
        ? DateTime.parse(json['validatedAt'] as String)
        : null,
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
      notes: json['notes'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'discoveryMethod': discoveryMethod,
      'confidence': confidence,
      'discoveredAt': discoveredAt?.toIso8601String(),
      'validatedAt': validatedAt?.toIso8601String(),
      'additionalData': additionalData,
      'notes': notes,
    };
  }

  RelationshipMetadata copyWith({
    String? discoveryMethod,
    String? confidence,
    DateTime? discoveredAt,
    DateTime? validatedAt,
    Map<String, dynamic>? additionalData,
    String? notes,
  }) {
    return RelationshipMetadata(
      discoveryMethod: discoveryMethod ?? this.discoveryMethod,
      confidence: confidence ?? this.confidence,
      discoveredAt: discoveredAt ?? this.discoveredAt,
      validatedAt: validatedAt ?? this.validatedAt,
      additionalData: additionalData ?? this.additionalData,
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RelationshipMetadata &&
            discoveryMethod == other.discoveryMethod &&
            confidence == other.confidence &&
            discoveredAt == other.discoveredAt &&
            validatedAt == other.validatedAt &&
            notes == other.notes);
  }

  @override
  int get hashCode => Object.hash(
    discoveryMethod,
    confidence,
    discoveredAt,
    validatedAt,
    notes,
  );
}

/// Relationship definition with full context
class AssetRelationship {
  final String id;
  final String sourceAssetId;
  final String targetAssetId;
  final AssetRelationshipType relationshipType;
  final bool isBidirectional;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final RelationshipMetadata? metadata;

  const AssetRelationship({
    required this.id,
    required this.sourceAssetId,
    required this.targetAssetId,
    required this.relationshipType,
    this.isBidirectional = false,
    this.createdAt,
    this.updatedAt,
    this.metadata,
  });

  factory AssetRelationship.fromJson(Map<String, dynamic> json) {
    return AssetRelationship(
      id: json['id'] as String,
      sourceAssetId: json['sourceAssetId'] as String,
      targetAssetId: json['targetAssetId'] as String,
      relationshipType: AssetRelationshipType.values.firstWhere(
        (e) => e.toString().split('.').last == json['relationshipType'],
        orElse: () => AssetRelationshipType.connectedTo,
      ),
      isBidirectional: json['isBidirectional'] as bool? ?? false,
      createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'] as String)
        : null,
      updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'] as String)
        : null,
      metadata: json['metadata'] != null
        ? RelationshipMetadata.fromJson(json['metadata'] as Map<String, dynamic>)
        : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sourceAssetId': sourceAssetId,
      'targetAssetId': targetAssetId,
      'relationshipType': relationshipType.toString().split('.').last,
      'isBidirectional': isBidirectional,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'metadata': metadata?.toJson(),
    };
  }

  AssetRelationship copyWith({
    String? id,
    String? sourceAssetId,
    String? targetAssetId,
    AssetRelationshipType? relationshipType,
    bool? isBidirectional,
    DateTime? createdAt,
    DateTime? updatedAt,
    RelationshipMetadata? metadata,
  }) {
    return AssetRelationship(
      id: id ?? this.id,
      sourceAssetId: sourceAssetId ?? this.sourceAssetId,
      targetAssetId: targetAssetId ?? this.targetAssetId,
      relationshipType: relationshipType ?? this.relationshipType,
      isBidirectional: isBidirectional ?? this.isBidirectional,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AssetRelationship &&
            id == other.id &&
            sourceAssetId == other.sourceAssetId &&
            targetAssetId == other.targetAssetId &&
            relationshipType == other.relationshipType &&
            isBidirectional == other.isBidirectional);
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceAssetId,
    targetAssetId,
    relationshipType,
    isBidirectional,
  );
}

/// Helper class for relationship operations
class RelationshipHelper {
  /// Get the inverse relationship type
  static AssetRelationshipType? getInverseRelationship(AssetRelationshipType type) {
    switch (type) {
      case AssetRelationshipType.parentOf:
        return AssetRelationshipType.childOf;
      case AssetRelationshipType.childOf:
        return AssetRelationshipType.parentOf;
      case AssetRelationshipType.trusts:
        return AssetRelationshipType.trustedBy;
      case AssetRelationshipType.trustedBy:
        return AssetRelationshipType.trusts;
      case AssetRelationshipType.authenticatesTo:
        return AssetRelationshipType.authenticatedBy;
      case AssetRelationshipType.authenticatedBy:
        return AssetRelationshipType.authenticatesTo;
      case AssetRelationshipType.manages:
        return AssetRelationshipType.managedBy;
      case AssetRelationshipType.managedBy:
        return AssetRelationshipType.manages;
      case AssetRelationshipType.hosts:
        return AssetRelationshipType.hostedBy;
      case AssetRelationshipType.hostedBy:
        return AssetRelationshipType.hosts;
      case AssetRelationshipType.dependsOn:
        return AssetRelationshipType.dependencyOf;
      case AssetRelationshipType.dependencyOf:
        return AssetRelationshipType.dependsOn;
      case AssetRelationshipType.discoveredVia:
        return AssetRelationshipType.ledToDiscoveryOf;
      case AssetRelationshipType.ledToDiscoveryOf:
        return AssetRelationshipType.discoveredVia;
      // Symmetric relationships have no inverse
      case AssetRelationshipType.connectedTo:
      case AssetRelationshipType.routesTo:
      case AssetRelationshipType.bridgedTo:
      case AssetRelationshipType.vlannedTo:
      case AssetRelationshipType.communicatesWith:
      case AssetRelationshipType.sharesCredentialsWith:
      case AssetRelationshipType.vulnerableTo:
        return null;
    }
  }

  /// Check if a relationship type is bidirectional by nature
  static bool isBidirectionalRelationship(AssetRelationshipType type) {
    switch (type) {
      case AssetRelationshipType.connectedTo:
      case AssetRelationshipType.routesTo:
      case AssetRelationshipType.bridgedTo:
      case AssetRelationshipType.vlannedTo:
      case AssetRelationshipType.communicatesWith:
      case AssetRelationshipType.sharesCredentialsWith:
        return true;
      default:
        return false;
    }
  }

  /// Get relationship type from string
  static AssetRelationshipType? fromString(String relationshipStr) {
    try {
      return AssetRelationshipType.values.firstWhere(
        (type) => type.toString().split('.').last == relationshipStr ||
                 _getJsonValue(type) == relationshipStr
      );
    } catch (e) {
      return null;
    }
  }

  /// Get JSON value for relationship type
  static String _getJsonValue(AssetRelationshipType type) {
    switch (type) {
      case AssetRelationshipType.parentOf:
        return 'parent_of';
      case AssetRelationshipType.childOf:
        return 'child_of';
      case AssetRelationshipType.connectedTo:
        return 'connected_to';
      case AssetRelationshipType.routesTo:
        return 'routes_to';
      case AssetRelationshipType.bridgedTo:
        return 'bridged_to';
      case AssetRelationshipType.vlannedTo:
        return 'vlanned_to';
      case AssetRelationshipType.trusts:
        return 'trusts';
      case AssetRelationshipType.trustedBy:
        return 'trusted_by';
      case AssetRelationshipType.authenticatesTo:
        return 'authenticates_to';
      case AssetRelationshipType.authenticatedBy:
        return 'authenticated_by';
      case AssetRelationshipType.manages:
        return 'manages';
      case AssetRelationshipType.managedBy:
        return 'managed_by';
      case AssetRelationshipType.hosts:
        return 'hosts';
      case AssetRelationshipType.hostedBy:
        return 'hosted_by';
      case AssetRelationshipType.dependsOn:
        return 'depends_on';
      case AssetRelationshipType.dependencyOf:
        return 'dependency_of';
      case AssetRelationshipType.communicatesWith:
        return 'communicates_with';
      case AssetRelationshipType.discoveredVia:
        return 'discovered_via';
      case AssetRelationshipType.ledToDiscoveryOf:
        return 'led_to_discovery_of';
      case AssetRelationshipType.sharesCredentialsWith:
        return 'shares_credentials_with';
      case AssetRelationshipType.vulnerableTo:
        return 'vulnerable_to';
    }
  }
}