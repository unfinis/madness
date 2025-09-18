import 'package:flutter/material.dart';

class CanvasState {
  final double zoom;
  final Offset pan;
  final Size canvasSize;
  final Size imageSize;
  final bool showGrid;
  final bool snapToGrid;
  final double gridSpacing;
  final Color gridColor;
  final double minZoom;
  final double maxZoom;

  const CanvasState({
    this.zoom = 1.0,
    this.pan = Offset.zero,
    required this.canvasSize,
    required this.imageSize,
    this.showGrid = false,
    this.snapToGrid = false,
    this.gridSpacing = 20.0,
    this.gridColor = const Color(0x33FFFFFF),
    this.minZoom = 0.1,
    this.maxZoom = 10.0,
  });

  factory CanvasState.initial({Size? imageSize}) {
    return CanvasState(
      canvasSize: const Size(800, 600),
      imageSize: imageSize ?? const Size(800, 600),
    );
  }

  CanvasState copyWith({
    double? zoom,
    Offset? pan,
    Size? canvasSize,
    Size? imageSize,
    bool? showGrid,
    bool? snapToGrid,
    double? gridSpacing,
    Color? gridColor,
    double? minZoom,
    double? maxZoom,
  }) {
    return CanvasState(
      zoom: zoom ?? this.zoom,
      pan: pan ?? this.pan,
      canvasSize: canvasSize ?? this.canvasSize,
      imageSize: imageSize ?? this.imageSize,
      showGrid: showGrid ?? this.showGrid,
      snapToGrid: snapToGrid ?? this.snapToGrid,
      gridSpacing: gridSpacing ?? this.gridSpacing,
      gridColor: gridColor ?? this.gridColor,
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
    );
  }

  // Viewport calculations
  Rect get visibleBounds {
    final topLeft = screenToCanvas(Offset.zero);
    final bottomRight = screenToCanvas(Offset(canvasSize.width, canvasSize.height));
    return Rect.fromPoints(topLeft, bottomRight);
  }

  Matrix4 get transformMatrix {
    final matrix = Matrix4.identity();
    matrix.translate(pan.dx, pan.dy);
    matrix.scale(zoom);
    return matrix;
  }

  Matrix4 get inverseTransformMatrix {
    final matrix = Matrix4.identity();
    matrix.scale(1.0 / zoom);
    matrix.translate(-pan.dx / zoom, -pan.dy / zoom);
    return matrix;
  }

  // Coordinate transformations
  Offset screenToCanvas(Offset screenPoint) {
    return (screenPoint - pan) / zoom;
  }

  Offset canvasToScreen(Offset canvasPoint) {
    return (canvasPoint * zoom) + pan;
  }

