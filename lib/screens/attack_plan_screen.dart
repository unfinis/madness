import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/asset_provider.dart';
import '../providers/navigation_provider.dart';
import '../models/attack_graph.dart';
import '../models/assets.dart';
import '../services/attack_graph_service.dart';
import '../services/attack_chain_service.dart';
import '../widgets/common_state_widgets.dart';
import '../dialogs/comprehensive_methodology_detail_dialog.dart';
import '../dialogs/add_network_segment_dialog.dart';
import '../constants/app_spacing.dart';

/// Unified Attack Plan Screen - Primary operational view for attack execution
class AttackPlanScreen extends ConsumerStatefulWidget {
  const AttackPlanScreen({super.key});

  @override
  ConsumerState<AttackPlanScreen> createState() => _AttackPlanScreenState();
}

class _AttackPlanScreenState extends ConsumerState<AttackPlanScreen> {
  final AttackGraphService _graphService = AttackGraphService();
  final AttackChainService _chainService = AttackChainService();

  // View options
  bool _showCompletedNodes = true;
  bool _showBlockedNodes = false;
  String _selectedPhaseFilter = 'all';

  @override
  void initState() {
    super.initState();
    _graphService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Attack Plan')),
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    final comprehensiveAssetsState = ref.watch(assetProvider(currentProject.id));
    final graph = _graphService.getProjectGraph(currentProject.id);

    return comprehensiveAssetsState.when(
      data: (assets) => Scaffold(
        appBar: _buildAppBar(context, currentProject.id),
        body: Column(
          children: [
            _buildStatsBar(graph, assets),
            _buildFilterBar(),
            Expanded(
              child: graph == null || graph.nodes.isEmpty
                  ? _buildEmptyState(context, currentProject.id)
                  : _buildAttackGraph(graph, assets),
            ),
          ],
        ),
      ),
      loading: () => Scaffold(
        appBar: _buildAppBar(context, currentProject.id),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: _buildAppBar(context, currentProject.id),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
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
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, String projectId) {
    return AppBar(
      title: const Text('Attack Plan'),
      actions: [
        IconButton(
          icon: const Icon(Icons.library_books),
          tooltip: 'Methodology Library',
          onPressed: () => _navigateToMethodologyLibrary(),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Add Network Segment',
          onPressed: () => _showAddNetworkSegmentDialog(context, projectId),
        ),
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(value, projectId),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'refresh',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Refresh Plan'),
              ),
            ),
            const PopupMenuItem(
              value: 'export',
              child: ListTile(
                leading: Icon(Icons.download),
                title: Text('Export Plan'),
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: ListTile(
                leading: Icon(Icons.clear),
                title: Text('Clear Plan'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsBar(AttackGraph? graph, List<Asset> assets) {
    final executable = graph?.getExecutableNodes() ?? [];
    final completed = graph?.getCompletedNodes() ?? [];
    final pending = graph?.nodes.where((n) => n.status == AttackNodeStatus.pending).length ?? 0;
    final blocked = graph?.nodes.where((n) => n.status == AttackNodeStatus.blocked).length ?? 0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatChip('Executable', executable.length, Icons.play_circle, Colors.green),
          _buildStatChip('Pending', pending, Icons.schedule, Colors.orange),
          _buildStatChip('Completed', completed.length, Icons.check_circle, Colors.blue),
          _buildStatChip('Blocked', blocked, Icons.block, Colors.red),
          _buildStatChip('Assets', assets.length, Icons.storage, Colors.purple),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          const Text('Filter: ', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: AppSpacing.sm),
          ChoiceChip(
            label: const Text('Show Completed'),
            selected: _showCompletedNodes,
            onSelected: (value) => setState(() => _showCompletedNodes = value),
          ),
          const SizedBox(width: AppSpacing.sm),
          ChoiceChip(
            label: const Text('Show Blocked'),
            selected: _showBlockedNodes,
            onSelected: (value) => setState(() => _showBlockedNodes = value),
          ),
          const SizedBox(width: AppSpacing.md),
          DropdownButton<String>(
            value: _selectedPhaseFilter,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('All Phases')),
              DropdownMenuItem(value: 'reconnaissance', child: Text('Reconnaissance')),
              DropdownMenuItem(value: 'initialAccess', child: Text('Initial Access')),
              DropdownMenuItem(value: 'credentialAccess', child: Text('Credential Access')),
              DropdownMenuItem(value: 'lateralMovement', child: Text('Lateral Movement')),
              DropdownMenuItem(value: 'privilegeEscalation', child: Text('Privilege Escalation')),
              DropdownMenuItem(value: 'persistence', child: Text('Persistence')),
            ],
            onChanged: (value) => setState(() => _selectedPhaseFilter = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String projectId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_tree,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'No Attack Plan Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Start by adding a network segment to begin your attack plan',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: () => _showAddNetworkSegmentDialog(context, projectId),
            icon: const Icon(Icons.add),
            label: const Text('Add Network Segment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttackGraph(AttackGraph graph, List<Asset> assets) {
    final filteredNodes = _filterNodes(graph.nodes);
    final executableNodes = graph.getExecutableNodes();
    final recommendedNodes = graph.getRecommendedNodes();

    return CustomScrollView(
      slivers: [
        // Recommended Actions Section
        if (recommendedNodes.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader('🎯 Recommended Actions', Colors.green),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 150,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildNodeCard(recommendedNodes[index], assets, true),
                childCount: recommendedNodes.length,
              ),
            ),
          ),
        ],

        // Executable Nodes Section
        if (executableNodes.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionHeader('▶️ Executable Now', Colors.orange),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisExtent: 150,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildNodeCard(executableNodes[index], assets, false),
                childCount: executableNodes.length,
              ),
            ),
          ),
        ],

        // All Nodes by Phase
        ...AttackChainPhase.values.map((phase) {
          final phaseNodes = filteredNodes.where((n) => n.phase == phase).toList();
          if (phaseNodes.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

          return SliverMainAxisGroup(
            slivers: [
              SliverToBoxAdapter(
                child: _buildSectionHeader(
                  '${_getPhaseIcon(phase)} ${phase.displayName}',
                  _getPhaseColor(phase),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildNodeListTile(phaseNodes[index], assets),
                    childCount: phaseNodes.length,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border(
          left: BorderSide(color: color, width: 4),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildNodeCard(AttackNode node, List<Asset> assets, bool isRecommended) {
    final canExecute = node.canExecute(assets);
    final statusColor = _getStatusColor(node.status);

    return Card(
      elevation: isRecommended ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isRecommended ? Colors.green : statusColor.withOpacity(0.3),
          width: isRecommended ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: canExecute || node.status == AttackNodeStatus.completed
            ? () => _showNodeDetails(node)
            : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getStatusIcon(node.status),
                    color: statusColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      node.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isRecommended)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'RECOMMENDED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                node.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    _formatDuration(node.estimatedDuration),
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getPhaseColor(node.phase).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getPhaseColor(node.phase).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      node.phase.displayName,
                      style: TextStyle(
                        fontSize: 10,
                        color: _getPhaseColor(node.phase),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodeListTile(AttackNode node, List<Asset> assets) {
    final canExecute = node.canExecute(assets);
    final statusColor = _getStatusColor(node.status);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          _getStatusIcon(node.status),
          color: statusColor,
        ),
        title: Text(
          node.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: node.status == AttackNodeStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(node.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.timer, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  _formatDuration(node.estimatedDuration),
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.trending_up, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  'Impact: ${(node.potentialImpact * 100).toInt()}%',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(width: 12),
                Icon(Icons.flag, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  'Priority: ${node.priority}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ],
        ),
        trailing: canExecute
            ? ElevatedButton.icon(
                onPressed: () => _executeNode(node),
                icon: const Icon(Icons.play_arrow, size: 16),
                label: const Text('Execute'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )
            : node.status == AttackNodeStatus.completed
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.lock, color: Colors.grey),
        onTap: () => _showNodeDetails(node),
      ),
    );
  }

  List<AttackNode> _filterNodes(List<AttackNode> nodes) {
    return nodes.where((node) {
      // Filter by completion status
      if (!_showCompletedNodes && node.status == AttackNodeStatus.completed) {
        return false;
      }

      // Filter by blocked status
      if (!_showBlockedNodes && node.status == AttackNodeStatus.blocked) {
        return false;
      }

      // Filter by phase
      if (_selectedPhaseFilter != 'all' && node.phase.name != _selectedPhaseFilter) {
        return false;
      }

      return true;
    }).toList();
  }

  void _showNodeDetails(AttackNode node) {
    // Convert AttackNode to methodology format
    final methodology = {
      'id': node.methodologyId,
      'name': node.title,
      'description': node.description,
      'category': node.phase.name,
      'risk_level': _getRiskLevelFromImpact(node.potentialImpact),
      'estimated_duration': _formatDuration(node.estimatedDuration),
      'stealth_level': 'moderate', // Default value
    };

    // Create trigger context for attack graph steps
    final triggerContext = {
      'triggered_by': 'attack_plan',
      'node_id': node.id,
      'phase': node.phase.displayName,
      'status': node.status.name,
      'priority': node.priority,
      'timestamp': node.createdDate?.toString() ?? DateTime.now().toString(),
      if (node.context != null) ...node.context!,
    };

    showDialog(
      context: context,
      builder: (context) => MethodologyDetailDialog(
        methodology: methodology,
        isFromLibrary: false,
        triggerContext: triggerContext,
      ),
    );
  }

  String _getRiskLevelFromImpact(double impact) {
    if (impact >= 0.8) return 'critical';
    if (impact >= 0.6) return 'high';
    if (impact >= 0.4) return 'medium';
    return 'low';
  }



  void _executeNode(AttackNode node) {
    // TODO: Execute the methodology for this node
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executing: ${node.title}'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => _showNodeDetails(node),
        ),
      ),
    );

    // Update node status
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      _graphService.updateNodeStatus(
        currentProject.id,
        node.id,
        AttackNodeStatus.inProgress,
      );
    }
  }

  void _showAddNetworkSegmentDialog(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => const AddNetworkSegmentDialog(),
    ).then((networkState) async {
      if (networkState != null) {
        // The dialog already adds the asset and creates the attack chain
        // We need to create/update the attack graph
        final currentProject = ref.read(currentProjectProvider);
        if (currentProject != null) {
          final comprehensiveAssetsState = ref.read(assetProvider(currentProject.id));

          comprehensiveAssetsState.whenData((comprehensiveAssets) async {
            final networkAsset = comprehensiveAssets.where(
              (a) => a.type == AssetType.networkSegment
            ).lastOrNull;

            if (networkAsset != null) {
              await _graphService.addNetworkAsset(currentProject.id, networkAsset);
            }
          });

          setState(() {});
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Network segment added to attack plan')),
        );
      }
    });
  }

  void _handleMenuAction(String action, String projectId) {
    switch (action) {
      case 'refresh':
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attack plan refreshed')),
        );
        break;
      case 'export':
        // TODO: Export plan visualization
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export feature coming soon')),
        );
        break;
      case 'clear':
        _chainService.clearProjectChain(projectId);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Attack plan cleared')),
        );
        break;
    }
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  IconData _getStatusIcon(AttackNodeStatus status) {
    switch (status) {
      case AttackNodeStatus.pending:
        return Icons.schedule;
      case AttackNodeStatus.inProgress:
        return Icons.play_circle_outline;
      case AttackNodeStatus.completed:
        return Icons.check_circle;
      case AttackNodeStatus.failed:
        return Icons.error;
      case AttackNodeStatus.skipped:
        return Icons.skip_next;
      case AttackNodeStatus.blocked:
        return Icons.block;
    }
  }

  Color _getStatusColor(AttackNodeStatus status) {
    switch (status) {
      case AttackNodeStatus.pending:
        return Colors.orange;
      case AttackNodeStatus.inProgress:
        return Colors.blue;
      case AttackNodeStatus.completed:
        return Colors.green;
      case AttackNodeStatus.failed:
        return Colors.red;
      case AttackNodeStatus.skipped:
        return Colors.grey;
      case AttackNodeStatus.blocked:
        return Colors.red[900]!;
    }
  }

  String _getPhaseIcon(AttackChainPhase phase) {
    switch (phase) {
      case AttackChainPhase.reconnaissance:
        return '🔍';
      case AttackChainPhase.initialAccess:
        return '🚪';
      case AttackChainPhase.credentialAccess:
        return '🔑';
      case AttackChainPhase.lateralMovement:
        return '➡️';
      case AttackChainPhase.privilegeEscalation:
        return '⬆️';
      case AttackChainPhase.persistence:
        return '🔒';
      case AttackChainPhase.domainAdmin:
        return '👑';
    }
  }

  Color _getPhaseColor(AttackChainPhase phase) {
    switch (phase) {
      case AttackChainPhase.reconnaissance:
        return Colors.blue;
      case AttackChainPhase.initialAccess:
        return Colors.orange;
      case AttackChainPhase.credentialAccess:
        return Colors.purple;
      case AttackChainPhase.lateralMovement:
        return Colors.teal;
      case AttackChainPhase.privilegeEscalation:
        return Colors.amber;
      case AttackChainPhase.persistence:
        return Colors.indigo;
      case AttackChainPhase.domainAdmin:
        return Colors.red;
    }
  }

  void _navigateToMethodologyLibrary() {
    ref.read(navigationProvider.notifier).navigateTo(NavigationSection.methodology);
  }

}