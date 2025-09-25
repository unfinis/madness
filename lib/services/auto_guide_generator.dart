import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'platform_text_recognizer.dart';

/// Represents an auto-generated guide
class AutoGuide {
  final String id;
  final double position;
  final bool isVertical;
  final String category;
  final String description;
  final double confidence;

  const AutoGuide({
    required this.id,
    required this.position,
    required this.isVertical,
    required this.category,
    required this.description,
    required this.confidence,
  });

  @override
  String toString() => 'AutoGuide($category: ${isVertical ? 'V' : 'H'}$position)';
}

/// Configuration for auto-guide generation
class AutoGuideConfig {
  final bool detectConsoleOutput;
  final bool detectUIElements;
  final bool detectTextBlocks;
  final double confidenceThreshold;
  final int paddingPixels;
  final int minLineSpacing;
  final int maxLineSpacing;
  final int minTextBlockWidth;
  final int minTextBlockHeight;
  final bool mergeSimilarGuides;
  final double mergeThreshold;

  const AutoGuideConfig({
    this.detectConsoleOutput = true,
    this.detectUIElements = true,
    this.detectTextBlocks = true,
    this.confidenceThreshold = 0.7,
    this.paddingPixels = 4,
    this.minLineSpacing = 5,
    this.maxLineSpacing = 50,
    this.minTextBlockWidth = 50,
    this.minTextBlockHeight = 20,
    this.mergeSimilarGuides = true,
    this.mergeThreshold = 10.0, // Increased threshold for better merging
  });
}

/// Text block with analysis for guide generation
class AnalyzedTextBlock {
  final String text;
  final Rect bounds;
  final double confidence;
  final bool isConsoleOutput;
  final bool isUIElement;
  final List<Rect> lines;

  const AnalyzedTextBlock({
    required this.text,
    required this.bounds,
    required this.confidence,
    required this.isConsoleOutput,
    required this.isUIElement,
    required this.lines,
  });
}

/// Service for automatically generating guides using OCR
class AutoGuideGenerator {
  /// Initialize the OCR engine
  static void initialize() {
    PlatformTextRecognizer.initialize();
  }

  /// Dispose of resources
  static void dispose() {
    PlatformTextRecognizer.dispose();
  }

  /// Generate guides automatically from an image
  static Future<List<AutoGuide>> generateGuides(
    ui.Image image, {
    AutoGuideConfig config = const AutoGuideConfig(),
  }) async {
    try {
      // Perform platform-aware text recognition
      debugPrint('🔍 Starting OCR for guide generation...');
      final textRecognitionResult = await PlatformTextRecognizer.recognizeText(image);
      debugPrint('✅ OCR completed: ${textRecognitionResult.textBlocks.length} blocks found');

      // Analyze text blocks
      final textBlocks = await _analyzeTextBlocks(textRecognitionResult, config);
      debugPrint('📊 Analysis completed: ${textBlocks.length} text blocks analyzed');

      // Generate guides based on analysis
      final guides = _generateGuidesFromTextBlocks(textBlocks, config);
      debugPrint('📏 Guide generation completed: ${guides.length} guides created');

      return guides;
    } catch (e) {
      debugPrint('❌ Error generating auto guides: $e');
      return [];
    }
  }

  /// Analyze OCR results to categorize text blocks
  static Future<List<AnalyzedTextBlock>> _analyzeTextBlocks(
    RecognizedTextResult recognitionResult,
    AutoGuideConfig config,
  ) async {
    final analyzedBlocks = <AnalyzedTextBlock>[];

    for (final textBlock in recognitionResult.textBlocks) {
      // Skip blocks that are too small
      if (textBlock.bounds.width < config.minTextBlockWidth ||
          textBlock.bounds.height < config.minTextBlockHeight) {
        continue;
      }

      // Analyze if this is console output
      final isConsoleOutput = _isConsoleOutput(textBlock.text, textBlock.bounds);

      // Analyze if this is a UI element
      final isUIElement = _isUIElement(textBlock.text, textBlock.bounds);

      analyzedBlocks.add(AnalyzedTextBlock(
        text: textBlock.text,
        bounds: textBlock.bounds,
        confidence: textBlock.confidence,
        isConsoleOutput: isConsoleOutput,
        isUIElement: isUIElement,
        lines: textBlock.lines,
      ));
    }

    return analyzedBlocks;
  }

