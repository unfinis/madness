import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/scope_provider.dart';
import '../constants/responsive_breakpoints.dart';

class ScopeFiltersWidget extends ConsumerWidget {
  final TextEditingController searchController;

  const ScopeFiltersWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(scopeFiltersProvider);
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
              hintText: 'Search segments, items, URLs...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(scopeFiltersProvider.notifier).updateSearchQuery('');
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
              ref.read(scopeFiltersProvider.notifier).updateSearchQuery(value);
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

  Widget _buildDesktopFilters(BuildContext context, WidgetRef ref, ScopeFilters filters) {
    return Wrap(
      spacing: 24,
      runSpacing: 16,
      children: [
        _buildFilterSection(
          context,
          ref,
          'Segments:',
          [
            _FilterChip(
              label: 'All Segments',
              isSelected: filters.activeFilters.contains(ScopeFilter.all),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.all),
            ),
            _FilterChip(
              label: 'Active Only',
              isSelected: filters.activeFilters.contains(ScopeFilter.active),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.active),
            ),
            _FilterChip(
              label: 'Planned Only',
              isSelected: filters.activeFilters.contains(ScopeFilter.planned),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.planned),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Type:',
          [
            _FilterChip(
              label: 'External',
              isSelected: filters.activeFilters.contains(ScopeFilter.external),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.external),
            ),
            _FilterChip(
              label: 'Internal',
              isSelected: filters.activeFilters.contains(ScopeFilter.internal),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.internal),
            ),
            _FilterChip(
              label: 'Web App',
              isSelected: filters.activeFilters.contains(ScopeFilter.webapp),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.webapp),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Status:',
          [
            _FilterChip(
              label: 'Completed',
              isSelected: filters.activeFilters.contains(ScopeFilter.completed),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.completed),
            ),
            _FilterChip(
              label: 'On Hold',
              isSelected: filters.activeFilters.contains(ScopeFilter.onHold),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.onHold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFilters(BuildContext context, WidgetRef ref, ScopeFilters filters) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterSection(
          context,
          ref,
          'Segments:',
          [
            _FilterChip(
              label: 'All Segments',
              isSelected: filters.activeFilters.contains(ScopeFilter.all),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.all),
            ),
            _FilterChip(
              label: 'Active Only',
              isSelected: filters.activeFilters.contains(ScopeFilter.active),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.active),
            ),
            _FilterChip(
              label: 'Planned Only',
              isSelected: filters.activeFilters.contains(ScopeFilter.planned),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.planned),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Type:',
          [
            _FilterChip(
              label: 'External',
              isSelected: filters.activeFilters.contains(ScopeFilter.external),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.external),
            ),
            _FilterChip(
              label: 'Internal',
              isSelected: filters.activeFilters.contains(ScopeFilter.internal),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.internal),
            ),
            _FilterChip(
              label: 'Web App',
              isSelected: filters.activeFilters.contains(ScopeFilter.webapp),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.webapp),
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
              label: 'Completed',
              isSelected: filters.activeFilters.contains(ScopeFilter.completed),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.completed),
            ),
            _FilterChip(
              label: 'On Hold',
              isSelected: filters.activeFilters.contains(ScopeFilter.onHold),
              onSelected: (selected) => _toggleFilter(ref, ScopeFilter.onHold),
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

  void _toggleFilter(WidgetRef ref, ScopeFilter filter) {
    ref.read(scopeFiltersProvider.notifier).toggleFilter(filter);
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