import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/database/database.dart';
import '../lib/repositories/asset_repository.dart';
import '../lib/services/asset_relationship_manager.dart';
import '../lib/providers/asset_repository_provider.dart';
import '../lib/models/assets.dart';
import '../lib/models/asset_relationships.dart';

/// Comprehensive example demonstrating the Asset Relationship System
///
/// This example shows how to:
/// 1. Set up the database and repositories
/// 2. Create assets with complex properties
/// 3. Establish relationships between assets
/// 4. Manage asset lifecycle states
/// 5. Use property inheritance
/// 6. Search and filter assets
/// 7. Use Riverpod providers for state management
///
/// Run this example with: dart run example/asset_relationship_system_example.dart
void main() async {
  print('🚀 Asset Relationship System Example');
  print('=====================================\n');

  // Initialize the system
  await runBasicExample();
  print('\n');
  await runAdvancedExample();
  print('\n');
  await runProviderExample();
}

/// Basic example showing fundamental operations
Future<void> runBasicExample() async {
  print('📋 BASIC EXAMPLE - Database Operations');
  print('--------------------------------------');

  // 1. Initialize database and repository
  final database = MadnessDatabase();
  final repository = AssetRepository(database);
  final relationshipManager = AssetRelationshipManager(repository);

  const projectId = 'demo-project-basic';

  try {
    // 2. Create assets with properties
    print('Creating assets...');

    final environment = AssetFactory.createEnvironment(
      projectId: projectId,
      name: 'Corporate Network',
      environmentType: 'production',
      additionalProperties: {
        'domain_name': const AssetPropertyValue.string('corp.example.com'),
        'security_level': const AssetPropertyValue.string('high'),
        'compliance_frameworks': const AssetPropertyValue.stringList(['SOX', 'PCI-DSS']),
      },
    );

    final dmzNetwork = AssetFactory.createNetworkSegment(
      projectId: projectId,
      subnet: '10.1.1.0/24',
      name: 'DMZ Network',
      environmentId: environment.id,
      additionalProperties: {
        'vlan_id': const AssetPropertyValue.integer(100),
        'firewall_protected': const AssetPropertyValue.boolean(true),
        'public_facing': const AssetPropertyValue.boolean(true),
      },
    );

    final webServer = AssetFactory.createHost(
      projectId: projectId,
      ipAddress: '10.1.1.10',
      hostname: 'web01.corp.example.com',
      networkSegmentId: dmzNetwork.id,
      additionalProperties: {
        'os_family': const AssetPropertyValue.string('linux'),
        'os_version': const AssetPropertyValue.string('Ubuntu 22.04 LTS'),
        'services': const AssetPropertyValue.stringList(['http:80', 'https:443', 'ssh:22']),
        'last_patched': AssetPropertyValue.dateTime(DateTime.now().subtract(const Duration(days: 7))),
      },
    );

    // 3. Save assets to database
    await repository.saveAsset(environment);
    await repository.saveAsset(dmzNetwork);
    await repository.saveAsset(webServer);

    // Update property indexes for searching
    await repository.updatePropertyIndex(environment);
    await repository.updatePropertyIndex(dmzNetwork);
    await repository.updatePropertyIndex(webServer);

    print('✅ Created 3 assets');

    // 4. Create relationships
    print('Creating relationships...');

    await relationshipManager.createRelationship(
      sourceAssetId: environment.id,
      targetAssetId: dmzNetwork.id,
      relationshipType: AssetRelationshipType.parentOf,
      metadata: RelationshipMetadata(
        discoveryMethod: 'network_topology_scan',
        confidence: 'high',
        discoveredAt: DateTime.now(),
        notes: 'DMZ is part of corporate environment',
      ),
    );

    await relationshipManager.createRelationship(
      sourceAssetId: dmzNetwork.id,
      targetAssetId: webServer.id,
      relationshipType: AssetRelationshipType.parentOf,
      metadata: RelationshipMetadata(
        discoveryMethod: 'subnet_scan',
        confidence: 'confirmed',
        discoveredAt: DateTime.now(),
        notes: 'Web server is in DMZ subnet',
      ),
    );

    print('✅ Created 2 relationships');

    // 5. Demonstrate asset lifecycle management
    print('Managing asset states...');

    final discoveredServer = await relationshipManager.updateAssetState(
      webServer.id,
      'discovered',
    );
    print('🔄 Web server state: ${discoveredServer.lifecycleState}');

    final scannedServer = await relationshipManager.updateAssetState(
      webServer.id,
      'scanned',
    );
    print('🔄 Web server state: ${scannedServer.lifecycleState}');

    // 6. Demonstrate property inheritance
    print('Testing property inheritance...');

    final inheritedServer = await relationshipManager.inheritPropertiesFromParents(
      webServer.id,
    );

    print('🧬 Inherited properties:');
    inheritedServer.inheritedProperties.forEach((key, value) {
      print('   $key: $value');
    });

    // 7. Query and search operations
    print('Querying assets...');

    final projectAssets = await repository.getProjectAssets(projectId);
    print('📊 Total project assets: ${projectAssets.length}');

    final hostAssets = await repository.getAssetsByType(projectId, AssetType.host);
    print('🖥️  Host assets: ${hostAssets.length}');

    final linuxHosts = await repository.searchAssetsByProperty(
      projectId,
      'os_family',
      'linux',
    );
    print('🐧 Linux hosts: ${linuxHosts.length}');

    // 8. Get asset hierarchy
    final hierarchy = await relationshipManager.getAssetHierarchy(webServer.id);
    print('🌳 Asset hierarchy for ${hierarchy.asset.name}:');
    print('   Parents: ${hierarchy.parents.map((p) => p.name).join(', ')}');
    print('   Children: ${hierarchy.children.map((c) => c.name).join(', ')}');

    print('✅ Basic example completed successfully!');

  } catch (error) {
    print('❌ Error in basic example: $error');
  } finally {
    relationshipManager.dispose();
    await database.close();
  }
}

