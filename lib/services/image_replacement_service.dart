import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
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

  /// Get image from clipboard and save to file, returning both image and file path
  static Future<Map<String, dynamic>?> getImageFromClipboardWithSave() async {
    try {
      debugPrint('Attempting to read image from clipboard...');

      // Try super_clipboard for image data
      final clipboard = SystemClipboard.instance;
      if (clipboard == null) {
        debugPrint('SystemClipboard.instance is null - clipboard not available');
        return null;
      }

      final reader = await clipboard.read();

      // Try PNG format first (most common for screenshots)
      if (reader.canProvide(Formats.png)) {
        debugPrint('🔍 PNG format is available, attempting to read...');

        try {
          // Use a Completer to handle the async result properly
          final completer = Completer<Map<String, dynamic>?>();

          // Using the getFile API - pass a callback that processes the file
          final progress = reader.getFile(
            Formats.png as FileFormat,
            (file) async {
              debugPrint('Reading PNG file from clipboard...');
              try {
                final bytes = <int>[];

                // Read all chunks from the stream
                await for (final chunk in file.getStream()) {
                  bytes.addAll(chunk);
                  debugPrint('Read chunk: ${chunk.length} bytes');
                }

                final uint8Bytes = Uint8List.fromList(bytes);
                debugPrint('Total PNG bytes read: ${uint8Bytes.length}');

                // Decode the image and save to file
                try {
                  final codec = await ui.instantiateImageCodec(uint8Bytes);
                  final frame = await codec.getNextFrame();
                  debugPrint('✅ Successfully decoded PNG image: ${frame.image.width}x${frame.image.height}');

                  // Save the image bytes to a file
                  final fileName = 'clipboard_paste_${DateTime.now().millisecondsSinceEpoch}.png';
                  final filePath = await saveImageToFile(uint8Bytes, fileName);

                  if (filePath != null) {
                    debugPrint('✅ Successfully saved clipboard image to: $filePath');
                    completer.complete({
                      'image': frame.image,
                      'filePath': filePath,
                    });
                  } else {
                    debugPrint('❌ Failed to save clipboard image to file');
                    completer.complete(null);
                  }
                } catch (e) {
                  debugPrint('❌ Failed to decode PNG: $e');
                  completer.complete(null);
                }
              } catch (e) {
                debugPrint('❌ Error reading PNG stream: $e');
                completer.complete(null);
              }
            },
          );

          // Wait for the operation to complete
          if (progress != null) {
            debugPrint('Waiting for PNG processing to complete...');

            // Wait for the completer with a timeout
            try {
              final result = await completer.future.timeout(
                const Duration(seconds: 5),
                onTimeout: () {
                  debugPrint('❌ Timeout waiting for clipboard read');
                  return null;
                },
              );

              return result;
            } catch (e) {
              debugPrint('❌ Error waiting for image: $e');
            }
          }
        } catch (e, stackTrace) {
          debugPrint('❌ Error reading PNG from clipboard: $e');
          debugPrint('Stack trace: $stackTrace');
        }
      } else {
        debugPrint('❌ No PNG format found in clipboard');
      }

      return null;

    } catch (e, stackTrace) {
      debugPrint('Error accessing clipboard: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Get image from clipboard (platform-specific implementation)
  static Future<ui.Image?> getImageFromClipboard() async {
    try {
      debugPrint('Attempting to read image from clipboard...');

      // First, try to detect if there's any clipboard content at all
      final basicClipboard = Clipboard.getData(Clipboard.kTextPlain);
      final hasClipboardContent = await basicClipboard;

      if (hasClipboardContent?.text?.isNotEmpty == true) {
        debugPrint('Found text in clipboard, but need image data');
      }

      // Try super_clipboard for image data
      final clipboard = SystemClipboard.instance;
      if (clipboard == null) {
        debugPrint('SystemClipboard.instance is null - clipboard not available');
        return null;
      }

      final reader = await clipboard.read();
      debugPrint('Got clipboard reader, checking available formats...');

      // Check what formats are available
      final availableFormats = reader.platformFormats;
      debugPrint('Available clipboard formats: ${availableFormats.length} formats');

      // Log each format to see what Windows is providing
      for (int i = 0; i < availableFormats.length; i++) {
        try {
          debugPrint('Format $i: ${availableFormats[i].toString()}');
        } catch (e) {
          debugPrint('Format $i: Could not convert to string - $e');
        }
      }

      // Check for standard image formats
      final formatChecks = {
        'PNG': reader.canProvide(Formats.png),
        'JPEG': reader.canProvide(Formats.jpeg),
        'TIFF': reader.canProvide(Formats.tiff),
        'BMP': reader.canProvide(Formats.bmp),
      };

      debugPrint('Format availability:');
      formatChecks.forEach((format, available) {
        debugPrint('  $format: $available');
      });

      // Try PNG format first (most common for screenshots)
      if (reader.canProvide(Formats.png)) {
        debugPrint('PNG format detected in clipboard - attempting to read...');
        try {
          // Let's try to actually read the PNG data
          // We need to find the right way to read the data
          debugPrint('PNG data confirmed available, but reading method needs to be implemented');
        } catch (e) {
          debugPrint('Error checking PNG from clipboard: $e');
        }
      }

      // Also try checking for Windows-specific clipboard formats that might contain images
      try {
        final allFormats = reader.platformFormats;
        debugPrint('Checking all ${allFormats.length} platform formats for potential image data...');

        // Check if any format might be an image format we don't recognize
        int formatIndex = 0;
        for (final _ in allFormats) {
          try {
            debugPrint('  Format $formatIndex: Checking if this could be an image format');
            // Try to see if we can determine the format type
            formatIndex++;
          } catch (e) {
            debugPrint('  Error checking format $formatIndex: $e');
          }
        }
      } catch (e) {
        debugPrint('Error enumerating platform formats: $e');
      }

      // Check for other image formats
      final imageFormatsDetected = [
        if (reader.canProvide(Formats.png)) 'PNG',
        if (reader.canProvide(Formats.jpeg)) 'JPEG',
        if (reader.canProvide(Formats.tiff)) 'TIFF',
        if (reader.canProvide(Formats.bmp)) 'BMP',
      ];

      if (imageFormatsDetected.isNotEmpty) {
        debugPrint('✅ Image formats detected: ${imageFormatsDetected.join(', ')}');
        debugPrint('Now attempting to implement actual image reading...');

        // Try to read the first available image format
        if (reader.canProvide(Formats.png)) {
          debugPrint('🔍 PNG format is available, attempting to read...');

          try {
            // Use a Completer to handle the async result properly
            final completer = Completer<ui.Image?>();

            // Using the getFile API - pass a callback that processes the file
            final progress = reader.getFile(
              Formats.png as FileFormat,
              (file) async {
                debugPrint('Reading PNG file from clipboard...');
                try {
                  final bytes = <int>[];

                  // Read all chunks from the stream
                  await for (final chunk in file.getStream()) {
                    bytes.addAll(chunk);
                    debugPrint('Read chunk: ${chunk.length} bytes');
                  }

                  final uint8Bytes = Uint8List.fromList(bytes);
                  debugPrint('Total PNG bytes read: ${uint8Bytes.length}');

                  // Decode the image
                  try {
                    final codec = await ui.instantiateImageCodec(uint8Bytes);
                    final frame = await codec.getNextFrame();
                    debugPrint('✅ Successfully decoded PNG image: ${frame.image.width}x${frame.image.height}');
                    completer.complete(frame.image);
                  } catch (e) {
                    debugPrint('❌ Failed to decode PNG: $e');
                    completer.complete(null);
                  }
                } catch (e) {
                  debugPrint('❌ Error reading PNG stream: $e');
                  completer.complete(null);
                }
              },
            );

            // Wait for the operation to complete
            if (progress != null) {
              debugPrint('Waiting for PNG processing to complete...');

              // Wait for the completer with a timeout
              try {
                final resultImage = await completer.future.timeout(
                  const Duration(seconds: 5),
                  onTimeout: () {
                    debugPrint('❌ Timeout waiting for clipboard read');
                    return null;
                  },
                );

                if (resultImage != null) {
                  debugPrint('✅ Successfully got image from clipboard!');
                  return resultImage;
                } else {
                  debugPrint('❌ Failed to get image from clipboard');
                }
              } catch (e) {
                debugPrint('❌ Error waiting for image: $e');
              }
            }
          } catch (e, stackTrace) {
            debugPrint('❌ Error reading PNG from clipboard: $e');
            debugPrint('Stack trace: $stackTrace');
          }
        }

        if (reader.canProvide(Formats.jpeg)) {
          debugPrint('🔍 JPEG format is available');
        }

        if (reader.canProvide(Formats.bmp)) {
          debugPrint('🔍 BMP format is available');
        }
      } else {
        debugPrint('❌ No standard image formats found in clipboard');
        debugPrint('This might mean:');
        debugPrint('  1. No image was copied');
        debugPrint('  2. Image is in a Windows-specific format we need to handle');
        debugPrint('  3. Snipping Tool uses a different clipboard format');
      }

      return null;

    } catch (e, stackTrace) {
      debugPrint('Error accessing clipboard: $e');
      debugPrint('Stack trace: $stackTrace');
      return null;
    }
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
      // Get the application documents directory
      final directory = Directory.current; // For now, save in current directory
      final uploadsDir = Directory('${directory.path}/assets/uploaded');

      // Create uploads directory if it doesn't exist
      if (!await uploadsDir.exists()) {
        await uploadsDir.create(recursive: true);
      }

      final file = File('${uploadsDir.path}/$fileName');
      await file.writeAsBytes(bytes);

      return file.path;
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