import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assets.dart';
import '../constants/app_spacing.dart';
import 'dart:math' as math;

/// A widget that visualizes asset relationships as an interactive graph
class AssetRelationshipGraph extends ConsumerStatefulWidget {
  final List<Asset> assets;
  final Asset? focusAsset;
  final Function(Asset)? onAssetTapped;
  final Function(Asset, Asset)? onRelationshipTapped;

  const AssetRelationshipGraph({
    super.key,
    required this.assets,
    this.focusAsset,
    this.onAssetTapped,
    this.onRelationshipTapped,
  });

  @override
  ConsumerState<AssetRelationshipGraph> createState() => _AssetRelationshipGraphState();
}

class _AssetRelationshipGraphState extends ConsumerState<AssetRelationshipGraph>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  final TransformationController _transformationController = TransformationController();
  final Map<String, AssetNode> _nodePositions = {};
  final Map<String, AssetRelationship> _relationships = {};

  bool _showLegend = true;
  AssetLayoutType _layoutType = AssetLayoutType.hierarchical;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _calculateLayout();
    _animationController.forward();
  }

  @override
  void didUpdateWidget(AssetRelationshipGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assets != widget.assets || oldWidget.focusAsset != widget.focusAsset) {
      _calculateLayout();
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _calculateLayout() {
    _nodePositions.clear();
    _relationships.clear();

    switch (_layoutType) {
      case AssetLayoutType.hierarchical:
        _calculateHierarchicalLayout();
        break;
      case AssetLayoutType.circular:
        _calculateCircularLayout();
        break;
      case AssetLayoutType.force:
        _calculateForceDirectedLayout();
        break;
    }

    _calculateRelationships();
  }

  void _calculateHierarchicalLayout() {
    if (widget.assets.isEmpty) return;

    final rootAssets = widget.assets.where((asset) => asset.parentAssetIds.isEmpty).toList();
    final levelHeight = 120.0;
    final nodeSpacing = 150.0;

    // If there's a focus asset, center the layout around it
    final centralAssets = widget.focusAsset != null ? [widget.focusAsset!] : rootAssets;

    for (int i = 0; i < centralAssets.length; i++) {
      final rootAsset = centralAssets[i];
      final rootX = i * nodeSpacing * 2;
      _positionAssetHierarchy(rootAsset, rootX, 0, nodeSpacing, levelHeight, 0);
    }
  }

  void _positionAssetHierarchy(
    Asset asset,
    double centerX,
    double y,
    double spacing,
    double levelHeight,
    int level,
  ) {
    _nodePositions[asset.id] = AssetNode(
      asset: asset,
      position: Offset(centerX, y),
      level: level,
    );

    final children = widget.assets.where((a) => asset.childAssetIds.contains(a.id)).toList();
    if (children.isEmpty) return;

    final childSpacing = spacing / math.max(1, children.length - 1);
    final startX = centerX - (childSpacing * (children.length - 1)) / 2;

    for (int i = 0; i < children.length; i++) {
      final childX = startX + (i * childSpacing);
      _positionAssetHierarchy(
        children[i],
        childX,
        y + levelHeight,
        spacing * 0.7,
        levelHeight,
        level + 1,
      );
    }
  }

  void _calculateCircularLayout() {
    if (widget.assets.isEmpty) return;

    final center = const Offset(200, 200);
    final radius = 150.0;
    final angleStep = (2 * math.pi) / widget.assets.length;

    for (int i = 0; i < widget.assets.length; i++) {
      final asset = widget.assets[i];
      final angle = i * angleStep;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      _nodePositions[asset.id] = AssetNode(
        asset: asset,
        position: Offset(x, y),
        level: 0,
      );
    }
  }

  void _calculateForceDirectedLayout() {
    // Simplified force-directed layout
    final random = math.Random();
    const area = Size(400, 400);

    for (final asset in widget.assets) {
      _nodePositions[asset.id] = AssetNode(
        asset: asset,
        position: Offset(
          random.nextDouble() * area.width,
          random.nextDouble() * area.height,
        ),
        level: 0,
      );
    }

    // Apply forces (simplified version)
    for (int iteration = 0; iteration < 50; iteration++) {
      _applyForces();
    }
  }

  void _applyForces() {
    const repulsionStrength = 1000.0;
    const attractionStrength = 0.1;
    const damping = 0.9;

    final forces = <String, Offset>{};

    // Initialize forces
    for (final nodeId in _nodePositions.keys) {
      forces[nodeId] = Offset.zero;
    }

    // Repulsion between all nodes
    for (final node1 in _nodePositions.values) {
      for (final node2 in _nodePositions.values) {
        if (node1.asset.id != node2.asset.id) {
          final dx = node1.position.dx - node2.position.dx;
          final dy = node1.position.dy - node2.position.dy;
          final distance = math.sqrt(dx * dx + dy * dy);

          if (distance > 0) {
            final force = repulsionStrength / (distance * distance);
            final fx = force * dx / distance;
            final fy = force * dy / distance;

            forces[node1.asset.id] = forces[node1.asset.id]! + Offset(fx, fy);
          }
        }
      }
    }

    // Attraction between connected nodes
    for (final relationship in _relationships.values) {
      final node1 = _nodePositions[relationship.fromAssetId];
      final node2 = _nodePositions[relationship.toAssetId];

      if (node1 != null && node2 != null) {
        final dx = node2.position.dx - node1.position.dx;
        final dy = node2.position.dy - node1.position.dy;
        final distance = math.sqrt(dx * dx + dy * dy);

        if (distance > 0) {
          final force = attractionStrength * distance;
          final fx = force * dx / distance;
          final fy = force * dy / distance;

          forces[node1.asset.id] = forces[node1.asset.id]! + Offset(fx, fy);
          forces[node2.asset.id] = forces[node2.asset.id]! - Offset(fx, fy);
        }
      }
    }

    // Apply forces with damping
    for (final entry in forces.entries) {
      final nodeId = entry.key;
      final force = entry.value;
      final node = _nodePositions[nodeId];

      if (node != null) {
        final newX = (node.position.dx + force.dx * damping).clamp(50.0, 350.0);
        final newY = (node.position.dy + force.dy * damping).clamp(50.0, 350.0);

        _nodePositions[nodeId] = node.copyWith(position: Offset(newX, newY));
      }
    }
  }

  void _calculateRelationships() {
    for (final asset in widget.assets) {
      // Parent-child relationships
      for (final childId in asset.childAssetIds) {
        final childAsset = widget.assets.where((a) => a.id == childId).firstOrNull;
        if (childAsset != null) {
          final relationshipId = '${asset.id}-$childId';
          _relationships[relationshipId] = AssetRelationship(
            id: relationshipId,
            fromAssetId: asset.id,
            toAssetId: childId,
            type: RelationshipType.parentChild,
            label: 'contains',
          );
        }
      }

      // Related asset relationships
      for (final relatedId in asset.relatedAssetIds) {
        final relatedAsset = widget.assets.where((a) => a.id == relatedId).firstOrNull;
        if (relatedAsset != null) {
          final relationshipId = '${asset.id}-$relatedId-related';
          _relationships[relationshipId] = AssetRelationship(
            id: relationshipId,
            fromAssetId: asset.id,
            toAssetId: relatedId,
            type: RelationshipType.related,
            label: 'related to',
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: Stack(
              children: [
                _buildGraph(),
                if (_showLegend) _buildLegend(),
                _buildControls(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          Text(
            'Asset Relationships',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          DropdownButton<AssetLayoutType>(
            value: _layoutType,
            items: AssetLayoutType.values.map((type) => DropdownMenuItem(
              value: type,
              child: Text(_formatLayoutTypeName(type)),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _layoutType = value;
                  _calculateLayout();
                  _animationController.reset();
                  _animationController.forward();
                });
              }
            },
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: Icon(_showLegend ? Icons.visibility_off : Icons.visibility),
            onPressed: () => setState(() => _showLegend = !_showLegend),
            tooltip: _showLegend ? 'Hide Legend' : 'Show Legend',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _calculateLayout();
              _animationController.reset();
              _animationController.forward();
            },
            tooltip: 'Refresh Layout',
          ),
        ],
      ),
    );
  }

  Widget _buildGraph() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return InteractiveViewer(
          transformationController: _transformationController,
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.1,
          maxScale: 3.0,
          child: CustomPaint(
            painter: AssetGraphPainter(
              nodes: _nodePositions.values.toList(),
              relationships: _relationships.values.toList(),
              focusAsset: widget.focusAsset,
              animationValue: _animation.value,
              theme: Theme.of(context),
            ),
            child: Container(
              width: 800,
              height: 600,
              child: Stack(
                children: _nodePositions.values.map((node) {
                  final animatedPosition = Offset(
                    node.position.dx * _animation.value,
                    node.position.dy * _animation.value,
                  );

                  return Positioned(
                    left: animatedPosition.dx - 30,
                    top: animatedPosition.dy - 30,
                    child: _buildAssetNode(node),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAssetNode(AssetNode node) {
    final isFocused = widget.focusAsset?.id == node.asset.id;
    final size = isFocused ? 80.0 : 60.0;

    return GestureDetector(
      onTap: () => widget.onAssetTapped?.call(node.asset),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _getAssetTypeColor(node.asset.type).withValues(alpha: isFocused ? 1.0 : 0.8),
          shape: BoxShape.circle,
          border: Border.all(
            color: isFocused ? Colors.white : Colors.transparent,
            width: isFocused ? 3 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: isFocused ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getAssetTypeIcon(node.asset.type),
              color: Colors.white,
              size: isFocused ? 24 : 20,
            ),
            if (isFocused) ...[
              const SizedBox(height: 2),
              Text(
                node.asset.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Positioned(
      top: AppSpacing.md,
      right: AppSpacing.md,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Legend',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ..._getVisibleAssetTypes().map((type) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _getAssetTypeColor(type),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getAssetTypeIcon(type),
                      color: Colors.white,
                      size: 10,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatAssetTypeName(type),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            )),
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.sm),
            ...[
              _buildLegendItem('Parent-Child', Colors.blue, isLine: true),
              _buildLegendItem('Related', Colors.orange, isLine: true, isDashed: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, {bool isLine = false, bool isDashed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLine)
            Container(
              width: 16,
              height: 2,
              decoration: BoxDecoration(
                color: color,
                border: isDashed ? Border.all(color: color, style: BorderStyle.solid) : null,
              ),
            )
          else
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: AppSpacing.md,
      left: AppSpacing.md,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'zoom_in',
            onPressed: _zoomIn,
            child: const Icon(Icons.zoom_in),
          ),
          const SizedBox(height: AppSpacing.sm),
          FloatingActionButton.small(
            heroTag: 'zoom_out',
            onPressed: _zoomOut,
            child: const Icon(Icons.zoom_out),
          ),
          const SizedBox(height: AppSpacing.sm),
          FloatingActionButton.small(
            heroTag: 'center',
            onPressed: _centerView,
            child: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),
    );
  }

  void _zoomIn() {
    final currentTransform = _transformationController.value;
    final newScale = (currentTransform.getMaxScaleOnAxis() * 1.2).clamp(0.1, 3.0);
    _transformationController.value = Matrix4.identity()..scale(newScale);
  }

  void _zoomOut() {
    final currentTransform = _transformationController.value;
    final newScale = (currentTransform.getMaxScaleOnAxis() * 0.8).clamp(0.1, 3.0);
    _transformationController.value = Matrix4.identity()..scale(newScale);
  }

  void _centerView() {
    _transformationController.value = Matrix4.identity();
  }

  List<AssetType> _getVisibleAssetTypes() {
    return widget.assets.map((asset) => asset.type).toSet().toList();
  }

  String _formatAssetTypeName(AssetType type) {
    return type.name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
  }

  String _formatLayoutTypeName(AssetLayoutType type) {
    return type.name[0].toUpperCase() + type.name.substring(1);
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.environment:
        return Icons.public;
      case AssetType.physicalSite:
        return Icons.location_on;
      case AssetType.networkSegment:
        return Icons.network_wifi;
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.cloud;
      case AssetType.credential:
        return Icons.key;
      case AssetType.wirelessNetwork:
        return Icons.wifi;
      case AssetType.cloudTenant:
        return Icons.cloud_outlined;
      case AssetType.person:
        return Icons.person_outline;
      default:
        return Icons.device_unknown;
    }
  }

  Color _getAssetTypeColor(AssetType type) {
    switch (type) {
      case AssetType.environment:
        return Colors.purple;
      case AssetType.physicalSite:
        return Colors.brown;
      case AssetType.networkSegment:
        return Colors.teal;
      case AssetType.host:
        return Colors.blue;
      case AssetType.service:
        return Colors.green;
      case AssetType.credential:
        return Colors.orange;
      case AssetType.wirelessNetwork:
        return Colors.amber;
      case AssetType.cloudTenant:
        return Colors.indigo;
      case AssetType.person:
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }
}

// Supporting classes and enums
enum AssetLayoutType { hierarchical, circular, force }

enum RelationshipType { parentChild, related, dependency }

class AssetNode {
  final Asset asset;
  final Offset position;
  final int level;

  AssetNode({
    required this.asset,
    required this.position,
    required this.level,
  });

  AssetNode copyWith({
    Asset? asset,
    Offset? position,
    int? level,
  }) {
    return AssetNode(
      asset: asset ?? this.asset,
      position: position ?? this.position,
      level: level ?? this.level,
    );
  }
}

class AssetRelationship {
  final String id;
  final String fromAssetId;
  final String toAssetId;
  final RelationshipType type;
  final String label;

  AssetRelationship({
    required this.id,
    required this.fromAssetId,
    required this.toAssetId,
    required this.type,
    required this.label,
  });
}

// Custom painter for drawing the graph connections
class AssetGraphPainter extends CustomPainter {
  final List<AssetNode> nodes;
  final List<AssetRelationship> relationships;
  final Asset? focusAsset;
  final double animationValue;
  final ThemeData theme;

  AssetGraphPainter({
    required this.nodes,
    required this.relationships,
    this.focusAsset,
    required this.animationValue,
    required this.theme,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final nodeMap = {for (var node in nodes) node.asset.id: node};

    for (final relationship in relationships) {
      final fromNode = nodeMap[relationship.fromAssetId];
      final toNode = nodeMap[relationship.toAssetId];

      if (fromNode != null && toNode != null) {
        _drawRelationship(canvas, fromNode, toNode, relationship);
      }
    }
  }

  void _drawRelationship(
    Canvas canvas,
    AssetNode fromNode,
    AssetNode toNode,
    AssetRelationship relationship,
  ) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    switch (relationship.type) {
      case RelationshipType.parentChild:
        paint.color = Colors.blue.withValues(alpha: 0.7 * animationValue);
        break;
      case RelationshipType.related:
        paint.color = Colors.orange.withValues(alpha: 0.7 * animationValue);
        // Could implement dashed lines here using a custom path if needed
        break;
      case RelationshipType.dependency:
        paint.color = Colors.red.withValues(alpha: 0.7 * animationValue);
        break;
    }

    final from = Offset(
      fromNode.position.dx * animationValue,
      fromNode.position.dy * animationValue,
    );
    final to = Offset(
      toNode.position.dx * animationValue,
      toNode.position.dy * animationValue,
    );

    canvas.drawLine(from, to, paint);

    // Draw arrow head for parent-child relationships
    if (relationship.type == RelationshipType.parentChild) {
      _drawArrowHead(canvas, from, to, paint);
    }
  }

  void _drawArrowHead(Canvas canvas, Offset from, Offset to, Paint paint) {
    const arrowSize = 8.0;
    final direction = (to - from).normalize();
    final perpendicular = Offset(-direction.dy, direction.dx);

    final arrowTip = to - direction * arrowSize;
    final arrowLeft = arrowTip - perpendicular * arrowSize * 0.5;
    final arrowRight = arrowTip + perpendicular * arrowSize * 0.5;

    final path = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(arrowLeft.dx, arrowLeft.dy)
      ..lineTo(arrowRight.dx, arrowRight.dy)
      ..close();

    canvas.drawPath(path, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(AssetGraphPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.nodes.length != nodes.length ||
           oldDelegate.relationships.length != relationships.length;
  }
}

extension OffsetExtensions on Offset {
  Offset normalize() {
    final magnitude = distance;
    return magnitude > 0 ? this / magnitude : Offset.zero;
  }
}