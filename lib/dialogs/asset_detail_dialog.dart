import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assets.dart';
import '../constants/app_spacing.dart';
import 'network_interface_dialog.dart';
import 'host_service_dialog.dart';
import 'host_application_dialog.dart';
import 'firewall_rule_dialog.dart';
import 'network_host_dialog.dart';
import 'access_point_dialog.dart';

/// A comprehensive dialog for viewing and editing asset details
/// Dynamically adapts its interface based on the asset type
class AssetDetailDialog extends ConsumerStatefulWidget {
  final Asset asset;
  final bool isEditMode;
  final Function(Asset)? onSave;

  const AssetDetailDialog({
    super.key,
    required this.asset,
    this.isEditMode = false,
    this.onSave,
  });

  @override
  ConsumerState<AssetDetailDialog> createState() => _AssetDetailDialogState();
}

class _AssetDetailDialogState extends ConsumerState<AssetDetailDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late Asset _editedAsset;
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _editedAsset = widget.asset;
    _tabController = TabController(length: _getTabCount(), vsync: this);
    _initializeControllers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _initializeControllers() {
    _controllers['name'] = TextEditingController(text: _editedAsset.name);
    _controllers['description'] = TextEditingController(text: _editedAsset.description ?? '');

    // Initialize controllers for asset-specific properties
    for (final entry in _editedAsset.properties.entries) {
      final value = entry.value.when(
        string: (v) => v,
        integer: (v) => v.toString(),
        double: (v) => v.toString(),
        boolean: (v) => v.toString(),
        stringList: (v) => v.join(', '),
        dateTime: (v) => v.toIso8601String(),
        map: (v) => v.toString(),
        objectList: (v) => v.toString(),
      );
      _controllers[entry.key] = TextEditingController(text: value);
    }
  }

  int _getTabCount() {
    // Base tabs: Basic Info, Properties, Relationships
    int count = 3;

    // Add asset-specific tabs
    switch (_editedAsset.type) {
      case AssetType.networkSegment:
        count += 2; // Security, Discovered Assets
        break;
      case AssetType.host:
        count += 5; // Network, Services, Applications, Security, Access
        break;
      case AssetType.cloudTenant:
        count += 2; // Subscriptions, Security
        break;
      case AssetType.wirelessNetwork:
        count += 1; // Clients
        break;
      case AssetType.person:
        count += 1; // Security Profile
        break;
      default:
        break;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Scaffold(
          appBar: AppBar(
            title: Text('${widget.isEditMode ? "Edit" : "View"} ${_formatAssetTypeName(_editedAsset.type)}'),
            automaticallyImplyLeading: false,
            actions: [
              if (widget.isEditMode) ...[
                TextButton(
                  onPressed: _saveAsset,
                  child: const Text('Save'),
                ),
                const SizedBox(width: AppSpacing.sm),
              ],
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: _buildTabs(),
            ),
          ),
          body: Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: _buildTabViews(),
            ),
          ),
        ),
      ),
    );
  }

  List<Tab> _buildTabs() {
    final tabs = [
      const Tab(icon: Icon(Icons.info), text: 'Basic Info'),
      const Tab(icon: Icon(Icons.settings), text: 'Properties'),
      const Tab(icon: Icon(Icons.account_tree), text: 'Relationships'),
    ];

    // Add asset-specific tabs
    switch (_editedAsset.type) {
      case AssetType.networkSegment:
        tabs.addAll([
          const Tab(icon: Icon(Icons.security), text: 'Security'),
          const Tab(icon: Icon(Icons.computer), text: 'Discovered'),
        ]);
        break;
      case AssetType.host:
        tabs.addAll([
          const Tab(icon: Icon(Icons.network_check), text: 'Network'),
          const Tab(icon: Icon(Icons.cloud), text: 'Services'),
          const Tab(icon: Icon(Icons.apps), text: 'Applications'),
          const Tab(icon: Icon(Icons.security), text: 'Security'),
          const Tab(icon: Icon(Icons.key), text: 'Access'),
        ]);
        break;
      case AssetType.cloudTenant:
        tabs.addAll([
          const Tab(icon: Icon(Icons.subscriptions), text: 'Subscriptions'),
          const Tab(icon: Icon(Icons.shield), text: 'Security'),
        ]);
        break;
      case AssetType.wirelessNetwork:
        tabs.add(const Tab(icon: Icon(Icons.devices), text: 'Clients'));
        break;
      case AssetType.person:
        tabs.add(const Tab(icon: Icon(Icons.person_pin), text: 'Security Profile'));
        break;
      default:
        break;
    }

    return tabs;
  }

  List<Widget> _buildTabViews() {
    final views = [
      _buildBasicInfoTab(),
      _buildPropertiesTab(),
      _buildRelationshipsTab(),
    ];

    // Add asset-specific tab views
    switch (_editedAsset.type) {
      case AssetType.networkSegment:
        views.addAll([
          _buildNetworkSecurityTab(),
          _buildDiscoveredAssetsTab(),
        ]);
        break;
      case AssetType.host:
        views.addAll([
          _buildHostNetworkTab(),
          _buildHostServicesTab(),
          _buildHostApplicationsTab(),
          _buildHostSecurityTab(),
          _buildHostAccessTab(),
        ]);
        break;
      case AssetType.cloudTenant:
        views.addAll([
          _buildCloudSubscriptionsTab(),
          _buildCloudSecurityTab(),
        ]);
        break;
      case AssetType.wirelessNetwork:
        views.add(_buildWirelessClientsTab());
        break;
      case AssetType.person:
        views.add(_buildPersonSecurityTab());
        break;
      default:
        break;
    }

    return views;
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Basic Information'),
          const SizedBox(height: AppSpacing.md),

          _buildTextField('Asset Name', 'name', required: true),
          const SizedBox(height: AppSpacing.md),

          _buildTextField('Description', 'description', maxLines: 3),
          const SizedBox(height: AppSpacing.md),

          _buildReadOnlyField('Asset Type', _formatAssetTypeName(_editedAsset.type)),
          const SizedBox(height: AppSpacing.md),

          _buildReadOnlyField('Asset ID', _editedAsset.id),
          const SizedBox(height: AppSpacing.md),

          _buildDropdownField(
            'Discovery Status',
            AssetDiscoveryStatus.values,
            _editedAsset.discoveryStatus,
            (value) => setState(() => _editedAsset = _editedAsset.copyWith(discoveryStatus: value ?? AssetDiscoveryStatus.discovered)),
            formatValue: (status) => _formatStatusName(status),
          ),
          const SizedBox(height: AppSpacing.md),

          if (_editedAsset.accessLevel != null)
            _buildDropdownField(
              'Access Level',
              AccessLevel.values,
              _editedAsset.accessLevel,
              (value) => setState(() => _editedAsset = _editedAsset.copyWith(accessLevel: value)),
              formatValue: (level) => _formatAccessLevelName(level),
            ),

          const SizedBox(height: AppSpacing.md),
          _buildReadOnlyField('Discovered At', _formatFullDate(_editedAsset.discoveredAt)),

          if (_editedAsset.lastUpdated != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildReadOnlyField('Last Updated', _formatFullDate(_editedAsset.lastUpdated!)),
          ],

          if (_editedAsset.discoveryMethod != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildReadOnlyField('Discovery Method', _editedAsset.discoveryMethod!),
          ],

          const SizedBox(height: AppSpacing.md),
          _buildReadOnlyField('Confidence', '${(_editedAsset.confidence * 100).toInt()}%'),

          const SizedBox(height: AppSpacing.lg),
          _buildTagsSection(),
        ],
      ),
    );
  }

  Widget _buildPropertiesTab() {
    final schema = _getAssetPropertySchema(_editedAsset.type);
    final filteredSchema = _filterSpecializedProperties(schema, _editedAsset.type);
    final groupedProperties = _groupPropertiesByCategory(_editedAsset.type, filteredSchema);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Asset Properties'),
          const SizedBox(height: AppSpacing.md),

          Text(
            'Properties specific to ${_formatAssetTypeName(_editedAsset.type).toLowerCase()}s',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade600,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          ...groupedProperties.entries.map((categoryEntry) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (categoryEntry.key.isNotEmpty) ...[
                Text(
                  categoryEntry.key,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  height: 1,
                  color: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              ...categoryEntry.value.entries.map((entry) => Column(
                children: [
                  _buildPropertyField(entry.key, entry.value),
                  const SizedBox(height: AppSpacing.md),
                ],
              )),
              const SizedBox(height: AppSpacing.lg),
            ],
          )),

          if (schema.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: Colors.grey.shade600, size: 32),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No specific properties defined for this asset type',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRelationshipsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Asset Relationships'),
          const SizedBox(height: AppSpacing.md),

          _buildRelationshipSection('Parent Assets', _editedAsset.parentAssetIds),
          const SizedBox(height: AppSpacing.lg),

          _buildRelationshipSection('Child Assets', _editedAsset.childAssetIds),
          const SizedBox(height: AppSpacing.lg),

          _buildRelationshipSection('Related Assets', _editedAsset.relatedAssetIds),
        ],
      ),
    );
  }

  // Asset-specific tab builders
  Widget _buildNetworkSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Network Access Control (NAC)'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('nac_enabled', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildNacTypeDropdown(),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('nac_bypass_methods', 'stringList'),
          const SizedBox(height: AppSpacing.lg),

          _buildSectionHeader('Firewall & Security'),
          const SizedBox(height: AppSpacing.md),
          _buildFirewallRulesSection(),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('ips_enabled', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('ips_signatures', 'stringList'),
          const SizedBox(height: AppSpacing.lg),

          _buildSectionHeader('Monitoring & Detection'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('network_monitoring', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('monitoring_tools', 'stringList'),
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
          _buildSectionHeader('Pentesting Access'),
          const SizedBox(height: AppSpacing.md),
          _buildNetworkAccessTypeDropdown(),
          const SizedBox(height: AppSpacing.md),
          _buildAccessPointsSection(),
          const SizedBox(height: AppSpacing.lg),

          _buildSectionHeader('Host Inventory'),
          const SizedBox(height: AppSpacing.md),
          _buildNetworkHostsSection(),
          const SizedBox(height: AppSpacing.lg),

          _buildSectionHeader('Infrastructure Assets'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('network_devices', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('wireless_aps', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('unknown_devices', 'stringList'),
          const SizedBox(height: AppSpacing.lg),

          _buildSectionHeader('Connectivity'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('connected_networks', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('internet_access', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('isolated', 'boolean'),
        ],
      ),
    );
  }

  Widget _buildHostNetworkTab() {
    // Get network interfaces from properties
    final networkInterfaces = _getObjectListProperty('network_interfaces')
        .map((json) => NetworkInterface.fromJson(json))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Network Interfaces'),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: () => _showNetworkInterfaceDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Interface'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (networkInterfaces.isEmpty)
            _buildEmptyState('No network interfaces configured', Icons.network_check)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: networkInterfaces.length,
              itemBuilder: (context, index) => _buildNetworkInterfaceCard(networkInterfaces[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildHostServicesTab() {
    // Get running services from properties
    final services = _getObjectListProperty('running_services')
        .map((json) => HostService.fromJson(json))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Running Services'),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: () => _showHostServiceDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Service'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (services.isEmpty)
            _buildEmptyState('No services configured', Icons.cloud)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              itemBuilder: (context, index) => _buildServiceCard(services[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildHostApplicationsTab() {
    // Get installed applications from properties
    final applications = _getObjectListProperty('installed_applications')
        .map((json) => HostApplication.fromJson(json))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('Installed Applications'),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: () => _showHostApplicationDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Application'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (applications.isEmpty)
            _buildEmptyState('No applications configured', Icons.apps)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: applications.length,
              itemBuilder: (context, index) => _buildApplicationCard(applications[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildHostSecurityTab() {
    // Get OS family to show relevant sections
    final osFamily = _editedAsset.getProperty<String>('os_family')?.toLowerCase() ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('General Security'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('antivirus_products', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('host_firewall_enabled', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('encryption_status', 'string'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('secure_boot_enabled', 'boolean'),
          const SizedBox(height: AppSpacing.lg),

          // Windows-specific security
          if (osFamily == 'windows') ...[
            _buildSectionHeader('Windows Security'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('windows_uac_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('windows_defender_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('windows_rdp_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('windows_admin_shares_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Linux-specific security
          if (osFamily == 'linux') ...[
            _buildSectionHeader('Linux Security'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('linux_selinux_status', 'string'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('linux_sudo_rules', 'objectList'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('linux_iptables_rules', 'objectList'),
            const SizedBox(height: AppSpacing.lg),
          ],

          // macOS-specific security
          if (osFamily == 'macos') ...[
            _buildSectionHeader('macOS Security'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('macos_sip_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('macos_gatekeeper_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('macos_filevault_enabled', 'boolean'),
            const SizedBox(height: AppSpacing.md),
            _buildPropertyField('macos_xprotect_version', 'string'),
            const SizedBox(height: AppSpacing.lg),
          ],

          _buildSectionHeader('Vulnerabilities & Compliance'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('missing_patches', 'objectList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('vulnerabilities', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('configuration_issues', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('compliance_frameworks', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('security_score', 'integer'),
        ],
      ),
    );
  }

  Widget _buildHostAccessTab() {
    // Get user accounts from properties
    final accounts = _getObjectListProperty('user_accounts')
        .map((json) => HostAccount.fromJson(json))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('User Accounts'),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: () => _showUserAccountDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Account'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          if (accounts.isEmpty)
            _buildEmptyState('No user accounts configured', Icons.person)
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: accounts.length,
              itemBuilder: (context, index) => _buildAccountCard(accounts[index]),
            ),

          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Access & Credentials'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('access_level', 'string'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('privilege_escalation_possible', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('cached_credentials', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('stored_passwords', 'stringList'),
        ],
      ),
    );
  }

  Widget _buildCloudSubscriptionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Cloud Subscriptions'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('subscription_ids', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('billing_account', 'string'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('licensing_info', 'map'),
        ],
      ),
    );
  }

  Widget _buildCloudSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Cloud Security'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('security_defaults_enabled', 'boolean'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('mfa_enforcement', 'string'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('conditional_access_policies', 'stringList'),
        ],
      ),
    );
  }

  Widget _buildWirelessClientsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Connected Clients'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('connected_clients', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('max_speed_mbps', 'integer'),
        ],
      ),
    );
  }

  Widget _buildPersonSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Security Profile'),
          const SizedBox(height: AppSpacing.md),

          _buildPropertyField('security_awareness_level', 'string'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('training_completed', 'stringList'),
          const SizedBox(height: AppSpacing.md),
          _buildPropertyField('incident_history', 'stringList'),
        ],
      ),
    );
  }

  // UI Helper Methods
  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_outlined, color: Theme.of(context).primaryColor),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String key, {bool required = false, int maxLines = 1}) {
    return TextFormField(
      controller: _controllers[key],
      enabled: widget.isEditMode,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: required ? (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      } : null,
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdownField<T>(
    String label,
    List<T> options,
    T? currentValue,
    Function(T?) onChanged, {
    String Function(T)? formatValue,
  }) {
    return DropdownButtonFormField<T>(
      value: currentValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: options.map((option) => DropdownMenuItem(
        value: option,
        child: Text(formatValue?.call(option) ?? option.toString()),
      )).toList(),
      onChanged: widget.isEditMode ? onChanged : null,
    );
  }

  Widget _buildPropertyField(String key, String type) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController();
    }

    switch (type) {
      case 'boolean':
        final currentValue = _editedAsset.getProperty<bool>(key) ?? false;
        return SwitchListTile(
          title: Text(_formatPropertyKey(key)),
          value: currentValue,
          onChanged: widget.isEditMode ? (value) {
            setState(() {
              _editedAsset = _editedAsset.updateProperty(key, AssetPropertyValue.boolean(value));
            });
          } : null,
        );

      case 'integer':
        return TextFormField(
          controller: _controllers[key],
          enabled: widget.isEditMode,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: _formatPropertyKey(key),
            border: const OutlineInputBorder(),
          ),
        );

      case 'stringList':
        return TextFormField(
          controller: _controllers[key],
          enabled: widget.isEditMode,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: _formatPropertyKey(key),
            hintText: 'Enter values separated by commas',
            border: const OutlineInputBorder(),
          ),
        );

      default:
        return TextFormField(
          controller: _controllers[key],
          enabled: widget.isEditMode,
          decoration: InputDecoration(
            labelText: _formatPropertyKey(key),
            border: const OutlineInputBorder(),
          ),
        );
    }
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tags',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 4,
          children: _editedAsset.tags.map((tag) => Chip(
            label: Text(tag),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            deleteIcon: widget.isEditMode ? const Icon(Icons.close, size: 16) : null,
            onDeleted: widget.isEditMode ? () {
              setState(() {
                final newTags = List<String>.from(_editedAsset.tags);
                newTags.remove(tag);
                _editedAsset = _editedAsset.copyWith(tags: newTags);
              });
            } : null,
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildRelationshipSection(String title, List<String> assetIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (assetIds.isEmpty)
          Text('No $title', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey))
        else
          ...assetIds.map((id) => Card(
            child: ListTile(
              leading: const Icon(Icons.link),
              title: Text(id),
              trailing: widget.isEditMode ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  // TODO: Remove relationship
                },
              ) : null,
            ),
          )),
      ],
    );
  }

  // Helper methods for structured objects
  List<Map<String, dynamic>> _getObjectListProperty(String key) {
    final property = _editedAsset.properties[key];
    if (property == null) return [];

    return property.when(
      objectList: (list) => list,
      string: (_) => [],
      integer: (_) => [],
      double: (_) => [],
      boolean: (_) => [],
      stringList: (_) => [],
      dateTime: (_) => [],
      map: (_) => [],
    );
  }

  void _updateObjectListProperty(String key, List<Map<String, dynamic>> objects) {
    setState(() {
      _editedAsset = _editedAsset.updateProperty(key, AssetPropertyValue.objectList(objects));
    });
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkInterfaceCard(NetworkInterface interface) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          _getInterfaceIcon(interface.type),
          color: interface.isEnabled ? Colors.green : Colors.grey,
        ),
        title: Text(interface.name),
        subtitle: Text(
          '${interface.macAddress} • ${interface.type} • '
          '${interface.addresses.map((a) => a.ip).join(', ')}',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showNetworkInterfaceDialog(interface),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeNetworkInterface(interface),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showNetworkInterfaceDialog(interface) : null,
      ),
    );
  }

  Widget _buildServiceCard(HostService service) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          Icons.cloud,
          color: _getServiceStateColor(service.state),
        ),
        title: Text('${service.name} (${service.port}/${service.protocol})'),
        subtitle: Text(
          '${service.state} • ${service.version ?? 'Unknown version'} • '
          '${service.vulnerabilities?.length ?? 0} CVEs',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showHostServiceDialog(service),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeHostService(service),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showHostServiceDialog(service) : null,
      ),
    );
  }

  Widget _buildApplicationCard(HostApplication application) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          _getApplicationIcon(application.type),
          color: application.isSystemCritical == true ? Colors.red : Colors.blue,
        ),
        title: Text(application.name),
        subtitle: Text(
          '${application.vendor ?? 'Unknown vendor'} • ${application.version ?? 'Unknown version'} • '
          '${application.architecture ?? 'Any'} • ${application.sizeMB ?? 0} MB',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (application.hasUpdateAvailable == true)
              Icon(Icons.update, color: Colors.orange, size: 16),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showHostApplicationDialog(application),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeHostApplication(application),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showHostApplicationDialog(application) : null,
      ),
    );
  }

  Widget _buildAccountCard(HostAccount account) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          Icons.person,
          color: account.isEnabled ? (account.isAdmin == true ? Colors.red : Colors.green) : Colors.grey,
        ),
        title: Text(account.username),
        subtitle: Text(
          '${account.type} • ${account.fullName ?? 'No full name'} • '
          '${account.isEnabled ? 'Enabled' : 'Disabled'}${account.isAdmin == true ? ' • Admin' : ''}',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showUserAccountDialog(account),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeUserAccount(account),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showUserAccountDialog(account) : null,
      ),
    );
  }

  // Dialog methods
  void _showNetworkInterfaceDialog([NetworkInterface? interface]) {
    showDialog(
      context: context,
      builder: (context) => NetworkInterfaceDialog(
        interface: interface,
        onSave: (newInterface) {
          final interfaces = _getObjectListProperty('network_interfaces');
          if (interface != null) {
            // Edit existing
            final index = interfaces.indexWhere((i) => i['id'] == interface.id);
            if (index >= 0) interfaces[index] = newInterface.toJson();
          } else {
            // Add new
            interfaces.add(newInterface.toJson());
          }
          _updateObjectListProperty('network_interfaces', interfaces);
        },
      ),
    );
  }

  void _showHostServiceDialog([HostService? service]) {
    showDialog(
      context: context,
      builder: (context) => HostServiceDialog(
        service: service,
        onSave: (newService) {
          final services = _getObjectListProperty('running_services');
          if (service != null) {
            // Edit existing
            final index = services.indexWhere((s) => s['id'] == service.id);
            if (index >= 0) services[index] = newService.toJson();
          } else {
            // Add new
            services.add(newService.toJson());
          }
          _updateObjectListProperty('running_services', services);
        },
      ),
    );
  }

  void _showHostApplicationDialog([HostApplication? application]) {
    showDialog(
      context: context,
      builder: (context) => HostApplicationDialog(
        application: application,
        onSave: (newApplication) {
          final applications = _getObjectListProperty('installed_applications');
          if (application != null) {
            // Edit existing
            final index = applications.indexWhere((a) => a['id'] == application.id);
            if (index >= 0) applications[index] = newApplication.toJson();
          } else {
            // Add new
            applications.add(newApplication.toJson());
          }
          _updateObjectListProperty('installed_applications', applications);
        },
      ),
    );
  }

  void _showUserAccountDialog([HostAccount? account]) {
    // TODO: Implement user account dialog similar to others
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User account dialog coming soon')),
    );
  }

  // Remove methods
  void _removeNetworkInterface(NetworkInterface interface) {
    final interfaces = _getObjectListProperty('network_interfaces');
    interfaces.removeWhere((i) => i['id'] == interface.id);
    _updateObjectListProperty('network_interfaces', interfaces);
  }

  void _removeHostService(HostService service) {
    final services = _getObjectListProperty('running_services');
    services.removeWhere((s) => s['id'] == service.id);
    _updateObjectListProperty('running_services', services);
  }

  void _removeHostApplication(HostApplication application) {
    final applications = _getObjectListProperty('installed_applications');
    applications.removeWhere((a) => a['id'] == application.id);
    _updateObjectListProperty('installed_applications', applications);
  }

  void _removeUserAccount(HostAccount account) {
    final accounts = _getObjectListProperty('user_accounts');
    accounts.removeWhere((a) => a['id'] == account.id);
    _updateObjectListProperty('user_accounts', accounts);
  }

  // Utility methods
  IconData _getInterfaceIcon(String type) {
    switch (type) {
      case 'ethernet': return Icons.cable;
      case 'wireless': return Icons.wifi;
      case 'loopback': return Icons.loop;
      case 'virtual': return Icons.cloud;
      default: return Icons.network_check;
    }
  }

  Color _getServiceStateColor(String state) {
    switch (state) {
      case 'open': return Colors.green;
      case 'filtered': return Colors.orange;
      case 'closed': return Colors.red;
      default: return Colors.grey;
    }
  }

  IconData _getApplicationIcon(String type) {
    switch (type) {
      case 'system': return Icons.settings;
      case 'user': return Icons.apps;
      case 'service': return Icons.cloud;
      case 'driver': return Icons.build;
      case 'runtime': return Icons.code;
      default: return Icons.app_registration;
    }
  }

  // Helper methods
  Map<String, String> _getAssetPropertySchema(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return AssetSchemas.networkSegmentProperties;
      case AssetType.host:
        return AssetSchemas.hostProperties;
      case AssetType.service:
        return AssetSchemas.serviceProperties;
      case AssetType.software:
        return AssetSchemas.softwareProperties;
      case AssetType.file:
        return AssetSchemas.fileProperties;
      case AssetType.wirelessNetwork:
        return AssetSchemas.wirelessNetworkProperties;
      case AssetType.cloudTenant:
        return AssetSchemas.cloudTenantProperties;
      case AssetType.cloudIdentity:
        return AssetSchemas.cloudIdentityProperties;
      case AssetType.person:
        return AssetSchemas.personProperties;
      case AssetType.restrictedEnvironment:
        return AssetSchemas.restrictedEnvironmentProperties;
      case AssetType.breakoutAttempt:
        return AssetSchemas.breakoutAttemptProperties;
      case AssetType.breakoutTechnique:
        return AssetSchemas.breakoutTechniqueProperties;
      case AssetType.securityControl:
        return AssetSchemas.securityControlProperties;
      default:
        return {};
    }
  }

  Map<String, Map<String, String>> _groupPropertiesByCategory(AssetType type, Map<String, String> schema) {
    final Map<String, Map<String, String>> grouped = {};

    switch (type) {
      case AssetType.networkSegment:
        grouped['Network Configuration'] = {};
        grouped['Security Controls'] = {};
        grouped['Discovered Assets'] = {};

        for (final entry in schema.entries) {
          if (['ip_range', 'subnet_mask', 'gateway', 'dns_servers', 'dhcp_range'].contains(entry.key)) {
            grouped['Network Configuration']![entry.key] = entry.value;
          } else if (['nac_enabled', 'nac_type', 'firewall_present', 'ips_enabled', 'network_monitoring'].contains(entry.key)) {
            grouped['Security Controls']![entry.key] = entry.value;
          } else if (['live_hosts', 'network_devices', 'wireless_aps'].contains(entry.key)) {
            grouped['Discovered Assets']![entry.key] = entry.value;
          } else {
            grouped.putIfAbsent('General', () => {})[entry.key] = entry.value;
          }
        }
        break;

      case AssetType.host:
        grouped['Basic Identification'] = {};
        grouped['Operating System'] = {};
        grouped['Hardware Information'] = {};
        grouped['General Security'] = {};
        grouped['Access & Credentials'] = {};
        grouped['Vulnerabilities & Compliance'] = {};
        grouped['Monitoring & Logging'] = {};
        grouped['Windows-Specific'] = {};
        grouped['Linux-Specific'] = {};
        grouped['macOS-Specific'] = {};
        grouped['Virtualization'] = {};

        for (final entry in schema.entries) {
          // Basic Identification
          if (['hostname', 'fqdn', 'domain_membership', 'computer_description', 'asset_tag'].contains(entry.key)) {
            grouped['Basic Identification']![entry.key] = entry.value;
          }
          // Operating System
          else if (['os_family', 'os_name', 'os_version', 'os_architecture', 'os_build', 'patch_level', 'kernel_version', 'last_boot_time', 'timezone'].contains(entry.key)) {
            grouped['Operating System']![entry.key] = entry.value;
          }
          // Hardware Information
          else if (['hardware_type', 'manufacturer', 'model', 'serial_number', 'bios_version', 'cpu_cores', 'memory_gb', 'total_disk_space_gb', 'free_disk_space_gb'].contains(entry.key)) {
            grouped['Hardware Information']![entry.key] = entry.value;
          }
          // General Security
          else if (['antivirus_products', 'host_firewall_enabled', 'encryption_status', 'secure_boot_enabled'].contains(entry.key)) {
            grouped['General Security']![entry.key] = entry.value;
          }
          // Access & Credentials
          else if (['access_level', 'privilege_escalation_possible', 'cached_credentials', 'stored_passwords'].contains(entry.key)) {
            grouped['Access & Credentials']![entry.key] = entry.value;
          }
          // Vulnerabilities & Compliance
          else if (['missing_patches', 'vulnerabilities', 'configuration_issues', 'compliance_frameworks', 'security_score'].contains(entry.key)) {
            grouped['Vulnerabilities & Compliance']![entry.key] = entry.value;
          }
          // Monitoring & Logging
          else if (['log_sources', 'monitoring_agents', 'remote_management_tools'].contains(entry.key)) {
            grouped['Monitoring & Logging']![entry.key] = entry.value;
          }
          // Windows-Specific
          else if (entry.key.startsWith('windows_')) {
            grouped['Windows-Specific']![entry.key] = entry.value;
          }
          // Linux-Specific
          else if (entry.key.startsWith('linux_')) {
            grouped['Linux-Specific']![entry.key] = entry.value;
          }
          // macOS-Specific
          else if (entry.key.startsWith('macos_')) {
            grouped['macOS-Specific']![entry.key] = entry.value;
          }
          // Virtualization
          else if (['virtualization_platform', 'container_runtime', 'hypervisor_version'].contains(entry.key)) {
            grouped['Virtualization']![entry.key] = entry.value;
          }
          // Skip structured components (they have their own tabs)
          else if (!['network_interfaces', 'installed_applications', 'running_services', 'user_accounts', 'hardware_components'].contains(entry.key)) {
            grouped.putIfAbsent('Other', () => {})[entry.key] = entry.value;
          }
        }
        break;

      case AssetType.service:
        grouped['Basic Service Information'] = {};
        grouped['Authentication & Security'] = {};
        grouped['SSL/TLS Configuration'] = {};
        grouped['Web Services'] = {};
        grouped['SMB/CIFS Services'] = {};
        grouped['SSH Services'] = {};
        grouped['RDP Services'] = {};
        grouped['FTP Services'] = {};
        grouped['Database Services'] = {};
        grouped['Mail Services'] = {};
        grouped['DNS Services'] = {};
        grouped['LDAP/AD Services'] = {};
        grouped['SNMP Services'] = {};
        grouped['Vulnerabilities & Issues'] = {};

        for (final entry in schema.entries) {
          // Basic Service Information
          if (['port', 'protocol', 'service_name', 'service_version', 'service_banner', 'state', 'process_name', 'process_id'].contains(entry.key)) {
            grouped['Basic Service Information']![entry.key] = entry.value;
          }
          // Authentication & Security
          else if (['authentication_required', 'authentication_methods', 'default_credentials', 'weak_credentials', 'anonymous_access_allowed', 'guest_access_allowed'].contains(entry.key)) {
            grouped['Authentication & Security']![entry.key] = entry.value;
          }
          // SSL/TLS Configuration
          else if (entry.key.startsWith('ssl_')) {
            grouped['SSL/TLS Configuration']![entry.key] = entry.value;
          }
          // Web Services
          else if (entry.key.startsWith('web_') || entry.key.startsWith('http_') || ['api_endpoints'].contains(entry.key)) {
            grouped['Web Services']![entry.key] = entry.value;
          }
          // SMB/CIFS Services
          else if (entry.key.startsWith('smb_')) {
            grouped['SMB/CIFS Services']![entry.key] = entry.value;
          }
          // SSH Services
          else if (entry.key.startsWith('ssh_')) {
            grouped['SSH Services']![entry.key] = entry.value;
          }
          // RDP Services
          else if (entry.key.startsWith('rdp_')) {
            grouped['RDP Services']![entry.key] = entry.value;
          }
          // FTP Services
          else if (entry.key.startsWith('ftp_')) {
            grouped['FTP Services']![entry.key] = entry.value;
          }
          // Database Services
          else if (entry.key.startsWith('database_')) {
            grouped['Database Services']![entry.key] = entry.value;
          }
          // Mail Services
          else if (entry.key.startsWith('mail_')) {
            grouped['Mail Services']![entry.key] = entry.value;
          }
          // DNS Services
          else if (entry.key.startsWith('dns_')) {
            grouped['DNS Services']![entry.key] = entry.value;
          }
          // LDAP/AD Services
          else if (entry.key.startsWith('ldap_') || entry.key.startsWith('ad_')) {
            grouped['LDAP/AD Services']![entry.key] = entry.value;
          }
          // SNMP Services
          else if (entry.key.startsWith('snmp_')) {
            grouped['SNMP Services']![entry.key] = entry.value;
          }
          // Vulnerabilities & Issues
          else if (['service_vulnerabilities', 'configuration_issues', 'security_warnings', 'compliance_status'].contains(entry.key)) {
            grouped['Vulnerabilities & Issues']![entry.key] = entry.value;
          }
          else {
            grouped.putIfAbsent('Other', () => {})[entry.key] = entry.value;
          }
        }
        break;

      case AssetType.cloudTenant:
        grouped['Tenant Information'] = {};
        grouped['Security Settings'] = {};
        grouped['Billing & Licensing'] = {};

        for (final entry in schema.entries) {
          if (['tenant_id', 'tenant_name', 'subscription_ids', 'admin_users'].contains(entry.key)) {
            grouped['Tenant Information']![entry.key] = entry.value;
          } else if (['security_defaults_enabled', 'mfa_enforcement', 'conditional_access_policies'].contains(entry.key)) {
            grouped['Security Settings']![entry.key] = entry.value;
          } else if (['billing_account', 'licensing_info'].contains(entry.key)) {
            grouped['Billing & Licensing']![entry.key] = entry.value;
          } else {
            grouped.putIfAbsent('General', () => {})[entry.key] = entry.value;
          }
        }
        break;

      case AssetType.wirelessNetwork:
        grouped['Network Configuration'] = {};
        grouped['Security Settings'] = {};
        grouped['Connected Devices'] = {};

        for (final entry in schema.entries) {
          if (['ssid', 'bssid', 'channel', 'frequency', 'max_speed_mbps'].contains(entry.key)) {
            grouped['Network Configuration']![entry.key] = entry.value;
          } else if (['security_type', 'encryption_method', 'authentication_mode'].contains(entry.key)) {
            grouped['Security Settings']![entry.key] = entry.value;
          } else if (['connected_clients', 'client_mac_addresses'].contains(entry.key)) {
            grouped['Connected Devices']![entry.key] = entry.value;
          } else {
            grouped.putIfAbsent('General', () => {})[entry.key] = entry.value;
          }
        }
        break;

      case AssetType.person:
        grouped['Personal Information'] = {};
        grouped['Security Profile'] = {};
        grouped['Training & Awareness'] = {};

        for (final entry in schema.entries) {
          if (['full_name', 'email', 'job_title', 'department', 'phone_number'].contains(entry.key)) {
            grouped['Personal Information']![entry.key] = entry.value;
          } else if (['security_awareness_level', 'incident_history', 'access_privileges'].contains(entry.key)) {
            grouped['Security Profile']![entry.key] = entry.value;
          } else if (['training_completed', 'training_due_date', 'phishing_test_results'].contains(entry.key)) {
            grouped['Training & Awareness']![entry.key] = entry.value;
          } else {
            grouped.putIfAbsent('General', () => {})[entry.key] = entry.value;
          }
        }
        break;

      case AssetType.credential:
        grouped['Credential Details'] = {};
        grouped['Security Information'] = {};

        for (final entry in schema.entries) {
          if (['username', 'credential_type', 'domain', 'source_location'].contains(entry.key)) {
            grouped['Credential Details']![entry.key] = entry.value;
          } else if (['password_policy_compliant', 'password_age', 'privileged_account', 'mfa_enabled'].contains(entry.key)) {
            grouped['Security Information']![entry.key] = entry.value;
          } else {
            grouped.putIfAbsent('General', () => {})[entry.key] = entry.value;
          }
        }
        break;

      default:
        // For asset types without specific grouping, just put everything in General
        grouped['General'] = Map.from(schema);
        break;
    }

    // Remove empty categories
    grouped.removeWhere((key, value) => value.isEmpty);

    return grouped;
  }

  String _formatAssetTypeName(AssetType type) {
    return type.name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
  }

  String _formatStatusName(AssetDiscoveryStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  String _formatAccessLevelName(AccessLevel level) {
    return level.name[0].toUpperCase() + level.name.substring(1);
  }

  String _formatPropertyKey(String key) {
    // Handle special cases first
    final specialCases = {
      'os_family': 'OS Family',
      'os_name': 'OS Name',
      'os_version': 'OS Version',
      'os_architecture': 'OS Architecture',
      'os_build': 'OS Build',
      'fqdn': 'FQDN',
      'cpu_cores': 'CPU Cores',
      'memory_gb': 'Memory (GB)',
      'total_disk_space_gb': 'Total Disk Space (GB)',
      'free_disk_space_gb': 'Free Disk Space (GB)',
      'bios_version': 'BIOS Version',
      'uac_enabled': 'UAC Enabled',
      'rdp_enabled': 'RDP Enabled',
      'smb_signing_required': 'SMB Signing Required',
      'ssl_enabled': 'SSL Enabled',
      'ssl_version': 'SSL Version',
      'api_endpoints': 'API Endpoints',
      'http_methods_allowed': 'HTTP Methods Allowed',
      'dns_servers': 'DNS Servers',
      'dhcp_enabled': 'DHCP Enabled',
      'vlan_id': 'VLAN ID',
      'mac_address': 'MAC Address',
      'ip_address': 'IP Address',
      'nac_enabled': 'NAC Enabled',
      'nac_type': 'NAC Type',
      'ips_enabled': 'IPS Enabled',
    };

    if (specialCases.containsKey(key)) {
      return specialCases[key]!;
    }

    // Handle OS-specific prefixes
    if (key.startsWith('windows_')) {
      String cleanKey = key.substring(8); // Remove 'windows_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'Windows $cleanKey';
    }

    if (key.startsWith('linux_')) {
      String cleanKey = key.substring(6); // Remove 'linux_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'Linux $cleanKey';
    }

    if (key.startsWith('macos_')) {
      String cleanKey = key.substring(6); // Remove 'macos_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'macOS $cleanKey';
    }

    // Handle service-specific prefixes
    if (key.startsWith('smb_')) {
      String cleanKey = key.substring(4); // Remove 'smb_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'SMB $cleanKey';
    }

    if (key.startsWith('ssh_')) {
      String cleanKey = key.substring(4); // Remove 'ssh_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'SSH $cleanKey';
    }

    if (key.startsWith('rdp_')) {
      String cleanKey = key.substring(4); // Remove 'rdp_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'RDP $cleanKey';
    }

    if (key.startsWith('ftp_')) {
      String cleanKey = key.substring(4); // Remove 'ftp_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'FTP $cleanKey';
    }

    if (key.startsWith('web_')) {
      String cleanKey = key.substring(4); // Remove 'web_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'Web $cleanKey';
    }

    if (key.startsWith('database_')) {
      String cleanKey = key.substring(9); // Remove 'database_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'Database $cleanKey';
    }

    if (key.startsWith('mail_')) {
      String cleanKey = key.substring(5); // Remove 'mail_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'Mail $cleanKey';
    }

    if (key.startsWith('dns_')) {
      String cleanKey = key.substring(4); // Remove 'dns_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'DNS $cleanKey';
    }

    if (key.startsWith('ldap_')) {
      String cleanKey = key.substring(5); // Remove 'ldap_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'LDAP $cleanKey';
    }

    if (key.startsWith('ad_')) {
      String cleanKey = key.substring(3); // Remove 'ad_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'Active Directory $cleanKey';
    }

    if (key.startsWith('snmp_')) {
      String cleanKey = key.substring(5); // Remove 'snmp_' prefix
      cleanKey = _formatBasicKey(cleanKey);
      return 'SNMP $cleanKey';
    }

    // Default formatting
    return _formatBasicKey(key);
  }

  String _formatBasicKey(String key) {
    return key.replaceAll('_', ' ').split(' ')
      .map((word) {
        // Handle common acronyms
        final acronyms = {'id', 'ip', 'dns', 'dhcp', 'ssl', 'tls', 'api', 'url', 'uri', 'http', 'https', 'ftp', 'ssh', 'rdp', 'smb', 'nac', 'ips', 'uac', 'sip'};
        if (acronyms.contains(word.toLowerCase())) {
          return word.toUpperCase();
        }
        return word[0].toUpperCase() + word.substring(1);
      })
      .join(' ');
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _saveAsset() {
    if (_formKey.currentState!.validate()) {
      // Update basic fields
      _editedAsset = _editedAsset.copyWith(
        name: _controllers['name']!.text,
        description: _controllers['description']!.text.isEmpty ? null : _controllers['description']!.text,
        lastUpdated: DateTime.now(),
      );

      // Update properties from controllers
      final updatedProperties = <String, AssetPropertyValue>{};
      for (final entry in _editedAsset.properties.entries) {
        final controller = _controllers[entry.key];
        if (controller != null) {
          // Convert based on original property type
          final updatedValue = entry.value.when(
            string: (_) => AssetPropertyValue.string(controller.text),
            integer: (_) => AssetPropertyValue.integer(int.tryParse(controller.text) ?? 0),
            double: (_) => AssetPropertyValue.double(double.tryParse(controller.text) ?? 0.0),
            boolean: (v) => AssetPropertyValue.boolean(v), // Already handled in UI
            stringList: (_) => AssetPropertyValue.stringList(
              controller.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()
            ),
            dateTime: (_) => AssetPropertyValue.dateTime(DateTime.tryParse(controller.text) ?? DateTime.now()),
            map: (v) => AssetPropertyValue.map(v), // Keep original for now
            objectList: (v) => AssetPropertyValue.objectList(v), // Keep original for now
          );
          updatedProperties[entry.key] = updatedValue;
        } else {
          updatedProperties[entry.key] = entry.value;
        }
      }

      _editedAsset = _editedAsset.copyWith(properties: updatedProperties);

      widget.onSave?.call(_editedAsset);
      Navigator.of(context).pop(_editedAsset);
    }
  }

  // === Enhanced Network Segment UI Methods ===

  Widget _buildNacTypeDropdown() {
    final currentValue = _editedAsset.getProperty<String>('nac_type') ?? 'none';

    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: const InputDecoration(
        labelText: 'NAC Type',
        border: OutlineInputBorder(),
        hintText: 'Select NAC implementation type',
      ),
      items: [
        const DropdownMenuItem(value: 'none', child: Text('None')),
        const DropdownMenuItem(value: 'dot1x', child: Text('802.1x Authentication')),
        const DropdownMenuItem(value: 'macAuth', child: Text('MAC Address Authentication')),
        const DropdownMenuItem(value: 'webAuth', child: Text('Web-based Authentication')),
        const DropdownMenuItem(value: 'hybrid', child: Text('Hybrid (Multiple Methods)')),
      ],
      onChanged: widget.isEditMode ? (value) {
        if (value != null) {
          setState(() {
            _editedAsset = _editedAsset.updateProperty('nac_type', AssetPropertyValue.string(value));
          });
        }
      } : null,
    );
  }

  Widget _buildFirewallRulesSection() {
    final firewallRules = _getObjectListProperty('firewall_rules');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Firewall Rules',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (widget.isEditMode)
              ElevatedButton.icon(
                onPressed: () => _showAddFirewallRuleDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Rule'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        if (firewallRules.isEmpty)
          _buildEmptyState('No firewall rules configured', Icons.security)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: firewallRules.length,
            itemBuilder: (context, index) => _buildFirewallRuleCard(firewallRules[index]),
          ),
      ],
    );
  }

  Widget _buildFirewallRuleCard(Map<String, dynamic> ruleData) {
    final action = ruleData['action'] as String? ?? 'allow';
    final enabled = ruleData['enabled'] as bool? ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          _getFirewallActionIcon(action),
          color: enabled ? _getFirewallActionColor(action) : Colors.grey,
        ),
        title: Text(ruleData['name'] as String? ?? 'Unnamed Rule'),
        subtitle: Text(
          '${ruleData['sourceNetwork'] ?? 'any'} → ${ruleData['destinationNetwork'] ?? 'any'} '
          '(${ruleData['protocol'] ?? 'any'}:${ruleData['ports'] ?? 'any'})',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!enabled)
              const Icon(Icons.pause_circle_outline, color: Colors.orange),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditFirewallRuleDialog(ruleData),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeFirewallRule(ruleData['id'] as String),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showEditFirewallRuleDialog(ruleData) : null,
      ),
    );
  }

  IconData _getFirewallActionIcon(String action) {
    switch (action) {
      case 'allow': return Icons.check_circle;
      case 'deny': return Icons.block;
      case 'drop': return Icons.delete;
      case 'log': return Icons.list_alt;
      default: return Icons.help;
    }
  }

  Color _getFirewallActionColor(String action) {
    switch (action) {
      case 'allow': return Colors.green;
      case 'deny': return Colors.red;
      case 'drop': return Colors.red.shade700;
      case 'log': return Colors.blue;
      default: return Colors.grey;
    }
  }

  void _showAddFirewallRuleDialog() {
    showDialog(
      context: context,
      builder: (context) => FirewallRuleDialog(
        onSave: (rule) {
          final rules = _getObjectListProperty('firewall_rules');
          rules.add(rule);
          _updateObjectListProperty('firewall_rules', rules);
        },
      ),
    );
  }

  void _showEditFirewallRuleDialog(Map<String, dynamic> ruleData) {
    showDialog(
      context: context,
      builder: (context) => FirewallRuleDialog(
        rule: ruleData,
        onSave: (updatedRule) {
          final rules = _getObjectListProperty('firewall_rules');
          final index = rules.indexWhere((r) => r['id'] == updatedRule['id']);
          if (index >= 0) {
            rules[index] = updatedRule;
            _updateObjectListProperty('firewall_rules', rules);
          }
        },
      ),
    );
  }

  void _removeFirewallRule(String ruleId) {
    final rules = _getObjectListProperty('firewall_rules');
    rules.removeWhere((rule) => rule['id'] == ruleId);
    _updateObjectListProperty('firewall_rules', rules);
  }

  Widget _buildNetworkAccessTypeDropdown() {
    final currentValue = _editedAsset.getProperty<String>('current_access_level') ?? 'none';

    return DropdownButtonFormField<String>(
      value: currentValue,
      decoration: const InputDecoration(
        labelText: 'Current Access Level',
        border: OutlineInputBorder(),
        hintText: 'What level of access do we have?',
      ),
      items: [
        const DropdownMenuItem(value: 'none', child: Text('🚫 No Access')),
        const DropdownMenuItem(value: 'external', child: Text('🌐 External (Internet/DMZ)')),
        const DropdownMenuItem(value: 'adjacent', child: Text('🔗 Adjacent Network')),
        const DropdownMenuItem(value: 'internal', child: Text('🏠 Internal Network')),
        const DropdownMenuItem(value: 'pivoted', child: Text('🔄 Pivoted Access')),
        const DropdownMenuItem(value: 'wireless', child: Text('📶 Wireless Access')),
        const DropdownMenuItem(value: 'physical', child: Text('🔌 Physical Access')),
      ],
      onChanged: widget.isEditMode ? (value) {
        if (value != null) {
          setState(() {
            _editedAsset = _editedAsset.updateProperty('current_access_level', AssetPropertyValue.string(value));
          });
        }
      } : null,
    );
  }

  Widget _buildAccessPointsSection() {
    final accessPoints = _getObjectListProperty('access_points');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Access Points',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (widget.isEditMode)
              ElevatedButton.icon(
                onPressed: () => _showAddAccessPointDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Access Point'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        if (accessPoints.isEmpty)
          _buildEmptyState('No access points configured', Icons.vpn_key)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: accessPoints.length,
            itemBuilder: (context, index) => _buildAccessPointCard(accessPoints[index]),
          ),
      ],
    );
  }

  Widget _buildAccessPointCard(Map<String, dynamic> accessPointData) {
    final accessType = accessPointData['accessType'] as String? ?? 'none';
    final active = accessPointData['active'] as bool? ?? true;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          _getAccessTypeIcon(accessType),
          color: active ? _getAccessTypeColor(accessType) : Colors.grey,
        ),
        title: Text(accessPointData['name'] as String? ?? 'Unnamed Access Point'),
        subtitle: Text(
          '${_formatAccessType(accessType)} • '
          '${accessPointData['description'] ?? 'No description'}',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!active)
              const Icon(Icons.pause_circle_outline, color: Colors.orange),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditAccessPointDialog(accessPointData),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeAccessPoint(accessPointData['id'] as String),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showEditAccessPointDialog(accessPointData) : null,
      ),
    );
  }

  Widget _buildNetworkHostsSection() {
    final networkHosts = _getObjectListProperty('network_hosts');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Network Hosts',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (widget.isEditMode)
              ElevatedButton.icon(
                onPressed: () => _showAddNetworkHostDialog(),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Host'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        if (networkHosts.isEmpty)
          _buildEmptyState('No hosts discovered', Icons.computer)
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: networkHosts.length,
            itemBuilder: (context, index) => _buildNetworkHostCard(networkHosts[index]),
          ),
      ],
    );
  }

  Widget _buildNetworkHostCard(Map<String, dynamic> hostData) {
    final isCompromised = hostData['isCompromised'] as bool? ?? false;
    final isGateway = hostData['isGateway'] as bool? ?? false;
    final hostname = hostData['hostname'] as String?;
    final ipAddress = hostData['ipAddress'] as String? ?? 'Unknown IP';

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          isGateway ? Icons.router : Icons.computer,
          color: isCompromised ? Colors.red : (isGateway ? Colors.blue : Colors.green),
        ),
        title: Text(hostname ?? ipAddress),
        subtitle: Text(
          '${ipAddress} • '
          '${isGateway ? 'Gateway • ' : ''}'
          '${isCompromised ? 'Compromised' : 'Discovered'}',
        ),
        trailing: widget.isEditMode ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCompromised)
              const Icon(Icons.warning, color: Colors.red),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _showEditNetworkHostDialog(hostData),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _removeNetworkHost(hostData['hostAssetId'] as String),
            ),
          ],
        ) : null,
        onTap: widget.isEditMode ? () => _showEditNetworkHostDialog(hostData) : null,
      ),
    );
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
      case 'external': return 'External';
      case 'adjacent': return 'Adjacent';
      case 'internal': return 'Internal';
      case 'pivoted': return 'Pivoted';
      case 'wireless': return 'Wireless';
      case 'physical': return 'Physical';
      default: return 'Unknown';
    }
  }

  void _showAddAccessPointDialog() {
    showDialog(
      context: context,
      builder: (context) => AccessPointDialog(
        onSave: (accessPoint) {
          final accessPoints = _getObjectListProperty('access_points');
          accessPoints.add(accessPoint);
          _updateObjectListProperty('access_points', accessPoints);
        },
      ),
    );
  }

  void _showEditAccessPointDialog(Map<String, dynamic> accessPointData) {
    showDialog(
      context: context,
      builder: (context) => AccessPointDialog(
        accessPointData: accessPointData,
        onSave: (updatedAccessPoint) {
          final accessPoints = _getObjectListProperty('access_points');
          final index = accessPoints.indexWhere((ap) => ap['id'] == updatedAccessPoint['id']);
          if (index >= 0) {
            accessPoints[index] = updatedAccessPoint;
            _updateObjectListProperty('access_points', accessPoints);
          }
        },
      ),
    );
  }

  void _removeAccessPoint(String accessPointId) {
    final accessPoints = _getObjectListProperty('access_points');
    accessPoints.removeWhere((ap) => ap['id'] == accessPointId);
    _updateObjectListProperty('access_points', accessPoints);
  }

  void _showAddNetworkHostDialog() {
    showDialog(
      context: context,
      builder: (context) => NetworkHostDialog(
        onSave: (hostData) {
          final hosts = _getObjectListProperty('network_hosts');
          hosts.add(hostData);
          _updateObjectListProperty('network_hosts', hosts);
        },
      ),
    );
  }

  void _showEditNetworkHostDialog(Map<String, dynamic> hostData) {
    showDialog(
      context: context,
      builder: (context) => NetworkHostDialog(
        hostData: hostData,
        onSave: (updatedHostData) {
          final hosts = _getObjectListProperty('network_hosts');
          final index = hosts.indexWhere((h) => h['hostAssetId'] == updatedHostData['hostAssetId']);
          if (index >= 0) {
            hosts[index] = updatedHostData;
            _updateObjectListProperty('network_hosts', hosts);
          }
        },
      ),
    );
  }

  void _removeNetworkHost(String hostAssetId) {
    final hosts = _getObjectListProperty('network_hosts');
    hosts.removeWhere((host) => host['hostAssetId'] == hostAssetId);
    _updateObjectListProperty('network_hosts', hosts);
  }

  /// Filter out properties that are already shown in specialized tabs
  Map<String, String> _filterSpecializedProperties(Map<String, String> schema, AssetType type) {
    final filteredSchema = Map<String, String>.from(schema);

    switch (type) {
      case AssetType.networkSegment:
        // Remove properties that appear in Security tab
        final securityTabProperties = {
          'nac_enabled',
          'nac_type',
          'nac_bypass_methods',
          'firewall_rules',
          'ips_enabled',
          'ips_signatures',
          'network_monitoring',
          'monitoring_tools',
          'security_policies',
        };

        // Remove properties that appear in Discovered Assets tab
        final discoveredAssetsTabProperties = {
          'access_points',
          'current_access_level',
          'compromised_hosts',
          'pivot_opportunities',
          'implants_deployed',
          'network_hosts',
          'network_devices',
          'wireless_aps',
          'unknown_devices',
          'connected_networks',
          'internet_access',
          'isolated',
        };

        // Remove all specialized properties
        for (final property in [...securityTabProperties, ...discoveredAssetsTabProperties]) {
          filteredSchema.remove(property);
        }
        break;

      case AssetType.host:
        // Remove properties that appear in Network tab
        final networkTabProperties = {
          'network_interfaces',
        };

        // Remove properties that appear in Services tab
        final servicesTabProperties = {
          'running_services',
        };

        // Remove properties that appear in Applications tab
        final applicationsTabProperties = {
          'installed_applications',
        };

        // Remove properties that appear in Security tab
        final securityTabProperties = {
          'antivirus_products',
          'host_firewall_enabled',
          'encryption_status',
          'secure_boot_enabled',
          'windows_uac_enabled',
          'windows_defender_enabled',
          'windows_rdp_enabled',
          'windows_admin_shares_enabled',
          'linux_selinux_status',
          'linux_sudo_rules',
          'linux_iptables_rules',
          'macos_sip_enabled',
          'macos_gatekeeper_enabled',
          'macos_filevault_enabled',
          'macos_xprotect_version',
          'missing_patches',
          'vulnerabilities',
          'configuration_issues',
          'compliance_frameworks',
          'security_score',
        };

        // Remove properties that appear in Access tab
        final accessTabProperties = {
          'user_accounts',
          'access_level',
          'privilege_escalation_possible',
          'cached_credentials',
          'stored_passwords',
        };

        // Remove all specialized properties
        for (final property in [
          ...networkTabProperties,
          ...servicesTabProperties,
          ...applicationsTabProperties,
          ...securityTabProperties,
          ...accessTabProperties
        ]) {
          filteredSchema.remove(property);
        }
        break;

      case AssetType.cloudTenant:
        // Remove properties that appear in Subscriptions tab
        final subscriptionsTabProperties = {
          'subscription_ids',
          'billing_account',
          'licensing_info',
        };

        // Remove properties that appear in Security tab
        final securityTabProperties = {
          'security_defaults_enabled',
          'mfa_enforcement',
          'conditional_access_policies',
        };

        // Remove all specialized properties
        for (final property in [...subscriptionsTabProperties, ...securityTabProperties]) {
          filteredSchema.remove(property);
        }
        break;

      case AssetType.wirelessNetwork:
        // Remove properties that appear in Clients tab
        final clientsTabProperties = {
          'connected_clients',
          'max_speed_mbps',
        };

        // Remove all specialized properties
        for (final property in clientsTabProperties) {
          filteredSchema.remove(property);
        }
        break;

      case AssetType.person:
        // Remove properties that appear in Security Profile tab
        final securityProfileTabProperties = {
          'security_awareness_level',
          'training_completed',
          'incident_history',
        };

        // Remove all specialized properties
        for (final property in securityProfileTabProperties) {
          filteredSchema.remove(property);
        }
        break;

      default:
        // For other asset types, don't filter anything
        break;
    }

    return filteredSchema;
  }
}