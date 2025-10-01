import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import 'finding_database.dart';

/// Repository interface for finding operations
abstract class FindingRepository {
  Future<Finding?> getFinding(String id);
  Future<List<Finding>> getAllFindings();
  Future<List<Finding>> getMasterFindings();
  Future<List<Finding>> getSubFindings(String masterFindingId);
  Future<void> saveFinding(Finding finding);
  Future<void> deleteFinding(String id);
  Future<void> updateFindingMarkdown(String id, String field, String markdown);
}

/// Implementation of FindingRepository using Drift database
class DriftFindingRepository implements FindingRepository {
  final FindingDatabase _db;

  DriftFindingRepository(this._db);

  @override
  Future<Finding?> getFinding(String id) async {
    final data = await _db.getFindingById(id);
    return data?.toDomain();
  }

  @override
  Future<List<Finding>> getAllFindings() async {
    final data = await _db.getAllFindings();
    return data.map((d) => d.toDomain()).toList();
  }

  @override
  Future<List<Finding>> getMasterFindings() async {
    final data = await _db.getMasterFindings();
    return data.map((d) => d.toDomain()).toList();
  }

  @override
  Future<List<Finding>> getSubFindings(String masterFindingId) async {
    final data = await _db.getSubFindings(masterFindingId);
    return data.map((d) => d.toDomain()).toList();
  }

  @override
  Future<void> saveFinding(Finding finding) async {
    final existing = await _db.getFindingById(finding.id);
    if (existing == null) {
      await _db.insertFinding(finding.toCompanion());
    } else {
      await _db.updateFinding(finding.toCompanion());
    }
  }

  @override
  Future<void> deleteFinding(String id) async {
    await _db.deleteFinding(id);
  }

  @override
  Future<void> updateFindingMarkdown(
      String id, String field, String markdown) async {
    final finding = await getFinding(id);
    if (finding == null) return;

    Finding updated;
    switch (field) {
      case 'description':
        updated = finding.copyWith(description: markdown);
        break;
      case 'remediation':
        updated = finding.copyWith(remediation: markdown);
        break;
      case 'references':
        updated = finding.copyWith(references: markdown);
        break;
      case 'affectedSystems':
        updated = finding.copyWith(affectedSystems: markdown);
        break;
      default:
        return;
    }

    await saveFinding(updated.copyWith(updatedAt: DateTime.now()));
  }
}

final findingDatabaseProvider = Provider<FindingDatabase>((ref) {
  return FindingDatabase();
});

final findingRepositoryProvider = Provider<FindingRepository>((ref) {
  final db = ref.watch(findingDatabaseProvider);
  return DriftFindingRepository(db);
});
