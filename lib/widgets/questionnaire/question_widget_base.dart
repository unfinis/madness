/// Base widget for questionnaire questions
import 'package:flutter/material.dart';
import '../../models/questionnaire.dart';

typedef QuestionAnswerCallback = void Function(String questionId, dynamic answer, QuestionStatus status);

abstract class QuestionWidgetBase extends StatefulWidget {
  final QuestionDefinition question;
  final QuestionAnswer? answer;
  final QuestionAnswerCallback onAnswerChanged;

  const QuestionWidgetBase({
    super.key,
    required this.question,
    required this.answer,
    required this.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState createState();
}

abstract class QuestionWidgetBaseState<T extends QuestionWidgetBase> extends State<T> {
  late dynamic _currentAnswer;
  late QuestionStatus _status;

  @override
  void initState() {
    super.initState();
    _currentAnswer = widget.answer?.answer;
    _status = widget.answer?.status ?? QuestionStatus.pending;
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      _currentAnswer = widget.answer?.answer;
      _status = widget.answer?.status ?? QuestionStatus.pending;
    }
  }

  /// Update the answer and notify parent
  void updateAnswer(dynamic answer, {QuestionStatus? status}) {
    setState(() {
      _currentAnswer = answer;
      _status = status ?? _determineStatus(answer);
    });

    widget.onAnswerChanged(widget.question.id, answer, _status);
  }

  /// Determine question status based on answer value
  QuestionStatus _determineStatus(dynamic answer) {
    if (answer == null || _isEmptyAnswer(answer)) {
      return QuestionStatus.pending;
    }
    return QuestionStatus.completed;
  }

  /// Check if answer is considered empty
  bool _isEmptyAnswer(dynamic answer) {
    if (answer == null) return true;
    if (answer is String && answer.trim().isEmpty) return true;
    if (answer is List && answer.isEmpty) return true;
    if (answer is Map && answer.isEmpty) return true;
    return false;
  }

  /// Get current answer value
  dynamic get currentAnswer => _currentAnswer;

  /// Get current status
  QuestionStatus get currentStatus => _status;

  /// Build the question content - to be implemented by subclasses
  Widget buildQuestionContent(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question header with status indicator
            Row(
              children: [
                _buildStatusIndicator(theme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.question.question,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (widget.question.info != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.question.info!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Question content
            buildQuestionContent(context),
          ],
        ),
      ),
    );
  }

  /// Build status indicator icon
  Widget _buildStatusIndicator(ThemeData theme) {
    Color color;
    IconData icon;
    
    switch (_status) {
      case QuestionStatus.pending:
        color = theme.colorScheme.outline;
        icon = Icons.radio_button_unchecked;
        break;
      case QuestionStatus.inProgress:
        color = theme.colorScheme.primary;
        icon = Icons.access_time;
        break;
      case QuestionStatus.completed:
        color = theme.colorScheme.primary;
        icon = Icons.check_circle;
        break;
      case QuestionStatus.blocked:
        color = theme.colorScheme.error;
        icon = Icons.error;
        break;
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }
}