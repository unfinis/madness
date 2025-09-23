import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_provider.dart';
import '../constants/responsive_breakpoints.dart';

class TaskFiltersWidget extends ConsumerWidget {
  final TextEditingController searchController;

  const TaskFiltersWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(taskFiltersProvider);
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
              hintText: 'Search tasks, assignees, descriptions...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(taskFiltersProvider.notifier).updateSearchQuery('');
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
            ),
            onChanged: (value) {
              ref.read(taskFiltersProvider.notifier).updateSearchQuery(value);
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

  Widget _buildDesktopFilters(BuildContext context, WidgetRef ref, TaskFilters filters) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        _buildFilterSection(
          context,
          ref,
          'Category:',
          [
            _FilterChip(
              label: 'All',
              isSelected: filters.activeFilters.contains(TaskFilter.all),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.all),
            ),
            _FilterChip(
              label: 'Admin',
              isSelected: filters.activeFilters.contains(TaskFilter.admin),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.admin),
            ),
            _FilterChip(
              label: 'Legal',
              isSelected: filters.activeFilters.contains(TaskFilter.legal),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.legal),
            ),
            _FilterChip(
              label: 'Setup',
              isSelected: filters.activeFilters.contains(TaskFilter.setup),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.setup),
            ),
            _FilterChip(
              label: 'Communication',
              isSelected: filters.activeFilters.contains(TaskFilter.communication),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.communication),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Status:',
          [
            _FilterChip(
              label: 'Urgent',
              isSelected: filters.activeFilters.contains(TaskFilter.urgent),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.urgent),
            ),
            _FilterChip(
              label: 'In Progress',
              isSelected: filters.activeFilters.contains(TaskFilter.inProgress),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.inProgress),
            ),
            _FilterChip(
              label: 'Pending',
              isSelected: filters.activeFilters.contains(TaskFilter.pending),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.pending),
            ),
            _FilterChip(
              label: 'Completed',
              isSelected: filters.activeFilters.contains(TaskFilter.completed),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.completed),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Priority:',
          [
            _FilterChip(
              label: 'High',
              isSelected: filters.activeFilters.contains(TaskFilter.high),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.high),
            ),
            _FilterChip(
              label: 'Medium',
              isSelected: filters.activeFilters.contains(TaskFilter.medium),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.medium),
            ),
            _FilterChip(
              label: 'Low',
              isSelected: filters.activeFilters.contains(TaskFilter.low),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.low),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFilters(BuildContext context, WidgetRef ref, TaskFilters filters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSection(
          context,
          ref,
          'Category:',
          [
            _FilterChip(
              label: 'All',
              isSelected: filters.activeFilters.contains(TaskFilter.all),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.all),
            ),
            _FilterChip(
              label: 'Admin',
              isSelected: filters.activeFilters.contains(TaskFilter.admin),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.admin),
            ),
            _FilterChip(
              label: 'Legal',
              isSelected: filters.activeFilters.contains(TaskFilter.legal),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.legal),
            ),
            _FilterChip(
              label: 'Setup',
              isSelected: filters.activeFilters.contains(TaskFilter.setup),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.setup),
            ),
            _FilterChip(
              label: 'Communication',
              isSelected: filters.activeFilters.contains(TaskFilter.communication),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.communication),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Status:',
          [
            _FilterChip(
              label: 'Urgent',
              isSelected: filters.activeFilters.contains(TaskFilter.urgent),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.urgent),
            ),
            _FilterChip(
              label: 'In Progress',
              isSelected: filters.activeFilters.contains(TaskFilter.inProgress),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.inProgress),
            ),
            _FilterChip(
              label: 'Pending',
              isSelected: filters.activeFilters.contains(TaskFilter.pending),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.pending),
            ),
            _FilterChip(
              label: 'Completed',
              isSelected: filters.activeFilters.contains(TaskFilter.completed),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.completed),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Priority:',
          [
            _FilterChip(
              label: 'High',
              isSelected: filters.activeFilters.contains(TaskFilter.high),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.high),
            ),
            _FilterChip(
              label: 'Medium',
              isSelected: filters.activeFilters.contains(TaskFilter.medium),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.medium),
            ),
            _FilterChip(
              label: 'Low',
              isSelected: filters.activeFilters.contains(TaskFilter.low),
              onSelected: (selected) => _toggleFilter(ref, TaskFilter.low),
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

  void _toggleFilter(WidgetRef ref, TaskFilter filter) {
    ref.read(taskFiltersProvider.notifier).toggleFilter(filter);
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