import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/editor_layer.dart';
import 'sensitive_data_detector.dart';
import 'platform_text_recognizer.dart';

/// Represents an auto-detected redaction suggestion
class RedactionSuggestion {
  final String id;
  final SensitiveDataMatch sensitiveMatch;
  final RedactionLayer suggestedLayer;
  final bool isAccepted;

  const RedactionSuggestion({
    required this.id,
    required this.sensitiveMatch,
    required this.suggestedLayer,
    this.isAccepted = false,
  });

  RedactionSuggestion copyWith({
    String? id,
    SensitiveDataMatch? sensitiveMatch,
    RedactionLayer? suggestedLayer,
    bool? isAccepted,
  }) {
    return RedactionSuggestion(
      id: id ?? this.id,
      sensitiveMatch: sensitiveMatch ?? this.sensitiveMatch,
      suggestedLayer: suggestedLayer ?? this.suggestedLayer,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }

  @override
  String toString() => 'RedactionSuggestion(${sensitiveMatch.category}: ${sensitiveMatch.description})';
}

/// Configuration for auto-redaction
class AutoRedactionConfig {
  final SensitiveDataDetectionConfig sensitiveDataConfig;
  final RedactionType defaultRedactionType;
  final Color defaultRedactionColor;
  final double defaultBlurIntensity;
  final int defaultPixelSize;
  final int paddingPixels;
  final bool autoAcceptHighConfidence;
  final double autoAcceptThreshold;
  final bool groupNearbyRedactions;
  final double groupingDistance;

  const AutoRedactionConfig({
    this.sensitiveDataConfig = const SensitiveDataDetectionConfig(),
    this.defaultRedactionType = RedactionType.blur,
    this.defaultRedactionColor = Colors.black,
    this.defaultBlurIntensity = 10.0,
    this.defaultPixelSize = 8,
    this.paddingPixels = 4,
    this.autoAcceptHighConfidence = false,
    this.autoAcceptThreshold = 0.9,
    this.groupNearbyRedactions = true,
    this.groupingDistance = 20.0,
  });
}

/// Result of auto-redaction analysis
class AutoRedactionResult {
  final List<RedactionSuggestion> suggestions;
  final List<String> detectedCategories;
  final int totalSensitiveItemsFound;
  final String analysisReport;

  const AutoRedactionResult({
    required this.suggestions,
    required this.detectedCategories,
    required this.totalSensitiveItemsFound,
    required this.analysisReport,
  });

  @override
  String toString() => 'AutoRedactionResult($totalSensitiveItemsFound items, ${suggestions.length} suggestions)';
}

/// Service for automatically detecting and creating redactions for sensitive data
class AutoRedactionService {
  static const _uuid = Uuid();

  /// Initialize the OCR engine
  static void initialize() {
    PlatformTextRecognizer.initialize();
  }

  /// Dispose of resources
  static void dispose() {
    PlatformTextRecognizer.dispose();
  }

  /// Analyze image and generate redaction suggestions
  static Future<AutoRedactionResult> analyzeAndSuggestRedactions(
    ui.Image image, {
    AutoRedactionConfig config = const AutoRedactionConfig(),
  }) async {
    initialize();

    try {
      // Convert Flutter ui.Image to bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        return const AutoRedactionResult(
          suggestions: [],
          detectedCategories: [],
          totalSensitiveItemsFound: 0,
          analysisReport: 'Failed to convert image to bytes',
        );
      }

      // Perform platform-aware text recognition
      final textRecognitionResult = await PlatformTextRecognizer.recognizeText(image);

      // Build map of text to screen coordinates
      final textBounds = <String, Rect>{};
      final fullText = StringBuffer();

      for (final textBlock in textRecognitionResult.textBlocks) {
        final blockText = textBlock.text;
        final blockBounds = textBlock.bounds;

        if (blockText.isNotEmpty) {
          textBounds[blockText] = blockBounds;
          fullText.writeln(blockText);

          // Also map individual lines for more precise detection
          final lines = blockText.split('\n');
          for (int i = 0; i < lines.length && i < textBlock.lines.length; i++) {
            final lineText = lines[i].trim();
            if (lineText.isNotEmpty) {
              textBounds[lineText] = textBlock.lines[i];
            }
          }
        }
      }

      // Detect sensitive data in the extracted text
      final sensitiveMatches = SensitiveDataDetector.detectSensitiveData(
        fullText.toString(),
        textBounds,
        config: config.sensitiveDataConfig,
      );

      // Create redaction suggestions
      final suggestions = await _createRedactionSuggestions(
        sensitiveMatches,
        config,
      );

      // Group nearby redactions if configured
      final finalSuggestions = config.groupNearbyRedactions
          ? _groupNearbyRedactions(suggestions, config.groupingDistance)
          : suggestions;

