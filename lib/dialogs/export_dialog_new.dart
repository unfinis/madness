import 'package:flutter/material.dart';
import '../services/import_export_service.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../constants/app_spacing.dart';

class ExportDialog extends StandardDialog {
  final int totalExpenses;
  final VoidCallback onExport;

  const ExportDialog({
    super.key,
    required this.totalExpenses,
    required this.onExport,
  }) : super(
          title: 'Export Expenses',
          subtitle: 'Export your expense data to file',
          icon: Icons.download_rounded,
          size: DialogSize.small,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      _ExportDialogContent(
        totalExpenses: totalExpenses,
        onExport: onExport,
      ),
    ];
  }
}

class _ExportDialogContent extends StatefulWidget {
  final int totalExpenses;
  final VoidCallback onExport;

  const _ExportDialogContent({
    required this.totalExpenses,
    required this.onExport,
  });

  @override
  State<_ExportDialogContent> createState() => _ExportDialogContentState();
}

class _ExportDialogContentState extends State<_ExportDialogContent> {
  ExportFormat _selectedFormat = ExportFormat.excel;
  final _fileNameController = TextEditingController();

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Info
        DialogComponents.buildInfoCard(
          context: context,
          title: 'Export Summary',
          content: 'Export ${widget.totalExpenses} expense${widget.totalExpenses == 1 ? '' : 's'} to file',
          icon: Icons.summarize_rounded,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        ),

        AppSpacing.vGapXL,

        // Format Selection
        DialogComponents.buildFormSection(
          context: context,
          title: 'File Format',
          icon: Icons.file_copy_rounded,
          children: [
            SegmentedButton<ExportFormat>(
              segments: const [
                ButtonSegment<ExportFormat>(
                  value: ExportFormat.excel,
                  icon: Icon(Icons.table_chart, size: AppSizes.iconSM),
                  label: Text('Excel (.xlsx)'),
                ),
                ButtonSegment<ExportFormat>(
                  value: ExportFormat.csv,
                  icon: Icon(Icons.text_snippet, size: AppSizes.iconSM),
                  label: Text('CSV'),
                ),
              ],
              selected: {_selectedFormat},
              onSelectionChanged: (selection) {
                setState(() {
                  _selectedFormat = selection.first;
                });
              },
              style: SegmentedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                ),
              ),
            ),
          ],
        ),

        AppSpacing.vGapXL,

        // File Name Input
        DialogComponents.buildTextField(
          context: context,
          label: 'File Name (Optional)',
          controller: _fileNameController,
          hintText: 'Leave empty for auto-generated name',
          helperText: 'File extension will be added automatically',
          prefixIcon: Icons.drive_file_rename_outline,
        ),

        AppSpacing.vGapXL,

        // Format Info
        Container(
          padding: AppSpacing.cardPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: AppSizes.iconMD,
                color: Theme.of(context).colorScheme.primary,
              ),
              AppSpacing.hGapSM,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedFormat == ExportFormat.excel ? 'Excel Format' : 'CSV Format',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    AppSpacing.vGapXS,
                    Text(
                      _selectedFormat == ExportFormat.excel
                          ? 'Excel format includes formatting and is ideal for analysis and reporting'
                          : 'CSV format is lightweight and compatible with most spreadsheet applications',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        AppSpacing.vGapXL,

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: DialogComponents.buildSecondaryButton(
                context: context,
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.close_rounded,
              ),
            ),
            AppSpacing.hGapLG,
            Expanded(
              child: DialogComponents.buildPrimaryButton(
                context: context,
                text: 'Export',
                onPressed: () => _handleExport(context),
                icon: Icons.download_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleExport(BuildContext context) {
    final result = {
      'format': _selectedFormat,
      'fileName': _fileNameController.text.trim().isEmpty
          ? null
          : _fileNameController.text.trim(),
    };

    Navigator.of(context).pop(result);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: AppSizes.iconMD),
            AppSpacing.hGapSM,
            Text('Export started for ${widget.totalExpenses} expenses'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
      ),
    );
  }
}

// Convenience function to show the dialog
Future<Map<String, dynamic>?> showExportDialog({
  required BuildContext context,
  required int totalExpenses,
  required VoidCallback onExport,
}) {
  return showStandardDialog<Map<String, dynamic>>(
    context: context,
    dialog: ExportDialog(
      totalExpenses: totalExpenses,
      onExport: onExport,
    ),
    animationType: DialogAnimationType.slideFromBottom,
  );
}