  /// Generate guides from analyzed text blocks
  static List<AutoGuide> _generateGuidesFromTextBlocks(
    List<AnalyzedTextBlock> textBlocks,
    AutoGuideConfig config,
  ) {
    final guides = <AutoGuide>[];
    int guideIdCounter = 0;

    // Limit the number of text blocks processed to prevent too many guides
    final maxBlocksToProcess = 20;
    final blocksToProcess = textBlocks.take(maxBlocksToProcess);

    for (final textBlock in blocksToProcess) {
      if (textBlock.confidence < config.confidenceThreshold) continue;

      // Generate guides for console output
      if (config.detectConsoleOutput && textBlock.isConsoleOutput) {
        guides.addAll(_generateConsoleGuides(textBlock, config, guideIdCounter));
        guideIdCounter += 100;
      }

      // Generate guides for UI elements
      if (config.detectUIElements && textBlock.isUIElement) {
        guides.addAll(_generateUIElementGuides(textBlock, config, guideIdCounter));
        guideIdCounter += 100;
      }

      // Generate guides for general text blocks (be more selective)
      if (config.detectTextBlocks && !textBlock.isConsoleOutput && !textBlock.isUIElement) {
        // Only generate guides for larger text blocks to reduce clutter
        if (textBlock.bounds.width > 100 && textBlock.bounds.height > 30) {
          guides.addAll(_generateTextBlockGuides(textBlock, config, guideIdCounter));
        }
        guideIdCounter += 100;
      }
    }

    debugPrint('📏 Generated ${guides.length} raw guides before merging');

    // Always merge similar guides to reduce clutter
    final mergedGuides = _mergeSimilarGuides(guides, config.mergeThreshold);
    debugPrint('🔧 Merged to ${mergedGuides.length} guides');

    // Limit total number of guides to prevent UI overload
    const maxTotalGuides = 50;
    if (mergedGuides.length > maxTotalGuides) {
      // Keep the highest confidence guides
      mergedGuides.sort((a, b) => b.confidence.compareTo(a.confidence));
      final limitedGuides = mergedGuides.take(maxTotalGuides).toList();
      debugPrint('⚠️ Limited to ${limitedGuides.length} guides due to maximum limit');
      return limitedGuides;
    }

    return mergedGuides;
  }

  /// Generate guides for console output
  static List<AutoGuide> _generateConsoleGuides(
    AnalyzedTextBlock textBlock,
    AutoGuideConfig config,
    int baseId,
  ) {
    final guides = <AutoGuide>[];

    // Add guides around the entire console block
    guides.add(AutoGuide(
      id: 'console_${baseId}_top',
      position: textBlock.bounds.top - config.paddingPixels,
      isVertical: false,
      category: 'Console',
      description: 'Console block start',
      confidence: 0.9,
    ));

    guides.add(AutoGuide(
      id: 'console_${baseId}_bottom',
      position: textBlock.bounds.bottom + config.paddingPixels,
      isVertical: false,
      category: 'Console',
      description: 'Console block end',
      confidence: 0.9,
    ));

    guides.add(AutoGuide(
      id: 'console_${baseId}_left',
      position: textBlock.bounds.left - config.paddingPixels,
      isVertical: true,
      category: 'Console',
      description: 'Console left margin',
      confidence: 0.8,
    ));

    guides.add(AutoGuide(
      id: 'console_${baseId}_right',
      position: textBlock.bounds.right + config.paddingPixels,
      isVertical: true,
      category: 'Console',
      description: 'Console right margin',
      confidence: 0.8,
    ));

    // Add guides between lines if they have consistent spacing
    if (textBlock.lines.length > 1) {
      final lineSpacings = <double>[];
      for (int i = 0; i < textBlock.lines.length - 1; i++) {
        final spacing = textBlock.lines[i + 1].top - textBlock.lines[i].bottom;
        if (spacing >= config.minLineSpacing && spacing <= config.maxLineSpacing) {
          lineSpacings.add(spacing);
        }
      }

      // Add guides between lines - be less restrictive for better line detection
      if (lineSpacings.isNotEmpty) {
        final averageSpacing = lineSpacings.reduce((a, b) => a + b) / lineSpacings.length;
        final isConsistentSpacing = lineSpacings.length <= 1 ||
            lineSpacings.every((spacing) =>
                (spacing - averageSpacing).abs() < averageSpacing * 0.5); // More tolerant

        if (isConsistentSpacing) {
          for (int i = 0; i < textBlock.lines.length - 1; i++) {
            final currentLine = textBlock.lines[i];
            final nextLine = textBlock.lines[i + 1];
            final actualSpacing = nextLine.top - currentLine.bottom;

            // Place guide in the middle of the spacing, but ensure reasonable distance
            final position = actualSpacing > 2.0
                ? currentLine.bottom + (actualSpacing / 2)
                : currentLine.bottom + 1.0;

            guides.add(AutoGuide(
              id: 'console_${baseId}_line_$i',
              position: position,
              isVertical: false,
              category: 'Console',
              description: 'Between console lines',
              confidence: 0.8,
            ));
          }
        }
      }
    }

    return guides;
  }

