import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import '../models/finding_template.dart';
import '../models/finding.dart';

class TemplateProvider extends StateNotifier<AsyncValue<List<TemplateInfo>>> {
  TemplateProvider() : super(const AsyncValue.loading()) {
    loadTemplateIndex();
  }

  static const String _templatesPath = '/home/kali/madness/devhelp/templates';
  List<FindingTemplate> _loadedTemplates = [];

  /// Load the template index from devhelp/templates/index.json
  Future<void> loadTemplateIndex() async {
    try {
      state = const AsyncValue.loading();
      
      final indexFile = File(path.join(_templatesPath, 'index.json'));
      if (!await indexFile.exists()) {
        throw Exception('Template index file not found at ${indexFile.path}');
      }

      final content = await indexFile.readAsString();
      final jsonData = json.decode(content) as Map<String, dynamic>;
      final templateIndex = TemplateIndex.fromJson(jsonData);
      
      state = AsyncValue.data(templateIndex.templates);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Load a specific template by its filename
  Future<FindingTemplate?> loadTemplate(String filename) async {
    try {
      // Check if already loaded
      final existing = _loadedTemplates.firstWhere(
        (t) => '${t.id}.json' == filename,
        orElse: () => throw StateError('Not found'),
      );
      return existing;
    } catch (_) {
      // Not in cache, load from file
      final templateFile = File(path.join(_templatesPath, filename));
      if (!await templateFile.exists()) {
        throw Exception('Template file not found: $filename');
      }

      final content = await templateFile.readAsString();
      final jsonData = json.decode(content) as Map<String, dynamic>;
      final template = FindingTemplate.fromJson(jsonData);
      
      // Cache the loaded template
      _loadedTemplates.add(template);
      return template;
    }
  }

  /// Load template by ID
  Future<FindingTemplate?> loadTemplateById(String id) async {
    final currentState = state;
    if (!currentState.hasValue) {
      await loadTemplateIndex();
    }

    final templates = state.value ?? [];
    final templateInfo = templates.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Template not found: $id'),
    );

    return await loadTemplate(templateInfo.filename);
  }

  /// Get all available template categories
  List<String> getCategories() {
    final currentState = state;
    if (!currentState.hasValue) return [];
    
    final categories = <String>{};
    for (final template in currentState.value!) {
      categories.add(template.category);
    }
    
    return categories.toList()..sort();
  }

  /// Get templates filtered by category
  List<TemplateInfo> getTemplatesByCategory(String category) {
    final currentState = state;
    if (!currentState.hasValue) return [];
    
    return currentState.value!
        .where((t) => t.category == category)
        .toList();
  }

  /// Search templates by title or category
  List<TemplateInfo> searchTemplates(String query) {
    final currentState = state;
    if (!currentState.hasValue) return [];
    
    final lowercaseQuery = query.toLowerCase();
    return currentState.value!
        .where((t) => 
            t.title.toLowerCase().contains(lowercaseQuery) ||
            t.category.toLowerCase().contains(lowercaseQuery))
        .toList();
  }

  /// Convert template to findings and return them (old method for compatibility)
  Future<List<Finding>> createFindingsFromTemplate(String templateId) async {
    final template = await loadTemplateById(templateId);
    if (template == null) {
      throw Exception('Template not found: $templateId');
    }
    
    return template.toFindings();
  }

  /// Create a main finding from selected sub-findings (new hierarchical approach)
  Future<Finding> createMainFindingFromSubFindings({
    required String templateId,
    required Set<int> selectedIndices,
    required String projectId,
  }) async {
    final template = await loadTemplateById(templateId);
    if (template == null) {
      throw Exception('Template not found: $templateId');
    }

    if (selectedIndices.isEmpty) {
      throw Exception('No sub-findings selected');
    }

    // Get selected sub-findings
    final selectedSubFindings = selectedIndices
        .map((index) => template.subFindings[index])
        .toList();

    // Calculate aggregated CVSS score (highest score)
    double highestScore = 0.0;
    String? highestVector;
    for (final subFinding in selectedSubFindings) {
      if (subFinding.cvssScore > highestScore) {
        highestScore = subFinding.cvssScore;
        highestVector = subFinding.cvssVector;
      }
    }

    // Determine severity from highest score
    final severity = FindingSeverity.fromScore(highestScore);

    // Build merged description with sub-finding sections
    final descriptionBuffer = StringBuffer();
    descriptionBuffer.writeln(template.baseDescription ?? '');
    descriptionBuffer.writeln();
    
    for (final subFinding in selectedSubFindings) {
      descriptionBuffer.writeln('## ${subFinding.title}');
      descriptionBuffer.writeln();
      descriptionBuffer.writeln(subFinding.description);
      descriptionBuffer.writeln();
    }

    // Build merged audit steps
    final stepsBuffer = StringBuffer();
    for (int i = 0; i < selectedSubFindings.length; i++) {
      final subFinding = selectedSubFindings[i];
      stepsBuffer.writeln('### ${i + 1}. ${subFinding.title}');
      stepsBuffer.writeln();
      stepsBuffer.writeln(subFinding.checkSteps);
      if (i < selectedSubFindings.length - 1) {
        stepsBuffer.writeln();
      }
    }

    // Build merged recommendations
    final recommendationsBuffer = StringBuffer();
    for (final subFinding in selectedSubFindings) {
      recommendationsBuffer.writeln('**${subFinding.title}:**');
      recommendationsBuffer.writeln(subFinding.recommendation);
      recommendationsBuffer.writeln();
    }

    // Collect all links from sub-findings
    final allLinks = <FindingLink>[];
    for (final subFinding in selectedSubFindings) {
      allLinks.addAll(subFinding.links);
    }

    // Convert sub-findings to SubFindingData
    final subFindingDataList = selectedSubFindings.map((sf) => SubFindingData(
      id: sf.id,
      title: sf.title,
      description: sf.description,
      cvssScore: sf.cvssScore,
      cvssVector: sf.cvssVector,
      severity: FindingSeverity.fromScore(sf.cvssScore),
      checkSteps: sf.checkSteps,
      recommendation: sf.recommendation,
      verificationProcedure: sf.verificationProcedure,
      links: sf.links,
      screenshotIds: [],
    )).toList();

    // Create the main finding
    return Finding(
      id: '', // Will be generated when saved
      projectId: projectId,
      title: template.title,
      description: descriptionBuffer.toString().trim(),
      cvssScore: highestScore,
      cvssVector: highestVector,
      severity: severity,
      status: FindingStatus.draft,
      auditSteps: stepsBuffer.toString().trim(),
      furtherReading: recommendationsBuffer.toString().trim(),
      verificationProcedure: selectedSubFindings
          .where((sf) => sf.verificationProcedure != null)
          .map((sf) => '**${sf.title}:**\n${sf.verificationProcedure}')
          .join('\n\n'),
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
      isMainFinding: true,
      parentFindingId: null,
      subFindings: subFindingDataList,
      components: [],
      links: allLinks,
      screenshotIds: [],
    );
  }

  /// Clear cached templates to force reload
  void clearCache() {
    _loadedTemplates.clear();
    loadTemplateIndex();
  }
}

// Providers
final templateProvider = StateNotifierProvider<TemplateProvider, AsyncValue<List<TemplateInfo>>>(
  (ref) => TemplateProvider(),
);

/// Provider for template categories
final templateCategoriesProvider = Provider<List<String>>((ref) {
  final templates = ref.watch(templateProvider);
  return templates.when(
    data: (templateList) {
      final categories = <String>{};
      for (final template in templateList) {
        categories.add(template.category);
      }
      return categories.toList()..sort();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for filtered templates by category
final templatesByCategoryProvider = Provider.family<List<TemplateInfo>, String?>((ref, category) {
  final templates = ref.watch(templateProvider);
  return templates.when(
    data: (templateList) {
      if (category == null || category.isEmpty) {
        return templateList;
      }
      return templateList.where((t) => t.category == category).toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Provider for searching templates
final templateSearchProvider = Provider.family<List<TemplateInfo>, String>((ref, query) {
  final templates = ref.watch(templateProvider);
  return templates.when(
    data: (templateList) {
      if (query.isEmpty) return templateList;
      
      final lowercaseQuery = query.toLowerCase();
      return templateList
          .where((t) => 
              t.title.toLowerCase().contains(lowercaseQuery) ||
              t.category.toLowerCase().contains(lowercaseQuery))
          .toList();
    },
    loading: () => [],
    error: (_, __) => [],
  );
});