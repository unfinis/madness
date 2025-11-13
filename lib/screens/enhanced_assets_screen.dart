import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../dialogs/comprehensive_asset_detail_dialog.dart';
import '../constants/app_spacing.dart';

/// Enhanced assets screen with type-specific views and property management
class EnhancedAssetsScreen extends ConsumerStatefulWidget {
  const EnhancedAssetsScreen({super.key});

  @override
  ConsumerState<EnhancedAssetsScreen> createState() => _EnhancedAssetsScreenState();
}

class _EnhancedAssetsScreenState extends ConsumerState<EnhancedAssetsScreen> {
  AssetType? _selectedTypeFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final projectId = ref.watch(selectedProjectIdProvider);
    if (projectId == null) {
      return const Center(child: Text('No project selected'));
    }

    final assetsAsync = ref.watch(comprehensiveAssetsProvider(projectId));

    return Column(
      children: [
        _buildHeader(context, projectId),
        _buildFilterBar(context),
        Expanded(
          child: assetsAsync.when(
            data: (assets) => _buildAssetsList(context, assets, projectId),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, String projectId) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 32,
            color: Theme.of(context).primary Color,
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assets',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                'Manage discovered assets and their properties',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () => _showCreateAssetDialog(context, projectId),
            icon: const Icon(Icons.add),
            label: const Text('Add Asset'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.5),
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search assets...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          DropdownButton<AssetType?>(
            value: _selectedTypeFilter,
            hint: const Text('All Types'),
            items: [
              const DropdownMenuItem<AssetType?>(
                value: null,
                child: Text('All Types'),
              ),
              ...AssetType.values.map((type) => DropdownMenuItem<AssetType?>(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getAssetTypeIcon(type), size: 16),
                        const SizedBox(width: 8),
                        Text(_formatAssetTypeName(type)),
                      ],
                    ),
                  )),
            ],
            onChanged: (value) => setState(() => _selectedTypeFilter = value),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetsList(BuildContext context, List<Asset> assets, String projectId) {
    // Filter assets
    var filteredAssets = assets.where((asset) {
      if (_selectedTypeFilter != null && asset.type != _selectedTypeFilter) {
        return false;
      }
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        return asset.name.toLowerCase().contains(query) ||
            (asset.description?.toLowerCase().contains(query) ?? false) ||
            asset.tags.any((tag) => tag.toLowerCase().contains(query));
      }
      return true;
    }).toList();

    // Sort by discovered date (newest first)
    filteredAssets.sort((a, b) => b.discoveredAt.compareTo(a.discoveredAt));

    if (filteredAssets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No assets found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              _searchQuery.isNotEmpty || _selectedTypeFilter != null
                  ? 'Try adjusting your filters'
                  : 'Add your first asset to get started',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () => _showCreateAssetDialog(context, projectId),
              icon: const Icon(Icons.add),
              label: const Text('Add Asset'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        mainAxisExtent: 220,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: filteredAssets.length,
      itemBuilder: (context, index) {
        final asset = filteredAssets[index];
        return _buildAssetCard(context, asset, projectId);
      },
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset, String projectId) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showAssetDetails(context, asset, projectId),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and type
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _getAssetTypeColor(asset.type).withOpacity(0.1),
                    _getAssetTypeColor(asset.type).withOpacity(0.05),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getAssetTypeIcon(asset.type),
                    color: _getAssetTypeColor(asset.type),
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asset.name,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatAssetTypeName(asset.type),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: _getAssetTypeColor(asset.type),
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (asset.description != null && asset.description!.isNotEmpty)
                      Text(
                        asset.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    const Spacer(),
                    _buildAssetSummary(context, asset),
                  ],
                ),
              ),
            ),

            // Footer with tags
            if (asset.tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withOpacity(0.5),
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: asset.tags.take(3).map((tag) {
                    return Chip(
                      label: Text(tag),
                      labelStyle: Theme.of(context).textTheme.bodySmall,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetSummary(BuildContext context, Asset asset) {
    // Build a type-specific summary
    final List<Widget> summaryItems = [];

    switch (asset.type) {
      case AssetType.networkSegment:
        if (asset.hasProperty('subnet')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.lan,
            'Subnet',
            asset.getProperty<String>('subnet') ?? 'Unknown',
          ));
        }
        if (asset.hasProperty('nac_enabled')) {
          final nacEnabled = asset.getProperty<bool>('nac_enabled') ?? false;
          summaryItems.add(_buildSummaryItem(
            context,
            nacEnabled ? Icons.lock : Icons.lock_open,
            'NAC',
            nacEnabled ? 'Enabled' : 'Disabled',
          ));
        }
        break;

      case AssetType.host:
        if (asset.hasProperty('ip_address')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.computer,
            'IP',
            asset.getProperty<String>('ip_address') ?? 'Unknown',
          ));
        }
        if (asset.hasProperty('os_type')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.laptop,
            'OS',
            asset.getProperty<String>('os_type') ?? 'Unknown',
          ));
        }
        break;

      case AssetType.service:
        if (asset.hasProperty('port')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.power,
            'Port',
            asset.getProperty<int>('port').toString(),
          ));
        }
        if (asset.hasProperty('service_name')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.label,
            'Service',
            asset.getProperty<String>('service_name') ?? 'Unknown',
          ));
        }
        break;

      case AssetType.credential:
        if (asset.hasProperty('username')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.person,
            'Username',
            asset.getProperty<String>('username') ?? 'Unknown',
          ));
        }
        if (asset.hasProperty('domain')) {
          summaryItems.add(_buildSummaryItem(
            context,
            Icons.domain,
            'Domain',
            asset.getProperty<String>('domain') ?? 'None',
          ));
        }
        break;

      default:
        summaryItems.add(_buildSummaryItem(
          context,
          Icons.info_outline,
          'Properties',
          '${asset.properties.length} defined',
        ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: summaryItems,
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAssetDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => ComprehensiveAssetDetailDialog(
        projectId: projectId,
        mode: AssetDialogMode.create,
      ),
    );
  }

  void _showAssetDetails(BuildContext context, Asset asset, String projectId) {
    showDialog(
      context: context,
      builder: (context) => ComprehensiveAssetDetailDialog(
        asset: asset,
        projectId: projectId,
        mode: AssetDialogMode.view,
      ),
    );
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return Icons.lan;
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.power;
      case AssetType.credential:
        return Icons.key;
      case AssetType.vulnerability:
        return Icons.bug_report;
      case AssetType.domain:
        return Icons.domain;
      case AssetType.wireless_network:
        return Icons.wifi;
      case AssetType.restrictedEnvironment:
        return Icons.lock;
      case AssetType.securityControl:
        return Icons.security;
      case AssetType.activeDirectoryDomain:
        return Icons.account_tree;
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
        return Icons.storage;
      case AssetType.smbShare:
        return Icons.folder_shared;
      case AssetType.kerberosTicket:
        return Icons.confirmation_number;
      case AssetType.azureTenant:
        return Icons.cloud;
      case AssetType.azureSubscription:
        return Icons.credit_card;
      case AssetType.azureStorageAccount:
        return Icons.cloud_upload;
      case AssetType.azureVirtualMachine:
        return Icons.cloud_circle;
      case AssetType.azureKeyVault:
        return Icons.vpn_key;
      case AssetType.azureWebApp:
        return Icons.web;
      case AssetType.azureFunctionApp:
        return Icons.functions;
      case AssetType.azureDevOpsOrganization:
        return Icons.code;
      case AssetType.azureSqlDatabase:
        return Icons.storage;
      case AssetType.azureContainerRegistry:
        return Icons.widgets;
      case AssetType.azureLogicApp:
        return Icons.account_tree;
      case AssetType.azureAutomationAccount:
        return Icons.automation;
      case AssetType.azureServicePrincipal:
        return Icons.badge;
      case AssetType.azureManagedIdentity:
        return Icons.fingerprint;
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
        return Colors.amber;
      case AssetType.securityControl:
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _formatAssetTypeName(AssetType type) {
    final name = type.name;
    // Convert camelCase to Title Case
    return name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
  }
}

// Provider for selected project ID
final selectedProjectIdProvider = StateProvider<String?>((ref) => null);
