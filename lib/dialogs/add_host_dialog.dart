import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../constants/app_spacing.dart';

class AddHostDialog extends ConsumerStatefulWidget {
  const AddHostDialog({super.key});

  @override
  ConsumerState<AddHostDialog> createState() => _AddHostDialogState();
}

class _AddHostDialogState extends ConsumerState<AddHostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipAddressController = TextEditingController();
  final _hostnameController = TextEditingController();
  final _macAddressController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _osType = 'unknown';
  String _osVersion = '';
  String _osArchitecture = 'x64';
  double _confidence = 0.9;

  @override
  void dispose() {
    _nameController.dispose();
    _ipAddressController.dispose();
    _hostnameController.dispose();
    _macAddressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Host Asset'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Host Name',
                    hintText: 'e.g., Web Server 01',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a host name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _ipAddressController,
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                    hintText: 'e.g., 192.168.1.100',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter an IP address';
                    }
                    // Basic IP validation
                    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                    if (!ipRegex.hasMatch(value!)) {
                      return 'Please enter a valid IP address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _hostnameController,
                  decoration: const InputDecoration(
                    labelText: 'Hostname (Optional)',
                    hintText: 'e.g., webserver01.corp.local',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _macAddressController,
                  decoration: const InputDecoration(
                    labelText: 'MAC Address (Optional)',
                    hintText: 'e.g., 00:1B:44:11:3A:B7',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _osType,
                  decoration: const InputDecoration(
                    labelText: 'Operating System',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'windows', child: Text('Windows')),
                    DropdownMenuItem(value: 'linux', child: Text('Linux')),
                    DropdownMenuItem(value: 'macos', child: Text('macOS')),
                    DropdownMenuItem(value: 'freebsd', child: Text('FreeBSD')),
                    DropdownMenuItem(value: 'solaris', child: Text('Solaris')),
                    DropdownMenuItem(value: 'unknown', child: Text('Unknown')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _osType = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'OS Version (Optional)',
                    hintText: 'e.g., Windows 10, Ubuntu 20.04',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _osVersion = value;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _osArchitecture,
                  decoration: const InputDecoration(
                    labelText: 'Architecture',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'x64', child: Text('x64 (64-bit)')),
                    DropdownMenuItem(value: 'x86', child: Text('x86 (32-bit)')),
                    DropdownMenuItem(value: 'arm64', child: Text('ARM64')),
                    DropdownMenuItem(value: 'arm', child: Text('ARM')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _osArchitecture = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Additional information about this host',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Confidence Level: ${(_confidence * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Slider(
                      value: _confidence,
                      min: 0.1,
                      max: 1.0,
                      divisions: 9,
                      onChanged: (value) {
                        setState(() {
                          _confidence = value;
                        });
                      },
                    ),
                  ],
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
          onPressed: _createHost,
          child: const Text('Add Host'),
        ),
      ],
    );
  }

  void _createHost() {
    if (_formKey.currentState?.validate() ?? false) {
      final properties = <String, PropertyValue>{
        'ip_address': PropertyValue.string(_ipAddressController.text),
        'os_type': PropertyValue.string(_osType),
        'os_architecture': PropertyValue.string(_osArchitecture),
        'open_ports': const PropertyValue.stringList([]),
        'services': const PropertyValue.objectList([]),
        'smb_signing': const PropertyValue.boolean(false),
        'shell_access': const PropertyValue.boolean(false),
        'privilege_level': PropertyValue.string('none'),
      };

      if (_hostnameController.text.isNotEmpty) {
        properties['hostname'] = PropertyValue.string(_hostnameController.text);
      }

      if (_macAddressController.text.isNotEmpty) {
        properties['mac_address'] = PropertyValue.string(_macAddressController.text);
      }

      if (_osVersion.isNotEmpty) {
        properties['os_version'] = PropertyValue.string(_osVersion);
      }

      final host = Asset(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AssetType.host,
        projectId: '', // Will be set by calling code
        name: _nameController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        properties: properties,
        completedTriggers: [],
        triggerResults: {},
        parentAssetIds: [],
        childAssetIds: [],
        discoveredAt: DateTime.now(),
        tags: ['host', _osType],
        confidence: _confidence,
        discoveryMethod: 'manual',
      );

      Navigator.of(context).pop(host);
    }
  }
}