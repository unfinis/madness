import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

/// A standardized statistics chip used across different screens
class StatChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const StatChip({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// A standardized stats bar that displays chips in a responsive wrapped layout
class StandardStatsBar extends StatelessWidget {
  final List<StatChip> chips;
  final EdgeInsets? padding;

  const StandardStatsBar({
    super.key,
    required this.chips,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      alignment: Alignment.center,
      child: Wrap(
        textDirection: TextDirection.ltr,
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: chips,
      ),
    );
  }
}

/// A data class to hold stat information
class StatData {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const StatData({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}

/// Helper to build stats from data list
class StatsHelper {
  static List<StatChip> buildChips(List<StatData> stats) {
    return stats.map((stat) => StatChip(
      label: stat.label,
      count: stat.count,
      icon: stat.icon,
      color: stat.color,
    )).toList();
  }
}