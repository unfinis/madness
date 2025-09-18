import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/contact_summary_widget.dart';
import '../widgets/contact_table_widget.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/common_layout_widgets.dart';
import '../dialogs/add_contact_dialog.dart';
import '../constants/responsive_breakpoints.dart';
import '../widgets/contact_filters_widget.dart';
import '../services/contacts_export_service.dart';

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
            ContactSummaryWidget(projectId: widget.projectId, compact: true),
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
                          'Contacts',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: CommonLayoutWidgets.itemSpacing),
                        // Responsive button layout with view toggle
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 600) {
                              return Row(
                                children: [
                                  if (shouldShowTableToggle) ...[
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
                                    const Spacer(),
                                  ] else
                                    const Spacer(),
                                  ..._buildActionButtons(context),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (shouldShowTableToggle) ...[
                                    SegmentedButton<bool>(
                                      segments: const [
                                        ButtonSegment<bool>(
                                          value: false,
                                          icon: Icon(Icons.view_agenda, size: 16),
                                        ),
                                        ButtonSegment<bool>(
                                          value: true,
                                          icon: Icon(Icons.table_rows, size: 16),
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
                                    SizedBox(height: CommonLayoutWidgets.compactSpacing),
                                  ],
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
                    SizedBox(height: isWideDesktop ? 16 : 24),
                    
                    ContactFiltersWidget(searchController: _searchController),
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


  List<Widget> _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.3;
    
    if (availableWidth > 300) {
      return [
        OutlinedButton.icon(
          onPressed: () => _exportContacts(context),
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddContactDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Contact'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else {
      return [
        IconButton.outlined(
          onPressed: () => _exportContacts(context),
          icon: const Icon(Icons.download, size: 18),
          tooltip: 'Export',
        ),
        const SizedBox(width: 4),
        FilledButton.icon(
          onPressed: () => _showAddContactDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        ),
      ];
    }
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
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
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
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
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
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
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

  void _exportContacts(BuildContext context) {
    final contactsAsync = ref.read(contactProvider(widget.projectId));
    final contacts = contactsAsync.asData?.value ?? [];
    
    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No contacts to export'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Contacts'),
        content: const Text('Choose export format:'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _performExport(context, 'csv');
            },
            child: const Text('Export as CSV'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _performExport(context, 'excel');
            },
            child: const Text('Export as Excel'),
          ),
        ],
      ),
    );
  }

  Future<void> _performExport(BuildContext context, String format) async {
    try {
      final contactsAsync = ref.read(contactProvider(widget.projectId));
      final contacts = contactsAsync.asData?.value ?? [];
      late final File file;
      
      if (format == 'excel') {
        file = await ContactsExportService.exportToExcel(contacts);
      } else {
        file = await ContactsExportService.exportToCSV(contacts);
      }
      
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exported ${contacts.length} contacts to ${file.path}'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              // Platform-specific file opening would go here
            },
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

}