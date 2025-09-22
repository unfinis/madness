import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service for loading and managing JSON methodology templates
class MethodologyLoader {
  static const String _methodologiesBasePath = 'assets/methodologies';
  static final Map<String, MethodologyTemplate> _cache = {};
  static final Map<String, List<MethodologyTemplate>> _workstreamCache = {};
  static bool _isLoaded = false;

  /// Load all methodologies from the assets directory
  static Future<Map<String, List<MethodologyTemplate>>> loadAllMethodologies() async {
    if (_isLoaded && _workstreamCache.isNotEmpty) {
      return _workstreamCache;
    }

    _workstreamCache.clear();
    _cache.clear();

    try {
      // Get list of workstream directories
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      // Find all JSON methodology files
      final methodologyFiles = manifestMap.keys
          .where((String key) => key.startsWith(_methodologiesBasePath) && key.endsWith('.json'))
          .toList();

      debugPrint('Found ${methodologyFiles.length} methodology files in manifest');

      for (final filePath in methodologyFiles) {
        try {
          final content = await rootBundle.loadString(filePath);
          final jsonData = json.decode(content);
          final methodology = MethodologyTemplate.fromJson(jsonData);

          // Extract workstream from file path
          final pathParts = filePath.split('/');
          final workstream = pathParts.length >= 3 ? pathParts[2] : 'general';

          // Cache by ID and workstream
          _cache[methodology.id] = methodology;
          _workstreamCache.putIfAbsent(workstream, () => []).add(methodology);

          debugPrint('Loaded methodology: ${methodology.id} (${methodology.name})');
        } catch (e) {
          debugPrint('Error loading methodology from $filePath: $e');
        }
      }

      _isLoaded = true;
      debugPrint('Loaded ${_cache.length} methodologies across ${_workstreamCache.length} workstreams');

    } catch (e) {
      debugPrint('Error loading methodologies: $e');
    }

    return _workstreamCache;
  }

  /// Get methodology by ID
  static MethodologyTemplate? getMethodologyById(String id) {
    return _cache[id];
  }

  /// Get methodologies by workstream
  static List<MethodologyTemplate> getMethodologiesByWorkstream(String workstream) {
    return _workstreamCache[workstream] ?? [];
  }

  /// Get all methodologies as a flat list
  static List<MethodologyTemplate> getAllMethodologies() {
    return _cache.values.toList();
  }

  /// Search methodologies by various criteria
  static List<MethodologyTemplate> searchMethodologies({
    String? query,
    String? workstream,
    List<String>? tags,
    String? riskLevel,
    String? status,
  }) {
    var results = getAllMethodologies();

    if (workstream != null) {
      results = results.where((m) => m.workstream == workstream).toList();
    }

    if (query != null && query.isNotEmpty) {
      final searchTerm = query.toLowerCase();
      results = results.where((m) =>
        m.name.toLowerCase().contains(searchTerm) ||
        m.description.toLowerCase().contains(searchTerm) ||
        m.tags.any((tag) => tag.toLowerCase().contains(searchTerm))
      ).toList();
    }

    if (tags != null && tags.isNotEmpty) {
      results = results.where((m) =>
        tags.every((tag) => m.tags.contains(tag))
      ).toList();
    }

    if (riskLevel != null) {
      results = results.where((m) => m.riskLevel == riskLevel).toList();
    }

    if (status != null) {
      results = results.where((m) => m.status == status).toList();
    }

    return results;
  }

  /// Get available workstreams
  static List<String> getAvailableWorkstreams() {
    return _workstreamCache.keys.toList()..sort();
  }

  /// Get methodology statistics
  static Map<String, dynamic> getStatistics() {
    final methodologies = getAllMethodologies();
    final workstreams = <String, int>{};
    final riskLevels = <String, int>{};
    final statuses = <String, int>{};

    for (final methodology in methodologies) {
      workstreams[methodology.workstream] = (workstreams[methodology.workstream] ?? 0) + 1;
      riskLevels[methodology.riskLevel] = (riskLevels[methodology.riskLevel] ?? 0) + 1;
      statuses[methodology.status] = (statuses[methodology.status] ?? 0) + 1;
    }

    return {
      'total_methodologies': methodologies.length,
      'workstreams': workstreams,
      'risk_levels': riskLevels,
      'statuses': statuses,
    };
  }

