import 'package:flutter/material.dart';
import 'editor_tool.dart';

/// Defines a preset configuration for a tool
class ToolPreset {
  final String id;
  final String name;
  final String? description;
  final Color? previewColor;
  final ToolConfig config;
  final bool isDefault;

  const ToolPreset({
    required this.id,
    required this.name,
    this.description,
    this.previewColor,
    required this.config,
    this.isDefault = false,
  });

  ToolPreset copyWith({
    String? id,
    String? name,
    String? description,
    Color? previewColor,
    ToolConfig? config,
    bool? isDefault,
  }) {
    return ToolPreset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      previewColor: previewColor ?? this.previewColor,
      config: config ?? this.config,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'previewColor': previewColor?.toARGB32(),
      'config': config.toJson(),
      'isDefault': isDefault,
    };
  }

  factory ToolPreset.fromJson(Map<String, dynamic> json) {
    return ToolPreset(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      previewColor: json['previewColor'] != null
          ? Color(json['previewColor'] as int)
          : null,
      config: ToolConfig.fromJson(json['config'] as Map<String, dynamic>),
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ToolPreset && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Manages presets for editor tools
class ToolPresetManager {
  static final Map<EditorTool, List<ToolPreset>> _presets = {};

  /// Gets all presets for a tool
  static List<ToolPreset> getPresetsForTool(EditorTool tool) {
    return _presets[tool] ?? _getDefaultPresets(tool);
  }

  /// Checks if a tool should have presets
  static bool toolSupportsPresets(EditorTool tool) {
    switch (tool) {
      case EditorTool.crop:
      case EditorTool.select:
      case EditorTool.move:
      case EditorTool.pan:
      case EditorTool.guide:
        return false; // These tools don't need presets
      default:
        return true;
    }
  }

  /// Gets the default preset for a tool (always the first one)
  static ToolPreset getDefaultPreset(EditorTool tool) {
    final presets = getPresetsForTool(tool);
    return presets.firstWhere(
      (preset) => preset.isDefault,
      orElse: () => presets.first,
    );
  }

  /// Sets presets for a tool (for future configuration)
  static void setPresetsForTool(EditorTool tool, List<ToolPreset> presets) {
    _presets[tool] = presets;
  }

  /// Gets default presets for each tool type
  static List<ToolPreset> _getDefaultPresets(EditorTool tool) {
    switch (tool) {
      case EditorTool.arrow:
        return _getArrowPresets();
      case EditorTool.highlightRect:
        return _getHighlightPresets();
      case EditorTool.text:
        return _getTextPresets();
      case EditorTool.numberLabel:
        return _getNumberLabelPresets();
      case EditorTool.redactBlackout:
        return _getBlackoutPresets();
      case EditorTool.redactBlur:
        return _getBlurPresets();
      case EditorTool.redactPixelate:
        return _getPixelatePresets();
      default:
        return [
          ToolPreset(
            id: 'default',
            name: 'Default',
            config: _getToolDefaultConfig(tool),
            isDefault: true,
          ),
        ];
    }
  }

  static ToolConfig _getToolDefaultConfig(EditorTool tool) {
    switch (tool) {
      case EditorTool.arrow:
        return ToolConfig.defaultArrow;
      case EditorTool.highlightRect:
        return ToolConfig.defaultHighlight;
      case EditorTool.text:
        return ToolConfig.defaultText;
      case EditorTool.numberLabel:
        return ToolConfig.defaultNumberLabel;
      case EditorTool.redactBlackout:
        return ToolConfig.defaultBlackout;
      case EditorTool.redactBlur:
        return ToolConfig.defaultBlur;
      case EditorTool.redactPixelate:
        return ToolConfig.defaultPixelate;
      default:
        return ToolConfig(tool: tool);
    }
  }

  static List<ToolPreset> _getArrowPresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.red,
        config: ToolConfig.defaultArrow,
        isDefault: true,
      ),
      ToolPreset(
        id: 'critical',
        name: 'Critical',
        previewColor: const Color(0xFFDC2626),
        config: ToolConfig.criticalPreset(EditorTool.arrow),
      ),
      ToolPreset(
        id: 'high',
        name: 'High',
        previewColor: const Color(0xFFEA580C),
        config: ToolConfig.highPreset(EditorTool.arrow),
      ),
      ToolPreset(
        id: 'medium',
        name: 'Medium',
        previewColor: const Color(0xFFCA8A04),
        config: ToolConfig.mediumPreset(EditorTool.arrow),
      ),
      ToolPreset(
        id: 'low',
        name: 'Low',
        previewColor: const Color(0xFF059669),
        config: ToolConfig.lowPreset(EditorTool.arrow),
      ),
    ];
  }

  static List<ToolPreset> _getHighlightPresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.red,
        config: ToolConfig.defaultHighlight,
        isDefault: true,
      ),
      ToolPreset(
        id: 'critical',
        name: 'Critical',
        previewColor: const Color(0xFFDC2626),
        config: ToolConfig.criticalPreset(EditorTool.highlightRect).copyWith(
          secondaryColor: const Color(0xFFFEE2E2), // Light red fill
          toolSpecificSettings: {
            'hasFill': true,
            'hasStroke': true,
          },
        ),
      ),
      ToolPreset(
        id: 'high',
        name: 'High',
        previewColor: const Color(0xFFEA580C),
        config: ToolConfig.highPreset(EditorTool.highlightRect).copyWith(
          secondaryColor: const Color(0xFFFED7AA), // Light orange fill
          toolSpecificSettings: {
            'hasFill': true,
            'hasStroke': true,
          },
        ),
      ),
      ToolPreset(
        id: 'medium',
        name: 'Medium',
        previewColor: const Color(0xFFCA8A04),
        config: ToolConfig.mediumPreset(EditorTool.highlightRect).copyWith(
          secondaryColor: const Color(0xFFFEF3C7), // Light yellow fill
          toolSpecificSettings: {
            'hasFill': true,
            'hasStroke': true,
          },
        ),
      ),
      ToolPreset(
        id: 'low',
        name: 'Low',
        previewColor: const Color(0xFF059669),
        config: ToolConfig.lowPreset(EditorTool.highlightRect).copyWith(
          secondaryColor: const Color(0xFFD1FAE5), // Light green fill
          toolSpecificSettings: {
            'hasFill': true,
            'hasStroke': true,
          },
        ),
      ),
      ToolPreset(
        id: 'outline-only',
        name: 'Outline Only',
        previewColor: Colors.red,
        config: ToolConfig.defaultHighlight.copyWith(
          secondaryColor: Colors.transparent,
          toolSpecificSettings: {
            'hasFill': false,
            'hasStroke': true,
          },
        ),
      ),
    ];
  }

  static List<ToolPreset> _getTextPresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.black,
        config: ToolConfig.defaultText,
        isDefault: true,
      ),
      ToolPreset(
        id: 'critical',
        name: 'Critical',
        previewColor: const Color(0xFFDC2626),
        config: ToolConfig.criticalPreset(EditorTool.text),
      ),
      ToolPreset(
        id: 'high',
        name: 'High',
        previewColor: const Color(0xFFEA580C),
        config: ToolConfig.highPreset(EditorTool.text),
      ),
      ToolPreset(
        id: 'medium',
        name: 'Medium',
        previewColor: const Color(0xFFCA8A04),
        config: ToolConfig.mediumPreset(EditorTool.text),
      ),
      ToolPreset(
        id: 'low',
        name: 'Low',
        previewColor: const Color(0xFF059669),
        config: ToolConfig.lowPreset(EditorTool.text),
      ),
      ToolPreset(
        id: 'large-title',
        name: 'Large Title',
        previewColor: Colors.black,
        config: ToolConfig.defaultText.copyWith(
          toolSpecificSettings: {
            'fontSize': 24.0,
            'fontFamily': 'Arial',
            'bold': true,
            'italic': false,
          },
        ),
      ),
    ];
  }

  static List<ToolPreset> _getNumberLabelPresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.red,
        config: ToolConfig.defaultNumberLabel,
        isDefault: true,
      ),
      ToolPreset(
        id: 'critical',
        name: 'Critical',
        previewColor: const Color(0xFFDC2626),
        config: ToolConfig.defaultNumberLabel.copyWith(
          primaryColor: Colors.white,
          secondaryColor: const Color(0xFFDC2626),
        ),
      ),
      ToolPreset(
        id: 'high',
        name: 'High',
        previewColor: const Color(0xFFEA580C),
        config: ToolConfig.defaultNumberLabel.copyWith(
          primaryColor: Colors.white,
          secondaryColor: const Color(0xFFEA580C),
        ),
      ),
      ToolPreset(
        id: 'medium',
        name: 'Medium',
        previewColor: const Color(0xFFCA8A04),
        config: ToolConfig.defaultNumberLabel.copyWith(
          primaryColor: Colors.black,
          secondaryColor: const Color(0xFFCA8A04),
        ),
      ),
      ToolPreset(
        id: 'low',
        name: 'Low',
        previewColor: const Color(0xFF059669),
        config: ToolConfig.defaultNumberLabel.copyWith(
          primaryColor: Colors.white,
          secondaryColor: const Color(0xFF059669),
        ),
      ),
    ];
  }

  static List<ToolPreset> _getBlackoutPresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.black,
        config: ToolConfig.defaultBlackout,
        isDefault: true,
      ),
    ];
  }

  static List<ToolPreset> _getBlurPresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.grey,
        config: ToolConfig.defaultBlur,
        isDefault: true,
      ),
      ToolPreset(
        id: 'light-blur',
        name: 'Light Blur',
        previewColor: Colors.grey,
        config: ToolConfig.defaultBlur.copyWith(
          toolSpecificSettings: {
            'blurRadius': 5.0,
          },
        ),
      ),
      ToolPreset(
        id: 'heavy-blur',
        name: 'Heavy Blur',
        previewColor: Colors.grey,
        config: ToolConfig.defaultBlur.copyWith(
          toolSpecificSettings: {
            'blurRadius': 20.0,
          },
        ),
      ),
    ];
  }

  static List<ToolPreset> _getPixelatePresets() {
    return [
      ToolPreset(
        id: 'default',
        name: 'Default',
        previewColor: Colors.grey,
        config: ToolConfig.defaultPixelate,
        isDefault: true,
      ),
      ToolPreset(
        id: 'fine-pixels',
        name: 'Fine',
        previewColor: Colors.grey,
        config: ToolConfig.defaultPixelate.copyWith(
          toolSpecificSettings: {
            'pixelSize': 10,
          },
        ),
      ),
      ToolPreset(
        id: 'coarse-pixels',
        name: 'Coarse',
        previewColor: Colors.grey,
        config: ToolConfig.defaultPixelate.copyWith(
          toolSpecificSettings: {
            'pixelSize': 40,
          },
        ),
      ),
    ];
  }
}