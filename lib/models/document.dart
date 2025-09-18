
enum DocumentType {
  authorisationForms,
  statementOfWork,
  presalesNotes,
  scopingDocuments,
  technicalDocuments,
  other,
}

enum DocumentStatus {
  draft,
  inReview,
  approved,
  finalized,
  archived,
}

class Document {
  final String id;
  final String name;
  final String description;
  final DocumentType type;
  final DocumentStatus status;
  final String? filePath;
  final String? fileExtension;
  final int? fileSizeBytes;
  final Set<String> tags;
  final String? version;
  final String? author;
  final DateTime dateCreated;
  final DateTime dateModified;
  final DateTime? dateApproved;
  final String? approvedBy;
  final bool isTemplate;
  final bool isConfidential;
  final String? notes;
  final String? transferLink;
  final String? transferWorkspaceName;

  Document({
    String? id,
    required this.name,
    this.description = '',
    this.type = DocumentType.other,
    this.status = DocumentStatus.draft,
    this.filePath,
    this.fileExtension,
    this.fileSizeBytes,
    Set<String>? tags,
    this.version,
    this.author,
    DateTime? dateCreated,
    DateTime? dateModified,
    this.dateApproved,
    this.approvedBy,
    this.isTemplate = false,
    this.isConfidential = false,
    this.notes,
    this.transferLink,
    this.transferWorkspaceName,
  })  : id = id ?? 'doc_${DateTime.now().millisecondsSinceEpoch}',
        tags = tags ?? <String>{},
        dateCreated = dateCreated ?? DateTime.now(),
        dateModified = dateModified ?? DateTime.now();

  Document copyWith({
    String? name,
    String? description,
    DocumentType? type,
    DocumentStatus? status,
    String? filePath,
    String? fileExtension,
    int? fileSizeBytes,
    Set<String>? tags,
    String? version,
    String? author,
    DateTime? dateModified,
    DateTime? dateApproved,
    String? approvedBy,
    bool? isTemplate,
    bool? isConfidential,
    String? notes,
    String? transferLink,
    String? transferWorkspaceName,
  }) {
    return Document(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      filePath: filePath ?? this.filePath,
      fileExtension: fileExtension ?? this.fileExtension,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      tags: tags ?? this.tags,
      version: version ?? this.version,
      author: author ?? this.author,
      dateCreated: dateCreated,
      dateModified: dateModified ?? DateTime.now(),
      dateApproved: dateApproved ?? this.dateApproved,
      approvedBy: approvedBy ?? this.approvedBy,
      isTemplate: isTemplate ?? this.isTemplate,
      isConfidential: isConfidential ?? this.isConfidential,
      notes: notes ?? this.notes,
      transferLink: transferLink ?? this.transferLink,
      transferWorkspaceName: transferWorkspaceName ?? this.transferWorkspaceName,
    );
  }

  String get displaySize {
    if (fileSizeBytes == null) return 'Unknown';
    
    final bytes = fileSizeBytes!;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String get typeDisplayName {
    switch (type) {
      case DocumentType.authorisationForms:
        return 'Authorisation Forms';
      case DocumentType.statementOfWork:
        return 'Statement of Work';
      case DocumentType.presalesNotes:
        return 'Presales Notes';
      case DocumentType.scopingDocuments:
        return 'Scoping Documents';
      case DocumentType.technicalDocuments:
        return 'Technical Documents';
      case DocumentType.other:
        return 'Other';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case DocumentStatus.draft:
        return 'Draft';
      case DocumentStatus.inReview:
        return 'In Review';
      case DocumentStatus.approved:
        return 'Approved';
      case DocumentStatus.finalized:
        return 'Final';
      case DocumentStatus.archived:
        return 'Archived';
    }
  }

  bool get hasFile => filePath != null && filePath!.isNotEmpty;
  bool get hasTransferLink => transferLink != null && transferLink!.isNotEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Document{id: $id, name: $name, type: $typeDisplayName, status: $statusDisplayName}';
  }
}

extension DocumentTypeExtension on DocumentType {
  String get icon {
    switch (this) {
      case DocumentType.authorisationForms:
        return '📋';
      case DocumentType.statementOfWork:
        return '📊';
      case DocumentType.presalesNotes:
        return '📝';
      case DocumentType.scopingDocuments:
        return '🔍';
      case DocumentType.technicalDocuments:
        return '🛠️';
      case DocumentType.other:
        return '📄';
    }
  }
}

extension DocumentStatusExtension on DocumentStatus {
  String get icon {
    switch (this) {
      case DocumentStatus.draft:
        return '✏️';
      case DocumentStatus.inReview:
        return '👀';
      case DocumentStatus.approved:
        return '✅';
      case DocumentStatus.finalized:
        return '🔒';
      case DocumentStatus.archived:
        return '📦';
    }
  }
}