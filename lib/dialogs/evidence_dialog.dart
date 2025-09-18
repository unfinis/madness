import 'dart:io';
import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/evidence_service.dart';

class EvidenceDialog extends StatefulWidget {
  final Function(List<EvidenceFile>) onEvidenceAdded;
  final List<EvidenceFile> existingEvidence;

  const EvidenceDialog({
    super.key,
    required this.onEvidenceAdded,
    this.existingEvidence = const [],
  });

  @override
  State<EvidenceDialog> createState() => _EvidenceDialogState();
}

class _EvidenceDialogState extends State<EvidenceDialog> {
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
    return AlertDialog(
      title: const Text('Add Evidence'),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Capture or upload evidence files for this expense',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 16.0 : 20.0),
            
            // Capture Options
            Text(
              'Capture Methods',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
            Wrap(
              spacing: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0,
              runSpacing: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0,
              children: [
                _buildCaptureButton(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onPressed: _isCapturing ? null : _captureFromCamera,
                ),
                _buildCaptureButton(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onPressed: _isCapturing ? null : _captureFromGallery,
                ),
                if (!Platform.isLinux) // Hide clipboard on Linux
                  _buildCaptureButton(
                    icon: Icons.content_paste,
                    label: 'Clipboard',
                    onPressed: _isCapturing ? null : _captureFromClipboard,
                  ),
                _buildCaptureButton(
                  icon: Icons.upload_file,
                  label: 'Upload Files',
                  onPressed: _isCapturing ? null : _uploadFiles,
                ),
              ],
            ),
            
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 12.0 : 16.0),
              Container(
                padding: EdgeInsets.all(Theme.of(context).visualDensity == VisualDensity.compact ? 10.0 : 12.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 16,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    SizedBox(width: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            if (_selectedEvidence.isNotEmpty) ...[
              SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 16.0 : 20.0),
              Text(
                'Evidence Files (${_selectedEvidence.length})',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
              Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _selectedEvidence.length,
                  separatorBuilder: (context, index) => SizedBox(
                    height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0,
                  ),
                  itemBuilder: (context, index) {
                    final evidence = _selectedEvidence[index];
                    return _buildEvidenceItem(evidence);
                  },
                ),
              ),
            ],

            if (_isCapturing) ...[
              SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 12.0 : 16.0),
              const LinearProgressIndicator(),
              SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0),
              Text(
                'Capturing evidence...',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isCapturing ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isCapturing || _selectedEvidence.isEmpty 
              ? null 
              : () {
                  widget.onEvidenceAdded(_selectedEvidence);
                  Navigator.of(context).pop();
                },
          child: Text('Add ${_selectedEvidence.length} Evidence${_selectedEvidence.length == 1 ? '' : 's'}'),
        ),
      ],
    );
  }

  Widget _buildCaptureButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: Theme.of(context).visualDensity == VisualDensity.compact ? 10.0 : 12.0,
          vertical: Theme.of(context).visualDensity == VisualDensity.compact ? 6.0 : 8.0,
        ),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildEvidenceItem(EvidenceFile evidence) {
    return Container(
      padding: EdgeInsets.all(Theme.of(context).visualDensity == VisualDensity.compact ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Text(
            evidence.type.icon,
            style: const TextStyle(fontSize: 20),
          ),
          SizedBox(width: Theme.of(context).visualDensity == VisualDensity.compact ? 10.0 : 12.0),
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
                SizedBox(height: Theme.of(context).visualDensity == VisualDensity.compact ? 2.0 : 4.0),
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
            icon: const Icon(Icons.remove_circle_outline, size: 20),
            tooltip: 'Remove',
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