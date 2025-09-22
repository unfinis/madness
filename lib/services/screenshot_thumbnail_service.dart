import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/screenshot.dart';
import 'screenshot_export_service.dart';

class ScreenshotThumbnailService {
  static const double thumbnailWidth = 200.0;
  static const double thumbnailHeight = 150.0;

  /// Generates a rendered thumbnail for a screenshot including all layers
  static Future<ui.Image?> generateThumbnailWithLayers(Screenshot screenshot) async {
    try {
      // Load the background image first
      final backgroundImage = await _loadBackgroundImage(screenshot);
      if (backgroundImage == null) return null;

      // Use the export service to render with layers
      final renderedImage = await ScreenshotExportService.renderScreenshotWithLayers(
        screenshot,
        backgroundImage,
      );

      // Scale down to thumbnail size while maintaining aspect ratio
      final thumbnail = await _scaleImageToThumbnail(renderedImage);

      return thumbnail;
    } catch (e) {
      print('Error generating thumbnail with layers: $e');
      return null;
    }
  }

  /// Loads the background image from file or asset
  static Future<ui.Image?> _loadBackgroundImage(Screenshot screenshot) async {
    try {
      if (screenshot.originalPath.isEmpty) return null;

      Uint8List bytes;

      if (screenshot.originalPath.startsWith('assets/')) {
        // Load from asset bundle
        final ByteData data = await rootBundle.load(screenshot.originalPath);
        bytes = data.buffer.asUint8List();
      } else {
        // Load from file system
        final file = File(screenshot.originalPath);
        if (!file.existsSync()) return null;
        bytes = await file.readAsBytes();
      }

      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      return frameInfo.image;
    } catch (e) {
      print('Error loading background image: $e');
      return null;
    }
  }

  /// Scales an image down to thumbnail size while maintaining aspect ratio
  static Future<ui.Image> _scaleImageToThumbnail(ui.Image originalImage) async {
    final originalWidth = originalImage.width.toDouble();
    final originalHeight = originalImage.height.toDouble();

    // Calculate scale to fit within thumbnail bounds while maintaining aspect ratio
    final scaleX = thumbnailWidth / originalWidth;
    final scaleY = thumbnailHeight / originalHeight;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final scaledWidth = (originalWidth * scale).round();
    final scaledHeight = (originalHeight * scale).round();

    // Create a picture recorder for the thumbnail
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, scaledWidth.toDouble(), scaledHeight.toDouble()));

    // Draw the scaled image
    final paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(
      originalImage,
      Rect.fromLTWH(0, 0, originalWidth, originalHeight),
      Rect.fromLTWH(0, 0, scaledWidth.toDouble(), scaledHeight.toDouble()),
      paint,
    );

    // Convert to image
    final picture = recorder.endRecording();
    final thumbnailImage = await picture.toImage(scaledWidth, scaledHeight);

    return thumbnailImage;
  }

  /// Generates a placeholder thumbnail for screenshots without images
  static Future<ui.Image> generatePlaceholderThumbnail({
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
    String? text,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, thumbnailWidth, thumbnailHeight));

    // Draw background
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(const Rect.fromLTWH(0, 0, thumbnailWidth, thumbnailHeight), backgroundPaint);

    // Draw icon in center
    final iconPaint = Paint()..color = iconColor;
    const iconSize = 48.0;

    // For simplicity, draw a circle for the icon placeholder
    canvas.drawCircle(
      const Offset(thumbnailWidth / 2, thumbnailHeight / 2 - 10),
      iconSize / 2,
      iconPaint,
    );

    // Draw text if provided
    if (text != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: iconColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          (thumbnailWidth - textPainter.width) / 2,
          thumbnailHeight / 2 + 20,
        ),
      );
    }

    final picture = recorder.endRecording();
    return await picture.toImage(thumbnailWidth.round(), thumbnailHeight.round());
  }

  /// Converts a ui.Image to bytes for caching or display
  static Future<Uint8List> imageToBytes(ui.Image image) async {
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Creates an Image widget from a ui.Image
  static Widget createImageWidget(ui.Image uiImage, {BoxFit fit = BoxFit.cover}) {
    return FutureBuilder<Uint8List>(
      future: imageToBytes(uiImage),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.error, color: Colors.red),
          );
        } else {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
      },
    );
  }
}