/// Advanced example showing complex scenarios
Future<void> runAdvancedExample() async {
  print('🔬 ADVANCED EXAMPLE - Complex Scenarios');
  print('---------------------------------------');

  final database = MadnessDatabase();
  final repository = AssetRepository(database);
  final relationshipManager = AssetRelationshipManager(repository);

  const projectId = 'demo-project-advanced';

  try {
    // Create a complex environment with multiple network segments
    final datacenter = AssetFactory.createEnvironment(
      projectId: projectId,
      name: 'Production Datacenter',
      environmentType: 'production',
      additionalProperties: {
        'location': const AssetPropertyValue.string('US-East-1'),
        'tier_level': const AssetPropertyValue.string('tier_3'),
        'uptime_sla': const AssetPropertyValue.double(99.95),
      },
    );

    final managementNetwork = AssetFactory.createNetworkSegment(
      projectId: projectId,
      subnet: '172.16.0.0/24',
      name: 'Management Network',
      environmentId: datacenter.id,
      additionalProperties: {
        'vlan_id': const AssetPropertyValue.integer(10),
        'access_control': const AssetPropertyValue.string('restricted'),
      },
    );

    final serverNetwork = AssetFactory.createNetworkSegment(
      projectId: projectId,
      subnet: '172.16.1.0/24',
      name: 'Server Network',
      environmentId: datacenter.id,
      additionalProperties: {
        'vlan_id': const AssetPropertyValue.integer(20),
        'access_control': const AssetPropertyValue.string('internal_only'),
      },
    );

    final domainController = AssetFactory.createHost(
      projectId: projectId,
      ipAddress: '172.16.0.10',
      hostname: 'DC01.corp.local',
      networkSegmentId: managementNetwork.id,
      additionalProperties: {
        'os_family': const AssetPropertyValue.string('windows'),
        'os_version': const AssetPropertyValue.string('Windows Server 2022'),
        'roles': const AssetPropertyValue.stringList(['domain_controller', 'dns', 'dhcp']),
        'is_critical': const AssetPropertyValue.boolean(true),
      },
    );

    final fileServer = AssetFactory.createHost(
      projectId: projectId,
      ipAddress: '172.16.1.20',
      hostname: 'FS01.corp.local',
      networkSegmentId: serverNetwork.id,
      additionalProperties: {
        'os_family': const AssetPropertyValue.string('windows'),
        'os_version': const AssetPropertyValue.string('Windows Server 2022'),
        'roles': const AssetPropertyValue.stringList(['file_server', 'print_server']),
        'storage_capacity_gb': const AssetPropertyValue.integer(10240),
      },
    );

    // Save all assets
    final assets = [datacenter, managementNetwork, serverNetwork, domainController, fileServer];
    await repository.bulkSaveAssets(assets);

    // Update property indexes
    for (final asset in assets) {
      await repository.updatePropertyIndex(asset);
    }

    print('✅ Created complex environment with ${assets.length} assets');

    // Create trust relationship between servers
    await relationshipManager.createRelationship(
      sourceAssetId: domainController.id,
      targetAssetId: fileServer.id,
      relationshipType: AssetRelationshipType.trusts,
      metadata: RelationshipMetadata(
        discoveryMethod: 'active_directory_enumeration',
        confidence: 'high',
        additionalData: {'trust_type': 'kerberos', 'bidirectional': true},
        notes: 'Domain trust for authentication',
      ),
    );

    // Create communication relationship
    await relationshipManager.createRelationship(
      sourceAssetId: managementNetwork.id,
      targetAssetId: serverNetwork.id,
      relationshipType: AssetRelationshipType.routesTo,
      metadata: RelationshipMetadata(
        discoveryMethod: 'routing_table_analysis',
        confidence: 'confirmed',
        additionalData: {'routing_protocol': 'static', 'cost': 1},
        notes: 'Management network can route to server network',
      ),
    );

    print('✅ Created trust and routing relationships');

    // Demonstrate complex property filtering
    final windowsServers = await repository.getAssetsWithProperties(
      projectId,
      {'os_family': 'windows', 'is_critical': true},
    );
    print('🪟 Critical Windows servers: ${windowsServers.length}');

    // Demonstrate asset statistics
    final stats = await repository.getAssetStatistics(projectId);
    print('📈 Project statistics:');
    print('   Total assets: ${stats['total']}');
    print('   By type: ${stats['by_type']}');
    print('   By state: ${stats['by_state']}');

    // Simulate compromise scenario
    print('🚨 Simulating security incident...');

    final compromisedDC = await relationshipManager.updateAssetState(
      domainController.id,
      'compromised',
    );
    print('⚠️  Domain controller compromised: ${compromisedDC.lifecycleState}');

    // Find related assets that might be at risk
    final trustedAssets = await relationshipManager.getRelatedAssets(
      domainController.id,
      AssetRelationshipType.trusts,
    );
    print('🔍 Assets that trust compromised DC: ${trustedAssets.map((a) => a.name).join(', ')}');

    // Get all compromised assets
    final compromisedAssets = await relationshipManager.getCompromisedAssets();
    print('💥 All compromised assets: ${compromisedAssets.map((a) => a.name).join(', ')}');

    print('✅ Advanced example completed successfully!');

  } catch (error) {
    print('❌ Error in advanced example: $error');
  } finally {
    relationshipManager.dispose();
    await database.close();
  }
}

