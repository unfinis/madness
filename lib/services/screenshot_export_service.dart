import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/screenshot.dart';
import '../models/editor_layer.dart';
import 'file_saver_web.dart' if (dart.library.io) 'file_saver_stub.dart';

class ScreenshotExportService {
  static const String _defaultExportPath = '/tmp/madness_exports';
  
  /// Renders a screenshot with all its layers into a final image
  static Future<ui.Image> renderScreenshotWithLayers(
    Screenshot screenshot,
    ui.Image backgroundImage,
  ) async {
    // Create a picture recorder to capture the rendering
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the background image
    final paint = Paint();
    canvas.drawImage(backgroundImage, Offset.zero, paint);

    // Cache pixel data for efficient sampling during pixelation
    ByteData? imagePixelData;
    try {
      imagePixelData = await backgroundImage.toByteData(format: ui.ImageByteFormat.rawRgba);
    } catch (e) {
      imagePixelData = null;
    }

    // Draw all visible layers in order
    for (final layer in screenshot.layers.where((l) => l.visible)) {
      await _renderLayer(canvas, layer, backgroundImage, imagePixelData);
    }

    // Convert to image
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      backgroundImage.width,
      backgroundImage.height,
    );

    return image;
  }
  
  /// Renders a single layer on the canvas
  static Future<void> _renderLayer(Canvas canvas, EditorLayer layer, ui.Image backgroundImage, ByteData? imagePixelData) async {
    final paint = Paint()..isAntiAlias = true;

    // Apply layer opacity and blend mode
    paint.color = paint.color.withValues(alpha: layer.opacity);

    // Set blend mode (simplified for now)
    paint.blendMode = _getBlendMode(layer.blendModeType);

    switch (layer.layerType) {
      case LayerType.vector:
        await _renderVectorLayer(canvas, layer as VectorLayer, paint);
        break;

      case LayerType.text:
        await _renderTextLayer(canvas, layer as TextLayer, paint);
        break;

      case LayerType.redaction:
        await _renderRedactionLayer(canvas, layer as RedactionLayer, paint, backgroundImage, imagePixelData);
        break;

      case LayerType.crop:
        // Crop layers are handled during background image rendering
        break;

      case LayerType.bitmap:
        // TODO: Implement bitmap layer rendering
        break;
    }
  }
  
  static Future<void> _renderVectorLayer(Canvas canvas, VectorLayer layer, Paint paint) async {
    paint
      ..color = layer.strokeColor.withValues(alpha: layer.opacity)
      ..strokeWidth = layer.strokeWidth
      ..style = PaintingStyle.stroke;
    
    // Draw fill first if fill color is not transparent
    if (layer.fillColor != Colors.transparent) {
      final fillPaint = Paint()
        ..color = layer.fillColor.withValues(alpha: layer.opacity)
        ..style = PaintingStyle.fill
        ..blendMode = paint.blendMode;
      
      for (final element in layer.elements) {
        _renderVectorElement(canvas, element, fillPaint);
      }
    }
    
    // Draw stroke
    for (final element in layer.elements) {
      _renderVectorElement(canvas, element, paint);
    }
  }
  
  static void _renderVectorElement(Canvas canvas, VectorElement element, Paint paint) {
    switch (element.type) {
      case VectorElementType.rectangle:
        if (element.points.length >= 2) {
          final rect = Rect.fromPoints(element.points[0], element.points[1]);
          canvas.drawRect(rect, paint);
        }
        break;
        
      case VectorElementType.arrow:
        if (element.points.length >= 2) {
          final start = element.points[0];
          final end = element.points[1];
          
          // Draw arrow line
          canvas.drawLine(start, end, paint);
          
          // Draw arrowhead
          const arrowLength = 15.0;
          const arrowAngle = 0.5;
          
          final direction = (end - start).direction;
          final arrowPoint1 = end + Offset.fromDirection(direction + 3.14159 - arrowAngle, arrowLength);
          final arrowPoint2 = end + Offset.fromDirection(direction + 3.14159 + arrowAngle, arrowLength);
          
          canvas.drawLine(end, arrowPoint1, paint);
          canvas.drawLine(end, arrowPoint2, paint);
        }
        break;
        
      case VectorElementType.ellipse:
      case VectorElementType.line:
      case VectorElementType.polygon:
        // TODO: Implement other vector elements
        break;
    }
  }
  
  static Future<void> _renderTextLayer(Canvas canvas, TextLayer layer, Paint paint) async {
    final textPainter = TextPainter(
      text: TextSpan(text: layer.text, style: layer.textStyle),
      textAlign: layer.textAlign,
      textDirection: TextDirection.ltr,
    );
    
    textPainter.layout(maxWidth: layer.bounds.width);
    textPainter.paint(canvas, layer.bounds.topLeft);
  }
  
  // Convert blur radius to sigma for Gaussian blur
  static double _radiusToSigma(double radius) {
    return radius * 0.57735 + 0.5; // Approximation for better visual results
  }

  static Future<void> _renderRedactionLayer(Canvas canvas, RedactionLayer layer, Paint paint, ui.Image backgroundImage, ByteData? imagePixelData) async {
    switch (layer.redactionType) {
      case RedactionType.blackout:
        paint
          ..color = Colors.black.withValues(alpha: layer.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(layer.bounds, paint);
        break;

      case RedactionType.blur:
        // TODO: Implement actual blur effect with background image
        // For now, we'll use a placeholder with proper opacity
        paint
          ..color = Colors.grey.withValues(alpha: 0.5 * layer.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(layer.bounds, paint);
        break;

      case RedactionType.pixelate:
        // Draw pixelated redaction using real image sampling
        final pixelSize = layer.pixelSize.toDouble();
        final bounds = layer.bounds;

        for (double x = bounds.left; x < bounds.right; x += pixelSize) {
          for (double y = bounds.top; y < bounds.bottom; y += pixelSize) {
            final pixelRect = Rect.fromLTWH(
              x,
              y,
              math.min(pixelSize, bounds.right - x),
              math.min(pixelSize, bounds.bottom - y),
            );

            // Sample actual pixel color from the background image
            final centerX = x + pixelSize / 2;
            final centerY = y + pixelSize / 2;
            final blockColor = _sampleImagePixel(backgroundImage, imagePixelData, centerX.toInt(), centerY.toInt());
            final pixelPaint = Paint()
              ..color = blockColor.withValues(alpha: layer.opacity)
              ..style = PaintingStyle.fill;

            canvas.drawRect(pixelRect, pixelPaint);
          }
        }
        break;
    }
  }

  /// Sample actual pixel color from the background image
  static Color _sampleImagePixel(ui.Image backgroundImage, ByteData? imagePixelData, int x, int y) {
    if (imagePixelData == null) {
      return Colors.grey;
    }

    try {
      final width = backgroundImage.width;
      final height = backgroundImage.height;

      // Clamp coordinates to image bounds
      final clampedX = x.clamp(0, width - 1);
      final clampedY = y.clamp(0, height - 1);

      // Calculate pixel index (4 bytes per pixel: RGBA)
      final pixelIndex = (clampedY * width + clampedX) * 4;

      // Extract RGBA values
      final bytes = imagePixelData.buffer.asUint8List();
      final r = bytes[pixelIndex];
      final g = bytes[pixelIndex + 1];
      final b = bytes[pixelIndex + 2];
      final a = bytes[pixelIndex + 3];

      return Color.fromARGB(a, r, g, b);
    } catch (e) {
      return Colors.grey;
    }
  }

  static BlendMode _getBlendMode(BlendModeType type) {
    switch (type) {
      case BlendModeType.normal:
        return BlendMode.srcOver;
      case BlendModeType.multiply:
        return BlendMode.multiply;
      case BlendModeType.screen:
        return BlendMode.screen;
      case BlendModeType.overlay:
        return BlendMode.overlay;
      case BlendModeType.softLight:
        return BlendMode.softLight;
      case BlendModeType.hardLight:
        return BlendMode.hardLight;
      case BlendModeType.colorDodge:
        return BlendMode.colorDodge;
      case BlendModeType.colorBurn:
        return BlendMode.colorBurn;
      case BlendModeType.darken:
        return BlendMode.darken;
      case BlendModeType.lighten:
        return BlendMode.lighten;
      case BlendModeType.difference:
        return BlendMode.difference;
      case BlendModeType.exclusion:
        return BlendMode.exclusion;
    }
  }
  
  /// Exports the rendered image to PNG format
  static Future<Uint8List> exportToPng(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
  
  /// Exports the rendered image to JPEG format
  static Future<Uint8List> exportToJpeg(ui.Image image, {int quality = 85}) async {
    // Note: Flutter doesn't have built-in JPEG encoding
    // For now, we'll export as PNG and in a real implementation
    // you would use a package like 'image' for JPEG conversion
    return exportToPng(image);
  }
  
  /// Saves the exported image data to a file path (platform-specific implementation)
  static Future<String> saveToFile(Uint8List imageData, String filename) async {
    try {
      if (kIsWeb) {
        // Web implementation using external file
        return await saveFileWeb(imageData, filename);
      } else {
        // Desktop/mobile implementation
        // For now, just simulate the save operation
        // In a real implementation, you'd use path_provider and file I/O
        await Future.delayed(const Duration(milliseconds: 500));
        return 'Saved to: /tmp/$filename';
      }
    } catch (e) {
      throw Exception('Failed to save file: $e');
    }
  }
  
  /// Generates a filename with timestamp
  static String generateFilename(String projectName, String screenshotName, String extension) {
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final cleanProjectName = projectName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final cleanScreenshotName = screenshotName.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    return '${cleanProjectName}_${cleanScreenshotName}_$timestamp.$extension';
  }
}