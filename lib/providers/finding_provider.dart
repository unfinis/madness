import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../models/finding.dart';
import '../providers/database_provider.dart';
import '../database/database.dart';

// Finding state class
class FindingState {
  final List<Finding> findings;
  final FindingFilters filters;
  final FindingSortConfig sortConfig;
  final bool isLoading;
  final String? error;
  final Finding? selectedFinding;

  FindingState({
    this.findings = const [],
    this.filters = const FindingFilters(),
    this.sortConfig = const FindingSortConfig(),
    this.isLoading = false,
    this.error,
    this.selectedFinding,
  });

  FindingState copyWith({
    List<Finding>? findings,
    FindingFilters? filters,
    FindingSortConfig? sortConfig,
    bool? isLoading,
    String? error,
    Finding? selectedFinding,
  }) {
    return FindingState(
      findings: findings ?? this.findings,
      filters: filters ?? this.filters,
      sortConfig: sortConfig ?? this.sortConfig,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedFinding: selectedFinding ?? this.selectedFinding,
    );
  }

  List<Finding> get filteredFindings {
    var filtered = List<Finding>.from(findings);

    // Apply severity filter
    if (filters.severities.isNotEmpty) {
      filtered = filtered.where((f) => filters.severities.contains(f.severity)).toList();
    }

    // Apply status filter
    if (filters.statuses.isNotEmpty) {
      filtered = filtered.where((f) => filters.statuses.contains(f.status)).toList();
    }

    // Apply CVSS score filter
    if (filters.minCvssScore != null) {
      filtered = filtered.where((f) => f.cvssScore >= filters.minCvssScore!).toList();
    }
    if (filters.maxCvssScore != null) {
      filtered = filtered.where((f) => f.cvssScore <= filters.maxCvssScore!).toList();
    }

    // Apply date filter
    if (filters.startDate != null) {
      filtered = filtered.where((f) => f.createdDate.isAfter(filters.startDate!)).toList();
    }
    if (filters.endDate != null) {
      filtered = filtered.where((f) => f.createdDate.isBefore(filters.endDate!)).toList();
    }

    // Apply search filter
    if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
      final query = filters.searchQuery!.toLowerCase();
      filtered = filtered.where((f) =>
          f.title.toLowerCase().contains(query) ||
          f.description.toLowerCase().contains(query) ||
          f.components.any((c) => c.value.toLowerCase().contains(query))).toList();
    }

    // Apply sorting
    filtered.sort((a, b) {
      int comparison = 0;
      
      switch (sortConfig.field) {
        case FindingSortField.title:
          comparison = a.title.compareTo(b.title);
          break;
        case FindingSortField.severity:
          comparison = a.severity.index.compareTo(b.severity.index);
          break;
        case FindingSortField.cvssScore:
          comparison = a.cvssScore.compareTo(b.cvssScore);
          break;
        case FindingSortField.status:
          comparison = a.status.index.compareTo(b.status.index);
          break;
        case FindingSortField.createdDate:
          comparison = a.createdDate.compareTo(b.createdDate);
          break;
        case FindingSortField.updatedDate:
          comparison = a.updatedDate.compareTo(b.updatedDate);
          break;
      }

      return sortConfig.direction == SortDirection.asc ? comparison : -comparison;
    });

    return filtered;
  }

  FindingSummaryStats get summaryStats => FindingSummaryStats.fromFindings(filteredFindings);

  Map<FindingSeverity, int> get severityBreakdown {
    final Map<FindingSeverity, int> breakdown = {};
    for (final finding in filteredFindings) {
      breakdown[finding.severity] = (breakdown[finding.severity] ?? 0) + 1;
    }
    return breakdown;
  }

  Map<FindingStatus, int> get statusBreakdown {
    final Map<FindingStatus, int> breakdown = {};
    for (final finding in filteredFindings) {
      breakdown[finding.status] = (breakdown[finding.status] ?? 0) + 1;
    }
    return breakdown;
  }
}

// Finding provider
class FindingProvider extends StateNotifier<FindingState> {
  final Ref _ref;
  final _uuid = const Uuid();

  FindingProvider(this._ref) : super(FindingState());

  MadnessDatabase get _database => _ref.read(databaseProvider);

