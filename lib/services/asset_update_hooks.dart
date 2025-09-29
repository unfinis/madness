import 'dart:async';
import '../models/assets.dart';
import '../models/asset_relationships.dart';
import 'asset_relationship_manager.dart';

/// Service that automatically handles asset updates through hooks
/// Provides reactive updates when assets change their states or relationships
class AssetUpdateHooks {
  final AssetRelationshipManager _relationshipManager;

  // Hooks for different asset update types
  final List<AssetStateChangeHook> _stateChangeHooks = [];
  final List<AssetPropertyUpdateHook> _propertyUpdateHooks = [];
  final List<AssetRelationshipHook> _relationshipHooks = [];
  final List<AssetDiscoveryHook> _discoveryHooks = [];

  // Event streams for reactive programming
  final StreamController<AssetUpdateEvent> _updateEventController =
      StreamController<AssetUpdateEvent>.broadcast();

  AssetUpdateHooks(this._relationshipManager) {
    _initializeDefaultHooks();
    _subscribeToRelationshipEvents();
  }

  /// Stream of all asset update events
  Stream<AssetUpdateEvent> get updateEvents => _updateEventController.stream;

  /// Register a state change hook
  void registerStateChangeHook(AssetStateChangeHook hook) {
    _stateChangeHooks.add(hook);
  }

  /// Register a property update hook
  void registerPropertyUpdateHook(AssetPropertyUpdateHook hook) {
    _propertyUpdateHooks.add(hook);
  }

  /// Register a relationship hook
  void registerRelationshipHook(AssetRelationshipHook hook) {
    _relationshipHooks.add(hook);
  }

  /// Register a discovery hook
  void registerDiscoveryHook(AssetDiscoveryHook hook) {
    _discoveryHooks.add(hook);
  }

  /// Process asset state change and trigger hooks
  Future<void> processStateChange(Asset asset, String oldState, String newState) async {
    try {
      // Execute all state change hooks
      for (final hook in _stateChangeHooks) {
        try {
          await hook.onStateChange(asset, oldState, newState);
        } catch (e) {
          print('Error in state change hook: $e');
          // Continue processing other hooks
        }
      }

      // Emit update event
      _updateEventController.add(AssetUpdateEvent.stateChanged(asset, oldState, newState));
    } catch (e) {
      print('Error processing state change: $e');
    }
  }

  /// Process asset property update and trigger hooks
  Future<void> processPropertyUpdate(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) async {
    try {
      // Execute all property update hooks
      for (final hook in _propertyUpdateHooks) {
        try {
          await hook.onPropertyUpdate(asset, propertyKey, oldValue, newValue);
        } catch (e) {
          print('Error in property update hook: $e');
          // Continue processing other hooks
        }
      }

      // Emit update event
      _updateEventController.add(AssetUpdateEvent.propertyChanged(asset, propertyKey, oldValue, newValue));
    } catch (e) {
      print('Error processing property update: $e');
    }
  }

  /// Process asset relationship change and trigger hooks
  Future<void> processRelationshipChange(
    AssetRelationship relationship,
    RelationshipChangeType changeType,
  ) async {
    try {
      // Execute all relationship hooks
      for (final hook in _relationshipHooks) {
        try {
          await hook.onRelationshipChange(relationship, changeType);
        } catch (e) {
          print('Error in relationship hook: $e');
          // Continue processing other hooks
        }
      }

      // Emit update event
      _updateEventController.add(AssetUpdateEvent.relationshipChanged(relationship, changeType));
    } catch (e) {
      print('Error processing relationship change: $e');
    }
  }

  /// Process asset discovery and trigger hooks
  Future<void> processAssetDiscovery(Asset asset, DiscoveryContext context) async {
    try {
      // Execute all discovery hooks
      for (final hook in _discoveryHooks) {
        try {
          await hook.onAssetDiscovered(asset, context);
        } catch (e) {
          print('Error in discovery hook: $e');
          // Continue processing other hooks
        }
      }

      // Emit update event
      _updateEventController.add(AssetUpdateEvent.assetDiscovered(asset, context));
    } catch (e) {
      print('Error processing asset discovery: $e');
    }
  }

