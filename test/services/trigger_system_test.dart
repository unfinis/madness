import 'package:flutter_test/flutter_test.dart';
import 'package:madness/services/trigger_system/execution_policy.dart';
import 'package:madness/services/trigger_system/execution_history.dart';
import 'package:madness/services/trigger_system/trigger_matcher.dart';
import 'package:madness/services/trigger_system/models/trigger_match_result.dart';
import 'package:madness/services/trigger_system/models/execution_decision.dart';
import 'package:madness/services/trigger_system/models/execution_priority.dart';

void main() {
  group('Trigger System Integration', () {
    late ExecutionHistory history;
    late ExecutionPolicy policy;

    setUp(() {
      history = ExecutionHistory();
      policy = ExecutionPolicy(history: history);
    });

    test('boolean matching returns true/false only', () {
      // Create a simple match result
      final matchResult = TriggerMatchResult.matched(
        triggerId: 'test-trigger',
        assetId: 'test-asset',
        context: {'os_type': 'windows'},
        reason: 'Test match',
        conditionChecks: [
          ConditionCheckResult(
            property: 'os_type',
            operator: '==',
            expectedValue: 'windows',
            actualValue: 'windows',
            passed: true,
            description: 'OS type is windows',
          ),
        ],
      );

      // CRITICAL: Must be boolean, not percentage
      expect(matchResult.matched, isA<bool>());
      expect(matchResult.matched, isTrue);

      // Verify no confidence field exists
      expect(matchResult.toString().contains('confidence'), isFalse);
    });

    test('no match result is boolean false', () {
      final notMatchedResult = TriggerMatchResult.notMatched(
        triggerId: 'test-trigger',
        assetId: 'test-asset',
        reason: 'Condition failed',
        conditionChecks: [
          ConditionCheckResult(
            property: 'os_type',
            operator: '==',
            expectedValue: 'windows',
            actualValue: 'linux',
            passed: false,
            description: 'OS type mismatch',
          ),
        ],
      );

      expect(notMatchedResult.matched, isFalse);
      expect(notMatchedResult.context, isEmpty);
    });

    test('priority is separate from matching', () {
      // High priority execution
      final highPriority = ExecutionPriority.critical('Critical asset');
      final mediumPriority = ExecutionPriority.medium('Normal asset');
      final lowPriority = ExecutionPriority.low('Low priority asset');

      // Verify priority levels are distinct
      expect(highPriority.score, greaterThan(mediumPriority.score));
      expect(mediumPriority.score, greaterThan(lowPriority.score));

      // Verify string representation
      expect(highPriority.level, 'Critical');
      expect(mediumPriority.level, 'Medium');
      expect(lowPriority.level, 'Low');
    });

    test('execution decision combines match and priority', () {
      final match = TriggerMatchResult.matched(
        triggerId: 'test',
        assetId: 'asset-1',
        context: {},
        reason: 'Test',
        conditionChecks: [],
      );

      final priority = ExecutionPriority.high('High value target');

      final decision = ExecutionDecision.execute(
        match: match,
        priority: priority,
        reason: 'Should execute on high priority match',
      );

      expect(decision.shouldExecute, isTrue);
      expect(decision.match.matched, isTrue);
      expect(decision.priority.score, greaterThanOrEqualTo(60));
      expect(decision.alreadyExecuted, isFalse);
    });

    test('execution can be skipped even if match succeeds', () {
      final match = TriggerMatchResult.matched(
        triggerId: 'test',
        assetId: 'asset-1',
        context: {},
        reason: 'Matched',
        conditionChecks: [],
      );

      final priority = ExecutionPriority.low('Low priority');

      final decision = ExecutionDecision.skip(
        match: match,
        priority: priority,
        reason: 'Already executed recently',
        alreadyExecuted: true,
      );

      expect(decision.match.matched, isTrue); // Still matched
      expect(decision.shouldExecute, isFalse); // But should not execute
      expect(decision.alreadyExecuted, isTrue);
    });

    test('execution history tracks success and failure', () {
      history.recordSuccess(
        triggerId: 'trigger-1',
        assetId: 'asset-1',
        deduplicationKey: 'dedup-1',
        executionTime: const Duration(seconds: 5),
      );

      history.recordFailure(
        triggerId: 'trigger-1',
        assetId: 'asset-2',
        deduplicationKey: 'dedup-2',
        errorMessage: 'Test failure',
        executionTime: const Duration(seconds: 3),
      );

      final stats = history.getStats('trigger-1');

      expect(stats.totalExecutions, 2);
      expect(stats.successCount, 1);
      expect(stats.failureCount, 1);
      expect(stats.successRate, 0.5);
    });

    test('deduplication prevents redundant executions', () {
      final deduplicationKey = 'trigger-1:asset-1:prop1:value1';

      // First execution
      expect(history.wasExecuted(deduplicationKey), isFalse);

      history.recordSuccess(
        triggerId: 'trigger-1',
        assetId: 'asset-1',
        deduplicationKey: deduplicationKey,
        executionTime: const Duration(seconds: 2),
      );

      // Second attempt should be detected
      expect(history.wasExecuted(deduplicationKey), isTrue);

      final lastExecution = history.getLastExecution(deduplicationKey);
      expect(lastExecution, isNotNull);
      expect(lastExecution!.success, isTrue);
    });

    test('execution decision handles cooldown', () {
      final match = TriggerMatchResult.matched(
        triggerId: 'test',
        assetId: 'asset-1',
        context: {},
        reason: 'Matched',
        conditionChecks: [],
      );

      final decision = ExecutionDecision.skip(
        match: match,
        priority: ExecutionPriority.medium('Test'),
        reason: 'Cooldown active',
        cooldownRemaining: const Duration(minutes: 5),
      );

      expect(decision.shouldExecute, isFalse);
      expect(decision.cooldownRemaining, isNotNull);
      expect(decision.cooldownRemaining!.inMinutes, 5);
    });

    test('priority factors contribute to score', () {
      final factors = [
        PriorityFactors.assetType('domain_controller', 30),
        PriorityFactors.compromised(20),
        PriorityFactors.highValue('Critical infrastructure', 25),
      ];

      final priority = ExecutionPriority.withScore(
        score: 75,
        reason: 'Multiple high-priority factors',
        factors: factors,
      );

      expect(priority.score, 75);
      expect(priority.factors.length, 3);
      expect(priority.level, 'High');
    });

    test('no match creates skip decision', () {
      final noMatch = TriggerMatchResult.notMatched(
        triggerId: 'test',
        assetId: 'asset-1',
        reason: 'Conditions not met',
        conditionChecks: [],
      );

      final decision = ExecutionDecision.noMatch(
        match: noMatch,
        reason: 'Asset does not meet trigger conditions',
      );

      expect(decision.match.matched, isFalse);
      expect(decision.shouldExecute, isFalse);
      expect(decision.priority.level, 'Low');
    });

    test('condition checks are tracked', () {
      final conditionChecks = [
        ConditionCheckResult(
          property: 'nac_enabled',
          operator: '==',
          expectedValue: true,
          actualValue: true,
          passed: true,
          description: 'NAC is enabled',
        ),
        ConditionCheckResult(
          property: 'credentials_available',
          operator: 'exists',
          expectedValue: null,
          actualValue: ['user1', 'user2'],
          passed: true,
          description: 'Credentials are available',
        ),
      ];

      final match = TriggerMatchResult.matched(
        triggerId: 'nac-bypass',
        assetId: 'network-1',
        context: {'credentials': ['user1', 'user2']},
        reason: 'NAC bypass conditions met',
        conditionChecks: conditionChecks,
      );

      expect(match.conditionChecks.length, 2);
      expect(match.conditionChecks.every((c) => c.passed), isTrue);
      expect(match.context.containsKey('credentials'), isTrue);
    });

    test('priority comparison works correctly', () {
      final critical = ExecutionPriority.critical('Test');
      final high = ExecutionPriority.high('Test');
      final medium = ExecutionPriority.medium('Test');
      final low = ExecutionPriority.low('Test');

      expect(critical.isHigherThan(high), isTrue);
      expect(high.isHigherThan(medium), isTrue);
      expect(medium.isHigherThan(low), isTrue);

      expect(low.isLowerThan(medium), isTrue);
      expect(medium.isLowerThan(high), isTrue);
      expect(high.isLowerThan(critical), isTrue);
    });
  });

  group('Execution History Statistics', () {
    late ExecutionHistory history;

    setUp(() {
      history = ExecutionHistory();
    });

    test('success rate calculation', () {
      // Record 3 successes and 1 failure
      for (int i = 0; i < 3; i++) {
        history.recordSuccess(
          triggerId: 'trigger-1',
          assetId: 'asset-$i',
          deduplicationKey: 'dedup-$i',
          executionTime: Duration(seconds: i + 1),
        );
      }

      history.recordFailure(
        triggerId: 'trigger-1',
        assetId: 'asset-4',
        deduplicationKey: 'dedup-4',
        errorMessage: 'Test error',
      );

      final successRate = history.getSuccessRate('trigger-1');
      expect(successRate, 0.75); // 3 out of 4
    });

    test('average execution time', () {
      history.recordSuccess(
        triggerId: 'trigger-1',
        assetId: 'asset-1',
        deduplicationKey: 'dedup-1',
        executionTime: const Duration(seconds: 2),
      );

      history.recordSuccess(
        triggerId: 'trigger-1',
        assetId: 'asset-2',
        deduplicationKey: 'dedup-2',
        executionTime: const Duration(seconds: 4),
      );

      final stats = history.getStats('trigger-1');
      expect(stats.averageExecutionTime.inSeconds, 3); // (2+4)/2 = 3
    });

    test('empty history returns zero stats', () {
      final stats = history.getStats('non-existent');

      expect(stats.totalExecutions, 0);
      expect(stats.successCount, 0);
      expect(stats.failureCount, 0);
      expect(stats.successRate, 0.0);
      expect(stats.averageExecutionTime, Duration.zero);
    });
  });
}
