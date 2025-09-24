import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';

class FindingFiltersWidget extends ConsumerStatefulWidget {
  const FindingFiltersWidget({super.key});

  @override
  ConsumerState<FindingFiltersWidget> createState() => _FindingFiltersWidgetState();
}

class _FindingFiltersWidgetState extends ConsumerState<FindingFiltersWidget> {
  late TextEditingController _searchController;
  late TextEditingController _minCvssController;
  late TextEditingController _maxCvssController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    final filters = ref.read(findingProvider).filters;
    _searchController = TextEditingController(text: filters.searchQuery ?? '');
    _minCvssController = TextEditingController(text: filters.minCvssScore?.toString() ?? '');
    _maxCvssController = TextEditingController(text: filters.maxCvssScore?.toString() ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _minCvssController.dispose();
    _maxCvssController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final findingState = ref.watch(findingProvider);
    final filters = findingState.filters;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // Search bar and expand button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search findings...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                _updateFilters();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) => _updateFilters(),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.tune),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  tooltip: 'Advanced Filters',
                ),
                if (filters.hasActiveFilters)
                  IconButton(
                    icon: const Icon(Icons.filter_list_off),
                    onPressed: () {
                      _clearAllFilters();
                    },
                    tooltip: 'Clear All Filters',
                  ),
              ],
            ),
          ),

          // Advanced filters (expandable)
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Severity filters
                  _buildSectionTitle(context, 'Severity'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: FindingSeverity.values.map((severity) {
                      final isSelected = filters.severities.contains(severity);
                      return FilterChip(
                        label: Text(severity.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          _toggleSeverityFilter(severity, selected);
                        },
                        avatar: CircleAvatar(
                          backgroundColor: severity.color,
                          radius: 6,
                        ),
                        selectedColor: severity.color.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: severity.color.withValues(alpha: 0.5),
                        ),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),

                  // Status filters
                  _buildSectionTitle(context, 'Status'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: FindingStatus.values.map((status) {
                      final isSelected = filters.statuses.contains(status);
                      return FilterChip(
                        label: Text(status.displayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          _toggleStatusFilter(status, selected);
                        },
                        selectedColor: status.color.withValues(alpha: 0.2),
                        side: BorderSide(
                          color: status.color.withValues(alpha: 0.5),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // CVSS Score range
                  _buildSectionTitle(context, 'CVSS Score Range'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minCvssController,
                          decoration: InputDecoration(
                            labelText: 'Min Score',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) => _updateFilters(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _maxCvssController,
                          decoration: InputDecoration(
                            labelText: 'Max Score',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (value) => _updateFilters(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date range (simplified for now)
                  _buildSectionTitle(context, 'Date Range'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(filters.startDate != null
                              ? 'From: ${_formatDate(filters.startDate!)}'
                              : 'Start Date'),
                          onPressed: () => _selectStartDate(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(filters.endDate != null
                              ? 'To: ${_formatDate(filters.endDate!)}'
                              : 'End Date'),
                          onPressed: () => _selectEndDate(context),
                        ),
                      ),
                    ],
                  ),

                  // Active filters summary
                  if (filters.hasActiveFilters) ...[
                    const SizedBox(height: 16),
                    _buildActiveFiltersSummary(context, filters),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildActiveFiltersSummary(BuildContext context, FindingFilters filters) {
    final activeFilters = <String>[];
    
    if (filters.severities.isNotEmpty) {
      activeFilters.add('${filters.severities.length} severities');
    }
    if (filters.statuses.isNotEmpty) {
      activeFilters.add('${filters.statuses.length} statuses');
    }
    if (filters.minCvssScore != null || filters.maxCvssScore != null) {
      activeFilters.add('CVSS range');
    }
    if (filters.startDate != null || filters.endDate != null) {
      activeFilters.add('Date range');
    }
    if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
      activeFilters.add('Search term');
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.filter_list,
            size: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Active filters: ${activeFilters.join(', ')}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: _clearAllFilters,
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _toggleSeverityFilter(FindingSeverity severity, bool selected) {
    final currentFilters = ref.read(findingProvider).filters;
    final updatedSeverities = List<FindingSeverity>.from(currentFilters.severities);
    
    if (selected) {
      updatedSeverities.add(severity);
    } else {
      updatedSeverities.remove(severity);
    }
    
    final updatedFilters = currentFilters.copyWith(severities: updatedSeverities);
    ref.read(findingProvider.notifier).updateFilters(updatedFilters);
  }

  void _toggleStatusFilter(FindingStatus status, bool selected) {
    final currentFilters = ref.read(findingProvider).filters;
    final updatedStatuses = List<FindingStatus>.from(currentFilters.statuses);
    
    if (selected) {
      updatedStatuses.add(status);
    } else {
      updatedStatuses.remove(status);
    }
    
    final updatedFilters = currentFilters.copyWith(statuses: updatedStatuses);
    ref.read(findingProvider.notifier).updateFilters(updatedFilters);
  }

  void _updateFilters() {
    final currentFilters = ref.read(findingProvider).filters;
    
    final minScore = double.tryParse(_minCvssController.text);
    final maxScore = double.tryParse(_maxCvssController.text);
    
    final updatedFilters = currentFilters.copyWith(
      searchQuery: _searchController.text.isEmpty ? null : _searchController.text,
      minCvssScore: minScore,
      maxCvssScore: maxScore,
    );
    
    ref.read(findingProvider.notifier).updateFilters(updatedFilters);
  }

  void _clearAllFilters() {
    _searchController.clear();
    _minCvssController.clear();
    _maxCvssController.clear();
    ref.read(findingProvider.notifier).clearFilters();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final currentFilters = ref.read(findingProvider).filters;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentFilters.startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    
    if (selectedDate != null) {
      final updatedFilters = currentFilters.copyWith(startDate: selectedDate);
      ref.read(findingProvider.notifier).updateFilters(updatedFilters);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final currentFilters = ref.read(findingProvider).filters;
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: currentFilters.endDate ?? DateTime.now(),
      firstDate: currentFilters.startDate ?? DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    
    if (selectedDate != null) {
      final updatedFilters = currentFilters.copyWith(endDate: selectedDate);
      ref.read(findingProvider.notifier).updateFilters(updatedFilters);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}