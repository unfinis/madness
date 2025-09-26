import 'dart:ui' as ui;
import 'dart:math' as math;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/editor_tool.dart';
import '../../models/editor_layer.dart';
import '../../models/screenshot.dart';
import '../../providers/screenshot_providers.dart';
import '../../providers/database_provider.dart';
import '../../services/image_replacement_service.dart';

class EditorCanvas extends ConsumerStatefulWidget {
  final String screenshotId;
  final String projectId;
  final EditorTool selectedTool;
  final ToolConfig toolConfig;
  final List<EditorLayer> layers;
  final Function(EditorLayer)? onLayerAdded;
  final Function(String, EditorLayer)? onLayerUpdated;
  final Function(String?)? onLayerSelected;
  final bool enableSnapping;
  final bool showGuides;
  final int Function()? getNextNumberLabelValue;
  final VoidCallback? onGuideToolTapped;
  final bool isVerticalGuideMode;
  final VoidCallback? onGuidesChanged;
  final Function(Rect?)? onCropChanged; // Callback for crop changes
  final Rect? initialCropBounds; // Initial crop bounds from metadata
  final Function(ui.Image)? onImageReplaced; // Callback for image replacement
  final VoidCallback? onCropStateChanged; // Callback when crop pending state changes

  const EditorCanvas({
    super.key,
    required this.screenshotId,
    required this.projectId,
    this.selectedTool = EditorTool.select,
    required this.toolConfig,
    this.layers = const [],
    this.onLayerAdded,
    this.onLayerUpdated,
    this.onLayerSelected,
    this.enableSnapping = true,
    this.showGuides = true,
    this.getNextNumberLabelValue,
    this.onGuideToolTapped,
    this.isVerticalGuideMode = true,
    this.onGuidesChanged,
    this.onCropChanged,
    this.initialCropBounds,
    this.onImageReplaced,
    this.onCropStateChanged,
  });

