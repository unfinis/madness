import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scope.dart';
import '../providers/scope_provider.dart';

class AddScopeSegmentDialog extends ConsumerStatefulWidget {
  const AddScopeSegmentDialog({super.key});

  @override
  ConsumerState<AddScopeSegmentDialog> createState() => _AddScopeSegmentDialogState();
}

class _AddScopeSegmentDialogState extends ConsumerState<AddScopeSegmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  ScopeSegmentType _selectedType = ScopeSegmentType.external;
  ScopeSegmentStatus _selectedStatus = ScopeSegmentStatus.planned;
  DateTime? _selectedStartDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 520 : null,
        constraints: const BoxConstraints(maxHeight: 600),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitleField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildTypeField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatusField()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildStartDateField(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.schema_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Testing Segment',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Define a new scope segment for testing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Segment Title',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            hintText: 'e.g., External Network Testing',
            prefixIcon: Icon(
              Icons.title_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a segment title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Describe what this segment covers...',
            prefixIcon: Icon(
              Icons.description_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          maxLines: 3,
          minLines: 2,
        ),
      ],
    );
  }

  Widget _buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Segment Type',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          child: DropdownButtonFormField<ScopeSegmentType>(
            value: _selectedType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ScopeSegmentType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Text(type.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          child: DropdownButtonFormField<ScopeSegmentStatus>(
            value: _selectedStatus,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ScopeSegmentStatus.values.map((status) {
              return DropdownMenuItem(
                value: status,
                child: Row(
                  children: [
                    Text(status.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(status.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedStatus = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStartDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start Date (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectStartDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
              color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedStartDate != null
                        ? '${_selectedStartDate!.day}/${_selectedStartDate!.month}/${_selectedStartDate!.year}'
                        : 'Select start date',
                    style: _selectedStartDate != null
                        ? Theme.of(context).textTheme.bodyLarge
                        : Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).hintColor,
                          ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submitSegment,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Creating...'),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Create Segment'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedStartDate) {
      setState(() {
        _selectedStartDate = picked;
      });
    }
  }

  void _submitSegment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final segment = ScopeSegment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        type: _selectedType,
        status: _selectedStatus,
        startDate: _selectedStartDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
      );

      ref.read(scopeProvider.notifier).addSegment(segment);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Segment "${segment.title}" created successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create segment: ${e.toString()}'),
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