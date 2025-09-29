import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';
import '../services/drift_storage_service.dart';
import '../services/methodology_loader.dart' as loader;

/// Unified service for loading methodologies from YAML assets into database
/// This replaces the multiple competing methodology loading systems
class UnifiedMethodologyLoader {
  static final _instance = UnifiedMethodologyLoader._internal();
  factory UnifiedMethodologyLoader() => _instance;
  UnifiedMethodologyLoader._internal();

  static const String _methodologiesBasePath = 'assets/methodologies';

  /// Database instance (will be injected)
  DriftStorageService? _storage;

  /// Set the storage service
  void setStorage(DriftStorageService storage) {
    _storage = storage;
  }

  /// Load all methodologies from YAML assets into database
  Future<void> loadMethodologies() async {
    if (_storage == null) {
      throw Exception('Storage service not set. Call setStorage() first.');
    }

    // 1. Check if already loaded
    try {
      final existingCount = await _storage!.getTemplateCount();
      if (existingCount > 0) {
        debugPrint('Methodologies already loaded: $existingCount templates');
        return;
      }
    } catch (e) {
      debugPrint('Error checking existing templates (will proceed with loading): $e');
    }

    // 2. Load YAML files from assets
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final yamlFiles = manifestMap.keys
        .where((key) => key.startsWith(_methodologiesBasePath) && key.endsWith('.yaml'))
        .where((key) => !key.contains('_index.yaml'))
        .toList();

    debugPrint('Found ${yamlFiles.length} YAML methodology files');

    // 3. Parse each YAML file
    int loadedCount = 0;
    for (final filePath in yamlFiles) {
      try {
        final yamlString = await rootBundle.loadString(filePath);
        final yamlMap = loadYaml(yamlString) as YamlMap;

        // 4. Convert YAML to MethodologyTemplate
        final template = _parseYamlToMethodologyTemplate(yamlMap);

        // 5. Store in database
        await _storage!.storeTemplate(template);

        debugPrint('Loaded: ${template.name} (${template.id})');
        loadedCount++;
      } catch (e) {
        debugPrint('Error loading $filePath: $e');
      }
    }

    debugPrint('Successfully loaded $loadedCount methodologies');
  }

  /// Convert YAML Map to MethodologyTemplate
  loader.MethodologyTemplate _parseYamlToMethodologyTemplate(YamlMap yaml) {
    return loader.MethodologyTemplate(
      id: yaml['id'] as String,
      version: yaml['version'] as String,
      templateVersion: yaml['template_version'] as String,
      name: yaml['name'] as String,
      workstream: yaml['workstream'] as String,
      author: yaml['author'] as String,
      created: DateTime.parse(yaml['created'] as String),
      modified: DateTime.parse(yaml['modified'] as String),
      status: yaml['status'] as String,
      description: yaml['description'] as String,
      tags: List<String>.from(yaml['tags'] as List),
      riskLevel: yaml['risk_level'] as String,
      overview: _parseOverview(yaml['overview'] as YamlMap),
      triggers: _parseTriggers((yaml['triggers'] as List?) ?? []),
      equipment: List<String>.from(yaml['equipment'] as List? ?? []),
      procedures: _parseProcedures((yaml['procedures'] as List?) ?? []),
      findings: _parseFindings((yaml['findings'] as List?) ?? []),
      cleanup: _parseCleanup((yaml['cleanup'] as List?) ?? []),
      troubleshooting: _parseTroubleshooting((yaml['troubleshooting'] as List?) ?? []),
    );
  }

  /// Parse overview section
  loader.MethodologyOverview _parseOverview(YamlMap overview) {
    return loader.MethodologyOverview(
      purpose: overview['purpose'] as String? ?? '',
      scope: overview['scope'] as String? ?? '',
      prerequisites: List<String>.from(overview['prerequisites'] as List? ?? []),
      category: overview['category'] as String? ?? '',
    );
  }

