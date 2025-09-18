import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/task.dart';
import '../database/database.dart';
import 'database_provider.dart';

enum TaskFilter {
  all,
  admin,
  legal,
  setup,
  communication,
  pending,
  inProgress,
  urgent,
  completed,
  low,
  medium,
  high,
}

class TaskFilters {
  final Set<TaskFilter> activeFilters;
  final String searchQuery;

  TaskFilters({
    Set<TaskFilter>? activeFilters,
    this.searchQuery = '',
  }) : activeFilters = activeFilters ?? {TaskFilter.all};

  TaskFilters copyWith({
    Set<TaskFilter>? activeFilters,
    String? searchQuery,
  }) {
    return TaskFilters(
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get showAll => activeFilters.contains(TaskFilter.all);
  bool get hasSearch => searchQuery.isNotEmpty;
}

class TaskNotifier extends StateNotifier<AsyncValue<List<Task>>> {
  final MadnessDatabase _database;
  final String _projectId;

  TaskNotifier(this._database, this._projectId) : super(const AsyncValue.loading()) {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await _database.getAllTasks(_projectId);
      state = AsyncValue.data(tasks);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addTask(Task task) async {
    try {
      await _database.insertTask(task, _projectId);
      await _loadTasks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateTask(Task task) async {
    try {
      await _database.updateTask(task, _projectId);
      await _loadTasks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _database.deleteTask(id);
      await _loadTasks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markTaskCompleted(String id) async {
    final currentState = state.value;
    if (currentState == null) return;

    final taskToUpdate = currentState.firstWhere((task) => task.id == id);
    final updatedTask = taskToUpdate.copyWith(
      status: TaskStatus.completed,
      progress: 100,
      completedDate: DateTime.now(),
    );
    
    await updateTask(updatedTask);
  }

  Future<void> bulkMarkCompleted(List<String> taskIds) async {
    final currentState = state.value;
    if (currentState == null) return;

    final now = DateTime.now();
    
    try {
      for (final taskId in taskIds) {
        final taskToUpdate = currentState.firstWhere((task) => task.id == taskId);
        final updatedTask = taskToUpdate.copyWith(
          status: TaskStatus.completed,
          progress: 100,
          completedDate: now,
        );
        await _database.updateTask(updatedTask, _projectId);
      }
      await _loadTasks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> bulkDelete(List<String> taskIds) async {
    try {
      for (final taskId in taskIds) {
        await _database.deleteTask(taskId);
      }
      await _loadTasks();
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void refresh() {
    _loadTasks();
  }
}

class TaskFiltersNotifier extends StateNotifier<TaskFilters> {
  TaskFiltersNotifier() : super(TaskFilters());

  void toggleFilter(TaskFilter filter) {
    final currentFilters = Set<TaskFilter>.from(state.activeFilters);
    
    if (filter == TaskFilter.all) {
      state = TaskFilters(activeFilters: {TaskFilter.all});
      return;
    }

    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
      if (currentFilters.isEmpty) {
        currentFilters.add(TaskFilter.all);
      }
    } else {
      currentFilters.remove(TaskFilter.all);
      currentFilters.add(filter);
    }
    
    state = TaskFilters(activeFilters: currentFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = TaskFilters();
  }
}

final taskProvider = StateNotifierProvider.family<TaskNotifier, AsyncValue<List<Task>>, String>((ref, projectId) {
  final database = ref.watch(databaseProvider);
  return TaskNotifier(database, projectId);
});

final taskFiltersProvider = StateNotifierProvider<TaskFiltersNotifier, TaskFilters>((ref) {
  return TaskFiltersNotifier();
});

final filteredTasksProvider = Provider.family<AsyncValue<List<Task>>, String>((ref, projectId) {
  final tasksAsync = ref.watch(taskProvider(projectId));
  final filters = ref.watch(taskFiltersProvider);

  return tasksAsync.when(
    data: (tasks) {
      var filtered = tasks.where((task) {
    // Search filter
    if (filters.hasSearch) {
      final query = filters.searchQuery.toLowerCase();
      final matchesSearch = task.title.toLowerCase().contains(query) ||
          (task.description?.toLowerCase().contains(query) ?? false) ||
          (task.assignedTo?.toLowerCase().contains(query) ?? false) ||
          task.category.displayName.toLowerCase().contains(query) ||
          task.status.displayName.toLowerCase().contains(query) ||
          task.priority.displayName.toLowerCase().contains(query);
      
      if (!matchesSearch) return false;
    }

    // Category filters
    if (filters.showAll) return true;

    bool matchesCategory = true;
    if (filters.activeFilters.contains(TaskFilter.admin)) {
      matchesCategory = task.category == TaskCategory.admin;
    } else if (filters.activeFilters.contains(TaskFilter.legal)) {
      matchesCategory = task.category == TaskCategory.legal;
    } else if (filters.activeFilters.contains(TaskFilter.setup)) {
      matchesCategory = task.category == TaskCategory.setup;
    } else if (filters.activeFilters.contains(TaskFilter.communication)) {
      matchesCategory = task.category == TaskCategory.communication;
    }

    bool matchesStatus = true;
    if (filters.activeFilters.contains(TaskFilter.pending)) {
      matchesStatus = task.status == TaskStatus.pending;
    } else if (filters.activeFilters.contains(TaskFilter.inProgress)) {
      matchesStatus = task.status == TaskStatus.inProgress;
    } else if (filters.activeFilters.contains(TaskFilter.urgent)) {
      matchesStatus = task.status == TaskStatus.urgent;
    } else if (filters.activeFilters.contains(TaskFilter.completed)) {
      matchesStatus = task.status == TaskStatus.completed;
    }

    bool matchesPriority = true;
    if (filters.activeFilters.contains(TaskFilter.low)) {
      matchesPriority = task.priority == TaskPriority.low;
    } else if (filters.activeFilters.contains(TaskFilter.medium)) {
      matchesPriority = task.priority == TaskPriority.medium;
    } else if (filters.activeFilters.contains(TaskFilter.high)) {
      matchesPriority = task.priority == TaskPriority.high;
    }

    return matchesCategory && matchesStatus && matchesPriority;
  }).toList();

  // Sort by priority (high first), then by due date
  filtered.sort((a, b) {
    // Completed tasks go to bottom
    if (a.status == TaskStatus.completed && b.status != TaskStatus.completed) return 1;
    if (b.status == TaskStatus.completed && a.status != TaskStatus.completed) return -1;
    
    // Then by overdue status
    if (a.isOverdue && !b.isOverdue) return -1;
    if (b.isOverdue && !a.isOverdue) return 1;
    
    // Then by priority
    final priorityOrder = {TaskPriority.high: 0, TaskPriority.medium: 1, TaskPriority.low: 2};
    final priorityComparison = priorityOrder[a.priority]!.compareTo(priorityOrder[b.priority]!);
    if (priorityComparison != 0) return priorityComparison;
    
    // Finally by due date
    if (a.dueDate == null && b.dueDate == null) return 0;
    if (a.dueDate == null) return 1;
    if (b.dueDate == null) return -1;
    return a.dueDate!.compareTo(b.dueDate!);
      });
      
      return AsyncValue.data(filtered);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final taskSummaryProvider = Provider.family<Map<String, int>, String>((ref, projectId) {
  final tasksAsync = ref.watch(taskProvider(projectId));

  return tasksAsync.when(
    data: (tasks) {
      int totalTasks = tasks.length;
      int urgentTasks = tasks.where((task) => task.status == TaskStatus.urgent).length;
      int inProgressTasks = tasks.where((task) => task.status == TaskStatus.inProgress).length;
      int completedTasks = tasks.where((task) => task.status == TaskStatus.completed).length;
      int overdueTasks = tasks.where((task) => task.isOverdue).length;

      return {
        'total': totalTasks,
        'urgent': urgentTasks,
        'inProgress': inProgressTasks,
        'completed': completedTasks,
        'overdue': overdueTasks,
      };
    },
    loading: () => {
      'total': 0,
      'urgent': 0,
      'inProgress': 0,
      'completed': 0,
      'overdue': 0,
    },
    error: (error, stackTrace) => {
      'total': 0,
      'urgent': 0,
      'inProgress': 0,
      'completed': 0,
      'overdue': 0,
    },
  );
});