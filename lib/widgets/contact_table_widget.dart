import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';
import '../dialogs/add_contact_dialog.dart';
import '../constants/app_spacing.dart';

class ContactTableWidget extends ConsumerWidget {
  final List<Contact> contacts;
  final String projectId;

  const ContactTableWidget({
    super.key,
    required this.contacts,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contacts.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.contentPadding.add(AppSpacing.cardPadding),
          child: Text(
            'No contacts found',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final sortedContacts = [...contacts]
      ..sort((a, b) => a.name.compareTo(b.name));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            headingRowColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            columns: const [
              DataColumn(
                label: Text(
                  'Name',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Role',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Phone',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Role Tags',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            rows: sortedContacts.map((contact) {
              return DataRow(
                onSelectChanged: (_) => _editContact(context, contact),
                cells: [
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          contact.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (contact.notes != null && contact.notes!.isNotEmpty)
                          Text(
                            contact.notes!,
                            style: TextStyle(
                              fontSize: Theme.of(context).textTheme.compactBody.fontSize,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: Text(
                        contact.role,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      contact.email,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      contact.phone,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Container(
                      constraints: const BoxConstraints(maxWidth: 150),
                      child: contact.tags.isEmpty
                        ? Text(
                            'No tags',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                              fontSize: Theme.of(context).textTheme.compactBody.fontSize,
                            ),
                          )
                        : Wrap(
                            spacing: 4,
                            runSpacing: 2,
                            children: [
                              ...contact.tags.take(3).map((tag) => 
                                _buildTag(context, tag, Theme.of(context).colorScheme.primary)),
                              if (contact.tags.length > 3)
                                _buildTag(context, '+${contact.tags.length - 3}', Theme.of(context).colorScheme.outline),
                            ],
                          ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _editContact(context, contact),
                          tooltip: 'Edit',
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => _deleteContact(context, ref, contact),
                          tooltip: 'Delete',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTag(BuildContext context, String label, Color color) {
    return Container(
      padding: AppSpacing.chipPadding,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.chipRadius),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.captionSmall.fontSize,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  void _editContact(BuildContext context, Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(contact: contact, projectId: projectId),
    );
  }

  void _deleteContact(BuildContext context, WidgetRef ref, Contact contact) {
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
              ref.read(contactProvider(projectId).notifier).deleteContact(contact.id);
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
}