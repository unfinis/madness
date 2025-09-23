import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../constants/app_spacing.dart';

class AddTaskDialog extends StandardDialog {
  const AddTaskDialog({super.key})
      : super(
          title: 'Add New Task',
          subtitle: 'Create a new task to track progress',
          icon: Icons.add_task_rounded,
          size: DialogSize.medium,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      const _AddTaskForm(),
    ];
  }
}

class _AddTaskForm extends ConsumerStatefulWidget {
  const _AddTaskForm();

  @override
  ConsumerState<_AddTaskForm> createState() => _AddTaskFormState();
}

class _AddTaskFormState extends ConsumerState<_AddTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  DateTime? _selectedDueDate;
  TaskCategory _selectedCategory = TaskCategory.admin;
  TaskPriority _selectedPriority = TaskPriority.medium;
  TaskStatus _selectedStatus = TaskStatus.pending;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _assignedToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task Details Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Task Details',
            icon: Icons.task_alt_rounded,
            children: [
              DialogComponents.buildTextField(
                context: context,
                label: 'Task Title',
                controller: _titleController,
                hintText: 'Enter a clear, descriptive task title',
                prefixIcon: Icons.task_alt_rounded,
                maxLines: 2,
                minLines: 1,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapLG,
              DialogComponents.buildTextField(
                context: context,
                label: 'Description (Optional)',
                controller: _descriptionController,
                hintText: 'Add any additional details, instructions, or context...',
                prefixIcon: Icons.description_rounded,
                maxLines: 3,
                minLines: 2,
              ),
            ],
          ),

          AppSpacing.vGapXL,

          // Classification Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Classification',
            icon: Icons.category_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DialogComponents.buildDropdownField<TaskCategory>(
                      context: context,
                      label: 'Category',
                      value: _selectedCategory,
                      items: TaskCategory.values,
                      prefixIcon: Icons.category_rounded,
                      itemBuilder: (category) => Row(
                        children: [
                          Icon(category.icon, size: 16),
                          AppSpacing.hGapSM,
                          Text(category.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                  ),
                  AppSpacing.hGapLG,
                  Expanded(
                    child: DialogComponents.buildDropdownField<TaskStatus>(
                      context: context,
                      label: 'Status',
                      value: _selectedStatus,
                      items: TaskStatus.values,
                      prefixIcon: Icons.assignment_turned_in_rounded,
                      itemBuilder: (status) => Row(
                        children: [
                          Icon(status.icon, size: 16),
                          AppSpacing.hGapSM,
                          Text(status.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                    ),
                  ),
                ],
              ),
              AppSpacing.vGapLG,
              DialogComponents.buildDropdownField<TaskPriority>(
                context: context,
                label: 'Priority',
                value: _selectedPriority,
                items: TaskPriority.values,
                prefixIcon: Icons.flag_rounded,
                itemBuilder: (priority) => Row(
                  children: [
                    Icon(priority.icon, size: 16),
                    AppSpacing.hGapSM,
                    Text(priority.displayName),
                  ],
                ),
                onChanged: (value) => setState(() => _selectedPriority = value!),
              ),
            ],
          ),

          AppSpacing.vGapXL,

          // Assignment Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Assignment & Scheduling',
            icon: Icons.person_rounded,
            children: [
              DialogComponents.buildTextField(
                context: context,
                label: 'Assigned To (Optional)',
                controller: _assignedToController,
                hintText: 'Enter the person responsible for this task',
                prefixIcon: Icons.person_rounded,
              ),
              AppSpacing.vGapLG,
              DialogComponents.buildDateField(
                context: context,
                label: 'Due Date (Optional)',
                selectedDate: _selectedDueDate,
                onDateSelected: (date) => setState(() => _selectedDueDate = date),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              ),
            ],
          ),

          AppSpacing.vGapXL,

          // Task Priority Information
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: _getPriorityColor(_selectedPriority).withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              border: Border.all(
                color: _getPriorityColor(_selectedPriority).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getPriorityIcon(_selectedPriority),
                  color: _getPriorityColor(_selectedPriority),
                  size: AppSizes.iconMD,
                ),
                AppSpacing.hGapSM,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedPriority.displayName} Priority Task',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: _getPriorityColor(_selectedPriority),
                        ),
                      ),
                      AppSpacing.vGapXS,
                      Text(
                        _getPriorityDescription(_selectedPriority),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          AppSpacing.vGapXL,

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: DialogComponents.buildSecondaryButton(
                  context: context,
                  text: 'Cancel',
                  onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  icon: Icons.close_rounded,
                ),
              ),
              AppSpacing.hGapLG,
              Expanded(
                child: DialogComponents.buildPrimaryButton(
                  context: context,
                  text: 'Create Task',
                  onPressed: _isSubmitting ? null : _submitTask,
                  icon: Icons.add_rounded,
                  isLoading: _isSubmitting,
                  loadingText: 'Creating...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.red.shade800;
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return Icons.arrow_downward_rounded;
      case TaskPriority.medium:
        return Icons.drag_handle_rounded;
      case TaskPriority.high:
        return Icons.arrow_upward_rounded;
      case TaskPriority.urgent:
        return Icons.warning_rounded;
    }
  }

  String _getPriorityDescription(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return 'Can be completed when time permits. Not time-sensitive.';
      case TaskPriority.medium:
        return 'Standard priority task. Should be completed in reasonable timeframe.';
      case TaskPriority.high:
        return 'Important task that should be prioritized over others.';
      case TaskPriority.urgent:
        return 'Critical task requiring immediate attention and action.';
    }
  }

  void _submitTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final task = Task(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        category: _selectedCategory,
        status: _selectedStatus,
        priority: _selectedPriority,
        assignedTo: _assignedToController.text.trim().isEmpty
            ? null
            : _assignedToController.text.trim(),
        dueDate: _selectedDueDate,
        createdDate: DateTime.now(),
      );

      final currentProject = ref.read(currentProjectProvider);
      if (currentProject != null) {
        await ref.read(taskProvider(currentProject.id).notifier).addTask(task);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: AppSizes.iconMD),
                AppSpacing.hGapSM,
                Expanded(child: Text('Task "${task.title}" created successfully')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Navigate to task detail or task list
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: AppSizes.iconMD),
                AppSpacing.hGapSM,
                Expanded(child: Text('Failed to create task: ${e.toString()}')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

// Convenience function to show the dialog
Future<void> showAddTaskDialog(BuildContext context) {
  return showStandardDialog(
    context: context,
    dialog: const AddTaskDialog(),
    animationType: DialogAnimationType.scaleAndFade,
  );
}