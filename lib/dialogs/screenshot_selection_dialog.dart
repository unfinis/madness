import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/screenshot.dart';
import '../providers/screenshot_providers.dart';

class ScreenshotSelectionDialog extends ConsumerStatefulWidget {
  final String projectId;
  final List<String> selectedScreenshotIds;
  final bool allowMultipleSelection;

  const ScreenshotSelectionDialog({
    super.key,
    required this.projectId,
    this.selectedScreenshotIds = const [],
    this.allowMultipleSelection = true,
  });

  @override
  ConsumerState<ScreenshotSelectionDialog> createState() => _ScreenshotSelectionDialogState();
}

class _ScreenshotSelectionDialogState extends ConsumerState<ScreenshotSelectionDialog> {
  late Set<String> _selectedIds;
  String _searchQuery = '';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _selectedIds = Set<String>.from(widget.selectedScreenshotIds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenshotsAsync = ref.watch(projectScreenshotsProvider(widget.projectId));

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.photo_library, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Screenshots',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          widget.allowMultipleSelection 
                            ? 'Choose one or more screenshots to link to this finding'
                            : 'Choose a screenshot to link to this finding',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Search and filter controls
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search screenshots',
                        hintText: 'Search by name or description',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'finding', child: Text('Finding')),
                        DropdownMenuItem(value: 'proof', child: Text('Proof')),
                        DropdownMenuItem(value: 'evidence', child: Text('Evidence')),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Screenshots grid
            Expanded(
              child: screenshotsAsync.when(
                data: (screenshots) {
                  final filteredScreenshots = _filterScreenshots(screenshots);
                  
                  if (filteredScreenshots.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            screenshots.isEmpty 
                              ? 'No screenshots available'
                              : 'No screenshots match your search',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                          if (screenshots.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              'Take screenshots first to link them to findings',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: filteredScreenshots.length,
                    itemBuilder: (context, index) {
                      final screenshot = filteredScreenshots[index];
                      final isSelected = _selectedIds.contains(screenshot.id);
                      
                      return _buildScreenshotCard(context, screenshot, isSelected);
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error loading screenshots',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    '${_selectedIds.length} selected',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _selectedIds.isEmpty 
                      ? null 
                      : () => Navigator.of(context).pop(_selectedIds.toList()),
                    child: const Text('Select'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Screenshot> _filterScreenshots(List<Screenshot> screenshots) {
    var filtered = screenshots;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((s) =>
          s.name.toLowerCase().contains(_searchQuery) ||
          s.description.toLowerCase().contains(_searchQuery)).toList();
    }

    // Filter by category
    if (_selectedCategory != 'all') {
      filtered = filtered.where((s) => s.category == _selectedCategory).toList();
    }

    return filtered;
  }

  Widget _buildScreenshotCard(BuildContext context, Screenshot screenshot, bool isSelected) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: isSelected ? 8 : 2,
      color: isSelected 
        ? theme.colorScheme.primaryContainer
        : theme.colorScheme.surface,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _toggleSelection(screenshot.id),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail
            Expanded(
              flex: 3,
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.colorScheme.surfaceContainerHighest,
                ),
                child: _buildThumbnail(screenshot, theme),
              ),
            ),
            
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            screenshot.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isSelected 
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (screenshot.description.isNotEmpty)
                      Text(
                        screenshot.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isSelected 
                            ? theme.colorScheme.onPrimaryContainer.withOpacity(0.8)
                            : theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.secondary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            screenshot.category,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${screenshot.width}x${screenshot.height}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isSelected 
                              ? theme.colorScheme.onPrimaryContainer.withOpacity(0.6)
                              : theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(Screenshot screenshot, ThemeData theme) {
    // Try to load thumbnail first, then original
    final imagePath = screenshot.thumbnailPath ?? screenshot.originalPath;
    
    if (imagePath.isEmpty) {
      return Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      );
    }

    // For file system images
    final file = File(imagePath);
    if (file.existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          file,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.broken_image,
                size: 48,
                color: theme.colorScheme.error.withOpacity(0.5),
              ),
            );
          },
        ),
      );
    }

    // Fallback for missing files
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 4),
          Text(
            'Image not found',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleSelection(String screenshotId) {
    setState(() {
      if (widget.allowMultipleSelection) {
        if (_selectedIds.contains(screenshotId)) {
          _selectedIds.remove(screenshotId);
        } else {
          _selectedIds.add(screenshotId);
        }
      } else {
        _selectedIds.clear();
        _selectedIds.add(screenshotId);
      }
    });
  }
}