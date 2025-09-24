import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/editor_tool.dart';
import '../models/editor_layer.dart';
import '../models/editor_command.dart';
import '../models/screenshot.dart';
import '../services/screenshot_export_service.dart';
import '../services/editor_history_service.dart';
import '../providers/screenshot_providers.dart';
import '../providers/database_provider.dart';
import '../dialogs/export_screenshot_dialog.dart';
import '../dialogs/screenshot_properties_dialog.dart';
import '../widgets/screenshot_editor/editor_canvas.dart';
import '../widgets/screenshot_editor/tool_panel.dart';
import '../widgets/screenshot_editor/layers_panel.dart';
import '../widgets/screenshot_editor/properties_panel.dart';
import '../widgets/screenshot_editor/collapsible_side_panel.dart';
import '../widgets/screenshot_editor/editor_constants.dart';
import '../widgets/screenshot_editor/drag_drop_wrapper.dart';
import '../dialogs/image_replacement_dialog.dart';

class ScreenshotEditorScreen extends ConsumerStatefulWidget {
  final String screenshotId;
  final String projectId;

  const ScreenshotEditorScreen({
    super.key,
    required this.screenshotId,
    required this.projectId,
  });

  @override
  ConsumerState<ScreenshotEditorScreen> createState() =>
      _ScreenshotEditorScreenState();
}

