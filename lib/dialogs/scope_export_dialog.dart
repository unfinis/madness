import 'package:flutter/material.dart';
import '../services/import_export_service.dart';

class ScopeExportDialog extends StatefulWidget {
  final int totalSegments;
  final int totalItems;

  const ScopeExportDialog({
    super.key,
    required this.totalSegments,
    required this.totalItems,
  });

  @override
  State<ScopeExportDialog> createState() => _ScopeExportDialogState();
}

class _ScopeExportDialogState extends State<ScopeExportDialog> {
  ExportFormat _selectedFormat = ExportFormat.excel;
  bool _includeItems = true;
  final _fileNameController = TextEditingController();

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Export Scope Data'),
      content: SizedBox(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Export ${widget.totalSegments} segment${widget.totalSegments == 1 ? '' : 's'}${_includeItems ? ' and ${widget.totalItems} item${widget.totalItems == 1 ? '' : 's'}' : ''} to file',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 16.0 : 20.0),
            
            Text(
              'Export Options',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
            CheckboxListTile(
              title: const Text('Include scope items'),
              subtitle: Text(
                _includeItems 
                    ? 'Export both segments and their items'
                    : 'Export segments only',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              value: _includeItems,
              onChanged: (value) {
                setState(() {
                  _includeItems = value ?? true;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 12.0 : 16.0),
            
            Text(
              'File Format',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
            SegmentedButton<ExportFormat>(
              segments: const [
                ButtonSegment<ExportFormat>(
                  value: ExportFormat.excel,
                  icon: Icon(Icons.table_chart, size: 16),
                  label: Text('Excel (.xlsx)'),
                ),
                ButtonSegment<ExportFormat>(
                  value: ExportFormat.csv,
                  icon: Icon(Icons.text_snippet, size: 16),
                  label: Text('CSV'),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedFormat = selection.first;
                });
              },
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 16.0 : 20.0),
            
            Text(
              'File Name (optional)',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
            TextField(
              controller: _fileNameController,
              decoration: InputDecoration(
                hintText: 'Leave empty for auto-generated name',
                suffixText: _selectedFormat == ExportFormat.excel ? '.xlsx' : '.csv',
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Theme.of(context).visualDensity == VisualDensity.compact ? 10.0 : 12.0, 
                  vertical: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0
                ),
              ),
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 12.0 : 16.0),
            
            Container(
              padding: EdgeInsets.all(Theme.of(context).visualDensity == VisualDensity.compact ? 10.0 : 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(width: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
                      Expanded(
                        child: Text(
                          _selectedFormat == ExportFormat.excel
                              ? 'Excel format creates separate sheets for segments and items'
                              : 'CSV format creates a single file with combined data',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (_selectedFormat == ExportFormat.excel && _includeItems) ...[
                    SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
                    Row(
                      children: [
                        Icon(
                          Icons.layers_outlined,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
                        Expanded(
                          child: Text(
                            'Creates "Segments" and "Items" sheets in the Excel file',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).pop({
              'format': _selectedFormat,
              'includeItems': _includeItems,
              'fileName': _fileNameController.text.trim().isEmpty 
                  ? null 
                  : _fileNameController.text.trim(),
            });
          },
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
        ),
      ],
    );
  }
}