      // Generate analysis report
      final analysisReport = _generateAnalysisReport(sensitiveMatches, finalSuggestions);

      // Extract detected categories
      final detectedCategories = sensitiveMatches
          .map((match) => match.category)
          .toSet()
          .toList();

      return AutoRedactionResult(
        suggestions: finalSuggestions,
        detectedCategories: detectedCategories,
        totalSensitiveItemsFound: sensitiveMatches.length,
        analysisReport: analysisReport,
      );

    } catch (e, stackTrace) {
      debugPrint('Error in auto-redaction analysis: $e');
      debugPrint('Stack trace: $stackTrace');

      return AutoRedactionResult(
        suggestions: [],
        detectedCategories: [],
        totalSensitiveItemsFound: 0,
        analysisReport: 'Error during analysis: $e',
      );
    }
  }

  /// Create redaction suggestions from sensitive data matches
  static Future<List<RedactionSuggestion>> _createRedactionSuggestions(
    List<SensitiveDataMatch> sensitiveMatches,
    AutoRedactionConfig config,
  ) async {
    final suggestions = <RedactionSuggestion>[];

    for (final match in sensitiveMatches) {
      // Determine redaction type based on category
      final redactionType = _getRedactionTypeForCategory(match.category, config);
      final redactionColor = _getRedactionColorForCategory(match.category, config);

      // Apply padding to bounds
      final paddedBounds = Rect.fromLTRB(
        match.bounds.left - config.paddingPixels,
        match.bounds.top - config.paddingPixels,
        match.bounds.right + config.paddingPixels,
        match.bounds.bottom + config.paddingPixels,
      );

      // Create redaction layer
      final redactionLayer = RedactionLayer(
        id: _uuid.v4(),
        name: 'Auto-redaction: ${match.category}',
        visible: true,
        locked: false,
        opacity: 1.0,
        blendModeType: BlendModeType.normal,
        bounds: paddedBounds,
        createdDate: DateTime.now(),
        modifiedDate: DateTime.now(),
        redactionType: redactionType,
        redactionColor: redactionColor,
        blurRadius: config.defaultBlurIntensity,
        pixelSize: config.defaultPixelSize,
      );

      // Determine if this should be auto-accepted
      final shouldAutoAccept = config.autoAcceptHighConfidence &&
          match.confidence >= config.autoAcceptThreshold;

      suggestions.add(RedactionSuggestion(
        id: _uuid.v4(),
        sensitiveMatch: match,
        suggestedLayer: redactionLayer,
        isAccepted: shouldAutoAccept,
      ));
    }

    return suggestions;
  }

  /// Get appropriate redaction type for category
  static RedactionType _getRedactionTypeForCategory(String category, AutoRedactionConfig config) {
    switch (category.toLowerCase()) {
      case 'hash':
      case 'password':
      case 'credentials':
      case 'certificate':
        return RedactionType.blackout; // Use solid black for high-security items
      case 'token':
      case 'network':
        return RedactionType.blur; // Use blur for medium-security items
      case 'filepath':
        return RedactionType.pixelate; // Use pixelate for path information
      default:
        return config.defaultRedactionType;
    }
  }

  /// Get appropriate redaction color for category
  static Color _getRedactionColorForCategory(String category, AutoRedactionConfig config) {
    switch (category.toLowerCase()) {
      case 'hash':
      case 'password':
      case 'credentials':
        return Colors.red.shade900; // High security - dark red
      case 'certificate':
        return Colors.black; // Maximum security - solid black
      case 'token':
        return Colors.orange.shade700; // Medium security - orange
      case 'network':
        return Colors.blue.shade700; // Network info - blue
      case 'filepath':
        return Colors.grey.shade600; // File paths - grey
      default:
        return config.defaultRedactionColor;
    }
  }

  /// Group nearby redactions to reduce clutter
  static List<RedactionSuggestion> _groupNearbyRedactions(
    List<RedactionSuggestion> suggestions,
    double groupingDistance,
  ) {
    if (suggestions.length <= 1) return suggestions;

    final grouped = <RedactionSuggestion>[];
    final processed = <bool>[];

    // Initialize processed flags
    for (int i = 0; i < suggestions.length; i++) {
      processed.add(false);
    }

    for (int i = 0; i < suggestions.length; i++) {
      if (processed[i]) continue;

      final current = suggestions[i];
      final group = <RedactionSuggestion>[current];

      // Find nearby suggestions
      for (int j = i + 1; j < suggestions.length; j++) {
        if (processed[j]) continue;

        final other = suggestions[j];
        final distance = _calculateDistance(
          current.sensitiveMatch.bounds.center,
          other.sensitiveMatch.bounds.center,
        );

        if (distance <= groupingDistance) {
          group.add(other);
          processed[j] = true;
        }
      }

      if (group.length == 1) {
        // Single item, add as-is
        grouped.add(current);
      } else {
        // Multiple items, create combined redaction
        final combinedBounds = _combineBounds(group.map((s) => s.sensitiveMatch.bounds).toList());
        final categories = group.map((s) => s.sensitiveMatch.category).toSet().join(', ');

        final combinedMatch = SensitiveDataMatch(
          text: '${group.length} items',
          category: categories,
          description: 'Combined sensitive data',
          bounds: combinedBounds,
          confidence: group.map((s) => s.sensitiveMatch.confidence).reduce((a, b) => a > b ? a : b),
        );

        final combinedLayer = RedactionLayer(
          id: _uuid.v4(),
          name: 'Combined auto-redaction',
          visible: true,
          locked: false,
          opacity: 1.0,
          blendModeType: BlendModeType.normal,
          bounds: combinedBounds,
          createdDate: DateTime.now(),
          modifiedDate: DateTime.now(),
          redactionType: RedactionType.blackout,
          redactionColor: Colors.red.shade900,
          blurRadius: 10.0,
          pixelSize: 8,
        );

        grouped.add(RedactionSuggestion(
          id: _uuid.v4(),
          sensitiveMatch: combinedMatch,
          suggestedLayer: combinedLayer,
          isAccepted: false,
        ));
      }

      processed[i] = true;
    }

    return grouped;
  }

  /// Calculate distance between two points
  static double _calculateDistance(Offset point1, Offset point2) {
    return (point1 - point2).distance;
  }

  /// Combine multiple bounds into a single encompassing bounds
  static Rect _combineBounds(List<Rect> bounds) {
    if (bounds.isEmpty) return Rect.zero;
    if (bounds.length == 1) return bounds.first;

    double left = bounds.first.left;
    double top = bounds.first.top;
    double right = bounds.first.right;
    double bottom = bounds.first.bottom;

    for (final bound in bounds.skip(1)) {
      left = left < bound.left ? left : bound.left;
      top = top < bound.top ? top : bound.top;
      right = right > bound.right ? right : bound.right;
      bottom = bottom > bound.bottom ? bottom : bound.bottom;
    }

    return Rect.fromLTRB(left, top, right, bottom);
  }

  /// Generate analysis report
  static String _generateAnalysisReport(
    List<SensitiveDataMatch> sensitiveMatches,
    List<RedactionSuggestion> suggestions,
  ) {
    final report = StringBuffer();
    report.writeln('🔍 Auto-Redaction Analysis Report');
    report.writeln('════════════════════════════════');
    report.writeln();

    // Summary
    report.writeln('📊 Summary:');
    report.writeln('  • Total sensitive items detected: ${sensitiveMatches.length}');
    report.writeln('  • Redaction suggestions generated: ${suggestions.length}');
    report.writeln();

    // Category breakdown
    final categoryCount = <String, int>{};
    for (final match in sensitiveMatches) {
      categoryCount[match.category] = (categoryCount[match.category] ?? 0) + 1;
    }

    if (categoryCount.isNotEmpty) {
      report.writeln('📂 Categories Detected:');
      for (final entry in categoryCount.entries) {
        final description = SensitiveDataDetector.getCategoryDescription(entry.key);
        report.writeln('  • ${entry.key} (${entry.value}): $description');
      }
      report.writeln();
    }

    // High confidence items
    final highConfidenceItems = sensitiveMatches
        .where((match) => match.confidence >= 0.9)
        .toList();

    if (highConfidenceItems.isNotEmpty) {
      report.writeln('⚠️  High Confidence Items (${highConfidenceItems.length}):');
      for (final item in highConfidenceItems.take(5)) {
        report.writeln('  • ${item.category}: ${item.description} (${(item.confidence * 100).toInt()}%)');
      }
      if (highConfidenceItems.length > 5) {
        report.writeln('  • ... and ${highConfidenceItems.length - 5} more');
      }
      report.writeln();
    }

    // Recommendations
    report.writeln('💡 Recommendations:');
    if (categoryCount.containsKey('Hash') || categoryCount.containsKey('Password')) {
      report.writeln('  • High-priority: Password hashes detected - recommend immediate redaction');
    }
    if (categoryCount.containsKey('Certificate')) {
      report.writeln('  • Critical: Private keys/certificates detected - mandatory redaction');
    }
    if (categoryCount.containsKey('Token')) {
      report.writeln('  • Important: API tokens detected - review and redact as needed');
    }
    if (sensitiveMatches.length > 10) {
      report.writeln('  • Consider using batch redaction for efficiency');
    }

    return report.toString();
  }

  /// Get available redaction categories
  static List<String> get availableCategories => SensitiveDataDetector.availableCategories;

  /// Get category description
  static String getCategoryDescription(String category) =>
      SensitiveDataDetector.getCategoryDescription(category);
}