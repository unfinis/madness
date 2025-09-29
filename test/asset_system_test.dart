import 'package:test/test.dart';
import 'package:madness_final/models/assets.dart';
import 'package:madness_final/models/asset_relationships.dart';
import 'package:madness_final/services/asset_relationship_manager.dart';
import 'package:madness_final/services/asset_update_hooks.dart';
import 'package:madness_final/services/discovery_orchestrator.dart';
import 'package:madness_final/services/smart_triggers.dart';
import 'package:madness_final/database/database.dart';

/// Comprehensive test suite for the Asset Relationship System
void main() {
  group('Asset Relationship System Tests', () {
    late AppDatabase mockDatabase;
    late AssetRelationshipManager relationshipManager;
    late AssetUpdateHooks updateHooks;
    late DiscoveryOrchestrator discoveryOrchestrator;
    late SmartTriggerSystem triggerSystem;

    setUp(() {
      // Initialize test components
      mockDatabase = _createMockDatabase();
      relationshipManager = AssetRelationshipManager(mockDatabase);
      updateHooks = AssetUpdateHooks(relationshipManager);
      discoveryOrchestrator = DiscoveryOrchestrator(relationshipManager, updateHooks);
      triggerSystem = SmartTriggerSystem(relationshipManager, updateHooks, discoveryOrchestrator);
    });

    tearDown(() {
      // Cleanup resources
      relationshipManager.dispose();
      updateHooks.dispose();
      discoveryOrchestrator.dispose();
      triggerSystem.dispose();
    });

    group('Asset Model Tests', () {
      test('Asset creation with new relationship fields', () {
        final asset = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
          name: 'Test Network',
        );

        expect(asset.relationships, isNotEmpty);
        expect(asset.inheritedProperties, isA<Map<String, dynamic>>());
        expect(asset.lifecycleState, equals('unknown'));
        expect(asset.stateTransitions, isNotEmpty);
        expect(asset.dependencyMap, isA<Map<String, String>>());
        expect(asset.discoveryPath, isA<List<String>>());
        expect(asset.relationshipMetadata, isA<Map<String, dynamic>>());
      });

      test('Asset factory methods create valid relationships', () {
        // Create environment
        final environment = AssetFactory.createEnvironment(
          projectId: 'test-project',
          name: 'Test Environment',
          environmentType: 'test',
        );

        // Create network segment with environment parent
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
          environmentId: environment.id,
        );

        expect(networkSegment.relationships['childOf'], contains(environment.id));
        expect(networkSegment.discoveryPath, contains(environment.id));
      });

      test('Asset lifecycle state defaults are correct', () {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
        );

        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        expect(networkSegment.lifecycleState, equals(AssetLifecycleStates.getDefaultState(AssetType.networkSegment)));
        expect(host.lifecycleState, equals(AssetLifecycleStates.getDefaultState(AssetType.host)));
      });
    });

    group('Asset Relationships Model Tests', () {
      test('AssetLifecycleStates validation works correctly', () {
        // Test valid transitions
        expect(AssetLifecycleStates.isValidTransition(AssetType.host, 'unknown', 'discovered'), isTrue);
        expect(AssetLifecycleStates.isValidTransition(AssetType.host, 'discovered', 'scanned'), isTrue);
        expect(AssetLifecycleStates.isValidTransition(AssetType.host, 'scanned', 'compromised'), isTrue);

        // Test invalid transitions
        expect(AssetLifecycleStates.isValidTransition(AssetType.host, 'unknown', 'compromised'), isFalse);
        expect(AssetLifecycleStates.isValidTransition(AssetType.host, 'cleaned', 'compromised'), isFalse);
      });

      test('RelationshipHelper provides correct inverse relationships', () {
        expect(RelationshipHelper.getInverseRelationship(AssetRelationshipType.parentOf),
               equals(AssetRelationshipType.childOf));
        expect(RelationshipHelper.getInverseRelationship(AssetRelationshipType.trusts),
               equals(AssetRelationshipType.trustedBy));
        expect(RelationshipHelper.getInverseRelationship(AssetRelationshipType.connectedTo),
               isNull);
      });

      test('Bidirectional relationships are identified correctly', () {
        expect(RelationshipHelper.isBidirectionalRelationship(AssetRelationshipType.connectedTo), isTrue);
        expect(RelationshipHelper.isBidirectionalRelationship(AssetRelationshipType.communicatesWith), isTrue);
        expect(RelationshipHelper.isBidirectionalRelationship(AssetRelationshipType.parentOf), isFalse);
      });
    });

    group('Asset Relationship Manager Tests', () {
      test('Create relationship between assets', () async {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
        );

        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        // Mock the asset queries
        _mockAssetQuery(mockDatabase, networkSegment);
        _mockAssetQuery(mockDatabase, host);

        final relationship = await relationshipManager.createRelationship(
          sourceAssetId: networkSegment.id,
          targetAssetId: host.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        expect(relationship.sourceAssetId, equals(networkSegment.id));
        expect(relationship.targetAssetId, equals(host.id));
        expect(relationship.relationshipType, equals(AssetRelationshipType.parentOf));
      });

      test('Update asset lifecycle state', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        _mockAssetQuery(mockDatabase, host);

        final updatedAsset = await relationshipManager.updateAssetState(host.id, 'discovered');

        expect(updatedAsset.lifecycleState, equals('discovered'));
        expect(updatedAsset.stateTransitions['discovered'], isNotNull);
      });

      test('Property inheritance from parents', () async {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
          additionalProperties: {
            'domain_name': const AssetPropertyValue.string('test.local'),
            'dns_servers': const AssetPropertyValue.stringList(['192.168.1.1']),
          },
        );

        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
          networkSegmentId: networkSegment.id,
        );

        _mockAssetQuery(mockDatabase, networkSegment);
        _mockAssetQuery(mockDatabase, host);

        final updatedHost = await relationshipManager.inheritPropertiesFromParents(host.id);

        expect(updatedHost.inheritedProperties['domain_name'], equals('test.local'));
        expect(updatedHost.inheritedProperties['dns_servers'], contains('192.168.1.1'));
      });
    });

    group('Asset Update Hooks Tests', () {
      test('State change hooks are triggered', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        var hookTriggered = false;
        updateHooks.registerStateChangeHook(TestStateChangeHook(() => hookTriggered = true));

        await updateHooks.processStateChange(host, 'unknown', 'discovered');

        expect(hookTriggered, isTrue);
      });

      test('Property update hooks are triggered', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        var hookTriggered = false;
        updateHooks.registerPropertyUpdateHook(TestPropertyUpdateHook(() => hookTriggered = true));

        await updateHooks.processPropertyUpdate(
          host,
          'test_property',
          const AssetPropertyValue.string('old_value'),
          const AssetPropertyValue.string('new_value'),
        );

        expect(hookTriggered, isTrue);
      });

      test('Discovery hooks are triggered', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        var hookTriggered = false;
        updateHooks.registerDiscoveryHook(TestDiscoveryHook(() => hookTriggered = true));

        await updateHooks.processAssetDiscovery(
          host,
          const DiscoveryContext(
            discoveredAt: null,
            discoveryMethod: 'test',
          ),
        );

        expect(hookTriggered, isTrue);
      });
    });

    group('Discovery Orchestrator Tests', () {
      test('Start discovery session', () async {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
        );

        _mockAssetQuery(mockDatabase, networkSegment);

        final session = await discoveryOrchestrator.startDiscoverySession(
          networkSegmentId: networkSegment.id,
          discoveryType: DiscoveryType.forward,
        );

        expect(session.networkSegmentId, equals(networkSegment.id));
        expect(session.discoveryType, equals(DiscoveryType.forward));
        expect(session.status, equals(DiscoveryStatus.initializing));
      });

      test('Generate discovery recommendations', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        _mockAssetQuery(mockDatabase, host);

        final recommendations = await discoveryOrchestrator.generateDiscoveryRecommendations(host.id);

        expect(recommendations, isNotEmpty);
        expect(recommendations.first.type, equals(DiscoveryType.forward));
        expect(recommendations.first.priority, equals(Priority.high));
      });
    });

    group('Smart Trigger System Tests', () {
      test('Property-based trigger evaluation', () async {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
          additionalProperties: {
            'nac_enabled': const AssetPropertyValue.boolean(true),
            'credentials_available': const AssetPropertyValue.stringList(['test:password']),
            'access_level': const AssetPropertyValue.string('blocked'),
          },
        );

        _mockAssetQuery(mockDatabase, networkSegment);

        final evaluations = await triggerSystem.evaluateTriggersForAsset(networkSegment.id);

        expect(evaluations, isNotEmpty);
        final nacTrigger = evaluations.firstWhere((e) => e.triggerId == 'nac_bypass_available');
        expect(nacTrigger.shouldExecute, isTrue);
        expect(nacTrigger.confidence, greaterThan(0.5));
      });

      test('State-based trigger evaluation', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
          additionalProperties: {
            'lateral_movement_attempted': const AssetPropertyValue.boolean(false),
          },
        );

        // Set host to compromised state
        final compromisedHost = host.copyWith(
          lifecycleState: 'compromised',
          stateTransitions: {
            'unknown': DateTime.now().subtract(const Duration(hours: 1)),
            'compromised': DateTime.now(),
          },
        );

        _mockAssetQuery(mockDatabase, compromisedHost);

        final evaluations = await triggerSystem.evaluateTriggersForAsset(compromisedHost.id);

        expect(evaluations, isNotEmpty);
        final lateralTrigger = evaluations.firstWhere((e) => e.triggerId == 'host_compromised_lateral');
        expect(lateralTrigger.shouldExecute, isTrue);
      });

      test('Cascade trigger evaluation', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
          additionalProperties: {
            'trust_relationships': const AssetPropertyValue.stringList(['DOMAIN\\TRUST']),
          },
        );

        _mockAssetQuery(mockDatabase, host);

        final evaluations = await triggerSystem.evaluateCascadeTriggers(host, 'domain_enumeration');

        expect(evaluations, isNotEmpty);
        final trustTrigger = evaluations.firstWhere((e) => e.triggerId == 'trust_relationship_discovered');
        expect(trustTrigger.shouldExecute, isTrue);
      });

      test('Trigger execution and deduplication', () async {
        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
        );

        _mockAssetQuery(mockDatabase, host);

        // Execute trigger manually
        final result1 = await triggerSystem.manuallyExecuteTrigger('host_compromised_lateral', host.id);
        expect(result1.executed, isTrue);

        // Try to execute the same trigger again - should be deduplicated
        final result2 = await triggerSystem.manuallyExecuteTrigger('host_compromised_lateral', host.id);
        expect(result2.executed, isFalse);
        expect(result2.reason, contains('Already executed'));
      });
    });

    group('Integration Tests', () {
      test('Complete workflow: Asset creation -> Relationship -> State change -> Trigger', () async {
        // Create network environment
        final environment = AssetFactory.createEnvironment(
          projectId: 'test-project',
          name: 'Test Environment',
          environmentType: 'lab',
        );

        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
          environmentId: environment.id,
        );

        final host = AssetFactory.createHost(
          projectId: 'test-project',
          ipAddress: '192.168.1.10',
          networkSegmentId: networkSegment.id,
        );

        _mockAssetQuery(mockDatabase, environment);
        _mockAssetQuery(mockDatabase, networkSegment);
        _mockAssetQuery(mockDatabase, host);

        // Create relationships
        await relationshipManager.createRelationship(
          sourceAssetId: environment.id,
          targetAssetId: networkSegment.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        await relationshipManager.createRelationship(
          sourceAssetId: networkSegment.id,
          targetAssetId: host.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        // Update host state to compromised
        final compromisedHost = await relationshipManager.updateAssetState(host.id, 'compromised');

        // Verify triggers are evaluated
        final evaluations = await triggerSystem.evaluateTriggersForAsset(compromisedHost.id);

        expect(evaluations, isNotEmpty);
        expect(compromisedHost.lifecycleState, equals('compromised'));
      });

      test('Discovery workflow integration', () async {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: 'test-project',
          subnet: '192.168.1.0/24',
          additionalProperties: {
            'nac_enabled': const AssetPropertyValue.boolean(true),
            'credentials_available': const AssetPropertyValue.stringList(['admin:password']),
          },
        );

        _mockAssetQuery(mockDatabase, networkSegment);

        // Start discovery session
        final session = await discoveryOrchestrator.startDiscoverySession(
          networkSegmentId: networkSegment.id,
          discoveryType: DiscoveryType.forward,
        );

        // Generate recommendations
        final recommendations = await discoveryOrchestrator.generateDiscoveryRecommendations(networkSegment.id);

        // Evaluate triggers
        final evaluations = await triggerSystem.evaluateTriggersForAsset(networkSegment.id);

        expect(session, isNotNull);
        expect(recommendations, isNotEmpty);
        expect(evaluations, isNotEmpty);
      });
    });

    group('Performance Tests', () {
      test('Large-scale relationship creation performance', () async {
        final stopwatch = Stopwatch()..start();

        // Create 100 assets and relationships
        final assets = <Asset>[];
        for (int i = 0; i < 100; i++) {
          final asset = AssetFactory.createHost(
            projectId: 'test-project',
            ipAddress: '192.168.1.$i',
          );
          assets.add(asset);
          _mockAssetQuery(mockDatabase, asset);
        }

        // Create relationships between adjacent assets
        for (int i = 0; i < assets.length - 1; i++) {
          await relationshipManager.createRelationship(
            sourceAssetId: assets[i].id,
            targetAssetId: assets[i + 1].id,
            relationshipType: AssetRelationshipType.connectedTo,
          );
        }

        stopwatch.stop();
        print('Created 100 assets with 99 relationships in ${stopwatch.elapsedMilliseconds}ms');

        expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // Should complete in under 5 seconds
      });

      test('Trigger evaluation performance on large asset set', () async {
        final stopwatch = Stopwatch()..start();

        // Create 50 assets
        final assets = <Asset>[];
        for (int i = 0; i < 50; i++) {
          final asset = AssetFactory.createNetworkSegment(
            projectId: 'test-project',
            subnet: '10.0.$i.0/24',
            additionalProperties: {
              'nac_enabled': AssetPropertyValue.boolean(i % 2 == 0),
              'credentials_available': const AssetPropertyValue.stringList(['test:password']),
            },
          );
          assets.add(asset);
          _mockAssetQuery(mockDatabase, asset);
        }

        // Evaluate triggers for all assets
        final allEvaluations = <TriggerEvaluation>[];
        for (final asset in assets) {
          final evaluations = await triggerSystem.evaluateTriggersForAsset(asset.id);
          allEvaluations.addAll(evaluations);
        }

        stopwatch.stop();
        print('Evaluated triggers for 50 assets in ${stopwatch.elapsedMilliseconds}ms');
        print('Generated ${allEvaluations.length} trigger evaluations');

        expect(stopwatch.elapsedMilliseconds, lessThan(3000)); // Should complete in under 3 seconds
        expect(allEvaluations, isNotEmpty);
      });
    });
  });
}