  /// Initialize default system hooks
  void _initializeDefaultHooks() {
    // Property inheritance hook
    registerPropertyUpdateHook(PropertyInheritanceHook(_relationshipManager));

    // State transition validation hook
    registerStateChangeHook(StateTransitionValidationHook());

    // Discovery path tracking hook
    registerDiscoveryHook(DiscoveryPathTrackingHook(_relationshipManager));

    // Relationship consistency hook
    registerRelationshipHook(RelationshipConsistencyHook(_relationshipManager));

    // Credential sharing detection hook
    registerPropertyUpdateHook(CredentialSharingDetectionHook(_relationshipManager));

    // Asset dependency tracking hook
    registerRelationshipHook(DependencyTrackingHook(_relationshipManager));

    // Vulnerability propagation hook
    registerPropertyUpdateHook(VulnerabilityPropagationHook(_relationshipManager));
  }

  /// Subscribe to relationship manager events
  void _subscribeToRelationshipEvents() {
    _relationshipManager.events.listen((event) {
      switch (event) {
        case RelationshipCreatedEvent():
          processRelationshipChange(event.relationship, RelationshipChangeType.created);
        case RelationshipRemovedEvent():
          processRelationshipChange(event.relationship, RelationshipChangeType.removed);
        case AssetStateChangedEvent():
          processStateChange(event.asset, event.oldState, event.newState);
      }
    });
  }

  /// Dispose resources
  void dispose() {
    _updateEventController.close();
  }
}

/// Property inheritance hook - propagates properties to child assets
class PropertyInheritanceHook implements AssetPropertyUpdateHook {
  final AssetRelationshipManager _relationshipManager;

  PropertyInheritanceHook(this._relationshipManager);

  @override
  Future<void> onPropertyUpdate(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) async {
    // Get child assets and propagate inheritable properties
    final children = await _relationshipManager.getRelatedAssets(
      asset.id,
      AssetRelationshipType.parentOf,
    );

    for (final child in children) {
      if (_isInheritableProperty(propertyKey)) {
        await _relationshipManager.inheritPropertiesFromParents(child.id);
      }
    }
  }

  bool _isInheritableProperty(String propertyKey) {
    // Define which properties should be inherited
    final inheritableProperties = [
      'domain_name',
      'dns_servers',
      'ntp_servers',
      'security_policies',
      'compliance_frameworks',
      'environment_type',
      'organization',
    ];

    return inheritableProperties.contains(propertyKey);
  }
}

/// State transition validation hook
class StateTransitionValidationHook implements AssetStateChangeHook {
  @override
  Future<void> onStateChange(Asset asset, String oldState, String newState) async {
    // Validate the state transition is allowed
    if (!AssetLifecycleStates.isValidTransition(asset.type, oldState, newState)) {
      throw AssetUpdateException(
        'Invalid state transition: $oldState -> $newState for ${asset.type}'
      );
    }

    // Log state change for audit trail
    print('Asset ${asset.name} (${asset.id}) transitioned from $oldState to $newState');
  }
}

/// Discovery path tracking hook
class DiscoveryPathTrackingHook implements AssetDiscoveryHook {
  final AssetRelationshipManager _relationshipManager;

  DiscoveryPathTrackingHook(this._relationshipManager);

  @override
  Future<void> onAssetDiscovered(Asset asset, DiscoveryContext context) async {
    // Update discovery path based on how the asset was found
    if (context.discoveredVia != null) {
      final updatedPath = [...asset.discoveryPath, context.discoveredVia!];

      // Update the asset with new discovery path
      // TODO: Implement asset update through relationship manager
      print('Asset ${asset.name} discovered via ${context.discoveredVia} - path: ${updatedPath.join(" -> ")}');
    }
  }
}

/// Relationship consistency hook
class RelationshipConsistencyHook implements AssetRelationshipHook {
  final AssetRelationshipManager _relationshipManager;

  RelationshipConsistencyHook(this._relationshipManager);

  @override
  Future<void> onRelationshipChange(
    AssetRelationship relationship,
    RelationshipChangeType changeType,
  ) async {
    // Ensure bidirectional relationships are maintained
    if (changeType == RelationshipChangeType.created) {
      final inverseType = RelationshipHelper.getInverseRelationship(relationship.relationshipType);
      if (inverseType != null) {
        // Check if inverse relationship exists
        final existingInverse = await _relationshipManager.getRelationshipsByType(
          relationship.targetAssetId,
          inverseType,
        );

        final hasInverse = existingInverse.any((r) => r.targetAssetId == relationship.sourceAssetId);
        if (!hasInverse) {
          // Create inverse relationship
          await _relationshipManager.createRelationship(
            sourceAssetId: relationship.targetAssetId,
            targetAssetId: relationship.sourceAssetId,
            relationshipType: inverseType,
            validateAssets: false, // Already validated
          );
        }
      }
    }
  }
}

