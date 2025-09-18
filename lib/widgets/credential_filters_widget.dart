import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/credential_provider.dart';
import '../constants/responsive_breakpoints.dart';

class CredentialFiltersWidget extends ConsumerWidget {
  final TextEditingController searchController;

  const CredentialFiltersWidget({
    super.key,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(credentialFiltersProvider);
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
              hintText: 'Search usernames, targets, sources...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        ref.read(credentialFiltersProvider.notifier).updateSearchQuery('');
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
              ref.read(credentialFiltersProvider.notifier).updateSearchQuery(value);
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

  Widget _buildDesktopFilters(BuildContext context, WidgetRef ref, CredentialFilters filters) {
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
              isSelected: filters.activeFilters.contains(CredentialFilter.all),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.all),
            ),
            _FilterChip(
              label: '👤 User',
              isSelected: filters.activeFilters.contains(CredentialFilter.user),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.user),
            ),
            _FilterChip(
              label: '👑 Admin',
              isSelected: filters.activeFilters.contains(CredentialFilter.admin),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.admin),
            ),
            _FilterChip(
              label: '⚙️ Service',
              isSelected: filters.activeFilters.contains(CredentialFilter.service),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.service),
            ),
            _FilterChip(
              label: '🔐 Hashes',
              isSelected: filters.activeFilters.contains(CredentialFilter.hash),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.hash),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Status:',
          [
            _FilterChip(
              label: 'Valid',
              isSelected: filters.activeFilters.contains(CredentialFilter.valid),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.valid),
            ),
            _FilterChip(
              label: 'Invalid',
              isSelected: filters.activeFilters.contains(CredentialFilter.invalid),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.invalid),
            ),
            _FilterChip(
              label: 'Untested',
              isSelected: filters.activeFilters.contains(CredentialFilter.untested),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.untested),
            ),
          ],
        ),
        _buildFilterSection(
          context,
          ref,
          'Source:',
          [
            _FilterChip(
              label: 'Client',
              isSelected: filters.activeFilters.contains(CredentialFilter.clientProvided),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.clientProvided),
            ),
            _FilterChip(
              label: 'Password Spray',
              isSelected: filters.activeFilters.contains(CredentialFilter.passwordSpray),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.passwordSpray),
            ),
            _FilterChip(
              label: 'Kerberoasting',
              isSelected: filters.activeFilters.contains(CredentialFilter.kerberoasting),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.kerberoasting),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileFilters(BuildContext context, WidgetRef ref, CredentialFilters filters) {
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
              isSelected: filters.activeFilters.contains(CredentialFilter.all),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.all),
            ),
            _FilterChip(
              label: '👤 User',
              isSelected: filters.activeFilters.contains(CredentialFilter.user),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.user),
            ),
            _FilterChip(
              label: '👑 Admin',
              isSelected: filters.activeFilters.contains(CredentialFilter.admin),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.admin),
            ),
            _FilterChip(
              label: '⚙️ Service',
              isSelected: filters.activeFilters.contains(CredentialFilter.service),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.service),
            ),
            _FilterChip(
              label: '🔐 Hashes',
              isSelected: filters.activeFilters.contains(CredentialFilter.hash),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.hash),
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
              label: 'Valid',
              isSelected: filters.activeFilters.contains(CredentialFilter.valid),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.valid),
            ),
            _FilterChip(
              label: 'Invalid',
              isSelected: filters.activeFilters.contains(CredentialFilter.invalid),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.invalid),
            ),
            _FilterChip(
              label: 'Untested',
              isSelected: filters.activeFilters.contains(CredentialFilter.untested),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.untested),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildFilterSection(
          context,
          ref,
          'Source:',
          [
            _FilterChip(
              label: 'Client',
              isSelected: filters.activeFilters.contains(CredentialFilter.clientProvided),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.clientProvided),
            ),
            _FilterChip(
              label: 'Password Spray',
              isSelected: filters.activeFilters.contains(CredentialFilter.passwordSpray),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.passwordSpray),
            ),
            _FilterChip(
              label: 'Kerberoasting',
              isSelected: filters.activeFilters.contains(CredentialFilter.kerberoasting),
              onSelected: (selected) => _toggleFilter(ref, CredentialFilter.kerberoasting),
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

  void _toggleFilter(WidgetRef ref, CredentialFilter filter) {
    ref.read(credentialFiltersProvider.notifier).toggleFilter(filter);
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