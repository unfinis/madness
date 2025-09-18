import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import 'unified_summary_widget.dart';

class TaskSummaryWidget extends ConsumerWidget {
  final String projectId;
  final bool compact;
  
  const TaskSummaryWidget({super.key, required this.projectId, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(taskSummaryProvider(projectId));
    final theme = Theme.of(context);
    
    final items = [
      SummaryItemData(
        label: 'Total Tasks',
        value: summary['total']?.toString() ?? '0',
        icon: Icons.task_alt,
        color: theme.colorScheme.primary,
      ),
      SummaryItemData(
        label: 'Urgent',
        value: summary['urgent']?.toString() ?? '0',
        icon: Icons.warning,
        color: theme.colorScheme.error,
      ),
      SummaryItemData(
        label: 'In Progress',
        value: summary['inProgress']?.toString() ?? '0',
        icon: Icons.schedule,
        color: theme.colorScheme.tertiary,
      ),
      SummaryItemData(
        label: 'Completed',
        value: summary['completed']?.toString() ?? '0',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      SummaryItemData(
        label: 'Overdue',
        value: summary['overdue']?.toString() ?? '0',
        icon: Icons.access_time,
        color: Colors.red,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '',
      items: items,
      compact: compact,
    );
  }

}