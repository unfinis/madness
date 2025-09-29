import 'package:flutter/material.dart';
import '../services/methodology_loader.dart' as loader;
import '../constants/app_spacing.dart';

class MethodologyTemplateCard extends StatelessWidget {
  final loader.MethodologyTemplate template;
  final VoidCallback onTap;
  final VoidCallback? onExecute;

  const MethodologyTemplateCard({
    super.key,
    required this.template,
    required this.onTap,
    this.onExecute,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and risk level
              Row(
                children: [
                  Expanded(
                    child: Text(
                      template.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildRiskBadge(context),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Description
              Text(
                template.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.md),

              // Metadata row
              Row(
                children: [
                  _buildMetadataChip(
                    context,
                    Icons.category,
                    template.workstream,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildMetadataChip(
                    context,
                    Icons.flash_on,
                    '${template.triggers.length} triggers',
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _buildMetadataChip(
                    context,
                    Icons.list,
                    '${template.procedures.length} procedures',
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.sm),

              // Tags
              if (template.tags.isNotEmpty) ...[
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: template.tags.take(5).map((tag) =>
                    Chip(
                      label: Text(
                        tag,
                        style: const TextStyle(fontSize: 11),
                      ),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    ),
                  ).toList(),
                ),
              ],

              const SizedBox(height: AppSpacing.md),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                  ),
                  if (onExecute != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: onExecute,
                      icon: const Icon(Icons.play_arrow, size: 16),
                      label: const Text('Execute'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRiskBadge(BuildContext context) {
    Color color;
    IconData icon;

    switch (template.riskLevel) {
      case 'low':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'medium':
        color = Colors.orange;
        icon = Icons.warning;
        break;
      case 'high':
        color = Colors.red;
        icon = Icons.error;
        break;
      case 'critical':
        color = Colors.purple;
        icon = Icons.dangerous;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            template.riskLevel.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}