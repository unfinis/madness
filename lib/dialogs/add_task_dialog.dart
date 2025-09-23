import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../utils/validation_rules.dart';

class AddTaskDialog extends StandardDialog {
  const AddTaskDialog({super.key});

  @override
  String get title => 'Add New Task';

  @override
  String get subtitle => 'Create a new task to track progress';

  @override
  IconData get headerIcon => Icons.add_task_rounded;

  @override
  Widget buildContent(BuildContext context) {
    return const _AddTaskForm();
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
          DialogComponents.buildFormSection(
            context: context,
            title: 'Task Information',
            children: [
              DialogComponents.buildTextField(
                context: context,
                controller: _titleController,
                label: 'Task Title',
                hintText: 'Enter a clear, descriptive task title',
                prefixIcon: Icons.task_alt_rounded,
                validator: ValidationRules.required,
                maxLines: 2,
              ),
              DialogComponents.buildTextField(
                context: context,
                controller: _descriptionController,
                label: 'Description (Optional)',
                hintText: 'Add any additional details, instructions, or context...',
                prefixIcon: Icons.description_rounded,
                maxLines: 3,
              ),
            ],
          ),
          DialogComponents.buildFormSection(
            context: context,
            title: 'Task Details',
            children: [
              Row(
                children: [
                  Expanded(
                    child: DialogComponents.buildDropdownField<TaskCategory>(
                      context: context,
                      value: _selectedCategory,
                      label: 'Category',
                      prefixIcon: Icons.category_rounded,
                      items: TaskCategory.values,
                      itemBuilder: (category) => Row(
                        children: [
                          Icon(category.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(category.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedCategory = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DialogComponents.buildDropdownField<TaskStatus>(
                      context: context,
                      value: _selectedStatus,
                      label: 'Status',
                      prefixIcon: Icons.assignment_turned_in_rounded,
                      items: TaskStatus.values,
                      itemBuilder: (status) => Row(
                        children: [
                          Icon(status.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(status.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: DialogComponents.buildDropdownField<TaskPriority>(
                      context: context,
                      value: _selectedPriority,
                      label: 'Priority',
                      prefixIcon: Icons.flag_rounded,
                      items: TaskPriority.values,
                      itemBuilder: (priority) => Row(
                        children: [
                          Icon(priority.icon, size: 16),
                          const SizedBox(width: 8),
                          Text(priority.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedPriority = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(child: _buildDueDateField()),
                ],
              ),
              DialogComponents.buildTextField(
                context: context,
                controller: _assignedToController,
                label: 'Assigned To (Optional)',
                hintText: 'Enter the person responsible for this task',
                prefixIcon: Icons.person_rounded,
              ),
            ],
          ),
          DialogComponents.buildActionButtons(
            context: context,
            primaryAction: ActionButton(
              label: 'Create Task',
              icon: Icons.add_rounded,
              onPressed: _isSubmitting ? null : _submitTask,
              isLoading: _isSubmitting,
              loadingText: 'Creating...',
            ),
            secondaryAction: ActionButton(
              label: 'Cancel',
              onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              type: ActionButtonType.secondary,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDueDateField() {
    return DialogComponents.buildDateField(
      context: context,
      label: 'Due Date (Optional)',
      selectedDate: _selectedDueDate,
      onDateSelected: (date) => setState(() => _selectedDueDate = date),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
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
            content: Text('Task "${task.title}" added successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add task: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
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