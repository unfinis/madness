import 'package:flutter/material.dart';

/// Configuration for screen-specific top bar content
class TopBarConfig {
  final String title;
  final List<TopBarAction> actions;

  const TopBarConfig({
    required this.title,
    this.actions = const [],
  });
}

/// Represents an action button in the top bar
class TopBarAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final String? tooltip;
  final bool isPrimary;

  const TopBarAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.tooltip,
    this.isPrimary = false,
  });
}

/// Widget that builds action buttons for the top bar
class TopBarActions extends StatelessWidget {
  final List<TopBarAction> actions;

  const TopBarActions({
    super.key,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // This widget is only used for buildActions method
  }

  /// Build actions as a list of widgets for AppBar actions
  List<Widget> buildActions(BuildContext context) {
    if (actions.isEmpty) return [];

    // Use icon-only style for all screen sizes for a clean, compact look
    return actions.map((action) {
      if (action.isPrimary) {
        // Primary actions get a filled icon button for emphasis
        return IconButton.filled(
          onPressed: action.onPressed,
          icon: Icon(action.icon),
          tooltip: action.tooltip ?? action.label,
          style: IconButton.styleFrom(
            padding: const EdgeInsets.all(8),
          ),
        );
      } else {
        // Secondary actions get standard icon buttons
        return IconButton(
          onPressed: action.onPressed,
          icon: Icon(action.icon),
          tooltip: action.tooltip ?? action.label,
        );
      }
    }).toList();
  }

}

/// Mixin that screens can use to provide top bar configuration
mixin HasTopBarConfig {
  TopBarConfig getTopBarConfig(BuildContext context);
}