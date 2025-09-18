# Stage 1: Foundation & Basic Canvas - Detailed Tasks

## 🎯 Stage 1 Goal
Establish core architecture and basic canvas functionality for the screenshot editor.

## 📋 Detailed Task Breakdown

### Task 1.1: Database Schema Extension
**Estimated Time**: 2-3 hours

#### Subtasks:
1. **Add Screenshot Table**
   ```dart
   @DataClassName('ScreenshotRow')
   class ScreenshotsTable extends Table {
     TextColumn get id => text()();
     TextColumn get projectId => text().references(ProjectsTable, #id)();
     TextColumn get name => text()();
     TextColumn get description => text().nullable()();
     TextColumn get originalPath => text().named('original_path')();
     TextColumn get editedPath => text().named('edited_path').nullable()();
     TextColumn get thumbnailPath => text().named('thumbnail_path').nullable()();
     IntColumn get width => integer()();
     IntColumn get height => integer()();
     IntColumn get fileSize => integer().named('file_size')();
     TextColumn get fileFormat => text().named('file_format')();
     DateTimeColumn get captureDate => dateTime().named('capture_date')();
     DateTimeColumn get createdDate => dateTime().named('created_date')();
     DateTimeColumn get modifiedDate => dateTime().named('modified_date')();
     TextColumn get tags => text().withDefault(const Constant(''))();
     BoolColumn get hasRedactions => boolean().named('has_redactions').withDefault(const Constant(false))();
     BoolColumn get isProcessed => boolean().named('is_processed').withDefault(const Constant(false))();
     TextColumn get metadata => text().withDefault(const Constant('{}'))();
     
     @override
     Set<Column> get primaryKey => {id};
   }
   ```

2. **Add Editor Layers Table**
   ```dart
   @DataClassName('EditorLayerRow')
   class EditorLayersTable extends Table {
     TextColumn get id => text()();
     TextColumn get screenshotId => text().named('screenshot_id').references(ScreenshotsTable, #id)();
     TextColumn get layerType => text().named('layer_type')(); // 'bitmap', 'vector', 'text', 'redaction'
     TextColumn get name => text()();
     IntColumn get orderIndex => integer().named('order_index')();
     BoolColumn get visible => boolean().withDefault(const Constant(true))();
     BoolColumn get locked => boolean().withDefault(const Constant(false))();
     RealColumn get opacity => real().withDefault(const Constant(1.0))();
     TextColumn get blendMode => text().named('blend_mode').withDefault(const Constant('normal'))();
     TextColumn get layerData => text().named('layer_data')(); // JSON serialized layer-specific data
     DateTimeColumn get createdDate => dateTime().named('created_date')();
     DateTimeColumn get modifiedDate => dateTime().named('modified_date')();
     
     @override
     Set<Column> get primaryKey => {id};
   }
   ```

3. **Add Screenshot-Finding Association Table**
   ```dart
   @DataClassName('ScreenshotFindingRow')
   class ScreenshotFindingsTable extends Table {
     TextColumn get screenshotId => text().named('screenshot_id').references(ScreenshotsTable, #id)();
     TextColumn get findingId => text().named('finding_id')(); // Reference to findings system
     TextColumn get annotationId => text().named('annotation_id').nullable()(); // Reference to specific annotation
     DateTimeColumn get linkedDate => dateTime().named('linked_date')();
     
     @override
     Set<Column> get primaryKey => {screenshotId, findingId};
   }
   ```

### Task 1.2: Core Data Models
**Estimated Time**: 3-4 hours

