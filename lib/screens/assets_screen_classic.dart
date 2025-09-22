import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../providers/projects_provider.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../dialogs/enhanced_asset_dialog.dart';
import 'package:uuid/uuid.dart';

class AssetsScreenClassic extends ConsumerStatefulWidget {
  const AssetsScreenClassic({super.key});

  @override
  ConsumerState<AssetsScreenClassic> createState() => _AssetsScreenClassicState();
}

class _AssetsScreenClassicState extends ConsumerState<AssetsScreenClassic>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  AssetType? _selectedType;
  static const _uuid = Uuid();

  String generateAssetId() => _uuid.v4();

  final List<AssetPerspective> _perspectives = [
    AssetPerspective(
      name: 'Infrastructure',
      icon: Icons.account_tree,
      types: [
        AssetType.networkSegment,
        AssetType.host,
        AssetType.service,
      ],
    ),
    AssetPerspective(
      name: 'Identity & Access',
      icon: Icons.security,
      types: [
        AssetType.credential,
        AssetType.vulnerability,
      ],
    ),
    AssetPerspective(
      name: 'Wireless',
      icon: Icons.wifi,
      types: [
        AssetType.wireless_network,
      ],
    ),
    AssetPerspective(
      name: 'Domain',
      icon: Icons.domain,
      types: [
        AssetType.domain,
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _perspectives.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    final assetsAsync = ref.watch(assetsProvider(currentProject.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(assetNotifierProvider(currentProject.id).notifier).refresh();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'manual_asset':
                  _showAddAssetDialog(context, currentProject.id);
                  break;
                case 'import_assets':
                  _showImportDialog(context);
                  break;
                case 'export_assets':
                  _showExportDialog(context);
                  break;
                case 'visualize_relationships':
                  _showRelationshipVisualization(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'manual_asset',
                child: ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add Asset'),
                ),
              ),
              const PopupMenuItem(
                value: 'import_assets',
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Import Assets'),
                ),
              ),
              const PopupMenuItem(
                value: 'export_assets',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export Assets'),
                ),
              ),
              const PopupMenuItem(
                value: 'visualize_relationships',
                child: ListTile(
                  leading: Icon(Icons.account_tree),
                  title: Text('Visualize Relationships'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _perspectives.map((perspective) => Tab(
            icon: Icon(perspective.icon),
            text: perspective.name,
          )).toList(),
        ),
      ),
      body: assetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
              const SizedBox(height: 16),
              Text('Error loading assets: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(assetsProvider(currentProject.id)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (assets) => Column(
          children: [
            _buildStatsBar(assets),
            const Divider(height: 1),
            _buildFilters(),
            const Divider(height: 1),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: _perspectives.map((perspective) =>
                  _buildPerspectiveView(perspective, assets)
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(List<Asset> assets) {
    final stats = _calculateStats(assets);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip('Total', stats.total, Icons.folder_outlined, Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Networks', stats.networks, Icons.network_wifi, Colors.teal),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Hosts', stats.hosts, Icons.computer, Colors.blue),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Services', stats.services, Icons.cloud, Colors.green),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Credentials', stats.credentials, Icons.key, Colors.orange),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Wireless', stats.wireless, Icons.wifi, Colors.amber),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Domains', stats.domains, Icons.domain, Colors.purple),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Vulnerabilities', stats.vulnerabilities, Icons.security, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use column layout for narrow screens
          if (constraints.maxWidth < 800) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search assets...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<AssetType?>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All', overflow: TextOverflow.ellipsis),
                    ),
                    ...AssetType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        _formatAssetTypeName(type),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ],
            );
          }
          // Use row layout for wider screens
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search assets by name, type, or properties...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<AssetType?>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Types', overflow: TextOverflow.ellipsis),
                    ),
                    ...AssetType.values.map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        _formatAssetTypeName(type),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPerspectiveView(AssetPerspective perspective, List<Asset> allAssets) {
    final perspectiveAssets = allAssets.where((asset) =>
        perspective.types.contains(asset.type)
    ).toList();

    final filteredAssets = _applyFilters(perspectiveAssets);

    if (filteredAssets.isEmpty) {
      return _buildEmptyState(perspective);
    }

    return _buildHierarchicalAssetView(filteredAssets, perspective);
  }

  Widget _buildHierarchicalAssetView(List<Asset> assets, AssetPerspective perspective) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _buildSectionHeader('${perspective.name} Assets', assets.length),
        const SizedBox(height: AppSpacing.sm),
        ...assets.map((asset) => _buildAssetCard(asset)),
      ],
    );
  }

  Widget _buildAssetCard(Asset asset) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          _getAssetTypeIcon(asset.type),
          color: _getAssetTypeColor(asset.type),
        ),
        title: Text(
          asset.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAssetStatusRow(asset),
            if (asset.description != null) ...[
              const SizedBox(height: 4),
              Text(
                asset.description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleAssetAction(action, asset),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View Details')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'relationships', child: Text('View Relationships')),
            const PopupMenuItem(value: 'trigger', child: Text('Trigger Methodologies')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => _showAssetDetails(asset),
      ),
    );
  }

  Widget _buildAssetStatusRow(Asset asset) {
    return Row(
      children: [
        Chip(
          label: Text(
            _formatAssetTypeName(asset.type),
            style: const TextStyle(fontSize: 9),
          ),
          backgroundColor: _getAssetTypeColor(asset.type).withOpacity(0.1),
          side: BorderSide(color: _getAssetTypeColor(asset.type)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const Spacer(),
        Text(
          _formatDate(asset.discoveredAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '$title ($count)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AssetPerspective perspective) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            perspective.icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No ${perspective.name.toLowerCase()} assets found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Assets will appear here as they are discovered or manually added',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: () {
              final currentProject = ref.read(currentProjectProvider);
              if (currentProject != null) {
                _showAddAssetDialog(context, currentProject.id);
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Asset'),
          ),
        ],
      ),
    );
  }

  List<Asset> _applyFilters(List<Asset> assets) {
    return assets.where((asset) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final searchableText = [
          asset.name,
          asset.description ?? '',
          asset.type.name,
          ...asset.tags,
        ].join(' ').toLowerCase();

        if (!searchableText.contains(_searchQuery)) {
          return false;
        }
      }

      // Type filter
      if (_selectedType != null && asset.type != _selectedType) {
        return false;
      }

      return true;
    }).toList();
  }

  AssetStats _calculateStats(List<Asset> assets) {
    return AssetStats(
      total: assets.length,
      networks: assets.where((a) => a.type == AssetType.networkSegment).length,
      hosts: assets.where((a) => a.type == AssetType.host).length,
      services: assets.where((a) => a.type == AssetType.service).length,
      credentials: assets.where((a) => a.type == AssetType.credential).length,
      wireless: assets.where((a) => a.type == AssetType.wireless_network).length,
      domains: assets.where((a) => a.type == AssetType.domain).length,
      vulnerabilities: assets.where((a) => a.type == AssetType.vulnerability).length,
    );
  }

  // Helper methods for formatting and colors

  String _formatAssetTypeName(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return 'Network';
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
        return 'Wireless';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return Icons.router;
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.cloud;
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

  Color _getAssetTypeColor(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return Colors.teal;
      case AssetType.host:
        return Colors.blue;
      case AssetType.service:
        return Colors.green;
      case AssetType.credential:
        return Colors.orange;
      case AssetType.vulnerability:
        return Colors.red;
      case AssetType.domain:
        return Colors.purple;
      case AssetType.wireless_network:
        return Colors.amber;
    }
  }

  void _showAssetDetails(Asset asset) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    showDialog(
      context: context,
      builder: (context) => EnhancedAssetDialog(
        asset: asset,
        projectId: currentProject.id,
        mode: AssetDialogMode.view,
      ),
    );
  }

  void _handleAssetAction(String action, Asset asset) {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    final notifier = ref.read(assetNotifierProvider(currentProject.id).notifier);

    switch (action) {
      case 'view':
        _showAssetDetails(asset);
        break;
      case 'edit':
        _showAssetDetails(asset);
        break;
      case 'relationships':
        _showRelationshipVisualization(context);
        break;
      case 'trigger':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Triggering methodologies...')),
        );
        break;
      case 'delete':
        _confirmDeleteAsset(asset, notifier);
        break;
    }
  }

  void _confirmDeleteAsset(Asset asset, notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete "${asset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              notifier.deleteAsset(asset.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Asset "${asset.name}" deleted')),
              );
            },
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddAssetDialog(BuildContext context, String projectId) async {
    await showDialog(
      context: context,
      builder: (context) => EnhancedAssetDialog(
        projectId: projectId,
        mode: AssetDialogMode.create,
        initialType: AssetType.networkSegment, // Default to network segment
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import feature coming soon')),
    );
  }

  void _showExportDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export feature coming soon')),
    );
  }

  void _showRelationshipVisualization(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relationship visualization coming soon')),
    );
  }

}

class AssetPerspective {
  final String name;
  final IconData icon;
  final List<AssetType> types;

  const AssetPerspective({
    required this.name,
    required this.icon,
    required this.types,
  });
}

class AssetStats {
  final int total;
  final int networks;
  final int hosts;
  final int services;
  final int credentials;
  final int wireless;
  final int domains;
  final int vulnerabilities;

  const AssetStats({
    required this.total,
    required this.networks,
    required this.hosts,
    required this.services,
    required this.credentials,
    required this.wireless,
    required this.domains,
    required this.vulnerabilities,
  });
}