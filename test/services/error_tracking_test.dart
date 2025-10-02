import 'package:flutter_test/flutter_test.dart';
import 'package:madness/services/error_tracking_service.dart';
import 'package:madness/models/error_report.dart';

void main() {
  group('ErrorTrackingService', () {
    late ErrorTrackingService errorTracker;

    setUp(() {
      errorTracker = ErrorTrackingService();
      errorTracker.clearErrors(); // Start with clean slate
    });

    tearDown(() {
      errorTracker.clearErrors();
    });

    test('tracks errors correctly', () {
      // Track an error
      errorTracker.trackError(
        'test_context',
        'Test error message',
        StackTrace.current,
        additionalData: {'key': 'value'},
      );

      // Verify error was tracked
      expect(errorTracker.errorCount, 1);

      final errors = errorTracker.getRecentErrors();
      expect(errors.length, 1);
      expect(errors.first.context, 'test_context');
      expect(errors.first.error, 'Test error message');
      expect(errors.first.additionalData['key'], 'value');
    });

    test('error stream emits events', () async {
      final errorsFuture = errorTracker.errorStream.first;

      errorTracker.trackError(
        'stream_test',
        'Stream error',
        null,
      );

      final error = await errorsFuture;
      expect(error.context, 'stream_test');
      expect(error.error, 'Stream error');
    });

    test('filters errors by time window', () {
      // Track error
      errorTracker.trackError('old_context', 'Old error', null);

      // Get errors within 1 hour
      final recentErrors = errorTracker.getRecentErrors(const Duration(hours: 1));
      expect(recentErrors.length, 1);

      // Get errors within 0 milliseconds (should be empty)
      final veryRecentErrors = errorTracker.getRecentErrors(const Duration(milliseconds: 0));
      expect(veryRecentErrors.length, 0);
    });

    test('filters errors by context', () {
      errorTracker.trackError('context_a', 'Error A', null);
      errorTracker.trackError('context_b', 'Error B', null);
      errorTracker.trackError('context_a', 'Error A2', null);

      final contextAErrors = errorTracker.getErrorsByContext('context_a');
      expect(contextAErrors.length, 2);
      expect(contextAErrors.every((e) => e.context == 'context_a'), true);

      final contextBErrors = errorTracker.getErrorsByContext('context_b');
      expect(contextBErrors.length, 1);
    });

    test('returns error counts by context', () {
      errorTracker.trackError('context_a', 'Error 1', null);
      errorTracker.trackError('context_a', 'Error 2', null);
      errorTracker.trackError('context_b', 'Error 3', null);

      final counts = errorTracker.getErrorCountsByContext();
      expect(counts['context_a'], 2);
      expect(counts['context_b'], 1);
    });

    test('returns most common errors', () {
      errorTracker.trackError('context_a', 'Error 1', null);
      errorTracker.trackError('context_a', 'Error 2', null);
      errorTracker.trackError('context_a', 'Error 3', null);
      errorTracker.trackError('context_b', 'Error 4', null);
      errorTracker.trackError('context_c', 'Error 5', null);
      errorTracker.trackError('context_c', 'Error 6', null);

      final mostCommon = errorTracker.getMostCommonErrors(limit: 2);
      expect(mostCommon.length, 2);
      expect(mostCommon.first.key, 'context_a'); // 3 errors
      expect(mostCommon.first.value, 3);
      expect(mostCommon[1].key, 'context_c'); // 2 errors
      expect(mostCommon[1].value, 2);
    });

    test('clears errors correctly', () {
      errorTracker.trackError('context_a', 'Error 1', null);
      errorTracker.trackError('context_b', 'Error 2', null);

      expect(errorTracker.errorCount, 2);

      errorTracker.clearErrors();
      expect(errorTracker.errorCount, 0);
    });

    test('clears errors by context', () {
      errorTracker.trackError('context_a', 'Error 1', null);
      errorTracker.trackError('context_b', 'Error 2', null);

      errorTracker.clearErrorsByContext('context_a');

      expect(errorTracker.errorCount, 1);
      expect(errorTracker.getErrorsByContext('context_a').length, 0);
      expect(errorTracker.getErrorsByContext('context_b').length, 1);
    });

    test('tracks exceptions correctly', () {
      try {
        throw Exception('Test exception');
      } catch (e, stack) {
        errorTracker.trackException(
          'exception_test',
          e,
          stack,
          additionalData: {'test': true},
        );
      }

      expect(errorTracker.errorCount, 1);
      final error = errorTracker.getRecentErrors().first;
      expect(error.context, 'exception_test');
      expect(error.error.contains('Test exception'), true);
      expect(error.stackTrace, isNotNull);
    });

    test('gets last error for context', () {
      errorTracker.trackError('context_a', 'Error 1', null);
      errorTracker.trackError('context_a', 'Error 2', null);

      final lastError = errorTracker.getLastError('context_a');
      expect(lastError, isNotNull);
      expect(lastError!.error, 'Error 2');
    });

    test('checks if context has errors', () {
      errorTracker.trackError('context_a', 'Error 1', null);

      expect(errorTracker.hasErrors('context_a'), true);
      expect(errorTracker.hasErrors('context_b'), false);
    });

    test('exports errors as JSON', () {
      errorTracker.trackError('context_a', 'Error 1', null,
        additionalData: {'key': 'value'});

      final exported = errorTracker.exportErrors();
      expect(exported.length, 1);
      expect(exported.first['context'], 'context_a');
      expect(exported.first['error'], 'Error 1');
      expect(exported.first['additionalData']['key'], 'value');
    });

    test('limits error history', () {
      // Track more than max errors (1000)
      for (int i = 0; i < 1100; i++) {
        errorTracker.trackError('test', 'Error $i', null);
      }

      // Should only keep last 1000
      expect(errorTracker.errorCount, 1000);
    });

    test('gets unique error contexts', () {
      errorTracker.trackError('context_a', 'Error 1', null);
      errorTracker.trackError('context_a', 'Error 2', null);
      errorTracker.trackError('context_b', 'Error 3', null);

      final contexts = errorTracker.getErrorContexts();
      expect(contexts.length, 2);
      expect(contexts.contains('context_a'), true);
      expect(contexts.contains('context_b'), true);
    });
  });
}
