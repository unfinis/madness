import 'package:flutter/material.dart';
import '../models/methodology_execution.dart';

class MethodologyActionDetailDialog extends StatelessWidget {
  const MethodologyActionDetailDialog({
    super.key,
    this.execution,
  });

  final MethodologyExecution? execution;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        constraints: const BoxConstraints(
          maxWidth: 800,
          maxHeight: 600,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.assignment,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          execution != null 
                              ? 'Methodology Execution Details'
                              : 'Action Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (execution != null)
                          Text(
                            'ID: ${execution!.id}',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: execution != null 
                  ? _buildExecutionContent(context)
                  : _buildEmptyContent(context),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  if (execution != null && !execution!.isCompleted) ...[
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () {
                        // TODO: Implement action controls (pause/resume/stop)
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Action controls not yet implemented')),
                        );
                      },
                      child: Text(execution!.isInProgress ? 'Pause' : 'Resume'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutionContent(BuildContext context) {
    final exec = execution!;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status and Progress Section
          _buildStatusSection(context, exec),
          
          const SizedBox(height: 24),
          
          // Steps Section
          _buildStepsSection(context, exec),
          
          const SizedBox(height: 24),
          
          // Discovered Assets Section
          if (exec.discoveredAssetIds.isNotEmpty)
            _buildDiscoveredAssetsSection(context, exec),
          
          const SizedBox(height: 24),
          
          // Execution Context Section
          if (exec.executionContext.isNotEmpty)
            _buildExecutionContextSection(context, exec),
        ],
      ),
    );
  }

  Widget _buildEmptyContent(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No execution data available',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(BuildContext context, MethodologyExecution exec) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Execution Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: exec.status.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: exec.status.color.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(exec.status.icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        exec.status.displayName,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: exec.status.color,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                Text(
                  'Progress: ${(exec.progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            LinearProgressIndicator(
              value: exec.progress,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context,
                    'Started',
                    _formatDateTime(exec.startedDate),
                  ),
                ),
                if (exec.completedDate != null)
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      'Completed',
                      _formatDateTime(exec.completedDate!),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepsSection(BuildContext context, MethodologyExecution exec) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Execution Steps',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            if (exec.stepExecutions.isEmpty)
              const Text('No steps executed yet')
            else
              Column(
                children: exec.stepExecutions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  final isActive = index == exec.currentStepIndex;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isActive 
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isActive 
                            ? Theme.of(context).colorScheme.primary.withOpacity(0.3)
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: step.status.color,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              step.status.icon,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Step ${index + 1}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (step.command.isNotEmpty)
                                Text(
                                  step.command,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontFamily: 'monospace',
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        Text(
                          step.status.displayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: step.status.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveredAssetsSection(BuildContext context, MethodologyExecution exec) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Discovered Assets',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exec.discoveredAssetIds.map((assetId) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    assetId.substring(0, 8),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutionContextSection(BuildContext context, MethodologyExecution exec) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Execution Context',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText(
                  exec.executionContext.toString(),
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
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
}