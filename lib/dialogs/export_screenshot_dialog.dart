import 'package:flutter/material.dart';

enum ExportFormat { png, jpeg }

class ExportOptions {
  final ExportFormat format;
  final int quality;
  final String filename;
  
  const ExportOptions({
    required this.format,
    required this.quality,
    required this.filename,
  });
}

class ExportScreenshotDialog extends StatefulWidget {
  final String defaultFilename;
  
  const ExportScreenshotDialog({
    super.key,
    required this.defaultFilename,
  });

  @override
  State<ExportScreenshotDialog> createState() => _ExportScreenshotDialogState();
}

class _ExportScreenshotDialogState extends State<ExportScreenshotDialog> {
  ExportFormat _selectedFormat = ExportFormat.png;
  double _quality = 90.0;
  late TextEditingController _filenameController;
  
  @override
  void initState() {
    super.initState();
    _filenameController = TextEditingController(text: widget.defaultFilename);
  }
  
  @override
  void dispose() {
    _filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.file_download),
          SizedBox(width: 8),
          Text('Export Screenshot'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filename input
            Text(
              'Filename',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _filenameController,
              decoration: InputDecoration(
                hintText: 'Enter filename',
                suffixText: '.${_selectedFormat.name}',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            const SizedBox(height: 20),
            
            // Format selection
            Text(
              'Format',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<ExportFormat>(
                    title: const Text('PNG'),
                    subtitle: const Text('Lossless, larger size'),
                    value: ExportFormat.png,
                    groupValue: _selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        _selectedFormat = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<ExportFormat>(
                    title: const Text('JPEG'),
                    subtitle: const Text('Compressed, smaller size'),
                    value: ExportFormat.jpeg,
                    groupValue: _selectedFormat,
                    onChanged: (value) {
                      setState(() {
                        _selectedFormat = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            
            // Quality slider (only for JPEG)
            if (_selectedFormat == ExportFormat.jpeg) ...[
              const SizedBox(height: 16),
              Text(
                'Quality: ${_quality.round()}%',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Slider(
                value: _quality,
                min: 10,
                max: 100,
                divisions: 18,
                label: '${_quality.round()}%',
                onChanged: (value) {
                  setState(() {
                    _quality = value;
                  });
                },
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Preview info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Export Information',
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        _selectedFormat == ExportFormat.png ? Icons.image : Icons.image_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Format: ${_selectedFormat.name.toUpperCase()}',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  if (_selectedFormat == ExportFormat.jpeg) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.compress,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Quality: ${_quality.round()}%',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.file_present,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'File: ${_filenameController.text.isNotEmpty ? _filenameController.text : 'unnamed'}.${_selectedFormat.name}',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
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
          onPressed: _filenameController.text.trim().isNotEmpty
              ? () {
                  final options = ExportOptions(
                    format: _selectedFormat,
                    quality: _quality.round(),
                    filename: '${_filenameController.text.trim()}.${_selectedFormat.name}',
                  );
                  Navigator.of(context).pop(options);
                }
              : null,
          icon: const Icon(Icons.file_download),
          label: const Text('Export'),
        ),
      ],
    );
  }
}