import 'package:flutter/material.dart';
import '../../services/trigger_system/models/trigger_match_result.dart';

/// Visual indicator showing whether a trigger matched
class TriggerMatchIndicator extends StatelessWidget {
  final TriggerMatchResult match;
  final bool showLabel;

  const TriggerMatchIndicator({
    super.key,
    required this.match,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          match.matched ? Icons.check_circle : Icons.cancel,
          color: match.matched ? Colors.green : Colors.grey,
          size: 20,
        ),
        if (showLabel) ...[
          const SizedBox(width: 8),
          Text(
            match.matched ? 'Match' : 'No Match',
            style: TextStyle(
              color: match.matched ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }
}

/// Compact chip version of the match indicator
class TriggerMatchChip extends StatelessWidget {
  final bool matched;
  final String? label;

  const TriggerMatchChip({
    super.key,
    required this.matched,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(
        matched ? Icons.check_circle : Icons.cancel,
        color: matched ? Colors.green : Colors.grey,
        size: 16,
      ),
      label: Text(
        label ?? (matched ? 'Matched' : 'Not Matched'),
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: matched ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
      side: BorderSide(
        color: matched ? Colors.green : Colors.grey,
      ),
    );
  }
}