#### Subtasks:
1. **Screenshot Model**
   ```dart
   class Screenshot {
     final String id;
     final String projectId;
     final String name;
     final String description;
     final String originalPath;
     final String? editedPath;
     final String? thumbnailPath;
     final int width;
     final int height;
     final int fileSize;
     final String fileFormat;
     final DateTime captureDate;
     final DateTime createdDate;
     final DateTime modifiedDate;
     final Set<String> tags;
     final bool hasRedactions;
     final bool isProcessed;
     final Map<String, dynamic> metadata;
     final List<EditorLayer> layers;
   
     // Methods for layer management
     Screenshot addLayer(EditorLayer layer);
     Screenshot removeLayer(String layerId);
     Screenshot updateLayer(EditorLayer layer);
     Screenshot reorderLayers(List<String> layerIds);
   }
   ```

2. **Editor Layer Base Class**
   ```dart
   abstract class EditorLayer {
     final String id;
     final String name;
     final bool visible;
     final bool locked;
     final double opacity;
     final BlendMode blendMode;
     final Rect bounds;
     final DateTime createdDate;
     final DateTime modifiedDate;
   
     // Abstract methods for rendering and serialization
     void render(Canvas canvas, Paint paint);
     Map<String, dynamic> toJson();
     static EditorLayer fromJson(Map<String, dynamic> json);
   }
   ```

3. **Canvas State Model**
   ```dart
   class CanvasState {
     final double zoom;
     final Offset pan;
     final Size canvasSize;
     final Size imageSize;
     final bool showGrid;
     final bool snapToGrid;
     final double gridSpacing;
     
     // Viewport calculations
     Rect get visibleBounds;
     Matrix4 get transformMatrix;
     Offset screenToCanvas(Offset screenPoint);
     Offset canvasToScreen(Offset canvasPoint);
   }
   ```

4. **Tool Configuration Models**
   ```dart
   enum EditorTool {
     select,
     pan,
     highlightRect,
     highlightBrush,
     arrow,
     text,
     redactBlackout,
     redactBlur,
     redactPixelate,
   }
   
   class ToolConfig {
     final EditorTool tool;
     final Color primaryColor;
     final Color secondaryColor;
     final double strokeWidth;
     final double opacity;
     final Map<String, dynamic> toolSpecificSettings;
   }
   ```

### Task 1.3: Basic Canvas Implementation
**Estimated Time**: 4-5 hours

#### Subtasks:
1. **Custom Canvas Painter**
   ```dart
   class EditorCanvasPainter extends CustomPainter {
     final Screenshot screenshot;
     final CanvasState canvasState;
     final ui.Image? backgroundImage;
     final EditorTool activeTool;
     
     @override
     void paint(Canvas canvas, Size size) {
       // Draw background grid if enabled
       _drawGrid(canvas, size);
       
       // Draw background image
       if (backgroundImage != null) {
         _drawBackgroundImage(canvas, size);
       }
       
       // Draw layers in order
       for (final layer in screenshot.layers) {
         if (layer.visible) {
           _drawLayer(canvas, layer);
         }
       }
       
       // Draw active tool overlay
       _drawToolOverlay(canvas, size);
     }
     
     @override
     bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
   }
   ```

2. **Gesture Handler Widget**
   ```dart
   class EditorCanvas extends StatefulWidget {
     final Screenshot screenshot;
     final Function(CanvasState) onCanvasStateChanged;
     final Function(EditorLayer) onLayerAdded;
     final Function(String) onLayerSelected;
     
     @override
     _EditorCanvasState createState() => _EditorCanvasState();
   }
   
   class _EditorCanvasState extends State<EditorCanvas> {
     CanvasState _canvasState = CanvasState.initial();
     
     void _handlePanStart(DragStartDetails details) { /* ... */ }
     void _handlePanUpdate(DragUpdateDetails details) { /* ... */ }
     void _handleScaleStart(ScaleStartDetails details) { /* ... */ }
     void _handleScaleUpdate(ScaleUpdateDetails details) { /* ... */ }
   }
   ```

