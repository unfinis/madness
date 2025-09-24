import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import '../providers/credential_provider.dart';
import '../widgets/credential_table_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/unified_filter/unified_filter.dart';
import '../widgets/standard_stats_bar.dart';
import '../constants/app_spacing.dart';
import '../dialogs/add_credential_dialog.dart';
import '../widgets/dynamic_top_bar.dart';

class CredentialsScreen extends ConsumerStatefulWidget {
  const CredentialsScreen({super.key});

  @override
  ConsumerState<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends ConsumerState<CredentialsScreen> with HasTopBarConfig {
  final _searchController = TextEditingController();
  final Set<String> _selectedCredentials = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  TopBarConfig getTopBarConfig(BuildContext context) {
    return TopBarConfig(
      title: 'Credentials',
      actions: [
        TopBarAction(
          icon: Icons.upload,
          label: 'Import',
          onPressed: () => _importCredentials(context),
          tooltip: 'Import credentials',
        ),
        TopBarAction(
          icon: Icons.download,
          label: 'Export',
          onPressed: () => _exportCredentials(context),
          tooltip: 'Export credentials',
        ),
        TopBarAction(
          icon: Icons.add,
          label: 'Add Credential',
          onPressed: () => _showAddCredentialDialog(context),
          tooltip: 'Add new credential',
          isPrimary: true,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredCredentials = ref.watch(filteredCredentialsProvider);
    
    return ScreenWrapper(
      children: [
        _buildCredentialsStatsBar(context),
        const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with responsive buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        // Title and buttons are now in the top bar
                      ],
                    ),
                    const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
                    
                    // NEW: Unified Filter Bar
                    UnifiedFilterBar(
                      searchController: _searchController,
                      searchHint: 'Search usernames, targets, sources...',
                      primaryFilters: _buildPrimaryFilters(),
                      advancedFilters: _buildAdvancedFilters(),
                      advancedFiltersTitle: 'Credential Filters',
                      onSearchChanged: (value) {
                        ref.read(credentialFiltersProvider.notifier).updateSearchQuery(value);
                      },
                      onSearchCleared: () {
                        ref.read(credentialFiltersProvider.notifier).updateSearchQuery('');
                      },
                      onAdvancedFiltersChanged: () {
                        // Advanced filter changes are handled by individual filter callbacks
                      },
                      activeFilterCount: _getActiveFilterCount(),
                      resultCount: filteredCredentials.length,
                    ),
                    AppSpacing.vGapLG,
                    
                    if (filteredCredentials.isEmpty)
                      CommonStateWidgets.noData(
                        itemName: 'credentials',
                        icon: Icons.key_outlined,
                        onCreate: () => _showAddCredentialDialog(context),
                        createButtonText: 'Add First Credential',
                      )
                    else
                      CredentialTableWidget(
                        credentials: filteredCredentials,
                        selectedCredentials: _selectedCredentials,
                        onSelectionChanged: _onSelectionChanged,
                        onCredentialTest: _testCredential,
                        onCredentialEdit: _editCredential,
                        onCredentialDelete: _deleteCredential,
                      ),
                    
                    if (_selectedCredentials.isNotEmpty)
                      _buildBulkActions(context),
                  ],
                ),
        ),
      ],
    );
  }



  Widget _buildBulkActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedCredentials.length} credential${_selectedCredentials.length == 1 ? '' : 's'} selected',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const Spacer(),
          OutlinedButton.icon(
            onPressed: () => _bulkTestCredentials(CredentialStatus.valid),
            icon: const Icon(Icons.check_circle, size: 16),
            label: const Text('Mark Valid'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _bulkCopyCredentials(),
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: () => _bulkDeleteCredentials(),
            icon: const Icon(Icons.delete, size: 16),
            label: const Text('Delete'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  void _onSelectionChanged(String credentialId, bool selected) {
    setState(() {
      if (selected) {
        _selectedCredentials.add(credentialId);
      } else {
        _selectedCredentials.remove(credentialId);
      }
    });
  }

  void _showAddCredentialDialog(BuildContext context) {
    showAddCredentialDialog(context);
  }

  void _testCredential(String credentialId, CredentialStatus status) {
    ref.read(credentialProvider.notifier).testCredential(credentialId, status);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Credential tested and marked as ${status.displayName.toLowerCase()}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _editCredential(String credentialId) {
    // TODO: Implement edit credential dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit credential dialog not yet implemented')),
    );
  }

  void _deleteCredential(String credentialId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Credential'),
        content: const Text('Are you sure you want to delete this credential?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(credentialProvider.notifier).deleteCredential(credentialId);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Credential deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _bulkTestCredentials(CredentialStatus status) {
    ref.read(credentialProvider.notifier).bulkTestCredentials(_selectedCredentials.toList(), status);
    setState(() => _selectedCredentials.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected credentials marked as ${status.displayName.toLowerCase()}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _bulkCopyCredentials() {
    // TODO: Implement bulk copy functionality
    setState(() => _selectedCredentials.clear());
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Credentials copied to clipboard'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _bulkDeleteCredentials() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Credentials'),
        content: Text('Are you sure you want to delete ${_selectedCredentials.length} credential${_selectedCredentials.length == 1 ? '' : 's'}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(credentialProvider.notifier).deleteCredentials(_selectedCredentials.toList());
              Navigator.of(context).pop();
              setState(() => _selectedCredentials.clear());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Credentials deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _importCredentials(BuildContext context) {
    // TODO: Implement import credentials functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Import credentials functionality coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _exportCredentials(BuildContext context) {
    final credentials = ref.read(filteredCredentialsProvider);
    
    if (credentials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No credentials to export'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }

    // TODO: Implement export credentials functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export ${credentials.length} credential${credentials.length == 1 ? '' : 's'} functionality coming soon'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildCredentialsStatsBar(BuildContext context) {
    final credentials = ref.watch(filteredCredentialsProvider);
    final stats = _calculateCredentialStats(credentials);

    final statsData = [
      StatData(
        label: 'Total',
        count: stats.total,
        icon: Icons.key,
        color: Theme.of(context).colorScheme.primary,
      ),
      StatData(
        label: 'Valid',
        count: stats.valid,
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      StatData(
        label: 'Invalid',
        count: stats.invalid,
        icon: Icons.cancel,
        color: Colors.red,
      ),
      StatData(
        label: 'Untested',
        count: stats.untested,
        icon: Icons.help_outline,
        color: Colors.orange,
      ),
      StatData(
        label: 'User Accounts',
        count: stats.userAccounts,
        icon: Icons.person,
        color: Colors.blue,
      ),
      StatData(
        label: 'Admin Accounts',
        count: stats.adminAccounts,
        icon: Icons.admin_panel_settings,
        color: Colors.purple,
      ),
    ];

    return StandardStatsBar(chips: StatsHelper.buildChips(statsData));
  }


  CredentialStats _calculateCredentialStats(List<Credential> credentials) {
    final valid = credentials.where((c) => c.status == CredentialStatus.valid).length;
    final invalid = credentials.where((c) => c.status == CredentialStatus.invalid).length;
    final untested = credentials.where((c) => c.status == CredentialStatus.untested).length;
    final userAccounts = credentials.where((c) => c.type == CredentialType.user).length;
    final adminAccounts = credentials.where((c) => c.type == CredentialType.admin).length;

    return CredentialStats(
      total: credentials.length,
      valid: valid,
      invalid: invalid,
      untested: untested,
      userAccounts: userAccounts,
      adminAccounts: adminAccounts,
    );
  }

  /// Build primary filters (most important ones shown on mobile)
  List<PrimaryFilter> _buildPrimaryFilters() {
    final filters = ref.watch(credentialFiltersProvider);
    final typeFilters = _getTypeFilters(filters.activeFilters);
    final statusFilters = _getStatusFilters(filters.activeFilters);

    return [
      // Status filter (most important for credentials)
      PrimaryFilter(
        label: 'Status: ${_getStatusLabel(statusFilters)}',
        isSelected: statusFilters.isNotEmpty,
        onPressed: () => _showStatusOptions(),
        icon: Icons.verified,
        badge: statusFilters.length > 1 ? statusFilters.length.toString() : null,
      ),

      // Type filter (second most important)
      PrimaryFilter(
        label: 'Type: ${_getTypeLabel(typeFilters)}',
        isSelected: typeFilters.isNotEmpty,
        onPressed: () => _showTypeOptions(),
        icon: Icons.category,
        badge: typeFilters.length > 1 ? typeFilters.length.toString() : null,
      ),
    ];
  }

  /// Build advanced filters for bottom sheet
  List<FilterSection> _buildAdvancedFilters() {
    final filters = ref.watch(credentialFiltersProvider);

    return [
      // Credential Types Section
      FilterSection(
        title: 'Credential Types',
        icon: Icons.category,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'User Accounts',
                isSelected: filters.activeFilters.contains(CredentialFilter.user),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.user),
                icon: Icons.person,
              ),
              StandardFilterChip(
                label: 'Admin Accounts',
                isSelected: filters.activeFilters.contains(CredentialFilter.admin),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.admin),
                icon: Icons.admin_panel_settings,
              ),
              StandardFilterChip(
                label: 'Service Accounts',
                isSelected: filters.activeFilters.contains(CredentialFilter.service),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.service),
                icon: Icons.settings,
              ),
              StandardFilterChip(
                label: 'Hashes',
                isSelected: filters.activeFilters.contains(CredentialFilter.hash),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.hash),
                icon: Icons.tag,
              ),
            ],
          ),
        ],
      ),

      // Status Section
      FilterSection(
        title: 'Status',
        icon: Icons.info,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Valid',
                isSelected: filters.activeFilters.contains(CredentialFilter.valid),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.valid),
                icon: Icons.check_circle,
              ),
              StandardFilterChip(
                label: 'Invalid',
                isSelected: filters.activeFilters.contains(CredentialFilter.invalid),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.invalid),
                icon: Icons.cancel,
              ),
              StandardFilterChip(
                label: 'Untested',
                isSelected: filters.activeFilters.contains(CredentialFilter.untested),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.untested),
                icon: Icons.help_outline,
              ),
            ],
          ),
        ],
      ),

      // Source Section
      FilterSection(
        title: 'Source',
        icon: Icons.source,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Client Provided',
                isSelected: filters.activeFilters.contains(CredentialFilter.clientProvided),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.clientProvided),
                icon: Icons.business,
              ),
              StandardFilterChip(
                label: 'Password Spray',
                isSelected: filters.activeFilters.contains(CredentialFilter.passwordSpray),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.passwordSpray),
                icon: Icons.water_drop,
              ),
              StandardFilterChip(
                label: 'Kerberoasting',
                isSelected: filters.activeFilters.contains(CredentialFilter.kerberoasting),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.kerberoasting),
                icon: Icons.security,
              ),
            ],
          ),
        ],
      ),

      // Privilege Level Section
      FilterSection(
        title: 'Privilege Level',
        icon: Icons.admin_panel_settings,
        initiallyExpanded: false,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Local Admin',
                isSelected: filters.activeFilters.contains(CredentialFilter.localAdmin),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.localAdmin),
                icon: Icons.computer,
              ),
              StandardFilterChip(
                label: 'Domain Admin',
                isSelected: filters.activeFilters.contains(CredentialFilter.domainAdmin),
                onPressed: () => ref.read(credentialFiltersProvider.notifier).toggleFilter(CredentialFilter.domainAdmin),
                icon: Icons.domain,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  // Filter helper methods
  Set<CredentialFilter> _getStatusFilters(Set<CredentialFilter> activeFilters) {
    return activeFilters.where((filter) => [
      CredentialFilter.valid,
      CredentialFilter.invalid,
      CredentialFilter.untested,
    ].contains(filter)).toSet();
  }

  Set<CredentialFilter> _getTypeFilters(Set<CredentialFilter> activeFilters) {
    return activeFilters.where((filter) => [
      CredentialFilter.user,
      CredentialFilter.admin,
      CredentialFilter.service,
      CredentialFilter.hash,
    ].contains(filter)).toSet();
  }

  String _getStatusLabel(Set<CredentialFilter> statusFilters) {
    if (statusFilters.isEmpty) return 'All';
    if (statusFilters.length == 1) {
      final filter = statusFilters.first;
      switch (filter) {
        case CredentialFilter.valid: return 'Valid';
        case CredentialFilter.invalid: return 'Invalid';
        case CredentialFilter.untested: return 'Untested';
        default: return 'All';
      }
    }
    return 'Multiple (${statusFilters.length})';
  }

  String _getTypeLabel(Set<CredentialFilter> typeFilters) {
    if (typeFilters.isEmpty) return 'All';
    if (typeFilters.length == 1) {
      final filter = typeFilters.first;
      switch (filter) {
        case CredentialFilter.user: return 'User';
        case CredentialFilter.admin: return 'Admin';
        case CredentialFilter.service: return 'Service';
        case CredentialFilter.hash: return 'Hash';
        default: return 'All';
      }
    }
    return 'Multiple (${typeFilters.length})';
  }

  int _getActiveFilterCount() {
    final filters = ref.read(credentialFiltersProvider);
    // Don't count 'all' as an active filter
    return filters.activeFilters.contains(CredentialFilter.all) ? 0 : filters.activeFilters.length;
  }

  void _showStatusOptions() {
    // Show quick status filter options
    final notifier = ref.read(credentialFiltersProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('Valid'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.valid);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: const Text('Invalid'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.invalid);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.orange),
              title: const Text('Untested'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.untested);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTypeOptions() {
    // Show quick type filter options
    final notifier = ref.read(credentialFiltersProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('User Accounts'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.user);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Accounts'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.admin);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Service Accounts'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.service);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.tag),
              title: const Text('Hashes'),
              onTap: () {
                notifier.toggleFilter(CredentialFilter.hash);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class CredentialStats {
  final int total;
  final int valid;
  final int invalid;
  final int untested;
  final int userAccounts;
  final int adminAccounts;

  CredentialStats({
    required this.total,
    required this.valid,
    required this.invalid,
    required this.untested,
    required this.userAccounts,
    required this.adminAccounts,
  });
}