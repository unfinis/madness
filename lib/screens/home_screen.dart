import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/responsive_breakpoints.dart';
import '../dialogs/new_project_dialog.dart';
import '../providers/projects_provider.dart';
import '../models/project.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    final crossAxisCount = isDesktop ? 3 : (ResponsiveBreakpoints.isTablet(screenWidth) ? 2 : 1);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back!',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a project to continue or create a new one',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search projects...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    _showNewProjectDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('New Project'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Expanded(
              child: _buildProjectsGrid(context, crossAxisCount),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsGrid(BuildContext context, int crossAxisCount) {
    return Consumer(
      builder: (context, ref, child) {
        final projectsAsync = ref.watch(projectsProvider);
        
        return projectsAsync.when(
          data: (projects) {
            if (projects.isEmpty) {
              return _buildEmptyState(context);
            }
            
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return _ProjectCard(project: project);
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading projects',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(projectsProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
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
              Icons.folder_outlined,
              size: 64,
              color: theme.colorScheme.primary.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No projects yet',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first penetration testing project to get started',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              _showNewProjectDialog(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Create Your First Project'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNewProjectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const NewProjectDialog(),
    );
  }
}

class _ProjectCard extends ConsumerWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () async {
          // Set as current project and navigate to dashboard
          await ref.read(currentProjectProvider.notifier).setCurrentProject(project);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Switched to project: ${project.name}'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: project.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      project.icon,
                      color: project.themeColor,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: project.status.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      project.status.displayName,
                      style: TextStyle(
                        color: project.status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                project.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                project.clientName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    project.dateRange,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: project.progress,
                backgroundColor: theme.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(project.themeColor),
                minHeight: 4,
              ),
              const SizedBox(height: 4),
              Text(
                '${(project.progress * 100).toInt()}% Complete',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


