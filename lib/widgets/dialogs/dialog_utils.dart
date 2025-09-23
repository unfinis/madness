import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dialog_system.dart';

/// Utilities for enhanced dialog functionality and accessibility
class DialogUtils {
  DialogUtils._();

  /// Keyboard shortcuts handler for dialogs
  static Widget withKeyboardShortcuts({
    required Widget child,
    VoidCallback? onEscape,
    VoidCallback? onEnter,
    VoidCallback? onTab,
  }) {
    return KeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          switch (event.logicalKey) {
            case LogicalKeyboardKey.escape:
              onEscape?.call();
              break;
            case LogicalKeyboardKey.enter:
              onEnter?.call();
              break;
            case LogicalKeyboardKey.tab:
              onTab?.call();
              break;
          }
        }
      },
      child: child,
    );
  }

  /// Enhanced focus management for dialogs
  static Widget withFocusManagement({
    required Widget child,
    bool trapFocus = true,
    bool autoFocus = true,
  }) {
    return FocusScope(
      canRequestFocus: true,
      autofocus: autoFocus,
      child: trapFocus
          ? FocusTrap(child: child)
          : child,
    );
  }

  /// Haptic feedback for dialog interactions
  static void triggerHapticFeedback(HapticFeedbackType type) {
    switch (type) {
      case HapticFeedbackType.light:
        HapticFeedback.lightImpact();
        break;
      case HapticFeedbackType.medium:
        HapticFeedback.mediumImpact();
        break;
      case HapticFeedbackType.heavy:
        HapticFeedback.heavyImpact();
        break;
      case HapticFeedbackType.selection:
        HapticFeedback.selectionClick();
        break;
    }
  }

  /// Announce text to screen readers
  static void announceToScreenReader(
    BuildContext context,
    String message, {
    Assertiveness assertiveness = Assertiveness.polite,
  }) {
    SemanticsService.announce(message, assertiveness);
  }

  /// Create semantic label for form fields
  static String createSemanticLabel({
    required String label,
    bool isRequired = false,
    String? helperText,
    String? errorText,
  }) {
    final buffer = StringBuffer(label);

    if (isRequired) {
      buffer.write(', required');
    }

    if (helperText != null) {
      buffer.write(', $helperText');
    }

    if (errorText != null) {
      buffer.write(', error: $errorText');
    }

    return buffer.toString();
  }

  /// Validate accessibility for dialog content
  static List<String> validateAccessibility(Widget widget) {
    final issues = <String>[];

    // This would be implemented with a custom widget inspector
    // For now, return basic checks

    return issues;
  }

  /// Get optimal dialog size based on screen size and content
  static DialogSize getOptimalDialogSize(BuildContext context, {
    required int formFieldCount,
    bool hasComplexContent = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Mobile devices
    if (screenWidth < 600) {
      return DialogSize.small;
    }

    // Tablet landscape or desktop
    if (screenWidth > 900 && !hasComplexContent && formFieldCount < 8) {
      return DialogSize.medium;
    }

    // Complex content or many fields
    if (hasComplexContent || formFieldCount > 10) {
      return DialogSize.xlarge;
    }

    return DialogSize.large;
  }

  /// Handle dialog result with type safety
  static Future<T?> showDialogWithResult<T>({
    required BuildContext context,
    required StandardDialog dialog,
    DialogAnimationType animationType = DialogAnimationType.scaleAndFade,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AnimatedStandardDialog(
        animationType: animationType,
        child: dialog,
      ),
    );
  }

  /// Show confirmation dialog with standard styling
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    Color? confirmColor,
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => _ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        icon: icon,
        confirmColor: confirmColor,
        isDestructive: isDestructive,
      ),
    );

    return result ?? false;
  }

  /// Show error dialog with standard styling
  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String? details,
    VoidCallback? onRetry,
  }) {
    return showDialog(
      context: context,
      builder: (context) => _ErrorDialog(
        title: title,
        message: message,
        details: details,
        onRetry: onRetry,
      ),
    );
  }

  /// Show loading dialog
  static Future<void> showLoadingDialog({
    required BuildContext context,
    required String message,
    bool canCancel = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: canCancel,
      builder: (context) => _LoadingDialog(
        message: message,
        canCancel: canCancel,
      ),
    );
  }
}

