import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import '../providers/methodology_provider.dart';
import '../providers/projects_provider.dart';
import '../widgets/methodology_summary_widget.dart';
import '../widgets/methodology_filters_widget.dart';
import '../widgets/methodology_action_card_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../dialogs/methodology_action_detail_dialog.dart';
import '../dialogs/import_methodology_dialog.dart';

class MethodologyScreen extends ConsumerStatefulWidget {
  const MethodologyScreen({super.key});

  @override
  ConsumerState<MethodologyScreen> createState() => _MethodologyScreenState();
}

class _MethodologyScreenState extends ConsumerState<MethodologyScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);
    
    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    final methodologyState = ref.watch(methodologyProvider(currentProject.id));
    final filteredExecutions = ref.watch(filteredExecutionsProvider(currentProject.id));
    final recommendations = ref.watch(filteredRecommendationsProvider(currentProject.id));

    return ScreenWrapper(
      children: [
        const MethodologySummaryWidget(compact: true),
        SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🔍 Testing Methodology',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: CommonLayoutWidgets.compactSpacing),
                            Text(
                              'Define and track testing procedures and actions',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ..._buildHeaderActions(context, currentProject.id),
                    ],
                  ),
                ],
              ),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              // Methodology Stats
              _buildMethodologyStats(context, currentProject.id),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              // Filters and Search
              MethodologyFiltersWidget(searchController: _searchController),
              SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              // Content based on state
              if (methodologyState.isLoading)
                CommonStateWidgets.loadingWithPadding(message: 'Loading methodologies...')
              else if (methodologyState.error != null)
                CommonStateWidgets.error(
                  methodologyState.error!,
                  onRetry: () => ref.refresh(methodologyProvider(currentProject.id)),
                )
              else
                _buildMethodologyContent(context, currentProject.id, filteredExecutions, recommendations),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildHeaderActions(BuildContext context, String projectId) {
    return [
      OutlinedButton.icon(
        onPressed: () => _showImportDialog(context),
        icon: const Icon(Icons.upload, size: 18),
        label: const Text('Import Template'),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      const SizedBox(width: 8),
      FilledButton.icon(
        onPressed: () => _showAddActionDialog(context, projectId),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Action'),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    ];
  }

  Widget _buildMethodologyStats(BuildContext context, String projectId) {
    final stats = ref.watch(methodologyStatsProvider(projectId));
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.assignment,
            value: stats.totalActions.toString(),
            label: 'Total Actions',
            sublabel: 'Planned',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.play_circle,
            value: stats.inProgressCount.toString(),
            label: 'In Progress',
            sublabel: 'Active',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.check_circle,
            value: stats.completedCount.toString(),
            label: 'Completed',
            sublabel: 'Finished',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            context,
            icon: Icons.pending,
            value: stats.pendingCount.toString(),
            label: 'Pending',
            sublabel: 'Not Started',
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required String sublabel,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: effectiveColor, size: 20),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: effectiveColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            sublabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodologyContent(
    BuildContext context,
    String projectId,
    List<MethodologyExecution> executions,
    List<MethodologyRecommendation> recommendations,
  ) {
    final selectedCategory = ref.watch(methodologyProvider(projectId)).selectedCategory;
    
    if (executions.isEmpty && recommendations.isEmpty) {
      return CommonStateWidgets.noData(
        itemName: 'methodology actions',
        icon: Icons.assignment_outlined,
        onCreate: () => _showAddActionDialog(context, projectId),
        createButtonText: 'Add First Action',
      );
    }

    // Group actions by category
    final actionsByCategory = <MethodologyCategory, List<dynamic>>{};
    
    // Add executions grouped by their methodology category
    for (final execution in executions) {
      // For now, we'll use reconnaissance as default since we need the actual methodology
      // In a real implementation, we'd look up the methodology to get its category
      final category = MethodologyCategory.reconnaissance;
      actionsByCategory.putIfAbsent(category, () => []);
      actionsByCategory[category]!.add(execution);
    }
    
    // Add recommendations grouped by their methodology category
    for (final recommendation in recommendations) {
      // Similar to above, we'd need to look up the methodology
      final category = MethodologyCategory.reconnaissance;
      actionsByCategory.putIfAbsent(category, () => []);
      actionsByCategory[category]!.add(recommendation);
    }

    // Filter by selected category if any
    final categories = selectedCategory != null 
        ? [selectedCategory] 
        : MethodologyCategory.values;

    return Column(
      children: categories.where((category) => actionsByCategory.containsKey(category)).map((category) {
        final actions = actionsByCategory[category]!;
        final completed = actions.where((action) {
          if (action is MethodologyExecution) return action.isCompleted;
          return false;
        }).length;
        
        return _buildPhaseSection(
          context,
          category,
          actions,
          completed,
          projectId,
        );
      }).toList(),
    );
  }

  Widget _buildPhaseSection(
    BuildContext context,
    MethodologyCategory category,
    List<dynamic> actions,
    int completed,
    String projectId,
  ) {
    final theme = Theme.of(context);
    final progressPercent = actions.isEmpty ? 0.0 : (completed / actions.length);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phase header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: category.color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Text(
                '${category.icon} ${category.displayName}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: category.color,
                ),
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$completed/${actions.length} Complete',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: category.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 100,
                    height: 6,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 100 * progressPercent,
                        height: 6,
                        decoration: BoxDecoration(
                          color: category.color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        SizedBox(height: CommonLayoutWidgets.itemSpacing),
        
        // Actions grid
        _buildActionsGrid(context, actions, projectId),
        
        SizedBox(height: CommonLayoutWidgets.sectionSpacing),
      ],
    );
  }

  Widget _buildActionsGrid(BuildContext context, List<dynamic> actions, String projectId) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        childAspectRatio: 1.2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        
        if (action is MethodologyExecution) {
          return MethodologyActionCardWidget(
            execution: action,
            onTap: () => _showActionDetailDialog(context, execution: action),
          );
        } else if (action is MethodologyRecommendation) {
          return MethodologyActionCardWidget(
            recommendation: action,
            onTap: () => _startRecommendedMethodology(projectId, action),
            onDismiss: () => ref.read(methodologyProvider(projectId).notifier)
                .dismissRecommendation(action.id),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1400) return 4;
    if (screenWidth > 1000) return 3;
    if (screenWidth > 600) return 2;
    return 1;
  }

  void _showAddActionDialog(BuildContext context, String projectId) {
    // For now, show a simple dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Action'),
        content: const Text('This feature will allow you to add custom methodology actions.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ImportMethodologyDialog(),
    );
  }

  void _showActionDetailDialog(BuildContext context, {MethodologyExecution? execution}) {
    showDialog(
      context: context,
      builder: (context) => MethodologyActionDetailDialog(execution: execution),
    );
  }

  void _startRecommendedMethodology(String projectId, MethodologyRecommendation recommendation) {
    ref.read(methodologyProvider(projectId).notifier)
        .startMethodology(recommendation.methodologyId, additionalContext: recommendation.context);
  }
}