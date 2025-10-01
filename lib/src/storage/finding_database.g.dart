// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finding_database.dart';

// ignore_for_file: type=lint
class $FindingsTable extends Findings with TableInfo<$FindingsTable, Finding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cvssScoreMeta = const VerificationMeta(
    'cvssScore',
  );
  @override
  late final GeneratedColumn<String> cvssScore = GeneratedColumn<String>(
    'cvss_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cweIdMeta = const VerificationMeta('cweId');
  @override
  late final GeneratedColumn<String> cweId = GeneratedColumn<String>(
    'cwe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _affectedSystemsMeta = const VerificationMeta(
    'affectedSystems',
  );
  @override
  late final GeneratedColumn<String> affectedSystems = GeneratedColumn<String>(
    'affected_systems',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remediationMeta = const VerificationMeta(
    'remediation',
  );
  @override
  late final GeneratedColumn<String> remediation = GeneratedColumn<String>(
    'remediation',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referencesMeta = const VerificationMeta(
    'references',
  );
  @override
  late final GeneratedColumn<String> references = GeneratedColumn<String>(
    'references',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _masterFindingIdMeta = const VerificationMeta(
    'masterFindingId',
  );
  @override
  late final GeneratedColumn<String> masterFindingId = GeneratedColumn<String>(
    'master_finding_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _subFindingIdsJsonMeta = const VerificationMeta(
    'subFindingIdsJson',
  );
  @override
  late final GeneratedColumn<String> subFindingIdsJson =
      GeneratedColumn<String>(
        'sub_finding_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _customFieldsJsonMeta = const VerificationMeta(
    'customFieldsJson',
  );
  @override
  late final GeneratedColumn<String> customFieldsJson = GeneratedColumn<String>(
    'custom_fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _imageIdsJsonMeta = const VerificationMeta(
    'imageIdsJson',
  );
  @override
  late final GeneratedColumn<String> imageIdsJson = GeneratedColumn<String>(
    'image_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _variablesJsonMeta = const VerificationMeta(
    'variablesJson',
  );
  @override
  late final GeneratedColumn<String> variablesJson = GeneratedColumn<String>(
    'variables_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('draft'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    severity,
    createdAt,
    updatedAt,
    cvssScore,
    cweId,
    affectedSystems,
    remediation,
    references,
    templateId,
    masterFindingId,
    subFindingIdsJson,
    customFieldsJson,
    imageIdsJson,
    variablesJson,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'findings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Finding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('cvss_score')) {
      context.handle(
        _cvssScoreMeta,
        cvssScore.isAcceptableOrUnknown(data['cvss_score']!, _cvssScoreMeta),
      );
    }
    if (data.containsKey('cwe_id')) {
      context.handle(
        _cweIdMeta,
        cweId.isAcceptableOrUnknown(data['cwe_id']!, _cweIdMeta),
      );
    }
    if (data.containsKey('affected_systems')) {
      context.handle(
        _affectedSystemsMeta,
        affectedSystems.isAcceptableOrUnknown(
          data['affected_systems']!,
          _affectedSystemsMeta,
        ),
      );
    }
    if (data.containsKey('remediation')) {
      context.handle(
        _remediationMeta,
        remediation.isAcceptableOrUnknown(
          data['remediation']!,
          _remediationMeta,
        ),
      );
    }
    if (data.containsKey('references')) {
      context.handle(
        _referencesMeta,
        references.isAcceptableOrUnknown(data['references']!, _referencesMeta),
      );
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    }
    if (data.containsKey('master_finding_id')) {
      context.handle(
        _masterFindingIdMeta,
        masterFindingId.isAcceptableOrUnknown(
          data['master_finding_id']!,
          _masterFindingIdMeta,
        ),
      );
    }
    if (data.containsKey('sub_finding_ids_json')) {
      context.handle(
        _subFindingIdsJsonMeta,
        subFindingIdsJson.isAcceptableOrUnknown(
          data['sub_finding_ids_json']!,
          _subFindingIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('custom_fields_json')) {
      context.handle(
        _customFieldsJsonMeta,
        customFieldsJson.isAcceptableOrUnknown(
          data['custom_fields_json']!,
          _customFieldsJsonMeta,
        ),
      );
    }
    if (data.containsKey('image_ids_json')) {
      context.handle(
        _imageIdsJsonMeta,
        imageIdsJson.isAcceptableOrUnknown(
          data['image_ids_json']!,
          _imageIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('variables_json')) {
      context.handle(
        _variablesJsonMeta,
        variablesJson.isAcceptableOrUnknown(
          data['variables_json']!,
          _variablesJsonMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Finding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Finding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      cvssScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cvss_score'],
      ),
      cweId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cwe_id'],
      ),
      affectedSystems: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}affected_systems'],
      ),
      remediation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remediation'],
      ),
      references: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}references'],
      ),
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      ),
      masterFindingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}master_finding_id'],
      ),
      subFindingIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_finding_ids_json'],
      )!,
      customFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_fields_json'],
      )!,
      imageIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_ids_json'],
      )!,
      variablesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variables_json'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
    );
  }

  @override
  $FindingsTable createAlias(String alias) {
    return $FindingsTable(attachedDatabase, alias);
  }
}

class Finding extends DataClass implements Insertable<Finding> {
  final String id;
  final String title;
  final String description;
  final String severity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cvssScore;
  final String? cweId;
  final String? affectedSystems;
  final String? remediation;
  final String? references;
  final String? templateId;
  final String? masterFindingId;
  final String subFindingIdsJson;
  final String customFieldsJson;
  final String imageIdsJson;
  final String variablesJson;
  final String status;
  const Finding({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.createdAt,
    required this.updatedAt,
    this.cvssScore,
    this.cweId,
    this.affectedSystems,
    this.remediation,
    this.references,
    this.templateId,
    this.masterFindingId,
    required this.subFindingIdsJson,
    required this.customFieldsJson,
    required this.imageIdsJson,
    required this.variablesJson,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['severity'] = Variable<String>(severity);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || cvssScore != null) {
      map['cvss_score'] = Variable<String>(cvssScore);
    }
    if (!nullToAbsent || cweId != null) {
      map['cwe_id'] = Variable<String>(cweId);
    }
    if (!nullToAbsent || affectedSystems != null) {
      map['affected_systems'] = Variable<String>(affectedSystems);
    }
    if (!nullToAbsent || remediation != null) {
      map['remediation'] = Variable<String>(remediation);
    }
    if (!nullToAbsent || references != null) {
      map['references'] = Variable<String>(references);
    }
    if (!nullToAbsent || templateId != null) {
      map['template_id'] = Variable<String>(templateId);
    }
    if (!nullToAbsent || masterFindingId != null) {
      map['master_finding_id'] = Variable<String>(masterFindingId);
    }
    map['sub_finding_ids_json'] = Variable<String>(subFindingIdsJson);
    map['custom_fields_json'] = Variable<String>(customFieldsJson);
    map['image_ids_json'] = Variable<String>(imageIdsJson);
    map['variables_json'] = Variable<String>(variablesJson);
    map['status'] = Variable<String>(status);
    return map;
  }

