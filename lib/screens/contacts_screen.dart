import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/contact_table_widget.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../dialogs/add_contact_dialog.dart';
import '../constants/app_spacing.dart';
import '../widgets/unified_filter/unified_filter.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  final String projectId;
  
  const ContactsScreen({super.key, required this.projectId});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchController = TextEditingController();
  bool _useTableView = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideDesktop = screenWidth > 1200;
    
    // If no project is selected, show a message
    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }
    
    final filteredContactsAsync = ref.watch(filteredContactsProvider(currentProject.id));
    
    // Auto-enable table view on very wide screens
    final shouldShowTableToggle = screenWidth > 1000;
    if (screenWidth > 1400 && !_useTableView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _useTableView = true;
          });
        }
      });
    }
    
    return ScreenWrapper(
      children: [
            _buildContactsStatsBar(context, currentProject.id),
            SizedBox(height: CommonLayoutWidgets.sectionSpacing),
            
            ResponsiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with responsive buttons
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and main actions are now in the top bar
                        // Keep view toggle here as it's screen-specific
                        if (shouldShowTableToggle)
                          SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment<bool>(
                                value: false,
                                icon: Icon(Icons.view_agenda, size: 16),
                                label: Text('Cards'),
                              ),
                              ButtonSegment<bool>(
                                value: true,
                                icon: Icon(Icons.table_rows, size: 16),
                                label: Text('Table'),
                              ),
                            ],
                            selected: {_useTableView},
                            onSelectionChanged: (selection) {
                              setState(() {
                                _useTableView = selection.first;
                              });
                            },
                            style: SegmentedButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: isWideDesktop ? 16 : 24),
                    
                    UnifiedFilterBar(
                      searchController: _searchController,
                      searchHint: 'Search contacts, emails, roles...',
                      primaryFilters: _buildPrimaryFilters(),
                      advancedFilters: _buildAdvancedFilters(),
                      advancedFiltersTitle: 'Contact Filters',
                      onSearchChanged: (value) {
                        ref.read(contactFiltersProvider.notifier).updateSearchQuery(value);
                      },
                      onSearchCleared: () {
                        ref.read(contactFiltersProvider.notifier).updateSearchQuery('');
                      },
                      onAdvancedFiltersChanged: () {
                        // Advanced filter changes are handled by individual filter callbacks
                      },
                      activeFilterCount: _getActiveFilterCount(),
                      resultCount: filteredContactsAsync.value?.length,
                    ),
                    SizedBox(height: isWideDesktop ? 16 : 24),
                    
                    filteredContactsAsync.when(
                      data: (filteredContacts) {
                        if (filteredContacts.isEmpty) {
                          return CommonStateWidgets.noData(
                            itemName: 'contacts',
                            icon: Icons.people_outline,
                            onCreate: () => _showAddContactDialog(context),
                            createButtonText: 'Add Contact',
                          );
                        } else if (_useTableView && shouldShowTableToggle) {
                          return ContactTableWidget(contacts: filteredContacts, projectId: currentProject.id);
                        } else {
                          return _buildContactsList(filteredContacts);
                        }
                      },
                      loading: () => CommonStateWidgets.loadingWithPadding(),
                      error: (error, stackTrace) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            children: [
                              const Icon(Icons.error, size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text('Error loading contacts: $error'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => ref.refresh(filteredContactsProvider(currentProject.id)),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }



  Widget _buildContactsList(List<Contact> contacts) {
    final sortedContacts = [...contacts]
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      children: sortedContacts.asMap().entries.map((entry) {
        final index = entry.key;
        final contact = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < sortedContacts.length - 1 ? 12 : 0),
          child: _buildContactCard(contact),
        );
      }).toList(),
    );
  }

  Widget _buildContactCard(Contact contact) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editContact(context, contact),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(isDesktop ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop)
                    _buildDesktopContactLayout(contact)
                  else
                    _buildMobileContactLayout(contact),
                  
                  if (contact.notes != null && contact.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        contact.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Action buttons positioned at top-right
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _editContact(context, contact),
                    tooltip: 'Edit contact',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => _deleteContact(context, contact),
                    tooltip: 'Delete contact',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopContactLayout(Contact contact) {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.role,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        contact.email,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.phone,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      contact.phone,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildRoleTagsPreview(contact),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileContactLayout(Contact contact) {
    return Padding(
      padding: const EdgeInsets.only(right: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      contact.role,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildRoleTagsPreview(contact),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.email,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  contact.email,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                contact.phone,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleTagsPreview(Contact contact) {
    if (contact.tags.isEmpty) {
      return Text(
        'No tags',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.outline,
          fontSize: 10,
        ),
      );
    }
    
    // Show first 2 tags, plus indicator if there are more
    final visibleTags = contact.tags.take(2).toList();
    final hasMoreTags = contact.tags.length > 2;
    
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: [
        ...visibleTags.map((tag) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        )),
        if (hasMoreTags)
          Text(
            '+${contact.tags.length - 2}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontSize: 9,
            ),
          ),
      ],
    );
  }

  void _showAddContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(projectId: widget.projectId),
    );
  }

  void _editContact(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(contact: contact, projectId: widget.projectId),
    );
  }

  void _deleteContact(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text(
          'Are you sure you want to delete "${contact.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(contactProvider(widget.projectId).notifier).deleteContact(contact.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact deleted successfully'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }



  Widget _buildContactsStatsBar(BuildContext context, String projectId) {
    final contactsAsync = ref.watch(contactProvider(projectId));

    return contactsAsync.when(
      loading: () => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: const Text('Error loading contacts'),
      ),
      data: (contacts) {
        final stats = _calculateContactStats(contacts);

        final statsData = [
          StatData(
            label: 'Total',
            count: stats.total,
            icon: Icons.people_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          StatData(
            label: 'Emergency',
            count: stats.emergency,
            icon: Icons.emergency,
            color: Colors.red,
          ),
          StatData(
            label: 'Technical',
            count: stats.technical,
            icon: Icons.engineering,
            color: Colors.blue,
          ),
          StatData(
            label: 'Report Recipients',
            count: stats.reportRecipients,
            icon: Icons.report,
            color: Colors.green,
          ),
          StatData(
            label: 'Client Contacts',
            count: stats.clientContacts,
            icon: Icons.business,
            color: Colors.orange,
          ),
          StatData(
            label: 'Internal Team',
            count: stats.internalTeam,
            icon: Icons.group,
            color: Colors.purple,
          ),
        ];

        return StandardStatsBar(chips: StatsHelper.buildChips(statsData));
      },
    );
  }


  ContactStats _calculateContactStats(List<Contact> contacts) {
    final emergency = contacts.where((c) => c.tags.contains('emergency')).length;
    final technical = contacts.where((c) => c.tags.contains('technical')).length;
    final reportRecipients = contacts.where((c) => c.tags.contains('reportRecipient')).length;
    final clientContacts = contacts.where((c) => c.tags.contains('client')).length;
    final internalTeam = contacts.where((c) => c.tags.contains('internal')).length;

    return ContactStats(
      total: contacts.length,
      emergency: emergency,
      technical: technical,
      reportRecipients: reportRecipients,
      clientContacts: clientContacts,
      internalTeam: internalTeam,
    );
  }

  /// Build primary filters (most important ones shown on mobile)
  List<PrimaryFilter> _buildPrimaryFilters() {
    final filters = ref.watch(contactFiltersProvider);
    final roleFilters = _getRoleFilters(filters.activeFilters);
    final typeFilters = _getTypeFilters(filters.activeFilters);

    return [
      // Role filter (most important for contacts)
      PrimaryFilter(
        label: 'Role: ${_getRoleLabel(roleFilters)}',
        isSelected: roleFilters.isNotEmpty,
        onPressed: () => _showRoleOptions(),
        icon: Icons.work,
        badge: roleFilters.length > 1 ? roleFilters.length.toString() : null,
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
    final filters = ref.watch(contactFiltersProvider);

    return [
      // Contact Roles Section
      FilterSection(
        title: 'Contact Roles',
        icon: Icons.work,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Primary Contact',
                isSelected: filters.activeFilters.contains(ContactFilter.primary),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.primary),
                icon: Icons.star,
              ),
              StandardFilterChip(
                label: 'Technical Contact',
                isSelected: filters.activeFilters.contains(ContactFilter.technical),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.technical),
                icon: Icons.engineering,
              ),
              StandardFilterChip(
                label: 'Emergency Contact',
                isSelected: filters.activeFilters.contains(ContactFilter.emergency),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.emergency),
                icon: Icons.emergency,
              ),
              StandardFilterChip(
                label: 'Escalation Contact',
                isSelected: filters.activeFilters.contains(ContactFilter.escalation),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.escalation),
                icon: Icons.trending_up,
              ),
            ],
          ),
        ],
      ),

      // Specialized Roles Section
      FilterSection(
        title: 'Specialized Roles',
        icon: Icons.person_pin,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              StandardFilterChip(
                label: 'Security Consultant',
                isSelected: filters.activeFilters.contains(ContactFilter.securityConsultant),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.securityConsultant),
                icon: Icons.security,
              ),
              StandardFilterChip(
                label: 'Account Manager',
                isSelected: filters.activeFilters.contains(ContactFilter.accountManager),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.accountManager),
                icon: Icons.account_circle,
              ),
              StandardFilterChip(
                label: 'Report Recipients',
                isSelected: filters.activeFilters.contains(ContactFilter.receiveReport),
                onPressed: () => ref.read(contactFiltersProvider.notifier).toggleFilter(ContactFilter.receiveReport),
                icon: Icons.report,
              ),
            ],
          ),
        ],
      ),
    ];
  }

  // Filter helper methods
  Set<ContactFilter> _getRoleFilters(Set<ContactFilter> activeFilters) {
    return activeFilters.where((filter) => [
      ContactFilter.primary,
      ContactFilter.technical,
      ContactFilter.emergency,
      ContactFilter.escalation,
    ].contains(filter)).toSet();
  }

  Set<ContactFilter> _getTypeFilters(Set<ContactFilter> activeFilters) {
    return activeFilters.where((filter) => [
      ContactFilter.securityConsultant,
      ContactFilter.accountManager,
      ContactFilter.receiveReport,
    ].contains(filter)).toSet();
  }

  String _getRoleLabel(Set<ContactFilter> roleFilters) {
    if (roleFilters.isEmpty) return 'All';
    if (roleFilters.length == 1) {
      final filter = roleFilters.first;
      switch (filter) {
        case ContactFilter.primary: return 'Primary';
        case ContactFilter.technical: return 'Technical';
        case ContactFilter.emergency: return 'Emergency';
        case ContactFilter.escalation: return 'Escalation';
        default: return 'All';
      }
    }
    return 'Multiple (${roleFilters.length})';
  }

  String _getTypeLabel(Set<ContactFilter> typeFilters) {
    if (typeFilters.isEmpty) return 'All';
    if (typeFilters.length == 1) {
      final filter = typeFilters.first;
      switch (filter) {
        case ContactFilter.securityConsultant: return 'Security';
        case ContactFilter.accountManager: return 'Account Mgr';
        case ContactFilter.receiveReport: return 'Reports';
        default: return 'All';
      }
    }
    return 'Multiple (${typeFilters.length})';
  }

  int _getActiveFilterCount() {
    final filters = ref.read(contactFiltersProvider);
    // Don't count 'all' as an active filter
    return filters.activeFilters.contains(ContactFilter.all) ? 0 : filters.activeFilters.length;
  }

  void _showRoleOptions() {
    // Show quick role filter options
    final notifier = ref.read(contactFiltersProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: const Text('Primary Contact'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.primary);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.engineering, color: Colors.blue),
              title: const Text('Technical Contact'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.technical);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.emergency, color: Colors.red),
              title: const Text('Emergency Contact'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.emergency);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.orange),
              title: const Text('Escalation Contact'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.escalation);
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
    final notifier = ref.read(contactFiltersProvider.notifier);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.security, color: Colors.purple),
              title: const Text('Security Consultant'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.securityConsultant);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.green),
              title: const Text('Account Manager'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.accountManager);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.report, color: Colors.blue),
              title: const Text('Report Recipients'),
              onTap: () {
                notifier.toggleFilter(ContactFilter.receiveReport);
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

class ContactStats {
  final int total;
  final int emergency;
  final int technical;
  final int reportRecipients;
  final int clientContacts;
  final int internalTeam;

  ContactStats({
    required this.total,
    required this.emergency,
    required this.technical,
    required this.reportRecipients,
    required this.clientContacts,
    required this.internalTeam,
  });
}