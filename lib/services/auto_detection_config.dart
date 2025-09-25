import 'package:flutter/material.dart';
import 'auto_guide_generator.dart';
import 'auto_redaction_service.dart';
import 'sensitive_data_detector.dart';

/// Padding configuration for different auto-detection features
class PaddingConfig {
  final int guidePadding;
  final int redactionPadding;
  final int consolePadding;
  final int uiElementPadding;
  final int textBlockPadding;
  final bool useUniformPadding;

  const PaddingConfig({
    this.guidePadding = 4,
    this.redactionPadding = 6,
    this.consolePadding = 8,
    this.uiElementPadding = 12,
    this.textBlockPadding = 4,
    this.useUniformPadding = false,
  });

  /// Get padding for specific context
  int getPaddingFor(PaddingContext context) {
    if (useUniformPadding) {
      return guidePadding; // Use guide padding as base when uniform
    }

    switch (context) {
      case PaddingContext.guide:
        return guidePadding;
      case PaddingContext.redaction:
        return redactionPadding;
      case PaddingContext.console:
        return consolePadding;
      case PaddingContext.uiElement:
        return uiElementPadding;
      case PaddingContext.textBlock:
        return textBlockPadding;
    }
  }

  PaddingConfig copyWith({
    int? guidePadding,
    int? redactionPadding,
    int? consolePadding,
    int? uiElementPadding,
    int? textBlockPadding,
    bool? useUniformPadding,
  }) {
    return PaddingConfig(
      guidePadding: guidePadding ?? this.guidePadding,
      redactionPadding: redactionPadding ?? this.redactionPadding,
      consolePadding: consolePadding ?? this.consolePadding,
      uiElementPadding: uiElementPadding ?? this.uiElementPadding,
      textBlockPadding: textBlockPadding ?? this.textBlockPadding,
      useUniformPadding: useUniformPadding ?? this.useUniformPadding,
    );
  }

  @override
  String toString() => 'PaddingConfig(guide: $guidePadding, redaction: $redactionPadding)';
}

/// Context for padding application
enum PaddingContext {
  guide,
  redaction,
  console,
  uiElement,
  textBlock,
}

/// Detection sensitivity levels
enum DetectionSensitivity {
  low,
  medium,
  high,
  maximum,
}

/// Comprehensive configuration for auto-detection features
class AutoDetectionConfig {
  // General settings
  final bool enableAutoGuides;
  final bool enableAutoRedaction;
  final DetectionSensitivity sensitivity;
  final PaddingConfig paddingConfig;

  // Guide generation settings
  final AutoGuideConfig guideConfig;

  // Redaction settings
  final AutoRedactionConfig redactionConfig;

  // Processing settings
  final bool processInBackground;
  final bool showProgressIndicator;
  final bool autoApplyHighConfidenceRedactions;
  final bool groupSimilarDetections;

  const AutoDetectionConfig({
    this.enableAutoGuides = true,
    this.enableAutoRedaction = true,
    this.sensitivity = DetectionSensitivity.medium,
    this.paddingConfig = const PaddingConfig(),
    this.guideConfig = const AutoGuideConfig(),
    this.redactionConfig = const AutoRedactionConfig(),
    this.processInBackground = true,
    this.showProgressIndicator = true,
    this.autoApplyHighConfidenceRedactions = false,
    this.groupSimilarDetections = true,
  });

  /// Get guide config with applied padding settings
  AutoGuideConfig getGuideConfigWithPadding() {
    return AutoGuideConfig(
      detectConsoleOutput: guideConfig.detectConsoleOutput,
      detectUIElements: guideConfig.detectUIElements,
      detectTextBlocks: guideConfig.detectTextBlocks,
      confidenceThreshold: _getConfidenceThreshold(),
      paddingPixels: paddingConfig.getPaddingFor(PaddingContext.guide),
      minLineSpacing: guideConfig.minLineSpacing,
      maxLineSpacing: guideConfig.maxLineSpacing,
      minTextBlockWidth: guideConfig.minTextBlockWidth,
      minTextBlockHeight: guideConfig.minTextBlockHeight,
      mergeSimilarGuides: groupSimilarDetections,
      mergeThreshold: guideConfig.mergeThreshold,
    );
  }

