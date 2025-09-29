import 'package:flutter/material.dart';

/// Centralized decoration patterns for consistent UI
class AppDecorations {
  AppDecorations._();

  /// Standard card decoration with subtle colored border
  static BoxDecoration subtleCard(Color color, {double radius = 8}) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    );
  }

  /// Success state decoration
  static BoxDecoration success({double radius = 8}) {
    return subtleCard(Colors.green, radius: radius);
  }

  /// Error state decoration
  static BoxDecoration error({double radius = 8}) {
    return subtleCard(Colors.red, radius: radius);
  }

  /// Warning state decoration
  static BoxDecoration warning({double radius = 8}) {
    return subtleCard(Colors.orange, radius: radius);
  }

  /// Info state decoration
  static BoxDecoration info({double radius = 8}) {
    return subtleCard(Colors.blue, radius: radius);
  }

  /// Neutral/default decoration
  static BoxDecoration neutral({double radius = 8}) {
    return BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: Colors.grey[300]!),
    );
  }

  /// Card decoration with elevation effect
  static BoxDecoration elevatedCard({
    double radius = 8,
    Color? color,
    List<BoxShadow>? customShadows,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(radius),
      boxShadow: customShadows ??
          [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
    );
  }

  /// Gradient decoration
  static BoxDecoration gradient({
    required List<Color> colors,
    double radius = 8,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: begin,
        end: end,
      ),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  /// Dashed border decoration (requires custom painter)
  static BoxDecoration dashedBorder({
    Color color = Colors.grey,
    double radius = 8,
  }) {
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: color,
        style: BorderStyle.solid, // Note: Flutter doesn't support dashed borders directly
      ),
    );
  }

  /// Selection/highlight decoration
  static BoxDecoration selected({
    Color? primaryColor,
    double radius = 8,
  }) {
    final color = primaryColor ?? Colors.blue;
    return BoxDecoration(
      color: color.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: color, width: 2),
    );
  }
}

/// Common text styles for consistency
class AppTextStyles {
  AppTextStyles._();

  /// Status text style
  static TextStyle statusText(Color color, {double fontSize = 12}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  /// Label text style
  static TextStyle label({Color? color, double fontSize = 12}) {
    return TextStyle(
      color: color ?? Colors.grey[600],
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }

  /// Badge text style
  static TextStyle badge(Color color, {double fontSize = 11}) {
    return TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
    );
  }

  /// Monospace/code text style
  static TextStyle code({Color? color, double fontSize = 13}) {
    return TextStyle(
      fontFamily: 'monospace',
      color: color ?? Colors.grey[800],
      fontSize: fontSize,
    );
  }

  /// Emphasized text style
  static TextStyle emphasized({Color? color, double fontSize = 14}) {
    return TextStyle(
      color: color ?? Colors.grey[900],
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
    );
  }

  /// Subtle/muted text style
  static TextStyle muted({double fontSize = 13}) {
    return TextStyle(
      color: Colors.grey[500],
      fontSize: fontSize,
    );
  }

  /// Error text style
  static const TextStyle error = TextStyle(
    color: Colors.red,
    fontSize: 12,
  );

  /// Success text style
  static const TextStyle success = TextStyle(
    color: Colors.green,
    fontSize: 12,
  );

  /// Warning text style
  static TextStyle warning = TextStyle(
    color: Colors.orange[700]!,
    fontSize: 12,
  );
}

/// Common shadow effects
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> small = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];
}

/// Common border styles
class AppBorders {
  AppBorders._();

  static Border subtle(Color color) {
    return Border.all(
      color: color.withValues(alpha: 0.2),
      width: 1,
    );
  }

  static Border normal(Color color) {
    return Border.all(
      color: color.withValues(alpha: 0.3),
      width: 1,
    );
  }

  static Border strong(Color color) {
    return Border.all(
      color: color,
      width: 2,
    );
  }

  static Border selected(Color color) {
    return Border.all(
      color: color,
      width: 2,
    );
  }
}