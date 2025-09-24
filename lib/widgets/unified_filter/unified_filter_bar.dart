import 'package:flutter/material.dart';
import '../../constants/filter_breakpoints.dart';
import 'standard_search_field.dart';
import 'standard_filter_chip.dart';
import 'filter_bottom_sheet.dart';

/// Main unified filter bar component that adapts to screen size
class UnifiedFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String searchHint;
  final List<PrimaryFilter> primaryFilters;
  final List<FilterSection>? advancedFilters;
  final String? advancedFiltersTitle;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchCleared;
  final VoidCallback? onAdvancedFiltersChanged;
  final int? activeFilterCount;
  final int? resultCount;

  const UnifiedFilterBar({
    super.key,
    required this.searchController,
    required this.searchHint,
    required this.primaryFilters,
    this.advancedFilters,
    this.advancedFiltersTitle,
    this.onSearchChanged,
    this.onSearchCleared,
    this.onAdvancedFiltersChanged,
    this.activeFilterCount,
    this.resultCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (FilterBreakpoints.isMobile(screenWidth)) {
      return _buildMobileLayout(context);
    } else if (FilterBreakpoints.isTablet(screenWidth)) {
      return _buildTabletLayout(context);
    } else {
      return _buildDesktopLayout(context);
    }
  }

  /// Mobile layout: Compact search + essential filters + overflow button
  Widget _buildMobileLayout(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = FilterBreakpoints.getSpacing(MediaQuery.of(context).size.width);
    final margin = FilterBreakpoints.getMargin(MediaQuery.of(context).size.width);

    // Show only the most important 2 primary filters on mobile
    final visibleFilters = primaryFilters.take(2).toList();
    final hasOverflowFilters = primaryFilters.length > 2 || (advancedFilters?.isNotEmpty ?? false);

    return Container(
      padding: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search bar (full width)
          StandardSearchField(
            controller: searchController,
            hintText: searchHint,
            onChanged: onSearchChanged,
            onClear: onSearchCleared,
          ),

          if (visibleFilters.isNotEmpty || hasOverflowFilters) ...[
            SizedBox(height: spacing),
            Row(
              children: [
                // Primary filters
                ...visibleFilters.map(
                  (filter) => Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: StandardFilterChip(
                      label: filter.label,
                      isSelected: filter.isSelected,
                      onPressed: filter.onPressed,
                      icon: filter.icon,
                      badge: filter.badge,
                    ),
                  ),
                ),

                // More filters button
                if (hasOverflowFilters)
                  StandardFilterChip(
                    label: 'More Filters',
                    isSelected: (activeFilterCount ?? 0) > 0,
                    onPressed: () => _showAdvancedFilters(context),
                    icon: Icons.tune,
                    badge: activeFilterCount != null && activeFilterCount! > 0
                        ? activeFilterCount.toString()
                        : null,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Tablet layout: Search + expandable filters
  Widget _buildTabletLayout(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = FilterBreakpoints.getSpacing(MediaQuery.of(context).size.width);
    final margin = FilterBreakpoints.getMargin(MediaQuery.of(context).size.width);

    return Container(
      padding: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search bar and filter toggle
          Row(
            children: [
              Expanded(
                flex: 3,
                child: StandardSearchField(
                  controller: searchController,
                  hintText: searchHint,
                  onChanged: onSearchChanged,
                  onClear: onSearchCleared,
                ),
              ),
              SizedBox(width: spacing),
              if (advancedFilters?.isNotEmpty ?? false)
                StandardFilterChip(
                  label: 'Filters',
                  isSelected: (activeFilterCount ?? 0) > 0,
                  onPressed: () => _showAdvancedFilters(context),
                  icon: Icons.tune,
                  badge: activeFilterCount != null && activeFilterCount! > 0
                      ? activeFilterCount.toString()
                      : null,
                ),
            ],
          ),

          // Primary filters (wrap layout)
          if (primaryFilters.isNotEmpty) ...[
            SizedBox(height: spacing),
            Wrap(
              spacing: spacing,
              runSpacing: spacing / 2,
              children: primaryFilters.map(
                (filter) => StandardFilterChip(
                  label: filter.label,
                  isSelected: filter.isSelected,
                  onPressed: filter.onPressed,
                  icon: filter.icon,
                  badge: filter.badge,
                ),
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Desktop layout: Full inline filters
  Widget _buildDesktopLayout(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = FilterBreakpoints.getSpacing(MediaQuery.of(context).size.width);
    final margin = FilterBreakpoints.getMargin(MediaQuery.of(context).size.width);

    return Container(
      padding: EdgeInsets.all(margin),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        children: [
          // Search and primary actions
          Row(
            children: [
              Expanded(
                flex: 2,
                child: StandardSearchField(
                  controller: searchController,
                  hintText: searchHint,
                  onChanged: onSearchChanged,
                  onClear: onSearchCleared,
                ),
              ),
              if (resultCount != null) ...[
                SizedBox(width: spacing * 2),
                Text(
                  '$resultCount results',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),

          // All filters (wrap layout)
          if (primaryFilters.isNotEmpty) ...[
            SizedBox(height: spacing),
            Wrap(
              spacing: spacing,
              runSpacing: spacing / 2,
              children: primaryFilters.map(
                (filter) => StandardFilterChip(
                  label: filter.label,
                  isSelected: filter.isSelected,
                  onPressed: filter.onPressed,
                  icon: filter.icon,
                  badge: filter.badge,
                ),
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  void _showAdvancedFilters(BuildContext context) {
    if (advancedFilters == null || advancedFilters!.isEmpty) return;

    FilterBottomSheet.show(
      context: context,
      title: advancedFiltersTitle ?? 'Filter Options',
      sections: advancedFilters!,
      onClearAll: () {
        // Clear all filters logic would go here
        onAdvancedFiltersChanged?.call();
      },
      onApply: onAdvancedFiltersChanged,
      resultCount: resultCount,
    );
  }
}

/// Configuration for a primary filter option
class PrimaryFilter {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;
  final IconData? icon;
  final String? badge;

  const PrimaryFilter({
    required this.label,
    required this.isSelected,
    required this.onPressed,
    this.icon,
    this.badge,
  });
}