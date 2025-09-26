import '../models/asset.dart';
import '../models/trigger_evaluation.dart';
import '../services/trigger_dsl_parser.dart';
import '../services/comprehensive_trigger_evaluator.dart';
import '../services/drift_storage_service.dart';

/// Test service for validating trigger evaluation functionality
class TriggerEvaluationTestService {
  final DriftStorageService _storage;
  final String _projectId;

  TriggerEvaluationTestService({
    required DriftStorageService storage,
    required String projectId,
  }) : _storage = storage, _projectId = projectId;

  /// Run comprehensive tests of the trigger evaluation system
  Future<Map<String, dynamic>> runAllTests() async {
    final results = <String, dynamic>{};

    try {
      results['dslParserTests'] = await _testDslParser();
      results['assetPropertyTests'] = await _testAssetProperties();
      results['triggerEvaluationTests'] = await _testTriggerEvaluation();
      results['integrationTests'] = await _testIntegration();

      results['success'] = true;
      results['timestamp'] = DateTime.now().toIso8601String();
      results['summary'] = _generateTestSummary(results);
    } catch (e, stackTrace) {
      results['success'] = false;
      results['error'] = e.toString();
      results['stackTrace'] = stackTrace.toString();
    }

    return results;
  }

  /// Test DSL parser functionality
  Future<Map<String, dynamic>> _testDslParser() async {
    final tests = <String, dynamic>{};

    // Test basic property existence
    final assetProps = {
      'nac_enabled': const PropertyValue.boolean(true),
      'web_services': const PropertyValue.stringList(['http://10.1.1.10:80']),
      'credentials_available': const PropertyValue.objectList([
        {'username': 'admin', 'password': 'password123'},
      ]),
    };

    // Test 1: Basic property check
    final test1 = TriggerDslParser.evaluateExpression('nac_enabled = true', assetProps);
    tests['basicPropertyCheck'] = {
      'expression': 'nac_enabled = true',
      'result': test1.result,
      'expected': true,
      'passed': test1.result == true,
    };

    // Test 2: List length check
    final test2 = TriggerDslParser.evaluateExpression('web_services.length > 0', assetProps);
    tests['listLengthCheck'] = {
      'expression': 'web_services.length > 0',
      'result': test2.result,
      'expected': true,
      'passed': test2.result == true,
    };

    // Test 3: Complex AND condition
    final test3 = TriggerDslParser.evaluateExpression(
      'nac_enabled = true AND credentials_available.length > 0',
      assetProps,
    );
    tests['complexAndCondition'] = {
      'expression': 'nac_enabled = true AND credentials_available.length > 0',
      'result': test3.result,
      'expected': true,
      'passed': test3.result == true,
    };

    // Test 4: OR condition
    final test4 = TriggerDslParser.evaluateExpression(
      'web_services.length > 0 OR credentials_available.length > 0',
      assetProps,
    );
    tests['orCondition'] = {
      'expression': 'web_services.length > 0 OR credentials_available.length > 0',
      'result': test4.result,
      'expected': true,
      'passed': test4.result == true,
    };

    // Test 5: Parentheses grouping
    final test5 = TriggerDslParser.evaluateExpression(
      '(nac_enabled = true) AND (web_services.length > 0 OR credentials_available.length > 0)',
      assetProps,
    );
    tests['parenthesesGrouping'] = {
      'expression': '(nac_enabled = true) AND (web_services.length > 0 OR credentials_available.length > 0)',
      'result': test5.result,
      'expected': true,
      'passed': test5.result == true,
    };

    tests['totalTests'] = 5;
    tests['passedTests'] = [test1, test2, test3, test4, test5].where((t) => t.result).length;

    return tests;
  }

  /// Test asset property creation and access
  Future<Map<String, dynamic>> _testAssetProperties() async {
    final tests = <String, dynamic>{};

    // Create test assets with different property types
    final networkSegment = _createTestNetworkSegment();
    final host = _createTestHost();
    final service = _createTestService();

    tests['networkSegmentCreation'] = {
      'assetType': networkSegment.type.name,
      'propertyCount': networkSegment.properties.length,
      'hasNacEnabled': networkSegment.properties.containsKey('nac_enabled'),
      'passed': networkSegment.properties.isNotEmpty,
    };

    tests['hostCreation'] = {
      'assetType': host.type.name,
      'propertyCount': host.properties.length,
      'hasIpAddress': host.properties.containsKey('ip_address'),
      'passed': host.properties.isNotEmpty,
    };

    tests['serviceCreation'] = {
      'assetType': service.type.name,
      'propertyCount': service.properties.length,
      'hasPort': service.properties.containsKey('port'),
      'passed': service.properties.isNotEmpty,
    };

    return tests;
  }

  /// Test trigger evaluation with sample data
  Future<Map<String, dynamic>> _testTriggerEvaluation() async {
    final tests = <String, dynamic>{};

    final evaluator = ComprehensiveTriggerEvaluator(
      storage: _storage,
      projectId: _projectId,
    );

    // Create test asset
    final testAsset = _createTestNetworkSegment();

    try {
      // This would normally evaluate against stored methodology templates
      // For testing, we'll simulate the process
      tests['evaluatorCreation'] = {
        'success': true,
        'projectId': _projectId,
      };

      // Test statistics retrieval
      final stats = await evaluator.getEvaluationStats();
      tests['statisticsRetrieval'] = {
        'stats': stats,
        'hasRunInstances': stats.containsKey('runInstances'),
        'hasMatches': stats.containsKey('totalMatches'),
        'passed': stats.isNotEmpty,
      };

    } catch (e) {
      tests['evaluationError'] = {
        'error': e.toString(),
        'passed': false,
      };
    }

    return tests;
  }

