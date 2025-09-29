import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/unified_methodology_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../constants/app_spacing.dart';
import '../dialogs/methodology_template_editor_dialog.dart';
import '../dialogs/methodology_details_dialog.dart';
import '../widgets/methodology_template_card.dart';
import '../services/methodology_loader.dart' as loader;

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

  @override
  void initState() {
    super.initState();
    // Initialize filters once in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateFilters();
    });
  }

  void _updateFilters() {
    ref.read(methodologySearchFiltersProvider.notifier).update((state) => {
      'query': _searchQuery,
      'tags': _selectedTag != null ? [_selectedTag!] : <String>[],
      'riskLevel': _selectedRiskLevel == 'all' ? null : _selectedRiskLevel,
      'workstream': null,
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

    // Remove the problematic WidgetsBinding.instance.addPostFrameCallback from here!

    // Watch all templates
    final allTemplatesAsync = ref.watch(allMethodologyTemplatesProvider);

    return allTemplatesAsync.when(
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
                onPressed: () => ref.refresh(allMethodologyTemplatesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      data: (allMethodologies) {
        // Use local filtering instead of async provider to avoid rebuild cycles
        final filteredMethodologies = _applyLocalFilters(allMethodologies);
        final allTags = _getAllTags(allMethodologies);
        final stats = _calculateStats(allMethodologies);

        return _buildLibraryContent(filteredMethodologies, allTags, allMethodologies, stats);
      },
    );
  }

  Widget _buildLibraryContent(List<loader.MethodologyTemplate> filteredMethodologies, List<String> allTags, List<loader.MethodologyTemplate> allMethodologies, _MethodologyStats stats) {
    return Scaffold(
      body: Column(
        children: [
          _buildStatsBar(filteredMethodologies, allMethodologies, stats),
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

  // Add local filtering method that doesn't depend on async provider
  List<loader.MethodologyTemplate> _applyLocalFilters(List<loader.MethodologyTemplate> methodologies) {
    var filtered = methodologies;

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((m) =>
        m.name.toLowerCase().contains(query) ||
        m.description.toLowerCase().contains(query) ||
        m.tags.any((t) => t.toLowerCase().contains(query))
      ).toList();
    }

    // Apply tag filter
    if (_selectedTag != null) {
      filtered = filtered.where((m) => m.tags.contains(_selectedTag)).toList();
    }

    // Apply risk level filter
    if (_selectedRiskLevel != 'all') {
      filtered = filtered.where((m) => m.riskLevel == _selectedRiskLevel).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'name':
          return a.name.compareTo(b.name);
        case 'risk':
          return _getRiskPriority(a.riskLevel).compareTo(_getRiskPriority(b.riskLevel));
        case 'created':
          return b.created.compareTo(a.created);
        case 'updated':
          return b.modified.compareTo(a.modified);
        default:
          return a.name.compareTo(b.name);
      }
    });

    return filtered;
  }

  int _getRiskPriority(String riskLevel) {
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

  Widget _buildStatsBar(List<loader.MethodologyTemplate> filtered, List<loader.MethodologyTemplate> total, _MethodologyStats stats) {

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
                  decoration: InputDecoration(
                    hintText: 'Search methodologies...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _updateFilters();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    // Debounce the filter update
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (_searchQuery == value) {
                        _updateFilters();
                      }
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
                  decoration: InputDecoration(
                    hintText: 'Search methodologies by title, ID, or tags...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _updateFilters();
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    // Debounce the filter update
                    Future.delayed(const Duration(milliseconds: 300), () {
                      if (_searchQuery == value) {
                        _updateFilters();
                      }
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
      initialValue: _selectedRiskLevel,
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
          _updateFilters(); // Update filters when risk level changes
        });
      },
    );
  }

  Widget _buildSortByFilter() {
    return DropdownButtonFormField<String>(
      initialValue: _sortBy,
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

  Widget _buildTagCloud(List<String> allTags, List<loader.MethodologyTemplate> methodologies) {
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
                      _updateFilters(); // Update filters when clearing tag filter
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
                    _updateFilters(); // Update filters when tag selection changes
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

  Widget _buildMethodologyGrid(List<loader.MethodologyTemplate> methodologies) {
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

  Widget _buildMethodologyCard(loader.MethodologyTemplate methodology) {
    return MethodologyTemplateCard(
      template: methodology,
      onTap: () => _openMethodology(methodology),
      onExecute: null, // Enable when ready for execution
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

  // Filtering is now handled by the unified provider

  List<String> _getAllTags(List<loader.MethodologyTemplate> methodologies) {
    final allTags = <String>{};
    for (final methodology in methodologies) {
      allTags.addAll(methodology.tags);
    }
    return allTags.toList()..sort();
  }

  _MethodologyStats _calculateStats(List<loader.MethodologyTemplate> methodologies) {
    return _MethodologyStats(
      lowRisk: methodologies.where((m) => m.riskLevel == 'low').length,
      mediumRisk: methodologies.where((m) => m.riskLevel == 'medium').length,
      highRisk: methodologies.where((m) => m.riskLevel == 'high').length,
      critical: methodologies.where((m) => m.riskLevel == 'critical').length,
    );
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

  void _openMethodology(loader.MethodologyTemplate template) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => MethodologyDetailsDialog(
        template: template,
        canExecute: false, // Set to true when execution is enabled
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