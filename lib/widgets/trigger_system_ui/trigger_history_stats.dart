import 'package:flutter/material.dart';
import '../../services/trigger_system/execution_history.dart';

/// Widget displaying historical performance statistics for a trigger
class TriggerHistoryStats extends StatelessWidget {
  final String triggerId;
  final ExecutionHistory history;

  const TriggerHistoryStats({
    super.key,
    required this.triggerId,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final stats = history.getStats(triggerId);

    if (stats.totalExecutions == 0) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: const Text(
          'No historical data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Historical Performance',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat(
                'Success Rate',
                '${(stats.successRate * 100).toStringAsFixed(1)}%',
                _getSuccessColor(stats.successRate),
                Icons.thumb_up,
              ),
              _buildStat(
                'Total Runs',
                '${stats.totalExecutions}',
                Colors.blue,
                Icons.play_circle,
              ),
              _buildStat(
                'Avg Time',
                _formatDuration(stats.averageExecutionTime),
                Colors.purple,
                Icons.timer,
              ),
            ],
          ),
          if (stats.failureCount > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${stats.failureCount} failures',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getSuccessColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.orange;
    return Colors.red;
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}

/// Compact version of history stats
class TriggerHistoryStatsCompact extends StatelessWidget {
  final String triggerId;
  final ExecutionHistory history;

  const TriggerHistoryStatsCompact({
    super.key,
    required this.triggerId,
    required this.history,
  });

  @override
  Widget build(BuildContext context) {
    final stats = history.getStats(triggerId);

    if (stats.totalExecutions == 0) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCompactStat(
          Icons.check_circle,
          '${(stats.successRate * 100).toInt()}%',
          Colors.green,
        ),
        const SizedBox(width: 8),
        _buildCompactStat(
          Icons.play_circle,
          '${stats.totalExecutions}',
          Colors.blue,
        ),
      ],
    );
  }

  Widget _buildCompactStat(IconData icon, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
