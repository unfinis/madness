import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/asset.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../providers/trigger_evaluation_provider.dart';
import '../providers/projects_provider.dart';
import '../dialogs/comprehensive_asset_detail_dialog.dart';
import '../dialogs/asset_type_selector_dialog.dart';
import '../dialogs/asset_relationship_dialog.dart';

class ComprehensiveAssetsScreen extends ConsumerStatefulWidget {
  const ComprehensiveAssetsScreen({super.key});

  @override
  ConsumerState<ComprehensiveAssetsScreen> createState() => _ComprehensiveAssetsScreenState();
}

class _ComprehensiveAssetsScreenState extends ConsumerState<ComprehensiveAssetsScreen> {
  AssetType? _selectedAssetType;
  String _searchQuery = '';
  bool _showOnlyTriggered = false;

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return const Center(
        child: Text('No project selected'),
      );
    }

    final assetsAsync = _selectedAssetType != null
        ? ref.watch(assetsByTypeProvider((projectId: currentProject.id, type: _selectedAssetType!)))
        : ref.watch(assetsProvider(currentProject.id));

    final assetStatsAsync = ref.watch(assetStatisticsProvider(currentProject.id));
    final triggerStatsAsync = ref.watch(triggerEvaluationStatsProvider(currentProject.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asset Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(assetsProvider(currentProject.id));
              ref.invalidate(assetStatisticsProvider(currentProject.id));
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddAssetDialog(context, currentProject.id),
          ),
        ],
      ),
      body: Column(
        children: [
          // Statistics Section
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Assets',
                      assetStatsAsync,
                      (stats) => stats['totalAssets']?.toString() ?? '0',
                      Icons.storage,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Trigger Matches',
                      triggerStatsAsync,
                      (stats) => stats['totalMatches']?.toString() ?? '0',
                      Icons.gps_fixed,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Run Instances',
                      triggerStatsAsync,
                      (stats) => stats['runInstances']?.toString() ?? '0',
                      Icons.play_arrow,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filters Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            labelText: 'Search assets...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<AssetType?>(
                        value: _selectedAssetType,
                        hint: const Text('Asset Type'),
                        items: [
                          const DropdownMenuItem<AssetType?>(
                            value: null,
                            child: Text('All Types'),
                          ),
                          ...AssetType.values.map((type) => DropdownMenuItem(
                            value: type,
                            child: Text(type.name),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedAssetType = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      FilterChip(
                        label: const Text('Show only triggered'),
                        selected: _showOnlyTriggered,
                        onSelected: (selected) {
                          setState(() {
                            _showOnlyTriggered = selected;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Assets List
          Expanded(
            child: assetsAsync.when(
              data: (assets) {
                var filteredAssets = assets;

                // Apply search filter
                if (_searchQuery.isNotEmpty) {
                  filteredAssets = filteredAssets.where((asset) {
                    return asset.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           asset.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true;
                  }).toList();
                }

                // Apply triggered filter
                if (_showOnlyTriggered) {
                  // This would require checking trigger matches - simplified for now
                  filteredAssets = filteredAssets.where((asset) => asset.completedTriggers.isNotEmpty).toList();
                }

                if (filteredAssets.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.storage_outlined, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No assets found'),
                        Text('Add assets to start trigger evaluation'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredAssets.length,
                  itemBuilder: (context, index) {
                    final asset = filteredAssets[index];
                    return _buildAssetCard(context, asset, currentProject.id);
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
                    Text('Error: $error'),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(assetsProvider(currentProject.id)),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    AsyncValue stats,
    String Function(Map<String, dynamic>) getValue,
    IconData icon,
  ) {
    return stats.when(
      data: (data) => _StatCard(
        title: title,
        value: getValue(data as Map<String, dynamic>),
        icon: icon,
      ),
      loading: () => _StatCard(
        title: title,
        value: '...',
        icon: icon,
      ),
      error: (_, __) => _StatCard(
        title: title,
        value: 'Error',
        icon: icon,
      ),
    );
  }

  Widget _buildAssetCard(BuildContext context, Asset asset, String projectId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getAssetTypeColor(asset.type),
          child: Icon(
            _getAssetTypeIcon(asset.type),
            color: Colors.white,
          ),
        ),
        title: Text(asset.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${asset.type.name} • ${asset.properties.length} properties'),
            if (asset.description?.isNotEmpty == true)
              Text(
                asset.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (asset.completedTriggers.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${asset.completedTriggers.length} triggers',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (action) => _handleAssetAction(context, action, asset, projectId),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(Icons.visibility),
                      SizedBox(width: 8),
                      Text('View Details'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'triggers',
                  child: Row(
                    children: [
                      Icon(Icons.gps_fixed),
                      SizedBox(width: 8),
                      Text('View Triggers'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'relationships',
                  child: Row(
                    children: [
                      Icon(Icons.account_tree),
                      SizedBox(width: 8),
                      Text('Manage Relationships'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _showAssetDetails(context, asset, projectId),
      ),
    );
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

  void _showAddAssetDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AssetTypeSelectorDialog(
        onAssetTypeSelected: (assetType) {
          Navigator.of(context).pop();
          _showAssetEditor(context, null, projectId, assetType);
        },
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

  void _showAssetEditor(BuildContext context, Asset? asset, String projectId, AssetType? assetType) {
    showDialog(
      context: context,
      builder: (context) => ComprehensiveAssetDetailDialog(
        asset: asset,
        projectId: projectId,
        mode: asset != null ? AssetDialogMode.edit : AssetDialogMode.create,
        initialAssetType: assetType,
      ),
    );
  }

  void _handleAssetAction(BuildContext context, String action, Asset asset, String projectId) {
    switch (action) {
      case 'view':
        _showAssetDetails(context, asset, projectId);
        break;
      case 'edit':
        _showAssetEditor(context, asset, projectId, null);
        break;
      case 'triggers':
        _showTriggerMatches(context, asset, projectId);
        break;
      case 'relationships':
        _showAssetRelationships(context, asset, projectId);
        break;
      case 'delete':
        _confirmDeleteAsset(context, asset, projectId);
        break;
    }
  }

  void _showTriggerMatches(BuildContext context, Asset asset, String projectId) {
    showDialog(
      context: context,
      builder: (context) => _TriggerMatchesDialog(
        asset: asset,
        projectId: projectId,
      ),
    );
  }

  void _showAssetRelationships(BuildContext context, Asset asset, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AssetRelationshipDialog(
        asset: asset,
        projectId: projectId,
      ),
    );
  }

  void _confirmDeleteAsset(BuildContext context, Asset asset, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Asset'),
        content: Text('Are you sure you want to delete "${asset.name}"? This action cannot be undone.'),
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
                await ref.read(assetNotifierProvider(projectId).notifier).deleteAsset(asset.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Asset "${asset.name}" deleted')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting asset: $e')),
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

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _TriggerMatchesDialog extends ConsumerWidget {
  final Asset asset;
  final String projectId;

  const _TriggerMatchesDialog({
    required this.asset,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final triggerMatchesAsync = ref.watch(
      triggerMatchesForAssetProvider((projectId: projectId, assetId: asset.id))
    );

    return Dialog(
      child: Container(
        width: 600,
        height: 500,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trigger Matches for ${asset.name}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: triggerMatchesAsync.when(
                data: (matches) {
                  if (matches.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.gps_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No trigger matches found'),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      final match = matches[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: match.matched ? Colors.green : Colors.red,
                            child: Icon(
                              match.matched ? Icons.check : Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          title: Text('Trigger: ${match.triggerId}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Confidence: ${(match.confidence * 100).toStringAsFixed(1)}%'),
                              Text('Evaluated: ${match.evaluatedAt.toString().substring(0, 16)}'),
                              if (match.error != null)
                                Text('Error: ${match.error}', style: const TextStyle(color: Colors.red)),
                            ],
                          ),
                          trailing: Text('Priority: ${match.priority}'),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error loading trigger matches: $error'),
                ),
              ),
            ),
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
}