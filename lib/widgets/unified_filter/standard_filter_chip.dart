import 'package:flutter/material.dart';
import '../../constants/filter_breakpoints.dart';

/// Standardized filter chip component with consistent design across all screens
class StandardFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? badge;
  final bool enabled;

  const StandardFilterChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.icon,
    this.badge,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final height = FilterBreakpoints.getChipHeight(screenWidth);
    final borderRadius = FilterBreakpoints.isMobile(screenWidth) ? 18.0 : 16.0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onPressed : null,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: height,
          constraints: const BoxConstraints(
            minWidth: 44, // Minimum touch target
            maxWidth: 200, // Prevent overly long chips
          ),
          padding: EdgeInsets.symmetric(
            horizontal: FilterBreakpoints.isMobile(screenWidth) ? 12 : 16,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: _getBackgroundColor(theme),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: _getBorderColor(theme),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: _getContentColor(theme),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: _getContentColor(theme),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (badge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badge!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              if (isSelected) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check,
                  size: 14,
                  color: _getContentColor(theme),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(ThemeData theme) {
    if (!enabled) {
      return theme.colorScheme.surfaceContainer.withValues(alpha: 0.5);
    }

    if (isSelected) {
      return theme.colorScheme.primaryContainer;
    }

    return theme.colorScheme.surfaceContainer;
  }

  Color _getBorderColor(ThemeData theme) {
    if (!enabled) {
      return theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    }

    if (isSelected) {
      return theme.colorScheme.primary.withValues(alpha: 0.5);
    }

    return theme.colorScheme.outlineVariant;
  }

  Color _getContentColor(ThemeData theme) {
    if (!enabled) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.5);
    }

    if (isSelected) {
      return theme.colorScheme.onPrimaryContainer;
    }

    return theme.colorScheme.onSurface;
  }
}