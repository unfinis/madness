import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/storage_provider.dart';
import '../services/methodology_loader.dart';
import '../widgets/common_state_widgets.dart';
import '../dialogs/enhanced_methodology_detail_dialog.dart';
import '../dialogs/methodology_template_editor_dialog.dart';

class EnhancedMethodologyBrowser extends ConsumerStatefulWidget {
  const EnhancedMethodologyBrowser({super.key});

  @override
  ConsumerState<EnhancedMethodologyBrowser> createState() => _EnhancedMethodologyBrowserState();
}

class _EnhancedMethodologyBrowserState extends ConsumerState<EnhancedMethodologyBrowser>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedDifficulty;
  String? _selectedTarget;
  Set<String> _selectedTags = {};
  MethodologySort _sortBy = MethodologySort.name;
  bool _gridView = true;

  // Category definitions
  final Map<String, MethodologyCategory> _categories = {
    'reconnaissance': MethodologyCategory(
      name: 'Reconnaissance',
      icon: Icons.search,
      color: Colors.blue,
      description: 'Information gathering and enumeration',
    ),
    'initial_access': MethodologyCategory(
      name: 'Initial Access',
      icon: Icons.login,
      color: Colors.orange,
      description: 'Gaining initial foothold',
    ),
    'persistence': MethodologyCategory(
      name: 'Persistence',
      icon: Icons.anchor,
      color: Colors.green,
      description: 'Maintaining access',
    ),
    'privilege_escalation': MethodologyCategory(
      name: 'Privilege Escalation',
      icon: Icons.trending_up,
      color: Colors.red,
      description: 'Elevating privileges',
    ),
    'credential_access': MethodologyCategory(
      name: 'Credential Access',
      icon: Icons.key,
      color: Colors.purple,
      description: 'Obtaining credentials',
    ),
    'lateral_movement': MethodologyCategory(
      name: 'Lateral Movement',
      icon: Icons.swap_horiz,
      color: Colors.indigo,
      description: 'Moving through network',
    ),
    'collection': MethodologyCategory(
      name: 'Collection',
      icon: Icons.folder,
      color: Colors.brown,
      description: 'Gathering information',
    ),
    'exfiltration': MethodologyCategory(
      name: 'Exfiltration',
      icon: Icons.upload,
      color: Colors.pink,
      description: 'Data extraction',
    ),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadMethodologiesIfNeeded();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMethodologiesIfNeeded() async {
    try {
      final storage = ref.read(storageServiceProvider);
      final existingTemplates = await storage.getAllTemplates();

      if (existingTemplates.isEmpty) {
        await MethodologyLoader.loadAllMethodologies();
        final jsonMethodologies = MethodologyLoader.getAllMethodologies();

        for (final methodology in jsonMethodologies) {
          await storage.storeTemplate(methodology);
        }
      }
    } catch (e) {
      debugPrint('Error loading methodologies: $e');
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

    final templatesAsync = ref.watch(templateNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Methodology Browser'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_gridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _gridView = !_gridView;
              });
            },
            tooltip: _gridView ? 'List View' : 'Grid View',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(templateNotifierProvider),
            tooltip: 'Refresh',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'new_template',
                child: Row(
                  children: [
                    Icon(Icons.add),
                    SizedBox(width: 8),
                    Text('Create Template'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 8),
                    Text('Import Templates'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.explore), text: 'Browse'),
            Tab(icon: Icon(Icons.category), text: 'Categories'),
            Tab(icon: Icon(Icons.star), text: 'Favorites'),
          ],
        ),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(error),
        data: (methodologies) => TabBarView(
          controller: _tabController,
          children: [
            _buildBrowseTab(methodologies),
            _buildCategoriesTab(methodologies),
            _buildFavoritesTab(methodologies),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text('Error loading methodologies: $error'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.refresh(templateNotifierProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseTab(List<MethodologyTemplate> methodologies) {
    final filteredMethodologies = _applyFilters(methodologies);

    return Column(
      children: [
        // Search and Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search methodologies...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Category Filter
                    PopupMenuButton<String>(
                      child: Chip(
                        label: Text(_selectedCategory ?? 'All Categories'),
                        avatar: const Icon(Icons.category, size: 16),
                        onDeleted: _selectedCategory != null
                            ? () => setState(() => _selectedCategory = null)
                            : null,
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selectedCategory = value == 'all' ? null : value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'all', child: Text('All Categories')),
                        ..._categories.entries.map((e) => PopupMenuItem(
                          value: e.key,
                          child: Row(
                            children: [
                              Icon(e.value.icon, size: 16, color: e.value.color),
                              const SizedBox(width: 8),
                              Text(e.value.name),
                            ],
                          ),
                        )),
                      ],
                    ),

                    const SizedBox(width: 8),

                    // Difficulty Filter
                    PopupMenuButton<String>(
                      child: Chip(
                        label: Text(_selectedDifficulty ?? 'All Levels'),
                        avatar: const Icon(Icons.bar_chart, size: 16),
                        onDeleted: _selectedDifficulty != null
                            ? () => setState(() => _selectedDifficulty = null)
                            : null,
                      ),
                      onSelected: (value) {
                        setState(() {
                          _selectedDifficulty = value == 'all' ? null : value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'all', child: Text('All Levels')),
                        const PopupMenuItem(value: 'beginner', child: Text('Beginner')),
                        const PopupMenuItem(value: 'intermediate', child: Text('Intermediate')),
                        const PopupMenuItem(value: 'advanced', child: Text('Advanced')),
                        const PopupMenuItem(value: 'expert', child: Text('Expert')),
                      ],
                    ),

                    const SizedBox(width: 8),

                    // Sort Option
                    PopupMenuButton<MethodologySort>(
                      child: Chip(
                        label: Text('Sort: ${_sortBy.displayName}'),
                        avatar: const Icon(Icons.sort, size: 16),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _sortBy = value;
                        });
                      },
                      itemBuilder: (context) => MethodologySort.values.map((sort) => PopupMenuItem(
                        value: sort,
                        child: Text(sort.displayName),
                      )).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Results Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                '${filteredMethodologies.length} methodologies',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              if (filteredMethodologies.isNotEmpty)
                Text(
                  _getResultsDescription(filteredMethodologies),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
            ],
          ),
        ),

        // Methodology List/Grid
        Expanded(
          child: filteredMethodologies.isEmpty
              ? _buildEmptyState()
              : _gridView
                  ? _buildMethodologyGrid(filteredMethodologies)
                  : _buildMethodologyList(filteredMethodologies),
        ),
      ],
    );
  }

  Widget _buildCategoriesTab(List<MethodologyTemplate> methodologies) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse by Category',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final entry = _categories.entries.elementAt(index);
              final category = entry.value;
              final categoryKey = entry.key;

              final categoryCount = methodologies.where((m) =>
                _getMethodologyCategory(m) == categoryKey
              ).length;

              return Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = categoryKey;
                      _tabController.animateTo(0); // Switch to browse tab
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          category.color.withValues(alpha: 0.1),
                          category.color.withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                category.icon,
                                color: category.color,
                                size: 24,
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: category.color.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$categoryCount',
                                  style: TextStyle(
                                    color: category.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            category.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            category.description,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab(List<MethodologyTemplate> methodologies) {
    // For now, show recently used or high-priority methodologies
    final favoriteMethodologies = methodologies.where((m) =>
      _getMethodologyPriority(m) <= 3 // High priority
    ).toList();

    return favoriteMethodologies.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_border, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No favorites yet',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mark methodologies as favorites to see them here',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteMethodologies.length,
            itemBuilder: (context, index) {
              return _buildMethodologyCard(favoriteMethodologies[index]);
            },
          );
  }

  Widget _buildMethodologyGrid(List<MethodologyTemplate> methodologies) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: methodologies.length,
      itemBuilder: (context, index) {
        return _buildMethodologyCard(methodologies[index]);
      },
    );
  }

  Widget _buildMethodologyList(List<MethodologyTemplate> methodologies) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: methodologies.length,
      itemBuilder: (context, index) {
        return _buildMethodologyListTile(methodologies[index]);
      },
    );
  }

  Widget _buildMethodologyCard(MethodologyTemplate methodology) {
    final category = _getMethodologyCategory(methodology);
    final categoryInfo = _categories[category];
    final difficulty = _getMethodologyDifficulty(methodology);
    final priority = _getMethodologyPriority(methodology);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showMethodologyDetail(methodology),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with category color
            Container(
              height: 4,
              color: categoryInfo?.color ?? Colors.grey,
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Icon(
                        categoryInfo?.icon ?? Icons.code,
                        size: 16,
                        color: categoryInfo?.color ?? Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          categoryInfo?.name ?? 'Other',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildDifficultyBadge(difficulty),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    methodology.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Description
                  Text(
                    methodology.description,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  // Footer
                  Row(
                    children: [
                      _buildPriorityIndicator(priority),
                      const Spacer(),
                      Text(
                        '${methodology.triggers.length} triggers',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodologyListTile(MethodologyTemplate methodology) {
    final category = _getMethodologyCategory(methodology);
    final categoryInfo = _categories[category];
    final difficulty = _getMethodologyDifficulty(methodology);
    final priority = _getMethodologyPriority(methodology);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: categoryInfo?.color.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.1),
          child: Icon(
            categoryInfo?.icon ?? Icons.code,
            color: categoryInfo?.color ?? Colors.grey,
            size: 20,
          ),
        ),
        title: Text(
          methodology.name,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              methodology.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildDifficultyBadge(difficulty),
                const SizedBox(width: 8),
                _buildPriorityIndicator(priority),
                const SizedBox(width: 8),
                Text(
                  '${methodology.triggers.length} triggers',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => _showMethodologyDetail(methodology),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = Colors.green;
        break;
      case 'intermediate':
        color = Colors.yellow;
        break;
      case 'advanced':
        color = Colors.orange;
        break;
      case 'expert':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(int priority) {
    Color color;
    IconData icon;

    if (priority <= 2) {
      color = Colors.red;
      icon = Icons.priority_high;
    } else if (priority <= 5) {
      color = Colors.orange;
      icon = Icons.warning;
    } else {
      color = Colors.green;
      icon = Icons.check_circle;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 2),
        Text(
          'P$priority',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'No methodologies found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _clearFilters,
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  List<MethodologyTemplate> _applyFilters(List<MethodologyTemplate> methodologies) {
    var filtered = methodologies.where((methodology) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!methodology.name.toLowerCase().contains(query) &&
            !methodology.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (_selectedCategory != null) {
        if (_getMethodologyCategory(methodology) != _selectedCategory) {
          return false;
        }
      }

      // Difficulty filter
      if (_selectedDifficulty != null) {
        if (_getMethodologyDifficulty(methodology).toLowerCase() != _selectedDifficulty) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      switch (_sortBy) {
        case MethodologySort.name:
          return a.name.compareTo(b.name);
        case MethodologySort.category:
          return _getMethodologyCategory(a).compareTo(_getMethodologyCategory(b));
        case MethodologySort.difficulty:
          return _getDifficultyOrder(a).compareTo(_getDifficultyOrder(b));
        case MethodologySort.priority:
          return _getMethodologyPriority(a).compareTo(_getMethodologyPriority(b));
        case MethodologySort.triggers:
          return b.triggers.length.compareTo(a.triggers.length);
      }
    });

    return filtered;
  }

  String _getMethodologyCategory(MethodologyTemplate methodology) {
    // Extract category from tags or infer from name/description
    for (final tag in methodology.tags) {
      if (_categories.containsKey(tag.toLowerCase())) {
        return tag.toLowerCase();
      }
    }

    // Infer from name
    final name = methodology.name.toLowerCase();
    if (name.contains('scan') || name.contains('enum') || name.contains('recon')) {
      return 'reconnaissance';
    } else if (name.contains('access') || name.contains('login') || name.contains('auth')) {
      return 'initial_access';
    } else if (name.contains('cred') || name.contains('password') || name.contains('hash')) {
      return 'credential_access';
    } else if (name.contains('lateral') || name.contains('pivot')) {
      return 'lateral_movement';
    } else if (name.contains('privilege') || name.contains('escalat')) {
      return 'privilege_escalation';
    }

    return 'reconnaissance'; // default
  }

  String _getMethodologyDifficulty(MethodologyTemplate methodology) {
    // Extract from metadata or infer from complexity
    final triggerCount = methodology.triggers.length;
    if (triggerCount <= 2) return 'beginner';
    if (triggerCount <= 5) return 'intermediate';
    if (triggerCount <= 8) return 'advanced';
    return 'expert';
  }

  int _getMethodologyPriority(MethodologyTemplate methodology) {
    // Extract priority from first trigger or default to 5
    if (methodology.triggers.isNotEmpty) {
      final firstTrigger = methodology.triggers.first;
      final conditions = firstTrigger.conditions;
      if (conditions != null && conditions.containsKey('priority')) {
        return conditions['priority'] as int? ?? 5;
      }
    }
    return 5;
  }

  int _getDifficultyOrder(MethodologyTemplate methodology) {
    switch (_getMethodologyDifficulty(methodology).toLowerCase()) {
      case 'beginner': return 1;
      case 'intermediate': return 2;
      case 'advanced': return 3;
      case 'expert': return 4;
      default: return 2;
    }
  }

  String _getResultsDescription(List<MethodologyTemplate> methodologies) {
    if (_selectedCategory != null || _selectedDifficulty != null || _searchQuery.isNotEmpty) {
      return 'Filtered results';
    }
    return 'All methodologies';
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
      _selectedDifficulty = null;
      _selectedTarget = null;
      _selectedTags.clear();
    });
  }

  void _showMethodologyDetail(MethodologyTemplate methodology) {
    showDialog(
      context: context,
      builder: (context) => EnhancedMethodologyDetailDialog(
        methodology: methodology,
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'new_template':
        showDialog(
          context: context,
          builder: (context) => const MethodologyTemplateEditorDialog(),
        );
        break;
      case 'import':
        // Handle import
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Import functionality coming soon')),
        );
        break;
    }
  }
}

// Supporting classes
class MethodologyCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String description;

  const MethodologyCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });
}

enum MethodologySort {
  name,
  category,
  difficulty,
  priority,
  triggers;

  String get displayName {
    switch (this) {
      case MethodologySort.name:
        return 'Name';
      case MethodologySort.category:
        return 'Category';
      case MethodologySort.difficulty:
        return 'Difficulty';
      case MethodologySort.priority:
        return 'Priority';
      case MethodologySort.triggers:
        return 'Triggers';
    }
  }
}