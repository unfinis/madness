import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';

class DocumentService {
  Future<List<Document>> uploadDocuments() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'gif', 'txt'],
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final documents = <Document>[];
        
        for (final file in result.files) {
          if (file.path != null) {
            final document = await saveDocumentFile(
              file.path!,
              file.name,
              _getDocumentTypeFromExtension(file.extension),
            );
            
            if (document != null) {
              documents.add(document);
            }
          }
        }
        
        return documents;
      }
      return [];
    } catch (e) {
      throw Exception('Failed to upload documents: $e');
    }
  }

  Future<Document?> saveDocumentFile(
    String sourcePath,
    String fileName,
    DocumentType type,
  ) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final documentsDir = Directory('${appDir.path}/documents');
      
      if (!await documentsDir.exists()) {
        await documentsDir.create(recursive: true);
      }

      final sourceFile = File(sourcePath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = fileName.contains('.') ? fileName.split('.').last : '';
      final nameWithoutExtension = fileName.contains('.') 
          ? fileName.substring(0, fileName.lastIndexOf('.'))
          : fileName;
      final newFileName = extension.isNotEmpty 
          ? '${timestamp}_$nameWithoutExtension.$extension'
          : '${timestamp}_$nameWithoutExtension';
      final targetPath = '${documentsDir.path}/$newFileName';
      
      final targetFile = await sourceFile.copy(targetPath);
      
      return Document(
        name: nameWithoutExtension,
        description: 'Uploaded document',
        type: type,
        status: DocumentStatus.draft,
        filePath: targetFile.path,
        fileExtension: extension,
        fileSizeBytes: await targetFile.length(),
        author: 'Current User',
      );
    } catch (e) {
      debugPrint('Failed to save document file: $e');
      return null;
    }
  }

  DocumentType _getDocumentTypeFromExtension(String? extension) {
    return DocumentType.other;
  }

  Future<bool> deleteDocumentFile(Document document) async {
    try {
      if (document.filePath != null) {
        final file = File(document.filePath!);
        if (await file.exists()) {
          await file.delete();
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint('Failed to delete document file: $e');
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