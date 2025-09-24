import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../../services/image_replacement_service.dart';

class DragDropWrapper extends StatefulWidget {
  final Widget child;
  final Function(ui.Image)? onImageDropped;
  final bool enabled;

  const DragDropWrapper({
    super.key,
    required this.child,
    this.onImageDropped,
    this.enabled = true,
  });

  @override
  State<DragDropWrapper> createState() => _DragDropWrapperState();
}

class _DragDropWrapperState extends State<DragDropWrapper> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return DropTarget(
      onDragEntered: (detail) {
        setState(() {
          _isDragging = true;
        });
      },
      onDragExited: (detail) {
        setState(() {
          _isDragging = false;
        });
      },
      onDragDone: (detail) async {
        setState(() {
          _isDragging = false;
        });

        // Process dropped files
        for (final file in detail.files) {
          if (ImageReplacementService.isSupportedImageFile(file.path)) {
            final image = await ImageReplacementService.loadImageFromPath(file.path);
            if (image != null) {
              widget.onImageDropped?.call(image);
              break; // Only process the first valid image
            }
          }
        }
      },
      child: Stack(
        children: [
          widget.child,
          if (_isDragging)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Drop image here to replace',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Supported formats: PNG, JPG, GIF, BMP, WebP',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}