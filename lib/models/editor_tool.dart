import 'package:flutter/material.dart';

enum EditorTool {
  select,
  pan,
  crop,
  move,
  arrow,
  highlightRect,
  text,
  numberLabel,
  redactBlackout,
  redactBlur,
  redactPixelate,
  guide,
}

extension EditorToolExtension on EditorTool {
  String get displayName {
    switch (this) {
      case EditorTool.select:
        return 'Select';
      case EditorTool.pan:
        return 'Pan';
      case EditorTool.crop:
        return 'Crop';
      case EditorTool.move:
        return 'Move';
      case EditorTool.arrow:
        return 'Arrow';
      case EditorTool.highlightRect:
        return 'Highlight Rectangle';
      case EditorTool.numberLabel:
        return 'Number Label';
      case EditorTool.text:
        return 'Text';
      case EditorTool.redactBlackout:
        return 'Blackout';
      case EditorTool.redactBlur:
        return 'Blur';
      case EditorTool.redactPixelate:
        return 'Pixelate';
      case EditorTool.guide:
        return 'Guide';
    }
  }

  IconData get icon {
    switch (this) {
      case EditorTool.select:
        return Icons.mouse;
      case EditorTool.pan:
        return Icons.pan_tool;
      case EditorTool.crop:
        return Icons.crop;
      case EditorTool.move:
        return Icons.open_with;
      case EditorTool.arrow:
        return Icons.arrow_outward;
      case EditorTool.highlightRect:
        return Icons.crop_square;
      case EditorTool.numberLabel:
        return Icons.looks_one;
      case EditorTool.text:
        return Icons.text_fields;
      case EditorTool.redactBlackout:
        return Icons.block;
      case EditorTool.redactBlur:
        return Icons.blur_on;
      case EditorTool.redactPixelate:
        return Icons.grid_on;
      case EditorTool.guide:
        return Icons.straighten;
    }
  }

  String get shortcut {
    switch (this) {
      case EditorTool.select:
        return 'V';
      case EditorTool.pan:
        return 'H';
      case EditorTool.crop:
        return 'C';
      case EditorTool.move:
        return 'M';
      case EditorTool.arrow:
        return 'A';
      case EditorTool.highlightRect:
        return 'R';
      case EditorTool.numberLabel:
        return 'N';
      case EditorTool.text:
        return 'T';
      case EditorTool.redactBlackout:
        return 'X';
      case EditorTool.redactBlur:
        return 'U';
      case EditorTool.redactPixelate:
        return 'P';
      case EditorTool.guide:
        return 'G';
    }
  }

  bool get isRedactionTool {
    switch (this) {
      case EditorTool.redactBlackout:
      case EditorTool.redactBlur:
      case EditorTool.redactPixelate:
        return true;
      default:
        return false;
    }
  }

  bool get isAnnotationTool {
    switch (this) {
      case EditorTool.arrow:
      case EditorTool.highlightRect:
      case EditorTool.text:
      case EditorTool.numberLabel:
        return true;
      default:
        return false;
    }
  }

  bool get isShapeTool {
    switch (this) {
      case EditorTool.arrow:
      case EditorTool.highlightRect:
        return true;
      default:
        return false;
    }
  }
}

class ToolConfig {
  final EditorTool tool;
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;
  final double opacity;
  final Map<String, dynamic> toolSpecificSettings;

  const ToolConfig({
    required this.tool,
    this.primaryColor = Colors.red,
    this.secondaryColor = Colors.transparent,
    this.strokeWidth = 2.0,
    this.opacity = 1.0,
    this.toolSpecificSettings = const {},
  });

  ToolConfig copyWith({
    EditorTool? tool,
    Color? primaryColor,
    Color? secondaryColor,
    double? strokeWidth,
    double? opacity,
    Map<String, dynamic>? toolSpecificSettings,
  }) {
    return ToolConfig(
      tool: tool ?? this.tool,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      opacity: opacity ?? this.opacity,
      toolSpecificSettings: toolSpecificSettings ?? this.toolSpecificSettings,
    );
  }

  // Predefined tool configurations
  static ToolConfig get defaultHighlight => const ToolConfig(
        tool: EditorTool.highlightRect,
        primaryColor: Color(0xFFFF0000), // Red stroke
        secondaryColor: Colors.transparent, // No fill by default
        strokeWidth: 2.0,
        toolSpecificSettings: {
          'hasFill': false, // Default to no fill
          'hasStroke': true,
        },
      );


  static ToolConfig get defaultText => const ToolConfig(
        tool: EditorTool.text,
        primaryColor: Colors.black,
        toolSpecificSettings: {
          'fontSize': 16.0,
          'fontFamily': 'Arial',
          'bold': false,
          'italic': false,
        },
      );

