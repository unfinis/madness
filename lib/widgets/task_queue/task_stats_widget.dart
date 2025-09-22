import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/task_queue_provider.dart';
import '../../constants/app_spacing.dart';

class TaskStatsWidget extends ConsumerWidget {
  const TaskStatsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskQueueState = ref.watch(taskQueueProvider);
    final pendingTasks = ref.watch(pendingTasksProvider);
    final activeTasks = ref.watch(activeTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);

    final totalTasks = taskQueueState.tasks.length;
    final totalTriggers = taskQueueState.tasks.fold<int>(
      0,
      (sum, task) => sum + task.triggers.length,
    );
    final completedTriggers = taskQueueState.tasks.fold<int>(
      0,
      (sum, task) => sum + task.completedCount,
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Theme.of(context).cardColor,
      child: Row(
        children: [
          _buildStatCard(
            context,
            'Total Tasks',
            totalTasks.toString(),
            Icons.list_alt,
            Colors.blue,
          ),
          const SizedBox(width: AppSpacing.md),
          _buildStatCard(
            context,
            'Pending',
            pendingTasks.length.toString(),
            Icons.pending_actions,
            Colors.orange,
          ),
          const SizedBox(width: AppSpacing.md),
          _buildStatCard(
            context,
            'Active',
            activeTasks.length.toString(),
            Icons.play_circle,
            Colors.blue,
          ),
          const SizedBox(width: AppSpacing.md),
          _buildStatCard(
            context,
            'Completed',
            completedTasks.length.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          const SizedBox(width: AppSpacing.md),
          _buildProgressCard(
            context,
            'Progress',
            totalTriggers > 0 ? (completedTriggers / totalTriggers) : 0.0,
            '$completedTriggers / $totalTriggers triggers',
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context,
    String label,
    double progress,
    String subtitle,
  ) {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, color: Colors.grey, size: 20),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      progress == 1.0 ? Colors.green : Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}