  @override
  ConsumerState<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends ConsumerState<EditorCanvas> {
  double _zoom = 1.0;
  Offset _pan = Offset.zero;
  ui.Image? _backgroundImage;
  bool _isLoading = true;

  // Store cached image data for pixel sampling
  ui.Image? _cachedImageForSampling;
  ByteData? _imagePixelData;
  
  // Drawing state
  final List<EditorLayer> _tempLayers = [];
  Offset? _drawingStart;
  Offset? _drawingEnd;
  bool _isDrawing = false;
  
  // Crop state - non-destructive crop that works on all layers
  Rect? _activeCropBounds; // Current confirmed crop bounds (from metadata)
  Rect? _previewCropBounds; // Temporary crop bounds being drawn
  Rect? _previousCropBounds; // Previous crop bounds for cancellation
  bool _isCropMode = false;
  bool _isCropResizing = false;
  String? _cropResizeHandle; // 'tl', 'tr', 'bl', 'br', 't', 'b', 'l', 'r'
  
  // Move/Resize state
  String? _selectedLayerId;
  Offset? _dragStart;
  Offset? _initialLayerPosition;
  Rect? _initialLayerBounds;
  bool _isDragging = false;
  bool _isResizing = false;
  String? _resizeHandle; // 'tl', 'tr', 'bl', 'br', 't', 'b', 'l', 'r'
  String? _hoverHandle; // Track which handle we're hovering over
  
  // Guides system
  final List<double> _verticalGuides = [];
  final List<double> _horizontalGuides = [];
  String? _draggingGuide; // 'v0', 'h1', etc.
  bool _isDraggingGuide = false;
  bool _isVerticalGuideMode = true; // Track guide orientation mode


  /// Get the appropriate cursor for the selected tool
  MouseCursor _getCursorForTool(EditorTool tool) {
    switch (tool) {
      case EditorTool.pan:
        return _isDrawing ? SystemMouseCursors.grabbing : SystemMouseCursors.grab; // Hand cursor
      case EditorTool.crop:
        // Return resize cursor when hovering over handles
        if (_hoverHandle != null) {
          switch (_hoverHandle) {
            case 'tl':
            case 'br':
              return SystemMouseCursors.resizeUpLeftDownRight;
            case 'tr':
            case 'bl':
              return SystemMouseCursors.resizeUpRightDownLeft;
            case 't':
            case 'b':
              return SystemMouseCursors.resizeUpDown;
            case 'l':
            case 'r':
              return SystemMouseCursors.resizeLeftRight;
          }
        }
        return SystemMouseCursors.precise;
      case EditorTool.select:
        // Return resize cursor when hovering over handles
        if (_hoverHandle != null) {
          switch (_hoverHandle) {
            case 'tl':
            case 'br':
              return SystemMouseCursors.resizeUpLeftDownRight;
            case 'tr':
            case 'bl':
              return SystemMouseCursors.resizeUpRightDownLeft;
            case 't':
            case 'b':
              return SystemMouseCursors.resizeUpDown;
            case 'l':
            case 'r':
              return SystemMouseCursors.resizeLeftRight;
          }
        }
        return SystemMouseCursors.basic; // Arrow cursor
      case EditorTool.move:
        // Return resize cursor when hovering over handles
        if (_hoverHandle != null) {
          switch (_hoverHandle) {
            case 'tl':
            case 'br':
              return SystemMouseCursors.resizeUpLeftDownRight;
            case 'tr':
            case 'bl':
              return SystemMouseCursors.resizeUpRightDownLeft;
            case 't':
            case 'b':
              return SystemMouseCursors.resizeUpDown;
            case 'l':
            case 'r':
              return SystemMouseCursors.resizeLeftRight;
          }
        }
        return SystemMouseCursors.move;
      case EditorTool.arrow:
      case EditorTool.highlightRect:
      case EditorTool.redactBlackout:
      case EditorTool.redactBlur:
      case EditorTool.redactPixelate:
        return SystemMouseCursors.precise;
      case EditorTool.text:
        return SystemMouseCursors.text;
      case EditorTool.numberLabel:
        return SystemMouseCursors.precise;
      case EditorTool.guide:
        return SystemMouseCursors.precise;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadScreenshotImage();
    _isVerticalGuideMode = widget.isVerticalGuideMode;
    _loadExistingCropBounds(); // Load initial crop bounds from metadata
  }

  @override
  void didUpdateWidget(EditorCanvas oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update guide mode
    if (oldWidget.isVerticalGuideMode != widget.isVerticalGuideMode) {
      setState(() {
        _isVerticalGuideMode = widget.isVerticalGuideMode;
      });
    }
    // Handle crop bounds updates from parent
    if (oldWidget.initialCropBounds != widget.initialCropBounds) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingCropBounds());
    }

    // Handle crop tool activation/deactivation
    if (widget.selectedTool == EditorTool.crop && oldWidget.selectedTool != EditorTool.crop) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _activateCropMode());
    } else if (widget.selectedTool != EditorTool.crop && oldWidget.selectedTool == EditorTool.crop) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _deactivateCropMode());
    }
  }

  void _activateCropMode() {
    setState(() {
      _isCropMode = true;
      // Store previous crop bounds for cancellation
      _previousCropBounds = _activeCropBounds;

      // Always set initial preview crop bounds when crop tool is activated
      if (_activeCropBounds != null) {
        // Start with existing crop as preview
        _previewCropBounds = _activeCropBounds;
      } else if (_backgroundImage != null) {
        // Set to full image size as initial crop bounds
        final imageSize = Size(
          _backgroundImage!.width.toDouble(),
          _backgroundImage!.height.toDouble(),
        );
        _previewCropBounds = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
      } else {
        // Fallback to a default size if no background image
        _previewCropBounds = const Rect.fromLTWH(50, 50, 200, 150);
      }
    });

    // Notify parent that crop state has changed
    widget.onCropStateChanged?.call();
  }

  void _deactivateCropMode() {
    setState(() {
      _isCropMode = false;
      _previewCropBounds = null;
      _isCropResizing = false;
      _cropResizeHandle = null;
    });
  }

  void _loadExistingCropBounds() {
    // Load crop bounds from parent component if available
    if (widget.initialCropBounds != null) {
      setState(() {
        _activeCropBounds = widget.initialCropBounds;
      });
    }
  }

  Future<void> _loadScreenshotImage() async {
    try {
      // Get the screenshot data first
      final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);

      print('DEBUG: Loading screenshot ${widget.screenshotId}');
      print('DEBUG: screenshot != null: ${screenshot != null}');
      if (screenshot != null) {
        print('DEBUG: isPlaceholder: ${screenshot.isPlaceholder}');
        print('DEBUG: originalPath: "${screenshot.originalPath}"');
        print('DEBUG: name: "${screenshot.name}"');
      }

      if (screenshot != null && screenshot.isPlaceholder) {
        print('DEBUG: Loading empty screenshot display');
        // Load empty screenshot display with capture instructions - priority over file loading
        await _loadEmptyScreenshotDisplay(screenshot);
      } else if (screenshot != null && screenshot.originalPath.isNotEmpty) {
        // Check if this is an asset path or a file path
        if (screenshot.originalPath.startsWith('assets/')) {
          await _loadImageFromAsset(screenshot.originalPath);
        } else {
          await _loadImageFromFile(screenshot.originalPath);
        }
      } else {
        await _loadPlaceholderImage();
      }
    } catch (e) {
      print('Error loading screenshot: $e');
      await _loadPlaceholderImage();
    }
  }

  Future<void> _loadImageFromAsset(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      setState(() {
        _backgroundImage = frameInfo.image;
        _isLoading = false;
      });

      // Initialize pixel data for sampling
      _initializePixelData();
    } catch (e) {
      print('Error loading image from asset: $e');
      await _loadPlaceholderImage();
    }
  }

  Future<void> _loadImageFromFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!file.existsSync()) {
        print('File does not exist: $filePath');
        await _loadPlaceholderImage();
        return;
      }

      final Uint8List bytes = await file.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();

      setState(() {
        _backgroundImage = frameInfo.image;
        _isLoading = false;
      });

      // Initialize pixel data for sampling
      _initializePixelData();
    } catch (e) {
      print('Error loading image from file: $e');
      print('The asset does not exist or has empty data.');
      await _loadPlaceholderImage();
    }
  }

  Future<void> _loadEmptyScreenshotDisplay(Screenshot screenshot) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 1200, 800));

    // Draw background with subtle pattern
    final bgPaint = Paint()..color = Theme.of(context).colorScheme.surface;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1200, 800), bgPaint);

    // Draw dashed border to indicate drop zone
    _drawDashedRect(canvas, const Rect.fromLTWH(40, 40, 1120, 720),
        Theme.of(context).colorScheme.primary.withValues(alpha: 0.4), 4, 12, 8);

    // Draw upload icon
    final iconPaint = Paint()
      ..color = Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // Upload icon (cloud with arrow)
    final centerX = 600.0;
    final centerY = 300.0;

    // Cloud shape
    final cloudPath = Path()
      ..addOval(Rect.fromCenter(center: Offset(centerX - 30, centerY - 10), width: 40, height: 30))
      ..addOval(Rect.fromCenter(center: Offset(centerX, centerY - 20), width: 60, height: 40))
      ..addOval(Rect.fromCenter(center: Offset(centerX + 30, centerY - 10), width: 40, height: 30))
      ..addRect(Rect.fromLTRB(centerX - 50, centerY - 5, centerX + 50, centerY + 15));

    canvas.drawPath(cloudPath, iconPaint);

    // Upload arrow
    final arrowPaint = Paint()
      ..color = Theme.of(context).colorScheme.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawLine(Offset(centerX, centerY + 20), Offset(centerX, centerY + 60), arrowPaint);
    canvas.drawLine(Offset(centerX - 15, centerY + 45), Offset(centerX, centerY + 30), arrowPaint);
    canvas.drawLine(Offset(centerX + 15, centerY + 45), Offset(centerX, centerY + 30), arrowPaint);

    // Title text
    final titlePainter = TextPainter(
      text: TextSpan(
        text: screenshot.name.isNotEmpty ? screenshot.name : 'Empty Screenshot',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 32,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    titlePainter.layout(maxWidth: 1000);
    titlePainter.paint(canvas, Offset((1200 - titlePainter.width) / 2, 380));

    // Instructions text
    final instructions = screenshot.instructions.isNotEmpty
        ? screenshot.instructions
        : 'Drag and drop an image here to add it to this screenshot.\n\nDouble-click to browse for files.\n\nCtrl+V to paste from clipboard.';

    final instructionsPainter = TextPainter(
      text: TextSpan(
        text: instructions,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 18,
          height: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    instructionsPainter.layout(maxWidth: 800);
    instructionsPainter.paint(canvas, Offset((1200 - instructionsPainter.width) / 2, 440));

    // Caption if available
    if (screenshot.caption.isNotEmpty) {
      final captionPainter = TextPainter(
        text: TextSpan(
          text: 'Caption: ${screenshot.caption}',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 16,
            fontStyle: FontStyle.italic,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      captionPainter.layout(maxWidth: 800);
      captionPainter.paint(canvas, Offset((1200 - captionPainter.width) / 2, 600));
    }

    // Footer text
    final footerPainter = TextPainter(
      text: TextSpan(
        text: 'Supported formats: PNG, JPG, JPEG • Created: ${screenshot.createdDate.day}/${screenshot.createdDate.month}/${screenshot.createdDate.year}',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          fontSize: 14,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    footerPainter.layout(maxWidth: 800);
    footerPainter.paint(canvas, Offset((1200 - footerPainter.width) / 2, 720));

    final picture = recorder.endRecording();
    final image = await picture.toImage(1200, 800);

    setState(() {
      _backgroundImage = image;
      _isLoading = false;
    });
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Color color, double strokeWidth, double dashLength, double gapLength) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Top edge
    double startX = rect.left;
    while (startX < rect.right) {
      final endX = (startX + dashLength).clamp(rect.left, rect.right);
      path.moveTo(startX, rect.top);
      path.lineTo(endX, rect.top);
      startX = endX + gapLength;
    }

    // Right edge
    double startY = rect.top;
    while (startY < rect.bottom) {
      final endY = (startY + dashLength).clamp(rect.top, rect.bottom);
      path.moveTo(rect.right, startY);
      path.lineTo(rect.right, endY);
      startY = endY + gapLength;
    }

    // Bottom edge
    startX = rect.right;
    while (startX > rect.left) {
      final endX = (startX - dashLength).clamp(rect.left, rect.right);
      path.moveTo(startX, rect.bottom);
      path.lineTo(endX, rect.bottom);
      startX = endX - gapLength;
    }

    // Left edge
    startY = rect.bottom;
    while (startY > rect.top) {
      final endY = (startY - dashLength).clamp(rect.top, rect.bottom);
      path.moveTo(rect.left, startY);
      path.lineTo(rect.left, endY);
      startY = endY - gapLength;
    }

    canvas.drawPath(path, paint);
  }

  Future<void> _handleFileUpload() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'],
        withData: false, // We'll read the file ourselves for better control
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          final image = await ImageReplacementService.loadImageFromPath(file.path!);
          if (image != null) {
            await _replaceBackgroundImage(image, file.path!);
          }
        }
      }
    } catch (e) {
      print('Error picking file: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleClipboardPaste() async {
    try {
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text != null) {
        // Try to handle clipboard text as a file path (basic implementation)
        final text = data!.text!.trim();
        if (text.toLowerCase().endsWith('.png') ||
            text.toLowerCase().endsWith('.jpg') ||
            text.toLowerCase().endsWith('.jpeg')) {
          final file = File(text);
          if (await file.exists()) {
            final image = await ImageReplacementService.loadImageFromPath(text);
            if (image != null) {
              await _replaceBackgroundImage(image, text);
              return;
            }
          }
        }
      }

      // Note: Direct image clipboard support would require platform-specific implementation
      // For now, we show a helpful message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Clipboard paste: Copy a file path or drag and drop an image file instead'),
          ),
        );
      }
    } catch (e) {
      print('Error handling clipboard: $e');
    }
  }

  Future<void> _replaceBackgroundImage(ui.Image newImage, String imagePath) async {
    try {
      setState(() {
        _backgroundImage = newImage;
        _isLoading = false;
      });

      // Update the screenshot in the database
      final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);
      if (screenshot != null) {
        final updatedScreenshot = screenshot.copyWith(
          originalPath: imagePath,
          width: newImage.width,
          height: newImage.height,
          fileFormat: imagePath.split('.').last.toLowerCase(),
          isPlaceholder: false, // No longer a placeholder
          modifiedDate: DateTime.now(),
        );

        // Update in database
        final database = ref.read(databaseProvider);
        await database.updateScreenshot(updatedScreenshot, widget.projectId);

        // Invalidate provider to refresh
        ref.invalidate(screenshotProvider(widget.screenshotId));
      }

      // Initialize pixel data for tools like pixelate
      _initializePixelData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image loaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error replacing background image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to replace image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadPlaceholderImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, 800, 600));
    
    // Draw a placeholder background
    final paint = Paint()..color = Theme.of(context).colorScheme.surfaceContainerHighest;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 800, 600), paint);
    
    // Draw a border
    paint
      ..color = Theme.of(context).colorScheme.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(const Rect.fromLTWH(1, 1, 798, 598), paint);
    
    // Draw placeholder text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Screenshot Not Found\n\nUsing Placeholder',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontSize: 24,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (800 - textPainter.width) / 2,
        (600 - textPainter.height) / 2,
      ),
    );
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(800, 600);
    
    setState(() {
      _backgroundImage = image;
      _isLoading = false;
    });

    // Initialize pixel data for sampling
    _initializePixelData();
  }

  void undo() {
    // Placeholder for undo functionality
  }

  void redo() {
    // Placeholder for redo functionality  
  }

  void deleteLayer(String layerId) {
    // Placeholder for delete layer functionality
  }

  void zoomOut() {
    setState(() {
      _zoom = (_zoom * 0.8).clamp(0.1, 10.0);
    });
  }

  void zoomIn() {
    setState(() {
      _zoom = (_zoom * 1.25).clamp(0.1, 10.0);
    });
  }

  void setZoom(double zoom) {
    setState(() {
      _zoom = zoom.clamp(0.1, 10.0);
    });
  }

  void fitToCanvas() {
    setState(() {
      _zoom = 1.0;
      _pan = Offset.zero;
    });
  }

  void actualSize() {
    setState(() {
      _zoom = 1.0;
    });
  }

  void applyCrop() {
    if (_previewCropBounds != null) {
      // Confirm the crop - store in metadata and update active crop
      setState(() {
        _activeCropBounds = _previewCropBounds;
        _previewCropBounds = null;
      });

      // Notify parent about crop change for metadata persistence
      _onCropChanged(_activeCropBounds);
    }
  }

  void cancelCrop() {
    setState(() {
      // Revert to previous crop state
      _activeCropBounds = _previousCropBounds;
      _previewCropBounds = null;
      _isCropResizing = false;
      _cropResizeHandle = null;
    });

    // Notify parent about reverting crop change
    _onCropChanged(_activeCropBounds);
  }

  bool get hasPendingCrop => _previewCropBounds != null;

  void enterCropMode() {
    // When entering crop mode, store current crop state and show uncropped image
    setState(() {
      _previousCropBounds = _activeCropBounds;
      // Don't clear _activeCropBounds yet - we need it for the initial crop bounds
      // The key is that when _previewCropBounds is null but we're in crop mode,
      // we show the uncropped image while still showing the crop bounds as guidelines
      if (_activeCropBounds != null) {
        _previewCropBounds = _activeCropBounds;
      }
    });
  }

  void exitCropMode() {
    // When exiting crop mode without applying, restore previous state
    setState(() {
      _previewCropBounds = null;
      _isCropResizing = false;
      _cropResizeHandle = null;
    });
  }

  void _onCropChanged(Rect? cropBounds) {
    // Notify parent component about crop changes
    widget.onCropChanged?.call(cropBounds);
  }

  void _onImageReplaced(ui.Image newImage) {
    // Notify parent component about image replacement
    widget.onImageReplaced?.call(newImage);
  }

  void _handleCropDrawingStart(Offset canvasPoint) {
    // Check if we're clicking on an existing crop handle first
    if (_previewCropBounds != null || _activeCropBounds != null) {
      final cropBounds = _previewCropBounds ?? _activeCropBounds!;
      final handle = _getHandleAtPoint(canvasPoint, cropBounds);
      if (handle != null) {
        // Start resizing existing crop
        setState(() {
          _isCropResizing = true;
          _cropResizeHandle = handle;
          _dragStart = canvasPoint;
          _initialLayerBounds = cropBounds;
          if (_activeCropBounds != null && _previewCropBounds == null) {
            // Copy active crop to preview for editing
            _previewCropBounds = _activeCropBounds;
          }
        });
        return;
      }

      // Check if clicking inside existing crop (for moving)
      if (cropBounds.contains(canvasPoint)) {
        setState(() {
          _isDragging = true;
          _dragStart = canvasPoint;
          _initialLayerBounds = cropBounds;
          if (_activeCropBounds != null && _previewCropBounds == null) {
            // Copy active crop to preview for editing
            _previewCropBounds = _activeCropBounds;
          }
        });
        return;
      }
    }

    // Start drawing new crop rectangle
    setState(() {
      _isDrawing = true;
      _drawingStart = canvasPoint;
      _drawingEnd = canvasPoint;
    });
  }

  void _handleCropDrawingUpdate(Offset canvasPoint) {
    Offset snappedPoint = canvasPoint;

    // Apply snapping if enabled
    if (widget.enableSnapping) {
      snappedPoint = _snapToGuides(canvasPoint);
    }

    if (_isCropResizing && _cropResizeHandle != null && _initialLayerBounds != null) {
      _handleCropResize(snappedPoint);
    } else if (_isDragging && _initialLayerBounds != null) {
      _handleCropMove(snappedPoint);
    } else if (_isDrawing && _drawingStart != null) {
      // Update crop rectangle drawing with snapping
      setState(() {
        _drawingEnd = snappedPoint;
      });
    }
  }

  void _handleCropDrawingEnd() {
    if (_isDrawing && _drawingStart != null && _drawingEnd != null) {
      // Create new crop preview from drawn rectangle
      final cropRect = Rect.fromPoints(_drawingStart!, _drawingEnd!);
      // Ensure minimum size
      if (cropRect.width > 20 && cropRect.height > 20) {
        setState(() {
          _previewCropBounds = cropRect;
        });
        widget.onCropStateChanged?.call();
      }
    }

    // Reset drawing state
    setState(() {
      _isDrawing = false;
      _isDragging = false;
      _isCropResizing = false;
      _cropResizeHandle = null;
      _drawingStart = null;
      _drawingEnd = null;
      _dragStart = null;
      _initialLayerBounds = null;
    });
  }

  void _handleCropResize(Offset currentPoint) {
    Offset snappedPoint = currentPoint;

    // Apply snapping if enabled
    if (widget.enableSnapping) {
      snappedPoint = _snapToGuides(currentPoint);
    }

    final delta = snappedPoint - _dragStart!;
    Rect newCropRect = _initialLayerBounds!;

    switch (_cropResizeHandle) {
      case 'tl':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left + delta.dx,
          _initialLayerBounds!.top + delta.dy,
          _initialLayerBounds!.right,
          _initialLayerBounds!.bottom,
        );
        break;
      case 'tr':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left,
          _initialLayerBounds!.top + delta.dy,
          _initialLayerBounds!.right + delta.dx,
          _initialLayerBounds!.bottom,
        );
        break;
      case 'bl':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left + delta.dx,
          _initialLayerBounds!.top,
          _initialLayerBounds!.right,
          _initialLayerBounds!.bottom + delta.dy,
        );
        break;
      case 'br':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left,
          _initialLayerBounds!.top,
          _initialLayerBounds!.right + delta.dx,
          _initialLayerBounds!.bottom + delta.dy,
        );
        break;
      case 't':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left,
          _initialLayerBounds!.top + delta.dy,
          _initialLayerBounds!.right,
          _initialLayerBounds!.bottom,
        );
        break;
      case 'b':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left,
          _initialLayerBounds!.top,
          _initialLayerBounds!.right,
          _initialLayerBounds!.bottom + delta.dy,
        );
        break;
      case 'l':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left + delta.dx,
          _initialLayerBounds!.top,
          _initialLayerBounds!.right,
          _initialLayerBounds!.bottom,
        );
        break;
      case 'r':
        newCropRect = Rect.fromLTRB(
          _initialLayerBounds!.left,
          _initialLayerBounds!.top,
          _initialLayerBounds!.right + delta.dx,
          _initialLayerBounds!.bottom,
        );
        break;
    }

    // Ensure minimum size and canvas bounds
    final renderBox = context.findRenderObject() as RenderBox?;
    final canvasSize = renderBox?.size ?? Size.zero;

    // Clamp bounds safely
    final clampedLeft = newCropRect.left.clamp(0.0, math.max(0.0, canvasSize.width - 20).toDouble());
    final clampedTop = newCropRect.top.clamp(0.0, math.max(0.0, canvasSize.height - 20).toDouble());
    final clampedRight = newCropRect.right.clamp(20.0, canvasSize.width);
    final clampedBottom = newCropRect.bottom.clamp(20.0, canvasSize.height);

    newCropRect = Rect.fromLTRB(
      clampedLeft,
      clampedTop,
      clampedRight,
      clampedBottom,
    );

    if (newCropRect.width > 20 && newCropRect.height > 20) {
      setState(() {
        _previewCropBounds = newCropRect;
      });
      widget.onCropStateChanged?.call();
    }
  }

  void _handleCropMove(Offset currentPoint) {
    final delta = currentPoint - _dragStart!;
    final newCropRect = _initialLayerBounds!.shift(delta);

    // Keep crop area within canvas bounds
    final renderBox = context.findRenderObject() as RenderBox?;
    final canvasSize = renderBox?.size ?? Size.zero;

    // Calculate max positions ensuring they're not negative
    final maxLeft = math.max(0.0, canvasSize.width - newCropRect.width);
    final maxTop = math.max(0.0, canvasSize.height - newCropRect.height);

    final clampedRect = Rect.fromLTWH(
      newCropRect.left.clamp(0.0, maxLeft),
      newCropRect.top.clamp(0.0, maxTop),
      newCropRect.width,
      newCropRect.height,
    );

    setState(() {
      _previewCropBounds = clampedRect;
    });
    widget.onCropStateChanged?.call();
  }

  EditorLayer? _findLayerAtPoint(Offset point) {
    // Search layers in reverse order (top to bottom)
    for (final layer in widget.layers.reversed) {
      if (layer.bounds.contains(point) == true) {
        return layer;
      }
    }
    return null;
  }

  String? _getHandleAtPoint(Offset point, Rect bounds) {
    const handleSize = 16.0; // Increased from 8.0 for easier clicking

    // Corner handles
    if ((point - bounds.topLeft).distance < handleSize) return 'tl';
    if ((point - bounds.topRight).distance < handleSize) return 'tr';
    if ((point - bounds.bottomLeft).distance < handleSize) return 'bl';
    if ((point - bounds.bottomRight).distance < handleSize) return 'br';

    // Edge handles
    if ((point - Offset(bounds.center.dx, bounds.top)).distance < handleSize) return 't';
    if ((point - Offset(bounds.center.dx, bounds.bottom)).distance < handleSize) return 'b';
    if ((point - Offset(bounds.left, bounds.center.dy)).distance < handleSize) return 'l';
    if ((point - Offset(bounds.right, bounds.center.dy)).distance < handleSize) return 'r';

    return null;
  }

  Offset _snapToGuides(Offset point) {
    const snapDistance = 10.0;
    double x = point.dx;
    double y = point.dy;

    if (_backgroundImage == null) return point;

    // Calculate the same scaling and offset used for the background image
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return point;

    final size = renderBox.size;
    final imageSize = Size(_backgroundImage!.width.toDouble(), _backgroundImage!.height.toDouble());
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    final scale = math.min(scaleX, scaleY);

    // Center the scaled image
    final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
    final offset = Offset(
      (size.width - scaledSize.width) / 2,
      (size.height - scaledSize.height) / 2,
    );

    // Snap to vertical guides - convert from image coordinates to canvas coordinates
    for (final guide in _verticalGuides) {
      if (guide >= 0 && guide <= imageSize.width) {
        final canvasGuideX = offset.dx + (guide * scale);
        if ((x - canvasGuideX).abs() < snapDistance) {
          x = canvasGuideX;
          break;
        }
      }
    }

    // Snap to horizontal guides - convert from image coordinates to canvas coordinates
    for (final guide in _horizontalGuides) {
      if (guide >= 0 && guide <= imageSize.height) {
        final canvasGuideY = offset.dy + (guide * scale);
        if ((y - canvasGuideY).abs() < snapDistance) {
          y = canvasGuideY;
          break;
        }
      }
    }

    // Snap to image edges
    final imageLeft = offset.dx;
    final imageRight = offset.dx + scaledSize.width;
    final imageTop = offset.dy;
    final imageBottom = offset.dy + scaledSize.height;

    if ((x - imageLeft).abs() < snapDistance) x = imageLeft;
    if ((x - imageRight).abs() < snapDistance) x = imageRight;
    if ((y - imageTop).abs() < snapDistance) y = imageTop;
    if ((y - imageBottom).abs() < snapDistance) y = imageBottom;

    // Snap to center
    final centerX = offset.dx + scaledSize.width / 2;
    final centerY = offset.dy + scaledSize.height / 2;
    if ((x - centerX).abs() < snapDistance) x = centerX;
    if ((y - centerY).abs() < snapDistance) y = centerY;

    return Offset(x, y);
  }

  String? _getGuideAtPoint(Offset point) {
    const guideSnapDistance = 8.0;

    if (_backgroundImage == null) return null;

    // Calculate the same scaling and offset used for the background image
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;

    final size = renderBox.size;
    final imageSize = Size(_backgroundImage!.width.toDouble(), _backgroundImage!.height.toDouble());
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    final scale = math.min(scaleX, scaleY);

    // Center the scaled image
    final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
    final offset = Offset(
      (size.width - scaledSize.width) / 2,
      (size.height - scaledSize.height) / 2,
    );

    // Check vertical guides - convert from image coordinates to canvas coordinates
    for (int i = 0; i < _verticalGuides.length; i++) {
      final guide = _verticalGuides[i];
      if (guide >= 0 && guide <= imageSize.width) {
        final canvasGuideX = offset.dx + (guide * scale);
        if ((point.dx - canvasGuideX).abs() < guideSnapDistance) {
          return 'v$i';
        }
      }
    }

    // Check horizontal guides - convert from image coordinates to canvas coordinates
    for (int i = 0; i < _horizontalGuides.length; i++) {
      final guide = _horizontalGuides[i];
      if (guide >= 0 && guide <= imageSize.height) {
        final canvasGuideY = offset.dy + (guide * scale);
        if ((point.dy - canvasGuideY).abs() < guideSnapDistance) {
          return 'h$i';
        }
      }
    }

    return null;
  }

  Offset _snapPoint(Offset point) {
    if (!widget.enableSnapping) return point;
    
    const snapDistance = 8.0;
    double snappedX = point.dx;
    double snappedY = point.dy;
    bool snappedToGuide = false;
    
    // Snap to guides (highest priority)
    for (final guideX in _verticalGuides) {
      if ((point.dx - guideX).abs() < snapDistance) {
        snappedX = guideX;
        snappedToGuide = true;
        break;
      }
    }
    
    for (final guideY in _horizontalGuides) {
      if ((point.dy - guideY).abs() < snapDistance) {
        snappedY = guideY;
        snappedToGuide = true;
        break;
      }
    }
    
    // Snap to other layer bounds (medium priority)
    if (!snappedToGuide) {
      for (final layer in widget.layers) {
        if (layer.visible) {
          final bounds = layer.bounds;
          
          // Snap to edges
          if ((point.dx - bounds.left).abs() < snapDistance && snappedX == point.dx) {
            snappedX = bounds.left;
          }
          if ((point.dx - bounds.right).abs() < snapDistance && snappedX == point.dx) {
            snappedX = bounds.right;
          }
          if ((point.dx - bounds.center.dx).abs() < snapDistance && snappedX == point.dx) {
            snappedX = bounds.center.dx;
          }
          
          if ((point.dy - bounds.top).abs() < snapDistance && snappedY == point.dy) {
            snappedY = bounds.top;
          }
          if ((point.dy - bounds.bottom).abs() < snapDistance && snappedY == point.dy) {
            snappedY = bounds.bottom;
          }
          if ((point.dy - bounds.center.dy).abs() < snapDistance && snappedY == point.dy) {
            snappedY = bounds.center.dy;
          }
        }
      }
    }
    
    // Snap to grid (lowest priority)
    const gridSize = 8.0;
    final gridX = (point.dx / gridSize).round() * gridSize;
    final gridY = (point.dy / gridSize).round() * gridSize;
    
    if ((point.dx - gridX).abs() < snapDistance && snappedX == point.dx) {
      snappedX = gridX;
    }
    if ((point.dy - gridY).abs() < snapDistance && snappedY == point.dy) {
      snappedY = gridY;
    }
    
    return Offset(snappedX, snappedY);
  }

  void _addVerticalGuide(double x) {
    setState(() {
      _verticalGuides.add(x);
    });
    widget.onGuidesChanged?.call();
  }

  void _addHorizontalGuide(double y) {
    setState(() {
      _horizontalGuides.add(y);
    });
    widget.onGuidesChanged?.call();
  }

  void _removeGuide(String guideId) {
    setState(() {
      if (guideId.startsWith('v')) {
        final index = int.parse(guideId.substring(1));
        if (index < _verticalGuides.length) {
          _verticalGuides.removeAt(index);
        }
      } else if (guideId.startsWith('h')) {
        final index = int.parse(guideId.substring(1));
        if (index < _horizontalGuides.length) {
          _horizontalGuides.removeAt(index);
        }
      }
    });
    widget.onGuidesChanged?.call();
  }

  void _updateGuide(String guideId, Offset newPosition) {
    setState(() {
      if (guideId.startsWith('v')) {
        final index = int.parse(guideId.substring(1));
        if (index < _verticalGuides.length) {
          _verticalGuides[index] = newPosition.dx;
        }
      } else if (guideId.startsWith('h')) {
        final index = int.parse(guideId.substring(1));
        if (index < _horizontalGuides.length) {
          _horizontalGuides[index] = newPosition.dy;
        }
      }
    });
    widget.onGuidesChanged?.call();
  }

  void _updateLayerBounds(String layerId, Rect newBounds) {
    final layerIndex = widget.layers.indexWhere((l) => l.id == layerId);
    if (layerIndex != -1) {
      final layer = widget.layers[layerIndex];
      final updatedLayer = _copyLayerWithBounds(layer, newBounds);
      widget.onLayerUpdated?.call(layerId, updatedLayer);
    }
  }

  EditorLayer _copyLayerWithBounds(EditorLayer layer, Rect bounds) {
    switch (layer.layerType) {
      case LayerType.vector:
        final vectorLayer = layer as VectorLayer;
        
        // For rectangles, simply update to use the new bounds
        final updatedElements = vectorLayer.elements.map((element) {
          switch (element.type) {
            case VectorElementType.rectangle:
              // Rectangle should use the full bounds
              return RectangleElement(points: [bounds.topLeft, bounds.bottomRight]);
            case VectorElementType.arrow:
              // Scale arrow points proportionally
              final scaleX = bounds.width / layer.bounds.width;
              final scaleY = bounds.height / layer.bounds.height;
              final updatedPoints = element.points.map((point) {
                final relativePoint = point - layer.bounds.topLeft;
                return Offset(
                  bounds.left + relativePoint.dx * scaleX,
                  bounds.top + relativePoint.dy * scaleY,
                );
              }).toList();
              return ArrowElement(points: updatedPoints);
            default:
              return element;
          }
        }).toList();
        
        return vectorLayer.copyWith(bounds: bounds, elements: updatedElements);
        
      case LayerType.text:
        return (layer as TextLayer).copyWith(bounds: bounds);
        
      case LayerType.redaction:
        return (layer as RedactionLayer).copyWith(bounds: bounds);
        
      default:
        return layer.copyWith(bounds: bounds);
    }
  }

  void _showTextEditDialog(TextLayer textLayer) {
    // Start with empty text if it's the default "Text"
    final initialText = textLayer.text == 'Text' ? '' : textLayer.text;
    final controller = TextEditingController(text: initialText);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Text'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter text',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                final updatedLayer = textLayer.copyWith(
                  text: text,
                );
                widget.onLayerUpdated?.call(textLayer.id, updatedLayer);
              }
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleDrawingStart(Offset point) {
    final canvasPoint = _screenToCanvasCoords(point);

    if (widget.selectedTool == EditorTool.crop) {
      // Crop tool uses special handling
      _handleCropDrawingStart(canvasPoint);
      return;
    }

    final startPoint = _snapPoint(canvasPoint);

    setState(() {
      _isDrawing = true;
      _drawingStart = startPoint;
      _drawingEnd = _drawingStart;
    });
  }

  void _handleDrawingUpdate(Offset point) {
    final canvasPoint = _screenToCanvasCoords(point);

    if (widget.selectedTool == EditorTool.crop) {
      // Crop tool uses special handling
      _handleCropDrawingUpdate(canvasPoint);
      return;
    }

    final endPoint = _snapPoint(canvasPoint);
    setState(() {
      _drawingEnd = endPoint;
    });
  }

  void _handleDrawingEnd() {
    if (widget.selectedTool == EditorTool.crop) {
      // Crop tool uses special handling
      _handleCropDrawingEnd();
      return;
    }

    if (_drawingStart != null && _drawingEnd != null) {
      final layer = _createLayerFromGesture();
      if (layer != null) {
        widget.onLayerAdded?.call(layer);
        setState(() {
          _tempLayers.clear();
        });
      }
    }

    setState(() {
      _isDrawing = false;
      _drawingStart = null;
      _drawingEnd = null;
    });
  }

  Offset _screenToCanvasCoords(Offset screenPoint) {
    // Simply use the screen point directly since the Transform widget handles pan/zoom
    // and we're working in the same coordinate space as the CustomPaint
    return screenPoint;
  }

  TextLayer? _createNumberLabel(Offset position) {
    final numberValue = widget.getNextNumberLabelValue?.call() ?? 1;
    final now = DateTime.now();
    // Add random component to ensure uniqueness
    final randomSuffix = (math.Random().nextDouble() * 10000).toInt();
    final layerId = 'number-label-${now.millisecondsSinceEpoch}-$randomSuffix';
    final fontSize = widget.toolConfig.toolSpecificSettings['fontSize']?.toDouble() ?? 16.0;
    final circleRadius = widget.toolConfig.toolSpecificSettings['circleRadius']?.toDouble() ?? 16.0;
    
    // Create a circular text layer for the number - centered exactly on the click position
    final textBounds = Rect.fromCenter(
      center: position,
      width: circleRadius * 2,
      height: circleRadius * 2,
    );
    
    return TextLayer(
      id: layerId,
      name: 'Number Label $numberValue',
      visible: true,
      locked: false,
      opacity: widget.toolConfig.opacity,
      blendModeType: BlendModeType.normal,
      bounds: textBounds,
      text: numberValue.toString(),
      textStyle: TextStyle(
        color: widget.toolConfig.primaryColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: widget.toolConfig.toolSpecificSettings['fontFamily'] as String? ?? 'Arial',
      ),
      textAlign: TextAlign.center,
      createdDate: now,
      modifiedDate: now,
      metadata: {
        'isNumberLabel': true,
        'numberValue': numberValue,
        'circleRadius': circleRadius,
        'backgroundColor': widget.toolConfig.secondaryColor.value,
      },
    );
  }

  EditorLayer? _createLayerFromGesture() {
    if (_drawingStart == null || _drawingEnd == null) return null;

    final now = DateTime.now();
    // Add random component to ensure uniqueness even with rapid creation
    final randomSuffix = (math.Random().nextDouble() * 10000).toInt();
    final layerId = 'layer-${now.millisecondsSinceEpoch}-$randomSuffix';
    
    switch (widget.selectedTool) {
      case EditorTool.highlightRect:
        final settings = widget.toolConfig.toolSpecificSettings;
        final hasFill = settings['hasFill'] ?? true;
        final hasStroke = settings['hasStroke'] ?? true;
        
        return VectorLayer(
          id: layerId,
          name: 'Highlight Rectangle',
          visible: true,
          locked: false,
          opacity: widget.toolConfig.opacity,
          blendModeType: BlendModeType.multiply,
          bounds: Rect.fromPoints(_drawingStart!, _drawingEnd!),
          strokeColor: widget.toolConfig.primaryColor,
          fillColor: hasFill 
              ? (widget.toolConfig.secondaryColor.opacity > 0 
                  ? widget.toolConfig.secondaryColor 
                  : widget.toolConfig.primaryColor.withValues(alpha: 0.3))
              : Colors.transparent,
          strokeWidth: hasStroke ? widget.toolConfig.strokeWidth : 0,
          elements: [
            RectangleElement(
              points: [_drawingStart!, _drawingEnd!],
            ),
          ],
          metadata: {
            'hasFill': hasFill,
            'hasStroke': hasStroke,
          },
          createdDate: now,
          modifiedDate: now,
        );
      
      case EditorTool.arrow:
        return VectorLayer(
          id: layerId,
          name: 'Arrow',
          visible: true,
          locked: false,
          opacity: widget.toolConfig.opacity,
          blendModeType: BlendModeType.normal,
          bounds: Rect.fromPoints(_drawingStart!, _drawingEnd!),
          strokeColor: widget.toolConfig.primaryColor,
          fillColor: Colors.transparent,
          strokeWidth: widget.toolConfig.strokeWidth,
          elements: [
            ArrowElement(
              points: [_drawingStart!, _drawingEnd!],
            ),
          ],
          metadata: {
            'arrowHeadSize': widget.toolConfig.toolSpecificSettings['arrowHeadSize'] ?? 15.0,
            'arrowHeadAngle': widget.toolConfig.toolSpecificSettings['arrowHeadAngle'] ?? 0.5,
          },
          createdDate: now,
          modifiedDate: now,
        );
      
      case EditorTool.redactBlackout:
      case EditorTool.redactBlur:
      case EditorTool.redactPixelate:
        return RedactionLayer(
          id: layerId,
          name: widget.selectedTool == EditorTool.redactBlackout 
              ? 'Blackout' 
              : widget.selectedTool == EditorTool.redactBlur 
                  ? 'Blur' 
                  : 'Pixelate',
          visible: true,
          locked: false,
          opacity: widget.toolConfig.opacity,
          blendModeType: BlendModeType.normal,
          bounds: Rect.fromPoints(_drawingStart!, _drawingEnd!),
          redactionType: widget.selectedTool == EditorTool.redactBlackout 
              ? RedactionType.blackout 
              : widget.selectedTool == EditorTool.redactBlur 
                  ? RedactionType.blur 
                  : RedactionType.pixelate,
          redactionColor: widget.toolConfig.primaryColor,
          blurRadius: widget.toolConfig.toolSpecificSettings['blurRadius']?.toDouble() ?? 10.0,
          pixelSize: widget.toolConfig.toolSpecificSettings['pixelSize']?.toInt() ?? 20,
          createdDate: now,
          modifiedDate: now,
        );
        
      case EditorTool.text:
        final textLayer = TextLayer(
          id: layerId,
          name: 'Text',
          visible: true,
          locked: false,
          opacity: widget.toolConfig.opacity,
          blendModeType: BlendModeType.normal,
          bounds: Rect.fromPoints(_drawingStart!, _drawingEnd!),
          text: 'Text',
          textStyle: TextStyle(
            color: widget.toolConfig.primaryColor,
            fontSize: 16.0,
            fontWeight: FontWeight.normal,
            fontStyle: FontStyle.normal,
          ),
          textAlign: TextAlign.left,
          createdDate: now,
          modifiedDate: now,
        );
        
        // Show text editor immediately after creating the layer
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showTextEditDialog(textLayer);
        });
        
        return textLayer;
      
      default:
        return null;
    }
  }

  // Crop functionality removed
  void _applyCropToAllLayers(Rect cropRect) {
    // Crop functionality disabled - to be re-implemented
  }

  Future<void> _handleKeyPress(KeyEvent event) async {
    if (event is KeyDownEvent) {
      final isCtrlPressed = HardwareKeyboard.instance.isControlPressed;

      // Handle Ctrl+V for paste image
      if (isCtrlPressed && event.logicalKey == LogicalKeyboardKey.keyV) {
        await _pasteImageFromClipboard();
      }
    }
  }

  Future<void> _pasteImageFromClipboard() async {
    try {
      print('DEBUG: Attempting to paste image from clipboard');
      final result = await ImageReplacementService.getImageFromClipboardWithSave();
      if (result != null && result['image'] != null && result['filePath'] != null) {
        final image = result['image'] as ui.Image;
        final filePath = result['filePath'] as String;
        print('DEBUG: Successfully got image from clipboard, size: ${image.width}x${image.height}');
        print('DEBUG: Saved clipboard image to: $filePath');
        await _replaceBackgroundImage(image, filePath);
      } else {
        print('DEBUG: No image found in clipboard or failed to save');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Clipboard paste detected but no image found.',
                             style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Try this instead:'),
                  const Text('• Take a screenshot (Windows key + Shift + S)'),
                  const Text('• Right-click an image → "Copy Image"'),
                  const Text('• Then paste here, or drag & drop the file'),
                ],
              ),
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.orange.shade800,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error pasting image from clipboard: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error pasting from clipboard: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        _handleKeyPress(event);
        return KeyEventResult.ignored;
      },
      child: MouseRegion(
        cursor: _getCursorForTool(widget.selectedTool),
        onHover: (event) {
          final canvasPoint = _screenToCanvasCoords(event.localPosition);

          // Track handle hover for crop tool
          if (widget.selectedTool == EditorTool.crop) {
            final cropBounds = _previewCropBounds ?? _activeCropBounds;
            if (cropBounds != null) {
              final handle = _getHandleAtPoint(canvasPoint, cropBounds);
              if (_hoverHandle != handle) {
                setState(() {
                  _hoverHandle = handle;
                });
              }
            } else if (_hoverHandle != null) {
              setState(() {
                _hoverHandle = null;
              });
            }
          }
          // Track handle hover for select and move tools
          else if ((widget.selectedTool == EditorTool.select || widget.selectedTool == EditorTool.move) && _selectedLayerId != null) {
            final selectedLayer = widget.layers.firstWhere(
              (l) => l.id == _selectedLayerId,
              orElse: () => widget.layers.first,
            );

            final handle = _getHandleAtPoint(canvasPoint, selectedLayer.bounds);
            if (_hoverHandle != handle) {
              setState(() {
                _hoverHandle = handle;
              });
            }
                    } else if (_hoverHandle != null) {
            setState(() {
              _hoverHandle = null;
            });
          }
        },
        child: GestureDetector(
        onTap: () {
          // Handle single-click for number label placement
          if (widget.selectedTool == EditorTool.numberLabel) {
            // We need to get the tap position, but onTap doesn't provide details
            // We'll use the last known mouse position or handle this differently
            return;
          }
        },
        onTapDown: (details) {
          // Handle single-click for number label placement
          if (widget.selectedTool == EditorTool.numberLabel) {
          // Small adjustment to align with crosshair center (compensates for cursor hotspot)
          final adjustedPosition = details.localPosition ;
          final canvasPoint = _screenToCanvasCoords(adjustedPosition);
          final snappedPoint = _snapPoint(canvasPoint);
          try {
            final layer = _createNumberLabel(snappedPoint);
            if (layer != null) {
              widget.onLayerAdded?.call(layer);
            }
          } catch (e) {
            print('Error creating number label: $e');
          }
        }
        
        // Handle single-click for guide creation
        if (widget.selectedTool == EditorTool.guide) {
          final canvasPoint = _screenToCanvasCoords(details.localPosition);
          
          // Check if clicking on an existing guide first (don't create if near a guide)
          final existingGuide = _getGuideAtPoint(canvasPoint);
          if (existingGuide != null) {
            // Don't create a new guide if clicking on an existing one
            return;
          }
          
          // Create guide based on current mode with snapping
          final snappedPoint = _snapPoint(canvasPoint);
          if (_isVerticalGuideMode) {
            _addVerticalGuide(snappedPoint.dx);
          } else {
            _addHorizontalGuide(snappedPoint.dy);
          }
        }
        },
        onDoubleTap: () {
          // For guides, we need the last tap position
          // This is handled in onDoubleTapDown
        },
        onDoubleTapDown: (details) async {
          // Check if this is an empty screenshot and handle file upload
          final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);
          if (screenshot != null && screenshot.isPlaceholder && screenshot.originalPath.isEmpty) {
            await _handleFileUpload();
            return;
          }

          final canvasPoint = _screenToCanvasCoords(details.localPosition);

          // Check for guide deletion only with select or guide tools
          // This prevents accidental guide deletion when using drawing tools
          if (widget.selectedTool == EditorTool.select || widget.selectedTool == EditorTool.guide) {
            final guide = _getGuideAtPoint(canvasPoint);
            if (guide != null) {
              _removeGuide(guide);
              return;
            }
          }

          // Handle double-tap for text editing
          if (_selectedLayerId != null) {
            final selectedLayer = widget.layers.firstWhere(
              (l) => l.id == _selectedLayerId,
              orElse: () => widget.layers.first,
            );
            if (selectedLayer.layerType == LayerType.text) {
              _showTextEditDialog(selectedLayer as TextLayer);
            }
          }
        },
        onScaleStart: (details) {
          final canvasPoint = _screenToCanvasCoords(details.localFocalPoint);

          // Check for guide interaction only with select or guide tools
          // This prevents accidental guide movement when using drawing tools
        if (widget.selectedTool == EditorTool.select || widget.selectedTool == EditorTool.guide) {
          final guide = _getGuideAtPoint(canvasPoint);
          if (guide != null) {
            setState(() {
              _draggingGuide = guide;
              _isDraggingGuide = true;
            });
            return;
          }
        }
        
        if (widget.selectedTool == EditorTool.pan) {
          // Handle pan/zoom gesture
        } else if (widget.selectedTool == EditorTool.select) {
          // Handle object selection, resizing, and dragging
          if (_selectedLayerId != null) {
            final selectedLayer = widget.layers.firstWhere((l) => l.id == _selectedLayerId);
            final handle = _getHandleAtPoint(canvasPoint, selectedLayer.bounds);
            if (handle != null) {
              // Start resizing
              setState(() {
                _resizeHandle = handle;
                _isResizing = true;
                _dragStart = canvasPoint;
                _initialLayerBounds = selectedLayer.bounds;
              });
              return;
            }
                    }
          
          final layer = _findLayerAtPoint(canvasPoint);
          if (layer != null) {
            // Select the layer if not already selected
            if (_selectedLayerId != layer.id) {
              setState(() {
                _selectedLayerId = layer.id;
              });
              widget.onLayerSelected?.call(layer.id);
            }
            
            // Start dragging the selected layer
            setState(() {
              _isDragging = true;
              _dragStart = canvasPoint;
              _initialLayerBounds = layer.bounds;
            });
          } else {
            // Clicked on empty space - deselect
            setState(() {
              _selectedLayerId = null;
            });
            widget.onLayerSelected?.call(null);
          }
          return; // Don't continue to other gesture handling
        } else if (widget.selectedTool == EditorTool.crop) {
          // Handle crop tool gesture
          _handleDrawingStart(details.localFocalPoint);
        } else if (widget.selectedTool == EditorTool.move) {
          // Handle move tool - check for resize handles first
          if (_selectedLayerId != null) {
            final selectedLayer = widget.layers.firstWhere((l) => l.id == _selectedLayerId);
            final handle = _getHandleAtPoint(canvasPoint, selectedLayer.bounds);
            if (handle != null) {
              // Start resizing
              setState(() {
                _resizeHandle = handle;
                _isResizing = true;
                _dragStart = canvasPoint;
                _initialLayerBounds = selectedLayer.bounds;
              });
              return;
            }
          }
          
          // Otherwise, select layer at point for moving
          final layer = _findLayerAtPoint(canvasPoint);
          if (layer != null) {
            setState(() {
              _selectedLayerId = layer.id;
              _dragStart = canvasPoint;
              _initialLayerPosition = layer.bounds.topLeft ?? Offset.zero;
              _initialLayerBounds = layer.bounds;
              _isDragging = true;
            });
          } else {
            // Deselect if clicking on empty space
            setState(() {
              _selectedLayerId = null;
            });
          }
        } else {
          // Check if clicking on existing text layer when text tool is selected
          if (widget.selectedTool == EditorTool.text) {
            final layer = _findLayerAtPoint(canvasPoint);
            if (layer != null && layer.layerType == LayerType.text) {
              // Select the text layer and show edit dialog
              setState(() {
                _selectedLayerId = layer.id;
              });
              _showTextEditDialog(layer as TextLayer);
              return; // Don't start drawing
            }
          }
          
          // Handle drawing start for other tools or new elements (skip for number label)
          if (widget.selectedTool != EditorTool.numberLabel) {
            _handleDrawingStart(details.localFocalPoint);
          }
        }
      },
        onScaleUpdate: (details) {
        // Handle guide dragging first
        if (_isDraggingGuide && _draggingGuide != null) {
          final canvasPoint = _screenToCanvasCoords(details.localFocalPoint);
          final snappedPoint = _snapPoint(canvasPoint);
          _updateGuide(_draggingGuide!, snappedPoint);
          return;
        }
        
        if (widget.selectedTool == EditorTool.pan) {
          // Handle pan/zoom
          setState(() {
            _zoom = (_zoom * details.scale).clamp(0.1, 10.0);
            _pan += details.focalPointDelta;
          });
        } else if (widget.selectedTool == EditorTool.select) {
          // Handle resizing and dragging selected objects with select tool
          if (_isResizing && _resizeHandle != null && _initialLayerBounds != null) {
            // Handle resizing
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final delta = currentPoint - _dragStart!;
            Rect newBounds = _initialLayerBounds!;
            
            switch (_resizeHandle) {
              case 'tl':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left + delta.dx,
                  _initialLayerBounds!.top + delta.dy,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'tr':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top + delta.dy,
                  _initialLayerBounds!.right + delta.dx,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'bl':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left + delta.dx,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom + delta.dy,
                );
                break;
              case 'br':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right + delta.dx,
                  _initialLayerBounds!.bottom + delta.dy,
                );
                break;
              case 't':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top + delta.dy,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'b':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom + delta.dy,
                );
                break;
              case 'l':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left + delta.dx,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'r':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right + delta.dx,
                  _initialLayerBounds!.bottom,
                );
                break;
            }
            _updateLayerBounds(_selectedLayerId!, newBounds);
          } else if (_isDragging && _selectedLayerId != null && _dragStart != null && _initialLayerBounds != null) {
            // Handle dragging with snapping
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final snappedPoint = _snapPoint(currentPoint);
            final delta = snappedPoint - _dragStart!;
            final newBounds = _initialLayerBounds!.shift(delta);
            _updateLayerBounds(_selectedLayerId!, newBounds);
          }
        } else if (widget.selectedTool == EditorTool.move) {
          if (_isResizing && _resizeHandle != null && _initialLayerBounds != null) {
            // Handle resizing
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final delta = currentPoint - _dragStart!;
            Rect newBounds = _initialLayerBounds!;
            
            switch (_resizeHandle) {
              case 'tl':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left + delta.dx,
                  _initialLayerBounds!.top + delta.dy,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'tr':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top + delta.dy,
                  _initialLayerBounds!.right + delta.dx,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'bl':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left + delta.dx,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom + delta.dy,
                );
                break;
              case 'br':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right + delta.dx,
                  _initialLayerBounds!.bottom + delta.dy,
                );
                break;
              case 't':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top + delta.dy,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'b':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom + delta.dy,
                );
                break;
              case 'l':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left + delta.dx,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right,
                  _initialLayerBounds!.bottom,
                );
                break;
              case 'r':
                newBounds = Rect.fromLTRB(
                  _initialLayerBounds!.left,
                  _initialLayerBounds!.top,
                  _initialLayerBounds!.right + delta.dx,
                  _initialLayerBounds!.bottom,
                );
                break;
            }
            
            // Ensure minimum size
            if (newBounds.width > 10 && newBounds.height > 10) {
              _updateLayerBounds(_selectedLayerId!, newBounds);
            }
          } else if (_isDragging && _initialLayerBounds != null) {
            // Handle layer moving with snapping
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final snappedPoint = _snapPoint(currentPoint);
            final delta = snappedPoint - _dragStart!;
            final newBounds = _initialLayerBounds!.shift(delta);
            _updateLayerBounds(_selectedLayerId!, newBounds);
          }
        } else if (widget.selectedTool == EditorTool.crop) {
          // Handle crop tool updates
          _handleDrawingUpdate(details.localFocalPoint);
        } else if (_isDrawing) {
          // Handle drawing update
          _handleDrawingUpdate(details.localFocalPoint);
        }
        },
        onScaleEnd: (details) {
          if (_isDrawing) {
            _handleDrawingEnd();
          } else if (_isDragging || _isResizing || _isDraggingGuide) {
            setState(() {
              _isDragging = false;
              _isResizing = false;
              _isDraggingGuide = false;
              _resizeHandle = null;
              _draggingGuide = null;
              _dragStart = null;
              _initialLayerPosition = null;
              _initialLayerBounds = null;
            });
          }
        },
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainer,
          child: ClipRect(
            child: Center(
              child: Transform(
                transform: Matrix4.identity()
                  ..translate(_pan.dx, _pan.dy)
                  ..scale(_zoom),
                child: CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: CanvasPainter(
                    _backgroundImage,
                    widget.layers,
                    _drawingStart,
                    _drawingEnd,
                    widget.selectedTool,
                    widget.toolConfig,
                    _previewCropBounds, // Preview crop bounds for drawing
                    _activeCropBounds, // Active confirmed crop bounds
                    _selectedLayerId,
                    _verticalGuides,
                    _horizontalGuides,
                    widget.showGuides,
                    Theme.of(context).colorScheme,
                    _imagePixelData, // Pass pixel data for real sampling
                  ),
                ),
              ),
            ),
          ),
        ), // Container
        ), // GestureDetector
      ), // MouseRegion
    ); // Focus
}

  // Public methods for accessing guides
  List<double> get verticalGuides => _verticalGuides;
  List<double> get horizontalGuides => _horizontalGuides;

  void setVerticalGuides(List<double> guides) {
    setState(() {
      _verticalGuides.clear();
      _verticalGuides.addAll(guides);
    });
  }

  void setHorizontalGuides(List<double> guides) {
    setState(() {
      _horizontalGuides.clear();
      _horizontalGuides.addAll(guides);
    });
  }

  // Public methods for crop functionality
  Rect? get activeCropBounds => _activeCropBounds;
  Rect? get previewCropBounds => _previewCropBounds;

  // Public method for image replacement
  void updateBackgroundImage(ui.Image newImage) {
    setState(() {
      _backgroundImage = newImage;
    });
  }

  /// Initialize pixel data for the background image to enable real pixel sampling
  Future<void> _initializePixelData() async {
    if (_backgroundImage == null) return;

    try {
      _cachedImageForSampling = _backgroundImage;
      _imagePixelData = await _backgroundImage!.toByteData(format: ui.ImageByteFormat.rawRgba);
    } catch (e) {
      _imagePixelData = null;
    }
  }

  Color _sampleRealImagePixelSync(int x, int y) {
    if (_backgroundImage == null || _imagePixelData == null) {
      return Colors.grey;
    }

    try {
      final width = _backgroundImage!.width;
      final height = _backgroundImage!.height;

      // Clamp coordinates to image bounds
      final clampedX = x.clamp(0, width - 1);
      final clampedY = y.clamp(0, height - 1);

      // Calculate pixel index (4 bytes per pixel: RGBA)
      final pixelIndex = (clampedY * width + clampedX) * 4;

      // Extract RGBA values
      final bytes = _imagePixelData!.buffer.asUint8List();
      final r = bytes[pixelIndex];
      final g = bytes[pixelIndex + 1];
      final b = bytes[pixelIndex + 2];
      final a = bytes[pixelIndex + 3];

      return Color.fromARGB(a.toInt(), r.toInt(), g.toInt(), b.toInt());
    } catch (e) {
      return Colors.grey;
    }
  }
}

class CanvasPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final List<EditorLayer> layers;
  final Offset? drawingStart;
  final Offset? drawingEnd;
  final EditorTool selectedTool;
  final ToolConfig toolConfig;
  final Rect? cropRect; // Preview crop bounds (for drawing preview)
  final Rect? activeCropBounds; // Active confirmed crop bounds
  final String? selectedLayerId;
  final List<double> verticalGuides;
  final List<double> horizontalGuides;
  final bool showGuides;
  final ColorScheme colorScheme;
  final ByteData? imagePixelData; // Added for real pixel sampling

  CanvasPainter(
    this.backgroundImage,
    this.layers,
    this.drawingStart,
    this.drawingEnd,
    this.selectedTool,
    this.toolConfig,
    this.cropRect,
    this.activeCropBounds,
    this.selectedLayerId,
    this.verticalGuides,
    this.horizontalGuides,
    this.showGuides,
    this.colorScheme,
    this.imagePixelData, // Added parameter
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background image (crop functionality disabled)
    if (backgroundImage != null) {
      // Calculate scaling to fit the image within the canvas while maintaining aspect ratio
      final imageSize = Size(backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
      final scaleX = size.width / imageSize.width;
      final scaleY = size.height / imageSize.height;
      final scale = math.min(scaleX, scaleY);

      // Center the scaled image
      final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
      final offset = Offset(
        (size.width - scaledSize.width) / 2,
        (size.height - scaledSize.height) / 2,
      );

        final rect = Rect.fromLTWH(offset.dx, offset.dy, scaledSize.width, scaledSize.height);
      final srcRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);

      // Apply crop clipping to background image if there's an active crop (but not in crop editing mode)
      bool shouldApplyCrop = activeCropBounds != null && cropRect == null;

      if (shouldApplyCrop) {
        canvas.save();
        canvas.clipRect(activeCropBounds!);
      }

      // Draw background image (cropped if active crop exists and not in preview mode)
      canvas.drawImageRect(backgroundImage!, srcRect, rect, Paint());

      if (shouldApplyCrop) {
        canvas.restore();
      }
    }

    // Apply global crop clipping for layers if there's an active crop (but not in crop editing mode)
    bool shouldApplyLayerCrop = activeCropBounds != null && cropRect == null;
    if (shouldApplyLayerCrop) {
      canvas.save();
      canvas.clipRect(activeCropBounds!);
    }

    // Draw all layers
    for (final layer in layers.where((l) => l.visible)) {
      _drawLayer(canvas, layer, size);
    }

    // Restore canvas state if we applied global clipping for layers
    if (shouldApplyLayerCrop) {
      canvas.restore();
    }
    
    // Draw preview of current drawing
    if (drawingStart != null && drawingEnd != null) {
      _drawDrawingPreview(canvas, size);
    }
    
    // Draw crop preview and borders
    final currentCropBounds = cropRect ?? activeCropBounds;
    if (currentCropBounds != null && selectedTool == EditorTool.crop) {
      _drawCropBorder(canvas, currentCropBounds, size);
    }
    
    // Draw selection handles for select and move tools
    if ((selectedTool == EditorTool.select || selectedTool == EditorTool.move) && selectedLayerId != null) {
      final selectedLayer = layers.firstWhere((l) => l.id == selectedLayerId, orElse: () => layers.first);
      _drawSelectionHandles(canvas, selectedLayer.bounds);
        }

    // Draw guides
    _drawGuides(canvas, size);

    // Debug: Draw coordinate information (removed for now)
  }

  void _drawLayer(Canvas canvas, EditorLayer layer, Size canvasSize) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = layer.layerType == LayerType.text 
          ? (layer as TextLayer).textStyle.color ?? Colors.black
          : layer is VectorLayer 
              ? layer.strokeColor 
              : Colors.black;
    
    paint.color = paint.color.withValues(alpha: layer.opacity);
    
    switch (layer.layerType) {
      case LayerType.vector:
        _drawVectorLayer(canvas, layer as VectorLayer);
        break;
      case LayerType.text:
        _drawTextLayer(canvas, layer as TextLayer);
        break;
      case LayerType.redaction:
        _drawRedactionLayer(canvas, layer as RedactionLayer, canvasSize);
        break;
      case LayerType.crop:
        // Crop functionality disabled - layers ignored
        break;
      case LayerType.bitmap:
        // TODO: Implement bitmap layer rendering
        break;
    }
  }

  void _drawVectorLayer(Canvas canvas, VectorLayer layer) {
    // Check for fill/stroke settings from metadata or use defaults
    final hasFill = layer.metadata['hasFill'] ?? layer.fillColor != Colors.transparent;
    final hasStroke = layer.metadata['hasStroke'] ?? true;
    
    // Draw fill first if enabled
    if (hasFill && layer.fillColor != Colors.transparent) {
      final fillPaint = Paint()
        ..color = layer.fillColor.withValues(alpha: layer.opacity)
        ..style = PaintingStyle.fill;
      
      for (final element in layer.elements) {
        _drawVectorElement(canvas, element, fillPaint);
      }
    }
    
    // Draw stroke if enabled
    if (hasStroke && layer.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = layer.strokeColor.withValues(alpha: layer.opacity)
        ..strokeWidth = layer.strokeWidth
        ..style = PaintingStyle.stroke;
      
      for (final element in layer.elements) {
        _drawVectorElement(canvas, element, strokePaint);
      }
    }
  }

  void _drawVectorElement(Canvas canvas, VectorElement element, Paint paint) {
    switch (element.type) {
      case VectorElementType.rectangle:
        if (element.points.length >= 2) {
          final rect = Rect.fromPoints(element.points[0], element.points[1]);
          canvas.drawRect(rect, paint);
        }
        break;
        
      case VectorElementType.arrow:
        if (element.points.length >= 2) {
          final start = element.points[0];
          final end = element.points[1];
          
          // Draw arrow line
          canvas.drawLine(start, end, paint);
          
          // Draw arrowhead
          const arrowLength = 15.0;
          const arrowAngle = 0.5;
          
          final direction = (end - start).direction;
          final arrowPoint1 = end + Offset.fromDirection(direction + math.pi - arrowAngle, arrowLength);
          final arrowPoint2 = end + Offset.fromDirection(direction + math.pi + arrowAngle, arrowLength);
          
          canvas.drawLine(end, arrowPoint1, paint);
          canvas.drawLine(end, arrowPoint2, paint);
        }
        break;
        
      case VectorElementType.ellipse:
      case VectorElementType.line:
      case VectorElementType.polygon:
        // TODO: Implement other vector elements
        break;
    }
  }

  void _drawTextLayer(Canvas canvas, TextLayer layer) {
    final isNumberLabel = layer.metadata['isNumberLabel'] == true;
    
    if (isNumberLabel) {
      // Draw number label with circular background
      final center = layer.bounds.center;
      final radius = layer.metadata['circleRadius']?.toDouble() ?? 16.0;
      final backgroundColor = Color(layer.metadata['backgroundColor'] ?? Colors.red.value);
      
      // Draw background circle
      final backgroundPaint = Paint()
        ..color = backgroundColor.withValues(alpha: layer.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, backgroundPaint);
      
      // Draw border
      final borderPaint = Paint()
        ..color = backgroundColor.withValues(alpha: layer.opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;
      canvas.drawCircle(center, radius, borderPaint);
      
      // Draw text centered in circle
      final textPainter = TextPainter(
        text: TextSpan(text: layer.text, style: layer.textStyle),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      
      // Calculate text offset to center it within the circle
      final textWidth = textPainter.width;
      final textHeight = textPainter.height;
      
      final textOffset = Offset(
        center.dx - textWidth / 2,
        center.dy - textHeight / 2,
      );
      textPainter.paint(canvas, textOffset);
    } else {
      // Regular text layer
      final textPainter = TextPainter(
        text: TextSpan(text: layer.text, style: layer.textStyle),
        textAlign: layer.textAlign,
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout(maxWidth: layer.bounds.width);
      textPainter.paint(canvas, layer.bounds.topLeft);
    }
  }

  void _drawRedactionLayer(Canvas canvas, RedactionLayer layer, Size canvasSize) {
    final paint = Paint();
    
    switch (layer.redactionType) {
      case RedactionType.blackout:
        paint
          ..color = Colors.black.withValues(alpha: layer.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(layer.bounds, paint);
        break;
        
      case RedactionType.blur:
        canvas.saveLayer(layer.bounds, Paint());
        
        // Draw the background image portion
        if (backgroundImage != null) {
          final imageSize = Size(backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
          // canvasSize passed as parameter
          
          // Calculate scaling to understand how the image is displayed on canvas
          final scaleX = canvasSize.width / imageSize.width;
          final scaleY = canvasSize.height / imageSize.height;
          final scale = math.min<double>(scaleX, scaleY);
          final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
          final imageOffset = Offset(
            (canvasSize.width - scaledSize.width) / 2,
            (canvasSize.height - scaledSize.height) / 2,
          );
          
          // Convert bounds from canvas coordinates to image coordinates  
          final srcRect = Rect.fromLTWH(
            (layer.bounds.left - imageOffset.dx) / scale,
            (layer.bounds.top - imageOffset.dy) / scale,
            layer.bounds.width / scale,
            layer.bounds.height / scale,
          );
          
          // Draw the background image portion with blur
          final blurPaint = Paint()
            ..imageFilter = ui.ImageFilter.blur(sigmaX: layer.blurRadius, sigmaY: layer.blurRadius)
            ..color = Colors.white.withValues(alpha: layer.opacity);
          
          canvas.drawImageRect(backgroundImage!, srcRect, layer.bounds, blurPaint);
        }
        
        canvas.restore();
        break;
        
      case RedactionType.pixelate:
        canvas.saveLayer(layer.bounds, Paint());
        
        // Draw the background image portion with pixelation
        if (backgroundImage != null) {
          final imageSize = Size(backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
          // canvasSize passed as parameter
          
          // Calculate scaling
          final scaleX = canvasSize.width / imageSize.width;
          final scaleY = canvasSize.height / imageSize.height;
          final scale = math.min<double>(scaleX, scaleY);
          final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
          final imageOffset = Offset(
            (canvasSize.width - scaledSize.width) / 2,
            (canvasSize.height - scaledSize.height) / 2,
          );
          
          // Pixelate by drawing small rects with average color from image blocks
          final pixelSize = layer.pixelSize.toDouble();
          final bounds = layer.bounds;

          for (double x = bounds.left; x < bounds.right; x += pixelSize) {
            for (double y = bounds.top; y < bounds.bottom; y += pixelSize) {
              final pixelRect = Rect.fromLTWH(
                x,
                y,
                math.min(pixelSize, bounds.right - x),
                math.min(pixelSize, bounds.bottom - y),
              );

              // Convert to image coordinates for color sampling
              // Sample from the CENTER of each pixel block for consistency
              final centerX = x + pixelSize / 2;
              final centerY = y + pixelSize / 2;
              final imgX = ((centerX - imageOffset.dx) / scale).clamp(0.0, imageSize.width - 1);
              final imgY = ((centerY - imageOffset.dy) / scale).clamp(0.0, imageSize.height - 1);

              // Get averaged color for this pixel block
              final blockColor = _getPixelBlockColorSync(imgX, imgY, layer.pixelSize.toDouble() / scale);
              final pixelPaint = Paint()
                ..color = blockColor.withValues(alpha: layer.opacity)
                ..style = PaintingStyle.fill;

              canvas.drawRect(pixelRect, pixelPaint);
            }
          }
        }
        
        canvas.restore();
        break;
    }
  }


  void _drawDrawingPreview(Canvas canvas, Size size) {
    if (drawingStart == null || drawingEnd == null) return;

    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = toolConfig.strokeWidth
      ..color = toolConfig.primaryColor.withValues(alpha: 0.7); // Semi-transparent for preview

    switch (selectedTool) {
      case EditorTool.highlightRect:
        // Draw rectangle preview with optional fill
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        final hasFill = toolConfig.toolSpecificSettings['hasFill'] as bool? ?? false;
        final hasStroke = toolConfig.toolSpecificSettings['hasStroke'] as bool? ?? true;

        // Draw fill if enabled
        if (hasFill) {
          final fillPaint = Paint()
            ..style = PaintingStyle.fill
            ..color = (toolConfig.secondaryColor.alpha > 0
                ? toolConfig.secondaryColor
                : toolConfig.primaryColor.withValues(alpha: 0.3)).withValues(alpha: 0.5); // Semi-transparent for preview
          canvas.drawRect(rect, fillPaint);
        }

        // Draw stroke if enabled
        if (hasStroke) {
          canvas.drawRect(rect, paint);
        }
        break;

      case EditorTool.arrow:
        // Draw arrow preview matching the existing arrow implementation
        final arrowHeadSize = toolConfig.toolSpecificSettings['arrowHeadSize'] as double? ?? 15.0;
        final arrowHeadAngle = toolConfig.toolSpecificSettings['arrowHeadAngle'] as double? ?? 0.5;

        // Draw main arrow line
        canvas.drawLine(drawingStart!, drawingEnd!, paint);

        // Draw arrowhead using the same logic as _drawVectorElement
        final direction = (drawingEnd! - drawingStart!).direction;
        final arrowPoint1 = drawingEnd! + Offset.fromDirection(direction + math.pi - arrowHeadAngle, arrowHeadSize);
        final arrowPoint2 = drawingEnd! + Offset.fromDirection(direction + math.pi + arrowHeadAngle, arrowHeadSize);

        canvas.drawLine(drawingEnd!, arrowPoint1, paint);
        canvas.drawLine(drawingEnd!, arrowPoint2, paint);
        break;

      case EditorTool.redactBlackout:
      case EditorTool.redactBlur:
      case EditorTool.redactPixelate:
        // Draw redaction area preview as filled rectangle
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        paint.style = PaintingStyle.fill;
        paint.color = selectedTool == EditorTool.redactBlackout
            ? Colors.black.withValues(alpha: 0.7)
            : Colors.grey.withValues(alpha: 0.7);
        canvas.drawRect(rect, paint);

        // Draw border
        paint.style = PaintingStyle.stroke;
        paint.color = paint.color.withValues(alpha: 1.0);
        canvas.drawRect(rect, paint);
        break;

      case EditorTool.text:
        // Draw text area preview as dashed rectangle
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        paint.strokeWidth = 1.0;
        paint.color = toolConfig.primaryColor.withValues(alpha: 0.7);
        _drawDashedRect(canvas, rect, paint);
        break;

      case EditorTool.numberLabel:
        // Draw number label preview as circle
        final center = (drawingStart! + drawingEnd!) / 2;
        final radius = toolConfig.toolSpecificSettings['circleRadius'] as double? ?? 12.0;

        // Draw circle background
        final backgroundPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = toolConfig.secondaryColor.withValues(alpha: 0.7);
        canvas.drawCircle(center, radius, backgroundPaint);

        // Draw circle border
        paint.style = PaintingStyle.stroke;
        canvas.drawCircle(center, radius, paint);
        break;

      default:
        // For other tools, draw a simple line preview
        canvas.drawLine(drawingStart!, drawingEnd!, paint);
        break;
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint) {
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    // Top edge
    _drawDashedLine(canvas, rect.topLeft, rect.topRight, paint, dashWidth, dashSpace);
    // Right edge
    _drawDashedLine(canvas, rect.topRight, rect.bottomRight, paint, dashWidth, dashSpace);
    // Bottom edge
    _drawDashedLine(canvas, rect.bottomRight, rect.bottomLeft, paint, dashWidth, dashSpace);
    // Left edge
    _drawDashedLine(canvas, rect.bottomLeft, rect.topLeft, paint, dashWidth, dashSpace);
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint, double dashWidth, double dashSpace) {
    final direction = end - start;
    final totalLength = direction.distance;
    final normalizedDirection = direction / totalLength;

    double currentLength = 0.0;
    bool drawDash = true;

    while (currentLength < totalLength) {
      final segmentLength = drawDash ? dashWidth : dashSpace;
      final segmentEnd = (currentLength + segmentLength).clamp(0.0, totalLength);

      if (drawDash) {
        final segmentStart = start + normalizedDirection * currentLength;
        final segmentEndPoint = start + normalizedDirection * segmentEnd;
        canvas.drawLine(segmentStart, segmentEndPoint, paint);
      }

      currentLength = segmentEnd;
      drawDash = !drawDash;
    }
  }


  void _drawCropBorder(Canvas canvas, Rect cropBounds, Size size) {
    // Draw translucent overlay for areas to be removed
    final overlayPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Draw overlay rectangles around the crop area (areas to be removed)
    // Top area
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, cropBounds.top),
      overlayPaint,
    );
    // Bottom area
    canvas.drawRect(
      Rect.fromLTWH(0, cropBounds.bottom, size.width, size.height - cropBounds.bottom),
      overlayPaint,
    );
    // Left area
    canvas.drawRect(
      Rect.fromLTWH(0, cropBounds.top, cropBounds.left, cropBounds.height),
      overlayPaint,
    );
    // Right area
    canvas.drawRect(
      Rect.fromLTWH(cropBounds.right, cropBounds.top, size.width - cropBounds.right, cropBounds.height),
      overlayPaint,
    );

    // Draw crop border with dashed pattern
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw solid border
    canvas.drawRect(cropBounds, borderPaint);

    // Draw rule of thirds grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Vertical thirds
    final thirdWidth = cropBounds.width / 3;
    canvas.drawLine(
      Offset(cropBounds.left + thirdWidth, cropBounds.top),
      Offset(cropBounds.left + thirdWidth, cropBounds.bottom),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropBounds.left + thirdWidth * 2, cropBounds.top),
      Offset(cropBounds.left + thirdWidth * 2, cropBounds.bottom),
      gridPaint,
    );

    // Horizontal thirds
    final thirdHeight = cropBounds.height / 3;
    canvas.drawLine(
      Offset(cropBounds.left, cropBounds.top + thirdHeight),
      Offset(cropBounds.right, cropBounds.top + thirdHeight),
      gridPaint,
    );
    canvas.drawLine(
      Offset(cropBounds.left, cropBounds.top + thirdHeight * 2),
      Offset(cropBounds.right, cropBounds.top + thirdHeight * 2),
      gridPaint,
    );

    // Draw resize handles
    _drawCropHandles(canvas, cropBounds);
  }

  void _drawCropHandles(Canvas canvas, Rect bounds) {
    final handlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final handleStrokePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    const handleSize = 10.0;
    const handleOffset = handleSize / 2;

    // Helper function to draw a handle
    void drawHandle(Offset center) {
      final rect = Rect.fromCenter(
        center: center,
        width: handleSize,
        height: handleSize,
      );
      canvas.drawRect(rect, handlePaint);
      canvas.drawRect(rect, handleStrokePaint);
    }

    // Corner handles
    drawHandle(bounds.topLeft);
    drawHandle(bounds.topRight);
    drawHandle(bounds.bottomLeft);
    drawHandle(bounds.bottomRight);

    // Edge handles
    drawHandle(Offset(bounds.center.dx, bounds.top));
    drawHandle(Offset(bounds.center.dx, bounds.bottom));
    drawHandle(Offset(bounds.left, bounds.center.dy));
    drawHandle(Offset(bounds.right, bounds.center.dy));
  }

  void _drawSelectionHandles(Canvas canvas, Rect bounds) {
    final handlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    const handleSize = 8.0;

    // Draw corner handles
    canvas.drawRect(
      Rect.fromCenter(center: bounds.topLeft, width: handleSize, height: handleSize),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: bounds.topRight, width: handleSize, height: handleSize),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: bounds.bottomLeft, width: handleSize, height: handleSize),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: bounds.bottomRight, width: handleSize, height: handleSize),
      handlePaint,
    );
  }

  void _drawGuides(Canvas canvas, Size size) {
    if (!showGuides || backgroundImage == null) return;

    final guidePaint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.6)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Calculate the same scaling and offset used for the background image
    final imageSize = Size(backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    final scale = math.min(scaleX, scaleY);

    // Center the scaled image
    final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
    final offset = Offset(
      (size.width - scaledSize.width) / 2,
      (size.height - scaledSize.height) / 2,
    );

    // Draw vertical guides - convert from image coordinates to screen coordinates
    for (final guideX in verticalGuides) {
      if (guideX >= 0 && guideX <= imageSize.width) {
        final screenX = offset.dx + (guideX * scale);
        if (screenX >= 0 && screenX <= size.width) {
          canvas.drawLine(
            Offset(screenX, offset.dy),
            Offset(screenX, offset.dy + scaledSize.height),
            guidePaint,
          );
        }
      }
    }

    // Draw horizontal guides - convert from image coordinates to screen coordinates
    for (final guideY in horizontalGuides) {
      if (guideY >= 0 && guideY <= imageSize.height) {
        final screenY = offset.dy + (guideY * scale);
        if (screenY >= 0 && screenY <= size.height) {
          canvas.drawLine(
            Offset(offset.dx, screenY),
            Offset(offset.dx + scaledSize.width, screenY),
            guidePaint,
          );
        }
      }
    }
  }

  Color _getPixelBlockColorSync(double imgX, double imgY, double blockSize) {
    if (backgroundImage == null || imagePixelData == null) {
      return Colors.grey.withValues(alpha: 0.8);
    }

    try {
      // Find the block boundaries
      final blockX = (imgX / blockSize).floor() * blockSize;
      final blockY = (imgY / blockSize).floor() * blockSize;

      // Sample from the center of the block for better representation
      final centerX = blockX + blockSize / 2;
      final centerY = blockY + blockSize / 2;

      // Sample actual pixel from the cached image data
      return _sampleRealImagePixelSync(centerX.toInt(), centerY.toInt());
    } catch (e) {
      return Colors.grey.withValues(alpha: 0.8);
    }
  }

  Color _sampleRealImagePixelSync(int x, int y) {
    if (backgroundImage == null || imagePixelData == null) {
      return Colors.grey.withValues(alpha: 0.8);
    }

    try {
      final width = backgroundImage!.width;
      final height = backgroundImage!.height;

      // Clamp coordinates to image bounds
      final clampedX = x.clamp(0, width - 1);
      final clampedY = y.clamp(0, height - 1);

      // Calculate pixel index (4 bytes per pixel: RGBA)
      final pixelIndex = (clampedY * width + clampedX) * 4;

      // Extract RGBA values
      final bytes = imagePixelData!.buffer.asUint8List();
      final r = bytes[pixelIndex];
      final g = bytes[pixelIndex + 1];
      final b = bytes[pixelIndex + 2];
      final a = bytes[pixelIndex + 3];

      return Color.fromARGB(a.toInt(), r.toInt(), g.toInt(), b.toInt());
    } catch (e) {
      return Colors.grey.withValues(alpha: 0.8);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
