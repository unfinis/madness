import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../constants/app_spacing.dart';

class AddNetworkSegmentDialog extends ConsumerStatefulWidget {
  const AddNetworkSegmentDialog({super.key});

  @override
  ConsumerState<AddNetworkSegmentDialog> createState() => _AddNetworkSegmentDialogState();
}

class _AddNetworkSegmentDialogState extends ConsumerState<AddNetworkSegmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _subnetController = TextEditingController();
  final _gatewayController = TextEditingController();
  final _domainNameController = TextEditingController();
  final _vlanIdController = TextEditingController();
  final _descriptionController = TextEditingController();

  AccessLevel _accessLevel = AccessLevel.blocked;
  bool _nacEnabled = false;
  String _nacType = 'none';
  bool _firewallPresent = false;
  bool _ipsIdsPresent = false;
  double _confidence = 0.9;

  final List<String> _dnsServers = [];
  final _dnsController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _subnetController.dispose();
    _gatewayController.dispose();
    _domainNameController.dispose();
    _vlanIdController.dispose();
    _descriptionController.dispose();
    _dnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Network Segment'),
      content: SizedBox(
        width: 600,
        height: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Network Name',
                    hintText: 'e.g., DMZ Network, Internal LAN',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a network name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _subnetController,
                  decoration: const InputDecoration(
                    labelText: 'Subnet/CIDR',
                    hintText: 'e.g., 192.168.1.0/24, 10.0.0.0/16',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Please enter a subnet';
                    }
                    // Basic CIDR validation
                    final cidrRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}\/\d{1,2}$');
                    if (!cidrRegex.hasMatch(value!)) {
                      return 'Please enter a valid CIDR notation (e.g., 192.168.1.0/24)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _gatewayController,
                  decoration: const InputDecoration(
                    labelText: 'Gateway IP (Optional)',
                    hintText: 'e.g., 192.168.1.1',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _domainNameController,
                  decoration: const InputDecoration(
                    labelText: 'Domain Name (Optional)',
                    hintText: 'e.g., corp.local, company.com',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _vlanIdController,
                        decoration: const InputDecoration(
                          labelText: 'VLAN ID (Optional)',
                          hintText: 'e.g., 100',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<AccessLevel>(
                        value: _accessLevel,
                        decoration: const InputDecoration(
                          labelText: 'Access Level',
                          border: OutlineInputBorder(),
                        ),
                        items: AccessLevel.values.map((level) {
                          return DropdownMenuItem(
                            value: level,
                            child: Row(
                              children: [
                                Icon(
                                  _getAccessLevelIcon(level),
                                  color: _getAccessLevelColor(level),
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(level.name.toUpperCase()),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _accessLevel = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Security Controls',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                CheckboxListTile(
                  title: const Text('Network Access Control (NAC) Enabled'),
                  value: _nacEnabled,
                  onChanged: (value) {
                    setState(() {
                      _nacEnabled = value ?? false;
                      if (!_nacEnabled) {
                        _nacType = 'none';
                      }
                    });
                  },
                  dense: true,
                ),
                if (_nacEnabled) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.lg),
                    child: DropdownButtonFormField<String>(
                      value: _nacType,
                      decoration: const InputDecoration(
                        labelText: 'NAC Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'none', child: Text('None')),
                        DropdownMenuItem(value: '802.1x', child: Text('802.1X')),
                        DropdownMenuItem(value: 'mac_auth', child: Text('MAC Authentication')),
                        DropdownMenuItem(value: 'web_auth', child: Text('Web Authentication')),
                        DropdownMenuItem(value: 'captive_portal', child: Text('Captive Portal')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _nacType = value!;
                        });
                      },
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                CheckboxListTile(
                  title: const Text('Firewall Present'),
                  value: _firewallPresent,
                  onChanged: (value) {
                    setState(() {
                      _firewallPresent = value ?? false;
                    });
                  },
                  dense: true,
                ),
                CheckboxListTile(
                  title: const Text('IPS/IDS Present'),
                  value: _ipsIdsPresent,
                  onChanged: (value) {
                    setState(() {
                      _ipsIdsPresent = value ?? false;
                    });
                  },
                  dense: true,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'DNS Servers',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _dnsController,
                        decoration: const InputDecoration(
                          labelText: 'DNS Server IP',
                          hintText: 'e.g., 8.8.8.8',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: _addDnsServer,
                      child: const Text('Add'),
                    ),
                  ],
                ),
                if (_dnsServers.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: _dnsServers.map((dns) => Chip(
                      label: Text(dns),
                      onDeleted: () {
                        setState(() {
                          _dnsServers.remove(dns);
                        });
                      },
                    )).toList(),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Additional information about this network segment',
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
          onPressed: _createNetworkSegment,
          child: const Text('Add Network'),
        ),
      ],
    );
  }

  void _addDnsServer() {
    final dns = _dnsController.text.trim();
    if (dns.isNotEmpty && !_dnsServers.contains(dns)) {
      // Basic IP validation
      final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
      if (ipRegex.hasMatch(dns)) {
        setState(() {
          _dnsServers.add(dns);
          _dnsController.clear();
        });
      }
    }
  }

  IconData _getAccessLevelIcon(AccessLevel level) {
    switch (level) {
      case AccessLevel.full:
        return Icons.check_circle;
      case AccessLevel.partial:
        return Icons.warning;
      case AccessLevel.limited:
        return Icons.info;
      case AccessLevel.blocked:
        return Icons.block;
    }
  }

  Color _getAccessLevelColor(AccessLevel level) {
    switch (level) {
      case AccessLevel.full:
        return Colors.green;
      case AccessLevel.partial:
        return Colors.orange;
      case AccessLevel.limited:
        return Colors.amber;
      case AccessLevel.blocked:
        return Colors.red;
    }
  }

  void _createNetworkSegment() {
    if (_formKey.currentState?.validate() ?? false) {
      final properties = <String, PropertyValue>{
        'subnet': PropertyValue.string(_subnetController.text),
        'access_level': PropertyValue.string(_accessLevel.name),
        'nac_enabled': PropertyValue.boolean(_nacEnabled),
        'firewall_present': PropertyValue.boolean(_firewallPresent),
        'ips_ids_present': PropertyValue.boolean(_ipsIdsPresent),
        'live_hosts': const PropertyValue.stringList([]),
        'web_services': const PropertyValue.objectList([]),
        'smb_hosts': const PropertyValue.stringList([]),
        'credentials_available': const PropertyValue.objectList([]),
        'bypass_methods_attempted': const PropertyValue.stringList([]),
        'dns_servers': PropertyValue.stringList(_dnsServers),
      };

      if (_gatewayController.text.isNotEmpty) {
        properties['gateway'] = PropertyValue.string(_gatewayController.text);
      }

      if (_domainNameController.text.isNotEmpty) {
        properties['domain_name'] = PropertyValue.string(_domainNameController.text);
      }

      if (_vlanIdController.text.isNotEmpty) {
        final vlanId = int.tryParse(_vlanIdController.text);
        if (vlanId != null) {
          properties['vlan_id'] = PropertyValue.integer(vlanId);
        }
      }

      if (_nacEnabled) {
        properties['nac_type'] = PropertyValue.string(_nacType);
      }

      final networkSegment = Asset(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: AssetType.networkSegment,
        projectId: '', // Will be set by calling code
        name: _nameController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        properties: properties,
        completedTriggers: [],
        triggerResults: {},
        parentAssetIds: [],
        childAssetIds: [],
        discoveredAt: DateTime.now(),
        tags: [
          'network',
          'segment',
          _accessLevel.name,
          if (_nacEnabled) 'nac',
          if (_firewallPresent) 'firewall',
        ],
        confidence: _confidence,
        discoveryMethod: 'manual',
      );

      Navigator.of(context).pop(networkSegment);
    }
  }
}