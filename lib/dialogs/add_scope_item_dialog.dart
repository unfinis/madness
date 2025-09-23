import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scope.dart';
import '../providers/scope_provider.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../utils/validation_rules.dart';

class AddScopeItemDialog extends StandardDialog {
  final String segmentId;
  final String segmentTitle;

  const AddScopeItemDialog({
    super.key,
    required this.segmentId,
    required this.segmentTitle,
  });

  @override
  String get title => 'Add Scope Item';

  @override
  String get subtitle => 'Add new target to $segmentTitle';

  @override
  IconData get headerIcon => Icons.add_box_rounded;

  @override
  Widget buildContent(BuildContext context) {
    return _AddScopeItemForm(segmentId: segmentId);
  }
}

class _AddScopeItemForm extends ConsumerStatefulWidget {
  final String segmentId;

  const _AddScopeItemForm({required this.segmentId});

  @override
  ConsumerState<_AddScopeItemForm> createState() => _AddScopeItemFormState();
}

class _AddScopeItemFormState extends ConsumerState<_AddScopeItemForm> {
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  final _descriptionController = TextEditingController();
  ScopeItemType _selectedType = ScopeItemType.url;
  bool _isActive = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _targetController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DialogComponents.buildFormSection(
            context: context,
            title: 'Target Information',
            children: [
              DialogComponents.buildDropdownField<ScopeItemType>(
                context: context,
                value: _selectedType,
                label: 'Target Type',
                prefixIcon: Icons.category_rounded,
                items: ScopeItemType.values,
                itemBuilder: (type) => Row(
                  children: [
                    Icon(_getTypeIcon(type), size: 16),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
                onChanged: (value) => setState(() => _selectedType = value!),
              ),
              DialogComponents.buildTextField(
                context: context,
                controller: _targetController,
                label: 'Target',
                hintText: _getTargetHint(),
                prefixIcon: Icons.web_rounded,
                validator: ValidationUtils.target(),
              ),
              DialogComponents.buildTextField(
                context: context,
                controller: _descriptionController,
                label: 'Description (Optional)',
                hintText: 'Add notes or additional context about this target',
                prefixIcon: Icons.description_rounded,
                maxLines: 3,
              ),
              DialogComponents.buildSwitchField(
                context: context,
                label: 'Active',
                subtitle: 'Include this target in testing',
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
          DialogComponents.buildActionButtons(
            context: context,
            primaryAction: ActionButton(
              label: 'Add Target',
              icon: Icons.add_rounded,
              onPressed: _isSubmitting ? null : _submitScopeItem,
              isLoading: _isSubmitting,
              loadingText: 'Adding...',
            ),
            secondaryAction: ActionButton(
              label: 'Cancel',
              onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
              type: ActionButtonType.secondary,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(ScopeItemType type) {
    switch (type) {
      case ScopeItemType.url:
        return Icons.link_rounded;
      case ScopeItemType.domain:
        return Icons.domain_rounded;
      case ScopeItemType.ipRange:
        return Icons.network_check_rounded;
      case ScopeItemType.host:
        return Icons.computer_rounded;
      case ScopeItemType.network:
        return Icons.hub_rounded;
    }
  }

  String _getTargetHint() {
    switch (_selectedType) {
      case ScopeItemType.url:
        return 'Enter URL (e.g., https://example.com)';
      case ScopeItemType.domain:
        return 'Enter domain name (e.g., example.com)';
      case ScopeItemType.ipRange:
        return 'Enter IP range (e.g., 192.168.1.0/24)';
      case ScopeItemType.host:
        return 'Enter host (e.g., 192.168.1.1 or server.local)';
      case ScopeItemType.network:
        return 'Enter network (e.g., 10.0.0.0/8)';
    }
  }

  void _submitScopeItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final scopeItem = ScopeItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        target: _targetController.text.trim(),
        type: _selectedType,
        description: _descriptionController.text.trim().isEmpty
            ? 'No description provided'
            : _descriptionController.text.trim(),
        isActive: _isActive,
        dateAdded: DateTime.now(),
      );

      await ref.read(scopeProvider.notifier).addItemToSegment(widget.segmentId, scopeItem);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Target "${scopeItem.target}" added successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add target: ${e.toString()}'),
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