  /// Generate guides for UI elements (buttons, panels, etc.)
  static List<AutoGuide> _generateUIElementGuides(
    AnalyzedTextBlock textBlock,
    AutoGuideConfig config,
    int baseId,
  ) {
    final guides = <AutoGuide>[];

    // Add guides around UI elements with larger padding
    final uiPadding = config.paddingPixels * 2;

    guides.add(AutoGuide(
      id: 'ui_${baseId}_top',
      position: textBlock.bounds.top - uiPadding,
      isVertical: false,
      category: 'UI Element',
      description: 'UI element top boundary',
      confidence: 0.85,
    ));

    guides.add(AutoGuide(
      id: 'ui_${baseId}_bottom',
      position: textBlock.bounds.bottom + uiPadding,
      isVertical: false,
      category: 'UI Element',
      description: 'UI element bottom boundary',
      confidence: 0.85,
    ));

    guides.add(AutoGuide(
      id: 'ui_${baseId}_left',
      position: textBlock.bounds.left - uiPadding,
      isVertical: true,
      category: 'UI Element',
      description: 'UI element left boundary',
      confidence: 0.85,
    ));

    guides.add(AutoGuide(
      id: 'ui_${baseId}_right',
      position: textBlock.bounds.right + uiPadding,
      isVertical: true,
      category: 'UI Element',
      description: 'UI element right boundary',
      confidence: 0.85,
    ));

    return guides;
  }

  /// Generate guides for general text blocks
  static List<AutoGuide> _generateTextBlockGuides(
    AnalyzedTextBlock textBlock,
    AutoGuideConfig config,
    int baseId,
  ) {
    final guides = <AutoGuide>[];

    // Add boundary guides
    guides.add(AutoGuide(
      id: 'text_${baseId}_top',
      position: textBlock.bounds.top - config.paddingPixels,
      isVertical: false,
      category: 'Text Block',
      description: 'Text block boundary',
      confidence: 0.7,
    ));

    guides.add(AutoGuide(
      id: 'text_${baseId}_bottom',
      position: textBlock.bounds.bottom + config.paddingPixels,
      isVertical: false,
      category: 'Text Block',
      description: 'Text block boundary',
      confidence: 0.7,
    ));

    // Add line-by-line guides for text blocks too, if we have multiple lines
    if (textBlock.lines.length > 1) {
      for (int i = 0; i < textBlock.lines.length; i++) {
        final line = textBlock.lines[i];

        // Add guide at top of each line
        guides.add(AutoGuide(
          id: 'text_${baseId}_line_${i}_top',
          position: line.top - (config.paddingPixels / 2),
          isVertical: false,
          category: 'Text Block',
          description: 'Line ${i + 1} top',
          confidence: 0.6,
        ));

        // Add guide at bottom of each line
        guides.add(AutoGuide(
          id: 'text_${baseId}_line_${i}_bottom',
          position: line.bottom + (config.paddingPixels / 2),
          isVertical: false,
          category: 'Text Block',
          description: 'Line ${i + 1} bottom',
          confidence: 0.6,
        ));

        // Add guides between lines
        if (i < textBlock.lines.length - 1) {
          final nextLine = textBlock.lines[i + 1];
          final spacing = nextLine.top - line.bottom;

          if (spacing >= config.minLineSpacing) {
            final position = spacing > 2.0
                ? line.bottom + (spacing / 2)
                : line.bottom + 1.0;

            guides.add(AutoGuide(
              id: 'text_${baseId}_between_${i}_${i + 1}',
              position: position,
              isVertical: false,
              category: 'Text Block',
              description: 'Between lines ${i + 1} and ${i + 2}',
              confidence: 0.7,
            ));
          }
        }
      }
    }

    return guides;
  }

