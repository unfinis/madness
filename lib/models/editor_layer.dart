import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum LayerType {
  bitmap,
  vector,
  text,
  redaction,
  crop,
}

enum BlendModeType {
  normal,
  multiply,
  screen,
  overlay,
  softLight,
  hardLight,
  colorDodge,
  colorBurn,
  darken,
  lighten,
  difference,
  exclusion,
}

extension BlendModeTypeExtension on BlendModeType {
  BlendMode get blendMode {
    switch (this) {
      case BlendModeType.normal:
        return BlendMode.srcOver;
      case BlendModeType.multiply:
        return BlendMode.multiply;
      case BlendModeType.screen:
        return BlendMode.screen;
      case BlendModeType.overlay:
        return BlendMode.overlay;
      case BlendModeType.softLight:
        return BlendMode.softLight;
      case BlendModeType.hardLight:
        return BlendMode.hardLight;
      case BlendModeType.colorDodge:
        return BlendMode.colorDodge;
      case BlendModeType.colorBurn:
        return BlendMode.colorBurn;
      case BlendModeType.darken:
        return BlendMode.darken;
      case BlendModeType.lighten:
        return BlendMode.lighten;
      case BlendModeType.difference:
        return BlendMode.difference;
      case BlendModeType.exclusion:
        return BlendMode.exclusion;
    }
  }
}

abstract class EditorLayer {
  final String id;
  final String name;
  final LayerType layerType;
  final bool visible;
  final bool locked;
  final double opacity;
  final BlendModeType blendModeType;
  final Rect bounds;
  final DateTime createdDate;
  final DateTime modifiedDate;

  const EditorLayer({
    required this.id,
    required this.name,
    required this.layerType,
    required this.visible,
    required this.locked,
    required this.opacity,
    required this.blendModeType,
    required this.bounds,
    required this.createdDate,
    required this.modifiedDate,
  });

  // Abstract methods that subclasses must implement
  void render(Canvas canvas, Paint paint);
  Map<String, dynamic> layerDataToJson();
  
  EditorLayer copyWith({
    String? name,
    bool? visible,
    bool? locked,
    double? opacity,
    BlendModeType? blendModeType,
    Rect? bounds,
  });

