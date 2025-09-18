/// Factory for creating question widgets based on answer type
import 'package:flutter/material.dart';
import '../../models/questionnaire.dart';
import 'question_widget_base.dart';
import 'yes_no_question_widget.dart';
import 'free_text_question_widget.dart';
import 'multiple_choice_question_widget.dart';
import 'date_question_widget.dart';
import 'number_question_widget.dart';
import 'project_info_question_widget.dart';
import 'project_dates_question_widget.dart';
import 'project_contacts_question_widget.dart';
import 'project_scope_question_widget.dart';
import 'contact_validation_question_widget.dart';

class QuestionWidgetFactory {
  /// Create appropriate question widget based on answer type
  static Widget create({
    required QuestionDefinition question,
    required QuestionAnswer? answer,
    required QuestionAnswerCallback onAnswerChanged,
  }) {
    switch (question.answerType) {
      case QuestionAnswerType.yesNo:
        return YesNoQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.freeText:
        return FreeTextQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.multipleChoice:
        return MultipleChoiceQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.date:
        return DateQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.number:
        return NumberQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.projectInfo:
        return ProjectInfoQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.projectDates:
        return ProjectDatesQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.projectContacts:
        return ProjectContactsQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.projectScope:
        return ProjectScopeQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
        
      case QuestionAnswerType.contactValidation:
        return ContactValidationQuestionWidget(
          question: question,
          answer: answer,
          onAnswerChanged: onAnswerChanged,
        );
    }
  }
}