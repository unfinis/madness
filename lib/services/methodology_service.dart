import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import 'methodology_yaml_parser.dart';

class MethodologyService {
  static final MethodologyService _instance = MethodologyService._internal();
  factory MethodologyService() => _instance;
  MethodologyService._internal();

  final Map<String, Methodology> _methodologies = {};
  final Map<String, List<String>> _dependencyGraph = {};
  final Map<String, MethodologySource> _methodologySources = {};
  bool _isInitialized = false;

  // File system paths
  late final Directory _methodologyDirectory;
  late final Directory _builtInDirectory;
  late final Directory _customDirectory;
  late final Directory _importedDirectory;
  late final Directory _disabledDirectory;

  List<Methodology> get methodologies => _methodologies.values.toList();
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _initializeDirectoryStructure();
      await _copyBuiltInMethodologies();
      await _loadMethodologies();
      _buildDependencyGraph();
      _isInitialized = true;
    } catch (e) {
      throw MethodologyServiceException('Failed to initialize methodology service: $e');
    }
  }

  Future<void> _initializeDirectoryStructure() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    _methodologyDirectory = Directory(path.join(documentsDir.path, 'methodologies'));
    _builtInDirectory = Directory(path.join(_methodologyDirectory.path, 'built-in'));
    _customDirectory = Directory(path.join(_methodologyDirectory.path, 'custom'));
    _importedDirectory = Directory(path.join(_methodologyDirectory.path, 'imported'));
    _disabledDirectory = Directory(path.join(_methodologyDirectory.path, 'disabled'));

    // Create directories if they don't exist
    await _builtInDirectory.create(recursive: true);
    await _customDirectory.create(recursive: true);
    await _importedDirectory.create(recursive: true);
    await _disabledDirectory.create(recursive: true);
  }

  Future<void> _copyBuiltInMethodologies() async {
    try {
      // Load methodology files from assets
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifest);

      final methodologyFiles = manifestMap.keys
          .where((key) => key.startsWith('assets/methodologies/') && key.endsWith('.yaml'))
          .toList();

      for (final assetPath in methodologyFiles) {
        final fileName = path.basename(assetPath);
        final localFile = File(path.join(_builtInDirectory.path, fileName));

        // Only copy if file doesn't exist or is older than app version
        if (!await localFile.exists() || await _shouldUpdateBuiltIn(localFile)) {
          final yamlContent = await rootBundle.loadString(assetPath);
          await localFile.writeAsString(yamlContent);
          print('Copied built-in methodology: $fileName');
        }
      }
    } catch (e) {
      print('Warning: Failed to copy built-in methodologies: $e');
      // Continue initialization even if copying fails
    }
  }

  Future<bool> _shouldUpdateBuiltIn(File localFile) async {
    // For now, always update built-in files
    // In future, could check file modification times or version headers
    return true;
  }

  Future<void> _loadMethodologies() async {
    _methodologies.clear();
    _methodologySources.clear();

    try {
      // Load methodologies from all directories
      await _loadMethodologiesFromDirectory(_builtInDirectory, MethodologySource.builtIn);
      await _loadMethodologiesFromDirectory(_customDirectory, MethodologySource.custom);
      await _loadMethodologiesFromDirectory(_importedDirectory, MethodologySource.imported);

      print('Loaded ${_methodologies.length} methodologies from file system');
    } catch (e) {
      throw MethodologyServiceException('Failed to load methodologies: $e');
    }
  }

  Future<void> _loadMethodologiesFromDirectory(Directory directory, MethodologySource source) async {
    if (!await directory.exists()) return;

    final yamlFiles = await directory
        .list()
        .where((entity) => entity is File && entity.path.endsWith('.yaml'))
        .cast<File>()
        .toList();

    for (final file in yamlFiles) {
      try {
        final yamlContent = await file.readAsString();
        final methodology = await _parseMethodologyYaml(yamlContent, file.path);

        // Check for ID conflicts
        if (_methodologies.containsKey(methodology.id)) {
          print('Warning: Methodology ID conflict: ${methodology.id} in ${file.path}');
          print('Skipping duplicate methodology from ${source.name}');
          continue;
        }

        _methodologies[methodology.id] = methodology;
        _methodologySources[methodology.id] = source;

        print('Loaded methodology: ${methodology.name} (${source.name})');
      } catch (e) {
        print('Error loading methodology from ${file.path}: $e');
      }
    }
  }

  Future<Methodology> _parseMethodologyYaml(String yamlContent, String filePath) async {
    try {
      // Use our enhanced YAML parser
      return MethodologyYamlParser.parseYaml(yamlContent);
    } catch (e) {
      throw MethodologyParseException('Failed to parse methodology YAML: $e');
    }
  }

  String _extractIdFromFilePath(String filePath) {
    return filePath.split('/').last.replaceAll('.yaml', '');
  }

  MethodologyCategory _parseCategory(dynamic category) {
    if (category == null) return MethodologyCategory.reconnaissance;
    
    final categoryStr = category.toString().toLowerCase();
    for (final cat in MethodologyCategory.values) {
      if (cat.name.toLowerCase() == categoryStr) {
        return cat;
      }
    }
    return MethodologyCategory.reconnaissance;
  }

  MethodologyRiskLevel _parseRiskLevel(dynamic riskLevel) {
    if (riskLevel == null) return MethodologyRiskLevel.medium;
    
    final riskStr = riskLevel.toString().toLowerCase();
    for (final risk in MethodologyRiskLevel.values) {
      if (risk.name.toLowerCase() == riskStr) {
        return risk;
      }
    }
    return MethodologyRiskLevel.medium;
  }

  StealthLevel _parseStealthLevel(dynamic stealthLevel) {
    if (stealthLevel == null) return StealthLevel.active;
    
    final stealthStr = stealthLevel.toString().toLowerCase();
    for (final stealth in StealthLevel.values) {
      if (stealth.name.toLowerCase() == stealthStr) {
        return stealth;
      }
    }
    return StealthLevel.active;
  }

  Duration _parseDuration(dynamic duration) {
    if (duration == null) return const Duration(minutes: 30);
    
    final durationStr = duration.toString().toLowerCase();
    final regex = RegExp(r'(\d+)([mhd])');
    final match = regex.firstMatch(durationStr);
    
    if (match != null) {
      final value = int.parse(match.group(1)!);
      final unit = match.group(2)!;
      
      switch (unit) {
        case 'm':
          return Duration(minutes: value);
        case 'h':
          return Duration(hours: value);
        case 'd':
          return Duration(days: value);
      }
    }
    
    return const Duration(minutes: 30);
  }

  List<MethodologyTrigger> _parseTriggers(dynamic triggers) {
    if (triggers == null) return [];
    
    final List<MethodologyTrigger> triggerList = [];
    
    if (triggers is List) {
      for (int i = 0; i < triggers.length; i++) {
        final trigger = triggers[i];
        if (trigger is Map) {
          triggerList.add(_parseTrigger(trigger, i));
        }
      }
    }
    
    return triggerList;
  }

  MethodologyTrigger _parseTrigger(Map<dynamic, dynamic> trigger, int index) {
    return MethodologyTrigger(
      id: 'trigger_$index',
      type: _parseTriggerType(trigger['type']),
      conditions: Map<String, dynamic>.from(trigger['conditions'] ?? {}),
      priority: trigger['priority'] ?? 0,
      description: trigger['description'] ?? '',
      deduplication: _parseDeduplication(trigger['deduplication']),
    );
  }

  TriggerType _parseTriggerType(dynamic type) {
    if (type == null) return TriggerType.assetDiscovered;
    
    final typeStr = type.toString().toLowerCase().replaceAll('_', '');
    for (final triggerType in TriggerType.values) {
      if (triggerType.name.toLowerCase().replaceAll('_', '') == typeStr) {
        return triggerType;
      }
    }
    return TriggerType.assetDiscovered;
  }

  DeduplicationStrategy _parseDeduplication(dynamic dedup) {
    if (dedup == null) {
      return const DeduplicationStrategy(strategy: 'signature_based');
    }
    
    final dedupMap = Map<String, dynamic>.from(dedup);
    return DeduplicationStrategy(
      strategy: dedupMap['strategy'] ?? 'signature_based',
      signatureFields: List<String>.from(dedupMap['signature_fields'] ?? []),
      cooldownPeriod: dedupMap['cooldown_period'] != null 
          ? _parseDuration(dedupMap['cooldown_period']) 
          : null,
      maxExecutions: dedupMap['max_executions'],
    );
  }

  List<MethodologyStep> _parseSteps(dynamic steps) {
    if (steps == null) return [];
    
    final List<MethodologyStep> stepList = [];
    
    if (steps is List) {
      for (int i = 0; i < steps.length; i++) {
        final step = steps[i];
        if (step is Map) {
          stepList.add(_parseStep(step, i));
        }
      }
    }
    
    return stepList;
  }

  MethodologyStep _parseStep(Map<dynamic, dynamic> step, int index) {
    return MethodologyStep(
      id: step['id'] ?? 'step_$index',
      name: step['name'] ?? 'Step ${index + 1}',
      description: step['description'] ?? '',
      type: _parseStepType(step['type']),
      orderIndex: step['order'] ?? index,
      command: step['command'] ?? '',
      commandVariants: _parseCommandVariants(step['command_variants']),
      expectedOutputs: _parseExpectedOutputs(step['expected_outputs']),
      assetDiscoveryRules: _parseAssetDiscoveryRules(step['asset_discovery']),
      parameters: Map<String, dynamic>.from(step['parameters'] ?? {}),
      timeout: step['timeout'] != null ? _parseDuration(step['timeout']) : null,
    );
  }

  MethodologyStepType _parseStepType(dynamic type) {
    if (type == null) return MethodologyStepType.command;
    
    final typeStr = type.toString().toLowerCase();
    for (final stepType in MethodologyStepType.values) {
      if (stepType.name.toLowerCase() == typeStr) {
        return stepType;
      }
    }
    return MethodologyStepType.command;
  }

  List<CommandVariant> _parseCommandVariants(dynamic variants) {
    if (variants == null) return [];
    
    final List<CommandVariant> variantList = [];
    
    if (variants is List) {
      for (final variant in variants) {
        if (variant is Map) {
          variantList.add(CommandVariant(
            condition: variant['condition'] ?? '',
            command: variant['command'] ?? '',
            description: variant['description'] ?? '',
          ));
        }
      }
    }
    
    return variantList;
  }

  List<ExpectedOutput> _parseExpectedOutputs(dynamic outputs) {
    if (outputs == null) return [];
    
    final List<ExpectedOutput> outputList = [];
    
    if (outputs is List) {
      for (final output in outputs) {
        if (output is Map) {
          outputList.add(ExpectedOutput(
            type: output['type'] ?? 'text',
            parser: output['parser'] ?? 'default',
            successIndicators: List<String>.from(output['success_indicators'] ?? []),
            failureIndicators: List<String>.from(output['failure_indicators'] ?? []),
          ));
        }
      }
    }
    
    return outputList;
  }

  List<AssetDiscoveryRule> _parseAssetDiscoveryRules(dynamic assetDiscovery) {
    if (assetDiscovery == null) return [];
    
    final List<AssetDiscoveryRule> ruleList = [];
    
    if (assetDiscovery is Map) {
      final searchPatterns = assetDiscovery['search_patterns'];
      if (searchPatterns is List) {
        for (final pattern in searchPatterns) {
          if (pattern is Map) {
            ruleList.add(AssetDiscoveryRule(
              pattern: pattern['pattern'] ?? '',
              assetType: pattern['asset_type'] ?? 'other',
              confidence: (pattern['confidence'] ?? 0.8).toDouble(),
              metadata: Map<String, dynamic>.from(pattern['metadata'] ?? {}),
            ));
          }
        }
      }
    }
    
    return ruleList;
  }

  List<String> _parseExpectedAssetTypes(dynamic assetDiscovery) {
    if (assetDiscovery == null) return [];
    
    if (assetDiscovery is Map) {
      final expectedAssets = assetDiscovery['expected_assets'];
      if (expectedAssets is List) {
        return expectedAssets
            .where((asset) => asset is Map && asset['type'] != null)
            .map<String>((asset) => asset['type'].toString())
            .toList();
      }
    }
    
    return [];
  }

  List<SuppressionOption> _parseSuppressionOptions(dynamic suppression) {
    if (suppression == null) return [];
    
    final List<SuppressionOption> optionList = [];
    
    if (suppression is Map) {
      final availableScopes = suppression['available_scopes'];
      if (availableScopes is List) {
        for (final scope in availableScopes) {
          if (scope is Map) {
            optionList.add(SuppressionOption(
              scope: scope['scope'] ?? 'global',
              description: scope['description'] ?? '',
              conditions: List<String>.from(scope['conditions'] ?? []),
            ));
          }
        }
      }
    }
    
    return optionList;
  }

  List<String> _parseNextMethodologies(dynamic nextMethodologies) {
    if (nextMethodologies == null) return [];
    
    final List<String> nextList = [];
    
    if (nextMethodologies is List) {
      for (final next in nextMethodologies) {
        if (next is Map && next['methodology'] != null) {
          nextList.add(next['methodology'].toString());
        }
      }
    }
    
    return nextList;
  }

  void _buildDependencyGraph() {
    _dependencyGraph.clear();
    
    for (final methodology in _methodologies.values) {
      _dependencyGraph[methodology.id] = methodology.nextMethodologyIds;
    }
  }

  List<Methodology> getMethodologiesByCategory(MethodologyCategory category) {
    return _methodologies.values
        .where((m) => m.category == category)
        .toList();
  }

  List<Methodology> getRecommendedMethodologies(String projectId, List<DiscoveredAsset> assets) {
    if (!_isInitialized) return [];
    
    final recommendations = <Methodology>[];
    
    for (final methodology in _methodologies.values) {
      if (_shouldRecommendMethodology(methodology, assets)) {
        recommendations.add(methodology.copyWith(projectId: projectId));
      }
    }
    
    // Sort by category order and priority
    recommendations.sort((a, b) {
      final categoryComparison = a.category.index.compareTo(b.category.index);
      if (categoryComparison != 0) return categoryComparison;
      
      // Secondary sort by estimated duration (shorter first)
      return a.estimatedDuration.compareTo(b.estimatedDuration);
    });
    
    return recommendations;
  }

  bool _shouldRecommendMethodology(Methodology methodology, List<DiscoveredAsset> assets) {
    if (methodology.triggers.isEmpty) return true; // No triggers means always recommend
    
    for (final trigger in methodology.triggers) {
      if (_evaluateTrigger(trigger, assets)) {
        return true;
      }
    }
    
    return false;
  }

  bool _evaluateTrigger(MethodologyTrigger trigger, List<DiscoveredAsset> assets) {
    switch (trigger.type) {
      case TriggerType.assetDiscovered:
        return _evaluateAssetDiscoveryTrigger(trigger.conditions, assets);
      case TriggerType.serviceDetected:
        return _evaluateServiceDetectionTrigger(trigger.conditions, assets);
      case TriggerType.credentialAvailable:
        return _evaluateCredentialTrigger(trigger.conditions, assets);
      case TriggerType.methodologyCompleted:
        // This would require execution history - simplified for now
        return false;
      case TriggerType.customCondition:
        return _evaluateCustomCondition(trigger.conditions, assets);
    }
  }

  bool _evaluateAssetDiscoveryTrigger(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    final requiredAssetType = conditions['asset_type'];
    final requiredProperties = conditions['properties'] as Map<String, dynamic>?;
    
    if (requiredAssetType == null) return false;
    
    final matchingAssets = assets.where((asset) {
      if (asset.type.name != requiredAssetType) return false;
      
      if (requiredProperties != null) {
        for (final entry in requiredProperties.entries) {
          if (asset.properties[entry.key] != entry.value) return false;
        }
      }
      
      return true;
    });
    
    return matchingAssets.isNotEmpty;
  }

  bool _evaluateServiceDetectionTrigger(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    final requiredPort = conditions['port'];
    final requiredService = conditions['service'];
    
    return assets.any((asset) {
      if (asset.type != AssetType.service) return false;
      
      if (requiredPort != null && asset.properties['port'] != requiredPort) {
        return false;
      }
      
      if (requiredService != null && !asset.name.toLowerCase().contains(requiredService.toString().toLowerCase())) {
        return false;
      }
      
      return true;
    });
  }

  bool _evaluateCredentialTrigger(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    final credentialType = conditions['type'];
    final privilegeLevel = conditions['privilege_level'];
    
    return assets.any((asset) {
      if (asset.type != AssetType.credential) return false;
      
      if (credentialType != null && asset.properties['type'] != credentialType) {
        return false;
      }
      
      if (privilegeLevel != null && asset.properties['privilege_level'] != privilegeLevel) {
        return false;
      }
      
      return true;
    });
  }

  bool _evaluateCustomCondition(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    // Simplified custom condition evaluation
    // In a real implementation, this would be more sophisticated
    return conditions.isEmpty || assets.isNotEmpty;
  }

  Methodology? getMethodologyById(String id) {
    return _methodologies[id];
  }

  List<Methodology> searchMethodologies(String query) {
    if (query.isEmpty) return methodologies;
    
    final lowercaseQuery = query.toLowerCase();
    return _methodologies.values.where((methodology) {
      return methodology.name.toLowerCase().contains(lowercaseQuery) ||
             methodology.description.toLowerCase().contains(lowercaseQuery) ||
             methodology.category.displayName.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Future<void> reloadMethodologies() async {
    _isInitialized = false;
    await initialize();
  }

  // Runtime methodology management methods
  Future<void> importMethodology(String yamlContent, {MethodologySource source = MethodologySource.imported}) async {
    try {
      final methodology = await _parseMethodologyYaml(yamlContent, 'imported');

      // Determine target directory
      Directory targetDir;
      switch (source) {
        case MethodologySource.custom:
          targetDir = _customDirectory;
          break;
        case MethodologySource.imported:
          targetDir = _importedDirectory;
          break;
        case MethodologySource.builtIn:
          throw MethodologyServiceException('Cannot import as built-in methodology');
      }

      // Create filename from methodology ID
      final fileName = '${methodology.id}.yaml';
      final targetFile = File(path.join(targetDir.path, fileName));

      // Check for conflicts
      if (await targetFile.exists()) {
        throw MethodologyServiceException('Methodology already exists: ${methodology.id}');
      }

      // Write file and update in-memory cache
      await targetFile.writeAsString(yamlContent);
      _methodologies[methodology.id] = methodology;
      _methodologySources[methodology.id] = source;

      print('Imported methodology: ${methodology.name} to ${source.name}');
    } catch (e) {
      throw MethodologyServiceException('Failed to import methodology: $e');
    }
  }

  Future<String> exportMethodology(String methodologyId) async {
    final methodology = _methodologies[methodologyId];
    if (methodology == null) {
      throw MethodologyServiceException('Methodology not found: $methodologyId');
    }

    final source = _methodologySources[methodologyId];
    Directory sourceDir;

    switch (source) {
      case MethodologySource.builtIn:
        sourceDir = _builtInDirectory;
        break;
      case MethodologySource.custom:
        sourceDir = _customDirectory;
        break;
      case MethodologySource.imported:
        sourceDir = _importedDirectory;
        break;
      default:
        throw MethodologyServiceException('Unknown methodology source');
    }

    final fileName = '$methodologyId.yaml';
    final sourceFile = File(path.join(sourceDir.path, fileName));

    if (!await sourceFile.exists()) {
      throw MethodologyServiceException('Methodology file not found: ${sourceFile.path}');
    }

    return await sourceFile.readAsString();
  }

  Future<void> createCustomMethodology(String yamlContent) async {
    await importMethodology(yamlContent, source: MethodologySource.custom);
  }

  Future<void> updateMethodology(String methodologyId, String yamlContent) async {
    final source = _methodologySources[methodologyId];
    if (source == null) {
      throw MethodologyServiceException('Methodology not found: $methodologyId');
    }

    if (source == MethodologySource.builtIn) {
      throw MethodologyServiceException('Cannot modify built-in methodology');
    }

    // Parse to validate
    final methodology = await _parseMethodologyYaml(yamlContent, 'updated');
    if (methodology.id != methodologyId) {
      throw MethodologyServiceException('Methodology ID mismatch');
    }

    Directory targetDir = source == MethodologySource.custom ? _customDirectory : _importedDirectory;
    final fileName = '$methodologyId.yaml';
    final targetFile = File(path.join(targetDir.path, fileName));

    await targetFile.writeAsString(yamlContent);
    _methodologies[methodologyId] = methodology;

    print('Updated methodology: ${methodology.name}');
  }

  Future<void> deleteMethodology(String methodologyId) async {
    final source = _methodologySources[methodologyId];
    if (source == null) {
      throw MethodologyServiceException('Methodology not found: $methodologyId');
    }

    if (source == MethodologySource.builtIn) {
      throw MethodologyServiceException('Cannot delete built-in methodology');
    }

    Directory sourceDir = source == MethodologySource.custom ? _customDirectory : _importedDirectory;
    final fileName = '$methodologyId.yaml';
    final sourceFile = File(path.join(sourceDir.path, fileName));

    if (await sourceFile.exists()) {
      await sourceFile.delete();
    }

    _methodologies.remove(methodologyId);
    _methodologySources.remove(methodologyId);

    print('Deleted methodology: $methodologyId');
  }

  Future<void> disableMethodology(String methodologyId) async {
    final source = _methodologySources[methodologyId];
    if (source == null) {
      throw MethodologyServiceException('Methodology not found: $methodologyId');
    }

    Directory sourceDir;
    switch (source) {
      case MethodologySource.builtIn:
        sourceDir = _builtInDirectory;
        break;
      case MethodologySource.custom:
        sourceDir = _customDirectory;
        break;
      case MethodologySource.imported:
        sourceDir = _importedDirectory;
        break;
    }

    final fileName = '$methodologyId.yaml';
    final sourceFile = File(path.join(sourceDir.path, fileName));
    final disabledFile = File(path.join(_disabledDirectory.path, fileName));

    if (await sourceFile.exists()) {
      await sourceFile.rename(disabledFile.path);
      _methodologies.remove(methodologyId);
      _methodologySources.remove(methodologyId);
      print('Disabled methodology: $methodologyId');
    }
  }

  Future<void> enableMethodology(String methodologyId, MethodologySource targetSource) async {
    final fileName = '$methodologyId.yaml';
    final disabledFile = File(path.join(_disabledDirectory.path, fileName));

    if (!await disabledFile.exists()) {
      throw MethodologyServiceException('Disabled methodology not found: $methodologyId');
    }

    Directory targetDir;
    switch (targetSource) {
      case MethodologySource.custom:
        targetDir = _customDirectory;
        break;
      case MethodologySource.imported:
        targetDir = _importedDirectory;
        break;
      case MethodologySource.builtIn:
        throw MethodologyServiceException('Cannot enable as built-in methodology');
    }

    final targetFile = File(path.join(targetDir.path, fileName));
    await disabledFile.rename(targetFile.path);

    // Reload the methodology
    final yamlContent = await targetFile.readAsString();
    final methodology = await _parseMethodologyYaml(yamlContent, targetFile.path);
    _methodologies[methodology.id] = methodology;
    _methodologySources[methodology.id] = targetSource;

    print('Enabled methodology: ${methodology.name}');
  }

  // Utility methods
  MethodologySource? getMethodologySource(String methodologyId) {
    return _methodologySources[methodologyId];
  }

  List<Methodology> getMethodologiesBySource(MethodologySource source) {
    return _methodologies.entries
        .where((entry) => _methodologySources[entry.key] == source)
        .map((entry) => entry.value)
        .toList();
  }

  List<String> getDisabledMethodologyIds() {
    if (!_disabledDirectory.existsSync()) return [];

    return _disabledDirectory
        .listSync()
        .where((entity) => entity is File && entity.path.endsWith('.yaml'))
        .map((file) => path.basenameWithoutExtension(file.path))
        .toList();
  }

  Future<String> getMethodologyFilePath(String methodologyId) async {
    final source = _methodologySources[methodologyId];
    if (source == null) {
      throw MethodologyServiceException('Methodology not found: $methodologyId');
    }

    Directory sourceDir;
    switch (source) {
      case MethodologySource.builtIn:
        sourceDir = _builtInDirectory;
        break;
      case MethodologySource.custom:
        sourceDir = _customDirectory;
        break;
      case MethodologySource.imported:
        sourceDir = _importedDirectory;
        break;
    }

    return path.join(sourceDir.path, '$methodologyId.yaml');
  }
}

class MethodologyServiceException implements Exception {
  final String message;
  MethodologyServiceException(this.message);
  
  @override
  String toString() => 'MethodologyServiceException: $message';
}

class MethodologyParseException implements Exception {
  final String message;
  MethodologyParseException(this.message);

  @override
  String toString() => 'MethodologyParseException: $message';
}

enum MethodologySource {
  builtIn,
  custom,
  imported;

  String get displayName {
    switch (this) {
      case MethodologySource.builtIn:
        return 'Built-in';
      case MethodologySource.custom:
        return 'Custom';
      case MethodologySource.imported:
        return 'Imported';
    }
  }

  String get description {
    switch (this) {
      case MethodologySource.builtIn:
        return 'Methodologies shipped with the application';
      case MethodologySource.custom:
        return 'User-created methodologies';
      case MethodologySource.imported:
        return 'Methodologies imported from external sources';
    }
  }
}