  static ToolConfig get defaultArrow => const ToolConfig(
        tool: EditorTool.arrow,
        primaryColor: Colors.red,
        strokeWidth: 3.0,
        toolSpecificSettings: {
          'arrowHeadSize': 15.0,
          'arrowHeadAngle': 0.5,
        },
      );

  static ToolConfig get defaultNumberLabel => const ToolConfig(
        tool: EditorTool.numberLabel,
        primaryColor: Colors.white,
        secondaryColor: Colors.red,
        strokeWidth: 2.0,
        toolSpecificSettings: {
          'fontSize': 16.0,
          'fontFamily': 'Arial',
          'bold': true,
          'italic': false,
          'circleRadius': 12.0,
          'number': 1,
        },
      );

  static ToolConfig get defaultBlackout => const ToolConfig(
        tool: EditorTool.redactBlackout,
        primaryColor: Colors.black,
      );

  static ToolConfig get defaultBlur => const ToolConfig(
        tool: EditorTool.redactBlur,
        primaryColor: Colors.grey,
        toolSpecificSettings: {
          'blurRadius': 10.0,
        },
      );

  static ToolConfig get defaultPixelate => const ToolConfig(
        tool: EditorTool.redactPixelate,
        primaryColor: Colors.grey,
        toolSpecificSettings: {
          'pixelSize': 20,
        },
      );

  // Severity-based presets for annotations
  static ToolConfig criticalPreset(EditorTool tool) {
    return ToolConfig(
      tool: tool,
      primaryColor: const Color(0xFFDC2626), // Red
      strokeWidth: tool == EditorTool.text ? 1.0 : 3.0,
      toolSpecificSettings: tool == EditorTool.text
          ? {
              'fontSize': 16.0,
              'fontFamily': 'Arial',
              'bold': true,
              'italic': false,
              'backgroundColor': const Color(0xFFFEE2E2), // Light red background
            }
          : {},
    );
  }

  static ToolConfig highPreset(EditorTool tool) {
    return ToolConfig(
      tool: tool,
      primaryColor: const Color(0xFFEA580C), // Orange
      strokeWidth: tool == EditorTool.text ? 1.0 : 2.5,
      toolSpecificSettings: tool == EditorTool.text
          ? {
              'fontSize': 15.0,
              'fontFamily': 'Arial',
              'bold': true,
              'italic': false,
              'backgroundColor': const Color(0xFFFED7AA), // Light orange background
            }
          : {},
    );
  }

  static ToolConfig mediumPreset(EditorTool tool) {
    return ToolConfig(
      tool: tool,
      primaryColor: const Color(0xFFCA8A04), // Yellow/Amber
      strokeWidth: tool == EditorTool.text ? 1.0 : 2.0,
      toolSpecificSettings: tool == EditorTool.text
          ? {
              'fontSize': 14.0,
              'fontFamily': 'Arial',
              'bold': false,
              'italic': false,
              'backgroundColor': const Color(0xFFFEF3C7), // Light yellow background
            }
          : {},
    );
  }

  static ToolConfig lowPreset(EditorTool tool) {
    return ToolConfig(
      tool: tool,
      primaryColor: const Color(0xFF059669), // Green
      strokeWidth: tool == EditorTool.text ? 1.0 : 1.5,
      toolSpecificSettings: tool == EditorTool.text
          ? {
              'fontSize': 13.0,
              'fontFamily': 'Arial',
              'bold': false,
              'italic': false,
              'backgroundColor': const Color(0xFFD1FAE5), // Light green background
            }
          : {},
    );
  }

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'tool': tool.name,
      'primaryColor': primaryColor.value,
      'secondaryColor': secondaryColor.value,
      'strokeWidth': strokeWidth,
      'opacity': opacity,
      'toolSpecificSettings': toolSpecificSettings,
    };
  }

  factory ToolConfig.fromJson(Map<String, dynamic> json) {
    return ToolConfig(
      tool: EditorTool.values.byName(json['tool'] as String),
      primaryColor: Color(json['primaryColor'] as int),
      secondaryColor: Color(json['secondaryColor'] as int),
      strokeWidth: json['strokeWidth'] as double,
      opacity: json['opacity'] as double,
      toolSpecificSettings:
          Map<String, dynamic>.from(json['toolSpecificSettings'] as Map),
    );
  }

  @override
  String toString() {
    return 'ToolConfig(tool: $tool, primaryColor: $primaryColor, strokeWidth: $strokeWidth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ToolConfig &&
        other.tool == tool &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.strokeWidth == strokeWidth &&
        other.opacity == opacity;
  }

  @override
  int get hashCode {
    return Object.hash(
      tool,
      primaryColor,
      secondaryColor,
      strokeWidth,
      opacity,
    );
  }
}