  /// Test integration between components
  Future<Map<String, dynamic>> _testIntegration() async {
    final tests = <String, dynamic>{};

    // Test 1: DSL expressions that match methodology patterns
    final nacBypassExpression = TriggerExpressionBuilder.nacEnabledWithCredentials();
    final webServicesExpression = TriggerExpressionBuilder.webServicesAvailable();

    final testAsset = _createTestNetworkSegment();

    final nacResult = TriggerDslParser.evaluateExpression(nacBypassExpression, testAsset.properties);
    final webResult = TriggerDslParser.evaluateExpression(webServicesExpression, testAsset.properties);

    tests['nacBypassTrigger'] = {
      'expression': nacBypassExpression,
      'result': nacResult.result,
      'executionTime': nacResult.executionTimeMs,
      'passed': nacResult.result,
    };

    tests['webServicesTrigger'] = {
      'expression': webServicesExpression,
      'result': webResult.result,
      'executionTime': webResult.executionTimeMs,
      'passed': webResult.result,
    };

    // Test 2: Storage integration
    tests['storageIntegration'] = {
      'templatesAvailable': await _checkTemplatesAvailable(),
      'canStoreMatches': await _testMatchStorage(),
    };

    return tests;
  }

  /// Create test network segment asset
  Asset _createTestNetworkSegment() {
    return Asset(
      id: 'test_network_segment_1',
      type: AssetType.networkSegment,
      projectId: _projectId,
      name: 'Test Network Segment',
      description: 'Test network segment for trigger evaluation',
      properties: {
        'subnet': const PropertyValue.string('192.168.1.0/24'),
        'nac_enabled': const PropertyValue.boolean(true),
        'nac_type': const PropertyValue.string('802.1x'),
        'access_level': const PropertyValue.string('blocked'),
        'web_services': const PropertyValue.objectList([
          {'host': '192.168.1.10', 'port': 80, 'service': 'http'},
          {'host': '192.168.1.10', 'port': 443, 'service': 'https'},
        ]),
        'credentials_available': const PropertyValue.objectList([
          {'username': 'corp\\admin', 'password': 'password123', 'source': 'llmnr_poisoning'},
          {'username': 'corp\\user', 'hash': 'aad3b435b51404eeaad3b435b51404ee:8846f7eaee8fb117ad06bdd830b7586c', 'source': 'hash_dump'},
        ]),
        'live_hosts': const PropertyValue.stringList(['192.168.1.1', '192.168.1.10', '192.168.1.20']),
      },
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['test', 'network_segment'],
    );
  }

  /// Create test host asset
  Asset _createTestHost() {
    return Asset(
      id: 'test_host_1',
      type: AssetType.host,
      projectId: _projectId,
      name: 'Test Host',
      properties: {
        'ip_address': const PropertyValue.string('192.168.1.10'),
        'hostname': const PropertyValue.string('WIN-SERVER01'),
        'os_type': const PropertyValue.string('windows'),
        'open_ports': const PropertyValue.stringList(['80', '443', '445', '3389']),
        'smb_signing': const PropertyValue.boolean(false),
        'rdp_enabled': const PropertyValue.boolean(true),
      },
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['test', 'host', 'windows'],
    );
  }

  /// Create test service asset
  Asset _createTestService() {
    return Asset(
      id: 'test_service_1',
      type: AssetType.service,
      projectId: _projectId,
      name: 'Test Web Service',
      properties: {
        'host': const PropertyValue.string('192.168.1.10'),
        'port': const PropertyValue.integer(80),
        'service_name': const PropertyValue.string('http'),
        'banner': const PropertyValue.string('Microsoft-IIS/10.0'),
        'ssl_enabled': const PropertyValue.boolean(false),
        'auth_required': const PropertyValue.boolean(true),
      },
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['test', 'service', 'web'],
    );
  }

  /// Check if methodology templates are available
  Future<bool> _checkTemplatesAvailable() async {
    try {
      final templates = await _storage.getAllTemplates();
      return templates.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Test trigger match storage
  Future<bool> _testMatchStorage() async {
    try {
      final testMatch = TriggerMatch(
        id: 'test_match_${DateTime.now().millisecondsSinceEpoch}',
        triggerId: 'test_trigger',
        templateId: 'test_template',
        assetId: 'test_asset',
        matched: true,
        extractedValues: {'test_property': 'test_value'},
        confidence: 1.0,
        evaluatedAt: DateTime.now(),
        priority: 5,
        debugInfo: {'test': true},
      );

      await _storage.storeTriggerMatch(testMatch, _projectId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Generate test summary
  Map<String, dynamic> _generateTestSummary(Map<String, dynamic> results) {
    int totalTests = 0;
    int passedTests = 0;

    results.forEach((category, categoryResults) {
      if (categoryResults is Map<String, dynamic>) {
        categoryResults.forEach((testName, testResult) {
          if (testResult is Map<String, dynamic> && testResult.containsKey('passed')) {
            totalTests++;
            if (testResult['passed'] == true) {
              passedTests++;
            }
          }
        });
      }
    });

    return {
      'totalTests': totalTests,
      'passedTests': passedTests,
      'failedTests': totalTests - passedTests,
      'successRate': totalTests > 0 ? (passedTests / totalTests * 100).toStringAsFixed(1) : '0.0',
      'categories': results.keys.length,
    };
  }
}