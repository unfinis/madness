/// Pre-engagement questionnaire models and enums
library;

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// Answer types for questionnaire questions
enum QuestionAnswerType {
  yesNo,
  freeText,
  number,
  date,
  multipleChoice,
  projectInfo,
  projectDates,
  projectContacts,
  projectScope,
  contactValidation;

  String get name {
    switch (this) {
      case QuestionAnswerType.yesNo:
        return 'yes_no';
      case QuestionAnswerType.freeText:
        return 'free_text';
      case QuestionAnswerType.number:
        return 'number';
      case QuestionAnswerType.date:
        return 'date';
      case QuestionAnswerType.multipleChoice:
        return 'multiple_choice';
      case QuestionAnswerType.projectInfo:
        return 'project_info';
      case QuestionAnswerType.projectDates:
        return 'project_dates';
      case QuestionAnswerType.projectContacts:
        return 'project_contacts';
      case QuestionAnswerType.projectScope:
        return 'project_scope';
      case QuestionAnswerType.contactValidation:
        return 'contact_validation';
    }
  }

  static QuestionAnswerType fromString(String value) {
    switch (value) {
      case 'yes_no':
        return QuestionAnswerType.yesNo;
      case 'free_text':
        return QuestionAnswerType.freeText;
      case 'number':
        return QuestionAnswerType.number;
      case 'date':
        return QuestionAnswerType.date;
      case 'multiple_choice':
        return QuestionAnswerType.multipleChoice;
      case 'project_info':
        return QuestionAnswerType.projectInfo;
      case 'project_dates':
        return QuestionAnswerType.projectDates;
      case 'project_contacts':
        return QuestionAnswerType.projectContacts;
      case 'project_scope':
        return QuestionAnswerType.projectScope;
      case 'contact_validation':
        return QuestionAnswerType.contactValidation;
      default:
        throw ArgumentError('Unknown answer type: $value');
    }
  }
}

/// Question status for tracking completion
enum QuestionStatus {
  pending,
  inProgress,
  completed,
  blocked;

  String get displayName {
    switch (this) {
      case QuestionStatus.pending:
        return 'Pending';
      case QuestionStatus.inProgress:
        return 'In Progress';
      case QuestionStatus.completed:
        return 'Completed';
      case QuestionStatus.blocked:
        return 'Blocked';
    }
  }
}

/// Question category for filtering
enum QuestionCategory {
  core,
  timing,
  contacts,
  scope,
  technical,
  logistics,
  network,
  webApp,
  mobile,
  wireless,
  physical,
  social,
  code,
  api,
  iot,
  ai,
  firewall,
  password;

  String get displayName {
    switch (this) {
      case QuestionCategory.core:
        return 'Core';
      case QuestionCategory.timing:
        return 'Timing';
      case QuestionCategory.contacts:
        return 'Contacts';
      case QuestionCategory.scope:
        return 'Scope';
      case QuestionCategory.technical:
        return 'Technical';
      case QuestionCategory.logistics:
        return 'Logistics';
      case QuestionCategory.network:
        return 'Network';
      case QuestionCategory.webApp:
        return 'Web App';
      case QuestionCategory.mobile:
        return 'Mobile';
      case QuestionCategory.wireless:
        return 'Wireless';
      case QuestionCategory.physical:
        return 'Physical';
      case QuestionCategory.social:
        return 'Social';
      case QuestionCategory.code:
        return 'Code';
      case QuestionCategory.api:
        return 'API';
      case QuestionCategory.iot:
        return 'IoT';
      case QuestionCategory.ai:
        return 'AI';
      case QuestionCategory.firewall:
        return 'Firewall';
      case QuestionCategory.password:
        return 'Password';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestionCategory.core:
        return Icons.center_focus_strong;
      case QuestionCategory.timing:
        return Icons.schedule;
      case QuestionCategory.contacts:
        return Icons.contacts;
      case QuestionCategory.scope:
        return Icons.track_changes;
      case QuestionCategory.technical:
        return Icons.engineering;
      case QuestionCategory.logistics:
        return Icons.inventory;
      case QuestionCategory.network:
        return Icons.hub;
      case QuestionCategory.webApp:
        return Icons.web;
      case QuestionCategory.mobile:
        return Icons.phone_android;
      case QuestionCategory.wireless:
        return Icons.wifi;
      case QuestionCategory.physical:
        return Icons.business;
      case QuestionCategory.social:
        return Icons.people;
      case QuestionCategory.code:
        return Icons.code;
      case QuestionCategory.api:
        return Icons.api;
      case QuestionCategory.iot:
        return Icons.sensors;
      case QuestionCategory.ai:
        return Icons.smart_toy;
      case QuestionCategory.firewall:
        return Icons.security;
      case QuestionCategory.password:
        return Icons.lock;
    }
  }

