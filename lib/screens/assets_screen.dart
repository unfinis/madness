import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assets.dart';
import '../providers/projects_provider.dart';
import '../providers/asset_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../constants/app_spacing.dart';
import '../dialogs/asset_detail_dialog.dart';
import '../dialogs/asset_type_selector_dialog.dart';
import 'package:uuid/uuid.dart';

class AssetsScreen extends ConsumerStatefulWidget {
  const AssetsScreen({super.key});

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  AssetType? _selectedType;
  AssetDiscoveryStatus? _selectedStatus;
  AccessLevel? _selectedAccessLevel;
  static const _uuid = Uuid();

  String generateAssetId() => _uuid.v4();

  final List<AssetPerspective> _perspectives = [
    AssetPerspective(
      name: 'Infrastructure',
      icon: Icons.account_tree,
      types: [
        AssetType.environment,
        AssetType.physicalSite,
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
        AssetType.identity,
        AssetType.authenticationSystem,
        AssetType.person,
      ],
    ),
    AssetPerspective(
      name: 'Data & Files',
      icon: Icons.folder,
      types: [
        AssetType.file,
        AssetType.database,
        AssetType.software,
        AssetType.certificate,
      ],
    ),
    AssetPerspective(
      name: 'Wireless & Network',
      icon: Icons.wifi,
      types: [
        AssetType.wirelessNetwork,
        AssetType.wirelessClient,
        AssetType.networkDevice,
      ],
    ),
    AssetPerspective(
      name: 'Cloud & Azure',
      icon: Icons.cloud,
      types: [
        AssetType.cloudTenant,
        AssetType.cloudResource,
        AssetType.cloudIdentity,
      ],
    ),
    AssetPerspective(
      name: 'Physical Security',
      icon: Icons.location_on,
      types: [
        AssetType.physicalSite,
        AssetType.physicalArea,
        AssetType.person,
        AssetType.accessControl,
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

    final assetsAsync = ref.watch(assetProvider(currentProject.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(assetProvider(currentProject.id).notifier).loadAssets();
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
                onPressed: () => ref.refresh(assetProvider(currentProject.id)),
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

    final statsData = [
      StatData(
        label: 'Total',
        count: stats.total,
        icon: Icons.folder_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      StatData(
        label: 'Environments',
        count: stats.environments,
        icon: Icons.public,
        color: Colors.purple,
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
        label: 'Cloud',
        count: stats.cloud,
        icon: Icons.cloud_outlined,
        color: Colors.indigo,
      ),
      StatData(
        label: 'Wireless',
        count: stats.wireless,
        icon: Icons.wifi,
        color: Colors.amber,
      ),
      StatData(
        label: 'Compromised',
        count: stats.compromised,
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<AssetType?>(
                        initialValue: _selectedType,
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
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: DropdownButtonFormField<AssetDiscoveryStatus?>(
                        initialValue: _selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All', overflow: TextOverflow.ellipsis),
                          ),
                          ...AssetDiscoveryStatus.values.map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(_formatStatusName(status), overflow: TextOverflow.ellipsis),
                          )),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedStatus = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<AccessLevel?>(
                  initialValue: _selectedAccessLevel,
                  decoration: const InputDecoration(
                    labelText: 'Access Level',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Access Levels', overflow: TextOverflow.ellipsis),
                    ),
                    ...AccessLevel.values.map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(_formatAccessLevelName(level), overflow: TextOverflow.ellipsis),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAccessLevel = value;
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
                flex: 2,
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
                flex: 3,
                child: DropdownButtonFormField<AssetType?>(
                  initialValue: _selectedType,
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
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<AssetDiscoveryStatus?>(
                  initialValue: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Statuses', overflow: TextOverflow.ellipsis),
                    ),
                    ...AssetDiscoveryStatus.values.map((status) => DropdownMenuItem(
                      value: status,
                      child: Text(
                        _formatStatusName(status),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<AccessLevel?>(
                  initialValue: _selectedAccessLevel,
                  decoration: const InputDecoration(
                    labelText: 'Access',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Access', overflow: TextOverflow.ellipsis),
                    ),
                    ...AccessLevel.values.map((level) => DropdownMenuItem(
                      value: level,
                      child: Text(
                        _formatAccessLevelName(level),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedAccessLevel = value;
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
    // Group assets by type and organize hierarchically
    final rootAssets = assets.where((asset) => asset.parentAssetIds.isEmpty).toList();
    final childAssets = assets.where((asset) => asset.parentAssetIds.isNotEmpty).toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (rootAssets.isNotEmpty) ...[
          _buildSectionHeader('Root Assets', rootAssets.length),
          const SizedBox(height: AppSpacing.sm),
          ...rootAssets.map((asset) => _buildAssetNode(asset, assets, 0)),
        ],
        if (childAssets.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          _buildSectionHeader('Other Assets', childAssets.length),
          const SizedBox(height: AppSpacing.sm),
          ...childAssets.map((asset) => _buildAssetCard(asset)),
        ],
      ],
    );
  }

  Widget _buildAssetNode(Asset asset, List<Asset> allAssets, int depth) {
    final children = allAssets.where((a) => asset.childAssetIds.contains(a.id)).toList();
    final hasChildren = children.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(left: depth * 24.0, bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAssetCard(asset, hasChildren: hasChildren),
          if (hasChildren) ...[
            const SizedBox(height: AppSpacing.sm),
            ...children.map((child) => _buildAssetNode(child, allAssets, depth + 1)),
          ],
        ],
      ),
    );
  }

  Widget _buildAssetCard(Asset asset, {bool hasChildren = false}) {
    return Card(
      elevation: hasChildren ? 3 : 1,
      child: ListTile(
        leading: Icon(
          _getAssetTypeIcon(asset.type),
          color: _getAssetTypeColor(asset.type),
        ),
        title: Text(
          asset.name,
          style: TextStyle(
            fontWeight: hasChildren ? FontWeight.bold : FontWeight.w600,
          ),
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
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 120),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (asset.childAssetIds.isNotEmpty) ...[
                Flexible(
                  child: Chip(
                    label: Text('${asset.childAssetIds.length}'),
                    backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              PopupMenuButton<String>(
                onSelected: (action) => _handleAssetAction(action, asset),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'view', child: Text('View Details')),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'relationships', child: Text('View Relationships')),
                  const PopupMenuItem(value: 'trigger', child: Text('Trigger Methodologies')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
        onTap: () => _showAssetDetails(asset),
      ),
    );
  }

  Widget _buildAssetStatusRow(Asset asset) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // For very narrow screens, use column layout
        if (constraints.maxWidth < 300) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildStatusChip(asset.discoveryStatus),
                  const SizedBox(width: AppSpacing.sm),
                  if (asset.accessLevel != null)
                    _buildAccessChip(asset.accessLevel!),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      _formatAssetTypeName(asset.type),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getAssetTypeColor(asset.type),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    _formatDate(asset.discoveredAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        // For normal width, use row but with flexible elements
        return Row(
          children: [
            _buildStatusChip(asset.discoveryStatus),
            const SizedBox(width: AppSpacing.sm),
            if (asset.accessLevel != null) ...[
              _buildAccessChip(asset.accessLevel!),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Text(
                _formatAssetTypeName(asset.type),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: _getAssetTypeColor(asset.type),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
      },
    );
  }

  Widget _buildStatusChip(AssetDiscoveryStatus status) {
    return Chip(
      label: Text(
        _formatStatusName(status),
        style: const TextStyle(fontSize: 9),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: _getStatusColor(status).withValues(alpha: 0.1),
      side: BorderSide(color: _getStatusColor(status)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildAccessChip(AccessLevel level) {
    return Chip(
      label: Text(
        _formatAccessLevelName(level),
        style: const TextStyle(fontSize: 9),
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor: _getAccessLevelColor(level).withValues(alpha: 0.1),
      side: BorderSide(color: _getAccessLevelColor(level)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
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
          ...asset.properties.values.map((v) => _formatPropertyValue(v)),
        ].join(' ').toLowerCase();

        if (!searchableText.contains(_searchQuery)) {
          return false;
        }
      }

      // Type filter
      if (_selectedType != null && asset.type != _selectedType) {
        return false;
      }

      // Status filter
      if (_selectedStatus != null && asset.discoveryStatus != _selectedStatus) {
        return false;
      }

      // Access level filter
      if (_selectedAccessLevel != null && asset.accessLevel != _selectedAccessLevel) {
        return false;
      }

      return true;
    }).toList();
  }

  AssetStats _calculateStats(List<Asset> assets) {
    return AssetStats(
      total: assets.length,
      environments: assets.where((a) => a.type == AssetType.environment).length,
      networks: assets.where((a) => a.type == AssetType.networkSegment).length,
      hosts: assets.where((a) => a.type == AssetType.host).length,
      services: assets.where((a) => a.type == AssetType.service).length,
      credentials: assets.where((a) => a.type == AssetType.credential).length,
      cloud: assets.where((a) => [
        AssetType.cloudTenant,
        AssetType.cloudResource,
        AssetType.cloudIdentity,
      ].contains(a.type)).length,
      wireless: assets.where((a) => [
        AssetType.wirelessNetwork,
        AssetType.wirelessClient,
      ].contains(a.type)).length,
      compromised: assets.where((a) => a.discoveryStatus == AssetDiscoveryStatus.compromised).length,
    );
  }

  // Helper methods for formatting and colors

  String _formatAssetTypeName(AssetType type) {
    return type.name.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (match) => ' ${match.group(1)}',
    ).trim();
  }

  String _formatStatusName(AssetDiscoveryStatus status) {
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  String _formatAccessLevelName(AccessLevel level) {
    return level.name[0].toUpperCase() + level.name.substring(1);
  }

  String _formatPropertyValue(AssetPropertyValue value) {
    return value.when(
      string: (v) => v,
      integer: (v) => v.toString(),
      double: (v) => v.toString(),
      boolean: (v) => v.toString(),
      stringList: (v) => v.join(', '),
      dateTime: (v) => v.toString(),
      map: (v) => v.toString(),
      objectList: (v) => '${v.length} item(s)',
    );
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
      case AssetType.environment:
        return Icons.public;
      case AssetType.physicalSite:
        return Icons.location_on;
      case AssetType.physicalArea:
        return Icons.room;
      case AssetType.networkSegment:
        return Icons.network_wifi;
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.cloud;
      case AssetType.credential:
        return Icons.key;
      case AssetType.identity:
        return Icons.person;
      case AssetType.authenticationSystem:
        return Icons.security;
      case AssetType.file:
        return Icons.insert_drive_file;
      case AssetType.database:
        return Icons.storage;
      case AssetType.software:
        return Icons.apps;
      case AssetType.wirelessNetwork:
        return Icons.wifi;
      case AssetType.wirelessClient:
        return Icons.phone_android;
      case AssetType.networkDevice:
        return Icons.router;
      case AssetType.cloudTenant:
        return Icons.cloud_outlined;
      case AssetType.cloudResource:
        return Icons.cloud_circle;
      case AssetType.cloudIdentity:
        return Icons.cloud_done;
      case AssetType.vulnerability:
        return Icons.bug_report;
      case AssetType.certificate:
        return Icons.verified_user;
      case AssetType.person:
        return Icons.person_outline;
      case AssetType.accessControl:
        return Icons.door_front_door;
      case AssetType.restrictedEnvironment:
        return Icons.lock;
      case AssetType.breakoutAttempt:
        return Icons.exit_to_app;
      case AssetType.breakoutTechnique:
        return Icons.build;
      case AssetType.securityControl:
        return Icons.shield;
      case AssetType.webApplication:
        return Icons.web;
      case AssetType.apiEndpoint:
        return Icons.api;
      case AssetType.container:
        return Icons.inventory_2;
      case AssetType.dnsRecord:
        return Icons.dns;
      case AssetType.email:
        return Icons.email;
      // Azure resources
      case AssetType.azureResource:
      case AssetType.azureVM:
      case AssetType.azureStorageAccount:
      case AssetType.azureKeyVault:
      case AssetType.azureSQLDatabase:
      case AssetType.azureCosmosDB:
      case AssetType.azureFunction:
      case AssetType.azureAppService:
      case AssetType.azureAD:
      case AssetType.azureNetworking:
      case AssetType.azureAKS:
        return Icons.cloud_outlined;
      // AWS resources
      case AssetType.awsResource:
      case AssetType.ec2Instance:
      case AssetType.s3Bucket:
      case AssetType.rdsDatabase:
      case AssetType.lambdaFunction:
      case AssetType.iamRole:
      case AssetType.awsSecret:
        return Icons.cloud_queue;
      // GCP resources
      case AssetType.gcpResource:
      case AssetType.computeInstance:
      case AssetType.cloudStorage:
      case AssetType.cloudSQL:
      case AssetType.cloudFunction:
        return Icons.cloud_circle;
      case AssetType.unknown:
        return Icons.help_outline;
    }
  }

  Color _getAssetTypeColor(AssetType type) {
    switch (type) {
      case AssetType.environment:
        return Colors.purple;
      case AssetType.physicalSite:
      case AssetType.physicalArea:
        return Colors.brown;
      case AssetType.networkSegment:
        return Colors.teal;
      case AssetType.host:
        return Colors.blue;
      case AssetType.service:
        return Colors.green;
      case AssetType.credential:
      case AssetType.identity:
        return Colors.orange;
      case AssetType.authenticationSystem:
        return Colors.red;
      case AssetType.file:
      case AssetType.database:
      case AssetType.software:
        return Colors.deepPurple;
      case AssetType.wirelessNetwork:
      case AssetType.wirelessClient:
        return Colors.amber;
      case AssetType.networkDevice:
        return Colors.cyan;
      case AssetType.cloudTenant:
      case AssetType.cloudResource:
      case AssetType.cloudIdentity:
        return Colors.indigo;
      case AssetType.vulnerability:
        return Colors.red;
      case AssetType.certificate:
        return Colors.lightGreen;
      case AssetType.person:
        return Colors.pink;
      case AssetType.accessControl:
        return Colors.grey;
      case AssetType.restrictedEnvironment:
        return Colors.deepOrange;
      case AssetType.breakoutAttempt:
        return Colors.red.shade700;
      case AssetType.breakoutTechnique:
        return Colors.purple.shade700;
      case AssetType.securityControl:
        return Colors.blue.shade700;
      case AssetType.webApplication:
        return Colors.deepPurple;
      case AssetType.apiEndpoint:
        return Colors.purple;
      case AssetType.container:
        return Colors.blueGrey;
      case AssetType.dnsRecord:
        return Colors.cyan;
      case AssetType.email:
        return Colors.lightBlue;
      // Azure resources
      case AssetType.azureResource:
      case AssetType.azureVM:
      case AssetType.azureStorageAccount:
      case AssetType.azureKeyVault:
      case AssetType.azureSQLDatabase:
      case AssetType.azureCosmosDB:
      case AssetType.azureFunction:
      case AssetType.azureAppService:
      case AssetType.azureAD:
      case AssetType.azureNetworking:
      case AssetType.azureAKS:
        return Colors.blue.shade600;
      // AWS resources
      case AssetType.awsResource:
      case AssetType.ec2Instance:
      case AssetType.s3Bucket:
      case AssetType.rdsDatabase:
      case AssetType.lambdaFunction:
      case AssetType.iamRole:
      case AssetType.awsSecret:
        return Colors.orange.shade700;
      // GCP resources
      case AssetType.gcpResource:
      case AssetType.computeInstance:
      case AssetType.cloudStorage:
      case AssetType.cloudSQL:
      case AssetType.cloudFunction:
        return Colors.red.shade600;
      case AssetType.unknown:
        return Colors.grey;
    }
  }

  Color _getStatusColor(AssetDiscoveryStatus status) {
    switch (status) {
      case AssetDiscoveryStatus.discovered:
        return Colors.blue;
      case AssetDiscoveryStatus.accessible:
        return Colors.orange;
      case AssetDiscoveryStatus.compromised:
        return Colors.red;
      case AssetDiscoveryStatus.analyzed:
        return Colors.green;
      case AssetDiscoveryStatus.unknown:
        return Colors.grey;
    }
  }

  Color _getAccessLevelColor(AccessLevel level) {
    switch (level) {
      case AccessLevel.none:
        return Colors.grey;
      case AccessLevel.guest:
        return Colors.blue;
      case AccessLevel.user:
        return Colors.orange;
      case AccessLevel.admin:
        return Colors.red;
      case AccessLevel.system:
        return Colors.purple;
    }
  }

  void _handleAssetAction(String action, Asset asset) {
    switch (action) {
      case 'view':
        _showAssetDetails(asset);
        break;
      case 'edit':
        _editAsset(asset);
        break;
      case 'relationships':
        _showRelationships(asset);
        break;
      case 'trigger':
        _triggerMethodologies(asset);
        break;
      case 'delete':
        _deleteAsset(asset);
        break;
    }
  }

  void _showAssetDetails(Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AssetDetailDialog(
        asset: asset,
        isEditMode: false,
      ),
    );
  }

  void _editAsset(Asset asset) {
    showDialog(
      context: context,
      builder: (context) => AssetDetailDialog(
        asset: asset,
        isEditMode: true,
        onSave: (updatedAsset) {
          // TODO: Save asset through provider
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Asset "${updatedAsset.name}" updated successfully')),
          );
        },
      ),
    );
  }

  void _showRelationships(Asset asset) {
    // TODO: Implement relationship visualization
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Relationship visualization coming soon')),
    );
  }

  void _triggerMethodologies(Asset asset) {
    // TODO: Implement methodology triggering
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Methodology triggering coming soon')),
    );
  }

  void _deleteAsset(Asset asset) {
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
              // TODO: Implement asset deletion
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Asset "${asset.name}" deleted')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddAssetDialog(BuildContext context, String projectId) async {
    // Capture ScaffoldMessenger early before entering dialog context
    final messenger = ScaffoldMessenger.of(context);

    // First, let user select the asset type
    AssetType? selectedType;
    await showDialog(
      context: context,
      builder: (context) => AssetTypeSelectorDialog(
        onAssetTypeSelected: (AssetType assetType) {
          selectedType = assetType;
          Navigator.of(context).pop();
        },
      ),
    );

    if (selectedType == null || !mounted) return;

    // Create a new blank asset based on the selected type
    final newAsset = _createAssetOfType(selectedType!, projectId);

    if (!mounted) return;

    // Show the asset detail dialog for editing
    showDialog(
      context: context,
      builder: (context) => AssetDetailDialog(
        asset: newAsset,
        isEditMode: true,
        onSave: (asset) async {
          try {
            print('Saving asset: ${asset.name} (${asset.type}) to project ${asset.projectId}');
            await ref.read(assetProvider(projectId).notifier).addAsset(asset);
            print('Asset successfully added, refreshing provider...');

            // Force refresh the provider to ensure UI updates
            await ref.read(assetProvider(projectId).notifier).loadAssets();
            print('Provider refreshed, asset should be visible now');

            if (mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('${_getAssetTypeDisplayName(asset.type)} "${asset.name}" created successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } catch (e) {
            print('Error saving asset: $e');
            if (mounted) {
              messenger.showSnackBar(
                SnackBar(
                  content: Text('Failed to create asset: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Asset _createAssetOfType(AssetType type, String projectId) {
    switch (type) {
      case AssetType.environment:
        return AssetFactory.createEnvironment(
          projectId: projectId,
          name: '',
          environmentType: 'hybrid',
          organization: '',
        );
      case AssetType.networkSegment:
        return AssetFactory.createNetworkSegment(
          projectId: projectId,
          subnet: '192.168.1.0/24',
          name: 'New Network Segment',
          gateway: '192.168.1.1',
          nacType: NacType.none,
          accessType: NetworkAccessType.none,
        );
      case AssetType.host:
        return AssetFactory.createHost(
          projectId: projectId,
          ipAddress: '0.0.0.0',
          hostname: 'New Host',
        );
      case AssetType.cloudTenant:
        return AssetFactory.createCloudTenant(
          projectId: projectId,
          tenantName: '',
          tenantType: 'azure',
          tenantId: '',
        );
      case AssetType.wirelessNetwork:
        return AssetFactory.createWirelessNetwork(
          projectId: projectId,
          ssid: '',
          encryptionType: 'wpa2',
        );
      default:
        // For other types, create a generic asset with the correct type
        return Asset(
          id: generateAssetId(),
          projectId: projectId,
          name: '',
          type: type,
          parentAssetIds: [],
          childAssetIds: [],
          relatedAssetIds: [],
          properties: {},
          tags: [],
          accessLevel: AccessLevel.none,
          discoveryStatus: AssetDiscoveryStatus.discovered,
          discoveredAt: DateTime.now(),
          completedTriggers: [],
          triggerResults: {},
        );
    }
  }

  String _getAssetTypeDisplayName(AssetType type) {
    switch (type) {
      case AssetType.environment:
        return 'Environment';
      case AssetType.physicalSite:
        return 'Physical Site';
      case AssetType.networkSegment:
        return 'Network Segment';
      case AssetType.host:
        return 'Host';
      case AssetType.service:
        return 'Service';
      case AssetType.credential:
        return 'Credential';
      case AssetType.cloudTenant:
        return 'Cloud Tenant';
      case AssetType.wirelessNetwork:
        return 'Wireless Network';
      default:
        return type.name;
    }
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Assets'),
        content: const Text('Asset import feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Assets'),
        content: const Text('Asset export feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showRelationshipVisualization(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Relationship Visualization'),
        content: const Text('Relationship visualization feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }


}

// Supporting classes
class AssetPerspective {
  final String name;
  final IconData icon;
  final List<AssetType> types;

  AssetPerspective({
    required this.name,
    required this.icon,
    required this.types,
  });
}

class AssetStats {
  final int total;
  final int environments;
  final int networks;
  final int hosts;
  final int services;
  final int credentials;
  final int cloud;
  final int wireless;
  final int compromised;

  AssetStats({
    required this.total,
    required this.environments,
    required this.networks,
    required this.hosts,
    required this.services,
    required this.credentials,
    required this.cloud,
    required this.wireless,
    required this.compromised,
  });
}