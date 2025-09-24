import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../providers/projects_provider.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
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
      ],
    ),
    AssetPerspective(
      name: 'Services',
      icon: Icons.dns,
      types: [
        AssetType.service,
        AssetType.azureSqlDatabase,
        AssetType.azureDevOpsOrganization,
      ],
    ),
    AssetPerspective(
      name: 'Web Services',
      icon: Icons.web,
      types: [
        AssetType.azureWebApp,
        AssetType.azureFunctionApp,
        AssetType.azureLogicApp,
        AssetType.azureContainerRegistry,
      ],
    ),
    AssetPerspective(
      name: 'Cloud Resources',
      icon: Icons.cloud,
      types: [
        AssetType.azureTenant,
        AssetType.azureSubscription,
        AssetType.azureStorageAccount,
        AssetType.azureVirtualMachine,
        AssetType.azureKeyVault,
        AssetType.azureAutomationAccount,
        AssetType.azureServicePrincipal,
        AssetType.azureManagedIdentity,
      ],
    ),
    AssetPerspective(
      name: 'Identity & Access',
      icon: Icons.security,
      types: [
        AssetType.credential,
        AssetType.vulnerability,
        AssetType.kerberosTicket,
      ],
    ),
    AssetPerspective(
      name: 'Active Directory',
      icon: Icons.domain_verification,
      types: [
        AssetType.activeDirectoryDomain,
        AssetType.domainController,
        AssetType.adUser,
        AssetType.adComputer,
      ],
    ),
    AssetPerspective(
      name: 'PKI & Management',
      icon: Icons.verified_user,
      types: [
        AssetType.certificateAuthority,
        AssetType.certificateTemplate,
        AssetType.sccmServer,
        AssetType.smbShare,
      ],
    ),
    AssetPerspective(
      name: 'Wireless & Other',
      icon: Icons.wifi,
      types: [
        AssetType.wireless_network,
        AssetType.domain,
        AssetType.restrictedEnvironment,
        AssetType.securityControl,
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
      body: assetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
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
        data: (assets) => SafeArea(
          child: Column(
            children: [
              _buildStatsBar(assets),
              const Divider(height: 1),
              _buildFilters(),
              const Divider(height: 1),
              Material(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: _perspectives.map((perspective) => Tab(
                    icon: Icon(perspective.icon),
                    text: perspective.name,
                  )).toList(),
                ),
              ),
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
      ),
    );
  }

  Widget _buildStatsBar(List<Asset> assets) {
    final stats = _calculateStats(assets);

    final statsData = [
      StatData(
        label: 'Total',
        count: stats.total,
        icon: Icons.folder_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      StatData(
        label: 'Networks',
        count: stats.networks,
        icon: Icons.network_wifi,
        color: Colors.teal,
      ),
      StatData(
        label: 'Hosts',
        count: stats.hosts,
        icon: Icons.computer,
        color: Colors.blue,
      ),
      StatData(
        label: 'Services',
        count: stats.services,
        icon: Icons.cloud,
        color: Colors.green,
      ),
      StatData(
        label: 'Credentials',
        count: stats.credentials,
        icon: Icons.key,
        color: Colors.orange,
      ),
      StatData(
        label: 'Wireless',
        count: stats.wireless,
        icon: Icons.wifi,
        color: Colors.amber,
      ),
      StatData(
        label: 'Domains',
        count: stats.domains,
        icon: Icons.domain,
        color: Colors.purple,
      ),
      StatData(
        label: 'Vulnerabilities',
        count: stats.vulnerabilities,
        icon: Icons.security,
        color: Colors.red,
      ),
    ];

    return StandardStatsBar(chips: StatsHelper.buildChips(statsData));
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
          backgroundColor: _getAssetTypeColor(asset.type).withValues(alpha: 0.1),
          side: BorderSide(color: _getAssetTypeColor(asset.type)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const Spacer(),
        Text(
          _formatDate(asset.discoveredAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
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
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No ${perspective.name.toLowerCase()} assets found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Assets will appear here as they are discovered or manually added',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          IconButton.filled(
            onPressed: () {
              final currentProject = ref.read(currentProjectProvider);
              if (currentProject != null) {
                _showAddAssetDialog(context, currentProject.id);
              }
            },
            icon: const Icon(Icons.add),
            tooltip: 'Add Asset',
            iconSize: 32,
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
      case AssetType.restrictedEnvironment:
        return 'Restricted';
      case AssetType.securityControl:
        return 'Security Control';
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
      // Azure asset types
      case AssetType.azureTenant:
        return 'Azure Tenant';
      case AssetType.azureSubscription:
        return 'Azure Subscription';
      case AssetType.azureStorageAccount:
        return 'Storage Account';
      case AssetType.azureVirtualMachine:
        return 'Virtual Machine';
      case AssetType.azureKeyVault:
        return 'Key Vault';
      case AssetType.azureWebApp:
        return 'Web App';
      case AssetType.azureFunctionApp:
        return 'Function App';
      case AssetType.azureDevOpsOrganization:
        return 'DevOps Org';
      case AssetType.azureSqlDatabase:
        return 'SQL Database';
      case AssetType.azureContainerRegistry:
        return 'Container Registry';
      case AssetType.azureLogicApp:
        return 'Logic App';
      case AssetType.azureAutomationAccount:
        return 'Automation Account';
      case AssetType.azureServicePrincipal:
        return 'Service Principal';
      case AssetType.azureManagedIdentity:
        return 'Managed Identity';
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
      case AssetType.restrictedEnvironment:
        return Icons.lock;
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
        return Icons.verified_user;
      case AssetType.certificateTemplate:
        return Icons.description;
      case AssetType.sccmServer:
        return Icons.settings_applications;
      case AssetType.smbShare:
        return Icons.folder_shared;
      case AssetType.kerberosTicket:
        return Icons.confirmation_number;
      // Azure asset types
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
      case AssetType.restrictedEnvironment:
        return Colors.grey;
      case AssetType.securityControl:
        return Colors.indigo;
      case AssetType.activeDirectoryDomain:
        return Colors.deepPurple;
      case AssetType.domainController:
        return Colors.indigo;
      case AssetType.adUser:
        return Colors.lightBlue;
      case AssetType.adComputer:
        return Colors.blue;
      case AssetType.certificateAuthority:
        return Colors.cyan;
      case AssetType.certificateTemplate:
        return Colors.teal;
      case AssetType.sccmServer:
        return Colors.brown;
      case AssetType.smbShare:
        return Colors.deepOrange;
      case AssetType.kerberosTicket:
        return Colors.pink;
      // Azure asset types
      case AssetType.azureTenant:
        return Colors.lightBlue;
      case AssetType.azureSubscription:
        return Colors.blue;
      case AssetType.azureStorageAccount:
        return Colors.cyan;
      case AssetType.azureVirtualMachine:
        return Colors.deepOrange;
      case AssetType.azureKeyVault:
        return Colors.amber;
      case AssetType.azureWebApp:
        return Colors.green;
      case AssetType.azureFunctionApp:
        return Colors.lime;
      case AssetType.azureDevOpsOrganization:
        return Colors.indigo;
      case AssetType.azureSqlDatabase:
        return Colors.blueGrey;
      case AssetType.azureContainerRegistry:
        return Colors.tealAccent;
      case AssetType.azureLogicApp:
        return Colors.purple;
      case AssetType.azureAutomationAccount:
        return Colors.deepPurple;
      case AssetType.azureServicePrincipal:
        return Colors.brown;
      case AssetType.azureManagedIdentity:
        return Colors.grey;
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
            style: TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.error),
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