  Rect screenToCanvasRect(Rect screenRect) {
    final topLeft = screenToCanvas(screenRect.topLeft);
    final bottomRight = screenToCanvas(screenRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }

  Rect canvasToScreenRect(Rect canvasRect) {
    final topLeft = canvasToScreen(canvasRect.topLeft);
    final bottomRight = canvasToScreen(canvasRect.bottomRight);
    return Rect.fromPoints(topLeft, bottomRight);
  }

  Size screenToCanvasSize(Size screenSize) {
    return Size(screenSize.width / zoom, screenSize.height / zoom);
  }

  Size canvasToScreenSize(Size canvasSize) {
    return Size(canvasSize.width * zoom, canvasSize.height * zoom);
  }

  // Zoom operations
  CanvasState zoomTo(double newZoom, {Offset? center}) {
    final clampedZoom = newZoom.clamp(minZoom, maxZoom);
    
    if (center != null) {
      // Zoom around a specific point
      final canvasPoint = screenToCanvas(center);
      final newPan = center - (canvasPoint * clampedZoom);
      return copyWith(zoom: clampedZoom, pan: newPan);
    } else {
      // Zoom around canvas center
      final centerPoint = Offset(canvasSize.width / 2, canvasSize.height / 2);
      return zoomTo(clampedZoom, center: centerPoint);
    }
  }

  CanvasState zoomBy(double factor, {Offset? center}) {
    return zoomTo(zoom * factor, center: center);
  }

  CanvasState zoomIn({Offset? center}) {
    return zoomBy(1.2, center: center);
  }

  CanvasState zoomOut({Offset? center}) {
    return zoomBy(0.8, center: center);
  }

  CanvasState fitToCanvas() {
    if (imageSize.isEmpty || canvasSize.isEmpty) return this;
    
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;
    final scale = (scaleX < scaleY ? scaleX : scaleY) * 0.9; // 90% to leave some margin
    
    final scaledImageSize = imageSize * scale;
    final centerOffset = Offset(
      (canvasSize.width - scaledImageSize.width) / 2,
      (canvasSize.height - scaledImageSize.height) / 2,
    );
    
    return copyWith(
      zoom: scale,
      pan: centerOffset,
    );
  }

  CanvasState fitWidth() {
    if (imageSize.isEmpty || canvasSize.isEmpty) return this;
    
    final scale = canvasSize.width / imageSize.width * 0.95;
    final scaledImageHeight = imageSize.height * scale;
    final centerY = (canvasSize.height - scaledImageHeight) / 2;
    
    return copyWith(
      zoom: scale,
      pan: Offset(0, centerY),
    );
  }

  CanvasState actualSize() {
    return copyWith(
      zoom: 1.0,
      pan: Offset(
        (canvasSize.width - imageSize.width) / 2,
        (canvasSize.height - imageSize.height) / 2,
      ),
    );
  }

  // Pan operations
  CanvasState panBy(Offset delta) {
    return copyWith(pan: pan + delta);
  }

  CanvasState centerOn(Offset canvasPoint) {
    final screenCenter = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final newPan = screenCenter - (canvasPoint * zoom);
    return copyWith(pan: newPan);
  }

  // Grid operations
  Offset snapToGridPoint(Offset point) {
    if (!snapToGrid) return point;
    
    final snappedX = (point.dx / gridSpacing).round() * gridSpacing;
    final snappedY = (point.dy / gridSpacing).round() * gridSpacing;
    return Offset(snappedX, snappedY);
  }

  List<double> get gridLinesX {
    if (!showGrid) return [];
    
    final bounds = visibleBounds;
    final lines = <double>[];
    
    final startX = (bounds.left / gridSpacing).floor() * gridSpacing;
    final endX = (bounds.right / gridSpacing).ceil() * gridSpacing;
    
    for (double x = startX; x <= endX; x += gridSpacing) {
      lines.add(x);
    }
    
    return lines;
  }

  List<double> get gridLinesY {
    if (!showGrid) return [];
    
    final bounds = visibleBounds;
    final lines = <double>[];
    
    final startY = (bounds.top / gridSpacing).floor() * gridSpacing;
    final endY = (bounds.bottom / gridSpacing).ceil() * gridSpacing;
    
    for (double y = startY; y <= endY; y += gridSpacing) {
      lines.add(y);
    }
    
    return lines;
  }

  // Utility methods
  bool get isZoomedIn => zoom > 1.0;
  bool get isZoomedOut => zoom < 1.0;
  bool get canZoomIn => zoom < maxZoom;
  bool get canZoomOut => zoom > minZoom;

  // Image bounds in canvas coordinates
  Rect get imageBounds {
    return Rect.fromLTWH(0, 0, imageSize.width, imageSize.height);
  }

  // Check if a canvas point is within the image bounds
  bool isPointInImage(Offset canvasPoint) {
    return imageBounds.contains(canvasPoint);
  }

  // Get the portion of the image that's visible
  Rect get visibleImageBounds {
    return visibleBounds.intersect(imageBounds);
  }

  @override
  String toString() {
    return 'CanvasState(zoom: $zoom, pan: $pan, canvasSize: $canvasSize, imageSize: $imageSize)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CanvasState &&
        other.zoom == zoom &&
        other.pan == pan &&
        other.canvasSize == canvasSize &&
        other.imageSize == imageSize &&
        other.showGrid == showGrid &&
        other.snapToGrid == snapToGrid &&
        other.gridSpacing == gridSpacing;
  }

  @override
  int get hashCode {
    return Object.hash(
      zoom,
      pan,
      canvasSize,
      imageSize,
      showGrid,
      snapToGrid,
      gridSpacing,
    );
  }
}