import 'package:flutter/material.dart';
import '../../services/trigger_system/models/execution_priority.dart';

/// Badge displaying execution priority with color coding
class ExecutionPriorityBadge extends StatelessWidget {
  final ExecutionPriority priority;
  final bool showScore;
  final bool compact;

  const ExecutionPriorityBadge({
    super.key,
    required this.priority,
    this.showScore = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getPriorityColor(priority.level);
    final icon = _getPriorityIcon(priority.level);

    if (compact) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            if (showScore) ...[
              const SizedBox(width: 4),
              Text(
                '${priority.score}',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          if (showScore) ...[
            Text(
              '${priority.score}',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            priority.level.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'high':
        return Colors.orange;
      case 'medium':
        return Colors.amber;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return Icons.warning;
      case 'high':
        return Icons.arrow_upward;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.help_outline;
    }
  }
}

/// Priority indicator with tooltip showing details
class ExecutionPriorityIndicator extends StatelessWidget {
  final ExecutionPriority priority;

  const ExecutionPriorityIndicator({
    super.key,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Priority: ${priority.level}\nScore: ${priority.score}\n\n${priority.reason}',
      child: ExecutionPriorityBadge(priority: priority),
    );
  }
}