// Mock database implementation
AppDatabase _createMockDatabase() {
  // TODO: Create a proper mock database for testing
  // This would typically use a package like mockito or create an in-memory database
  throw UnimplementedError('Mock database not implemented yet');
}

void _mockAssetQuery(AppDatabase database, Asset asset) {
  // TODO: Mock the asset query to return the specified asset
  // This would configure the mock to return the asset when queried by ID
}

// Test hook implementations
class TestStateChangeHook implements AssetStateChangeHook {
  final VoidCallback onTriggered;

  TestStateChangeHook(this.onTriggered);

  @override
  Future<void> onStateChange(Asset asset, String oldState, String newState) async {
    onTriggered();
  }
}

class TestPropertyUpdateHook implements AssetPropertyUpdateHook {
  final VoidCallback onTriggered;

  TestPropertyUpdateHook(this.onTriggered);

  @override
  Future<void> onPropertyUpdate(
    Asset asset,
    String propertyKey,
    AssetPropertyValue? oldValue,
    AssetPropertyValue? newValue,
  ) async {
    onTriggered();
  }
}

class TestDiscoveryHook implements AssetDiscoveryHook {
  final VoidCallback onTriggered;

  TestDiscoveryHook(this.onTriggered);

  @override
  Future<void> onAssetDiscovered(Asset asset, DiscoveryContext context) async {
    onTriggered();
  }
}

typedef VoidCallback = void Function();