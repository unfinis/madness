import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../constants/app_spacing.dart';

class NacAssessmentWizardDialog extends ConsumerStatefulWidget {
  final String projectId;

  const NacAssessmentWizardDialog({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<NacAssessmentWizardDialog> createState() => _NacAssessmentWizardDialogState();
}

class _NacAssessmentWizardDialogState extends ConsumerState<NacAssessmentWizardDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  // Step 1: Basic Network Info
  final _networkNameController = TextEditingController();
  final _subnetController = TextEditingController();
  final _gatewayController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Step 2: NAC Configuration
  bool _nacEnabled = false;
  String _nacType = '';
  String _accessLevel = 'blocked';
  bool _physicalAccess = false;
  bool _authenticatedDevicePresent = false;

  // Step 3: Security Configuration
  bool _vlanSegmentation = false;
  bool _macsecEnabled = false;
  bool _multipleMacsAllowed = false;
  bool _portSecurityEnabled = false;

  // Step 4: Discovered Assets
  final List<String> _authorizedMacs = [];
  final List<Map<String, dynamic>> _vlans = [];
  final List<Map<String, dynamic>> _credentials = [];

  // Controllers for adding items
  final _macController = TextEditingController();
  final _vlanIdController = TextEditingController();
  final _vlanNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _domainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _networkNameController.dispose();
    _subnetController.dispose();
    _gatewayController.dispose();
    _descriptionController.dispose();
    _macController.dispose();
    _vlanIdController.dispose();
    _vlanNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
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
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Theme.of(context).primaryColor),
                  const SizedBox(width: AppSpacing.sm),
                  const Expanded(
                    child: Text(
                      'NAC Assessment Setup Wizard',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Network Info'),
                Tab(text: 'NAC Config'),
                Tab(text: 'Security'),
                Tab(text: 'Discovered Assets'),
                Tab(text: 'Review & Create'),
              ],
            ),

