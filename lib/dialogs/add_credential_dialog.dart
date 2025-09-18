import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import '../providers/credential_provider.dart';

class AddCredentialDialog extends ConsumerStatefulWidget {
  const AddCredentialDialog({super.key});

  @override
  ConsumerState<AddCredentialDialog> createState() => _AddCredentialDialogState();
}

class _AddCredentialDialogState extends ConsumerState<AddCredentialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hashController = TextEditingController();
  final _targetController = TextEditingController();
  final _domainController = TextEditingController();
  final _notesController = TextEditingController();
  
  CredentialType _selectedType = CredentialType.user;
  CredentialStatus _selectedStatus = CredentialStatus.untested;
  CredentialPrivilege _selectedPrivilege = CredentialPrivilege.user;
  CredentialSource _selectedSource = CredentialSource.clientProvided;
  bool _isSubmitting = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _hashController.dispose();
    _targetController.dispose();
    _domainController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 600 : null,
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
            _buildHeader(context),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildUsernameField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildDomainField()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildTypeField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildPrivilegeField()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (_selectedType != CredentialType.hash) _buildPasswordField()
                      else _buildHashField(),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: _buildSourceField()),
                          const SizedBox(width: 16),
                          Expanded(child: _buildStatusField()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildTargetField(),
                      const SizedBox(height: 20),
                      _buildNotesField(),
                    ],
                  ),
                ),
              ),
            ),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
              Icons.key_rounded,
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
                  'Add Credential',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add a new credential to your collection',
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

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            hintText: 'e.g., administrator',
            prefixIcon: Icon(
              Icons.person_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a username';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDomainField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Domain (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _domainController,
          decoration: InputDecoration(
            hintText: 'e.g., DOMAIN',
            prefixIcon: Icon(
              Icons.domain_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _passwordController,
          obscureText: !_showPassword,
          decoration: InputDecoration(
            hintText: 'Enter password',
            prefixIcon: Icon(
              Icons.lock_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _showPassword = !_showPassword),
              icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a password';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHashField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hash',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _hashController,
          decoration: InputDecoration(
            hintText: 'Enter hash value',
            prefixIcon: Icon(
              Icons.tag_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          maxLines: 3,
          minLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a hash';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTypeField() {
    return _buildDropdownField(
      'Type',
      _selectedType,
      CredentialType.values,
      (type) => Row(
        children: [
          Text(type.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(type.displayName),
        ],
      ),
      (value) => setState(() => _selectedType = value!),
    );
  }

  Widget _buildPrivilegeField() {
    return _buildDropdownField(
      'Privilege',
      _selectedPrivilege,
      CredentialPrivilege.values,
      (privilege) => Text(privilege.displayName),
      (value) => setState(() => _selectedPrivilege = value!),
    );
  }

  Widget _buildSourceField() {
    return _buildDropdownField(
      'Source',
      _selectedSource,
      CredentialSource.values,
      (source) => Text(source.displayName),
      (value) => setState(() => _selectedSource = value!),
    );
  }

  Widget _buildStatusField() {
    return _buildDropdownField(
      'Status',
      _selectedStatus,
      CredentialStatus.values,
      (status) => Row(
        children: [
          Text(status.icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(status.displayName),
        ],
      ),
      (value) => setState(() => _selectedStatus = value!),
    );
  }

  Widget _buildDropdownField<T>(
    String label,
    T value,
    List<T> items,
    Widget Function(T) itemBuilder,
    void Function(T?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
            color: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: items.map((item) {
              return DropdownMenuItem(
                value: item,
                child: itemBuilder(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Target',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _targetController,
          decoration: InputDecoration(
            hintText: 'e.g., 192.168.1.100 or server.domain.com',
            prefixIcon: Icon(
              Icons.computer_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a target';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes (Optional)',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _notesController,
          decoration: InputDecoration(
            hintText: 'Additional notes about this credential...',
            prefixIcon: Icon(
              Icons.note_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
          ),
          maxLines: 3,
          minLines: 2,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
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
              onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submitCredential,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8),
                        Text('Adding...'),
                      ],
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Add Credential'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitCredential() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final credential = Credential(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        username: _usernameController.text.trim(),
        password: _selectedType != CredentialType.hash ? _passwordController.text.trim() : null,
        hash: _selectedType == CredentialType.hash ? _hashController.text.trim() : null,
        type: _selectedType,
        status: _selectedStatus,
        privilege: _selectedPrivilege,
        source: _selectedSource,
        target: _targetController.text.trim(),
        dateAdded: DateTime.now(),
        domain: _domainController.text.trim().isEmpty ? null : _domainController.text.trim(),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      ref.read(credentialProvider.notifier).addCredential(credential);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Credential "${credential.username}" added successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add credential: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}