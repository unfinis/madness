import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../models/finding.dart';
import '../models/finding_template.dart';

part 'finding_database.g.dart';

/// Table for storing findings
class Findings extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get severity => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get cvssScore => text().nullable()();
  TextColumn get cweId => text().nullable()();
  TextColumn get affectedSystems => text().nullable()();
  TextColumn get remediation => text().nullable()();
  TextColumn get references => text().nullable()();
  TextColumn get templateId => text().nullable()();
  TextColumn get masterFindingId => text().nullable()();
  TextColumn get subFindingIdsJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get customFieldsJson =>
      text().withDefault(const Constant('{}'))();
  TextColumn get imageIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get variablesJson => text().withDefault(const Constant('{}'))();
  TextColumn get status => text().withDefault(const Constant('draft'))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table for storing finding templates
class FindingTemplates extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get descriptionTemplate => text()();
  TextColumn get remediationTemplate => text()();
  TextColumn get defaultSeverity => text().nullable()();
  TextColumn get defaultCvssScore => text().nullable()();
  TextColumn get defaultCweId => text().nullable()();
  TextColumn get variablesJson => text().withDefault(const Constant('[]'))();
  TextColumn get customFieldsJson =>
      text().withDefault(const Constant('[]'))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Table for storing finding images/attachments
class FindingImages extends Table {
  TextColumn get id => text()();
  TextColumn get findingId => text()();
  TextColumn get filename => text()();
  TextColumn get mimeType => text()();
  BlobColumn get data => blob()();
  DateTimeColumn get uploadedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Findings, FindingTemplates, FindingImages])
class FindingDatabase extends _$FindingDatabase {
  FindingDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'findings_db');
  }

  // Finding CRUD operations
  Future<List<FindingData>> getAllFindings() => select(findings).get();

  Future<FindingData?> getFindingById(String id) =>
      (select(findings)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<List<FindingData>> getMasterFindings() => (select(findings)
        ..where((tbl) => tbl.masterFindingId.isNull()))
      .get();

  Future<List<FindingData>> getSubFindings(String masterFindingId) =>
      (select(findings)
            ..where((tbl) => tbl.masterFindingId.equals(masterFindingId)))
          .get();

  Future<int> insertFinding(FindingsCompanion finding) =>
      into(findings).insert(finding);

  Future<bool> updateFinding(FindingsCompanion finding) =>
      update(findings).replace(finding);

  Future<int> deleteFinding(String id) =>
      (delete(findings)..where((tbl) => tbl.id.equals(id))).go();

  // Template CRUD operations
  Future<List<FindingTemplateData>> getAllTemplates() =>
      select(findingTemplates).get();

  Future<FindingTemplateData?> getTemplateById(String id) =>
      (select(findingTemplates)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<List<FindingTemplateData>> getTemplatesByCategory(String category) =>
      (select(findingTemplates)..where((tbl) => tbl.category.equals(category)))
          .get();

  Future<int> insertTemplate(FindingTemplatesCompanion template) =>
      into(findingTemplates).insert(template);

  Future<bool> updateTemplate(FindingTemplatesCompanion template) =>
      update(findingTemplates).replace(template);

  Future<int> deleteTemplate(String id) =>
      (delete(findingTemplates)..where((tbl) => tbl.id.equals(id))).go();

  // Image operations
  Future<List<FindingImageData>> getImagesForFinding(String findingId) =>
      (select(findingImages)..where((tbl) => tbl.findingId.equals(findingId)))
          .get();

  Future<FindingImageData?> getImageById(String id) =>
      (select(findingImages)..where((tbl) => tbl.id.equals(id)))
          .getSingleOrNull();

  Future<int> insertImage(FindingImagesCompanion image) =>
      into(findingImages).insert(image);

  Future<int> deleteImage(String id) =>
      (delete(findingImages)..where((tbl) => tbl.id.equals(id))).go();
}

// Extension methods to convert between Drift data and domain models
extension FindingDataX on FindingData {
  Finding toDomain() {
    return Finding(
      id: id,
      title: title,
      description: description,
      severity: FindingSeverity.values.firstWhere(
        (e) => e.name == severity,
        orElse: () => FindingSeverity.informational,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
      cvssScore: cvssScore,
      cweId: cweId,
      affectedSystems: affectedSystems,
      remediation: remediation,
      references: references,
      templateId: templateId,
      masterFindingId: masterFindingId,
      subFindingIds: (jsonDecode(subFindingIdsJson) as List)
          .map((e) => e.toString())
          .toList(),
      customFields: jsonDecode(customFieldsJson) as Map<String, dynamic>,
      imageIds:
          (jsonDecode(imageIdsJson) as List).map((e) => e.toString()).toList(),
      variables: Map<String, String>.from(jsonDecode(variablesJson) as Map),
      status: FindingStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => FindingStatus.draft,
      ),
    );
  }
}

extension FindingX on Finding {
  FindingsCompanion toCompanion() {
    return FindingsCompanion.insert(
      id: id,
      title: title,
      description: description,
      severity: severity.name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      cvssScore: Value(cvssScore),
      cweId: Value(cweId),
      affectedSystems: Value(affectedSystems),
      remediation: Value(remediation),
      references: Value(references),
      templateId: Value(templateId),
      masterFindingId: Value(masterFindingId),
      subFindingIdsJson: Value(jsonEncode(subFindingIds)),
      customFieldsJson: Value(jsonEncode(customFields)),
      imageIdsJson: Value(jsonEncode(imageIds)),
      variablesJson: Value(jsonEncode(variables)),
      status: Value(status.name),
    );
  }
}

extension FindingTemplateDataX on FindingTemplateData {
  FindingTemplate toDomain() {
    return FindingTemplate(
      id: id,
      name: name,
      category: category,
      descriptionTemplate: descriptionTemplate,
      remediationTemplate: remediationTemplate,
      defaultSeverity: defaultSeverity,
      defaultCvssScore: defaultCvssScore,
      defaultCweId: defaultCweId,
      variables: (jsonDecode(variablesJson) as List)
          .map((e) => TemplateVariable.fromJson(e as Map<String, dynamic>))
          .toList(),
      customFields: (jsonDecode(customFieldsJson) as List)
          .map((e) => CustomField.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCustom: isCustom,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension FindingTemplateX on FindingTemplate {
  FindingTemplatesCompanion toCompanion() {
    return FindingTemplatesCompanion.insert(
      id: id,
      name: name,
      category: category,
      descriptionTemplate: descriptionTemplate,
      remediationTemplate: remediationTemplate,
      defaultSeverity: Value(defaultSeverity),
      defaultCvssScore: Value(defaultCvssScore),
      defaultCweId: Value(defaultCweId),
      variablesJson: Value(jsonEncode(variables.map((e) => e.toJson()).toList())),
      customFieldsJson: Value(jsonEncode(customFields.map((e) => e.toJson()).toList())),
      isCustom: Value(isCustom),
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
