import 'package:drift/drift.dart';

@DataClassName('ProjectRow')
class ProjectsTable extends Table {
  @override
  String get tableName => 'projects';
  
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get reference => text()();
  TextColumn get clientName => text().named('client_name')();
  TextColumn get projectType => text().named('project_type')();
  TextColumn get status => text()();
  DateTimeColumn get startDate => dateTime().named('start_date')();
  DateTimeColumn get endDate => dateTime().named('end_date')();
  TextColumn get contactPerson => text().named('contact_person').nullable()();
  TextColumn get contactEmail => text().named('contact_email').nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get constraints => text()();
  TextColumn get rules => text()();
  TextColumn get scope => text()();
  TextColumn get assessmentScope => text().named('assessment_scope')();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get updatedDate => dateTime().named('updated_date')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProjectStatsRow')
class ProjectStatsTable extends Table {
  @override
  String get tableName => 'project_statistics';

  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  IntColumn get totalFindings => integer().named('total_findings').withDefault(const Constant(0))();
  IntColumn get criticalIssues => integer().named('critical_issues').withDefault(const Constant(0))();
  IntColumn get screenshots => integer().withDefault(const Constant(0))();
  IntColumn get attackChains => integer().named('attack_chains').withDefault(const Constant(0))();
  DateTimeColumn get updatedDate => dateTime().named('updated_date')();

  @override
  Set<Column> get primaryKey => {projectId};
}

@DataClassName('TaskRow')
class TasksTable extends Table {
  @override
  String get tableName => 'tasks';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get category => text()();
  TextColumn get status => text()();
  TextColumn get priority => text()();
  TextColumn get assignedTo => text().named('assigned_to').nullable()();
  DateTimeColumn get dueDate => dateTime().named('due_date').nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get completedDate => dateTime().named('completed_date').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ContactRow')
class ContactsTable extends Table {
  @override
  String get tableName => 'contacts';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get name => text()();
  TextColumn get role => text()();
  TextColumn get email => text()();
  TextColumn get phone => text()();
  TextColumn get tags => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get dateAdded => dateTime().named('date_added')();
  DateTimeColumn get dateModified => dateTime().named('date_modified')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseRow')
class ExpensesTable extends Table {
  @override
  String get tableName => 'expenses';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  TextColumn get category => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get receiptPath => text().named('receipt_path').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EvidenceFileRow')
class EvidenceFilesTable extends Table {
  @override
  String get tableName => 'evidence_files';

