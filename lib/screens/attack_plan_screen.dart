import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';

class AttackPlanScreen extends ConsumerStatefulWidget {
  const AttackPlanScreen({super.key});

  @override
  ConsumerState<AttackPlanScreen> createState() => _AttackPlanScreenState();
}

class _AttackPlanScreenState extends ConsumerState<AttackPlanScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attack Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh actions
            },
            tooltip: 'Refresh Actions',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'generate_actions',
                child: ListTile(
                  leading: Icon(Icons.auto_fix_high),
                  title: Text('Generate New Actions'),
                ),
              ),
              const PopupMenuItem(
                value: 'export_plan',
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('Export Plan'),
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Plan Settings'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'All Actions'),
            Tab(icon: Icon(Icons.schedule), text: 'Pending'),
            Tab(icon: Icon(Icons.play_arrow), text: 'In Progress'),
            Tab(icon: Icon(Icons.check_circle), text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search and filter bar
          _buildSearchAndFilterBar(),

          // Content tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActionsTab('all'),
                _buildActionsTab('pending'),
                _buildActionsTab('in_progress'),
                _buildActionsTab('completed'),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _generateNewActions(currentProject.id),
        icon: const Icon(Icons.auto_fix_high),
        label: const Text('Generate Actions'),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Search bar
          Expanded(
            flex: 2,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search actions...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // Priority filter
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedFilter,
              decoration: InputDecoration(
                labelText: 'Priority',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Priorities')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedFilter = value ?? 'all';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsTab(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assignment_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            filter == 'all' ? 'No actions generated yet' : 'No ${filter.replaceAll('_', ' ')} actions',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Click "Generate Actions" to create methodology actions based on your assets and triggers.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () {
              final currentProject = ref.read(currentProjectProvider);
              if (currentProject != null) {
                _generateNewActions(currentProject.id);
              }
            },
            icon: const Icon(Icons.auto_fix_high),
            label: const Text('Generate Actions'),
          ),
        ],
      ),
    );
  }

  Future<void> _generateNewActions(String projectId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating methodology actions...'),
      ),
    );

    // TODO: Implement action generation
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Action generation coming soon...'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'generate_actions':
        final currentProject = ref.read(currentProjectProvider);
        if (currentProject != null) {
          _generateNewActions(currentProject.id);
        }
        break;
      case 'export_plan':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export plan coming soon...')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plan settings coming soon...')),
        );
        break;
    }
  }
}