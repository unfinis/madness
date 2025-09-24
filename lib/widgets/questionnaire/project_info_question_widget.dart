/// Project information widget for questionnaire system
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/project.dart';
import '../../providers/projects_provider.dart';
import '../../constants/app_spacing.dart';
import 'question_widget_base.dart';

class ProjectInfoQuestionWidget extends QuestionWidgetBase {
  const ProjectInfoQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<ProjectInfoQuestionWidget> createState() => _ProjectInfoQuestionWidgetState();
}

class _ProjectInfoQuestionWidgetState extends QuestionWidgetBaseState<ProjectInfoQuestionWidget> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget buildQuestionContent(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final project = ref.watch(currentProjectProvider);
        
        if (project == null) {
          return _buildNoProjectState(context);
        }

        return _buildProjectInfoTabs(context, project);
      },
    );
  }

  Widget _buildNoProjectState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 48,
            color: theme.colorScheme.primary,
          ),
          AppSpacing.vGapMD,
          Text(
            'No Project Selected',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapSM,
          Text(
            'Please select a project to view and confirm project information.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.vGapLG,
          FilledButton(
            onPressed: () => updateAnswer('completed'),
            child: const Text('Continue Without Project'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectInfoTabs(BuildContext context, Project project) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assignment,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Overview',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Review and confirm project details',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton(
                  onPressed: () => updateAnswer('confirmed'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                  ),
                  child: const Text('Confirm Details'),
                ),
              ],
            ),
          ),
          
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
            tabs: const [
              Tab(
                icon: Icon(Icons.info_outline),
                text: 'Overview',
              ),
              Tab(
                icon: Icon(Icons.schedule),
                text: 'Timeline',
              ),
              Tab(
                icon: Icon(Icons.people_outline),
                text: 'Contacts',
              ),
            ],
          ),
          
          // Tab Content
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, project),
                _buildTimelineTab(context, project),
                _buildContactsTab(context, project),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, Project project) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem(
            context,
            'Project Name',
            project.name,
            Icons.assignment,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'Reference ID',
            project.reference,
            Icons.tag,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'Client',
            project.clientName,
            Icons.business,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'Project Type',
            project.projectType,
            Icons.category,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'Status',
            project.status.displayName,
            Icons.flag,
            statusColor: project.status.color,
          ),
          if (project.description?.isNotEmpty == true) ...[
            AppSpacing.vGapMD,
            _buildInfoItem(
              context,
              'Description',
              project.description!,
              Icons.description,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineTab(BuildContext context, Project project) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoItem(
            context,
            'Start Date',
            '${project.startDate.day}/${project.startDate.month}/${project.startDate.year}',
            Icons.event,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'End Date',
            '${project.endDate.day}/${project.endDate.month}/${project.endDate.year}',
            Icons.event,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'Duration',
            '${project.endDate.difference(project.startDate).inDays} days',
            Icons.schedule,
          ),
          AppSpacing.vGapMD,
          _buildInfoItem(
            context,
            'Progress',
            '${(project.progress * 100).round()}%',
            Icons.trending_up,
          ),
        ],
      ),
    );
  }

  Widget _buildContactsTab(BuildContext context, Project project) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (project.contactPerson?.isNotEmpty == true)
            _buildInfoItem(
              context,
              'Primary Contact',
              project.contactPerson!,
              Icons.person,
            ),
          if (project.contactEmail?.isNotEmpty == true) ...[
            AppSpacing.vGapMD,
            _buildInfoItem(
              context,
              'Contact Email',
              project.contactEmail!,
              Icons.email,
            ),
          ],
          AppSpacing.vGapLG,
          Text(
            'Assessment Scope',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vGapSM,
          Expanded(
            child: ListView(
              children: project.assessmentScope.entries
                  .where((entry) => entry.value)
                  .map((entry) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            AppSpacing.hGapSM,
                            Text(
                              entry.key.replaceAll('_', ' ').toUpperCase(),
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? statusColor,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: statusColor ?? theme.colorScheme.primary,
          ),
          AppSpacing.hGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: statusColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}