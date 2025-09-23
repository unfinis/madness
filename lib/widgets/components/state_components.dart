import 'package:flutter/material.dart';
import '../../constants/app_spacing.dart';

/// State management components for loading, error, and empty states
class StateComponents {
  StateComponents._();

  // ================== LOADING STATES ==================

  /// Standard loading indicator with optional message
  static Widget buildLoadingIndicator({
    required BuildContext context,
    String? message,
    double? size,
    Color? color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            AppSpacing.vGapLG,
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  /// Skeleton loading placeholder for content
  static Widget buildSkeleton({
    required BuildContext context,
    double? width,
    double? height,
    BorderRadius? borderRadius,
  }) {
    return Container(
      width: width,
      height: height ?? 16,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: borderRadius ?? BorderRadius.circular(AppSizes.chipRadius),
      ),
    );
  }

  /// Animated skeleton shimmer effect
  static Widget buildShimmerSkeleton({
    required BuildContext context,
    required Widget child,
    bool isLoading = true,
  }) {
    if (!isLoading) return child;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: _ShimmerEffect(
        baseColor: Theme.of(context).colorScheme.surfaceContainer,
        highlightColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5),
        child: child,
      ),
    );
  }

  /// Card skeleton loader
  static Widget buildCardSkeleton({
    required BuildContext context,
    int itemCount = 3,
    double? itemHeight,
  }) {
    return Column(
      children: List.generate(
        itemCount,
        (index) => Card(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildSkeleton(context: context, height: 20, width: 200),
                AppSpacing.vGapSM,
                buildSkeleton(context: context, height: 16, width: 150),
                AppSpacing.vGapSM,
                buildSkeleton(context: context, height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Table skeleton loader
  static Widget buildTableSkeleton({
    required BuildContext context,
    int columnCount = 4,
    int rowCount = 5,
  }) {
    return Card(
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: Column(
          children: [
            // Header skeleton
            Row(
              children: List.generate(
                columnCount,
                (index) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    child: buildSkeleton(context: context, height: 18),
                  ),
                ),
              ),
            ),
            AppSpacing.vGapLG,
            // Row skeletons
            ...List.generate(
              rowCount,
              (rowIndex) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: List.generate(
                    columnCount,
                    (colIndex) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        child: buildSkeleton(context: context, height: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// List skeleton loader
  static Widget buildListSkeleton({
    required BuildContext context,
    int itemCount = 5,
    bool hasAvatar = false,
    bool hasSubtitle = true,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => Card(
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: ListTile(
          leading: hasAvatar
            ? buildSkeleton(
                context: context,
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
          title: buildSkeleton(context: context, height: 16, width: 120),
          subtitle: hasSubtitle
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.vGapSM,
                  buildSkeleton(context: context, height: 14, width: 180),
                  AppSpacing.vGapXS,
                  buildSkeleton(context: context, height: 12, width: 100),
                ],
              )
            : null,
          trailing: buildSkeleton(
            context: context,
            width: 20,
            height: 20,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // ================== ERROR STATES ==================

  /// Standard error display with retry option
  static Widget buildErrorState({
    required BuildContext context,
    required String title,
    required String message,
    String? details,
    IconData? icon,
    String? retryText,
    VoidCallback? onRetry,
    String? supportText,
    VoidCallback? onSupport,
    bool showDetails = false,
  }) {
    return Center(
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.huge),
              ),
              child: Icon(
                icon ?? Icons.error_outline_rounded,
                size: AppSizes.huge,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            AppSpacing.vGapXL,
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
            if (details != null && showDetails) ...[
              AppSpacing.vGapLG,
              Container(
                width: double.infinity,
                padding: AppSpacing.cardPadding,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technical Details:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    AppSpacing.vGapSM,
                    SelectableText(
                      details,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            AppSpacing.vGapXL,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onRetry != null) ...[
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded, size: AppSizes.iconSM),
                    label: Text(retryText ?? 'Retry'),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                    ),
                  ),
                  if (onSupport != null) AppSpacing.hGapMD,
                ],
                if (onSupport != null)
                  OutlinedButton.icon(
                    onPressed: onSupport,
                    icon: const Icon(Icons.help_outline_rounded, size: AppSizes.iconSM),
                    label: Text(supportText ?? 'Get Help'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
                      ),
                    ),
                  ),
              ],
            ),
            if (details != null && !showDetails) ...[
              AppSpacing.vGapMD,
              TextButton(
                onPressed: () {
                  // This would typically show details in a dialog or expand the view
                },
                child: const Text('Show Details'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Network error with specific messaging
  static Widget buildNetworkError({
    required BuildContext context,
    VoidCallback? onRetry,
    bool isOffline = false,
  }) {
    return buildErrorState(
      context: context,
      title: isOffline ? 'No Internet Connection' : 'Network Error',
      message: isOffline
        ? 'Please check your internet connection and try again.'
        : 'Unable to connect to the server. Please try again.',
      icon: isOffline ? Icons.wifi_off_rounded : Icons.cloud_off_rounded,
      onRetry: onRetry,
    );
  }

  /// Permission error
  static Widget buildPermissionError({
    required BuildContext context,
    required String permission,
    VoidCallback? onRetry,
  }) {
    return buildErrorState(
      context: context,
      title: 'Permission Required',
      message: 'This app needs $permission permission to continue.',
      icon: Icons.lock_outline_rounded,
      retryText: 'Grant Permission',
      onRetry: onRetry,
    );
  }

  /// Not found error (404-style)
  static Widget buildNotFoundError({
    required BuildContext context,
    required String itemType,
    VoidCallback? onRetry,
  }) {
    return buildErrorState(
      context: context,
      title: '$itemType Not Found',
      message: 'The $itemType you\'re looking for doesn\'t exist or has been removed.',
      icon: Icons.search_off_rounded,
      retryText: 'Go Back',
      onRetry: onRetry,
    );
  }

  // ================== EMPTY STATES ==================

  /// Standard empty state
  static Widget buildEmptyState({
    required BuildContext context,
    required String title,
    required String message,
    IconData? icon,
    String? actionText,
    VoidCallback? onAction,
    Widget? customAction,
    Color? iconColor,
    bool showBackground = true,
  }) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showBackground)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5),
              borderRadius: BorderRadius.circular(AppSizes.huge),
            ),
            child: Icon(
              icon ?? Icons.inbox_rounded,
              size: AppSizes.huge,
              color: iconColor ?? Theme.of(context).colorScheme.outline,
            ),
          )
        else
          Icon(
            icon ?? Icons.inbox_rounded,
            size: AppSizes.huge,
            color: iconColor ?? Theme.of(context).colorScheme.outline,
          ),
        AppSpacing.vGapXL,
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
        if (customAction != null) ...[
          AppSpacing.vGapXL,
          customAction,
        ] else if (actionText != null && onAction != null) ...[
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
    );

    return Center(
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: content,
      ),
    );
  }

  /// Search results empty state
  static Widget buildSearchEmpty({
    required BuildContext context,
    required String searchTerm,
    VoidCallback? onClear,
  }) {
    return buildEmptyState(
      context: context,
      title: 'No Results Found',
      message: 'No items match "$searchTerm". Try adjusting your search terms.',
      icon: Icons.search_off_rounded,
      actionText: 'Clear Search',
      onAction: onClear,
    );
  }

  /// Filter results empty state
  static Widget buildFilterEmpty({
    required BuildContext context,
    VoidCallback? onClearFilters,
  }) {
    return buildEmptyState(
      context: context,
      title: 'No Items Match Filters',
      message: 'Try removing some filters to see more results.',
      icon: Icons.filter_list_off_rounded,
      actionText: 'Clear Filters',
      onAction: onClearFilters,
    );
  }

  // ================== PLACEHOLDER STATES ==================

  /// Placeholder for content being loaded
  static Widget buildContentPlaceholder({
    required BuildContext context,
    required String title,
    String? subtitle,
    IconData? icon,
  }) {
    return Center(
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon ?? Icons.hourglass_empty_rounded,
              size: AppSizes.huge,
              color: Theme.of(context).colorScheme.outline,
            ),
            AppSpacing.vGapLG,
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              AppSpacing.vGapSM,
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ================== PROGRESS INDICATORS ==================

  /// Linear progress with percentage
  static Widget buildLinearProgress({
    required BuildContext context,
    required double progress,
    String? label,
    bool showPercentage = true,
  }) {
    final percentage = (progress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        if (label != null) AppSpacing.vGapSM,
        ClipRRect(
          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// ================== SHIMMER EFFECT ==================

class _ShimmerEffect extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const _ShimmerEffect({
    required this.child,
    required this.baseColor,
    required this.highlightColor,
  });

  @override
  State<_ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<_ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: [
                0.0,
                0.5,
                1.0,
              ],
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}