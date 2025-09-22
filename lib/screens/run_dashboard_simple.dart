import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../providers/trigger_evaluation_provider.dart';
import '../providers/methodology_execution_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../models/asset.dart';
import '../models/trigger_evaluation.dart';
import '../models/run_instance.dart';

class RunDashboardSimple extends ConsumerStatefulWidget {
  const RunDashboardSimple({super.key});

  @override
  ConsumerState<RunDashboardSimple> createState() => _RunDashboardSimpleState();
}

class _RunDashboardSimpleState extends ConsumerState<RunDashboardSimple>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _autoRefresh = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Auto-refresh every 10 seconds if enabled
    if (_autoRefresh) {
      _startAutoRefresh();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startAutoRefresh() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _autoRefresh) {
        setState(() {});
        _startAutoRefresh();
      }
    });
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
    final triggersAsync = ref.watch(triggerEvaluationNotifierProvider(currentProject.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Run Dashboard'),
        actions: [
          IconButton(
            icon: Icon(_autoRefresh ? Icons.pause : Icons.play_arrow),
            onPressed: () {
              setState(() {
                _autoRefresh = !_autoRefresh;
                if (_autoRefresh) {
                  _startAutoRefresh();
                }
              });
            },
            tooltip: _autoRefresh ? 'Pause Auto-refresh' : 'Resume Auto-refresh',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.refresh(assetsProvider(currentProject.id));
              ref.refresh(triggerEvaluationNotifierProvider(currentProject.id));
            },
            tooltip: 'Refresh Now',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_report',
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('Export Report'),
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.timeline), text: 'Activity'),
            Tab(icon: Icon(Icons.analytics), text: 'Metrics'),
            Tab(icon: Icon(Icons.play_circle), text: 'Execution'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(assetsAsync, triggersAsync),
          _buildActivityTab(triggersAsync),
          _buildMetricsTab(assetsAsync, triggersAsync),
          _buildExecutionTab(currentProject.id),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(AsyncValue<List<Asset>> assetsAsync, AsyncValue<List<TriggerMatch>> triggersAsync) {
    return assetsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (assets) => triggersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (triggerMatches) => _buildOverviewContent(assets, triggerMatches),
      ),
    );
  }

  Widget _buildOverviewContent(List<Asset> assets, List<TriggerMatch> triggerMatches) {
    final totalMatches = triggerMatches.length;
    final successfulMatches = triggerMatches.where((m) => m.matched).length;
    final recentMatches = triggerMatches.where((m) =>
      DateTime.now().difference(m.evaluatedAt).inHours < 24
    ).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Real-time stats
          _buildStatsGrid([
            _StatCard('Total Assets', assets.length.toString(), Icons.folder, Colors.blue, 'Discovered assets'),
            _StatCard('Trigger Matches', totalMatches.toString(), Icons.flash_on, Colors.orange, 'All time matches'),
            _StatCard('Successful', successfulMatches.toString(), Icons.check_circle, Colors.green, 'Matched triggers'),
            _StatCard('Recent (24h)', recentMatches.toString(), Icons.timeline, Colors.purple, 'Latest activity'),
          ]),

          const SizedBox(height: AppSpacing.xl),

          // System status
          _buildSystemStatus(),

          const SizedBox(height: AppSpacing.xl),

          // Recent activity preview
          _buildRecentActivityPreview(triggerMatches),

          const SizedBox(height: AppSpacing.xl),

          // Quick actions
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(List<_StatCard> stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 400 ? 2 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
            childAspectRatio: 1.2,
          ),
          itemCount: stats.length,
          itemBuilder: (context, index) => _buildStatCardWidget(stats[index]),
        );
      },
    );
  }

  Widget _buildStatCardWidget(_StatCard stat) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              stat.color.withOpacity(0.1),
              stat.color.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(stat.icon, size: 32, color: stat.color),
            const SizedBox(height: AppSpacing.sm),
            Text(
              stat.value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: stat.color,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              stat.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              stat.subtitle,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatus() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.computer, color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'System Status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _buildStatusItem('Trigger Engine', 'Running', Icons.flash_on, Colors.green),
                ),
                Expanded(
                  child: _buildStatusItem('Asset Monitor', 'Active', Icons.monitor, Colors.blue),
                ),
                Expanded(
                  child: _buildStatusItem('Storage', 'Connected', Icons.storage, Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String status, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.sm),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          status,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentActivityPreview(List<TriggerMatch> triggerMatches) {
    final recentMatches = triggerMatches
        .where((m) => DateTime.now().difference(m.evaluatedAt).inHours < 24)
        .take(5)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Recent Activity',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (recentMatches.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Text('No recent activity'),
                ),
              )
            else
              ...recentMatches.map((match) => _buildActivityItem(match)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(TriggerMatch match) {
    final statusColor = match.matched ? Colors.green : Colors.grey;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            match.matched ? Icons.check_circle : Icons.cancel,
            color: statusColor,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.templateId,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Asset: ${match.assetId}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatTime(match.evaluatedAt),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bolt, color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                _buildQuickActionButton(
                  'Refresh Assets',
                  Icons.refresh,
                  Colors.blue,
                  () => _refreshAssets(),
                ),
                _buildQuickActionButton(
                  'Run Evaluation',
                  Icons.play_circle_fill,
                  Colors.green,
                  () => _runEvaluation(),
                ),
                _buildQuickActionButton(
                  'View Logs',
                  Icons.description,
                  Colors.orange,
                  () => _viewLogs(),
                ),
                _buildQuickActionButton(
                  'Export Data',
                  Icons.download,
                  Colors.purple,
                  () => _exportData(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
    );
  }

  Widget _buildActivityTab(AsyncValue<List<TriggerMatch>> triggersAsync) {
    return triggersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (triggerMatches) {
        if (triggerMatches.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timeline_outlined, size: 64, color: Colors.grey[400]),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'No Activity Yet',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Trigger evaluations will appear here',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: triggerMatches.length,
          itemBuilder: (context, index) => _buildActivityCard(triggerMatches[index]),
        );
      },
    );
  }

  Widget _buildActivityCard(TriggerMatch match) {
    final statusColor = match.matched ? Colors.green : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    match.matched ? Icons.check_circle : Icons.cancel,
                    color: statusColor,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.templateId,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        match.matched ? 'Match Found' : 'No Match',
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Priority ${match.priority}',
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(Icons.computer, size: 16, color: Colors.grey[600]),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'Asset: ${match.assetId}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDateTime(match.evaluatedAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            if (match.confidence < 1.0) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Icon(Icons.speed, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    'Confidence: ${(match.confidence * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsTab(AsyncValue<List<Asset>> assetsAsync, AsyncValue<List<TriggerMatch>> triggersAsync) {
    return assetsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (assets) => triggersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (triggerMatches) => _buildMetricsContent(assets, triggerMatches),
      ),
    );
  }

  Widget _buildMetricsContent(List<Asset> assets, List<TriggerMatch> triggerMatches) {
    final successfulMatches = triggerMatches.where((m) => m.matched).length;
    final successRate = triggerMatches.isNotEmpty ? (successfulMatches / triggerMatches.length * 100) : 0.0;
    final avgConfidence = triggerMatches.isNotEmpty
        ? triggerMatches.map((m) => m.confidence).reduce((a, b) => a + b) / triggerMatches.length
        : 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Metrics grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            children: [
              _buildMetricCard('Assets', assets.length.toString(), Icons.folder),
              _buildMetricCard('Total Evaluations', triggerMatches.length.toString(), Icons.analytics),
              _buildMetricCard('Success Rate', '${successRate.toStringAsFixed(1)}%', Icons.check_circle),
              _buildMetricCard('Avg Confidence', '${(avgConfidence * 100).toStringAsFixed(1)}%', Icons.speed),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Asset type breakdown
          _buildAssetTypeBreakdown(assets),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Theme.of(context).primaryColor),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetTypeBreakdown(List<Asset> assets) {
    final typeBreakdown = <AssetType, int>{};
    for (final asset in assets) {
      typeBreakdown[asset.type] = (typeBreakdown[asset.type] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Type Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ...typeBreakdown.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(_getAssetTypeIcon(entry.key), size: 16),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(_formatAssetTypeName(entry.key))),
                  Text(entry.value.toString()),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutionTab(String projectId) {
    final orchestratorStatus = ref.watch(orchestratorStatusProvider);
    final pendingRunInstancesAsync = ref.watch(pendingRunInstancesProvider(projectId));
    final executionStats = ref.watch(executionStatsProvider(projectId));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Orchestrator controls
          _buildOrchestratorControls(orchestratorStatus),

          const SizedBox(height: AppSpacing.xl),

          // Execution statistics
          _buildExecutionStats(executionStats),

          const SizedBox(height: AppSpacing.xl),

          // Pending run instances
          _buildPendingRunInstances(pendingRunInstancesAsync),
        ],
      ),
    );
  }

  Widget _buildOrchestratorControls(OrchestratorStatus status) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.play_circle, color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Methodology Execution Orchestrator',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: status.isRunning ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: status.isRunning ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status.isRunning ? 'Running' : 'Stopped',
                        style: TextStyle(
                          color: status.isRunning ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Controls
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: [
                ElevatedButton.icon(
                  onPressed: status.isRunning ?
                    () => ref.read(orchestratorStatusProvider.notifier).stop() :
                    () => ref.read(orchestratorStatusProvider.notifier).start(),
                  icon: Icon(status.isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(status.isRunning ? 'Stop' : 'Start'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    ref.read(orchestratorStatusProvider.notifier).setAutoExecutionEnabled(!status.autoExecutionEnabled);
                  },
                  icon: Icon(status.autoExecutionEnabled ? Icons.pause : Icons.auto_mode),
                  label: Text(status.autoExecutionEnabled ? 'Disable Auto' : 'Enable Auto'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _showConcurrencyDialog(status.maxConcurrentExecutions),
                  icon: const Icon(Icons.settings),
                  label: Text('Concurrency: ${status.maxConcurrentExecutions}'),
                ),
              ],
            ),

            if (status.lastError != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 16),
                    const SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Error: ${status.lastError}',
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExecutionStats(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Execution Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Total Executions', stats['totalExecutions']?.toString() ?? '0'),
                ),
                Expanded(
                  child: _buildStatItem('Successful', stats['successfulExecutions']?.toString() ?? '0'),
                ),
                Expanded(
                  child: _buildStatItem('Failed', stats['failedExecutions']?.toString() ?? '0'),
                ),
                Expanded(
                  child: _buildStatItem('Success Rate', '${((stats['successRate'] ?? 0) * 100).toStringAsFixed(1)}%'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem('Active', stats['activeExecutions']?.toString() ?? '0'),
                ),
                Expanded(
                  child: _buildStatItem('Auto Execution', stats['autoExecutionEnabled'] == true ? 'Enabled' : 'Disabled'),
                ),
                Expanded(
                  child: _buildStatItem('Max Concurrent', stats['maxConcurrentExecutions']?.toString() ?? '3'),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPendingRunInstances(AsyncValue<List<RunInstance>> pendingAsync) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Pending Run Instances',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    final currentProject = ref.read(currentProjectProvider);
                    if (currentProject != null) {
                      ref.refresh(pendingRunInstancesProvider(currentProject.id));
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            pendingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error loading pending instances: $error'),
              data: (instances) {
                if (instances.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.xl),
                      child: Text('No pending run instances'),
                    ),
                  );
                }

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: instances.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) => _buildRunInstanceItem(instances[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRunInstanceItem(RunInstance instance) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(instance.status).withOpacity(0.1),
        child: Icon(
          _getStatusIcon(instance.status),
          color: _getStatusColor(instance.status),
          size: 20,
        ),
      ),
      title: Text(instance.runId),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Template: ${instance.templateId}'),
          Text('Asset: ${instance.assetId}'),
          Text('Priority: ${instance.priority}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatTime(instance.createdAt),
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              ref.read(orchestratorStatusProvider.notifier).executeRunInstance(instance.runId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Executing ${instance.runId}...')),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(RunInstanceStatus status) {
    switch (status) {
      case RunInstanceStatus.pending:
        return Colors.orange;
      case RunInstanceStatus.inProgress:
        return Colors.blue;
      case RunInstanceStatus.completed:
        return Colors.green;
      case RunInstanceStatus.failed:
        return Colors.red;
      case RunInstanceStatus.blocked:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(RunInstanceStatus status) {
    switch (status) {
      case RunInstanceStatus.pending:
        return Icons.schedule;
      case RunInstanceStatus.inProgress:
        return Icons.play_arrow;
      case RunInstanceStatus.completed:
        return Icons.check_circle;
      case RunInstanceStatus.failed:
        return Icons.error;
      case RunInstanceStatus.blocked:
        return Icons.block;
    }
  }

  void _showConcurrencyDialog(int currentValue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Max Concurrent Executions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose the maximum number of methodologies that can run simultaneously:'),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<int>(
              value: currentValue,
              items: List.generate(10, (index) => index + 1)
                  .map((value) => DropdownMenuItem(
                        value: value,
                        child: Text(value.toString()),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  ref.read(orchestratorStatusProvider.notifier).setMaxConcurrentExecutions(value);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.day}/${dateTime.month}';
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

  String _formatAssetTypeName(AssetType type) {
    switch (type) {
      case AssetType.networkSegment:
        return 'Network Segment';
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
        return 'Wireless Network';
    }
  }

  // Action handlers
  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_report':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting report...')),
        );
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings coming soon...')),
        );
        break;
    }
  }

  void _refreshAssets() {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ref.refresh(assetsProvider(currentProject.id));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshing assets...')),
    );
  }

  void _runEvaluation() {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      ref.refresh(triggerEvaluationNotifierProvider(currentProject.id));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Running trigger evaluation...')),
    );
  }

  void _viewLogs() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logs coming soon...')),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting data...')),
    );
  }
}

class _StatCard {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCard(this.title, this.value, this.icon, this.color, this.subtitle);
}