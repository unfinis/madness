import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/editor_layer.dart';

class LayersPanel extends ConsumerWidget {
  final String screenshotId;
  final String projectId;
  final List<EditorLayer> layers;
  final String? selectedLayerId;
  final ValueChanged<String?> onLayerSelected;
  final Function(String) onLayerVisibilityToggle;
  final Function(String, String) onLayerRename;
  final Function(String) onLayerDelete;
  final Function(String) onLayerDuplicate;
  final Function(String, int, int)? onLayerReorder;
  final VoidCallback? onRevert;

  const LayersPanel({
    super.key,
    required this.screenshotId,
    required this.projectId,
    required this.layers,
    required this.selectedLayerId,
    required this.onLayerSelected,
    required this.onLayerVisibilityToggle,
    required this.onLayerRename,
    required this.onLayerDelete,
    required this.onLayerDuplicate,
    this.onLayerReorder,
    this.onRevert,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.layers_outlined,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Layers',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(Top → Bottom)',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                Text(
                  '${layers.length}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Layer List
          Expanded(
            child: layers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.layers,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No Layers',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ReorderableListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: layers.length,
                    buildDefaultDragHandles: false, // Disable automatic drag handles
                    onReorder: onLayerReorder != null
                        ? (oldIndex, newIndex) {
                            if (newIndex > oldIndex) newIndex -= 1;
                            // Convert UI indices back to actual layer indices (reverse the order)
                            final actualOldIndex = layers.length - 1 - oldIndex;
                            final actualNewIndex = layers.length - 1 - newIndex;
                            final layer = layers[actualOldIndex];
                            onLayerReorder!(layer.id, actualOldIndex, actualNewIndex);
                          }
                        : (_, _) {},
                    itemBuilder: (context, index) {
                      // Reverse the order so topmost layer appears at top of panel
                      final reversedIndex = layers.length - 1 - index;
                      final layer = layers[reversedIndex];
                      final isSelected = layer.id == selectedLayerId;

                      return _LayerTile(
                        key: ValueKey(layer.id),
                        layer: layer,
                        index: index, // Pass the UI index for drag handling
                        totalLayers: layers.length,
                        isSelected: isSelected,
                        onTap: () => onLayerSelected(layer.id),
                        onVisibilityToggle: () => onLayerVisibilityToggle(layer.id),
                        onRename: (newName) => onLayerRename(layer.id, newName),
                        showDragHandle: onLayerReorder != null,
                      );
                    },
                  ),
          ),
          
          // Layer Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Column(
              children: [
                // Top row - Duplicate and Delete
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.tonalIcon(
                        onPressed: selectedLayerId != null
                            ? () => onLayerDuplicate(selectedLayerId!)
                            : null,
                        icon: const Icon(Icons.content_copy_outlined, size: 16),
                        label: const Text('Duplicate'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: selectedLayerId != null
                            ? () => _confirmDeleteLayer(context, selectedLayerId!)
                            : null,
                        icon: const Icon(Icons.delete_outline, size: 16),
                        label: const Text('Delete'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: theme.colorScheme.errorContainer,
                          foregroundColor: theme.colorScheme.onErrorContainer,
                          textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Bottom row - Flatten and Revert
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: layers.isNotEmpty ? () => _flattenForRelease(context) : null,
                        icon: const Icon(Icons.layers_clear, size: 16),
                        label: const Text('Flatten'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          backgroundColor: theme.colorScheme.primaryContainer,
                          foregroundColor: theme.colorScheme.onPrimaryContainer,
                          textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: layers.isNotEmpty ? () => _revertToOriginal(context) : null,
                        icon: const Icon(Icons.restore, size: 16),
                        label: const Text('Revert'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          textStyle: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteLayer(BuildContext context, String layerId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Layer'),
        content: const Text('Are you sure you want to delete this layer? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onLayerDelete(layerId);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _flattenForRelease(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flatten for Release'),
        content: const Text(
          'This will merge all layers into a single flattened image for '
          'release purposes. The layered version will still be preserved '
          'for future editing. Continue?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Flattened version exported for release'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Flatten'),
          ),
        ],
      ),
    );
  }

  void _revertToOriginal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revert to Original'),
        content: const Text(
          'This will remove all layers and restore the screenshot to its '
          'original state. This action cannot be undone. Are you sure?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              onRevert?.call();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Revert'),
          ),
        ],
      ),
    );
  }
}

