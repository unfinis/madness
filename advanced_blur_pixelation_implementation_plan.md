# Implementation Plan for Advanced Blur and Pixelation Effects

## Phase 1: Enhanced Blur Implementation

### 1. Multi-pass Blur for Large Radii
For blur radii greater than 10px, implement multi-pass blur to maintain quality:

```dart
void applyMultiPassBlur(Canvas canvas, Rect bounds, double radius) {
  // Split large radius into multiple smaller passes
  final passes = (radius / 10).ceil();
  final sigmaPerPass = _radiusToSigma(radius) / passes;
  
  canvas.saveLayer(bounds, Paint());
  for (int i = 0; i < passes; i++) {
    final paint = Paint()
      ..imageFilter = ui.ImageFilter.blur(
        sigmaX: sigmaPerPass,
        sigmaY: sigmaPerPass,
        tileMode: TileMode.decal,
      );
    canvas.saveLayer(bounds, paint);
    // Draw content
    canvas.restore();
  }
  canvas.restore();
}
```

### 2. Proper Background Sampling
Enhance the blur effect to properly sample the background image:

```dart
Future<void> _applyAdvancedBlur(
  Canvas canvas,
  RedactionLayer layer,
  ui.Image backgroundImage,
  Size canvasSize,
) async {
  // Calculate proper image coordinates as in the current implementation
  final imageSize = Size(backgroundImage.width.toDouble(), backgroundImage.height.toDouble());
  
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
  
  // For large blur radii, use multi-pass approach
  if (layer.blurRadius > 10) {
    _applyMultiPassBlur(canvas, layer, backgroundImage, srcRect);
  } else {
    // Use single pass for smaller radii
    final sigma = _radiusToSigma(layer.blurRadius);
    final blurPaint = Paint()
      ..imageFilter = ui.ImageFilter.blur(
        sigmaX: sigma, 
        sigmaY: sigma, 
        tileMode: TileMode.decal
      );
    
    canvas.saveLayer(layer.bounds!, blurPaint);
    canvas.drawImageRect(backgroundImage, srcRect, layer.bounds!, Paint());
    canvas.restore();
  }
}

void _applyMultiPassBlur(
  Canvas canvas,
  RedactionLayer layer,
  ui.Image backgroundImage,
  Rect srcRect,
) {
  final passes = (layer.blurRadius / 10).ceil();
  final sigmaPerPass = _radiusToSigma(layer.blurRadius) / passes;
  
  canvas.saveLayer(layer.bounds!, Paint());
  for (int i = 0; i < passes; i++) {
    final paint = Paint()
      ..imageFilter = ui.ImageFilter.blur(
        sigmaX: sigmaPerPass,
        sigmaY: sigmaPerPass,
        tileMode: TileMode.decal,
      );
    canvas.saveLayer(layer.bounds!, paint);
    canvas.drawImageRect(backgroundImage, srcRect, layer.bounds!, Paint());
    canvas.restore();
  }
  canvas.restore();
}
```

## Phase 2: Advanced Pixelation with Actual Sampling

### 1. True Pixel Block Averaging

```dart
Future<Color> _calculateTrueAverageColor(
  ui.Image image,
  Rect srcRect,
) async {
  // This would require access to actual pixel data
  // In a real implementation, you would:
  // 1. Use image.toByteData() to get pixel data
  // 2. Sample all pixels in the rect
  // 3. Calculate average RGB values
  // 4. Return the averaged color
  
  // For now, we'll use a more sophisticated placeholder
  final centerX = srcRect.center.dx.clamp(0.0, image.width - 1.0);
  final centerY = srcRect.center.dy.clamp(0.0, image.height - 1.0);
  
  // Sample multiple points and average them
  final points = [
    Offset(centerX, centerY),
    Offset(srcRect.left, srcRect.top),
    Offset(srcRect.right - 1, srcRect.top),
    Offset(srcRect.left, srcRect.bottom - 1),
    Offset(srcRect.right - 1, srcRect.bottom - 1),
  ];
  
  int r = 0, g = 0, b = 0;
  for (final point in points) {
    final x = point.dx.clamp(0.0, image.width - 1.0);
    final y = point.dy.clamp(0.0, image.height - 1.0);
    r += ((x * 255) % 255).toInt();
    g += ((y * 255) % 255).toInt();
    b += (((x + y) * 127) % 255).toInt();
  }
  
  return Color.fromRGBO(
    (r / points.length).toInt(),
    (g / points.length).toInt(),
    (b / points.length).toInt(),
    1.0,
  );
}
```

### 2. Precomputed Pixel Blocks for Performance

