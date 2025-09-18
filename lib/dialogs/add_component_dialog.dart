import 'package:flutter/material.dart';
import '../models/finding.dart';

class AddComponentDialog extends StatefulWidget {
  final FindingComponent? component;

  const AddComponentDialog({
    super.key,
    this.component,
  });

  @override
  State<AddComponentDialog> createState() => _AddComponentDialogState();
}

class _AddComponentDialogState extends State<AddComponentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _valueController;
  late TextEditingController _descriptionController;
  
  ComponentType _selectedType = ComponentType.hostname;

  @override
  void initState() {
    super.initState();
    
    final component = widget.component;
    _nameController = TextEditingController(text: component?.name ?? '');
    _valueController = TextEditingController(text: component?.value ?? '');
    _descriptionController = TextEditingController(text: component?.description ?? '');
    
    if (component != null) {
      _selectedType = component.type;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.component != null;
    
    return AlertDialog(
      title: Text(isEditing ? 'Edit Component' : 'Add Component'),
      content: Container(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Component Type
              DropdownButtonFormField<ComponentType>(
                value: _selectedType,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ComponentType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                    _updatePlaceholders();
                  }
                },
              ),
              const SizedBox(height: 16),
              
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g., Login URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Value
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText: 'e.g., https://example.com/login',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Value is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Description (optional)
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Additional context or notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _saveComponent,
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _updatePlaceholders() {
    // Update placeholders based on component type
    switch (_selectedType) {
      case ComponentType.hostname:
        if (_nameController.text.isEmpty) _nameController.text = 'Server Name';
        break;
      case ComponentType.ipAddress:
        if (_nameController.text.isEmpty) _nameController.text = 'IP Address';
        break;
      case ComponentType.url:
        if (_nameController.text.isEmpty) _nameController.text = 'Target URL';
        break;
      case ComponentType.port:
        if (_nameController.text.isEmpty) _nameController.text = 'Port Number';
        break;
      case ComponentType.service:
        if (_nameController.text.isEmpty) _nameController.text = 'Service Name';
        break;
      case ComponentType.parameter:
        if (_nameController.text.isEmpty) _nameController.text = 'Parameter Name';
        break;
      case ComponentType.path:
        if (_nameController.text.isEmpty) _nameController.text = 'File Path';
        break;
      case ComponentType.other:
        if (_nameController.text.isEmpty) _nameController.text = 'Component';
        break;
    }
  }

  void _saveComponent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final component = FindingComponent(
      id: widget.component?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      findingId: widget.component?.findingId ?? '',
      type: _selectedType,
      name: _nameController.text.trim(),
      value: _valueController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      createdDate: widget.component?.createdDate ?? DateTime.now(),
    );

    Navigator.of(context).pop(component);
  }
}