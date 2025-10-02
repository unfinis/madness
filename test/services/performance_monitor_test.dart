import 'package:flutter_test/flutter_test.dart';
import 'package:madness/services/performance_monitor.dart';
import 'package:madness/models/performance_metrics.dart';

void main() {
  group('PerformanceMonitor', () {
    setUp(() {
      PerformanceMonitor.clearMetrics(); // Start with clean slate
    });

    tearDown(() {
      PerformanceMonitor.clearMetrics();
    });

    test('times operations correctly', () async {
      PerformanceMonitor.startTimer('test_operation');

      // Simulate work
      await Future.delayed(const Duration(milliseconds: 100));

      final duration = PerformanceMonitor.endTimer('test_operation');

      expect(duration, isNotNull);
      expect(duration!.inMilliseconds, greaterThanOrEqualTo(100));
    });

    test('returns null for non-existent timer', () {
      final duration = PerformanceMonitor.endTimer('non_existent');
      expect(duration, isNull);
    });

    test('records metrics stream', () async {
      final metricsFuture = PerformanceMonitor.metricsStream.first;

      PerformanceMonitor.startTimer('stream_test');
      await Future.delayed(const Duration(milliseconds: 50));
      PerformanceMonitor.endTimer('stream_test');

      final metric = await metricsFuture;
      expect(metric.operation, 'stream_test');
      expect(metric.duration.inMilliseconds, greaterThanOrEqualTo(50));
    });

    test('stores metadata with metrics', () async {
      PerformanceMonitor.startTimer('meta_test',
        metadata: {'userId': '123'});

      await Future.delayed(const Duration(milliseconds: 10));

      PerformanceMonitor.endTimer('meta_test',
        metadata: {'result': 'success'});

      final metrics = PerformanceMonitor.getMetrics('meta_test');
      expect(metrics.length, 1);
      expect(metrics.first.metadata['result'], 'success');
    });

    test('calculates average time correctly', () async {
      // Record multiple operations
      for (int i = 0; i < 3; i++) {
        PerformanceMonitor.startTimer('avg_test');
        await Future.delayed(const Duration(milliseconds: 100));
        PerformanceMonitor.endTimer('avg_test');
      }

      final avgTime = PerformanceMonitor.getAverageTime('avg_test');
      expect(avgTime, greaterThanOrEqualTo(100));
      expect(avgTime, lessThan(150)); // Allow some variance
    });

    test('filters metrics by time window', () async {
      PerformanceMonitor.startTimer('old_op');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('old_op');

      // Get metrics within 1 hour
      final recentMetrics = PerformanceMonitor.getMetrics('old_op', const Duration(hours: 1));
      expect(recentMetrics.length, 1);

      // Get metrics within 0 milliseconds (should be empty)
      final veryRecentMetrics = PerformanceMonitor.getMetrics('old_op', const Duration(milliseconds: 0));
      expect(veryRecentMetrics.length, 0);
    });

    test('gets min and max times', () async {
      // Record operations with different durations
      PerformanceMonitor.startTimer('minmax_test');
      await Future.delayed(const Duration(milliseconds: 50));
      PerformanceMonitor.endTimer('minmax_test');

      PerformanceMonitor.startTimer('minmax_test');
      await Future.delayed(const Duration(milliseconds: 150));
      PerformanceMonitor.endTimer('minmax_test');

      PerformanceMonitor.startTimer('minmax_test');
      await Future.delayed(const Duration(milliseconds: 100));
      PerformanceMonitor.endTimer('minmax_test');

      final minTime = PerformanceMonitor.getMinTime('minmax_test');
      final maxTime = PerformanceMonitor.getMaxTime('minmax_test');

      expect(minTime, isNotNull);
      expect(maxTime, isNotNull);
      expect(minTime!.inMilliseconds, lessThan(maxTime!.inMilliseconds));
    });

    test('gets statistics for operation', () async {
      // Record multiple operations
      for (int i = 0; i < 5; i++) {
        PerformanceMonitor.startTimer('stats_test');
        await Future.delayed(Duration(milliseconds: 50 + (i * 10)));
        PerformanceMonitor.endTimer('stats_test');
      }

      final stats = PerformanceMonitor.getStats('stats_test');
      expect(stats.count, 5);
      expect(stats.min.inMilliseconds, greaterThanOrEqualTo(50));
      expect(stats.max.inMilliseconds, greaterThanOrEqualTo(90));
      expect(stats.average.inMilliseconds, greaterThan(0));
    });

    test('identifies slow operations', () async {
      // Fast operation
      PerformanceMonitor.startTimer('fast_op');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('fast_op');

      // Slow operation
      PerformanceMonitor.startTimer('slow_op');
      await Future.delayed(const Duration(milliseconds: 600));
      PerformanceMonitor.endTimer('slow_op');

      final slowOps = PerformanceMonitor.getSlowOperations(
        threshold: const Duration(milliseconds: 500),
      );

      expect(slowOps.length, 1);
      expect(slowOps.first.key, 'slow_op');
    });

    test('gets slow metrics', () async {
      // Fast operation
      PerformanceMonitor.startTimer('fast');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('fast');

      // Slow operation
      PerformanceMonitor.startTimer('slow');
      await Future.delayed(const Duration(milliseconds: 1100));
      PerformanceMonitor.endTimer('slow');

      final slowMetrics = PerformanceMonitor.getSlowMetrics(
        threshold: const Duration(seconds: 1),
      );

      expect(slowMetrics.length, 1);
      expect(slowMetrics.first.operation, 'slow');
    });

    test('clears metrics correctly', () async {
      PerformanceMonitor.startTimer('clear_test');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('clear_test');

      expect(PerformanceMonitor.totalMetrics, 1);

      PerformanceMonitor.clearMetrics();
      expect(PerformanceMonitor.totalMetrics, 0);
    });

    test('clears metrics for specific operation', () async {
      PerformanceMonitor.startTimer('op_a');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('op_a');

      PerformanceMonitor.startTimer('op_b');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('op_b');

      expect(PerformanceMonitor.totalMetrics, 2);

      PerformanceMonitor.clearOperationMetrics('op_a');

      expect(PerformanceMonitor.totalMetrics, 1);
      expect(PerformanceMonitor.getMetrics('op_a').length, 0);
      expect(PerformanceMonitor.getMetrics('op_b').length, 1);
    });

    test('gets operation names', () async {
      PerformanceMonitor.startTimer('op1');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('op1');

      PerformanceMonitor.startTimer('op2');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('op2');

      final names = PerformanceMonitor.getOperationNames();
      expect(names.length, 2);
      expect(names.contains('op1'), true);
      expect(names.contains('op2'), true);
    });

    test('gets call count for operation', () async {
      for (int i = 0; i < 3; i++) {
        PerformanceMonitor.startTimer('count_test');
        await Future.delayed(const Duration(milliseconds: 10));
        PerformanceMonitor.endTimer('count_test');
      }

      final count = PerformanceMonitor.getCallCount('count_test');
      expect(count, 3);
    });

    test('gets all stats', () async {
      PerformanceMonitor.startTimer('op1');
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('op1');

      PerformanceMonitor.startTimer('op2');
      await Future.delayed(const Duration(milliseconds: 20));
      PerformanceMonitor.endTimer('op2');

      final allStats = PerformanceMonitor.getAllStats();
      expect(allStats.length, 2);
      expect(allStats.containsKey('op1'), true);
      expect(allStats.containsKey('op2'), true);
    });

    test('exports metrics as JSON', () async {
      PerformanceMonitor.startTimer('export_test',
        metadata: {'key': 'value'});
      await Future.delayed(const Duration(milliseconds: 10));
      PerformanceMonitor.endTimer('export_test');

      final exported = PerformanceMonitor.exportMetrics();
      expect(exported.length, 1);
      expect(exported.first['operation'], 'export_test');
      expect(exported.first['durationMs'], greaterThanOrEqualTo(10));
      expect(exported.first['metadata']['key'], 'value');
    });

    test('timeAsync convenience method works', () async {
      final result = await PerformanceMonitor.timeAsync(
        'async_test',
        () async {
          await Future.delayed(const Duration(milliseconds: 50));
          return 'success';
        },
      );

      expect(result, 'success');

      final metrics = PerformanceMonitor.getMetrics('async_test');
      expect(metrics.length, 1);
      expect(metrics.first.duration.inMilliseconds, greaterThanOrEqualTo(50));
    });

    test('timeAsync tracks errors', () async {
      try {
        await PerformanceMonitor.timeAsync(
          'error_test',
          () async {
            throw Exception('Test error');
          },
        );
        fail('Should have thrown exception');
      } catch (e) {
        // Expected
      }

      final metrics = PerformanceMonitor.getMetrics('error_test');
      expect(metrics.length, 1);
      expect(metrics.first.metadata['error'], true);
    });

    test('timeSync convenience method works', () {
      final result = PerformanceMonitor.timeSync(
        'sync_test',
        () {
          return 42;
        },
      );

      expect(result, 42);

      final metrics = PerformanceMonitor.getMetrics('sync_test');
      expect(metrics.length, 1);
    });

    test('limits metrics history', () async {
      // Record more than max metrics (10000)
      for (int i = 0; i < 10100; i++) {
        PerformanceMonitor.startTimer('limit_test');
        PerformanceMonitor.endTimer('limit_test', logResult: true);
      }

      // Should only keep last 10000
      expect(PerformanceMonitor.totalMetrics, 10000);
    });
  });

  group('PerformanceStats', () {
    test('calculates statistics from metrics', () {
      final metrics = [
        PerformanceMetric(
          operation: 'test',
          duration: const Duration(milliseconds: 50),
          timestamp: DateTime.now(),
        ),
        PerformanceMetric(
          operation: 'test',
          duration: const Duration(milliseconds: 100),
          timestamp: DateTime.now(),
        ),
        PerformanceMetric(
          operation: 'test',
          duration: const Duration(milliseconds: 150),
          timestamp: DateTime.now(),
        ),
      ];

      final stats = PerformanceStats.fromMetrics('test', metrics);

      expect(stats.count, 3);
      expect(stats.min.inMilliseconds, 50);
      expect(stats.max.inMilliseconds, 150);
      expect(stats.average.inMilliseconds, 100);
      expect(stats.median.inMilliseconds, 100);
    });

    test('handles empty metrics', () {
      final stats = PerformanceStats.fromMetrics('test', []);

      expect(stats.count, 0);
      expect(stats.min, Duration.zero);
      expect(stats.max, Duration.zero);
      expect(stats.average, Duration.zero);
    });
  });
}