  /// Parse triggers section
  List<loader.MethodologyTrigger> _parseTriggers(List<dynamic> triggers) {
    return triggers.map((trigger) {
      final t = trigger as YamlMap;
      return loader.MethodologyTrigger(
        name: t['name'] as String,
        type: t['type'] as String,
        conditions: t['conditions'] != null ? Map<String, dynamic>.from(t['conditions'] as Map) : null,
        description: t['name'] as String, // Use name as description for now
      );
    }).toList();
  }

  /// Parse procedures section
  List<loader.MethodologyProcedure> _parseProcedures(List<dynamic> procedures) {
    return procedures.map((procedure) {
      final p = procedure as YamlMap;

      // Convert simple commands to MethodologyCommand objects
      final commands = (p['commands'] as List? ?? []).map((cmd) {
        return loader.MethodologyCommand(
          tool: 'shell', // Default tool
          command: cmd as String,
          description: 'Command: $cmd',
        );
      }).toList();

      return loader.MethodologyProcedure(
        id: p['id'] as String,
        name: p['name'] as String,
        description: p['description'] as String? ?? '',
        riskLevel: 'low', // Default risk level
        risks: [], // No specific risks in YAML format yet
        commands: commands,
      );
    }).toList();
  }

  /// Parse findings section
  List<loader.MethodologyFinding> _parseFindings(List<dynamic> findings) {
    return findings.map((finding) {
      final f = finding as YamlMap;
      return loader.MethodologyFinding(
        title: f['title'] as String,
        severity: f['severity'] as String,
        description: f['description'] as String? ?? '',
        recommendation: f['remediation'] as String? ?? '',
      );
    }).toList();
  }

  /// Parse cleanup section
  List<loader.MethodologyCleanup> _parseCleanup(List<dynamic> cleanup) {
    return cleanup.map((clean) {
      final c = clean as YamlMap;
      return loader.MethodologyCleanup(
        description: c['description'] as String,
        command: (c['commands'] as List? ?? []).join('; '), // Join commands
        step: c['id'] as String,
      );
    }).toList();
  }

  /// Parse troubleshooting section
  List<loader.MethodologyTroubleshooting> _parseTroubleshooting(List<dynamic> troubleshooting) {
    return troubleshooting.map((trouble) {
      final t = trouble as YamlMap;
      return loader.MethodologyTroubleshooting(
        issue: t['issue'] as String,
        solution: t['solution'] as String,
      );
    }).toList();
  }

  /// Get all methodologies from database
  Future<List<loader.MethodologyTemplate>> getAllMethodologies() async {
    if (_storage == null) {
      throw Exception('Storage service not set. Call setStorage() first.');
    }
    return await _storage!.getAllTemplates();
  }

  /// Get methodology by ID
  Future<loader.MethodologyTemplate?> getMethodology(String id) async {
    if (_storage == null) {
      throw Exception('Storage service not set. Call setStorage() first.');
    }
    return await _storage!.getTemplate(id);
  }

  /// Search methodologies
  Future<List<loader.MethodologyTemplate>> searchMethodologies({
    String? query,
    List<String>? tags,
    String? riskLevel,
    String? workstream,
  }) async {
    final all = await getAllMethodologies();

    return all.where((m) {
      if (query != null && query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!m.name.toLowerCase().contains(q) &&
            !m.description.toLowerCase().contains(q)) {
          return false;
        }
      }

      if (tags != null && tags.isNotEmpty) {
        if (!tags.any((tag) => m.tags.contains(tag))) {
          return false;
        }
      }

      if (riskLevel != null && m.riskLevel != riskLevel) {
        return false;
      }

      if (workstream != null && m.workstream != workstream) {
        return false;
      }

      return true;
    }).toList();
  }

  /// Get methodology statistics
  Future<Map<String, dynamic>> getStatistics() async {
    final methodologies = await getAllMethodologies();
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

  /// Clear database and reload from YAML
  Future<void> reloadMethodologies() async {
    if (_storage == null) {
      throw Exception('Storage service not set. Call setStorage() first.');
    }

    // Clear existing templates
    await _storage!.clearAllTemplates();

    // Reload from YAML
    await loadMethodologies();
  }
}