  /// Get redaction config with applied padding settings
  AutoRedactionConfig getRedactionConfigWithPadding() {
    return AutoRedactionConfig(
      sensitiveDataConfig: SensitiveDataDetectionConfig(
        detectPasswords: redactionConfig.sensitiveDataConfig.detectPasswords,
        detectHashes: redactionConfig.sensitiveDataConfig.detectHashes,
        detectTokens: redactionConfig.sensitiveDataConfig.detectTokens,
        detectNetworkInfo: redactionConfig.sensitiveDataConfig.detectNetworkInfo,
        detectFilesPaths: redactionConfig.sensitiveDataConfig.detectFilesPaths,
        detectCredentials: redactionConfig.sensitiveDataConfig.detectCredentials,
        detectCertificates: redactionConfig.sensitiveDataConfig.detectCertificates,
        confidenceThreshold: _getConfidenceThreshold(),
        paddingPixels: paddingConfig.getPaddingFor(PaddingContext.redaction),
      ),
      defaultRedactionType: redactionConfig.defaultRedactionType,
      defaultRedactionColor: redactionConfig.defaultRedactionColor,
      defaultBlurIntensity: redactionConfig.defaultBlurIntensity,
      defaultPixelSize: redactionConfig.defaultPixelSize,
      paddingPixels: paddingConfig.getPaddingFor(PaddingContext.redaction),
      autoAcceptHighConfidence: autoApplyHighConfidenceRedactions,
      autoAcceptThreshold: _getAutoAcceptThreshold(),
      groupNearbyRedactions: groupSimilarDetections,
      groupingDistance: redactionConfig.groupingDistance,
    );
  }

  /// Get confidence threshold based on sensitivity
  double _getConfidenceThreshold() {
    switch (sensitivity) {
      case DetectionSensitivity.low:
        return 0.9;
      case DetectionSensitivity.medium:
        return 0.7;
      case DetectionSensitivity.high:
        return 0.5;
      case DetectionSensitivity.maximum:
        return 0.3;
    }
  }

  /// Get auto-accept threshold based on sensitivity
  double _getAutoAcceptThreshold() {
    switch (sensitivity) {
      case DetectionSensitivity.low:
        return 0.95;
      case DetectionSensitivity.medium:
        return 0.9;
      case DetectionSensitivity.high:
        return 0.85;
      case DetectionSensitivity.maximum:
        return 0.8;
    }
  }

  AutoDetectionConfig copyWith({
    bool? enableAutoGuides,
    bool? enableAutoRedaction,
    DetectionSensitivity? sensitivity,
    PaddingConfig? paddingConfig,
    AutoGuideConfig? guideConfig,
    AutoRedactionConfig? redactionConfig,
    bool? processInBackground,
    bool? showProgressIndicator,
    bool? autoApplyHighConfidenceRedactions,
    bool? groupSimilarDetections,
  }) {
    return AutoDetectionConfig(
      enableAutoGuides: enableAutoGuides ?? this.enableAutoGuides,
      enableAutoRedaction: enableAutoRedaction ?? this.enableAutoRedaction,
      sensitivity: sensitivity ?? this.sensitivity,
      paddingConfig: paddingConfig ?? this.paddingConfig,
      guideConfig: guideConfig ?? this.guideConfig,
      redactionConfig: redactionConfig ?? this.redactionConfig,
      processInBackground: processInBackground ?? this.processInBackground,
      showProgressIndicator: showProgressIndicator ?? this.showProgressIndicator,
      autoApplyHighConfidenceRedactions: autoApplyHighConfidenceRedactions ?? this.autoApplyHighConfidenceRedactions,
      groupSimilarDetections: groupSimilarDetections ?? this.groupSimilarDetections,
    );
  }

  @override
  String toString() => 'AutoDetectionConfig(sensitivity: $sensitivity, guides: $enableAutoGuides, redaction: $enableAutoRedaction)';
}

