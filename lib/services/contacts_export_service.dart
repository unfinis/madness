import 'dart:io';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/contact.dart';

class ContactsExportService {
  static Future<File> exportToExcel(List<Contact> contacts) async {
    final excel = Excel.createExcel();
    
    // Remove default sheet and create Contacts sheet
    excel.delete('Sheet1');
    final sheet = excel['Contacts'];
    
    // Add headers
    final headers = [
      'Name',
      'Role',
      'Email',
      'Phone',
      'Role Tags',
      'Notes',
      'Date Added',
    ];
    
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
      );
    }
    
    // Add data rows
    for (int rowIndex = 0; rowIndex < contacts.length; rowIndex++) {
      final contact = contacts[rowIndex];
      final actualRowIndex = rowIndex + 1; // Account for header row
      
      final values = [
        contact.name,
        contact.role,
        contact.email,
        contact.phone,
        contact.tags.join(', '),
        contact.notes ?? '',
        DateFormat('yyyy-MM-dd').format(contact.dateAdded),
      ];
      
      for (int colIndex = 0; colIndex < values.length; colIndex++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
          columnIndex: colIndex,
          rowIndex: actualRowIndex,
        ));
        cell.value = TextCellValue(values[colIndex]);
      }
    }
    
    // Auto-fit columns (approximate)
    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnWidth(i, 20);
    }
    
    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/contacts_export_$timestamp.xlsx');
    
    final fileBytes = excel.save();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
    }
    
    return file;
  }
  
  static Future<File> exportToCSV(List<Contact> contacts) async {
    final List<List<dynamic>> rows = [];
    
    // Add headers
    rows.add([
      'Name',
      'Role',
      'Email',
      'Phone',
      'Role Tags',
      'Notes',
      'Date Added',
    ]);
    
    // Add data rows
    for (final contact in contacts) {
      rows.add([
        contact.name,
        contact.role,
        contact.email,
        contact.phone,
        contact.tags.join('; '),
        contact.notes ?? '',
        DateFormat('yyyy-MM-dd').format(contact.dateAdded),
      ]);
    }
    
    // Convert to CSV
    final csv = const ListToCsvConverter().convert(rows);
    
    // Save to file
    final directory = await getApplicationDocumentsDirectory();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/contacts_export_$timestamp.csv');
    await file.writeAsString(csv);
    
    return file;
  }
}