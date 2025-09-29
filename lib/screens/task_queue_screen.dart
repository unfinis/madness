import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_queue_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/task_queue/task_card_widget.dart';
import '../widgets/task_queue/task_stats_widget.dart';
import '../constants/app_spacing.dart';
import '../constants/responsive_breakpoints.dart';

class TaskQueueScreen extends ConsumerStatefulWidget {
  const TaskQueueScreen({super.key});

  @override
  ConsumerState<TaskQueueScreen> createState() => _TaskQueueScreenState();
}

class _TaskQueueScreenState extends ConsumerState<TaskQueueScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);
    final pendingTasks = ref.watch(pendingTasksProvider);
    final activeTasks = ref.watch(activeTasksProvider);
    final completedTasks = ref.watch(completedTasksProvider);

    if (currentProject == null) {
      return const Scaffold(
        body: Center(
          child: Text('No project selected'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Queue'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Pending (${pendingTasks.length})',
              icon: const Icon(Icons.pending_actions),
            ),
            Tab(
              text: 'Active (${activeTasks.length})',
              icon: const Icon(Icons.play_circle),
            ),
            Tab(
              text: 'Completed (${completedTasks.length})',
              icon: const Icon(Icons.check_circle),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Trigger re-evaluation
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'clear_completed':
                  ref.read(taskQueueProvider.notifier).clearCompletedTasks();
                  break;
                case 'export':
                  _exportTasks();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_completed',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Clear Completed'),
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export Tasks'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const TaskStatsWidget(),
          const Divider(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(pendingTasks, TaskStatus.pending),
                _buildTaskList(activeTasks, TaskStatus.inProgress),
                _buildTaskList(completedTasks, TaskStatus.completed),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<TaskInstance> tasks, TaskStatus status) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              _getEmptyMessage(status),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= ResponsiveBreakpoints.desktop;

        if (isDesktop) {
          return _buildDesktopLayout(tasks);
        } else {
          return _buildMobileLayout(tasks);
        }
      },
    );
  }

  Widget _buildDesktopLayout(List<TaskInstance> tasks) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.5,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
        ),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskCardWidget(task: tasks[index]);
        },
      ),
    );
  }

  Widget _buildMobileLayout(List<TaskInstance> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: TaskCardWidget(task: tasks[index]),
        );
      },
    );
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Icons.pending_actions;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.failed:
        return Icons.error;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }

  String _getEmptyMessage(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return 'No pending tasks';
      case TaskStatus.inProgress:
        return 'No active tasks';
      case TaskStatus.completed:
        return 'No completed tasks';
      case TaskStatus.failed:
        return 'No failed tasks';
      case TaskStatus.cancelled:
        return 'No cancelled tasks';
    }
  }

  void _exportTasks() {
    // TODO: Implement task export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality coming soon')),
    );
  }
}