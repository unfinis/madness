import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';

class AssetRelationshipDialog extends ConsumerStatefulWidget {
  final Asset asset;
  final String projectId;

  const AssetRelationshipDialog({
    super.key,
    required this.asset,
    required this.projectId,
  });

  @override
  ConsumerState<AssetRelationshipDialog> createState() => _AssetRelationshipDialogState();
}

class _AssetRelationshipDialogState extends ConsumerState<AssetRelationshipDialog> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _relationshipTypes = [
    'contains',
    'connects_to',
    'depends_on',
    'hosts',
    'authenticates_to',
    'manages',
    'monitors',
    'accesses',
    'communicates_with',
  ];

  String _selectedRelationshipType = 'contains';
  Asset? _selectedTargetAsset;
  final TextEditingController _searchController = TextEditingController();
  List<Asset> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadAvailableAssets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailableAssets() async {
    final allAssets = await ref.read(assetServiceProvider(widget.projectId)).getAllAssets();
    setState(() {
      _filteredAssets = allAssets.where((asset) => asset.id != widget.asset.id).toList();
    });
  }

  void _filterAssets(String query) {
    setState(() {
      if (query.isEmpty) {
        _loadAvailableAssets();
      } else {
        _filteredAssets = _filteredAssets.where((asset) =>
          asset.name.toLowerCase().contains(query.toLowerCase()) ||
          asset.description?.toLowerCase().contains(query.toLowerCase()) == true
        ).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final relationshipsAsync = ref.watch(assetRelationshipsProvider((projectId: widget.projectId, assetId: widget.asset.id)));

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.account_tree, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Asset Relationships',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Manage relationships for: ${widget.asset.name}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.list), text: 'Existing Relationships'),
                Tab(icon: Icon(Icons.add), text: 'Add Relationship'),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildExistingRelationshipsTab(relationshipsAsync),
                  _buildAddRelationshipTab(),
                ],
              ),
            ),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingRelationshipsTab(AsyncValue<List<AssetRelationship>> relationshipsAsync) {
    return relationshipsAsync.when(
      data: (relationships) {
        if (relationships.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_tree_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No relationships found'),
                Text('Add relationships to see how assets connect'),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: relationships.length,
          itemBuilder: (context, index) {
            final relationship = relationships[index];
            return _buildRelationshipCard(relationship);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error loading relationships: $error'),
          ],
        ),
      ),
    );
  }

  Widget _buildRelationshipCard(AssetRelationship relationship) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getRelationshipIcon(relationship.relationshipType),
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatRelationshipDescription(relationship),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${relationship.relationshipType}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    'Created: ${_formatDateTime(relationship.createdAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (action) => _handleRelationshipAction(context, action, relationship),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRelationshipTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Relationship Type Selection
          Text(
            'Relationship Type',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedRelationshipType,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select relationship type',
            ),
            items: _relationshipTypes.map((type) => DropdownMenuItem(
              value: type,
              child: Row(
                children: [
                  Icon(_getRelationshipIcon(type), size: 20),
                  const SizedBox(width: 8),
                  Text(_formatRelationshipType(type)),
                ],
              ),
            )).toList(),
            onChanged: (value) {
              setState(() {
                _selectedRelationshipType = value!;
              });
            },
          ),

          const SizedBox(height: 24),

          // Target Asset Selection
          Text(
            'Target Asset',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Search for assets...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _filterAssets,
          ),

          const SizedBox(height: 16),

          // Asset List
          Container(
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              itemCount: _filteredAssets.length,
              itemBuilder: (context, index) {
                final asset = _filteredAssets[index];
                final isSelected = _selectedTargetAsset?.id == asset.id;

                return ListTile(
                  selected: isSelected,
                  leading: CircleAvatar(
                    backgroundColor: _getAssetTypeColor(asset.type),
                    radius: 16,
                    child: Icon(
                      _getAssetTypeIcon(asset.type),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  title: Text(asset.name),
                  subtitle: Text('${asset.type.name} • ${asset.properties.length} properties'),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                  onTap: () {
                    setState(() {
                      _selectedTargetAsset = isSelected ? null : asset;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Add Button
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _selectedTargetAsset != null ? _addRelationship : null,
                icon: const Icon(Icons.add),
                label: const Text('Add Relationship'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getRelationshipIcon(String relationshipType) {
    switch (relationshipType) {
      case 'contains':
        return Icons.folder;
      case 'connects_to':
        return Icons.cable;
      case 'depends_on':
        return Icons.arrow_forward;
      case 'hosts':
        return Icons.dns;
      case 'authenticates_to':
        return Icons.key;
      case 'manages':
        return Icons.settings;
      case 'monitors':
        return Icons.visibility;
      case 'accesses':
        return Icons.login;
      case 'communicates_with':
        return Icons.chat;
      default:
        return Icons.link;
    }
  }

  Color _getAssetTypeColor(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return Colors.blue;
      case AssetType.host:
        return Colors.green;
      case AssetType.service:
        return Colors.orange;
      case AssetType.credential:
        return Colors.purple;
      case AssetType.vulnerability:
        return Colors.red;
      case AssetType.domain:
        return Colors.indigo;
      case AssetType.wireless_network:
        return Colors.cyan;
      case AssetType.restrictedEnvironment:
        return Colors.deepOrange;
      case AssetType.securityControl:
        return Colors.teal;
      case AssetType.activeDirectoryDomain:
        return Colors.deepPurple;
      case AssetType.domainController:
        return Colors.indigo.shade700;
      case AssetType.adUser:
        return Colors.lightBlue;
      case AssetType.adComputer:
        return Colors.blueGrey;
      case AssetType.certificateAuthority:
        return Colors.amber;
      case AssetType.certificateTemplate:
        return Colors.amber.shade300;
      case AssetType.sccmServer:
        return Colors.pink;
      case AssetType.smbShare:
        return Colors.brown;
      case AssetType.kerberosTicket:
        return Colors.deepOrange.shade300;
      case AssetType.azureTenant:
        return Colors.lightBlue.shade800;
      case AssetType.azureSubscription:
        return Colors.lightBlue.shade700;
      case AssetType.azureVirtualMachine:
        return Colors.green.shade300;
      case AssetType.azureStorageAccount:
        return Colors.orange.shade300;
      case AssetType.azureKeyVault:
        return Colors.deepPurple.shade300;
      case AssetType.azureWebApp:
        return Colors.teal.shade300;
      case AssetType.azureFunctionApp:
        return Colors.green.shade600;
      case AssetType.azureDevOpsOrganization:
        return Colors.blue.shade600;
      case AssetType.azureSqlDatabase:
        return Colors.blue.shade700;
      case AssetType.azureContainerRegistry:
        return Colors.indigo.shade400;
      case AssetType.azureLogicApp:
        return Colors.purple.shade400;
      case AssetType.azureAutomationAccount:
        return Colors.grey.shade600;
      case AssetType.azureServicePrincipal:
        return Colors.cyan.shade600;
      case AssetType.azureManagedIdentity:
        return Colors.cyan.shade400;
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
      case AssetType.restrictedEnvironment:
        return Icons.security;
      case AssetType.securityControl:
        return Icons.shield;
      case AssetType.activeDirectoryDomain:
        return Icons.domain_verification;
      case AssetType.domainController:
        return Icons.dns;
      case AssetType.adUser:
        return Icons.person;
      case AssetType.adComputer:
        return Icons.desktop_windows;
      case AssetType.certificateAuthority:
        return Icons.verified;
      case AssetType.certificateTemplate:
        return Icons.card_membership;
      case AssetType.sccmServer:
        return Icons.settings_system_daydream;
      case AssetType.smbShare:
        return Icons.folder_shared;
      case AssetType.kerberosTicket:
        return Icons.confirmation_num;
      case AssetType.azureTenant:
        return Icons.cloud_outlined;
      case AssetType.azureSubscription:
        return Icons.cloud;
      case AssetType.azureVirtualMachine:
        return Icons.computer;
      case AssetType.azureStorageAccount:
        return Icons.storage;
      case AssetType.azureKeyVault:
        return Icons.lock;
      case AssetType.azureWebApp:
        return Icons.web;
      case AssetType.azureFunctionApp:
        return Icons.functions;
      case AssetType.azureDevOpsOrganization:
        return Icons.engineering;
      case AssetType.azureSqlDatabase:
        return Icons.storage;
      case AssetType.azureContainerRegistry:
        return Icons.inventory_2;
      case AssetType.azureLogicApp:
        return Icons.schema;
      case AssetType.azureAutomationAccount:
        return Icons.settings;
      case AssetType.azureServicePrincipal:
        return Icons.account_box;
      case AssetType.azureManagedIdentity:
        return Icons.fingerprint;
    }
  }

  String _formatRelationshipType(String type) {
    return type.replaceAll('_', ' ').toUpperCase();
  }

  String _formatRelationshipDescription(AssetRelationship relationship) {
    final isParent = relationship.parentAssetId == widget.asset.id;
    if (isParent) {
      return '${widget.asset.name} ${relationship.relationshipType.replaceAll('_', ' ')} [Target Asset]';
    } else {
      return '[Source Asset] ${relationship.relationshipType.replaceAll('_', ' ')} ${widget.asset.name}';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _addRelationship() async {
    if (_selectedTargetAsset == null) return;

    try {
      final relationship = AssetRelationship(
        parentAssetId: widget.asset.id,
        childAssetId: _selectedTargetAsset!.id,
        relationshipType: _selectedRelationshipType,
        createdAt: DateTime.now(),
      );

      await ref.read(assetServiceProvider(widget.projectId)).createAssetRelationship(relationship);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Relationship added successfully')),
        );

        // Reset form
        setState(() {
          _selectedTargetAsset = null;
          _searchController.clear();
        });
        _loadAvailableAssets();

        // Refresh relationships
        ref.invalidate(assetRelationshipsProvider((projectId: widget.projectId, assetId: widget.asset.id)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding relationship: $e')),
        );
      }
    }
  }

  void _handleRelationshipAction(BuildContext context, String action, AssetRelationship relationship) {
    switch (action) {
      case 'delete':
        _deleteRelationship(context, relationship);
        break;
    }
  }

  void _deleteRelationship(BuildContext context, AssetRelationship relationship) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Relationship'),
        content: const Text('Are you sure you want to delete this relationship? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(assetServiceProvider(widget.projectId)).deleteAssetRelationship(relationship);

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Relationship deleted successfully')),
                  );

                  // Refresh relationships
                  ref.invalidate(assetRelationshipsProvider((projectId: widget.projectId, assetId: widget.asset.id)));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting relationship: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}