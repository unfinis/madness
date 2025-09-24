import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/project.dart';
import '../database/database.dart';
import 'database_provider.dart';

// Current active project provider
final currentProjectProvider = StateNotifierProvider<CurrentProjectNotifier, Project?>((ref) {
  return CurrentProjectNotifier(ref.read(databaseProvider));
});

// All projects provider
final projectsProvider = StateNotifierProvider<ProjectsNotifier, AsyncValue<List<Project>>>((ref) {
  return ProjectsNotifier(ref.read(databaseProvider));
});

// Project statistics provider
final projectStatisticsProvider = StateNotifierProvider.family<ProjectStatisticsNotifier, AsyncValue<ProjectStatistics?>, String>((ref, projectId) {
  return ProjectStatisticsNotifier(ref.read(databaseProvider), projectId);
});

class CurrentProjectNotifier extends StateNotifier<Project?> {
  final MadnessDatabase _database;

  CurrentProjectNotifier(this._database) : super(null) {
    _loadMostRecentProject();
  }

  Future<void> _loadMostRecentProject() async {
    try {
      final project = await _database.getMostRecentProject();
      state = project;
    } catch (e) {
      // Handle error - for now just stay null
      state = null;
    }
  }

  Future<void> setCurrentProject(Project project) async {
    state = project;
    
    // Update the project's updated_date to mark it as most recently accessed
    final updatedProject = project.copyWith(updatedDate: DateTime.now());
    await _database.updateProject(updatedProject);
    state = updatedProject;
  }

  Future<void> updateCurrentProject(Project updatedProject) async {
    await _database.updateProject(updatedProject);
    state = updatedProject;
  }

  void clearCurrentProject() {
    state = null;
  }
}

class ProjectsNotifier extends StateNotifier<AsyncValue<List<Project>>> {
  final MadnessDatabase _database;

  ProjectsNotifier(this._database) : super(const AsyncValue.loading()) {
    loadProjects();
  }

  Future<void> loadProjects() async {
    try {
      state = const AsyncValue.loading();
      final projects = await _database.getAllProjects();
      state = AsyncValue.data(projects);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<Project> createProject({
    required String name,
    required String clientName,
    required String projectType,
    required DateTime startDate,
    required DateTime endDate,
    String? contactPerson,
    String? contactEmail,
    String? description,
    Map<String, bool>? assessmentScope,
  }) async {
    final uuid = const Uuid();
    final now = DateTime.now();
    
    // Generate project reference
    final typePrefix = _getTypePrefix(projectType);
    final year = now.year;
    final randomNum = (now.millisecondsSinceEpoch % 900) + 100;
    final reference = '$typePrefix-$year-$randomNum';

    final project = Project(
      id: uuid.v4(),
      name: name,
      reference: reference,
      clientName: clientName,
      projectType: projectType,
      status: ProjectStatus.planning,
      startDate: startDate,
      endDate: endDate,
      contactPerson: contactPerson,
      contactEmail: contactEmail,
      description: description,
      constraints: 'The time frame provisioned for the completion of this engagement was adequate. No constraints were encountered during the engagement.',
      rules: [
        'Social engineering was not permitted.',
        'Denial of Service (DoS) testing was not permitted.',
      ],
      scope: description ?? 'Comprehensive security assessment as per agreed scope of work.',
      assessmentScope: assessmentScope ?? {},
      createdDate: now,
      updatedDate: now,
    );

    await _database.insertProject(project);
    await loadProjects(); // Refresh the list
    
    return project;
  }

  String _getTypePrefix(String projectType) {
    switch (projectType) {
      case 'Internal Network Assessment':
        return 'INA';
      case 'External Network Assessment':
        return 'ENA';
      case 'Web Application Assessment':
        return 'WEB';
      case 'Mobile Application Assessment':
        return 'MOB';
      case 'Wireless Assessment':
        return 'WLS';
      case 'Social Engineering Assessment':
        return 'SOC';
      case 'Physical Assessment':
        return 'PHY';
      case 'Red Team Exercise':
        return 'RED';
      case 'Vulnerability Assessment':
        return 'VUL';
      case 'Compliance Assessment':
        return 'COM';
      default:
        return 'PRJ';
    }
  }

  Future<void> updateProject(Project project) async {
    final updatedProject = project.copyWith(updatedDate: DateTime.now());
    await _database.updateProject(updatedProject);
    await loadProjects(); // Refresh the list
  }

  Future<void> deleteProject(String projectId) async {
    await _database.deleteProject(projectId);
    await loadProjects(); // Refresh the list
  }

  Future<void> searchProjects(String query) async {
    if (query.isEmpty) {
      await loadProjects();
      return;
    }

    try {
      state = const AsyncValue.loading();
      final projects = await _database.searchProjects(query);
      state = AsyncValue.data(projects);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> filterByStatus(ProjectStatus status) async {
    try {
      state = const AsyncValue.loading();
      final projects = await _database.getProjectsByStatus(status);
      state = AsyncValue.data(projects);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

class ProjectStatisticsNotifier extends StateNotifier<AsyncValue<ProjectStatistics?>> {
  final MadnessDatabase _database;
  final String projectId;

  ProjectStatisticsNotifier(this._database, this.projectId) : super(const AsyncValue.loading()) {
    loadStatistics();
  }

  Future<void> loadStatistics() async {
    try {
      state = const AsyncValue.loading();
      final statistics = await _database.getProjectStatistics(projectId);
      state = AsyncValue.data(statistics);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateStatistics({
    int? totalFindings,
    int? criticalIssues,
    int? screenshots,
    int? attackChains,
  }) async {
    final currentStats = state.value ?? ProjectStatistics.empty(projectId);
    
    final updatedStats = currentStats.copyWith(
      totalFindings: totalFindings ?? currentStats.totalFindings,
      criticalIssues: criticalIssues ?? currentStats.criticalIssues,
      screenshots: screenshots ?? currentStats.screenshots,
      attackChains: attackChains ?? currentStats.attackChains,
      updatedDate: DateTime.now(),
    );

    await _database.updateProjectStatistics(updatedStats);
    state = AsyncValue.data(updatedStats);
  }
}

// Computed providers
final activeProjectsProvider = Provider<AsyncValue<List<Project>>>((ref) {
  final allProjects = ref.watch(projectsProvider);
  
  return allProjects.when(
    data: (projects) {
      final activeProjects = projects.where((p) => p.status == ProjectStatus.active).toList();
      return AsyncValue.data(activeProjects);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final recentProjectsProvider = Provider<AsyncValue<List<Project>>>((ref) {
  final allProjects = ref.watch(projectsProvider);
  
  return allProjects.when(
    data: (projects) {
      final recentProjects = projects.take(5).toList();
      return AsyncValue.data(recentProjects);
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});

final projectCountProvider = Provider<AsyncValue<int>>((ref) {
  final allProjects = ref.watch(projectsProvider);
  
  return allProjects.when(
    data: (projects) => AsyncValue.data(projects.length),
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});