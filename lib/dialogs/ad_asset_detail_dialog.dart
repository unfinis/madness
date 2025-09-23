import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';

class AdAssetDetailDialog extends ConsumerStatefulWidget {
  final String projectId;
  final Asset? asset;
  final AssetType? assetType;

  const AdAssetDetailDialog({
    super.key,
    required this.projectId,
    this.asset,
    this.assetType,
  });

  @override
  ConsumerState<AdAssetDetailDialog> createState() => _AdAssetDetailDialogState();
}

class _AdAssetDetailDialogState extends ConsumerState<AdAssetDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  late AssetType _selectedAssetType;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  final Map<String, TextEditingController> _propertyControllers = {};
  final Map<String, bool> _booleanProperties = {};
  final Map<String, List<String>> _listProperties = {};

  bool get _isEditing => widget.asset != null;

  @override
  void initState() {
    super.initState();
    _selectedAssetType = widget.assetType ?? widget.asset?.type ?? AssetType.activeDirectoryDomain;
    _nameController = TextEditingController(text: widget.asset?.name ?? '');
    _descriptionController = TextEditingController(text: widget.asset?.description ?? '');

    _initializePropertyControllers();
  }

  void _initializePropertyControllers() {
    final properties = _getPropertySchemaForType(_selectedAssetType);

    for (final entry in properties.entries) {
      final key = entry.key;
      final type = entry.value;

      if (type == 'boolean') {
        _booleanProperties[key] = widget.asset?.getProperty<bool>(key) ?? false;
      } else if (type == 'stringList') {
        _listProperties[key] = widget.asset?.getProperty<List<String>>(key) ?? [];
      } else {
        final value = widget.asset?.getProperty<dynamic>(key)?.toString() ?? '';
        _propertyControllers[key] = TextEditingController(text: value);
      }
    }
  }

  Map<String, String> _getPropertySchemaForType(AssetType type) {
    switch (type) {
      case AssetType.activeDirectoryDomain:
        return AssetPropertySchemas.activeDirectoryDomainProperties;
      case AssetType.domainController:
        return AssetPropertySchemas.domainControllerProperties;
      case AssetType.adUser:
        return AssetPropertySchemas.adUserProperties;
      case AssetType.adComputer:
        return AssetPropertySchemas.adComputerProperties;
      case AssetType.certificateAuthority:
        return AssetPropertySchemas.certificateAuthorityProperties;
      case AssetType.certificateTemplate:
        return AssetPropertySchemas.certificateTemplateProperties;
      case AssetType.sccmServer:
        return AssetPropertySchemas.sccmServerProperties;
      case AssetType.smbShare:
        return AssetPropertySchemas.smbShareProperties;
      case AssetType.kerberosTicket:
        return AssetPropertySchemas.kerberosTicketProperties;
      default:
        return {};
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (final controller in _propertyControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getAssetTypeIcon(_selectedAssetType)),
                const SizedBox(width: 12),
                Text(
                  _isEditing ? 'Edit ${_formatAssetTypeName(_selectedAssetType)}' : 'Add ${_formatAssetTypeName(_selectedAssetType)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isEditing) _buildAssetTypeSelector(),
                      _buildBasicInfoSection(),
                      const SizedBox(height: 24),
                      _buildPropertiesSection(),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _saveAsset,
                  child: Text(_isEditing ? 'Update' : 'Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Asset Type',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<AssetType>(
          value: _selectedAssetType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Select asset type',
          ),
          items: [
            AssetType.activeDirectoryDomain,
            AssetType.domainController,
            AssetType.adUser,
            AssetType.adComputer,
            AssetType.certificateAuthority,
            AssetType.certificateTemplate,
            AssetType.sccmServer,
            AssetType.smbShare,
            AssetType.kerberosTicket,
          ].map((type) => DropdownMenuItem(
            value: type,
            child: Row(
              children: [
                Icon(_getAssetTypeIcon(type), size: 20),
                const SizedBox(width: 8),
                Text(_formatAssetTypeName(type)),
              ],
            ),
          )).toList(),
          onChanged: (AssetType? newType) {
            if (newType != null && newType != _selectedAssetType) {
              setState(() {
                _selectedAssetType = newType;
                _propertyControllers.clear();
                _booleanProperties.clear();
                _listProperties.clear();
                _initializePropertyControllers();
              });
            }
          },
          validator: (value) => value == null ? 'Please select an asset type' : null,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
            hintText: 'Enter asset name',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description',
            border: OutlineInputBorder(),
            hintText: 'Enter asset description (optional)',
          ),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPropertiesSection() {
    final properties = _getPropertySchemaForType(_selectedAssetType);

    if (properties.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Properties',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        ...properties.entries.map((entry) {
          final key = entry.key;
          final type = entry.value;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPropertyField(key, type),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPropertyField(String key, String type) {
    final label = _formatPropertyLabel(key);

    switch (type) {
      case 'boolean':
        return Row(
          children: [
            Checkbox(
              value: _booleanProperties[key] ?? false,
              onChanged: (bool? value) {
                setState(() {
                  _booleanProperties[key] = value ?? false;
                });
              },
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(label)),
          ],
        );

      case 'integer':
        return TextFormField(
          controller: _propertyControllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (int.tryParse(value) == null) {
                return 'Must be a valid number';
              }
            }
            return null;
          },
        );

      case 'stringList':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ...(_listProperties[key] ?? []).asMap().entries.map((entry) {
                    final index = entry.key;
                    final value = entry.value;
                    return Row(
                      children: [
                        Expanded(child: Text(value)),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _listProperties[key]?.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Add new $label',
                            border: const OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _listProperties[key] ??= [];
                                _listProperties[key]!.add(value);
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          // Show add dialog
                          _showAddListItemDialog(key, label);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );

      default:
        return TextFormField(
          controller: _propertyControllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        );
    }
  }

  String _formatPropertyLabel(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  void _showAddListItemDialog(String key, String label) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $label'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter $label',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  _listProperties[key] ??= [];
                  _listProperties[key]!.add(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _saveAsset() {
    if (_formKey.currentState?.validate() ?? false) {
      final properties = <String, PropertyValue>{};

      // Add string properties
      for (final entry in _propertyControllers.entries) {
        final key = entry.key;
        final value = entry.value.text;
        if (value.isNotEmpty) {
          final schema = _getPropertySchemaForType(_selectedAssetType);
          final type = schema[key];

          if (type == 'integer') {
            final intValue = int.tryParse(value);
            if (intValue != null) {
              properties[key] = PropertyValue.integer(intValue);
            }
          } else {
            properties[key] = PropertyValue.string(value);
          }
        }
      }

      // Add boolean properties
      for (final entry in _booleanProperties.entries) {
        properties[entry.key] = PropertyValue.boolean(entry.value);
      }

      // Add list properties
      for (final entry in _listProperties.entries) {
        if (entry.value.isNotEmpty) {
          properties[entry.key] = PropertyValue.stringList(entry.value);
        }
      }

      if (_isEditing) {
        final updatedAsset = widget.asset!.copyWith(
          name: _nameController.text,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
          properties: {...widget.asset!.properties, ...properties},
          lastUpdated: DateTime.now(),
        );

        ref.read(assetNotifierProvider(widget.projectId).notifier).updateAsset(updatedAsset);
      } else {
        final asset = _createAssetFromType(
          _selectedAssetType,
          _nameController.text,
          _descriptionController.text.isEmpty ? null : _descriptionController.text,
          properties,
        );

        ref.read(assetNotifierProvider(widget.projectId).notifier).addAsset(asset);
      }

      Navigator.of(context).pop();
    }
  }

  Asset _createAssetFromType(AssetType type, String name, String? description, Map<String, PropertyValue> additionalProperties) {
    switch (type) {
      case AssetType.activeDirectoryDomain:
        return AssetFactory.createActiveDirectoryDomain(
          projectId: widget.projectId,
          domainName: name,
          additionalProperties: additionalProperties,
        ).copyWith(description: description);

      case AssetType.domainController:
        final ipAddress = additionalProperties['ip_address']?.when(
          string: (v) => v,
          integer: (v) => '',
          boolean: (v) => '',
          stringList: (v) => '',
          map: (v) => '',
          objectList: (v) => '',
        ) ?? '';
        final domain = additionalProperties['domain_name']?.when(
          string: (v) => v,
          integer: (v) => '',
          boolean: (v) => '',
          stringList: (v) => '',
          map: (v) => '',
          objectList: (v) => '',
        ) ?? '';

        return AssetFactory.createDomainController(
          projectId: widget.projectId,
          hostname: name,
          ipAddress: ipAddress,
          domainName: domain,
          additionalProperties: additionalProperties,
        ).copyWith(description: description);

      case AssetType.adUser:
        final domain = additionalProperties['domain_name']?.when(
          string: (v) => v,
          integer: (v) => '',
          boolean: (v) => '',
          stringList: (v) => '',
          map: (v) => '',
          objectList: (v) => '',
        ) ?? 'DOMAIN';

        return AssetFactory.createAdUser(
          projectId: widget.projectId,
          username: name,
          domainName: domain,
          additionalProperties: additionalProperties,
        ).copyWith(description: description);

      case AssetType.adComputer:
        final domain = additionalProperties['domain_name']?.when(
          string: (v) => v,
          integer: (v) => '',
          boolean: (v) => '',
          stringList: (v) => '',
          map: (v) => '',
          objectList: (v) => '',
        ) ?? 'DOMAIN';

        return AssetFactory.createAdComputer(
          projectId: widget.projectId,
          hostname: name,
          domainName: domain,
          additionalProperties: additionalProperties,
        ).copyWith(description: description);

      case AssetType.certificateAuthority:
        final server = additionalProperties['ca_server']?.when(
          string: (v) => v,
          integer: (v) => '',
          boolean: (v) => '',
          stringList: (v) => '',
          map: (v) => '',
          objectList: (v) => '',
        ) ?? name;

        return AssetFactory.createCertificateAuthority(
          projectId: widget.projectId,
          caName: name,
          caServer: server,
          additionalProperties: additionalProperties,
        ).copyWith(description: description);

      case AssetType.sccmServer:
        final siteCode = additionalProperties['site_code']?.when(
          string: (v) => v,
          integer: (v) => '',
          boolean: (v) => '',
          stringList: (v) => '',
          map: (v) => '',
          objectList: (v) => '',
        ) ?? 'SCM';

        return AssetFactory.createSccmServer(
          projectId: widget.projectId,
          serverHostname: name,
          siteCode: siteCode,
          additionalProperties: additionalProperties,
        ).copyWith(description: description);

      default:
        // Generic asset creation
        return Asset(
          id: const Uuid().v4(),
          type: type,
          projectId: widget.projectId,
          name: name,
          description: description,
          properties: additionalProperties,
          completedTriggers: [],
          triggerResults: {},
          parentAssetIds: [],
          childAssetIds: [],
          discoveredAt: DateTime.now(),
          tags: ['ad'],
        );
    }
  }

  String _formatAssetTypeName(AssetType type) {
    switch (type) {
      case AssetType.activeDirectoryDomain:
        return 'AD Domain';
      case AssetType.domainController:
        return 'Domain Controller';
      case AssetType.adUser:
        return 'AD User';
      case AssetType.adComputer:
        return 'AD Computer';
      case AssetType.certificateAuthority:
        return 'Certificate Authority';
      case AssetType.certificateTemplate:
        return 'Certificate Template';
      case AssetType.sccmServer:
        return 'SCCM Server';
      case AssetType.smbShare:
        return 'SMB Share';
      case AssetType.kerberosTicket:
        return 'Kerberos Ticket';
      default:
        return type.name;
    }
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.activeDirectoryDomain:
        return Icons.domain_verification;
      case AssetType.domainController:
        return Icons.dns;
      case AssetType.adUser:
        return Icons.person;
      case AssetType.adComputer:
        return Icons.desktop_windows;
      case AssetType.certificateAuthority:
        return Icons.verified_user;
      case AssetType.certificateTemplate:
        return Icons.description;
      case AssetType.sccmServer:
        return Icons.settings_applications;
      case AssetType.smbShare:
        return Icons.folder_shared;
      case AssetType.kerberosTicket:
        return Icons.confirmation_number;
      default:
        return Icons.help;
    }
  }
}