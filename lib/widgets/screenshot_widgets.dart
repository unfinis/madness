import 'package:flutter/material.dart';
import '../models/screenshot.dart';
import '../models/screenshot_category.dart';
import '../constants/app_spacing.dart';

class ScreenshotWidgets {
  /// Creates a category badge with consistent styling
  static Widget categoryBadge(String category, ThemeData theme) {
    final categoryEnum = ScreenshotCategory.fromValue(category);
    
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: _getCategoryColor(categoryEnum),
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 3), // 12px radius
      ),
      child: Text(
        categoryEnum.displayName,
        style: theme.textTheme.captionSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Creates a status badge for edited/raw/redacted screenshots
  static Widget statusBadge(Screenshot screenshot, ThemeData theme) {
    if (screenshot.hasRedactions) {
      return _buildStatusBadge('Redacted', theme.colorScheme.error, theme);
    } else if (screenshot.hasEditedLayers) {
      return _buildStatusBadge('Edited', theme.colorScheme.primary, theme);
    } else {
      return _buildStatusBadge('Raw', theme.colorScheme.outline, theme);
    }
  }

  /// Creates a finding count badge
  static Widget findingCountBadge(int count, ThemeData theme) {
    if (count == 0) return const SizedBox.shrink();
    
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 3),
        border: Border.all(
          color: theme.colorScheme.error.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bug_report,
            size: AppSizes.iconXS,
            color: theme.colorScheme.onErrorContainer,
          ),
          AppSpacing.hGapXS,
          Text(
            count.toString(),
            style: theme.textTheme.captionSmall.copyWith(
              color: theme.colorScheme.onErrorContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a finding tag chip
  static Widget findingTag(String findingId, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs * 1.5, // 6px
        vertical: AppSpacing.xs * 0.5, // 2px
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 2), // 8px radius
      ),
      child: Text(
        findingId,
        style: theme.textTheme.captionSmall.copyWith(
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
    );
  }

  /// Creates a screenshot thumbnail container with consistent styling
  static Widget thumbnailContainer({
    required Widget child,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
      ),
      child: child,
    );
  }

  /// Creates a placeholder icon for screenshots
  static Widget thumbnailPlaceholder({double size = AppSizes.iconXL * 1.5}) {
    return Icon(
      Icons.image,
      size: size,
      color: Colors.grey.shade400,
    );
  }

  /// Creates a view mode toggle button
  static Widget viewModeButton({
    required IconData icon,
    required String mode,
    required String tooltip,
    required String currentMode,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    final isSelected = currentMode == mode;
    
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        child: Container(
          padding: AppSpacing.buttonPadding,
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : null,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
          ),
          child: Icon(
            icon,
            size: AppSizes.iconMD,
            color: isSelected 
                ? theme.colorScheme.onPrimary 
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  /// Creates a filter chip with consistent styling
  static Widget filterChip({
    required String label,
    required String value,
    required String currentValue,
    required ValueChanged<String> onSelected,
    required ThemeData theme,
  }) {
    final isSelected = currentValue == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(value),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected 
            ? theme.colorScheme.onPrimaryContainer 
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }

  /// Creates a section header with consistent styling
  static Widget sectionHeader({
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppSizes.iconXL,
          color: theme.colorScheme.primary,
        ),
        AppSpacing.hGapLG,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Private helper methods
  static Widget _buildStatusBadge(String label, Color color, ThemeData theme) {
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 3),
      ),
      child: Text(
        label,
        style: theme.textTheme.captionSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static Color _getCategoryColor(ScreenshotCategory category) {
    switch (category) {
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
}

/// Format utilities for screenshots
class ScreenshotFormatUtils {
  /// Formats file size in human readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  /// Formats relative time
  static String formatRelativeTime(DateTime dateTime) {
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

  /// Formats timeline date
  static String formatTimelineDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) return 'Today';
    if (dateOnly == yesterday) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}