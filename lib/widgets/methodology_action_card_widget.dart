import 'package:flutter/material.dart';
import '../models/methodology_execution.dart';

class MethodologyActionCardWidget extends StatelessWidget {
  const MethodologyActionCardWidget({
    super.key,
    this.execution,
    this.recommendation,
    required this.onTap,
    this.onDismiss,
  }) : assert(execution != null || recommendation != null, 'Either execution or recommendation must be provided');

  final MethodologyExecution? execution;
  final MethodologyRecommendation? recommendation;
  final VoidCallback onTap;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRecommendation = recommendation != null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isRecommendation 
                  ? theme.colorScheme.primary.withOpacity(0.3)
                  : theme.dividerColor,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status icon
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _getStatusIcon(),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Title and meta
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getDescription(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Actions
                  if (onDismiss != null)
                    IconButton(
                      onPressed: onDismiss,
                      icon: const Icon(Icons.close, size: 16),
                      constraints: const BoxConstraints(
                        minWidth: 24,
                        minHeight: 24,
                      ),
                      tooltip: 'Dismiss',
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Meta information
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getToolInfo(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _getTimeInfo(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Bottom section
              if (execution != null)
                _buildExecutionBottomSection(theme)
              else if (recommendation != null)
                _buildRecommendationBottomSection(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExecutionBottomSection(ThemeData theme) {
    final exec = execution!;
    
    if (exec.status == ExecutionStatus.inProgress) {
      // Show progress bar
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Progress: ${(exec.progress * 100).toInt()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'Step ${exec.currentStepIndex + 1}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: exec.progress,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
          ),
        ],
      );
    } else if (exec.status == ExecutionStatus.completed) {
      // Show findings badge
      final findings = exec.discoveredAssetIds.length;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          findings > 0 ? '$findings findings' : 'No findings',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    } else {
      // Show status
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          exec.status.displayName,
          style: theme.textTheme.bodySmall?.copyWith(
            color: _getStatusColor(),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
  }

  Widget _buildRecommendationBottomSection(ThemeData theme) {
    final rec = recommendation!;
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Priority ${rec.priority}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${(rec.confidence * 100).toInt()}% confidence',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getTitle() {
    if (execution != null) {
      // For now, return a placeholder. In real implementation, we'd look up the methodology
      return 'Methodology Action ${execution!.id.substring(0, 8)}';
    } else {
      return 'Recommended Action ${recommendation!.id.substring(0, 8)}';
    }
  }

  String _getDescription() {
    if (execution != null) {
      return 'Execute methodology steps and track progress';
    } else {
      return recommendation!.reason;
    }
  }

  String _getStatusIcon() {
    if (execution != null) {
      return execution!.status.icon;
    } else {
      return '💡';
    }
  }

  Color _getStatusColor() {
    if (execution != null) {
      return execution!.status.color;
    } else {
      return Colors.blue;
    }
  }

  String _getToolInfo() {
    if (execution != null) {
      return '🛠️ Methodology';
    } else {
      return '💡 Recommended';
    }
  }

  String _getTimeInfo() {
    if (execution != null) {
      final duration = DateTime.now().difference(execution!.startedDate);
      if (duration.inDays > 0) {
        return '${duration.inDays}d ago';
      } else if (duration.inHours > 0) {
        return '${duration.inHours}h ago';
      } else if (duration.inMinutes > 0) {
        return '${duration.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } else {
      final duration = DateTime.now().difference(recommendation!.createdDate);
      if (duration.inDays > 0) {
        return '${duration.inDays}d ago';
      } else if (duration.inHours > 0) {
        return '${duration.inHours}h ago';
      } else if (duration.inMinutes > 0) {
        return '${duration.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    }
  }
}