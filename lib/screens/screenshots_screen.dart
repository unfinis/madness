import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../models/screenshot.dart';
import '../models/screenshot_category.dart';
import '../providers/screenshot_providers.dart';
import '../providers/database_provider.dart';
import '../screens/screenshot_editor_screen.dart';
import '../dialogs/upload_screenshot_dialog.dart';
import '../services/screenshot_upload_service.dart';
import '../constants/responsive_breakpoints.dart';
import '../constants/app_spacing.dart';
import '../widgets/screenshot_widgets.dart';
import '../widgets/rendered_screenshot_thumbnail.dart';

class ScreenshotsScreen extends ConsumerStatefulWidget {
  final String projectId;
  
  const ScreenshotsScreen({super.key, required this.projectId});

  @override
  ConsumerState<ScreenshotsScreen> createState() => _ScreenshotsScreenState();
}

class _ScreenshotsScreenState extends ConsumerState<ScreenshotsScreen> {
  String _searchQuery = '';
  String _filterCategory = 'all';
  String _filterStatus = 'all';
  String _filterFindings = 'all';
  String _sortBy = 'recent';
  String _viewMode = 'grid';
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    final isWideDesktop = ResponsiveBreakpoints.isWideDesktop(screenWidth);

    final screenshotsAsync = ref.watch(projectScreenshotsProvider(widget.projectId));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: DropTarget(
        onDragDone: _handleFileDrop,
        onDragEntered: (_) => setState(() => _isDragOver = true),
        onDragExited: (_) => setState(() => _isDragOver = false),
        child: Container(
          decoration: _isDragOver
              ? BoxDecoration(
                  border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                  color: theme.colorScheme.primaryContainer.withOpacity(0.1),
                )
              : null,
          child: Padding(
            padding: EdgeInsets.all(isWideDesktop ? AppSpacing.lg + AppSpacing.xs : (isDesktop ? AppSpacing.xl : AppSpacing.lg)),
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            isDesktop 
                ? Row(
                    children: [
                      Expanded(
                        child: ScreenshotWidgets.sectionHeader(
                          title: 'Screenshots',
                          subtitle: 'Manage and edit screenshot evidence',
                          icon: Icons.photo_camera,
                          theme: theme,
                        ),
                      ),
                      FilledButton.icon(
                        onPressed: () => _createNewScreenshot(),
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload Screenshot'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenshotWidgets.sectionHeader(
                        title: 'Screenshots',
                        subtitle: 'Manage and edit screenshot evidence',
                        icon: Icons.photo_camera,
                        theme: theme,
                      ),
                      AppSpacing.vGapLG,
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _createNewScreenshot(),
                          icon: const Icon(Icons.upload),
                          label: const Text('Upload Screenshot'),
                        ),
                      ),
                    ],
                  ),
            AppSpacing.vGapXL,
            
            // Filters and Search Panel
            Card(
              child: Padding(
                padding: AppSpacing.cardPadding,
                child: Column(
                  children: [
                    // Search Bar with View Toggle
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: 'Search screenshots...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                        ),
                        AppSpacing.hGapLG,
                        // View Mode Toggle
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: theme.colorScheme.outline),
                            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ScreenshotWidgets.viewModeButton(
                                icon: Icons.grid_view,
                                mode: 'grid',
                                tooltip: 'Grid',
                                currentMode: _viewMode,
                                onTap: () => setState(() => _viewMode = 'grid'),
                                theme: theme,
                              ),
                              ScreenshotWidgets.viewModeButton(
                                icon: Icons.view_list,
                                mode: 'list',
                                tooltip: 'List',
                                currentMode: _viewMode,
                                onTap: () => setState(() => _viewMode = 'list'),
                                theme: theme,
                              ),
                              ScreenshotWidgets.viewModeButton(
                                icon: Icons.timeline,
                                mode: 'timeline',
                                tooltip: 'Timeline',
                                currentMode: _viewMode,
                                onTap: () => setState(() => _viewMode = 'timeline'),
                                theme: theme,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    AppSpacing.vGapLG,
                    
                    // Category Filter Buttons
                    Row(
                      children: [
                        Text(
                          'Category:',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        AppSpacing.hGapMD,
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ScreenshotWidgets.filterChip(
                                  label: 'All',
                                  value: 'all',
                                  currentValue: _filterCategory,
                                  onSelected: (value) => setState(() => _filterCategory = value),
                                  theme: theme,
                                ),
                                AppSpacing.hGapSM,
                                ScreenshotWidgets.filterChip(
                                  label: '🌐 Web',
                                  value: 'web',
                                  currentValue: _filterCategory,
                                  onSelected: (value) => setState(() => _filterCategory = value),
                                  theme: theme,
                                ),
                                AppSpacing.hGapSM,
                                ScreenshotWidgets.filterChip(
                                  label: '🔌 Network',
                                  value: 'network',
                                  currentValue: _filterCategory,
                                  onSelected: (value) => setState(() => _filterCategory = value),
                                  theme: theme,
                                ),
                                AppSpacing.hGapSM,
                                ScreenshotWidgets.filterChip(
                                  label: '💻 System',
                                  value: 'system',
                                  currentValue: _filterCategory,
                                  onSelected: (value) => setState(() => _filterCategory = value),
                                  theme: theme,
                                ),
                                AppSpacing.hGapSM,
                                ScreenshotWidgets.filterChip(
                                  label: '📱 Mobile',
                                  value: 'mobile',
                                  currentValue: _filterCategory,
                                  onSelected: (value) => setState(() => _filterCategory = value),
                                  theme: theme,
                                ),
                                AppSpacing.hGapSM,
                                ScreenshotWidgets.filterChip(
                                  label: '📁 Other',
                                  value: 'other',
                                  currentValue: _filterCategory,
                                  onSelected: (value) => setState(() => _filterCategory = value),
                                  theme: theme,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    AppSpacing.vGapMD,
                    
                    // Status and Findings Filters + Sort
                    isDesktop
                        ? Row(
                            children: [
                              // Status Filter
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      'Status:',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    AppSpacing.hGapSM,
                                    DropdownButton<String>(
                                      value: _filterStatus,
                                      underline: const SizedBox.shrink(),
                                      items: const [
                                        DropdownMenuItem(value: 'all', child: Text('All')),
                                        DropdownMenuItem(value: 'edited', child: Text('Edited')),
                                        DropdownMenuItem(value: 'raw', child: Text('Raw')),
                                        DropdownMenuItem(value: 'redacted', child: Text('Redacted')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _filterStatus = value;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Findings Filter
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      'Findings:',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    AppSpacing.hGapSM,
                                    DropdownButton<String>(
                                      value: _filterFindings,
                                      underline: const SizedBox.shrink(),
                                      items: const [
                                        DropdownMenuItem(value: 'all', child: Text('All')),
                                        DropdownMenuItem(value: 'with-findings', child: Text('With Findings')),
                                        DropdownMenuItem(value: 'no-findings', child: Text('No Findings')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _filterFindings = value;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Sort Options
                              Row(
                                children: [
                                  Text(
                                    'Sort:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  DropdownButton<String>(
                                    value: _sortBy,
                                    underline: const SizedBox.shrink(),
                                    items: const [
                                      DropdownMenuItem(value: 'recent', child: Text('Recent')),
                                      DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
                                      DropdownMenuItem(value: 'name', child: Text('Name')),
                                      DropdownMenuItem(value: 'size', child: Text('Size')),
                                      DropdownMenuItem(value: 'category', child: Text('Category')),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _sortBy = value;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              // Status Filter Row
                              Row(
                                children: [
                                  Text(
                                    'Status:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AppSpacing.hGapSM,
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _filterStatus,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'all', child: Text('All')),
                                        DropdownMenuItem(value: 'edited', child: Text('Edited')),
                                        DropdownMenuItem(value: 'raw', child: Text('Raw')),
                                        DropdownMenuItem(value: 'redacted', child: Text('Redacted')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _filterStatus = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacing.vGapMD,
                              // Findings Filter Row
                              Row(
                                children: [
                                  Text(
                                    'Findings:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AppSpacing.hGapSM,
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _filterFindings,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'all', child: Text('All')),
                                        DropdownMenuItem(value: 'with-findings', child: Text('With Findings')),
                                        DropdownMenuItem(value: 'no-findings', child: Text('No Findings')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _filterFindings = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              AppSpacing.vGapMD,
                              // Sort Options Row
                              Row(
                                children: [
                                  Text(
                                    'Sort:',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  AppSpacing.hGapSM,
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _sortBy,
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(value: 'recent', child: Text('Recent')),
                                        DropdownMenuItem(value: 'oldest', child: Text('Oldest')),
                                        DropdownMenuItem(value: 'name', child: Text('Name')),
                                        DropdownMenuItem(value: 'size', child: Text('Size')),
                                        DropdownMenuItem(value: 'category', child: Text('Category')),
                                      ],
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            _sortBy = value;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
            
            AppSpacing.vGapXL,
            
            // Screenshots Grid
            Expanded(
              child: screenshotsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: theme.colorScheme.error,
                      ),
                      AppSpacing.vGapLG,
                      Text(
                        'Failed to load screenshots',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                data: (screenshots) {
                  final filteredScreenshots = _filterScreenshots(screenshots);
                  
                  if (filteredScreenshots.isEmpty) {
                    return _buildEmptyState(theme);
                  }
                  
                  return _buildScreenshotsView(filteredScreenshots, isDesktop);
                },
              ),
            ),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No screenshots yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your first screenshot to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _createNewScreenshot(),
            icon: const Icon(Icons.upload),
            label: const Text('Upload Screenshot'),
          ),
        ],
      ),
    );
  }

  // Build screenshots view based on current view mode
  Widget _buildScreenshotsView(List<Screenshot> screenshots, bool isDesktop) {
    switch (_viewMode) {
      case 'list':
        return _buildScreenshotsList(screenshots);
      case 'timeline':
        return _buildScreenshotsTimeline(screenshots);
      case 'grid':
      default:
        return _buildScreenshotsGrid(screenshots, isDesktop);
    }
  }

  Widget _buildScreenshotsGrid(List<Screenshot> screenshots, bool isDesktop) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    double childAspectRatio;
    
    if (screenWidth > 1200) {
      // Wide desktop: 5 columns
      crossAxisCount = 5;
      childAspectRatio = 0.75;
    } else if (screenWidth > 900) {
      // Desktop: 4 columns
      crossAxisCount = 4;
      childAspectRatio = 0.8;
    } else if (screenWidth > 600) {
      // Tablet: 3 columns
      crossAxisCount = 3;
      childAspectRatio = 0.85;
    } else if (screenWidth > 400) {
      // Mobile: 2 columns
      crossAxisCount = 2;
      childAspectRatio = 0.9;
    } else {
      // Small mobile: 1 column
      crossAxisCount = 1;
      childAspectRatio = 1.2;
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: screenshots.length,
      itemBuilder: (context, index) {
        final screenshot = screenshots[index];
        return _buildScreenshotCard(screenshot);
      },
    );
  }

  Widget _buildScreenshotsList(List<Screenshot> screenshots) {
    return ListView.builder(
      itemCount: screenshots.length,
      itemBuilder: (context, index) {
        final screenshot = screenshots[index];
        return _buildScreenshotListItem(screenshot);
      },
    );
  }

  Widget _buildScreenshotsTimeline(List<Screenshot> screenshots) {
    // Group screenshots by date
    final groupedScreenshots = <String, List<Screenshot>>{};
    for (final screenshot in screenshots) {
      final dateKey = '${screenshot.captureDate.year}-${screenshot.captureDate.month.toString().padLeft(2, '0')}-${screenshot.captureDate.day.toString().padLeft(2, '0')}';
      groupedScreenshots[dateKey] = (groupedScreenshots[dateKey] ?? [])..add(screenshot);
    }
    
    final sortedDates = groupedScreenshots.keys.toList()..sort((a, b) => b.compareTo(a));
    
    return ListView.builder(
      itemCount: sortedDates.length,
      itemBuilder: (context, index) {
        final date = sortedDates[index];
        final dayScreenshots = groupedScreenshots[date]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 768 ? AppSpacing.lg : AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Text(
                _formatTimelineDate(DateTime.parse(date.replaceAll('-', ''))),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Screenshots for this date
            ...dayScreenshots.map((screenshot) => _buildScreenshotListItem(screenshot)),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildScreenshotListItem(Screenshot screenshot) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;
    
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.lg : AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      child: InkWell(
        onTap: () => _openScreenshotEditor(screenshot),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
          child: Row(
            children: [
              // Thumbnail
              Container(
                width: isDesktop ? 80 : 60,
                height: isDesktop ? 60 : 45,
                decoration: BoxDecoration(
                  color: screenshot.isPlaceholder 
                      ? theme.colorScheme.secondaryContainer.withOpacity(0.3)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  screenshot.isPlaceholder 
                      ? Icons.insert_photo_outlined
                      : Icons.image,
                  size: 32,
                  color: screenshot.isPlaceholder
                      ? theme.colorScheme.secondary
                      : Colors.grey.shade400,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Screenshot info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            screenshot.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Placeholder badge + Category badge  
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (screenshot.isPlaceholder) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Placeholder',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSecondary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getCategoryColor(screenshot.category, theme),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                _getCategoryLabel(screenshot.category),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    if (screenshot.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        screenshot.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Text(
                          screenshot.isPlaceholder 
                              ? 'Placeholder'
                              : '${screenshot.width} × ${screenshot.height}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        AppSpacing.hGapLG,
                        
                        Text(
                          screenshot.isPlaceholder 
                              ? 'No file'
                              : _formatFileSize(screenshot.fileSize),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        const Spacer(),
                        
                        // Finding tags
                        if (_getDemoFindingTags(screenshot.id).isNotEmpty) ...[
                          ...(_getDemoFindingTags(screenshot.id).take(2).map((finding) {
                            return Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.errorContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                finding,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onErrorContainer,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          })),
                          if (_getDemoFindingTags(screenshot.id).length > 2)
                            Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              child: Text(
                                '+${_getDemoFindingTags(screenshot.id).length - 2}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                        
                        const SizedBox(width: 8),
                        
                        Text(
                          _formatRelativeTime(screenshot.modifiedDate),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimelineDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
  
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Widget _buildScreenshotCard(Screenshot screenshot) {
    final theme = Theme.of(context);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openScreenshotEditor(screenshot),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Screenshot Preview
            Expanded(
              flex: 3,
              child: Container(
                color: screenshot.isPlaceholder
                    ? theme.colorScheme.secondaryContainer.withOpacity(0.3)
                    : Colors.grey.shade100,
                child: Stack(
                  children: [
                    // Rendered thumbnail with layers
                    Positioned.fill(
                      child: RenderedScreenshotThumbnail(
                        screenshot: screenshot,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Status badges
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Placeholder badge (show first if it's a placeholder)
                          if (screenshot.isPlaceholder) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Placeholder',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          // Category badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(screenshot.category, theme),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getCategoryLabel(screenshot.category),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          // Status badges
                          if (screenshot.hasEditedLayers) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Edited',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                          if (!screenshot.hasEditedLayers && !screenshot.hasRedactions) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Raw',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                          if (screenshot.hasRedactions) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'Redacted',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onError,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                          // Finding count badge (demo data - would be from findings relationship)
                          if (_getDemoFindingCount(screenshot.id) > 0) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${_getDemoFindingCount(screenshot.id)} Finding${_getDemoFindingCount(screenshot.id) == 1 ? '' : 's'}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Screenshot Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screenshot.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      screenshot.description.isNotEmpty 
                          ? screenshot.description 
                          : 'No description',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (screenshot.caption.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.text_fields,
                            size: 12,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              screenshot.caption,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (screenshot.instructions.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.help_outline,
                            size: 12,
                            color: theme.colorScheme.secondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              screenshot.instructions,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    // Finding tags
                    if (_getDemoFindingTags(screenshot.id).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: _getDemoFindingTags(screenshot.id).map((finding) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: theme.colorScheme.error.withOpacity(0.5),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              finding,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onErrorContainer,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.layers,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            screenshot.isPlaceholder
                                ? 'Template ready'
                                : '${screenshot.layers.length} layers',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          screenshot.isPlaceholder 
                              ? 'PLACEHOLDER'
                              : screenshot.fileFormat.toUpperCase(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
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


  void _createNewScreenshot() async {
    final result = await showDialog<Screenshot>(
      context: context,
      builder: (context) => UploadScreenshotDialog(
        projectId: widget.projectId,
      ),
    );

    // The dialog handles success feedback and provider invalidation
    // No additional action needed here
    if (result != null) {
      // Optionally navigate to editor for the new screenshot
      // _openScreenshotEditor(result);
    }
  }

  void _openScreenshotEditor(Screenshot screenshot) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScreenshotEditorScreen(
          screenshotId: screenshot.id,
          projectId: widget.projectId,
        ),
      ),
    );
  }

  void _handleFileDrop(DropDoneDetails details) async {
    setState(() {
      _isDragOver = false;
    });

    final files = details.files.where((file) {
      final extension = file.path.split('.').last.toLowerCase();
      return ['png', 'jpg', 'jpeg'].contains(extension);
    }).toList();

    if (files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please drop only PNG, JPG, or JPEG image files'),
        ),
      );
      return;
    }

    // Process multiple files
    for (final file in files) {
      try {
        // Show upload dialog for each file with pre-filled data
        await showDialog<Screenshot>(
          context: context,
          builder: (context) => _UploadScreenshotWithFileDialog(
            projectId: widget.projectId,
            filePath: file.path,
            onSuccess: () {
              // Refresh the screenshots list
              ref.invalidate(projectScreenshotsProvider(widget.projectId));
            },
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process ${file.name}: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }


  // Filter and sort screenshots based on current settings
  List<Screenshot> _filterScreenshots(List<Screenshot> screenshots) {
    var filtered = screenshots.where((screenshot) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!screenshot.name.toLowerCase().contains(query) &&
            !screenshot.description.toLowerCase().contains(query) &&
            !screenshot.caption.toLowerCase().contains(query) &&
            !screenshot.instructions.toLowerCase().contains(query)) {
          return false;
        }
      }
      
      // Category filter
      if (_filterCategory != 'all' && screenshot.category != _filterCategory) {
        return false;
      }
      
      // Status filter
      if (_filterStatus != 'all') {
        switch (_filterStatus) {
          case 'edited':
            if (!screenshot.hasEditedLayers) return false;
            break;
          case 'raw':
            if (screenshot.hasEditedLayers || screenshot.hasRedactions) return false;
            break;
          case 'redacted':
            if (!screenshot.hasRedactions) return false;
            break;
        }
      }
      
      // Findings filter
      if (_filterFindings != 'all') {
        final findingCount = _getDemoFindingCount(screenshot.id);
        switch (_filterFindings) {
          case 'with-findings':
            if (findingCount == 0) return false;
            break;
          case 'no-findings':
            if (findingCount > 0) return false;
            break;
        }
      }
      
      return true;
    }).toList();
    
    // Sort screenshots
    switch (_sortBy) {
      case 'recent':
        filtered.sort((a, b) => b.modifiedDate.compareTo(a.modifiedDate));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdDate.compareTo(b.createdDate));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'size':
        filtered.sort((a, b) => b.fileSize.compareTo(a.fileSize));
        break;
      case 'category':
        filtered.sort((a, b) => a.category.compareTo(b.category));
        break;
    }
    
    return filtered;
  }

  // Helper methods for category and finding badges
  Color _getCategoryColor(String category, ThemeData theme) {
    final categoryEnum = ScreenshotCategory.fromValue(category);
    switch (categoryEnum) {
      case ScreenshotCategory.web:
        return Colors.blue.shade600;
      case ScreenshotCategory.network:
        return Colors.green.shade600;
      case ScreenshotCategory.system:
        return Colors.purple.shade600;
      case ScreenshotCategory.mobile:
        return Colors.pink.shade600;
      case ScreenshotCategory.other:
      default:
        return Colors.grey.shade600;
    }
  }

  String _getCategoryLabel(String category) {
    final categoryEnum = ScreenshotCategory.fromValue(category);
    return categoryEnum.displayName;
  }

  // Demo data for finding count - in real app would come from database relationships
  int _getDemoFindingCount(String screenshotId) {
    // Sample data based on screenshot IDs
    switch (screenshotId) {
      case 'demo-screenshot-001':
        return 3;
      case 'demo-screenshot-002':
        return 1;
      case 'demo-screenshot-003':
        return 0;
      default:
        return 0;
    }
  }

  // Demo data for finding tags - in real app would come from database relationships
  List<String> _getDemoFindingTags(String screenshotId) {
    switch (screenshotId) {
      case 'demo-screenshot-001':
        return ['FIND-001', 'FIND-002', 'FIND-007'];
      case 'demo-screenshot-002':
        return ['FIND-012'];
      case 'demo-screenshot-003':
        return [];
      default:
        return [];
    }
  }
}

// Helper dialog for drag-and-drop files
class _UploadScreenshotWithFileDialog extends ConsumerStatefulWidget {
  final String projectId;
  final String filePath;
  final VoidCallback onSuccess;

  const _UploadScreenshotWithFileDialog({
    required this.projectId,
    required this.filePath,
    required this.onSuccess,
  });

  @override
  ConsumerState<_UploadScreenshotWithFileDialog> createState() =>
      __UploadScreenshotWithFileDialogState();
}

class __UploadScreenshotWithFileDialogState extends ConsumerState<_UploadScreenshotWithFileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _screenshotUploadService = ScreenshotUploadService();
  
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Auto-populate name from filename
    final fileName = widget.filePath.split('/').last;
    final nameWithoutExt = fileName.replaceAll(RegExp(r'\.[^.]*$'), '');
    _nameController.text = nameWithoutExt.replaceAll(RegExp(r'[_-]'), ' ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final file = File(widget.filePath);
    
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.upload,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          const Text('Upload Screenshot'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // File info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            file.path.split('/').last,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _screenshotUploadService.formatFileSize(file.lengthSync()),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: theme.colorScheme.onErrorContainer,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Name field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Screenshot Name *',
                  hintText: 'Enter a name for this screenshot',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Description field
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Optional description of the screenshot',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isUploading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: !_isUploading ? _uploadScreenshot : null,
          child: _isUploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Upload'),
        ),
      ],
    );
  }

  Future<void> _uploadScreenshot() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final database = ref.read(databaseProvider);
      final file = File(widget.filePath);
      
      final screenshot = await _screenshotUploadService.createScreenshotFromFile(
        projectId: widget.projectId,
        file: file,
        fileBytes: null,
        fileName: file.path.split('/').last,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      await database.insertScreenshot(screenshot, widget.projectId);
      
      widget.onSuccess();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Screenshot "${screenshot.name}" uploaded successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.of(context).pop(screenshot);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Upload failed: ${e.toString()}';
        _isUploading = false;
      });
    }
  }
}