/// Example showing Riverpod provider usage
Future<void> runProviderExample() async {
  print('🏗️  PROVIDER EXAMPLE - Riverpod Integration');
  print('------------------------------------------');

  // Create a provider container for testing
  final container = ProviderContainer();

  const projectId = 'demo-project-providers';

  try {
    // Get repository and relationship manager from providers
    final repository = container.read(assetRepositoryProvider);
    final relationshipManager = container.read(assetRelationshipManagerProvider);

    print('✅ Initialized providers');

    // Create some test assets
    final testEnvironment = AssetFactory.createEnvironment(
      projectId: projectId,
      name: 'Test Environment',
      environmentType: 'testing',
    );

    final testNetwork = AssetFactory.createNetworkSegment(
      projectId: projectId,
      subnet: '192.168.100.0/24',
      name: 'Test Network',
      environmentId: testEnvironment.id,
    );

    await repository.saveAsset(testEnvironment);
    await repository.saveAsset(testNetwork);

    print('✅ Created test assets');

    // Use providers to get data
    final projectAssets = await container.read(projectAssetsProvider(projectId).future);
    print('📋 Project assets via provider: ${projectAssets.length}');

    final environmentAssets = await container.read(
      assetsByTypeProvider((projectId, AssetType.environment)).future,
    );
    print('🌍 Environment assets via provider: ${environmentAssets.length}');

    final statistics = await container.read(assetStatisticsProvider(projectId).future);
    print('📊 Statistics via provider: ${statistics['total']} total assets');

    // Create relationship and get hierarchy
    await relationshipManager.createRelationship(
      sourceAssetId: testEnvironment.id,
      targetAssetId: testNetwork.id,
      relationshipType: AssetRelationshipType.parentOf,
    );

    final hierarchy = await container.read(
      assetHierarchyProviderNew(testNetwork.id).future,
    );
    print('🌳 Hierarchy via provider: ${hierarchy.parents.length} parents, ${hierarchy.children.length} children');

    print('✅ Provider example completed successfully!');

  } catch (error) {
    print('❌ Error in provider example: $error');
  } finally {
    container.dispose();
  }
}

