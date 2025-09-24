import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contact_provider.dart';
import '../constants/responsive_breakpoints.dart';

class ContactFiltersWidget extends ConsumerWidget {
  final TextEditingController searchController;

  const ContactFiltersWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(contactFiltersProvider);
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
              hintText: 'Search contacts, email, phone, role...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(contactFiltersProvider.notifier).updateSearchQuery('');
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
              ref.read(contactFiltersProvider.notifier).updateSearchQuery(value);
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

  Widget _buildDesktopFilters(BuildContext context, WidgetRef ref, ContactFilters filters) {
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
              isSelected: filters.activeFilters.contains(ContactFilter.all),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.all),
            ),
            _FilterChip(
              label: 'Primary',
              isSelected: filters.activeFilters.contains(ContactFilter.primary),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.primary),
            ),
            _FilterChip(
              label: 'Technical',
              isSelected: filters.activeFilters.contains(ContactFilter.technical),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.technical),
            ),
            _FilterChip(
              label: 'Emergency',
              isSelected: filters.activeFilters.contains(ContactFilter.emergency),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.emergency),
            ),
            _FilterChip(
              label: 'Escalation',
              isSelected: filters.activeFilters.contains(ContactFilter.escalation),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.escalation),
            ),
            _FilterChip(
              label: 'Security',
              isSelected: filters.activeFilters.contains(ContactFilter.securityConsultant),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.securityConsultant),
            ),
            _FilterChip(
              label: 'Account Manager',
              isSelected: filters.activeFilters.contains(ContactFilter.accountManager),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.accountManager),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Special:',
          [
            _FilterChip(
              label: 'Receive Report',
              isSelected: filters.activeFilters.contains(ContactFilter.receiveReport),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.receiveReport),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFilters(BuildContext context, WidgetRef ref, ContactFilters filters) {
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
              isSelected: filters.activeFilters.contains(ContactFilter.all),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.all),
            ),
            _FilterChip(
              label: 'Primary',
              isSelected: filters.activeFilters.contains(ContactFilter.primary),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.primary),
            ),
            _FilterChip(
              label: 'Technical',
              isSelected: filters.activeFilters.contains(ContactFilter.technical),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.technical),
            ),
            _FilterChip(
              label: 'Emergency',
              isSelected: filters.activeFilters.contains(ContactFilter.emergency),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.emergency),
            ),
            _FilterChip(
              label: 'Escalation',
              isSelected: filters.activeFilters.contains(ContactFilter.escalation),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.escalation),
            ),
            _FilterChip(
              label: 'Security',
              isSelected: filters.activeFilters.contains(ContactFilter.securityConsultant),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.securityConsultant),
            ),
            _FilterChip(
              label: 'Account Manager',
              isSelected: filters.activeFilters.contains(ContactFilter.accountManager),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.accountManager),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Special:',
          [
            _FilterChip(
              label: 'Receive Report',
              isSelected: filters.activeFilters.contains(ContactFilter.receiveReport),
              onSelected: (selected) => _toggleFilter(ref, ContactFilter.receiveReport),
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

  void _toggleFilter(WidgetRef ref, ContactFilter filter) {
    ref.read(contactFiltersProvider.notifier).toggleFilter(filter);
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