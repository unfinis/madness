import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';
import 'unified_summary_widget.dart';

class FindingSummaryWidget extends ConsumerWidget {
  final bool compact;
  
  const FindingSummaryWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryStats = ref.watch(findingSummaryStatsProvider);
    final severityBreakdown = ref.watch(findingSeverityBreakdownProvider);

    return Card(
      margin: EdgeInsets.all(compact ? 8.0 : 12.0),
      child: Padding(
        padding: EdgeInsets.all(compact ? 12.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return _buildDesktopLayout(context, summaryStats, severityBreakdown);
                } else {
                  return _buildMobileLayout(context, summaryStats, severityBreakdown);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    FindingSummaryStats stats,
    Map<FindingSeverity, int> severityBreakdown,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildOverviewCards(context, stats),
        ),
        SizedBox(width: compact ? 12 : 16),
        Expanded(
          flex: 3,
          child: _buildSeverityBreakdown(context, severityBreakdown),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    FindingSummaryStats stats,
    Map<FindingSeverity, int> severityBreakdown,
  ) {
    return Column(
      children: [
        _buildOverviewCards(context, stats),
        SizedBox(height: compact ? 12 : 16),
        _buildSeverityBreakdown(context, severityBreakdown),
      ],
    );
  }

  Widget _buildOverviewCards(BuildContext context, FindingSummaryStats stats) {
    final theme = Theme.of(context);
    
    final items = [
      SummaryItemData(
        label: 'Total Findings',
        value: stats.totalFindings.toString(),
        icon: Icons.bug_report,
        color: theme.colorScheme.primary,
      ),
      SummaryItemData(
        label: 'Highest CVSS',
        value: stats.highestCvssScore.toStringAsFixed(1),
        icon: Icons.priority_high,
        color: _getCvssScoreColor(stats.highestCvssScore),
      ),
      SummaryItemData(
        label: 'Resolved',
        value: stats.resolvedCount.toString(),
        icon: Icons.check_circle,
        color: Colors.green,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '',
      items: items,
      compact: compact,
    );
  }


  Widget _buildSeverityBreakdown(
    BuildContext context,
    Map<FindingSeverity, int> severityBreakdown,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Severity Breakdown',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...FindingSeverity.values.map((severity) {
          final count = severityBreakdown[severity] ?? 0;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildSeverityRow(context, severity, count, severityBreakdown),
          );
        }),
      ],
    );
  }

  Widget _buildSeverityRow(
    BuildContext context,
    FindingSeverity severity,
    int count,
    Map<FindingSeverity, int> allCounts,
  ) {
    final totalCount = allCounts.values.fold(0, (sum, count) => sum + count);
    final percentage = totalCount > 0 ? (count / totalCount) * 100 : 0.0;

    return Row(
      children: [
        // Severity indicator
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: severity.color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        
        // Severity name
        SizedBox(
          width: 60,
          child: Text(
            severity.displayName,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Progress bar
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: totalCount > 0 ? count / totalCount : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: severity.color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        
        // Count and percentage
        SizedBox(
          width: 60,
          child: Text(
            '$count (${percentage.toStringAsFixed(0)}%)',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Color _getCvssScoreColor(double score) {
    if (score >= 9.0) return const Color(0xFFef4444); // Critical
    if (score >= 7.0) return const Color(0xFFf59e0b); // High
    if (score >= 4.0) return const Color(0xFFfbbf24); // Medium
    if (score >= 0.1) return const Color(0xFF10b981); // Low
    return const Color(0xFF6b7280); // Info
  }
}