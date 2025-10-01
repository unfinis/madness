import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/trigger_implementation_fix.dart';
import '../services/property_driven_engine.dart';
import '../providers/task_queue_provider.dart';
import '../widgets/trigger_system_ui/trigger_notifications.dart';

/// Widget to test the trigger system with sample data
class TriggerTestWidget extends ConsumerWidget {
  const TriggerTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.science, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Trigger System Test',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Test the methodology trigger system with sample assets and evaluate trigger matching.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _initializeTriggerSystem(context, ref),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Initialize System'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _testTriggerEvaluation(context, ref),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Evaluate Triggers'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _createTestTasks(context, ref),
                  icon: const Icon(Icons.add_task),
                  label: const Text('Create Tasks'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showTriggerDetails(context),
                  icon: const Icon(Icons.info),
                  label: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Initialize the trigger system
  void _initializeTriggerSystem(BuildContext context, WidgetRef ref) async {
    try {
      // Initialize the property driven engine
      final engine = PropertyDrivenEngine();
      await engine.initialize();

      if (context.mounted) {
        TriggerNotifications.showExecutionComplete(
          context,
          success: true,
          message: 'Trigger system initialized successfully',
        );
      }
    } catch (e) {
      if (context.mounted) {
        TriggerNotifications.showError(
          context,
          'Failed to initialize trigger system',
          details: e.toString(),
        );
      }
    }
  }

  /// Test trigger evaluation with sample data
  void _testTriggerEvaluation(BuildContext context, WidgetRef ref) {
    try {
      // Get test assets and triggers
      final testAssets = TriggerTestData.generateTestAssets();
      final triggers = SampleTriggers.getTestTriggers();

      int totalMatches = 0;
      final results = <String>[];

      // Test each trigger against the assets
      for (final trigger in triggers) {
        final matches = TriggerEvaluatorFixed.findMatchingAssets(trigger, testAssets);
        totalMatches += matches.length;

        if (matches.isNotEmpty) {
          results.add('✅ ${trigger.name}: ${matches.length} matches');
          for (final match in matches) {
            results.add('   - ${match['name']} (${match['type']})');
          }
        } else {
          results.add('⚪ ${trigger.name}: No matches');
        }
      }

      // Show evaluation summary notification
      final matchedTriggers = triggers.where((t) =>
        TriggerEvaluatorFixed.findMatchingAssets(t, testAssets).isNotEmpty
      ).length;

      TriggerNotifications.showEvaluationSummary(
        context,
        totalTriggers: triggers.length,
        matchedTriggers: matchedTriggers,
        decisionsToExecute: totalMatches,
      );

      // Show results dialog
      _showResultsDialog(context,
        'Trigger Evaluation Results',
        'Evaluated ${triggers.length} triggers against ${testAssets.length} assets.\n'
        'Matched triggers: $matchedTriggers\n'
        'Total asset matches: $totalMatches\n\n'
        '${results.join('\n')}'
      );

    } catch (e) {
      TriggerNotifications.showError(
        context,
        'Trigger evaluation failed',
        details: e.toString(),
      );
    }
  }

  /// Create test tasks from triggered methodologies
  void _createTestTasks(BuildContext context, WidgetRef ref) {
    try {
      // Get test assets and triggers
      final testAssets = TriggerTestData.generateTestAssets();
      final triggers = SampleTriggers.getTestTriggers();

      final createdTasks = <TaskInstance>[];

      // Create tasks for each trigger match
      for (final trigger in triggers) {
        final matches = TriggerEvaluatorFixed.findMatchingAssets(trigger, testAssets);

        for (final match in matches) {
          final task = QuickTaskCreator.createTaskFromTrigger(trigger, match);
          createdTasks.add(task);

          // Add to task queue
          ref.read(taskQueueProvider.notifier).addTask(task);
        }
      }

      if (createdTasks.isNotEmpty) {
        TriggerNotifications.showExecutionComplete(
          context,
          success: true,
          message: 'Created ${createdTasks.length} test tasks',
        );
      } else {
        TriggerNotifications.showWarning(
          context,
          'No tasks created - no trigger matches found',
        );
      }

    } catch (e) {
      TriggerNotifications.showError(
        context,
        'Failed to create tasks',
        details: e.toString(),
      );
    }
  }

  /// Show detailed information about the triggers
  void _showTriggerDetails(BuildContext context) {
    final triggers = SampleTriggers.getTestTriggers();
    final testAssets = TriggerTestData.generateTestAssets();

    final details = <String>[];
    details.add('Available Triggers:');

    for (final trigger in triggers) {
      details.add('\n📋 ${trigger.name}');
      details.add('   ID: ${trigger.id}');
      details.add('   Asset Type: ${trigger.assetType.name}');
      details.add('   Priority: ${trigger.priority}');
      details.add('   Batch Capable: ${trigger.batchCapable}');
      if (trigger.conditions != null) {
        details.add('   Conditions: ${trigger.conditions}');
      }
    }

    details.add('\n\nTest Assets:');
    for (final asset in testAssets) {
      details.add('\n🎯 ${asset['name']} (${asset['type']})');
      details.add('   ID: ${asset['id']}');
      // Show a few key properties
      final keys = asset.keys.where((k) => !['id', 'name', 'type'].contains(k)).take(3);
      for (final key in keys) {
        details.add('   $key: ${asset[key]}');
      }
    }

    _showResultsDialog(context, 'Trigger System Details', details.join('\n'));
  }

  /// Show a dialog with results
  void _showResultsDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              content,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}