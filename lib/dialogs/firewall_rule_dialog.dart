import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_spacing.dart';

class FirewallRuleDialog extends StatefulWidget {
  final Map<String, dynamic>? rule;
  final Function(Map<String, dynamic>) onSave;

  const FirewallRuleDialog({
    super.key,
    this.rule,
    required this.onSave,
  });

  @override
  State<FirewallRuleDialog> createState() => _FirewallRuleDialogState();
}

class _FirewallRuleDialogState extends State<FirewallRuleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sourceNetworkController = TextEditingController();
  final _destinationNetworkController = TextEditingController();
  final _portsController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedAction = 'allow';
  String _selectedProtocol = 'tcp';
  bool _enabled = true;

  static const _uuid = Uuid();

  final List<String> _actions = ['allow', 'deny', 'drop', 'log'];
  final List<String> _protocols = ['tcp', 'udp', 'icmp', 'any'];

  @override
  void initState() {
    super.initState();
    if (widget.rule != null) {
      _loadExistingRule();
    } else {
      _setDefaults();
    }
  }

  void _loadExistingRule() {
    final rule = widget.rule!;
    _nameController.text = rule['name'] ?? '';
    _sourceNetworkController.text = rule['sourceNetwork'] ?? '';
    _destinationNetworkController.text = rule['destinationNetwork'] ?? '';
    _portsController.text = rule['ports'] ?? '';
    _descriptionController.text = rule['description'] ?? '';
    _selectedAction = rule['action'] ?? 'allow';
    _selectedProtocol = rule['protocol'] ?? 'tcp';
    _enabled = rule['enabled'] ?? true;
  }

  void _setDefaults() {
    _nameController.text = 'New Firewall Rule';
    _sourceNetworkController.text = 'any';
    _destinationNetworkController.text = 'any';
    _portsController.text = 'any';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sourceNetworkController.dispose();
    _destinationNetworkController.dispose();
    _portsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.rule == null ? 'Add Firewall Rule' : 'Edit Firewall Rule'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Rule Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Rule Name',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Allow HTTP Traffic',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Rule name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Action Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedAction,
                  decoration: const InputDecoration(
                    labelText: 'Action',
                    border: OutlineInputBorder(),
                  ),
                  items: _actions.map((action) => DropdownMenuItem(
                    value: action,
                    child: Row(
                      children: [
                        Icon(_getActionIcon(action), color: _getActionColor(action)),
                        const SizedBox(width: 8),
                        Text(_formatActionName(action)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAction = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Source Network
                TextFormField(
                  controller: _sourceNetworkController,
                  decoration: const InputDecoration(
                    labelText: 'Source Network',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 192.168.1.0/24 or any',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Source network is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Destination Network
                TextFormField(
                  controller: _destinationNetworkController,
                  decoration: const InputDecoration(
                    labelText: 'Destination Network',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 192.168.2.0/24 or any',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Destination network is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Protocol Dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedProtocol,
                  decoration: const InputDecoration(
                    labelText: 'Protocol',
                    border: OutlineInputBorder(),
                  ),
                  items: _protocols.map((protocol) => DropdownMenuItem(
                    value: protocol,
                    child: Text(protocol.toUpperCase()),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProtocol = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Ports
                TextFormField(
                  controller: _portsController,
                  decoration: const InputDecoration(
                    labelText: 'Ports',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 80, 80-443, or any',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ports field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'Brief description of this rule',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),

                // Enabled Switch
                SwitchListTile(
                  title: const Text('Rule Enabled'),
                  subtitle: Text(_enabled ? 'This rule is active' : 'This rule is disabled'),
                  value: _enabled,
                  onChanged: (value) {
                    setState(() {
                      _enabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveRule,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveRule() {
    if (_formKey.currentState!.validate()) {
      final rule = {
        'id': widget.rule?['id'] ?? _uuid.v4(),
        'name': _nameController.text,
        'action': _selectedAction,
        'sourceNetwork': _sourceNetworkController.text,
        'destinationNetwork': _destinationNetworkController.text,
        'protocol': _selectedProtocol,
        'ports': _portsController.text,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'enabled': _enabled,
        'lastModified': DateTime.now().toIso8601String(),
      };

      widget.onSave(rule);
      Navigator.of(context).pop();
    }
  }

  IconData _getActionIcon(String action) {
    switch (action) {
      case 'allow': return Icons.check_circle;
      case 'deny': return Icons.block;
      case 'drop': return Icons.delete;
      case 'log': return Icons.list_alt;
      default: return Icons.help;
    }
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'allow': return Colors.green;
      case 'deny': return Colors.red;
      case 'drop': return Colors.red.shade700;
      case 'log': return Colors.blue;
      default: return Colors.grey;
    }
  }

  String _formatActionName(String action) {
    switch (action) {
      case 'allow': return 'Allow';
      case 'deny': return 'Deny';
      case 'drop': return 'Drop';
      case 'log': return 'Log';
      default: return action;
    }
  }
}