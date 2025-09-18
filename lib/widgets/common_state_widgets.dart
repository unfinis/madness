import 'package:flutter/material.dart';

/// Common reusable state widgets to reduce code duplication across screens
class CommonStateWidgets {
  CommonStateWidgets._();

  /// Standard loading widget with optional message
  static Widget loading({String? message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Standard loading widget with padding for list/grid contexts
  static Widget loadingWithPadding({String? message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: loading(message: message),
      ),
    );
  }

  /// Standard error widget with optional retry callback
  static Widget error(
    String message, {
    VoidCallback? onRetry,
    IconData? icon,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.error_outline,
              size: 64,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Empty state widget with customizable content
  static Widget emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? action,
    Color? iconColor,
    bool showBackground = false,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final effectiveIconColor = iconColor ?? theme.colorScheme.outline;

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24),
                if (showBackground)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  )
                else
                  Icon(
                    icon,
                    size: 64,
                    color: effectiveIconColor,
                  ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (action != null) ...[
                  const SizedBox(height: 32),
                  action,
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  /// No project selected state - commonly used across screens
  static Widget noProjectSelected({VoidCallback? onSelectProject}) {
    return emptyState(
      icon: Icons.folder_open,
      title: 'No project selected',
      subtitle: 'Please select a project to continue',
      showBackground: true,
      action: onSelectProject != null
          ? ElevatedButton.icon(
              onPressed: onSelectProject,
              icon: const Icon(Icons.folder),
              label: const Text('Select Project'),
            )
          : null,
    );
  }

  /// Generic empty data state
  static Widget noData({
    required String itemName,
    IconData? icon,
    VoidCallback? onCreate,
    String? createButtonText,
  }) {
    return emptyState(
      icon: icon ?? Icons.inbox_outlined,
      title: 'No $itemName found',
      subtitle: 'Try adjusting your filters or create new $itemName',
      action: onCreate != null
          ? ElevatedButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add),
              label: Text(createButtonText ?? 'Add ${itemName.replaceAll('s', '')}'),
            )
          : null,
    );
  }
}

/// Reusable stat card widget for dashboard-style displays
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.color,
    this.onTap,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.dividerColor),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: effectiveColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 28,
                  color: effectiveColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectiveColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable responsive grid builder for stat cards or similar items
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.maxCrossAxisExtent = 200.0,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 16.0,
    this.mainAxisSpacing = 16.0,
    this.padding = EdgeInsets.zero,
  });

  final List<Widget> children;
  final double maxCrossAxisExtent;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}