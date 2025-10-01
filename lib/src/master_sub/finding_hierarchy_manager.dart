import '../models/finding.dart';
import '../storage/finding_repository.dart';

/// Manager for master-sub finding hierarchies
class FindingHierarchyManager {
  final FindingRepository _repository;

  FindingHierarchyManager(this._repository);

  /// Add a sub-finding to a master finding
  Future<void> addSubFinding(String masterFindingId, Finding subFinding) async {
    // Get master finding
    final master = await _repository.getFinding(masterFindingId);
    if (master == null) {
      throw Exception('Master finding not found: $masterFindingId');
    }

    // Update sub-finding to reference master
    final updatedSub = subFinding.copyWith(
      masterFindingId: masterFindingId,
    );
    await _repository.saveFinding(updatedSub);

    // Update master to include sub-finding in list
    final updatedMaster = master.copyWith(
      subFindingIds: [...master.subFindingIds, subFinding.id],
      updatedAt: DateTime.now(),
    );
    await _repository.saveFinding(updatedMaster);
  }

  /// Remove a sub-finding from its master
  Future<void> removeSubFinding(
      String masterFindingId, String subFindingId) async {
    // Get master finding
    final master = await _repository.getFinding(masterFindingId);
    if (master == null) {
      throw Exception('Master finding not found: $masterFindingId');
    }

    // Get sub-finding
    final sub = await _repository.getFinding(subFindingId);
    if (sub == null) {
      throw Exception('Sub-finding not found: $subFindingId');
    }

    // Update sub-finding to remove master reference
    final updatedSub = sub.copyWith(
      masterFindingId: null,
    );
    await _repository.saveFinding(updatedSub);

    // Update master to remove sub-finding from list
    final updatedMaster = master.copyWith(
      subFindingIds:
          master.subFindingIds.where((id) => id != subFindingId).toList(),
      updatedAt: DateTime.now(),
    );
    await _repository.saveFinding(updatedMaster);
  }

  /// Get all sub-findings for a master finding
  Future<List<Finding>> getSubFindings(String masterFindingId) async {
    return await _repository.getSubFindings(masterFindingId);
  }

  /// Get the master finding for a sub-finding
  Future<Finding?> getMasterFinding(String subFindingId) async {
    final sub = await _repository.getFinding(subFindingId);
    if (sub?.masterFindingId == null) return null;

    return await _repository.getFinding(sub!.masterFindingId!);
  }

  /// Promote a sub-finding to a master finding
  Future<void> promoteSubFinding(String subFindingId) async {
    final sub = await _repository.getFinding(subFindingId);
    if (sub == null) {
      throw Exception('Sub-finding not found: $subFindingId');
    }

    if (sub.masterFindingId == null) {
      return; // Already a master finding
    }

    // Remove from master
    await removeSubFinding(sub.masterFindingId!, subFindingId);
  }

  /// Merge multiple sub-findings into their master
  Future<Finding> mergeSubFindings(
    String masterFindingId,
    List<String> subFindingIds,
  ) async {
    final master = await _repository.getFinding(masterFindingId);
    if (master == null) {
      throw Exception('Master finding not found: $masterFindingId');
    }

    final subFindings = <Finding>[];
    for (final id in subFindingIds) {
      final sub = await _repository.getFinding(id);
      if (sub != null) {
        subFindings.add(sub);
      }
    }

    // Merge descriptions
    final mergedDescription = StringBuffer(master.description);
    mergedDescription.writeln('\n\n## Additional Details\n');

    for (final sub in subFindings) {
      mergedDescription.writeln('### ${sub.title}\n');
      mergedDescription.writeln(sub.description);
      mergedDescription.writeln();
    }

    // Merge affected systems
    final affectedSystems = <String>[];
    if (master.affectedSystems != null) {
      affectedSystems.add(master.affectedSystems!);
    }
    for (final sub in subFindings) {
      if (sub.affectedSystems != null) {
        affectedSystems.add(sub.affectedSystems!);
      }
    }

    // Merge images
    final imageIds = <String>{...master.imageIds};
    for (final sub in subFindings) {
      imageIds.addAll(sub.imageIds);
    }

    // Create merged finding
    final merged = master.copyWith(
      description: mergedDescription.toString(),
      affectedSystems: affectedSystems.isNotEmpty
          ? affectedSystems.join('\n\n')
          : null,
      imageIds: imageIds.toList(),
      updatedAt: DateTime.now(),
    );

    // Save merged finding
    await _repository.saveFinding(merged);

    // Delete sub-findings
    for (final id in subFindingIds) {
      await _repository.deleteFinding(id);
    }

    // Update master's sub-finding list
    final updatedMaster = merged.copyWith(
      subFindingIds: merged.subFindingIds
          .where((id) => !subFindingIds.contains(id))
          .toList(),
    );
    await _repository.saveFinding(updatedMaster);

    return updatedMaster;
  }

  /// Convert a master finding to a sub-finding of another master
  Future<void> convertToSubFinding(
    String findingId,
    String newMasterFindingId,
  ) async {
    final finding = await _repository.getFinding(findingId);
    if (finding == null) {
      throw Exception('Finding not found: $findingId');
    }

    // If it's already a sub-finding, remove from old master first
    if (finding.masterFindingId != null) {
      await removeSubFinding(finding.masterFindingId!, findingId);
    }

    // If it has sub-findings, promote them to master findings
    if (finding.subFindingIds.isNotEmpty) {
      for (final subId in finding.subFindingIds) {
        await promoteSubFinding(subId);
      }
    }

    // Add to new master
    await addSubFinding(newMasterFindingId, finding);
  }

  /// Get the complete hierarchy tree starting from a master finding
  Future<FindingHierarchyTree> getHierarchyTree(String masterFindingId) async {
    final master = await _repository.getFinding(masterFindingId);
    if (master == null) {
      throw Exception('Finding not found: $masterFindingId');
    }

    final children = await getSubFindings(masterFindingId);

    return FindingHierarchyTree(
      finding: master,
      children: children
          .map((child) => FindingHierarchyTree(finding: child, children: []))
          .toList(),
    );
  }
}

/// Represents a node in the finding hierarchy tree
class FindingHierarchyTree {
  final Finding finding;
  final List<FindingHierarchyTree> children;

  FindingHierarchyTree({
    required this.finding,
    required this.children,
  });

  bool get hasChildren => children.isNotEmpty;

  int get totalFindings => 1 + children.fold(0, (sum, child) => sum + child.totalFindings);
}