  static QuestionCategory fromQuestionId(String questionId) {
    if (questionId.startsWith('core_') || questionId.startsWith('project_')) {
      return QuestionCategory.core;
    } else if (questionId.startsWith('net_')) {
      return QuestionCategory.network;
    } else if (questionId.startsWith('web_')) {
      return QuestionCategory.webApp;
    } else if (questionId.startsWith('mobile_')) {
      return QuestionCategory.mobile;
    } else if (questionId.startsWith('wifi_')) {
      return QuestionCategory.wireless;
    } else if (questionId.startsWith('physical_')) {
      return QuestionCategory.physical;
    } else if (questionId.startsWith('social_')) {
      return QuestionCategory.social;
    } else if (questionId.startsWith('code_')) {
      return QuestionCategory.code;
    } else if (questionId.startsWith('api_')) {
      return QuestionCategory.api;
    } else if (questionId.startsWith('iot_')) {
      return QuestionCategory.iot;
    } else if (questionId.startsWith('ai_')) {
      return QuestionCategory.ai;
    } else if (questionId.startsWith('firewall_')) {
      return QuestionCategory.firewall;
    } else if (questionId.startsWith('password_')) {
      return QuestionCategory.password;
    } else if (questionId.contains('contact')) {
      return QuestionCategory.contacts;
    } else if (questionId.contains('date') || questionId.contains('time')) {
      return QuestionCategory.timing;
    } else if (questionId.contains('scope')) {
      return QuestionCategory.scope;
    } else if (questionId.contains('tech')) {
      return QuestionCategory.technical;
    } else {
      return QuestionCategory.logistics;
    }
  }
}

/// Questionnaire metadata
class QuestionnaireMetadata extends Equatable {
  final String id;
  final String name;
  final String description;
  final String version;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String author;
  final bool isActive;
  final List<String> tags;

  const QuestionnaireMetadata({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.isActive,
    required this.tags,
  });

