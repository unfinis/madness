import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../providers/projects_provider.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/common_layout_widgets.dart';
import '../constants/app_spacing.dart';
import '../dialogs/ad_asset_detail_dialog.dart';

class AdAssetsScreen extends ConsumerStatefulWidget {
  const AdAssetsScreen({super.key});

  @override
  ConsumerState<AdAssetsScreen> createState() => _AdAssetsScreenState();
}

class _AdAssetsScreenState extends ConsumerState<AdAssetsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  AssetType? _selectedType;

  final List<AdAssetCategory> _categories = [
    AdAssetCategory(
      name: 'Domain Infrastructure',
      icon: Icons.domain_verification,
      types: [AssetType.activeDirectoryDomain, AssetType.domainController],
      description: 'Core AD infrastructure and domain controllers',
    ),
    AdAssetCategory(
      name: 'Users & Computers',
      icon: Icons.people,
      types: [AssetType.adUser, AssetType.adComputer],
      description: 'AD users, computers and their properties',
    ),
    AdAssetCategory(
      name: 'Certificate Services',
      icon: Icons.verified_user,
      types: [AssetType.certificateAuthority, AssetType.certificateTemplate],
      description: 'ADCS infrastructure and templates',
    ),
    AdAssetCategory(
      name: 'Management & Shares',
      icon: Icons.settings_applications,
      types: [AssetType.sccmServer, AssetType.smbShare],
      description: 'SCCM servers and SMB file shares',
    ),
    AdAssetCategory(
      name: 'Tickets & Auth',
      icon: Icons.confirmation_number,
      types: [AssetType.kerberosTicket],
      description: 'Kerberos tickets and authentication artifacts',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Directory Assets'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(
            icon: Icon(category.icon),
            text: category.name,
          )).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(assetNotifierProvider(currentProject.id).notifier).refresh();
            },
            tooltip: 'Refresh Assets',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, currentProject.id),
            tooltip: 'AD Asset Options',
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'import_bloodhound',
                child: ListTile(
                  leading: Icon(Icons.upload),
                  title: Text('Import BloodHound Data'),
                ),
              ),
              const PopupMenuItem(
                value: 'create_domain',
                child: ListTile(
                  leading: Icon(Icons.domain_verification),
                  title: Text('Add AD Domain'),
                ),
              ),
              const PopupMenuItem(
                value: 'bulk_import',
                child: ListTile(
                  leading: Icon(Icons.file_upload),
                  title: Text('Bulk Import Users/Computers'),
                ),
              ),
              const PopupMenuItem(
                value: 'export_data',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export AD Data'),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ScreenWrapper(
        children: [
          _buildAdAssetsStatsBar(context, currentProject.id),
          SizedBox(height: CommonLayoutWidgets.sectionSpacing),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _categories.map((category) =>
                _buildCategoryView(context, currentProject.id, category)
              ).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAssetDialog(context, currentProject.id),
        icon: const Icon(Icons.add),
        label: const Text('Add Asset'),
      ),
    );
  }

  Widget _buildAdAssetsStatsBar(BuildContext context, String projectId) {
    final assetsAsync = ref.watch(assetsProvider(projectId));

    return assetsAsync.when(
      data: (assets) {
        final adAssets = assets.where(_isAdAsset).toList();
        final stats = _calculateAdStats(adAssets);

        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatChip('Total AD Assets', stats.total, Icons.domain_verification, Colors.deepPurple),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Domains', stats.domains, Icons.domain, Colors.purple),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Domain Controllers', stats.domainControllers, Icons.dns, Colors.indigo),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Users', stats.users, Icons.person, Colors.lightBlue),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Computers', stats.computers, Icons.desktop_windows, Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('ADCS', stats.adcs, Icons.verified_user, Colors.cyan),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('SCCM', stats.sccm, Icons.settings_applications, Colors.brown),
                const SizedBox(width: AppSpacing.sm),
                _buildStatChip('Tickets', stats.tickets, Icons.confirmation_number, Colors.pink),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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

  Widget _buildCategoryView(BuildContext context, String projectId, AdAssetCategory category) {
    final assetsAsync = ref.watch(assetsProvider(projectId));

    return assetsAsync.when(
      data: (assets) {
        final categoryAssets = assets.where((asset) =>
          category.types.contains(asset.type) &&
          (_searchQuery.isEmpty || asset.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        ).toList();

        if (categoryAssets.isEmpty) {
          return CommonStateWidgets.noData(
            itemName: 'assets in this category',
            icon: category.icon,
            onCreate: () => _showAddAssetDialog(context, projectId),
            createButtonText: 'Add ${category.name} Asset',
          );
        }

        return Column(
          children: [
            // Category description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(category.icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          category.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${categoryAssets.length} assets',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            if (categoryAssets.length > 5)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search ${category.name.toLowerCase()}...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => _searchQuery = value),
                ),
              ),

            const SizedBox(height: 16),

            // Assets list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categoryAssets.length,
                itemBuilder: (context, index) {
                  final asset = categoryAssets[index];
                  return _buildAssetCard(context, asset);
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAssetTypeColor(asset.type).withValues(alpha: 0.2),
          child: Icon(
            _getAssetTypeIcon(asset.type),
            color: _getAssetTypeColor(asset.type),
            size: 20,
          ),
        ),
        title: Text(
          asset.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_formatAssetTypeName(asset.type)),
            if (asset.description?.isNotEmpty == true)
              Text(
                asset.description!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(asset.discoveredAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const Spacer(),
                if (asset.tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: asset.tags.take(2).map((tag) => Chip(
                      label: Text(tag),
                      backgroundColor: _getAssetTypeColor(asset.type).withValues(alpha: 0.1),
                      labelStyle: TextStyle(
                        fontSize: 10,
                        color: _getAssetTypeColor(asset.type),
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
              ],
            ),
          ],
        ),
        onTap: () => _showAssetDetails(asset),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showAssetMenu(context, asset),
        ),
      ),
    );
  }

  bool _isAdAsset(Asset asset) {
    return [
      AssetType.activeDirectoryDomain,
      AssetType.domainController,
      AssetType.adUser,
      AssetType.adComputer,
      AssetType.certificateAuthority,
      AssetType.certificateTemplate,
      AssetType.sccmServer,
      AssetType.smbShare,
      AssetType.kerberosTicket,
    ].contains(asset.type);
  }

  AdAssetStats _calculateAdStats(List<Asset> assets) {
    final domains = assets.where((a) => a.type == AssetType.activeDirectoryDomain).length;
    final domainControllers = assets.where((a) => a.type == AssetType.domainController).length;
    final users = assets.where((a) => a.type == AssetType.adUser).length;
    final computers = assets.where((a) => a.type == AssetType.adComputer).length;
    final adcs = assets.where((a) => [AssetType.certificateAuthority, AssetType.certificateTemplate].contains(a.type)).length;
    final sccm = assets.where((a) => a.type == AssetType.sccmServer).length;
    final tickets = assets.where((a) => a.type == AssetType.kerberosTicket).length;

    return AdAssetStats(
      total: assets.length,
      domains: domains,
      domainControllers: domainControllers,
      users: users,
      computers: computers,
      adcs: adcs,
      sccm: sccm,
      tickets: tickets,
    );
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

  Color _getAssetTypeColor(AssetType type) {
    switch (type) {
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
      default:
        return Colors.grey;
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

  void _handleMenuAction(String action, String projectId) {
    switch (action) {
      case 'import_bloodhound':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('BloodHound import coming soon')),
        );
        break;
      case 'create_domain':
        _showAddAssetDialog(context, projectId, AssetType.activeDirectoryDomain);
        break;
      case 'bulk_import':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bulk import coming soon')),
        );
        break;
      case 'export_data':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export functionality coming soon')),
        );
        break;
    }
  }

  void _showAddAssetDialog(BuildContext context, String projectId, [AssetType? assetType]) {
    showDialog(
      context: context,
      builder: (context) => AdAssetDetailDialog(
        projectId: projectId,
        assetType: assetType ?? AssetType.activeDirectoryDomain,
      ),
    );
  }

  void _showAssetDetails(Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AdAssetDetailDialog(
        projectId: asset.projectId,
        asset: asset,
      ),
    );
  }

  void _showAssetMenu(BuildContext context, Asset asset) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Asset'),
              onTap: () {
                Navigator.pop(context);
                _showAssetDetails(asset);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Duplicate Asset'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement duplicate functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Duplicate functionality coming soon')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete Asset', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteAsset(context, asset);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteAsset(BuildContext context, Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete "${asset.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(assetNotifierProvider(asset.projectId).notifier).deleteAsset(asset.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Asset deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class AdAssetCategory {
  final String name;
  final IconData icon;
  final List<AssetType> types;
  final String description;

  AdAssetCategory({
    required this.name,
    required this.icon,
    required this.types,
    required this.description,
  });
}

class AdAssetStats {
  final int total;
  final int domains;
  final int domainControllers;
  final int users;
  final int computers;
  final int adcs;
  final int sccm;
  final int tickets;

  AdAssetStats({
    required this.total,
    required this.domains,
    required this.domainControllers,
    required this.users,
    required this.computers,
    required this.adcs,
    required this.sccm,
    required this.tickets,
  });
}