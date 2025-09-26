import 'package:uuid/uuid.dart';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import 'methodology_service.dart';
import 'methodology_chain_manager.dart';
import 'output_parser_service.dart';

/// Service for ingesting outcomes from manual testing and triggering next steps
class OutcomeIngestionService {
  static final OutcomeIngestionService _instance = OutcomeIngestionService._internal();
  factory OutcomeIngestionService() => _instance;
  OutcomeIngestionService._internal();

  final _uuid = const Uuid();
  final MethodologyService _methodologyService = MethodologyService();
  final MethodologyChainManager _chainManager = MethodologyChainManager();
  final OutputParserService _outputParser = OutputParserService();

  // Current engagement state
  final Map<String, dynamic> _engagementContext = {};
  final List<IngestionEvent> _ingestionHistory = [];
  final Map<String, List<String>> _completedMethodologies = {};

  /// Ingest an outcome from manual testing
  Future<IngestionResult> ingestOutcome({
    required String projectId,
    required String methodologyId,
    required String stepId,
    required Map<String, dynamic> outcome,
    String? rawOutput,
    String? parserType,
  }) async {
    // Create ingestion event
    final event = IngestionEvent(
      id: _uuid.v4(),
      projectId: projectId,
      methodologyId: methodologyId,
      stepId: stepId,
      outcome: outcome,
      rawOutput: rawOutput,
      timestamp: DateTime.now(),
    );

    _ingestionHistory.add(event);

    // Parse raw output if provided
    if (rawOutput != null && parserType != null) {
      final parsedData = _outputParser.parseOutput(rawOutput, parserType);
      outcome.addAll(parsedData);

      // Extract assets from parsed output
      final assets = _outputParser.extractAssets(parsedData, parserType);
      outcome['discovered_assets'] = assets.map((a) => a.toJson()).toList();
    }

    // Update engagement context with new data
    _updateEngagementContext(outcome);

    // Mark methodology step as completed
    _markStepCompleted(projectId, methodologyId, stepId);

    // Evaluate what should happen next
    final recommendations = _evaluateNextSteps(projectId, methodologyId, outcome);

    // Check for critical findings
    final criticalFindings = _checkForCriticalFindings(outcome);

    return IngestionResult(
      success: true,
      recommendations: recommendations,
      criticalFindings: criticalFindings,
      updatedContext: Map<String, dynamic>.from(_engagementContext),
      triggeredMethodologies: _getTriggeredMethodologies(outcome),
    );
  }

  /// Manually report an outcome without raw data
  Future<IngestionResult> reportOutcome({
    required String projectId,
    required String methodologyId,
    required OutcomeType outcomeType,
    required Map<String, dynamic> data,
  }) async {
    // Build outcome based on type
    final outcome = _buildOutcomeFromType(outcomeType, data);

    // Ingest the outcome
    return ingestOutcome(
      projectId: projectId,
      methodologyId: methodologyId,
      stepId: 'manual_report',
      outcome: outcome,
    );
  }

  /// Update the engagement context with new information
  void _updateEngagementContext(Map<String, dynamic> outcome) {
    // Update discovered assets
    if (outcome['discovered_assets'] != null) {
      _engagementContext['all_assets'] ??= [];
      (_engagementContext['all_assets'] as List).addAll(outcome['discovered_assets']);
    }

    // Update captured hashes
    if (outcome['captured_hashes'] != null) {
      _engagementContext['captured_hashes'] ??= [];
      (_engagementContext['captured_hashes'] as List).addAll(outcome['captured_hashes']);
    }

    // Update valid credentials
    if (outcome['valid_credentials'] != null) {
      _engagementContext['valid_credentials'] ??= [];
      (_engagementContext['valid_credentials'] as List).addAll(outcome['valid_credentials']);
    }

    // Update admin access
    if (outcome['admin_access'] != null) {
      _engagementContext['admin_access'] ??= {};
      (_engagementContext['admin_access'] as Map).addAll(outcome['admin_access']);
    }

    // Update network information
    if (outcome['domain_identified'] != null) {
      _engagementContext['domain_identified'] = outcome['domain_identified'];
    }

    if (outcome['broadcast_protocols'] != null) {
      _engagementContext['broadcast_protocols'] = outcome['broadcast_protocols'];
    }

    if (outcome['live_hosts_count'] != null) {
      _engagementContext['live_hosts_count'] = outcome['live_hosts_count'];
    }

    // Track high-value discoveries
    if (outcome['domain_controllers'] != null) {
      _engagementContext['domain_controllers'] = outcome['domain_controllers'];
    }

    if (outcome['sql_servers'] != null) {
      _engagementContext['sql_servers'] = outcome['sql_servers'];
    }

    if (outcome['web_servers'] != null) {
      _engagementContext['web_servers'] = outcome['web_servers'];
    }

    // Update attack paths
    if (outcome['attack_paths_found'] != null) {
      _engagementContext['attack_paths_found'] = outcome['attack_paths_found'];
    }
  }

