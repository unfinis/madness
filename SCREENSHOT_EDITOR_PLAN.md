# Screenshot Editor Implementation Plan

## 📋 Overview
The Screenshot Editor is the most complex module in the Madness application, providing professional-grade image editing capabilities specifically designed for penetration testing documentation. This plan breaks down implementation into manageable stages while ensuring architectural soundness.

## 🎯 Core Features Summary

### Essential Features (MVP)
- Layer-based editing with bitmap, vector, text, and redaction layers
- Basic redaction tools (blackout, blur, pixelate)
- Simple annotations (arrows, text callouts, numbered labels)
- Canvas manipulation (zoom, pan, basic transforms)
- Export functionality with metadata stripping

### Advanced Features (Post-MVP)
- Snapping system with smart guides
- Advanced redaction (hash patterns, text replacement)
- Curved arrows with object attachment
- Severity-based styling presets
- Edge-aware snapping (UI element detection)

## 🏗️ Architecture Overview

### Technology Stack
- **Canvas Engine**: Custom Flutter CustomPainter + gesture handling
- **State Management**: Riverpod with complex state for editor
- **File Handling**: Local file system with secure export
- **Database**: Drift integration for screenshot metadata
- **Image Processing**: Flutter's dart:ui + custom algorithms

### Core Components
1. **ScreenshotEditor** - Main editor screen with full-screen canvas
2. **LayerSystem** - Layer management and rendering
3. **ToolSystem** - Tool selection and behavior
4. **CanvasRenderer** - Custom painter for canvas rendering
5. **ExportSystem** - Secure export with metadata stripping

## 📁 File Structure
```
lib/
├── screens/
│   └── screenshot_editor_screen.dart
├── widgets/
│   ├── screenshot_editor/
│   │   ├── editor_canvas.dart
│   │   ├── editor_toolbar.dart
│   │   ├── layer_panel.dart
│   │   ├── properties_panel.dart
│   │   └── tool_panels/
│   │       ├── redaction_tool_panel.dart
│   │       ├── annotation_tool_panel.dart
│   │       └── transform_tool_panel.dart
├── models/
│   ├── screenshot.dart
│   ├── editor_layer.dart
│   ├── editor_tool.dart
│   └── canvas_state.dart
├── services/
│   ├── screenshot_service.dart
│   ├── layer_service.dart
│   ├── export_service.dart
│   └── image_processing_service.dart
├── providers/
│   ├── screenshot_editor_provider.dart
│   ├── layer_provider.dart
│   └── tool_provider.dart
└── utils/
    ├── canvas_utils.dart
    ├── geometry_utils.dart
    └── security_utils.dart
```

## 🚀 Implementation Stages

### Stage 1: Foundation & Basic Canvas (Week 1-2)
**Goal**: Establish core architecture and basic canvas functionality

#### Tasks:
1. **Database Schema Extension**
   - Add screenshot table with metadata
   - Layer storage schema
   - Edit history tracking

2. **Basic Models**
   ```dart
   // Screenshot model with layers
   // EditorLayer base class with subclasses
   // CanvasState for viewport management
   // Tool enums and configurations
   ```

3. **Core Canvas Implementation**
   - CustomPainter-based canvas renderer
   - Basic gesture handling (pan, zoom)
   - Image loading and display
   - Coordinate system management

4. **Basic UI Shell**
   - Editor screen layout (toolbar, canvas, panels)
   - Tool selection buttons
   - Layer panel placeholder
   - Basic navigation

#### Deliverables:
- ✅ Load and display images on canvas
- ✅ Pan and zoom functionality
- ✅ Basic tool selection UI
- ✅ Layer structure foundation

### Stage 2: Layer System & Basic Tools (Week 3-4)
**Goal**: Implement layer management and basic drawing tools

#### Tasks:
1. **Layer System Implementation**
   - Layer rendering pipeline
   - Layer creation, deletion, reordering
   - Visibility toggle and locking
   - Layer selection and manipulation

2. **Basic Redaction Tools**
   - Blackout rectangles (solid color)
   - Simple blur tool (gaussian blur)
   - Pixelation tool (mosaic effect)
   - Brush-based redaction

3. **Layer Panel UI**
   - Layer list with drag-to-reorder
   - Visibility and lock toggles
   - Layer thumbnails
   - Context menus

4. **Basic Annotation Tools**
   - Rectangle and ellipse shapes
   - Straight arrow tool
   - Text tool with basic formatting
   - Color picker for all tools

#### Deliverables:
- ✅ Working layer system with reordering
- ✅ Basic redaction tools (blackout, blur, pixelate)
- ✅ Simple shape and arrow tools
- ✅ Text annotation capability

### Stage 3: Advanced Annotations & Export (Week 5-6)
**Goal**: Implement sophisticated annotation tools and secure export

#### Tasks:
1. **Advanced Annotation Features**
   - Auto-incrementing number labels
   - Callout boxes with leader lines
   - Multi-point arrows (orthogonal routing)
   - Severity-based styling presets

2. **Properties Panel**
   - Tool-specific property editors
   - Color schemes and presets
   - Stroke width, opacity controls
   - Text formatting options

3. **Export System Implementation**
   - Metadata stripping for security
   - Multiple format support (PNG, JPG, PDF)
   - Layer flattening options
   - Secure temp file handling

4. **Undo/Redo System**
   - Command pattern implementation
   - History management
   - State serialization

#### Deliverables:
- ✅ Professional annotation tools
- ✅ Secure export functionality
- ✅ Undo/redo system
- ✅ Property panels for all tools