class _ScreenshotEditorScreenState
    extends ConsumerState<ScreenshotEditorScreen> {
  final GlobalKey _canvasKey = GlobalKey();
  EditorTool _selectedTool = EditorTool.select;
  ToolConfig _toolConfig = ToolConfig.defaultHighlight;
  String? _selectedLayerId;
  List<EditorLayer> _layers = [];
  bool _enableSnapping = true;
  bool _showGuides = true;
  bool _isVerticalGuideMode = true;
  int _nextNumberLabelValue = 1;
  final GlobalKey<CollapsibleSidePanelState> _sidePanelKey = GlobalKey();
  Rect? _activeCropBounds; // Current active crop bounds

  @override
  void initState() {
    super.initState();
    _loadScreenshotLayers();
  }

  void _loadScreenshotLayers() async {
    final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);
    if (screenshot != null && mounted) {
      setState(() {
        _layers = List.from(screenshot.layers);
        // Update next number label value based on existing number labels
        _updateNextNumberLabelValue();
        // Load saved guides and crop from metadata
        _loadGuidesFromMetadata(screenshot.metadata);
        _loadCropFromMetadata(screenshot.metadata);
      });
    }
  }

  void _loadGuidesFromMetadata(Map<String, dynamic> metadata) {
    // We need to wait for the canvas to be built before setting guides
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final canvasState = _canvasKey.currentState as dynamic;
      if (canvasState != null) {
        final verticalGuides = metadata['verticalGuides'] as List<dynamic>?;
        final horizontalGuides = metadata['horizontalGuides'] as List<dynamic>?;

        if (verticalGuides != null) {
          canvasState.setVerticalGuides(
            verticalGuides.map((e) => (e as num).toDouble()).toList()
          );
        }

        if (horizontalGuides != null) {
          canvasState.setHorizontalGuides(
            horizontalGuides.map((e) => (e as num).toDouble()).toList()
          );
        }
      }
    });
  }

  void _loadCropFromMetadata(Map<String, dynamic> metadata) {
    final activeCropData = metadata['activeCrop'] as Map<String, dynamic>?;
    if (activeCropData != null) {
      setState(() {
        _activeCropBounds = Rect.fromLTWH(
          activeCropData['left'] as double,
          activeCropData['top'] as double,
          activeCropData['width'] as double,
          activeCropData['height'] as double,
        );
      });
    }
  }

  void _updateNextNumberLabelValue() {
    int maxNumber = 0;
    for (final layer in _layers) {
      if (layer.layerType == LayerType.text) {
        final textLayer = layer as TextLayer;
        // Check if this is a number label by examining metadata
        if (textLayer.metadata['isNumberLabel'] == true) {
          final numberValue = textLayer.metadata['numberValue'] as int?;
          if (numberValue != null && numberValue > maxNumber) {
            maxNumber = numberValue;
          }
        } else {
          // Fallback: check if this is a number label by examining the text content
          final numberMatch = RegExp(r'^\d+$').firstMatch(textLayer.text);
          if (numberMatch != null) {
            final number = int.tryParse(numberMatch.group(0)!) ?? 0;
            if (number > maxNumber) {
              maxNumber = number;
            }
          }
        }
      }
    }
    _nextNumberLabelValue = maxNumber + 1;
  }

  int _getNextNumberLabelValue() {
    final currentValue = _nextNumberLabelValue;
    _nextNumberLabelValue++;
    return currentValue;
  }

  void _setNumberLabelValue(int value) {
    setState(() {
      _nextNumberLabelValue = value;
      // Update tool config if number label tool is selected
      if (_selectedTool == EditorTool.numberLabel) {
        _toolConfig = _toolConfig.copyWith(
          toolSpecificSettings: {
            ..._toolConfig.toolSpecificSettings,
            'number': value,
          },
        );
      }
    });
  }

  void _onToolSelected(EditorTool tool) {
    // Handle crop tool transitions
    final canvas = _canvasKey.currentState as dynamic;
    if (canvas != null) {
      // If switching away from crop tool, exit crop mode
      if (_selectedTool == EditorTool.crop && tool != EditorTool.crop) {
        canvas.exitCropMode();
      }
      // If switching to crop tool, enter crop mode
      else if (_selectedTool != EditorTool.crop && tool == EditorTool.crop) {
        canvas.enterCropMode();
      }
    }

    setState(() {
      _selectedTool = tool;
      _toolConfig = _getDefaultToolConfig(tool);
      // If selecting number label tool, make sure the number is current
      if (tool == EditorTool.numberLabel) {
        _toolConfig = _toolConfig.copyWith(
          toolSpecificSettings: {
            ..._toolConfig.toolSpecificSettings,
            'number': _nextNumberLabelValue,
          },
        );
      }
      // If selecting guide tool when already selected, toggle between vertical/horizontal
      if (tool == EditorTool.guide && _selectedTool == EditorTool.guide) {
        _toggleGuideMode();
      }
    });
  }

  void _onToolConfigChanged(ToolConfig config) {
    setState(() {
      _toolConfig = config;
    });
  }

  void _onLayerSelected(String? layerId) {
    setState(() {
      _selectedLayerId = layerId;
    });
  }

  void _toggleGuideMode() {
    setState(() {
      _isVerticalGuideMode = !_isVerticalGuideMode;
    });
  }

  void _onGuidesChanged() {
    // Auto-save guides when they change
    _saveChanges();
  }

  void _onCropChanged(Rect? cropBounds) {
    setState(() {
      _activeCropBounds = cropBounds;
    });
    // Auto-save crop changes
    _saveChanges();
  }

  void _onImageReplaced(ui.Image newImage) async {
    try {
      // Update the canvas with the new background image
      final canvasState = _canvasKey.currentState as dynamic;
      if (canvasState != null && canvasState.updateBackgroundImage != null) {
        canvasState.updateBackgroundImage(newImage);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Image replaced successfully (${newImage.width}×${newImage.height})',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }

      // Auto-save changes
      _saveChanges();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error replacing image: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _showImageReplacementDialog() async {
    final result = await showDialog<ui.Image>(
      context: context,
      builder: (context) => const ImageReplacementDialog(),
    );

    if (result != null) {
      _onImageReplaced(result);
    }
  }

  Future<void> _showPropertiesDialog() async {
    final screenshotAsync = ref.read(screenshotProvider(widget.screenshotId));

    screenshotAsync.when(
      data: (screenshot) async {
        if (screenshot != null) {
          await showDialog(
            context: context,
            builder: (context) => ScreenshotPropertiesDialog(
              screenshot: screenshot,
              onSave: (updatedScreenshot) {
                _updateScreenshotProperties(updatedScreenshot);
              },
            ),
          );
        }
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading screenshot data...')),
        );
      },
      error: (error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading screenshot: $error')),
        );
      },
    );
  }

  void _updateScreenshotProperties(Screenshot updatedScreenshot) {
    try {
      // Update the screenshot via provider
      ref.read(databaseProvider).updateScreenshot(updatedScreenshot, widget.projectId);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Screenshot properties updated: "${updatedScreenshot.name}"'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );

      // Refresh the screenshot data
      ref.refresh(screenshotProvider(widget.screenshotId));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating properties: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _onLayerAdded(EditorLayer layer) {
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = AddLayerCommand(
      layer,
      _addLayer,
      _removeLayer,
    );
    historyService.executeCommand(command);
  }

  void _onLayerUpdated(String layerId, EditorLayer updatedLayer) {
    setState(() {
      final index = _layers.indexWhere((l) => l.id == layerId);
      if (index != -1) {
        _layers[index] = updatedLayer;
        // Changes are saved automatically when needed
        // Can call _saveChanges() if immediate save is required
      }
    });
  }

  void _addLayer(EditorLayer layer) {
    setState(() {
      _layers.add(layer);
    });
    // No notification needed for adding layers
  }

  void _removeLayer(String layerId) {
    setState(() {
      _layers.removeWhere((layer) => layer.id == layerId);
      if (_selectedLayerId == layerId) {
        _selectedLayerId = null;
      }
    });
  }

  void _modifyLayer(EditorLayer layer) {
    setState(() {
      final index = _layers.indexWhere((l) => l.id == layer.id);
      if (index != -1) {
        _layers[index] = layer;
      }
    });
  }

  void _deleteSelectedLayer() {
    if (_selectedLayerId == null) return;
    
    final layer = _layers.firstWhere((l) => l.id == _selectedLayerId);
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = RemoveLayerCommand(
      layer,
      _addLayer,
      _removeLayer,
    );
    historyService.executeCommand(command);
  }

  void _undo() {
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    historyService.undo();
    // Force UI update after undo
    setState(() {
      // UI will rebuild with current layer state
    });
  }

  void _redo() {
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    historyService.redo();
    // Force UI update after redo
    setState(() {
      // UI will rebuild with current layer state
    });
  }

  ToolConfig _getDefaultToolConfig(EditorTool tool) {
    switch (tool) {
      case EditorTool.highlightRect:
        return ToolConfig.defaultHighlight;
      case EditorTool.text:
        return ToolConfig.defaultText;
      case EditorTool.arrow:
        return ToolConfig.defaultArrow;
      case EditorTool.numberLabel:
        return ToolConfig.defaultNumberLabel.copyWith(
          toolSpecificSettings: {
            ...ToolConfig.defaultNumberLabel.toolSpecificSettings,
            'number': _nextNumberLabelValue,
          },
        );
      case EditorTool.redactBlackout:
        return ToolConfig.defaultBlackout;
      case EditorTool.redactBlur:
        return ToolConfig.defaultBlur;
      case EditorTool.redactPixelate:
        return ToolConfig.defaultPixelate;
      default:
        return ToolConfig(tool: tool);
    }
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      // Handle tool shortcuts (when no modifier keys are pressed)
      if (!event.isControlPressed && !event.isMetaPressed && !event.isShiftPressed) {
        final shortcut = event.logicalKey.keyLabel;
        final tool = EditorTool.values.cast<EditorTool?>().firstWhere(
              (t) => t?.shortcut == shortcut,
              orElse: () => null,
            );
        
        if (tool != null) {
          // Special handling for guide tool toggle
          if (tool == EditorTool.guide && _selectedTool == EditorTool.guide) {
            _toggleGuideMode();
          } else {
            _onToolSelected(tool);
          }
          return;
        }
      }

      // Handle Shift+key shortcuts for additional tools
      if (event.isShiftPressed && !event.isControlPressed && !event.isMetaPressed) {
        final shortcut = 'Shift+${event.logicalKey.keyLabel}';
        final tool = EditorTool.values.cast<EditorTool?>().firstWhere(
              (t) => t?.shortcut == shortcut,
              orElse: () => null,
            );
        
        if (tool != null) {
          _onToolSelected(tool);
          return;
        }
      }

      // Handle modifier shortcuts
      if (event.isControlPressed || event.isMetaPressed) {
        switch (event.logicalKey.keyLabel) {
          case 'Z':
            if (event.isShiftPressed) {
              _redo();
            } else {
              _undo();
            }
            break;
          case 'Y':
            _redo();
            break;
          case 'S':
            _saveChanges();
            break;
          case 'E':
            _exportScreenshot();
            break;
          case 'A':
            // Select all layers (future implementation)
            break;
          case 'D':
            // Duplicate selected layer (future implementation)
            if (_selectedLayerId != null) {
              _duplicateSelectedLayer();
            }
            break;
          case '[':
            // Send layer backward
            if (_selectedLayerId != null) {
              _moveLayerBackward();
            }
            break;
          case ']':
            // Bring layer forward
            if (_selectedLayerId != null) {
              _moveLayerForward();
            }
            break;
        }
      }

      // Handle delete key
      if (event.logicalKey == LogicalKeyboardKey.delete ||
          event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_selectedLayerId != null) {
          _deleteSelectedLayer();
        }
      }

      // Handle escape key
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        setState(() {
          _selectedLayerId = null;
          _selectedTool = EditorTool.select;
        });
      }

      // Handle panel shortcuts (F1-F3)
      if (event.logicalKey == LogicalKeyboardKey.f1) {
        _sidePanelKey.currentState?.togglePropertiesPanel();
      } else if (event.logicalKey == LogicalKeyboardKey.f2) {
        _sidePanelKey.currentState?.toggleLayersPanel();
      } else if (event.logicalKey == LogicalKeyboardKey.f3) {
        _sidePanelKey.currentState?.toggleDisplayMode();
      }

      // Handle numeric keys for opacity
      if (event.isControlPressed && event.logicalKey.keyId >= LogicalKeyboardKey.digit1.keyId &&
          event.logicalKey.keyId <= LogicalKeyboardKey.digit9.keyId) {
        final opacity = (event.logicalKey.keyId - LogicalKeyboardKey.digit0.keyId) / 10.0;
        setState(() {
          _toolConfig = _toolConfig.copyWith(opacity: opacity);
        });
      }
    }
  }

  void _duplicateSelectedLayer() {
    if (_selectedLayerId == null) return;
    
    final layer = _layers.firstWhere((l) => l.id == _selectedLayerId);
    final now = DateTime.now();
    final duplicatedLayerId = 'layer-${now.millisecondsSinceEpoch}';
    
    EditorLayer duplicatedLayer;
    
    switch (layer.layerType) {
      case LayerType.vector:
        final vectorLayer = layer as VectorLayer;
        duplicatedLayer = VectorLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          strokeColor: vectorLayer.strokeColor,
          fillColor: vectorLayer.fillColor,
          strokeWidth: vectorLayer.strokeWidth,
          elements: vectorLayer.elements.map((e) => e.copyWith()).toList(),
          createdDate: now,
          modifiedDate: now,
        );
        break;
      case LayerType.text:
        final textLayer = layer as TextLayer;
        duplicatedLayer = TextLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          text: textLayer.text,
          textStyle: textLayer.textStyle,
          textAlign: textLayer.textAlign,
          createdDate: now,
          modifiedDate: now,
        );
        break;
      case LayerType.redaction:
        final redactionLayer = layer as RedactionLayer;
        duplicatedLayer = RedactionLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          redactionType: redactionLayer.redactionType,
          redactionColor: redactionLayer.redactionColor,
          blurRadius: redactionLayer.blurRadius,
          pixelSize: redactionLayer.pixelSize,
          createdDate: now,
          modifiedDate: now,
        );
        break;
      case LayerType.crop:
        // Crop functionality disabled - skip duplication
        return;
        break;
      case LayerType.bitmap:
        final bitmapLayer = layer as BitmapLayer;
        duplicatedLayer = BitmapLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          createdDate: now,
          modifiedDate: now,
          image: bitmapLayer.image,
          imagePath: bitmapLayer.imagePath,
        );
        break;
    }
    
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = AddLayerCommand(duplicatedLayer, _addLayer, _removeLayer);
    historyService.executeCommand(command);
  }

  void _moveLayerBackward() {
    if (_selectedLayerId == null || _layers.isEmpty) return;
    
    final currentIndex = _layers.indexWhere((l) => l.id == _selectedLayerId);
    if (currentIndex <= 0) return; // Already at the back
    
    final newIndex = currentIndex - 1;
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = MoveLayerCommand(_selectedLayerId!, currentIndex, newIndex, _moveLayer);
    historyService.executeCommand(command);
  }

  void _moveLayerForward() {
    if (_selectedLayerId == null || _layers.isEmpty) return;
    
    final currentIndex = _layers.indexWhere((l) => l.id == _selectedLayerId);
    if (currentIndex >= _layers.length - 1) return; // Already at the front
    
    final newIndex = currentIndex + 1;
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = MoveLayerCommand(_selectedLayerId!, currentIndex, newIndex, _moveLayer);
    historyService.executeCommand(command);
  }

  void _moveLayer(String layerId, int fromIndex, int toIndex) {
    setState(() {
      final layer = _layers.removeAt(fromIndex);
      _layers.insert(toIndex, layer);
    });
  }

  void _toggleLayerVisibility(String layerId) {
    final layerIndex = _layers.indexWhere((l) => l.id == layerId);
    if (layerIndex == -1) return;
    
    final layer = _layers[layerIndex];
    final updatedLayer = layer.copyWith(visible: !layer.visible);
    
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = ModifyLayerCommand(
      layer,
      updatedLayer,
      _modifyLayer,
    );
    historyService.executeCommand(command);
  }

  void _renameLayer(String layerId, String newName) {
    final layerIndex = _layers.indexWhere((l) => l.id == layerId);
    if (layerIndex == -1) return;
    
    final layer = _layers[layerIndex];
    final updatedLayer = layer.copyWith(name: newName);
    
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = ModifyLayerCommand(
      layer,
      updatedLayer,
      _modifyLayer,
    );
    historyService.executeCommand(command);
  }

  void _deleteLayerById(String layerId) {
    final layer = _layers.firstWhere((l) => l.id == layerId);
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = RemoveLayerCommand(
      layer,
      _addLayer,
      _removeLayer,
    );
    historyService.executeCommand(command);
  }

  void _revertToOriginal() {
    if (_layers.isEmpty) return;
    
    // Create composite command to remove all layers
    final allLayers = List<EditorLayer>.from(_layers);
    final commands = allLayers.map((layer) => RemoveLayerCommand(
      layer,
      _addLayer,
      _removeLayer,
    )).toList();
    
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final compositeCommand = CompositeCommand(commands, 'Revert to original');
    historyService.executeCommand(compositeCommand);
    
    // Save the screenshot after reverting
    _saveChanges();
  }

  void _duplicateLayer(String layerId) {
    final layer = _layers.firstWhere((l) => l.id == layerId);
    final now = DateTime.now();
    final duplicatedLayerId = 'layer-${now.millisecondsSinceEpoch}';
    
    EditorLayer duplicatedLayer;
    
    switch (layer.layerType) {
      case LayerType.vector:
        final vectorLayer = layer as VectorLayer;
        duplicatedLayer = VectorLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          strokeColor: vectorLayer.strokeColor,
          fillColor: vectorLayer.fillColor,
          strokeWidth: vectorLayer.strokeWidth,
          elements: vectorLayer.elements.map((e) => e.copyWith()).toList(),
          createdDate: now,
          modifiedDate: now,
        );
        break;
      case LayerType.text:
        final textLayer = layer as TextLayer;
        duplicatedLayer = TextLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          text: textLayer.text,
          textStyle: textLayer.textStyle,
          textAlign: textLayer.textAlign,
          createdDate: now,
          modifiedDate: now,
        );
        break;
      case LayerType.redaction:
        final redactionLayer = layer as RedactionLayer;
        duplicatedLayer = RedactionLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          redactionType: redactionLayer.redactionType,
          redactionColor: redactionLayer.redactionColor,
          blurRadius: redactionLayer.blurRadius,
          pixelSize: redactionLayer.pixelSize,
          createdDate: now,
          modifiedDate: now,
        );
        break;
      case LayerType.crop:
        // Crop functionality disabled - skip duplication
        return;
        break;
      case LayerType.bitmap:
        final bitmapLayer = layer as BitmapLayer;
        duplicatedLayer = BitmapLayer(
          id: duplicatedLayerId,
          name: '${layer.name} Copy',
          visible: layer.visible,
          locked: layer.locked,
          opacity: layer.opacity,
          blendModeType: layer.blendModeType,
          bounds: layer.bounds != null ? layer.bounds.translate(10, 10) : Rect.fromLTWH(10, 10, 100, 100),
          image: bitmapLayer.image,
          imagePath: bitmapLayer.imagePath,
          createdDate: now,
          modifiedDate: now,
        );
        break;
    }
    
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = AddLayerCommand(
      duplicatedLayer,
      _addLayer,
      _removeLayer,
    );
    historyService.executeCommand(command);
  }

  void _reorderLayer(String layerId, int oldIndex, int newIndex) {
    final historyService = ref.read(editorHistoryProvider(widget.screenshotId));
    final command = MoveLayerCommand(layerId, oldIndex, newIndex, _moveLayer);
    historyService.executeCommand(command);
  }

  void _saveChanges() async {
    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Saving changes...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }

      // Get current screenshot data
      final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);
      if (screenshot == null) {
        throw Exception('Screenshot not found');
      }

      // Get current guides from canvas
      final canvasState = _canvasKey.currentState as dynamic;
      final currentVerticalGuides = canvasState?.verticalGuides as List<double>? ?? <double>[];
      final currentHorizontalGuides = canvasState?.horizontalGuides as List<double>? ?? <double>[];
      
      // Create updated metadata with guides and crop bounds
      final updatedMetadata = Map<String, dynamic>.from(screenshot.metadata);
      updatedMetadata['verticalGuides'] = currentVerticalGuides;
      updatedMetadata['horizontalGuides'] = currentHorizontalGuides;

      // Save active crop bounds
      if (_activeCropBounds != null) {
        updatedMetadata['activeCrop'] = {
          'left': _activeCropBounds!.left,
          'top': _activeCropBounds!.top,
          'width': _activeCropBounds!.width,
          'height': _activeCropBounds!.height,
        };
      } else {
        updatedMetadata.remove('activeCrop'); // Remove crop if null
      }

      // Create updated screenshot with current layers and guides
      final updatedScreenshot = screenshot.copyWith(
        layers: _layers,
        metadata: updatedMetadata,
        modifiedDate: DateTime.now(),
      );

      // Save to database
      final database = ref.read(databaseProvider);
      await database.updateScreenshot(updatedScreenshot, widget.projectId);

      // Invalidate providers to refresh data
      ref.invalidate(screenshotProvider(widget.screenshotId));
      ref.invalidate(projectScreenshotsProvider(widget.projectId));

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                const Text('Changes saved successfully'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to save: $e')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
          ),
        );
      }
    }
  }

  void _exportScreenshot() async {
    try {
      // Get current screenshot data first
      final screenshot = await ref.read(screenshotProvider(widget.screenshotId).future);
      if (screenshot == null) {
        throw Exception('Screenshot not found');
      }

      // Show export dialog
      final exportOptions = await showDialog<ExportOptions>(
        context: context,
        builder: (context) => ExportScreenshotDialog(
          defaultFilename: screenshot.name.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_'),
        ),
      );

      if (exportOptions == null) {
        // User cancelled
        return;
      }

      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Text('Exporting screenshot...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      // Load the background image
      final backgroundImage = await _loadBackgroundImage(screenshot.originalPath);
      
      // Render the screenshot with all layers
      final renderedImage = await ScreenshotExportService.renderScreenshotWithLayers(
        screenshot, 
        backgroundImage,
      );
      
      // Export based on selected format
      final Uint8List imageData;
      switch (exportOptions.format) {
        case ExportFormat.png:
          imageData = await ScreenshotExportService.exportToPng(renderedImage);
          break;
        case ExportFormat.jpeg:
          imageData = await ScreenshotExportService.exportToJpeg(
            renderedImage, 
            quality: exportOptions.quality,
          );
          break;
      }
      
      // Save the file
      final savedPath = await ScreenshotExportService.saveToFile(
        imageData, 
        exportOptions.filename,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.download_done, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(savedPath)),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'OK',
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Theme.of(context).colorScheme.onError),
                const SizedBox(width: 8),
                Expanded(child: Text('Export failed: $e')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  Future<ui.Image> _loadBackgroundImage(String assetPath) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      final ui.Codec codec = await ui.instantiateImageCodec(bytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      return frameInfo.image;
    } catch (e) {
      throw Exception('Failed to load background image: $e');
    }
  }

  void _applyCrop() {
    final canvas = _canvasKey.currentState as dynamic;
    if (canvas != null && canvas.hasPendingCrop) {
      canvas.applyCrop();
      canvas.exitCropMode(); // Exit crop mode before switching tool
      // Switch back to select tool after applying crop
      setState(() {
        _selectedTool = EditorTool.select;
      });
    }
  }

  void _cancelCrop() {
    final canvas = _canvasKey.currentState as dynamic;
    if (canvas != null) {
      canvas.cancelCrop();
      canvas.exitCropMode(); // Exit crop mode before switching tool
      // Switch back to select tool after canceling crop
      setState(() {
        _selectedTool = EditorTool.select;
      });
    }
  }

  bool get _hasPendingCrop {
    final canvas = _canvasKey.currentState as dynamic;
    return canvas?.hasPendingCrop ?? false;
  }

  bool get _isCropToolActive {
    return _selectedTool == EditorTool.crop;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 768;

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: _handleKeyPress,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          foregroundColor: theme.colorScheme.onSurface,
          elevation: 1,
          shadowColor: theme.colorScheme.shadow,
          title: Row(
            children: [
              Icon(
                Icons.photo_camera,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Screenshot Editor - ${widget.screenshotId}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            Consumer(
              builder: (context, ref, child) {
                final historyService = ref.watch(editorHistoryProvider(widget.screenshotId));
                return IconButton(
                  onPressed: historyService.canUndo ? _undo : null,
                  icon: const Icon(Icons.undo),
                  tooltip: historyService.canUndo 
                      ? 'Undo ${historyService.undoDescription} (Ctrl+Z)'
                      : 'Undo (Ctrl+Z)',
                );
              },
            ),
            Consumer(
              builder: (context, ref, child) {
                final historyService = ref.watch(editorHistoryProvider(widget.screenshotId));
                return IconButton(
                  onPressed: historyService.canRedo ? _redo : null,
                  icon: const Icon(Icons.redo),
                  tooltip: historyService.canRedo 
                      ? 'Redo ${historyService.redoDescription} (Ctrl+Y)'
                      : 'Redo (Ctrl+Y)',
                );
              },
            ),
            
            // Crop controls - shown when crop tool is active
            if (_isCropToolActive) ...[
              const SizedBox(width: 8),
              // Apply crop button (tick icon like Photoshop) - always enabled when crop tool is active
              IconButton(
                onPressed: _applyCrop,
                icon: const Icon(Icons.check_circle),
                iconSize: 32,
                color: _hasPendingCrop ? Colors.green : Colors.grey,
                tooltip: 'Apply crop (Enter)',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(width: 4),
              // Cancel crop button (X icon like Photoshop)
              IconButton(
                onPressed: _cancelCrop,
                icon: const Icon(Icons.cancel),
                iconSize: 32,
                color: Colors.red,
                tooltip: 'Cancel crop (Esc)',
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.8),
                ),
              ),
            ],

            // Image replacement button
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _showImageReplacementDialog,
              icon: const Icon(Icons.image, size: 18),
              label: const Text('Replace Image'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _showPropertiesDialog,
              icon: const Icon(Icons.settings, size: 18),
              label: const Text('Properties'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save, size: 18),
              label: const Text('Save'),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: _exportScreenshot,
              icon: const Icon(Icons.download, size: 18),
              label: const Text('Export'),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // Tool Panel
        Container(
          width: EditorConstants.toolPanelWidth,
          color: theme.colorScheme.surfaceContainer,
          child: ToolPanel(
            selectedTool: _selectedTool,
            onToolSelected: _onToolSelected,
            isVerticalGuideMode: _isVerticalGuideMode,
            onGuideToolTapped: _toggleGuideMode,
          ),
        ),
        
        // Canvas Area
        Expanded(
          child: Container(
            color: const Color(0xFF2A2A2A),
            child: Column(
              children: [
                // Zoom Controls
                Container(
                  height: EditorConstants.zoomBarHeight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => (_canvasKey.currentState as dynamic)?.zoomOut(),
                        icon: const Icon(Icons.zoom_out),
                        tooltip: 'Zoom Out',
                      ),
                      DropdownButton<String>(
                        value: '100',
                        items: const [
                          DropdownMenuItem(value: '25', child: Text('25%')),
                          DropdownMenuItem(value: '50', child: Text('50%')),
                          DropdownMenuItem(value: '75', child: Text('75%')),
                          DropdownMenuItem(value: '100', child: Text('100%')),
                          DropdownMenuItem(value: '150', child: Text('150%')),
                          DropdownMenuItem(value: '200', child: Text('200%')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            final zoomLevel = double.parse(value) / 100.0;
                            (_canvasKey.currentState as dynamic)?.setZoom(zoomLevel);
                          }
                        },
                        underline: Container(),
                      ),
                      IconButton(
                        onPressed: () => (_canvasKey.currentState as dynamic)?.zoomIn(),
                        icon: const Icon(Icons.zoom_in),
                        tooltip: 'Zoom In',
                      ),
                      const Spacer(),
                      
                      // Canvas Control Buttons
                      _buildCanvasToggle(
                        context,
                        'Snap',
                        Icons.auto_awesome,
                        _enableSnapping,
                        (value) => setState(() => _enableSnapping = value),
                      ),
                      const SizedBox(width: 8),
                      _buildCanvasToggle(
                        context,
                        'Guides',
                        Icons.straighten,
                        _showGuides,
                        (value) => setState(() => _showGuides = value),
                      ),
                      
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () => (_canvasKey.currentState as dynamic)?.fitToCanvas(),
                        icon: const Icon(Icons.fit_screen),
                        tooltip: 'Fit to Canvas',
                      ),
                      IconButton(
                        onPressed: () => (_canvasKey.currentState as dynamic)?.actualSize(),
                        icon: const Icon(Icons.fullscreen),
                        tooltip: 'Actual Size',
                      ),
                    ],
                  ),
                ),
                
                // Canvas with Overlay Controls
                Expanded(
                  child: Stack(
                    children: [
                      DragDropWrapper(
                        onImageDropped: _onImageReplaced,
                        child: EditorCanvas(
                          key: _canvasKey,
                          screenshotId: widget.screenshotId,
                          projectId: widget.projectId,
                          selectedTool: _selectedTool,
                          toolConfig: _toolConfig,
                          layers: _layers,
                          onLayerAdded: _onLayerAdded,
                          onLayerUpdated: _onLayerUpdated,
                          onLayerSelected: _onLayerSelected,
                          enableSnapping: _enableSnapping,
                          showGuides: _showGuides,
                          isVerticalGuideMode: _isVerticalGuideMode,
                          onGuideToolTapped: _toggleGuideMode,
                          getNextNumberLabelValue: _getNextNumberLabelValue,
                          onGuidesChanged: _onGuidesChanged,
                          onCropChanged: _onCropChanged,
                          initialCropBounds: _activeCropBounds,
                          onImageReplaced: _onImageReplaced,
                          onCropStateChanged: () => WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {})),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Right Panel - Collapsible
        CollapsibleSidePanel(
          key: _sidePanelKey,
          propertiesPanel: PropertiesPanel(
            selectedTool: _selectedTool,
            toolConfig: _toolConfig,
            onConfigChanged: _onToolConfigChanged,
            selectedLayerId: _selectedLayerId,
            currentNumberLabelValue: _selectedTool == EditorTool.numberLabel ? _nextNumberLabelValue : null,
            onNumberLabelValueChanged: _selectedTool == EditorTool.numberLabel ? _setNumberLabelValue : null,
          ),
          layersPanel: LayersPanel(
            screenshotId: widget.screenshotId,
            projectId: widget.projectId,
            layers: _layers,
            selectedLayerId: _selectedLayerId,
            onLayerSelected: _onLayerSelected,
            onLayerVisibilityToggle: _toggleLayerVisibility,
            onLayerRename: _renameLayer,
            onLayerDelete: _deleteLayerById,
            onLayerDuplicate: _duplicateLayer,
            onLayerReorder: _reorderLayer,
            onRevert: _revertToOriginal,
          ),
          propertiesTitle: 'Properties',
          layersTitle: 'Layers',
          propertiesIcon: Icons.tune,
          layersIcon: Icons.layers,
          width: EditorConstants.sidePanelDefaultWidth,
          minWidth: 200,
          maxWidth: 400,
          initialMode: PanelDisplayMode.tabbed,
          keyboardShortcuts: const {
            'toggle_properties': 'F1',
            'toggle_layers': 'F2',
            'toggle_mode': 'F3',
          },
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Mobile Tool Bar
        Container(
          height: 60,
          color: theme.colorScheme.surfaceContainer,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: EditorTool.values.map((tool) {
                final isSelected = _selectedTool == tool;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: IconButton(
                    onPressed: () => _onToolSelected(tool),
                    icon: Icon(tool.icon),
                    style: IconButton.styleFrom(
                      backgroundColor: isSelected 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      foregroundColor: isSelected 
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                    tooltip: tool.displayName,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        
        // Canvas Area
        Expanded(
          child: Container(
            color: const Color(0xFF2A2A2A),
            child: DragDropWrapper(
              onImageDropped: _onImageReplaced,
              child: EditorCanvas(
                key: _canvasKey,
                screenshotId: widget.screenshotId,
                projectId: widget.projectId,
                selectedTool: _selectedTool,
                toolConfig: _toolConfig,
                layers: _layers,
                onLayerAdded: _onLayerAdded,
                onLayerUpdated: _onLayerUpdated,
                onLayerSelected: _onLayerSelected,
                isVerticalGuideMode: _isVerticalGuideMode,
                onGuideToolTapped: _toggleGuideMode,
                getNextNumberLabelValue: _getNextNumberLabelValue,
                onCropChanged: _onCropChanged,
                initialCropBounds: _activeCropBounds,
                onImageReplaced: _onImageReplaced,
                onCropStateChanged: () => WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {})),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCanvasToggle(
    BuildContext context,
    String label,
    IconData icon,
    bool isEnabled,
    ValueChanged<bool> onToggle,
  ) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        onTap: () => onToggle(!isEnabled),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isEnabled 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isEnabled 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: isEnabled ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}