import 'package:flutter/material.dart';
import '../../providers/task_queue_provider.dart';

/// Shared widget for displaying trigger status icons consistently across the app
class TriggerStatusIcon extends StatelessWidget {
  final TriggerStatus status;
  final double size;

  const TriggerStatusIcon({
    super.key,
    required this.status,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, color) = _getIconAndColor(status);
    return Icon(icon, size: size, color: color);
  }

  /// Static method to build icon without widget wrapper
  static Icon buildIcon(TriggerStatus status, {double size = 16}) {
    final (icon, color) = _getIconAndColor(status);
    return Icon(icon, size: size, color: color);
  }

  static (IconData, Color) _getIconAndColor(TriggerStatus status) {
    return switch (status) {
      TriggerStatus.pending => (Icons.radio_button_unchecked, Colors.grey),
      TriggerStatus.running => (Icons.play_circle_outline, Colors.blue),
      TriggerStatus.completed => (Icons.check_circle_outline, Colors.green),
      TriggerStatus.failed => (Icons.error_outline, Colors.red),
      TriggerStatus.skipped => (Icons.skip_next, Colors.orange),
    };
  }
}

/// Utility class for getting display text for triggers
class TriggerDisplayUtils {
  /// Get formatted display text for a trigger instance
  static String getText(TriggerInstance trigger) {
    final asset = trigger.context['asset'] as Map<String, dynamic>?;
    if (asset != null) {
      final host = asset['host'] ?? asset['identifier'] ?? '';
      final type = asset['type'] ?? '';
      if (type.isNotEmpty && host.isNotEmpty) {
        return '$type: $host';
      } else if (host.isNotEmpty) {
        return host;
      } else if (type.isNotEmpty) {
        return type;
      }
    }
    return 'Trigger ${trigger.triggerId}';
  }

  /// Get short display text (for compact views)
  static String getShortText(TriggerInstance trigger) {
    final asset = trigger.context['asset'] as Map<String, dynamic>?;
    if (asset != null) {
      return asset['identifier'] ?? asset['host'] ?? trigger.triggerId;
    }
    return trigger.triggerId;
  }

  /// Get status text
  static String getStatusText(TriggerStatus status) {
    return switch (status) {
      TriggerStatus.pending => 'Pending',
      TriggerStatus.running => 'Running',
      TriggerStatus.completed => 'Completed',
      TriggerStatus.failed => 'Failed',
      TriggerStatus.skipped => 'Skipped',
    };
  }
}

/// Reusable trigger list item widget
class TriggerListItem extends StatelessWidget {
  final TriggerInstance trigger;
  final VoidCallback? onTap;
  final bool showStatus;
  final bool compact;

  const TriggerListItem({
    super.key,
    required this.trigger,
    this.onTap,
    this.showStatus = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: compact ? 2.0 : 4.0,
          horizontal: compact ? 4.0 : 8.0,
        ),
        child: Row(
          children: [
            if (showStatus) ...[
              TriggerStatusIcon(
                status: trigger.status,
                size: compact ? 14 : 16,
              ),
              SizedBox(width: compact ? 4 : 8),
            ],
            Expanded(
              child: Text(
                compact
                    ? TriggerDisplayUtils.getShortText(trigger)
                    : TriggerDisplayUtils.getText(trigger),
                style: compact
                    ? textTheme.bodySmall
                    : textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trigger.executedDate != null)
              Text(
                _formatTime(trigger.executedDate!),
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}