/// Presets for common auto-detection scenarios
class AutoDetectionPresets {
  /// Preset for pentesting screenshots with console output
  static const pentest = AutoDetectionConfig(
    enableAutoGuides: true,
    enableAutoRedaction: true,
    sensitivity: DetectionSensitivity.high,
    paddingConfig: PaddingConfig(
      guidePadding: 4,
      redactionPadding: 8,
      consolePadding: 6,
      uiElementPadding: 10,
      textBlockPadding: 4,
    ),
    autoApplyHighConfidenceRedactions: false, // Let user review first
    groupSimilarDetections: true,
  );

  /// Preset for documentation screenshots with minimal redaction
  static const documentation = AutoDetectionConfig(
    enableAutoGuides: true,
    enableAutoRedaction: true,
    sensitivity: DetectionSensitivity.medium,
    paddingConfig: PaddingConfig(
      guidePadding: 8,
      redactionPadding: 6,
      consolePadding: 8,
      uiElementPadding: 12,
      textBlockPadding: 6,
    ),
    autoApplyHighConfidenceRedactions: false,
    groupSimilarDetections: true,
  );

  /// Preset for high-security environments
  static const highSecurity = AutoDetectionConfig(
    enableAutoGuides: true,
    enableAutoRedaction: true,
    sensitivity: DetectionSensitivity.maximum,
    paddingConfig: PaddingConfig(
      guidePadding: 6,
      redactionPadding: 12,
      consolePadding: 10,
      uiElementPadding: 14,
      textBlockPadding: 8,
    ),
    autoApplyHighConfidenceRedactions: true, // Auto-apply for security
    groupSimilarDetections: true,
  );

  /// Preset for UI/design screenshots
  static const uiDesign = AutoDetectionConfig(
    enableAutoGuides: true,
    enableAutoRedaction: false, // Usually no sensitive data
    sensitivity: DetectionSensitivity.low,
    paddingConfig: PaddingConfig(
      guidePadding: 2,
      redactionPadding: 4,
      consolePadding: 4,
      uiElementPadding: 8,
      textBlockPadding: 2,
      useUniformPadding: true,
    ),
    autoApplyHighConfidenceRedactions: false,
    groupSimilarDetections: false, // Keep individual guides for design
  );

  /// Get all available presets
  static Map<String, AutoDetectionConfig> get allPresets => {
        'Pentesting': pentest,
        'Documentation': documentation,
        'High Security': highSecurity,
        'UI Design': uiDesign,
      };

  /// Get preset description
  static String getPresetDescription(String presetName) {
    switch (presetName) {
      case 'Pentesting':
        return 'Optimized for penetration testing screenshots with console output and sensitive data';
      case 'Documentation':
        return 'Balanced settings for documentation with moderate security requirements';
      case 'High Security':
        return 'Maximum detection sensitivity with automatic redaction for sensitive environments';
      case 'UI Design':
        return 'Focused on guide generation for UI/design work with minimal redaction';
      default:
        return 'Unknown preset';
    }
  }
}

/// Helper extensions for sensitivity
extension DetectionSensitivityExtension on DetectionSensitivity {
  String get displayName {
    switch (this) {
      case DetectionSensitivity.low:
        return 'Low (Conservative)';
      case DetectionSensitivity.medium:
        return 'Medium (Balanced)';
      case DetectionSensitivity.high:
        return 'High (Sensitive)';
      case DetectionSensitivity.maximum:
        return 'Maximum (All Possible)';
    }
  }

  String get description {
    switch (this) {
      case DetectionSensitivity.low:
        return 'Only detect high-confidence matches to minimize false positives';
      case DetectionSensitivity.medium:
        return 'Balanced detection with reasonable false positive rate';
      case DetectionSensitivity.high:
        return 'Aggressive detection, may include some false positives';
      case DetectionSensitivity.maximum:
        return 'Detect everything possible, expect many false positives';
    }
  }

  Color get color {
    switch (this) {
      case DetectionSensitivity.low:
        return Colors.green;
      case DetectionSensitivity.medium:
        return Colors.blue;
      case DetectionSensitivity.high:
        return Colors.orange;
      case DetectionSensitivity.maximum:
        return Colors.red;
    }
  }
}