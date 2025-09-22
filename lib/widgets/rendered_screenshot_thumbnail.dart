import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/screenshot.dart';
import '../services/screenshot_thumbnail_service.dart';

class RenderedScreenshotThumbnail extends StatefulWidget {
  final Screenshot screenshot;
  final double? width;
  final double? height;
  final BoxFit fit;

  const RenderedScreenshotThumbnail({
    super.key,
    required this.screenshot,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  State<RenderedScreenshotThumbnail> createState() => _RenderedScreenshotThumbnailState();
}

class _RenderedScreenshotThumbnailState extends State<RenderedScreenshotThumbnail> {
  ui.Image? _thumbnailImage;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _generateThumbnail();
  }

  @override
  void didUpdateWidget(RenderedScreenshotThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Regenerate thumbnail if screenshot changed
    if (oldWidget.screenshot.id != widget.screenshot.id ||
        oldWidget.screenshot.layers.length != widget.screenshot.layers.length) {
      _generateThumbnail();
    }
  }

  Future<void> _generateThumbnail() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      ui.Image? thumbnail;

      if (widget.screenshot.isPlaceholder) {
        // Generate placeholder thumbnail
        thumbnail = await ScreenshotThumbnailService.generatePlaceholderThumbnail(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
          iconColor: Theme.of(context).colorScheme.secondary,
          icon: Icons.insert_photo_outlined,
          text: 'Placeholder',
        );
      } else if (widget.screenshot.originalPath.isNotEmpty) {
        // Generate thumbnail with layers
        thumbnail = await ScreenshotThumbnailService.generateThumbnailWithLayers(widget.screenshot);

        // Fallback to placeholder if generation failed
        if (thumbnail == null) {
          thumbnail = await ScreenshotThumbnailService.generatePlaceholderThumbnail(
            backgroundColor: Colors.grey.shade200,
            iconColor: Colors.grey.shade400,
            icon: Icons.broken_image,
            text: 'Failed to load',
          );
        }
      } else {
        // No image path - create empty placeholder
        thumbnail = await ScreenshotThumbnailService.generatePlaceholderThumbnail(
          backgroundColor: Colors.grey.shade100,
          iconColor: Colors.grey.shade400,
          icon: Icons.image,
          text: 'No image',
        );
      }

      if (mounted) {
        setState(() {
          _thumbnailImage = thumbnail;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error generating thumbnail for ${widget.screenshot.id}: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade200,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_hasError || _thumbnailImage == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade200,
        child: Icon(
          Icons.error,
          color: Colors.red.shade400,
          size: 32,
        ),
      );
    }

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ScreenshotThumbnailService.createImageWidget(
        _thumbnailImage!,
        fit: widget.fit,
      ),
    );
  }

  @override
  void dispose() {
    _thumbnailImage?.dispose();
    super.dispose();
  }
}