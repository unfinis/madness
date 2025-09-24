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
  BoolColumn get isPlaceholder => boolean().named('is_placeholder').withDefault(const Constant(false))();
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


// Assets table for hierarchical object-oriented asset system
@DataClassName('AssetRow')
class AssetsTable extends Table {
  @override
  String get tableName => 'assets';

  TextColumn get id => text()();
  TextColumn get type => text()(); // AssetType enum as string
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();

  // Rich property system - stored as JSON
  TextColumn get properties => text()(); // Map<String, AssetPropertyValue> as JSON

  // Discovery and status
  TextColumn get discoveryStatus => text().named('discovery_status')(); // AssetDiscoveryStatus enum
  DateTimeColumn get discoveredAt => dateTime().named('discovered_at')();
  DateTimeColumn get lastUpdated => dateTime().named('last_updated').nullable()();
  TextColumn get discoveryMethod => text().named('discovery_method').nullable()();
  RealColumn get confidence => real().withDefault(const Constant(1.0))();

  // Hierarchical relationships - stored as JSON arrays
  TextColumn get parentAssetIds => text().named('parent_asset_ids')(); // List<String> as JSON
  TextColumn get childAssetIds => text().named('child_asset_ids')(); // List<String> as JSON
  TextColumn get relatedAssetIds => text().named('related_asset_ids')(); // List<String> as JSON

  // Methodology integration
  TextColumn get completedTriggers => text().named('completed_triggers')(); // List<String> as JSON
  TextColumn get triggerResults => text().named('trigger_results')(); // Map<String, TriggerExecutionResult> as JSON

  // Organization and filtering
  TextColumn get tags => text()(); // List<String> as JSON
  TextColumn get metadata => text().nullable()(); // Map<String, String> as JSON

  // Security context
  TextColumn get accessLevel => text().named('access_level').nullable()(); // AccessLevel enum as string
  TextColumn get securityControls => text().named('security_controls').nullable()(); // List<String> as JSON

  @override
  Set<Column> get primaryKey => {id};
}

// Asset relationships table for efficient querying of hierarchical relationships
@DataClassName('AssetRelationshipRow')
class AssetRelationshipsTable extends Table {
  @override
  String get tableName => 'asset_relationships';

