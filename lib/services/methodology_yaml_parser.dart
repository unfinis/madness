import 'package:yaml/yaml.dart';
import '../models/methodology.dart';

class MethodologyYamlParser {
  static Methodology parseYaml(String yamlContent) {
    final yaml = loadYaml(yamlContent) as YamlMap;

    return Methodology(
      id: yaml['id'] ?? '',
      name: yaml['name'] ?? '',
      version: yaml['version'] ?? '1.0.0',
      projectId: '', // Will be set when importing
      category: _parseCategory(yaml['category']),
      description: yaml['description'] ?? '',
      rationale: yaml['rationale'] ?? '',
      riskLevel: _parseRiskLevel(yaml['risk_level']),
      stealthLevel: _parseStealthLevel(yaml['stealth_level']),
      estimatedDuration: Duration(minutes: yaml['estimated_duration_minutes'] ?? 30),
      triggers: _parseTriggers(yaml['triggers']),
      steps: _parseSteps(yaml['execution_methods']),
      expectedAssetTypes: _parseList(yaml['expected_asset_types']),
      suppressionOptions: _parseSuppressionOptions(yaml['suppression_options']),
      nextMethodologyIds: _parseList(yaml['next_methodologies']),
      createdDate: DateTime.now(),
      updatedDate: DateTime.now(),
    );
  }

  static MethodologyCategory _parseCategory(dynamic value) {
    if (value == null) return MethodologyCategory.reconnaissance;

    switch (value.toString().toLowerCase()) {
      case 'reconnaissance':
      case 'recon':
        return MethodologyCategory.reconnaissance;
      case 'scanning':
        return MethodologyCategory.scanning;
      case 'enumeration':
        return MethodologyCategory.enumeration;
      case 'exploitation':
        return MethodologyCategory.exploitation;
      case 'post-exploitation':
      case 'postexploitation':
        return MethodologyCategory.postExploitation;
      default:
        return MethodologyCategory.reconnaissance;
    }
  }

  static MethodologyRiskLevel _parseRiskLevel(dynamic value) {
    if (value == null) return MethodologyRiskLevel.medium;

    switch (value.toString().toLowerCase()) {
      case 'low':
        return MethodologyRiskLevel.low;
      case 'medium':
        return MethodologyRiskLevel.medium;
      case 'high':
        return MethodologyRiskLevel.high;
      case 'critical':
        return MethodologyRiskLevel.critical;
      default:
        return MethodologyRiskLevel.medium;
    }
  }

  static StealthLevel _parseStealthLevel(dynamic value) {
    if (value == null) return StealthLevel.active;

    switch (value.toString().toLowerCase()) {
      case 'passive':
        return StealthLevel.passive;
      case 'active':
        return StealthLevel.active;
      case 'aggressive':
        return StealthLevel.aggressive;
      default:
        return StealthLevel.active;
    }
  }

  static List<MethodologyTrigger> _parseTriggers(dynamic triggersYaml) {
    if (triggersYaml == null || triggersYaml is! YamlList) return [];

    return triggersYaml.map((trigger) {
      final triggerMap = trigger as YamlMap;
      return MethodologyTrigger(
        id: triggerMap['id'] ?? '',
        type: _parseTriggerType(triggerMap['type']),
        conditions: _parseConditions(triggerMap['conditions']),
        priority: triggerMap['priority'] ?? 0,
        description: triggerMap['description'] ?? '',
        deduplication: _parseDeduplication(triggerMap['deduplication']),
      );
    }).toList();
  }

  static TriggerType _parseTriggerType(dynamic value) {
    if (value == null) return TriggerType.assetDiscovered;

    switch (value.toString().toLowerCase()) {
      case 'asset_discovered':
      case 'asset':
        return TriggerType.assetDiscovered;
      case 'service_detected':
      case 'service':
        return TriggerType.serviceDetected;
      case 'credential_available':
      case 'credential':
        return TriggerType.credentialAvailable;
      case 'methodology_completed':
        return TriggerType.methodologyCompleted;
      case 'custom_condition':
      case 'custom':
        return TriggerType.customCondition;
      default:
        return TriggerType.assetDiscovered;
    }
  }

  static Map<String, dynamic> _parseConditions(dynamic conditions) {
    if (conditions == null) return {};

    final Map<String, dynamic> result = {};

    if (conditions is YamlMap) {
      conditions.forEach((key, value) {
        if (value is YamlList) {
          result[key.toString()] = value.toList();
        } else if (value is YamlMap) {
          result[key.toString()] = _yamlMapToMap(value);
        } else {
          result[key.toString()] = value;
        }
      });
    }

    return result;
  }

