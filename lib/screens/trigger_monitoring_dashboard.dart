import 'package:flutter/material.dart';
import 'dart:async';

/// Real-time monitoring dashboard for trigger system
class TriggerMonitoringDashboard extends StatefulWidget {
  const TriggerMonitoringDashboard({super.key});

  @override
  State<TriggerMonitoringDashboard> createState() => _TriggerMonitoringDashboardState();
}

class _TriggerMonitoringDashboardState extends State<TriggerMonitoringDashboard> {
  late Stream<Map<String, dynamic>> _metricsStream;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _metricsStream = _createMetricsStream();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Stream<Map<String, dynamic>> _createMetricsStream() {
    return Stream.periodic(const Duration(seconds: 2), (_) {
      // In production, this would fetch real metrics
      return {
        'performance': {
          'avgEvaluationTime': 45,
          'cacheHitRate': 78,
          'evaluationsPerSecond': 12,
        },
        'quality': {
          'matchRate': 65,
          'successRate': 92,
          'falsePositives': 3,
        },
        'activeExecutions': [
          {
            'id': 'exec1',
            'methodology': 'Network Scan',
            'progress': 0.6,
            'startedAt': DateTime.now().subtract(const Duration(minutes: 2)),
          },
          {
            'id': 'exec2',
            'methodology': 'Service Enumeration',
            'progress': 0.3,
            'startedAt': DateTime.now().subtract(const Duration(minutes: 1)),
          },
        ],
        'recentEvents': [
          {
            'type': 'execution_complete',
            'methodology': 'Port Scan',
            'success': true,
            'timestamp': DateTime.now().subtract(const Duration(minutes: 5)),
          },
          {
            'type': 'trigger_matched',
            'trigger': 'NAC Detection',
            'timestamp': DateTime.now().subtract(const Duration(minutes: 3)),
          },
        ],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trigger System Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _metricsStream = _createMetricsStream();
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _metricsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final metrics = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMetricSection(
                  'Performance',
                  metrics['performance'],
                  [
                    MetricCard(
                      title: 'Evaluation Speed',
                      value: '${metrics['performance']['avgEvaluationTime']}ms',
                      icon: Icons.speed,
                      color: Colors.blue,
                    ),
                    MetricCard(
                      title: 'Cache Hit Rate',
                      value: '${metrics['performance']['cacheHitRate']}%',
                      icon: Icons.cached,
                      color: Colors.green,
                    ),
                    MetricCard(
                      title: 'Throughput',
                      value: '${metrics['performance']['evaluationsPerSecond']}/s',
                      icon: Icons.trending_up,
                      color: Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildMetricSection(
                  'Quality',
                  metrics['quality'],
                  [
                    MetricCard(
                      title: 'Match Rate',
                      value: '${metrics['quality']['matchRate']}%',
                      icon: Icons.check_circle,
                      color: Colors.teal,
                    ),
                    MetricCard(
                      title: 'Success Rate',
                      value: '${metrics['quality']['successRate']}%',
                      icon: Icons.thumb_up,
                      color: Colors.green,
                    ),
                    MetricCard(
                      title: 'False Positives',
                      value: '${metrics['quality']['falsePositives']}%',
                      icon: Icons.error,
                      color: Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildActiveExecutions(metrics['activeExecutions']),
                const SizedBox(height: 24),
                _buildRecentEvents(metrics['recentEvents']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricSection(
    String title,
    Map<String, dynamic> data,
    List<MetricCard> cards,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 3 : 2;
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: cards,
            );
          },
        ),
      ],
    );
  }

  Widget _buildActiveExecutions(List<dynamic> executions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Active Executions',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        if (executions.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: Text('No active executions'),
              ),
            ),
          )
        else
          ...executions.map((exec) => Card(
                child: ListTile(
                  leading: const CircularProgressIndicator(),
                  title: Text(exec['methodology']),
                  subtitle: LinearProgressIndicator(
                    value: exec['progress'].toDouble(),
                  ),
                  trailing: Text(
                    _formatDuration(
                      DateTime.now().difference(exec['startedAt']),
                    ),
                  ),
                ),
              )),
      ],
    );
  }

  Widget _buildRecentEvents(List<dynamic> events) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Events',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: events.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final event = events[index];
              return ListTile(
                leading: _getEventIcon(event['type']),
                title: Text(_getEventTitle(event)),
                subtitle: Text(_formatTimestamp(event['timestamp'])),
                trailing: _getEventTrailing(event),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _getEventIcon(String type) {
    switch (type) {
      case 'execution_complete':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'trigger_matched':
        return const Icon(Icons.flash_on, color: Colors.blue);
      default:
        return const Icon(Icons.info);
    }
  }

  String _getEventTitle(Map<String, dynamic> event) {
    switch (event['type']) {
      case 'execution_complete':
        return 'Completed: ${event['methodology']}';
      case 'trigger_matched':
        return 'Matched: ${event['trigger']}';
      default:
        return 'Event';
    }
  }

  Widget? _getEventTrailing(Map<String, dynamic> event) {
    if (event['type'] == 'execution_complete') {
      return Icon(
        event['success'] ? Icons.check : Icons.error,
        color: event['success'] ? Colors.green : Colors.red,
      );
    }
    return null;
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
    return '${duration.inSeconds}s';
  }

  String _formatTimestamp(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

/// Card displaying a metric value
class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
