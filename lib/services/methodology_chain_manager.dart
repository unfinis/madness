import 'dart:convert';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import 'methodology_service.dart';
import 'output_parser_service.dart';

/// Manages the chaining of methodologies based on execution results
class MethodologyChainManager {
  final MethodologyService _methodologyService;
  final OutputParserService _outputParser;

  MethodologyChainManager({
    MethodologyService? methodologyService,
    OutputParserService? outputParser,
  })  : _methodologyService = methodologyService ?? MethodologyService(),
        _outputParser = outputParser ?? OutputParserService();

  /// Evaluate if next methodologies should be triggered based on results
  List<NextMethodology> evaluateNextMethodologies(
    String completedMethodologyId,
    Map<String, dynamic> executionResults,
  ) {
    final methodology = _methodologyService.getMethodologyById(completedMethodologyId);
    if (methodology == null) return [];

    final triggeredMethodologies = <NextMethodology>[];

    // Check each next methodology condition
    for (final nextMethodology in methodology.nextMethodologyIds) {
      if (_shouldTriggerNextMethodology(nextMethodology, executionResults)) {
        triggeredMethodologies.add(NextMethodology(
          methodologyId: nextMethodology,
          triggerReason: 'Triggered by completion of $completedMethodologyId',
          context: _buildContextForNextMethodology(nextMethodology, executionResults),
          priority: _calculatePriority(nextMethodology, executionResults),
        ));
      }
    }

    return triggeredMethodologies;
  }

  /// Check if a methodology should be triggered based on conditions
  bool _shouldTriggerNextMethodology(
    String methodologyId,
    Map<String, dynamic> results,
  ) {
    // Get the methodology to check its trigger conditions
    final methodology = _methodologyService.getMethodologyById(methodologyId);
    if (methodology == null) return false;

    // For now, we'll use simple condition checking
    // In a full implementation, this would parse condition expressions

    // Example conditions that would be parsed from YAML:
    // - "captured_hashes.length > 0"
    // - "admin_access != null"
    // - "domain_identified != null"

    // Check for specific result patterns
    if (methodologyId.contains('hash_cracking')) {
      return _hasCaptures(results, 'captured_hashes');
    }

    if (methodologyId.contains('dns_enumeration')) {
      return results['domain_identified'] != null;
    }

    if (methodologyId.contains('llmnr_poisoning')) {
      final protocols = results['broadcast_protocols'] as List?;
      return protocols?.contains('LLMNR') ?? false;
    }

    if (methodologyId.contains('deploy_payload')) {
      return results['admin_access'] != null &&
             (results['admin_access'] as Map).isNotEmpty;
    }

    if (methodologyId.contains('bloodhound')) {
      return results['domain_identified'] != null &&
             results['beacon_established'] == true;
    }

    // Default: trigger if there were successful results
    return results['success'] == true || results['status'] == 'completed';
  }

  /// Build context for the next methodology
  Map<String, dynamic> _buildContextForNextMethodology(
    String methodologyId,
    Map<String, dynamic> results,
  ) {
    final context = <String, dynamic>{
      'previous_methodology_results': results,
      'timestamp': DateTime.now().toIso8601String(),
    };

    // Add specific context based on methodology type
    if (methodologyId.contains('hash_cracking')) {
      context['hashes'] = results['captured_hashes'];
    }

    if (methodologyId.contains('credential_testing')) {
      context['credentials'] = results['cracked_credentials'] ?? results['valid_credentials'];
    }

    if (methodologyId.contains('lateral_movement')) {
      context['targets'] = results['admin_access'] ?? results['accessible_hosts'];
    }

    if (methodologyId.contains('sql')) {
      context['sql_servers'] = results['sql_servers'];
      context['sql_credentials'] = _extractSqlCredentials(results);
    }

    return context;
  }

  /// Calculate priority for methodology execution
  int _calculatePriority(String methodologyId, Map<String, dynamic> results) {
    // Higher priority for critical findings
    if (results['admin_access'] != null && (results['admin_access'] as Map).isNotEmpty) {
      return 10; // Highest priority
    }

    if (results['captured_hashes'] != null && (results['captured_hashes'] as List).isNotEmpty) {
      return 8;
    }

    if (results['domain_controllers'] != null && (results['domain_controllers'] as List).isNotEmpty) {
      return 7;
    }

    if (results['sql_servers'] != null && (results['sql_servers'] as List).isNotEmpty) {
      return 6;
    }

    return 5; // Default priority
  }

  /// Check if results contain captures of a specific type
  bool _hasCaptures(Map<String, dynamic> results, String captureType) {
    final captures = results[captureType];
    if (captures == null) return false;
    if (captures is List) return captures.isNotEmpty;
    if (captures is Map) return captures.isNotEmpty;
    return false;
  }

