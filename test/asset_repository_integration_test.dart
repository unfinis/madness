import 'package:flutter_test/flutter_test.dart';
import '../lib/database/database.dart';
import '../lib/repositories/asset_repository.dart';
import '../lib/services/asset_relationship_manager.dart';
import '../lib/models/assets.dart';
import '../lib/models/asset_relationships.dart';

/// Integration test for Asset Repository and Relationship Manager
///
/// This test suite validates the complete integration between:
/// - Database schema and migrations
/// - AssetRepository CRUD operations
/// - AssetRelationshipManager business logic
/// - Property indexing and search functionality
/// - Relationship management and hierarchy
void main() {
  group('Asset Repository Integration Tests', () {
    late MadnessDatabase database;
    late AssetRepository repository;
    late AssetRelationshipManager relationshipManager;
    late String testProjectId;

    setUpAll(() async {
      // Create an in-memory database for testing
      database = MadnessDatabase();
      repository = AssetRepository(database);
      relationshipManager = AssetRelationshipManager(repository);
      testProjectId = 'test-project-${DateTime.now().millisecondsSinceEpoch}';

      print('Test database initialized (in-memory)');
    });

    tearDownAll(() async {
      relationshipManager.dispose();
      await database.close();
      print('Test database closed');
    });

    group('Database Schema and Migration Tests', () {
      test('Database initializes with correct schema version', () async {
        expect(database.schemaVersion, equals(15));
      });

      test('Assets table has all required columns', () async {
        // Try to create an asset to verify all columns exist
        final asset = AssetFactory.createNetworkSegment(
          projectId: testProjectId,
          subnet: '192.168.1.0/24',
          name: 'Test Network',
        );

        await repository.saveAsset(asset);
        final retrievedAsset = await repository.getAsset(asset.id);

        expect(retrievedAsset, isNotNull);
        expect(retrievedAsset!.id, equals(asset.id));
        expect(retrievedAsset.relationships, isA<Map<String, List<String>>>());
        expect(retrievedAsset.inheritedProperties, isA<Map<String, dynamic>>());
        expect(retrievedAsset.lifecycleState, isA<String>());
        expect(retrievedAsset.stateTransitions, isA<Map<String, DateTime>>());
        expect(retrievedAsset.dependencyMap, isA<Map<String, String>>());
        expect(retrievedAsset.discoveryPath, isA<List<String>>());
        expect(retrievedAsset.relationshipMetadata, isA<Map<String, dynamic>>());
      });
    });

    group('Asset Repository CRUD Operations', () {
      test('Create and retrieve asset', () async {
        final asset = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '192.168.1.10',
          hostname: 'test-host',
          additionalProperties: {
            'os_family': const AssetPropertyValue.string('linux'),
            'ssh_enabled': const AssetPropertyValue.boolean(true),
          },
        );

        await repository.saveAsset(asset);
        final retrieved = await repository.getAsset(asset.id);

        expect(retrieved, isNotNull);
        expect(retrieved!.id, equals(asset.id));
        expect(retrieved.name, equals(asset.name));
        expect(retrieved.properties['os_family']?.when(
          string: (value) => value,
          integer: (value) => value.toString(),
          double: (value) => value.toString(),
          boolean: (value) => value.toString(),
          stringList: (value) => value.join(','),
          dateTime: (value) => value.toString(),
          map: (value) => value.toString(),
          objectList: (value) => value.toString(),
        ), equals('linux'));
      });

      test('Update existing asset', () async {
        final asset = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.1.1.100',
          hostname: 'update-test-host',
        );

        await repository.saveAsset(asset);

        final updatedAsset = asset.copyWith(
          description: 'Updated test host',
          lifecycleState: 'discovered',
        );

        await repository.saveAsset(updatedAsset);
        final retrieved = await repository.getAsset(asset.id);

        expect(retrieved!.description, equals('Updated test host'));
        expect(retrieved.lifecycleState, equals('discovered'));
      });

      test('Delete asset', () async {
        final asset = AssetFactory.createWirelessNetwork(
          projectId: testProjectId,
          ssid: 'DeleteTestNetwork',
          encryptionType: 'wpa2',
        );

        await repository.saveAsset(asset);
        expect(await repository.getAsset(asset.id), isNotNull);

        await repository.deleteAsset(asset.id);
        expect(await repository.getAsset(asset.id), isNull);
      });

      test('Get project assets', () async {
        final assets = [
          AssetFactory.createHost(
            projectId: testProjectId,
            ipAddress: '10.0.0.1',
            hostname: 'host1',
          ),
          AssetFactory.createHost(
            projectId: testProjectId,
            ipAddress: '10.0.0.2',
            hostname: 'host2',
          ),
          AssetFactory.createNetworkSegment(
            projectId: testProjectId,
            subnet: '10.0.0.0/24',
            name: 'Test Subnet',
          ),
        ];

        for (final asset in assets) {
          await repository.saveAsset(asset);
        }

        final projectAssets = await repository.getProjectAssets(testProjectId);
        expect(projectAssets.length, greaterThanOrEqualTo(3));

        final hostAssets = projectAssets.where((a) => a.type == AssetType.host);
        expect(hostAssets.length, greaterThanOrEqualTo(2));
      });

      test('Get assets by type', () async {
        final hostAssets = await repository.getAssetsByType(testProjectId, AssetType.host);
        final networkAssets = await repository.getAssetsByType(testProjectId, AssetType.networkSegment);

        // We should have hosts and networks created in previous tests
        expect(hostAssets.length, greaterThanOrEqualTo(1));
        expect(networkAssets.length, greaterThanOrEqualTo(1));

        // Verify all returned assets are of the correct type
        for (final asset in hostAssets) {
          expect(asset.type, equals(AssetType.host));
        }
        for (final asset in networkAssets) {
          expect(asset.type, equals(AssetType.networkSegment));
        }
      });

      test('Get assets by lifecycle state', () async {
        final asset = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.2.2.200',
          hostname: 'state-test-host',
        );

        final updatedAsset = asset.copyWith(lifecycleState: 'confirmed');
        await repository.saveAsset(updatedAsset);

        final confirmedAssets = await repository.getAssetsByState(testProjectId, 'confirmed');
        expect(confirmedAssets, isNotEmpty);
        expect(confirmedAssets.any((a) => a.id == asset.id), isTrue);
      });
    });

    group('Property Indexing and Search', () {
      test('Property index is created and updated', () async {
        final asset = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '172.16.1.100',
          hostname: 'search-test-host',
          additionalProperties: {
            'os_family': const AssetPropertyValue.string('windows'),
            'domain_membership': const AssetPropertyValue.string('example.local'),
            'open_ports': const AssetPropertyValue.stringList(['80', '443', '3389']),
          },
        );

        await repository.saveAsset(asset);
        await repository.updatePropertyIndex(asset);

        // Search by string property
        final windowsHosts = await repository.searchAssetsByProperty(
          testProjectId,
          'os_family',
          'windows',
        );
        expect(windowsHosts, isNotEmpty);
        expect(windowsHosts.any((h) => h.id == asset.id), isTrue);

        // Search by domain membership
        final domainHosts = await repository.searchAssetsByProperty(
          testProjectId,
          'domain_membership',
          'example',
        );
        expect(domainHosts, isNotEmpty);
        expect(domainHosts.any((h) => h.id == asset.id), isTrue);
      });

      test('Complex property filtering', () async {
        final webAsset = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '192.168.50.10',
          hostname: 'web-server',
          additionalProperties: {
            'os_family': const AssetPropertyValue.string('linux'),
            'ssl_enabled': const AssetPropertyValue.boolean(false),
            'web_server': const AssetPropertyValue.string('apache'),
          },
        );

        await repository.saveAsset(webAsset);

        final propertyFilters = {
          'os_family': 'linux',
          'ssl_enabled': false,
        };

        final matchingAssets = await repository.getAssetsWithProperties(
          testProjectId,
          propertyFilters,
        );

        expect(matchingAssets, isNotEmpty);
        expect(matchingAssets.any((a) => a.id == webAsset.id), isTrue);
      });
    });

    group('Asset Relationship Management', () {
      test('Create and retrieve relationships', () async {
        final networkSegment = AssetFactory.createNetworkSegment(
          projectId: testProjectId,
          subnet: '172.20.0.0/24',
          name: 'DMZ Network',
        );

        final webServer = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '172.20.0.10',
          hostname: 'web01',
          networkSegmentId: networkSegment.id,
        );

        await repository.saveAsset(networkSegment);
        await repository.saveAsset(webServer);

        // Create relationship through relationship manager
        final relationship = await relationshipManager.createRelationship(
          sourceAssetId: networkSegment.id,
          targetAssetId: webServer.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        expect(relationship.sourceAssetId, equals(networkSegment.id));
        expect(relationship.targetAssetId, equals(webServer.id));
        expect(relationship.relationshipType, equals(AssetRelationshipType.parentOf));

        // Verify relationship can be retrieved
        final relationships = await relationshipManager.getAssetRelationships(networkSegment.id);
        expect(relationships, isNotEmpty);
        expect(relationships.any((r) => r.targetAssetId == webServer.id), isTrue);
      });

      test('Asset hierarchy and discovery path', () async {
        final environment = AssetFactory.createEnvironment(
          projectId: testProjectId,
          name: 'Production Environment',
          environmentType: 'production',
        );

        final subnet = AssetFactory.createNetworkSegment(
          projectId: testProjectId,
          subnet: '10.10.0.0/16',
          name: 'Production LAN',
          environmentId: environment.id,
        );

        final server = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.10.1.50',
          hostname: 'prod-srv-01',
          networkSegmentId: subnet.id,
        );

        await repository.saveAsset(environment);
        await repository.saveAsset(subnet);
        await repository.saveAsset(server);

        // Create hierarchy relationships
        await relationshipManager.createRelationship(
          sourceAssetId: environment.id,
          targetAssetId: subnet.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        await relationshipManager.createRelationship(
          sourceAssetId: subnet.id,
          targetAssetId: server.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        // Test hierarchy retrieval
        final hierarchy = await relationshipManager.getAssetHierarchy(server.id);
        expect(hierarchy.asset.id, equals(server.id));
        expect(hierarchy.parents, isNotEmpty);

        // Test discovery path
        final discoveryPath = await relationshipManager.getDiscoveryPath(server.id);
        // Discovery path might be empty if not set, but the call should succeed
        expect(discoveryPath, isA<List<Asset>>());
      });

      test('Asset lifecycle state management', () async {
        final testHost = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '192.168.100.50',
          hostname: 'lifecycle-test',
        );

        await repository.saveAsset(testHost);

        // Test state transitions
        expect(testHost.lifecycleState, equals('unknown'));

        final discoveredHost = await relationshipManager.updateAssetState(
          testHost.id,
          'discovered',
        );
        expect(discoveredHost.lifecycleState, equals('discovered'));
        expect(discoveredHost.stateTransitions['discovered'], isNotNull);

        final scannedHost = await relationshipManager.updateAssetState(
          testHost.id,
          'scanned',
        );
        expect(scannedHost.lifecycleState, equals('scanned'));
        expect(scannedHost.stateTransitions['scanned'], isNotNull);

        // Test invalid state transition should throw
        expect(
          () async => await relationshipManager.updateAssetState(
            testHost.id,
            'cleaned', // Invalid transition from 'scanned' to 'cleaned'
          ),
          throwsA(isA<AssetRelationshipException>()),
        );
      });

      test('Property inheritance from parents', () async {
        final domainController = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.1.1.10',
          hostname: 'DC01',
          additionalProperties: {
            'domain_name': const AssetPropertyValue.string('corp.example.com'),
            'dns_servers': const AssetPropertyValue.stringList(['10.1.1.10', '10.1.1.11']),
            'time_zone': const AssetPropertyValue.string('UTC-5'),
            'is_domain_controller': const AssetPropertyValue.boolean(true),
          },
        );

        final memberServer = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.1.1.50',
          hostname: 'SRV01',
        );

        await repository.saveAsset(domainController);
        await repository.saveAsset(memberServer);

        // Create parent-child relationship
        await relationshipManager.createRelationship(
          sourceAssetId: domainController.id,
          targetAssetId: memberServer.id,
          relationshipType: AssetRelationshipType.parentOf,
        );

        // Test property inheritance
        final inheritedServer = await relationshipManager.inheritPropertiesFromParents(
          memberServer.id,
        );

        expect(inheritedServer.inheritedProperties['domain_name'], equals('corp.example.com'));
        expect(inheritedServer.inheritedProperties['time_zone'], equals('UTC-5'));
        expect(inheritedServer.inheritedProperties['dns_servers'], contains('10.1.1.10'));
      });
    });

    group('Bulk Operations and Performance', () {
      test('Bulk asset operations', () async {
        final bulkAssets = <Asset>[];

        // Create 25 assets for bulk testing
        for (int i = 1; i <= 25; i++) {
          final asset = AssetFactory.createHost(
            projectId: testProjectId,
            ipAddress: '172.30.1.$i',
            hostname: 'bulk-host-$i',
            additionalProperties: {
              'batch_id': AssetPropertyValue.string('bulk-test-${DateTime.now().millisecondsSinceEpoch}'),
              'host_number': AssetPropertyValue.integer(i),
            },
          );
          bulkAssets.add(asset);
        }

        final stopwatch = Stopwatch()..start();
        await repository.bulkSaveAssets(bulkAssets);
        stopwatch.stop();

        print('Bulk saved 25 assets in ${stopwatch.elapsedMilliseconds}ms');

        // Verify all assets were saved
        final savedAssets = await repository.getProjectAssets(testProjectId);
        final bulkAssetIds = bulkAssets.map((a) => a.id).toSet();
        final foundBulkAssets = savedAssets.where((a) => bulkAssetIds.contains(a.id)).toList();

        expect(foundBulkAssets.length, equals(25));
        expect(stopwatch.elapsedMilliseconds, lessThan(2000)); // Should complete quickly
      });

      test('Asset statistics generation', () async {
        final stats = await repository.getAssetStatistics(testProjectId);

        expect(stats['total'], isA<int>());
        expect(stats['total'], greaterThan(0));
        expect(stats['by_type'], isA<Map>());
        expect(stats['by_state'], isA<Map>());
        expect(stats['by_discovery_status'], isA<Map>());

        print('Project statistics: $stats');
      });
    });

    group('Error Handling and Edge Cases', () {
      test('Handle non-existent asset gracefully', () async {
        final nonExistentAsset = await repository.getAsset('non-existent-id');
        expect(nonExistentAsset, isNull);

        final nonExistentRelationships = await relationshipManager.getAssetRelationships('non-existent-id');
        expect(nonExistentRelationships, isEmpty);
      });

      test('Handle invalid relationship creation', () async {
        expect(
          () async => await relationshipManager.createRelationship(
            sourceAssetId: 'non-existent-source',
            targetAssetId: 'non-existent-target',
            relationshipType: AssetRelationshipType.parentOf,
          ),
          throwsA(isA<AssetRelationshipException>()),
        );
      });

      test('Handle empty search results', () async {
        final emptyResults = await repository.searchAssetsByProperty(
          testProjectId,
          'non_existent_property',
          'non_existent_value',
        );
        expect(emptyResults, isEmpty);

        final emptyTypeResults = await repository.getAssetsByType(testProjectId, AssetType.vulnerability);
        // Should not throw, might be empty depending on test state
        expect(emptyTypeResults, isA<List<Asset>>());
      });
    });

    group('Data Consistency and Integrity', () {
      test('Asset property serialization and deserialization', () async {
        final complexAsset = AssetFactory.createCloudTenant(
          projectId: testProjectId,
          tenantName: 'Test Azure Tenant',
          tenantType: 'azure',
          tenantId: 'test-tenant-123',
          additionalProperties: {
            'subscription_ids': const AssetPropertyValue.stringList(['sub-1', 'sub-2']),
            'security_score': const AssetPropertyValue.double(85.5),
            'compliance_status': const AssetPropertyValue.map({
              'gdpr': true,
              'sox': false,
              'pci': true,
            }),
            'last_audit': AssetPropertyValue.dateTime(DateTime.now().subtract(const Duration(days: 30))),
          },
        );

        await repository.saveAsset(complexAsset);
        final retrieved = await repository.getAsset(complexAsset.id);

        expect(retrieved, isNotNull);

        // Test string list property
        final subscriptions = retrieved!.properties['subscription_ids'];
        subscriptions?.when(
          stringList: (value) => expect(value, containsAll(['sub-1', 'sub-2'])),
          string: (value) => fail('Expected stringList, got string'),
          integer: (value) => fail('Expected stringList, got integer'),
          double: (value) => fail('Expected stringList, got double'),
          boolean: (value) => fail('Expected stringList, got boolean'),
          dateTime: (value) => fail('Expected stringList, got dateTime'),
          map: (value) => fail('Expected stringList, got map'),
          objectList: (value) => fail('Expected stringList, got objectList'),
        );

        // Test double property
        final score = retrieved.properties['security_score'];
        score?.when(
          double: (value) => expect(value, equals(85.5)),
          string: (value) => fail('Expected double, got string'),
          integer: (value) => fail('Expected double, got integer'),
          boolean: (value) => fail('Expected double, got boolean'),
          stringList: (value) => fail('Expected double, got stringList'),
          dateTime: (value) => fail('Expected double, got dateTime'),
          map: (value) => fail('Expected double, got map'),
          objectList: (value) => fail('Expected double, got objectList'),
        );

        // Test map property
        final compliance = retrieved.properties['compliance_status'];
        compliance?.when(
          map: (value) => {
            expect(value['gdpr'], equals(true)),
            expect(value['sox'], equals(false)),
            expect(value['pci'], equals(true)),
          },
          string: (value) => fail('Expected map, got string'),
          integer: (value) => fail('Expected map, got integer'),
          double: (value) => fail('Expected map, got double'),
          boolean: (value) => fail('Expected map, got boolean'),
          stringList: (value) => fail('Expected map, got stringList'),
          dateTime: (value) => fail('Expected map, got dateTime'),
          objectList: (value) => fail('Expected map, got objectList'),
        );
      });

      test('Relationship metadata persistence', () async {
        final source = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.2.1.10',
          hostname: 'metadata-source',
        );

        final target = AssetFactory.createHost(
          projectId: testProjectId,
          ipAddress: '10.2.1.20',
          hostname: 'metadata-target',
        );

        await repository.saveAsset(source);
        await repository.saveAsset(target);

        final metadata = RelationshipMetadata(
          discoveryMethod: 'network_scan',
          confidence: 'high',
          discoveredAt: DateTime.now(),
          validatedAt: DateTime.now(),
          additionalData: {
            'scan_tool': 'nmap',
            'response_time': 25,
          },
          notes: 'Discovered via automated network scanning',
        );

        final relationship = await relationshipManager.createRelationship(
          sourceAssetId: source.id,
          targetAssetId: target.id,
          relationshipType: AssetRelationshipType.connectedTo,
          metadata: metadata,
        );

        expect(relationship.metadata, isNotNull);
        expect(relationship.metadata!.discoveryMethod, equals('network_scan'));
        expect(relationship.metadata!.confidence, equals('high'));
        expect(relationship.metadata!.notes, equals('Discovered via automated network scanning'));
      });
    });
  });
}