  TextColumn get id => text()();
  TextColumn get expenseId => text().named('expense_id').references(ExpensesTable, #id)();
  TextColumn get filePath => text().named('file_path')();
  TextColumn get fileName => text().named('file_name')();
  TextColumn get type => text()();
  DateTimeColumn get dateAdded => dateTime().named('date_added')();
  IntColumn get fileSizeBytes => integer().named('file_size_bytes').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CredentialRow')
class CredentialsTable extends Table {
  @override
  String get tableName => 'credentials';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get username => text()();
  TextColumn get password => text().nullable()();
  TextColumn get hash => text().nullable()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  TextColumn get privilege => text()();
  TextColumn get source => text()();
  TextColumn get target => text()();
  DateTimeColumn get dateAdded => dateTime().named('date_added')();
  DateTimeColumn get lastTested => dateTime().named('last_tested').nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get domain => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScopeSegmentRow')
class ScopeSegmentsTable extends Table {
  @override
  String get tableName => 'scope_segments';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get title => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  DateTimeColumn get startDate => dateTime().named('start_date').nullable()();
  DateTimeColumn get endDate => dateTime().named('end_date').nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScopeItemRow')
class ScopeItemsTable extends Table {
  @override
  String get tableName => 'scope_items';

  TextColumn get id => text()();
  TextColumn get segmentId => text().named('segment_id').references(ScopeSegmentsTable, #id)();
  TextColumn get type => text()();
  TextColumn get target => text()();
  TextColumn get description => text()();
  DateTimeColumn get dateAdded => dateTime().named('date_added')();
  BoolColumn get isActive => boolean().named('is_active').withDefault(const Constant(true))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DocumentRow')
class DocumentsTable extends Table {
  @override
  String get tableName => 'documents';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get type => text()();
  TextColumn get status => text()();
  TextColumn get filePath => text().named('file_path').nullable()();
  TextColumn get fileExtension => text().named('file_extension').nullable()();
  IntColumn get fileSizeBytes => integer().named('file_size_bytes').nullable()();
  TextColumn get tags => text()();
  TextColumn get version => text().nullable()();
  TextColumn get author => text().nullable()();
  DateTimeColumn get dateCreated => dateTime().named('date_created')();
  DateTimeColumn get dateModified => dateTime().named('date_modified')();
  DateTimeColumn get dateApproved => dateTime().named('date_approved').nullable()();
  TextColumn get approvedBy => text().named('approved_by').nullable()();
  BoolColumn get isTemplate => boolean().named('is_template').withDefault(const Constant(false))();
  BoolColumn get isConfidential => boolean().named('is_confidential').withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
  TextColumn get transferLink => text().named('transfer_link').nullable()();
  TextColumn get transferWorkspaceName => text().named('transfer_workspace_name').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScreenshotRow')
class ScreenshotsTable extends Table {
  @override
  String get tableName => 'screenshots';

  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get caption => text().withDefault(const Constant(''))();
  TextColumn get instructions => text().withDefault(const Constant(''))();
  TextColumn get originalPath => text().named('original_path')();
  TextColumn get editedPath => text().named('edited_path').nullable()();
  TextColumn get thumbnailPath => text().named('thumbnail_path').nullable()();
  IntColumn get width => integer()();
  IntColumn get height => integer()();
  IntColumn get fileSize => integer().named('file_size')();
  TextColumn get fileFormat => text().named('file_format')();
  DateTimeColumn get captureDate => dateTime().named('capture_date')();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get modifiedDate => dateTime().named('modified_date')();
  TextColumn get category => text().withDefault(const Constant('other'))();
  TextColumn get tags => text().withDefault(const Constant(''))();
  BoolColumn get hasRedactions => boolean().named('has_redactions').withDefault(const Constant(false))();
  BoolColumn get isProcessed => boolean().named('is_processed').withDefault(const Constant(false))();
  TextColumn get metadata => text().withDefault(const Constant('{}'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EditorLayerRow')
class EditorLayersTable extends Table {
  @override
  String get tableName => 'editor_layers';

  TextColumn get id => text()();
  TextColumn get screenshotId => text().named('screenshot_id').references(ScreenshotsTable, #id)();
  TextColumn get layerType => text().named('layer_type')(); // 'bitmap', 'vector', 'text', 'redaction'
  TextColumn get name => text()();
  IntColumn get orderIndex => integer().named('order_index')();
  BoolColumn get visible => boolean().withDefault(const Constant(true))();
  BoolColumn get locked => boolean().withDefault(const Constant(false))();
  RealColumn get opacity => real().withDefault(const Constant(1.0))();
  TextColumn get blendMode => text().named('blend_mode').withDefault(const Constant('normal'))();
  TextColumn get layerData => text().named('layer_data')(); // JSON serialized layer-specific data
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get modifiedDate => dateTime().named('modified_date')();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ScreenshotFindingRow')
class ScreenshotFindingsTable extends Table {
  @override
  String get tableName => 'screenshot_findings';

  TextColumn get screenshotId => text().named('screenshot_id').references(ScreenshotsTable, #id)();
  TextColumn get findingId => text().named('finding_id')();
  TextColumn get annotationId => text().named('annotation_id').nullable()();
  // Sub-finding support
  TextColumn get subFindingId => text().named('sub_finding_id').nullable()();
  TextColumn get subFindingTitle => text().named('sub_finding_title').nullable()();
  DateTimeColumn get linkedDate => dateTime().named('linked_date')();

  @override
  Set<Column> get primaryKey => {screenshotId, findingId};
}

@DataClassName('FindingRow')
class FindingsTable extends Table {
  @override
  String get tableName => 'findings';
  
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get title => text()();
  TextColumn get description => text()();
  RealColumn get cvssScore => real().named('cvss_score')();
  TextColumn get cvssVector => text().named('cvss_vector').nullable()();
  TextColumn get severity => text()();
  TextColumn get status => text().withDefault(const Constant('draft'))();
  TextColumn get auditSteps => text().named('audit_steps').nullable()();
  TextColumn get automatedScript => text().named('automated_script').nullable()();
  TextColumn get furtherReading => text().named('further_reading').nullable()();
  TextColumn get verificationProcedure => text().named('verification_procedure').nullable()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  // Sub-finding support
  BoolColumn get isMainFinding => boolean().named('is_main_finding').withDefault(const Constant(false))();
  TextColumn get parentFindingId => text().named('parent_finding_id').nullable()();
  TextColumn get subFindingsData => text().named('sub_findings_data').nullable()(); // JSON array of sub-findings
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  DateTimeColumn get updatedDate => dateTime().named('updated_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FindingComponentRow')
class FindingComponentsTable extends Table {
  @override
  String get tableName => 'finding_components';
  
  TextColumn get id => text()();
  TextColumn get findingId => text().named('finding_id').references(FindingsTable, #id)();
  TextColumn get componentType => text().named('component_type')();
  TextColumn get name => text()();
  TextColumn get value => text()();
  TextColumn get description => text().nullable()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('FindingLinkRow')
class FindingLinksTable extends Table {
  @override
  String get tableName => 'finding_links';
  
  TextColumn get id => text()();
  TextColumn get findingId => text().named('finding_id').references(FindingsTable, #id)();
  TextColumn get title => text()();
  TextColumn get url => text()();
  IntColumn get orderIndex => integer().named('order_index').withDefault(const Constant(0))();
  DateTimeColumn get createdDate => dateTime().named('created_date')();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Methodology persistence tables
@DataClassName('MethodologyExecutionRow')
class MethodologyExecutionsTable extends Table {
  @override
  String get tableName => 'methodology_executions';
  
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get methodologyId => text().named('methodology_id')();
  TextColumn get status => text()();
  TextColumn get category => text()();
  TextColumn get riskLevel => text().named('risk_level')();
  DateTimeColumn get startTime => dateTime().named('start_time')();
  DateTimeColumn get endTime => dateTime().named('end_time').nullable()();
  DateTimeColumn get lastUpdated => dateTime().named('last_updated')();
  TextColumn get triggerSource => text().named('trigger_source').nullable()();
  TextColumn get additionalContext => text().named('additional_context').nullable()(); // JSON
  TextColumn get output => text().nullable()();
  TextColumn get errors => text().nullable()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('StepExecutionRow')
class StepExecutionsTable extends Table {
  @override
  String get tableName => 'step_executions';
  
  TextColumn get id => text()();
  TextColumn get executionId => text().named('execution_id').references(MethodologyExecutionsTable, #id)();
  TextColumn get stepId => text().named('step_id')();
  TextColumn get status => text()();
  DateTimeColumn get startTime => dateTime().named('start_time')();
  DateTimeColumn get endTime => dateTime().named('end_time').nullable()();
  TextColumn get command => text().nullable()();
  TextColumn get output => text().nullable()();
  TextColumn get errors => text().nullable()();
  IntColumn get exitCode => integer().named('exit_code').nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DiscoveredAssetRow')
class DiscoveredAssetsTable extends Table {
  @override
  String get tableName => 'discovered_assets';
  
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get executionId => text().named('execution_id').references(MethodologyExecutionsTable, #id).nullable()();
  TextColumn get type => text()();
  TextColumn get value => text()();
  TextColumn get source => text()();
  RealColumn get confidence => real()();
  DateTimeColumn get discoveredAt => dateTime().named('discovered_at')();
  TextColumn get metadata => text().nullable()(); // JSON
  BoolColumn get isVerified => boolean().named('is_verified').withDefault(const Constant(false))();
  TextColumn get tags => text().withDefault(const Constant(''))();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MethodologyRecommendationRow')
class MethodologyRecommendationsTable extends Table {
  @override
  String get tableName => 'methodology_recommendations';
  
  TextColumn get id => text()();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get methodologyId => text().named('methodology_id')();
  TextColumn get category => text()();
  TextColumn get riskLevel => text().named('risk_level')();
  TextColumn get reason => text()();
  TextColumn get triggerAssetId => text().named('trigger_asset_id').references(DiscoveredAssetsTable, #id).nullable()();
  RealColumn get confidence => real()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  BoolColumn get isDismissed => boolean().named('is_dismissed').withDefault(const Constant(false))();
  BoolColumn get isSuppressed => boolean().named('is_suppressed').withDefault(const Constant(false))();
  TextColumn get suppressionReason => text().named('suppression_reason').nullable()();
  TextColumn get context => text().nullable()(); // JSON
  
  @override
  Set<Column> get primaryKey => {id};
}