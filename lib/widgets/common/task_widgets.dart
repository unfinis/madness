import 'package:flutter/material.dart';
import '../../providers/task_queue_provider.dart' as tq;
import '../../models/task.dart';

/// Reusable task progress indicator widget
class TaskProgressIndicator extends StatelessWidget {
  final double progress;
  final bool showPercentage;
  final double size;
  final double strokeWidth;

  const TaskProgressIndicator({
    super.key,
    required this.progress,
    this.showPercentage = false,
    this.size = 40,
    this.strokeWidth = 3,
  });

  Color get progressColor {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: strokeWidth,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
          if (showPercentage)
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
        ],
      ),
    );
  }
}

/// Linear progress bar variant
class TaskLinearProgress extends StatelessWidget {
  final double progress;
  final bool showPercentage;
  final double height;

  const TaskLinearProgress({
    super.key,
    required this.progress,
    this.showPercentage = false,
    this.height = 8,
  });

  Color get progressColor {
    if (progress >= 0.8) return Colors.green;
    if (progress >= 0.5) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}

/// Task status chip widget for queue
class TaskQueueStatusChip extends StatelessWidget {
  final tq.TaskStatus status;
  final bool compact;

  const TaskQueueStatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = _getStatusData(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: color),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  (Color, IconData, String) _getStatusData(tq.TaskStatus status) {
    return switch (status) {
      tq.TaskStatus.pending => (Colors.grey, Icons.hourglass_empty, 'Pending'),
      tq.TaskStatus.inProgress => (Colors.orange, Icons.play_circle, 'In Progress'),
      tq.TaskStatus.completed => (Colors.green, Icons.check_circle, 'Completed'),
      tq.TaskStatus.failed => (Colors.red, Icons.error, 'Failed'),
      tq.TaskStatus.cancelled => (Colors.grey[600]!, Icons.cancel, 'Cancelled'),
    };
  }
}

/// Task status chip widget for regular tasks
class TaskStatusChip extends StatelessWidget {
  final TaskStatus status;
  final bool compact;

  const TaskStatusChip({
    super.key,
    required this.status,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, icon, label) = _getStatusData(status);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: color),
          if (!compact) ...[
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  (Color, IconData, String) _getStatusData(TaskStatus status) {
    return switch (status) {
      TaskStatus.pending => (Colors.grey, Icons.hourglass_empty, 'Pending'),
      TaskStatus.urgent => (Colors.red, Icons.priority_high, 'Urgent'),
      TaskStatus.inProgress => (Colors.orange, Icons.play_circle, 'In Progress'),
      TaskStatus.completed => (Colors.green, Icons.check_circle, 'Completed'),
    };
  }
}

/// Task priority badge widget
class TaskPriorityBadge extends StatelessWidget {
  final TaskPriority priority;
  final bool compact;

  const TaskPriorityBadge({
    super.key,
    required this.priority,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = TaskPriorityUtils.getColor(priority);
    final label = TaskPriorityUtils.getLabel(priority);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(compact ? 8 : 12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        compact ? label.substring(0, 1) : label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: compact ? 10 : null,
            ),
      ),
    );
  }
}

/// Utility class for task priority operations
class TaskPriorityUtils {
  static Color getColor(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.high => Colors.red,
      TaskPriority.medium => Colors.orange,
      TaskPriority.low => Colors.blue,
    };
  }

  static String getLabel(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.high => 'High',
      TaskPriority.medium => 'Medium',
      TaskPriority.low => 'Low',
    };
  }

  static IconData getIcon(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.high => Icons.priority_high,
      TaskPriority.medium => Icons.remove,
      TaskPriority.low => Icons.arrow_downward,
    };
  }
}

/// Common task stats summary widget
class TaskStatsSummary extends StatelessWidget {
  final int total;
  final int completed;
  final int running;
  final int failed;
  final bool compact;

  const TaskStatsSummary({
    super.key,
    required this.total,
    required this.completed,
    required this.running,
    required this.failed,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: compact ? 8 : 12,
      children: [
        _buildStat(context, 'Total', total, Colors.blue),
        _buildStat(context, 'Completed', completed, Colors.green),
        if (running > 0) _buildStat(context, 'Running', running, Colors.orange),
        if (failed > 0) _buildStat(context, 'Failed', failed, Colors.red),
      ],
    );
  }

  Widget _buildStat(BuildContext context, String label, int value, Color color) {
    final textTheme = Theme.of(context).textTheme;

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          '$value',
          style: textTheme.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}