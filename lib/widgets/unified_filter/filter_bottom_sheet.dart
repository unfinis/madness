import 'package:flutter/material.dart';

/// Modal bottom sheet for advanced filter options on mobile devices
class FilterBottomSheet extends StatelessWidget {
  final String title;
  final List<FilterSection> sections;
  final VoidCallback? onClearAll;
  final VoidCallback? onApply;
  final int? resultCount;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.sections,
    this.onClearAll,
    this.onApply,
    this.resultCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onClearAll != null)
                  TextButton(
                    onPressed: onClearAll,
                    child: Text(
                      'Clear All',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Filter sections
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return sections[index];
              },
            ),
          ),

          // Bottom actions
          if (onApply != null || resultCount != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (resultCount != null)
                    Expanded(
                      child: Text(
                        '$resultCount results',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  if (onApply != null)
                    FilledButton(
                      onPressed: () {
                        onApply!();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply Filters'),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Show the filter bottom sheet
  static Future<void> show({
    required BuildContext context,
    required String title,
    required List<FilterSection> sections,
    VoidCallback? onClearAll,
    VoidCallback? onApply,
    int? resultCount,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        title: title,
        sections: sections,
        onClearAll: onClearAll,
        onApply: onApply,
        resultCount: resultCount,
      ),
    );
  }
}

/// A collapsible section within the filter bottom sheet
class FilterSection extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool initiallyExpanded;
  final IconData? icon;

  const FilterSection({
    super.key,
    required this.title,
    required this.children,
    this.initiallyExpanded = true,
    this.icon,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        AnimatedSizeAndFade(
          show: _isExpanded,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: widget.children,
            ),
          ),
        ),
      ],
    );
  }
}

/// Animated widget for smooth expand/collapse transitions
class AnimatedSizeAndFade extends StatelessWidget {
  final Widget child;
  final bool show;
  final Duration duration;

  const AnimatedSizeAndFade({
    super.key,
    required this.child,
    required this.show,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: child,
      secondChild: const SizedBox.shrink(),
      crossFadeState: show ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: duration,
      sizeCurve: Curves.easeInOut,
    );
  }
}