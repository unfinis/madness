import 'package:flutter/material.dart';

/// Theme constants and utilities for trigger system UI components
class TriggerSystemTheme {
  // Priority colors
  static const Map<String, Color> priorityColors = {
    'critical': Color(0xFFD32F2F),
    'high': Color(0xFFF57C00),
    'medium': Color(0xFFFBC02D),
    'low': Color(0xFF1976D2),
    'minimal': Color(0xFF616161),
  };

  // Match status colors
  static const Map<String, Color> matchColors = {
    'matched': Color(0xFF4CAF50),
    'not_matched': Color(0xFF9E9E9E),
    'error': Color(0xFFE53935),
  };

  // Execution status colors
  static const Map<String, Color> executionColors = {
    'running': Color(0xFF2196F3),
    'success': Color(0xFF4CAF50),
    'failed': Color(0xFFE53935),
    'pending': Color(0xFF9E9E9E),
    'skipped': Color(0xFFFF9800),
  };

  /// Get color for a priority level
  static Color getPriorityColor(String level) {
    return priorityColors[level.toLowerCase()] ?? priorityColors['minimal']!;
  }

  /// Get color for match status
  static Color getMatchColor(bool matched) {
    return matched ? matchColors['matched']! : matchColors['not_matched']!;
  }

  /// Get color for execution status
  static Color getExecutionColor(String status) {
    return executionColors[status.toLowerCase()] ?? executionColors['pending']!;
  }

  /// Create a decoration for priority-based containers
  static BoxDecoration priorityDecoration(String level) {
    final color = getPriorityColor(level);
    return BoxDecoration(
      color: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Create a text style for priority labels
  static TextStyle priorityTextStyle(String level, {double? fontSize}) {
    final color = getPriorityColor(level);
    return TextStyle(
      color: color,
      fontWeight: FontWeight.bold,
      fontSize: fontSize ?? 14,
    );
  }

  /// Create a decoration for match status
  static BoxDecoration matchDecoration(bool matched) {
    final color = getMatchColor(matched);
    return BoxDecoration(
      color: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Create a decoration for execution status
  static BoxDecoration executionDecoration(String status) {
    final color = getExecutionColor(status);
    return BoxDecoration(
      color: color.withOpacity(0.1),
      border: Border.all(color: color.withOpacity(0.3)),
      borderRadius: BorderRadius.circular(4),
    );
  }

  /// Create a chip theme for priority badges
  static ChipThemeData priorityChipTheme(BuildContext context, String level) {
    final color = getPriorityColor(level);
    return ChipThemeData(
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      side: BorderSide(color: color),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  /// Icon for priority level
  static IconData priorityIcon(String level) {
    switch (level.toLowerCase()) {
      case 'critical':
        return Icons.warning;
      case 'high':
        return Icons.arrow_upward;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.arrow_downward;
      default:
        return Icons.help_outline;
    }
  }

  /// Icon for execution status
  static IconData executionIcon(String status) {
    switch (status.toLowerCase()) {
      case 'running':
        return Icons.play_circle;
      case 'success':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'pending':
        return Icons.schedule;
      case 'skipped':
        return Icons.skip_next;
      default:
        return Icons.help_outline;
    }
  }

  /// Standard card elevation for trigger cards
  static const double cardElevation = 2.0;

  /// Standard spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  /// Standard border radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;

  /// Icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeLarge = 24.0;
}
