import 'package:freezed_annotation/freezed_annotation.dart';
import 'assets.dart';

part 'asset_relationships.freezed.dart';
part 'asset_relationships.g.dart';

/// Defines all possible relationship types between assets
enum AssetRelationshipType {
  // Hierarchical relationships
  @JsonValue('parent_of')
  parentOf,
  @JsonValue('child_of')
  childOf,

  // Network relationships
  @JsonValue('connected_to')
  connectedTo,
  @JsonValue('routes_to')
  routesTo,
  @JsonValue('bridged_to')
  bridgedTo,
  @JsonValue('vlanned_to')
  vlannedTo,

  // Security relationships
  @JsonValue('trusts')
  trusts,
  @JsonValue('trusted_by')
  trustedBy,
  @JsonValue('authenticates_to')
  authenticatesTo,
  @JsonValue('authenticated_by')
  authenticatedBy,
  @JsonValue('manages')
  manages,
  @JsonValue('managed_by')
  managedBy,

  // Service relationships
  @JsonValue('hosts')
  hosts,
  @JsonValue('hosted_by')
  hostedBy,
  @JsonValue('depends_on')
  dependsOn,
  @JsonValue('dependency_of')
  dependencyOf,
  @JsonValue('communicates_with')
  communicatesWith,

  // Discovery relationships
  @JsonValue('discovered_via')
  discoveredVia,
  @JsonValue('led_to_discovery_of')
  ledToDiscoveryOf,
  @JsonValue('shares_credentials_with')
  sharesCredentialsWith,
  @JsonValue('vulnerable_to')
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
      // case AssetType.finding: (when finding asset type is added)
      //   return findingStates;
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
@freezed
class RelationshipMetadata with _$RelationshipMetadata {
  const factory RelationshipMetadata({
    @Default('') String discoveryMethod,
    @Default('') String confidence,
    DateTime? discoveredAt,
    DateTime? validatedAt,
    @Default({}) Map<String, dynamic> additionalData,
    @Default('') String notes,
  }) = _RelationshipMetadata;

  factory RelationshipMetadata.fromJson(Map<String, dynamic> json) =>
      _$RelationshipMetadataFromJson(json);
}

/// Relationship definition with full context
@freezed
class AssetRelationship with _$AssetRelationship {
  const factory AssetRelationship({
    required String id,
    required String sourceAssetId,
    required String targetAssetId,
    required AssetRelationshipType relationshipType,
    @Default(false) bool isBidirectional,
    DateTime? createdAt,
    DateTime? updatedAt,
    RelationshipMetadata? metadata,
  }) = _AssetRelationship;

  factory AssetRelationship.fromJson(Map<String, dynamic> json) =>
      _$AssetRelationshipFromJson(json);
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