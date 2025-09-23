import 'package:flutter/material.dart';

enum TaskCategory {
  admin,
  legal,
  setup,
  communication,
}

enum TaskStatus {
  pending,
  inProgress,
  urgent,
  completed,
}

enum TaskPriority {
  low,
  medium,
  high,
}

class Task {
  final String id;
  final String title;
  final String? description;
  final TaskCategory category;
  final TaskStatus status;
  final TaskPriority priority;
  final String? assignedTo;
  final DateTime? dueDate;
  final int progress;
  final DateTime createdDate;
  final DateTime? completedDate;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.category,
    required this.status,
    required this.priority,
    this.assignedTo,
    this.dueDate,
    this.progress = 0,
    required this.createdDate,
    this.completedDate,
  });

  bool get isOverdue {
    if (dueDate == null || status == TaskStatus.completed) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueSoon {
    if (dueDate == null || status == TaskStatus.completed) return false;
    final now = DateTime.now();
    final daysDiff = dueDate!.difference(now).inDays;
    return daysDiff >= 0 && daysDiff <= 2;
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskStatus? status,
    TaskPriority? priority,
    String? assignedTo,
    DateTime? dueDate,
    int? progress,
    DateTime? createdDate,
    DateTime? completedDate,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      assignedTo: assignedTo ?? this.assignedTo,
      dueDate: dueDate ?? this.dueDate,
      progress: progress ?? this.progress,
      createdDate: createdDate ?? this.createdDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

extension TaskCategoryExtension on TaskCategory {
  String get displayName {
    switch (this) {
      case TaskCategory.admin:
        return 'Administrative';
      case TaskCategory.legal:
        return 'Legal';
      case TaskCategory.setup:
        return 'Setup';
      case TaskCategory.communication:
        return 'Communication';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskCategory.admin:
        return Icons.admin_panel_settings;
      case TaskCategory.legal:
        return Icons.gavel;
      case TaskCategory.setup:
        return Icons.build;
      case TaskCategory.communication:
        return Icons.chat;
    }
  }
}

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.urgent:
        return 'Urgent';
      case TaskStatus.completed:
        return 'Completed';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.inProgress:
        return Icons.play_circle;
      case TaskStatus.urgent:
        return Icons.priority_high;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }
}

extension TaskPriorityExtension on TaskPriority {
  String get displayName {
    switch (this) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
    }
  }

  IconData get icon {
    switch (this) {
      case TaskPriority.low:
        return Icons.keyboard_arrow_down;
      case TaskPriority.medium:
        return Icons.remove;
      case TaskPriority.high:
        return Icons.keyboard_arrow_up;
    }
  }
}