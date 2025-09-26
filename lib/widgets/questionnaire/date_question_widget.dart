/// Date question widget
library;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'question_widget_base.dart';

class DateQuestionWidget extends QuestionWidgetBase {
  const DateQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<DateQuestionWidget> createState() => _DateQuestionWidgetState();
}

class _DateQuestionWidgetState extends QuestionWidgetBaseState<DateQuestionWidget> {
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  DateTime? get selectedDate {
    if (currentAnswer == null) return null;
    if (currentAnswer is DateTime) return currentAnswer;
    if (currentAnswer is String) {
      try {
        return DateTime.parse(currentAnswer);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      updateAnswer(picked.toIso8601String());
    }
  }

  void _clearDate() {
    updateAnswer(null);
  }

  @override
  Widget buildQuestionContent(BuildContext context) {
    final theme = Theme.of(context);
    final date = selectedDate;
    
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_month,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date != null 
                    ? _dateFormat.format(date)
                    : 'Select date...',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: date != null 
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            if (date != null) ...[
              IconButton(
                onPressed: _clearDate,
                icon: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                tooltip: 'Clear date',
              ),
            ],
          ],
        ),
      ),
    );
  }
}