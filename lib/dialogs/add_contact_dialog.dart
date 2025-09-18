import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/contact.dart';
import '../providers/contact_provider.dart';

class AddContactDialog extends ConsumerStatefulWidget {
  final Contact? contact;
  final String projectId;

  const AddContactDialog({
    super.key,
    this.contact,
    required this.projectId,
  });

  @override
  ConsumerState<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends ConsumerState<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  late Set<String> _selectedTags;
  
  // Predefined role tags from wireframe
  final List<String> _availableRoleTags = [
    'Primary',
    'Technical',
    'Emergency',
    'Escalation',
    'Security Consultant',
    'Account Manager',
    'Receive Report',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _roleController = TextEditingController(text: widget.contact?.role ?? '');
    _emailController = TextEditingController(text: widget.contact?.email ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    _notesController = TextEditingController(text: widget.contact?.notes ?? '');
    _selectedTags = Set<String>.from(widget.contact?.tags ?? <String>{});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    final isEditing = widget.contact != null;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: isDesktop ? 520 : null,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildContactHeader(context, isEditing),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isDesktop)
                        _buildDesktopLayout()
                      else
                        _buildMobileLayout(),
                    ],
                  ),
                ),
              ),
            ),
            _buildContactActions(context, isEditing),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildNameField()),
            const SizedBox(width: 16),
            Expanded(child: _buildRoleField()),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildEmailField()),
            const SizedBox(width: 16),
            Expanded(child: _buildPhoneField()),
          ],
        ),
        const SizedBox(height: 16),
        _buildRoleTagsSection(),
        const SizedBox(height: 16),
        _buildNotesField(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildNameField(),
        const SizedBox(height: 16),
        _buildRoleField(),
        const SizedBox(height: 16),
        _buildEmailField(),
        const SizedBox(height: 16),
        _buildPhoneField(),
        const SizedBox(height: 16),
        _buildRoleTagsSection(),
        const SizedBox(height: 16),
        _buildNotesField(),
      ],
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Name is required';
        }
        return null;
      },
    );
  }

  Widget _buildRoleField() {
    return TextFormField(
      controller: _roleController,
      decoration: const InputDecoration(
        labelText: 'Role',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.work),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Role is required';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Phone is required';
        }
        return null;
      },
    );
  }


  Widget _buildRoleTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Role Tags',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Show available role tags
            ..._availableRoleTags.map((tag) => _buildRoleTagChip(tag)),
            // Show custom tags that aren't in the predefined list
            ..._selectedTags
                .where((tag) => !_availableRoleTags.contains(tag))
                .map((tag) => _buildCustomTagChip(tag)),
            // Add custom tag button
            _buildAddCustomTagButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleTagChip(String tag) {
    final isSelected = _selectedTags.contains(tag);
    return FilterChip(
      label: Text(tag),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          if (selected) {
            _selectedTags.add(tag);
          } else {
            _selectedTags.remove(tag);
          }
        });
      },
    );
  }

  Widget _buildCustomTagChip(String tag) {
    return FilterChip(
      label: Text(tag),
      selected: true,
      onDeleted: () {
        setState(() {
          _selectedTags.remove(tag);
        });
      },
      onSelected: (selected) {
        // Custom tags are always removable via delete button
      },
    );
  }

  Widget _buildAddCustomTagButton() {
    return ActionChip(
      label: const Text('+ Custom Tag'),
      onPressed: () {
        _showAddCustomTagDialog();
      },
    );
  }

  void _showAddCustomTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Custom Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Custom tag name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final tag = controller.text.trim();
              if (tag.isNotEmpty && !_selectedTags.contains(tag)) {
                setState(() {
                  _selectedTags.add(tag);
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      minLines: 2,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        id: widget.contact?.id,
        name: _nameController.text.trim(),
        role: _roleController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        tags: _selectedTags,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        dateAdded: widget.contact?.dateAdded,
      );

      if (widget.contact != null) {
        ref.read(contactProvider(widget.projectId).notifier).updateContact(contact);
      } else {
        ref.read(contactProvider(widget.projectId).notifier).addContact(contact);
      }

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.contact != null 
              ? 'Contact updated successfully' 
              : 'Contact added successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  Widget _buildContactHeader(BuildContext context, bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              isEditing ? Icons.edit_rounded : Icons.person_add_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Edit Contact' : 'Add New Contact',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditing ? 'Update contact information' : 'Add a new contact to your directory',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
              foregroundColor: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactActions(BuildContext context, bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.5),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                ),
              ),
              child: Text(
                'Cancel',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: _submitForm,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isEditing ? Icons.update_rounded : Icons.person_add_rounded,
                    size: 18,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isEditing ? 'Update Contact' : 'Add Contact',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}