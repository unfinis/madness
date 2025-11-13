import 'package:flutter/material.dart';
import '../models/asset.dart';
import '../constants/app_spacing.dart';

/// Enhanced property editor with intelligent grouping and type-specific editors
class EnhancedAssetPropertyEditor extends StatefulWidget {
  final AssetType assetType;
  final Map<String, PropertyValue> properties;
  final void Function(Map<String, PropertyValue>) onPropertiesChanged;
  final bool readOnly;
  final GlobalKey<FormState>? formKey;

  const EnhancedAssetPropertyEditor({
    super.key,
    required this.assetType,
    required this.properties,
    required this.onPropertiesChanged,
    this.readOnly = false,
    this.formKey,
  });

  @override
  State<EnhancedAssetPropertyEditor> createState() => _EnhancedAssetPropertyEditorState();
}

class _EnhancedAssetPropertyEditorState extends State<EnhancedAssetPropertyEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, PropertyValue> _workingProperties;

  @override
  void initState() {
    super.initState();
    _workingProperties = Map.from(widget.properties);

    final sections = _getPropertySections();
    _tabController = TabController(length: sections.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sections = _getPropertySections();

    if (sections.isEmpty) {
      return const Center(child: Text('No properties available'));
    }

    final content = Column(
      children: [
        if (sections.length > 1)
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: sections.map((section) {
              return Tab(
                icon: Icon(section.icon),
                text: section.title,
              );
            }).toList(),
          ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: sections.map((section) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: _buildSectionContent(section),
              );
            }).toList(),
          ),
        ),
      ],
    );

    // Wrap in Form if a formKey is provided for validation
    if (widget.formKey != null) {
      return Form(
        key: widget.formKey,
        child: content,
      );
    }

    return content;
  }

  Widget _buildSectionContent(PropertySection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (section.description != null) ...[
          Text(
            section.description!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
        ...section.propertyKeys.map((key) {
          if (!_workingProperties.containsKey(key)) {
            return const SizedBox.shrink();
          }
          return _buildPropertyEditor(key, _workingProperties[key]!);
        }),
      ],
    );
  }

  Widget _buildPropertyEditor(String key, PropertyValue value) {
    final metadata = _getPropertyMetadata(key);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      metadata.label,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (metadata.helpText != null)
                      Text(
                        metadata.helpText!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                  ],
                ),
              ),
              if (!widget.readOnly && !metadata.required)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: () => _removeProperty(key),
                  tooltip: 'Remove property',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          value.when(
            string: (v) => _buildStringEditor(key, v, metadata),
            integer: (v) => _buildIntegerEditor(key, v, metadata),
            boolean: (v) => _buildBooleanEditor(key, v, metadata),
            stringList: (v) => _buildStringListEditor(key, v, metadata),
            map: (v) => _buildMapEditor(key, v, metadata),
            objectList: (v) => _buildObjectListEditor(key, v, metadata),
          ),
        ],
      ),
    );
  }

  Widget _buildStringEditor(String key, String value, PropertyMetadata metadata) {
    if (metadata.possibleValues != null && metadata.possibleValues!.isNotEmpty) {
      // Use dropdown for enum-like values
      return DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: metadata.placeholder,
        ),
        items: metadata.possibleValues!.map((v) {
          return DropdownMenuItem(
            value: v,
            child: Text(v),
          );
        }).toList(),
        validator: metadata.required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a value';
                }
                return null;
              }
            : null,
        onChanged: widget.readOnly
            ? null
            : (newValue) {
                _updateProperty(key, PropertyValue.string(newValue ?? ''));
              },
      );
    }

    // Regular text field
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: metadata.placeholder,
        prefixIcon: metadata.icon != null ? Icon(metadata.icon) : null,
      ),
      readOnly: widget.readOnly,
      maxLines: metadata.multiline ? 3 : 1,
      validator: metadata.required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              return null;
            }
          : null,
      onChanged: (newValue) {
        _updateProperty(key, PropertyValue.string(newValue));
      },
    );
  }

  Widget _buildIntegerEditor(String key, int value, PropertyMetadata metadata) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: metadata.placeholder,
        prefixIcon: metadata.icon != null ? Icon(metadata.icon) : null,
      ),
      keyboardType: TextInputType.number,
      readOnly: widget.readOnly,
      validator: metadata.required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return 'This field is required';
              }
              if (int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            }
          : (value) {
              if (value != null && value.isNotEmpty && int.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
      onChanged: (newValue) {
        final intValue = int.tryParse(newValue) ?? 0;
        _updateProperty(key, PropertyValue.integer(intValue));
      },
    );
  }

  Widget _buildBooleanEditor(String key, bool value, PropertyMetadata metadata) {
    return Card(
      child: SwitchListTile(
        title: Text(value ? 'Enabled' : 'Disabled'),
        subtitle: metadata.helpText != null ? Text(metadata.helpText!) : null,
        value: value,
        onChanged: widget.readOnly
            ? null
            : (newValue) {
                _updateProperty(key, PropertyValue.boolean(newValue));
              },
      ),
    );
  }

  Widget _buildStringListEditor(String key, List<String> values, PropertyMetadata metadata) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (values.isEmpty)
              Text(
                'No items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              )
            else
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: values.map((item) {
                  return Chip(
                    label: Text(item),
                    deleteIcon: widget.readOnly ? null : const Icon(Icons.close, size: 16),
                    onDeleted: widget.readOnly
                        ? null
                        : () {
                            final newList = List<String>.from(values)..remove(item);
                            _updateProperty(key, PropertyValue.stringList(newList));
                          },
                  );
                }).toList(),
              ),
            if (!widget.readOnly) ...[
              const SizedBox(height: AppSpacing.sm),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                onPressed: () => _showAddStringDialog(key, values, metadata),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMapEditor(String key, Map<String, dynamic> value, PropertyMetadata metadata) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (value.isEmpty)
              Text(
                'No entries',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              )
            else
              ...value.entries.map((entry) {
                return ListTile(
                  dense: true,
                  title: Text(entry.key),
                  subtitle: Text(entry.value.toString()),
                  trailing: widget.readOnly
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () {
                            final newMap = Map<String, dynamic>.from(value)..remove(entry.key);
                            _updateProperty(key, PropertyValue.map(newMap));
                          },
                        ),
                );
              }),
            if (!widget.readOnly) ...[
              const Divider(),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Entry'),
                onPressed: () => _showAddMapEntryDialog(key, value, metadata),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildObjectListEditor(String key, List<Map<String, dynamic>> values, PropertyMetadata metadata) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (values.isEmpty)
              Text(
                'No items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              )
            else
              ...values.asMap().entries.map((entry) {
                final index = entry.key;
                final obj = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    dense: true,
                    title: Text('Item ${index + 1}'),
                    subtitle: Text(
                      obj.entries.take(2).map((e) => '${e.key}: ${e.value}').join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: widget.readOnly
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () {
                              final newList = List<Map<String, dynamic>>.from(values)..removeAt(index);
                              _updateProperty(key, PropertyValue.objectList(newList));
                            },
                          ),
                    onTap: () => _showObjectEditor(key, values, index, metadata),
                  ),
                );
              }),
            if (!widget.readOnly) ...[
              const Divider(),
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Object'),
                onPressed: () => _showAddObjectDialog(key, values, metadata),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _updateProperty(String key, PropertyValue value) {
    setState(() {
      _workingProperties[key] = value;
    });
    widget.onPropertiesChanged(_workingProperties);
  }

  void _removeProperty(String key) {
    setState(() {
      _workingProperties.remove(key);
    });
    widget.onPropertiesChanged(_workingProperties);
  }

  void _showAddStringDialog(String key, List<String> currentValues, PropertyMetadata metadata) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${metadata.label}'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Value',
            hintText: metadata.placeholder,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                final newList = List<String>.from(currentValues)..add(controller.text);
                _updateProperty(key, PropertyValue.stringList(newList));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddMapEntryDialog(String key, Map<String, dynamic> currentMap, PropertyMetadata metadata) {
    final keyController = TextEditingController();
    final valueController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Entry to ${metadata.label}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(
                labelText: 'Key',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (keyController.text.isNotEmpty) {
                final newMap = Map<String, dynamic>.from(currentMap);
                newMap[keyController.text] = valueController.text;
                _updateProperty(key, PropertyValue.map(newMap));
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddObjectDialog(String key, List<Map<String, dynamic>> currentList, PropertyMetadata metadata) {
    // Simplified - just add an empty object for now
    final newList = List<Map<String, dynamic>>.from(currentList);
    newList.add({});
    _updateProperty(key, PropertyValue.objectList(newList));
  }

  void _showObjectEditor(String key, List<Map<String, dynamic>> currentList, int index, PropertyMetadata metadata) {
    // TODO: Implement detailed object editor
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Object editor not yet implemented')),
    );
  }

  List<PropertySection> _getPropertySections() {
    switch (widget.assetType) {
      case AssetType.networkSegment:
        return _getNetworkSegmentSections();
      case AssetType.host:
        return _getHostSections();
      case AssetType.service:
        return _getServiceSections();
      case AssetType.credential:
        return _getCredentialSections();
      case AssetType.activeDirectoryDomain:
        return _getAdDomainSections();
      case AssetType.domainController:
        return _getDomainControllerSections();
      default:
        return _getDefaultSections();
    }
  }

  List<PropertySection> _getNetworkSegmentSections() {
    return [
      PropertySection(
        title: 'Basic',
        icon: Icons.info_outline,
        description: 'Basic network segment information',
        propertyKeys: ['subnet', 'gateway', 'dns_servers', 'domain_name', 'vlan_id'],
      ),
      PropertySection(
        title: 'Security',
        icon: Icons.security,
        description: 'Security controls and NAC configuration',
        propertyKeys: [
          'nac_enabled',
          'nac_type',
          'access_level',
          'firewall_present',
          'ips_ids_present',
        ],
      ),
      PropertySection(
        title: 'Discovery',
        icon: Icons.search,
        description: 'Discovered assets and services',
        propertyKeys: [
          'live_hosts',
          'web_services',
          'smb_hosts',
          'domain_controllers',
        ],
      ),
      PropertySection(
        title: 'Credentials',
        icon: Icons.key,
        description: 'Available credentials and hashes',
        propertyKeys: [
          'credentials_available',
          'captured_hashes',
        ],
      ),
      PropertySection(
        title: 'Bypass',
        icon: Icons.lock_open,
        description: 'NAC bypass attempts and results',
        propertyKeys: [
          'bypass_methods_attempted',
          'bypass_methods_successful',
        ],
      ),
    ];
  }

  List<PropertySection> _getHostSections() {
    return [
      PropertySection(
        title: 'Basic',
        icon: Icons.info_outline,
        propertyKeys: ['ip_address', 'ipv6_address', 'hostname', 'fqdn', 'mac_address'],
      ),
      PropertySection(
        title: 'OS',
        icon: Icons.computer,
        propertyKeys: ['os_type', 'os_version', 'os_architecture'],
      ),
      PropertySection(
        title: 'Services',
        icon: Icons.power,
        propertyKeys: ['open_ports', 'services'],
      ),
      PropertySection(
        title: 'Security',
        icon: Icons.security,
        propertyKeys: [
          'smb_signing',
          'null_sessions',
          'rdp_enabled',
          'ssh_enabled',
        ],
      ),
      PropertySection(
        title: 'Access',
        icon: Icons.vpn_key,
        propertyKeys: [
          'credentials_valid',
          'shell_access',
          'privilege_level',
        ],
      ),
    ];
  }

  List<PropertySection> _getServiceSections() {
    return [
      PropertySection(
        title: 'Basic',
        icon: Icons.info_outline,
        propertyKeys: ['host', 'port', 'protocol', 'service_name', 'version', 'banner'],
      ),
      PropertySection(
        title: 'Web',
        icon: Icons.web,
        propertyKeys: ['web_technology', 'ssl_enabled', 'ssl_vulnerabilities'],
      ),
      PropertySection(
        title: 'Authentication',
        icon: Icons.lock,
        propertyKeys: [
          'auth_required',
          'auth_methods',
          'default_creds_tested',
          'weak_creds_found',
        ],
      ),
    ];
  }

  List<PropertySection> _getCredentialSections() {
    return [
      PropertySection(
        title: 'Credential',
        icon: Icons.key,
        propertyKeys: [
          'username',
          'password',
          'hash',
          'hash_type',
          'domain',
          'source',
          'privilege_level',
        ],
      ),
      PropertySection(
        title: 'Validation',
        icon: Icons.check_circle,
        propertyKeys: [
          'confirmed_hosts',
          'last_tested',
        ],
      ),
    ];
  }

  List<PropertySection> _getAdDomainSections() {
    return [
      PropertySection(
        title: 'Basic',
        icon: Icons.domain,
        propertyKeys: ['domain_name', 'forest_name', 'functional_level'],
      ),
      PropertySection(
        title: 'Infrastructure',
        icon: Icons.dns,
        propertyKeys: ['domain_controllers', 'trust_relationships'],
      ),
      PropertySection(
        title: 'Policy',
        icon: Icons.policy,
        propertyKeys: ['password_policy', 'fine_grained_password_policies'],
      ),
      PropertySection(
        title: 'Enumeration',
        icon: Icons.search,
        propertyKeys: [
          'valid_credentials_available',
          'enumeration_completed',
          'bloodhound_collected',
        ],
      ),
    ];
  }

  List<PropertySection> _getDomainControllerSections() {
    return [
      PropertySection(
        title: 'Basic',
        icon: Icons.dns,
        propertyKeys: ['hostname', 'ip_address', 'domain_name', 'operating_system'],
      ),
      PropertySection(
        title: 'Roles',
        icon: Icons.admin_panel_settings,
        propertyKeys: ['roles', 'global_catalog'],
      ),
      PropertySection(
        title: 'Services',
        icon: Icons.power,
        propertyKeys: [
          'ldap_enabled',
          'ldaps_enabled',
          'smb_signing_required',
          'ldap_anonymous_access',
        ],
      ),
      PropertySection(
        title: 'Vulnerabilities',
        icon: Icons.bug_report,
        propertyKeys: [
          'zerologon_vulnerable',
          'printnightmare_vulnerable',
        ],
      ),
    ];
  }

  List<PropertySection> _getDefaultSections() {
    final allKeys = _workingProperties.keys.toList()..sort();
    return [
      PropertySection(
        title: 'Properties',
        icon: Icons.list,
        propertyKeys: allKeys,
      ),
    ];
  }

  PropertyMetadata _getPropertyMetadata(String key) {
    // Define metadata for common properties
    final commonMetadata = <String, PropertyMetadata>{
      // Network
      'subnet': PropertyMetadata(
        label: 'Subnet',
        helpText: 'Network subnet in CIDR notation (e.g., 192.168.1.0/24)',
        placeholder: '192.168.1.0/24',
        icon: Icons.lan,
        required: true,
      ),
      'gateway': PropertyMetadata(
        label: 'Gateway',
        helpText: 'Default gateway IP address',
        placeholder: '192.168.1.1',
        icon: Icons.router,
      ),
      'ip_address': PropertyMetadata(
        label: 'IP Address',
        helpText: 'IPv4 address',
        placeholder: '192.168.1.10',
        icon: Icons.computer,
        required: true,
      ),
      'hostname': PropertyMetadata(
        label: 'Hostname',
        helpText: 'Computer hostname',
        placeholder: 'WKS-001',
        icon: Icons.label,
      ),

      // NAC
      'nac_enabled': PropertyMetadata(
        label: 'NAC Enabled',
        helpText: 'Network Access Control is enabled on this segment',
        icon: Icons.lock,
      ),
      'nac_type': PropertyMetadata(
        label: 'NAC Type',
        helpText: 'Type of NAC implementation',
        possibleValues: ['802.1x', 'web_auth', 'mac_auth', 'vpn'],
        icon: Icons.security,
      ),
      'access_level': PropertyMetadata(
        label: 'Access Level',
        helpText: 'Current network access level',
        possibleValues: ['blocked', 'limited', 'partial', 'full'],
        icon: Icons.traffic,
        required: true,
      ),

      // Service
      'port': PropertyMetadata(
        label: 'Port',
        helpText: 'Service port number',
        placeholder: '80',
        icon: Icons.power,
        required: true,
      ),
      'protocol': PropertyMetadata(
        label: 'Protocol',
        helpText: 'Network protocol',
        possibleValues: ['tcp', 'udp'],
        icon: Icons.swap_horiz,
      ),
      'service_name': PropertyMetadata(
        label: 'Service Name',
        helpText: 'Service identifier',
        placeholder: 'http',
        icon: Icons.label,
      ),

      // Credentials
      'username': PropertyMetadata(
        label: 'Username',
        helpText: 'Account username',
        placeholder: 'admin',
        icon: Icons.person,
        required: true,
      ),
      'password': PropertyMetadata(
        label: 'Password',
        helpText: 'Account password (if known)',
        placeholder: '**********',
        icon: Icons.password,
      ),
      'domain': PropertyMetadata(
        label: 'Domain',
        helpText: 'Domain name',
        placeholder: 'CORP',
        icon: Icons.domain,
      ),

      // OS
      'os_type': PropertyMetadata(
        label: 'OS Type',
        helpText: 'Operating system type',
        possibleValues: ['windows', 'linux', 'macos', 'unix', 'other'],
        icon: Icons.computer,
      ),
    };

    return commonMetadata[key] ??
        PropertyMetadata(
          label: _formatPropertyName(key),
          helpText: null,
        );
  }

  String _formatPropertyName(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Represents a section of properties
class PropertySection {
  final String title;
  final IconData icon;
  final String? description;
  final List<String> propertyKeys;

  PropertySection({
    required this.title,
    required this.icon,
    this.description,
    required this.propertyKeys,
  });
}

/// Metadata about a property for rendering
class PropertyMetadata {
  final String label;
  final String? helpText;
  final String? placeholder;
  final IconData? icon;
  final bool required;
  final bool multiline;
  final List<String>? possibleValues;

  PropertyMetadata({
    required this.label,
    this.helpText,
    this.placeholder,
    this.icon,
    this.required = false,
    this.multiline = false,
    this.possibleValues,
  });
}
