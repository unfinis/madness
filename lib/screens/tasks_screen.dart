import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/task_item_widget.dart';
import '../widgets/task_table_widget.dart';
import '../widgets/task_summary_widget.dart';
import '../widgets/task_filters_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
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
        TaskSummaryWidget(projectId: currentProject.id, compact: true),
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
                    'Tasks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: CommonLayoutWidgets.itemSpacing),
                  // Responsive button layout with view toggle
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            if (shouldShowTableToggle) ...[
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
                              const Spacer(),
                            ] else
                              const Spacer(),
                            ..._buildActionButtons(context),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (shouldShowTableToggle) ...[
                              SegmentedButton<bool>(
                                segments: const [
                                  ButtonSegment<bool>(
                                    value: false,
                                    icon: Icon(Icons.view_agenda, size: 16),
                                  ),
                                  ButtonSegment<bool>(
                                    value: true,
                                    icon: Icon(Icons.table_rows, size: 16),
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
                              SizedBox(height: CommonLayoutWidgets.compactSpacing),
                            ],
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
              
              TaskFiltersWidget(searchController: _searchController),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
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


  List<Widget> _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.3;
    
    if (availableWidth > 350) {
      // Wide enough: All buttons in a row with labels
      return [
        OutlinedButton.icon(
          onPressed: () => _exportTasks(context),
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _importTasks(context),
          icon: const Icon(Icons.upload, size: 18),
          label: const Text('Import'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddTaskDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Task'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else if (availableWidth > 250) {
      // Medium width: Icon buttons with tooltips + Add button
      return [
        IconButton.outlined(
          onPressed: () => _exportTasks(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 4),
        IconButton.outlined(
          onPressed: () => _importTasks(context),
          icon: const Icon(Icons.upload, size: 18),
          tooltip: 'Import',
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddTaskDialog(context),
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
        IconButton.outlined(
          onPressed: () => _exportTasks(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 4),
        FilledButton.icon(
          onPressed: () => _showAddTaskDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        ),
      ];
    }
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

  void _exportTasks(BuildContext context) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;
    
    final filteredTasksAsync = ref.read(filteredTasksProvider(currentProject.id));
    
    filteredTasksAsync.whenOrNull(
      data: (filteredTasks) {
        if (filteredTasks.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('No tasks to export'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
            ),
          );
          return;
        }

        // TODO: Implement task export functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export feature coming soon! Found ${filteredTasks.length} tasks to export.'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }

  void _importTasks(BuildContext context) {
    // TODO: Implement task import functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Import feature coming soon!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}