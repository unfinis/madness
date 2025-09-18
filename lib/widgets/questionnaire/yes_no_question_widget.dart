/// Yes/No question widget
import 'package:flutter/material.dart';
import 'question_widget_base.dart';

class YesNoQuestionWidget extends QuestionWidgetBase {
  const YesNoQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<YesNoQuestionWidget> createState() => _YesNoQuestionWidgetState();
}

class _YesNoQuestionWidgetState extends QuestionWidgetBaseState<YesNoQuestionWidget> {
  @override
  Widget buildQuestionContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => updateAnswer(true),
            icon: Icon(
              currentAnswer == true ? Icons.check_circle : Icons.radio_button_unchecked,
              color: currentAnswer == true ? theme.colorScheme.primary : null,
            ),
            label: const Text('Yes'),
            style: OutlinedButton.styleFrom(
              backgroundColor: currentAnswer == true 
                  ? theme.colorScheme.primaryContainer
                  : null,
              foregroundColor: currentAnswer == true 
                  ? theme.colorScheme.onPrimaryContainer
                  : null,
              side: BorderSide(
                color: currentAnswer == true 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: currentAnswer == true ? 2 : 1,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => updateAnswer(false),
            icon: Icon(
              currentAnswer == false ? Icons.cancel : Icons.radio_button_unchecked,
              color: currentAnswer == false ? theme.colorScheme.primary : null,
            ),
            label: const Text('No'),
            style: OutlinedButton.styleFrom(
              backgroundColor: currentAnswer == false 
                  ? theme.colorScheme.primaryContainer
                  : null,
              foregroundColor: currentAnswer == false 
                  ? theme.colorScheme.onPrimaryContainer
                  : null,
              side: BorderSide(
                color: currentAnswer == false 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
                width: currentAnswer == false ? 2 : 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}