import 'dart:convert';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../models/run_instance.dart';
import '../models/trigger_evaluation.dart';
import '../models/asset.dart';
import '../services/methodology_loader.dart' as loader;

/// Drift-based storage service for managing all data persistence
class DriftStorageService {
  final MadnessDatabase _database;

  DriftStorageService(this._database);

  // ===== METHODOLOGY TEMPLATES =====

  /// Store a methodology template in the database
  Future<void> storeTemplate(loader.MethodologyTemplate template) async {
    await _database.into(_database.methodologyTemplatesTable).insert(
      MethodologyTemplatesTableCompanion.insert(
        id: template.id,
        version: template.version,
        templateVersion: template.templateVersion,
        name: template.name,
        workstream: template.workstream,
        author: template.author,
        created: template.created,
        modified: template.modified,
        status: template.status,
        description: template.description,
        tags: jsonEncode(template.tags),
        riskLevel: template.riskLevel,
        overview: jsonEncode(template.overview.toJson()),
        triggers: jsonEncode(template.triggers.map((t) => t.toJson()).toList()),
        equipment: jsonEncode(template.equipment),
        procedures: jsonEncode(template.procedures.map((p) => p.toJson()).toList()),
        findings: jsonEncode(template.findings.map((f) => f.toJson()).toList()),
        cleanup: jsonEncode(template.cleanup.map((c) => c.toJson()).toList()),
        troubleshooting: jsonEncode(template.troubleshooting.map((t) => t.toJson()).toList()),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get a methodology template by ID
  Future<loader.MethodologyTemplate?> getTemplate(String id) async {
    final row = await (_database.select(_database.methodologyTemplatesTable)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (row == null) return null;

    return _methodologyTemplateFromRow(row);
  }

  /// Get all methodology templates
  Future<List<loader.MethodologyTemplate>> getAllTemplates() async {
    final rows = await _database.select(_database.methodologyTemplatesTable).get();
    return rows.map(_methodologyTemplateFromRow).toList();
  }

  /// Delete a methodology template
  Future<void> deleteTemplate(String id) async {
    await (_database.delete(_database.methodologyTemplatesTable)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  /// Check if a template exists
  Future<bool> templateExists(String id) async {
    final query = _database.select(_database.methodologyTemplatesTable)
      ..where((tbl) => tbl.id.equals(id))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }

  // ===== RUN INSTANCES =====

  /// Store a run instance
  Future<void> storeRunInstance(RunInstance runInstance, String projectId) async {
    await _database.into(_database.runInstancesTable).insert(
      RunInstancesTableCompanion.insert(
        runId: runInstance.runId,
        projectId: projectId,
        templateId: runInstance.templateId,
        templateVersion: runInstance.templateVersion,
        triggerId: runInstance.triggerId,
        assetId: runInstance.assetId,
        matchedValues: jsonEncode(runInstance.matchedValues),
        parameters: jsonEncode(runInstance.parameters),
        status: runInstance.status.name,
        createdAt: runInstance.createdAt,
        createdBy: runInstance.createdBy,
        updatedAt: Value(runInstance.updatedAt),
        evidenceIds: jsonEncode(runInstance.evidenceIds),
        findingIds: jsonEncode(runInstance.findingIds),
        notes: Value(runInstance.notes),
        priority: Value(runInstance.priority),
        tags: Value(jsonEncode(runInstance.tags)),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get a run instance by ID
  Future<RunInstance?> getRunInstance(String runId) async {
    final row = await (_database.select(_database.runInstancesTable)
          ..where((tbl) => tbl.runId.equals(runId)))
        .getSingleOrNull();

    if (row == null) return null;

    return _runInstanceFromRow(row);
  }

  /// Get all run instances for a project
  Future<List<RunInstance>> getAllRunInstances(String projectId) async {
    final rows = await (_database.select(_database.runInstancesTable)
          ..where((tbl) => tbl.projectId.equals(projectId)))
        .get();
    return rows.map(_runInstanceFromRow).toList();
  }

  /// Get run instances by status
  Future<List<RunInstance>> getRunInstancesByStatus(String projectId, RunInstanceStatus status) async {
    final rows = await (_database.select(_database.runInstancesTable)
          ..where((tbl) => tbl.projectId.equals(projectId) &tbl.status.equals(status.name)))
        .get();
    return rows.map(_runInstanceFromRow).toList();
  }

  /// Get run instances for a specific asset
  Future<List<RunInstance>> getRunInstancesForAsset(String projectId, String assetId) async {
    final rows = await (_database.select(_database.runInstancesTable)
          ..where((tbl) => tbl.projectId.equals(projectId) &tbl.assetId.equals(assetId)))
        .get();
    return rows.map(_runInstanceFromRow).toList();
  }

  /// Get run instances for a specific template
  Future<List<RunInstance>> getRunInstancesForTemplate(String projectId, String templateId) async {
    final rows = await (_database.select(_database.runInstancesTable)
          ..where((tbl) => tbl.projectId.equals(projectId) &tbl.templateId.equals(templateId)))
        .get();
    return rows.map(_runInstanceFromRow).toList();
  }

  /// Update a run instance
  Future<void> updateRunInstance(RunInstance runInstance, String projectId) async {
    await (_database.update(_database.runInstancesTable)
          ..where((tbl) => tbl.runId.equals(runInstance.runId)))
        .write(RunInstancesTableCompanion(
          matchedValues: Value(jsonEncode(runInstance.matchedValues)),
          parameters: Value(jsonEncode(runInstance.parameters)),
          status: Value(runInstance.status.name),
          updatedAt: Value(runInstance.updatedAt ?? DateTime.now()),
          evidenceIds: Value(jsonEncode(runInstance.evidenceIds)),
          findingIds: Value(jsonEncode(runInstance.findingIds)),
          notes: Value(runInstance.notes),
          priority: Value(runInstance.priority),
          tags: Value(jsonEncode(runInstance.tags)),
        ));
  }

  /// Delete a run instance
  Future<void> deleteRunInstance(String runId) async {
    await (_database.delete(_database.runInstancesTable)
          ..where((tbl) => tbl.runId.equals(runId)))
        .go();
  }

  // ===== HISTORY ENTRIES =====

  /// Store a history entry
  Future<void> storeHistoryEntry(HistoryEntry entry, String runId) async {
    await _database.into(_database.historyEntriesTable).insert(
      HistoryEntriesTableCompanion.insert(
        id: entry.id,
        runId: runId,
        timestamp: entry.timestamp,
        performedBy: entry.performedBy,
        action: entry.action.name,
        description: entry.description,
        previousValue: Value(entry.previousValue),
        newValue: Value(entry.newValue),
        metadata: Value(jsonEncode(entry.metadata)),
      ),
    );
  }

  /// Get history entries for a run instance
  Future<List<HistoryEntry>> getHistoryForRunInstance(String runId) async {
    final query = _database.select(_database.historyEntriesTable)
      ..where((tbl) => tbl.runId.equals(runId))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]);
    final rows = await query.get();
    return rows.map(_historyEntryFromRow).toList();
  }

  // ===== TRIGGER MATCHES =====

  /// Store a trigger match
  Future<void> storeTriggerMatch(TriggerMatch match, String projectId) async {
    await _database.into(_database.triggerMatchesTable).insert(
      TriggerMatchesTableCompanion.insert(
        id: match.id,
        triggerId: match.triggerId,
        templateId: match.templateId,
        assetId: match.assetId,
        projectId: projectId,
        matched: match.matched,
        extractedValues: jsonEncode(match.extractedValues),
        confidence: Value(match.confidence),
        evaluatedAt: match.evaluatedAt,
        priority: Value(match.priority),
        error: Value.absentIfNull(match.error),
        debugInfo: Value(jsonEncode(match.debugInfo)),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get trigger matches for an asset
  Future<List<TriggerMatch>> getTriggerMatchesForAsset(String projectId, String assetId) async {
    final rows = await (_database.select(_database.triggerMatchesTable)
          ..where((tbl) => tbl.projectId.equals(projectId) &tbl.assetId.equals(assetId)))
        .get();
    return rows.map(_triggerMatchFromRow).toList();
  }

  /// Get successful trigger matches
  Future<List<TriggerMatch>> getSuccessfulMatches(String projectId) async {
    final rows = await (_database.select(_database.triggerMatchesTable)
          ..where((tbl) => tbl.projectId.equals(projectId) &tbl.matched.equals(true)))
        .get();
    return rows.map(_triggerMatchFromRow).toList();
  }

  /// Delete all trigger matches for a specific asset
  Future<void> deleteTriggerMatchesForAsset(String projectId, String assetId) async {
    await (_database.delete(_database.triggerMatchesTable)
      ..where((t) => t.projectId.equals(projectId) & t.assetId.equals(assetId))).go();
  }

  /// Get count of all trigger matches in a project
  Future<int> getTriggerMatchCount(String projectId) async {
    final count = await (_database.selectOnly(_database.triggerMatchesTable)
      ..addColumns([_database.triggerMatchesTable.id.count()])
      ..where(_database.triggerMatchesTable.projectId.equals(projectId))).getSingle();
    return count.read(_database.triggerMatchesTable.id.count()) ?? 0;
  }

  /// Get count of successful trigger matches in a project
  Future<int> getSuccessfulMatchCount(String projectId) async {
    final count = await (_database.selectOnly(_database.triggerMatchesTable)
      ..addColumns([_database.triggerMatchesTable.id.count()])
      ..where(_database.triggerMatchesTable.projectId.equals(projectId) &
              _database.triggerMatchesTable.matched.equals(true))).getSingle();
    return count.read(_database.triggerMatchesTable.id.count()) ?? 0;
  }

  /// Get recent trigger matches within a time period
  Future<List<TriggerMatch>> getRecentTriggerMatches(String projectId, Duration timeWindow) async {
    final cutoffTime = DateTime.now().subtract(timeWindow);
    final rows = await (_database.select(_database.triggerMatchesTable)
      ..where((t) => t.projectId.equals(projectId) & t.evaluatedAt.isBiggerThanValue(cutoffTime))
      ..orderBy([(t) => OrderingTerm(expression: t.evaluatedAt, mode: OrderingMode.desc)])).get();

    return rows.map(_triggerMatchFromRow).toList();
  }

  /// Get count of run instances in a project
  Future<int> getRunInstanceCount(String projectId) async {
    // This would need to be implemented based on your run instance table
    // For now, return 0 as a placeholder
    return 0;
  }

  // ===== PARAMETER RESOLUTIONS =====

  /// Store parameter resolutions for a run instance
  Future<void> storeParameterResolutions(String runId, List<ParameterResolution> resolutions) async {
    for (final resolution in resolutions) {
      await _database.into(_database.parameterResolutionsTable).insert(
        ParameterResolutionsTableCompanion.insert(
          id: '${runId}_${resolution.name}',
          runId: runId,
          name: resolution.name,
          type: resolution.type.name,
          value: jsonEncode(resolution.value),
          source: resolution.source.name,
          required: Value(resolution.required),
          resolved: Value(resolution.resolved),
          error: Value.absentIfNull(resolution.error),
          resolvedAt: resolution.resolvedAt,
          metadata: Value(jsonEncode(resolution.metadata)),
        ),
        mode: InsertMode.insertOrReplace,
      );
    }
  }

  /// Get parameter resolutions for a run instance
  Future<List<ParameterResolution>> getParameterResolutions(String runId) async {
    final rows = await (_database.select(_database.parameterResolutionsTable)
          ..where((tbl) => tbl.runId.equals(runId)))
        .get();
    return rows.map(_parameterResolutionFromRow).toList();
  }

  // ===== ASSETS =====

  /// Store an asset in the database
  Future<void> storeAsset(Asset asset) async {
    await _database.into(_database.assetsTable).insert(
      AssetsTableCompanion.insert(
        id: asset.id,
        type: asset.type.name,
        projectId: asset.projectId,
        name: asset.name,
        description: Value(asset.description),
        properties: jsonEncode(asset.properties.map((k, v) => MapEntry(k, v.toJson()))),
        discoveryStatus: 'confirmed', // Default status
        discoveredAt: asset.discoveredAt,
        lastUpdated: Value(asset.lastUpdated),
        confidence: Value(asset.confidence ?? 1.0),
        parentAssetIds: jsonEncode(asset.parentAssetIds),
        childAssetIds: jsonEncode(asset.childAssetIds),
        relatedAssetIds: jsonEncode(<String>[]), // Empty for now
        completedTriggers: jsonEncode(asset.completedTriggers),
        triggerResults: jsonEncode(asset.triggerResults.map((k, v) => MapEntry(k, v.toJson()))),
        tags: jsonEncode(asset.tags),
        metadata: const Value('{}'), // Additional metadata
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get an asset by ID
  Future<Asset?> getAsset(String assetId) async {
    final row = await (_database.select(_database.assetsTable)
          ..where((tbl) => tbl.id.equals(assetId)))
        .getSingleOrNull();

    if (row == null) return null;

    return _assetFromRow(row);
  }

  /// Get all assets for a project
  Future<List<Asset>> getAllAssets(String projectId) async {
    final rows = await (_database.select(_database.assetsTable)
          ..where((tbl) => tbl.projectId.equals(projectId)))
        .get();
    return rows.map(_assetFromRow).toList();
  }

  /// Get assets by type
  Future<List<Asset>> getAssetsByType(String projectId, String assetType) async {
    final rows = await (_database.select(_database.assetsTable)
          ..where((tbl) => tbl.projectId.equals(projectId) & tbl.type.equals(assetType)))
        .get();
    return rows.map(_assetFromRow).toList();
  }

  /// Update an asset
  Future<void> updateAsset(Asset asset) async {
    await (_database.update(_database.assetsTable)
          ..where((tbl) => tbl.id.equals(asset.id)))
        .write(AssetsTableCompanion(
          name: Value(asset.name),
          description: Value(asset.description),
          properties: Value(jsonEncode(asset.properties.map((k, v) => MapEntry(k, v.toJson())))),
          lastUpdated: Value(asset.lastUpdated),
          confidence: Value(asset.confidence ?? 1.0),
          parentAssetIds: Value(jsonEncode(asset.parentAssetIds)),
          childAssetIds: Value(jsonEncode(asset.childAssetIds)),
          completedTriggers: Value(jsonEncode(asset.completedTriggers)),
          triggerResults: Value(jsonEncode(asset.triggerResults.map((k, v) => MapEntry(k, v.toJson())))),
          tags: Value(jsonEncode(asset.tags)),
        ));
  }

  /// Delete an asset
  Future<void> deleteAsset(String assetId) async {
    await (_database.delete(_database.assetsTable)
          ..where((tbl) => tbl.id.equals(assetId)))
        .go();
  }

  /// Store asset relationship
  Future<void> storeAssetRelationship(String parentAssetId, String childAssetId, String relationshipType) async {
    await _database.into(_database.assetRelationshipsTable).insert(
      AssetRelationshipsTableCompanion.insert(
        parentAssetId: parentAssetId,
        childAssetId: childAssetId,
        relationshipType: relationshipType,
        createdAt: DateTime.now(),
        metadata: const Value('{}'),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Get asset relationships for an asset
  Future<List<AssetRelationshipRow>> getAssetRelationships(String assetId) async {
    final rows = await (_database.select(_database.assetRelationshipsTable)
          ..where((tbl) => tbl.parentAssetId.equals(assetId) | tbl.childAssetId.equals(assetId)))
        .get();
    return rows;
  }

  /// Delete asset relationship
  Future<void> deleteAssetRelationship(String parentAssetId, String childAssetId, String relationshipType) async {
    await (_database.delete(_database.assetRelationshipsTable)
      ..where((tbl) =>
        tbl.parentAssetId.equals(parentAssetId) &
        tbl.childAssetId.equals(childAssetId) &
        tbl.relationshipType.equals(relationshipType))).go();
  }

  /// Store asset property index entry
  Future<void> storeAssetPropertyIndex(String assetId, String propertyKey, String propertyValue, String propertyType) async {
    await _database.into(_database.assetPropertyIndexTable).insert(
      AssetPropertyIndexTableCompanion.insert(
        assetId: assetId,
        propertyKey: propertyKey,
        propertyValue: propertyValue,
        propertyType: propertyType,
        indexedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Search assets by property
  Future<List<String>> searchAssetIdsByProperty(String projectId, String propertyKey, String propertyValue) async {
    final query = _database.select(_database.assetPropertyIndexTable).join([
      innerJoin(_database.assetsTable, _database.assetsTable.id.equalsExp(_database.assetPropertyIndexTable.assetId))
    ])
      ..where(_database.assetsTable.projectId.equals(projectId) &
              _database.assetPropertyIndexTable.propertyKey.equals(propertyKey) &
              _database.assetPropertyIndexTable.propertyValue.equals(propertyValue));

    final results = await query.get();
    return results.map((row) => row.read(_database.assetPropertyIndexTable.assetId)!).toList();
  }

  /// Delete asset property index entries
  Future<void> deleteAssetPropertyIndex(String assetId) async {
    await (_database.delete(_database.assetPropertyIndexTable)
          ..where((tbl) => tbl.assetId.equals(assetId)))
        .go();
  }

  /// Delete asset relationships
  Future<void> deleteAssetRelationships(String assetId) async {
    await (_database.delete(_database.assetRelationshipsTable)
          ..where((tbl) => tbl.parentAssetId.equals(assetId) | tbl.childAssetId.equals(assetId)))
        .go();
  }

  // ===== UTILITIES =====

  /// Get storage statistics
  Future<Map<String, int>> getStorageStats(String projectId) async {
    final templateCount = await (_database.selectOnly(_database.methodologyTemplatesTable)
          ..addColumns([_database.methodologyTemplatesTable.id.count()]))
        .getSingle();

    final runInstanceCount = await (_database.selectOnly(_database.runInstancesTable)
          ..addColumns([_database.runInstancesTable.runId.count()])
          ..where(_database.runInstancesTable.projectId.equals(projectId)))
        .getSingle();

    final triggerMatchCount = await (_database.selectOnly(_database.triggerMatchesTable)
          ..addColumns([_database.triggerMatchesTable.id.count()])
          ..where(_database.triggerMatchesTable.projectId.equals(projectId)))
        .getSingle();

    final historyCount = await (_database.selectOnly(_database.historyEntriesTable)
          ..addColumns([_database.historyEntriesTable.id.count()]))
        .getSingle();

    return {
      'templates': templateCount.read(_database.methodologyTemplatesTable.id.count()) ?? 0,
      'runInstances': runInstanceCount.read(_database.runInstancesTable.runId.count()) ?? 0,
      'triggerMatches': triggerMatchCount.read(_database.triggerMatchesTable.id.count()) ?? 0,
      'history': historyCount.read(_database.historyEntriesTable.id.count()) ?? 0,
    };
  }

  // ===== PRIVATE HELPER METHODS =====

  loader.MethodologyTemplate _methodologyTemplateFromRow(MethodologyTemplateRow row) {
    return loader.MethodologyTemplate(
      id: row.id,
      version: row.version,
      templateVersion: row.templateVersion,
      name: row.name,
      workstream: row.workstream,
      author: row.author,
      created: row.created,
      modified: row.modified,
      status: row.status,
      description: row.description,
      tags: List<String>.from(jsonDecode(row.tags)),
      riskLevel: row.riskLevel,
      overview: loader.MethodologyOverview.fromJson(jsonDecode(row.overview)),
      triggers: (jsonDecode(row.triggers) as List)
          .map((t) => loader.MethodologyTrigger.fromJson(t))
          .toList(),
      equipment: List<String>.from(jsonDecode(row.equipment)),
      procedures: (jsonDecode(row.procedures) as List)
          .map((p) => loader.MethodologyProcedure.fromJson(p))
          .toList(),
      findings: (jsonDecode(row.findings) as List)
          .map((f) => loader.MethodologyFinding.fromJson(f))
          .toList(),
      cleanup: (jsonDecode(row.cleanup) as List)
          .map((c) => loader.MethodologyCleanup.fromJson(c))
          .toList(),
      troubleshooting: (jsonDecode(row.troubleshooting) as List)
          .map((t) => loader.MethodologyTroubleshooting.fromJson(t))
          .toList(),
    );
  }

  RunInstance _runInstanceFromRow(RunInstanceRow row) {
    return RunInstance(
      runId: row.runId,
      templateId: row.templateId,
      templateVersion: row.templateVersion,
      triggerId: row.triggerId,
      assetId: row.assetId,
      matchedValues: Map<String, dynamic>.from(jsonDecode(row.matchedValues)),
      parameters: Map<String, dynamic>.from(jsonDecode(row.parameters)),
      status: RunInstanceStatus.values.firstWhere((e) => e.name == row.status),
      createdAt: row.createdAt,
      createdBy: row.createdBy,
      evidenceIds: List<String>.from(jsonDecode(row.evidenceIds)),
      findingIds: List<String>.from(jsonDecode(row.findingIds)),
      history: [], // History loaded separately
      notes: row.notes,
      updatedAt: row.updatedAt,
      priority: row.priority,
      tags: List<String>.from(jsonDecode(row.tags)),
    );
  }

  HistoryEntry _historyEntryFromRow(HistoryEntryRow row) {
    return HistoryEntry(
      id: row.id,
      timestamp: row.timestamp,
      performedBy: row.performedBy,
      action: HistoryActionType.values.firstWhere((e) => e.name == row.action),
      description: row.description,
      previousValue: row.previousValue,
      newValue: row.newValue,
      metadata: Map<String, dynamic>.from(jsonDecode(row.metadata)),
    );
  }

  TriggerMatch _triggerMatchFromRow(TriggerMatchRow row) {
    return TriggerMatch(
      id: row.id,
      triggerId: row.triggerId,
      templateId: row.templateId,
      assetId: row.assetId,
      matched: row.matched,
      extractedValues: Map<String, dynamic>.from(jsonDecode(row.extractedValues)),
      confidence: row.confidence,
      evaluatedAt: row.evaluatedAt,
      priority: row.priority,
      error: row.error,
      debugInfo: Map<String, dynamic>.from(jsonDecode(row.debugInfo)),
    );
  }

  ParameterResolution _parameterResolutionFromRow(ParameterResolutionRow row) {
    return ParameterResolution(
      name: row.name,
      type: ParameterType.values.firstWhere((e) => e.name == row.type),
      value: jsonDecode(row.value),
      source: ParameterSource.values.firstWhere((e) => e.name == row.source),
      required: row.required,
      resolved: row.resolved,
      error: row.error,
      resolvedAt: row.resolvedAt,
      metadata: Map<String, dynamic>.from(jsonDecode(row.metadata)),
    );
  }

  Asset _assetFromRow(AssetRow row) {
    final propertiesJson = jsonDecode(row.properties) as Map<String, dynamic>;
    final properties = propertiesJson.map((k, v) => MapEntry(k, PropertyValue.fromJson(v as Map<String, dynamic>)));

    final completedTriggers = List<String>.from(jsonDecode(row.completedTriggers));
    final triggerResultsJson = jsonDecode(row.triggerResults) as Map<String, dynamic>;
    final triggerResults = triggerResultsJson.map((k, v) => MapEntry(k, TriggerResult.fromJson(v as Map<String, dynamic>)));

    return Asset(
      id: row.id,
      type: AssetType.values.firstWhere((e) => e.name == row.type),
      projectId: row.projectId,
      name: row.name,
      description: row.description,
      properties: properties,
      completedTriggers: completedTriggers,
      triggerResults: triggerResults,
      parentAssetIds: List<String>.from(jsonDecode(row.parentAssetIds)),
      childAssetIds: List<String>.from(jsonDecode(row.childAssetIds)),
      discoveredAt: row.discoveredAt,
      lastUpdated: row.lastUpdated,
      confidence: row.confidence,
      tags: List<String>.from(jsonDecode(row.tags)),
    );
  }
}