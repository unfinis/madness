import 'package:flutter/material.dart';
import '../../constants/app_spacing.dart';

/// Unified dialog design system constants
class DialogConstants {
  // Updated dialog styling constants
  static const double borderRadius = 16.0;
  static const double headerBorderRadius = 16.0;
  static const double fieldBorderRadius = 12.0;
  static const double buttonBorderRadius = 12.0;

  // Standard dialog sizes
  static const double smallDialogWidth = 400.0;
  static const double mediumDialogWidth = 600.0;
  static const double largeDialogWidth = 800.0;
  static const double xlargeDialogWidth = 1000.0;

  // Standard heights
  static const double maxDialogHeight = 700.0;
  static const double compactMaxHeight = 500.0;

  // Animation constants
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 200);
}

/// Standard dialog size enum
enum DialogSize {
  small(DialogConstants.smallDialogWidth),
  medium(DialogConstants.mediumDialogWidth),
  large(DialogConstants.largeDialogWidth),
  xlarge(DialogConstants.xlargeDialogWidth);

  const DialogSize(this.width);
  final double width;
}

/// Base class for all standardized dialogs
abstract class StandardDialog extends StatelessWidget {
  const StandardDialog({
    super.key,
    this.size = DialogSize.medium,
    this.maxHeight,
    this.showCloseButton = true,
    this.canPop = true,
    this.scrollable = true,
  });

  final DialogSize size;
  final double? maxHeight;
  final bool showCloseButton;
  final bool canPop;
  final bool scrollable;

  // Abstract getters to implement
  String get title;
  String? get subtitle => null;
  IconData? get headerIcon => null;

  // Abstract methods to implement
  Widget buildContent(BuildContext context);
  List<Widget>? buildActions(BuildContext context) => null;

  // Optional overrides
  Color? getHeaderColor(BuildContext context) => null;
  Widget? buildCustomHeader(BuildContext context) => null;
  EdgeInsets getContentPadding() => AppSpacing.dialogContentPadding;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: _getDialogWidth(context),
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? DialogConstants.maxDialogHeight,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(DialogConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              Flexible(
                child: scrollable
                  ? SingleChildScrollView(
                      padding: getContentPadding(),
                      child: buildContent(context),
                    )
                  : Padding(
                      padding: getContentPadding(),
                      child: buildContent(context),
                    ),
              ),
              if (buildActions(context) != null) _buildActionBar(context),
            ],
          ),
        ),
      ),
    );
  }

  double _getDialogWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) return screenWidth * 0.9;
    return size.width.clamp(0, screenWidth * 0.9);
  }

  Widget _buildHeader(BuildContext context) {
    final customHeader = buildCustomHeader(context);
    if (customHeader != null) return customHeader;

    final headerColor = getHeaderColor(context) ??
        Theme.of(context).colorScheme.primaryContainer;

    return Container(
      padding: AppSpacing.dialogHeaderPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            headerColor,
            headerColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(DialogConstants.headerBorderRadius),
          topRight: Radius.circular(DialogConstants.headerBorderRadius),
        ),
      ),
      child: Row(
        children: [
          if (headerIcon != null) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(DialogConstants.fieldBorderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                headerIcon!,
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppSizes.iconLG,
              ),
            ),
            AppSpacing.hGapLG,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                if (subtitle != null) ...[
                  AppSpacing.vGapXS,
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer
                          .withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showCloseButton)
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded),
              style: IconButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.surface
                    .withValues(alpha: 0.9),
                foregroundColor: Theme.of(context).colorScheme.onSurface,
              ),
              tooltip: 'Close',
            ),
        ],
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    final actions = buildActions(context)!;

    return Container(
      padding: AppSpacing.dialogActionsPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(DialogConstants.borderRadius),
          bottomRight: Radius.circular(DialogConstants.borderRadius),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < actions.length; i++) ...[
            if (i > 0) AppSpacing.hGapLG,
            Expanded(child: actions[i]),
          ],
        ],
      ),
    );
  }
}

/// Animated dialog wrapper for enhanced UX
class AnimatedStandardDialog extends StatefulWidget {
  const AnimatedStandardDialog({
    super.key,
    required this.child,
    this.animationType = DialogAnimationType.scaleAndFade,
  });

  final StandardDialog child;
  final DialogAnimationType animationType;

  @override
  State<AnimatedStandardDialog> createState() => _AnimatedStandardDialogState();
}

enum DialogAnimationType {
  scaleAndFade,
  slideFromBottom,
  slideFromTop,
  fade,
}

class _AnimatedStandardDialogState extends State<AnimatedStandardDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: DialogConstants.animationDuration,
      vsync: this,
    );

    switch (widget.animationType) {
      case DialogAnimationType.scaleAndFade:
        _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
        );
        _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeIn),
        );
        break;
      case DialogAnimationType.slideFromBottom:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
        _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
        break;
      case DialogAnimationType.slideFromTop:
        _slideAnimation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
        _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
        break;
      case DialogAnimationType.fade:
        _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeIn),
        );
        break;
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget dialogWidget = widget.child;

        // Apply animations based on type
        switch (widget.animationType) {
          case DialogAnimationType.scaleAndFade:
            dialogWidget = ScaleTransition(
              scale: _scaleAnimation,
              child: dialogWidget,
            );
            break;
          case DialogAnimationType.slideFromBottom:
          case DialogAnimationType.slideFromTop:
            dialogWidget = SlideTransition(
              position: _slideAnimation,
              child: dialogWidget,
            );
            break;
          case DialogAnimationType.fade:
            break; // Fade is applied below
        }

        return FadeTransition(
          opacity: _fadeAnimation,
          child: dialogWidget,
        );
      },
    );
  }
}

/// Convenience method to show animated dialogs
Future<T?> showStandardDialog<T>({
  required BuildContext context,
  required StandardDialog dialog,
  DialogAnimationType animationType = DialogAnimationType.scaleAndFade,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder: (context) => AnimatedStandardDialog(
      animationType: animationType,
      child: dialog,
    ),
  );
}