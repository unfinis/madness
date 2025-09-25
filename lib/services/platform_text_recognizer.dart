import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Cross-platform text recognition service using Tesseract OCR
class PlatformTextRecognizer {
  static String? _tessdataPath;
  static bool _tessdataInitialized = false;

  /// Check if Tesseract OCR is supported on this platform
  static bool get isTesseractSupported {
    // Tesseract supports all desktop platforms
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Check if any OCR is supported
  static bool get isSupported {
    return isTesseractSupported;
  }

  /// Initialize the text recognizer and prepare tessdata
  static Future<void> initialize() async {
    if (!isTesseractSupported) {
      debugPrint('⚠️ Tesseract OCR is not supported on this platform');
      return;
    }

    if (_tessdataInitialized) {
      return;
    }

    try {
      // Copy tessdata from assets to a temporary directory
      final tempDir = await getTemporaryDirectory();
      _tessdataPath = path.join(tempDir.path, 'tessdata');
      final tessdataDir = Directory(_tessdataPath!);

      if (!await tessdataDir.exists()) {
        await tessdataDir.create(recursive: true);
      }

      // Copy eng.traineddata from assets
      final engTrainedDataPath = path.join(_tessdataPath!, 'eng.traineddata');
      final engTrainedDataFile = File(engTrainedDataPath);

      if (!await engTrainedDataFile.exists()) {
        debugPrint('📦 Copying tessdata from assets to $_tessdataPath');
        final data = await rootBundle.load('assets/tessdata/eng.traineddata');
        final bytes = data.buffer.asUint8List();
        await engTrainedDataFile.writeAsBytes(bytes);
        debugPrint('✅ Tessdata copied successfully');
      }

      _tessdataInitialized = true;
      debugPrint('🔧 Tesseract OCR initialized with tessdata at $_tessdataPath');
    } catch (e) {
      debugPrint('❌ Failed to initialize tessdata: $e');
      _tessdataInitialized = false;
    }
  }

  /// Dispose of resources
  static void dispose() {
    // Clean up if needed
    _tessdataInitialized = false;
  }

  /// Recognize text from image with Tesseract OCR
  static Future<RecognizedTextResult> recognizeText(ui.Image image) async {
    if (!isTesseractSupported) {
      throw UnsupportedError('OCR is not supported on this platform');
    }

    // Ensure tessdata is initialized
    if (!_tessdataInitialized) {
      await initialize();
    }

    return _recognizeTextWithTesseract(image);
  }

  /// Use system Tesseract executable for text recognition (desktop platforms)
  static Future<RecognizedTextResult> _recognizeTextWithTesseract(ui.Image image) async {
    try {
      debugPrint('🔍 Using system Tesseract for text recognition...');

      // Convert ui.Image to bytes
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Failed to convert image to bytes');
      }

      final bytes = byteData.buffer.asUint8List();
      debugPrint('📝 Processing image (${bytes.length} bytes)...');

      // Save bytes to temporary file for Tesseract
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempImageFile = File(path.join(tempDir.path, 'temp_ocr_image_$timestamp.png'));
      final tempOutputFile = File(path.join(tempDir.path, 'temp_ocr_output_$timestamp'));

      await tempImageFile.writeAsBytes(bytes);
      debugPrint('📁 Temporary image saved to: ${tempImageFile.path}');

      // Try different possible Tesseract executable paths
      final tesseractPaths = Platform.isWindows
          ? [
              'C:\\Program Files\\Tesseract-OCR\\tesseract.exe',
              'C:\\Program Files (x86)\\Tesseract-OCR\\tesseract.exe',
              'tesseract.exe',
              'tesseract',
            ]
          : [
              '/usr/bin/tesseract',
              '/usr/local/bin/tesseract',
              '/opt/homebrew/bin/tesseract', // macOS with Homebrew
              'tesseract',
            ];

      String? extractedText;
      bool tesseractFound = false;
      String? lastError;

      for (final tesseractPath in tesseractPaths) {
        try {
          // Build command arguments with proper tessdata path
          final args = [
            tempImageFile.path,
            tempOutputFile.path,
            '-l', 'eng',
            '--psm', '3', // Fully automatic page segmentation
            '--oem', '3', // Default OCR Engine mode
          ];

          // Add tessdata directory if we have it
          if (_tessdataPath != null) {
            args.addAll(['--tessdata-dir', _tessdataPath!]);
            debugPrint('📚 Using tessdata from: $_tessdataPath');
          }

          // Run Tesseract OCR
          final result = await Process.run(tesseractPath, args);

          if (result.exitCode == 0) {
            tesseractFound = true;
            // Read the text output
            final outputTextFile = File('${tempOutputFile.path}.txt');

            if (await outputTextFile.exists()) {
              extractedText = await outputTextFile.readAsString();
              debugPrint('✅ Tesseract extracted ${extractedText.length} characters of text');

              // Now try to get TSV coordinate data with a second run
              String? tsvContent;
              try {
                final tsvArgs = [
                  tempImageFile.path,
                  '${tempOutputFile.path}_tsv',
                  '-l', 'eng',
                  '--psm', '3',
                  '--oem', '3',
                  '-c', 'tessedit_create_tsv=1',
                ];
                if (_tessdataPath != null) {
                  tsvArgs.addAll(['--tessdata-dir', _tessdataPath!]);
                }

                final tsvResult = await Process.run(tesseractPath, tsvArgs);
                if (tsvResult.exitCode == 0) {
                  final tsvFile = File('${tempOutputFile.path}_tsv.tsv');
                  if (await tsvFile.exists()) {
                    tsvContent = await tsvFile.readAsString();
                    debugPrint('📊 TSV coordinate data available (${tsvContent.length} bytes)');
                    await tsvFile.delete().catchError((_) => tsvFile);
                  }
                }
              } catch (e) {
                debugPrint('⚠️ Failed to get TSV coordinates: $e');
              }

              // Parse the TSV data and create accurate text blocks
              final textBlocks = _createTextBlocksFromTsv(tsvContent, extractedText, image);

              // Clean up output files
              await outputTextFile.delete().catchError((_) => outputTextFile);

              return RecognizedTextResult(
                textBlocks: textBlocks,
                fullText: extractedText,
                isTesseractResult: true,
              );
            } else {
              throw Exception('Tesseract output file not found');
            }
            break;
          } else {
            lastError = 'Exit code ${result.exitCode}: ${result.stderr}';
            debugPrint('⚠️ Tesseract failed - $lastError');
          }
        } catch (e) {
          lastError = e.toString();
          continue;
        }
      }

      // Clean up temporary image file
      await tempImageFile.delete().catchError((_) => tempImageFile);

      if (!tesseractFound) {
        throw Exception(
          'Tesseract executable not found. Please install Tesseract OCR.\n'
          'Windows: Download from https://github.com/UB-Mannheim/tesseract/wiki\n'
          'macOS: brew install tesseract\n'
          'Linux: apt-get install tesseract-ocr\n'
          'Last error: $lastError'
        );
      }

      if (extractedText == null || extractedText.isEmpty) {
        extractedText = ''; // Return empty string instead of null
        debugPrint('⚠️ No text extracted from image');
      }

      // Fallback - should not reach here if everything worked
      return RecognizedTextResult(
        textBlocks: [],
        fullText: extractedText ?? '',
        isTesseractResult: true,
      );

    } catch (e, stackTrace) {
      debugPrint('❌ Tesseract OCR failed: $e');
      debugPrint('📝 Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Create text blocks from Tesseract TSV output with precise coordinates
  static List<DetectedTextBlock> _createTextBlocksFromTsv(String? tsvContent, String fullText, ui.Image image) {
    final textBlocks = <DetectedTextBlock>[];

    if (fullText.trim().isEmpty) {
      return textBlocks;
    }

    if (tsvContent == null || tsvContent.trim().isEmpty) {
      // Fallback to estimated positions if no TSV data
      return _createTextBlocksFromExtractedTextFallback(fullText, image);
    }

    try {
      // Parse Tesseract TSV format
      final lines = tsvContent.split('\n');
      if (lines.isEmpty) {
        return _createTextBlocksFromExtractedTextFallback(fullText, image);
      }

      // Group lines by text blocks and paragraphs
      final blockGroups = <int, List<TsvLine>>{};
      final lineGroups = <String, List<TsvLine>>{};

      for (int i = 1; i < lines.length; i++) { // Skip header
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split('\t');
        if (parts.length >= 12) {
          final tsvLine = TsvLine.fromParts(parts);
          if (tsvLine != null && tsvLine.text.trim().isNotEmpty) {
            // Group by block (paragraph level)
            final blockKey = tsvLine.blockNum;
            blockGroups.putIfAbsent(blockKey, () => []).add(tsvLine);

            // Group by line within block
            final lineKey = '${tsvLine.blockNum}_${tsvLine.parNum}_${tsvLine.lineNum}';
            lineGroups.putIfAbsent(lineKey, () => []).add(tsvLine);
          }
        }
      }

      // Create text blocks from grouped lines
      for (final blockEntry in blockGroups.entries) {
        final blockLines = blockEntry.value;
        if (blockLines.isEmpty) continue;

        // Calculate block bounds
        final minX = blockLines.map((l) => l.left).reduce((a, b) => a < b ? a : b).toDouble();
        final minY = blockLines.map((l) => l.top).reduce((a, b) => a < b ? a : b).toDouble();
        final maxX = blockLines.map((l) => l.left + l.width).reduce((a, b) => a > b ? a : b).toDouble();
        final maxY = blockLines.map((l) => l.top + l.height).reduce((a, b) => a > b ? a : b).toDouble();

        final blockBounds = Rect.fromLTRB(minX, minY, maxX, maxY);
        final blockText = blockLines.map((l) => l.text).join(' ');

        // Create line bounds for this block
        final lineBounds = <Rect>[];
        final processedLineKeys = <String>{};

        for (final lineEntry in lineGroups.entries) {
          if (!lineEntry.key.startsWith('${blockEntry.key}_')) continue;
          if (processedLineKeys.contains(lineEntry.key)) continue;

          final lineWords = lineEntry.value;
          if (lineWords.isEmpty) continue;

          final lineMinX = lineWords.map((l) => l.left).reduce((a, b) => a < b ? a : b).toDouble();
          final lineMinY = lineWords.map((l) => l.top).reduce((a, b) => a < b ? a : b).toDouble();
          final lineMaxX = lineWords.map((l) => l.left + l.width).reduce((a, b) => a > b ? a : b).toDouble();
          final lineMaxY = lineWords.map((l) => l.top + l.height).reduce((a, b) => a > b ? a : b).toDouble();

          lineBounds.add(Rect.fromLTRB(lineMinX, lineMinY, lineMaxX, lineMaxY));
          processedLineKeys.add(lineEntry.key);
        }

        // Sort line bounds by Y position
        lineBounds.sort((a, b) => a.top.compareTo(b.top));

        textBlocks.add(DetectedTextBlock(
          text: blockText,
          bounds: blockBounds,
          confidence: 0.9,
          lines: lineBounds,
        ));
      }

      debugPrint('📊 Created ${textBlocks.length} text blocks with ${textBlocks.fold(0, (sum, block) => sum + block.lines.length)} total lines from TSV data');

    } catch (e) {
      debugPrint('⚠️ Failed to parse TSV data: $e, falling back to estimated positions');
      return _createTextBlocksFromExtractedTextFallback(fullText, image);
    }

    return textBlocks.isEmpty ? _createTextBlocksFromExtractedTextFallback(fullText, image) : textBlocks;
  }

  /// Fallback method for creating text blocks with estimated positions
  static List<DetectedTextBlock> _createTextBlocksFromExtractedTextFallback(String fullText, ui.Image image) {
    final textBlocks = <DetectedTextBlock>[];

    if (fullText.trim().isEmpty) {
      return textBlocks;
    }

    // Split text into lines
    final lines = fullText.split('\n').where((line) => line.trim().isNotEmpty).toList();
    if (lines.isEmpty) {
      return textBlocks;
    }

    // Since we don't have position info, estimate bounds
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    // Create a single large text block with estimated position
    final bounds = Rect.fromLTWH(
      imageWidth * 0.05,  // 5% from left
      imageHeight * 0.05, // 5% from top
      imageWidth * 0.9,   // 90% width
      imageHeight * 0.9,  // 90% height
    );

    // Create line bounds
    final lineBounds = <Rect>[];
    final lineHeight = bounds.height / lines.length.clamp(1, 100);
    for (int i = 0; i < lines.length && i < 100; i++) {
      lineBounds.add(Rect.fromLTWH(
        bounds.left,
        bounds.top + (i * lineHeight),
        bounds.width,
        lineHeight,
      ));
    }

    textBlocks.add(DetectedTextBlock(
      text: fullText,
      bounds: bounds,
      confidence: 0.75, // Lower confidence for estimated positions
      lines: lineBounds,
    ));

    return textBlocks;
  }

}

/// Represents a line from Tesseract TSV output
class TsvLine {
  final int level;
  final int pageNum;
  final int blockNum;
  final int parNum;
  final int lineNum;
  final int wordNum;
  final int left;
  final int top;
  final int width;
  final int height;
  final int conf;
  final String text;

  const TsvLine({
    required this.level,
    required this.pageNum,
    required this.blockNum,
    required this.parNum,
    required this.lineNum,
    required this.wordNum,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.conf,
    required this.text,
  });

  static TsvLine? fromParts(List<String> parts) {
    try {
      if (parts.length < 12) return null;

      return TsvLine(
        level: int.tryParse(parts[0]) ?? 0,
        pageNum: int.tryParse(parts[1]) ?? 0,
        blockNum: int.tryParse(parts[2]) ?? 0,
        parNum: int.tryParse(parts[3]) ?? 0,
        lineNum: int.tryParse(parts[4]) ?? 0,
        wordNum: int.tryParse(parts[5]) ?? 0,
        left: int.tryParse(parts[6]) ?? 0,
        top: int.tryParse(parts[7]) ?? 0,
        width: int.tryParse(parts[8]) ?? 0,
        height: int.tryParse(parts[9]) ?? 0,
        conf: int.tryParse(parts[10]) ?? 0,
        text: parts.length > 11 ? parts[11] : '',
      );
    } catch (e) {
      return null;
    }
  }
}

/// Standardized text block representation
class DetectedTextBlock {
  final String text;
  final Rect bounds;
  final double confidence;
  final List<Rect> lines;

  const DetectedTextBlock({
    required this.text,
    required this.bounds,
    required this.confidence,
    required this.lines,
  });

  @override
  String toString() => 'DetectedTextBlock(text: ${text.substring(0, text.length > 20 ? 20 : text.length)}..., bounds: $bounds)';
}

/// Result of text recognition
class RecognizedTextResult {
  final List<DetectedTextBlock> textBlocks;
  final String fullText;
  final bool isTesseractResult;

  const RecognizedTextResult({
    required this.textBlocks,
    required this.fullText,
    this.isTesseractResult = true,
  });

  @override
  String toString() => 'RecognizedTextResult(blocks: ${textBlocks.length}, isTesseract: $isTesseractResult)';
}