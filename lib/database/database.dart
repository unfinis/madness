import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../models/project.dart';
import '../models/task.dart';
import '../models/contact.dart';
import '../models/expense.dart';
import '../models/credential.dart';
import '../models/scope.dart';
import '../models/document.dart';
import '../models/screenshot.dart';
import '../models/editor_layer.dart';
import '../models/methodology_execution.dart';
import '../models/assets.dart' as AssetsNew;
import '../models/asset_relationship.dart';
import 'tables.dart';
import 'dart:convert';

part 'database.g.dart';

@DriftDatabase(tables: [
  ProjectsTable,
  ProjectStatsTable,
  TasksTable,
  ContactsTable,
  ExpensesTable,
  EvidenceFilesTable,
  CredentialsTable,
  ScopeSegmentsTable,
  ScopeItemsTable,
  DocumentsTable,
  ScreenshotsTable,
  EditorLayersTable,
  ScreenshotFindingsTable,
  FindingsTable,
  FindingComponentsTable,
  FindingLinksTable,
  MethodologyExecutionsTable,
  StepExecutionsTable,
  DiscoveredAssetsTable,
  MethodologyRecommendationsTable,
  AssetsTable,
  AssetRelationshipsTable,
  AssetPropertyIndexTable,
  // Phase 1.1: Methodology Engine Tables
  RunInstancesTable,
  HistoryEntriesTable,
  TriggerMatchesTable,
  ParameterResolutionsTable,
  MethodologyTemplatesTable,
])
class MadnessDatabase extends _$MadnessDatabase {
  MadnessDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 13;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // For now, we recreate all tables on schema changes
        // as per CLAUDE.md instructions
        if (to >= 12) {
          // Drop and recreate assets table to include new schema
          await m.deleteTable('assets');
          await m.deleteTable('asset_relationships');
          await m.deleteTable('asset_property_index');

          // Recreate all tables
          await m.createAll();
        } else if (to >= 9) {
          // Drop and recreate all tables to ensure consistency
          await m.deleteTable('methodology_executions');
          await m.deleteTable('step_executions');
          await m.deleteTable('discovered_assets');
          await m.deleteTable('methodology_recommendations');
          await m.deleteTable('tasks');
          await m.deleteTable('contacts');
          await m.deleteTable('expenses');
          await m.deleteTable('evidence_files');
          await m.deleteTable('credentials');
          await m.deleteTable('scope_segments');
          await m.deleteTable('scope_items');
          await m.deleteTable('documents');
          await m.deleteTable('screenshots');
          await m.deleteTable('editor_layers');
          await m.deleteTable('screenshot_findings');
          await m.deleteTable('findings');
          await m.deleteTable('finding_components');
          await m.deleteTable('finding_links');
          
          // Recreate all tables
          await m.createAll();
        } else if (to >= 8) {
          // Drop and recreate all tables to ensure consistency
          await m.deleteTable('tasks');
          await m.deleteTable('contacts');
          await m.deleteTable('expenses');
          await m.deleteTable('evidence_files');
          await m.deleteTable('credentials');
          await m.deleteTable('scope_segments');
          await m.deleteTable('scope_items');
          await m.deleteTable('documents');
          await m.deleteTable('screenshots');
          await m.deleteTable('editor_layers');
          await m.deleteTable('screenshot_findings');
          await m.deleteTable('findings');
          await m.deleteTable('finding_components');
          await m.deleteTable('finding_links');
          
          // Recreate all tables
          await m.createAll();
        } else if (to >= 5) {
          // Drop and recreate all tables to ensure consistency
          await m.deleteTable('tasks');
          await m.deleteTable('contacts');
          await m.deleteTable('expenses');
          await m.deleteTable('evidence_files');
          await m.deleteTable('credentials');
          await m.deleteTable('scope_segments');
          await m.deleteTable('scope_items');
          await m.deleteTable('documents');
          await m.deleteTable('screenshots');
          await m.deleteTable('editor_layers');
          await m.deleteTable('screenshot_findings');
          
          // Recreate all tables
          await m.createAll();
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'madness');
  }

  // Project operations - returns our model classes, not Drift data classes
  Future<List<Project>> getAllProjects() async {
    final query = select(projectsTable)..orderBy([(p) => OrderingTerm.desc(p.updatedDate)]);
    final rows = await query.get();
    return rows.map(_projectRowToModel).toList();
  }
  
  Future<Project?> getProject(String id) async {
    final query = select(projectsTable)..where((p) => p.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _projectRowToModel(row) : null;
  }

  Future<List<Project>> searchProjects(String query) async {
    final searchQuery = select(projectsTable)
      ..where((p) => 
        p.name.like('%$query%') | 
        p.clientName.like('%$query%') | 
        p.reference.like('%$query%'))
      ..orderBy([(p) => OrderingTerm.desc(p.updatedDate)]);
    
    final rows = await searchQuery.get();
    return rows.map(_projectRowToModel).toList();
  }

  Future<List<Project>> getProjectsByStatus(ProjectStatus status) async {
    final query = select(projectsTable)
      ..where((p) => p.status.equals(status.displayName))
      ..orderBy([(p) => OrderingTerm.desc(p.updatedDate)]);
    
    final rows = await query.get();
    return rows.map(_projectRowToModel).toList();
  }

  Future<Project?> getMostRecentProject() async {
    final query = select(projectsTable)
      ..orderBy([(p) => OrderingTerm.desc(p.updatedDate)])
      ..limit(1);
    
    final row = await query.getSingleOrNull();
    return row != null ? _projectRowToModel(row) : null;
  }

  Future<void> insertProject(Project modelProject) async {
    await into(projectsTable).insert(_modelToProjectRow(modelProject));
    
    // Create default statistics  
    await insertProjectStatistics(ProjectStatistics(
      projectId: modelProject.id,
      totalFindings: 0,
      criticalIssues: 0,
      screenshots: 0,
      attackChains: 0,
      updatedDate: DateTime.now(),
    ));
  }

  Future<void> updateProject(Project modelProject) async {
    await (update(projectsTable)..where((p) => p.id.equals(modelProject.id)))
        .write(_modelToProjectRow(modelProject));
  }

  Future<void> deleteProject(String id) async {
    await (delete(projectStatsTable)..where((p) => p.projectId.equals(id))).go();
    await (delete(projectsTable)..where((p) => p.id.equals(id))).go();
  }

  // Project Statistics operations
  Future<ProjectStatistics?> getProjectStatistics(String projectId) async {
    final query = select(projectStatsTable)..where((p) => p.projectId.equals(projectId));
    final row = await query.getSingleOrNull();
    return row != null ? _projectStatsRowToModel(row) : null;
  }

  Future<void> insertProjectStatistics(ProjectStatistics stats) async {
    await into(projectStatsTable).insert(_modelToProjectStatsRow(stats));
  }

  Future<void> updateProjectStatistics(ProjectStatistics stats) async {
    await (update(projectStatsTable)..where((p) => p.projectId.equals(stats.projectId)))
        .write(_modelToProjectStatsRow(stats));
  }

  Future<void> deleteProjectStatistics(String projectId) async {
    await (delete(projectStatsTable)..where((p) => p.projectId.equals(projectId))).go();
  }

  // Adapter methods to convert between Drift data classes and our model classes
  Project _projectRowToModel(ProjectRow row) {
    return Project(
      id: row.id,
      name: row.name,
      reference: row.reference,
      clientName: row.clientName,
      projectType: row.projectType,
      status: ProjectStatus.fromString(row.status),
      startDate: row.startDate,
      endDate: row.endDate,
      contactPerson: row.contactPerson,
      contactEmail: row.contactEmail,
      description: row.description,
      constraints: row.constraints,
      rules: row.rules.isEmpty ? <String>[] : row.rules.split('|'),
      scope: row.scope,
      assessmentScope: _decodeAssessmentScope(row.assessmentScope),
      createdDate: row.createdDate,
      updatedDate: row.updatedDate,
    );
  }

  ProjectsTableCompanion _modelToProjectRow(Project model) {
    return ProjectsTableCompanion(
      id: Value(model.id),
      name: Value(model.name),
      reference: Value(model.reference),
      clientName: Value(model.clientName),
      projectType: Value(model.projectType),
      status: Value(model.status.displayName),
      startDate: Value(model.startDate),
      endDate: Value(model.endDate),
      contactPerson: Value(model.contactPerson),
      contactEmail: Value(model.contactEmail),
      description: Value(model.description),
      constraints: Value(model.constraints),
      rules: Value(model.rules.join('|')),
      scope: Value(model.scope),
      assessmentScope: Value(_encodeAssessmentScope(model.assessmentScope)),
      createdDate: Value(model.createdDate),
      updatedDate: Value(model.updatedDate),
    );
  }

  ProjectStatistics _projectStatsRowToModel(ProjectStatsRow row) {
    return ProjectStatistics(
      projectId: row.projectId,
      totalFindings: row.totalFindings,
      criticalIssues: row.criticalIssues,
      screenshots: row.screenshots,
      attackChains: row.attackChains,
      updatedDate: row.updatedDate,
    );
  }

  ProjectStatsTableCompanion _modelToProjectStatsRow(ProjectStatistics model) {
    return ProjectStatsTableCompanion(
      projectId: Value(model.projectId),
      totalFindings: Value(model.totalFindings),
      criticalIssues: Value(model.criticalIssues),
      screenshots: Value(model.screenshots),
      attackChains: Value(model.attackChains),
      updatedDate: Value(model.updatedDate),
    );
  }

  static String _encodeAssessmentScope(Map<String, bool> scope) {
    return scope.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .join(',');
  }

  static Map<String, bool> _decodeAssessmentScope(String encoded) {
    if (encoded.isEmpty) return {};
    
    final scopeItems = encoded.split(',');
    return {
      'physicalAccess': scopeItems.contains('physicalAccess'),
      'remoteAccess': scopeItems.contains('remoteAccess'),
      'wirelessAssessment': scopeItems.contains('wirelessAssessment'),
      'socialEngineering': scopeItems.contains('socialEngineering'),
    };
  }

  // Task operations
  Future<List<Task>> getAllTasks(String projectId) async {
    final query = select(tasksTable)
      ..where((t) => t.projectId.equals(projectId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdDate)]);
    final rows = await query.get();
    return rows.map(_taskRowToModel).toList();
  }

  Future<Task?> getTask(String id) async {
    final query = select(tasksTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _taskRowToModel(row) : null;
  }

  Future<void> insertTask(Task task, String projectId) async {
    await into(tasksTable).insert(_modelToTaskRow(task, projectId));
  }

  Future<void> updateTask(Task task, String projectId) async {
    await (update(tasksTable)..where((t) => t.id.equals(task.id)))
        .write(_modelToTaskRow(task, projectId));
  }

  Future<void> deleteTask(String id) async {
    await (delete(tasksTable)..where((t) => t.id.equals(id))).go();
  }

  Task _taskRowToModel(TaskRow row) {
    return Task(
      id: row.id,
      title: row.title,
      description: row.description,
      category: TaskCategory.values.firstWhere((c) => c.name == row.category),
      status: TaskStatus.values.firstWhere((s) => s.name == row.status),
      priority: TaskPriority.values.firstWhere((p) => p.name == row.priority),
      assignedTo: row.assignedTo,
      dueDate: row.dueDate,
      progress: row.progress,
      createdDate: row.createdDate,
      completedDate: row.completedDate,
    );
  }

  TasksTableCompanion _modelToTaskRow(Task task, String projectId) {
    return TasksTableCompanion(
      id: Value(task.id),
      projectId: Value(projectId),
      title: Value(task.title),
      description: Value(task.description),
      category: Value(task.category.name),
      status: Value(task.status.name),
      priority: Value(task.priority.name),
      assignedTo: Value(task.assignedTo),
      dueDate: Value(task.dueDate),
      progress: Value(task.progress),
      createdDate: Value(task.createdDate),
      completedDate: Value(task.completedDate),
    );
  }

  // Contact operations
  Future<List<Contact>> getAllContacts(String projectId) async {
    final query = select(contactsTable)
      ..where((c) => c.projectId.equals(projectId))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);
    final rows = await query.get();
    return rows.map(_contactRowToModel).toList();
  }

  Future<Contact?> getContact(String id) async {
    final query = select(contactsTable)..where((c) => c.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _contactRowToModel(row) : null;
  }

  Future<void> insertContact(Contact contact, String projectId) async {
    await into(contactsTable).insert(_modelToContactRow(contact, projectId));
  }

  Future<void> updateContact(Contact contact, String projectId) async {
    await (update(contactsTable)..where((c) => c.id.equals(contact.id)))
        .write(_modelToContactRow(contact, projectId));
  }

  Future<void> deleteContact(String id) async {
    await (delete(contactsTable)..where((c) => c.id.equals(id))).go();
  }

  Contact _contactRowToModel(ContactRow row) {
    return Contact(
      id: row.id,
      name: row.name,
      role: row.role,
      email: row.email,
      phone: row.phone,
      tags: row.tags.isEmpty ? <String>{} : row.tags.split('|').toSet(),
      notes: row.notes,
      dateAdded: row.dateAdded,
      dateModified: row.dateModified,
    );
  }

  ContactsTableCompanion _modelToContactRow(Contact contact, String projectId) {
    return ContactsTableCompanion(
      id: Value(contact.id),
      projectId: Value(projectId),
      name: Value(contact.name),
      role: Value(contact.role),
      email: Value(contact.email),
      phone: Value(contact.phone),
      tags: Value(contact.tags.join('|')),
      notes: Value(contact.notes),
      dateAdded: Value(contact.dateAdded),
      dateModified: Value(contact.dateModified),
    );
  }

  // Expense operations
  Future<List<Expense>> getAllExpenses(String projectId) async {
    final query = select(expensesTable)
      ..where((e) => e.projectId.equals(projectId))
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    final rows = await query.get();
    final expenses = <Expense>[];
    
    for (final row in rows) {
      final evidenceFiles = await _getEvidenceFilesForExpense(row.id);
      expenses.add(_expenseRowToModel(row, evidenceFiles));
    }
    return expenses;
  }

  Future<Expense?> getExpense(String id) async {
    final query = select(expensesTable)..where((e) => e.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    
    final evidenceFiles = await _getEvidenceFilesForExpense(id);
    return _expenseRowToModel(row, evidenceFiles);
  }

  Future<void> insertExpense(Expense expense, String projectId) async {
    await into(expensesTable).insert(_modelToExpenseRow(expense, projectId));
    
    // Insert evidence files
    for (final evidenceFile in expense.evidenceFiles) {
      await into(evidenceFilesTable).insert(_modelToEvidenceFileRow(evidenceFile, expense.id));
    }
  }

  Future<void> updateExpense(Expense expense, String projectId) async {
    await (update(expensesTable)..where((e) => e.id.equals(expense.id)))
        .write(_modelToExpenseRow(expense, projectId));
    
    // Delete old evidence files and insert new ones
    await (delete(evidenceFilesTable)..where((ef) => ef.expenseId.equals(expense.id))).go();
    for (final evidenceFile in expense.evidenceFiles) {
      await into(evidenceFilesTable).insert(_modelToEvidenceFileRow(evidenceFile, expense.id));
    }
  }

  Future<void> deleteExpense(String id) async {
    await (delete(evidenceFilesTable)..where((ef) => ef.expenseId.equals(id))).go();
    await (delete(expensesTable)..where((e) => e.id.equals(id))).go();
  }

  Future<List<EvidenceFile>> _getEvidenceFilesForExpense(String expenseId) async {
    final query = select(evidenceFilesTable)..where((ef) => ef.expenseId.equals(expenseId));
    final rows = await query.get();
    return rows.map(_evidenceFileRowToModel).toList();
  }

  Expense _expenseRowToModel(ExpenseRow row, List<EvidenceFile> evidenceFiles) {
    return Expense(
      id: row.id,
      description: row.description,
      amount: row.amount,
      type: ExpenseType.values.firstWhere((t) => t.name == row.type),
      category: ExpenseCategory.values.firstWhere((c) => c.name == row.category),
      date: row.date,
      notes: row.notes,
      receiptPath: row.receiptPath,
      evidenceFiles: evidenceFiles,
    );
  }

  ExpensesTableCompanion _modelToExpenseRow(Expense expense, String projectId) {
    return ExpensesTableCompanion(
      id: Value(expense.id),
      projectId: Value(projectId),
      description: Value(expense.description),
      amount: Value(expense.amount),
      type: Value(expense.type.name),
      category: Value(expense.category.name),
      date: Value(expense.date),
      notes: Value(expense.notes),
      receiptPath: Value(expense.receiptPath),
    );
  }

  EvidenceFile _evidenceFileRowToModel(EvidenceFileRow row) {
    return EvidenceFile(
      id: row.id,
      filePath: row.filePath,
      fileName: row.fileName,
      type: EvidenceType.values.firstWhere((t) => t.name == row.type),
      dateAdded: row.dateAdded,
      fileSizeBytes: row.fileSizeBytes,
    );
  }

  EvidenceFilesTableCompanion _modelToEvidenceFileRow(EvidenceFile evidenceFile, String expenseId) {
    return EvidenceFilesTableCompanion(
      id: Value(evidenceFile.id),
      expenseId: Value(expenseId),
      filePath: Value(evidenceFile.filePath),
      fileName: Value(evidenceFile.fileName),
      type: Value(evidenceFile.type.name),
      dateAdded: Value(evidenceFile.dateAdded),
      fileSizeBytes: Value(evidenceFile.fileSizeBytes),
    );
  }

  // Credential operations
  Future<List<Credential>> getAllCredentials(String projectId) async {
    final query = select(credentialsTable)
      ..where((c) => c.projectId.equals(projectId))
      ..orderBy([(c) => OrderingTerm.desc(c.dateAdded)]);
    final rows = await query.get();
    return rows.map(_credentialRowToModel).toList();
  }

  Future<Credential?> getCredential(String id) async {
    final query = select(credentialsTable)..where((c) => c.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _credentialRowToModel(row) : null;
  }

  Future<void> insertCredential(Credential credential, String projectId) async {
    await into(credentialsTable).insert(_modelToCredentialRow(credential, projectId));
  }

  Future<void> updateCredential(Credential credential, String projectId) async {
    await (update(credentialsTable)..where((c) => c.id.equals(credential.id)))
        .write(_modelToCredentialRow(credential, projectId));
  }

  Future<void> deleteCredential(String id) async {
    await (delete(credentialsTable)..where((c) => c.id.equals(id))).go();
  }

  Credential _credentialRowToModel(CredentialRow row) {
    return Credential(
      id: row.id,
      username: row.username,
      password: row.password,
      hash: row.hash,
      type: CredentialType.values.firstWhere((t) => t.name == row.type),
      status: CredentialStatus.values.firstWhere((s) => s.name == row.status),
      privilege: CredentialPrivilege.values.firstWhere((p) => p.name == row.privilege),
      source: CredentialSource.values.firstWhere((s) => s.name == row.source),
      target: row.target,
      dateAdded: row.dateAdded,
      lastTested: row.lastTested,
      notes: row.notes,
      domain: row.domain,
    );
  }

  CredentialsTableCompanion _modelToCredentialRow(Credential credential, String projectId) {
    return CredentialsTableCompanion(
      id: Value(credential.id),
      projectId: Value(projectId),
      username: Value(credential.username),
      password: Value(credential.password),
      hash: Value(credential.hash),
      type: Value(credential.type.name),
      status: Value(credential.status.name),
      privilege: Value(credential.privilege.name),
      source: Value(credential.source.name),
      target: Value(credential.target),
      dateAdded: Value(credential.dateAdded),
      lastTested: Value(credential.lastTested),
      notes: Value(credential.notes),
      domain: Value(credential.domain),
    );
  }

  // Scope operations
  Future<List<ScopeSegment>> getAllScopeSegments(String projectId) async {
    final query = select(scopeSegmentsTable)
      ..where((s) => s.projectId.equals(projectId))
      ..orderBy([(s) => OrderingTerm.asc(s.title)]);
    final rows = await query.get();
    final segments = <ScopeSegment>[];
    
    for (final row in rows) {
      final items = await _getScopeItemsForSegment(row.id);
      segments.add(_scopeSegmentRowToModel(row, items));
    }
    return segments;
  }

  Future<ScopeSegment?> getScopeSegment(String id) async {
    final query = select(scopeSegmentsTable)..where((s) => s.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    
    final items = await _getScopeItemsForSegment(id);
    return _scopeSegmentRowToModel(row, items);
  }

  Future<void> insertScopeSegment(ScopeSegment segment, String projectId) async {
    await into(scopeSegmentsTable).insert(_modelToScopeSegmentRow(segment, projectId));
    
    // Insert scope items
    for (final item in segment.items) {
      await into(scopeItemsTable).insert(_modelToScopeItemRow(item, segment.id));
    }
  }

  Future<void> updateScopeSegment(ScopeSegment segment, String projectId) async {
    await (update(scopeSegmentsTable)..where((s) => s.id.equals(segment.id)))
        .write(_modelToScopeSegmentRow(segment, projectId));
    
    // Delete old items and insert new ones
    await (delete(scopeItemsTable)..where((si) => si.segmentId.equals(segment.id))).go();
    for (final item in segment.items) {
      await into(scopeItemsTable).insert(_modelToScopeItemRow(item, segment.id));
    }
  }

  Future<void> deleteScopeSegment(String id) async {
    await (delete(scopeItemsTable)..where((si) => si.segmentId.equals(id))).go();
    await (delete(scopeSegmentsTable)..where((s) => s.id.equals(id))).go();
  }

  Future<List<ScopeItem>> _getScopeItemsForSegment(String segmentId) async {
    final query = select(scopeItemsTable)..where((si) => si.segmentId.equals(segmentId));
    final rows = await query.get();
    return rows.map(_scopeItemRowToModel).toList();
  }

  ScopeSegment _scopeSegmentRowToModel(ScopeSegmentRow row, List<ScopeItem> items) {
    return ScopeSegment(
      id: row.id,
      title: row.title,
      type: ScopeSegmentType.values.firstWhere((t) => t.name == row.type),
      status: ScopeSegmentStatus.values.firstWhere((s) => s.name == row.status),
      startDate: row.startDate,
      endDate: row.endDate,
      items: items,
      description: row.description,
      notes: row.notes,
    );
  }

  ScopeSegmentsTableCompanion _modelToScopeSegmentRow(ScopeSegment segment, String projectId) {
    return ScopeSegmentsTableCompanion(
      id: Value(segment.id),
      projectId: Value(projectId),
      title: Value(segment.title),
      type: Value(segment.type.name),
      status: Value(segment.status.name),
      startDate: Value(segment.startDate),
      endDate: Value(segment.endDate),
      description: Value(segment.description),
      notes: Value(segment.notes),
    );
  }

  ScopeItem _scopeItemRowToModel(ScopeItemRow row) {
    return ScopeItem(
      id: row.id,
      type: ScopeItemType.values.firstWhere((t) => t.name == row.type),
      target: row.target,
      description: row.description,
      dateAdded: row.dateAdded,
      isActive: row.isActive,
      notes: row.notes,
    );
  }

  ScopeItemsTableCompanion _modelToScopeItemRow(ScopeItem item, String segmentId) {
    return ScopeItemsTableCompanion(
      id: Value(item.id),
      segmentId: Value(segmentId),
      type: Value(item.type.name),
      target: Value(item.target),
      description: Value(item.description),
      dateAdded: Value(item.dateAdded),
      isActive: Value(item.isActive),
      notes: Value(item.notes),
    );
  }

  // Document operations
  Future<List<Document>> getAllDocuments(String projectId) async {
    final query = select(documentsTable)
      ..where((d) => d.projectId.equals(projectId))
      ..orderBy([(d) => OrderingTerm.desc(d.dateModified)]);
    final rows = await query.get();
    return rows.map(_documentRowToModel).toList();
  }

  Future<Document?> getDocument(String id) async {
    final query = select(documentsTable)..where((d) => d.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _documentRowToModel(row) : null;
  }

  Future<void> insertDocument(Document document, String projectId) async {
    await into(documentsTable).insert(_modelToDocumentRow(document, projectId));
  }

  Future<void> updateDocument(Document document, String projectId) async {
    await (update(documentsTable)..where((d) => d.id.equals(document.id)))
        .write(_modelToDocumentRow(document, projectId));
  }

  Future<void> deleteDocument(String id) async {
    await (delete(documentsTable)..where((d) => d.id.equals(id))).go();
  }

  Document _documentRowToModel(DocumentRow row) {
    return Document(
      id: row.id,
      name: row.name,
      description: row.description,
      type: DocumentType.values.firstWhere((t) => t.name == row.type),
      status: DocumentStatus.values.firstWhere((s) => s.name == row.status),
      filePath: row.filePath,
      fileExtension: row.fileExtension,
      fileSizeBytes: row.fileSizeBytes,
      tags: row.tags.isEmpty ? <String>{} : row.tags.split('|').toSet(),
      version: row.version,
      author: row.author,
      dateCreated: row.dateCreated,
      dateModified: row.dateModified,
      dateApproved: row.dateApproved,
      approvedBy: row.approvedBy,
      isTemplate: row.isTemplate,
      isConfidential: row.isConfidential,
      notes: row.notes,
      transferLink: row.transferLink,
      transferWorkspaceName: row.transferWorkspaceName,
    );
  }

  DocumentsTableCompanion _modelToDocumentRow(Document document, String projectId) {
    return DocumentsTableCompanion(
      id: Value(document.id),
      projectId: Value(projectId),
      name: Value(document.name),
      description: Value(document.description),
      type: Value(document.type.name),
      status: Value(document.status.name),
      filePath: Value(document.filePath),
      fileExtension: Value(document.fileExtension),
      fileSizeBytes: Value(document.fileSizeBytes),
      tags: Value(document.tags.join('|')),
      version: Value(document.version),
      author: Value(document.author),
      dateCreated: Value(document.dateCreated),
      dateModified: Value(document.dateModified),
      dateApproved: Value(document.dateApproved),
      approvedBy: Value(document.approvedBy),
      isTemplate: Value(document.isTemplate),
      isConfidential: Value(document.isConfidential),
      notes: Value(document.notes),
      transferLink: Value(document.transferLink),
      transferWorkspaceName: Value(document.transferWorkspaceName),
    );
  }

  // Screenshot operations
  Future<List<Screenshot>> getAllScreenshots(String projectId) async {
    final query = select(screenshotsTable)
      ..where((s) => s.projectId.equals(projectId))
      ..orderBy([(s) => OrderingTerm.desc(s.createdDate)]);
    final rows = await query.get();
    final screenshots = <Screenshot>[];
    
    for (final row in rows) {
      final layers = await _getLayersForScreenshot(row.id);
      screenshots.add(_screenshotRowToModel(row, layers));
    }
    return screenshots;
  }

  Future<Screenshot?> getScreenshot(String id) async {
    final query = select(screenshotsTable)..where((s) => s.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    
    final layers = await _getLayersForScreenshot(id);
    return _screenshotRowToModel(row, layers);
  }

  Future<void> insertScreenshot(Screenshot screenshot, String projectId) async {
    await into(screenshotsTable).insert(_modelToScreenshotRow(screenshot, projectId));
    
    // Insert layers
    for (int i = 0; i < screenshot.layers.length; i++) {
      final layer = screenshot.layers[i];
      await into(editorLayersTable).insert(_modelToLayerRow(layer, screenshot.id, i));
    }
  }

  Future<void> updateScreenshot(Screenshot screenshot, String projectId) async {
    await (update(screenshotsTable)..where((s) => s.id.equals(screenshot.id)))
        .write(_modelToScreenshotRow(screenshot, projectId));
    
    // Delete old layers and insert new ones
    await (delete(editorLayersTable)..where((el) => el.screenshotId.equals(screenshot.id))).go();
    for (int i = 0; i < screenshot.layers.length; i++) {
      final layer = screenshot.layers[i];
      await into(editorLayersTable).insert(_modelToLayerRow(layer, screenshot.id, i));
    }
  }

  Future<void> deleteScreenshot(String id) async {
    await (delete(editorLayersTable)..where((el) => el.screenshotId.equals(id))).go();
    await (delete(screenshotsTable)..where((s) => s.id.equals(id))).go();
  }

  Future<List<EditorLayer>> _getLayersForScreenshot(String screenshotId) async {
    final query = select(editorLayersTable)
      ..where((el) => el.screenshotId.equals(screenshotId))
      ..orderBy([(el) => OrderingTerm.asc(el.orderIndex)]);
    final rows = await query.get();
    return rows.map(_layerRowToModel).toList();
  }

  Screenshot _screenshotRowToModel(ScreenshotRow row, List<EditorLayer> layers) {
    return Screenshot(
      id: row.id,
      name: row.name,
      description: row.description ?? '',
      caption: row.caption,
      instructions: row.instructions,
      originalPath: row.originalPath,
      editedPath: row.editedPath,
      thumbnailPath: row.thumbnailPath,
      width: row.width,
      height: row.height,
      fileSize: row.fileSize,
      layers: layers,
      category: row.category,
      tags: row.tags.isEmpty ? <String>{} : row.tags.split('|').toSet(),
      projectId: row.projectId,
      fileFormat: row.fileFormat,
      captureDate: row.captureDate,
      createdDate: row.createdDate,
      modifiedDate: row.modifiedDate,
      hasRedactions: row.hasRedactions,
      isProcessed: row.isProcessed,
      metadata: row.metadata.isEmpty ? <String, dynamic>{} : json.decode(row.metadata),
    );
  }

  ScreenshotsTableCompanion _modelToScreenshotRow(Screenshot screenshot, String projectId) {
    return ScreenshotsTableCompanion(
      id: Value(screenshot.id),
      projectId: Value(projectId),
      name: Value(screenshot.name),
      description: Value(screenshot.description),
      caption: Value(screenshot.caption),
      instructions: Value(screenshot.instructions),
      originalPath: Value(screenshot.originalPath),
      editedPath: Value(screenshot.editedPath),
      thumbnailPath: Value(screenshot.thumbnailPath),
      width: Value(screenshot.width),
      height: Value(screenshot.height),
      fileSize: Value(screenshot.fileSize),
      fileFormat: Value(screenshot.fileFormat),
      captureDate: Value(screenshot.captureDate),
      createdDate: Value(screenshot.createdDate),
      modifiedDate: Value(screenshot.modifiedDate),
      category: Value(screenshot.category),
      tags: Value(screenshot.tags.join('|')),
      hasRedactions: Value(screenshot.hasRedactions),
      isProcessed: Value(screenshot.isProcessed),
      metadata: Value(json.encode(screenshot.metadata)),
    );
  }

  EditorLayer _layerRowToModel(EditorLayerRow row) {
    final layerData = jsonDecode(row.layerData) as Map<String, dynamic>;
    
    // Build complete JSON structure that EditorLayer.fromJson expects
    final completeJson = {
      'id': row.id,
      'name': row.name,
      'layerType': row.layerType,
      'visible': row.visible,
      'locked': row.locked,
      'opacity': row.opacity,
      'blendModeType': row.blendMode,
      'createdDate': row.createdDate.toIso8601String(),
      'modifiedDate': row.modifiedDate.toIso8601String(),
      ...layerData, // Include the layer-specific data including bounds
    };
    
    return EditorLayer.fromJson(completeJson);
  }

  EditorLayersTableCompanion _modelToLayerRow(EditorLayer layer, String screenshotId, int orderIndex) {
    final layerJson = layer.toJson();
    final layerData = Map<String, dynamic>.from(layerJson);
    
    // Remove common fields that are stored in separate columns
    layerData.removeWhere((key, value) => 
      ['id', 'name', 'layerType', 'visible', 'locked', 'opacity', 'blendModeType', 
       'createdDate', 'modifiedDate'].contains(key));
    
    return EditorLayersTableCompanion(
      id: Value(layer.id),
      screenshotId: Value(screenshotId),
      layerType: Value(layer.layerType.name),
      name: Value(layer.name),
      orderIndex: Value(orderIndex),
      visible: Value(layer.visible),
      locked: Value(layer.locked),
      opacity: Value(layer.opacity),
      blendMode: Value(layer.blendModeType.name),
      layerData: Value(jsonEncode(layerData)),
      createdDate: Value(layer.createdDate),
      modifiedDate: Value(layer.modifiedDate),
    );
  }

  // Methodology execution operations
  Future<List<MethodologyExecution>> getAllMethodologyExecutions(String projectId) async {
    final query = select(methodologyExecutionsTable)
      ..where((e) => e.projectId.equals(projectId))
      ..orderBy([(e) => OrderingTerm.desc(e.startTime)]);
    final rows = await query.get();
    
    final executions = <MethodologyExecution>[];
    for (final row in rows) {
      final steps = await _getStepExecutionsForExecution(row.id);
      executions.add(_methodologyExecutionRowToModel(row, steps));
    }
    return executions;
  }

  Future<MethodologyExecution?> getMethodologyExecution(String id) async {
    final query = select(methodologyExecutionsTable)..where((e) => e.id.equals(id));
    final row = await query.getSingleOrNull();
    if (row == null) return null;
    
    final steps = await _getStepExecutionsForExecution(id);
    return _methodologyExecutionRowToModel(row, steps);
  }

  Future<void> insertMethodologyExecution(MethodologyExecution execution) async {
    await into(methodologyExecutionsTable).insert(_modelToMethodologyExecutionRow(execution));
    
    for (final step in execution.stepExecutions) {
      await into(stepExecutionsTable).insert(_modelToStepExecutionRow(step, execution.id));
    }
  }

  Future<void> updateMethodologyExecution(MethodologyExecution execution) async {
    await (update(methodologyExecutionsTable)..where((e) => e.id.equals(execution.id)))
        .write(_modelToMethodologyExecutionRow(execution));
    
    // Delete old step executions and insert new ones
    await (delete(stepExecutionsTable)..where((se) => se.executionId.equals(execution.id))).go();
    for (final step in execution.stepExecutions) {
      await into(stepExecutionsTable).insert(_modelToStepExecutionRow(step, execution.id));
    }
  }

  Future<void> deleteMethodologyExecution(String id) async {
    await (delete(stepExecutionsTable)..where((se) => se.executionId.equals(id))).go();
    await (delete(methodologyExecutionsTable)..where((e) => e.id.equals(id))).go();
  }

  Future<List<StepExecution>> _getStepExecutionsForExecution(String executionId) async {
    final query = select(stepExecutionsTable)..where((se) => se.executionId.equals(executionId));
    final rows = await query.get();
    return rows.map(_stepExecutionRowToModel).toList();
  }

  MethodologyExecution _methodologyExecutionRowToModel(MethodologyExecutionRow row, List<StepExecution> steps) {
    return MethodologyExecution(
      id: row.id,
      projectId: row.projectId,
      methodologyId: row.methodologyId,
      status: ExecutionStatus.values.firstWhere((s) => s.name == row.status),
      progress: row.progress.toDouble(),
      startedDate: row.startTime,
      completedDate: row.endTime,
      stepExecutions: steps,
      executionContext: row.additionalContext != null ? jsonDecode(row.additionalContext!) : {},
      errorMessage: row.errors,
    );
  }

  MethodologyExecutionsTableCompanion _modelToMethodologyExecutionRow(MethodologyExecution execution) {
    return MethodologyExecutionsTableCompanion(
      id: Value(execution.id),
      projectId: Value(execution.projectId),
      methodologyId: Value(execution.methodologyId),
      status: Value(execution.status.name),
      category: Value(''), // Will be filled from methodology definition
      riskLevel: Value(''), // Will be filled from methodology definition
      startTime: Value(execution.startedDate),
      endTime: Value(execution.completedDate),
      lastUpdated: Value(execution.completedDate ?? DateTime.now()),
      triggerSource: Value(null), // Not directly available in current model
      additionalContext: Value(jsonEncode(execution.executionContext)),
      output: Value(null), // Not directly available in current model
      errors: Value(execution.errorMessage),
      progress: Value(execution.progress.toInt()),
    );
  }

  StepExecution _stepExecutionRowToModel(StepExecutionRow row) {
    return StepExecution(
      id: row.id,
      stepId: row.stepId,
      executionId: '', // Will be set by calling code
      status: ExecutionStatus.values.firstWhere((s) => s.name == row.status),
      command: row.command ?? '',
      output: row.output,
      errorOutput: row.errors,
      exitCode: row.exitCode ?? 0,
      startedDate: row.startTime,
      completedDate: row.endTime,
    );
  }

  StepExecutionsTableCompanion _modelToStepExecutionRow(StepExecution step, String executionId) {
    return StepExecutionsTableCompanion(
      id: Value(step.id),
      executionId: Value(executionId),
      stepId: Value(step.stepId),
      status: Value(step.status.name),
      startTime: Value(step.startedDate),
      endTime: Value(step.completedDate),
      command: Value(step.command),
      output: Value(step.output),
      errors: Value(step.errorOutput),
      exitCode: Value(step.exitCode),
    );
  }

  // Discovered assets operations
  Future<List<DiscoveredAsset>> getAllDiscoveredAssets(String projectId) async {
    final query = select(discoveredAssetsTable)
      ..where((a) => a.projectId.equals(projectId))
      ..orderBy([(a) => OrderingTerm.desc(a.discoveredAt)]);
    final rows = await query.get();
    return rows.map(_discoveredAssetRowToModel).toList();
  }

  Future<List<DiscoveredAsset>> getDiscoveredAssetsByExecution(String executionId) async {
    final query = select(discoveredAssetsTable)
      ..where((a) => a.executionId.equals(executionId))
      ..orderBy([(a) => OrderingTerm.desc(a.discoveredAt)]);
    final rows = await query.get();
    return rows.map(_discoveredAssetRowToModel).toList();
  }

  Future<void> insertDiscoveredAsset(DiscoveredAsset asset) async {
    await into(discoveredAssetsTable).insert(_modelToDiscoveredAssetRow(asset));
  }

  Future<void> updateDiscoveredAsset(DiscoveredAsset asset) async {
    await (update(discoveredAssetsTable)..where((a) => a.id.equals(asset.id)))
        .write(_modelToDiscoveredAssetRow(asset));
  }

  Future<void> deleteDiscoveredAsset(String id) async {
    await (delete(discoveredAssetsTable)..where((a) => a.id.equals(id))).go();
  }

  DiscoveredAsset _discoveredAssetRowToModel(DiscoveredAssetRow row) {
    return DiscoveredAsset(
      id: row.id,
      projectId: row.projectId,
      type: AssetType.values.firstWhere((t) => t.name == row.type),
      name: '', // Will need to be derived from value or metadata
      value: row.value,
      properties: row.metadata != null ? jsonDecode(row.metadata!) : {},
      confidence: row.confidence,
      discoveredDate: row.discoveredAt,
      isVerified: row.isVerified,
    );
  }

  DiscoveredAssetsTableCompanion _modelToDiscoveredAssetRow(DiscoveredAsset asset) {
    return DiscoveredAssetsTableCompanion(
      id: Value(asset.id),
      projectId: Value(asset.projectId),
      executionId: Value(asset.sourceExecutionId),
      type: Value(asset.type.name),
      value: Value(asset.value),
      source: Value(asset.sourceStepId ?? 'manual'),
      confidence: Value(asset.confidence),
      discoveredAt: Value(asset.discoveredDate),
      metadata: Value(jsonEncode(asset.properties)),
      isVerified: Value(asset.isVerified),
      tags: Value(''), // Tags not directly available in current model
    );
  }

  // Methodology recommendations operations
  Future<List<MethodologyRecommendation>> getAllMethodologyRecommendations(String projectId) async {
    final query = select(methodologyRecommendationsTable)
      ..where((r) => r.projectId.equals(projectId))
      ..orderBy([(r) => OrderingTerm.desc(r.createdAt)]);
    final rows = await query.get();
    return rows.map(_methodologyRecommendationRowToModel).toList();
  }

  Future<void> insertMethodologyRecommendation(MethodologyRecommendation recommendation) async {
    await into(methodologyRecommendationsTable).insert(_modelToMethodologyRecommendationRow(recommendation));
  }

  Future<void> updateMethodologyRecommendation(MethodologyRecommendation recommendation) async {
    await (update(methodologyRecommendationsTable)..where((r) => r.id.equals(recommendation.id)))
        .write(_modelToMethodologyRecommendationRow(recommendation));
  }

  Future<void> deleteMethodologyRecommendation(String id) async {
    await (delete(methodologyRecommendationsTable)..where((r) => r.id.equals(id))).go();
  }

  MethodologyRecommendation _methodologyRecommendationRowToModel(MethodologyRecommendationRow row) {
    return MethodologyRecommendation(
      id: row.id,
      projectId: row.projectId,
      methodologyId: row.methodologyId,
      reason: row.reason,
      confidence: row.confidence,
      createdDate: row.createdAt,
      isDismissed: row.isDismissed,
      context: row.context != null ? jsonDecode(row.context!) : {},
    );
  }

  MethodologyRecommendationsTableCompanion _modelToMethodologyRecommendationRow(MethodologyRecommendation recommendation) {
    return MethodologyRecommendationsTableCompanion(
      id: Value(recommendation.id),
      projectId: Value(recommendation.projectId),
      methodologyId: Value(recommendation.methodologyId),
      category: Value(''), // Will be filled from methodology definition
      riskLevel: Value(''), // Will be filled from methodology definition
      reason: Value(recommendation.reason),
      triggerAssetId: Value(null), // Will be set by the calling code if needed
      confidence: Value(recommendation.confidence),
      createdAt: Value(recommendation.createdDate),
      isDismissed: Value(recommendation.isDismissed),
      isSuppressed: Value(false), // Not directly available in current model
      suppressionReason: Value(null), // Not directly available in current model
      context: Value(jsonEncode(recommendation.context)),
    );
  }


  // ==========================================================================
  // Asset Management Operations
  // ==========================================================================

  /// Get all assets for a project
  Future<List<AssetsNew.Asset>> getAssetsForProject(String projectId) async {
    final query = select(assetsTable)
      ..where((a) => a.projectId.equals(projectId))
      ..orderBy([(a) => OrderingTerm.desc(a.discoveredAt)]);
    final rows = await query.get();
    return rows.map(_assetRowToModel).toList();
  }

  /// Get assets by type
  Future<List<AssetsNew.Asset>> getAssetsByType(
      String projectId, AssetsNew.AssetType type) async {
    final query = select(assetsTable)
      ..where((a) => a.projectId.equals(projectId) & a.type.equals(type.name))
      ..orderBy([(a) => OrderingTerm.desc(a.discoveredAt)]);
    final rows = await query.get();
    return rows.map(_assetRowToModel).toList();
  }

  /// Get a single asset by ID
  Future<AssetsNew.Asset?> getAsset(String id) async {
    final query = select(assetsTable)..where((a) => a.id.equals(id));
    final row = await query.getSingleOrNull();
    return row != null ? _assetRowToModel(row) : null;
  }

  /// Insert a new asset
  Future<AssetsNew.Asset> insertAsset(AssetsNew.Asset asset) async {
    await into(assetsTable).insert(_modelToAssetRow(asset));

    // Insert relationships
    await _insertAssetRelationships(asset);

    // Index properties for searching
    await _indexAssetProperties(asset);

    return asset;
  }

  /// Update an existing asset
  Future<AssetsNew.Asset> updateAsset(AssetsNew.Asset asset) async {
    await (update(assetsTable)..where((a) => a.id.equals(asset.id)))
        .write(_modelToAssetRow(asset));

    // Update relationships
    await _deleteAssetRelationships(asset.id);
    await _insertAssetRelationships(asset);

    // Re-index properties
    await _deleteAssetPropertyIndex(asset.id);
    await _indexAssetProperties(asset);

    return asset;
  }

  /// Delete an asset
  Future<void> deleteAsset(String id) async {
    await _deleteAssetRelationships(id);
    await _deleteAssetPropertyIndex(id);
    await (delete(assetsTable)..where((a) => a.id.equals(id))).go();
  }

  Future<void> insertAssetRelationship(AssetRelationship relationship) async {
    await into(assetRelationshipsTable).insert(
      AssetRelationshipsTableCompanion(
        parentAssetId: Value(relationship.parentAssetId),
        childAssetId: Value(relationship.childAssetId),
        relationshipType: Value(relationship.relationshipType.name),
        createdAt: Value(relationship.createdAt),
      ),
    );
  }

  /// Get child assets for a parent asset
  Future<List<AssetsNew.Asset>> getChildAssets(String parentAssetId) async {
    final relationshipQuery = select(assetRelationshipsTable)
      ..where((r) => r.parentAssetId.equals(parentAssetId) &
                     r.relationshipType.equals('parent'));

    final relationships = await relationshipQuery.get();
    final childIds = relationships.map((r) => r.childAssetId).toList();

    if (childIds.isEmpty) return [];

    final assetQuery = select(assetsTable)
      ..where((a) => a.id.isIn(childIds));

    final rows = await assetQuery.get();
    return rows.map(_assetRowToModel).toList();
  }

  /// Get parent assets for a child asset
  Future<List<AssetsNew.Asset>> getParentAssets(String childAssetId) async {
    final relationshipQuery = select(assetRelationshipsTable)
      ..where((r) => r.childAssetId.equals(childAssetId) &
                     r.relationshipType.equals('parent'));

    final relationships = await relationshipQuery.get();
    final parentIds = relationships.map((r) => r.parentAssetId).toList();

    if (parentIds.isEmpty) return [];

    final assetQuery = select(assetsTable)
      ..where((a) => a.id.isIn(parentIds));

    final rows = await assetQuery.get();
    return rows.map(_assetRowToModel).toList();
  }

  /// Search assets by property values
  Future<List<AssetsNew.Asset>> searchAssetsByProperty(
      String projectId, String propertyKey, String propertyValue) async {
    final indexQuery = select(assetPropertyIndexTable)
      ..where((i) => i.propertyKey.equals(propertyKey) &
                     i.propertyValue.like('%$propertyValue%'));

    final indexRows = await indexQuery.get();
    final assetIds = indexRows.map((i) => i.assetId).toSet().toList();

    if (assetIds.isEmpty) return [];

    final assetQuery = select(assetsTable)
      ..where((a) => a.projectId.equals(projectId) & a.id.isIn(assetIds));

    final rows = await assetQuery.get();
    return rows.map(_assetRowToModel).toList();
  }

  /// Get assets by discovery status
  Future<List<AssetsNew.Asset>> getAssetsByDiscoveryStatus(
      String projectId, AssetsNew.AssetDiscoveryStatus status) async {
    final query = select(assetsTable)
      ..where((a) => a.projectId.equals(projectId) &
                     a.discoveryStatus.equals(status.name))
      ..orderBy([(a) => OrderingTerm.desc(a.discoveredAt)]);

    final rows = await query.get();
    return rows.map(_assetRowToModel).toList();
  }

  // Private helper methods for assets

  /// Convert database row to asset model
  AssetsNew.Asset _assetRowToModel(AssetRow row) {
    try {
      final propertiesMap = jsonDecode(row.properties) as Map<String, dynamic>;
      final properties = <String, AssetsNew.AssetPropertyValue>{};

      for (final entry in propertiesMap.entries) {
        properties[entry.key] = AssetsNew.AssetPropertyValue.fromJson(entry.value);
      }

      final completedTriggers = List<String>.from(jsonDecode(row.completedTriggers));

      final triggerResultsMap = jsonDecode(row.triggerResults) as Map<String, dynamic>;
      final triggerResults = <String, AssetsNew.TriggerExecutionResult>{};

      for (final entry in triggerResultsMap.entries) {
        triggerResults[entry.key] = AssetsNew.TriggerExecutionResult.fromJson(entry.value);
      }

      final parentAssetIds = List<String>.from(jsonDecode(row.parentAssetIds));
      final childAssetIds = List<String>.from(jsonDecode(row.childAssetIds));
      final relatedAssetIds = List<String>.from(jsonDecode(row.relatedAssetIds));
      final tags = List<String>.from(jsonDecode(row.tags));

      final metadata = row.metadata != null
          ? Map<String, String>.from(jsonDecode(row.metadata!))
          : <String, String>{};

      final securityControls = row.securityControls != null
          ? List<String>.from(jsonDecode(row.securityControls!))
          : <String>[];

      return AssetsNew.Asset(
        id: row.id,
        type: AssetsNew.AssetType.values.byName(row.type),
        projectId: row.projectId,
        name: row.name,
        description: row.description,
        properties: properties,
        discoveryStatus: AssetsNew.AssetDiscoveryStatus.values.byName(row.discoveryStatus),
        discoveredAt: row.discoveredAt,
        lastUpdated: row.lastUpdated,
        discoveryMethod: row.discoveryMethod,
        confidence: row.confidence,
        parentAssetIds: parentAssetIds,
        childAssetIds: childAssetIds,
        relatedAssetIds: relatedAssetIds,
        completedTriggers: completedTriggers,
        triggerResults: triggerResults,
        tags: tags,
        metadata: metadata,
        accessLevel: row.accessLevel != null
            ? AssetsNew.AccessLevel.values.byName(row.accessLevel!) : null,
        securityControls: securityControls,
      );
    } catch (e) {
      throw Exception('Failed to convert ComprehensiveAssetRow to Asset: $e');
    }
  }

  /// Convert asset model to database row
  AssetsTableCompanion _modelToAssetRow(AssetsNew.Asset asset) {
    try {
      final propertiesJson = <String, dynamic>{};
      for (final entry in asset.properties.entries) {
        propertiesJson[entry.key] = entry.value.toJson();
      }

      final triggerResultsJson = <String, dynamic>{};
      for (final entry in asset.triggerResults.entries) {
        triggerResultsJson[entry.key] = entry.value.toJson();
      }

      return AssetsTableCompanion(
        id: Value(asset.id),
        type: Value(asset.type.name),
        projectId: Value(asset.projectId),
        name: Value(asset.name),
        description: Value(asset.description),
        properties: Value(jsonEncode(propertiesJson)),
        discoveryStatus: Value(asset.discoveryStatus.name),
        discoveredAt: Value(asset.discoveredAt),
        lastUpdated: Value(asset.lastUpdated),
        discoveryMethod: Value(asset.discoveryMethod),
        confidence: Value(asset.confidence),
        parentAssetIds: Value(jsonEncode(asset.parentAssetIds)),
        childAssetIds: Value(jsonEncode(asset.childAssetIds)),
        relatedAssetIds: Value(jsonEncode(asset.relatedAssetIds)),
        completedTriggers: Value(jsonEncode(asset.completedTriggers)),
        triggerResults: Value(jsonEncode(triggerResultsJson)),
        tags: Value(jsonEncode(asset.tags)),
        metadata: Value(asset.metadata != null ? jsonEncode(asset.metadata!) : null),
        accessLevel: Value(asset.accessLevel?.name),
        securityControls: Value(asset.securityControls != null ?
            jsonEncode(asset.securityControls!) : null),
      );
    } catch (e) {
      throw Exception('Failed to convert Asset to AssetsTableCompanion: $e');
    }
  }

  /// Insert asset relationships
  Future<void> _insertAssetRelationships(AssetsNew.Asset asset) async {
    final now = DateTime.now();

    // Insert parent relationships
    for (final parentId in asset.parentAssetIds) {
      await into(assetRelationshipsTable).insert(
        AssetRelationshipsTableCompanion(
          parentAssetId: Value(parentId),
          childAssetId: Value(asset.id),
          relationshipType: const Value('parent'),
          createdAt: Value(now),
        ),
      );
    }

    // Insert child relationships
    for (final childId in asset.childAssetIds) {
      await into(assetRelationshipsTable).insert(
        AssetRelationshipsTableCompanion(
          parentAssetId: Value(asset.id),
          childAssetId: Value(childId),
          relationshipType: const Value('parent'),
          createdAt: Value(now),
        ),
      );
    }

    // Insert related relationships
    for (final relatedId in asset.relatedAssetIds) {
      await into(assetRelationshipsTable).insert(
        AssetRelationshipsTableCompanion(
          parentAssetId: Value(asset.id),
          childAssetId: Value(relatedId),
          relationshipType: const Value('related'),
          createdAt: Value(now),
        ),
      );
    }
  }

  /// Delete asset relationships
  Future<void> _deleteAssetRelationships(String assetId) async {
    await (delete(assetRelationshipsTable)..where((r) =>
        r.parentAssetId.equals(assetId) | r.childAssetId.equals(assetId))).go();
  }

  /// Index asset properties for searching
  Future<void> _indexAssetProperties(AssetsNew.Asset asset) async {
    final now = DateTime.now();

    for (final entry in asset.properties.entries) {
      final propertyValue = entry.value.when(
        string: (v) => v,
        integer: (v) => v.toString(),
        double: (v) => v.toString(),
        boolean: (v) => v.toString(),
        stringList: (v) => v.join(','),
        dateTime: (v) => v.toIso8601String(),
        map: (v) => jsonEncode(v),
        objectList: (v) => jsonEncode(v),
      );

      final propertyType = entry.value.when(
        string: (_) => 'string',
        integer: (_) => 'integer',
        double: (_) => 'double',
        boolean: (_) => 'boolean',
        stringList: (_) => 'stringList',
        dateTime: (_) => 'dateTime',
        map: (_) => 'map',
        objectList: (_) => 'objectList',
      );

      await into(assetPropertyIndexTable).insert(
        AssetPropertyIndexTableCompanion(
          assetId: Value(asset.id),
          propertyKey: Value(entry.key),
          propertyValue: Value(propertyValue),
          propertyType: Value(propertyType),
          indexedAt: Value(now),
        ),
      );
    }
  }

  /// Delete asset property index entries
  Future<void> _deleteAssetPropertyIndex(String assetId) async {
    await (delete(assetPropertyIndexTable)..where((i) => i.assetId.equals(assetId))).go();
  }
}