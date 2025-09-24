/// Service for handling question templating and variable substitution
library;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../models/questionnaire.dart';
import '../providers/projects_provider.dart';

class QuestionTemplatingService {
  final Ref ref;

  QuestionTemplatingService(this.ref);

  /// Apply templating to a question definition, substituting variables
  QuestionDefinition applyTemplating(QuestionDefinition question) {
    final project = ref.read(currentProjectProvider);
    if (project == null) return question;

    final templatedQuestion = _substituteVariables(question.question, project);
    final templatedInfo = question.info != null
        ? _substituteVariables(question.info!, project)
        : null;

    return QuestionDefinition(
      id: question.id,
      question: templatedQuestion,
      info: templatedInfo,
      answerType: question.answerType,
      trigger: question.trigger,
      options: question.options,
      displayFields: question.displayFields,
      linkedField: question.linkedField,
      autoPopulate: question.autoPopulate,
      validationRoles: question.validationRoles,
    );
  }

  /// Substitute template variables in text with actual values
  String _substituteVariables(String text, Project project) {
    String result = text;

    // Project basic info
    result = result.replaceAll('{project.name}', project.name);
    result = result.replaceAll('{project.description}', project.description ?? '');
    result = result.replaceAll('{project.client}', project.clientName);

    // Project dates
    result = result.replaceAll('{project.startDate}', _formatDate(project.startDate));
    result = result.replaceAll('{project.startDate.short}', _formatDateShort(project.startDate));

    result = result.replaceAll('{project.endDate}', _formatDate(project.endDate));
    result = result.replaceAll('{project.endDate.short}', _formatDateShort(project.endDate));

    // Project duration
    final duration = project.endDate.difference(project.startDate).inDays + 1;
    result = result.replaceAll('{project.duration}', '$duration days');
    result = result.replaceAll('{project.duration.number}', '$duration');

    // Project timeline context
    final now = DateTime.now();
    final daysUntilStart = project.startDate.difference(now).inDays;
    if (daysUntilStart > 0) {
      result = result.replaceAll('{project.timeToStart}', 'in $daysUntilStart days');
    } else if (daysUntilStart == 0) {
      result = result.replaceAll('{project.timeToStart}', 'today');
    } else {
      result = result.replaceAll('{project.timeToStart}', '${-daysUntilStart} days ago');
    }

    // Project status context
    if (now.isBefore(project.startDate)) {
      result = result.replaceAll('{project.status}', 'upcoming');
    } else if (now.isAfter(project.endDate)) {
      result = result.replaceAll('{project.status}', 'completed');
    } else {
      result = result.replaceAll('{project.status}', 'active');
    }

    return result;
  }

  /// Format date as "January 15, 2024"
  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  /// Format date as "1/15/24"
  String _formatDateShort(DateTime date) {
    return '${date.month}/${date.day}/${date.year.toString().substring(2)}';
  }

  /// Get available template variables for documentation/help
  static List<TemplateVariable> getAvailableVariables() {
    return [
      const TemplateVariable(
        name: '{project.name}',
        description: 'Project name',
        example: 'Acme Corp Security Assessment',
      ),
      const TemplateVariable(
        name: '{project.client}',
        description: 'Client name',
        example: 'Acme Corporation',
      ),
      const TemplateVariable(
        name: '{project.startDate}',
        description: 'Project start date (long format)',
        example: 'January 15, 2024',
      ),
      const TemplateVariable(
        name: '{project.startDate.short}',
        description: 'Project start date (short format)',
        example: '1/15/24',
      ),
      const TemplateVariable(
        name: '{project.endDate}',
        description: 'Project end date (long format)',
        example: 'January 25, 2024',
      ),
      const TemplateVariable(
        name: '{project.endDate.short}',
        description: 'Project end date (short format)',
        example: '1/25/24',
      ),
      const TemplateVariable(
        name: '{project.duration}',
        description: 'Project duration with "days" label',
        example: '10 days',
      ),
      const TemplateVariable(
        name: '{project.duration.number}',
        description: 'Project duration as number only',
        example: '10',
      ),
      const TemplateVariable(
        name: '{project.timeToStart}',
        description: 'Time until project starts (or time since start)',
        example: 'in 5 days',
      ),
      const TemplateVariable(
        name: '{project.status}',
        description: 'Project status (upcoming/active/completed)',
        example: 'active',
      ),
    ];
  }
}

/// Template variable definition for documentation
class TemplateVariable {
  final String name;
  final String description;
  final String example;

  const TemplateVariable({
    required this.name,
    required this.description,
    required this.example,
  });
}

/// Provider for the question templating service
final questionTemplatingServiceProvider = Provider<QuestionTemplatingService>((ref) {
  return QuestionTemplatingService(ref);
});