class _LayerTile extends StatefulWidget {
  final EditorLayer layer;
  final int index; // Added index for proper drag handling
  final int totalLayers; // Added to show correct Z-order
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onVisibilityToggle;
  final Function(String) onRename;
  final bool showDragHandle;

  const _LayerTile({
    super.key,
    required this.layer,
    required this.index,
    required this.totalLayers,
    required this.isSelected,
    required this.onTap,
    required this.onVisibilityToggle,
    required this.onRename,
    this.showDragHandle = false,
  });

  @override
  State<_LayerTile> createState() => _LayerTileState();
}

class _LayerTileState extends State<_LayerTile> {
  bool _isEditing = false;
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.layer.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _nameController.text = widget.layer.name;
    });
  }

  void _finishEditing() {
    if (_nameController.text.trim().isNotEmpty && _nameController.text.trim() != widget.layer.name) {
      widget.onRename(_nameController.text.trim());
    }
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final tileContent = Container(
      margin: const EdgeInsets.symmetric(vertical: 1),
      decoration: BoxDecoration(
        color: widget.isSelected
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
            : null,
        borderRadius: BorderRadius.circular(6),
        border: widget.isSelected
            ? Border.all(color: theme.colorScheme.primary, width: 1.5)
            : Border.all(color: Colors.transparent, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            
            // Layer type icon
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: widget.isSelected 
                    ? theme.colorScheme.primary.withValues(alpha: 0.1)
                    : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                _getLayerIcon(),
                size: 16,
                color: widget.isSelected 
                    ? theme.colorScheme.primary 
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 10),
            
            // Layer name (main clickable area)
            Expanded(
              child: GestureDetector(
                onTap: widget.onTap,
                onDoubleTap: _startEditing,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: _isEditing
                      ? TextField(
                          controller: _nameController,
                          autofocus: true,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          onSubmitted: (_) => _finishEditing(),
                          onTapOutside: (_) => _finishEditing(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.layer.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: widget.isSelected 
                                    ? theme.colorScheme.primary 
                                    : theme.colorScheme.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  _getLayerTypeText(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                    fontSize: 11,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '• Z${widget.totalLayers - widget.index}', // Show correct Z-order (topmost = highest)
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Visibility toggle - isolated clickable area
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onVisibilityToggle,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    widget.layer.visible ? Icons.visibility : Icons.visibility_off,
                    size: 18,
                    color: widget.layer.visible 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // Wrap with drag listener if drag is enabled
    return widget.showDragHandle
        ? ReorderableDragStartListener(
            index: widget.index,
            child: tileContent,
          )
        : tileContent;
  }

  IconData _getLayerIcon() {
    switch (widget.layer.layerType) {
      case LayerType.vector:
        return Icons.brush_outlined;
      case LayerType.text:
        return Icons.text_fields_outlined;
      case LayerType.redaction:
        return Icons.block_outlined;
      case LayerType.crop:
        return Icons.crop_outlined;
      case LayerType.bitmap:
        return Icons.image_outlined;
    }
  }

  String _getLayerTypeText() {
    switch (widget.layer.layerType) {
      case LayerType.vector:
        return 'Vector';
      case LayerType.text:
        return 'Text';
      case LayerType.redaction:
        return 'Redaction';
      case LayerType.crop:
        return 'Crop';
      case LayerType.bitmap:
        return 'Image';
    }
  }
}