  /// Determine if a text block represents console output
  static bool _isConsoleOutput(String text, Rect bounds) {
    // Look for console-specific patterns
    final consolePatterns = [
      RegExp(r'\$\s+', multiLine: true), // Shell prompt
      RegExp(r'>\s+', multiLine: true), // Windows prompt
      RegExp(r'^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+:', multiLine: true), // SSH prompt
      RegExp(r'\[[0-9]{1,2}:[0-9]{2}:[0-9]{2}\]', multiLine: true), // Timestamps
      RegExp(r'^(INFO|ERROR|DEBUG|WARN)', multiLine: true), // Log levels
      RegExp(r'^\s*\d+\s+', multiLine: true), // Line numbers
      RegExp(r'[A-Za-z]:\\[^\\]+\\', multiLine: true), // Windows paths
      RegExp(r'/[a-zA-Z0-9_/-]+', multiLine: true), // Unix paths
    ];

    final hasConsolePatterns = consolePatterns.any((pattern) => pattern.hasMatch(text));

    // Console output typically has consistent formatting and is often wider
    final aspectRatio = bounds.width / bounds.height;
    final isWideBlock = aspectRatio > 3.0;

    return hasConsolePatterns || (isWideBlock && text.contains('\n'));
  }

  /// Determine if a text block represents a UI element
  static bool _isUIElement(String text, Rect bounds) {
    // Look for UI element patterns
    final uiPatterns = [
      RegExp(r'^(OK|Cancel|Apply|Save|Delete|Edit|Settings|Options)$', caseSensitive: false),
      RegExp(r'^(File|Edit|View|Tools|Help)$', caseSensitive: false), // Menu items
      RegExp(r'^\[.*\]$'), // Checkbox or button text in brackets
      RegExp(r'^.*\.\.\.$'), // Ellipsis indicating more options
    ];

    final hasUIPatterns = uiPatterns.any((pattern) => pattern.hasMatch(text.trim()));

    // UI elements are typically smaller, more square, and contain short text
    final aspectRatio = bounds.width / bounds.height;
    final isCompactBlock = aspectRatio > 0.5 && aspectRatio < 4.0;
    final isShortText = text.length < 50 && !text.contains('\n');

    return hasUIPatterns || (isCompactBlock && isShortText);
  }


  /// Merge similar guides to reduce clutter
  static List<AutoGuide> _mergeSimilarGuides(List<AutoGuide> guides, double threshold) {
    final mergedGuides = <AutoGuide>[];
    final processed = <bool>[];

    // Initialize processed flags
    for (int i = 0; i < guides.length; i++) {
      processed.add(false);
    }

    for (int i = 0; i < guides.length; i++) {
      if (processed[i]) continue;

      final currentGuide = guides[i];
      final similar = <AutoGuide>[currentGuide];

      // Find similar guides
      for (int j = i + 1; j < guides.length; j++) {
        if (processed[j]) continue;

        final otherGuide = guides[j];
        if (currentGuide.isVertical == otherGuide.isVertical &&
            (currentGuide.position - otherGuide.position).abs() <= threshold) {
          similar.add(otherGuide);
          processed[j] = true;
        }
      }

      // Create merged guide
      final avgPosition = similar.map((g) => g.position).reduce((a, b) => a + b) / similar.length;
      final maxConfidence = similar.map((g) => g.confidence).reduce((a, b) => a > b ? a : b);
      final categories = similar.map((g) => g.category).toSet().join(', ');

      mergedGuides.add(AutoGuide(
        id: 'merged_${similar.map((g) => g.id).join('_')}',
        position: avgPosition,
        isVertical: currentGuide.isVertical,
        category: categories,
        description: 'Merged guide',
        confidence: maxConfidence,
      ));

      processed[i] = true;
    }

    return mergedGuides;
  }

  /// Get available guide categories
  static List<String> get availableCategories => [
        'Console',
        'UI Element',
        'Text Block',
      ];

  /// Get description for a category
  static String getCategoryDescription(String category) {
    switch (category) {
      case 'Console':
        return 'Terminal/console output boundaries';
      case 'UI Element':
        return 'Buttons, menus, and controls';
      case 'Text Block':
        return 'General text content';
      default:
        return 'Unknown category';
    }
  }
}