            // Tab content
            Expanded(
              child: Form(
                key: _formKey,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildNetworkInfoTab(),
                    _buildNacConfigTab(),
                    _buildSecurityTab(),
                    _buildDiscoveredAssetsTab(),
                    _buildReviewTab(),
                  ],
                ),
              ),
            ),

            // Footer with navigation
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  if (_tabController.index > 0)
                    TextButton.icon(
                      onPressed: () {
                        _tabController.animateTo(_tabController.index - 1);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Previous'),
                    ),
                  const Spacer(),
                  if (_tabController.index < 4)
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_validateCurrentTab()) {
                          _tabController.animateTo(_tabController.index + 1);
                        }
                      },
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next'),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _createNacAssessment,
                      icon: const Icon(Icons.check),
                      label: const Text('Create Assessment'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Network Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Enter the basic information about the network segment you want to assess for NAC bypass.',
          ),
          const SizedBox(height: AppSpacing.xl),

          TextFormField(
            controller: _networkNameController,
            decoration: const InputDecoration(
              labelText: 'Network Name *',
              hintText: 'e.g., Corporate LAN, Guest Network',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a network name';
              }
              return null;
            },
          ),

          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _subnetController,
            decoration: const InputDecoration(
              labelText: 'Subnet/Network Range (Optional)',
              hintText: 'e.g., 192.168.1.0/24, 10.0.0.0/16',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _gatewayController,
            decoration: const InputDecoration(
              labelText: 'Gateway IP',
              hintText: 'e.g., 192.168.1.1',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Additional details about this network segment',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildNacConfigTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NAC Configuration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Configure the Network Access Control settings for this segment.',
          ),
          const SizedBox(height: AppSpacing.xl),

          SwitchListTile(
            title: const Text('NAC Enabled'),
            subtitle: const Text('Is Network Access Control configured on this segment?'),
            value: _nacEnabled,
            onChanged: (value) {
              setState(() {
                _nacEnabled = value;
              });
            },
          ),

          if (_nacEnabled) ...[
            const SizedBox(height: AppSpacing.lg),

            DropdownButtonFormField<String>(
              value: _nacType.isEmpty ? null : _nacType,
              decoration: const InputDecoration(
                labelText: 'NAC Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: '802.1x', child: Text('802.1X Authentication')),
                DropdownMenuItem(value: 'web_auth', child: Text('Web Authentication Portal')),
                DropdownMenuItem(value: 'mac_auth', child: Text('MAC Address Authentication')),
              ],
              onChanged: (value) {
                setState(() {
                  _nacType = value ?? '';
                });
              },
            ),

            const SizedBox(height: AppSpacing.lg),

            DropdownButtonFormField<String>(
              value: _accessLevel,
              decoration: const InputDecoration(
                labelText: 'Current Access Level',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'blocked', child: Text('Blocked - No access')),
                DropdownMenuItem(value: 'limited', child: Text('Limited - Restricted access')),
                DropdownMenuItem(value: 'partial', child: Text('Partial - Some resources accessible')),
                DropdownMenuItem(value: 'full', child: Text('Full - Complete access')),
              ],
              onChanged: (value) {
                setState(() {
                  _accessLevel = value ?? 'blocked';
                });
              },
            ),
          ],

          const SizedBox(height: AppSpacing.xl),

          SwitchListTile(
            title: const Text('Physical Access Available'),
            subtitle: const Text('Do you have physical access to network jacks/cables?'),
            value: _physicalAccess,
            onChanged: (value) {
              setState(() {
                _physicalAccess = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Authenticated Device Present'),
            subtitle: const Text('Is there an authenticated device you can observe/access?'),
            value: _authenticatedDevicePresent,
            onChanged: (value) {
              setState(() {
                _authenticatedDevicePresent = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security Configuration',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Additional security controls that may affect NAC bypass techniques.',
          ),
          const SizedBox(height: AppSpacing.xl),

          SwitchListTile(
            title: const Text('VLAN Segmentation'),
            subtitle: const Text('Are VLANs used for network segmentation?'),
            value: _vlanSegmentation,
            onChanged: (value) {
              setState(() {
                _vlanSegmentation = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('MACsec Enabled'),
            subtitle: const Text('Is MACsec (802.1AE) encryption used?'),
            value: _macsecEnabled,
            onChanged: (value) {
              setState(() {
                _macsecEnabled = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Multiple MACs Allowed'),
            subtitle: const Text('Can multiple MAC addresses use the same port?'),
            value: _multipleMacsAllowed,
            onChanged: (value) {
              setState(() {
                _multipleMacsAllowed = value;
              });
            },
          ),

          SwitchListTile(
            title: const Text('Port Security Enabled'),
            subtitle: const Text('Is switch port security configured?'),
            value: _portSecurityEnabled,
            onChanged: (value) {
              setState(() {
                _portSecurityEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveredAssetsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discovered Assets',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Add any already discovered assets that could be used for NAC bypass.',
          ),
          const SizedBox(height: AppSpacing.xl),

          // Authorized MACs
          _buildDiscoveredSection(
            'Authorized MAC Addresses',
            'MAC addresses of devices that have network access',
            _authorizedMacs,
            () => _showAddMacDialog(),
            (index) => _authorizedMacs.removeAt(index),
          ),

          const SizedBox(height: AppSpacing.xl),

          // VLANs
          _buildVlanSection(),

          const SizedBox(height: AppSpacing.xl),

          // Credentials
          _buildCredentialsSection(),
        ],
      ),
    );
  }

  Widget _buildDiscoveredSection(
    String title,
    String subtitle,
    List<String> items,
    VoidCallback onAdd,
    Function(int) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              tooltip: 'Add item',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'No items added yet',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...items.asMap().entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: ListTile(
              title: Text(entry.value),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    onRemove(entry.key);
                  });
                },
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildVlanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discovered VLANs',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'VLAN IDs and names discovered on the network',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _showAddVlanDialog,
              icon: const Icon(Icons.add),
              tooltip: 'Add VLAN',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_vlans.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'No VLANs added yet',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ..._vlans.asMap().entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: ListTile(
              title: Text('VLAN ${entry.value['id']}: ${entry.value['name']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _vlans.removeAt(entry.key);
                  });
                },
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildCredentialsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Credentials',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Credentials that might work for NAC authentication',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _showAddCredentialDialog,
              icon: const Icon(Icons.add),
              tooltip: 'Add credential',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        if (_credentials.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'No credentials added yet',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ..._credentials.asMap().entries.map((entry) => Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: ListTile(
              title: Text('${entry.value['username']}@${entry.value['domain'] ?? 'local'}'),
              subtitle: Text('Type: ${entry.value['type'] ?? 'local'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    _credentials.removeAt(entry.key);
                  });
                },
              ),
            ),
          )),
      ],
    );
  }

  Widget _buildReviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Review & Create Assessment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'Review your NAC assessment configuration. This will create a network segment asset with all the properties needed to trigger NAC bypass methodologies.',
          ),
          const SizedBox(height: AppSpacing.xl),

          _buildReviewSection('Network Information', [
            'Name: ${_networkNameController.text}',
            'Subnet: ${_subnetController.text}',
            'Gateway: ${_gatewayController.text}',
            if (_descriptionController.text.isNotEmpty) 'Description: ${_descriptionController.text}',
          ]),

          _buildReviewSection('NAC Configuration', [
            'NAC Enabled: ${_nacEnabled ? 'Yes' : 'No'}',
            if (_nacEnabled) 'NAC Type: $_nacType',
            'Access Level: $_accessLevel',
            'Physical Access: ${_physicalAccess ? 'Available' : 'Not available'}',
            'Authenticated Device: ${_authenticatedDevicePresent ? 'Present' : 'Not present'}',
          ]),

          _buildReviewSection('Security Controls', [
            'VLAN Segmentation: ${_vlanSegmentation ? 'Enabled' : 'Disabled'}',
            'MACsec: ${_macsecEnabled ? 'Enabled' : 'Disabled'}',
            'Multiple MACs Allowed: ${_multipleMacsAllowed ? 'Yes' : 'No'}',
            'Port Security: ${_portSecurityEnabled ? 'Enabled' : 'Disabled'}',
          ]),

          _buildReviewSection('Discovered Assets', [
            'Authorized MACs: ${_authorizedMacs.length} discovered',
            'VLANs: ${_vlans.length} discovered',
            'Credentials: ${_credentials.length} available',
          ]),

          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    const SizedBox(width: AppSpacing.sm),
                    const Text(
                      'Triggered Methodologies',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _getPotentialMethodologies(),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $item'),
              )).toList(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
      ],
    );
  }

  String _getPotentialMethodologies() {
    final List<String> methodologies = [];

    if (_nacEnabled) {
      if (_authorizedMacs.isNotEmpty && _accessLevel != 'full') {
        methodologies.add('MAC Address Spoofing NAC Bypass');
      }

      if (_credentials.isNotEmpty && (_nacType == '802.1x' || _nacType == 'web_auth')) {
        methodologies.add('NAC Credential Authentication');
      }

      if (_physicalAccess && _authenticatedDevicePresent && _nacType == '802.1x') {
        methodologies.add('802.1X Hub/Tap Bypass');
      }

      if (_vlanSegmentation && _vlans.isNotEmpty && _accessLevel == 'limited') {
        methodologies.add('VLAN Hopping Attack');
      }
    }

    if (methodologies.isEmpty) {
      return 'No methodologies will be triggered with the current configuration. Consider enabling NAC and adding discovered assets to trigger bypass methodologies.';
    }

    return 'Based on your configuration, the following methodologies may be triggered:\n\n${methodologies.map((m) => '• $m').join('\n')}';
  }

  bool _validateCurrentTab() {
    switch (_tabController.index) {
      case 0:
        return _networkNameController.text.isNotEmpty;
      case 1:
        return !_nacEnabled || _nacType.isNotEmpty;
      default:
        return true;
    }
  }

  void _showAddMacDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add MAC Address'),
        content: TextField(
          controller: _macController,
          decoration: const InputDecoration(
            labelText: 'MAC Address',
            hintText: 'e.g., 00:1A:2B:3C:4D:5E',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_macController.text.isNotEmpty) {
                setState(() {
                  _authorizedMacs.add(_macController.text);
                  _macController.clear();
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddVlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add VLAN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _vlanIdController,
              decoration: const InputDecoration(
                labelText: 'VLAN ID',
                hintText: 'e.g., 10',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _vlanNameController,
              decoration: const InputDecoration(
                labelText: 'VLAN Name',
                hintText: 'e.g., management, users',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_vlanIdController.text.isNotEmpty && _vlanNameController.text.isNotEmpty) {
                setState(() {
                  _vlans.add({
                    'id': int.tryParse(_vlanIdController.text) ?? 0,
                    'name': _vlanNameController.text,
                  });
                  _vlanIdController.clear();
                  _vlanNameController.clear();
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddCredentialDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Credential'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                hintText: 'e.g., jdoe',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Password or hash',
              ),
              obscureText: true,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Domain (optional)',
                hintText: 'e.g., CORP, local',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                setState(() {
                  _credentials.add({
                    'username': _usernameController.text,
                    'password': _passwordController.text,
                    'domain': _domainController.text.isEmpty ? 'local' : _domainController.text,
                    'type': 'password',
                  });
                  _usernameController.clear();
                  _passwordController.clear();
                  _domainController.clear();
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _createNacAssessment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final assetId = _uuid.v4();

    final properties = <String, PropertyValue>{
      // Basic network properties
      'subnet': PropertyValue.string(_subnetController.text),
      'gateway': PropertyValue.string(_gatewayController.text),
      'network_range': PropertyValue.string(_subnetController.text),

      // NAC Configuration
      'nac_enabled': PropertyValue.boolean(_nacEnabled),
      'nac_type': PropertyValue.string(_nacType),
      'access_level': PropertyValue.string(_accessLevel),

      // Physical Access Properties
      'physical_access': PropertyValue.boolean(_physicalAccess),
      'authenticated_device_present': PropertyValue.boolean(_authenticatedDevicePresent),

      // Security Configuration
      'vlan_segmentation': PropertyValue.boolean(_vlanSegmentation),
      'macsec_enabled': PropertyValue.boolean(_macsecEnabled),
      'multiple_macs_allowed': PropertyValue.boolean(_multipleMacsAllowed),
      'port_security_enabled': PropertyValue.boolean(_portSecurityEnabled),

      // Discovered Assets Lists
      'authorized_macs_discovered': PropertyValue.stringList(_authorizedMacs),
      'vlans_discovered': PropertyValue.objectList(_vlans),
      'credentials_available': PropertyValue.objectList(_credentials),

      // Assessment State (initial values)
      'bypass_methods_attempted': const PropertyValue.stringList([]),
      'bypass_methods_successful': const PropertyValue.stringList([]),
      'nac_bypassed': const PropertyValue.boolean(false),
      'internal_subnet_discovered': const PropertyValue.string(''),
    };

    final asset = Asset(
      id: assetId,
      projectId: widget.projectId,
      name: _networkNameController.text,
      type: AssetType.networkSegment,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      properties: properties,
      tags: ['NAC', 'assessment', 'network_security'],
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    try {
      await ref.read(assetServiceProvider(widget.projectId)).createAsset(asset);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('NAC assessment "${_networkNameController.text}" created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating NAC assessment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}