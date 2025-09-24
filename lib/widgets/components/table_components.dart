import 'package:flutter/material.dart';
import '../../constants/app_spacing.dart';

/// Table and data display components for consistent presentation
class TableComponents {
  TableComponents._();

  // ================== DATA TABLE COMPONENTS ==================

  /// Standard data table with consistent styling and features
  static Widget buildDataTable({
    required BuildContext context,
    required List<DataColumn> columns,
    required List<DataRow> rows,
    bool sortAscending = true,
    int? sortColumnIndex,
    bool showCheckboxColumn = false,
    double? dataRowHeight,
    double? headingRowHeight,
    double? horizontalMargin,
    double? columnSpacing,
    String? emptyMessage,
    Widget? emptyWidget,
    bool isLoading = false,
    VoidCallback? onRefresh,
  }) {
    if (isLoading) {
      return _buildLoadingTable(context, columns.length);
    }

    if (rows.isEmpty) {
      return _buildEmptyTable(
        context: context,
        message: emptyMessage ?? 'No data available',
        emptyWidget: emptyWidget,
        onRefresh: onRefresh,
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: DataTable(
          columns: columns,
          rows: rows,
          sortAscending: sortAscending,
          sortColumnIndex: sortColumnIndex,
          showCheckboxColumn: showCheckboxColumn,
          dataRowHeight: dataRowHeight ?? 56,
          headingRowHeight: headingRowHeight ?? 56,
          horizontalMargin: horizontalMargin ?? AppSpacing.lg,
          columnSpacing: columnSpacing ?? AppSpacing.xl,
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainer,
          ),
          border: TableBorder(
            horizontalInside: BorderSide(
              color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// Responsive data table that adapts to screen size
  static Widget buildResponsiveDataTable({
    required BuildContext context,
    required List<ResponsiveColumn> columns,
    required List<Map<String, dynamic>> data,
    String Function(Map<String, dynamic>)? getRowKey,
    bool sortAscending = true,
    int? sortColumnIndex,
    Function(int, bool)? onSort,
    bool showCheckboxColumn = false,
    Set<String>? selectedRows,
    Function(String, bool)? onRowSelected,
    String? emptyMessage,
    bool isLoading = false,
    VoidCallback? onRefresh,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final visibleColumns = columns.where((col) =>
      col.minWidth == null || screenWidth >= col.minWidth!
    ).toList();

    if (screenWidth < 600) {
      // Mobile: Use card list instead of table
      return _buildMobileCardList(
        context: context,
        columns: visibleColumns,
        data: data,
        getRowKey: getRowKey,
        selectedRows: selectedRows,
        onRowSelected: onRowSelected,
        emptyMessage: emptyMessage,
        isLoading: isLoading,
        onRefresh: onRefresh,
      );
    }

    // Desktop/Tablet: Use standard data table
    final dataColumns = visibleColumns.map((col) =>
      DataColumn(
        label: Text(
          col.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onSort: onSort != null ? (columnIndex, ascending) =>
          onSort(columns.indexOf(col), ascending) : null,
      ),
    ).toList();

    final dataRows = data.map((item) {
      final key = getRowKey?.call(item) ?? item.hashCode.toString();
      final isSelected = selectedRows?.contains(key) ?? false;

      return DataRow(
        key: ValueKey(key),
        selected: isSelected,
        onSelectChanged: onRowSelected != null
          ? (selected) => onRowSelected(key, selected ?? false)
          : null,
        cells: visibleColumns.map((col) =>
          DataCell(col.cellBuilder(context, item)),
        ).toList(),
      );
    }).toList();

    return buildDataTable(
      context: context,
      columns: dataColumns,
      rows: dataRows,
      sortAscending: sortAscending,
      sortColumnIndex: sortColumnIndex,
      showCheckboxColumn: showCheckboxColumn,
      emptyMessage: emptyMessage,
      isLoading: isLoading,
      onRefresh: onRefresh,
    );
  }

  // ================== LIST COMPONENTS ==================

  /// Standard list tile with consistent styling
  static Widget buildListTile({
    required BuildContext context,
    Widget? leading,
    required Widget title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool selected = false,
    bool enabled = true,
    EdgeInsets? contentPadding,
  }) {
    return Card(
      elevation: selected ? 4 : 1,
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        side: selected
          ? BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 2,
            )
          : BorderSide.none,
      ),
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        onTap: enabled ? onTap : null,
        selected: selected,
        enabled: enabled,
        contentPadding: contentPadding ?? AppSpacing.cardPadding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
      ),
    );
  }

  /// Expandable list tile with consistent styling
  static Widget buildExpandableTile({
    required BuildContext context,
    Widget? leading,
    required Widget title,
    Widget? subtitle,
    required List<Widget> children,
    bool initiallyExpanded = false,
    EdgeInsets? tilePadding,
    EdgeInsets? childrenPadding,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        child: ExpansionTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          initiallyExpanded: initiallyExpanded,
          tilePadding: tilePadding ?? AppSpacing.cardPadding,
          childrenPadding: childrenPadding ?? const EdgeInsets.only(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            bottom: AppSpacing.lg,
          ),
          children: children,
        ),
      ),
    );
  }

  // ================== FILTER COMPONENTS ==================

  /// Filter chip bar with consistent styling
  static Widget buildFilterChipBar({
    required BuildContext context,
    required List<FilterChipData> chips,
    bool showClearAll = true,
    VoidCallback? onClearAll,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filters',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (showClearAll && chips.any((chip) => chip.isSelected))
                  TextButton(
                    onPressed: onClearAll,
                    child: const Text('Clear All'),
                  ),
              ],
            ),
            AppSpacing.vGapSM,
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: chips.map((chip) =>
                FilterChip(
                  label: Text(chip.label),
                  selected: chip.isSelected,
                  onSelected: chip.onSelected,
                  avatar: chip.icon != null ? Icon(chip.icon!, size: AppSizes.iconSM) : null,
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.chipRadius * 4),
                  ),
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ================== SEARCH COMPONENTS ==================

  /// Standard search bar with consistent styling
  static Widget buildSearchBar({
    required BuildContext context,
    required TextEditingController controller,
    String? hintText,
    VoidCallback? onClear,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    bool autofocus = false,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: TextField(
          controller: controller,
          autofocus: autofocus,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText ?? 'Search...',
            prefixIcon: const Icon(Icons.search_rounded),
            suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: onClear ?? () {
                    controller.clear();
                    onChanged?.call('');
                  },
                )
              : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
          ),
        ),
      ),
    );
  }

  // ================== HELPER WIDGETS ==================

  static Widget _buildLoadingTable(BuildContext context, int columnCount) {
    return Card(
      child: Padding(
        padding: AppSpacing.contentPadding,
        child: Column(
          children: [
            // Loading header
            Row(
              children: List.generate(
                columnCount,
                (index) => Expanded(
                  child: Container(
                    height: 16,
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(AppSizes.chipRadius),
                    ),
                  ),
                ),
              ),
            ),
            AppSpacing.vGapLG,
            // Loading rows
            ...List.generate(
              5,
              (rowIndex) => Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: Row(
                  children: List.generate(
                    columnCount,
                    (colIndex) => Expanded(
                      child: Container(
                        height: 12,
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(AppSizes.chipRadius),
                        ),
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

  static Widget _buildEmptyTable({
    required BuildContext context,
    required String message,
    Widget? emptyWidget,
    VoidCallback? onRefresh,
  }) {
    return Card(
      child: Padding(
        padding: AppSpacing.contentPadding * 2,
        child: emptyWidget ?? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_chart_outlined,
              size: AppSizes.huge,
              color: Theme.of(context).colorScheme.outline,
            ),
            AppSpacing.vGapLG,
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRefresh != null) ...[
              AppSpacing.vGapLG,
              TextButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Refresh'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildMobileCardList({
    required BuildContext context,
    required List<ResponsiveColumn> columns,
    required List<Map<String, dynamic>> data,
    String Function(Map<String, dynamic>)? getRowKey,
    Set<String>? selectedRows,
    Function(String, bool)? onRowSelected,
    String? emptyMessage,
    bool isLoading = false,
    VoidCallback? onRefresh,
  }) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data.isEmpty) {
      return _buildEmptyTable(
        context: context,
        message: emptyMessage ?? 'No data available',
        onRefresh: onRefresh,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        final key = getRowKey?.call(item) ?? item.hashCode.toString();
        final isSelected = selectedRows?.contains(key) ?? false;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columns.take(3).map((col) => // Show first 3 columns on mobile
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        child: Text(
                          '${col.label}:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: col.cellBuilder(context, item)),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),
        );
      },
    );
  }
}

// ================== DATA CLASSES ==================

/// Data class for responsive table columns
class ResponsiveColumn {
  final String label;
  final Widget Function(BuildContext context, Map<String, dynamic> data) cellBuilder;
  final double? minWidth;
  final bool sortable;

  const ResponsiveColumn({
    required this.label,
    required this.cellBuilder,
    this.minWidth,
    this.sortable = false,
  });
}

/// Data class for filter chips
class FilterChipData {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;
  final IconData? icon;

  const FilterChipData({
    required this.label,
    required this.isSelected,
    required this.onSelected,
    this.icon,
  });
}