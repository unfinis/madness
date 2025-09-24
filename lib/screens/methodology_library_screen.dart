import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/storage_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../constants/app_spacing.dart';
import '../dialogs/methodology_template_editor_dialog.dart';
import '../services/methodology_loader.dart';

class MethodologyLibraryScreen extends ConsumerStatefulWidget {
  const MethodologyLibraryScreen({super.key});

  @override
  ConsumerState<MethodologyLibraryScreen> createState() => _MethodologyLibraryScreenState();
}

class _MethodologyLibraryScreenState extends ConsumerState<MethodologyLibraryScreen> {
  String _searchQuery = '';
  String? _selectedTag;
  String _selectedRiskLevel = 'all';
  String _sortBy = 'name'; // name, created, updated, risk

  bool _hasLoadedFromJson = false;

  @override
  void initState() {
    super.initState();
    _loadMethodologiesFromJsonIfNeeded();
  }

  /// Load methodologies from JSON assets if storage is empty
  Future<void> _loadMethodologiesFromJsonIfNeeded() async {
    if (_hasLoadedFromJson) return;

    try {
      final storage = ref.read(storageServiceProvider);
      final existingTemplates = await storage.getAllTemplates();

      // If storage is empty, load from JSON and migrate
      if (existingTemplates.isEmpty) {
        debugPrint('Storage empty, loading from JSON assets...');
        await MethodologyLoader.loadAllMethodologies();
        final jsonMethodologies = MethodologyLoader.getAllMethodologies();
        debugPrint('Loaded ${jsonMethodologies.length} methodologies from JSON');

        // Store in Drift database
        for (final methodology in jsonMethodologies) {
          await storage.storeTemplate(methodology);
        }
        debugPrint('Migrated ${jsonMethodologies.length} methodologies to Drift database');
      }

      _hasLoadedFromJson = true;
    } catch (e) {
      debugPrint('Error in _loadMethodologiesFromJsonIfNeeded: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    // Watch templates from storage
    final templatesAsync = ref.watch(templateNotifierProvider);

    return templatesAsync.when(
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                size: 64,
                color: Colors.red[400],
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading methodologies: $error',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(templateNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (methodologies) {
        final filteredMethodologies = _applyFilters(methodologies);
        final allTags = _getAllTags(methodologies);

        return _buildLibraryContent(filteredMethodologies, allTags);
      },
    );
  }

  Widget _buildLibraryContent(List<MethodologyTemplate> filteredMethodologies, List<String> allTags) {
    // Get original methodologies list for stats
    final templatesAsync = ref.read(templateNotifierProvider);
    final allMethodologies = templatesAsync.asData?.value ?? [];

    return Scaffold(
      body: Column(
        children: [
          _buildStatsBar(filteredMethodologies, allMethodologies),
          const Divider(height: 1),
          _buildSearchAndFilters(),
          const Divider(height: 1),
          if (allTags.isNotEmpty) ...[
            _buildTagCloud(allTags, allMethodologies),
            const Divider(height: 1),
          ],
          Expanded(
            child: filteredMethodologies.isEmpty
                ? _buildEmptyState()
                : _buildMethodologyGrid(filteredMethodologies),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(List<MethodologyTemplate> filtered, List<MethodologyTemplate> total) {
    final stats = _calculateStats(total);

    final statsData = [
      StatData(
        label: 'Total',
        count: total.length,
        icon: Icons.library_books,
        color: Theme.of(context).colorScheme.primary,
      ),
      StatData(
        label: 'Filtered',
        count: filtered.length,
        icon: Icons.filter_list,
        color: Colors.blue,
      ),
      StatData(
        label: 'Low Risk',
        count: stats.lowRisk,
        icon: Icons.info,
        color: Colors.green,
      ),
      StatData(
        label: 'Medium Risk',
        count: stats.mediumRisk,
        icon: Icons.warning,
        color: Colors.orange,
      ),
      StatData(
        label: 'High Risk',
        count: stats.highRisk,
        icon: Icons.error,
        color: Colors.red,
      ),
      StatData(
        label: 'Critical',
        count: stats.critical,
        icon: Icons.dangerous,
        color: Colors.purple,
      ),
    ];

    return StandardStatsBar(chips: StatsHelper.buildChips(statsData));
  }


  Widget _buildSearchAndFilters() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            return Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search methodologies...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: _buildRiskLevelFilter()),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildSortByFilter()),
                  ],
                ),
              ],
            );
          }
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search methodologies by title, ID, or tags...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _buildRiskLevelFilter()),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildSortByFilter()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRiskLevelFilter() {
    return DropdownButtonFormField<String>(
      value: _selectedRiskLevel,
      decoration: const InputDecoration(
        labelText: 'Risk Level',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: const [
        DropdownMenuItem(value: 'all', child: Text('All Levels')),
        DropdownMenuItem(value: 'low', child: Text('Low')),
        DropdownMenuItem(value: 'medium', child: Text('Medium')),
        DropdownMenuItem(value: 'high', child: Text('High')),
        DropdownMenuItem(value: 'critical', child: Text('Critical')),
      ],
      onChanged: (value) {
        setState(() {
          _selectedRiskLevel = value ?? 'all';
        });
      },
    );
  }

  Widget _buildSortByFilter() {
    return DropdownButtonFormField<String>(
      value: _sortBy,
      decoration: const InputDecoration(
        labelText: 'Sort By',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: const [
        DropdownMenuItem(value: 'name', child: Text('Name')),
        DropdownMenuItem(value: 'created', child: Text('Created')),
        DropdownMenuItem(value: 'updated', child: Text('Updated')),
        DropdownMenuItem(value: 'risk', child: Text('Risk Level')),
      ],
      onChanged: (value) {
        setState(() {
          _sortBy = value ?? 'name';
        });
      },
    );
  }

  Widget _buildTagCloud(List<String> allTags, List<MethodologyTemplate> methodologies) {
    final tagFrequency = <String, int>{};
    for (final methodology in methodologies) {
      for (final tag in methodology.tags) {
        tagFrequency[tag] = (tagFrequency[tag] ?? 0) + 1;
      }
    }

    final sortedTags = tagFrequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Popular Tags',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              if (_selectedTag != null) ...[
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedTag = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear Filter'),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: sortedTags.take(20).map((entry) {
              final isSelected = _selectedTag == entry.key;
              final frequency = entry.value;
              final size = _getTagSize(frequency, tagFrequency.values.reduce((a, b) => a > b ? a : b));

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTag = isSelected ? null : entry.key;
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8 + size * 2,
                    vertical: 4 + size,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${entry.key} ($frequency)',
                    style: TextStyle(
                      color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 11 + size * 2,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  double _getTagSize(int frequency, int maxFrequency) {
    if (maxFrequency <= 1) return 0.0;
    return (frequency / maxFrequency).clamp(0.0, 1.0) * 3.0;
  }

  Widget _buildMethodologyGrid(List<MethodologyTemplate> methodologies) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 1200 ? 3 : constraints.maxWidth > 800 ? 2 : 1;

        return GridView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 1.2,
          ),
          itemCount: methodologies.length,
          itemBuilder: (context, index) {
            return _buildMethodologyCard(methodologies[index]);
          },
        );
      },
    );
  }

  Widget _buildMethodologyCard(MethodologyTemplate methodology) {
    final riskColor = _getRiskLevelColor(methodology.riskLevel);

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _openMethodology(methodology),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: riskColor.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: riskColor.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        methodology.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: riskColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        methodology.id,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Objective
                      Text(
                        methodology.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),

                      // Tags
                      if (methodology.tags.isNotEmpty) ...[
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: methodology.tags.take(3).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (methodology.tags.length > 3)
                          Text(
                            '+${methodology.tags.length - 3} more',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.sm),
                      ],

                      // Stats row
                      Row(
                        children: [
                          _buildMethodologyBadge('Triggers: ${methodology.triggers.length}', Icons.flash_on, Colors.orange),
                          const SizedBox(width: 4),
                          _buildMethodologyBadge('Commands: ${methodology.procedures.expand((p) => p.commands).length}', Icons.terminal, Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Footer
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(methodology.modified),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'v${methodology.version}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    PopupMenuButton<String>(
                      onSelected: (action) => _handleMethodologyAction(action, methodology),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'view', child: Text('View Details')),
                        const PopupMenuItem(value: 'edit', child: Text('Edit Template')),
                        const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                        const PopupMenuItem(value: 'export', child: Text('Export')),
                        const PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                      child: Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodologyBadge(String text, IconData icon, Color color) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: color),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            _searchQuery.isNotEmpty || _selectedTag != null
                ? 'No methodologies match your filters'
                : 'No methodology templates found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _searchQuery.isNotEmpty || _selectedTag != null
                ? 'Try adjusting your search or filters'
                : 'Create your first methodology template to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () => _handleMenuAction('new_template'),
            icon: const Icon(Icons.add),
            label: const Text('Create Template'),
          ),
        ],
      ),
    );
  }

  List<MethodologyTemplate> _applyFilters(List<MethodologyTemplate> methodologies) {
    var filtered = methodologies.where((methodology) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchableText = [
          methodology.name,
          methodology.id,
          methodology.description,
          ...methodology.tags,
        ].join(' ').toLowerCase();

        if (!searchableText.contains(_searchQuery)) {
          return false;
        }
      }

      // Risk level filter
      if (_selectedRiskLevel != 'all' && methodology.riskLevel != _selectedRiskLevel) {
        return false;
      }

      // Tag filter
      if (_selectedTag != null && !methodology.tags.contains(_selectedTag)) {
        return false;
      }

      return true;
    }).toList();

    // Sort
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'created':
        filtered.sort((a, b) => b.created.compareTo(a.created));
        break;
      case 'updated':
        filtered.sort((a, b) => b.modified.compareTo(a.modified));
        break;
      case 'risk':
        filtered.sort((a, b) => _getRiskLevelPriority(b.riskLevel).compareTo(_getRiskLevelPriority(a.riskLevel)));
        break;
    }

    return filtered;
  }

  List<String> _getAllTags(List<MethodologyTemplate> methodologies) {
    final allTags = <String>{};
    for (final methodology in methodologies) {
      allTags.addAll(methodology.tags);
    }
    return allTags.toList()..sort();
  }

  _MethodologyStats _calculateStats(List<MethodologyTemplate> methodologies) {
    return _MethodologyStats(
      lowRisk: methodologies.where((m) => m.riskLevel == 'low').length,
      mediumRisk: methodologies.where((m) => m.riskLevel == 'medium').length,
      highRisk: methodologies.where((m) => m.riskLevel == 'high').length,
      critical: methodologies.where((m) => m.riskLevel == 'critical').length,
    );
  }

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  int _getRiskLevelPriority(String riskLevel) {
    switch (riskLevel) {
      case 'critical':
        return 4;
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
        return 1;
      default:
        return 0;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }


  void _handleMenuAction(String action) {
    switch (action) {
      case 'new_template':
        _createNewTemplate();
        break;
      case 'import':
        _importTemplates();
        break;
      case 'export':
        _exportLibrary();
        break;
      case 'settings':
        _openLibrarySettings();
        break;
    }
  }

  void _createNewTemplate() {
    showDialog(
      context: context,
      builder: (context) => MethodologyTemplateEditorDialog(
        isEditMode: true,
        onSave: (methodology) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Template "${methodology.title}" created successfully!')),
          );
          // TODO: Add to methodology service
        },
      ),
    );
  }

  void _openMethodology(MethodologyTemplate template) {
    showDialog(
      context: context,
      builder: (context) => MethodologyTemplateEditorDialog(
        jsonMethodology: template,
        isEditMode: false,
      ),
    );
  }

  void _handleMethodologyAction(String action, MethodologyTemplate methodology) {
    switch (action) {
      case 'view':
        _openMethodology(methodology);
        break;
      case 'edit':
        _editMethodology(methodology);
        break;
      case 'duplicate':
        _duplicateMethodology(methodology);
        break;
      case 'export':
        _exportMethodology(methodology);
        break;
      case 'delete':
        _deleteMethodology(methodology);
        break;
    }
  }

  void _editMethodology(MethodologyTemplate template) {
    showDialog(
      context: context,
      builder: (context) => MethodologyTemplateEditorDialog(
        jsonMethodology: template,
        isEditMode: true,
        onSave: (updatedMethodology) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Template "${updatedMethodology.title}" updated successfully!')),
          );
          // TODO: Update in methodology service
        },
      ),
    );
  }

  void _duplicateMethodology(MethodologyTemplate methodology) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Duplicate methodology coming soon')),
    );
  }

  void _exportMethodology(MethodologyTemplate methodology) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export methodology coming soon')),
    );
  }

  void _deleteMethodology(MethodologyTemplate methodology) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Methodology'),
        content: Text('Are you sure you want to delete "${methodology.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Methodology "${methodology.name}" deleted')),
              );
              // TODO: Delete from methodology service
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _importTemplates() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import templates coming soon')),
    );
  }

  void _exportLibrary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export library coming soon')),
    );
  }

  void _openLibrarySettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Library settings coming soon')),
    );
  }
}

// Supporting classes

class _MethodologyStats {
  final int lowRisk;
  final int mediumRisk;
  final int highRisk;
  final int critical;

  _MethodologyStats({
    required this.lowRisk,
    required this.mediumRisk,
    required this.highRisk,
    required this.critical,
  });
}