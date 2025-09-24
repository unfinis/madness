import 'package:flutter/material.dart';
import '../../constants/filter_breakpoints.dart';

/// Standardized search field component for consistent UX across all screens
class StandardSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onClear;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final IconData? prefixIcon;

  const StandardSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onClear,
    this.onChanged,
    this.enabled = true,
    this.prefixIcon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final height = FilterBreakpoints.getSearchHeight(screenWidth);

    return SizedBox(
      height: height,
      child: TextField(
        controller: controller,
        enabled: enabled,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                )
              : null,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                    onChanged?.call('');
                  },
                  icon: Icon(
                    Icons.clear,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  tooltip: 'Clear search',
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: FilterBreakpoints.isMobile(screenWidth) ? 12 : 16,
            vertical: 0,
          ),
          isDense: true,
        ),
        style: theme.textTheme.bodyMedium,
      ),
    );
  }
}