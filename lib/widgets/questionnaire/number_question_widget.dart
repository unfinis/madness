/// Number question widget
library;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'question_widget_base.dart';

class NumberQuestionWidget extends QuestionWidgetBase {
  const NumberQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<NumberQuestionWidget> createState() => _NumberQuestionWidgetState();
}

class _NumberQuestionWidgetState extends QuestionWidgetBaseState<NumberQuestionWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: currentAnswer?.toString() ?? '');
  }

  @override
  void didUpdateWidget(NumberQuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer?.answer != widget.answer?.answer) {
      _controller.text = currentAnswer?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildQuestionContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        hintText: 'Enter a number...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        prefixIcon: Icon(
          Icons.numbers,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onChanged: (value) {
        if (value.trim().isEmpty) {
          updateAnswer(null);
        } else {
          final number = int.tryParse(value.trim());
          updateAnswer(number);
        }
      },
    );
  }
}