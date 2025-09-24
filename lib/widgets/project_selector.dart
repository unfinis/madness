import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project.dart';
import '../providers/projects_provider.dart';

class ProjectSelector extends ConsumerWidget {
  const ProjectSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentProject = ref.watch(currentProjectProvider);
    final allProjectsAsync = ref.watch(projectsProvider);

    if (currentProject == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              'No Project Selected',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return PopupMenuButton<Project>(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: currentProject.themeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                currentProject.icon,
                size: 16,
                color: currentProject.themeColor,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    currentProject.name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '#${currentProject.reference}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.expand_more,
              size: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
      itemBuilder: (context) {
        return allProjectsAsync.when(
          data: (projects) {
            final items = <PopupMenuEntry<Project>>[];
            
            // Add current project at top if not in the list
            if (!projects.any((p) => p.id == currentProject.id)) {
              items.add(
                PopupMenuItem(
                  value: currentProject,
                  child: _ProjectMenuItem(
                    project: currentProject,
                    isSelected: true,
                  ),
                ),
              );
              if (projects.isNotEmpty) {
                items.add(const PopupMenuDivider());
              }
            }
            
            // Add all other projects
            for (final project in projects) {
              items.add(
                PopupMenuItem(
                  value: project,
                  child: _ProjectMenuItem(
                    project: project,
                    isSelected: project.id == currentProject.id,
                  ),
                ),
              );
            }
            
            return items;
          },
          loading: () => [
            const PopupMenuItem(
              enabled: false,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('Loading projects...'),
                ],
              ),
            ),
          ],
          error: (error, stackTrace) => [
            const PopupMenuItem(
              enabled: false,
              child: Row(
                children: [
                  Icon(Icons.error, size: 16),
                  SizedBox(width: 12),
                  Text('Error loading projects'),
                ],
              ),
            ),
          ],
        );
      },
      onSelected: (project) {
        if (project.id != currentProject.id) {
          ref.read(currentProjectProvider.notifier).setCurrentProject(project);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Switched to project: ${project.name}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}

class _ProjectMenuItem extends StatelessWidget {
  final Project project;
  final bool isSelected;

  const _ProjectMenuItem({
    required this.project,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: project.themeColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              project.icon,
              size: 18,
              color: project.themeColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        project.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: project.status.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        project.status.displayName,
                        style: TextStyle(
                          color: project.status.color,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '#${project.reference}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      project.clientName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isSelected) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.check_circle,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ],
      ),
    );
  }
}