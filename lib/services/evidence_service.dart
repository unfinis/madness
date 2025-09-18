import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/expense.dart';

class EvidenceService {
  static final ImagePicker _picker = ImagePicker();
  
  Future<EvidenceFile?> captureFromCamera() async {
    try {
      // Request camera permission
      final cameraPermission = await Permission.camera.request();
      if (cameraPermission != PermissionStatus.granted) {
        throw Exception('Camera permission denied');
      }

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo != null) {
        return await _saveEvidenceFile(
          photo.path,
          photo.name,
          EvidenceType.photo,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to capture photo: $e');
    }
  }

  Future<EvidenceFile?> captureFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (photo != null) {
        return await _saveEvidenceFile(
          photo.path,
          photo.name,
          EvidenceType.photo,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick photo from gallery: $e');
    }
  }

  Future<EvidenceFile?> captureFromClipboard() async {
    // Clipboard functionality temporarily disabled due to API compatibility
    throw Exception('Clipboard capture is not currently supported on this platform');
  }

  Future<List<EvidenceFile>> uploadFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'gif', 'doc', 'docx', 'txt'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final evidenceFiles = <EvidenceFile>[];
        
        for (final file in result.files) {
          if (file.path != null) {
            final evidenceFile = await _saveEvidenceFile(
              file.path!,
              file.name,
              _getEvidenceTypeFromExtension(file.extension),
            );
            
            if (evidenceFile != null) {
              evidenceFiles.add(evidenceFile);
            }
          }
        }
        
        return evidenceFiles;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to upload files: $e');
    }
  }

  Future<EvidenceFile?> _saveEvidenceFile(
    String sourcePath,
    String fileName,
    EvidenceType type,
  ) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final evidenceDir = Directory('${appDir.path}/evidence');
      
      if (!await evidenceDir.exists()) {
        await evidenceDir.create(recursive: true);
      }

      final sourceFile = File(sourcePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = '${timestamp}_$fileName';
      final targetPath = '${evidenceDir.path}/$newFileName';
      
      final targetFile = await sourceFile.copy(targetPath);
      
      return EvidenceFile(
        id: timestamp.toString(),
        filePath: targetFile.path,
        fileName: newFileName,
        type: type,
        dateAdded: DateTime.now(),
        fileSizeBytes: await targetFile.length(),
      );
    } catch (e) {
      debugPrint('Failed to save evidence file: $e');
      return null;
    }
  }

  Future<File?> _saveClipboardImage(Uint8List imageData, String fileName) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final evidenceDir = Directory('${appDir.path}/evidence');
      
      if (!await evidenceDir.exists()) {
        await evidenceDir.create(recursive: true);
      }

      final targetPath = '${evidenceDir.path}/$fileName';
      final file = File(targetPath);
      
      await file.writeAsBytes(imageData);
      return file;
    } catch (e) {
      debugPrint('Failed to save clipboard image: $e');
      return null;
    }
  }

  EvidenceType _getEvidenceTypeFromExtension(String? extension) {
    if (extension == null) return EvidenceType.document;
    
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return EvidenceType.photo;
      case 'pdf':
      case 'doc':
      case 'docx':
      case 'txt':
        return EvidenceType.document;
      default:
        return EvidenceType.document;
    }
  }

  Future<bool> deleteEvidenceFile(EvidenceFile evidence) async {
    try {
      final file = File(evidence.filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Failed to delete evidence file: $e');
      return false;
    }
  }

  String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }
}