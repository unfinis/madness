/// Service for loading and managing questionnaire configurations
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import '../models/questionnaire.dart';
import '../models/project.dart';

class QuestionnaireService {
  static const String _defaultConfigPath = 'assets/questionnaire/kickoff-template.yaml';
  
  /// Load questionnaire configuration from YAML file
  Future<QuestionnaireConfiguration> loadConfiguration({
    String? configPath,
  }) async {
    final path = configPath ?? _defaultConfigPath;
    
    try {
      final yamlString = await rootBundle.loadString(path);
      final yamlData = loadYaml(yamlString);
      final jsonData = _yamlToJson(yamlData);
      
      return QuestionnaireConfiguration.fromJson(jsonData);
    } catch (e) {
      throw Exception('Failed to load questionnaire configuration: $e');
    }
  }

  /// Convert YAML dynamic to JSON-compatible Map
  dynamic _yamlToJson(dynamic yamlData) {
    if (yamlData is YamlMap) {
      return Map<String, dynamic>.from(yamlData.map((key, value) => MapEntry(
        key.toString(),
        _yamlToJson(value),
      )));
    } else if (yamlData is YamlList) {
      return yamlData.map(_yamlToJson).toList();
    } else {
      return yamlData;
    }
  }

  /// Filter questions based on project and previous answers
  List<QuestionDefinition> getVisibleQuestions({
    required List<QuestionDefinition> allQuestions,
    required Project? project,
    required Map<String, QuestionAnswer> answers,
  }) {
    final visibleQuestions = <QuestionDefinition>[];

    for (final question in allQuestions) {
      if (_shouldShowQuestion(question, project, answers)) {
        visibleQuestions.add(question);
      }
    }

    return visibleQuestions;
  }

  /// Determine if a question should be shown based on trigger conditions
  bool _shouldShowQuestion(
    QuestionDefinition question,
    Project? project,
    Map<String, QuestionAnswer> answers,
  ) {
    final trigger = question.trigger.toLowerCase().trim();

    // Always show questions with "always" trigger
    if (trigger == 'always') {
      return true;
    }

    // Parse complex trigger expressions
    return _evaluateTriggerExpression(trigger, project, answers);
  }

  /// Evaluate trigger expression with support for AND/OR logic
  bool _evaluateTriggerExpression(
    String expression,
    Project? project,
    Map<String, QuestionAnswer> answers,
  ) {
    // Handle OR conditions first (split by OR)
    if (expression.contains(' or ')) {
      final orParts = expression.split(' or ');
      return orParts.any((part) => _evaluateTriggerExpression(part.trim(), project, answers));
    }

    // Handle AND conditions (split by AND)
    if (expression.contains(' and ')) {
      final andParts = expression.split(' and ');
      return andParts.every((part) => _evaluateTriggerExpression(part.trim(), project, answers));
    }

    // Handle parentheses for complex expressions
    if (expression.contains('(') && expression.contains(')')) {
      return _evaluateComplexExpression(expression, project, answers);
    }

    // Evaluate individual condition
    return _evaluateCondition(expression, project, answers);
  }

  /// Evaluate complex expressions with parentheses
  bool _evaluateComplexExpression(
    String expression,
    Project? project,
    Map<String, QuestionAnswer> answers,
  ) {
    // Simple implementation - would need more sophisticated parsing for complex cases
    // For now, handle basic (A AND B) OR C pattern
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(expression);
    
    if (match != null) {
      final innerExpression = match.group(1)!;
      final innerResult = _evaluateTriggerExpression(innerExpression, project, answers);
      
      // Replace the parentheses part with the result and re-evaluate
      final remainingExpression = expression.replaceFirst(match.group(0)!, innerResult.toString());
      return _evaluateTriggerExpression(remainingExpression, project, answers);
    }

    return _evaluateTriggerExpression(expression, project, answers);
  }

  /// Evaluate individual trigger condition
  bool _evaluateCondition(
    String condition,
    Project? project,
    Map<String, QuestionAnswer> answers,
  ) {
    condition = condition.trim();

    // Handle element_type conditions
    if (condition.startsWith('element_type = ')) {
      final elementType = condition.substring('element_type = '.length);
      return _checkElementType(elementType, project);
    }

    // Handle engagement_type conditions (legacy)
    if (condition.startsWith('engagement_type = ')) {
      final engagementType = condition.substring('engagement_type = '.length);
      return _checkEngagementType(engagementType, project);
    }

    // Handle answer-based conditions (questionId = value)
    if (condition.contains(' = ')) {
      final parts = condition.split(' = ');
      if (parts.length == 2) {
        final questionId = parts[0].trim();
        final expectedValue = parts[1].trim();
        return _checkAnswerCondition(questionId, expectedValue, answers);
      }
    }

    // Unknown condition - default to false for safety
    return false;
  }

  /// Check if project has specific element type enabled
  bool _checkElementType(String elementType, Project? project) {
    if (project == null) return false;

    // Convert element type to match project assessment scope
    final normalizedType = _normalizeElementType(elementType);
    
    // Check if assessment scope includes this type
    return project.assessmentScope[normalizedType] == true ||
           project.assessmentScope[elementType] == true;
  }

