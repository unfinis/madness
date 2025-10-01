import 'package:flutter/material.dart';
import '../../services/trigger_system/models/execution_decision.dart';
import 'trigger_match_indicator.dart';
import 'execution_priority_badge.dart';

/// Card displaying an execution decision with all relevant details
class ExecutionDecisionCard extends StatelessWidget {
  final ExecutionDecision decision;
  final String methodologyName;
  final VoidCallback? onExecute;
  final VoidCallback? onSkip;
  final bool showActions;

  const ExecutionDecisionCard({
    super.key,
    required this.decision,
    required this.methodologyName,
    this.onExecute,
    this.onSkip,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with methodology name
            Row(
              children: [
                Expanded(
                  child: Text(
                    methodologyName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ExecutionPriorityBadge(priority: decision.priority),
              ],
            ),
            const SizedBox(height: 12),

            // Match status and decision
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TriggerMatchIndicator(match: decision.match),
                _buildDecisionIndicator(context),
              ],
            ),

            const SizedBox(height: 12),

            // Decision details
            _buildDetailRow('Reason', decision.reason),

            if (decision.deduplicationKey != null)
              _buildDetailRow('Deduplication Key', decision.deduplicationKey!, mono: true),

            if (decision.alreadyExecuted) _buildWarningRow('Already executed', Icons.history),

            if (decision.cooldownRemaining != null)
              _buildWarningRow(
                'Cooldown: ${_formatDuration(decision.cooldownRemaining!)}',
                Icons.timer,
              ),

            // Context preview
            if (decision.match.context.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildContextPreview(context),
            ],

            // Action buttons
            if (showActions && decision.shouldExecute) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (onSkip != null)
                    OutlinedButton(
                      onPressed: onSkip,
                      child: const Text('Skip'),
                    ),
                  const SizedBox(width: 8),
                  if (onExecute != null)
                    ElevatedButton.icon(
                      onPressed: onExecute,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Execute'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionIndicator(BuildContext context) {
    final color = decision.shouldExecute ? Colors.green : Colors.orange;
    final icon = decision.shouldExecute ? Icons.check_circle : Icons.block;
    final label = decision.shouldExecute ? 'Execute' : 'Skip';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, {bool mono = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontFamily: mono ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningRow(String message, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.orange),
          const SizedBox(width: 8),
          Text(
            message,
            style: TextStyle(
              color: Colors.orange[700],
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContextPreview(BuildContext context) {
    final entries = decision.match.context.entries.take(3).toList();
    return ExpansionTile(
      title: const Text(
        'Execution Context',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: entries
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        '${e.key}: ${e.value}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