  TextColumn get parentAssetId => text().named('parent_asset_id').references(AssetsTable, #id)();
  TextColumn get childAssetId => text().named('child_asset_id').references(AssetsTable, #id)();
  TextColumn get relationshipType => text().named('relationship_type')(); // "parent", "child", "related"
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  TextColumn get metadata => text().nullable()(); // Additional relationship metadata as JSON

  @override
  Set<Column> get primaryKey => {parentAssetId, childAssetId, relationshipType};
}

// Asset property index for efficient property-based searches
@DataClassName('AssetPropertyIndexRow')
class AssetPropertyIndexTable extends Table {
  @override
  String get tableName => 'asset_property_index';

  TextColumn get assetId => text().named('asset_id').references(AssetsTable, #id)();
  TextColumn get propertyKey => text().named('property_key')();
  TextColumn get propertyValue => text().named('property_value')(); // String representation for indexing
  TextColumn get propertyType => text().named('property_type')(); // "string", "integer", "boolean", etc.
  DateTimeColumn get indexedAt => dateTime().named('indexed_at')();

  @override
  Set<Column> get primaryKey => {assetId, propertyKey};
}

// ===== PHASE 1.1: METHODOLOGY ENGINE TABLES =====

// Run instances for methodology execution tracking
@DataClassName('RunInstanceRow')
class RunInstancesTable extends Table {
  @override
  String get tableName => 'run_instances';

  TextColumn get runId => text().named('run_id')();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();
  TextColumn get templateId => text().named('template_id')();
  TextColumn get templateVersion => text().named('template_version')();
  TextColumn get triggerId => text().named('trigger_id')();
  TextColumn get assetId => text().named('asset_id').references(AssetsTable, #id)();

  // JSON stored data
  TextColumn get matchedValues => text().named('matched_values')(); // Map<String, dynamic> as JSON
  TextColumn get parameters => text()(); // Map<String, dynamic> as JSON

  // Status and metadata
  TextColumn get status => text()(); // RunInstanceStatus enum as string
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  TextColumn get createdBy => text().named('created_by')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();

  // Evidence and findings - JSON arrays of IDs
  TextColumn get evidenceIds => text().named('evidence_ids')(); // List<String> as JSON
  TextColumn get findingIds => text().named('finding_ids')(); // List<String> as JSON

  // Additional fields
  TextColumn get notes => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(5))();
  TextColumn get tags => text().withDefault(const Constant('[]'))(); // List<String> as JSON

  @override
  Set<Column> get primaryKey => {runId};
}

// History entries for audit trail
@DataClassName('HistoryEntryRow')
class HistoryEntriesTable extends Table {
  @override
  String get tableName => 'history_entries';

  TextColumn get id => text()();
  TextColumn get runId => text().named('run_id').references(RunInstancesTable, #runId)();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get performedBy => text().named('performed_by')();
  TextColumn get action => text()(); // HistoryActionType enum as string
  TextColumn get description => text()();
  TextColumn get previousValue => text().named('previous_value').nullable()();
  TextColumn get newValue => text().named('new_value').nullable()();
  TextColumn get metadata => text().withDefault(const Constant('{}'))(); // Map<String, dynamic> as JSON

  @override
  Set<Column> get primaryKey => {id};
}

// Trigger evaluation results
@DataClassName('TriggerMatchRow')
class TriggerMatchesTable extends Table {
  @override
  String get tableName => 'trigger_matches';

  TextColumn get id => text()();
  TextColumn get triggerId => text().named('trigger_id')();
  TextColumn get templateId => text().named('template_id')();
  TextColumn get assetId => text().named('asset_id').references(AssetsTable, #id)();
  TextColumn get projectId => text().named('project_id').references(ProjectsTable, #id)();

  BoolColumn get matched => boolean()();
  TextColumn get extractedValues => text().named('extracted_values')(); // Map<String, dynamic> as JSON
  RealColumn get confidence => real().withDefault(const Constant(1.0))();
  DateTimeColumn get evaluatedAt => dateTime().named('evaluated_at')();
  IntColumn get priority => integer().withDefault(const Constant(5))();

  TextColumn get error => text().nullable()();
  TextColumn get debugInfo => text().named('debug_info').withDefault(const Constant('{}'))(); // Map<String, dynamic> as JSON

  @override
  Set<Column> get primaryKey => {id};
}

// Parameter resolution tracking
@DataClassName('ParameterResolutionRow')
class ParameterResolutionsTable extends Table {
  @override
  String get tableName => 'parameter_resolutions';

  TextColumn get id => text()();
  TextColumn get runId => text().named('run_id').references(RunInstancesTable, #runId)();
  TextColumn get name => text()();
  TextColumn get type => text()(); // ParameterType enum as string
  TextColumn get value => text()(); // Dynamic value as JSON string
  TextColumn get source => text()(); // ParameterSource enum as string

  BoolColumn get required => boolean().withDefault(const Constant(false))();
  BoolColumn get resolved => boolean().withDefault(const Constant(true))();
  TextColumn get error => text().nullable()();
  DateTimeColumn get resolvedAt => dateTime().named('resolved_at')();
  TextColumn get metadata => text().withDefault(const Constant('{}'))(); // Map<String, dynamic> as JSON

  @override
  Set<Column> get primaryKey => {id};
}

// Methodology templates stored in database (instead of JSON assets)
@DataClassName('MethodologyTemplateRow')
class MethodologyTemplatesTable extends Table {
  @override
  String get tableName => 'methodology_templates';

  TextColumn get id => text()();
  TextColumn get version => text()();
  TextColumn get templateVersion => text().named('template_version')();
  TextColumn get name => text()();
  TextColumn get workstream => text()();
  TextColumn get author => text()();
  DateTimeColumn get created => dateTime()();
  DateTimeColumn get modified => dateTime()();
  TextColumn get status => text()();
  TextColumn get description => text()();
  TextColumn get tags => text()(); // List<String> as JSON
  TextColumn get riskLevel => text().named('risk_level')();

  // Template content stored as JSON
  TextColumn get overview => text()(); // MethodologyOverview as JSON
  TextColumn get triggers => text()(); // List<MethodologyTrigger> as JSON
  TextColumn get equipment => text()(); // List<String> as JSON
  TextColumn get procedures => text()(); // List<MethodologyProcedure> as JSON
  TextColumn get findings => text()(); // List<MethodologyFinding> as JSON
  TextColumn get cleanup => text()(); // List<MethodologyCleanup> as JSON
  TextColumn get troubleshooting => text()(); // List<MethodologyTroubleshooting> as JSON

  @override
  Set<Column> get primaryKey => {id};
}