import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/task_table_widget.dart';
import '../widgets/unified_filter/unified_filter.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../constants/app_spacing.dart';
import '../dialogs/add_task_dialog.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  bool _useTableView = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    
    // If no project is selected, show a message
    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }
    
    final filteredTasksAsync = ref.watch(filteredTasksProvider(currentProject.id));
    
    // Auto-enable table view on very wide screens
    final shouldShowTableToggle = screenWidth > 1000;
    if (screenWidth > 1400 && !_useTableView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _useTableView = true;
          });
        }
      });
    }
    
    return ScreenWrapper(
      children: [
        _buildTasksStatsBar(context, currentProject.id),
        const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with responsive buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and main actions are now in the top bar
                  // Keep view toggle here as it's screen-specific
                  if (shouldShowTableToggle)
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment<bool>(
                          value: false,
                          icon: Icon(Icons.view_agenda, size: 16),
                          label: Text('Cards'),
                        ),
                        ButtonSegment<bool>(
                          value: true,
                          icon: Icon(Icons.table_rows, size: 16),
                          label: Text('Table'),
                        ),
                      ],
                      selected: {_useTableView},
                      onSelectionChanged: (selection) {
                        setState(() {
                          _useTableView = selection.first;
                        });
                      },
                      style: SegmentedButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              UnifiedFilterBar(
                searchController: _searchController,
                searchHint: 'Search tasks, descriptions, assignees...',
                primaryFilters: _buildPrimaryFilters(),
                advancedFilters: _buildAdvancedFilters(),
                advancedFiltersTitle: 'Task Filters',
                onSearchChanged: (value) {
                  ref.read(taskFiltersProvider.notifier).updateSearchQuery(value);
                },
                onSearchCleared: () {
                  ref.read(taskFiltersProvider.notifier).updateSearchQuery('');
                },
                onAdvancedFiltersChanged: () {
                  // Advanced filter changes are handled by individual filter callbacks
                },
                activeFilterCount: _getActiveFilterCount(),
                resultCount: filteredTasksAsync.value?.length,
              ),
              const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              filteredTasksAsync.when(
                data: (filteredTasks) {
                  if (filteredTasks.isEmpty) {
                    return CommonStateWidgets.noData(
                      itemName: 'tasks',
                      icon: Icons.task_alt_outlined,
                      onCreate: () => _showAddTaskDialog(context),
                      createButtonText: 'Add First Task',
                    );
                  } else if (_useTableView && shouldShowTableToggle) {
                    return TaskTableWidget(tasks: filteredTasks, projectId: currentProject.id);
                  } else {
                    return _buildTasksList(filteredTasks);
                  }
                },
                loading: () => CommonStateWidgets.loadingWithPadding(),
                error: (error, stackTrace) => CommonStateWidgets.error(
                  'Error loading tasks: $error',
                  onRetry: () => ref.refresh(filteredTasksProvider(currentProject.id)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildTasksList(List<Task> tasks) {
    final sortedTasks = [...tasks];

    return Column(
      children: sortedTasks.asMap().entries.map((entry) {
        final index = entry.key;
        final task = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < sortedTasks.length - 1 ? CommonLayoutWidgets.itemSpacing : 0),
          child: TaskItemWidget(task: task),
        );
      }).toList(),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddTaskDialog(),
    );
  }



  Widget _buildTasksStatsBar(BuildContext context, String projectId) {
    final tasksAsync = ref.watch(filteredTasksProvider(projectId));

    return tasksAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: const Text('Error loading tasks'),
      ),
      data: (tasks) {
        final stats = _calculateTaskStats(tasks);

        final statsData = [
          StatData(
            label: 'Total',
            count: stats.total,
            icon: Icons.task_alt,
            color: Theme.of(context).colorScheme.primary,
          ),
          StatData(
            label: 'Pending',
            count: stats.pending,
            icon: Icons.radio_button_unchecked,
            color: Colors.orange,
          ),
          StatData(
            label: 'In Progress',
            count: stats.inProgress,
            icon: Icons.access_time,
            color: Colors.blue,
          ),
          StatData(
            label: 'Completed',
            count: stats.completed,
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          StatData(
            label: 'High Priority',
            count: stats.highPriority,
            icon: Icons.priority_high,
            color: Colors.red,
          ),
          StatData(
            label: 'Overdue',
            count: stats.overdue,
            icon: Icons.warning,
            color: Colors.deepOrange,
          ),
        ];

        return StandardStatsBar(chips: StatsHelper.buildChips(statsData));
      },
    );
  }


  TaskStats _calculateTaskStats(List<Task> tasks) {
    final now = DateTime.now();
    final pending = tasks.where((t) => t.status == TaskStatus.pending).length;
    final inProgress = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final completed = tasks.where((t) => t.status == TaskStatus.completed).length;
    final highPriority = tasks.where((t) => t.priority == TaskPriority.high).length;
    final overdue = tasks.where((t) => t.dueDate != null && t.dueDate!.isBefore(now) && t.status != TaskStatus.completed).length;

    return TaskStats(
      total: tasks.length,
      pending: pending,
      inProgress: inProgress,
      completed: completed,
      highPriority: highPriority,
      overdue: overdue,
    );
  }

  /// Build primary filters (most important ones shown on mobile)
  List<PrimaryFilter> _buildPrimaryFilters() {
    final filters = ref.watch(taskFiltersProvider);
    final statusFilters = _getStatusFilters(filters.activeFilters);
    final priorityFilters = _getPriorityFilters(filters.activeFilters);

    return [
      // Status filter (most important for tasks)
      PrimaryFilter(
        label: 'Status: ${_getStatusLabel(statusFilters)}',
        isSelected: statusFilters.isNotEmpty,
        onPressed: () => _showStatusOptions(),
        icon: Icons.task_alt,
        badge: statusFilters.length > 1 ? statusFilters.length.toString() : null,
      ),

      // Priority filter (second most important)
      PrimaryFilter(
        label: 'Priority: ${_getPriorityLabel(priorityFilters)}',
        isSelected: priorityFilters.isNotEmpty,
        onPressed: () => _showPriorityOptions(),
        icon: Icons.priority_high,
        badge: priorityFilters.length > 1 ? priorityFilters.length.toString() : null,
      ),
    ];
  }

  /// Build advanced filters for bottom sheet
  List<FilterSection> _buildAdvancedFilters() {
    final filters = ref.watch(taskFiltersProvider);

    return [
      // Status Section
      FilterSection(
        title: 'Status',
        icon: Icons.task_alt,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Pending',
                isSelected: filters.activeFilters.contains(TaskFilter.pending),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.pending),
                icon: Icons.radio_button_unchecked,
              ),
              StandardFilterChip(
                label: 'In Progress',
                isSelected: filters.activeFilters.contains(TaskFilter.inProgress),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.inProgress),
                icon: Icons.access_time,
              ),
              StandardFilterChip(
                label: 'Urgent',
                isSelected: filters.activeFilters.contains(TaskFilter.urgent),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.urgent),
                icon: Icons.warning,
              ),
              StandardFilterChip(
                label: 'Completed',
                isSelected: filters.activeFilters.contains(TaskFilter.completed),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.completed),
                icon: Icons.check_circle,
              ),
            ],
          ),
        ],
      ),

      // Priority Section
      FilterSection(
        title: 'Priority',
        icon: Icons.priority_high,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'High',
                isSelected: filters.activeFilters.contains(TaskFilter.high),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.high),
                icon: Icons.keyboard_double_arrow_up,
              ),
              StandardFilterChip(
                label: 'Medium',
                isSelected: filters.activeFilters.contains(TaskFilter.medium),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.medium),
                icon: Icons.keyboard_arrow_up,
              ),
              StandardFilterChip(
                label: 'Low',
                isSelected: filters.activeFilters.contains(TaskFilter.low),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.low),
                icon: Icons.keyboard_arrow_down,
              ),
            ],
          ),
        ],
      ),

      // Category Section
      FilterSection(
        title: 'Category',
        icon: Icons.category,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Admin',
                isSelected: filters.activeFilters.contains(TaskFilter.admin),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.admin),
                icon: Icons.admin_panel_settings,
              ),
              StandardFilterChip(
                label: 'Legal',
                isSelected: filters.activeFilters.contains(TaskFilter.legal),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.legal),
                icon: Icons.gavel,
              ),
              StandardFilterChip(
                label: 'Setup',
                isSelected: filters.activeFilters.contains(TaskFilter.setup),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.setup),
                icon: Icons.build,
              ),
              StandardFilterChip(
                label: 'Communication',
                isSelected: filters.activeFilters.contains(TaskFilter.communication),
                onPressed: () => ref.read(taskFiltersProvider.notifier).toggleFilter(TaskFilter.communication),
                icon: Icons.chat,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  // Filter helper methods
  Set<TaskFilter> _getStatusFilters(Set<TaskFilter> activeFilters) {
    return activeFilters.where((filter) => [
      TaskFilter.pending,
      TaskFilter.inProgress,
      TaskFilter.urgent,
      TaskFilter.completed,
    ].contains(filter)).toSet();
  }

  Set<TaskFilter> _getPriorityFilters(Set<TaskFilter> activeFilters) {
    return activeFilters.where((filter) => [
      TaskFilter.low,
      TaskFilter.medium,
      TaskFilter.high,
    ].contains(filter)).toSet();
  }

  String _getStatusLabel(Set<TaskFilter> statusFilters) {
    if (statusFilters.isEmpty) return 'All';
    if (statusFilters.length == 1) {
      final filter = statusFilters.first;
      switch (filter) {
        case TaskFilter.pending: return 'Pending';
        case TaskFilter.inProgress: return 'In Progress';
        case TaskFilter.urgent: return 'Urgent';
        case TaskFilter.completed: return 'Completed';
        default: return 'All';
      }
    }
    return 'Multiple (${statusFilters.length})';
  }

  String _getPriorityLabel(Set<TaskFilter> priorityFilters) {
    if (priorityFilters.isEmpty) return 'All';
    if (priorityFilters.length == 1) {
      final filter = priorityFilters.first;
      switch (filter) {
        case TaskFilter.high: return 'High';
        case TaskFilter.medium: return 'Medium';
        case TaskFilter.low: return 'Low';
        default: return 'All';
      }
    }
    return 'Multiple (${priorityFilters.length})';
  }

  int _getActiveFilterCount() {
    final filters = ref.read(taskFiltersProvider);
    // Don't count 'all' as an active filter
    return filters.activeFilters.contains(TaskFilter.all) ? 0 : filters.activeFilters.length;
  }

  void _showStatusOptions() {
    // Show quick status filter options
    final notifier = ref.read(taskFiltersProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.radio_button_unchecked, color: Colors.orange),
              title: const Text('Pending'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.pending);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.blue),
              title: const Text('In Progress'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.inProgress);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: const Text('Urgent'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.urgent);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Completed'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.completed);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPriorityOptions() {
    // Show quick priority filter options
    final notifier = ref.read(taskFiltersProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.keyboard_double_arrow_up, color: Colors.red),
              title: const Text('High Priority'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.high);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_arrow_up, color: Colors.orange),
              title: const Text('Medium Priority'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.medium);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.keyboard_arrow_down, color: Colors.green),
              title: const Text('Low Priority'),
              onTap: () {
                notifier.toggleFilter(TaskFilter.low);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class TaskStats {
  final int total;
  final int pending;
  final int inProgress;
  final int completed;
  final int highPriority;
  final int overdue;

  TaskStats({
    required this.total,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.highPriority,
    required this.overdue,
  });
}