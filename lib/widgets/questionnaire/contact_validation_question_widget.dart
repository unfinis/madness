/// Contact validation widget for team roles and stakeholder management
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/contact.dart';
import '../../providers/contact_provider.dart';
import '../../providers/projects_provider.dart';
import '../../constants/app_spacing.dart';
import '../../dialogs/add_contact_dialog.dart';
import 'question_widget_base.dart';

class ContactValidationQuestionWidget extends QuestionWidgetBase {
  const ContactValidationQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<ContactValidationQuestionWidget> createState() => _ContactValidationQuestionWidgetState();
}

class _ContactValidationQuestionWidgetState extends QuestionWidgetBaseState<ContactValidationQuestionWidget> {
  final Map<String, String?> _roleAssignments = {};
  final Set<String> _validatedRoles = {};

  @override
  void initState() {
    super.initState();
    // Initialize role assignments from existing answer
    if (widget.answer?.answer is Map) {
      final answer = widget.answer!.answer as Map<String, dynamic>;
      _roleAssignments.addAll(Map<String, String?>.from(answer['assignments'] ?? {}));
      _validatedRoles.addAll(Set<String>.from(answer['validated'] ?? []));
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
          data: (contacts) => _buildContactValidationWidget(context, contacts, project?.id),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(context, error.toString()),
        );
      },
    );
  }

  Widget _buildContactValidationWidget(BuildContext context, List<Contact> contacts, String? projectId) {
    final theme = Theme.of(context);
    final roles = widget.question.validationRoles ?? ['Primary Contact', 'Technical Contact', 'Project Manager'];

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
              color: theme.colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.people_alt,
                  color: theme.colorScheme.secondary,
                  size: 24,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Validation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Assign and validate key project contacts',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildActionButtons(context, projectId),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Role assignments
                ...roles.map((role) => _buildRoleAssignment(context, role, contacts)),
                
                AppSpacing.vGapLG,
                
                // Validation status
                _buildValidationStatus(context, roles),
                
                AppSpacing.vGapLG,
                
                // Contact list
                if (contacts.isNotEmpty) _buildContactList(context, contacts),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, String? projectId) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: OutlinedButton.icon(
              onPressed: projectId != null ? () => _showAddContactDialog(context, projectId) : null,
              icon: const Icon(Icons.person_add, size: 16),
              label: const Text('Add Contact'),
              style: OutlinedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          AppSpacing.hGapSM,
          Flexible(
            child: FilledButton.icon(
              onPressed: _allRolesValidated() ? () => _completeValidation() : null,
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Validate All'),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleAssignment(BuildContext context, String role, List<Contact> contacts) {
    final theme = Theme.of(context);
    final assignedContactId = _roleAssignments[role];
    final assignedContact = contacts.where((c) => c.id == assignedContactId).firstOrNull;
    final isValidated = _validatedRoles.contains(role);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isValidated 
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isValidated 
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isValidated ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 20,
                color: isValidated 
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              AppSpacing.hGapSM,
              Text(
                role,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isValidated 
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              if (assignedContact != null && !isValidated)
                TextButton(
                  onPressed: () => _validateRole(role),
                  child: const Text('Validate'),
                ),
            ],
          ),
          
          AppSpacing.vGapSM,
          
          DropdownButtonFormField<String?>(
            initialValue: assignedContactId,
            decoration: InputDecoration(
              labelText: 'Select Contact',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: assignedContact != null 
                  ? IconButton(
                      icon: Icon(
                        isValidated ? Icons.verified : Icons.person,
                        color: isValidated 
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () => _showContactDetails(context, assignedContact),
                    )
                  : null,
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Select a contact...'),
              ),
              ...contacts.map((contact) => DropdownMenuItem<String?>(
                value: contact.id,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text(
                          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      AppSpacing.hGapSM,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              contact.name,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (contact.email.isNotEmpty)
                              Text(
                                contact.email,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
            onChanged: isValidated ? null : (contactId) {
              setState(() {
                _roleAssignments[role] = contactId;
                _updateAnswer();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildValidationStatus(BuildContext context, List<String> roles) {
    final theme = Theme.of(context);
    final validatedCount = _validatedRoles.length;
    final totalCount = roles.length;
    final progress = totalCount > 0 ? validatedCount / totalCount : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_turned_in,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              AppSpacing.hGapSM,
              Text(
                'Validation Progress',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                '$validatedCount of $totalCount',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          
          AppSpacing.vGapSM,
          
          LinearProgressIndicator(
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildContactList(BuildContext context, List<Contact> contacts) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Contacts',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.vGapSM,
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        AppSpacing.vGapSM,
                        Text(
                          contact.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (contact.role.isNotEmpty)
                          Text(
                            contact.role,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (contact.email.isNotEmpty)
                          Text(
                            contact.email,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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

  void _validateRole(String role) {
    setState(() {
      _validatedRoles.add(role);
      _updateAnswer();
    });
  }

  bool _allRolesValidated() {
    final roles = widget.question.validationRoles ?? ['Primary Contact', 'Technical Contact', 'Project Manager'];
    return roles.every((role) => _validatedRoles.contains(role));
  }

  void _completeValidation() {
    updateAnswer({
      'assignments': _roleAssignments,
      'validated': _validatedRoles.toList(),
      'completed': true,
    });
  }

  void _updateAnswer() {
    updateAnswer({
      'assignments': _roleAssignments,
      'validated': _validatedRoles.toList(),
      'completed': _allRolesValidated(),
    });
  }

  void _showAddContactDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(projectId: projectId),
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
              radius: 20,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
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
}