import 'dart:io';
import 'dart:typed_data';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../models/scope.dart';

enum ExportFormat { excel, csv }

class ImportExportService {
  static const List<String> csvHeaders = [
    'ID',
    'Description',
    'Amount',
    'Type',
    'Category',
    'Date',
    'Notes',
    'Receipt Path',
  ];

  Future<String?> exportExpenses(
    List<Expense> expenses,
    ExportFormat format, {
    String? customFileName,
  }) async {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd_HH-mm-ss');
      final timestamp = dateFormat.format(DateTime.now());
      final fileName = customFileName ?? 'expenses_export_$timestamp';
      
      late Uint8List bytes;
      late String fileExtension;
      
      switch (format) {
        case ExportFormat.excel:
          bytes = await _exportToExcel(expenses);
          fileExtension = 'xlsx';
          break;
        case ExportFormat.csv:
          bytes = await _exportToCsv(expenses);
          fileExtension = 'csv';
          break;
      }

      final directory = await getDownloadsDirectory() ?? await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName.$fileExtension';
      final file = File(filePath);
      
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      throw Exception('Failed to export expenses: $e');
    }
  }

  Future<Uint8List> _exportToExcel(List<Expense> expenses) async {
    final excel = Excel.createExcel();
    
    // Remove default sheet and create our own
    excel.delete('Sheet1');
    final sheet = excel['Expenses'];
    
    // Add headers
    for (int i = 0; i < csvHeaders.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(csvHeaders[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.blue100,
      );
    }

    // Add data rows
    for (int rowIndex = 0; rowIndex < expenses.length; rowIndex++) {
      final expense = expenses[rowIndex];
      final dataRowIndex = rowIndex + 1;
      
      final rowData = [
        expense.id,
        expense.description,
        expense.amount.toString(),
        expense.type.displayName,
        expense.category.displayName,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(expense.date),
        expense.notes ?? '',
        expense.receiptPath ?? '',
      ];

      for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: colIndex,
          rowIndex: dataRowIndex,
        ));
        cell.value = TextCellValue(rowData[colIndex]);
      }
    }

    // Auto-fit columns
    for (int i = 0; i < csvHeaders.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  Future<Uint8List> _exportToCsv(List<Expense> expenses) async {
    final List<List<String>> rows = [csvHeaders];
    
    for (final expense in expenses) {
      rows.add([
        expense.id,
        expense.description,
        expense.amount.toString(),
        expense.type.displayName,
        expense.category.displayName,
        DateFormat('yyyy-MM-dd HH:mm:ss').format(expense.date),
        expense.notes ?? '',
        expense.receiptPath ?? '',
      ]);
    }

    final csvString = const ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvString.codeUnits);
  }

  Future<List<Expense>?> importExpenses() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final extension = result.files.single.extension?.toLowerCase();

        switch (extension) {
          case 'xlsx':
            return await _importFromExcel(filePath);
          case 'csv':
            return await _importFromCsv(filePath);
          default:
            throw Exception('Unsupported file format: $extension');
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to import expenses: $e');
    }
  }

  Future<List<Expense>> _importFromExcel(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    
    // Look for "Expenses" sheet first, then fall back to first available sheet
    Sheet? sheet = excel.tables['Expenses'];
    sheet ??= excel.tables.values.firstOrNull;
    
    if (sheet == null || sheet.rows.isEmpty) {
      throw Exception('Excel file is empty or corrupted');
    }

    final expenses = <Expense>[];
    final rows = sheet.rows;
    
    // Skip header row
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;
      
      try {
        final expense = _parseExpenseFromRow(row.map((cell) => cell?.value?.toString() ?? '').toList());
        expenses.add(expense);
      } catch (e) {
        // Skip invalid rows but continue processing
        // Skip invalid rows but continue processing
      }
    }

    return expenses;
  }

  Future<List<Expense>> _importFromCsv(String filePath) async {
    final file = File(filePath);
    final contents = await file.readAsString();
    final csvData = const CsvToListConverter().convert(contents);
    
    if (csvData.isEmpty) {
      throw Exception('CSV file is empty');
    }

    final expenses = <Expense>[];
    
    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.isEmpty) continue;
      
      try {
        final expense = _parseExpenseFromRow(row.map((cell) => cell?.toString() ?? '').toList());
        expenses.add(expense);
      } catch (e) {
        // Skip invalid rows but continue processing
        // Skip invalid rows but continue processing
      }
    }

    return expenses;
  }

  Expense _parseExpenseFromRow(List<String> row) {
    if (row.length < 6) {
      throw Exception('Invalid row format - insufficient columns');
    }

    // Parse expense type
    ExpenseType? type;
    for (final expenseType in ExpenseType.values) {
      if (expenseType.displayName.toLowerCase() == row[3].toLowerCase()) {
        type = expenseType;
        break;
      }
    }
    if (type == null) {
      throw Exception('Invalid expense type: ${row[3]}');
    }

    // Parse expense category
    ExpenseCategory? category;
    for (final expenseCategory in ExpenseCategory.values) {
      if (expenseCategory.displayName.toLowerCase() == row[4].toLowerCase()) {
        category = expenseCategory;
        break;
      }
    }
    if (category == null) {
      throw Exception('Invalid expense category: ${row[4]}');
    }

    // Parse date
    DateTime date;
    try {
      date = DateFormat('yyyy-MM-dd HH:mm:ss').parse(row[5]);
    } catch (e) {
      try {
        date = DateFormat('yyyy-MM-dd').parse(row[5]);
      } catch (e) {
        throw Exception('Invalid date format: ${row[5]}');
      }
    }

    // Parse amount
    double amount;
    try {
      amount = double.parse(row[2]);
    } catch (e) {
      throw Exception('Invalid amount: ${row[2]}');
    }

    return Expense(
      id: row[0].isNotEmpty ? row[0] : DateTime.now().millisecondsSinceEpoch.toString(),
      description: row[1],
      amount: amount,
      type: type,
      category: category,
      date: date,
      notes: row.length > 6 && row[6].isNotEmpty ? row[6] : null,
      receiptPath: row.length > 7 && row[7].isNotEmpty ? row[7] : null,
    );
  }

  // Scope-specific functionality
  static const List<String> scopeSegmentHeaders = [
    'Segment ID',
    'Title',
    'Type',
    'Status',
    'Start Date',
    'End Date',
    'Description',
    'Notes',
  ];

  static const List<String> scopeItemHeaders = [
    'Segment ID',
    'Item ID',
    'Type',
    'Target',
    'Description',
    'Date Added',
    'Is Active',
    'Notes',
  ];

  Future<String?> exportScope(
    List<ScopeSegment> segments,
    ExportFormat format, {
    String? customFileName,
    bool includeItems = true,
  }) async {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd_HH-mm-ss');
      final timestamp = dateFormat.format(DateTime.now());
      final fileName = customFileName ?? 'scope_export_$timestamp';
      
      late Uint8List bytes;
      late String fileExtension;
      
      switch (format) {
        case ExportFormat.excel:
          bytes = await _exportScopeToExcel(segments, includeItems);
          fileExtension = 'xlsx';
          break;
        case ExportFormat.csv:
          bytes = await _exportScopeToCsv(segments, includeItems);
          fileExtension = 'csv';
          break;
      }

      final directory = await getDownloadsDirectory() ?? await getTemporaryDirectory();
      final filePath = '${directory.path}/$fileName.$fileExtension';
      final file = File(filePath);
      
      await file.writeAsBytes(bytes);
      return filePath;
    } catch (e) {
      throw Exception('Failed to export scope: $e');
    }
  }

  Future<Uint8List> _exportScopeToExcel(List<ScopeSegment> segments, bool includeItems) async {
    final excel = Excel.createExcel();
    
    // Remove default sheet
    excel.delete('Sheet1');
    
    // Create segments sheet
    final segmentsSheet = excel['Segments'];
    _addScopeSegmentHeaders(segmentsSheet);
    _addScopeSegmentData(segmentsSheet, segments);
    
    // Create items sheet if requested
    if (includeItems) {
      final itemsSheet = excel['Items'];
      _addScopeItemHeaders(itemsSheet);
      _addScopeItemData(itemsSheet, segments);
    }

    return Uint8List.fromList(excel.encode()!);
  }

  void _addScopeSegmentHeaders(Sheet sheet) {
    for (int i = 0; i < scopeSegmentHeaders.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(scopeSegmentHeaders[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.blue100,
      );
    }
  }

  void _addScopeSegmentData(Sheet sheet, List<ScopeSegment> segments) {
    for (int rowIndex = 0; rowIndex < segments.length; rowIndex++) {
      final segment = segments[rowIndex];
      final dataRowIndex = rowIndex + 1;
      
      final rowData = [
        segment.id,
        segment.title,
        segment.type.displayName,
        segment.status.displayName,
        segment.startDate != null ? DateFormat('yyyy-MM-dd').format(segment.startDate!) : '',
        segment.endDate != null ? DateFormat('yyyy-MM-dd').format(segment.endDate!) : '',
        segment.description ?? '',
        segment.notes ?? '',
      ];

      for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: colIndex,
          rowIndex: dataRowIndex,
        ));
        cell.value = TextCellValue(rowData[colIndex]);
      }
    }

    // Auto-fit columns
    for (int i = 0; i < scopeSegmentHeaders.length; i++) {
      sheet.setColumnAutoFit(i);
    }
  }

  void _addScopeItemHeaders(Sheet sheet) {
    for (int i = 0; i < scopeItemHeaders.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(scopeItemHeaders[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        backgroundColorHex: ExcelColor.green100,
      );
    }
  }

  void _addScopeItemData(Sheet sheet, List<ScopeSegment> segments) {
    int dataRowIndex = 1;
    
    for (final segment in segments) {
      for (final item in segment.items) {
        final rowData = [
          segment.id,
          item.id,
          item.type.displayName,
          item.target,
          item.description,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(item.dateAdded),
          item.isActive.toString(),
          item.notes ?? '',
        ];

        for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
          final cell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex,
            rowIndex: dataRowIndex,
          ));
          cell.value = TextCellValue(rowData[colIndex]);
        }
        dataRowIndex++;
      }
    }

    // Auto-fit columns
    for (int i = 0; i < scopeItemHeaders.length; i++) {
      sheet.setColumnAutoFit(i);
    }
  }

  Future<Uint8List> _exportScopeToCsv(List<ScopeSegment> segments, bool includeItems) async {
    final List<List<String>> rows = [];
    
    if (includeItems) {
      // Combined format with items
      rows.add([
        'Segment ID', 'Segment Title', 'Segment Type', 'Segment Status',
        'Segment Start Date', 'Segment End Date', 'Segment Description',
        'Item ID', 'Item Type', 'Item Target', 'Item Description',
        'Item Date Added', 'Item Active', 'Item Notes'
      ]);
      
      for (final segment in segments) {
        if (segment.items.isEmpty) {
          // Add segment row without items
          rows.add([
            segment.id,
            segment.title,
            segment.type.displayName,
            segment.status.displayName,
            segment.startDate != null ? DateFormat('yyyy-MM-dd').format(segment.startDate!) : '',
            segment.endDate != null ? DateFormat('yyyy-MM-dd').format(segment.endDate!) : '',
            segment.description ?? '',
            '', '', '', '', '', '', ''
          ]);
        } else {
          // Add one row per item
          for (final item in segment.items) {
            rows.add([
              segment.id,
              segment.title,
              segment.type.displayName,
              segment.status.displayName,
              segment.startDate != null ? DateFormat('yyyy-MM-dd').format(segment.startDate!) : '',
              segment.endDate != null ? DateFormat('yyyy-MM-dd').format(segment.endDate!) : '',
              segment.description ?? '',
              item.id,
              item.type.displayName,
              item.target,
              item.description,
              DateFormat('yyyy-MM-dd HH:mm:ss').format(item.dateAdded),
              item.isActive.toString(),
              item.notes ?? '',
            ]);
          }
        }
      }
    } else {
      // Segments only
      rows.add(scopeSegmentHeaders);
      
      for (final segment in segments) {
        rows.add([
          segment.id,
          segment.title,
          segment.type.displayName,
          segment.status.displayName,
          segment.startDate != null ? DateFormat('yyyy-MM-dd').format(segment.startDate!) : '',
          segment.endDate != null ? DateFormat('yyyy-MM-dd').format(segment.endDate!) : '',
          segment.description ?? '',
          segment.notes ?? '',
        ]);
      }
    }

    final csvString = const ListToCsvConverter().convert(rows);
    return Uint8List.fromList(csvString.codeUnits);
  }

  Future<List<ScopeSegment>?> importScope() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'csv'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        final extension = result.files.single.extension?.toLowerCase();

        switch (extension) {
          case 'xlsx':
            return await _importScopeFromExcel(filePath);
          case 'csv':
            return await _importScopeFromCsv(filePath);
          default:
            throw Exception('Unsupported file format: $extension');
        }
      }
      return null;
    } catch (e) {
      throw Exception('Failed to import scope: $e');
    }
  }

  Future<List<ScopeSegment>> _importScopeFromExcel(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();
    final excel = Excel.decodeBytes(bytes);
    
    // Look for "Segments" sheet
    Sheet? segmentsSheet = excel.tables['Segments'];
    segmentsSheet ??= excel.tables.values.firstOrNull;
    
    if (segmentsSheet == null || segmentsSheet.rows.isEmpty) {
      throw Exception('Excel file is empty or corrupted');
    }

    final segments = <ScopeSegment>[];
    final segmentRows = segmentsSheet.rows;
    
    // Parse segments (skip header row)
    for (int i = 1; i < segmentRows.length; i++) {
      final row = segmentRows[i];
      if (row.isEmpty) continue;
      
      try {
        final segment = _parseScopeSegmentFromRow(row.map((cell) => cell?.value?.toString() ?? '').toList());
        segments.add(segment);
      } catch (e) {
        // Skip invalid rows but continue processing
      }
    }

    // Look for items sheet
    Sheet? itemsSheet = excel.tables['Items'];
    if (itemsSheet != null && itemsSheet.rows.isNotEmpty) {
      final itemRows = itemsSheet.rows;
      
      // Parse items (skip header row)
      for (int i = 1; i < itemRows.length; i++) {
        final row = itemRows[i];
        if (row.isEmpty) continue;
        
        try {
          final rowData = row.map((cell) => cell?.value?.toString() ?? '').toList();
          if (rowData.isNotEmpty) {
            final segmentId = rowData[0];
            final item = _parseScopeItemFromRow(rowData);
            
            // Find segment and add item
            final segmentIndex = segments.indexWhere((s) => s.id == segmentId);
            if (segmentIndex != -1) {
              final segment = segments[segmentIndex];
              segments[segmentIndex] = segment.copyWith(
                items: [...segment.items, item],
              );
            }
          }
        } catch (e) {
          // Skip invalid rows but continue processing
        }
      }
    }

    return segments;
  }

  Future<List<ScopeSegment>> _importScopeFromCsv(String filePath) async {
    final file = File(filePath);
    final contents = await file.readAsString();
    final csvData = const CsvToListConverter().convert(contents);
    
    if (csvData.isEmpty) {
      throw Exception('CSV file is empty');
    }

    final segments = <String, ScopeSegment>{};
    
    // Skip header row
    for (int i = 1; i < csvData.length; i++) {
      final row = csvData[i];
      if (row.isEmpty) continue;
      
      try {
        final rowData = row.map((cell) => cell?.toString() ?? '').toList();
        
        // Check if this is a combined format (has item columns)
        if (rowData.length >= 14) {
          // Combined format
          final segmentId = rowData[0];
          
          // Create or get segment
          if (!segments.containsKey(segmentId)) {
            final segment = _parseScopeSegmentFromCombinedRow(rowData);
            segments[segmentId] = segment;
          }
          
          // Add item if present
          if (rowData[7].isNotEmpty) { // Item ID
            final item = _parseScopeItemFromCombinedRow(rowData);
            final segment = segments[segmentId]!;
            segments[segmentId] = segment.copyWith(
              items: [...segment.items, item],
            );
          }
        } else {
          // Segments-only format
          final segment = _parseScopeSegmentFromRow(rowData);
          segments[segment.id] = segment;
        }
      } catch (e) {
        // Skip invalid rows but continue processing
      }
    }

    return segments.values.toList();
  }

  ScopeSegment _parseScopeSegmentFromRow(List<String> row) {
    if (row.length < 3) {
      throw Exception('Invalid segment row format - insufficient columns');
    }

    // Parse segment type
    ScopeSegmentType? type;
    for (final segmentType in ScopeSegmentType.values) {
      if (segmentType.displayName.toLowerCase() == row[2].toLowerCase()) {
        type = segmentType;
        break;
      }
    }
    if (type == null) {
      throw Exception('Invalid segment type: ${row[2]}');
    }

    // Parse segment status
    ScopeSegmentStatus? status;
    for (final segmentStatus in ScopeSegmentStatus.values) {
      if (segmentStatus.displayName.toLowerCase() == row[3].toLowerCase()) {
        status = segmentStatus;
        break;
      }
    }
    if (status == null) {
      throw Exception('Invalid segment status: ${row[3]}');
    }

    // Parse dates
    DateTime? startDate;
    if (row.length > 4 && row[4].isNotEmpty) {
      try {
        startDate = DateFormat('yyyy-MM-dd').parse(row[4]);
      } catch (e) {
        // Invalid date, skip
      }
    }

    DateTime? endDate;
    if (row.length > 5 && row[5].isNotEmpty) {
      try {
        endDate = DateFormat('yyyy-MM-dd').parse(row[5]);
      } catch (e) {
        // Invalid date, skip
      }
    }

    return ScopeSegment(
      id: row[0].isNotEmpty ? row[0] : DateTime.now().millisecondsSinceEpoch.toString(),
      title: row[1],
      type: type,
      status: status,
      startDate: startDate,
      endDate: endDate,
      description: row.length > 6 && row[6].isNotEmpty ? row[6] : null,
      notes: row.length > 7 && row[7].isNotEmpty ? row[7] : null,
    );
  }

  ScopeSegment _parseScopeSegmentFromCombinedRow(List<String> row) {
    return _parseScopeSegmentFromRow(row.sublist(0, 7));
  }

  ScopeItem _parseScopeItemFromRow(List<String> row) {
    if (row.length < 6) {
      throw Exception('Invalid item row format - insufficient columns');
    }

    // Parse item type (skip segment ID at index 0)
    ScopeItemType? type;
    for (final itemType in ScopeItemType.values) {
      if (itemType.displayName.toLowerCase() == row[2].toLowerCase()) {
        type = itemType;
        break;
      }
    }
    if (type == null) {
      throw Exception('Invalid item type: ${row[2]}');
    }

    // Parse date
    DateTime dateAdded;
    try {
      dateAdded = DateFormat('yyyy-MM-dd HH:mm:ss').parse(row[5]);
    } catch (e) {
      try {
        dateAdded = DateFormat('yyyy-MM-dd').parse(row[5]);
      } catch (e) {
        dateAdded = DateTime.now();
      }
    }

    // Parse active status
    bool isActive = true;
    if (row.length > 6 && row[6].isNotEmpty) {
      isActive = row[6].toLowerCase() == 'true';
    }

    return ScopeItem(
      id: row[1].isNotEmpty ? row[1] : DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      target: row[3],
      description: row[4],
      dateAdded: dateAdded,
      isActive: isActive,
      notes: row.length > 7 && row[7].isNotEmpty ? row[7] : null,
    );
  }

  ScopeItem _parseScopeItemFromCombinedRow(List<String> row) {
    // Extract item data from combined row format
    return ScopeItem(
      id: row[7].isNotEmpty ? row[7] : DateTime.now().millisecondsSinceEpoch.toString(),
      type: _parseItemType(row[8]),
      target: row[9],
      description: row[10],
      dateAdded: _parseDateTime(row[11]),
      isActive: row[12].toLowerCase() == 'true',
      notes: row.length > 13 && row[13].isNotEmpty ? row[13] : null,
    );
  }

  ScopeItemType _parseItemType(String typeString) {
    for (final itemType in ScopeItemType.values) {
      if (itemType.displayName.toLowerCase() == typeString.toLowerCase()) {
        return itemType;
      }
    }
    return ScopeItemType.url; // Default fallback
  }

  DateTime _parseDateTime(String dateString) {
    try {
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateString);
    } catch (e) {
      try {
        return DateFormat('yyyy-MM-dd').parse(dateString);
      } catch (e) {
        return DateTime.now();
      }
    }
  }
}