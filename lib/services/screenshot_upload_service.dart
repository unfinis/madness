import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../models/screenshot.dart';

class ScreenshotUploadService {
  static const List<String> _supportedFormats = ['jpg', 'jpeg', 'png'];
  static const int _maxFileSize = 50 * 1024 * 1024; // 50MB

  /// Validates if the file is a supported image format
  bool isValidImageFile(String fileName) {
    final extension = path.extension(fileName).toLowerCase().replaceAll('.', '');
    return _supportedFormats.contains(extension);
  }

  /// Validates file size
  bool isValidFileSize(int fileSize) {
    return fileSize <= _maxFileSize;
  }

  /// Gets image information (dimensions, format, size)
  Future<Map<String, dynamic>?> getImageInfo(File? file, Uint8List? bytes) async {
    try {
      Uint8List imageBytes;
      String fileName;
      int fileSize;

      if (file != null) {
        imageBytes = await file.readAsBytes();
        fileName = path.basename(file.path);
        fileSize = file.lengthSync();
      } else if (bytes != null) {
        imageBytes = bytes;
        fileName = 'uploaded_file';
        fileSize = bytes.length;
      } else {
        return null;
      }

      // Basic validation
      if (!isValidFileSize(fileSize)) {
        throw Exception('File size exceeds maximum allowed size (50MB)');
      }

      if (!isValidImageFile(fileName)) {
        throw Exception('Unsupported file format. Please use JPG, JPEG, or PNG');
      }

      // Get image dimensions by reading image header
      final dimensions = _getImageDimensions(imageBytes);
      final format = _getImageFormat(imageBytes);

      return {
        'width': dimensions['width'] ?? 0,
        'height': dimensions['height'] ?? 0,
        'format': format,
        'size': fileSize,
        'sizeFormatted': formatFileSize(fileSize),
      };
    } catch (e) {
      throw Exception('Failed to process image: ${e.toString()}');
    }
  }

  /// Creates a Screenshot object from uploaded file
  Future<Screenshot> createScreenshotFromFile({
    required String projectId,
    File? file,
    Uint8List? fileBytes,
    required String fileName,
    required String name,
    required String description,
  }) async {
    try {
      // Get image info
      final imageInfo = await getImageInfo(file, fileBytes);
      if (imageInfo == null) {
        throw Exception('Failed to process image file');
      }

      // Generate unique ID
      const uuid = Uuid();
      final screenshotId = uuid.v4();

      // Create file paths
      final originalPath = await _saveFile(
        screenshotId,
        'original',
        fileName,
        file,
        fileBytes,
      );

      final now = DateTime.now();
      
      return Screenshot(
        id: screenshotId,
        projectId: projectId,
        name: name,
        description: description,
        caption: '',
        instructions: '',
        originalPath: originalPath,
        editedPath: null,
        thumbnailPath: null,
        width: imageInfo['width'],
        height: imageInfo['height'],
        fileSize: imageInfo['size'],
        fileFormat: imageInfo['format'],
        captureDate: now, // Use upload time as capture time
        createdDate: now,
        modifiedDate: now,
        category: 'other',
        tags: <String>{},
        hasRedactions: false,
        isProcessed: false,
        metadata: <String, dynamic>{},
        layers: [], // Empty layers initially
      );
    } catch (e) {
      throw Exception('Failed to create screenshot: ${e.toString()}');
    }
  }

  /// Creates a Screenshot object from a file with extended metadata
  Future<Screenshot> createScreenshotFromFileExtended({
    required String projectId,
    required String name,
    required String description,
    required String caption,
    required String instructions,
    required String category,
    required String screenshotId,
    File? file,
    Uint8List? fileBytes,
    required String fileName,
    bool isPlaceholder = false,
  }) async {
    try {
      if (file == null && fileBytes == null) {
        throw Exception('Either file or fileBytes must be provided');
      }

      // Get image information
      final imageInfo = await getImageInfo(file, fileBytes);
      if (imageInfo == null) {
        throw Exception('Failed to get image information');
      }

      // Save the original file
      final originalPath = await _saveFile(
        screenshotId,
        'original',
        fileName,
        file,
        fileBytes,
      );

      final now = DateTime.now();
      
      return Screenshot(
        id: screenshotId,
        projectId: projectId,
        name: name,
        description: description,
        caption: caption,
        instructions: instructions,
        originalPath: originalPath,
        editedPath: null,
        thumbnailPath: null,
        width: imageInfo['width'] as int,
        height: imageInfo['height'] as int,
        fileSize: imageInfo['size'] as int,
        fileFormat: imageInfo['format'] as String,
        captureDate: now, // Use upload time as capture time
        createdDate: now,
        modifiedDate: now,
        category: category,
        tags: <String>{},
        hasRedactions: false,
        isProcessed: false,
        isPlaceholder: isPlaceholder,
        metadata: <String, dynamic>{},
        layers: [], // Empty layers initially
      );
    } catch (e) {
      throw Exception('Failed to create screenshot: ${e.toString()}');
    }
  }

