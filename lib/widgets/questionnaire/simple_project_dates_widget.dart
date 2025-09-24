/// Simple project dates widget - just start and end date selection
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/questionnaire.dart';
import '../../models/project.dart';
import '../../providers/projects_provider.dart';
import '../../constants/app_spacing.dart';
import 'question_widget_base.dart';

class SimpleProjectDatesWidget extends ConsumerStatefulWidget {
  final QuestionDefinition question;
  final QuestionAnswer? answer;
  final QuestionAnswerCallback onAnswerChanged;

  const SimpleProjectDatesWidget({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
  });

  @override
  ConsumerState<SimpleProjectDatesWidget> createState() => _SimpleProjectDatesWidgetState();
}

class _SimpleProjectDatesWidgetState extends ConsumerState<SimpleProjectDatesWidget> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isConfirmed = false;

  @override
  void initState() {
    super.initState();
    _loadAnswerData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future(() => _initializeFromProject());
  }

  void _initializeFromProject() {
    final project = ref.read(currentProjectProvider);
    if (project != null && widget.answer?.answer == null) {
      setState(() {
        _startDate = project.startDate;
        _endDate = project.endDate;
      });
      Future(() => _updateAnswer());
    }
  }

  void _loadAnswerData() {
    if (widget.answer?.answer is Map) {
      final data = widget.answer!.answer as Map<String, dynamic>;
      setState(() {
        if (data['startDate'] != null) {
          _startDate = DateTime.parse(data['startDate']);
        }
        if (data['endDate'] != null) {
          _endDate = DateTime.parse(data['endDate']);
        }
        _isConfirmed = data['confirmed'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen for project changes and update accordingly
    ref.listen<Project?>(currentProjectProvider, (previous, next) {
      if (next != null && (previous?.startDate != next.startDate || previous?.endDate != next.endDate)) {
        if (!_isConfirmed) {
          setState(() {
            _startDate = next.startDate;
            _endDate = next.endDate;
          });
          Future(() => _updateAnswer());
        }
      }
    });

    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.date_range,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Timeline',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Confirm project start and end dates',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildDurationCard(context),
              ],
            ),
          ),

          // Date Selection
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Range Picker
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        context,
                        'Start Date',
                        _startDate,
                        Icons.play_arrow,
                        (date) => setState(() {
                          _startDate = date;
                          // Reset end date if it's before start date
                          if (_endDate != null && date != null && _endDate!.isBefore(date)) {
                            _endDate = null;
                          }
                          _updateAnswer();
                        }),
                      ),
                    ),
                    AppSpacing.hGapMD,
                    Expanded(
                      child: _buildDateField(
                        context,
                        'End Date',
                        _endDate,
                        Icons.stop,
                        (date) => setState(() {
                          _endDate = date;
                          _updateAnswer();
                        }),
                        firstDate: _startDate,
                      ),
                    ),
                  ],
                ),

                AppSpacing.vGapLG,

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _resetToProject,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reset to Project'),
                      ),
                    ),
                    AppSpacing.hGapMD,
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _hasValidDates() ? _confirmDates : null,
                        icon: Icon(_isConfirmed ? Icons.check_circle : Icons.check),
                        label: Text(_isConfirmed ? 'Confirmed' : 'Confirm Dates'),
                        style: FilledButton.styleFrom(
                          backgroundColor: _isConfirmed ? Colors.green : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard(BuildContext context) {
    final theme = Theme.of(context);
    final duration = _startDate != null && _endDate != null
        ? _endDate!.difference(_startDate!).inDays + 1
        : 0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$duration',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            duration == 1 ? 'Day' : 'Days',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? value,
    IconData icon,
    Function(DateTime?) onChanged, {
    DateTime? firstDate,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _selectDate(context, value, onChanged, firstDate: firstDate),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value != null
                  ? '${value.day}/${value.month}/${value.year}'
                  : 'Select date',
              style: value != null
                  ? theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)
                  : theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? currentValue,
    Function(DateTime?) onChanged, {
    DateTime? firstDate,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentValue ?? firstDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    onChanged(date);
  }

  void _resetToProject() {
    final project = ref.read(currentProjectProvider);
    if (project != null) {
      setState(() {
        _startDate = project.startDate;
        _endDate = project.endDate;
        _isConfirmed = false;
      });
      _updateAnswer();
    }
  }

  bool _hasValidDates() {
    return _startDate != null && _endDate != null && !_endDate!.isBefore(_startDate!);
  }

  Future<void> _confirmDates() async {
    if (!_hasValidDates()) return;

    setState(() {
      _isConfirmed = true;
    });

    // Update the questionnaire answer
    _updateAnswer();

    // Bidirectional sync: Update the actual project dates
    await _updateProjectDates();
  }

  Future<void> _updateProjectDates() async {
    if (!_hasValidDates()) return;

    try {
      final projectsNotifier = ref.read(projectsProvider.notifier);
      final currentProject = ref.read(currentProjectProvider);

      if (currentProject != null) {
        final updatedProject = currentProject.copyWith(
          startDate: _startDate!,
          endDate: _endDate!,
          updatedDate: DateTime.now(),
        );

        await projectsNotifier.updateProject(updatedProject);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Project dates updated: ${_formatDateShort(_startDate!)} - ${_formatDateShort(_endDate!)}'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating project dates: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  String _formatDateShort(DateTime date) {
    return '${date.month}/${date.day}/${date.year.toString().substring(2)}';
  }

  void _updateAnswer() {
    final answerData = {
      'startDate': _startDate?.toIso8601String(),
      'endDate': _endDate?.toIso8601String(),
      'confirmed': _isConfirmed,
    };

    final status = _isConfirmed ? QuestionStatus.completed : QuestionStatus.inProgress;

    widget.onAnswerChanged(widget.question.id, answerData, status);
  }
}