import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/screenshot.dart';
import '../constants/app_spacing.dart';

class ScreenshotPropertiesDialog extends ConsumerStatefulWidget {
  final Screenshot screenshot;
  final Function(Screenshot) onSave;

  const ScreenshotPropertiesDialog({
    super.key,
    required this.screenshot,
    required this.onSave,
  });

  @override
  ConsumerState<ScreenshotPropertiesDialog> createState() =>
      _ScreenshotPropertiesDialogState();
}

class _ScreenshotPropertiesDialogState
    extends ConsumerState<ScreenshotPropertiesDialog> {
  late TextEditingController _nameController;
  late TextEditingController _captionController;
  late TextEditingController _descriptionController;
  late TextEditingController _instructionsController;
  late TextEditingController _categoryController;
  late TextEditingController _tagsController;
  DateTime? _captureDate;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.screenshot.name);
    _captionController = TextEditingController(text: widget.screenshot.caption);
    _descriptionController = TextEditingController(text: widget.screenshot.description);
    _instructionsController = TextEditingController(text: widget.screenshot.instructions);
    _categoryController = TextEditingController(text: widget.screenshot.category);
    _tagsController = TextEditingController(text: widget.screenshot.tags.join(', '));
    _captureDate = widget.screenshot.captureDate;

    // Add listeners to detect changes
    _nameController.addListener(_onChanged);
    _captionController.addListener(_onChanged);
    _descriptionController.addListener(_onChanged);
    _instructionsController.addListener(_onChanged);
    _categoryController.addListener(_onChanged);
    _tagsController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _captionController.dispose();
    _descriptionController.dispose();
    _instructionsController.dispose();
    _categoryController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  void _onCaptureDateChanged(DateTime? date) {
    setState(() {
      _captureDate = date;
      _hasChanges = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 600,
        height: 700,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.image_outlined,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                  AppSpacing.hGapMD,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Screenshot Properties',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        AppSpacing.vGapXS,
                        Text(
                          'Edit metadata and capture details',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Basic Information Section
                    _buildSection(
                      context,
                      'Basic Information',
                      Icons.info_outline,
                      [
                        _buildTextField(
                          'Screenshot Name',
                          _nameController,
                          'Enter a descriptive name for this screenshot',
                          required: true,
                        ),
                        AppSpacing.vGapMD,
                        _buildTextField(
                          'Caption',
                          _captionController,
                          'Brief caption or title for reports',
                          maxLines: 2,
                        ),
                        AppSpacing.vGapMD,
                        _buildTextField(
                          'Category',
                          _categoryController,
                          'Category (e.g., vulnerability, evidence, process)',
                        ),
                        AppSpacing.vGapMD,
                        _buildTextField(
                          'Tags',
                          _tagsController,
                          'Comma-separated tags for organization',
                          helperText: 'Separate tags with commas (e.g., critical, web, authentication)',
                        ),
                      ],
                    ),

                    AppSpacing.vGapLG,

                    // Description Section
                    _buildSection(
                      context,
                      'Description & Instructions',
                      Icons.description_outlined,
                      [
                        _buildTextField(
                          'Description',
                          _descriptionController,
                          'Detailed description of what this screenshot shows',
                          maxLines: 4,
                        ),
                        AppSpacing.vGapMD,
                        _buildTextField(
                          'Instructions',
                          _instructionsController,
                          'Step-by-step instructions or context for reproducing this',
                          maxLines: 4,
                        ),
                      ],
                    ),

                    AppSpacing.vGapLG,

                    // Capture Details Section
                    _buildSection(
                      context,
                      'Capture Details',
                      Icons.schedule_outlined,
                      [
                        _buildDateField(
                          context,
                          'Capture Date',
                          _captureDate,
                          _onCaptureDateChanged,
                        ),
                        AppSpacing.vGapMD,
                        _buildMetadataCard(context),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Footer Actions
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (_hasChanges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Unsaved changes',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  AppSpacing.hGapMD,
                  FilledButton.icon(
                    onPressed: _hasChanges ? _saveChanges : null,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.hGapSM,
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          // Section Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String hint, {
    bool required = false,
    int maxLines = 1,
    String? helperText,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        AppSpacing.vGapXS,
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            helperMaxLines: 2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? value,
    Function(DateTime?) onChanged,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.vGapXS,
        InkWell(
          onTap: () => _selectDate(context, value, onChanged),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: theme.colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Text(
                    value != null
                        ? '${value.day}/${value.month}/${value.year} at ${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}'
                        : 'Select capture date and time',
                    style: value != null
                        ? theme.textTheme.bodyLarge
                        : theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataCard(BuildContext context) {
    final theme = Theme.of(context);
    final screenshot = widget.screenshot;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 16,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.hGapSM,
              Text(
                'Technical Details',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.vGapMD,
          _buildInfoRow('Dimensions', '${screenshot.width} × ${screenshot.height} pixels'),
          _buildInfoRow('File Size', _formatFileSize(screenshot.fileSize)),
          _buildInfoRow('Format', screenshot.fileFormat.toUpperCase()),
          _buildInfoRow('Created', _formatDateTime(screenshot.createdDate)),
          _buildInfoRow('Modified', _formatDateTime(screenshot.modifiedDate)),
          _buildInfoRow('Layers', '${screenshot.layers.length} layers'),
          if (screenshot.hasRedactions)
            _buildInfoRow('Redactions', 'Contains sensitive content', isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isHighlighted = false}) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          AppSpacing.hGapMD,
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isHighlighted
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface,
                fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? currentValue,
    Function(DateTime?) onChanged,
  ) async {
    final date = await showDatePicker(
      context: context,
      initialDate: currentValue ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null) {
      if (!context.mounted) return;

      final time = await showTimePicker(
        context: context,
        initialTime: currentValue != null
            ? TimeOfDay.fromDateTime(currentValue)
            : TimeOfDay.now(),
      );

      if (time != null) {
        final combinedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
        onChanged(combinedDateTime);
      }
    }
  }

  void _saveChanges() {
    final tags = _tagsController.text
        .split(',')
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toSet();

    final updatedScreenshot = widget.screenshot.copyWith(
      name: _nameController.text.trim(),
      caption: _captionController.text.trim(),
      description: _descriptionController.text.trim(),
      instructions: _instructionsController.text.trim(),
      category: _categoryController.text.trim().isEmpty
          ? 'other'
          : _categoryController.text.trim(),
      tags: tags,
      captureDate: _captureDate ?? widget.screenshot.captureDate,
      modifiedDate: DateTime.now(),
    );

    widget.onSave(updatedScreenshot);
    Navigator.of(context).pop();
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}