import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/finding_filters_widget.dart';
import '../widgets/finding_table_widget.dart';
import '../widgets/sub_finding_template_dialog.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/responsive_breakpoints.dart';
import '../constants/app_spacing.dart';
import '../dialogs/enhanced_finding_dialog.dart';

class FindingsScreen extends ConsumerStatefulWidget {
  const FindingsScreen({super.key});

  @override
  ConsumerState<FindingsScreen> createState() => _FindingsScreenState();
}

class _FindingsScreenState extends ConsumerState<FindingsScreen> {
  bool _showFilters = true;

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
        appBar: AppBar(
          title: const Text('Findings'),
        ),
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context, currentProject),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(findingProvider.notifier).loadFindings(currentProject.id);
        },
        child: SingleChildScrollView(
          padding: CommonLayoutWidgets.getScreenPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPillStyleSummary(),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),

              ResponsiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showFilters) ...[
                      const FindingFiltersWidget(),
                      SizedBox(height: CommonLayoutWidgets.sectionSpacing),
                    ],
                    
                    FindingTableWidget(
                      onRowTap: _handleFindingTap,
                      onRowDoubleTap: _handleFindingEdit,
                      onEdit: _handleFindingEdit,
                      onDelete: _handleFindingDelete,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, dynamic currentProject) {
    final findingState = ref.watch(findingProvider);
    final filteredCount = findingState.filteredFindings.length;
    final totalCount = findingState.findings.length;

    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Findings'),
          if (filteredCount != totalCount)
            Text(
              '$filteredCount of $totalCount findings',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
        ],
      ),
      actions: [
        // Template button
        IconButton(
          icon: const Icon(Icons.account_tree_outlined),
          onPressed: () async {
            final result = await showSubFindingTemplateDialog(context);
            if (result == true) {
              // Refresh the findings list
              ref.read(findingProvider.notifier).loadFindings(currentProject.id);
            }
          },
          tooltip: 'Create from Template',
        ),
        
        // Filter toggle
        IconButton(
          icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_off),
          onPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
          tooltip: _showFilters ? 'Hide Filters' : 'Show Filters',
        ),
        
        // Export menu
        PopupMenuButton(
          icon: const Icon(Icons.download),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'export_all',
              child: Row(
                children: [
                  Icon(Icons.file_download, size: 16),
                  SizedBox(width: 8),
                  Text('Export All Findings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'export_filtered',
              child: Row(
                children: [
                  Icon(Icons.filter_alt, size: 16),
                  SizedBox(width: 8),
                  Text('Export Filtered'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'import',
              child: Row(
                children: [
                  Icon(Icons.file_upload, size: 16),
                  SizedBox(width: 8),
                  Text('Import Findings'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'export_all':
                _exportFindings(findingState.findings);
                break;
              case 'export_filtered':
                _exportFindings(findingState.filteredFindings);
                break;
              case 'import':
                _importFindings();
                break;
            }
          },
        ),
        
        // More options
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: Row(
                children: [
                  Icon(Icons.refresh, size: 16),
                  SizedBox(width: 8),
                  Text('Refresh'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear_filters',
              child: Row(
                children: [
                  Icon(Icons.clear, size: 16),
                  SizedBox(width: 8),
                  Text('Clear All Filters'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 'refresh':
                ref.read(findingProvider.notifier).loadFindings(currentProject.id);
                break;
              case 'clear_filters':
                ref.read(findingProvider.notifier).clearFilters();
                break;
            }
          },
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = ResponsiveBreakpoints.isDesktop(constraints.maxWidth);
        
        if (isDesktop) {
          return FloatingActionButton.extended(
            onPressed: _createNewFinding,
            icon: const Icon(Icons.add),
            label: const Text('New Finding'),
          );
        } else {
          return FloatingActionButton(
            onPressed: _createNewFinding,
            child: const Icon(Icons.add),
            tooltip: 'New Finding',
          );
        }
      },
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
            Text('Are you sure you want to delete this finding?'),
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

  Widget _buildPillStyleSummary() {
    final findingState = ref.watch(findingProvider);
    final findings = findingState.findings;

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
    final highestCvss = findings.isEmpty ? 0.0 : findings.map((f) => f.cvssScore).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip('Total', totalFindings, Icons.folder_outlined, Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Critical', criticalCount, Icons.error, const Color(0xFFef4444)),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('High', highCount, Icons.warning, const Color(0xFFf59e0b)),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Medium', mediumCount, Icons.info, const Color(0xFFfbbf24)),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Low', lowCount, Icons.check_circle, const Color(0xFF10b981)),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Info', infoCount, Icons.info_outline, const Color(0xFF6b7280)),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Active', activeCount, Icons.play_circle, Colors.red),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Resolved', resolvedCount, Icons.check_circle, Colors.green),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Max CVSS', highestCvss.toStringAsFixed(1), Icons.speed, Colors.deepOrange),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, dynamic value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  void _exportFindings(List<Finding> findings) async {
    try {
      final findingIds = findings.map((f) => f.id).toList();
      final jsonData = await ref.read(findingProvider.notifier).exportFindings(findingIds);
      
      // TODO: Implement file save functionality
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${findings.length} findings'),
            action: SnackBarAction(
              label: 'Preview',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: Container(
                      width: 600,
                      height: 400,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(child: Text('Export Preview')),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          const Divider(),
                          Expanded(
                            child: SingleChildScrollView(
                              child: SelectableText(
                                jsonData,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _importFindings() {
    // TODO: Implement file picker and import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import functionality coming soon...')),
    );
  }
}