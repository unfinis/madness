import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import '../providers/methodology_provider.dart';
import '../providers/projects_provider.dart';

class MethodologyFiltersWidget extends ConsumerWidget {
  const MethodologyFiltersWidget({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(currentProjectProvider);
    if (currentProject == null) return const SizedBox.shrink();
    
    final methodologyState = ref.watch(methodologyProvider(currentProject.id));
    final filters = methodologyState.filters;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category filters
          Row(
            children: [
              Text(
                'Category:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildFilterButton(
                      context,
                      'All',
                      filters.categories.isEmpty,
                      () => ref.read(methodologyProvider(currentProject.id).notifier)
                          .updateFilters(filters.copyWith(categories: [])),
                    ),
                    ...MethodologyCategory.values.map((category) => 
                      _buildFilterButton(
                        context,
                        '${category.icon} ${category.displayName}',
                        filters.categories.contains(category),
                        () => ref.read(methodologyProvider(currentProject.id).notifier)
                            .toggleCategoryFilter(category),
                        color: category.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Status filters
          Row(
            children: [
              Text(
                'Status:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _buildFilterButton(
                      context,
                      'All',
                      filters.statuses.isEmpty,
                      () => ref.read(methodologyProvider(currentProject.id).notifier)
                          .updateFilters(filters.copyWith(statuses: [])),
                    ),
                    ...ExecutionStatus.values.where((status) => 
                      status != ExecutionStatus.suppressed && status != ExecutionStatus.blocked
                    ).map((status) => 
                      _buildFilterButton(
                        context,
                        '${status.icon} ${status.displayName}',
                        filters.statuses.contains(status),
                        () => ref.read(methodologyProvider(currentProject.id).notifier)
                            .toggleStatusFilter(status),
                        color: status.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Search
          Row(
            children: [
              Text(
                'Search:',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search actions, tools, descriptions...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: (query) {
                    ref.read(methodologyProvider(currentProject.id).notifier)
                        .setSearchQuery(query);
                  },
                ),
              ),
              if (filters.hasActiveFilters) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    searchController.clear();
                    ref.read(methodologyProvider(currentProject.id).notifier).clearFilters();
                  },
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear Filters',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    String label,
    bool isActive,
    VoidCallback onTap, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive 
                ? effectiveColor.withOpacity(0.1) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive 
                  ? effectiveColor 
                  : theme.dividerColor,
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive 
                  ? effectiveColor 
                  : theme.colorScheme.onSurface,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}