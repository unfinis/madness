/// Multiple choice question widget
library;
import 'package:flutter/material.dart';
import 'question_widget_base.dart';

class MultipleChoiceQuestionWidget extends QuestionWidgetBase {
  const MultipleChoiceQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<MultipleChoiceQuestionWidget> createState() => _MultipleChoiceQuestionWidgetState();
}

class _MultipleChoiceQuestionWidgetState extends QuestionWidgetBaseState<MultipleChoiceQuestionWidget> {
  @override
  Widget buildQuestionContent(BuildContext context) {
    final theme = Theme.of(context);
    final options = widget.question.options ?? [];
    
    if (options.isEmpty) {
      return Text(
        'No options available',
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.error,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < options.length; i++) ...[
          RadioListTile<String>(
            value: options[i],
            groupValue: currentAnswer?.toString(),
            onChanged: (value) => updateAnswer(value),
            title: Text(options[i]),
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: theme.colorScheme.primary,
          ),
          if (i < options.length - 1) const SizedBox(height: 4),
        ],
      ],
    );
  }
}