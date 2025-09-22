import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/attack_plan_provider.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../models/attack_plan_action.dart';
import '../dialogs/attack_plan_action_detail_dialog.dart';

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
              initialValue: _selectedFilter,
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
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return const SizedBox();

    final actionsAsync = ref.watch(attackPlanActionsProvider(currentProject.id));

    return actionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red[400]),
            const SizedBox(height: AppSpacing.md),
            Text('Error loading actions: $error'),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: () => ref.refresh(attackPlanActionsProvider(currentProject.id)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (allActions) {
        List<AttackPlanAction> filteredActions;

        switch (filter) {
          case 'pending':
            filteredActions = allActions.where((a) => a.status == ActionStatus.pending).toList();
            break;
          case 'in_progress':
            filteredActions = allActions.where((a) => a.status == ActionStatus.inProgress).toList();
            break;
          case 'completed':
            filteredActions = allActions.where((a) => a.status == ActionStatus.completed).toList();
            break;
          default:
            filteredActions = allActions;
        }

        // Apply search filter
        if (_searchQuery.isNotEmpty) {
          filteredActions = filteredActions.where((action) {
            final query = _searchQuery.toLowerCase();
            return action.title.toLowerCase().contains(query) ||
                action.objective.toLowerCase().contains(query) ||
                action.tags.any((tag) => tag.toLowerCase().contains(query));
          }).toList();
        }

        // Apply priority filter
        if (_selectedFilter != 'all') {
          final priority = ActionPriority.values.where((p) => p.name == _selectedFilter).firstOrNull;
          if (priority != null) {
            filteredActions = filteredActions.where((a) => a.priority == priority).toList();
          }
        }

        if (filteredActions.isEmpty && allActions.isEmpty) {
          return _buildEmptyState(filter);
        }

        if (filteredActions.isEmpty) {
          return _buildNoResultsState(filter);
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.md),
          itemCount: filteredActions.length,
          itemBuilder: (context, index) {
            final action = filteredActions[index];
            return _buildActionCard(action);
          },
        );
      },
    );
  }

  Widget _buildEmptyState(String filter) {
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

  Widget _buildNoResultsState(String filter) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No actions match your current filters',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Try adjusting your search or filter criteria.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(AttackPlanAction action) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: () => _showActionDetail(action),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      action.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(action.status),
                  const SizedBox(width: AppSpacing.sm),
                  _buildPriorityChip(action.priority),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                action.objective,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.security, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Risk: ${action.riskLevel.displayName}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  if (action.triggerEvents.length > 1) ...[
                    Icon(Icons.merge_type, size: 16, color: Colors.blue[600]),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      '${action.triggerEvents.length} triggers',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                  ],
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Created: ${action.createdAt.toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              if (action.tags.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: action.tags.take(3).map((tag) => Chip(
                    label: Text(tag, style: const TextStyle(fontSize: 10)),
                    backgroundColor: Colors.grey[200],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(ActionStatus status) {
    Color color;
    switch (status) {
      case ActionStatus.pending:
        color = Colors.orange;
        break;
      case ActionStatus.inProgress:
        color = Colors.blue;
        break;
      case ActionStatus.completed:
        color = Colors.green;
        break;
      case ActionStatus.blocked:
        color = Colors.red;
        break;
      case ActionStatus.skipped:
        color = Colors.grey;
        break;
    }

    return Chip(
      label: Text(
        status.displayName,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildPriorityChip(ActionPriority priority) {
    Color color;
    switch (priority) {
      case ActionPriority.critical:
        color = Colors.red[700]!;
        break;
      case ActionPriority.high:
        color = Colors.orange[700]!;
        break;
      case ActionPriority.medium:
        color = Colors.yellow[700]!;
        break;
      case ActionPriority.low:
        color = Colors.blue[700]!;
        break;
    }

    return Chip(
      label: Text(
        priority.displayName,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  void _showActionDetail(AttackPlanAction action) {
    showDialog(
      context: context,
      builder: (context) => AttackPlanActionDetailDialog(action: action),
    );
  }

  Future<void> _generateNewActions(String projectId) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Generating methodology actions...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Get all assets for the project
      final assets = await ref.read(assetsProvider(projectId).future);
      print('AttackPlanScreen: Found ${assets.length} assets for project $projectId');

      if (assets.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No assets found. Please add some assets first.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Generate actions from assets
      print('AttackPlanScreen: Calling generateActionsFromAssets with ${assets.length} assets');
      for (int i = 0; i < assets.length; i++) {
        final asset = assets[i];
        print('AttackPlanScreen: Asset $i: ${asset.name} (${asset.type.name}) with properties: ${asset.properties.keys.toList()}');
      }

      final actionsNotifier = ref.read(attackPlanActionsProvider(projectId).notifier);
      await actionsNotifier.generateActionsFromAssets(assets);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Actions generated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating actions: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
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