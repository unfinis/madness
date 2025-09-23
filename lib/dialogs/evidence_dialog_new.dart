import 'dart:io';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/evidence_service.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../constants/app_spacing.dart';

class EvidenceDialog extends StandardDialog {
  final Function(List<EvidenceFile>) onEvidenceAdded;
  final List<EvidenceFile> existingEvidence;

  const EvidenceDialog({
    super.key,
    required this.onEvidenceAdded,
    this.existingEvidence = const [],
  }) : super(
          title: 'Add Evidence',
          subtitle: 'Capture or upload evidence files for this expense',
          icon: Icons.photo_library_rounded,
          size: DialogSize.medium,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      _EvidenceDialogContent(
        onEvidenceAdded: onEvidenceAdded,
        existingEvidence: existingEvidence,
      ),
    ];
  }
}

class _EvidenceDialogContent extends StatefulWidget {
  final Function(List<EvidenceFile>) onEvidenceAdded;
  final List<EvidenceFile> existingEvidence;

  const _EvidenceDialogContent({
    required this.onEvidenceAdded,
    this.existingEvidence = const [],
  });

  @override
  State<_EvidenceDialogContent> createState() => _EvidenceDialogContentState();
}

class _EvidenceDialogContentState extends State<_EvidenceDialogContent> {
  final _evidenceService = EvidenceService();
  final List<EvidenceFile> _selectedEvidence = [];
  bool _isCapturing = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _selectedEvidence.addAll(widget.existingEvidence);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Capture Methods Section
        DialogComponents.buildFormSection(
          context: context,
          title: 'Capture Methods',
          icon: Icons.camera_alt_rounded,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _buildCaptureButton(
                  context: context,
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onPressed: _isCapturing ? null : _captureFromCamera,
                ),
                _buildCaptureButton(
                  context: context,
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onPressed: _isCapturing ? null : _captureFromGallery,
                ),
                if (!Platform.isLinux)
                  _buildCaptureButton(
                    context: context,
                    icon: Icons.content_paste,
                    label: 'Clipboard',
                    onPressed: _isCapturing ? null : _captureFromClipboard,
                  ),
                _buildCaptureButton(
                  context: context,
                  icon: Icons.upload_file,
                  label: 'Upload Files',
                  onPressed: _isCapturing ? null : _uploadFiles,
                ),
              ],
            ),
          ],
        ),

        AppSpacing.vGapLG,

        // Error Display
        if (_errorMessage.isNotEmpty) ...[
          DialogComponents.buildInfoCard(
            context: context,
            title: 'Error',
            content: _errorMessage,
            icon: Icons.error_outline,
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            textColor: Theme.of(context).colorScheme.onErrorContainer,
          ),
          AppSpacing.vGapLG,
        ],

        // Evidence Files Section
        if (_selectedEvidence.isNotEmpty) ...[
          DialogComponents.buildFormSection(
            context: context,
            title: 'Evidence Files (${_selectedEvidence.length})',
            icon: Icons.attachment_rounded,
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _selectedEvidence.length,
                  separatorBuilder: (context, index) => AppSpacing.vGapSM,
                  itemBuilder: (context, index) {
                    final evidence = _selectedEvidence[index];
                    return _buildEvidenceItem(context, evidence);
                  },
                ),
              ),
            ],
          ),
          AppSpacing.vGapLG,
        ],

        // Capturing Progress
        if (_isCapturing) ...[
          DialogComponents.buildInfoCard(
            context: context,
            title: 'Capturing Evidence',
            content: 'Please wait while we process your evidence...',
            icon: Icons.hourglass_top_rounded,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
          AppSpacing.vGapSM,
          const LinearProgressIndicator(),
        ],

        // Action Buttons
        AppSpacing.vGapXL,
        Row(
          children: [
            Expanded(
              child: DialogComponents.buildSecondaryButton(
                context: context,
                text: 'Cancel',
                onPressed: _isCapturing ? null : () => Navigator.of(context).pop(),
                icon: Icons.close_rounded,
              ),
            ),
            AppSpacing.hGapLG,
            Expanded(
              child: DialogComponents.buildPrimaryButton(
                context: context,
                text: 'Add ${_selectedEvidence.length} Evidence${_selectedEvidence.length == 1 ? '' : 's'}',
                onPressed: _isCapturing || _selectedEvidence.isEmpty
                    ? null
                    : () {
                        widget.onEvidenceAdded(_selectedEvidence);
                        Navigator.of(context).pop();
                      },
                icon: Icons.add_rounded,
                isLoading: _isCapturing,
                loadingText: 'Processing...',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCaptureButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppSizes.iconSM),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
      ),
    );
  }

  Widget _buildEvidenceItem(BuildContext context, EvidenceFile evidence) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            child: Text(
              evidence.type.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          AppSpacing.hGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evidence.fileName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.vGapXS,
                Text(
                  '${evidence.type.displayName} • ${evidence.fileSizeBytes != null ? _evidenceService.formatFileSize(evidence.fileSizeBytes!) : 'Unknown size'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedEvidence.removeWhere((e) => e.id == evidence.id);
              });
            },
            icon: Icon(
              Icons.remove_circle_outline,
              size: AppSizes.iconMD,
              color: Theme.of(context).colorScheme.error,
            ),
            tooltip: 'Remove evidence',
          ),
        ],
      ),
    );
  }

  Future<void> _captureFromCamera() async {
    setState(() {
      _isCapturing = true;
      _errorMessage = '';
    });

    try {
      final evidence = await _evidenceService.captureFromCamera();
      if (evidence != null) {
        setState(() {
          _selectedEvidence.add(evidence);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _captureFromGallery() async {
    setState(() {
      _isCapturing = true;
      _errorMessage = '';
    });

    try {
      final evidence = await _evidenceService.captureFromGallery();
      if (evidence != null) {
        setState(() {
          _selectedEvidence.add(evidence);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _captureFromClipboard() async {
    setState(() {
      _isCapturing = true;
      _errorMessage = '';
    });

    try {
      final evidence = await _evidenceService.captureFromClipboard();
      if (evidence != null) {
        setState(() {
          _selectedEvidence.add(evidence);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }

  Future<void> _uploadFiles() async {
    setState(() {
      _isCapturing = true;
      _errorMessage = '';
    });

    try {
      final evidenceFiles = await _evidenceService.uploadFiles();
      if (evidenceFiles.isNotEmpty) {
        setState(() {
          _selectedEvidence.addAll(evidenceFiles);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isCapturing = false;
      });
    }
  }
}

// Convenience function to show the dialog
Future<void> showEvidenceDialog({
  required BuildContext context,
  required Function(List<EvidenceFile>) onEvidenceAdded,
  List<EvidenceFile> existingEvidence = const [],
}) {
  return showStandardDialog(
    context: context,
    dialog: EvidenceDialog(
      onEvidenceAdded: onEvidenceAdded,
      existingEvidence: existingEvidence,
    ),
    animationType: DialogAnimationType.scaleAndFade,
  );
}