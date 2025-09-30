import 'package:flutter_test/flutter_test.dart';
import '../lib/database/database.dart';
import '../lib/repositories/asset_repository.dart';
import '../lib/services/asset_relationship_manager.dart';
import '../lib/models/assets.dart';
import '../lib/models/asset_relationships.dart';

void main() {
  test('Asset Repository Integration - Simple Verification', () async {
    // Initialize components
    final database = MadnessDatabase();
    final repository = AssetRepository(database);
    final relationshipManager = AssetRelationshipManager(repository);

    try {
      const projectId = 'test-project';

      // Create test asset
      final testAsset = AssetFactory.createHost(
        projectId: projectId,
        ipAddress: '192.168.1.100',
        hostname: 'test-host',
        additionalProperties: {
          'os_family': const AssetPropertyValue.string('linux'),
          'test_property': const AssetPropertyValue.boolean(true),
        },
      );

      // Test basic CRUD operations
      print('Testing save asset...');
      await repository.saveAsset(testAsset);

      print('Testing retrieve asset...');
      final retrieved = await repository.getAsset(testAsset.id);
      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals(testAsset.id));
      expect(retrieved.name, equals(testAsset.name));

      // Test new relationship fields are preserved
      expect(retrieved.relationships, isA<Map<String, List<String>>>());
      expect(retrieved.inheritedProperties, isA<Map<String, dynamic>>());
      expect(retrieved.lifecycleState, isA<String>());
      expect(retrieved.stateTransitions, isA<Map<String, DateTime>>());

      print('Testing project assets query...');
      final projectAssets = await repository.getProjectAssets(projectId);
      expect(projectAssets, isNotEmpty);
      expect(projectAssets.any((a) => a.id == testAsset.id), isTrue);

      // Test relationship manager integration
      print('Testing relationship manager...');
      final assetFromManager = await relationshipManager.getAsset(testAsset.id);
      expect(assetFromManager, isNotNull);
      expect(assetFromManager!.id, equals(testAsset.id));

      // Test state update through relationship manager
      print('Testing state transition...');
      final updatedAsset = await relationshipManager.updateAssetState(
        testAsset.id,
        'discovered',
      );
      expect(updatedAsset.lifecycleState, equals('discovered'));
      expect(updatedAsset.stateTransitions.containsKey('discovered'), isTrue);

      print('✅ All tests passed! Asset Repository is working correctly.');

    } catch (error, stackTrace) {
      print('❌ Test failed: $error');
      print('Stack trace: $stackTrace');
      rethrow;
    } finally {
      relationshipManager.dispose();
      await database.close();
    }
  });
}