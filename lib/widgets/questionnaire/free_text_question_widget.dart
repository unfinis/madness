/// Free text question widget
import 'package:flutter/material.dart';
import 'question_widget_base.dart';

class FreeTextQuestionWidget extends QuestionWidgetBase {
  const FreeTextQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<FreeTextQuestionWidget> createState() => _FreeTextQuestionWidgetState();
}

class _FreeTextQuestionWidgetState extends QuestionWidgetBaseState<FreeTextQuestionWidget> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: currentAnswer?.toString() ?? '');
  }

  @override
  void didUpdateWidget(FreeTextQuestionWidget oldWidget) {
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
      maxLines: 3,
      decoration: InputDecoration(
        hintText: 'Enter your answer...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      ),
      onChanged: (value) {
        updateAnswer(value.trim().isEmpty ? null : value.trim());
      },
    );
  }
}