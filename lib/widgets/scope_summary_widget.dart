import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scope_provider.dart';
import 'unified_summary_widget.dart';

class ScopeSummaryWidget extends ConsumerWidget {
  final bool compact;
  
  const ScopeSummaryWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(scopeSummaryProvider);
    final theme = Theme.of(context);
    
    final items = [
      SummaryItemData(
        label: 'Testing Segments',
        value: summary['totalSegments']?.toString() ?? '0',
        icon: Icons.schema_rounded,
        color: theme.colorScheme.primary,
      ),
      SummaryItemData(
        label: 'Active Segments',
        value: summary['activeSegments']?.toString() ?? '0',
        icon: Icons.play_circle_rounded,
        color: Colors.green,
      ),
      SummaryItemData(
        label: 'Planned Segments',
        value: summary['plannedSegments']?.toString() ?? '0',
        icon: Icons.schedule_rounded,
        color: Colors.orange,
      ),
      SummaryItemData(
        label: 'Completed Segments',
        value: summary['completedSegments']?.toString() ?? '0',
        icon: Icons.check_circle_rounded,
        color: Colors.blue,
      ),
      SummaryItemData(
        label: 'Total Items',
        value: summary['totalItems']?.toString() ?? '0',
        icon: Icons.list_alt_rounded,
        color: theme.colorScheme.tertiary,
      ),
      SummaryItemData(
        label: 'Active Items',
        value: summary['activeItems']?.toString() ?? '0',
        icon: Icons.gps_fixed_rounded,
        color: theme.colorScheme.secondary,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '',
      items: items,
      compact: compact,
    );
  }

}