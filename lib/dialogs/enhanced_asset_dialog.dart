import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../constants/app_spacing.dart';

enum AssetDialogMode { create, edit, view }

class EnhancedAssetDialog extends ConsumerStatefulWidget {
  final Asset? asset;
  final String projectId;
  final AssetDialogMode mode;
  final AssetType? initialType;

  const EnhancedAssetDialog({
    super.key,
    this.asset,
    required this.projectId,
    required this.mode,
    this.initialType,
  });

  @override
  ConsumerState<EnhancedAssetDialog> createState() => _EnhancedAssetDialogState();
}

class _EnhancedAssetDialogState extends ConsumerState<EnhancedAssetDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();
  bool _isLoading = false;

  // Basic asset fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  AssetType? _selectedAssetType;
  List<String> _tags = [];

  // Network Segment fields
  final _subnetController = TextEditingController();
  final _gatewayController = TextEditingController();
  final _networkRangeController = TextEditingController();
  final _dnsServersController = TextEditingController();

  // NAC Configuration
  String _nacEnabled = ''; // '', 'enabled', 'disabled'
  String _nacType = '';
  String _accessLevel = 'blocked';
  String _physicalAccess = ''; // '', 'enabled', 'disabled'
  String _authenticatedDevicePresent = ''; // '', 'enabled', 'disabled'
  String _vlanSegmentation = ''; // '', 'enabled', 'disabled'
  String _macsecEnabled = ''; // '', 'enabled', 'disabled'
  String _multipleMacsAllowed = ''; // '', 'enabled', 'disabled'
  String _portSecurityEnabled = ''; // '', 'enabled', 'disabled'

  // Host fields
  final _ipAddressController = TextEditingController();
  final _hostnameController = TextEditingController();
  String _osType = '';
  String _privilegeLevel = 'none';

  // Service fields
  final _hostController = TextEditingController();
  int _port = 80;
  String _protocol = 'tcp';
  final _serviceNameController = TextEditingController();
  final _versionController = TextEditingController();
  String _sslEnabled = ''; // '', 'enabled', 'disabled'

  // Credential fields
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _hashController = TextEditingController();
  final _domainController = TextEditingController();
  final _sourceController = TextEditingController();

  // Lists for dynamic content
  final List<String> _openPorts = [];
  final List<String> _authorizedMacs = [];
  final List<String> _dnsServersList = [];
  final List<String> _confirmedHosts = [];

  @override
  void initState() {
    super.initState();
    _selectedAssetType = widget.initialType ?? widget.asset?.type ?? AssetType.host;
    _tabController = TabController(
      length: _getTabCount(),
      vsync: this,
    );

    if (widget.asset != null) {
      _loadAssetData();
    }
  }

  int _getTabCount() {
    switch (_selectedAssetType!) {
      case AssetType.networkSegment:
        return 4; // Overview, Network Config, NAC Security, Discovery
      case AssetType.host:
        return 3; // Overview, System Info, Services
      case AssetType.service:
        return 2; // Overview, Service Config
      case AssetType.credential:
        return 3; // Overview, Authentication, Usage
      case AssetType.vulnerability:
        return 3; // Overview, Technical Details, Impact
      case AssetType.domain:
        return 3; // Overview, Structure, Users & Computers
      case AssetType.wireless_network:
        return 3; // Overview, Wireless Config, Security
    }
  }

  List<Tab> _getTabs() {
    switch (_selectedAssetType!) {
      case AssetType.networkSegment:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.router), text: 'Network'),
          Tab(icon: Icon(Icons.security), text: 'NAC Security'),
          Tab(icon: Icon(Icons.search), text: 'Discovery'),
        ];
      case AssetType.host:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.computer), text: 'System'),
          Tab(icon: Icon(Icons.list), text: 'Services'),
        ];
      case AssetType.service:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.web), text: 'Service'),
        ];
      case AssetType.credential:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.key), text: 'Auth'),
          Tab(icon: Icon(Icons.verified_user), text: 'Usage'),
        ];
      case AssetType.vulnerability:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.bug_report), text: 'Technical'),
          Tab(icon: Icon(Icons.warning), text: 'Impact'),
        ];
      case AssetType.domain:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.account_tree), text: 'Structure'),
          Tab(icon: Icon(Icons.people), text: 'Users'),
        ];
      case AssetType.wireless_network:
        return const [
          Tab(icon: Icon(Icons.info), text: 'Overview'),
          Tab(icon: Icon(Icons.wifi), text: 'Wireless'),
          Tab(icon: Icon(Icons.shield), text: 'Security'),
        ];
    }
  }

  void _loadAssetData() {
    final asset = widget.asset!;
    _nameController.text = asset.name;
    _descriptionController.text = asset.description ?? '';
    _tags = asset.tags.toList();

    // Load properties based on asset type
    switch (asset.type) {
      case AssetType.networkSegment:
        _loadNetworkSegmentData(asset);
        break;
      case AssetType.host:
        _loadHostData(asset);
        break;
      case AssetType.service:
        _loadServiceData(asset);
        break;
      case AssetType.credential:
        _loadCredentialData(asset);
        break;
      default:
        break;
    }
  }

  void _loadNetworkSegmentData(Asset asset) {
    _subnetController.text = _getStringProperty(asset, 'subnet');
    _gatewayController.text = _getStringProperty(asset, 'gateway');
    _networkRangeController.text = _getStringProperty(asset, 'network_range');
    _nacEnabled = _getTriStateProperty(asset, 'nac_enabled');
    _nacType = _getStringProperty(asset, 'nac_type');
    _accessLevel = _getStringProperty(asset, 'access_level');
    _physicalAccess = _getTriStateProperty(asset, 'physical_access');
    _authenticatedDevicePresent = _getTriStateProperty(asset, 'authenticated_device_present');
    _vlanSegmentation = _getTriStateProperty(asset, 'vlan_segmentation');
    _macsecEnabled = _getTriStateProperty(asset, 'macsec_enabled');
    _multipleMacsAllowed = _getTriStateProperty(asset, 'multiple_macs_allowed');
    _portSecurityEnabled = _getTriStateProperty(asset, 'port_security_enabled');
  }

  void _loadHostData(Asset asset) {
    _ipAddressController.text = _getStringProperty(asset, 'ip_address');
    _hostnameController.text = _getStringProperty(asset, 'hostname');
    _osType = _getStringProperty(asset, 'os_type');
    _privilegeLevel = _getStringProperty(asset, 'privilege_level');
  }

  void _loadServiceData(Asset asset) {
    _hostController.text = _getStringProperty(asset, 'host');
    _port = _getIntProperty(asset, 'port');
    _protocol = _getStringProperty(asset, 'protocol');
    _serviceNameController.text = _getStringProperty(asset, 'service_name');
    _versionController.text = _getStringProperty(asset, 'version');
    _sslEnabled = _getTriStateProperty(asset, 'ssl_enabled');
  }

  void _loadCredentialData(Asset asset) {
    _usernameController.text = _getStringProperty(asset, 'username');
    _passwordController.text = _getStringProperty(asset, 'password');
    _hashController.text = _getStringProperty(asset, 'hash');
    _domainController.text = _getStringProperty(asset, 'domain');
    _sourceController.text = _getStringProperty(asset, 'source');
  }

  String _getStringProperty(Asset asset, String key) {
    final prop = asset.properties[key];
    return prop?.when(
      string: (value) => value,
      integer: (value) => value.toString(),
      boolean: (value) => value.toString(),
      stringList: (values) => values.join(', '),
      map: (value) => value.toString(),
      objectList: (objects) => objects.toString(),
    ) ?? '';
  }

  int _getIntProperty(Asset asset, String key) {
    final prop = asset.properties[key];
    return prop?.when(
      string: (value) => int.tryParse(value) ?? 0,
      integer: (value) => value,
      boolean: (value) => value ? 1 : 0,
      stringList: (values) => values.length,
      map: (value) => value.length,
      objectList: (objects) => objects.length,
    ) ?? 0;
  }

  String _getTriStateProperty(Asset asset, String key) {
    final prop = asset.properties[key];
    return prop?.when(
      string: (value) {
        if (value.isEmpty) return '';
        if (value.toLowerCase() == 'true' || value.toLowerCase() == 'enabled') return 'enabled';
        if (value.toLowerCase() == 'false' || value.toLowerCase() == 'disabled') return 'disabled';
        return '';
      },
      boolean: (value) => value ? 'enabled' : 'disabled',
      integer: (value) => value != 0 ? 'enabled' : 'disabled',
      stringList: (values) => values.isNotEmpty ? 'enabled' : 'disabled',
      map: (value) => value.isNotEmpty ? 'enabled' : 'disabled',
      objectList: (objects) => objects.isNotEmpty ? 'enabled' : 'disabled',
    ) ?? '';
  }

  Widget _buildTriStateDropdown({
    required String label,
    required String value,
    required Function(String?) onChanged,
    String? subtitle,
    bool isViewMode = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitle != null) ...[
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            labelText: subtitle == null ? label : null,
            border: const OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: null, child: Text('❓ Unknown')),
            DropdownMenuItem(value: 'enabled', child: Text('✅ Enabled')),
            DropdownMenuItem(value: 'disabled', child: Text('❌ Disabled')),
          ],
          onChanged: isViewMode ? null : onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isViewMode = widget.mode == AssetDialogMode.view;
    final isCreateMode = widget.mode == AssetDialogMode.create;

    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getAssetTypeIcon(_selectedAssetType!),
                    size: 32,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCreateMode ? 'Create ${_getAssetTypeName(_selectedAssetType!)}'
                                      : isViewMode ? '${_getAssetTypeName(_selectedAssetType!)} Details'
                                                  : 'Edit ${_getAssetTypeName(_selectedAssetType!)}',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          _nameController.text.isNotEmpty ? _nameController.text : 'New Asset',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isViewMode && _isLoading)
                    const CircularProgressIndicator()
                  else if (!isViewMode)
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        ElevatedButton(
                          onPressed: _saveAsset,
                          child: Text(isCreateMode ? 'Create' : 'Save'),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: _getTabs(),
              isScrollable: true,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _getTabViews(isViewMode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getTabViews(bool isViewMode) {
    switch (_selectedAssetType!) {
      case AssetType.networkSegment:
        return [
          _buildOverviewTab(isViewMode),
          _buildNetworkConfigTab(isViewMode),
          _buildNacSecurityTab(isViewMode),
          _buildDiscoveryTab(isViewMode),
        ];
      case AssetType.host:
        return [
          _buildOverviewTab(isViewMode),
          _buildHostSystemTab(isViewMode),
          _buildHostServicesTab(isViewMode),
        ];
      case AssetType.service:
        return [
          _buildOverviewTab(isViewMode),
          _buildServiceConfigTab(isViewMode),
        ];
      case AssetType.credential:
        return [
          _buildOverviewTab(isViewMode),
          _buildCredentialAuthTab(isViewMode),
          _buildCredentialUsageTab(isViewMode),
        ];
      default:
        return [
          _buildOverviewTab(isViewMode),
          _buildGenericPropertiesTab(isViewMode),
        ];
    }
  }

  Widget _buildOverviewTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                'Basic Information',
                [
                  if (widget.mode == AssetDialogMode.create)
                    DropdownButtonFormField<AssetType>(
                      value: _selectedAssetType,
                      decoration: const InputDecoration(
                        labelText: 'Asset Type',
                        border: OutlineInputBorder(),
                      ),
                      items: AssetType.values.map((type) => DropdownMenuItem(
                        value: type,
                        child: Row(
                          children: [
                            Icon(_getAssetTypeIcon(type)),
                            const SizedBox(width: 8),
                            Text(_getAssetTypeName(type)),
                          ],
                        ),
                      )).toList(),
                      onChanged: isViewMode ? null : (AssetType? value) {
                        if (value != null && value != _selectedAssetType) {
                          setState(() {
                            _selectedAssetType = value;
                            _tabController.dispose();
                            _tabController = TabController(
                              length: _getTabCount(),
                              vsync: this,
                            );
                          });
                        }
                      },
                      validator: (value) => value == null ? 'Please select an asset type' : null,
                    ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter a descriptive name',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: isViewMode,
                    validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      hintText: 'Optional description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    readOnly: isViewMode,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              _buildCard(
                'Tags',
                [
                  _buildTagsWidget(isViewMode),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTagsWidget(bool isViewMode) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ..._tags.map((tag) => Chip(
          label: Text(tag),
          onDeleted: isViewMode ? null : () {
            setState(() {
              _tags.remove(tag);
            });
          },
        )),
        if (!isViewMode)
          ActionChip(
            label: const Text('Add Tag'),
            onPressed: _showAddTagDialog,
            avatar: const Icon(Icons.add),
          ),
      ],
    );
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tag name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty && !_tags.contains(controller.text)) {
                setState(() {
                  _tags.add(controller.text);
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Network Segment specific tabs
  Widget _buildNetworkConfigTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Network Configuration',
              [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _subnetController,
                        decoration: const InputDecoration(
                          labelText: 'Subnet/CIDR',
                          hintText: '192.168.1.0/24',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _gatewayController,
                        decoration: const InputDecoration(
                          labelText: 'Gateway',
                          hintText: '192.168.1.1',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _networkRangeController,
                  decoration: const InputDecoration(
                    labelText: 'Network Range',
                    hintText: '192.168.1.1-192.168.1.254',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _dnsServersController,
                  decoration: const InputDecoration(
                    labelText: 'DNS Servers',
                    hintText: '8.8.8.8, 1.1.1.1',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNacSecurityTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'NAC Configuration',
              [
                _buildTriStateDropdown(
                  label: 'NAC Enabled',
                  subtitle: 'Network Access Control is active',
                  value: _nacEnabled,
                  onChanged: (value) {
                    setState(() {
                      _nacEnabled = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
                if (_nacEnabled == 'enabled') ...[
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _nacType.isEmpty ? null : _nacType,
                    decoration: const InputDecoration(
                      labelText: 'NAC Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: '802.1x', child: Text('802.1X Authentication')),
                      DropdownMenuItem(value: 'web_auth', child: Text('Web Authentication')),
                      DropdownMenuItem(value: 'mac_auth', child: Text('MAC Authentication')),
                    ],
                    onChanged: isViewMode ? null : (value) {
                      setState(() {
                        _nacType = value ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    value: _accessLevel,
                    decoration: const InputDecoration(
                      labelText: 'Access Level',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'blocked', child: Text('🚫 Blocked')),
                      DropdownMenuItem(value: 'limited', child: Text('⚠️ Limited/Quarantine')),
                      DropdownMenuItem(value: 'partial', child: Text('🔶 Partial Access')),
                      DropdownMenuItem(value: 'full', child: Text('✅ Full Access')),
                    ],
                    onChanged: isViewMode ? null : (value) {
                      setState(() {
                        _accessLevel = value ?? 'blocked';
                      });
                    },
                  ),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            _buildCard(
              'Physical Access',
              [
                _buildTriStateDropdown(
                  label: 'Physical Access Available',
                  subtitle: 'Can physically access network ports',
                  value: _physicalAccess,
                  onChanged: (value) {
                    setState(() {
                      _physicalAccess = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTriStateDropdown(
                  label: 'Authenticated Device Present',
                  subtitle: 'Have access to already authenticated device',
                  value: _authenticatedDevicePresent,
                  onChanged: (value) {
                    setState(() {
                      _authenticatedDevicePresent = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.lg),

            _buildCard(
              'Security Features',
              [
                _buildTriStateDropdown(
                  label: 'VLAN Segmentation',
                  subtitle: 'Network uses VLAN separation',
                  value: _vlanSegmentation,
                  onChanged: (value) {
                    setState(() {
                      _vlanSegmentation = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTriStateDropdown(
                  label: 'MACsec Enabled',
                  subtitle: 'MAC Security encryption active',
                  value: _macsecEnabled,
                  onChanged: (value) {
                    setState(() {
                      _macsecEnabled = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTriStateDropdown(
                  label: 'Multiple MACs Allowed',
                  subtitle: 'Port allows multiple MAC addresses',
                  value: _multipleMacsAllowed,
                  onChanged: (value) {
                    setState(() {
                      _multipleMacsAllowed = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTriStateDropdown(
                  label: 'Port Security Enabled',
                  subtitle: 'Switch port security is active',
                  value: _portSecurityEnabled,
                  onChanged: (value) {
                    setState(() {
                      _portSecurityEnabled = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Discovered Assets',
              [
                const Text('This tab will show discovered hosts, services, and other assets on this network segment.'),
                const SizedBox(height: AppSpacing.md),
                const Text('• Live Hosts'),
                const Text('• Authorized MAC Addresses'),
                const Text('• VLANs'),
                const Text('• Credentials'),
                const Text('• Web Services'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Host specific tabs
  Widget _buildHostSystemTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'System Information',
              [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _ipAddressController,
                        decoration: const InputDecoration(
                          labelText: 'IP Address',
                          hintText: '192.168.1.100',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _hostnameController,
                        decoration: const InputDecoration(
                          labelText: 'Hostname',
                          hintText: 'workstation-01',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _osType.isEmpty ? null : _osType,
                        decoration: const InputDecoration(
                          labelText: 'Operating System',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'windows', child: Text('🪟 Windows')),
                          DropdownMenuItem(value: 'linux', child: Text('🐧 Linux')),
                          DropdownMenuItem(value: 'macos', child: Text('🍎 macOS')),
                          DropdownMenuItem(value: 'unix', child: Text('Unix')),
                          DropdownMenuItem(value: 'other', child: Text('Other')),
                        ],
                        onChanged: isViewMode ? null : (value) {
                          setState(() {
                            _osType = value ?? '';
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _privilegeLevel,
                        decoration: const InputDecoration(
                          labelText: 'Access Level',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'none', child: Text('🚫 No Access')),
                          DropdownMenuItem(value: 'user', child: Text('👤 User Level')),
                          DropdownMenuItem(value: 'admin', child: Text('👑 Administrator')),
                          DropdownMenuItem(value: 'system', child: Text('⚙️ System Level')),
                        ],
                        onChanged: isViewMode ? null : (value) {
                          setState(() {
                            _privilegeLevel = value ?? 'none';
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHostServicesTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Open Ports & Services',
              [
                const Text('This tab will show open ports and running services on this host.'),
                const SizedBox(height: AppSpacing.md),
                const Text('• Port scan results'),
                const Text('• Service enumeration'),
                const Text('• Version detection'),
                const Text('• Vulnerability assessment'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Service specific tabs
  Widget _buildServiceConfigTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Service Configuration',
              [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _hostController,
                        decoration: const InputDecoration(
                          labelText: 'Host',
                          hintText: '192.168.1.100',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        initialValue: _port.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                        onChanged: (value) {
                          _port = int.tryParse(value) ?? 80;
                        },
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _protocol,
                        decoration: const InputDecoration(
                          labelText: 'Protocol',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'tcp', child: Text('TCP')),
                          DropdownMenuItem(value: 'udp', child: Text('UDP')),
                        ],
                        onChanged: isViewMode ? null : (value) {
                          setState(() {
                            _protocol = value ?? 'tcp';
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _serviceNameController,
                        decoration: const InputDecoration(
                          labelText: 'Service Name',
                          hintText: 'HTTP, SSH, FTP, etc.',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _versionController,
                        decoration: const InputDecoration(
                          labelText: 'Version',
                          hintText: 'Apache 2.4.41',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTriStateDropdown(
                  label: 'SSL/TLS Enabled',
                  subtitle: 'Service uses encrypted connection',
                  value: _sslEnabled,
                  onChanged: (value) {
                    setState(() {
                      _sslEnabled = value ?? '';
                    });
                  },
                  isViewMode: isViewMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Credential specific tabs
  Widget _buildCredentialAuthTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Authentication Details',
              [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: !isViewMode,
                  readOnly: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _hashController,
                  decoration: const InputDecoration(
                    labelText: 'Hash',
                    hintText: 'NTLM, SHA, etc.',
                    border: OutlineInputBorder(),
                  ),
                  readOnly: isViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _domainController,
                        decoration: const InputDecoration(
                          labelText: 'Domain',
                          hintText: 'CORP, WORKGROUP',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: TextFormField(
                        controller: _sourceController,
                        decoration: const InputDecoration(
                          labelText: 'Source',
                          hintText: 'Password spray, OSINT, etc.',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: isViewMode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCredentialUsageTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Usage & Validation',
              [
                const Text('This tab will show where these credentials have been tested and confirmed.'),
                const SizedBox(height: AppSpacing.md),
                const Text('• Confirmed hosts'),
                const Text('• Validation status'),
                const Text('• Last tested'),
                const Text('• Privilege level'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenericPropertiesTab(bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildCard(
              'Additional Properties',
              [
                const Text('Asset-specific properties will be shown here.'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return Icons.router;
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.web;
      case AssetType.credential:
        return Icons.key;
      case AssetType.vulnerability:
        return Icons.security;
      case AssetType.domain:
        return Icons.domain;
      case AssetType.wireless_network:
        return Icons.wifi;
    }
  }

  String _getAssetTypeName(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return 'Network Segment';
      case AssetType.host:
        return 'Host';
      case AssetType.service:
        return 'Service';
      case AssetType.credential:
        return 'Credential';
      case AssetType.vulnerability:
        return 'Vulnerability';
      case AssetType.domain:
        return 'Domain';
      case AssetType.wireless_network:
        return 'Wireless Network';
    }
  }

  Map<String, PropertyValue> _buildProperties() {
    final properties = <String, PropertyValue>{};

    switch (_selectedAssetType!) {
      case AssetType.networkSegment:
        properties.addAll({
          'subnet': PropertyValue.string(_subnetController.text),
          'gateway': PropertyValue.string(_gatewayController.text),
          'network_range': PropertyValue.string(_networkRangeController.text),
          'dns_servers': PropertyValue.stringList(_dnsServersList),
          'nac_enabled': PropertyValue.string(_nacEnabled),
          'nac_type': PropertyValue.string(_nacType),
          'access_level': PropertyValue.string(_accessLevel),
          'physical_access': PropertyValue.string(_physicalAccess),
          'authenticated_device_present': PropertyValue.string(_authenticatedDevicePresent),
          'vlan_segmentation': PropertyValue.string(_vlanSegmentation),
          'macsec_enabled': PropertyValue.string(_macsecEnabled),
          'multiple_macs_allowed': PropertyValue.string(_multipleMacsAllowed),
          'port_security_enabled': PropertyValue.string(_portSecurityEnabled),
          'authorized_macs_discovered': PropertyValue.stringList(_authorizedMacs),
          'vlans_discovered': const PropertyValue.objectList([]),
          'credentials_available': const PropertyValue.objectList([]),
          'live_hosts': const PropertyValue.stringList([]),
          'web_services': const PropertyValue.objectList([]),
          'bypass_methods_attempted': const PropertyValue.stringList([]),
          'bypass_methods_successful': const PropertyValue.stringList([]),
          'nac_bypassed': const PropertyValue.boolean(false),
          'internal_subnet_discovered': const PropertyValue.string(''),
        });
        break;
      case AssetType.host:
        properties.addAll({
          'ip_address': PropertyValue.string(_ipAddressController.text),
          'hostname': PropertyValue.string(_hostnameController.text),
          'os_type': PropertyValue.string(_osType),
          'privilege_level': PropertyValue.string(_privilegeLevel),
          'open_ports': PropertyValue.stringList(_openPorts),
          'services': const PropertyValue.objectList([]),
        });
        break;
      case AssetType.service:
        properties.addAll({
          'host': PropertyValue.string(_hostController.text),
          'port': PropertyValue.integer(_port),
          'protocol': PropertyValue.string(_protocol),
          'service_name': PropertyValue.string(_serviceNameController.text),
          'version': PropertyValue.string(_versionController.text),
          'ssl_enabled': PropertyValue.string(_sslEnabled),
        });
        break;
      case AssetType.credential:
        properties.addAll({
          'username': PropertyValue.string(_usernameController.text),
          'password': PropertyValue.string(_passwordController.text),
          'hash': PropertyValue.string(_hashController.text),
          'domain': PropertyValue.string(_domainController.text),
          'source': PropertyValue.string(_sourceController.text),
          'confirmed_hosts': PropertyValue.stringList(_confirmedHosts),
        });
        break;
      default:
        break;
    }

    return properties;
  }

  Future<void> _saveAsset() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final asset = Asset(
        id: widget.asset?.id ?? _uuid.v4(),
        projectId: widget.projectId,
        name: _nameController.text,
        type: _selectedAssetType!,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        properties: _buildProperties(),
        tags: _tags,
        completedTriggers: widget.asset?.completedTriggers ?? [],
        triggerResults: widget.asset?.triggerResults ?? {},
        parentAssetIds: widget.asset?.parentAssetIds ?? [],
        childAssetIds: widget.asset?.childAssetIds ?? [],
        discoveredAt: widget.asset?.discoveredAt ?? DateTime.now(),
        lastUpdated: DateTime.now(),
      );

      if (widget.mode == AssetDialogMode.create) {
        await ref.read(assetServiceProvider(widget.projectId)).createAsset(asset);
      } else {
        await ref.read(assetServiceProvider(widget.projectId)).updateAsset(asset);
      }

      if (mounted) {
        Navigator.of(context).pop(asset);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving asset: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _subnetController.dispose();
    _gatewayController.dispose();
    _networkRangeController.dispose();
    _dnsServersController.dispose();
    _ipAddressController.dispose();
    _hostnameController.dispose();
    _hostController.dispose();
    _serviceNameController.dispose();
    _versionController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _hashController.dispose();
    _domainController.dispose();
    _sourceController.dispose();
    super.dispose();
  }
}