```dart
class PixelatedBlock {
  final Rect bounds;
  final Color averageColor;
  
  PixelatedBlock(this.bounds, this.averageColor);
}

class PixelationCache {
  final Map<String, List<PixelatedBlock>> _cache = {};
  
  String _generateKey(Rect bounds, int pixelSize) {
    return '${bounds.left},${bounds.top},${bounds.right},${bounds.bottom},$pixelSize';
  }
  
  void cacheBlocks(Rect bounds, int pixelSize, List<PixelatedBlock> blocks) {
    final key = _generateKey(bounds, pixelSize);
    _cache[key] = blocks;
  }
  
  List<PixelatedBlock>? getBlocks(Rect bounds, int pixelSize) {
    final key = _generateKey(bounds, pixelSize);
    return _cache[key];
  }
  
  void clear() {
    _cache.clear();
  }
}
```

## Phase 3: Asynchronous Processing

### 1. Background Processing for Large Areas

```dart
Future<List<PixelatedBlock>> _computePixelationAsync(
  ui.Image backgroundImage,
  Rect bounds,
  int pixelSize,
  Size canvasSize,
) async {
  // Move heavy computation to background
  return compute(_computePixelationIsolate, 
    PixelationParams(backgroundImage, bounds, pixelSize, canvasSize));
}

class PixelationParams {
  final ui.Image backgroundImage;
  final Rect bounds;
  final int pixelSize;
  final Size canvasSize;
  
  PixelationParams(this.backgroundImage, this.bounds, this.pixelSize, this.canvasSize);
}

// This would run in an isolate
List<PixelatedBlock> _computePixelationIsolate(PixelationParams params) {
  // Implementation of pixelation computation
  // This is a simplified version - actual implementation would be more complex
  final blocks = <PixelatedBlock>[];
  
  // Perform pixelation calculations
  for (double x = params.bounds.left; x < params.bounds.right; x += params.pixelSize) {
    for (double y = params.bounds.top; y < params.bounds.bottom; y += params.pixelSize) {
      final pixelRect = Rect.fromLTWH(
        x,
        y,
        math.min(params.pixelSize.toDouble(), params.bounds.right - x),
        math.min(params.pixelSize.toDouble(), params.bounds.bottom - y),
      );
      
      // Calculate average color (simplified)
      final avgColor = Color.fromRGBO(128, 128, 128, 1.0); // Placeholder
      blocks.add(PixelatedBlock(pixelRect, avgColor));
    }
  }
  
  return blocks;
}
```

## Phase 4: Coordinate Transformation Improvements

### 1. Robust Coordinate Conversion

```dart
class CoordinateTransformer {
  final ui.Image backgroundImage;
  final Size canvasSize;
  
  CoordinateTransformer(this.backgroundImage, this.canvasSize);
  
  // Convert canvas coordinates to image coordinates
  Rect canvasToImageRect(Rect canvasRect) {
    final imageSize = Size(backgroundImage.width.toDouble(), backgroundImage.height.toDouble());
    
    // Calculate scaling
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;
    final scale = math.min<double>(scaleX, scaleY);
    final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
    final imageOffset = Offset(
      (canvasSize.width - scaledSize.width) / 2,
      (canvasSize.height - scaledSize.height) / 2,
    );
    
    return Rect.fromLTWH(
      (canvasRect.left - imageOffset.dx) / scale,
      (canvasRect.top - imageOffset.dy) / scale,
      canvasRect.width / scale,
      canvasRect.height / scale,
    );
  }
  
  // Convert image coordinates to canvas coordinates
  Rect imageToCanvasRect(Rect imageRect) {
    final imageSize = Size(backgroundImage.width.toDouble(), backgroundImage.height.toDouble());
    
    // Calculate scaling
    final scaleX = canvasSize.width / imageSize.width;
    final scaleY = canvasSize.height / imageSize.height;
    final scale = math.min<double>(scaleX, scaleY);
    final scaledSize = Size(imageSize.width * scale, imageSize.height * scale);
    final imageOffset = Offset(
      (canvasSize.width - scaledSize.width) / 2,
      (canvasSize.height - scaledSize.height) / 2,
    );
    
    return Rect.fromLTWH(
      imageRect.left * scale + imageOffset.dx,
      imageRect.top * scale + imageOffset.dy,
      imageRect.width * scale,
      imageRect.height * scale,
    );
  }
}
```

## Implementation Priority

1. **Phase 1** (High Priority): Implement proper sigma calculation and multi-pass blur
2. **Phase 2** (High Priority): Replace placeholder pixelation with better sampling
3. **Phase 3** (Medium Priority): Add caching mechanism for performance
4. **Phase 4** (Low Priority): Implement asynchronous processing for very large areas
5. **Phase 5** (Medium Priority): Improve coordinate transformation accuracy

This approach will significantly improve the quality and performance of blur and pixelation effects while maintaining compatibility with the existing codebase.