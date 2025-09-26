import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/assets.dart';
import '../providers/asset_provider.dart';
import '../providers/projects_provider.dart';
import '../constants/app_spacing.dart';

class NetworkHostDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic>? hostData;
  final Function(Map<String, dynamic>) onSave;

  const NetworkHostDialog({
    super.key,
    this.hostData,
    required this.onSave,
  });

  @override
  ConsumerState<NetworkHostDialog> createState() => _NetworkHostDialogState();
}

class _NetworkHostDialogState extends ConsumerState<NetworkHostDialog> {
  final _formKey = GlobalKey<FormState>();
  final _ipAddressController = TextEditingController();
  final _hostnameController = TextEditingController();
  final _macAddressController = TextEditingController();
  final _openPortsController = TextEditingController();

  String? _selectedHostAssetId;
  bool _isGateway = false;
  bool _isDhcpServer = false;
  bool _isDnsServer = false;
  bool _isCompromised = false;

  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.hostData != null) {
      _loadExistingHost();
    } else {
      _setDefaults();
    }
  }

  void _loadExistingHost() {
    final hostData = widget.hostData!;
    _selectedHostAssetId = hostData['hostAssetId'];
    _ipAddressController.text = hostData['ipAddress'] ?? '';
    _hostnameController.text = hostData['hostname'] ?? '';
    _macAddressController.text = hostData['macAddress'] ?? '';
    _isGateway = hostData['isGateway'] ?? false;
    _isDhcpServer = hostData['isDhcpServer'] ?? false;
    _isDnsServer = hostData['isDnsServer'] ?? false;
    _isCompromised = hostData['isCompromised'] ?? false;

    final openPorts = hostData['openPorts'] as List<dynamic>?;
    if (openPorts != null) {
      _openPortsController.text = openPorts.cast<String>().join(', ');
    }
  }

  void _setDefaults() {
    _ipAddressController.text = '192.168.1.';
    _hostnameController.text = '';
    _macAddressController.text = '';
  }

  @override
  void dispose() {
    _ipAddressController.dispose();
    _hostnameController.dispose();
    _macAddressController.dispose();
    _openPortsController.dispose();
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
      title: Text(widget.hostData == null ? 'Add Network Host' : 'Edit Network Host'),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Host Asset Selection
                assetsAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error loading assets: $error'),
                  data: (assets) {
                    final hostAssets = assets.where((asset) => asset.type == AssetType.host).toList();

                    return Column(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: _selectedHostAssetId,
                          decoration: const InputDecoration(
                            labelText: 'Link to Host Asset (Optional)',
                            border: OutlineInputBorder(),
                            hintText: 'Select existing host asset',
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: null,
                              child: Text('No linked asset'),
                            ),
                            ...hostAssets.map((asset) => DropdownMenuItem(
                              value: asset.id,
                              child: Text('${asset.name} (${asset.getProperty<String>('ip_address') ?? 'No IP'})'),
                            )),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedHostAssetId = value;
                              if (value != null) {
                                // Auto-populate fields from selected asset
                                final selectedAsset = hostAssets.firstWhere((a) => a.id == value);
                                _hostnameController.text = selectedAsset.name;
                                _ipAddressController.text = selectedAsset.getProperty<String>('ip_address') ?? '';
                                _macAddressController.text = selectedAsset.getProperty<String>('mac_address') ?? '';
                              }
                            });
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),

                        if (hostAssets.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue),
                                SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    'No host assets found. You can still create a network host reference, or create host assets first.',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // IP Address
                TextFormField(
                  controller: _ipAddressController,
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 192.168.1.100',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'IP address is required';
                    }
                    // Basic IP validation
                    final ipRegex = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                    if (!ipRegex.hasMatch(value)) {
                      return 'Please enter a valid IP address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                // Hostname
                TextFormField(
                  controller: _hostnameController,
                  decoration: const InputDecoration(
                    labelText: 'Hostname (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., DC01, WORKSTATION-01',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // MAC Address
                TextFormField(
                  controller: _macAddressController,
                  decoration: const InputDecoration(
                    labelText: 'MAC Address (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 00:11:22:33:44:55',
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Open Ports
                TextFormField(
                  controller: _openPortsController,
                  decoration: const InputDecoration(
                    labelText: 'Open Ports (Optional)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., 22, 80, 443, 3389',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Role Switches
                const Text(
                  'Host Roles',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),

                SwitchListTile(
                  title: const Text('Gateway'),
                  subtitle: const Text('This host is a network gateway/router'),
                  value: _isGateway,
                  onChanged: (value) => setState(() => _isGateway = value),
                ),

                SwitchListTile(
                  title: const Text('DHCP Server'),
                  subtitle: const Text('This host provides DHCP services'),
                  value: _isDhcpServer,
                  onChanged: (value) => setState(() => _isDhcpServer = value),
                ),

                SwitchListTile(
                  title: const Text('DNS Server'),
                  subtitle: const Text('This host provides DNS services'),
                  value: _isDnsServer,
                  onChanged: (value) => setState(() => _isDnsServer = value),
                ),

                const SizedBox(height: AppSpacing.md),

                // Security Status
                const Text(
                  'Security Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),

                SwitchListTile(
                  title: const Text('Compromised'),
                  subtitle: Text(
                    _isCompromised
                      ? 'This host has been compromised during testing'
                      : 'This host has not been compromised',
                    style: TextStyle(
                      color: _isCompromised ? Colors.red : Colors.green,
                    ),
                  ),
                  value: _isCompromised,
                  onChanged: (value) => setState(() => _isCompromised = value),
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
          onPressed: _saveHost,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveHost() {
    if (_formKey.currentState!.validate()) {
      final openPorts = _openPortsController.text.isNotEmpty
        ? _openPortsController.text.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList()
        : <String>[];

      final hostData = {
        'hostAssetId': _selectedHostAssetId ?? _uuid.v4(),
        'ipAddress': _ipAddressController.text,
        'hostname': _hostnameController.text.isEmpty ? null : _hostnameController.text,
        'macAddress': _macAddressController.text.isEmpty ? null : _macAddressController.text,
        'isGateway': _isGateway,
        'isDhcpServer': _isDhcpServer,
        'isDnsServer': _isDnsServer,
        'isCompromised': _isCompromised,
        'openPorts': openPorts,
        'lastSeen': DateTime.now().toIso8601String(),
      };

      widget.onSave(hostData);
      Navigator.of(context).pop();
    }
  }
}