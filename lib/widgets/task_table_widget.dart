import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTableWidget extends ConsumerStatefulWidget {
  final List<Task> tasks;
  final String projectId;

  const TaskTableWidget({
    super.key,
    required this.tasks,
    required this.projectId,
  });

  @override
  ConsumerState<TaskTableWidget> createState() => _TaskTableWidgetState();
}

class _TaskTableWidgetState extends ConsumerState<TaskTableWidget> {
  final Set<String> _selectedTasks = {};
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedTasks.isNotEmpty) _buildBulkActions(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width - 80,
            ),
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainer,
              ),
              columns: [
                DataColumn(
                  label: Checkbox(
                    value: _selectAll,
                    onChanged: _toggleSelectAll,
                    tristate: true,
                  ),
                ),
                const DataColumn(
                  label: Text('Task'),
                ),
                const DataColumn(
                  label: Text('Category'),
                ),
                const DataColumn(
                  label: Text('Status'),
                ),
                const DataColumn(
                  label: Text('Priority'),
                ),
                const DataColumn(
                  label: Text('Assigned'),
                ),
                const DataColumn(
                  label: Text('Due Date'),
                ),
                const DataColumn(
                  label: Text('Progress'),
                ),
                const DataColumn(
                  label: Text('Actions'),
                ),
              ],
              rows: widget.tasks.map((task) => _buildTaskRow(task)).toList(),
            ),
          ),
        ),
      ],
    );
  }

  DataRow _buildTaskRow(Task task) {
    final isSelected = _selectedTasks.contains(task.id);
    final isOverdue = task.isOverdue;
    final isDueSoon = task.isDueSoon;
    final isCompleted = task.status == TaskStatus.completed;

    return DataRow(
      selected: isSelected,
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (isCompleted) {
          return Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5);
        }
        if (isOverdue) {
          return Theme.of(context).colorScheme.errorContainer.withOpacity(0.3);
        }
        if (isDueSoon) {
          return Theme.of(context).colorScheme.tertiaryContainer.withOpacity(0.3);
        }
        return null;
      }),
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (value) => _toggleTaskSelection(task.id),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted ? Theme.of(context).colorScheme.outline : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (task.description != null) ...[
                const SizedBox(height: 2),
                Text(
                  task.description!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task.category.icon),
              const SizedBox(width: 4),
              Text(task.category.displayName),
            ],
          ),
        ),
        DataCell(
          _buildStatusChip(task.status),
        ),
        DataCell(
          _buildPriorityChip(task.priority),
        ),
        DataCell(
          Text(task.assignedTo ?? 'Unassigned'),
        ),
        DataCell(
          task.dueDate != null
              ? Text(
                  DateFormat('dd/MM/yyyy').format(task.dueDate!),
                  style: TextStyle(
                    color: isOverdue
                        ? Theme.of(context).colorScheme.error
                        : isDueSoon
                            ? Theme.of(context).colorScheme.tertiary
                            : null,
                    fontWeight: (isOverdue || isDueSoon) ? FontWeight.w500 : null,
                  ),
                )
              : const Text('-'),
        ),
        DataCell(
          _buildProgressIndicator(task),
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            onPressed: task.status == TaskStatus.completed
                ? null
                : () => _markTaskCompleted(task.id),
            tooltip: task.status == TaskStatus.completed
                ? 'Already completed'
                : 'Mark as completed',
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(TaskStatus status) {
    Color color;
    switch (status) {
      case TaskStatus.completed:
        color = Colors.green;
        break;
      case TaskStatus.urgent:
        color = Theme.of(context).colorScheme.error;
        break;
      case TaskStatus.inProgress:
        color = Theme.of(context).colorScheme.tertiary;
        break;
      case TaskStatus.pending:
        color = Theme.of(context).colorScheme.outline;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(status.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            status.displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority) {
    Color color;
    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        break;
      case TaskPriority.low:
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(priority.icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            priority.displayName,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(Task task) {
    if (task.status == TaskStatus.completed) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 16),
          SizedBox(width: 4),
          Text('100%', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 60,
          child: LinearProgressIndicator(
            value: task.progress / 100,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              task.progress > 80
                  ? Colors.green
                  : task.progress > 50
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text('${task.progress}%'),
      ],
    );
  }

  Widget _buildBulkActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            '${_selectedTasks.length} task${_selectedTasks.length == 1 ? '' : 's'} selected',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: _bulkMarkCompleted,
            icon: const Icon(Icons.check_circle_outline, size: 16),
            label: const Text('Mark Complete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
              side: BorderSide(color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: _bulkDelete,
            icon: const Icon(Icons.delete_outline, size: 16),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              side: BorderSide(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      if (value == true) {
        _selectedTasks.addAll(widget.tasks.map((task) => task.id));
        _selectAll = true;
      } else {
        _selectedTasks.clear();
        _selectAll = false;
      }
    });
  }

  void _toggleTaskSelection(String taskId) {
    setState(() {
      if (_selectedTasks.contains(taskId)) {
        _selectedTasks.remove(taskId);
      } else {
        _selectedTasks.add(taskId);
      }
      _selectAll = _selectedTasks.length == widget.tasks.length;
    });
  }

  void _markTaskCompleted(String taskId) {
    ref.read(taskProvider(widget.projectId).notifier).markTaskCompleted(taskId);
    setState(() {
      _selectedTasks.remove(taskId);
    });
  }

  void _bulkMarkCompleted() {
    ref.read(taskProvider(widget.projectId).notifier).bulkMarkCompleted(_selectedTasks.toList());
    setState(() {
      _selectedTasks.clear();
      _selectAll = false;
    });
  }

  void _bulkDelete() {
    ref.read(taskProvider(widget.projectId).notifier).bulkDelete(_selectedTasks.toList());
    setState(() {
      _selectedTasks.clear();
      _selectAll = false;
    });
  }
}