### Stage 4: Precision Features & Polish (Week 7-8)
**Goal**: Add precision tools and professional polish

#### Tasks:
1. **Snapping System**
   - Grid snapping with configurable spacing
   - Object edge and center snapping
   - Smart guides with distance display
   - Keyboard nudging (fine/coarse)

2. **Advanced Redaction**
   - Hash pattern redaction
   - Text replacement (••• pattern)
   - Custom pattern support
   - Irreversible redaction modes

3. **Performance Optimization**
   - Canvas rendering optimization
   - Large image handling
   - Memory management
   - Smooth animations

4. **Professional Features**
   - Ruler and measurement tools
   - Alignment helpers
   - Batch operations
   - Template system

#### Deliverables:
- ✅ Precision snapping system
- ✅ Advanced redaction options
- ✅ Optimized performance
- ✅ Professional-grade features

### Stage 5: Integration & Future Features (Week 9+)
**Goal**: Integrate with main app and implement nice-to-have features

#### Tasks:
1. **App Integration**
   - Screenshot management screen
   - Finding associations
   - Report generation integration
   - Cross-screen navigation

2. **Edge-Aware Snapping (Future)**
   - Computer vision for UI element detection
   - Smart bounding box detection
   - Context-aware snapping suggestions
   - Machine learning model integration

3. **Advanced Export Options**
   - Batch export processing
   - Custom export templates
   - Cloud storage integration
   - Automated report insertion

## 🔧 Technical Considerations

### Performance Challenges
- **Large Image Handling**: Implement tile-based rendering for very large screenshots
- **Layer Composition**: Optimize layer blending and caching
- **Memory Management**: Implement proper disposal and caching strategies
- **Smooth Interactions**: 60fps canvas updates during manipulation

### Security Requirements
- **Metadata Stripping**: Remove all EXIF and embedded metadata
- **Secure Redaction**: Ensure redacted content is truly irreversible
- **Temp File Management**: Secure handling of temporary files
- **Export Validation**: Verify no sensitive data leaks

### Platform Considerations
- **Desktop First**: Optimized for desktop with keyboard shortcuts
- **Mobile Adaptation**: Touch-optimized tools and gestures
- **File System Access**: Platform-specific file handling
- **Memory Constraints**: Graceful handling on lower-end devices

## 📝 Data Models

### Core Models Structure
```dart
// Screenshot metadata and layers
class Screenshot {
  String id;
  String projectId;
  String name;
  String originalPath;
  List<EditorLayer> layers;
  CanvasState canvasState;
  Map<String, dynamic> metadata;
  DateTime created;
  DateTime modified;
}

// Base layer class
abstract class EditorLayer {
  String id;
  String name;
  bool visible;
  bool locked;
  double opacity;
  BlendMode blendMode;
  Rect bounds;
}

// Specific layer types
class BitmapLayer extends EditorLayer { ... }
class VectorLayer extends EditorLayer { ... }
class TextLayer extends EditorLayer { ... }
class RedactionLayer extends EditorLayer { ... }
```

## 🎨 UI/UX Considerations

### Design Principles
- **Professional Feel**: Dark theme optimized for image editing
- **Keyboard-First**: Comprehensive keyboard shortcuts
- **Context Aware**: Tool panels adapt to selected layer/tool
- **Non-Destructive**: All edits preserve original image

### Responsive Design
- **Desktop (≥1200px)**: Full feature set with all panels
- **Tablet (768-1199px)**: Collapsible panels, gesture optimized
- **Mobile (<768px)**: Essential tools only, touch-first design

## 🔄 Integration Points

### Database Integration
- Extend existing Drift schema with screenshot tables
- Link screenshots to findings and projects
- Store layer data and edit history
- Maintain file path references

### Provider Architecture
- Screenshot management providers
- Editor state providers (canvas, tools, layers)
- Integration with existing project providers
- Cross-screen data flow

### Export Integration
- Report generation system
- Evidence package creation
- Finding documentation workflow
- Batch processing capabilities

## 📊 Success Metrics

### Technical Metrics
- Canvas rendering at 60fps during interactions
- Support for images up to 50MP without performance degradation
- Layer operations complete within 100ms
- Export operations complete within 5 seconds

### User Experience Metrics
- Intuitive tool discovery (minimal learning curve)
- Efficient annotation workflow (annotations in under 30 seconds)
- Reliable redaction (zero data leaks in security testing)
- Professional output quality (meets industry standards)

## 🚨 Risk Mitigation

### Technical Risks
- **Canvas Performance**: Implement progressive rendering and LOD
- **Memory Usage**: Implement smart caching and disposal
- **Platform Differences**: Extensive cross-platform testing
- **Complex State**: Careful state management architecture

### Security Risks
- **Data Leaks**: Comprehensive redaction testing
- **Metadata Exposure**: Multiple validation layers
- **File Handling**: Secure temporary file practices
- **Export Integrity**: Automated verification processes

## 📅 Timeline Summary

- **Weeks 1-2**: Foundation & Canvas (25% complete)
- **Weeks 3-4**: Layers & Basic Tools (50% complete)
- **Weeks 5-6**: Annotations & Export (75% complete)
- **Weeks 7-8**: Precision & Polish (90% complete)
- **Week 9+**: Integration & Advanced Features (100% complete)

This plan provides a solid foundation for implementing a professional-grade screenshot editor while maintaining manageable complexity and clear milestones.