import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../../models/asset.dart';
import '../../models/methodology_trigger.dart' as mt;
import 'models/execution_decision.dart';
import 'execution_policy.dart';
import 'execution_history.dart';

/// Evaluates triggers in background isolate for large datasets
///
/// Handles 1000+ assets without blocking the UI thread by:
/// - Using compute() for web compatibility
/// - Using Isolate.run() for native platforms
/// - Processing in batches to track progress
class IsolateEvaluator {
  /// Threshold for using isolate processing
  static const int isolateThreshold = 100;

  /// Batch size for processing assets
  static const int batchSize = 50;

  /// Evaluate triggers in background isolate for large datasets
  static Future<List<ExecutionDecision>> evaluateLargeDataset({
    required List<Asset> assets,
    required List<mt.MethodologyTrigger> triggers,
  }) async {
    if (assets.length < isolateThreshold) {
      // For small datasets, use main thread
      return _evaluateOnMainThread(assets, triggers);
    }

    // Use compute for web compatibility, Isolate.run for native
    if (kIsWeb) {
      return compute(_evaluateInBackground, _IsolateData(assets, triggers));
    } else {
      return Isolate.run(() => _evaluateInBackground(
        _IsolateData(assets, triggers)
      ));
    }
  }

  /// Evaluate on main thread for small datasets
  static List<ExecutionDecision> _evaluateOnMainThread(
    List<Asset> assets,
    List<mt.MethodologyTrigger> triggers,
  ) {
    final history = ExecutionHistory();
    final policy = ExecutionPolicy(history: history);
    final decisions = <ExecutionDecision>[];

    for (final asset in assets) {
      for (final trigger in triggers) {
        if (!trigger.enabled) continue;

        final decision = policy.evaluate(
          trigger: trigger,
          asset: asset,
          allAssets: assets,
        );

        if (decision.shouldExecute || decision.match.matched) {
          decisions.add(decision);
        }
      }
    }

    return decisions;
  }

  /// Background evaluation function (runs in isolate)
  static List<ExecutionDecision> _evaluateInBackground(_IsolateData data) {
    final history = ExecutionHistory();
    final policy = ExecutionPolicy(history: history);
    final decisions = <ExecutionDecision>[];

    // Process in batches to track progress
    for (var i = 0; i < data.assets.length; i += batchSize) {
      final batch = data.assets.skip(i).take(batchSize);

      for (final asset in batch) {
        for (final trigger in data.triggers) {
          if (!trigger.enabled) continue;

          final decision = policy.evaluate(
            trigger: trigger,
            asset: asset,
            allAssets: data.assets,
          );

          if (decision.shouldExecute || decision.match.matched) {
            decisions.add(decision);
          }
        }
      }
    }

    return decisions;
  }

  /// Evaluate with progress reporting
  static Stream<IsolateProgress> evaluateWithProgress({
    required List<Asset> assets,
    required List<mt.MethodologyTrigger> triggers,
  }) async* {
    final history = ExecutionHistory();
    final policy = ExecutionPolicy(history: history);
    final decisions = <ExecutionDecision>[];

    final totalAssets = assets.length;
    final totalTriggers = triggers.length;
    final totalOperations = totalAssets * totalTriggers;
    var completedOperations = 0;

    // Process in batches
    for (var i = 0; i < assets.length; i += batchSize) {
      final batch = assets.skip(i).take(batchSize);

      for (final asset in batch) {
        for (final trigger in triggers) {
          if (!trigger.enabled) {
            completedOperations++;
            continue;
          }

          final decision = policy.evaluate(
            trigger: trigger,
            asset: asset,
            allAssets: assets,
          );

          if (decision.shouldExecute || decision.match.matched) {
            decisions.add(decision);
          }

          completedOperations++;

          // Yield progress every batch
          if (completedOperations % (batchSize * 5) == 0) {
            yield IsolateProgress(
              totalOperations: totalOperations,
              completedOperations: completedOperations,
              currentBatch: i ~/ batchSize,
              totalBatches: (totalAssets / batchSize).ceil(),
              decisions: List.from(decisions),
            );
          }
        }
      }
    }

    // Final progress
    yield IsolateProgress(
      totalOperations: totalOperations,
      completedOperations: completedOperations,
      currentBatch: (totalAssets / batchSize).ceil(),
      totalBatches: (totalAssets / batchSize).ceil(),
      decisions: decisions,
    );
  }

  /// Evaluate multiple trigger sets in parallel isolates
  static Future<List<ExecutionDecision>> evaluateParallel({
    required List<Asset> assets,
    required List<mt.MethodologyTrigger> triggers,
    int parallelism = 4,
  }) async {
    // Split assets into chunks
    final chunkSize = (assets.length / parallelism).ceil();
    final futures = <Future<List<ExecutionDecision>>>[];

    for (var i = 0; i < assets.length; i += chunkSize) {
      final chunk = assets.skip(i).take(chunkSize).toList();
      futures.add(evaluateLargeDataset(
        assets: chunk,
        triggers: triggers,
      ));
    }

    final results = await Future.wait(futures);
    return results.expand((d) => d).toList();
  }
}

/// Data class for isolate communication
class _IsolateData {
  final List<Asset> assets;
  final List<mt.MethodologyTrigger> triggers;

  _IsolateData(this.assets, this.triggers);
}

/// Progress information from isolate evaluation
class IsolateProgress {
  final int totalOperations;
  final int completedOperations;
  final int currentBatch;
  final int totalBatches;
  final List<ExecutionDecision> decisions;

  IsolateProgress({
    required this.totalOperations,
    required this.completedOperations,
    required this.currentBatch,
    required this.totalBatches,
    required this.decisions,
  });

  double get percentage =>
      totalOperations > 0 ? (completedOperations / totalOperations) * 100 : 0;

  bool get isComplete => completedOperations >= totalOperations;

  @override
  String toString() {
    return 'IsolateProgress(${percentage.toStringAsFixed(1)}% - '
        'Batch $currentBatch/$totalBatches - '
        '${decisions.length} decisions)';
  }
}
