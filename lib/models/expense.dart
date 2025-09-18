enum ExpenseType {
  billable,
  personal,
}

enum ExpenseCategory {
  travel,
  accommodation,
  food,
  equipment,
  other,
}

class EvidenceFile {
  final String id;
  final String filePath;
  final String fileName;
  final EvidenceType type;
  final DateTime dateAdded;
  final int? fileSizeBytes;

  EvidenceFile({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.type,
    required this.dateAdded,
    this.fileSizeBytes,
  });

  EvidenceFile copyWith({
    String? id,
    String? filePath,
    String? fileName,
    EvidenceType? type,
    DateTime? dateAdded,
    int? fileSizeBytes,
  }) {
    return EvidenceFile(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      type: type ?? this.type,
      dateAdded: dateAdded ?? this.dateAdded,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
    );
  }
}

enum EvidenceType {
  receipt,
  photo,
  document,
  screenshot,
}

class Expense {
  final String id;
  final String description;
  final double amount;
  final ExpenseType type;
  final ExpenseCategory category;
  final DateTime date;
  final String? notes;
  final String? receiptPath; // Keep for backward compatibility
  final List<EvidenceFile> evidenceFiles;

  Expense({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.notes,
    this.receiptPath,
    this.evidenceFiles = const [],
  });

  bool get hasEvidence => evidenceFiles.isNotEmpty || receiptPath != null;

  Expense copyWith({
    String? id,
    String? description,
    double? amount,
    ExpenseType? type,
    ExpenseCategory? category,
    DateTime? date,
    String? notes,
    String? receiptPath,
    List<EvidenceFile>? evidenceFiles,
  }) {
    return Expense(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      notes: notes ?? this.notes,
      receiptPath: receiptPath ?? this.receiptPath,
      evidenceFiles: evidenceFiles ?? this.evidenceFiles,
    );
  }
}

extension ExpenseTypeExtension on ExpenseType {
  String get displayName {
    switch (this) {
      case ExpenseType.billable:
        return 'Billable';
      case ExpenseType.personal:
        return 'Personal';
    }
  }
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.travel:
        return 'Travel';
      case ExpenseCategory.accommodation:
        return 'Accommodation';
      case ExpenseCategory.food:
        return 'Food';
      case ExpenseCategory.equipment:
        return 'Equipment';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get icon {
    switch (this) {
      case ExpenseCategory.travel:
        return '🚗';
      case ExpenseCategory.accommodation:
        return '🏨';
      case ExpenseCategory.food:
        return '🍽️';
      case ExpenseCategory.equipment:
        return '💻';
      case ExpenseCategory.other:
        return '📦';
    }
  }
}

extension EvidenceTypeExtension on EvidenceType {
  String get displayName {
    switch (this) {
      case EvidenceType.receipt:
        return 'Receipt';
      case EvidenceType.photo:
        return 'Photo';
      case EvidenceType.document:
        return 'Document';
      case EvidenceType.screenshot:
        return 'Screenshot';
    }
  }

  String get icon {
    switch (this) {
      case EvidenceType.receipt:
        return '🧾';
      case EvidenceType.photo:
        return '📷';
      case EvidenceType.document:
        return '📄';
      case EvidenceType.screenshot:
        return '📸';
    }
  }
}