import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/editor_tool.dart';
import '../../models/editor_layer.dart';
import '../../providers/screenshot_providers.dart';

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
  });

  @override
  ConsumerState<EditorCanvas> createState() => _EditorCanvasState();
}

class _EditorCanvasState extends ConsumerState<EditorCanvas> {
  double _zoom = 1.0;
  Offset _pan = Offset.zero;
  ui.Image? _backgroundImage;
  bool _isLoading = true;
  
  // Drawing state
  final List<EditorLayer> _tempLayers = [];
  Offset? _drawingStart;
  Offset? _drawingEnd;
  bool _isDrawing = false;
  
  // Crop state - now non-destructive
  Rect? _cropRect;
  bool _isCropMode = false;
  bool _isCropResizing = false;
  String? _cropHandle;
  
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
    // Check if crop tool was selected
    if (widget.selectedTool == EditorTool.crop && oldWidget.selectedTool != EditorTool.crop) {
      _activateCropMode();
    } else if (widget.selectedTool != EditorTool.crop && oldWidget.selectedTool == EditorTool.crop) {
      _deactivateCropMode();
    }
  }

  void _activateCropMode() {
    setState(() {
      _isCropMode = true;
      // Only set existing crop bounds if they exist, don't create a default
      _cropRect = _getExistingCropBounds();
    });
  }

  void _deactivateCropMode() {
    setState(() {
      _isCropMode = false;
      _cropRect = null;
      _isCropResizing = false;
      _cropHandle = null;
    });
  }

  Rect? _getExistingCropBounds() {
    // Find the most recent crop layer
    final cropLayers = widget.layers.where((layer) => 
        layer.layerType == LayerType.crop && layer.visible).cast<CropLayer>().toList();
    
    if (cropLayers.isNotEmpty) {
      return cropLayers.first.cropRect;
    }
    return null;
  }

  Future<void> _loadScreenshotImage() async {
    try {
      // Get the screenshot data first
      final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);
      
      if (screenshot != null && screenshot.originalPath.isNotEmpty) {
        await _loadImageFromAsset(screenshot.originalPath);
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
    } catch (e) {
      print('Error loading image from asset: $e');
      await _loadPlaceholderImage();
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
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
    if (_cropRect == null) return;
    
    // Create a non-destructive crop layer
    final now = DateTime.now();
    final cropLayer = CropLayer(
      id: 'crop-${now.millisecondsSinceEpoch}',
      name: 'Crop',
      visible: true,
      locked: false,
      opacity: 1.0,
      blendModeType: BlendModeType.normal,
      bounds: _cropRect!,
      cropRect: _cropRect!,
      createdDate: now,
      modifiedDate: now,
    );
    
    // Add the crop layer through the parent widget
    widget.onLayerAdded?.call(cropLayer);
    
    setState(() {
      _cropRect = null;
    });
  }

  void cancelCrop() {
    setState(() {
      _cropRect = null;
    });
  }

  bool get hasPendingCrop => _cropRect != null;

  EditorLayer? _findLayerAtPoint(Offset point) {
    // Search layers in reverse order (top to bottom)
    for (final layer in widget.layers.reversed) {
      if (layer.bounds?.contains(point) == true) {
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

  String? _getGuideAtPoint(Offset point) {
    const guideSnapDistance = 8.0;
    
    // Check vertical guides
    for (int i = 0; i < _verticalGuides.length; i++) {
      if ((point.dx - _verticalGuides[i]).abs() < guideSnapDistance) {
        return 'v$i';
      }
    }
    
    // Check horizontal guides
    for (int i = 0; i < _horizontalGuides.length; i++) {
      if ((point.dy - _horizontalGuides[i]).abs() < guideSnapDistance) {
        return 'h$i';
      }
    }
    
    return null;
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
    setState(() {
      _isDrawing = true;
      _drawingStart = _screenToCanvasCoords(point);
      _drawingEnd = _drawingStart;
    });
  }

  void _handleDrawingUpdate(Offset point) {
    setState(() {
      _drawingEnd = _screenToCanvasCoords(point);
    });
  }

  void _handleDrawingEnd() {
    if (_drawingStart != null && _drawingEnd != null) {
      if (widget.selectedTool == EditorTool.crop) {
        // For crop tool, store the crop rectangle and create crop layer
        final cropRect = Rect.fromPoints(_drawingStart!, _drawingEnd!);
        setState(() {
          _cropRect = cropRect;
        });
        // Create the crop layer immediately
        _applyCropToAllLayers(cropRect);
      } else {
        final layer = _createLayerFromGesture();
        if (layer != null) {
          widget.onLayerAdded?.call(layer);
          setState(() {
            _tempLayers.clear();
          });
        }
      }
    }
    
    setState(() {
      _isDrawing = false;
      _drawingStart = null;
      _drawingEnd = null;
    });
  }

  Offset _screenToCanvasCoords(Offset screenPoint) {
    // Convert screen coordinates to canvas coordinates
    // Get the render box to understand the actual widget layout
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return Offset.zero;
    
    final canvasSize = renderBox.size;
    final containerSize = renderBox.size;
    
    // Account for the Center widget that centers the canvas within the container
    // The canvas (800x600) is centered within the container
    final centerOffset = Offset(
      (containerSize.width - canvasSize.width * _zoom) / 2,
      (containerSize.height - canvasSize.height * _zoom) / 2,
    );
    
    // Transform from container coordinates to canvas coordinates
    // 1. Subtract the center offset and pan offset
    // 2. Divide by zoom to get canvas coordinates
    final canvasPoint = Offset(
      (screenPoint.dx - centerOffset.dx - _pan.dx) / _zoom,
      (screenPoint.dy - centerOffset.dy - _pan.dy) / _zoom,
    );
    
    // Clamp to canvas bounds
    return Offset(
      canvasPoint.dx.clamp(0, canvasSize.width),
      canvasPoint.dy.clamp(0, canvasSize.height),
    );
  }

  TextLayer? _createNumberLabel(Offset position) {
    final numberValue = widget.getNextNumberLabelValue?.call() ?? 1;
    final now = DateTime.now();
    final layerId = 'number-label-${now.millisecondsSinceEpoch}';
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
    final layerId = 'layer-${now.millisecondsSinceEpoch}';
    
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
                  : widget.toolConfig.primaryColor.withOpacity(0.3))
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

  void _applyCropToAllLayers(Rect cropRect) {
    // Create a new crop layer that applies to all layers
    final now = DateTime.now();
    final cropLayerId = 'crop-${now.millisecondsSinceEpoch}';
    
    final cropLayer = CropLayer(
      id: cropLayerId,
      name: 'Crop',
      visible: true,
      locked: false,
      opacity: 1.0,
      blendModeType: BlendModeType.normal,
      bounds: cropRect,
      cropRect: cropRect,
      createdDate: now,
      modifiedDate: now,
    );

    // Remove any existing crop layers to prevent multiple crops
    // Add the new crop layer
    widget.onLayerAdded?.call(cropLayer);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return MouseRegion(
      cursor: _getCursorForTool(widget.selectedTool),
      onHover: (event) {
        // Track handle hover for select and move tools
        if ((widget.selectedTool == EditorTool.select || widget.selectedTool == EditorTool.move) && _selectedLayerId != null) {
          final canvasPoint = _screenToCanvasCoords(event.localPosition);
          final selectedLayer = widget.layers.firstWhere(
            (l) => l.id == _selectedLayerId,
            orElse: () => widget.layers.first,
          );
          
          if (selectedLayer.bounds != null) {
            final handle = _getHandleAtPoint(canvasPoint, selectedLayer.bounds!);
            if (_hoverHandle != handle) {
              setState(() {
                _hoverHandle = handle;
              });
            }
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
          try {
            final layer = _createNumberLabel(canvasPoint);
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
          
          // Create guide based on current mode
          if (_isVerticalGuideMode) {
            _addVerticalGuide(canvasPoint.dx);
          } else {
            _addHorizontalGuide(canvasPoint.dy);
          }
        }
      },
        onDoubleTap: () {
        // For guides, we need the last tap position
        // This is handled in onDoubleTapDown
      },
        onDoubleTapDown: (details) {
        final canvasPoint = _screenToCanvasCoords(details.localPosition);
        
        // Check for guide deletion first - works with any tool
        final guide = _getGuideAtPoint(canvasPoint);
        if (guide != null) {
          _removeGuide(guide);
          return;
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
        
        // Check for guide interaction first (works with any tool)
        final guide = _getGuideAtPoint(canvasPoint);
        if (guide != null) {
          setState(() {
            _draggingGuide = guide;
            _isDraggingGuide = true;
          });
          return;
        }
        
        if (widget.selectedTool == EditorTool.pan) {
          // Handle pan/zoom gesture
        } else if (widget.selectedTool == EditorTool.select) {
          // Handle object selection, resizing, and dragging
          if (_selectedLayerId != null) {
            final selectedLayer = widget.layers.firstWhere((l) => l.id == _selectedLayerId);
            if (selectedLayer.bounds != null) {
              final handle = _getHandleAtPoint(canvasPoint, selectedLayer.bounds!);
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
          // Handle crop tool - check for crop handles first
          if (_cropRect != null) {
            final handle = _getHandleAtPoint(canvasPoint, _cropRect!);
            if (handle != null) {
              // Start crop resizing
              setState(() {
                _cropHandle = handle;
                _isCropResizing = true;
                _dragStart = canvasPoint;
                _initialLayerBounds = _cropRect;
              });
              return;
            } else if (_cropRect!.contains(canvasPoint)) {
              // Start moving the crop area
              setState(() {
                _isDragging = true;
                _dragStart = canvasPoint;
                _initialLayerBounds = _cropRect;
              });
              return;
            }
          }
          
          // Start new crop selection
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
              _initialLayerPosition = layer.bounds?.topLeft ?? Offset.zero;
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
          _updateGuide(_draggingGuide!, canvasPoint);
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
            // Handle dragging
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final delta = currentPoint - _dragStart!;
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
            // Handle layer moving
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final delta = currentPoint - _dragStart!;
            final newBounds = _initialLayerBounds!.shift(delta);
            _updateLayerBounds(_selectedLayerId!, newBounds);
          }
        } else if (widget.selectedTool == EditorTool.crop) {
          // Handle crop tool updates
          if (_isCropResizing && _cropHandle != null && _initialLayerBounds != null && _cropRect != null) {
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final delta = currentPoint - _dragStart!;
            Rect newCropRect = _initialLayerBounds!;
            
            switch (_cropHandle) {
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
            
            // Ensure minimum crop size and stay within canvas bounds
            final renderBox = context.findRenderObject() as RenderBox?;
            final canvasSize = renderBox?.size ?? Size.zero;
            newCropRect = Rect.fromLTRB(
              newCropRect.left.clamp(0.0, canvasSize.width - 50),
              newCropRect.top.clamp(0.0, canvasSize.height - 50),
              newCropRect.right.clamp(50.0, canvasSize.width),
              newCropRect.bottom.clamp(50.0, canvasSize.height),
            );
            
            if (newCropRect.width > 50 && newCropRect.height > 50) {
              setState(() {
                _cropRect = newCropRect;
              });
            }
          } else if (_isDragging && _initialLayerBounds != null && _cropRect != null) {
            // Handle moving the entire crop area
            final currentPoint = _screenToCanvasCoords(details.localFocalPoint);
            final delta = currentPoint - _dragStart!;
            final newCropRect = _initialLayerBounds!.shift(delta);
            
            // Keep crop area within canvas bounds
            final renderBox = context.findRenderObject() as RenderBox?;
            final canvasSize = renderBox?.size ?? Size.zero;
            final clampedRect = Rect.fromLTRB(
              newCropRect.left.clamp(0.0, canvasSize.width - newCropRect.width),
              newCropRect.top.clamp(0.0, canvasSize.height - newCropRect.height),
              (newCropRect.left + newCropRect.width).clamp(newCropRect.width, canvasSize.width),
              (newCropRect.top + newCropRect.height).clamp(newCropRect.height, canvasSize.height),
            );
            
            setState(() {
              _cropRect = clampedRect;
            });
          }
        } else if (_isDrawing) {
          // Handle drawing update
          _handleDrawingUpdate(details.localFocalPoint);
        }
      },
        onScaleEnd: (details) {
        if (_isDrawing) {
          _handleDrawingEnd();
        } else if (_isDragging || _isResizing || _isCropResizing || _isDraggingGuide) {
          setState(() {
            _isDragging = false;
            _isResizing = false;
            _isCropResizing = false;
            _isDraggingGuide = false;
            _resizeHandle = null;
            _cropHandle = null;
            _draggingGuide = null;
            _dragStart = null;
            _initialLayerPosition = null;
            _initialLayerBounds = null;
          });
          
          // If we were working with crop tool, apply the crop to all layers
          if (widget.selectedTool == EditorTool.crop && _cropRect != null) {
            _applyCropToAllLayers(_cropRect!);
          }
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
                _cropRect,
                _selectedLayerId,
                _verticalGuides,
                _horizontalGuides,
                widget.showGuides,
                Theme.of(context).colorScheme,
              ),
            ),
          ),
        ),
      ), // Container
    ), // GestureDetector
    ), // GestureDetector
  ); // MouseRegion
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
}

class CanvasPainter extends CustomPainter {
  final ui.Image? backgroundImage;
  final List<EditorLayer> layers;
  final Offset? drawingStart;
  final Offset? drawingEnd;
  final EditorTool selectedTool;
  final ToolConfig toolConfig;
  final Rect? cropRect;
  final String? selectedLayerId;
  final List<double> verticalGuides;
  final List<double> horizontalGuides;
  final bool showGuides;
  final ColorScheme colorScheme;

  CanvasPainter(
    this.backgroundImage, 
    this.layers,
    this.drawingStart,
    this.drawingEnd,
    this.selectedTool,
    this.toolConfig,
    this.cropRect,
    this.selectedLayerId,
    this.verticalGuides,
    this.horizontalGuides,
    this.showGuides,
    this.colorScheme,
  );

  @override
  void paint(Canvas canvas, Size size) {
    // Find active crop layers
    final activeCropLayers = layers.where((layer) => 
        layer.layerType == LayerType.crop && layer.visible).cast<CropLayer>().toList();
    
    // Draw background image
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
      
      // If there are active crop layers or a crop preview, apply clipping
      if (activeCropLayers.isNotEmpty) {
        // Use the first (most recent) crop layer
        final activeCrop = activeCropLayers.first;
        _drawImageWithCrop(canvas, activeCrop.cropRect, offset, scaledSize, size);
      } else if (cropRect != null) {
        // Temporary crop preview
        _drawImageWithCrop(canvas, cropRect!, offset, scaledSize, size);
      } else {
        // Normal drawing without crop
        final rect = Rect.fromLTWH(offset.dx, offset.dy, scaledSize.width, scaledSize.height);
        final srcRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
        canvas.drawImageRect(backgroundImage!, srcRect, rect, Paint());
      }
    }
    
    // Draw all layers
    for (final layer in layers.where((l) => l.visible)) {
      _drawLayer(canvas, layer, size);
    }
    
    // Draw preview of current drawing
    if (drawingStart != null && drawingEnd != null) {
      _drawDrawingPreview(canvas);
    }
    
    // Draw crop border when there's an active crop (but not while drawing)
    if (cropRect != null && drawingStart == null) {
      _drawCropBorder(canvas, cropRect!);
    }
    
    // Draw selection handles for select and move tools
    if ((selectedTool == EditorTool.select || selectedTool == EditorTool.move) && selectedLayerId != null) {
      final selectedLayer = layers.firstWhere((l) => l.id == selectedLayerId, orElse: () => layers.first);
      if (selectedLayer.bounds != null) {
        _drawSelectionHandles(canvas, selectedLayer.bounds!);
      }
    }
    
    // Draw guides
    _drawGuides(canvas, size);
  }

  void _drawLayer(Canvas canvas, EditorLayer layer, Size canvasSize) {
    final paint = Paint()
      ..isAntiAlias = true
      ..color = layer.layerType == LayerType.text 
          ? (layer as TextLayer).textStyle.color ?? Colors.black
          : layer is VectorLayer 
              ? layer.strokeColor 
              : Colors.black;
    
    paint.color = paint.color.withOpacity(layer.opacity);
    
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
        // Crop layers don't draw anything - they affect background image rendering
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
        ..color = layer.fillColor.withOpacity(layer.opacity)
        ..style = PaintingStyle.fill;
      
      for (final element in layer.elements) {
        _drawVectorElement(canvas, element, fillPaint);
      }
    }
    
    // Draw stroke if enabled
    if (hasStroke && layer.strokeWidth > 0) {
      final strokePaint = Paint()
        ..color = layer.strokeColor.withOpacity(layer.opacity)
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
    if (layer.bounds == null) return;
    
    // Check if this is a number label
    final isNumberLabel = layer.metadata['isNumberLabel'] == true;
    
    if (isNumberLabel) {
      // Draw number label with circular background
      final center = layer.bounds!.center;
      final radius = layer.metadata['circleRadius']?.toDouble() ?? 16.0;
      final backgroundColor = Color(layer.metadata['backgroundColor'] ?? Colors.red.value);
      
      // Draw background circle
      final backgroundPaint = Paint()
        ..color = backgroundColor.withOpacity(layer.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(center, radius, backgroundPaint);
      
      // Draw border
      final borderPaint = Paint()
        ..color = backgroundColor.withOpacity(layer.opacity)
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
      
      textPainter.layout(maxWidth: layer.bounds!.width);
      textPainter.paint(canvas, layer.bounds!.topLeft);
    }
  }

  void _drawRedactionLayer(Canvas canvas, RedactionLayer layer, Size canvasSize) {
    if (layer.bounds == null) return;
    
    final paint = Paint();
    
    switch (layer.redactionType) {
      case RedactionType.blackout:
        paint
          ..color = Colors.black.withOpacity(layer.opacity)
          ..style = PaintingStyle.fill;
        canvas.drawRect(layer.bounds!, paint);
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
            (layer.bounds!.left - imageOffset.dx) / scale,
            (layer.bounds!.top - imageOffset.dy) / scale,
            layer.bounds!.width / scale,
            layer.bounds!.height / scale,
          );
          
          // Draw the background image portion with blur
          final blurPaint = Paint()
            ..imageFilter = ui.ImageFilter.blur(sigmaX: layer.blurRadius, sigmaY: layer.blurRadius)
            ..color = Colors.white.withOpacity(layer.opacity);
          
          canvas.drawImageRect(backgroundImage!, srcRect, layer.bounds!, blurPaint);
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
          
          // Pixelate by drawing small rects with average color
          final pixelSize = layer.pixelSize.toDouble();
          final bounds = layer.bounds!;
          
          for (double x = bounds.left; x < bounds.right; x += pixelSize) {
            for (double y = bounds.top; y < bounds.bottom; y += pixelSize) {
              final pixelRect = Rect.fromLTWH(
                x,
                y,
                math.min(pixelSize, bounds.right - x),
                math.min(pixelSize, bounds.bottom - y),
              );
              
              // Convert to image coordinates for color sampling
              final imgX = ((x - imageOffset.dx) / scale).clamp(0.0, imageSize.width - 1);
              final imgY = ((y - imageOffset.dy) / scale).clamp(0.0, imageSize.height - 1);
              
              // Use a representative color (could be improved with actual pixel sampling)
              final pixelPaint = Paint()
                ..color = _getPixelatedColor(imgX, imgY).withOpacity(layer.opacity)
                ..style = PaintingStyle.fill;
              
              canvas.drawRect(pixelRect, pixelPaint);
            }
          }
        }
        
        canvas.restore();
        break;
    }
  }

  Color _getPixelatedColor(double imgX, double imgY) {
    // Generate a color based on position for pixelation effect
    // In a real implementation, you'd sample the actual pixel from the image
    final int r = ((imgX * 255) % 255).toInt();
    final int g = ((imgY * 255) % 255).toInt();
    final int b = (((imgX + imgY) * 127) % 255).toInt();
    return Color.fromRGBO(r, g, b, 1.0);
  }

  void _drawImageWithCrop(Canvas canvas, Rect cropRect, Offset imageOffset, Size scaledSize, Size canvasSize) {
    // Save canvas state for clipping
    canvas.save();
    
    // Clip to crop area
    canvas.clipRect(cropRect);
    
    // Draw the image with proper scaling
    final imageSize = Size(backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
    final rect = Rect.fromLTWH(imageOffset.dx, imageOffset.dy, scaledSize.width, scaledSize.height);
    final srcRect = Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
    canvas.drawImageRect(backgroundImage!, srcRect, rect, Paint());
    
    // Restore canvas state
    canvas.restore();
    
    // Draw darkened overlay outside crop area for preview (only if cropRect is temporary)
    if (this.cropRect != null) {
      final overlayPaint = Paint()..color = Colors.black.withOpacity(0.7);
      
      // Top overlay
      if (cropRect.top > 0) {
        canvas.drawRect(
          Rect.fromLTRB(0, 0, canvasSize.width, cropRect.top),
          overlayPaint,
        );
      }
      
      // Bottom overlay
      if (cropRect.bottom < canvasSize.height) {
        canvas.drawRect(
          Rect.fromLTRB(0, cropRect.bottom, canvasSize.width, canvasSize.height),
          overlayPaint,
        );
      }
      
      // Left overlay
      if (cropRect.left > 0) {
        canvas.drawRect(
          Rect.fromLTRB(0, cropRect.top, cropRect.left, cropRect.bottom),
          overlayPaint,
        );
      }
      
      // Right overlay
      if (cropRect.right < canvasSize.width) {
        canvas.drawRect(
          Rect.fromLTRB(cropRect.right, cropRect.top, canvasSize.width, cropRect.bottom),
          overlayPaint,
        );
      }
    }
  }

  void _drawSelectionHandles(Canvas canvas, Rect bounds) {
    // Draw selection border
    final borderPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(bounds, borderPaint);
    
    // Draw corner handles
    const handleSize = 8.0;
    final handlePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    // Top-left handle
    canvas.drawRect(
      Rect.fromCenter(center: bounds.topLeft, width: handleSize, height: handleSize),
      handlePaint,
    );
    
    // Top-right handle
    canvas.drawRect(
      Rect.fromCenter(center: bounds.topRight, width: handleSize, height: handleSize),
      handlePaint,
    );
    
    // Bottom-left handle
    canvas.drawRect(
      Rect.fromCenter(center: bounds.bottomLeft, width: handleSize, height: handleSize),
      handlePaint,
    );
    
    // Bottom-right handle
    canvas.drawRect(
      Rect.fromCenter(center: bounds.bottomRight, width: handleSize, height: handleSize),
      handlePaint,
    );
    
    // Side handles
    canvas.drawRect(
      Rect.fromCenter(center: Offset(bounds.center.dx, bounds.top), width: handleSize, height: handleSize),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(bounds.center.dx, bounds.bottom), width: handleSize, height: handleSize),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(bounds.left, bounds.center.dy), width: handleSize, height: handleSize),
      handlePaint,
    );
    canvas.drawRect(
      Rect.fromCenter(center: Offset(bounds.right, bounds.center.dy), width: handleSize, height: handleSize),
      handlePaint,
    );
  }

  void _drawGuides(Canvas canvas, Size size) {
    // Only draw guides if showGuides is true
    if (!showGuides) return;
    
    final guidePaint = Paint()
      ..color = colorScheme.primary // Theme color for guides
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    final handlePaint = Paint()
      ..color = colorScheme.primary.withOpacity(0.5)
      ..style = PaintingStyle.fill;
    
    // Draw vertical guides
    for (final x in verticalGuides) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        guidePaint,
      );
      
      // Draw small handle at the top for easier interaction
      canvas.drawCircle(
        Offset(x, 10),
        4.0,
        handlePaint,
      );
    }
    
    // Draw horizontal guides
    for (final y in horizontalGuides) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        guidePaint,
      );
      
      // Draw small handle at the left for easier interaction
      canvas.drawCircle(
        Offset(10, y),
        4.0,
        handlePaint,
      );
    }
  }

  void _drawCropBorder(Canvas canvas, Rect cropRect) {
    // Draw crop border
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawRect(cropRect, borderPaint);
    
    // Draw crop overlay - darken everything outside crop area
    final canvasRect = Rect.fromLTWH(0, 0, 800, 600);
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.5);
    
    // Top overlay
    if (cropRect.top > 0) {
      canvas.drawRect(
        Rect.fromLTRB(0, 0, 800, cropRect.top),
        overlayPaint,
      );
    }
    
    // Bottom overlay
    if (cropRect.bottom < 600) {
      canvas.drawRect(
        Rect.fromLTRB(0, cropRect.bottom, 800, 600),
        overlayPaint,
      );
    }
    
    // Left overlay
    if (cropRect.left > 0) {
      canvas.drawRect(
        Rect.fromLTRB(0, cropRect.top, cropRect.left, cropRect.bottom),
        overlayPaint,
      );
    }
    
    // Right overlay
    if (cropRect.right < 800) {
      canvas.drawRect(
        Rect.fromLTRB(cropRect.right, cropRect.top, 800, cropRect.bottom),
        overlayPaint,
      );
    }
    
    // Draw resize handles when crop tool is selected
    if (selectedTool == EditorTool.crop) {
      const handleSize = 8.0;
      final handlePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      
      final handleBorderPaint = Paint()
        ..color = Colors.black
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;
      
      final handles = [
        cropRect.topLeft,     // tl
        cropRect.topRight,    // tr
        cropRect.bottomLeft,  // bl
        cropRect.bottomRight, // br
        Offset(cropRect.center.dx, cropRect.top),    // t
        Offset(cropRect.center.dx, cropRect.bottom), // b
        Offset(cropRect.left, cropRect.center.dy),   // l
        Offset(cropRect.right, cropRect.center.dy),  // r
      ];
      
      for (final handlePos in handles) {
        final handleRect = Rect.fromCenter(
          center: handlePos,
          width: handleSize,
          height: handleSize,
        );
        canvas.drawRect(handleRect, handlePaint);
        canvas.drawRect(handleRect, handleBorderPaint);
      }
    } else {
      // Draw crop corners when not actively editing
      const cornerSize = 10.0;
      final cornerPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 3.0
        ..style = PaintingStyle.stroke;
      
      // Top-left corner
      canvas.drawLine(cropRect.topLeft, cropRect.topLeft + const Offset(cornerSize, 0), cornerPaint);
      canvas.drawLine(cropRect.topLeft, cropRect.topLeft + const Offset(0, cornerSize), cornerPaint);
      
      // Top-right corner
      canvas.drawLine(cropRect.topRight, cropRect.topRight + const Offset(-cornerSize, 0), cornerPaint);
      canvas.drawLine(cropRect.topRight, cropRect.topRight + const Offset(0, cornerSize), cornerPaint);
      
      // Bottom-left corner
      canvas.drawLine(cropRect.bottomLeft, cropRect.bottomLeft + const Offset(cornerSize, 0), cornerPaint);
      canvas.drawLine(cropRect.bottomLeft, cropRect.bottomLeft + const Offset(0, -cornerSize), cornerPaint);
      
      // Bottom-right corner
      canvas.drawLine(cropRect.bottomRight, cropRect.bottomRight + const Offset(-cornerSize, 0), cornerPaint);
      canvas.drawLine(cropRect.bottomRight, cropRect.bottomRight + const Offset(0, -cornerSize), cornerPaint);
    }
  }


  void _drawDrawingPreview(Canvas canvas) {
    if (drawingStart == null || drawingEnd == null) return;
    
    final paint = Paint()
      ..color = toolConfig.primaryColor.withOpacity(0.7)
      ..strokeWidth = toolConfig.strokeWidth
      ..style = PaintingStyle.stroke;
    
    switch (selectedTool) {
      case EditorTool.crop:
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        
        // Draw crop overlay - darken everything outside crop area
        final canvasRect = Rect.fromLTWH(0, 0, 800, 600);
        final overlayPaint = Paint()
          ..color = Colors.black.withOpacity(0.5)
          ..style = PaintingStyle.fill;
        
        // Draw overlay on all four sides of the crop rectangle
        if (rect.top > 0) {
          canvas.drawRect(Rect.fromLTRB(canvasRect.left, canvasRect.top, canvasRect.right, rect.top), overlayPaint);
        }
        if (rect.bottom < canvasRect.bottom) {
          canvas.drawRect(Rect.fromLTRB(canvasRect.left, rect.bottom, canvasRect.right, canvasRect.bottom), overlayPaint);
        }
        if (rect.left > 0) {
          canvas.drawRect(Rect.fromLTRB(canvasRect.left, rect.top, rect.left, rect.bottom), overlayPaint);
        }
        if (rect.right < canvasRect.right) {
          canvas.drawRect(Rect.fromLTRB(rect.right, rect.top, canvasRect.right, rect.bottom), overlayPaint);
        }
        
        // Draw crop border
        paint
          ..color = Colors.white
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;
        canvas.drawRect(rect, paint);
        
        // Draw crop corners
        const cornerSize = 10.0;
        final cornerPaint = Paint()
          ..color = Colors.white
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke;
        
        // Top-left corner
        canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(cornerSize, 0), cornerPaint);
        canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, cornerSize), cornerPaint);
        
        // Top-right corner
        canvas.drawLine(rect.topRight, rect.topRight + const Offset(-cornerSize, 0), cornerPaint);
        canvas.drawLine(rect.topRight, rect.topRight + const Offset(0, cornerSize), cornerPaint);
        
        // Bottom-left corner
        canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(cornerSize, 0), cornerPaint);
        canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(0, -cornerSize), cornerPaint);
        
        // Bottom-right corner
        canvas.drawLine(rect.bottomRight, rect.bottomRight + const Offset(-cornerSize, 0), cornerPaint);
        canvas.drawLine(rect.bottomRight, rect.bottomRight + const Offset(0, -cornerSize), cornerPaint);
        break;
        
      case EditorTool.highlightRect:
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        paint
          ..color = toolConfig.primaryColor.withOpacity(0.3)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);
        
        paint
          ..color = toolConfig.primaryColor
          ..style = PaintingStyle.stroke;
        canvas.drawRect(rect, paint);
        break;
        
      case EditorTool.redactBlackout:
      case EditorTool.redactBlur:
      case EditorTool.redactPixelate:
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        paint
          ..color = toolConfig.primaryColor.withOpacity(0.5)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);
        break;
        
      case EditorTool.text:
        final rect = Rect.fromPoints(drawingStart!, drawingEnd!);
        paint
          ..color = toolConfig.primaryColor.withOpacity(0.2)
          ..style = PaintingStyle.fill;
        canvas.drawRect(rect, paint);
        
        paint
          ..color = toolConfig.primaryColor
          ..style = PaintingStyle.stroke;
        canvas.drawRect(rect, paint);
        break;
        
      case EditorTool.numberLabel:
        // Draw number label preview as a circle at the starting point
        final radius = toolConfig.toolSpecificSettings['circleRadius']?.toDouble() ?? 16.0;
        final backgroundColor = toolConfig.secondaryColor;
        
        // Draw background circle
        final backgroundPaint = Paint()
          ..color = backgroundColor.withOpacity(0.5)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(drawingStart!, radius, backgroundPaint);
        
        // Draw border
        final borderPaint = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0;
        canvas.drawCircle(drawingStart!, radius, borderPaint);
        
        // Draw preview number
        final numberValue = toolConfig.toolSpecificSettings['number'] ?? 1;
        final fontSize = toolConfig.toolSpecificSettings['fontSize']?.toDouble() ?? 16.0;
        final textPainter = TextPainter(
          text: TextSpan(
            text: numberValue.toString(),
            style: TextStyle(
              color: toolConfig.primaryColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: toolConfig.toolSpecificSettings['fontFamily'] as String? ?? 'Arial',
            ),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        final textOffset = Offset(
          drawingStart!.dx - textPainter.width / 2,
          drawingStart!.dy - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
        break;
      
      case EditorTool.arrow:
        // Draw arrow preview
        final start = drawingStart!;
        final end = drawingEnd!;
        
        // Draw arrow line
        canvas.drawLine(start, end, paint);
        
        // Draw arrowhead
        final arrowHeadSize = toolConfig.toolSpecificSettings['arrowHeadSize']?.toDouble() ?? 15.0;
        final arrowHeadAngle = toolConfig.toolSpecificSettings['arrowHeadAngle']?.toDouble() ?? 0.5;
        
        final direction = (end - start).direction;
        final arrowPoint1 = end + Offset.fromDirection(direction + math.pi - arrowHeadAngle, arrowHeadSize);
        final arrowPoint2 = end + Offset.fromDirection(direction + math.pi + arrowHeadAngle, arrowHeadSize);
        
        canvas.drawLine(end, arrowPoint1, paint);
        canvas.drawLine(end, arrowPoint2, paint);
        break;
      
      default:
        // No preview for other tools
        break;
    }
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}