  // Common serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'layerType': layerType.name,
      'visible': visible,
      'locked': locked,
      'opacity': opacity,
      'blendModeType': blendModeType.name,
      'bounds': {
        'left': bounds.left,
        'top': bounds.top,
        'right': bounds.right,
        'bottom': bounds.bottom,
      },
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'layerData': layerDataToJson(),
    };
  }

  // Factory method to create layer from JSON
  static EditorLayer fromJson(Map<String, dynamic> json) {
    final layerType = LayerType.values.byName(json['layerType'] as String);
    final bounds = Rect.fromLTRB(
      json['bounds']['left'] as double,
      json['bounds']['top'] as double,
      json['bounds']['right'] as double,
      json['bounds']['bottom'] as double,
    );

    switch (layerType) {
      case LayerType.vector:
        return VectorLayer.fromJson(json, bounds);
      case LayerType.text:
        return TextLayer.fromJson(json, bounds);
      case LayerType.redaction:
        return RedactionLayer.fromJson(json, bounds);
      case LayerType.crop:
        return CropLayer.fromJson(json, bounds);
      case LayerType.bitmap:
        return BitmapLayer.fromJson(json, bounds);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditorLayer && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Vector layer for shapes, arrows, highlights
class VectorLayer extends EditorLayer {
  final List<VectorElement> elements;
  final Color strokeColor;
  final Color fillColor;
  final double strokeWidth;
  final Map<String, dynamic> metadata;

  const VectorLayer({
    required super.id,
    required super.name,
    required super.visible,
    required super.locked,
    required super.opacity,
    required super.blendModeType,
    required super.bounds,
    required super.createdDate,
    required super.modifiedDate,
    required this.elements,
    required this.strokeColor,
    required this.fillColor,
    required this.strokeWidth,
    this.metadata = const {},
  }) : super(layerType: LayerType.vector);

  @override
  void render(Canvas canvas, Paint paint) {
    canvas.save();
    
    // Apply layer opacity and blend mode
    paint.color = strokeColor.withValues(alpha: opacity);
    paint.strokeWidth = strokeWidth;
    paint.style = PaintingStyle.stroke;

    for (final element in elements) {
      element.render(canvas, paint);
    }

    canvas.restore();
  }

  @override
  Map<String, dynamic> layerDataToJson() {
    return {
      'elements': elements.map((e) => e.toJson()).toList(),
      'strokeColor': strokeColor.value,
      'fillColor': fillColor.value,
      'strokeWidth': strokeWidth,
      'metadata': metadata,
    };
  }

  @override
  VectorLayer copyWith({
    String? name,
    bool? visible,
    bool? locked,
    double? opacity,
    BlendModeType? blendModeType,
    Rect? bounds,
    List<VectorElement>? elements,
    Color? strokeColor,
    Color? fillColor,
    double? strokeWidth,
    Map<String, dynamic>? metadata,
  }) {
    return VectorLayer(
      id: id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      opacity: opacity ?? this.opacity,
      blendModeType: blendModeType ?? this.blendModeType,
      bounds: bounds ?? this.bounds,
      createdDate: createdDate,
      modifiedDate: DateTime.now(),
      elements: elements ?? this.elements,
      strokeColor: strokeColor ?? this.strokeColor,
      fillColor: fillColor ?? this.fillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      metadata: metadata ?? this.metadata,
    );
  }

  static VectorLayer fromJson(Map<String, dynamic> json, Rect bounds) {
    final layerData = json['layerData'] as Map<String, dynamic>;
    return VectorLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool,
      locked: json['locked'] as bool,
      opacity: json['opacity'] as double,
      blendModeType: BlendModeType.values.byName(json['blendModeType'] as String),
      bounds: bounds,
      createdDate: DateTime.parse(json['createdDate'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      elements: (layerData['elements'] as List)
          .map((e) => VectorElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      strokeColor: Color(layerData['strokeColor'] as int),
      fillColor: Color(layerData['fillColor'] as int),
      strokeWidth: layerData['strokeWidth'] as double,
      metadata: layerData['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}

// Text layer for annotations
class TextLayer extends EditorLayer {
  final String text;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final Map<String, dynamic> metadata;

  const TextLayer({
    required super.id,
    required super.name,
    required super.visible,
    required super.locked,
    required super.opacity,
    required super.blendModeType,
    required super.bounds,
    required super.createdDate,
    required super.modifiedDate,
    required this.text,
    required this.textStyle,
    required this.textAlign,
    this.metadata = const {},
  }) : super(layerType: LayerType.text);

  @override
  void render(Canvas canvas, Paint paint) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: textStyle.copyWith(color: textStyle.color?.withValues(alpha: opacity)),
      ),
      textAlign: textAlign,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: bounds.width);
    textPainter.paint(canvas, bounds.topLeft);
  }

  @override
  Map<String, dynamic> layerDataToJson() {
    return {
      'text': text,
      'textStyle': {
        'fontSize': textStyle.fontSize,
        'fontWeight': textStyle.fontWeight?.index,
        'color': textStyle.color?.value,
        'fontFamily': textStyle.fontFamily,
      },
      'textAlign': textAlign.index,
      'metadata': metadata,
    };
  }

  @override
  TextLayer copyWith({
    String? name,
    bool? visible,
    bool? locked,
    double? opacity,
    BlendModeType? blendModeType,
    Rect? bounds,
    String? text,
    TextStyle? textStyle,
    TextAlign? textAlign,
    Map<String, dynamic>? metadata,
  }) {
    return TextLayer(
      id: id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      opacity: opacity ?? this.opacity,
      blendModeType: blendModeType ?? this.blendModeType,
      bounds: bounds ?? this.bounds,
      createdDate: createdDate,
      modifiedDate: DateTime.now(),
      text: text ?? this.text,
      textStyle: textStyle ?? this.textStyle,
      textAlign: textAlign ?? this.textAlign,
      metadata: metadata ?? this.metadata,
    );
  }

  static TextLayer fromJson(Map<String, dynamic> json, Rect bounds) {
    final layerData = json['layerData'] as Map<String, dynamic>;
    final textStyleData = layerData['textStyle'] as Map<String, dynamic>;
    
    return TextLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool,
      locked: json['locked'] as bool,
      opacity: json['opacity'] as double,
      blendModeType: BlendModeType.values.byName(json['blendModeType'] as String),
      bounds: bounds,
      createdDate: DateTime.parse(json['createdDate'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      text: layerData['text'] as String,
      textStyle: TextStyle(
        fontSize: textStyleData['fontSize'] as double?,
        fontWeight: textStyleData['fontWeight'] != null
            ? FontWeight.values[textStyleData['fontWeight'] as int]
            : null,
        color: textStyleData['color'] != null
            ? Color(textStyleData['color'] as int)
            : null,
        fontFamily: textStyleData['fontFamily'] as String?,
      ),
      textAlign: TextAlign.values[layerData['textAlign'] as int],
      metadata: layerData['metadata'] as Map<String, dynamic>? ?? {},
    );
  }
}

// Redaction layer for security
class RedactionLayer extends EditorLayer {
  final RedactionType redactionType;
  final Color redactionColor;
  final double blurRadius;
  final int pixelSize;

  const RedactionLayer({
    required super.id,
    required super.name,
    required super.visible,
    required super.locked,
    required super.opacity,
    required super.blendModeType,
    required super.bounds,
    required super.createdDate,
    required super.modifiedDate,
    required this.redactionType,
    required this.redactionColor,
    required this.blurRadius,
    required this.pixelSize,
  }) : super(layerType: LayerType.redaction);

  @override
  void render(Canvas canvas, Paint paint) {
    switch (redactionType) {
      case RedactionType.blackout:
        paint.color = redactionColor.withValues(alpha: opacity);
        paint.style = PaintingStyle.fill;
        canvas.drawRect(bounds, paint);
        break;
      case RedactionType.blur:
        // TODO: Implement blur effect
        paint.color = redactionColor.withValues(alpha: opacity * 0.5);
        paint.style = PaintingStyle.fill;
        canvas.drawRect(bounds, paint);
        break;
      case RedactionType.pixelate:
        // Draw pixelated effect using block-based rendering
        final pixelSize = this.pixelSize.toDouble();
        for (double x = bounds.left; x < bounds.right; x += pixelSize) {
          for (double y = bounds.top; y < bounds.bottom; y += pixelSize) {
            final pixelRect = Rect.fromLTWH(
              x,
              y,
              math.min(pixelSize, bounds.right - x),
              math.min(pixelSize, bounds.bottom - y),
            );

            // Use a position-based color for consistency with other implementations
            final blockColor = _generateBlockColor(x.toInt(), y.toInt());
            paint.color = blockColor.withValues(alpha: opacity);
            paint.style = PaintingStyle.fill;
            canvas.drawRect(pixelRect, paint);
          }
        }
        break;
    }
  }

  @override
  Map<String, dynamic> layerDataToJson() {
    return {
      'redactionType': redactionType.name,
      'redactionColor': redactionColor.value,
      'blurRadius': blurRadius,
      'pixelSize': pixelSize,
    };
  }

  @override
  RedactionLayer copyWith({
    String? name,
    bool? visible,
    bool? locked,
    double? opacity,
    BlendModeType? blendModeType,
    Rect? bounds,
    RedactionType? redactionType,
    Color? redactionColor,
    double? blurRadius,
    int? pixelSize,
  }) {
    return RedactionLayer(
      id: id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      opacity: opacity ?? this.opacity,
      blendModeType: blendModeType ?? this.blendModeType,
      bounds: bounds ?? this.bounds,
      createdDate: createdDate,
      modifiedDate: DateTime.now(),
      redactionType: redactionType ?? this.redactionType,
      redactionColor: redactionColor ?? this.redactionColor,
      blurRadius: blurRadius ?? this.blurRadius,
      pixelSize: pixelSize ?? this.pixelSize,
    );
  }

  static RedactionLayer fromJson(Map<String, dynamic> json, Rect bounds) {
    final layerData = json['layerData'] as Map<String, dynamic>;
    return RedactionLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool,
      locked: json['locked'] as bool,
      opacity: json['opacity'] as double,
      blendModeType: BlendModeType.values.byName(json['blendModeType'] as String),
      bounds: bounds,
      createdDate: DateTime.parse(json['createdDate'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      redactionType: RedactionType.values.byName(layerData['redactionType'] as String),
      redactionColor: Color(layerData['redactionColor'] as int),
      blurRadius: layerData['blurRadius'] as double,
      pixelSize: layerData['pixelSize'] as int,
    );
  }

  Color _generateBlockColor(int x, int y) {
    // Generate consistent pixelated colors that match the other implementations
    final normalizedX = x / 800.0; // Assume 800px width
    final normalizedY = y / 600.0; // Assume 600px height

    // Use sine functions to create natural color variation
    final baseR = (math.sin(normalizedX * math.pi * 2) * 64 + 128).toInt().clamp(0, 255);
    final baseG = (math.cos(normalizedY * math.pi * 1.5) * 64 + 128).toInt().clamp(0, 255);
    final baseB = (math.sin((normalizedX + normalizedY) * math.pi) * 64 + 128).toInt().clamp(0, 255);

    // Add variation and regional consistency
    final hashValue = (x * 73 + y * 37) % 256;
    final variation = (hashValue / 8 - 16).toInt(); // +/- 16 variation

    final regionX = (x / 50).floor();
    final regionY = (y / 50).floor();
    final regionHash = (regionX * 31 + regionY * 17) % 256;
    final regionBias = regionHash / 4; // 0-64 range

    final r = (baseR + variation + regionBias / 4).clamp(0, 255);
    final g = (baseG + variation + regionBias / 3).clamp(0, 255);
    final b = (baseB + variation + regionBias / 2).clamp(0, 255);

    return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 1.0);
  }
}

// Bitmap layer for raster elements
class BitmapLayer extends EditorLayer {
  final ui.Image? image;
  final String? imagePath;

  const BitmapLayer({
    required super.id,
    required super.name,
    required super.visible,
    required super.locked,
    required super.opacity,
    required super.blendModeType,
    required super.bounds,
    required super.createdDate,
    required super.modifiedDate,
    this.image,
    this.imagePath,
  }) : super(layerType: LayerType.bitmap);

  @override
  void render(Canvas canvas, Paint paint) {
    if (image != null) {
      paint.color = Color.fromRGBO(255, 255, 255, opacity);
      canvas.drawImageRect(
        image!,
        Rect.fromLTWH(0, 0, image!.width.toDouble(), image!.height.toDouble()),
        bounds,
        paint,
      );
    }
  }

  @override
  Map<String, dynamic> layerDataToJson() {
    return {
      'imagePath': imagePath,
    };
  }

  @override
  BitmapLayer copyWith({
    String? name,
    bool? visible,
    bool? locked,
    double? opacity,
    BlendModeType? blendModeType,
    Rect? bounds,
    ui.Image? image,
    String? imagePath,
  }) {
    return BitmapLayer(
      id: id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      opacity: opacity ?? this.opacity,
      blendModeType: blendModeType ?? this.blendModeType,
      bounds: bounds ?? this.bounds,
      createdDate: createdDate,
      modifiedDate: DateTime.now(),
      image: image ?? this.image,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  static BitmapLayer fromJson(Map<String, dynamic> json, Rect bounds) {
    final layerData = json['layerData'] as Map<String, dynamic>;
    return BitmapLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool,
      locked: json['locked'] as bool,
      opacity: json['opacity'] as double,
      blendModeType: BlendModeType.values.byName(json['blendModeType'] as String),
      bounds: bounds,
      createdDate: DateTime.parse(json['createdDate'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      imagePath: layerData['imagePath'] as String?,
    );
  }
}

// Crop layer for non-destructive image cropping (acts as viewport mask)
class CropLayer extends EditorLayer {
  final Rect cropRect; // The crop rectangle in image coordinates

  const CropLayer({
    required super.id,
    required super.name,
    required super.visible,
    required super.locked,
    required super.opacity,
    required super.blendModeType,
    required super.bounds,
    required super.createdDate,
    required super.modifiedDate,
    required this.cropRect,
  }) : super(layerType: LayerType.crop);

  @override
  void render(Canvas canvas, Paint paint) {
    // CropLayer doesn't render itself - it's used as metadata
    // The actual cropping is handled by the canvas painter
  }

  @override
  Map<String, dynamic> layerDataToJson() {
    return {
      'cropRect': {
        'left': cropRect.left,
        'top': cropRect.top,
        'width': cropRect.width,
        'height': cropRect.height,
      },
    };
  }

  @override
  CropLayer copyWith({
    String? name,
    bool? visible,
    bool? locked,
    double? opacity,
    BlendModeType? blendModeType,
    Rect? bounds,
    Rect? cropRect,
  }) {
    return CropLayer(
      id: id,
      name: name ?? this.name,
      visible: visible ?? this.visible,
      locked: locked ?? this.locked,
      opacity: opacity ?? this.opacity,
      blendModeType: blendModeType ?? this.blendModeType,
      bounds: bounds ?? this.bounds,
      createdDate: createdDate,
      modifiedDate: DateTime.now(),
      cropRect: cropRect ?? this.cropRect,
    );
  }

  static CropLayer fromJson(Map<String, dynamic> json, Rect bounds) {
    final layerData = json['layerData'] as Map<String, dynamic>;
    final cropRectData = layerData['cropRect'] as Map<String, dynamic>;
    
    return CropLayer(
      id: json['id'] as String,
      name: json['name'] as String,
      visible: json['visible'] as bool,
      locked: json['locked'] as bool,
      opacity: json['opacity'] as double,
      blendModeType: BlendModeType.values.byName(json['blendModeType'] as String),
      bounds: bounds,
      createdDate: DateTime.parse(json['createdDate'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      cropRect: Rect.fromLTWH(
        cropRectData['left'] as double,
        cropRectData['top'] as double,
        cropRectData['width'] as double,
        cropRectData['height'] as double,
      ),
    );
  }
}

// Supporting enums and classes
enum RedactionType {
  blackout,
  blur,
  pixelate,
}

enum VectorElementType {
  rectangle,
  ellipse,
  arrow,
  line,
  polygon,
}

abstract class VectorElement {
  final VectorElementType type;
  final List<Offset> points;

  const VectorElement({
    required this.type,
    required this.points,
  });

  void render(Canvas canvas, Paint paint);
  Map<String, dynamic> toJson();
  VectorElement copyWith();

  static VectorElement fromJson(Map<String, dynamic> json) {
    final type = VectorElementType.values.byName(json['type'] as String);
    final points = (json['points'] as List)
        .map((p) => Offset(p['x'] as double, p['y'] as double))
        .toList();

    switch (type) {
      case VectorElementType.rectangle:
        return RectangleElement(points: points);
      case VectorElementType.ellipse:
        return EllipseElement(points: points);
      case VectorElementType.arrow:
        return ArrowElement(points: points);
      case VectorElementType.line:
        return LineElement(points: points);
      case VectorElementType.polygon:
        return PolygonElement(points: points);
    }
  }
}

class RectangleElement extends VectorElement {
  const RectangleElement({required super.points}) : super(type: VectorElementType.rectangle);

  @override
  void render(Canvas canvas, Paint paint) {
    if (points.length >= 2) {
      final rect = Rect.fromPoints(points[0], points[1]);
      canvas.drawRect(rect, paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    };
  }

  @override
  VectorElement copyWith({List<Offset>? points}) {
    return RectangleElement(points: points ?? List.from(this.points));
  }
}

class EllipseElement extends VectorElement {
  const EllipseElement({required super.points}) : super(type: VectorElementType.ellipse);

  @override
  void render(Canvas canvas, Paint paint) {
    if (points.length >= 2) {
      final rect = Rect.fromPoints(points[0], points[1]);
      canvas.drawOval(rect, paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    };
  }

  @override
  VectorElement copyWith({List<Offset>? points}) {
    return EllipseElement(points: points ?? List.from(this.points));
  }
}

class ArrowElement extends VectorElement {
  const ArrowElement({required super.points}) : super(type: VectorElementType.arrow);

  @override
  void render(Canvas canvas, Paint paint) {
    if (points.length >= 2) {
      final start = points[0];
      final end = points[1];
      
      // Draw line
      canvas.drawLine(start, end, paint);
      
      // Draw arrowhead
      final direction = (end - start).direction;
      final arrowLength = 20.0;
      final arrowAngle = 0.5;
      
      final arrowPoint1 = end + Offset.fromDirection(direction + arrowAngle + 3.14159, arrowLength);
      final arrowPoint2 = end + Offset.fromDirection(direction - arrowAngle + 3.14159, arrowLength);
      
      canvas.drawLine(end, arrowPoint1, paint);
      canvas.drawLine(end, arrowPoint2, paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    };
  }

  @override
  VectorElement copyWith({List<Offset>? points}) {
    return ArrowElement(points: points ?? List.from(this.points));
  }
}

class LineElement extends VectorElement {
  const LineElement({required super.points}) : super(type: VectorElementType.line);

  @override
  void render(Canvas canvas, Paint paint) {
    if (points.length >= 2) {
      canvas.drawLine(points[0], points[1], paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    };
  }

  @override
  VectorElement copyWith({List<Offset>? points}) {
    return ArrowElement(points: points ?? List.from(this.points));
  }
}

class PolygonElement extends VectorElement {
  const PolygonElement({required super.points}) : super(type: VectorElementType.polygon);

  @override
  void render(Canvas canvas, Paint paint) {
    if (points.length >= 3) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'points': points.map((p) => {'x': p.dx, 'y': p.dy}).toList(),
    };
  }

  @override
  VectorElement copyWith({List<Offset>? points}) {
    return ArrowElement(points: points ?? List.from(this.points));
  }
}

