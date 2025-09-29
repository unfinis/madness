import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_queue_provider.dart';
import '../../dialogs/task_execution_dialog.dart';
import '../../constants/app_spacing.dart';
import '../common/trigger_widgets.dart';
import '../common/task_widgets.dart';
import '../../theme/app_decorations.dart';

class TaskCardWidget extends ConsumerWidget {
  final TaskInstance task;

  const TaskCardWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: AppSpacing.sm),
            _buildProgress(context),
            const SizedBox(height: AppSpacing.sm),
            _buildTriggersList(context),
            const SizedBox(height: AppSpacing.sm),
            _buildActions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _buildStatusIcon(),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.methodologyName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Created ${_formatDate(task.createdDate)}',
                style: AppTextStyles.muted(),
              ),
            ],
          ),
        ),
        TaskQueueStatusChip(status: task.status),
      ],
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (task.status) {
      case TaskStatus.pending:
        icon = Icons.pending_actions;
        color = Colors.orange;
        break;
      case TaskStatus.inProgress:
        icon = Icons.play_circle;
        color = Colors.blue;
        break;
      case TaskStatus.completed:
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case TaskStatus.failed:
        icon = Icons.error;
        color = Colors.red;
        break;
      case TaskStatus.cancelled:
        icon = Icons.cancel;
        color = Colors.grey;
        break;
    }

    return Icon(icon, color: color);
  }

  Widget _buildProgress(BuildContext context) {
    final total = task.triggers.length;
    final completed = task.completedCount;
    final progress = total > 0 ? completed / total : 0.0;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: AppTextStyles.emphasized(),
            ),
            Text(
              '$completed / $total',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        TaskLinearProgress(
          progress: progress,
          showPercentage: false,
        ),
      ],
    );
  }

  Widget _buildTriggersList(BuildContext context) {
    if (task.triggers.isEmpty) {
      return const Text('No triggers');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Triggers (${task.triggers.length})',
          style: AppTextStyles.emphasized(),
        ),
        const SizedBox(height: AppSpacing.xs),
        ...task.triggers.take(3).map((trigger) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                TriggerStatusIcon(status: trigger.status),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    TriggerDisplayUtils.getText(trigger),
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }),
        if (task.triggers.length > 3)
          Text(
            '... and ${task.triggers.length - 3} more',
            style: AppTextStyles.muted(fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (task.status == TaskStatus.completed && task.completedDate != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: AppDecorations.success(),
            child: Text(
              'Completed ${_formatDate(task.completedDate!)}',
              style: AppTextStyles.success,
            ),
          )
        else
          const Spacer(),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showTaskDetails(context),
          tooltip: 'View Details',
        ),
        if (task.status != TaskStatus.completed) ...[
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _executeTask(context, ref),
            tooltip: 'Execute',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _removeTask(context, ref),
            tooltip: 'Remove',
          ),
        ],
      ],
    );
  }

  void _showTaskDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.methodologyName),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Task ID: ${task.id}'),
              Text('Methodology ID: ${task.methodologyId}'),
              Text('Status: ${task.status.name}'),
              Text('Created: ${_formatDateTime(task.createdDate)}'),
              if (task.completedDate != null)
                Text('Completed: ${_formatDateTime(task.completedDate!)}'),
              const SizedBox(height: AppSpacing.md),
              Text('Triggers:', style: AppTextStyles.emphasized()),
              const SizedBox(height: AppSpacing.sm),
              ...task.triggers.map((trigger) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TriggerStatusIcon(status: trigger.status),
                          const SizedBox(width: AppSpacing.xs),
                          Text(TriggerDisplayUtils.getText(trigger)),
                        ],
                      ),
                      Text('Status: ${TriggerDisplayUtils.getStatusText(trigger.status)}'),
                      if (trigger.output != null) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text('Output:', style: AppTextStyles.emphasized()),
                        Text(trigger.output!, style: AppTextStyles.code()),
                      ],
                    ],
                  ),
                ),
              )),
            ],
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

  void _executeTask(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => TaskExecutionDialog(task: task),
    );
  }

  void _removeTask(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Task'),
        content: Text('Are you sure you want to remove "${task.methodologyName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(taskQueueProvider.notifier).removeTask(task.id);
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}