  /// Check engagement type (legacy support)
  bool _checkEngagementType(String engagementType, Project? project) {
    // Map engagement types to element types
    final elementTypeMapping = {
      'network internal': 'internal_network',
      'network external': 'external_infrastructure',
      'web application': 'web_applications',
      'mobile application': 'mobile_app',
      'wireless assessment': 'wireless',
      'physical assessment': 'physical',
      'social engineering': 'social',
      'code review': 'code_review',
      'build review': 'build_review',
      'api testing': 'api',
      'iot': 'iot',
      'ai': 'ai',
      'firewall': 'firewall',
      'password audit': 'password',
    };

    final mappedType = elementTypeMapping[engagementType.toLowerCase()];
    if (mappedType != null) {
      return _checkElementType(mappedType, project);
    }

    return false;
  }

  /// Check answer-based condition
  bool _checkAnswerCondition(
    String questionId,
    String expectedValue,
    Map<String, QuestionAnswer> answers,
  ) {
    final answer = answers[questionId];
    if (answer?.answer == null) return false;

    final actualValue = answer!.answer.toString().toLowerCase();
    final expected = expectedValue.toLowerCase();

    // Handle boolean answers
    if (expected == 'yes') {
      return actualValue == 'true' || actualValue == 'yes';
    }
    if (expected == 'no') {
      return actualValue == 'false' || actualValue == 'no';
    }

    // Direct string comparison
    return actualValue == expected;
  }

  /// Normalize element type names for consistent comparison
  String _normalizeElementType(String elementType) {
    return elementType
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll('-', '_');
  }

  /// Get questions filtered by category
  List<QuestionDefinition> getQuestionsByCategory(
    List<QuestionDefinition> questions,
    QuestionCategory category,
  ) {
    return questions.where((q) => q.category == category).toList();
  }

  /// Get questions filtered by status
  List<QuestionDefinition> getQuestionsByStatus(
    List<QuestionDefinition> questions,
    QuestionStatus status,
    Map<String, QuestionAnswer> answers,
  ) {
    return questions.where((q) {
      final answer = answers[q.id];
      return (answer?.status ?? QuestionStatus.pending) == status;
    }).toList();
  }

  /// Interpolate project variables in question text
  String interpolateQuestionText(String text, Project? project) {
    if (project == null) return text;

    var result = text;

    // Replace common project variables
    result = result.replaceAll('{project.name}', project.name);
    result = result.replaceAll('{project.startDate}', project.startDate?.toString().substring(0, 10) ?? 'TBD');
    result = result.replaceAll('{project.endDate}', project.endDate?.toString().substring(0, 10) ?? 'TBD');
    
    // Calculate duration
    if (project.startDate != null && project.endDate != null) {
      final duration = project.endDate!.difference(project.startDate!).inDays;
      result = result.replaceAll('{project.duration}', '$duration days');
    } else {
      result = result.replaceAll('{project.duration}', 'TBD');
    }

    // Contact count (using available contact fields)
    int contactCount = 0;
    if (project.contactPerson?.isNotEmpty == true) contactCount++;
    if (project.contactEmail?.isNotEmpty == true) contactCount++;
    result = result.replaceAll('{project.contactCount}', contactCount.toString());

    // Phase count (using project status as phase indicator)
    int phaseCount = 1; // Default single phase
    result = result.replaceAll('{project.phaseCount}', phaseCount.toString());

    // Scope items count (using assessment scope)
    final scopeItemsCount = project.assessmentScope.values.where((enabled) => enabled).length;
    result = result.replaceAll('{project.scopeItems}', scopeItemsCount.toString());

    return result;
  }

  /// Create a new questionnaire session for a project
  QuestionnaireSession createSession({
    required String projectId,
    required String questionnaireId,
    required List<QuestionDefinition> visibleQuestions,
  }) {
    final sessionId = 'QS-${DateTime.now().millisecondsSinceEpoch}';
    final now = DateTime.now();

    // Initialize answers for all visible questions
    final answers = <String, QuestionAnswer>{};
    for (final question in visibleQuestions) {
      answers[question.id] = QuestionAnswer(
        questionId: question.id,
        status: QuestionStatus.pending,
      );
    }

    return QuestionnaireSession(
      id: sessionId,
      projectId: projectId,
      questionnaireId: questionnaireId,
      answers: answers,
      createdAt: now,
      updatedAt: now,
      isCompleted: false,
    );
  }

  /// Update session completion status
  QuestionnaireSession updateSessionCompletion(QuestionnaireSession session) {
    final stats = session.statistics;
    final totalQuestions = stats['total'] ?? 0;
    final completedQuestions = stats['completed'] ?? 0;
    
    final isCompleted = totalQuestions > 0 && completedQuestions == totalQuestions;

    return session.copyWith(
      isCompleted: isCompleted,
      updatedAt: DateTime.now(),
    );
  }
}