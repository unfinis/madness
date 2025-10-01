import 'package:flutter/material.dart';

/// Toast notifications for trigger system events
class TriggerNotifications {
  /// Show notification that execution has started
  static void showExecutionStarted(BuildContext context, String methodologyName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text('Executing $methodologyName...'),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue,
      ),
    );
  }

  /// Show notification that execution completed
  static void showExecutionComplete(
    BuildContext context, {
    required bool success,
    String? methodologyName,
    String? message,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: Colors.white,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                message ??
                    (success
                        ? 'Execution completed${methodologyName != null ? ': $methodologyName' : ''}'
                        : 'Execution failed${methodologyName != null ? ': $methodologyName' : ''}'),
              ),
            ),
          ],
        ),
        backgroundColor: success ? Colors.green : Colors.red,
        duration: Duration(seconds: success ? 3 : 5),
        action: success
            ? null
            : SnackBarAction(
                label: 'Details',
                textColor: Colors.white,
                onPressed: () {},
              ),
      ),
    );
  }

  /// Show notification that trigger matched
  static void showTriggerMatched(
    BuildContext context,
    String triggerName, {
    int? matchCount,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                matchCount != null
                    ? '$triggerName matched ($matchCount assets)'
                    : '$triggerName matched',
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Show notification about trigger evaluation
  static void showEvaluationSummary(
    BuildContext context, {
    required int totalTriggers,
    required int matchedTriggers,
    required int decisionsToExecute,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trigger Evaluation Complete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('$matchedTriggers/$totalTriggers triggers matched'),
            Text('$decisionsToExecute actions ready to execute'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show warning notification
  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Show error notification
  static void showError(BuildContext context, String message, {String? details}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 16),
                Expanded(child: Text(message)),
              ],
            ),
            if (details != null) ...[
              const SizedBox(height: 4),
              Text(
                details,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}
