import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/responsive_breakpoints.dart';
import '../providers/navigation_provider.dart';
import '../providers/projects_provider.dart';
import '../models/project.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  // UI state
  bool _isEditingConstraints = false;
  bool _isEditingRules = false;
  bool _isEditingProject = false;
  bool _isEditingScope = false;
  
  // Controllers
  final _constraintsController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _projectTypeController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _scopeController = TextEditingController();
  List<TextEditingController> _ruleControllers = [];

  @override
  void initState() {
    super.initState();
  }

  void _initializeControllers(Project project) {
    _constraintsController.text = project.constraints;
    _scopeController.text = project.scope;
    _projectNameController.text = project.name;
    _clientNameController.text = project.clientName;
    _projectTypeController.text = project.projectType;
    _startDateController.text = project.dateRange.split(' - ')[0];
    _endDateController.text = project.dateRange.split(' - ')[1];
    _initializeRuleControllers(project.rules);
  }

  void _initializeRuleControllers(List<String> rules) {
    for (final controller in _ruleControllers) {
      controller.dispose();
    }
    _ruleControllers = rules.map((rule) => TextEditingController(text: rule)).toList();
  }

  @override
  void dispose() {
    _constraintsController.dispose();
    _projectNameController.dispose();
    _clientNameController.dispose();
    _projectTypeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _scopeController.dispose();
    for (final controller in _ruleControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    final currentProject = ref.watch(currentProjectProvider);
    
    if (currentProject == null) {
      return _buildNoProjectState(context, theme);
    }

    // Initialize controllers when project changes
    if (_constraintsController.text != currentProject.constraints) {
      _initializeControllers(currentProject);
    }
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProjectHeader(context, theme, currentProject),
            const SizedBox(height: 32),
            _buildProjectInfoSections(context, theme, isDesktop, currentProject),
            const SizedBox(height: 32),
            _buildStatisticsCards(context, theme, isDesktop, currentProject),
          ],
        ),
      ),
    );
  }

  Widget _buildNoProjectState(BuildContext context, ThemeData theme) {
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.dashboard,
                size: 64,
                color: theme.colorScheme.primary.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Project Selected',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please select a project to view its dashboard',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader(BuildContext context, ThemeData theme, Project project) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _isEditingProject
                    ? TextField(
                        controller: _projectNameController,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      )
                    : Text(
                        project.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              if (_isEditingProject) ...[
                TextButton.icon(
                  onPressed: _saveProject,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _cancelProjectEdit,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ] else
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingProject = true;
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit Project'),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _buildProjectDetails(theme, project),
          const SizedBox(height: 24),
          _buildProjectScope(theme),
          const SizedBox(height: 24),
          _buildActionButtons(context, theme),
        ],
      ),
    );
  }

  Widget _buildProjectDetails(ThemeData theme, Project project) {
    if (_isEditingProject) {
      return _buildEditableProjectDetails(theme);
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          childAspectRatio: 3.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildDetailItem(theme, 'Project ID:', project.reference),
            _buildDetailItem(theme, 'Client:', project.clientName),
            _buildDetailItem(theme, 'Type:', project.projectType),
            _buildDetailItem(theme, 'Status:', project.status.displayName, isStatus: true),
            _buildDetailItem(theme, 'Start Date:', project.dateRange.split(' - ')[0]),
            _buildDetailItem(theme, 'End Date:', project.dateRange.split(' - ')[1]),
          ],
        );
      },
    );
  }

  Widget _buildEditableProjectDetails(ThemeData theme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _clientNameController,
                decoration: InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _projectTypeController,
                decoration: InputDecoration(
                  labelText: 'Project Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(ThemeData theme, String label, String value, {bool isStatus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        if (isStatus)
          Consumer(
            builder: (context, ref, child) {
              final currentProject = ref.watch(currentProjectProvider);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: currentProject?.status.color ?? Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          )
        else
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }

  Widget _buildProjectScope(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(
            color: theme.colorScheme.primary,
            width: 4,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Project Scope:',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              if (_isEditingScope) ...[
                TextButton.icon(
                  onPressed: _saveScope,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _cancelScopeEdit,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ] else
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingScope = true;
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _isEditingScope
              ? TextField(
                  controller: _scopeController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: theme.colorScheme.surface,
                    filled: true,
                  ),
                )
              : Consumer(
                  builder: (context, ref, child) {
                    final currentProject = ref.watch(currentProjectProvider);
                    return Text(
                      currentProject?.scope ?? 'No scope defined',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                        height: 1.5,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildActionButton(
          context,
          'Edit Scope',
          () {
            setState(() {
              _isEditingScope = true;
            });
          },
          false,
        ),
        _buildActionButton(
          context,
          'Team Members',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Team members coming soon')),
          ),
          false,
        ),
        _buildActionButton(
          context,
          'Export Project',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Export project coming soon')),
          ),
          false,
        ),
        _buildActionButton(
          context,
          'Archive',
          () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Archive project coming soon')),
          ),
          false,
        ),
        _buildActionButton(
          context,
          '+ Add Finding',
          () {
            ref.read(navigationProvider.notifier).navigateTo(NavigationSection.findings);
          },
          true,
        ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, String label, VoidCallback onPressed, bool isPrimary) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? theme.colorScheme.primary : theme.colorScheme.surface,
        foregroundColor: isPrimary ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        side: isPrimary ? null : BorderSide(color: theme.dividerColor),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: isPrimary ? 2 : 0,
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildProjectInfoSections(BuildContext context, ThemeData theme, bool isDesktop, Project project) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildConstraintsSection(theme, project)),
          const SizedBox(width: 24),
          Expanded(child: _buildRulesSection(theme, project)),
        ],
      );
    } else {
      return Column(
        children: [
          _buildConstraintsSection(theme, project),
          const SizedBox(height: 16),
          _buildRulesSection(theme, project),
        ],
      );
    }
  }

  Widget _buildConstraintsSection(ThemeData theme, Project project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
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
          Row(
            children: [
              const Text(
                '',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Constraints and Observations',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isEditingConstraints) ...[
                TextButton.icon(
                  onPressed: _saveConstraints,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _cancelConstraintsEdit,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ] else
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingConstraints = true;
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _isEditingConstraints
              ? TextField(
                  controller: _constraintsController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    fillColor: theme.colorScheme.surface,
                    filled: true,
                  ),
                )
              : Text(
                  project.constraints,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildRulesSection(ThemeData theme, Project project) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
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
          Row(
            children: [
              const Text(
                '',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Rules of Engagement',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isEditingRules) ...[
                TextButton.icon(
                  onPressed: _saveRules,
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: _cancelRulesEdit,
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ] else
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditingRules = true;
                    });
                  },
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isEditingRules)
            _buildEditableRules(theme)
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: project.rules.map((rule) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildRuleItem(theme, rule),
              )).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildEditableRules(ThemeData theme) {
    return Column(
      children: [
        ...List.generate(_ruleControllers.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ruleControllers[index],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _removeRule(index),
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Remove',
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _addRule,
            icon: const Icon(Icons.add),
            label: const Text('Add Rule'),
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: theme.dividerColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRuleItem(ThemeData theme, String rule) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            rule,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(BuildContext context, ThemeData theme, bool isDesktop, Project project) {
    final crossAxisCount = isDesktop ? 5 : (ResponsiveBreakpoints.isTablet(MediaQuery.of(context).size.width) ? 3 : 2);
    
    return Consumer(
      builder: (context, ref, child) {
        final statsAsync = ref.watch(projectStatisticsProvider(project.id));
        
        return statsAsync.when(
          data: (stats) {
            final statistics = stats ?? ProjectStatistics.empty(project.id);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(theme, '', '${statistics.totalFindings}', 'Total Findings', theme.colorScheme.primary),
                _buildStatCard(theme, '', '${statistics.criticalIssues}', 'Critical Issues', Colors.red),
                _buildStatCard(theme, '', '${statistics.screenshots}', 'Screenshots', theme.colorScheme.secondary),
                _buildStatCard(theme, '', '${statistics.attackChains}', 'Attack Chains', Colors.orange),
                _buildStatCard(theme, '', '${(project.progress * 100).toInt()}%', 'Completion', Colors.green),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildStatCard(theme, '', '0', 'Total Findings', theme.colorScheme.primary),
              _buildStatCard(theme, '', '0', 'Critical Issues', Colors.red),
              _buildStatCard(theme, '', '0', 'Screenshots', theme.colorScheme.secondary),
              _buildStatCard(theme, '', '0', 'Attack Chains', Colors.orange),
              _buildStatCard(theme, '', '${(project.progress * 100).toInt()}%', 'Completion', Colors.green),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(ThemeData theme, String emoji, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
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
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 22,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Edit functionality methods
  void _saveProject() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    try {
      final updatedProject = currentProject.copyWith(
        name: _projectNameController.text,
        clientName: _clientNameController.text,
        projectType: _projectTypeController.text,
      );
      
      await ref.read(currentProjectProvider.notifier).updateCurrentProject(updatedProject);
      await ref.read(projectsProvider.notifier).updateProject(updatedProject);
      
      setState(() {
        _isEditingProject = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project details saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving project: $e')),
        );
      }
    }
  }

  void _cancelProjectEdit() {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      _initializeControllers(currentProject);
    }
    setState(() {
      _isEditingProject = false;
    });
  }

  void _saveScope() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    try {
      final updatedProject = currentProject.copyWith(
        scope: _scopeController.text,
      );
      
      await ref.read(currentProjectProvider.notifier).updateCurrentProject(updatedProject);
      await ref.read(projectsProvider.notifier).updateProject(updatedProject);
      
      setState(() {
        _isEditingScope = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Project scope saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving scope: $e')),
        );
      }
    }
  }

  void _cancelScopeEdit() {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      _scopeController.text = currentProject.scope;
    }
    setState(() {
      _isEditingScope = false;
    });
  }

  void _saveConstraints() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    try {
      final updatedProject = currentProject.copyWith(
        constraints: _constraintsController.text,
      );
      
      await ref.read(currentProjectProvider.notifier).updateCurrentProject(updatedProject);
      await ref.read(projectsProvider.notifier).updateProject(updatedProject);
      
      setState(() {
        _isEditingConstraints = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Constraints saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving constraints: $e')),
        );
      }
    }
  }

  void _cancelConstraintsEdit() {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      _constraintsController.text = currentProject.constraints;
    }
    setState(() {
      _isEditingConstraints = false;
    });
  }

  void _saveRules() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;

    try {
      final rules = _ruleControllers
          .map((controller) => controller.text)
          .where((rule) => rule.isNotEmpty)
          .toList();
      
      final updatedProject = currentProject.copyWith(
        rules: rules,
      );
      
      await ref.read(currentProjectProvider.notifier).updateCurrentProject(updatedProject);
      await ref.read(projectsProvider.notifier).updateProject(updatedProject);
      
      setState(() {
        _isEditingRules = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rules of engagement saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving rules: $e')),
        );
      }
    }
  }

  void _cancelRulesEdit() {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject != null) {
      _initializeRuleControllers(currentProject.rules);
    }
    setState(() {
      _isEditingRules = false;
    });
  }

  void _addRule() {
    setState(() {
      _ruleControllers.add(TextEditingController());
    });
  }

  void _removeRule(int index) {
    setState(() {
      _ruleControllers[index].dispose();
      _ruleControllers.removeAt(index);
    });
  }
}