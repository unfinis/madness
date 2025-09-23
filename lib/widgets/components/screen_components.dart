import 'package:flutter/material.dart';
import '../../constants/app_spacing.dart';

/// Screen-level components for consistent layout and design
class ScreenComponents {
  ScreenComponents._();

  // ================== LAYOUT COMPONENTS ==================

  /// Standard screen wrapper with consistent padding and responsive behavior
  static Widget buildScreenWrapper({
    required BuildContext context,
    required List<Widget> children,
    EdgeInsets? padding,
    bool addSafeArea = true,
    Color? backgroundColor,
  }) {
    final content = SingleChildScrollView(
      padding: padding ?? _getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );

    if (addSafeArea) {
      return SafeArea(
        child: Container(
          color: backgroundColor,
          child: content,
        ),
      );
    }

    return Container(
      color: backgroundColor,
      child: content,
    );
  }

  /// Responsive card container with consistent styling
  static Widget buildResponsiveCard({
    required BuildContext context,
    required Widget child,
    EdgeInsets? padding,
    double? elevation,
    Color? backgroundColor,
    BorderRadius? borderRadius,
  }) {
    return Card(
      elevation: elevation ?? 2,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: Padding(
        padding: padding ?? AppSpacing.contentPadding,
        child: child,
      ),
    );
  }

  /// Standard section header with optional action
  static Widget buildSectionHeader({
    required BuildContext context,
    required String title,
    String? subtitle,
    Widget? action,
    IconData? icon,
    bool showDivider = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppSizes.iconLG,
                color: Theme.of(context).colorScheme.primary,
              ),
              AppSpacing.hGapMD,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (subtitle != null) ...[
                    AppSpacing.vGapXS,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) action,
          ],
        ),
        if (showDivider) ...[
          AppSpacing.vGapLG,
          Divider(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ],
      ],
    );
  }

  // ================== STATS & METRICS ==================

  /// Stats card for displaying key metrics
  static Widget buildStatsCard({
    required BuildContext context,
    required String title,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    final card = Container(
      padding: AppSpacing.contentPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: (iconColor ?? Theme.of(context).colorScheme.primary)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                  ),
                  child: Icon(
                    icon,
                    size: AppSizes.iconMD,
                    color: iconColor ?? Theme.of(context).colorScheme.primary,
                  ),
                ),
                AppSpacing.hGapSM,
              ],
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vGapSM,
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            AppSpacing.vGapXS,
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: card,
      );
    }

    return card;
  }

  /// Stats bar with multiple metrics
  static Widget buildStatsBar({
    required BuildContext context,
    required List<StatsItem> stats,
    bool isCompact = false,
  }) {
    final crossAxisCount = _getStatsColumns(context, stats.length);

    if (isCompact) {
      return Row(
        children: stats.map((stat) =>
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _buildCompactStatItem(context, stat),
            ),
          ),
        ).toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3.5,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) => buildStatsCard(
        context: context,
        title: stats[index].title,
        value: stats[index].value,
        subtitle: stats[index].subtitle,
        icon: stats[index].icon,
        iconColor: stats[index].iconColor,
        backgroundColor: stats[index].backgroundColor,
        onTap: stats[index].onTap,
      ),
    );
  }

  static Widget _buildCompactStatItem(BuildContext context, StatsItem stat) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: stat.backgroundColor ?? Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (stat.icon != null) ...[
            Icon(
              stat.icon!,
              size: AppSizes.iconSM,
              color: stat.iconColor ?? Theme.of(context).colorScheme.primary,
            ),
            AppSpacing.vGapXS,
          ],
          Text(
            stat.value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            stat.title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ================== ACTION COMPONENTS ==================

  /// Standard floating action button with consistent styling
  static Widget buildFloatingActionButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required IconData icon,
    String? tooltip,
    bool isExtended = false,
    String? label,
  }) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        tooltip: tooltip,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      child: Icon(icon),
    );
  }

  /// Standard action button row for screens
  static Widget buildActionButtonRow({
    required BuildContext context,
    required List<ActionButton> buttons,
    MainAxisAlignment alignment = MainAxisAlignment.end,
  }) {
    return Row(
      mainAxisAlignment: alignment,
      children: buttons.map((button) {
        Widget buttonWidget;

        switch (button.type) {
          case ActionButtonType.primary:
            buttonWidget = FilledButton.icon(
              onPressed: button.onPressed,
              icon: button.icon != null ? Icon(button.icon!, size: AppSizes.iconSM) : const SizedBox.shrink(),
              label: Text(button.label),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                ),
              ),
            );
            break;
          case ActionButtonType.secondary:
            buttonWidget = OutlinedButton.icon(
              onPressed: button.onPressed,
              icon: button.icon != null ? Icon(button.icon!, size: AppSizes.iconSM) : const SizedBox.shrink(),
              label: Text(button.label),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                ),
              ),
            );
            break;
          case ActionButtonType.text:
            buttonWidget = TextButton.icon(
              onPressed: button.onPressed,
              icon: button.icon != null ? Icon(button.icon!, size: AppSizes.iconSM) : const SizedBox.shrink(),
              label: Text(button.label),
            );
            break;
        }

        return Padding(
          padding: const EdgeInsets.only(left: AppSpacing.sm),
          child: buttonWidget,
        );
      }).toList(),
    );
  }

  // ================== EMPTY STATES ==================

  /// Standard empty state widget
  static Widget buildEmptyState({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String? actionText,
    VoidCallback? onAction,
    Color? iconColor,
  }) {
    return Center(
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.inbox_rounded,
              size: AppSizes.huge,
              color: iconColor ?? Theme.of(context).colorScheme.outline,
            ),
            AppSpacing.vGapLG,
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            AppSpacing.vGapSM,
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              AppSpacing.vGapXL,
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add_rounded, size: AppSizes.iconSM),
                label: Text(actionText),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================== HELPER METHODS ==================

  static EdgeInsets _getResponsivePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return AppSpacing.contentPadding;
    } else if (width < 900) {
      return const EdgeInsets.all(AppSpacing.xl);
    } else {
      return const EdgeInsets.all(AppSpacing.xxl);
    }
  }

  static int _getStatsColumns(BuildContext context, int itemCount) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      return itemCount > 2 ? 2 : itemCount;
    } else if (width < 900) {
      return itemCount > 3 ? 3 : itemCount;
    } else {
      return itemCount > 4 ? 4 : itemCount;
    }
  }
}

// ================== DATA CLASSES ==================

/// Data class for stats items
class StatsItem {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const StatsItem({
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });
}

/// Data class for action buttons
class ActionButton {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ActionButtonType type;

  const ActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.type = ActionButtonType.primary,
  });
}

enum ActionButtonType {
  primary,
  secondary,
  text,
}