  /// Evaluate what methodologies should be triggered next
  List<MethodologyRecommendation> _evaluateNextSteps(
    String projectId,
    String completedMethodologyId,
    Map<String, dynamic> outcome,
  ) {
    final recommendations = <MethodologyRecommendation>[];

    // Get the completed methodology
    final methodology = _methodologyService.getMethodologyById(completedMethodologyId);
    if (methodology == null) return recommendations;

    // Use chain manager to evaluate next methodologies
    final nextMethodologies = _chainManager.evaluateNextMethodologies(
      completedMethodologyId,
      _engagementContext,
    );

    // Convert to recommendations
    for (final next in nextMethodologies) {
      final nextMethodology = _methodologyService.getMethodologyById(next.methodologyId);
      if (nextMethodology != null) {
        recommendations.add(MethodologyRecommendation(
          id: _uuid.v4(),
          projectId: projectId,
          methodologyId: next.methodologyId,
          reason: next.triggerReason,
          priority: next.priority,
          confidence: _calculateConfidence(next, outcome),
          context: next.context,
          createdDate: DateTime.now(),
          suggestedActions: _getSuggestedActions(nextMethodology, next.context),
        ));
      }
    }

    // Sort by priority and confidence
    recommendations.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.confidence.compareTo(a.confidence);
    });

    return recommendations;
  }

  /// Check for critical findings that need immediate attention
  List<CriticalFinding> _checkForCriticalFindings(Map<String, dynamic> outcome) {
    final findings = <CriticalFinding>[];

    // Check for domain admin access
    if (outcome['admin_access'] != null) {
      final adminAccess = outcome['admin_access'] as Map;
      for (final entry in adminAccess.entries) {
        if (entry.key.toString().toLowerCase().contains('dc') ||
            _engagementContext['domain_controllers']?.contains(entry.key) == true) {
          findings.add(CriticalFinding(
            severity: 'CRITICAL',
            finding: 'Domain Controller Administrative Access',
            details: 'Admin access achieved on domain controller ${entry.key}',
            recommendations: ['Establish persistence', 'Dump domain hashes', 'Document thoroughly'],
          ));
        }
      }
    }

    // Check for high-value credentials
    if (outcome['valid_credentials'] != null) {
      final creds = outcome['valid_credentials'] as List;
      for (final cred in creds) {
        if (cred['username']?.toString().toLowerCase().contains('admin') == true ||
            cred['username']?.toString().toLowerCase().contains('svc_') == true) {
          findings.add(CriticalFinding(
            severity: 'HIGH',
            finding: 'Privileged Account Compromised',
            details: 'Credentials obtained for ${cred['username']}',
            recommendations: ['Test access levels', 'Check for reuse', 'Enumerate privileges'],
          ));
        }
      }
    }

    // Check for SQL sysadmin
    if (outcome['sql_access_level']?['current_user'] == 'sysadmin') {
      findings.add(CriticalFinding(
        severity: 'HIGH',
        finding: 'SQL Server Sysadmin Access',
        details: 'Sysadmin privileges on SQL Server',
        recommendations: ['Enable xp_cmdshell', 'Check linked servers', 'Extract credentials'],
      ));
    }

    // Check for exploitable services
    if (outcome['broadcast_protocols']?.contains('LLMNR') == true &&
        (_engagementContext['valid_credentials'] as List?)?.isEmpty != false) {
      findings.add(CriticalFinding(
        severity: 'MEDIUM',
        finding: 'LLMNR Poisoning Possible',
        details: 'LLMNR protocol detected and no valid credentials yet',
        recommendations: ['Start Responder', 'Monitor for hashes', 'Prepare cracking setup'],
      ));
    }

    return findings;
  }

  /// Get methodologies that should be triggered based on outcome
  List<String> _getTriggeredMethodologies(Map<String, dynamic> outcome) {
    final triggered = <String>[];

    // Check each methodology's triggers
    for (final methodology in _methodologyService.methodologies) {
      for (final trigger in methodology.triggers) {
        if (_evaluateTrigger(trigger, outcome)) {
          triggered.add(methodology.id);
          break; // Only add once per methodology
        }
      }
    }

    return triggered;
  }

  /// Evaluate if a trigger condition is met
  bool _evaluateTrigger(MethodologyTrigger trigger, Map<String, dynamic> outcome) {
    switch (trigger.type) {
      case TriggerType.assetDiscovered:
        return _checkAssetTrigger(trigger.conditions, outcome);

      case TriggerType.customCondition:
        return _chainManager.evaluateCondition(
          trigger.conditions['condition']?.toString() ?? '',
          outcome,
        );

      default:
        return false;
    }
  }

  /// Check if asset-based trigger is met
  bool _checkAssetTrigger(Map<String, dynamic> conditions, Map<String, dynamic> outcome) {
    final assetType = conditions['asset_type'];
    final assets = outcome['discovered_assets'] as List?;

    if (assets == null || assets.isEmpty) return false;

    return assets.any((asset) => asset['type'] == assetType);
  }

  /// Calculate confidence score for a recommendation
  double _calculateConfidence(NextMethodology next, Map<String, dynamic> outcome) {
    double confidence = 0.7; // Base confidence

    // Increase confidence if multiple indicators present
    if (outcome['success'] == true) confidence += 0.1;
    if (outcome['critical'] == true) confidence += 0.15;
    if (next.priority > 8) confidence += 0.05;

    return confidence.clamp(0.0, 1.0);
  }

  /// Get suggested actions for a methodology
  List<String> _getSuggestedActions(Methodology methodology, Map<String, dynamic> context) {
    final actions = <String>[];

    for (final step in methodology.steps) {
      // Build action description
      String action = step.description;

      // Add relevant context
      if (context['target_host'] != null) {
        action += ' on ${context['target_host']}';
      }

      if (context['credentials'] != null) {
        action += ' using obtained credentials';
      }

      actions.add(action);
    }

    return actions;
  }

  /// Mark a methodology step as completed
  void _markStepCompleted(String projectId, String methodologyId, String stepId) {
    _completedMethodologies[projectId] ??= [];
    final key = '$methodologyId:$stepId';

    if (!_completedMethodologies[projectId]!.contains(key)) {
      _completedMethodologies[projectId]!.add(key);
    }
  }

  /// Build outcome from a predefined type
  Map<String, dynamic> _buildOutcomeFromType(OutcomeType type, Map<String, dynamic> data) {
    switch (type) {
      case OutcomeType.hashCaptured:
        return {
          'captured_hashes': [data],
          'poisoning_success': true,
        };

      case OutcomeType.credentialFound:
        return {
          'valid_credentials': [data],
          'credential_verified': false,
        };

      case OutcomeType.adminAccess:
        return {
          'admin_access': {data['host']: data['user']},
          'access_level': 'administrator',
        };

      case OutcomeType.vulnerabilityFound:
        return {
          'vulnerabilities': [data],
          'exploitable': data['exploitable'] ?? false,
        };

      case OutcomeType.hostDiscovered:
        return {
          'discovered_hosts': [data],
          'live_hosts_count': (_engagementContext['live_hosts_count'] ?? 0) + 1,
        };

      case OutcomeType.serviceIdentified:
        return {
          'services_found': {data['host']: data['ports']},
        };

      case OutcomeType.domainInfo:
        return {
          'domain_identified': data['domain'],
          'domain_controllers': data['dcs'] ?? [],
        };

      default:
        return data;
    }
  }

  /// Get current engagement context
  Map<String, dynamic> getEngagementContext() => Map.from(_engagementContext);

  /// Get ingestion history
  List<IngestionEvent> getIngestionHistory() => List.from(_ingestionHistory);

  /// Reset engagement context (for new engagement)
  void resetEngagement() {
    _engagementContext.clear();
    _ingestionHistory.clear();
    _completedMethodologies.clear();
  }
}

