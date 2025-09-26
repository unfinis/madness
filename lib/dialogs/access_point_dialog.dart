import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/assets.dart';
import '../providers/asset_provider.dart';
import '../providers/projects_provider.dart';
import '../constants/app_spacing.dart';

class AccessPointDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? accessPointData;
  final Function(Map<String, dynamic>) onSave;

  const AccessPointDialog({
    super.key,
    this.accessPointData,
    required this.onSave,
  });

  @override
  ConsumerState<AccessPointDialog> createState() => _AccessPointDialogState();
}

class _AccessPointDialogState extends ConsumerState<AccessPointDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _credentialsController = TextEditingController();

  String _selectedAccessType = 'none';
  String? _selectedSourceAssetId;
  String? _selectedSourceNetworkId;
  String? _selectedCredentialId;
  bool _active = true;

  final Map<String, String> _accessDetails = {};

  static const _uuid = Uuid();

  final List<String> _accessTypes = [
    'none', 'external', 'adjacent', 'internal', 'pivoted', 'wireless', 'physical'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.accessPointData != null) {
      _loadExistingAccessPoint();
    } else {
      _setDefaults();
    }
  }

  void _loadExistingAccessPoint() {
    final data = widget.accessPointData!;
    _nameController.text = data['name'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _credentialsController.text = data['credentials'] ?? '';
    _selectedAccessType = data['accessType'] ?? 'none';
    _selectedSourceAssetId = data['sourceAssetId'];
    _selectedSourceNetworkId = data['sourceNetworkId'];
    _selectedCredentialId = data['credentials'];
    _active = data['active'] ?? true;

    final details = data['accessDetails'] as Map<String, dynamic>?;
    if (details != null) {
      _accessDetails.addAll(details.cast<String, String>());
    }
  }

  void _setDefaults() {
    _nameController.text = 'New Access Point';
    _selectedAccessType = 'external';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _credentialsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);
    if (currentProject == null) {
      return const AlertDialog(
        title: Text('Error'),
        content: Text('No project selected'),
      );
    }

    final assetsAsync = ref.watch(assetProvider(currentProject.id));

    return AlertDialog(
      title: Text(widget.accessPointData == null ? 'Add Access Point' : 'Edit Access Point'),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Access Point Name
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Access Point Name',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., VPN Connection, WiFi Access',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Access point name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Access Type
                DropdownButtonFormField<String>(
                  initialValue: _selectedAccessType,
                  decoration: const InputDecoration(
                    labelText: 'Access Type',
                    border: OutlineInputBorder(),
                  ),
                  items: _accessTypes.map((type) => DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getAccessTypeIcon(type), color: _getAccessTypeColor(type)),
                        const SizedBox(width: 8),
                        Text(_formatAccessType(type)),
                      ],
                    ),
                  )).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccessType = value!;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Asset Selection
                assetsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error loading assets: $error'),
                  data: (assets) {
                    final hostAssets = assets.where((asset) => asset.type == AssetType.host).toList();
                    final networkAssets = assets.where((asset) => asset.type == AssetType.networkSegment).toList();
                    final credentialAssets = assets.where((asset) => asset.type == AssetType.credential).toList();

                    return Column(
                      children: [
                        // Source Asset (Host/Device)
                        DropdownButtonFormField<String>(
                          initialValue: _selectedSourceAssetId,
                          decoration: const InputDecoration(
                            labelText: 'Source Host/Device (Optional)',
                            border: OutlineInputBorder(),
                            hintText: 'Host we\'re accessing from',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('No source host'),
                            ),
                            ...hostAssets.map((asset) => DropdownMenuItem(
                              value: asset.id,
                              child: Text('${asset.name} (${asset.getProperty<String>('ip_address') ?? 'No IP'})'),
                            )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSourceAssetId = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Source Network
                        DropdownButtonFormField<String>(
                          initialValue: _selectedSourceNetworkId,
                          decoration: const InputDecoration(
                            labelText: 'Source Network (Optional)',
                            border: OutlineInputBorder(),
                            hintText: 'Network we\'re coming from',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('No source network'),
                            ),
                            ...networkAssets.map((asset) => DropdownMenuItem(
                              value: asset.id,
                              child: Text('${asset.name} (${asset.getProperty<String>('subnet') ?? 'No subnet'})'),
                            )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSourceNetworkId = value;
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Credentials
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCredentialId,
                          decoration: const InputDecoration(
                            labelText: 'Credentials (Optional)',
                            border: OutlineInputBorder(),
                            hintText: 'Credentials used for access',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('No credentials'),
                            ),
                            ...credentialAssets.map((asset) => DropdownMenuItem(
                              value: asset.id,
                              child: Text('${asset.name} (${asset.getProperty<String>('username') ?? 'No username'})'),
                            )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedCredentialId = value;
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Description
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'How this access point works',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: AppSpacing.md),

                // Access Type Specific Fields
                if (_selectedAccessType != 'none') ...[
                  Text(
                    '${_formatAccessType(_selectedAccessType)} Specific Details',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _buildAccessTypeSpecificFields(),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Active Status
                SwitchListTile(
                  title: const Text('Access Point Active'),
                  subtitle: Text(
                    _active
                      ? 'This access point is currently available'
                      : 'This access point is inactive/unavailable',
                    style: TextStyle(
                      color: _active ? Colors.green : Colors.orange,
                    ),
                  ),
                  value: _active,
                  onChanged: (value) => setState(() => _active = value),
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
          onPressed: _saveAccessPoint,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildAccessTypeSpecificFields() {
    switch (_selectedAccessType) {
      case 'wireless':
        return Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'SSID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _accessDetails['ssid'] = value,
              controller: TextEditingController(text: _accessDetails['ssid']),
            ),
            const SizedBox(height: AppSpacing.sm),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Security Type',
                border: OutlineInputBorder(),
                hintText: 'WPA2, WPA3, Open, etc.',
              ),
              onChanged: (value) => _accessDetails['security_type'] = value,
              controller: TextEditingController(text: _accessDetails['security_type']),
            ),
          ],
        );

      case 'physical':
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Physical Location',
            border: OutlineInputBorder(),
            hintText: 'Server room, network closet, etc.',
          ),
          onChanged: (value) => _accessDetails['location'] = value,
          controller: TextEditingController(text: _accessDetails['location']),
        );

      case 'pivoted':
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'Pivot Method',
            border: OutlineInputBorder(),
            hintText: 'SSH tunnel, port forward, etc.',
          ),
          onChanged: (value) => _accessDetails['pivot_method'] = value,
          controller: TextEditingController(text: _accessDetails['pivot_method']),
        );

      case 'external':
        return TextFormField(
          decoration: const InputDecoration(
            labelText: 'External IP/Service',
            border: OutlineInputBorder(),
            hintText: 'VPN endpoint, exposed service, etc.',
          ),
          onChanged: (value) => _accessDetails['external_endpoint'] = value,
          controller: TextEditingController(text: _accessDetails['external_endpoint']),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _saveAccessPoint() {
    if (_formKey.currentState!.validate()) {
      final accessPointData = {
        'id': widget.accessPointData?['id'] ?? _uuid.v4(),
        'name': _nameController.text,
        'accessType': _selectedAccessType,
        'sourceAssetId': _selectedSourceAssetId,
        'sourceNetworkId': _selectedSourceNetworkId,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'active': _active,
        'credentials': _selectedCredentialId,
        'accessDetails': _accessDetails.isNotEmpty ? _accessDetails : null,
        'discoveredAt': widget.accessPointData?['discoveredAt'] ?? DateTime.now().toIso8601String(),
        'lastTested': DateTime.now().toIso8601String(),
      };

      widget.onSave(accessPointData);
      Navigator.of(context).pop();
    }
  }

  IconData _getAccessTypeIcon(String accessType) {
    switch (accessType) {
      case 'external': return Icons.public;
      case 'adjacent': return Icons.compare_arrows;
      case 'internal': return Icons.home;
      case 'pivoted': return Icons.route;
      case 'wireless': return Icons.wifi;
      case 'physical': return Icons.electrical_services;
      default: return Icons.help;
    }
  }

  Color _getAccessTypeColor(String accessType) {
    switch (accessType) {
      case 'external': return Colors.blue;
      case 'adjacent': return Colors.orange;
      case 'internal': return Colors.green;
      case 'pivoted': return Colors.purple;
      case 'wireless': return Colors.cyan;
      case 'physical': return Colors.brown;
      default: return Colors.grey;
    }
  }

  String _formatAccessType(String accessType) {
    switch (accessType) {
      case 'external': return 'External Access';
      case 'adjacent': return 'Adjacent Network';
      case 'internal': return 'Internal Network';
      case 'pivoted': return 'Pivoted Access';
      case 'wireless': return 'Wireless Access';
      case 'physical': return 'Physical Access';
      case 'none': return 'No Access';
      default: return accessType;
    }
  }
}