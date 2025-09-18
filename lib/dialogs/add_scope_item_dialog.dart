import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scope.dart';
import '../providers/scope_provider.dart';

class AddScopeItemDialog extends ConsumerStatefulWidget {
  final String segmentId;
  final String segmentTitle;

  const AddScopeItemDialog({
    super.key,
    required this.segmentId,
    required this.segmentTitle,
  });

  @override
  ConsumerState<AddScopeItemDialog> createState() => _AddScopeItemDialogState();
}

class _AddScopeItemDialogState extends ConsumerState<AddScopeItemDialog> {
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width > 600 ? 520 : null,
        constraints: const BoxConstraints(maxHeight: 600),
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
                      _buildTypeField(),
                      const SizedBox(height: 20),
                      _buildTargetField(),
                      const SizedBox(height: 20),
                      _buildDescriptionField(),
                      const SizedBox(height: 20),
                      _buildActiveField(),
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
              Icons.add_box_rounded,
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
                  'Add Scope Item',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Add new item to "${widget.segmentTitle}"',
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

  Widget _buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item Type',
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
          child: DropdownButtonFormField<ScopeItemType>(
            value: _selectedType,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: ScopeItemType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Row(
                  children: [
                    Text(type.icon, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Text(type.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTargetField() {
    String hintText;
    switch (_selectedType) {
      case ScopeItemType.url:
        hintText = 'e.g., https://example.com';
        break;
      case ScopeItemType.domain:
        hintText = 'e.g., example.com';
        break;
      case ScopeItemType.ipRange:
        hintText = 'e.g., 192.168.1.0/24';
        break;
      case ScopeItemType.host:
        hintText = 'e.g., server01.example.com';
        break;
      case ScopeItemType.network:
        hintText = 'e.g., WiFi Network Name';
        break;
    }

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
            hintText: hintText,
            prefixIcon: Icon(
              _getIconForType(_selectedType),
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

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            hintText: 'Describe this scope item...',
            prefixIcon: Icon(
              Icons.description_rounded,
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
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildActiveField() {
    return Row(
      children: [
        Switch(
          value: _isActive,
          onChanged: (value) {
            setState(() {
              _isActive = value;
            });
          },
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Active Item',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                'Active items are included in testing scope',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
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
              onPressed: _isSubmitting ? null : _submitItem,
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
                        Text('Add Item'),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(ScopeItemType type) {
    switch (type) {
      case ScopeItemType.url:
        return Icons.link_rounded;
      case ScopeItemType.domain:
        return Icons.language_rounded;
      case ScopeItemType.ipRange:
        return Icons.router_rounded;
      case ScopeItemType.host:
        return Icons.computer_rounded;
      case ScopeItemType.network:
        return Icons.wifi_rounded;
    }
  }

  void _submitItem() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final item = ScopeItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: _selectedType,
        target: _targetController.text.trim(),
        description: _descriptionController.text.trim(),
        dateAdded: DateTime.now(),
        isActive: _isActive,
      );

      ref.read(scopeProvider.notifier).addItemToSegment(widget.segmentId, item);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item "${item.target}" added successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add item: ${e.toString()}'),
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