import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../constants/responsive_breakpoints.dart';

class ExpenseFiltersWidget extends ConsumerWidget {
  final TextEditingController searchController;
  final String projectId;

  const ExpenseFiltersWidget({
    super.key,
    required this.searchController,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(expenseFiltersProvider(projectId));
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search bar
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search descriptions, categories, amounts...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(expenseFiltersProvider(projectId).notifier).updateSearchQuery('');
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: 0.3),
            ),
            onChanged: (value) {
              ref.read(expenseFiltersProvider(projectId).notifier).updateSearchQuery(value);
            },
          ),
        ),

        // Filter sections
        if (isDesktop) 
          _buildDesktopFilters(context, ref, filters)
        else 
          _buildMobileFilters(context, ref, filters),
      ],
    );
  }

  Widget _buildDesktopFilters(BuildContext context, WidgetRef ref, ExpenseFilters filters) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        _buildFilterSection(
          context,
          ref,
          'Type:',
          [
            _FilterChip(
              label: 'All',
              isSelected: filters.activeFilters.contains(ExpenseFilter.all),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.all),
            ),
            _FilterChip(
              label: 'Billable',
              isSelected: filters.activeFilters.contains(ExpenseFilter.billable),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.billable),
            ),
            _FilterChip(
              label: 'Personal',
              isSelected: filters.activeFilters.contains(ExpenseFilter.personal),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.personal),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Category:',
          [
            _FilterChip(
              label: 'Travel',
              isSelected: filters.activeFilters.contains(ExpenseFilter.travel),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.travel),
            ),
            _FilterChip(
              label: 'Accommodation',
              isSelected: filters.activeFilters.contains(ExpenseFilter.accommodation),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.accommodation),
            ),
            _FilterChip(
              label: 'Food',
              isSelected: filters.activeFilters.contains(ExpenseFilter.food),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.food),
            ),
            _FilterChip(
              label: 'Equipment',
              isSelected: filters.activeFilters.contains(ExpenseFilter.equipment),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.equipment),
            ),
            _FilterChip(
              label: 'Other',
              isSelected: filters.activeFilters.contains(ExpenseFilter.other),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.other),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Period:',
          [
            _FilterChip(
              label: 'This Month',
              isSelected: filters.activeFilters.contains(ExpenseFilter.thisMonth),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.thisMonth),
            ),
            _FilterChip(
              label: 'Last Month',
              isSelected: filters.activeFilters.contains(ExpenseFilter.lastMonth),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.lastMonth),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFilters(BuildContext context, WidgetRef ref, ExpenseFilters filters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSection(
          context,
          ref,
          'Type:',
          [
            _FilterChip(
              label: 'All',
              isSelected: filters.activeFilters.contains(ExpenseFilter.all),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.all),
            ),
            _FilterChip(
              label: 'Billable',
              isSelected: filters.activeFilters.contains(ExpenseFilter.billable),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.billable),
            ),
            _FilterChip(
              label: 'Personal',
              isSelected: filters.activeFilters.contains(ExpenseFilter.personal),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.personal),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Category:',
          [
            _FilterChip(
              label: 'Travel',
              isSelected: filters.activeFilters.contains(ExpenseFilter.travel),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.travel),
            ),
            _FilterChip(
              label: 'Accommodation',
              isSelected: filters.activeFilters.contains(ExpenseFilter.accommodation),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.accommodation),
            ),
            _FilterChip(
              label: 'Food',
              isSelected: filters.activeFilters.contains(ExpenseFilter.food),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.food),
            ),
            _FilterChip(
              label: 'Equipment',
              isSelected: filters.activeFilters.contains(ExpenseFilter.equipment),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.equipment),
            ),
            _FilterChip(
              label: 'Other',
              isSelected: filters.activeFilters.contains(ExpenseFilter.other),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.other),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Period:',
          [
            _FilterChip(
              label: 'This Month',
              isSelected: filters.activeFilters.contains(ExpenseFilter.thisMonth),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.thisMonth),
            ),
            _FilterChip(
              label: 'Last Month',
              isSelected: filters.activeFilters.contains(ExpenseFilter.lastMonth),
              onSelected: (selected) => _toggleFilter(ref, ExpenseFilter.lastMonth),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context, WidgetRef ref, String title, List<Widget> chips) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips,
        ),
      ],
    );
  }

  void _toggleFilter(WidgetRef ref, ExpenseFilter filter) {
    ref.read(expenseFiltersProvider(projectId).notifier).toggleFilter(filter);
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      labelStyle: TextStyle(
        color: isSelected 
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}