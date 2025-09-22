import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../models/service_asset.dart';
import '../constants/app_spacing.dart';

class AddServiceDialog extends ConsumerStatefulWidget {
  final Asset? host; // Optional host to attach service to

  const AddServiceDialog({super.key, this.host});

  @override
  ConsumerState<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends ConsumerState<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _portController = TextEditingController();
  final _versionController = TextEditingController();
  final _bannerController = TextEditingController();
  final _descriptionController = TextEditingController();

  ServiceProtocol _protocol = ServiceProtocol.tcp;
  ServiceState _state = ServiceState.open;
  String _serviceName = 'unknown';
  bool _sslEnabled = false;
  bool _authRequired = true;
  double _confidence = 0.9;

  @override
  void dispose() {
    _portController.dispose();
    _versionController.dispose();
    _bannerController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.host != null
          ? 'Add Service to ${widget.host!.name}'
          : 'Add Service Asset'),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.host != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.computer, color: Colors.blue),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Host: ${widget.host!.name}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('IP: ${widget.host!.getProperty<String>('ip_address') ?? 'Unknown'}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _portController,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: 'e.g., 80, 443, 22',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter a port number';
                          }
                          final port = int.tryParse(value!);
                          if (port == null || port < 1 || port > 65535) {
                            return 'Please enter a valid port (1-65535)';
                          }
                          return null;
                        },
                        onChanged: _onPortChanged,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<ServiceProtocol>(
                        value: _protocol,
                        decoration: const InputDecoration(
                          labelText: 'Protocol',
                          border: OutlineInputBorder(),
                        ),
                        items: ServiceProtocol.values.map((protocol) {
                          return DropdownMenuItem(
                            value: protocol,
                            child: Text(protocol.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _protocol = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _serviceName,
                  decoration: const InputDecoration(
                    labelText: 'Service Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _getServiceNameOptions(),
                  onChanged: (value) {
                    setState(() {
                      _serviceName = value!;
                      _updateServiceDefaults();
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<ServiceState>(
                  value: _state,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                  items: ServiceState.values.map((state) {
                    return DropdownMenuItem(
                      value: state,
                      child: Row(
                        children: [
                          Icon(
                            _getStateIcon(state),
                            color: _getStateColor(state),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(state.name.toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _state = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _versionController,
                  decoration: const InputDecoration(
                    labelText: 'Version (Optional)',
                    hintText: 'e.g., Apache/2.4.41, OpenSSH_8.0',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _bannerController,
                  decoration: const InputDecoration(
                    labelText: 'Banner (Optional)',
                    hintText: 'Service banner information',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('SSL/TLS Enabled'),
                        value: _sslEnabled,
                        onChanged: (value) {
                          setState(() {
                            _sslEnabled = value ?? false;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Authentication Required'),
                        value: _authRequired,
                        onChanged: (value) {
                          setState(() {
                            _authRequired = value ?? true;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Additional information about this service',
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
                if (_serviceName != 'unknown') ...[
                  const SizedBox(height: AppSpacing.md),
                  _buildServiceInfo(),
                ],
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
          onPressed: _createService,
          child: const Text('Add Service'),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    final port = int.tryParse(_portController.text);
    if (port == null) return const SizedBox.shrink();

    final serviceInfo = ServiceDefinitions.getServiceByPort(port);
    if (serviceInfo == null) return const SizedBox.shrink();

    final category = serviceInfo['category'] as ServiceCategory?;
    final defaultCreds = serviceInfo['default_creds'] as List?;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                'Service Information',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (category != null)
            Text('Category: ${category.name.replaceAll('_', ' ').toUpperCase()}'),
          if (defaultCreds != null && defaultCreds.isNotEmpty)
            Text('Default Credentials: ${defaultCreds.length} available'),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> _getServiceNameOptions() {
    // Common service names
    const commonServices = [
      'unknown',
      'http',
      'https',
      'ssh',
      'ftp',
      'smtp',
      'smb',
      'mysql',
      'postgresql',
      'mssql',
      'oracle',
      'mongodb',
      'redis',
      'ldap',
      'dns',
      'snmp',
      'rdp',
      'vnc',
      'telnet',
      'pop3',
      'imap',
      'ntp',
      'dhcp',
    ];

    return commonServices.map((service) {
      return DropdownMenuItem(
        value: service,
        child: Text(service.toUpperCase()),
      );
    }).toList();
  }

  void _onPortChanged(String value) {
    final port = int.tryParse(value);
    if (port != null) {
      final serviceInfo = ServiceDefinitions.getServiceByPort(port);
      if (serviceInfo != null) {
        setState(() {
          _serviceName = serviceInfo['name'] ?? 'unknown';
          _sslEnabled = serviceInfo['ssl'] ?? false;
          _authRequired = serviceInfo['auth_required'] ?? true;
        });
      }
    }
  }

  void _updateServiceDefaults() {
    final port = int.tryParse(_portController.text);
    if (port != null) {
      final serviceInfo = ServiceDefinitions.getServiceByPort(port);
      if (serviceInfo != null) {
        setState(() {
          _sslEnabled = serviceInfo['ssl'] ?? false;
          _authRequired = serviceInfo['auth_required'] ?? true;
        });
      }
    }
  }

  IconData _getStateIcon(ServiceState state) {
    switch (state) {
      case ServiceState.open:
        return Icons.check_circle;
      case ServiceState.filtered:
        return Icons.warning;
      case ServiceState.closed:
        return Icons.cancel;
      case ServiceState.unknown:
        return Icons.help;
    }
  }

  Color _getStateColor(ServiceState state) {
    switch (state) {
      case ServiceState.open:
        return Colors.green;
      case ServiceState.filtered:
        return Colors.orange;
      case ServiceState.closed:
        return Colors.red;
      case ServiceState.unknown:
        return Colors.grey;
    }
  }

  void _createService() {
    if (_formKey.currentState?.validate() ?? false) {
      final port = int.parse(_portController.text);
      final serviceInfo = ServiceDefinitions.getServiceByPort(port);

      final properties = <String, PropertyValue>{
        'port': PropertyValue.integer(port),
        'protocol': PropertyValue.string(_protocol.name),
        'state': PropertyValue.string(_state.name),
        'service_name': PropertyValue.string(_serviceName),
        'ssl': PropertyValue.boolean(_sslEnabled),
        'auth_required': PropertyValue.boolean(_authRequired),
        'tested_credentials': const PropertyValue.stringList([]),
        'valid_credentials': const PropertyValue.stringList([]),
      };

      if (widget.host != null) {
        properties['host_id'] = PropertyValue.string(widget.host!.id);
      }

      if (_versionController.text.isNotEmpty) {
        properties['version'] = PropertyValue.string(_versionController.text);
      }

      if (_bannerController.text.isNotEmpty) {
        properties['banner'] = PropertyValue.string(_bannerController.text);
      }

      if (serviceInfo?['category'] != null) {
        properties['category'] = PropertyValue.string(
          (serviceInfo!['category'] as ServiceCategory).name
        );
      }

      final service = Asset(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AssetType.service,
        projectId: '', // Will be set by calling code
        name: '$_serviceName on port $port',
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text :
                    '${_protocol.name.toUpperCase()} service on port $port',
        properties: properties,
        completedTriggers: [],
        triggerResults: {},
        parentAssetIds: widget.host != null ? [widget.host!.id] : [],
        childAssetIds: [],
        discoveredAt: DateTime.now(),
        tags: [
          'service',
          'port:$port',
          _protocol.name,
          _serviceName,
        ],
        confidence: _confidence,
        discoveryMethod: 'manual',
      );

      Navigator.of(context).pop(service);
    }
  }
}