/// Types of outcomes that can be reported
enum OutcomeType {
  hashCaptured,
  credentialFound,
  adminAccess,
  vulnerabilityFound,
  hostDiscovered,
  serviceIdentified,
  domainInfo,
  custom,
}

/// Event representing an ingestion
class IngestionEvent {
  final String id;
  final String projectId;
  final String methodologyId;
  final String stepId;
  final Map<String, dynamic> outcome;
  final String? rawOutput;
  final DateTime timestamp;

  IngestionEvent({
    required this.id,
    required this.projectId,
    required this.methodologyId,
    required this.stepId,
    required this.outcome,
    this.rawOutput,
    required this.timestamp,
  });
}

/// Result of ingesting an outcome
class IngestionResult {
  final bool success;
  final List<MethodologyRecommendation> recommendations;
  final List<CriticalFinding> criticalFindings;
  final Map<String, dynamic> updatedContext;
  final List<String> triggeredMethodologies;

  IngestionResult({
    required this.success,
    required this.recommendations,
    required this.criticalFindings,
    required this.updatedContext,
    required this.triggeredMethodologies,
  });
}

/// Critical finding that needs attention
class CriticalFinding {
  final String severity;
  final String finding;
  final String details;
  final List<String> recommendations;

  CriticalFinding({
    required this.severity,
    required this.finding,
    required this.details,
    required this.recommendations,
  });
}