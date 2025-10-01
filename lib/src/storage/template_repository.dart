import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding_template.dart';
import 'finding_database.dart';
import 'finding_repository.dart';

/// Repository interface for template operations
abstract class TemplateRepository {
  Future<FindingTemplate?> getTemplate(String id);
  Future<List<FindingTemplate>> getAllTemplates();
  Future<List<FindingTemplate>> getTemplatesByCategory(String category);
  Future<void> saveTemplate(FindingTemplate template);
  Future<void> deleteTemplate(String id);
}

/// Implementation of TemplateRepository using Drift database
class DriftTemplateRepository implements TemplateRepository {
  final FindingDatabase _db;

  DriftTemplateRepository(this._db);

  @override
  Future<FindingTemplate?> getTemplate(String id) async {
    final data = await _db.getTemplateById(id);
    return data?.toDomain();
  }

  @override
  Future<List<FindingTemplate>> getAllTemplates() async {
    final data = await _db.getAllTemplates();
    return data.map((d) => d.toDomain()).toList();
  }

  @override
  Future<List<FindingTemplate>> getTemplatesByCategory(String category) async {
    final data = await _db.getTemplatesByCategory(category);
    return data.map((d) => d.toDomain()).toList();
  }

  @override
  Future<void> saveTemplate(FindingTemplate template) async {
    final existing = await _db.getTemplateById(template.id);
    if (existing == null) {
      await _db.insertTemplate(template.toCompanion());
    } else {
      await _db.updateTemplate(template.toCompanion());
    }
  }

  @override
  Future<void> deleteTemplate(String id) async {
    await _db.deleteTemplate(id);
  }
}

final templateRepositoryProvider = Provider<TemplateRepository>((ref) {
  final db = ref.watch(findingDatabaseProvider);
  return DriftTemplateRepository(db);
});
