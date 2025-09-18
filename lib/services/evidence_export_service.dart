import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';
import '../models/expense.dart';

class EvidenceExportService {
  
  Future<String?> exportAllEvidence(List<Expense> expenses) async {
    try {
      final evidenceFiles = <EvidenceFile>[];
      
      // Collect all evidence files from all expenses
      for (final expense in expenses) {
        evidenceFiles.addAll(expense.evidenceFiles);
      }
      
      if (evidenceFiles.isEmpty) {
        throw Exception('No evidence files found to export');
      }
      
      return await _createEvidenceArchive(evidenceFiles, expenses);
    } catch (e) {
      throw Exception('Failed to export evidence: $e');
    }
  }
  
  Future<String?> exportEvidenceForExpense(Expense expense) async {
    try {
      if (expense.evidenceFiles.isEmpty) {
        throw Exception('No evidence files found for this expense');
      }
      
      return await _createEvidenceArchive(expense.evidenceFiles, [expense]);
    } catch (e) {
      throw Exception('Failed to export evidence: $e');
    }
  }
  
  Future<String> _createEvidenceArchive(List<EvidenceFile> evidenceFiles, List<Expense> expenses) async {
    final archive = Archive();
    final fileNameMap = <String, int>{}; // Track duplicate names for auto-increment
    
    // Add evidence files to archive with better names
    for (final expense in expenses) {
      for (int i = 0; i < expense.evidenceFiles.length; i++) {
        final evidence = expense.evidenceFiles[i];
        final file = File(evidence.filePath);
        if (await file.exists()) {
          final fileBytes = await file.readAsBytes();
          
          // Create better filename: ExpenseName_Date_Index.ext
          final expenseName = _sanitizeFileName(expense.description);
          final dateStr = _formatDateForFileName(expense.date);
          final extension = evidence.fileName.split('.').last;
          final baseFileName = '${expenseName}_${dateStr}';
          
          // Handle duplicate names with auto-increment
          String finalFileName;
          if (expense.evidenceFiles.length > 1) {
            finalFileName = '${baseFileName}_${i + 1}.$extension';
          } else {
            finalFileName = '$baseFileName.$extension';
          }
          
          // Check for duplicates across all expenses and increment if needed
          int counter = 1;
          String uniqueFileName = finalFileName;
          while (fileNameMap.containsKey(uniqueFileName)) {
            counter++;
            if (expense.evidenceFiles.length > 1) {
              uniqueFileName = '${baseFileName}_${i + 1}_v$counter.$extension';
            } else {
              uniqueFileName = '${baseFileName}_v$counter.$extension';
            }
          }
          fileNameMap[uniqueFileName] = 1;
          
          final archiveFile = ArchiveFile(
            uniqueFileName,
            fileBytes.length,
            fileBytes,
          );
          archive.addFile(archiveFile);
        }
      }
    }
    
    // Create evidence manifest
    final manifest = _createEvidenceManifest(evidenceFiles, expenses);
    final manifestFile = ArchiveFile(
      'evidence_manifest.txt',
      manifest.length,
      manifest.codeUnits,
    );
    archive.addFile(manifestFile);
    
    // Create ZIP file
    final zipEncoder = ZipEncoder();
    final zipData = zipEncoder.encode(archive);
    
    if (zipData != null) {
      final directory = await getDownloadsDirectory() ?? await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final zipPath = '${directory.path}/evidence_export_$timestamp.zip';
      final zipFile = File(zipPath);
      
      await zipFile.writeAsBytes(zipData);
      return zipPath;
    } else {
      throw Exception('Failed to create evidence archive');
    }
  }
  
  String _createEvidenceManifest(List<EvidenceFile> evidenceFiles, List<Expense> expenses) {
    final buffer = StringBuffer();
    buffer.writeln('EVIDENCE EXPORT MANIFEST');
    buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln('Total Files: ${evidenceFiles.length}');
    buffer.writeln('Total Expenses: ${expenses.length}');
    buffer.writeln();
    
    buffer.writeln('EXPENSE DETAILS:');
    buffer.writeln('================');
    for (final expense in expenses) {
      buffer.writeln('Expense ID: ${expense.id}');
      buffer.writeln('Description: ${expense.description}');
      buffer.writeln('Amount: £${expense.amount.toStringAsFixed(2)}');
      buffer.writeln('Date: ${expense.date.toIso8601String()}');
      buffer.writeln('Type: ${expense.type.displayName}');
      buffer.writeln('Category: ${expense.category.displayName}');
      if (expense.notes != null) {
        buffer.writeln('Notes: ${expense.notes}');
      }
      buffer.writeln('Evidence Files:');
      for (final evidence in expense.evidenceFiles) {
        buffer.writeln('  - ${evidence.fileName} (${evidence.type.displayName})');
      }
      buffer.writeln();
    }
    
    buffer.writeln('EVIDENCE FILE DETAILS:');
    buffer.writeln('=====================');
    for (final evidence in evidenceFiles) {
      buffer.writeln('File: ${evidence.fileName}');
      buffer.writeln('Type: ${evidence.type.displayName}');
      buffer.writeln('Size: ${evidence.fileSizeBytes != null ? _formatFileSize(evidence.fileSizeBytes!) : 'Unknown'}');
      buffer.writeln('Added: ${evidence.dateAdded.toIso8601String()}');
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1073741824) return '${(bytes / 1048576).toStringAsFixed(1)} MB';
    return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
  }
  
  String _sanitizeFileName(String fileName) {
    // Remove invalid filename characters and limit length
    final sanitized = fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .trim();
    
    // Limit length to 50 characters
    return sanitized.length > 50 ? sanitized.substring(0, 50) : sanitized;
  }
  
  String _formatDateForFileName(DateTime date) {
    // Format: YYYY-MM-DD
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}