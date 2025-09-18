import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:super_clipboard/super_clipboard.dart';
import 'package:image_picker/image_picker.dart';

class ImageReplacementService {
  static const List<String> supportedImageTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'
  ];

  /// Pick an image file using file picker dialog
  static Future<ui.Image?> pickImageFromFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: supportedImageTypes,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        return await _loadImageFromFile(file);
      }
    } catch (e) {
      debugPrint('Error picking image file: $e');
    }
    return null;
  }

  /// Pick an image using image picker (mobile/desktop)
  static Future<ui.Image?> pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        final file = File(image.path);
        return await _loadImageFromFile(file);
      }
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
    }
    return null;
  }

  /// Get image from clipboard (platform-specific implementation)
  static Future<ui.Image?> getImageFromClipboard() async {
    try {
      // For now, return null and show message to user
      // This feature requires platform-specific implementation
      debugPrint('Clipboard image paste not yet implemented - use file upload instead');
      return null;
    } catch (e) {
      debugPrint('Error accessing clipboard: $e');
    }
    return null;
  }

  /// Load image from file path (for drag & drop)
  static Future<ui.Image?> loadImageFromPath(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        return await _loadImageFromFile(file);
      }
    } catch (e) {
      debugPrint('Error loading image from path: $e');
    }
    return null;
  }

  /// Load image from bytes
  static Future<ui.Image?> loadImageFromBytes(Uint8List bytes) async {
    return await _loadImageFromBytes(bytes);
  }

  /// Check if file is a supported image type
  static bool isSupportedImageFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return supportedImageTypes.contains(extension);
  }

  /// Private method to load image from file
  static Future<ui.Image?> _loadImageFromFile(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return await _loadImageFromBytes(bytes);
    } catch (e) {
      debugPrint('Error loading image from file: $e');
      return null;
    }
  }

  /// Private method to load image from bytes
  static Future<ui.Image?> _loadImageFromBytes(Uint8List bytes) async {
    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      return frame.image;
    } catch (e) {
      debugPrint('Error loading image from bytes: $e');
      return null;
    }
  }

  /// Save image bytes to file (for persistence)
  static Future<String?> saveImageToFile(Uint8List bytes, String fileName) async {
    try {
      // This would typically save to app documents directory
      // Implementation depends on where you want to store uploaded images
      // For now, return a placeholder path
      return 'assets/uploaded/$fileName';
    } catch (e) {
      debugPrint('Error saving image file: $e');
      return null;
    }
  }

  /// Convert ui.Image to bytes (for saving)
  static Future<Uint8List?> imageToBytes(ui.Image image) async {
    try {
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error converting image to bytes: $e');
      return null;
    }
  }
}