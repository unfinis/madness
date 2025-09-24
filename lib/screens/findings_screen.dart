import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/finding_filters_widget.dart';
import '../widgets/finding_table_widget.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../widgets/perspective_tab_view.dart';
import '../constants/app_spacing.dart';
import '../dialogs/enhanced_finding_dialog.dart';

class FindingsScreen extends ConsumerStatefulWidget {
  const FindingsScreen({super.key});

  @override
  ConsumerState<FindingsScreen> createState() => _FindingsScreenState();
}

class _FindingsScreenState extends ConsumerState<FindingsScreen> {
  final bool _showFilters = true;

  @override
  void initState() {
    super.initState();
    // Load findings when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentProject = ref.read(currentProjectProvider);
      if (currentProject != null) {
        ref.read(findingProvider.notifier).loadFindings(currentProject.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    final findingState = ref.watch(findingProvider);
    final findings = findingState.findings;

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(findingProvider.notifier).loadFindings(currentProject.id);
      },
      child: PerspectiveTabView(
        header: _buildStandardStatsBar(findings),
        filters: _showFilters ? const FindingFiltersWidget() : null,
        tabs: [
          PerspectiveTab(
            name: 'All',
            icon: Icons.list,
            content: _buildFindingsList(findings),
          ),
          PerspectiveTab(
            name: 'Critical',
            icon: Icons.warning,
            content: _buildFindingsList(findings.where((f) => f.severity == FindingSeverity.critical).toList()),
          ),
          PerspectiveTab(
            name: 'Active',
            icon: Icons.radio_button_checked,
            content: _buildFindingsList(findings.where((f) => f.status == FindingStatus.active).toList()),
          ),
          PerspectiveTab(
            name: 'Resolved',
            icon: Icons.check_circle,
            content: _buildFindingsList(findings.where((f) => f.status == FindingStatus.resolved).toList()),
          ),
        ],
      ),
    );
  }


  void _handleFindingTap(Finding finding) {
    // Single tap - just select the finding for now
    ref.read(findingProvider.notifier).selectFinding(finding);
  }

  void _handleFindingEdit(Finding finding) {
    // Double tap or edit action - open enhanced finding dialog
    _showEnhancedFindingDialog(finding);
  }

  void _handleFindingDelete(Finding finding) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Finding'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this finding?'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    finding.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${finding.severity.displayName} • CVSS ${finding.cvssScore.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: finding.severity.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text('This action cannot be undone.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(findingProvider.notifier).deleteFinding(finding.id);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted finding "${finding.title}"'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // TODO: Implement undo functionality
                      ref.read(findingProvider.notifier).createFinding(finding);
                    },
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _createNewFinding() {
    _showEnhancedFindingDialog(null);
  }

  void _showEnhancedFindingDialog(Finding? finding) async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    final result = await showDialog<Finding>(
      context: context,
      builder: (context) => EnhancedFindingDialog(
        projectId: currentProject.id,
        finding: finding,
      ),
    );

    if (result != null && mounted) {
      // Refresh the findings list
      ref.read(findingProvider.notifier).loadFindings(currentProject.id);
    }
  }



  Widget _buildStandardStatsBar(List<Finding> findings) {
    if (findings.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate statistics
    final totalFindings = findings.length;
    final criticalCount = findings.where((f) => f.severity == FindingSeverity.critical).length;
    final highCount = findings.where((f) => f.severity == FindingSeverity.high).length;
    final mediumCount = findings.where((f) => f.severity == FindingSeverity.medium).length;
    final lowCount = findings.where((f) => f.severity == FindingSeverity.low).length;
    final infoCount = findings.where((f) => f.severity == FindingSeverity.informational).length;
    final activeCount = findings.where((f) => f.status == FindingStatus.active).length;
    final resolvedCount = findings.where((f) => f.status == FindingStatus.resolved).length;

    final stats = [
      StatData(
        label: 'Total',
        count: totalFindings,
        icon: Icons.list,
        color: Theme.of(context).colorScheme.primary,
      ),
      StatData(
        label: 'Critical',
        count: criticalCount,
        icon: Icons.warning,
        color: Colors.red,
      ),
      StatData(
        label: 'High',
        count: highCount,
        icon: Icons.priority_high,
        color: Colors.orange,
      ),
      StatData(
        label: 'Medium',
        count: mediumCount,
        icon: Icons.remove,
        color: Colors.yellow.shade700,
      ),
      StatData(
        label: 'Low',
        count: lowCount,
        icon: Icons.low_priority,
        color: Colors.blue,
      ),
      StatData(
        label: 'Info',
        count: infoCount,
        icon: Icons.info,
        color: Colors.grey,
      ),
      StatData(
        label: 'Active',
        count: activeCount,
        icon: Icons.radio_button_checked,
        color: Colors.green,
      ),
      StatData(
        label: 'Resolved',
        count: resolvedCount,
        icon: Icons.check_circle,
        color: Colors.teal,
      ),
    ];

    return StandardStatsBar(chips: StatsHelper.buildChips(stats));
  }

  Widget _buildFindingsList(List<Finding> findings) {
    if (findings.isEmpty) {
      return PerspectiveEmptyState(
        title: 'No findings available',
        subtitle: 'Findings will appear here as they are discovered and documented',
        icon: Icons.search,
        onAction: () => _createNewFinding(),
        actionLabel: 'Add Finding',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: FindingTableWidget(
        onRowTap: _handleFindingTap,
        onRowDoubleTap: _handleFindingEdit,
        onEdit: _handleFindingEdit,
        onDelete: _handleFindingDelete,
      ),
    );
  }
}