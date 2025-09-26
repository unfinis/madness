/// Project contacts and team roles assignment widget
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/contact.dart';
import '../../providers/contact_provider.dart';
import '../../providers/projects_provider.dart';
import '../../constants/app_spacing.dart';
import '../../dialogs/add_contact_dialog.dart';
import 'question_widget_base.dart';

class ProjectContactsQuestionWidget extends QuestionWidgetBase {
  const ProjectContactsQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<ProjectContactsQuestionWidget> createState() => _ProjectContactsQuestionWidgetState();
}

class _ProjectContactsQuestionWidgetState extends QuestionWidgetBaseState<ProjectContactsQuestionWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  final Map<String, List<String>> _teamRoles = {};
  final Set<String> _confirmedContacts = {};

  // Standard team roles for penetration testing
  static const Map<String, Map<String, dynamic>> _standardRoles = {
    'project_manager': {
      'name': 'Project Manager',
      'icon': Icons.person_outline,
      'description': 'Overall project coordination and client communication',
      'required': true,
    },
    'lead_tester': {
      'name': 'Lead Penetration Tester',
      'icon': Icons.security,
      'description': 'Technical lead and primary testing execution',
      'required': true,
    },
    'technical_specialist': {
      'name': 'Technical Specialist',
      'icon': Icons.engineering,
      'description': 'Specialized technical expertise (web, mobile, network)',
      'required': false,
    },
    'social_engineer': {
      'name': 'Social Engineering Specialist',
      'icon': Icons.psychology,
      'description': 'Human factor testing and awareness campaigns',
      'required': false,
    },
    'report_writer': {
      'name': 'Report Writer',
      'icon': Icons.description,
      'description': 'Technical writing and report creation',
      'required': true,
    },
    'quality_assurance': {
      'name': 'Quality Assurance',
      'icon': Icons.verified,
      'description': 'Review and quality control',
      'required': false,
    },
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAnswerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadAnswerData() {
    if (widget.answer?.answer is Map) {
      final data = widget.answer!.answer as Map<String, dynamic>;
      
      if (data['teamRoles'] is Map) {
        final roles = data['teamRoles'] as Map<String, dynamic>;
        _teamRoles.clear();
        roles.forEach((key, value) {
          _teamRoles[key] = List<String>.from(value ?? []);
        });
      }
      
      if (data['confirmedContacts'] is List) {
        _confirmedContacts.clear();
        _confirmedContacts.addAll(Set<String>.from(data['confirmedContacts']));
      }
    }
  }

  @override
  Widget buildQuestionContent(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final project = ref.watch(currentProjectProvider);
        final contactsAsyncValue = project != null 
            ? ref.watch(contactProvider(project.id))
            : const AsyncValue.data(<Contact>[]);

        return contactsAsyncValue.when(
          data: (contacts) => _buildContactsWidget(context, contacts, project?.id),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(context, error.toString()),
        );
      },
    );
  }

  Widget _buildContactsWidget(BuildContext context, List<Contact> contacts, String? projectId) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.groups,
                  color: theme.colorScheme.tertiary,
                  size: 24,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Team & Contacts',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.tertiary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Manage team assignments and contact confirmations',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildTeamStats(context, contacts),
              ],
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(icon: Icon(Icons.assignment_ind), text: 'Team Roles'),
              Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
            ],
          ),
          
          // Tab Content
          SizedBox(
            height: 500,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTeamRolesTab(context, contacts),
                _buildContactsTab(context, contacts, projectId),
              ],
            ),
          ),
          
          // Footer Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: projectId != null ? () => _showAddContactDialog(context, projectId) : null,
                    icon: const Icon(Icons.person_add),
                    label: const Text('Add Contact'),
                  ),
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _hasRequiredRoles() ? _confirmTeamAssignments : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Confirm Team'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamStats(BuildContext context, List<Contact> contacts) {
    final theme = Theme.of(context);
    final assignedRoles = _teamRoles.values.where((members) => members.isNotEmpty).length;
    final requiredRoles = _standardRoles.values.where((role) => role['required'] == true).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$assignedRoles/$requiredRoles',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Required',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${contacts.length} Contacts',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRolesTab(BuildContext context, List<Contact> contacts) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Role Assignments',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapMD,
          
          Expanded(
            child: ListView(
              children: _standardRoles.entries.map((entry) =>
                _buildRoleCard(context, entry.key, entry.value, contacts)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab(BuildContext context, List<Contact> contacts, String? projectId) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Project Contacts',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '${_confirmedContacts.length} of ${contacts.length} confirmed',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          AppSpacing.vGapMD,
          
          Expanded(
            child: contacts.isEmpty 
                ? _buildEmptyContactsState(context, projectId)
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return _buildContactCard(context, contact);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String roleKey, Map<String, dynamic> roleData, List<Contact> contacts) {
    final theme = Theme.of(context);
    final assignedMembers = _teamRoles[roleKey] ?? <String>[];
    final isRequired = roleData['required'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  roleData['icon'] as IconData,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                AppSpacing.hGapSM,
                Expanded(
                  child: Text(
                    roleData['name'] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isRequired)
                  Chip(
                    label: const Text('Required'),
                    backgroundColor: theme.colorScheme.errorContainer,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onErrorContainer,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            
            AppSpacing.vGapSM,
            
            Text(
              roleData['description'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            
            AppSpacing.vGapMD,
            
            // Assigned members
            if (assignedMembers.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: assignedMembers.map((contactId) {
                  final contact = contacts.where((c) => c.id == contactId).firstOrNull;
                  return contact != null
                      ? Chip(
                          avatar: CircleAvatar(
                            backgroundColor: theme.colorScheme.primaryContainer,
                            child: Text(
                              contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          label: Text(contact.name),
                          onDeleted: () => _unassignRole(roleKey, contactId),
                        )
                      : const SizedBox();
                }).toList(),
              ),
              AppSpacing.vGapSM,
            ],
            
            // Assign button
            OutlinedButton.icon(
              onPressed: contacts.isNotEmpty ? () => _showRoleAssignmentDialog(context, roleKey, roleData, contacts) : null,
              icon: const Icon(Icons.person_add, size: 16),
              label: Text(assignedMembers.isEmpty ? 'Assign Member' : 'Add Member'),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, Contact contact) {
    final theme = Theme.of(context);
    final isConfirmed = _confirmedContacts.contains(contact.id);
    final assignedRoles = _getContactRoles(contact.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isConfirmed 
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          child: Text(
            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
            style: TextStyle(
              color: isConfirmed 
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(contact.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.email.isNotEmpty)
              Text(contact.email),
            if (assignedRoles.isNotEmpty) ...[
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: assignedRoles.map((role) => Chip(
                  label: Text(_standardRoles[role]?['name'] ?? role),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                  labelStyle: const TextStyle(fontSize: 10),
                )).toList(),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConfirmed)
              Icon(
                Icons.verified,
                color: theme.colorScheme.primary,
                size: 20,
              ),
            IconButton(
              icon: Icon(
                isConfirmed ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isConfirmed ? theme.colorScheme.primary : null,
              ),
              onPressed: () => _toggleContactConfirmation(contact.id),
            ),
          ],
        ),
        onTap: () => _showContactDetails(context, contact),
      ),
    );
  }

  Widget _buildEmptyContactsState(BuildContext context, String? projectId) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_add,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          AppSpacing.vGapLG,
          Text(
            'No Contacts Added',
            style: theme.textTheme.headlineSmall,
          ),
          AppSpacing.vGapMD,
          Text(
            'Add project contacts to assign team roles and manage communications.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGapLG,
          FilledButton.icon(
            onPressed: projectId != null ? () => _showAddContactDialog(context, projectId) : null,
            icon: const Icon(Icons.person_add),
            label: const Text('Add First Contact'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.error),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: theme.colorScheme.error,
          ),
          AppSpacing.vGapMD,
          Text(
            'Failed to load contacts',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapSM,
          Text(
            error,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onErrorContainer,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<String> _getContactRoles(String contactId) {
    final roles = <String>[];
    _teamRoles.forEach((roleKey, members) {
      if (members.contains(contactId)) {
        roles.add(roleKey);
      }
    });
    return roles;
  }

  void _showRoleAssignmentDialog(BuildContext context, String roleKey, Map<String, dynamic> roleData, List<Contact> contacts) {
    final assignedMembers = _teamRoles[roleKey] ?? <String>[];
    final availableContacts = contacts.where((c) => !assignedMembers.contains(c.id)).toList();

    if (availableContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All contacts are already assigned to this role')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign ${roleData['name']}'),
        content: SizedBox(
          width: 300,
          height: 400,
          child: ListView.builder(
            itemCount: availableContacts.length,
            itemBuilder: (context, index) {
              final contact = availableContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(contact.name),
                subtitle: Text(contact.email),
                onTap: () {
                  _assignRole(roleKey, contact.id);
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showContactDetails(BuildContext context, Contact contact) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppSpacing.hGapMD,
            Text(contact.name),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contact.role.isNotEmpty) ...[
              Text('Role: ${contact.role}'),
              AppSpacing.vGapSM,
            ],
            if (contact.email.isNotEmpty) ...[
              Text('Email: ${contact.email}'),
              AppSpacing.vGapSM,
            ],
            if (contact.phone.isNotEmpty) ...[
              Text('Phone: ${contact.phone}'),
              AppSpacing.vGapSM,
            ],
            if (contact.notes?.isNotEmpty == true) ...[
              Text('Notes: ${contact.notes}'),
            ],
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

  void _showAddContactDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(projectId: projectId),
    );
  }

  void _assignRole(String roleKey, String contactId) {
    setState(() {
      _teamRoles[roleKey] = [...(_teamRoles[roleKey] ?? []), contactId];
      _updateAnswer();
    });
  }

  void _unassignRole(String roleKey, String contactId) {
    setState(() {
      _teamRoles[roleKey]?.remove(contactId);
      _updateAnswer();
    });
  }

  void _toggleContactConfirmation(String contactId) {
    setState(() {
      if (_confirmedContacts.contains(contactId)) {
        _confirmedContacts.remove(contactId);
      } else {
        _confirmedContacts.add(contactId);
      }
      _updateAnswer();
    });
  }

  bool _hasRequiredRoles() {
    final requiredRoles = _standardRoles.entries
        .where((entry) => entry.value['required'] == true)
        .map((entry) => entry.key)
        .toList();

    return requiredRoles.every((role) => 
        _teamRoles[role]?.isNotEmpty == true
    );
  }

  void _confirmTeamAssignments() {
    updateAnswer({
      'teamRoles': _teamRoles,
      'confirmedContacts': _confirmedContacts.toList(),
      'confirmed': true,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _updateAnswer() {
    updateAnswer({
      'teamRoles': _teamRoles,
      'confirmedContacts': _confirmedContacts.toList(),
      'confirmed': false,
    });
  }
}