3. **Coordinate System Management**
   ```dart
   class CoordinateSystem {
     final CanvasState state;
     
     CoordinateSystem(this.state);
     
     Offset screenToCanvas(Offset screenPoint) {
       return (screenPoint - state.pan) / state.zoom;
     }
     
     Offset canvasToScreen(Offset canvasPoint) {
       return (canvasPoint * state.zoom) + state.pan;
     }
     
     Rect screenToCanvas(Rect screenRect) { /* ... */ }
     Rect canvasToScreen(Rect canvasRect) { /* ... */ }
   }
   ```

### Task 1.4: Basic UI Shell
**Estimated Time**: 3-4 hours

#### Subtasks:
1. **Editor Screen Layout**
   ```dart
   class ScreenshotEditorScreen extends ConsumerStatefulWidget {
     final String screenshotId;
     
     @override
     ConsumerState<ScreenshotEditorScreen> createState() => _ScreenshotEditorScreenState();
   }
   
   class _ScreenshotEditorScreenState extends ConsumerState<ScreenshotEditorScreen> {
     @override
     Widget build(BuildContext context) {
       return Scaffold(
         backgroundColor: Colors.grey[900], // Dark theme for editing
         body: Row(
           children: [
             // Left toolbar (60px wide)
             EditorToolbar(
               activeTool: _activeTool,
               onToolSelected: _handleToolSelected,
             ),
             
             // Main canvas area
             Expanded(
               flex: 3,
               child: EditorCanvas(
                 screenshot: _screenshot,
                 onCanvasStateChanged: _handleCanvasStateChanged,
                 onLayerAdded: _handleLayerAdded,
               ),
             ),
             
             // Right panels (300px wide, collapsible)
             EditorRightPanel(
               screenshot: _screenshot,
               onLayerSelectionChanged: _handleLayerSelectionChanged,
               onLayerPropertiesChanged: _handleLayerPropertiesChanged,
             ),
           ],
         ),
         
         // Top app bar
         appBar: EditorAppBar(
           screenshotName: _screenshot.name,
           onSave: _handleSave,
           onExport: _handleExport,
           onUndo: _handleUndo,
           onRedo: _handleRedo,
         ),
       );
     }
   }
   ```

2. **Toolbar Component**
   ```dart
   class EditorToolbar extends StatelessWidget {
     final EditorTool activeTool;
     final Function(EditorTool) onToolSelected;
     
     @override
     Widget build(BuildContext context) {
       return Container(
         width: 60,
         color: Colors.grey[850],
         padding: EdgeInsets.all(8),
         child: Column(
           children: [
             _buildToolButton(EditorTool.select, Icons.mouse, 'Select'),
             _buildToolButton(EditorTool.pan, Icons.pan_tool, 'Pan'),
             Divider(),
             _buildToolButton(EditorTool.highlightRect, Icons.crop_square, 'Highlight'),
             _buildToolButton(EditorTool.arrow, Icons.arrow_forward, 'Arrow'),
             _buildToolButton(EditorTool.text, Icons.text_fields, 'Text'),
             Divider(),
             _buildToolButton(EditorTool.redactBlackout, Icons.block, 'Blackout'),
             _buildToolButton(EditorTool.redactBlur, Icons.blur_on, 'Blur'),
             _buildToolButton(EditorTool.redactPixelate, Icons.grid_on, 'Pixelate'),
           ],
         ),
       );
     }
   }
   ```

3. **Layer Panel Placeholder**
   ```dart
   class LayerPanel extends StatelessWidget {
     final Screenshot screenshot;
     final String? selectedLayerId;
     final Function(String) onLayerSelected;
     
     @override
     Widget build(BuildContext context) {
       return Container(
         width: 300,
         color: Colors.grey[800],
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             // Panel header
             Container(
               padding: EdgeInsets.all(16),
               child: Text(
                 'Layers',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ),
             
             // Layer list
             Expanded(
               child: ListView.builder(
                 itemCount: screenshot.layers.length,
                 itemBuilder: (context, index) {
                   final layer = screenshot.layers[index];
                   return _buildLayerItem(layer);
                 },
               ),
             ),
           ],
         ),
       );
     }
   }
   ```