/// Credential sharing detection hook
class CredentialSharingDetectionHook implements AssetPropertyUpdateHook {
  final AssetRelationshipManager _relationshipManager;

  CredentialSharingDetectionHook(this._relationshipManager);

  @override
  Future<void> onPropertyUpdate(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) async {
    // Detect when credentials are shared between assets
    if (propertyKey == 'credentials_available' && newValue != null) {
      // Find other assets with the same credentials
      // TODO: Implement credential sharing detection logic
      print('Credentials updated on asset ${asset.name}');
    }
  }
}

/// Dependency tracking hook
class DependencyTrackingHook implements AssetRelationshipHook {
  final AssetRelationshipManager _relationshipManager;

  DependencyTrackingHook(this._relationshipManager);

  @override
  Future<void> onRelationshipChange(
    AssetRelationship relationship,
    RelationshipChangeType changeType,
  ) async {
    // Track dependencies for service relationships
    if (relationship.relationshipType == AssetRelationshipType.dependsOn) {
      // Update dependency maps
      print('Dependency relationship ${changeType.name}: ${relationship.sourceAssetId} -> ${relationship.targetAssetId}');
    }
  }
}

/// Vulnerability propagation hook
class VulnerabilityPropagationHook implements AssetPropertyUpdateHook {
  final AssetRelationshipManager _relationshipManager;

  VulnerabilityPropagationHook(this._relationshipManager);

  @override
  Future<void> onPropertyUpdate(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) async {
    // Propagate vulnerability information to related assets
    if (propertyKey == 'vulnerabilities' && newValue != null) {
      // Check for assets that might be affected by the same vulnerabilities
      print('Vulnerabilities updated on asset ${asset.name}');
    }
  }
}

/// Hook interfaces
abstract class AssetStateChangeHook {
  Future<void> onStateChange(Asset asset, String oldState, String newState);
}

abstract class AssetPropertyUpdateHook {
  Future<void> onPropertyUpdate(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  );
}

abstract class AssetRelationshipHook {
  Future<void> onRelationshipChange(
    AssetRelationship relationship,
    RelationshipChangeType changeType,
  );
}

abstract class AssetDiscoveryHook {
  Future<void> onAssetDiscovered(Asset asset, DiscoveryContext context);
}

/// Event types for asset updates
sealed class AssetUpdateEvent {
  const AssetUpdateEvent();

  factory AssetUpdateEvent.stateChanged(Asset asset, String oldState, String newState) =
      AssetStateChangeEvent;

  factory AssetUpdateEvent.propertyChanged(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) = AssetPropertyChangeEvent;

  factory AssetUpdateEvent.relationshipChanged(
    AssetRelationship relationship,
    RelationshipChangeType changeType,
  ) = AssetRelationshipChangeEvent;

  factory AssetUpdateEvent.assetDiscovered(Asset asset, DiscoveryContext context) =
      AssetDiscoveryEvent;
}

class AssetStateChangeEvent extends AssetUpdateEvent {
  final Asset asset;
  final String oldState;
  final String newState;

  const AssetStateChangeEvent(this.asset, this.oldState, this.newState);
}

class AssetPropertyChangeEvent extends AssetUpdateEvent {
  final Asset asset;
  final String propertyKey;
  final AssetPropertyValue? oldValue;
  final AssetPropertyValue? newValue;

  const AssetPropertyChangeEvent(this.asset, this.propertyKey, this.oldValue, this.newValue);
}

class AssetRelationshipChangeEvent extends AssetUpdateEvent {
  final AssetRelationship relationship;
  final RelationshipChangeType changeType;

  const AssetRelationshipChangeEvent(this.relationship, this.changeType);
}

class AssetDiscoveryEvent extends AssetUpdateEvent {
  final Asset asset;
  final DiscoveryContext context;

  const AssetDiscoveryEvent(this.asset, this.context);
}

/// Supporting enums and classes
enum RelationshipChangeType {
  created,
  removed,
  updated,
}

class DiscoveryContext {
  final String? discoveredVia;
  final DateTime discoveredAt;
  final String discoveryMethod;
  final Map<String, dynamic> metadata;

  const DiscoveryContext({
    this.discoveredVia,
    required this.discoveredAt,
    required this.discoveryMethod,
    this.metadata = const {},
  });
}

/// Exception for asset update operations
class AssetUpdateException implements Exception {
  final String message;
  const AssetUpdateException(this.message);

  @override
  String toString() => 'AssetUpdateException: $message';
}