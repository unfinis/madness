import 'package:flutter/painting.dart';
import 'editor_layer.dart';

class Screenshot {
  final String id;
  final String projectId;
  final String name;
  final String description;
  final String caption;
  final String instructions;
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
  final String category;
  final Set<String> tags;
  final bool hasRedactions;
  final bool isProcessed;
  final bool isPlaceholder;
  final Map<String, dynamic> metadata;
  final List<EditorLayer> layers;

  const Screenshot({
    required this.id,
    required this.projectId,
    required this.name,
    required this.description,
    required this.caption,
    required this.instructions,
    required this.originalPath,
    this.editedPath,
    this.thumbnailPath,
    required this.width,
    required this.height,
    required this.fileSize,
    required this.fileFormat,
    required this.captureDate,
    required this.createdDate,
    required this.modifiedDate,
    required this.category,
    required this.tags,
    required this.hasRedactions,
    required this.isProcessed,
    this.isPlaceholder = false,
    required this.metadata,
    required this.layers,
  });

  Screenshot copyWith({
    String? id,
    String? projectId,
    String? name,
    String? description,
    String? caption,
    String? instructions,
    String? originalPath,
    String? editedPath,
    String? thumbnailPath,
    int? width,
    int? height,
    int? fileSize,
    String? fileFormat,
    DateTime? captureDate,
    DateTime? createdDate,
    DateTime? modifiedDate,
    String? category,
    Set<String>? tags,
    bool? hasRedactions,
    bool? isProcessed,
    bool? isPlaceholder,
    Map<String, dynamic>? metadata,
    List<EditorLayer>? layers,
  }) {
    return Screenshot(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      caption: caption ?? this.caption,
      instructions: instructions ?? this.instructions,
      originalPath: originalPath ?? this.originalPath,
      editedPath: editedPath ?? this.editedPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      width: width ?? this.width,
      height: height ?? this.height,
      fileSize: fileSize ?? this.fileSize,
      fileFormat: fileFormat ?? this.fileFormat,
      captureDate: captureDate ?? this.captureDate,
      createdDate: createdDate ?? this.createdDate,
      modifiedDate: modifiedDate ?? this.modifiedDate,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      hasRedactions: hasRedactions ?? this.hasRedactions,
      isProcessed: isProcessed ?? this.isProcessed,
      isPlaceholder: isPlaceholder ?? this.isPlaceholder,
      metadata: metadata ?? this.metadata,
      layers: layers ?? this.layers,
    );
  }

  // Layer management methods
  Screenshot addLayer(EditorLayer layer) {
    final newLayers = List<EditorLayer>.from(layers);
    newLayers.add(layer);
    return copyWith(
      layers: newLayers,
      modifiedDate: DateTime.now(),
    );
  }

  Screenshot removeLayer(String layerId) {
    final newLayers = layers.where((layer) => layer.id != layerId).toList();
    return copyWith(
      layers: newLayers,
      modifiedDate: DateTime.now(),
    );
  }

  Screenshot updateLayer(EditorLayer updatedLayer) {
    final newLayers = layers.map((layer) {
      return layer.id == updatedLayer.id ? updatedLayer : layer;
    }).toList();
    return copyWith(
      layers: newLayers,
      modifiedDate: DateTime.now(),
    );
  }

  Screenshot reorderLayers(List<String> layerIds) {
    final layerMap = {for (var layer in layers) layer.id: layer};
    final newLayers = layerIds
        .where((id) => layerMap.containsKey(id))
        .map((id) => layerMap[id]!)
        .toList();
    
    return copyWith(
      layers: newLayers,
      modifiedDate: DateTime.now(),
    );
  }

  Screenshot toggleLayerVisibility(String layerId) {
    return updateLayer(
      layers.firstWhere((layer) => layer.id == layerId).copyWith(
        visible: !layers.firstWhere((layer) => layer.id == layerId).visible,
      ),
    );
  }

  Screenshot toggleLayerLock(String layerId) {
    return updateLayer(
      layers.firstWhere((layer) => layer.id == layerId).copyWith(
        locked: !layers.firstWhere((layer) => layer.id == layerId).locked,
      ),
    );
  }

  // Utility getters
  Size get imageSize => Size(width.toDouble(), height.toDouble());
  
  bool get hasEditedLayers => layers.isNotEmpty;
  
  List<EditorLayer> get visibleLayers => layers.where((layer) => layer.visible).toList();
  
  List<EditorLayer> get redactionLayers => layers.where((layer) => layer.layerType == LayerType.redaction).toList();

  // Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'projectId': projectId,
      'name': name,
      'description': description,
      'caption': caption,
      'instructions': instructions,
      'originalPath': originalPath,
      'editedPath': editedPath,
      'thumbnailPath': thumbnailPath,
      'width': width,
      'height': height,
      'fileSize': fileSize,
      'fileFormat': fileFormat,
      'captureDate': captureDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'category': category,
      'tags': tags.toList(),
      'hasRedactions': hasRedactions,
      'isProcessed': isProcessed,
      'metadata': metadata,
      'layers': layers.map((layer) => layer.toJson()).toList(),
    };
  }

  factory Screenshot.fromJson(Map<String, dynamic> json) {
    return Screenshot(
      id: json['id'] as String,
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      caption: json['caption'] as String? ?? '',
      instructions: json['instructions'] as String? ?? '',
      originalPath: json['originalPath'] as String,
      editedPath: json['editedPath'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
      width: json['width'] as int,
      height: json['height'] as int,
      fileSize: json['fileSize'] as int,
      fileFormat: json['fileFormat'] as String,
      captureDate: DateTime.parse(json['captureDate'] as String),
      createdDate: DateTime.parse(json['createdDate'] as String),
      modifiedDate: DateTime.parse(json['modifiedDate'] as String),
      category: json['category'] as String? ?? 'other',
      tags: Set<String>.from(json['tags'] as List),
      hasRedactions: json['hasRedactions'] as bool,
      isProcessed: json['isProcessed'] as bool,
      metadata: Map<String, dynamic>.from(json['metadata'] as Map),
      layers: (json['layers'] as List)
          .map((layerJson) => EditorLayer.fromJson(layerJson as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Screenshot(id: $id, name: $name, layers: ${layers.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Screenshot && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}