  static Map<String, dynamic> _yamlMapToMap(YamlMap yamlMap) {
    final Map<String, dynamic> result = {};
    yamlMap.forEach((key, value) {
      if (value is YamlList) {
        result[key.toString()] = value.toList();
      } else if (value is YamlMap) {
        result[key.toString()] = _yamlMapToMap(value);
      } else {
        result[key.toString()] = value;
      }
    });
    return result;
  }

  static DeduplicationStrategy _parseDeduplication(dynamic dedup) {
    if (dedup == null) {
      return const DeduplicationStrategy(strategy: 'signature_based');
    }

    if (dedup is YamlMap) {
      return DeduplicationStrategy(
        strategy: dedup['strategy'] ?? 'signature_based',
        signatureFields: _parseList(dedup['signature_fields']),
        cooldownPeriod: dedup['cooldown_seconds'] != null
            ? Duration(seconds: dedup['cooldown_seconds'])
            : null,
        maxExecutions: dedup['max_executions'],
      );
    }

    return const DeduplicationStrategy(strategy: 'signature_based');
  }

  static List<MethodologyStep> _parseSteps(dynamic stepsYaml) {
    if (stepsYaml == null || stepsYaml is! YamlList) return [];

    return stepsYaml.asMap().entries.map((entry) {
      final step = entry.value as YamlMap;
      return MethodologyStep(
        id: step['id'] ?? 'step_${entry.key}',
        name: step['name'] ?? 'Step ${entry.key + 1}',
        description: step['description'] ?? '',
        type: _parseStepType(step['type']),
        orderIndex: entry.key,
        command: step['command'] ?? '',
        commandVariants: _parseCommandVariants(step['variants']),
        expectedOutputs: _parseExpectedOutputs(step['expected_outputs']),
        assetDiscoveryRules: _parseAssetDiscoveryRules(step['asset_discovery']),
        parameters: _parseParameters(step['parameters']),
        timeout: step['timeout_seconds'] != null
            ? Duration(seconds: step['timeout_seconds'])
            : null,
      );
    }).toList();
  }

  static MethodologyStepType _parseStepType(dynamic value) {
    if (value == null) return MethodologyStepType.command;

    switch (value.toString().toLowerCase()) {
      case 'command':
        return MethodologyStepType.command;
      case 'manual':
        return MethodologyStepType.manual;
      case 'script':
        return MethodologyStepType.script;
      case 'validation':
        return MethodologyStepType.validation;
      default:
        return MethodologyStepType.command;
    }
  }

  static List<CommandVariant> _parseCommandVariants(dynamic variants) {
    if (variants == null || variants is! YamlList) return [];

    return variants.map((variant) {
      final variantMap = variant as YamlMap;
      return CommandVariant(
        condition: variantMap['condition'] ?? '',
        command: variantMap['command'] ?? '',
        description: variantMap['description'] ?? '',
      );
    }).toList();
  }

  static List<ExpectedOutput> _parseExpectedOutputs(dynamic outputs) {
    if (outputs == null || outputs is! YamlList) return [];

    return outputs.map((output) {
      final outputMap = output as YamlMap;
      return ExpectedOutput(
        type: outputMap['type'] ?? '',
        parser: outputMap['parser'] ?? '',
        successIndicators: _parseList(outputMap['success_indicators']),
        failureIndicators: _parseList(outputMap['failure_indicators']),
      );
    }).toList();
  }

  static List<AssetDiscoveryRule> _parseAssetDiscoveryRules(dynamic rules) {
    if (rules == null || rules is! YamlList) return [];

    return rules.map((rule) {
      final ruleMap = rule as YamlMap;
      return AssetDiscoveryRule(
        pattern: ruleMap['pattern'] ?? '',
        assetType: ruleMap['asset_type'] ?? '',
        confidence: (ruleMap['confidence'] ?? 0.8).toDouble(),
        metadata: _parseParameters(ruleMap['metadata']),
      );
    }).toList();
  }

  static Map<String, dynamic> _parseParameters(dynamic params) {
    if (params == null) return {};

    if (params is YamlMap) {
      return _yamlMapToMap(params);
    }

    return {};
  }

  static List<SuppressionOption> _parseSuppressionOptions(dynamic options) {
    if (options == null || options is! YamlList) return [];

    return options.map((option) {
      final optionMap = option as YamlMap;
      return SuppressionOption(
        scope: optionMap['scope'] ?? '',
        description: optionMap['description'] ?? '',
        conditions: _parseList(optionMap['conditions']),
      );
    }).toList();
  }

  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is YamlList) {
      return value.map((e) => e.toString()).toList();
    }
    return [];
  }
}