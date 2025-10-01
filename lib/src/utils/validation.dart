import '../models/finding.dart';
import '../models/finding_template.dart';

/// Validation utilities for findings
class FindingValidator {
  /// Validate a finding and return validation result
  ValidationResult validateFinding(Finding finding) {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields
    if (finding.title.trim().isEmpty) {
      errors.add('Title is required');
    }

    if (finding.description.trim().isEmpty) {
      errors.add('Description is required');
    }

    // CVSS validation
    if (finding.cvssScore != null && finding.cvssScore!.isNotEmpty) {
      if (!isValidCVSS(finding.cvssScore!)) {
        warnings.add('CVSS score format may be invalid');
      }
    }

    // CWE validation
    if (finding.cweId != null && finding.cweId!.isNotEmpty) {
      if (!isValidCWE(finding.cweId!)) {
        warnings.add('CWE ID format may be invalid (expected: CWE-###)');
      }
    }

    // Completeness checks
    if (finding.remediation == null || finding.remediation!.trim().isEmpty) {
      warnings.add('Remediation section is empty');
    }

    if (finding.affectedSystems == null ||
        finding.affectedSystems!.trim().isEmpty) {
      warnings.add('Affected systems not specified');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  /// Validate CVSS score format
  bool isValidCVSS(String cvss) {
    // Simple CVSS score (0.0-10.0)
    final simpleScore = RegExp(r'^([0-9]|10)(\.[0-9])?$');
    if (simpleScore.hasMatch(cvss)) {
      final score = double.tryParse(cvss);
      return score != null && score >= 0 && score <= 10;
    }

    // CVSS vector string
    final vectorPattern = RegExp(
      r'^CVSS:3\.[01]/(AV:[NALP]|AC:[LH]|PR:[NLH]|UI:[NR]|S:[UC]|[CIA]:[NLH])+$',
    );
    return vectorPattern.hasMatch(cvss);
  }

  /// Validate CWE ID format
  bool isValidCWE(String cwe) {
    final pattern = RegExp(r'^CWE-\d+$', caseSensitive: false);
    return pattern.hasMatch(cwe);
  }

  /// Get list of missing required fields
  List<String> getMissingRequiredFields(
    Finding finding,
    FindingTemplate? template,
  ) {
    final missing = <String>[];

    if (finding.title.trim().isEmpty) {
      missing.add('title');
    }

    if (finding.description.trim().isEmpty) {
      missing.add('description');
    }

    // Check template-specific required variables
    if (template != null) {
      for (final variable in template.variables) {
        if (variable.required) {
          final value = finding.variables[variable.name];
          if (value == null || value.isEmpty) {
            missing.add('variable: ${variable.name}');
          }
        }
      }

      // Check custom fields
      for (final field in template.customFields) {
        if (field.required) {
          final value = finding.customFields[field.name];
          if (value == null || value.toString().isEmpty) {
            missing.add('custom field: ${field.name}');
          }
        }
      }
    }

    return missing;
  }

  /// Validate IP address format
  bool isValidIPAddress(String ip) {
    // IPv4
    final ipv4Pattern = RegExp(
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    if (ipv4Pattern.hasMatch(ip)) return true;

    // IPv6 (simplified)
    final ipv6Pattern = RegExp(
      r'^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$',
    );
    return ipv6Pattern.hasMatch(ip);
  }

  /// Validate URL format
  bool isValidURL(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.host.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}

/// Result of finding validation
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
  bool get isComplete => !hasErrors && !hasWarnings;
}