  // Load findings for a project
  Future<void> loadFindings(String projectId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final findingRows = await (_database.select(_database.findingsTable)
            ..where((t) => t.projectId.equals(projectId))
            ..orderBy([
              (t) => OrderingTerm(expression: t.updatedDate, mode: OrderingMode.desc)
            ]))
          .get();

      final findings = <Finding>[];
      
      for (final findingRow in findingRows) {
        // Load components for this finding
        final componentRows = await (_database.select(_database.findingComponentsTable)
              ..where((t) => t.findingId.equals(findingRow.id))
              ..orderBy([
                (t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.asc)
              ]))
            .get();

        // Load links for this finding
        final linkRows = await (_database.select(_database.findingLinksTable)
              ..where((t) => t.findingId.equals(findingRow.id))
              ..orderBy([
                (t) => OrderingTerm(expression: t.orderIndex, mode: OrderingMode.asc)
              ]))
            .get();

        // Load screenshot IDs for this finding (from existing ScreenshotFindingsTable)
        final screenshotFindingRows = await (_database.select(_database.screenshotFindingsTable)
              ..where((t) => t.findingId.equals(findingRow.id)))
            .get();

        // Parse sub-findings data
        final subFindingsData = <SubFindingData>[];
        if (findingRow.subFindingsData != null && findingRow.subFindingsData!.isNotEmpty) {
          try {
            final subFindingsJson = jsonDecode(findingRow.subFindingsData!) as List<dynamic>;
            subFindingsData.addAll(
              subFindingsJson.map((json) => SubFindingData.fromJson(json as Map<String, dynamic>))
            );
          } catch (e) {
            // Log error but don't fail the loading
            // Error parsing sub-findings for finding ${findingRow.id}: $e
          }
        }

        final finding = Finding(
          id: findingRow.id,
          projectId: findingRow.projectId,
          title: findingRow.title,
          description: findingRow.description,
          cvssScore: findingRow.cvssScore,
          cvssVector: findingRow.cvssVector,
          severity: _parseSeverity(findingRow.severity),
          status: _parseStatus(findingRow.status),
          auditSteps: findingRow.auditSteps,
          automatedScript: findingRow.automatedScript,
          furtherReading: findingRow.furtherReading,
          verificationProcedure: findingRow.verificationProcedure,
          orderIndex: findingRow.orderIndex,
          createdDate: findingRow.createdDate,
          updatedDate: findingRow.updatedDate,
          // Sub-findings support
          isMainFinding: findingRow.isMainFinding,
          parentFindingId: findingRow.parentFindingId,
          subFindings: subFindingsData,
          components: componentRows.map(_componentRowToModel).toList(),
          links: linkRows.map(_linkRowToModel).toList(),
          screenshotIds: screenshotFindingRows.map((r) => r.screenshotId).toList(),
        );
        
        findings.add(finding);
      }
      
      state = state.copyWith(
        findings: findings,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(
        error: error.toString(),
        isLoading: false,
      );
    }
  }

  // Create a new finding
  Future<Finding> createFinding(Finding finding) async {
    try {
      final findingId = finding.id.isEmpty ? _uuid.v4() : finding.id;
      final now = DateTime.now();
      
      await _database.transaction(() async {
        // Insert the finding
        await _database.into(_database.findingsTable).insert(
          FindingsTableCompanion(
            id: Value(findingId),
            projectId: Value(finding.projectId),
            title: Value(finding.title),
            description: Value(finding.description),
            cvssScore: Value(finding.cvssScore),
            cvssVector: Value(finding.cvssVector),
            severity: Value(finding.severity.name),
            status: Value(finding.status.name),
            auditSteps: Value(finding.auditSteps),
            automatedScript: Value(finding.automatedScript),
            furtherReading: Value(finding.furtherReading),
            verificationProcedure: Value(finding.verificationProcedure),
            orderIndex: Value(finding.orderIndex),
            // Sub-findings support
            isMainFinding: Value(finding.isMainFinding),
            parentFindingId: Value(finding.parentFindingId),
            subFindingsData: Value(finding.subFindings.isNotEmpty 
                ? jsonEncode(finding.subFindings.map((sf) => sf.toJson()).toList())
                : null),
            createdDate: Value(now),
            updatedDate: Value(now),
          ),
        );

        // Insert components
        for (int i = 0; i < finding.components.length; i++) {
          final component = finding.components[i];
          await _database.into(_database.findingComponentsTable).insert(
            FindingComponentsTableCompanion(
              id: Value(component.id.isEmpty ? _uuid.v4() : component.id),
              findingId: Value(findingId),
              componentType: Value(component.type.name),
              name: Value(component.name),
              value: Value(component.value),
              description: Value(component.description),
              orderIndex: Value(i),
              createdDate: Value(component.createdDate),
            ),
          );
        }

        // Insert links
        for (int i = 0; i < finding.links.length; i++) {
          final link = finding.links[i];
          await _database.into(_database.findingLinksTable).insert(
            FindingLinksTableCompanion(
              id: Value(link.id.isEmpty ? _uuid.v4() : link.id),
              findingId: Value(findingId),
              title: Value(link.title),
              url: Value(link.url),
              orderIndex: Value(i),
              createdDate: Value(link.createdDate),
            ),
          );
        }

        // Insert screenshot associations
        for (final screenshotId in finding.screenshotIds) {
          await _database.into(_database.screenshotFindingsTable).insert(
            ScreenshotFindingsTableCompanion(
              screenshotId: Value(screenshotId),
              findingId: Value(findingId),
              linkedDate: Value(now),
            ),
          );
        }
      });

      final newFinding = finding.copyWith(
        id: findingId,
        createdDate: now,
        updatedDate: now,
      );

      state = state.copyWith(
        findings: [...state.findings, newFinding],
      );

      return newFinding;
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    }
  }