  /// Clear cache and force reload
  static void clearCache() {
    _cache.clear();
    _workstreamCache.clear();
    _isLoaded = false;
  }

  /// Validate methodology JSON structure
  static bool validateMethodology(Map<String, dynamic> json) {
    try {
      MethodologyTemplate.fromJson(json);
      return true;
    } catch (e) {
      // Methodology validation failed: $e
      return false;
    }
  }
}

/// JSON Methodology Template Model
class MethodologyTemplate {
  final String id;
  final String version;
  final String templateVersion;
  final String name;
  final String workstream;
  final String author;
  final DateTime created;
  final DateTime modified;
  final String status;
  final String description;
  final List<String> tags;
  final String riskLevel;

  // Content sections
  final MethodologyOverview overview;
  final List<MethodologyTrigger> triggers;
  final List<String> equipment;
  final List<MethodologyProcedure> procedures;
  final List<MethodologyFinding> findings;
  final List<MethodologyCleanup> cleanup;
  final List<MethodologyTroubleshooting> troubleshooting;

  const MethodologyTemplate({
    required this.id,
    required this.version,
    required this.templateVersion,
    required this.name,
    required this.workstream,
    required this.author,
    required this.created,
    required this.modified,
    required this.status,
    required this.description,
    required this.tags,
    required this.riskLevel,
    required this.overview,
    required this.triggers,
    required this.equipment,
    required this.procedures,
    required this.findings,
    required this.cleanup,
    required this.troubleshooting,
  });

