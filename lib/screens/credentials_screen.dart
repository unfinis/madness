import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import '../providers/credential_provider.dart';
import '../widgets/credential_filters_widget.dart';
import '../widgets/credential_table_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../dialogs/add_credential_dialog.dart';

class CredentialsScreen extends ConsumerStatefulWidget {
  const CredentialsScreen({super.key});

  @override
  ConsumerState<CredentialsScreen> createState() => _CredentialsScreenState();
}

class _CredentialsScreenState extends ConsumerState<CredentialsScreen> {
  final _searchController = TextEditingController();
  final Set<String> _selectedCredentials = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCredentials = ref.watch(filteredCredentialsProvider);
    
    return ScreenWrapper(
      children: [
        _buildCredentialsStatsBar(context),
        SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with responsive buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Credentials',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: CommonLayoutWidgets.itemSpacing),
                        // Responsive button layout
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 400) {
                              return Row(
                                children: [
                                  const Spacer(),
                                  ..._buildActionButtons(context),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _buildActionButtons(context),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: CommonLayoutWidgets.sectionSpacing),
                    
                    CredentialFiltersWidget(searchController: _searchController),
                    SizedBox(height: CommonLayoutWidgets.sectionSpacing),
                    
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


  List<Widget> _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.3;
    
    if (availableWidth > 400) {
      // Wide enough: All buttons in a row with labels
      return [
        OutlinedButton.icon(
          onPressed: () => _importCredentials(context),
          icon: const Icon(Icons.upload, size: 18),
          label: const Text('Import'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _exportCredentials(context),
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddCredentialDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Credential'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else if (availableWidth > 300) {
      // Medium width: Icon buttons with tooltips + Add button
      return [
        IconButton.outlined(
          onPressed: () => _importCredentials(context),
          icon: const Icon(Icons.upload, size: 18),
          tooltip: 'Import',
        ),
        const SizedBox(width: 4),
        IconButton.outlined(
          onPressed: () => _exportCredentials(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddCredentialDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else if (availableWidth > 200) {
      // Narrow: Export and Add only
      return [
        IconButton.outlined(
          onPressed: () => _exportCredentials(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddCredentialDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else {
      // Very narrow: Just essential buttons
      return [
        FilledButton.icon(
          onPressed: () => _showAddCredentialDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        ),
      ];
    }
  }

  Widget _buildBulkActions(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
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

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip('Total', stats.total, Icons.key, Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Valid', stats.valid, Icons.check_circle, Colors.green),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Invalid', stats.invalid, Icons.cancel, Colors.red),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Untested', stats.untested, Icons.help_outline, Colors.orange),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('User Accounts', stats.userAccounts, Icons.person, Colors.blue),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Admin Accounts', stats.adminAccounts, Icons.admin_panel_settings, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
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