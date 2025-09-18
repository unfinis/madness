import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/methodology_provider.dart';
import '../providers/projects_provider.dart';
import 'unified_summary_widget.dart';

class MethodologySummaryWidget extends ConsumerWidget {
  const MethodologySummaryWidget({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(currentProjectProvider);
    if (currentProject == null) {
      return const SizedBox.shrink();
    }

    final stats = ref.watch(methodologyStatsProvider(currentProject.id));
    
    final summaryItems = [
      SummaryItemData(
        icon: Icons.assignment,
        value: stats.totalActions.toString(),
        label: 'Total Actions',
        color: Theme.of(context).colorScheme.primary,
      ),
      SummaryItemData(
        icon: Icons.play_circle,
        value: stats.inProgressCount.toString(),
        label: 'In Progress',
        color: Theme.of(context).colorScheme.secondary,
      ),
      SummaryItemData(
        icon: Icons.check_circle,
        value: stats.completedCount.toString(),
        label: 'Completed',
        color: Theme.of(context).colorScheme.tertiary,
      ),
      SummaryItemData(
        icon: Icons.lightbulb,
        value: stats.recommendationCount.toString(),
        label: 'Recommendations',
        color: Theme.of(context).colorScheme.primary,
      ),
      SummaryItemData(
        icon: Icons.analytics,
        value: stats.discoveredAssetsCount.toString(),
        label: 'Assets Found',
        color: Theme.of(context).colorScheme.secondary,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '', // Empty title for compact mode
      items: summaryItems,
      compact: compact,
    );
  }
}