  factory MethodologyTemplate.fromJson(Map<String, dynamic> json) {
    return MethodologyTemplate(
      id: json['id'] as String,
      version: json['version'] as String,
      templateVersion: json['template_version'] as String,
      name: json['name'] as String,
      workstream: json['workstream'] as String,
      author: json['author'] as String,
      created: DateTime.parse(json['created'] as String),
      modified: DateTime.parse(json['modified'] as String),
      status: json['status'] as String,
      description: json['description'] as String,
      tags: List<String>.from(json['tags'] as List),
      riskLevel: json['risk_level'] as String,
      overview: MethodologyOverview.fromJson(json['overview'] as Map<String, dynamic>),
      triggers: (json['triggers'] as List)
          .map((t) => MethodologyTrigger.fromJson(t as Map<String, dynamic>))
          .toList(),
      equipment: List<String>.from(json['equipment'] as List? ?? []),
      procedures: (json['procedures'] as List)
          .map((p) => MethodologyProcedure.fromJson(p as Map<String, dynamic>))
          .toList(),
      findings: (json['findings'] as List? ?? [])
          .map((f) => MethodologyFinding.fromJson(f as Map<String, dynamic>))
          .toList(),
      cleanup: (json['cleanup'] as List? ?? [])
          .map((c) => MethodologyCleanup.fromJson(c as Map<String, dynamic>))
          .toList(),
      troubleshooting: (json['troubleshooting'] as List? ?? [])
          .map((t) => MethodologyTroubleshooting.fromJson(t as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'template_version': templateVersion,
      'name': name,
      'workstream': workstream,
      'author': author,
      'created': created.toIso8601String(),
      'modified': modified.toIso8601String(),
      'status': status,
      'description': description,
      'tags': tags,
      'risk_level': riskLevel,
      'overview': overview.toJson(),
      'triggers': triggers.map((t) => t.toJson()).toList(),
      'equipment': equipment,
      'procedures': procedures.map((p) => p.toJson()).toList(),
      'findings': findings.map((f) => f.toJson()).toList(),
      'cleanup': cleanup.map((c) => c.toJson()).toList(),
      'troubleshooting': troubleshooting.map((t) => t.toJson()).toList(),
    };
  }
}

/// Supporting model classes
class MethodologyOverview {
  final String purpose;
  final String scope;
  final List<String> prerequisites;
  final String category;

  const MethodologyOverview({
    required this.purpose,
    required this.scope,
    required this.prerequisites,
    required this.category,
  });

  factory MethodologyOverview.fromJson(Map<String, dynamic> json) {
    return MethodologyOverview(
      purpose: json['purpose'] as String,
      scope: json['scope'] as String,
      prerequisites: List<String>.from(json['prerequisites'] as List),
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose,
      'scope': scope,
      'prerequisites': prerequisites,
      'category': category,
    };
  }
}

class MethodologyTrigger {
  final String name;
  final String type; // "simple" or "complex"
  final Map<String, dynamic>? conditions;
  final String? script;
  final String description;

  const MethodologyTrigger({
    required this.name,
    required this.type,
    this.conditions,
    this.script,
    required this.description,
  });

  factory MethodologyTrigger.fromJson(Map<String, dynamic> json) {
    return MethodologyTrigger(
      name: json['name'] as String,
      type: json['type'] as String,
      conditions: json['conditions'] as Map<String, dynamic>?,
      script: json['script'] as String?,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      if (conditions != null) 'conditions': conditions,
      if (script != null) 'script': script,
      'description': description,
    };
  }
}

class MethodologyProcedure {
  final String id;
  final String name;
  final String description;
  final String riskLevel;
  final List<MethodologyRisk> risks;
  final List<MethodologyCommand> commands;

  const MethodologyProcedure({
    required this.id,
    required this.name,
    required this.description,
    required this.riskLevel,
    required this.risks,
    required this.commands,
  });

  factory MethodologyProcedure.fromJson(Map<String, dynamic> json) {
    return MethodologyProcedure(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      riskLevel: json['risk_level'] as String,
      risks: (json['risks'] as List? ?? [])
          .map((r) => MethodologyRisk.fromJson(r as Map<String, dynamic>))
          .toList(),
      commands: (json['commands'] as List)
          .map((c) => MethodologyCommand.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'risk_level': riskLevel,
      'risks': risks.map((r) => r.toJson()).toList(),
      'commands': commands.map((c) => c.toJson()).toList(),
    };
  }
}

class MethodologyRisk {
  final String risk;
  final String mitigation;

  const MethodologyRisk({
    required this.risk,
    required this.mitigation,
  });

  factory MethodologyRisk.fromJson(Map<String, dynamic> json) {
    return MethodologyRisk(
      risk: json['risk'] as String,
      mitigation: json['mitigation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'risk': risk,
      'mitigation': mitigation,
    };
  }
}

class MethodologyCommand {
  final String tool;
  final String command;
  final String description;
  final Map<String, String>? parameters;
  final List<String>? platforms;

  const MethodologyCommand({
    required this.tool,
    required this.command,
    required this.description,
    this.parameters,
    this.platforms,
  });

  factory MethodologyCommand.fromJson(Map<String, dynamic> json) {
    return MethodologyCommand(
      tool: json['tool'] as String,
      command: json['command'] as String,
      description: json['description'] as String,
      parameters: json['parameters'] != null
          ? Map<String, String>.from(json['parameters'] as Map)
          : null,
      platforms: json['platforms'] != null
          ? List<String>.from(json['platforms'] as List)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tool': tool,
      'command': command,
      'description': description,
      if (parameters != null) 'parameters': parameters,
      if (platforms != null) 'platforms': platforms,
    };
  }
}

class MethodologyFinding {
  final String title;
  final String severity;
  final String description;
  final String recommendation;

  const MethodologyFinding({
    required this.title,
    required this.severity,
    required this.description,
    required this.recommendation,
  });

  factory MethodologyFinding.fromJson(Map<String, dynamic> json) {
    return MethodologyFinding(
      title: json['title'] as String,
      severity: json['severity'] as String,
      description: json['description'] as String,
      recommendation: json['recommendation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'severity': severity,
      'description': description,
      'recommendation': recommendation,
    };
  }
}

class MethodologyCleanup {
  final String step;
  final String description;
  final String command;

  const MethodologyCleanup({
    required this.step,
    required this.description,
    required this.command,
  });

  factory MethodologyCleanup.fromJson(Map<String, dynamic> json) {
    return MethodologyCleanup(
      step: json['step'] as String,
      description: json['description'] as String,
      command: json['command'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'description': description,
      'command': command,
    };
  }
}

class MethodologyTroubleshooting {
  final String issue;
  final String solution;

  const MethodologyTroubleshooting({
    required this.issue,
    required this.solution,
  });

  factory MethodologyTroubleshooting.fromJson(Map<String, dynamic> json) {
    return MethodologyTroubleshooting(
      issue: json['issue'] as String,
      solution: json['solution'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'issue': issue,
      'solution': solution,
    };
  }
}