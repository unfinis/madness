import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/trigger_evaluation.dart';
import '../providers/trigger_evaluation_provider.dart';
import '../providers/projects_provider.dart';
import '../dialogs/trigger_evaluation_detail_dialog.dart';

class TriggerEvaluationDashboardScreen extends ConsumerStatefulWidget {
  const TriggerEvaluationDashboardScreen({super.key});

  @override
  ConsumerState<TriggerEvaluationDashboardScreen> createState() => _TriggerEvaluationDashboardScreenState();
}

class _TriggerEvaluationDashboardScreenState extends ConsumerState<TriggerEvaluationDashboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _autoRefresh = true;
  TriggerFilter _filter = TriggerFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      return const Center(
        child: Text('No project selected'),
      );
    }

    final statsAsync = ref.watch(triggerEvaluationStatsProvider(currentProject.id));
    final performanceStream = ref.watch(triggerEvaluationPerformanceProvider(currentProject.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trigger Evaluation Dashboard'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.access_time),
            onSelected: (value) {
              // Time range selection would be used for filtering data
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '1h', child: Text('Last Hour')),
              const PopupMenuItem(value: '24h', child: Text('Last 24 Hours')),
              const PopupMenuItem(value: '7d', child: Text('Last 7 Days')),
              const PopupMenuItem(value: '30d', child: Text('Last 30 Days')),
            ],
          ),
          IconButton(
            icon: Icon(
              _autoRefresh ? Icons.pause : Icons.play_arrow,
              color: _autoRefresh ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _autoRefresh = !_autoRefresh;
              });
            },
            tooltip: _autoRefresh ? 'Pause Auto Refresh' : 'Start Auto Refresh',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(triggerEvaluationStatsProvider(currentProject.id));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.gps_fixed), text: 'Matches'),
            Tab(icon: Icon(Icons.trending_up), text: 'Performance'),
            Tab(icon: Icon(Icons.settings), text: 'Configuration'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(context, currentProject.id, statsAsync),
          _buildMatchesTab(context, currentProject.id),
          _buildPerformanceTab(context, currentProject.id, performanceStream),
          _buildConfigurationTab(context, currentProject.id),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, String projectId, AsyncValue<Map<String, dynamic>> statsAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistics Cards
          statsAsync.when(
            data: (stats) => _buildStatsGrid(context, stats),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorCard('Statistics Error', error.toString()),
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Recent Trigger Activity',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildRecentActivity(context, projectId),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Evaluation Progress
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.track_changes, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'Evaluation Progress',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildEvaluationProgress(context, projectId),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, Map<String, dynamic> stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildStatCard(
          'Total Matches',
          stats['totalMatches']?.toString() ?? '0',
          Icons.gps_fixed,
          Colors.blue,
        ),
        _buildStatCard(
          'Success Rate',
          '${((stats['successfulMatches'] ?? 0) / (stats['totalMatches'] ?? 1) * 100).toStringAsFixed(1)}%',
          Icons.check_circle,
          Colors.green,
        ),
        _buildStatCard(
          'Active Triggers',
          stats['activeTriggers']?.toString() ?? '0',
          Icons.play_arrow,
          Colors.orange,
        ),
        _buildStatCard(
          'Run Instances',
          stats['runInstances']?.toString() ?? '0',
          Icons.rocket_launch,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchesTab(BuildContext context, String projectId) {
    final successfulMatches = ref.watch(successfulTriggerMatchesProvider(projectId));

    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<TriggerFilter>(
                  segments: const [
                    ButtonSegment(
                      value: TriggerFilter.all,
                      label: Text('All'),
                      icon: Icon(Icons.list),
                    ),
                    ButtonSegment(
                      value: TriggerFilter.successful,
                      label: Text('Successful'),
                      icon: Icon(Icons.check_circle),
                    ),
                    ButtonSegment(
                      value: TriggerFilter.failed,
                      label: Text('Failed'),
                      icon: Icon(Icons.error),
                    ),
                    ButtonSegment(
                      value: TriggerFilter.pending,
                      label: Text('Pending'),
                      icon: Icon(Icons.schedule),
                    ),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (Set<TriggerFilter> selection) {
                    setState(() {
                      _filter = selection.first;
                    });
                  },
                ),
              ),
            ],
          ),
        ),

        // Matches List
        Expanded(
          child: successfulMatches.when(
            data: (matches) {
              final filteredMatches = _filterMatches(matches);

              if (filteredMatches.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getFilterIcon(),
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text('No ${_filter.name} matches found'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredMatches.length,
                itemBuilder: (context, index) {
                  final match = filteredMatches[index];
                  return _buildMatchCard(context, match, projectId);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => _buildErrorCard('Matches Error', error.toString()),
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(BuildContext context, TriggerMatch match, String projectId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
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
            Text('Asset: ${match.assetId}'),
            Text('Confidence: ${(match.confidence * 100).toStringAsFixed(1)}%'),
            Text('Evaluated: ${_formatDateTime(match.evaluatedAt)}'),
            if (match.error != null)
              Text(
                'Error: ${match.error}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getPriorityColor(match.priority).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'P${match.priority}',
                style: TextStyle(
                  color: _getPriorityColor(match.priority),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => _showMatchDetails(context, match),
            ),
          ],
        ),
        onTap: () => _showMatchDetails(context, match),
      ),
    );
  }

  Widget _buildPerformanceTab(BuildContext context, String projectId, AsyncValue<Map<String, dynamic>> performanceStream) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real-time Performance',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  performanceStream.when(
                    data: (data) => _buildPerformanceMetrics(context, data),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Text('Performance monitoring unavailable: $error'),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluation Timeline',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text('Timeline chart would go here'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationTab(BuildContext context, String projectId) {
    final config = ref.watch(triggerEvaluationConfigProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Evaluation Settings',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Auto Evaluation'),
                    subtitle: const Text('Automatically evaluate triggers when assets change'),
                    value: config.autoEvaluationEnabled,
                    onChanged: (value) {
                      ref.read(triggerEvaluationConfigProvider.notifier).state =
                          config.copyWith(autoEvaluationEnabled: value);
                    },
                  ),
                  ListTile(
                    title: const Text('Evaluation Interval'),
                    subtitle: Text('${config.evaluationInterval.inMinutes} minutes'),
                    trailing: DropdownButton<int>(
                      value: config.evaluationInterval.inMinutes,
                      items: [1, 5, 10, 15, 30, 60].map((minutes) =>
                        DropdownMenuItem(
                          value: minutes,
                          child: Text('$minutes min'),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(triggerEvaluationConfigProvider.notifier).state =
                              config.copyWith(evaluationInterval: Duration(minutes: value));
                        }
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Max Concurrent Evaluations'),
                    subtitle: Text('${config.maxConcurrentEvaluations} parallel evaluations'),
                    trailing: DropdownButton<int>(
                      value: config.maxConcurrentEvaluations,
                      items: [1, 5, 10, 20, 50].map((count) =>
                        DropdownMenuItem(
                          value: count,
                          child: Text('$count'),
                        ),
                      ).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(triggerEvaluationConfigProvider.notifier).state =
                              config.copyWith(maxConcurrentEvaluations: value);
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Debug Mode'),
                    subtitle: const Text('Enable detailed evaluation logging'),
                    value: config.debugMode,
                    onChanged: (value) {
                      ref.read(triggerEvaluationConfigProvider.notifier).state =
                          config.copyWith(debugMode: value);
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _evaluateAllAssets(context, projectId),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Evaluate All Assets'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _clearEvaluationHistory(context, projectId),
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear History'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context, String projectId) {
    final recentMatches = ref.watch(successfulTriggerMatchesProvider(projectId));

    return recentMatches.when(
      data: (matches) {
        final recent = matches.take(5).toList();
        if (recent.isEmpty) {
          return const Text('No recent activity');
        }

        return Column(
          children: recent.map((match) => ListTile(
            dense: true,
            leading: Icon(
              match.matched ? Icons.check_circle : Icons.error,
              color: match.matched ? Colors.green : Colors.red,
              size: 20,
            ),
            title: Text('${match.triggerId} → ${match.assetId}'),
            subtitle: Text(_formatDateTime(match.evaluatedAt)),
            trailing: Text('P${match.priority}'),
          )).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error loading recent activity: $error'),
    );
  }

  Widget _buildEvaluationProgress(BuildContext context, String projectId) {
    // This would show progress of ongoing evaluations
    return const Column(
      children: [
        LinearProgressIndicator(value: 0.7),
        SizedBox(height: 8),
        Text('Evaluating assets... 7 of 10 complete'),
      ],
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, Map<String, dynamic> data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricTile('Evaluation Cycle', '#${data['evaluationCycle']}'),
            ),
            Expanded(
              child: _buildMetricTile('Last Update', _formatDateTime(DateTime.parse(data['timestamp']))),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildErrorCard(String title, String error) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(error),
          ],
        ),
      ),
    );
  }

  List<TriggerMatch> _filterMatches(List<TriggerMatch> matches) {
    switch (_filter) {
      case TriggerFilter.successful:
        return matches.where((m) => m.matched && m.error == null).toList();
      case TriggerFilter.failed:
        return matches.where((m) => !m.matched || m.error != null).toList();
      case TriggerFilter.pending:
        // This would filter for pending evaluations if we had that state
        return [];
      case TriggerFilter.all:
        return matches;
    }
  }

  IconData _getFilterIcon() {
    switch (_filter) {
      case TriggerFilter.successful:
        return Icons.check_circle;
      case TriggerFilter.failed:
        return Icons.error;
      case TriggerFilter.pending:
        return Icons.schedule;
      case TriggerFilter.all:
        return Icons.list;
    }
  }

  Color _getPriorityColor(int priority) {
    if (priority <= 2) return Colors.red;
    if (priority <= 5) return Colors.orange;
    if (priority <= 7) return Colors.blue;
    return Colors.green;
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showMatchDetails(BuildContext context, TriggerMatch match) {
    showDialog(
      context: context,
      builder: (context) => TriggerEvaluationDetailDialog(match: match),
    );
  }

  void _evaluateAllAssets(BuildContext context, String projectId) async {
    try {
      await ref.read(triggerEvaluationNotifierProvider(projectId).notifier).evaluateAllAssets();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Asset evaluation started')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting evaluation: $e')),
        );
      }
    }
  }

  void _clearEvaluationHistory(BuildContext context, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Evaluation History'),
        content: const Text('Are you sure you want to clear all trigger evaluation history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement clear history
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Evaluation history cleared')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

enum TriggerFilter {
  all,
  successful,
  failed,
  pending,
}