  FindingsCompanion toCompanion(bool nullToAbsent) {
    return FindingsCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      severity: Value(severity),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      cvssScore: cvssScore == null && nullToAbsent
          ? const Value.absent()
          : Value(cvssScore),
      cweId: cweId == null && nullToAbsent
          ? const Value.absent()
          : Value(cweId),
      affectedSystems: affectedSystems == null && nullToAbsent
          ? const Value.absent()
          : Value(affectedSystems),
      remediation: remediation == null && nullToAbsent
          ? const Value.absent()
          : Value(remediation),
      references: references == null && nullToAbsent
          ? const Value.absent()
          : Value(references),
      templateId: templateId == null && nullToAbsent
          ? const Value.absent()
          : Value(templateId),
      masterFindingId: masterFindingId == null && nullToAbsent
          ? const Value.absent()
          : Value(masterFindingId),
      subFindingIdsJson: Value(subFindingIdsJson),
      customFieldsJson: Value(customFieldsJson),
      imageIdsJson: Value(imageIdsJson),
      variablesJson: Value(variablesJson),
      status: Value(status),
    );
  }

  factory Finding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Finding(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      severity: serializer.fromJson<String>(json['severity']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      cvssScore: serializer.fromJson<String?>(json['cvssScore']),
      cweId: serializer.fromJson<String?>(json['cweId']),
      affectedSystems: serializer.fromJson<String?>(json['affectedSystems']),
      remediation: serializer.fromJson<String?>(json['remediation']),
      references: serializer.fromJson<String?>(json['references']),
      templateId: serializer.fromJson<String?>(json['templateId']),
      masterFindingId: serializer.fromJson<String?>(json['masterFindingId']),
      subFindingIdsJson: serializer.fromJson<String>(json['subFindingIdsJson']),
      customFieldsJson: serializer.fromJson<String>(json['customFieldsJson']),
      imageIdsJson: serializer.fromJson<String>(json['imageIdsJson']),
      variablesJson: serializer.fromJson<String>(json['variablesJson']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'severity': serializer.toJson<String>(severity),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'cvssScore': serializer.toJson<String?>(cvssScore),
      'cweId': serializer.toJson<String?>(cweId),
      'affectedSystems': serializer.toJson<String?>(affectedSystems),
      'remediation': serializer.toJson<String?>(remediation),
      'references': serializer.toJson<String?>(references),
      'templateId': serializer.toJson<String?>(templateId),
      'masterFindingId': serializer.toJson<String?>(masterFindingId),
      'subFindingIdsJson': serializer.toJson<String>(subFindingIdsJson),
      'customFieldsJson': serializer.toJson<String>(customFieldsJson),
      'imageIdsJson': serializer.toJson<String>(imageIdsJson),
      'variablesJson': serializer.toJson<String>(variablesJson),
      'status': serializer.toJson<String>(status),
    };
  }

  Finding copyWith({
    String? id,
    String? title,
    String? description,
    String? severity,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<String?> cvssScore = const Value.absent(),
    Value<String?> cweId = const Value.absent(),
    Value<String?> affectedSystems = const Value.absent(),
    Value<String?> remediation = const Value.absent(),
    Value<String?> references = const Value.absent(),
    Value<String?> templateId = const Value.absent(),
    Value<String?> masterFindingId = const Value.absent(),
    String? subFindingIdsJson,
    String? customFieldsJson,
    String? imageIdsJson,
    String? variablesJson,
    String? status,
  }) => Finding(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    severity: severity ?? this.severity,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    cvssScore: cvssScore.present ? cvssScore.value : this.cvssScore,
    cweId: cweId.present ? cweId.value : this.cweId,
    affectedSystems: affectedSystems.present
        ? affectedSystems.value
        : this.affectedSystems,
    remediation: remediation.present ? remediation.value : this.remediation,
    references: references.present ? references.value : this.references,
    templateId: templateId.present ? templateId.value : this.templateId,
    masterFindingId: masterFindingId.present
        ? masterFindingId.value
        : this.masterFindingId,
    subFindingIdsJson: subFindingIdsJson ?? this.subFindingIdsJson,
    customFieldsJson: customFieldsJson ?? this.customFieldsJson,
    imageIdsJson: imageIdsJson ?? this.imageIdsJson,
    variablesJson: variablesJson ?? this.variablesJson,
    status: status ?? this.status,
  );
  Finding copyWithCompanion(FindingsCompanion data) {
    return Finding(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      severity: data.severity.present ? data.severity.value : this.severity,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      cvssScore: data.cvssScore.present ? data.cvssScore.value : this.cvssScore,
      cweId: data.cweId.present ? data.cweId.value : this.cweId,
      affectedSystems: data.affectedSystems.present
          ? data.affectedSystems.value
          : this.affectedSystems,
      remediation: data.remediation.present
          ? data.remediation.value
          : this.remediation,
      references: data.references.present
          ? data.references.value
          : this.references,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      masterFindingId: data.masterFindingId.present
          ? data.masterFindingId.value
          : this.masterFindingId,
      subFindingIdsJson: data.subFindingIdsJson.present
          ? data.subFindingIdsJson.value
          : this.subFindingIdsJson,
      customFieldsJson: data.customFieldsJson.present
          ? data.customFieldsJson.value
          : this.customFieldsJson,
      imageIdsJson: data.imageIdsJson.present
          ? data.imageIdsJson.value
          : this.imageIdsJson,
      variablesJson: data.variablesJson.present
          ? data.variablesJson.value
          : this.variablesJson,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Finding(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cvssScore: $cvssScore, ')
          ..write('cweId: $cweId, ')
          ..write('affectedSystems: $affectedSystems, ')
          ..write('remediation: $remediation, ')
          ..write('references: $references, ')
          ..write('templateId: $templateId, ')
          ..write('masterFindingId: $masterFindingId, ')
          ..write('subFindingIdsJson: $subFindingIdsJson, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('imageIdsJson: $imageIdsJson, ')
          ..write('variablesJson: $variablesJson, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    severity,
    createdAt,
    updatedAt,
    cvssScore,
    cweId,
    affectedSystems,
    remediation,
    references,
    templateId,
    masterFindingId,
    subFindingIdsJson,
    customFieldsJson,
    imageIdsJson,
    variablesJson,
    status,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Finding &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.severity == this.severity &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.cvssScore == this.cvssScore &&
          other.cweId == this.cweId &&
          other.affectedSystems == this.affectedSystems &&
          other.remediation == this.remediation &&
          other.references == this.references &&
          other.templateId == this.templateId &&
          other.masterFindingId == this.masterFindingId &&
          other.subFindingIdsJson == this.subFindingIdsJson &&
          other.customFieldsJson == this.customFieldsJson &&
          other.imageIdsJson == this.imageIdsJson &&
          other.variablesJson == this.variablesJson &&
          other.status == this.status);
}

class FindingsCompanion extends UpdateCompanion<Finding> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> severity;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<String?> cvssScore;
  final Value<String?> cweId;
  final Value<String?> affectedSystems;
  final Value<String?> remediation;
  final Value<String?> references;
  final Value<String?> templateId;
  final Value<String?> masterFindingId;
  final Value<String> subFindingIdsJson;
  final Value<String> customFieldsJson;
  final Value<String> imageIdsJson;
  final Value<String> variablesJson;
  final Value<String> status;
  final Value<int> rowid;
  const FindingsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.severity = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.cvssScore = const Value.absent(),
    this.cweId = const Value.absent(),
    this.affectedSystems = const Value.absent(),
    this.remediation = const Value.absent(),
    this.references = const Value.absent(),
    this.templateId = const Value.absent(),
    this.masterFindingId = const Value.absent(),
    this.subFindingIdsJson = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.imageIdsJson = const Value.absent(),
    this.variablesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FindingsCompanion.insert({
    required String id,
    required String title,
    required String description,
    required String severity,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.cvssScore = const Value.absent(),
    this.cweId = const Value.absent(),
    this.affectedSystems = const Value.absent(),
    this.remediation = const Value.absent(),
    this.references = const Value.absent(),
    this.templateId = const Value.absent(),
    this.masterFindingId = const Value.absent(),
    this.subFindingIdsJson = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.imageIdsJson = const Value.absent(),
    this.variablesJson = const Value.absent(),
    this.status = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       description = Value(description),
       severity = Value(severity),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Finding> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? severity,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<String>? cvssScore,
    Expression<String>? cweId,
    Expression<String>? affectedSystems,
    Expression<String>? remediation,
    Expression<String>? references,
    Expression<String>? templateId,
    Expression<String>? masterFindingId,
    Expression<String>? subFindingIdsJson,
    Expression<String>? customFieldsJson,
    Expression<String>? imageIdsJson,
    Expression<String>? variablesJson,
    Expression<String>? status,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (severity != null) 'severity': severity,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (cvssScore != null) 'cvss_score': cvssScore,
      if (cweId != null) 'cwe_id': cweId,
      if (affectedSystems != null) 'affected_systems': affectedSystems,
      if (remediation != null) 'remediation': remediation,
      if (references != null) 'references': references,
      if (templateId != null) 'template_id': templateId,
      if (masterFindingId != null) 'master_finding_id': masterFindingId,
      if (subFindingIdsJson != null) 'sub_finding_ids_json': subFindingIdsJson,
      if (customFieldsJson != null) 'custom_fields_json': customFieldsJson,
      if (imageIdsJson != null) 'image_ids_json': imageIdsJson,
      if (variablesJson != null) 'variables_json': variablesJson,
      if (status != null) 'status': status,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FindingsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? severity,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<String?>? cvssScore,
    Value<String?>? cweId,
    Value<String?>? affectedSystems,
    Value<String?>? remediation,
    Value<String?>? references,
    Value<String?>? templateId,
    Value<String?>? masterFindingId,
    Value<String>? subFindingIdsJson,
    Value<String>? customFieldsJson,
    Value<String>? imageIdsJson,
    Value<String>? variablesJson,
    Value<String>? status,
    Value<int>? rowid,
  }) {
    return FindingsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cvssScore: cvssScore ?? this.cvssScore,
      cweId: cweId ?? this.cweId,
      affectedSystems: affectedSystems ?? this.affectedSystems,
      remediation: remediation ?? this.remediation,
      references: references ?? this.references,
      templateId: templateId ?? this.templateId,
      masterFindingId: masterFindingId ?? this.masterFindingId,
      subFindingIdsJson: subFindingIdsJson ?? this.subFindingIdsJson,
      customFieldsJson: customFieldsJson ?? this.customFieldsJson,
      imageIdsJson: imageIdsJson ?? this.imageIdsJson,
      variablesJson: variablesJson ?? this.variablesJson,
      status: status ?? this.status,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (cvssScore.present) {
      map['cvss_score'] = Variable<String>(cvssScore.value);
    }
    if (cweId.present) {
      map['cwe_id'] = Variable<String>(cweId.value);
    }
    if (affectedSystems.present) {
      map['affected_systems'] = Variable<String>(affectedSystems.value);
    }
    if (remediation.present) {
      map['remediation'] = Variable<String>(remediation.value);
    }
    if (references.present) {
      map['references'] = Variable<String>(references.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (masterFindingId.present) {
      map['master_finding_id'] = Variable<String>(masterFindingId.value);
    }
    if (subFindingIdsJson.present) {
      map['sub_finding_ids_json'] = Variable<String>(subFindingIdsJson.value);
    }
    if (customFieldsJson.present) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson.value);
    }
    if (imageIdsJson.present) {
      map['image_ids_json'] = Variable<String>(imageIdsJson.value);
    }
    if (variablesJson.present) {
      map['variables_json'] = Variable<String>(variablesJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('severity: $severity, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('cvssScore: $cvssScore, ')
          ..write('cweId: $cweId, ')
          ..write('affectedSystems: $affectedSystems, ')
          ..write('remediation: $remediation, ')
          ..write('references: $references, ')
          ..write('templateId: $templateId, ')
          ..write('masterFindingId: $masterFindingId, ')
          ..write('subFindingIdsJson: $subFindingIdsJson, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('imageIdsJson: $imageIdsJson, ')
          ..write('variablesJson: $variablesJson, ')
          ..write('status: $status, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FindingTemplatesTable extends FindingTemplates
    with TableInfo<$FindingTemplatesTable, FindingTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionTemplateMeta =
      const VerificationMeta('descriptionTemplate');
  @override
  late final GeneratedColumn<String> descriptionTemplate =
      GeneratedColumn<String>(
        'description_template',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _remediationTemplateMeta =
      const VerificationMeta('remediationTemplate');
  @override
  late final GeneratedColumn<String> remediationTemplate =
      GeneratedColumn<String>(
        'remediation_template',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _defaultSeverityMeta = const VerificationMeta(
    'defaultSeverity',
  );
  @override
  late final GeneratedColumn<String> defaultSeverity = GeneratedColumn<String>(
    'default_severity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultCvssScoreMeta = const VerificationMeta(
    'defaultCvssScore',
  );
  @override
  late final GeneratedColumn<String> defaultCvssScore = GeneratedColumn<String>(
    'default_cvss_score',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultCweIdMeta = const VerificationMeta(
    'defaultCweId',
  );
  @override
  late final GeneratedColumn<String> defaultCweId = GeneratedColumn<String>(
    'default_cwe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _variablesJsonMeta = const VerificationMeta(
    'variablesJson',
  );
  @override
  late final GeneratedColumn<String> variablesJson = GeneratedColumn<String>(
    'variables_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _customFieldsJsonMeta = const VerificationMeta(
    'customFieldsJson',
  );
  @override
  late final GeneratedColumn<String> customFieldsJson = GeneratedColumn<String>(
    'custom_fields_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    descriptionTemplate,
    remediationTemplate,
    defaultSeverity,
    defaultCvssScore,
    defaultCweId,
    variablesJson,
    customFieldsJson,
    isCustom,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finding_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<FindingTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('description_template')) {
      context.handle(
        _descriptionTemplateMeta,
        descriptionTemplate.isAcceptableOrUnknown(
          data['description_template']!,
          _descriptionTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionTemplateMeta);
    }
    if (data.containsKey('remediation_template')) {
      context.handle(
        _remediationTemplateMeta,
        remediationTemplate.isAcceptableOrUnknown(
          data['remediation_template']!,
          _remediationTemplateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remediationTemplateMeta);
    }
    if (data.containsKey('default_severity')) {
      context.handle(
        _defaultSeverityMeta,
        defaultSeverity.isAcceptableOrUnknown(
          data['default_severity']!,
          _defaultSeverityMeta,
        ),
      );
    }
    if (data.containsKey('default_cvss_score')) {
      context.handle(
        _defaultCvssScoreMeta,
        defaultCvssScore.isAcceptableOrUnknown(
          data['default_cvss_score']!,
          _defaultCvssScoreMeta,
        ),
      );
    }
    if (data.containsKey('default_cwe_id')) {
      context.handle(
        _defaultCweIdMeta,
        defaultCweId.isAcceptableOrUnknown(
          data['default_cwe_id']!,
          _defaultCweIdMeta,
        ),
      );
    }
    if (data.containsKey('variables_json')) {
      context.handle(
        _variablesJsonMeta,
        variablesJson.isAcceptableOrUnknown(
          data['variables_json']!,
          _variablesJsonMeta,
        ),
      );
    }
    if (data.containsKey('custom_fields_json')) {
      context.handle(
        _customFieldsJsonMeta,
        customFieldsJson.isAcceptableOrUnknown(
          data['custom_fields_json']!,
          _customFieldsJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FindingTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      descriptionTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_template'],
      )!,
      remediationTemplate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remediation_template'],
      )!,
      defaultSeverity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_severity'],
      ),
      defaultCvssScore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_cvss_score'],
      ),
      defaultCweId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_cwe_id'],
      ),
      variablesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variables_json'],
      )!,
      customFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_fields_json'],
      )!,
      isCustom: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_custom'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FindingTemplatesTable createAlias(String alias) {
    return $FindingTemplatesTable(attachedDatabase, alias);
  }
}

class FindingTemplate extends DataClass implements Insertable<FindingTemplate> {
  final String id;
  final String name;
  final String category;
  final String descriptionTemplate;
  final String remediationTemplate;
  final String? defaultSeverity;
  final String? defaultCvssScore;
  final String? defaultCweId;
  final String variablesJson;
  final String customFieldsJson;
  final bool isCustom;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FindingTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.descriptionTemplate,
    required this.remediationTemplate,
    this.defaultSeverity,
    this.defaultCvssScore,
    this.defaultCweId,
    required this.variablesJson,
    required this.customFieldsJson,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['description_template'] = Variable<String>(descriptionTemplate);
    map['remediation_template'] = Variable<String>(remediationTemplate);
    if (!nullToAbsent || defaultSeverity != null) {
      map['default_severity'] = Variable<String>(defaultSeverity);
    }
    if (!nullToAbsent || defaultCvssScore != null) {
      map['default_cvss_score'] = Variable<String>(defaultCvssScore);
    }
    if (!nullToAbsent || defaultCweId != null) {
      map['default_cwe_id'] = Variable<String>(defaultCweId);
    }
    map['variables_json'] = Variable<String>(variablesJson);
    map['custom_fields_json'] = Variable<String>(customFieldsJson);
    map['is_custom'] = Variable<bool>(isCustom);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FindingTemplatesCompanion toCompanion(bool nullToAbsent) {
    return FindingTemplatesCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      descriptionTemplate: Value(descriptionTemplate),
      remediationTemplate: Value(remediationTemplate),
      defaultSeverity: defaultSeverity == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultSeverity),
      defaultCvssScore: defaultCvssScore == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCvssScore),
      defaultCweId: defaultCweId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultCweId),
      variablesJson: Value(variablesJson),
      customFieldsJson: Value(customFieldsJson),
      isCustom: Value(isCustom),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FindingTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingTemplate(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      descriptionTemplate: serializer.fromJson<String>(
        json['descriptionTemplate'],
      ),
      remediationTemplate: serializer.fromJson<String>(
        json['remediationTemplate'],
      ),
      defaultSeverity: serializer.fromJson<String?>(json['defaultSeverity']),
      defaultCvssScore: serializer.fromJson<String?>(json['defaultCvssScore']),
      defaultCweId: serializer.fromJson<String?>(json['defaultCweId']),
      variablesJson: serializer.fromJson<String>(json['variablesJson']),
      customFieldsJson: serializer.fromJson<String>(json['customFieldsJson']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'descriptionTemplate': serializer.toJson<String>(descriptionTemplate),
      'remediationTemplate': serializer.toJson<String>(remediationTemplate),
      'defaultSeverity': serializer.toJson<String?>(defaultSeverity),
      'defaultCvssScore': serializer.toJson<String?>(defaultCvssScore),
      'defaultCweId': serializer.toJson<String?>(defaultCweId),
      'variablesJson': serializer.toJson<String>(variablesJson),
      'customFieldsJson': serializer.toJson<String>(customFieldsJson),
      'isCustom': serializer.toJson<bool>(isCustom),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FindingTemplate copyWith({
    String? id,
    String? name,
    String? category,
    String? descriptionTemplate,
    String? remediationTemplate,
    Value<String?> defaultSeverity = const Value.absent(),
    Value<String?> defaultCvssScore = const Value.absent(),
    Value<String?> defaultCweId = const Value.absent(),
    String? variablesJson,
    String? customFieldsJson,
    bool? isCustom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FindingTemplate(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    descriptionTemplate: descriptionTemplate ?? this.descriptionTemplate,
    remediationTemplate: remediationTemplate ?? this.remediationTemplate,
    defaultSeverity: defaultSeverity.present
        ? defaultSeverity.value
        : this.defaultSeverity,
    defaultCvssScore: defaultCvssScore.present
        ? defaultCvssScore.value
        : this.defaultCvssScore,
    defaultCweId: defaultCweId.present ? defaultCweId.value : this.defaultCweId,
    variablesJson: variablesJson ?? this.variablesJson,
    customFieldsJson: customFieldsJson ?? this.customFieldsJson,
    isCustom: isCustom ?? this.isCustom,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FindingTemplate copyWithCompanion(FindingTemplatesCompanion data) {
    return FindingTemplate(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      descriptionTemplate: data.descriptionTemplate.present
          ? data.descriptionTemplate.value
          : this.descriptionTemplate,
      remediationTemplate: data.remediationTemplate.present
          ? data.remediationTemplate.value
          : this.remediationTemplate,
      defaultSeverity: data.defaultSeverity.present
          ? data.defaultSeverity.value
          : this.defaultSeverity,
      defaultCvssScore: data.defaultCvssScore.present
          ? data.defaultCvssScore.value
          : this.defaultCvssScore,
      defaultCweId: data.defaultCweId.present
          ? data.defaultCweId.value
          : this.defaultCweId,
      variablesJson: data.variablesJson.present
          ? data.variablesJson.value
          : this.variablesJson,
      customFieldsJson: data.customFieldsJson.present
          ? data.customFieldsJson.value
          : this.customFieldsJson,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingTemplate(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('descriptionTemplate: $descriptionTemplate, ')
          ..write('remediationTemplate: $remediationTemplate, ')
          ..write('defaultSeverity: $defaultSeverity, ')
          ..write('defaultCvssScore: $defaultCvssScore, ')
          ..write('defaultCweId: $defaultCweId, ')
          ..write('variablesJson: $variablesJson, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('isCustom: $isCustom, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    descriptionTemplate,
    remediationTemplate,
    defaultSeverity,
    defaultCvssScore,
    defaultCweId,
    variablesJson,
    customFieldsJson,
    isCustom,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingTemplate &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.descriptionTemplate == this.descriptionTemplate &&
          other.remediationTemplate == this.remediationTemplate &&
          other.defaultSeverity == this.defaultSeverity &&
          other.defaultCvssScore == this.defaultCvssScore &&
          other.defaultCweId == this.defaultCweId &&
          other.variablesJson == this.variablesJson &&
          other.customFieldsJson == this.customFieldsJson &&
          other.isCustom == this.isCustom &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FindingTemplatesCompanion extends UpdateCompanion<FindingTemplate> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String> descriptionTemplate;
  final Value<String> remediationTemplate;
  final Value<String?> defaultSeverity;
  final Value<String?> defaultCvssScore;
  final Value<String?> defaultCweId;
  final Value<String> variablesJson;
  final Value<String> customFieldsJson;
  final Value<bool> isCustom;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FindingTemplatesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.descriptionTemplate = const Value.absent(),
    this.remediationTemplate = const Value.absent(),
    this.defaultSeverity = const Value.absent(),
    this.defaultCvssScore = const Value.absent(),
    this.defaultCweId = const Value.absent(),
    this.variablesJson = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.isCustom = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FindingTemplatesCompanion.insert({
    required String id,
    required String name,
    required String category,
    required String descriptionTemplate,
    required String remediationTemplate,
    this.defaultSeverity = const Value.absent(),
    this.defaultCvssScore = const Value.absent(),
    this.defaultCweId = const Value.absent(),
    this.variablesJson = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
    this.isCustom = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       descriptionTemplate = Value(descriptionTemplate),
       remediationTemplate = Value(remediationTemplate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FindingTemplate> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? descriptionTemplate,
    Expression<String>? remediationTemplate,
    Expression<String>? defaultSeverity,
    Expression<String>? defaultCvssScore,
    Expression<String>? defaultCweId,
    Expression<String>? variablesJson,
    Expression<String>? customFieldsJson,
    Expression<bool>? isCustom,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (descriptionTemplate != null)
        'description_template': descriptionTemplate,
      if (remediationTemplate != null)
        'remediation_template': remediationTemplate,
      if (defaultSeverity != null) 'default_severity': defaultSeverity,
      if (defaultCvssScore != null) 'default_cvss_score': defaultCvssScore,
      if (defaultCweId != null) 'default_cwe_id': defaultCweId,
      if (variablesJson != null) 'variables_json': variablesJson,
      if (customFieldsJson != null) 'custom_fields_json': customFieldsJson,
      if (isCustom != null) 'is_custom': isCustom,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FindingTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String>? descriptionTemplate,
    Value<String>? remediationTemplate,
    Value<String?>? defaultSeverity,
    Value<String?>? defaultCvssScore,
    Value<String?>? defaultCweId,
    Value<String>? variablesJson,
    Value<String>? customFieldsJson,
    Value<bool>? isCustom,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FindingTemplatesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      descriptionTemplate: descriptionTemplate ?? this.descriptionTemplate,
      remediationTemplate: remediationTemplate ?? this.remediationTemplate,
      defaultSeverity: defaultSeverity ?? this.defaultSeverity,
      defaultCvssScore: defaultCvssScore ?? this.defaultCvssScore,
      defaultCweId: defaultCweId ?? this.defaultCweId,
      variablesJson: variablesJson ?? this.variablesJson,
      customFieldsJson: customFieldsJson ?? this.customFieldsJson,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (descriptionTemplate.present) {
      map['description_template'] = Variable<String>(descriptionTemplate.value);
    }
    if (remediationTemplate.present) {
      map['remediation_template'] = Variable<String>(remediationTemplate.value);
    }
    if (defaultSeverity.present) {
      map['default_severity'] = Variable<String>(defaultSeverity.value);
    }
    if (defaultCvssScore.present) {
      map['default_cvss_score'] = Variable<String>(defaultCvssScore.value);
    }
    if (defaultCweId.present) {
      map['default_cwe_id'] = Variable<String>(defaultCweId.value);
    }
    if (variablesJson.present) {
      map['variables_json'] = Variable<String>(variablesJson.value);
    }
    if (customFieldsJson.present) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('descriptionTemplate: $descriptionTemplate, ')
          ..write('remediationTemplate: $remediationTemplate, ')
          ..write('defaultSeverity: $defaultSeverity, ')
          ..write('defaultCvssScore: $defaultCvssScore, ')
          ..write('defaultCweId: $defaultCweId, ')
          ..write('variablesJson: $variablesJson, ')
          ..write('customFieldsJson: $customFieldsJson, ')
          ..write('isCustom: $isCustom, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FindingImagesTable extends FindingImages
    with TableInfo<$FindingImagesTable, FindingImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FindingImagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _findingIdMeta = const VerificationMeta(
    'findingId',
  );
  @override
  late final GeneratedColumn<String> findingId = GeneratedColumn<String>(
    'finding_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<Uint8List> data = GeneratedColumn<Uint8List>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadedAtMeta = const VerificationMeta(
    'uploadedAt',
  );
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
    'uploaded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    findingId,
    filename,
    mimeType,
    data,
    uploadedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'finding_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<FindingImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('finding_id')) {
      context.handle(
        _findingIdMeta,
        findingId.isAcceptableOrUnknown(data['finding_id']!, _findingIdMeta),
      );
    } else if (isInserting) {
      context.missing(_findingIdMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mimeTypeMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
        _uploadedAtMeta,
        uploadedAt.isAcceptableOrUnknown(data['uploaded_at']!, _uploadedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_uploadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FindingImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FindingImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      findingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}finding_id'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}data'],
      )!,
      uploadedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}uploaded_at'],
      )!,
    );
  }

  @override
  $FindingImagesTable createAlias(String alias) {
    return $FindingImagesTable(attachedDatabase, alias);
  }
}

class FindingImage extends DataClass implements Insertable<FindingImage> {
  final String id;
  final String findingId;
  final String filename;
  final String mimeType;
  final Uint8List data;
  final DateTime uploadedAt;
  const FindingImage({
    required this.id,
    required this.findingId,
    required this.filename,
    required this.mimeType,
    required this.data,
    required this.uploadedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['finding_id'] = Variable<String>(findingId);
    map['filename'] = Variable<String>(filename);
    map['mime_type'] = Variable<String>(mimeType);
    map['data'] = Variable<Uint8List>(data);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    return map;
  }

  FindingImagesCompanion toCompanion(bool nullToAbsent) {
    return FindingImagesCompanion(
      id: Value(id),
      findingId: Value(findingId),
      filename: Value(filename),
      mimeType: Value(mimeType),
      data: Value(data),
      uploadedAt: Value(uploadedAt),
    );
  }

  factory FindingImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FindingImage(
      id: serializer.fromJson<String>(json['id']),
      findingId: serializer.fromJson<String>(json['findingId']),
      filename: serializer.fromJson<String>(json['filename']),
      mimeType: serializer.fromJson<String>(json['mimeType']),
      data: serializer.fromJson<Uint8List>(json['data']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'findingId': serializer.toJson<String>(findingId),
      'filename': serializer.toJson<String>(filename),
      'mimeType': serializer.toJson<String>(mimeType),
      'data': serializer.toJson<Uint8List>(data),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
    };
  }

  FindingImage copyWith({
    String? id,
    String? findingId,
    String? filename,
    String? mimeType,
    Uint8List? data,
    DateTime? uploadedAt,
  }) => FindingImage(
    id: id ?? this.id,
    findingId: findingId ?? this.findingId,
    filename: filename ?? this.filename,
    mimeType: mimeType ?? this.mimeType,
    data: data ?? this.data,
    uploadedAt: uploadedAt ?? this.uploadedAt,
  );
  FindingImage copyWithCompanion(FindingImagesCompanion data) {
    return FindingImage(
      id: data.id.present ? data.id.value : this.id,
      findingId: data.findingId.present ? data.findingId.value : this.findingId,
      filename: data.filename.present ? data.filename.value : this.filename,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      data: data.data.present ? data.data.value : this.data,
      uploadedAt: data.uploadedAt.present
          ? data.uploadedAt.value
          : this.uploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FindingImage(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('data: $data, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    findingId,
    filename,
    mimeType,
    $driftBlobEquality.hash(data),
    uploadedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FindingImage &&
          other.id == this.id &&
          other.findingId == this.findingId &&
          other.filename == this.filename &&
          other.mimeType == this.mimeType &&
          $driftBlobEquality.equals(other.data, this.data) &&
          other.uploadedAt == this.uploadedAt);
}

class FindingImagesCompanion extends UpdateCompanion<FindingImage> {
  final Value<String> id;
  final Value<String> findingId;
  final Value<String> filename;
  final Value<String> mimeType;
  final Value<Uint8List> data;
  final Value<DateTime> uploadedAt;
  final Value<int> rowid;
  const FindingImagesCompanion({
    this.id = const Value.absent(),
    this.findingId = const Value.absent(),
    this.filename = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.data = const Value.absent(),
    this.uploadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FindingImagesCompanion.insert({
    required String id,
    required String findingId,
    required String filename,
    required String mimeType,
    required Uint8List data,
    required DateTime uploadedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       findingId = Value(findingId),
       filename = Value(filename),
       mimeType = Value(mimeType),
       data = Value(data),
       uploadedAt = Value(uploadedAt);
  static Insertable<FindingImage> custom({
    Expression<String>? id,
    Expression<String>? findingId,
    Expression<String>? filename,
    Expression<String>? mimeType,
    Expression<Uint8List>? data,
    Expression<DateTime>? uploadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (findingId != null) 'finding_id': findingId,
      if (filename != null) 'filename': filename,
      if (mimeType != null) 'mime_type': mimeType,
      if (data != null) 'data': data,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FindingImagesCompanion copyWith({
    Value<String>? id,
    Value<String>? findingId,
    Value<String>? filename,
    Value<String>? mimeType,
    Value<Uint8List>? data,
    Value<DateTime>? uploadedAt,
    Value<int>? rowid,
  }) {
    return FindingImagesCompanion(
      id: id ?? this.id,
      findingId: findingId ?? this.findingId,
      filename: filename ?? this.filename,
      mimeType: mimeType ?? this.mimeType,
      data: data ?? this.data,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (findingId.present) {
      map['finding_id'] = Variable<String>(findingId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (data.present) {
      map['data'] = Variable<Uint8List>(data.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FindingImagesCompanion(')
          ..write('id: $id, ')
          ..write('findingId: $findingId, ')
          ..write('filename: $filename, ')
          ..write('mimeType: $mimeType, ')
          ..write('data: $data, ')
          ..write('uploadedAt: $uploadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FindingDatabase extends GeneratedDatabase {
  _$FindingDatabase(QueryExecutor e) : super(e);
  $FindingDatabaseManager get managers => $FindingDatabaseManager(this);
  late final $FindingsTable findings = $FindingsTable(this);
  late final $FindingTemplatesTable findingTemplates = $FindingTemplatesTable(
    this,
  );
  late final $FindingImagesTable findingImages = $FindingImagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    findings,
    findingTemplates,
    findingImages,
  ];
}

typedef $$FindingsTableCreateCompanionBuilder =
    FindingsCompanion Function({
      required String id,
      required String title,
      required String description,
      required String severity,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<String?> cvssScore,
      Value<String?> cweId,
      Value<String?> affectedSystems,
      Value<String?> remediation,
      Value<String?> references,
      Value<String?> templateId,
      Value<String?> masterFindingId,
      Value<String> subFindingIdsJson,
      Value<String> customFieldsJson,
      Value<String> imageIdsJson,
      Value<String> variablesJson,
      Value<String> status,
      Value<int> rowid,
    });
typedef $$FindingsTableUpdateCompanionBuilder =
    FindingsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> severity,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<String?> cvssScore,
      Value<String?> cweId,
      Value<String?> affectedSystems,
      Value<String?> remediation,
      Value<String?> references,
      Value<String?> templateId,
      Value<String?> masterFindingId,
      Value<String> subFindingIdsJson,
      Value<String> customFieldsJson,
      Value<String> imageIdsJson,
      Value<String> variablesJson,
      Value<String> status,
      Value<int> rowid,
    });

class $$FindingsTableFilterComposer
    extends Composer<_$FindingDatabase, $FindingsTable> {
  $$FindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cvssScore => $composableBuilder(
    column: $table.cvssScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cweId => $composableBuilder(
    column: $table.cweId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get affectedSystems => $composableBuilder(
    column: $table.affectedSystems,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remediation => $composableBuilder(
    column: $table.remediation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get references => $composableBuilder(
    column: $table.references,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get masterFindingId => $composableBuilder(
    column: $table.masterFindingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subFindingIdsJson => $composableBuilder(
    column: $table.subFindingIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageIdsJson => $composableBuilder(
    column: $table.imageIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variablesJson => $composableBuilder(
    column: $table.variablesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FindingsTableOrderingComposer
    extends Composer<_$FindingDatabase, $FindingsTable> {
  $$FindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cvssScore => $composableBuilder(
    column: $table.cvssScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cweId => $composableBuilder(
    column: $table.cweId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get affectedSystems => $composableBuilder(
    column: $table.affectedSystems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remediation => $composableBuilder(
    column: $table.remediation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get references => $composableBuilder(
    column: $table.references,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get masterFindingId => $composableBuilder(
    column: $table.masterFindingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subFindingIdsJson => $composableBuilder(
    column: $table.subFindingIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageIdsJson => $composableBuilder(
    column: $table.imageIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variablesJson => $composableBuilder(
    column: $table.variablesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FindingsTableAnnotationComposer
    extends Composer<_$FindingDatabase, $FindingsTable> {
  $$FindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get cvssScore =>
      $composableBuilder(column: $table.cvssScore, builder: (column) => column);

  GeneratedColumn<String> get cweId =>
      $composableBuilder(column: $table.cweId, builder: (column) => column);

  GeneratedColumn<String> get affectedSystems => $composableBuilder(
    column: $table.affectedSystems,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remediation => $composableBuilder(
    column: $table.remediation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get references => $composableBuilder(
    column: $table.references,
    builder: (column) => column,
  );

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get masterFindingId => $composableBuilder(
    column: $table.masterFindingId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subFindingIdsJson => $composableBuilder(
    column: $table.subFindingIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageIdsJson => $composableBuilder(
    column: $table.imageIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variablesJson => $composableBuilder(
    column: $table.variablesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$FindingsTableTableManager
    extends
        RootTableManager<
          _$FindingDatabase,
          $FindingsTable,
          Finding,
          $$FindingsTableFilterComposer,
          $$FindingsTableOrderingComposer,
          $$FindingsTableAnnotationComposer,
          $$FindingsTableCreateCompanionBuilder,
          $$FindingsTableUpdateCompanionBuilder,
          (Finding, BaseReferences<_$FindingDatabase, $FindingsTable, Finding>),
          Finding,
          PrefetchHooks Function()
        > {
  $$FindingsTableTableManager(_$FindingDatabase db, $FindingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String?> cvssScore = const Value.absent(),
                Value<String?> cweId = const Value.absent(),
                Value<String?> affectedSystems = const Value.absent(),
                Value<String?> remediation = const Value.absent(),
                Value<String?> references = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String?> masterFindingId = const Value.absent(),
                Value<String> subFindingIdsJson = const Value.absent(),
                Value<String> customFieldsJson = const Value.absent(),
                Value<String> imageIdsJson = const Value.absent(),
                Value<String> variablesJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FindingsCompanion(
                id: id,
                title: title,
                description: description,
                severity: severity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                cvssScore: cvssScore,
                cweId: cweId,
                affectedSystems: affectedSystems,
                remediation: remediation,
                references: references,
                templateId: templateId,
                masterFindingId: masterFindingId,
                subFindingIdsJson: subFindingIdsJson,
                customFieldsJson: customFieldsJson,
                imageIdsJson: imageIdsJson,
                variablesJson: variablesJson,
                status: status,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String description,
                required String severity,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<String?> cvssScore = const Value.absent(),
                Value<String?> cweId = const Value.absent(),
                Value<String?> affectedSystems = const Value.absent(),
                Value<String?> remediation = const Value.absent(),
                Value<String?> references = const Value.absent(),
                Value<String?> templateId = const Value.absent(),
                Value<String?> masterFindingId = const Value.absent(),
                Value<String> subFindingIdsJson = const Value.absent(),
                Value<String> customFieldsJson = const Value.absent(),
                Value<String> imageIdsJson = const Value.absent(),
                Value<String> variablesJson = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FindingsCompanion.insert(
                id: id,
                title: title,
                description: description,
                severity: severity,
                createdAt: createdAt,
                updatedAt: updatedAt,
                cvssScore: cvssScore,
                cweId: cweId,
                affectedSystems: affectedSystems,
                remediation: remediation,
                references: references,
                templateId: templateId,
                masterFindingId: masterFindingId,
                subFindingIdsJson: subFindingIdsJson,
                customFieldsJson: customFieldsJson,
                imageIdsJson: imageIdsJson,
                variablesJson: variablesJson,
                status: status,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$FindingDatabase,
      $FindingsTable,
      Finding,
      $$FindingsTableFilterComposer,
      $$FindingsTableOrderingComposer,
      $$FindingsTableAnnotationComposer,
      $$FindingsTableCreateCompanionBuilder,
      $$FindingsTableUpdateCompanionBuilder,
      (Finding, BaseReferences<_$FindingDatabase, $FindingsTable, Finding>),
      Finding,
      PrefetchHooks Function()
    >;
typedef $$FindingTemplatesTableCreateCompanionBuilder =
    FindingTemplatesCompanion Function({
      required String id,
      required String name,
      required String category,
      required String descriptionTemplate,
      required String remediationTemplate,
      Value<String?> defaultSeverity,
      Value<String?> defaultCvssScore,
      Value<String?> defaultCweId,
      Value<String> variablesJson,
      Value<String> customFieldsJson,
      Value<bool> isCustom,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FindingTemplatesTableUpdateCompanionBuilder =
    FindingTemplatesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<String> descriptionTemplate,
      Value<String> remediationTemplate,
      Value<String?> defaultSeverity,
      Value<String?> defaultCvssScore,
      Value<String?> defaultCweId,
      Value<String> variablesJson,
      Value<String> customFieldsJson,
      Value<bool> isCustom,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$FindingTemplatesTableFilterComposer
    extends Composer<_$FindingDatabase, $FindingTemplatesTable> {
  $$FindingTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionTemplate => $composableBuilder(
    column: $table.descriptionTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remediationTemplate => $composableBuilder(
    column: $table.remediationTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultSeverity => $composableBuilder(
    column: $table.defaultSeverity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultCvssScore => $composableBuilder(
    column: $table.defaultCvssScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultCweId => $composableBuilder(
    column: $table.defaultCweId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variablesJson => $composableBuilder(
    column: $table.variablesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FindingTemplatesTableOrderingComposer
    extends Composer<_$FindingDatabase, $FindingTemplatesTable> {
  $$FindingTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionTemplate => $composableBuilder(
    column: $table.descriptionTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remediationTemplate => $composableBuilder(
    column: $table.remediationTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultSeverity => $composableBuilder(
    column: $table.defaultSeverity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultCvssScore => $composableBuilder(
    column: $table.defaultCvssScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultCweId => $composableBuilder(
    column: $table.defaultCweId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variablesJson => $composableBuilder(
    column: $table.variablesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FindingTemplatesTableAnnotationComposer
    extends Composer<_$FindingDatabase, $FindingTemplatesTable> {
  $$FindingTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get descriptionTemplate => $composableBuilder(
    column: $table.descriptionTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remediationTemplate => $composableBuilder(
    column: $table.remediationTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultSeverity => $composableBuilder(
    column: $table.defaultSeverity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultCvssScore => $composableBuilder(
    column: $table.defaultCvssScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultCweId => $composableBuilder(
    column: $table.defaultCweId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variablesJson => $composableBuilder(
    column: $table.variablesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$FindingTemplatesTableTableManager
    extends
        RootTableManager<
          _$FindingDatabase,
          $FindingTemplatesTable,
          FindingTemplate,
          $$FindingTemplatesTableFilterComposer,
          $$FindingTemplatesTableOrderingComposer,
          $$FindingTemplatesTableAnnotationComposer,
          $$FindingTemplatesTableCreateCompanionBuilder,
          $$FindingTemplatesTableUpdateCompanionBuilder,
          (
            FindingTemplate,
            BaseReferences<
              _$FindingDatabase,
              $FindingTemplatesTable,
              FindingTemplate
            >,
          ),
          FindingTemplate,
          PrefetchHooks Function()
        > {
  $$FindingTemplatesTableTableManager(
    _$FindingDatabase db,
    $FindingTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingTemplatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingTemplatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> descriptionTemplate = const Value.absent(),
                Value<String> remediationTemplate = const Value.absent(),
                Value<String?> defaultSeverity = const Value.absent(),
                Value<String?> defaultCvssScore = const Value.absent(),
                Value<String?> defaultCweId = const Value.absent(),
                Value<String> variablesJson = const Value.absent(),
                Value<String> customFieldsJson = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FindingTemplatesCompanion(
                id: id,
                name: name,
                category: category,
                descriptionTemplate: descriptionTemplate,
                remediationTemplate: remediationTemplate,
                defaultSeverity: defaultSeverity,
                defaultCvssScore: defaultCvssScore,
                defaultCweId: defaultCweId,
                variablesJson: variablesJson,
                customFieldsJson: customFieldsJson,
                isCustom: isCustom,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required String descriptionTemplate,
                required String remediationTemplate,
                Value<String?> defaultSeverity = const Value.absent(),
                Value<String?> defaultCvssScore = const Value.absent(),
                Value<String?> defaultCweId = const Value.absent(),
                Value<String> variablesJson = const Value.absent(),
                Value<String> customFieldsJson = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FindingTemplatesCompanion.insert(
                id: id,
                name: name,
                category: category,
                descriptionTemplate: descriptionTemplate,
                remediationTemplate: remediationTemplate,
                defaultSeverity: defaultSeverity,
                defaultCvssScore: defaultCvssScore,
                defaultCweId: defaultCweId,
                variablesJson: variablesJson,
                customFieldsJson: customFieldsJson,
                isCustom: isCustom,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FindingTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$FindingDatabase,
      $FindingTemplatesTable,
      FindingTemplate,
      $$FindingTemplatesTableFilterComposer,
      $$FindingTemplatesTableOrderingComposer,
      $$FindingTemplatesTableAnnotationComposer,
      $$FindingTemplatesTableCreateCompanionBuilder,
      $$FindingTemplatesTableUpdateCompanionBuilder,
      (
        FindingTemplate,
        BaseReferences<
          _$FindingDatabase,
          $FindingTemplatesTable,
          FindingTemplate
        >,
      ),
      FindingTemplate,
      PrefetchHooks Function()
    >;
typedef $$FindingImagesTableCreateCompanionBuilder =
    FindingImagesCompanion Function({
      required String id,
      required String findingId,
      required String filename,
      required String mimeType,
      required Uint8List data,
      required DateTime uploadedAt,
      Value<int> rowid,
    });
typedef $$FindingImagesTableUpdateCompanionBuilder =
    FindingImagesCompanion Function({
      Value<String> id,
      Value<String> findingId,
      Value<String> filename,
      Value<String> mimeType,
      Value<Uint8List> data,
      Value<DateTime> uploadedAt,
      Value<int> rowid,
    });

class $$FindingImagesTableFilterComposer
    extends Composer<_$FindingDatabase, $FindingImagesTable> {
  $$FindingImagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get findingId => $composableBuilder(
    column: $table.findingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FindingImagesTableOrderingComposer
    extends Composer<_$FindingDatabase, $FindingImagesTable> {
  $$FindingImagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get findingId => $composableBuilder(
    column: $table.findingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FindingImagesTableAnnotationComposer
    extends Composer<_$FindingDatabase, $FindingImagesTable> {
  $$FindingImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get findingId =>
      $composableBuilder(column: $table.findingId, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<Uint8List> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
    column: $table.uploadedAt,
    builder: (column) => column,
  );
}

class $$FindingImagesTableTableManager
    extends
        RootTableManager<
          _$FindingDatabase,
          $FindingImagesTable,
          FindingImage,
          $$FindingImagesTableFilterComposer,
          $$FindingImagesTableOrderingComposer,
          $$FindingImagesTableAnnotationComposer,
          $$FindingImagesTableCreateCompanionBuilder,
          $$FindingImagesTableUpdateCompanionBuilder,
          (
            FindingImage,
            BaseReferences<
              _$FindingDatabase,
              $FindingImagesTable,
              FindingImage
            >,
          ),
          FindingImage,
          PrefetchHooks Function()
        > {
  $$FindingImagesTableTableManager(
    _$FindingDatabase db,
    $FindingImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FindingImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FindingImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FindingImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> findingId = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> mimeType = const Value.absent(),
                Value<Uint8List> data = const Value.absent(),
                Value<DateTime> uploadedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FindingImagesCompanion(
                id: id,
                findingId: findingId,
                filename: filename,
                mimeType: mimeType,
                data: data,
                uploadedAt: uploadedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String findingId,
                required String filename,
                required String mimeType,
                required Uint8List data,
                required DateTime uploadedAt,
                Value<int> rowid = const Value.absent(),
              }) => FindingImagesCompanion.insert(
                id: id,
                findingId: findingId,
                filename: filename,
                mimeType: mimeType,
                data: data,
                uploadedAt: uploadedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FindingImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$FindingDatabase,
      $FindingImagesTable,
      FindingImage,
      $$FindingImagesTableFilterComposer,
      $$FindingImagesTableOrderingComposer,
      $$FindingImagesTableAnnotationComposer,
      $$FindingImagesTableCreateCompanionBuilder,
      $$FindingImagesTableUpdateCompanionBuilder,
      (
        FindingImage,
        BaseReferences<_$FindingDatabase, $FindingImagesTable, FindingImage>,
      ),
      FindingImage,
      PrefetchHooks Function()
    >;

class $FindingDatabaseManager {
  final _$FindingDatabase _db;
  $FindingDatabaseManager(this._db);
  $$FindingsTableTableManager get findings =>
      $$FindingsTableTableManager(_db, _db.findings);
  $$FindingTemplatesTableTableManager get findingTemplates =>
      $$FindingTemplatesTableTableManager(_db, _db.findingTemplates);
  $$FindingImagesTableTableManager get findingImages =>
      $$FindingImagesTableTableManager(_db, _db.findingImages);
}