/// Helper function to demonstrate error handling
Future<void> demonstrateErrorHandling() async {
  print('⚠️  ERROR HANDLING EXAMPLES');
  print('---------------------------');

  final database = MadnessDatabase();
  final repository = AssetRepository(database);
  final relationshipManager = AssetRelationshipManager(repository);

  try {
    // Try to get non-existent asset
    final nonExistent = await repository.getAsset('non-existent-id');
    assert(nonExistent == null, 'Should return null for non-existent asset');
    print('✅ Handled non-existent asset gracefully');

    // Try invalid state transition
    final testHost = AssetFactory.createHost(
      projectId: 'error-test',
      ipAddress: '1.1.1.1',
      hostname: 'error-host',
    );
    await repository.saveAsset(testHost);

    try {
      await relationshipManager.updateAssetState(testHost.id, 'invalid-state');
      print('❌ Should have thrown exception for invalid state');
    } on AssetRelationshipException catch (e) {
      print('✅ Caught expected exception: ${e.message}');
    }

    // Try creating relationship with non-existent assets
    try {
      await relationshipManager.createRelationship(
        sourceAssetId: 'non-existent-1',
        targetAssetId: 'non-existent-2',
        relationshipType: AssetRelationshipType.parentOf,
      );
      print('❌ Should have thrown exception for non-existent assets');
    } on AssetRelationshipException catch (e) {
      print('✅ Caught expected exception: ${e.message}');
    }

    print('✅ Error handling examples completed');

  } finally {
    relationshipManager.dispose();
    await database.close();
  }
}

/// Performance testing helper
Future<void> performanceTest() async {
  print('⚡ PERFORMANCE TEST');
  print('------------------');

  final database = MadnessDatabase();
  final repository = AssetRepository(database);
  final relationshipManager = AssetRelationshipManager(repository);

  const projectId = 'performance-test';
  final stopwatch = Stopwatch();

  try {
    // Create many assets
    stopwatch.start();
    final assets = <Asset>[];

    for (int i = 1; i <= 100; i++) {
      final asset = AssetFactory.createHost(
        projectId: projectId,
        ipAddress: '10.0.${i ~/ 256}.${i % 256}',
        hostname: 'host-$i',
        additionalProperties: {
          'batch_number': AssetPropertyValue.integer(i),
          'created_at': AssetPropertyValue.dateTime(DateTime.now()),
        },
      );
      assets.add(asset);
    }

    await repository.bulkSaveAssets(assets);
    stopwatch.stop();

    print('✅ Created 100 assets in ${stopwatch.elapsedMilliseconds}ms');

    // Test bulk property indexing
    stopwatch.reset();
    stopwatch.start();

    for (final asset in assets.take(50)) {
      await repository.updatePropertyIndex(asset);
    }

    stopwatch.stop();
    print('✅ Indexed 50 assets in ${stopwatch.elapsedMilliseconds}ms');

    // Test search performance
    stopwatch.reset();
    stopwatch.start();

    final searchResults = await repository.searchAssetsByProperty(
      projectId,
      'batch_number',
      '50',
    );

    stopwatch.stop();
    print('✅ Searched ${assets.length} assets in ${stopwatch.elapsedMilliseconds}ms (${searchResults.length} results)');

    print('✅ Performance test completed');

  } finally {
    relationshipManager.dispose();
    await database.close();
  }
}