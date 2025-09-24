import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:typed_data';
import '../models/screenshot.dart';
import '../models/screenshot_category.dart';
import '../providers/database_provider.dart';
import '../providers/screenshot_providers.dart';
import '../services/screenshot_upload_service.dart';

class UploadScreenshotDialog extends ConsumerStatefulWidget {
  final String projectId;

  const UploadScreenshotDialog({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<UploadScreenshotDialog> createState() => _UploadScreenshotDialogState();
}

class _UploadScreenshotDialogState extends ConsumerState<UploadScreenshotDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _captionController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _screenshotUploadService = ScreenshotUploadService();
  
  File? _selectedFile;
  Uint8List? _fileBytes;
  String? _fileName;
  String _screenshotId = '';
  ScreenshotCategory _selectedCategory = ScreenshotCategory.other;
  bool _autoDetectSensitive = false;
  bool _isUploading = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    // Generate screenshot ID
    _screenshotId = 'SCR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _captionController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final maxWidth = screenSize.width > 600 ? 500.0 : screenSize.width * 0.9;
    final maxHeight = screenSize.height * 0.8;
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.add_photo_alternate,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Create Screenshot or Placeholder',
              style: theme.textTheme.titleLarge,
            ),
          ),
        ],
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: maxWidth,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add explanatory header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You can either upload an existing image or create an empty placeholder for future capture.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

              // File Selection Area
              _buildFileSelectionArea(theme),
              
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Show file info if available
              if (_selectedFile != null || _fileBytes != null) ...[
                // Screenshot Info
                _buildScreenshotInfo(theme),
                const SizedBox(height: 16),
              ],
              
              // Screenshot ID field (read-only) - the only required field
              TextFormField(
                initialValue: _screenshotId,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Screenshot ID (Auto-generated) *',
                  hintText: 'Auto-generated unique identifier',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),

              const SizedBox(height: 24),

              // Optional fields header
              Text(
                'Optional Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Screenshot Name',
                  hintText: 'Optional: Enter a name (defaults to Screenshot ID if empty)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Description field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Optional description of the screenshot or placeholder',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Caption field
              TextFormField(
                controller: _captionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Caption',
                  hintText: 'Brief description of what this should capture',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Capture Instructions field - especially important for placeholders
              TextFormField(
                controller: _instructionsController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Capture Instructions',
                  hintText: 'Step-by-step instructions for reproducing this screenshot\ne.g., "In wireshark filter on LLMNR || NBNS"',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              // Category dropdown
              DropdownButtonFormField<ScreenshotCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ScreenshotCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                },
              ),
              
              
              // Only show auto-detect for actual file uploads
              if (_selectedFile != null || _fileBytes != null) ...[
                const SizedBox(height: 16),
                
                // Auto-detect sensitive information checkbox
                CheckboxListTile(
                  value: _autoDetectSensitive,
                  onChanged: (value) {
                    setState(() {
                      _autoDetectSensitive = value ?? false;
                    });
                  },
                  title: const Text('Auto-detect and flag sensitive information'),
                  subtitle: const Text('Automatically identify and mark sensitive data in the screenshot'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ],
                ],
              ),
            ),
          ),
        ),
      ),
      actions: screenSize.width < 600 
          ? [
              // Mobile layout - stack vertically
              SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton.icon(
                      onPressed: !_isUploading ? _handleCreateScreenshot : null,
                      icon: _isUploading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(_selectedFile != null || _fileBytes != null
                              ? Icons.upload
                              : Icons.add_photo_alternate_outlined),
                      label: _isUploading
                          ? const Text('Processing...')
                          : Text(_selectedFile != null || _fileBytes != null
                              ? 'Create with Image'
                              : 'Create Empty Screenshot'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
              ),
            ]
          : [
              // Desktop layout - horizontal
              TextButton(
                onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: !_isUploading ? _handleCreateScreenshot : null,
                icon: _isUploading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(_selectedFile != null || _fileBytes != null
                        ? Icons.upload
                        : Icons.add_photo_alternate_outlined),
                label: _isUploading
                    ? const Text('Processing...')
                    : Text(_selectedFile != null || _fileBytes != null
                        ? 'Create with Image'
                        : 'Create Empty Screenshot'),
              ),
            ],
    );
  }

  Widget _buildFileSelectionArea(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 140,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: _selectedFile != null || _fileBytes != null
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
        color: _selectedFile != null || _fileBytes != null
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1)
            : theme.colorScheme.surface,
      ),
      child: _selectedFile != null || _fileBytes != null
          ? _buildSelectedFileInfo(theme)
          : _buildFileSelectionPrompt(theme),
    );
  }

  Widget _buildFileSelectionPrompt(ThemeData theme) {
    return InkWell(
      onTap: _showFileSelectionOptions,
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_upload_outlined,
            size: 32,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            'Click to select an existing image file',
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Text(
            'Supported: PNG, JPG, JPEG, GIF, BMP, WebP',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  'This step is completely optional',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedFileInfo(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _fileName ?? 'Selected file',
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_selectedFile != null) ...[
                  Text(
                    _screenshotUploadService.formatFileSize(_selectedFile!.lengthSync()),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: _clearSelection,
            icon: const Icon(Icons.close),
            tooltip: 'Remove file',
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshotInfo(ThemeData theme) {
    if (_selectedFile == null && _fileBytes == null) return const SizedBox.shrink();

    return FutureBuilder<Map<String, dynamic>?>(
      future: _screenshotUploadService.getImageInfo(_selectedFile, _fileBytes),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final info = snapshot.data!;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                '${info['width']}×${info['height']} • ${info['format']} • ${info['sizeFormatted']}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _showFileSelectionOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
            if (Platform.isWindows || Platform.isMacOS || Platform.isLinux)
              ListTile(
                leading: const Icon(Icons.folder),
                title: const Text('Choose from Files'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImageFromFiles();
                },
              ),
            if (Platform.isAndroid || Platform.isIOS)
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      
      if (image != null) {
        final file = File(image.path);
        final bytes = await file.readAsBytes();
        
        setState(() {
          _selectedFile = file;
          _fileBytes = bytes;
          _fileName = path.basename(file.path);
          _errorMessage = null;
          
          // Auto-populate name if empty
          if (_nameController.text.isEmpty) {
            final nameWithoutExt = path.basenameWithoutExtension(file.path);
            _nameController.text = nameWithoutExt.replaceAll(RegExp(r'[_-]'), ' ');
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select image: ${e.toString()}';
      });
    }
  }

  Future<void> _pickImageFromFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        
        setState(() {
          _selectedFile = file.path != null ? File(file.path!) : null;
          _fileBytes = file.bytes;
          _fileName = file.name;
          _errorMessage = null;
          
          // Auto-populate name if empty
          if (_nameController.text.isEmpty) {
            final nameWithoutExt = path.basenameWithoutExtension(file.name);
            _nameController.text = nameWithoutExt.replaceAll(RegExp(r'[_-]'), ' ');
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to select file: ${e.toString()}';
      });
    }
  }

  Future<void> _takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      
      if (image != null) {
        final file = File(image.path);
        final bytes = await file.readAsBytes();
        
        setState(() {
          _selectedFile = file;
          _fileBytes = bytes;
          _fileName = path.basename(file.path);
          _errorMessage = null;
          
          // Auto-populate name with timestamp if empty
          if (_nameController.text.isEmpty) {
            final now = DateTime.now();
            _nameController.text = 'Screenshot ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';
          }
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to take photo: ${e.toString()}';
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFile = null;
      _fileBytes = null;
      _fileName = null;
      _errorMessage = null;
    });
  }

  Future<void> _handleCreateScreenshot() async {
    if (_selectedFile != null || _fileBytes != null) {
      // User has selected a file, upload it
      await _uploadScreenshot();
    } else {
      // No file selected, create placeholder
      await _createPlaceholder();
    }
  }

  Future<void> _createPlaceholder() async {
    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final database = ref.read(databaseProvider);
      final now = DateTime.now();

      // Generate default name if none provided
      final name = _nameController.text.trim().isEmpty
          ? 'Screenshot $_screenshotId'
          : _nameController.text.trim();

      // Create placeholder screenshot with required fields
      final placeholder = Screenshot(
        id: _screenshotId,
        projectId: widget.projectId,
        name: name,
        description: _descriptionController.text.trim(),
        caption: _captionController.text.trim(),
        instructions: _instructionsController.text.trim(),
        originalPath: '', // Empty for placeholder
        editedPath: null,
        thumbnailPath: null,
        width: 0, // Placeholder dimensions
        height: 0,
        fileSize: 0,
        fileFormat: 'placeholder',
        captureDate: now,
        createdDate: now,
        modifiedDate: now,
        category: _selectedCategory.value,
        tags: <String>{},
        hasRedactions: false,
        isProcessed: false,
        isPlaceholder: true, // Mark as placeholder
        metadata: {
          'placeholder': true,
          'created_by': 'user',
          'template_ready': true,
        },
        layers: [],
      );

      print('DEBUG: Creating placeholder screenshot with isPlaceholder = ${placeholder.isPlaceholder}');

      await database.insertScreenshot(placeholder, widget.projectId);
      
      // Invalidate providers to refresh data
      ref.invalidate(projectScreenshotsProvider(widget.projectId));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Placeholder "${placeholder.name}" created successfully'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            action: SnackBarAction(
              label: 'View',
              onPressed: () {
                // Could navigate to the screenshots list
              },
            ),
          ),
        );
        Navigator.of(context).pop(placeholder);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to create placeholder: ${e.toString()}';
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadScreenshot() async {
    if (_selectedFile == null && _fileBytes == null) return;

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final database = ref.read(databaseProvider);

      // Generate default name if none provided
      final name = _nameController.text.trim().isEmpty
          ? 'Screenshot $_screenshotId'
          : _nameController.text.trim();

      final screenshot = await _screenshotUploadService.createScreenshotFromFileExtended(
        projectId: widget.projectId,
        file: _selectedFile,
        fileBytes: _fileBytes,
        fileName: _fileName!,
        name: name,
        description: _descriptionController.text.trim(),
        caption: _captionController.text.trim(),
        instructions: _instructionsController.text.trim(),
        category: _selectedCategory.value,
        screenshotId: _screenshotId,
        isPlaceholder: false, // Regular upload is not a placeholder
      );

      await database.insertScreenshot(screenshot, widget.projectId);
      
      // Invalidate providers to refresh data
      ref.invalidate(projectScreenshotsProvider(widget.projectId));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Screenshot "${screenshot.name}" uploaded successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.of(context).pop(screenshot);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Upload failed: ${e.toString()}';
        _isUploading = false;
      });
    }
  }

  /// Helper method to convert placeholder to actual screenshot
  static Future<Screenshot> convertPlaceholderToScreenshot({
    required Screenshot placeholder,
    required File? file,
    required Uint8List? fileBytes,
    required String fileName,
    required String projectId,
    required ScreenshotUploadService uploadService,
  }) async {
    if (!placeholder.isPlaceholder) {
      throw ArgumentError('Screenshot is not a placeholder');
    }

    // Create new screenshot from file but keep placeholder metadata
    final newScreenshot = await uploadService.createScreenshotFromFileExtended(
      projectId: projectId,
      file: file,
      fileBytes: fileBytes,
      fileName: fileName,
      name: placeholder.name, // Keep original name
      description: placeholder.description, // Keep original description
      caption: placeholder.caption, // Keep original caption
      instructions: placeholder.instructions, // Keep original instructions
      category: placeholder.category, // Keep original category
      screenshotId: placeholder.id, // Keep same ID to replace
      isPlaceholder: false, // No longer a placeholder
    );

    // Preserve original metadata but update placeholder status
    final updatedMetadata = Map<String, dynamic>.from(placeholder.metadata);
    updatedMetadata['placeholder'] = false;
    updatedMetadata['converted_from_placeholder'] = true;
    updatedMetadata['converted_date'] = DateTime.now().toIso8601String();

    return newScreenshot.copyWith(
      tags: placeholder.tags, // Keep original tags
      metadata: updatedMetadata,
      layers: placeholder.layers, // Keep any existing layers
    );
  }
}