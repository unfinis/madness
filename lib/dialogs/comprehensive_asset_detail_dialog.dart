import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';

enum AssetDialogMode { view, create, edit }

class ComprehensiveAssetDetailDialog extends ConsumerStatefulWidget {
  final Asset? asset;
  final String projectId;
  final AssetDialogMode mode;
  final AssetType? initialAssetType;

  const ComprehensiveAssetDetailDialog({
    super.key,
    this.asset,
    required this.projectId,
    required this.mode,
    this.initialAssetType,
  });

  @override
  ConsumerState<ComprehensiveAssetDetailDialog> createState() => _ComprehensiveAssetDetailDialogState();
}

class _ComprehensiveAssetDetailDialogState extends ConsumerState<ComprehensiveAssetDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _uuid = const Uuid();

  AssetType? _selectedAssetType;
  Map<String, PropertyValue> _properties = {};
  List<String> _tags = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAssetType = widget.initialAssetType ?? widget.asset?.type;

    if (widget.asset != null) {
      _nameController.text = widget.asset!.name;
      _descriptionController.text = widget.asset!.description ?? '';
      _properties = Map.from(widget.asset!.properties);
      _tags = List.from(widget.asset!.tags);
    } else {
      _initializeDefaultProperties();
    }
  }

  void _initializeDefaultProperties() {
    if (_selectedAssetType != null) {
      _properties = _getDefaultPropertiesForType(_selectedAssetType!);
    }
  }

  Map<String, PropertyValue> _getDefaultPropertiesForType(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return {
          'subnet': const PropertyValue.string(''),
          'gateway': const PropertyValue.string(''),
          'dns_servers': const PropertyValue.stringList([]),
          'nac_enabled': const PropertyValue.boolean(false),
          'access_level': const PropertyValue.string('blocked'),
          'live_hosts': const PropertyValue.stringList([]),
          'web_services': const PropertyValue.objectList([]),
          'credentials_available': const PropertyValue.objectList([]),
        };
      case AssetType.host:
        return {
          'ip_address': const PropertyValue.string(''),
          'hostname': const PropertyValue.string(''),
          'os_type': const PropertyValue.string(''),
          'open_ports': const PropertyValue.stringList([]),
          'services': const PropertyValue.objectList([]),
          'privilege_level': const PropertyValue.string('none'),
        };
      case AssetType.service:
        return {
          'host': const PropertyValue.string(''),
          'port': const PropertyValue.integer(80),
          'protocol': const PropertyValue.string('tcp'),
          'service_name': const PropertyValue.string(''),
          'version': const PropertyValue.string(''),
          'ssl_enabled': const PropertyValue.boolean(false),
        };
      case AssetType.credential:
        return {
          'username': const PropertyValue.string(''),
          'password': const PropertyValue.string(''),
          'hash': const PropertyValue.string(''),
          'domain': const PropertyValue.string(''),
          'source': const PropertyValue.string(''),
          'confirmed_hosts': const PropertyValue.stringList([]),
        };
      case AssetType.vulnerability:
        return {
          'cve_id': const PropertyValue.string(''),
          'severity': const PropertyValue.string('medium'),
          'description': const PropertyValue.string(''),
          'affected_hosts': const PropertyValue.stringList([]),
          'exploitable': const PropertyValue.boolean(false),
        };
      case AssetType.domain:
        return {
          'domain_name': const PropertyValue.string(''),
          'domain_controllers': const PropertyValue.stringList([]),
          'trust_relationships': const PropertyValue.objectList([]),
          'users': const PropertyValue.stringList([]),
          'computers': const PropertyValue.stringList([]),
        };
      case AssetType.wireless_network:
        return {
          'ssid': const PropertyValue.string(''),
          'bssid': const PropertyValue.string(''),
          'security': const PropertyValue.string(''),
          'channel': const PropertyValue.integer(1),
          'signal_strength': const PropertyValue.integer(-50),
          'encryption': const PropertyValue.string(''),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final isViewMode = widget.mode == AssetDialogMode.view;
    final isCreateMode = widget.mode == AssetDialogMode.create;

    return Dialog(
      child: Container(
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  _getAssetTypeIcon(_selectedAssetType ?? AssetType.host),
                  size: 32,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCreateMode ? 'Create Asset' : isViewMode ? 'Asset Details' : 'Edit Asset',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (_selectedAssetType != null)
                        Text(
                          _selectedAssetType!.name,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
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
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveAsset,
                        child: Text(isCreateMode ? 'Create' : 'Save'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Re-open in edit mode
                          showDialog(
                            context: context,
                            builder: (context) => ComprehensiveAssetDetailDialog(
                              asset: widget.asset,
                              projectId: widget.projectId,
                              mode: AssetDialogMode.edit,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Basic Information
                      _buildBasicInfoSection(isViewMode),
                      const SizedBox(height: 24),

                      // Properties
                      _buildPropertiesSection(isViewMode),
                      const SizedBox(height: 24),

                      // Tags
                      _buildTagsSection(isViewMode),

                      if (widget.asset != null) ...[
                        const SizedBox(height: 24),
                        _buildMetadataSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(bool isViewMode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (!isViewMode && widget.mode == AssetDialogMode.create)
              DropdownButtonFormField<AssetType>(
                value: _selectedAssetType,
                decoration: const InputDecoration(
                  labelText: 'Asset Type',
                  border: OutlineInputBorder(),
                ),
                items: AssetType.values.map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type.name),
                )).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAssetType = value;
                    _initializeDefaultProperties();
                  });
                },
                validator: (value) => value == null ? 'Please select an asset type' : null,
              ),
            if (!isViewMode && widget.mode == AssetDialogMode.create)
              const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              readOnly: isViewMode,
              validator: (value) => value?.isEmpty == true ? 'Please enter a name' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              readOnly: isViewMode,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesSection(bool isViewMode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Properties',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (!isViewMode)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addCustomProperty,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_properties.isEmpty)
              const Text('No properties defined')
            else
              ..._properties.entries.map((entry) => _buildPropertyField(
                entry.key,
                entry.value,
                isViewMode,
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyField(String key, PropertyValue value, bool isViewMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              key,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: value.when(
              string: (v) => TextFormField(
                initialValue: v,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffix: !isViewMode ? IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => _removeProperty(key),
                  ) : null,
                ),
                readOnly: isViewMode,
                onChanged: (newValue) => _updateProperty(key, PropertyValue.string(newValue)),
              ),
              integer: (v) => TextFormField(
                initialValue: v.toString(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffix: !isViewMode ? IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => _removeProperty(key),
                  ) : null,
                ),
                keyboardType: TextInputType.number,
                readOnly: isViewMode,
                onChanged: (newValue) {
                  final intValue = int.tryParse(newValue) ?? 0;
                  _updateProperty(key, PropertyValue.integer(intValue));
                },
              ),
              boolean: (v) => isViewMode
                ? Text(v ? 'Yes' : 'No')
                : Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          title: Text(v ? 'Yes' : 'No'),
                          value: v,
                          onChanged: (newValue) => _updateProperty(key, PropertyValue.boolean(newValue ?? false)),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16),
                        onPressed: () => _removeProperty(key),
                      ),
                    ],
                  ),
              stringList: (v) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...v.map((item) => Chip(
                    label: Text(item),
                    deleteIcon: isViewMode ? null : const Icon(Icons.close, size: 16),
                    onDeleted: isViewMode ? null : () {
                      final newList = List<String>.from(v)..remove(item);
                      _updateProperty(key, PropertyValue.stringList(newList));
                    },
                  )),
                  if (!isViewMode)
                    TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add item'),
                      onPressed: () => _showAddStringDialog(key, v),
                    ),
                ],
              ),
              map: (v) => isViewMode
                ? Text('Map with ${v.length} entries')
                : Text('Map editing not implemented'),
              objectList: (v) => isViewMode
                ? Text('${v.length} objects')
                : Text('Object list editing not implemented'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(bool isViewMode) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Tags',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (!isViewMode)
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTag,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_tags.isEmpty)
              const Text('No tags')
            else
              Wrap(
                spacing: 8,
                children: _tags.map((tag) => Chip(
                  label: Text(tag),
                  deleteIcon: isViewMode ? null : const Icon(Icons.close, size: 16),
                  onDeleted: isViewMode ? null : () {
                    setState(() {
                      _tags.remove(tag);
                    });
                  },
                )).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataSection() {
    final asset = widget.asset!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Metadata',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildMetadataRow('Asset ID', asset.id),
            _buildMetadataRow('Project ID', asset.projectId),
            _buildMetadataRow('Discovered', asset.discoveredAt.toString().substring(0, 16)),
            if (asset.lastUpdated != null)
              _buildMetadataRow('Last Updated', asset.lastUpdated.toString().substring(0, 16)),
            if (asset.confidence != null)
              _buildMetadataRow('Confidence', '${(asset.confidence! * 100).toStringAsFixed(1)}%'),
            _buildMetadataRow('Completed Triggers', asset.completedTriggers.length.toString()),
            _buildMetadataRow('Trigger Results', asset.triggerResults.length.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _updateProperty(String key, PropertyValue value) {
    setState(() {
      _properties[key] = value;
    });
  }

  void _removeProperty(String key) {
    setState(() {
      _properties.remove(key);
    });
  }

  void _addCustomProperty() {
    showDialog(
      context: context,
      builder: (context) => _AddPropertyDialog(
        onPropertyAdded: (key, value) {
          setState(() {
            _properties[key] = value;
          });
        },
      ),
    );
  }

  void _showAddStringDialog(String propertyKey, List<String> currentList) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add item to $propertyKey'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Value',
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
              if (controller.text.isNotEmpty) {
                final newList = List<String>.from(currentList)..add(controller.text);
                _updateProperty(propertyKey, PropertyValue.stringList(newList));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _addTag() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Tag',
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
              if (controller.text.isNotEmpty) {
                setState(() {
                  _tags.add(controller.text);
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

  Future<void> _saveAsset() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedAssetType == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final asset = Asset(
        id: widget.asset?.id ?? _uuid.v4(),
        type: _selectedAssetType!,
        projectId: widget.projectId,
        name: _nameController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        properties: _properties,
        completedTriggers: widget.asset?.completedTriggers ?? [],
        triggerResults: widget.asset?.triggerResults ?? {},
        parentAssetIds: widget.asset?.parentAssetIds ?? [],
        childAssetIds: widget.asset?.childAssetIds ?? [],
        discoveredAt: widget.asset?.discoveredAt ?? DateTime.now(),
        lastUpdated: DateTime.now(),
        confidence: widget.asset?.confidence,
        tags: _tags,
      );

      if (widget.mode == AssetDialogMode.create) {
        await ref.read(assetNotifierProvider(widget.projectId).notifier).addAsset(asset);
      } else {
        await ref.read(assetNotifierProvider(widget.projectId).notifier).updateAsset(asset);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Asset ${widget.mode == AssetDialogMode.create ? 'created' : 'updated'} successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

class _AddPropertyDialog extends StatefulWidget {
  final Function(String key, PropertyValue value) onPropertyAdded;

  const _AddPropertyDialog({required this.onPropertyAdded});

  @override
  State<_AddPropertyDialog> createState() => _AddPropertyDialogState();
}

class _AddPropertyDialogState extends State<_AddPropertyDialog> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  String _selectedType = 'string';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Property'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              labelText: 'Property Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Type',
              border: OutlineInputBorder(),
            ),
            items: ['string', 'integer', 'boolean'].map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
          const SizedBox(height: 16),
          if (_selectedType == 'boolean')
            DropdownButtonFormField<bool>(
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: true, child: Text('True')),
                DropdownMenuItem(value: false, child: Text('False')),
              ],
              onChanged: (value) {
                _valueController.text = value.toString();
              },
            )
          else
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                border: OutlineInputBorder(),
              ),
              keyboardType: _selectedType == 'integer' ? TextInputType.number : TextInputType.text,
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
            if (_keyController.text.isNotEmpty && _valueController.text.isNotEmpty) {
              PropertyValue value;
              switch (_selectedType) {
                case 'integer':
                  value = PropertyValue.integer(int.tryParse(_valueController.text) ?? 0);
                  break;
                case 'boolean':
                  value = PropertyValue.boolean(_valueController.text.toLowerCase() == 'true');
                  break;
                default:
                  value = PropertyValue.string(_valueController.text);
              }
              widget.onPropertyAdded(_keyController.text, value);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}