  // Update an existing finding
  Future<Finding> updateFinding(Finding finding) async {
    try {
      final now = DateTime.now();
      
      await _database.transaction(() async {
        // Update the finding
        await _database.update(_database.findingsTable).replace(
          FindingsTableCompanion(
            id: Value(finding.id),
            projectId: Value(finding.projectId),
            title: Value(finding.title),
            description: Value(finding.description),
            cvssScore: Value(finding.cvssScore),
            cvssVector: Value(finding.cvssVector),
            severity: Value(finding.severity.name),
            status: Value(finding.status.name),
            auditSteps: Value(finding.auditSteps),
            automatedScript: Value(finding.automatedScript),
            furtherReading: Value(finding.furtherReading),
            verificationProcedure: Value(finding.verificationProcedure),
            orderIndex: Value(finding.orderIndex),
            createdDate: Value(finding.createdDate),
            updatedDate: Value(now),
          ),
        );

        // Delete existing components and links
        await (_database.delete(_database.findingComponentsTable)
              ..where((t) => t.findingId.equals(finding.id)))
            .go();
        await (_database.delete(_database.findingLinksTable)
              ..where((t) => t.findingId.equals(finding.id)))
            .go();

        // Insert updated components
        for (int i = 0; i < finding.components.length; i++) {
          final component = finding.components[i];
          await _database.into(_database.findingComponentsTable).insert(
            FindingComponentsTableCompanion(
              id: Value(component.id.isEmpty ? _uuid.v4() : component.id),
              findingId: Value(finding.id),
              componentType: Value(component.type.name),
              name: Value(component.name),
              value: Value(component.value),
              description: Value(component.description),
              orderIndex: Value(i),
              createdDate: Value(component.createdDate),
            ),
          );
        }

        // Insert updated links
        for (int i = 0; i < finding.links.length; i++) {
          final link = finding.links[i];
          await _database.into(_database.findingLinksTable).insert(
            FindingLinksTableCompanion(
              id: Value(link.id.isEmpty ? _uuid.v4() : link.id),
              findingId: Value(finding.id),
              title: Value(link.title),
              url: Value(link.url),
              orderIndex: Value(i),
              createdDate: Value(link.createdDate),
            ),
          );
        }

        // Delete existing screenshot associations
        await (_database.delete(_database.screenshotFindingsTable)
              ..where((t) => t.findingId.equals(finding.id)))
            .go();

        // Insert updated screenshot associations
        for (final screenshotId in finding.screenshotIds) {
          await _database.into(_database.screenshotFindingsTable).insert(
            ScreenshotFindingsTableCompanion(
              screenshotId: Value(screenshotId),
              findingId: Value(finding.id),
              linkedDate: Value(now),
            ),
          );
        }
      });

      final updatedFinding = finding.copyWith(updatedDate: now);
      
      final updatedFindings = state.findings
          .map((f) => f.id == finding.id ? updatedFinding : f)
          .toList();

      state = state.copyWith(findings: updatedFindings);
      
      return updatedFinding;
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    }
  }

  // Delete a finding
  Future<void> deleteFinding(String findingId) async {
    try {
      await _database.transaction(() async {
        // Delete components and links first
        await (_database.delete(_database.findingComponentsTable)
              ..where((t) => t.findingId.equals(findingId)))
            .go();
        await (_database.delete(_database.findingLinksTable)
              ..where((t) => t.findingId.equals(findingId)))
            .go();
        
        // Delete screenshot associations
        await (_database.delete(_database.screenshotFindingsTable)
              ..where((t) => t.findingId.equals(findingId)))
            .go();

        // Delete the finding
        await (_database.delete(_database.findingsTable)
              ..where((t) => t.id.equals(findingId)))
            .go();
      });

      final updatedFindings = state.findings
          .where((f) => f.id != findingId)
          .toList();

      state = state.copyWith(findings: updatedFindings);
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    }
  }

