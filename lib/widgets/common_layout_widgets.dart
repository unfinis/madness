import 'package:flutter/material.dart';
import '../constants/responsive_breakpoints.dart';

/// Common reusable layout widgets for consistent screen layouts
class CommonLayoutWidgets {
  CommonLayoutWidgets._();

  /// Standard screen padding based on responsive breakpoints
  static EdgeInsets getScreenPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    return EdgeInsets.all(isDesktop ? 24.0 : 16.0);
  }

  /// Standard card padding based on responsive breakpoints
  static EdgeInsets getCardPadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    return EdgeInsets.all(isDesktop ? 20.0 : 16.0);
  }

  /// Standard section spacing
  static const double sectionSpacing = 24.0;
  static const double itemSpacing = 16.0;
  static const double compactSpacing = 8.0;
}

/// Reusable screen wrapper that provides consistent layout structure
class ScreenWrapper extends StatelessWidget {
  const ScreenWrapper({
    super.key,
    required this.children,
    this.padding,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.backgroundColor,
  });

  final List<Widget> children;
  final EdgeInsets? padding;
  final CrossAxisAlignment crossAxisAlignment;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: padding ?? CommonLayoutWidgets.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          children: children,
        ),
      ),
    );
  }
}

/// Card wrapper with consistent styling and responsive padding
class ResponsiveCard extends StatelessWidget {
  const ResponsiveCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.elevation,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      child: Padding(
        padding: padding ?? CommonLayoutWidgets.getCardPadding(context),
        child: child,
      ),
    );
  }
}

/// Responsive action button bar that adapts to screen width
class ResponsiveActionBar extends StatelessWidget {
  const ResponsiveActionBar({
    super.key,
    required this.actions,
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  });

  final List<Widget> actions;
  final MainAxisAlignment mainAxisAlignment;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Use Row for wide screens, Wrap for narrow screens
    if (screenWidth > 600) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: actions
            .expand((action) => [action, SizedBox(width: spacing)])
            .take(actions.length * 2 - 1)
            .toList(),
      );
    }
    
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: spacing,
      runSpacing: runSpacing,
      children: actions,
    );
  }
}

/// Standard section header with title and optional action
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final Widget? action;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// Responsive layout builder that provides consistent breakpoints
class ResponsiveLayoutBuilder extends StatelessWidget {
  const ResponsiveLayoutBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (ResponsiveBreakpoints.isDesktop(screenWidth)) {
      return desktop;
    }
    
    if (ResponsiveBreakpoints.isTablet(screenWidth) && tablet != null) {
      return tablet!;
    }
    
    return mobile;
  }
}

/// Reusable list/grid toggle for data views
class ViewToggle extends StatelessWidget {
  const ViewToggle({
    super.key,
    required this.isGridView,
    required this.onToggle,
    this.gridLabel = 'Grid',
    this.listLabel = 'List',
  });

  final bool isGridView;
  final ValueChanged<bool> onToggle;
  final String gridLabel;
  final String listLabel;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<bool>(
      segments: [
        ButtonSegment<bool>(
          value: false,
          icon: const Icon(Icons.view_agenda, size: 16),
          label: Text(listLabel),
        ),
        ButtonSegment<bool>(
          value: true,
          icon: const Icon(Icons.grid_view, size: 16),
          label: Text(gridLabel),
        ),
      ],
      selected: {isGridView},
      onSelectionChanged: (selection) => onToggle(selection.first),
      style: SegmentedButton.styleFrom(
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

/// Reusable search bar with consistent styling
class CommonSearchBar extends StatelessWidget {
  const CommonSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onClear,
    this.prefixIcon = Icons.search,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final IconData prefixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  controller.clear();
                  onClear?.call();
                },
                icon: const Icon(Icons.clear),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        isDense: true,
      ),
    );
  }
}