  factory QuestionnaireMetadata.fromJson(Map<String, dynamic> json) {
    return QuestionnaireMetadata(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      version: json['version'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      author: json['author'] as String,
      isActive: json['is_active'] as bool,
      tags: List<String>.from(json['tags'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'version': version,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author': author,
      'is_active': isActive,
      'tags': tags,
    };
  }

  @override
  List<Object?> get props => [id, name, description, version, type, createdAt, updatedAt, author, isActive, tags];
}

/// Individual question definition
class QuestionDefinition extends Equatable {
  final String id;
  final String question;
  final String? info;
  final QuestionAnswerType answerType;
  final String trigger;
  final List<String>? options;
  final List<String>? displayFields;
  final String? linkedField;
  final bool autoPopulate;
  final List<String>? validationRoles;

  const QuestionDefinition({
    required this.id,
    required this.question,
    this.info,
    required this.answerType,
    required this.trigger,
    this.options,
    this.displayFields,
    this.linkedField,
    this.autoPopulate = false,
    this.validationRoles,
  });

  factory QuestionDefinition.fromJson(Map<String, dynamic> json) {
    return QuestionDefinition(
      id: json['id'] as String,
      question: json['question'] as String,
      info: json['info'] as String?,
      answerType: QuestionAnswerType.fromString(json['answer_type'] as String),
      trigger: json['trigger'] as String,
      options: json['options'] != null ? List<String>.from(json['options'] as List) : null,
      displayFields: json['display_fields'] != null ? List<String>.from(json['display_fields'] as List) : null,
      linkedField: json['linked_field'] as String?,
      autoPopulate: json['auto_populate'] as bool? ?? false,
      validationRoles: json['validation_roles'] != null ? List<String>.from(json['validation_roles'] as List) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'info': info,
      'answer_type': answerType.name,
      'trigger': trigger,
      'options': options,
      'display_fields': displayFields,
      'linked_field': linkedField,
      'auto_populate': autoPopulate,
      'validation_roles': validationRoles,
    };
  }

  /// Get the category of this question based on its ID
  QuestionCategory get category => QuestionCategory.fromQuestionId(id);

  @override
  List<Object?> get props => [id, question, info, answerType, trigger, options, displayFields, linkedField, autoPopulate, validationRoles];
}

/// Complete questionnaire configuration
class QuestionnaireConfiguration extends Equatable {
  final QuestionnaireMetadata metadata;
  final List<QuestionDefinition> questions;

  const QuestionnaireConfiguration({
    required this.metadata,
    required this.questions,
  });

  factory QuestionnaireConfiguration.fromJson(Map<String, dynamic> json) {
    return QuestionnaireConfiguration(
      metadata: QuestionnaireMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      questions: (json['questions'] as List)
          .map((q) => QuestionDefinition.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata.toJson(),
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [metadata, questions];
}

/// Question answer/response
class QuestionAnswer extends Equatable {
  final String questionId;
  final dynamic answer;
  final QuestionStatus status;
  final DateTime? answeredAt;
  final String? notes;

  const QuestionAnswer({
    required this.questionId,
    this.answer,
    required this.status,
    this.answeredAt,
    this.notes,
  });

  factory QuestionAnswer.fromJson(Map<String, dynamic> json) {
    return QuestionAnswer(
      questionId: json['question_id'] as String,
      answer: json['answer'],
      status: QuestionStatus.values.byName(json['status'] as String),
      answeredAt: json['answered_at'] != null ? DateTime.parse(json['answered_at'] as String) : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'answer': answer,
      'status': status.name,
      'answered_at': answeredAt?.toIso8601String(),
      'notes': notes,
    };
  }

  QuestionAnswer copyWith({
    String? questionId,
    dynamic answer,
    QuestionStatus? status,
    DateTime? answeredAt,
    String? notes,
  }) {
    return QuestionAnswer(
      questionId: questionId ?? this.questionId,
      answer: answer ?? this.answer,
      status: status ?? this.status,
      answeredAt: answeredAt ?? this.answeredAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [questionId, answer, status, answeredAt, notes];
}

/// Questionnaire session state
class QuestionnaireSession extends Equatable {
  final String id;
  final String projectId;
  final String questionnaireId;
  final Map<String, QuestionAnswer> answers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isCompleted;

  const QuestionnaireSession({
    required this.id,
    required this.projectId,
    required this.questionnaireId,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
    required this.isCompleted,
  });

  factory QuestionnaireSession.fromJson(Map<String, dynamic> json) {
    final answersJson = json['answers'] as Map<String, dynamic>;
    final answers = <String, QuestionAnswer>{};
    
    for (final entry in answersJson.entries) {
      answers[entry.key] = QuestionAnswer.fromJson(entry.value as Map<String, dynamic>);
    }

    return QuestionnaireSession(
      id: json['id'] as String,
      projectId: json['project_id'] as String,
      questionnaireId: json['questionnaire_id'] as String,
      answers: answers,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isCompleted: json['is_completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    final answersJson = <String, dynamic>{};
    for (final entry in answers.entries) {
      answersJson[entry.key] = entry.value.toJson();
    }

    return {
      'id': id,
      'project_id': projectId,
      'questionnaire_id': questionnaireId,
      'answers': answersJson,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_completed': isCompleted,
    };
  }

  QuestionnaireSession copyWith({
    String? id,
    String? projectId,
    String? questionnaireId,
    Map<String, QuestionAnswer>? answers,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isCompleted,
  }) {
    return QuestionnaireSession(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      questionnaireId: questionnaireId ?? this.questionnaireId,
      answers: answers ?? this.answers,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// Get answer for a specific question
  QuestionAnswer? getAnswer(String questionId) {
    return answers[questionId];
  }

  /// Update answer for a question
  QuestionnaireSession updateAnswer(String questionId, QuestionAnswer answer) {
    final newAnswers = Map<String, QuestionAnswer>.from(answers);
    newAnswers[questionId] = answer;

    return copyWith(
      answers: newAnswers,
      updatedAt: DateTime.now(),
    );
  }

  /// Get completion statistics
  Map<String, int> get statistics {
    final stats = <String, int>{
      'total': 0,
      'completed': 0,
      'inProgress': 0,
      'pending': 0,
      'blocked': 0,
    };

    for (final answer in answers.values) {
      stats['total'] = (stats['total'] ?? 0) + 1;
      stats[answer.status.name] = (stats[answer.status.name] ?? 0) + 1;
    }

    return stats;
  }

  @override
  List<Object?> get props => [id, projectId, questionnaireId, answers, createdAt, updatedAt, isCompleted];
}