### Task 1.5: Image Loading and Display
**Estimated Time**: 2-3 hours

#### Subtasks:
1. **Image Service**
   ```dart
   class ImageService {
     static Future<ui.Image> loadImageFromPath(String path) async {
       final bytes = await File(path).readAsBytes();
       final codec = await ui.instantiateImageCodec(bytes);
       final frame = await codec.getNextFrame();
       return frame.image;
     }
     
     static Future<String> generateThumbnail(String imagePath, {int maxSize = 300}) async {
       // Generate thumbnail and save to temp directory
     }
     
     static Future<Map<String, dynamic>> extractImageMetadata(String path) async {
       // Extract EXIF and other metadata
     }
   }
   ```

2. **Background Image Rendering**
   ```dart
   void _drawBackgroundImage(Canvas canvas, Size canvasSize) {
     if (backgroundImage == null) return;
     
     final imageRect = Rect.fromLTWH(0, 0, backgroundImage!.width.toDouble(), backgroundImage!.height.toDouble());
     final canvasRect = Rect.fromLTWH(0, 0, canvasSize.width, canvasSize.height);
     
     // Apply canvas transformation
     canvas.save();
     canvas.transform(_canvasState.transformMatrix.storage);
     
     // Draw image with proper scaling
     paintImage(
       canvas: canvas,
       rect: _calculateImageBounds(),
       image: backgroundImage!,
       fit: BoxFit.contain,
     );
     
     canvas.restore();
   }
   ```

## 🎯 Stage 1 Deliverables Checklist

### Database
- [ ] Screenshot table schema implemented
- [ ] Editor layers table schema implemented  
- [ ] Database migration scripts created
- [ ] CRUD operations for screenshots

### Models
- [ ] Screenshot model with layer management
- [ ] EditorLayer base class defined
- [ ] CanvasState model implemented
- [ ] Tool configuration models

### Canvas
- [ ] CustomPainter for canvas rendering
- [ ] Pan and zoom gesture handling
- [ ] Coordinate system management
- [ ] Image loading and display

### UI
- [ ] Editor screen layout structure
- [ ] Basic toolbar with tool selection
- [ ] Layer panel placeholder
- [ ] Dark theme implementation

### Integration
- [ ] Provider setup for editor state
- [ ] Navigation from screenshots list
- [ ] Basic save/load functionality
- [ ] Error handling and loading states

## 🚨 Critical Success Criteria

1. **Image Display**: Successfully load and display screenshots on canvas
2. **Navigation**: Smooth pan and zoom without performance issues  
3. **Tool Selection**: Functional tool switching with visual feedback
4. **Foundation**: Solid architecture ready for layer implementation
5. **Performance**: 60fps interactions on desktop, 30fps+ on mobile

## 🔄 Testing Strategy

### Unit Tests
- Canvas coordinate transformations
- Image loading and metadata extraction
- Model serialization/deserialization
- Database CRUD operations

### Integration Tests
- End-to-end screenshot loading workflow
- Canvas rendering with various image sizes
- Tool selection and state management
- Provider integration

### Performance Tests
- Large image loading (50MB+)
- Pan/zoom performance benchmarks
- Memory usage monitoring
- Canvas rendering frame rates

## 📝 Implementation Notes

### Performance Considerations
- Implement image caching for frequently accessed screenshots
- Use RepaintBoundary widgets to isolate canvas repaints
- Consider implementing tile-based rendering for very large images
- Profile memory usage during image operations

### Security Considerations
- Validate image files before loading to prevent exploits
- Implement secure temporary file handling
- Ensure proper cleanup of cached images
- Validate image dimensions to prevent memory exhaustion

This detailed breakdown provides clear, actionable tasks for implementing the foundation of the screenshot editor. Each task includes specific code structure guidance and measurable deliverables.