/// Unified Dialog Design System
///
/// This library provides a comprehensive dialog system with consistent styling,
/// accessibility features, and enhanced UX for the Madness application.
///
/// ## Core Components
///
/// - [StandardDialog] - Base class for all dialogs
/// - [DialogComponents] - Reusable UI components
/// - [DialogUtils] - Utility functions and helpers
///
/// ## Usage
///
/// ```dart
/// import 'package:madness/widgets/dialogs/index.dart';
///
/// class MyDialog extends StandardDialog {
///   // Implementation
/// }
///
/// // Show dialog
/// await showStandardDialog(
///   context: context,
///   dialog: const MyDialog(),
/// );
/// ```
///
/// See README.md for complete documentation and examples.

library;

// Core dialog system
export 'dialog_system.dart';

// Reusable components
export 'dialog_components.dart';

// Utilities and helpers
export 'dialog_utils.dart';

// Re-export commonly used classes for convenience
export 'package:flutter/material.dart'
    show
        BuildContext,
        Widget,
        StatelessWidget,
        StatefulWidget,
        State,
        IconData,
        Icons,
        TextEditingController,
        GlobalKey,
        FormState,
        Navigator;

// Re-export app constants
export '../../constants/app_spacing.dart';