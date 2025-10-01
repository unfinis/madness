import 'dart:convert';
import '../models/finding.dart';

/// Utilities for exporting findings to various formats
class FindingExporter {
  /// Export a single finding to markdown
  Future<String> exportToMarkdown(Finding finding) async {
    final buffer = StringBuffer();

    // Title and metadata
    buffer.writeln('# ${finding.title}');
    buffer.writeln();
    buffer.writeln('**Severity:** ${finding.severity.displayName}');
    if (finding.cvssScore != null) {
      buffer.writeln('**CVSS Score:** ${finding.cvssScore}');
    }
    if (finding.cweId != null) {
      buffer.writeln('**CWE:** ${finding.cweId}');
    }
    buffer.writeln('**Status:** ${finding.status.displayName}');
    buffer.writeln('**Created:** ${_formatDate(finding.createdAt)}');
    buffer.writeln('**Updated:** ${_formatDate(finding.updatedAt)}');
    buffer.writeln();

    // Affected Systems
    if (finding.affectedSystems != null &&
        finding.affectedSystems!.isNotEmpty) {
      buffer.writeln('## Affected Systems');
      buffer.writeln();
      buffer.writeln(finding.affectedSystems);
      buffer.writeln();
    }

    // Description
    buffer.writeln('## Description');
    buffer.writeln();
    buffer.writeln(finding.description);
    buffer.writeln();

    // Remediation
    if (finding.remediation != null && finding.remediation!.isNotEmpty) {
      buffer.writeln('## Remediation');
      buffer.writeln();
      buffer.writeln(finding.remediation);
      buffer.writeln();
    }

    // References
    if (finding.references != null && finding.references!.isNotEmpty) {
      buffer.writeln('## References');
      buffer.writeln();
      buffer.writeln(finding.references);
      buffer.writeln();
    }

    return buffer.toString();
  }

  /// Export a single finding to HTML
  Future<String> exportToHtml(Finding finding) async {
    final markdown = await exportToMarkdown(finding);

    // Convert markdown to HTML (simplified)
    var html = markdown
        .replaceAllMapped(RegExp(r'^# (.+)$', multiLine: true),
            (m) => '<h1>${m.group(1)}</h1>')
        .replaceAllMapped(RegExp(r'^## (.+)$', multiLine: true),
            (m) => '<h2>${m.group(1)}</h2>')
        .replaceAllMapped(RegExp(r'^### (.+)$', multiLine: true),
            (m) => '<h3>${m.group(1)}</h3>')
        .replaceAllMapped(
            RegExp(r'\*\*(.+?)\*\*'), (m) => '<strong>${m.group(1)}</strong>')
        .replaceAllMapped(
            RegExp(r'\*(.+?)\*'), (m) => '<em>${m.group(1)}</em>')
        .replaceAllMapped(RegExp(r'`(.+?)`'), (m) => '<code>${m.group(1)}</code>')
        .replaceAll('\n\n', '</p><p>')
        .replaceAll('\n', '<br>');

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${finding.title}</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
            color: #333;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        h2 {
            color: #34495e;
            margin-top: 30px;
        }
        h3 {
            color: #7f8c8d;
        }
        code {
            background-color: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: "Courier New", monospace;
        }
        .severity-${finding.severity.name} {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-weight: bold;
            color: white;
            background-color: ${_getSeverityColor(finding.severity)};
        }
    </style>
</head>
<body>
    <p>$html</p>
</body>
</html>
''';
  }

  /// Export finding to JSON
  Future<String> exportToJson(Finding finding) async {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(finding.toJson());
  }

  /// Export multiple findings to markdown
  Future<String> exportMultipleFindingsToMarkdown(
      List<Finding> findings) async {
    final buffer = StringBuffer();

    buffer.writeln('# Security Findings Report');
    buffer.writeln();
    buffer.writeln('**Generated:** ${_formatDate(DateTime.now())}');
    buffer.writeln('**Total Findings:** ${findings.length}');
    buffer.writeln();

    // Summary by severity
    buffer.writeln('## Summary');
    buffer.writeln();
    final severityCounts = <FindingSeverity, int>{};
    for (final finding in findings) {
      severityCounts[finding.severity] =
          (severityCounts[finding.severity] ?? 0) + 1;
    }

    for (final severity in FindingSeverity.values) {
      final count = severityCounts[severity] ?? 0;
      if (count > 0) {
        buffer.writeln('- **${severity.displayName}:** $count');
      }
    }
    buffer.writeln();

    // Table of contents
    buffer.writeln('## Table of Contents');
    buffer.writeln();
    for (var i = 0; i < findings.length; i++) {
      buffer.writeln('${i + 1}. [${findings[i].title}](#finding-${i + 1})');
    }
    buffer.writeln();

    // Individual findings
    buffer.writeln('---');
    buffer.writeln();

    for (var i = 0; i < findings.length; i++) {
      buffer.writeln('<a name="finding-${i + 1}"></a>');
      buffer.writeln('## ${i + 1}. ${findings[i].title}');
      buffer.writeln();

      final findingMarkdown = await exportToMarkdown(findings[i]);
      // Remove the title line from individual finding export
      final lines = findingMarkdown.split('\n');
      buffer.writeln(lines.skip(2).join('\n'));

      buffer.writeln('---');
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getSeverityColor(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.critical:
        return '#9b59b6';
      case FindingSeverity.high:
        return '#e74c3c';
      case FindingSeverity.medium:
        return '#f39c12';
      case FindingSeverity.low:
        return '#f1c40f';
      case FindingSeverity.informational:
        return '#3498db';
    }
  }
}
