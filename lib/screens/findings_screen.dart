import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/finding_summary_widget.dart';
import '../widgets/finding_filters_widget.dart';
import '../widgets/finding_table_widget.dart';
import '../widgets/sub_finding_template_dialog.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/responsive_breakpoints.dart';
import 'finding_editor_screen.dart';

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
              const FindingSummaryWidget(compact: true),
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
    // Navigate to finding detail screen
    _showFindingDetails(finding);
  }

  void _handleFindingEdit(Finding finding) {
    // Navigate to finding editor
    _showFindingEditor(finding);
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
    _showFindingEditor(null);
  }

  void _showFindingDetails(Finding finding) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      finding.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: finding.severity.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: finding.severity.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      finding.severity.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: finding.severity.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: finding.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: finding.status.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      finding.status.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: finding.status.color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: finding.severity.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'CVSS ${finding.cvssScore.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: finding.severity.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (finding.description.isNotEmpty) ...[
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(finding.description),
                        const SizedBox(height: 24),
                      ],
                      if (finding.components.isNotEmpty) ...[
                        Text(
                          'Affected Components',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...finding.components.map((component) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  component.type.displayName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text('${component.name}: ${component.value}')),
                            ],
                          ),
                        )),
                        const SizedBox(height: 24),
                      ],
                      if (finding.links.isNotEmpty) ...[
                        Text(
                          'References',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...finding.links.map((link) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.link, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  link.title,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showFindingEditor(finding);
                    },
                    child: const Text('Edit Finding'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFindingEditor(Finding? finding) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FindingEditorScreen(finding: finding),
      ),
    );
  }

  void _exportFindings(List<Finding> findings) async {
    try {
      final findingIds = findings.map((f) => f.id).toList();
      final jsonData = await ref.read(findingProvider.notifier).exportFindings(findingIds);
      
      // TODO: Implement file save functionality
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _importFindings() {
    // TODO: Implement file picker and import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import functionality coming soon...')),
    );
  }
}