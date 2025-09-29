import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/trigger_implementation_fix.dart';
import '../services/property_driven_engine.dart';
import '../providers/task_queue_provider.dart';

/// Widget to test the trigger system with sample data
class TriggerTestWidget extends ConsumerWidget {
  const TriggerTestWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trigger System Test',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Test the methodology trigger system with sample assets',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _initializeTriggerSystem(context, ref),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Initialize Triggers'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _testTriggerEvaluation(context, ref),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Test Evaluation'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _createTestTasks(context, ref),
                  icon: const Icon(Icons.add_task),
                  label: const Text('Create Tasks'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showTriggerDetails(context),
                  icon: const Icon(Icons.info),
                  label: const Text('Show Details'),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trigger system initialized successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error initializing triggers: $e')),
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
          results.add('❌ ${trigger.name}: No matches');
        }
      }

      // Show results dialog
      _showResultsDialog(context,
        'Trigger Evaluation Results',
        'Evaluated ${triggers.length} triggers against ${testAssets.length} assets.\n'
        'Total matches found: $totalMatches\n\n'
        '${results.join('\n')}'
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error testing triggers: $e')),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Created ${createdTasks.length} test tasks')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating tasks: $e')),
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