  // Bulk update findings
  Future<void> bulkUpdateFindings(List<String> ids, Map<String, dynamic> updates) async {
    try {
      final now = DateTime.now();
      
      await _database.transaction(() async {
        for (final findingId in ids) {
          FindingsTableCompanion companion = FindingsTableCompanion(
            updatedDate: Value(now),
          );

          // Add specific updates
          if (updates.containsKey('status')) {
            companion = companion.copyWith(status: Value(updates['status'] as String));
          }
          if (updates.containsKey('severity')) {
            companion = companion.copyWith(severity: Value(updates['severity'] as String));
          }

          await (_database.update(_database.findingsTable)
                ..where((t) => t.id.equals(findingId)))
              .write(companion);
        }
      });

      // Update local state
      final updatedFindings = state.findings.map((finding) {
        if (ids.contains(finding.id)) {
          Finding updatedFinding = finding;
          
          if (updates.containsKey('status')) {
            final status = FindingStatus.values.firstWhere(
              (s) => s.name == updates['status'],
              orElse: () => finding.status,
            );
            updatedFinding = updatedFinding.copyWith(status: status);
          }
          
          if (updates.containsKey('severity')) {
            final severity = FindingSeverity.values.firstWhere(
              (s) => s.name == updates['severity'],
              orElse: () => finding.severity,
            );
            updatedFinding = updatedFinding.copyWith(severity: severity);
          }
          
          return updatedFinding.copyWith(updatedDate: now);
        }
        return finding;
      }).toList();

      state = state.copyWith(findings: updatedFindings);
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    }
  }

  // Update filters
  void updateFilters(FindingFilters filters) {
    state = state.copyWith(filters: filters);
  }

  // Update sort configuration
  void updateSort(FindingSortConfig sortConfig) {
    state = state.copyWith(sortConfig: sortConfig);
  }

  // Clear all filters
  void clearFilters() {
    state = state.copyWith(filters: const FindingFilters());
  }

  // Select a finding
  void selectFinding(Finding finding) {
    state = state.copyWith(selectedFinding: finding);
  }

  // Clear selection
  void clearSelection() {
    state = state.copyWith(selectedFinding: null);
  }

  // Export findings to JSON
  Future<String> exportFindings(List<String> findingIds) async {
    try {
      final findingsToExport = state.findings
          .where((f) => findingIds.contains(f.id))
          .toList();

      final exportData = {
        'findings': findingsToExport.map((f) => f.toJson()).toList(),
        'exportDate': DateTime.now().toIso8601String(),
        'version': '1.0',
      };

      return jsonEncode(exportData);
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    }
  }

  // Import findings from JSON
  Future<List<Finding>> importFindings(String jsonData, String projectId) async {
    try {
      final data = jsonDecode(jsonData);
      final findingsJson = data['findings'] as List<dynamic>;
      
      final importedFindings = <Finding>[];
      
      for (final json in findingsJson) {
        final finding = Finding.fromJson(json).copyWith(
          projectId: projectId,
          id: _uuid.v4(),
          createdDate: DateTime.now(),
          updatedDate: DateTime.now(),
        );
        
        final createdFinding = await createFinding(finding);
        importedFindings.add(createdFinding);
      }

      return importedFindings;
    } catch (error) {
      state = state.copyWith(error: error.toString());
      rethrow;
    }
  }

  // Helper methods for parsing database rows
  FindingSeverity _parseSeverity(String severity) {
    return FindingSeverity.values.firstWhere(
      (s) => s.name == severity,
      orElse: () => FindingSeverity.medium,
    );
  }

  FindingStatus _parseStatus(String status) {
    return FindingStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => FindingStatus.draft,
    );
  }

  ComponentType _parseComponentType(String type) {
    return ComponentType.values.firstWhere(
      (t) => t.name == type,
      orElse: () => ComponentType.other,
    );
  }

  FindingComponent _componentRowToModel(FindingComponentRow row) {
    return FindingComponent(
      id: row.id,
      findingId: row.findingId,
      type: _parseComponentType(row.componentType),
      name: row.name,
      value: row.value,
      description: row.description,
      createdDate: row.createdDate,
    );
  }

  FindingLink _linkRowToModel(FindingLinkRow row) {
    return FindingLink(
      id: row.id,
      findingId: row.findingId,
      title: row.title,
      url: row.url,
      createdDate: row.createdDate,
    );
  }

}

// Provider instance
final findingProvider = StateNotifierProvider<FindingProvider, FindingState>((ref) {
  return FindingProvider(ref);
});

// Convenience providers
final filteredFindingsProvider = Provider<List<Finding>>((ref) {
  final state = ref.watch(findingProvider);
  return state.filteredFindings;
});

final findingSummaryStatsProvider = Provider<FindingSummaryStats>((ref) {
  final state = ref.watch(findingProvider);
  return state.summaryStats;
});

final findingSeverityBreakdownProvider = Provider<Map<FindingSeverity, int>>((ref) {
  final state = ref.watch(findingProvider);
  return state.severityBreakdown;
});

final findingStatusBreakdownProvider = Provider<Map<FindingStatus, int>>((ref) {
  final state = ref.watch(findingProvider);
  return state.statusBreakdown;
});