  /// Saves the uploaded file to the appropriate directory
  Future<String> _saveFile(
    String screenshotId,
    String type, // 'original', 'edited', 'thumbnail'
    String fileName,
    File? file,
    Uint8List? fileBytes,
  ) async {
    try {
      // Get app documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final screenshotsDir = Directory(path.join(appDir.path, 'madness', 'screenshots'));
      
      // Create directories if they don't exist
      if (!await screenshotsDir.exists()) {
        await screenshotsDir.create(recursive: true);
      }

      // Generate file name with ID prefix
      final extension = path.extension(fileName);
      final newFileName = '${screenshotId}_${type}$extension';
      final filePath = path.join(screenshotsDir.path, newFileName);

      // Save file
      final targetFile = File(filePath);
      if (file != null) {
        await file.copy(filePath);
      } else if (fileBytes != null) {
        await targetFile.writeAsBytes(fileBytes);
      } else {
        throw Exception('No file data provided');
      }

      return filePath;
    } catch (e) {
      throw Exception('Failed to save file: ${e.toString()}');
    }
  }

  /// Formats file size in human readable format
  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Gets image format from file header
  String _getImageFormat(Uint8List bytes) {
    if (bytes.length < 8) return 'unknown';

    // PNG signature
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      return 'PNG';
    }

    // JPEG signature
    if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
      return 'JPEG';
    }

    return 'unknown';
  }

  /// Gets image dimensions from file header
  Map<String, int?> _getImageDimensions(Uint8List bytes) {
    try {
      if (bytes.length < 8) return {'width': null, 'height': null};

      // PNG format
      if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
        return _getPngDimensions(bytes);
      }

      // JPEG format
      if (bytes[0] == 0xFF && bytes[1] == 0xD8) {
        return _getJpegDimensions(bytes);
      }

      return {'width': null, 'height': null};
    } catch (e) {
      return {'width': null, 'height': null};
    }
  }

  /// Gets PNG dimensions from header
  Map<String, int?> _getPngDimensions(Uint8List bytes) {
    try {
      if (bytes.length < 24) return {'width': null, 'height': null};

      // PNG IHDR chunk starts at byte 16
      final width = (bytes[16] << 24) | (bytes[17] << 16) | (bytes[18] << 8) | bytes[19];
      final height = (bytes[20] << 24) | (bytes[21] << 16) | (bytes[22] << 8) | bytes[23];

      return {'width': width, 'height': height};
    } catch (e) {
      return {'width': null, 'height': null};
    }
  }

  /// Gets JPEG dimensions from header
  Map<String, int?> _getJpegDimensions(Uint8List bytes) {
    try {
      int offset = 2; // Skip SOI marker

      while (offset < bytes.length - 1) {
        // Find next marker
        if (bytes[offset] != 0xFF) {
          offset++;
          continue;
        }

        final marker = bytes[offset + 1];
        offset += 2;

        // Skip padding bytes
        while (offset < bytes.length && bytes[offset] == 0xFF) {
          offset++;
        }

        // SOF markers (Start of Frame)
        if ((marker >= 0xC0 && marker <= 0xC3) || 
            (marker >= 0xC5 && marker <= 0xC7) ||
            (marker >= 0xC9 && marker <= 0xCB) ||
            (marker >= 0xCD && marker <= 0xCF)) {
          
          if (offset + 7 < bytes.length) {
            final height = (bytes[offset + 3] << 8) | bytes[offset + 4];
            final width = (bytes[offset + 5] << 8) | bytes[offset + 6];
            return {'width': width, 'height': height};
          }
          break;
        }

        // Skip segment data
        if (offset + 1 < bytes.length) {
          final segmentLength = (bytes[offset] << 8) | bytes[offset + 1];
          offset += segmentLength;
        } else {
          break;
        }
      }

      return {'width': null, 'height': null};
    } catch (e) {
      return {'width': null, 'height': null};
    }
  }

  /// Generates thumbnail for the screenshot (placeholder for future implementation)
  Future<String?> generateThumbnail(String originalPath) async {
    // TODO: Implement thumbnail generation using image processing library
    // For now, return null to indicate no thumbnail
    return null;
  }

  /// Validates and cleans up uploaded files
  Future<void> cleanupTempFiles(List<String> filePaths) async {
    for (final filePath in filePaths) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore cleanup errors
        continue;
      }
    }
  }
}