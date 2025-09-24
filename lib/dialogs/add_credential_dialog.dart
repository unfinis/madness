import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/credential.dart';
import '../providers/credential_provider.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../constants/app_spacing.dart';

class AddCredentialDialog extends StandardDialog {
  const AddCredentialDialog({super.key}) : super(size: DialogSize.medium);

  @override
  String get title => 'Add Credential';

  @override
  String? get subtitle => 'Add a new credential to your collection';

  @override
  IconData? get headerIcon => Icons.key_rounded;

  @override
  Widget buildContent(BuildContext context) {
    return const _AddCredentialForm();
  }
}

class _AddCredentialForm extends ConsumerStatefulWidget {
  const _AddCredentialForm();

  @override
  ConsumerState<_AddCredentialForm> createState() => _AddCredentialFormState();
}

class _AddCredentialFormState extends ConsumerState<_AddCredentialForm> {
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Information Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Basic Information',
            icon: Icons.person_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DialogComponents.buildTextField(
                      context: context,
                      label: 'Username',
                      controller: _usernameController,
                      hintText: 'e.g., administrator',
                      prefixIcon: Icons.person_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                  ),
                  AppSpacing.hGapLG,
                  Expanded(
                    child: DialogComponents.buildTextField(
                      context: context,
                      label: 'Domain (Optional)',
                      controller: _domainController,
                      hintText: 'e.g., DOMAIN',
                      prefixIcon: Icons.domain_rounded,
                    ),
                  ),
                ],
              ),
              AppSpacing.vGapXL,
              Row(
                children: [
                  Expanded(
                    child: DialogComponents.buildDropdownField<CredentialType>(
                      context: context,
                      label: 'Type',
                      value: _selectedType,
                      items: CredentialType.values,
                      prefixIcon: Icons.category_rounded,
                      itemBuilder: (type) => Row(
                        children: [
                          Icon(type.icon, size: 16),
                          AppSpacing.hGapSM,
                          Text(type.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedType = value!),
                    ),
                  ),
                  AppSpacing.hGapLG,
                  Expanded(
                    child: DialogComponents.buildDropdownField<CredentialPrivilege>(
                      context: context,
                      label: 'Privilege',
                      value: _selectedPrivilege,
                      items: CredentialPrivilege.values,
                      prefixIcon: Icons.admin_panel_settings_rounded,
                      itemBuilder: (privilege) => Text(privilege.displayName),
                      onChanged: (value) => setState(() => _selectedPrivilege = value!),
                    ),
                  ),
                ],
              ),
            ],
          ),

          AppSpacing.vGapXL,

          // Authentication Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Authentication',
            icon: Icons.lock_rounded,
            children: [
              if (_selectedType != CredentialType.hash)
                DialogComponents.buildTextField(
                  context: context,
                  label: 'Password',
                  controller: _passwordController,
                  hintText: 'Enter password',
                  prefixIcon: Icons.lock_rounded,
                  suffixIcon: _showPassword ? Icons.visibility_off : Icons.visibility,
                  onSuffixPressed: () => setState(() => _showPassword = !_showPassword),
                  obscureText: !_showPassword,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                )
              else
                DialogComponents.buildTextField(
                  context: context,
                  label: 'Hash',
                  controller: _hashController,
                  hintText: 'Enter hash value',
                  prefixIcon: Icons.tag_rounded,
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
          ),

          AppSpacing.vGapXL,

          // Status and Source Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Status & Source',
            icon: Icons.info_rounded,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DialogComponents.buildDropdownField<CredentialSource>(
                      context: context,
                      label: 'Source',
                      value: _selectedSource,
                      items: CredentialSource.values,
                      prefixIcon: Icons.source_rounded,
                      itemBuilder: (source) => Text(source.displayName),
                      onChanged: (value) => setState(() => _selectedSource = value!),
                    ),
                  ),
                  AppSpacing.hGapLG,
                  Expanded(
                    child: DialogComponents.buildDropdownField<CredentialStatus>(
                      context: context,
                      label: 'Status',
                      value: _selectedStatus,
                      items: CredentialStatus.values,
                      prefixIcon: Icons.assignment_turned_in_rounded,
                      itemBuilder: (status) => Row(
                        children: [
                          Icon(status.icon, size: 16),
                          AppSpacing.hGapSM,
                          Text(status.displayName),
                        ],
                      ),
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                    ),
                  ),
                ],
              ),
            ],
          ),

          AppSpacing.vGapXL,

          // Target and Notes Section
          DialogComponents.buildFormSection(
            context: context,
            title: 'Additional Details',
            icon: Icons.notes_rounded,
            children: [
              DialogComponents.buildTextField(
                context: context,
                label: 'Target',
                controller: _targetController,
                hintText: 'e.g., 192.168.1.100 or server.domain.com',
                prefixIcon: Icons.computer_rounded,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a target';
                  }
                  return null;
                },
              ),
              AppSpacing.vGapLG,
              DialogComponents.buildTextField(
                context: context,
                label: 'Notes (Optional)',
                controller: _notesController,
                hintText: 'Additional notes about this credential...',
                prefixIcon: Icons.note_rounded,
                maxLines: 3,
                minLines: 2,
              ),
            ],
          ),

          AppSpacing.vGapXL,

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: DialogComponents.buildSecondaryButton(
                  context: context,
                  text: 'Cancel',
                  onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  icon: Icons.close_rounded,
                ),
              ),
              AppSpacing.hGapLG,
              Expanded(
                child: DialogComponents.buildPrimaryButton(
                  context: context,
                  text: 'Add Credential',
                  onPressed: _isSubmitting ? null : _submitCredential,
                  icon: Icons.add_rounded,
                  isLoading: _isSubmitting,
                  loadingText: 'Adding...',
                ),
              ),
            ],
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
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: AppSizes.iconMD),
                AppSpacing.hGapSM,
                Text('Credential "${credential.username}" added successfully'),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: AppSizes.iconMD),
                AppSpacing.hGapSM,
                Expanded(child: Text('Failed to add credential: ${e.toString()}')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
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

// Convenience function to show the dialog
Future<void> showAddCredentialDialog(BuildContext context) {
  return showStandardDialog(
    context: context,
    dialog: const AddCredentialDialog(),
    animationType: DialogAnimationType.scaleAndFade,
  );
}