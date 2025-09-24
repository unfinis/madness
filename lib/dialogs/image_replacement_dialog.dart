import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/image_replacement_service.dart';

class ImageReplacementDialog extends StatefulWidget {
  final ui.Image? currentImage;

  const ImageReplacementDialog({
    super.key,
    this.currentImage,
  });

  @override
  State<ImageReplacementDialog> createState() => _ImageReplacementDialogState();
}

class _ImageReplacementDialogState extends State<ImageReplacementDialog> {
  bool _isLoading = false;
  String _statusMessage = '';

  void _setLoading(bool loading, [String message = '']) {
    setState(() {
      _isLoading = loading;
      _statusMessage = message;
    });
  }

  Future<void> _pickFromFile() async {
    _setLoading(true, 'Selecting file...');
    try {
      final image = await ImageReplacementService.pickImageFromFile();
      if (image != null && mounted) {
        Navigator.of(context).pop(image);
      } else if (mounted) {
        _setLoading(false);
        _showErrorSnackBar('No image selected or failed to load');
      }
    } catch (e) {
      if (mounted) {
        _setLoading(false);
        _showErrorSnackBar('Error loading file: $e');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    _setLoading(true, 'Opening gallery...');
    try {
      final image = await ImageReplacementService.pickImageFromGallery();
      if (image != null && mounted) {
        Navigator.of(context).pop(image);
      } else if (mounted) {
        _setLoading(false);
        _showErrorSnackBar('No image selected or failed to load');
      }
    } catch (e) {
      if (mounted) {
        _setLoading(false);
        _showErrorSnackBar('Error loading from gallery: $e');
      }
    }
  }

  Future<void> _pasteFromClipboard() async {
    _setLoading(true, 'Checking clipboard...');
    try {
      final image = await ImageReplacementService.getImageFromClipboard();
      if (image != null && mounted) {
        Navigator.of(context).pop(image);
      } else if (mounted) {
        _setLoading(false);
        _showErrorSnackBar('Clipboard image paste not yet available - use file upload instead');
      }
    } catch (e) {
      if (mounted) {
        _setLoading(false);
        _showErrorSnackBar('Clipboard image paste not yet available - use file upload instead');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Replace Image'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.currentImage != null) ...[
              Text(
                'Current image: ${widget.currentImage!.width}×${widget.currentImage!.height}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
            ],

            Text(
              'Choose how to replace the image:',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            if (_isLoading) ...[
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(_statusMessage),
                  ],
                ),
              ),
            ] else ...[
              // File Upload Option
              _buildOptionCard(
                icon: Icons.upload_file,
                title: 'Upload from Computer',
                description: 'Select an image file from your device',
                onTap: _pickFromFile,
              ),
              const SizedBox(height: 12),

              // Gallery Option
              _buildOptionCard(
                icon: Icons.photo_library,
                title: 'Choose from Gallery',
                description: 'Select from your photo gallery',
                onTap: _pickFromGallery,
              ),
              const SizedBox(height: 12),

              // Clipboard Option
              _buildOptionCard(
                icon: Icons.content_paste,
                title: 'Paste from Clipboard',
                description: 'Use an image copied to clipboard',
                onTap: _pasteFromClipboard,
              ),
              const SizedBox(height: 16),

              // Drag & Drop hint
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You can also drag and drop an image directly onto the canvas',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}