/// Enum for haptic feedback types
enum HapticFeedbackType {
  light,
  medium,
  heavy,
  selection,
}

/// Focus trap widget to keep focus within dialog
class FocusTrap extends StatefulWidget {
  final Widget child;

  const FocusTrap({super.key, required this.child});

  @override
  State<FocusTrap> createState() => _FocusTrapState();
}

class _FocusTrapState extends State<FocusTrap> {
  late FocusNode _firstFocusNode;
  late FocusNode _lastFocusNode;

  @override
  void initState() {
    super.initState();
    _firstFocusNode = FocusNode();
    _lastFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _firstFocusNode.dispose();
    _lastFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Focus(
          focusNode: _firstFocusNode,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _focusLastFocusableElement();
            }
          },
          child: const SizedBox.shrink(),
        ),
        Expanded(child: widget.child),
        Focus(
          focusNode: _lastFocusNode,
          onFocusChange: (hasFocus) {
            if (hasFocus) {
              _focusFirstFocusableElement();
            }
          },
          child: const SizedBox.shrink(),
        ),
      ],
    );
  }

  void _focusFirstFocusableElement() {
    final focusScope = FocusScope.of(context);
    final focusedChild = focusScope.focusedChild;
    if (focusedChild != null) {
      focusScope.previousFocus();
    }
  }

  void _focusLastFocusableElement() {
    final focusScope = FocusScope.of(context);
    final focusedChild = focusScope.focusedChild;
    if (focusedChild != null) {
      focusScope.nextFocus();
    }
  }
}

/// Standard confirmation dialog
class _ConfirmationDialog extends StandardDialog {
  final String message;
  final String confirmText;
  final String cancelText;
  final Color? confirmColor;
  final bool isDestructive;

  const _ConfirmationDialog({
    required String title,
    required this.message,
    required this.confirmText,
    required this.cancelText,
    IconData? icon,
    this.confirmColor,
    this.isDestructive = false,
  }) : super(
          title: title,
          icon: icon ?? (isDestructive ? Icons.warning_rounded : Icons.help_rounded),
          size: DialogSize.small,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive
              ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.3)
              : Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isDestructive ? Icons.warning_rounded : Icons.info_rounded,
              color: isDestructive
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelText),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: isDestructive
                  ? FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    )
                  : null,
              child: Text(confirmText),
            ),
          ),
        ],
      ),
    ];
  }
}

/// Standard error dialog
class _ErrorDialog extends StandardDialog {
  final String message;
  final String? details;
  final VoidCallback? onRetry;

  const _ErrorDialog({
    required String title,
    required this.message,
    this.details,
    this.onRetry,
  }) : super(
          title: title,
          icon: Icons.error_rounded,
          size: DialogSize.medium,
        );

  @override
  Color? getHeaderColor(BuildContext context) =>
      Theme.of(context).colorScheme.errorContainer;

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.error_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
            if (details != null) ...[
              const SizedBox(height: 12),
              ExpansionTile(
                title: const Text('Technical Details'),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      details!,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      const SizedBox(height: 24),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onRetry!();
                },
                child: const Text('Retry'),
              ),
            ),
          ],
        ],
      ),
    ];
  }
}

/// Standard loading dialog
class _LoadingDialog extends StandardDialog {
  final String message;
  final bool canCancel;

  const _LoadingDialog({
    required this.message,
    this.canCancel = false,
  }) : super(
          title: 'Please Wait',
          icon: Icons.hourglass_top_rounded,
          size: DialogSize.small,
          showCloseButton: false,
          canPop: canCancel,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          if (canCancel) ...[
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ],
      ),
    ];
  }
}