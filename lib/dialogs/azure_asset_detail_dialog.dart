import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';

class AzureAssetDetailDialog extends ConsumerStatefulWidget {
  final String projectId;
  final Asset? asset;
  final AssetType? assetType;

  const AzureAssetDetailDialog({
    super.key,
    required this.projectId,
    this.asset,
    this.assetType,
  });

  @override
  ConsumerState<AzureAssetDetailDialog> createState() => _AzureAssetDetailDialogState();
}

class _AzureAssetDetailDialogState extends ConsumerState<AzureAssetDetailDialog> {
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
    _selectedAssetType = widget.assetType ?? widget.asset?.type ?? AssetType.azureTenant;
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
      case AssetType.azureTenant:
        return AssetPropertySchemas.azureTenantProperties;
      case AssetType.azureSubscription:
        return AssetPropertySchemas.azureSubscriptionProperties;
      case AssetType.azureStorageAccount:
        return AssetPropertySchemas.azureStorageAccountProperties;
      case AssetType.azureVirtualMachine:
        return AssetPropertySchemas.azureVirtualMachineProperties;
      case AssetType.azureKeyVault:
        return AssetPropertySchemas.azureKeyVaultProperties;
      case AssetType.azureWebApp:
        return AssetPropertySchemas.azureWebAppProperties;
      case AssetType.azureFunctionApp:
        return AssetPropertySchemas.azureFunctionAppProperties;
      case AssetType.azureDevOpsOrganization:
        return AssetPropertySchemas.azureDevOpsOrganizationProperties;
      case AssetType.azureSqlDatabase:
        return AssetPropertySchemas.azureSqlDatabaseProperties;
      case AssetType.azureContainerRegistry:
        return AssetPropertySchemas.azureContainerRegistryProperties;
      case AssetType.azureLogicApp:
        return AssetPropertySchemas.azureLogicAppProperties;
      case AssetType.azureAutomationAccount:
        return AssetPropertySchemas.azureAutomationAccountProperties;
      case AssetType.azureServicePrincipal:
        return AssetPropertySchemas.azureServicePrincipalProperties;
      case AssetType.azureManagedIdentity:
        return AssetPropertySchemas.azureManagedIdentityProperties;
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
        width: 800,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getAssetTypeIcon(_selectedAssetType),
                  size: 32,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _isEditing ? 'Edit ${_getAssetTypeName(_selectedAssetType)}' : 'Create ${_getAssetTypeName(_selectedAssetType)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                      _buildBasicInformation(),
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
                ElevatedButton(
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

  Widget _buildBasicInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (!_isEditing)
              DropdownButtonFormField<AssetType>(
                value: _selectedAssetType,
                decoration: const InputDecoration(
                  labelText: 'Asset Type',
                  border: OutlineInputBorder(),
                ),
                items: [
                  AssetType.azureTenant,
                  AssetType.azureSubscription,
                  AssetType.azureStorageAccount,
                  AssetType.azureVirtualMachine,
                  AssetType.azureKeyVault,
                  AssetType.azureWebApp,
                  AssetType.azureFunctionApp,
                  AssetType.azureDevOpsOrganization,
                  AssetType.azureSqlDatabase,
                  AssetType.azureContainerRegistry,
                  AssetType.azureLogicApp,
                  AssetType.azureAutomationAccount,
                  AssetType.azureServicePrincipal,
                  AssetType.azureManagedIdentity,
                ].map((type) => DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(_getAssetTypeIcon(type), size: 16),
                      const SizedBox(width: 8),
                      Text(_getAssetTypeName(type)),
                    ],
                  ),
                )).toList(),
                onChanged: (AssetType? value) {
                  if (value != null && value != _selectedAssetType) {
                    setState(() {
                      _selectedAssetType = value;
                      _initializePropertyControllers();
                    });
                  }
                },
                validator: (value) => value == null ? 'Please select an asset type' : null,
              ),
            if (!_isEditing) const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'Enter asset name',
                border: OutlineInputBorder(),
              ),
              validator: (value) => value?.isEmpty ?? true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertiesSection() {
    final properties = _getPropertySchemaForType(_selectedAssetType);
    if (properties.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Properties',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...properties.entries.map((entry) => _buildPropertyField(entry.key, entry.value)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyField(String key, String type) {
    switch (type) {
      case 'boolean':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CheckboxListTile(
            title: Text(_formatPropertyName(key)),
            value: _booleanProperties[key] ?? false,
            onChanged: (bool? value) {
              setState(() {
                _booleanProperties[key] = value ?? false;
              });
            },
          ),
        );
      case 'stringList':
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_formatPropertyName(key)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...(_listProperties[key] ?? []).map(
                    (value) => Chip(
                      label: Text(value),
                      deleteIcon: const Icon(Icons.close, size: 16),
                      onDeleted: () {
                        setState(() {
                          _listProperties[key]?.remove(value);
                        });
                      },
                    ),
                  ),
                  ActionChip(
                    label: const Text('Add'),
                    onPressed: () => _showAddListItemDialog(key),
                  ),
                ],
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TextFormField(
            controller: _propertyControllers[key],
            decoration: InputDecoration(
              labelText: _formatPropertyName(key),
              border: const OutlineInputBorder(),
            ),
          ),
        );
    }
  }

  String _formatPropertyName(String key) {
    return key.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }

  void _showAddListItemDialog(String key) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${_formatPropertyName(key)}'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter value',
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
                  _listProperties[key] ??= [];
                  _listProperties[key]!.add(controller.text);
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

    final properties = <String, PropertyValue>{};

    // Add string properties
    for (final entry in _propertyControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        properties[entry.key] = PropertyValue.string(entry.value.text);
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

    final asset = Asset(
      id: widget.asset?.id ?? const Uuid().v4(),
      type: _selectedAssetType,
      projectId: widget.projectId,
      name: _nameController.text,
      description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
      properties: properties,
      completedTriggers: widget.asset?.completedTriggers ?? [],
      triggerResults: widget.asset?.triggerResults ?? {},
      parentAssetIds: widget.asset?.parentAssetIds ?? [],
      childAssetIds: widget.asset?.childAssetIds ?? [],
      discoveredAt: widget.asset?.discoveredAt ?? DateTime.now(),
      lastUpdated: _isEditing ? DateTime.now() : null,
      discoveryMethod: widget.asset?.discoveryMethod,
      confidence: widget.asset?.confidence,
      tags: widget.asset?.tags ?? ['azure'],
    );

    final assetService = ref.read(assetServiceProvider(widget.projectId));
    if (_isEditing) {
      await assetService.updateAsset(asset);
    } else {
      await assetService.createAsset(asset);
    }

    if (mounted) {
      Navigator.of(context).pop(asset);
    }
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.azureTenant:
        return Icons.cloud;
      case AssetType.azureSubscription:
        return Icons.credit_card;
      case AssetType.azureStorageAccount:
        return Icons.storage;
      case AssetType.azureVirtualMachine:
        return Icons.computer;
      case AssetType.azureKeyVault:
        return Icons.vpn_key;
      case AssetType.azureWebApp:
        return Icons.web;
      case AssetType.azureFunctionApp:
        return Icons.functions;
      case AssetType.azureDevOpsOrganization:
        return Icons.work;
      case AssetType.azureSqlDatabase:
        return Icons.data_object;
      case AssetType.azureContainerRegistry:
        return Icons.inventory_2;
      case AssetType.azureLogicApp:
        return Icons.account_tree;
      case AssetType.azureAutomationAccount:
        return Icons.auto_awesome;
      case AssetType.azureServicePrincipal:
        return Icons.admin_panel_settings;
      case AssetType.azureManagedIdentity:
        return Icons.badge;
      default:
        return Icons.cloud;
    }
  }

  String _getAssetTypeName(AssetType type) {
    switch (type) {
      case AssetType.azureTenant:
        return 'Azure Tenant';
      case AssetType.azureSubscription:
        return 'Azure Subscription';
      case AssetType.azureStorageAccount:
        return 'Azure Storage Account';
      case AssetType.azureVirtualMachine:
        return 'Azure Virtual Machine';
      case AssetType.azureKeyVault:
        return 'Azure Key Vault';
      case AssetType.azureWebApp:
        return 'Azure Web App';
      case AssetType.azureFunctionApp:
        return 'Azure Function App';
      case AssetType.azureDevOpsOrganization:
        return 'Azure DevOps Organization';
      case AssetType.azureSqlDatabase:
        return 'Azure SQL Database';
      case AssetType.azureContainerRegistry:
        return 'Azure Container Registry';
      case AssetType.azureLogicApp:
        return 'Azure Logic App';
      case AssetType.azureAutomationAccount:
        return 'Azure Automation Account';
      case AssetType.azureServicePrincipal:
        return 'Azure Service Principal';
      case AssetType.azureManagedIdentity:
        return 'Azure Managed Identity';
      default:
        return 'Azure Asset';
    }
  }
}