import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskItemWidget extends ConsumerWidget {
  final Task task;

  const TaskItemWidget({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOverdue = task.isOverdue;
    final isDueSoon = task.isDueSoon;
    final isCompleted = task.status == TaskStatus.completed;

    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isOverdue
                ? Theme.of(context).colorScheme.error.withValues(alpha: 0.5)
                : isDueSoon
                    ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5)
                    : Colors.transparent,
            width: isOverdue || isDueSoon ? 2 : 0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                            color: isCompleted ? Theme.of(context).colorScheme.outline : null,
                          ),
                        ),
                        if (task.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description!,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                              decoration: isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (task.status != TaskStatus.completed)
                    IconButton(
                      onPressed: () => _markTaskCompleted(ref, task.id),
                      icon: const Icon(Icons.check_circle_outline),
                      tooltip: 'Mark as completed',
                      style: IconButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    )
                  else
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip(
                    context,
                    '${task.category.icon} ${task.category.displayName}',
                    Theme.of(context).colorScheme.secondary,
                  ),
                  _buildStatusChip(context, task.status),
                  _buildPriorityChip(context, task.priority),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.assignedTo != null) ...[
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.assignedTo!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                        ],
                        if (task.dueDate != null) ...[
                          Row(
                            children: [
                              Icon(
                                isOverdue ? Icons.error_outline : Icons.schedule,
                                size: 16,
                                color: isOverdue
                                    ? Theme.of(context).colorScheme.error
                                    : isDueSoon
                                        ? Theme.of(context).colorScheme.tertiary
                                        : Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('dd/MM/yyyy').format(task.dueDate!),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isOverdue
                                      ? Theme.of(context).colorScheme.error
                                      : isDueSoon
                                          ? Theme.of(context).colorScheme.tertiary
                                          : Theme.of(context).colorScheme.outline,
                                  fontWeight: (isOverdue || isDueSoon) ? FontWeight.w500 : null,
                                ),
                              ),
                              if (isOverdue) ...[
                                const SizedBox(width: 4),
                                Text(
                                  'Overdue',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ] else if (isDueSoon) ...[
                                const SizedBox(width: 4),
                                Text(
                                  'Due Soon',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildProgressSection(context, task),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, TaskStatus status) {
    Color color;
    switch (status) {
      case TaskStatus.completed:
        color = Colors.green;
        break;
      case TaskStatus.urgent:
        color = Theme.of(context).colorScheme.error;
        break;
      case TaskStatus.inProgress:
        color = Theme.of(context).colorScheme.tertiary;
        break;
      case TaskStatus.pending:
        color = Theme.of(context).colorScheme.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(BuildContext context, TaskPriority priority) {
    Color color;
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        break;
      case TaskPriority.low:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(priority.icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(BuildContext context, Task task) {
    if (task.status == TaskStatus.completed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(height: 2),
          Text(
            '100%',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: task.progress / 100,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              task.progress > 80
                  ? Colors.green
                  : task.progress > 50
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${task.progress}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _markTaskCompleted(WidgetRef ref, String taskId) {
    // TODO: Fix provider family access
    // ref.read(taskProvider(projectId).notifier).markTaskCompleted(taskId);
    ScaffoldMessenger.of(ref.context).showSnackBar(
      const SnackBar(content: Text('Task completion functionality is temporarily disabled')),
    );
  }
}