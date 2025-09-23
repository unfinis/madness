import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scope.dart';
import '../providers/scope_provider.dart';
import '../widgets/scope_filters_widget.dart';
import '../widgets/scope_segment_card_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../dialogs/add_scope_segment_dialog.dart';
import '../dialogs/scope_export_dialog.dart';
import '../services/import_export_service.dart';

class ScopeScreen extends ConsumerStatefulWidget {
  const ScopeScreen({super.key});

  @override
  ConsumerState<ScopeScreen> createState() => _ScopeScreenState();
}

class _ScopeScreenState extends ConsumerState<ScopeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSegments = ref.watch(filteredScopeSegmentsProvider);
    
    return ScreenWrapper(
      children: [
        _buildScopeStatsBar(context),
        SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with responsive buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Testing Segments',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: CommonLayoutWidgets.itemSpacing),
                  // Responsive button layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            const Spacer(),
                            ..._buildActionButtons(context),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Wrap(
                              alignment: WrapAlignment.end,
                              spacing: 8,
                              runSpacing: 8,
                              children: _buildActionButtons(context),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              ScopeFiltersWidget(searchController: _searchController),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              if (filteredSegments.isEmpty)
                CommonStateWidgets.noData(
                  itemName: 'testing segments',
                  icon: Icons.schema_outlined,
                  onCreate: () => _showAddSegmentDialog(context),
                  createButtonText: 'Add First Segment',
                )
              else
                _buildSegmentsList(filteredSegments),
            ],
          ),
        ),
      ],
    );
  }


  List<Widget> _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.3;
    
    if (availableWidth > 400) {
      // Wide enough: All buttons in a row with labels
      return [
        OutlinedButton.icon(
          onPressed: () => _importScope(context),
          icon: const Icon(Icons.upload, size: 18),
          label: const Text('Import'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _exportScope(context),
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddSegmentDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Segment'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else if (availableWidth > 300) {
      // Medium width: Icon buttons with tooltips + Add button
      return [
        IconButton.outlined(
          onPressed: () => _importScope(context),
          icon: const Icon(Icons.upload, size: 18),
          tooltip: 'Import',
        ),
        const SizedBox(width: 4),
        IconButton.outlined(
          onPressed: () => _exportScope(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddSegmentDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else if (availableWidth > 200) {
      // Narrow: Export and Add only
      return [
        IconButton.outlined(
          onPressed: () => _exportScope(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddSegmentDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else {
      // Very narrow: Just essential buttons
      return [
        FilledButton.icon(
          onPressed: () => _showAddSegmentDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        ),
      ];
    }
  }

  Widget _buildSegmentsList(List<ScopeSegment> segments) {
    return Column(
      children: segments.asMap().entries.map((entry) {
        final index = entry.key;
        final segment = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < segments.length - 1 ? CommonLayoutWidgets.itemSpacing : 0),
          child: ScopeSegmentCardWidget(segment: segment),
        );
      }).toList(),
    );
  }

  void _showAddSegmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddScopeSegmentDialog(),
    );
  }

  void _exportScope(BuildContext context) async {
    final filteredSegments = ref.read(filteredScopeSegmentsProvider);
    
    if (filteredSegments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No scope segments to export'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }

    final totalItems = filteredSegments.fold(0, (sum, segment) => sum + segment.totalItemsCount);

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ScopeExportDialog(
        totalSegments: filteredSegments.length,
        totalItems: totalItems,
      ),
    );

    if (result != null) {
      try {
        final importExportService = ImportExportService();
        final filePath = await importExportService.exportScope(
          filteredSegments,
          result['format'] as ExportFormat,
          customFileName: result['fileName'] as String?,
          includeItems: result['includeItems'] as bool,
        );

        if (filePath != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Scope data exported successfully to: ${filePath.split('/').last}'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              action: SnackBarAction(
                label: 'Open Folder',
                onPressed: () {
                  // TODO: Open file location
                },
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export failed: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  void _importScope(BuildContext context) async {
    try {
      final importExportService = ImportExportService();
      final segments = await importExportService.importScope();

      if (segments != null && segments.isNotEmpty && mounted) {
        // Show confirmation dialog
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Import Scope Data'),
            content: Text(
              'Found ${segments.length} segment${segments.length == 1 ? '' : 's'} to import. '
              'This will add them to your existing scope data. Continue?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Import'),
              ),
            ],
          ),
        );

        if (confirmed == true) {
          // Add segments to the provider
          for (final segment in segments) {
            ref.read(scopeProvider.notifier).addSegment(segment);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully imported ${segments.length} scope segment${segments.length == 1 ? '' : 's'}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          }
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No data to import or import was cancelled'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Widget _buildScopeStatsBar(BuildContext context) {
    final segments = ref.watch(filteredScopeSegmentsProvider);
    final stats = _calculateScopeStats(segments);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip('Total', stats.total, Icons.track_changes, Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('External', stats.external, Icons.public, Colors.teal),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Internal', stats.internal, Icons.business, Colors.blue),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Web App', stats.webapp, Icons.web, Colors.green),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Mobile', stats.mobile, Icons.phone_android, Colors.orange),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('API', stats.api, Icons.api, Colors.red),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Wireless', stats.wireless, Icons.wifi, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
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
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  ScopeStats _calculateScopeStats(List<ScopeSegment> segments) {
    final external = segments.where((s) => s.type == ScopeSegmentType.external).length;
    final internal = segments.where((s) => s.type == ScopeSegmentType.internal).length;
    final webapp = segments.where((s) => s.type == ScopeSegmentType.webapp).length;
    final mobile = segments.where((s) => s.type == ScopeSegmentType.mobile).length;
    final api = segments.where((s) => s.type == ScopeSegmentType.api).length;
    final wireless = segments.where((s) => s.type == ScopeSegmentType.wireless).length;

    return ScopeStats(
      total: segments.length,
      external: external,
      internal: internal,
      webapp: webapp,
      mobile: mobile,
      api: api,
      wireless: wireless,
    );
  }
}

class ScopeStats {
  final int total;
  final int external;
  final int internal;
  final int webapp;
  final int mobile;
  final int api;
  final int wireless;

  ScopeStats({
    required this.total,
    required this.external,
    required this.internal,
    required this.webapp,
    required this.mobile,
    required this.api,
    required this.wireless,
  });
}