  /// Extract SQL credentials from results
  List<Map<String, dynamic>> _extractSqlCredentials(Map<String, dynamic> results) {
    final sqlCreds = <Map<String, dynamic>>[];

    // Look for SQL credentials in various places
    final credentials = results['credentials_found'] as List?;
    if (credentials != null) {
      for (final cred in credentials) {
        if (cred is Map && (cred['context'] == 'SQL' || cred['type'] == 'sql')) {
          sqlCreds.add(Map<String, dynamic>.from(cred));
        }
      }
    }

    // Check browser credentials for SQL admin panels
    final browserCreds = results['browser_creds'] as List?;
    if (browserCreds != null) {
      for (final cred in browserCreds) {
        if (cred is Map && cred['url']?.toString().contains('sql') == true) {
          sqlCreds.add(Map<String, dynamic>.from(cred));
        }
      }
    }

    return sqlCreds;
  }

  /// Evaluate conditional expressions from methodology YAML
  bool evaluateCondition(String condition, Map<String, dynamic> context) {
    // Simple expression evaluator for conditions like:
    // - "captured_hashes.length > 0"
    // - "admin_access != null"
    // - "valid_credentials.length > 0 AND av_present.includes('CrowdStrike')"

    // Remove whitespace
    condition = condition.trim();

    // Handle "always" condition
    if (condition.toLowerCase() == 'always') return true;
    if (condition.toLowerCase() == 'never') return false;

    // Handle null checks
    if (condition.contains('!= null')) {
      final field = condition.split('!= null')[0].trim();
      return _getNestedValue(context, field) != null;
    }

    if (condition.contains('== null')) {
      final field = condition.split('== null')[0].trim();
      return _getNestedValue(context, field) == null;
    }

    // Handle length checks
    if (condition.contains('.length >')) {
      final parts = condition.split('.length >');
      final field = parts[0].trim();
      final value = int.tryParse(parts[1].trim()) ?? 0;

      final fieldValue = _getNestedValue(context, field);
      if (fieldValue is List) return fieldValue.length > value;
      if (fieldValue is Map) return fieldValue.length > value;
      if (fieldValue is String) return fieldValue.length > value;
      return false;
    }

    // Handle includes/contains
    if (condition.contains('.includes(')) {
      // Simple parsing for now: field.includes('value')
      final parts = condition.split('.includes(');
      if (parts.length == 2) {
        final field = parts[0].trim();
        final valuePart = parts[1].trim();
        // Extract value between quotes - simple string replacement
        final searchValue = valuePart.replaceAll(')', '').replaceAll("'", '').replaceAll('"', '').trim();
        final fieldValue = _getNestedValue(context, field);
        if (fieldValue is List) return fieldValue.contains(searchValue);
        if (fieldValue is String) return fieldValue.contains(searchValue);
      }
      return false;
    }

    // Handle boolean checks
    if (condition.contains('== true')) {
      final field = condition.split('== true')[0].trim();
      return _getNestedValue(context, field) == true;
    }

    if (condition.contains('== false')) {
      final field = condition.split('== false')[0].trim();
      return _getNestedValue(context, field) == false;
    }

    // Handle AND conditions
    if (condition.contains(' AND ')) {
      final parts = condition.split(' AND ');
      return parts.every((part) => evaluateCondition(part, context));
    }

    // Handle OR conditions
    if (condition.contains(' OR ')) {
      final parts = condition.split(' OR ');
      return parts.any((part) => evaluateCondition(part, context));
    }

    // Default: check if field exists and is truthy
    final value = _getNestedValue(context, condition);
    if (value == null) return false;
    if (value is bool) return value;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    if (value is String) return value.isNotEmpty;
    return true;
  }

  /// Get nested value from context using dot notation
  dynamic _getNestedValue(Map<String, dynamic> context, String path) {
    final parts = path.split('.');
    dynamic current = context;

    for (final part in parts) {
      if (current is Map) {
        // Handle array index notation like "hashes[0]"
        if (part.contains('[') && part.contains(']')) {
          final match = RegExp(r'(\w+)\[(\d+)\]').firstMatch(part);
          if (match != null) {
            final field = match.group(1)!;
            final index = int.parse(match.group(2)!);

            final arrayValue = current[field];
            if (arrayValue is List && index < arrayValue.length) {
              current = arrayValue[index];
            } else {
              return null;
            }
          } else {
            current = current[part];
          }
        } else {
          current = current[part];
        }
      } else {
        return null;
      }
    }

    return current;
  }
}

/// Represents a methodology that should be triggered next
class NextMethodology {
  final String methodologyId;
  final String triggerReason;
  final Map<String, dynamic> context;
  final int priority;

  NextMethodology({
    required this.methodologyId,
    required this.triggerReason,
    required this.context,
    this.priority = 5,
  });
}