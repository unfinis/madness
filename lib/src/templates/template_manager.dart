import 'package:uuid/uuid.dart';
import '../models/finding.dart';
import '../models/finding_template.dart';
import '../storage/template_repository.dart';

/// Manages template operations including applying templates to findings
class TemplateManager {
  final TemplateRepository _repository;

  TemplateManager(this._repository);

  /// Apply a template to create a new finding with variable substitution
  Future<Finding> applyTemplate(
    FindingTemplate template,
    Map<String, String> variableValues,
  ) async {
    final description = resolveVariables(
      template.descriptionTemplate,
      variableValues,
    );
    final remediation = resolveVariables(
      template.remediationTemplate,
      variableValues,
    );

    final severity = template.defaultSeverity != null
        ? FindingSeverity.values.firstWhere(
            (s) => s.name.toLowerCase() == template.defaultSeverity!.toLowerCase(),
            orElse: () => FindingSeverity.medium,
          )
        : FindingSeverity.medium;

    return Finding(
      id: const Uuid().v4(),
      title: template.name,
      description: description,
      severity: severity,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      cvssScore: template.defaultCvssScore,
      cweId: template.defaultCweId,
      remediation: remediation,
      templateId: template.id,
      variables: variableValues,
      status: FindingStatus.draft,
    );
  }

  /// Resolve template variables in text
  String resolveVariables(String template, Map<String, String> values) {
    var result = template;

    // Replace {{variable}} patterns with values
    for (final entry in values.entries) {
      final pattern = '{{${entry.key}}}';
      result = result.replaceAll(pattern, entry.value);
    }

    return result;
  }

  /// Extract variable names from template text
  List<String> extractVariables(String template) {
    final pattern = RegExp(r'\{\{(\w+)\}\}');
    final matches = pattern.allMatches(template);
    return matches.map((m) => m.group(1)!).toSet().toList();
  }

  /// Validate that all required variables have values
  bool validateVariables(
    FindingTemplate template,
    Map<String, String> values,
  ) {
    for (final variable in template.variables) {
      if (variable.required) {
        final value = values[variable.name];
        if (value == null || value.isEmpty) {
          return false;
        }
      }
    }
    return true;
  }

  /// Get missing required variables
  List<TemplateVariable> getMissingVariables(
    FindingTemplate template,
    Map<String, String> values,
  ) {
    return template.variables
        .where((variable) =>
            variable.required &&
            (values[variable.name] == null || values[variable.name]!.isEmpty))
        .toList();
  }

  /// Create a default SQL injection template
  static FindingTemplate createSqlInjectionTemplate() {
    return FindingTemplate(
      id: const Uuid().v4(),
      name: 'SQL Injection',
      category: 'Web Application',
      descriptionTemplate: '''
## Vulnerability Description

SQL injection vulnerabilities were identified in the {{application_name}} application at the endpoint {{endpoint}}. The vulnerable parameter {{parameter}} does not properly sanitize user input, allowing an attacker to inject arbitrary SQL commands.

## Impact

An attacker could exploit this vulnerability to:
- Extract sensitive data from the database
- Modify or delete data
- Bypass authentication mechanisms
- Execute administrative operations on the database

## Proof of Concept

The following payload was used to demonstrate the vulnerability:

```
{{payload}}
```

## Affected Systems

- Application: {{application_name}}
- URL: {{url}}
- Parameter: {{parameter}}
''',
      remediationTemplate: '''
## Remediation Steps

1. **Use Parameterized Queries**: Replace all dynamic SQL with parameterized queries or prepared statements.

2. **Input Validation**: Implement strict input validation for the {{parameter}} parameter:
   - Define expected data types and formats
   - Reject any input that doesn't match expected patterns
   - Use allowlists where possible

3. **Least Privilege**: Ensure database accounts used by the application have minimal necessary privileges.

4. **Web Application Firewall**: Deploy a WAF with rules to detect and block SQL injection attempts.

## Code Example

Replace vulnerable code like:
```sql
SELECT * FROM users WHERE username = '{{parameter}}'
```

With parameterized queries:
```sql
SELECT * FROM users WHERE username = ?
```
''',
      defaultSeverity: 'high',
      defaultCvssScore: '8.6',
      defaultCweId: 'CWE-89',
      variables: [
        const TemplateVariable(
          name: 'application_name',
          label: 'Application Name',
          type: VariableType.text,
          required: true,
          placeholder: 'e.g., Customer Portal',
        ),
        const TemplateVariable(
          name: 'endpoint',
          label: 'Vulnerable Endpoint',
          type: VariableType.text,
          required: true,
          placeholder: 'e.g., /api/search',
        ),
        const TemplateVariable(
          name: 'parameter',
          label: 'Vulnerable Parameter',
          type: VariableType.text,
          required: true,
          placeholder: 'e.g., query',
        ),
        const TemplateVariable(
          name: 'payload',
          label: 'Exploit Payload',
          type: VariableType.multiline,
          required: true,
          placeholder: "e.g., ' OR '1'='1",
        ),
        const TemplateVariable(
          name: 'url',
          label: 'Full URL',
          type: VariableType.url,
          required: true,
          placeholder: 'e.g., https://example.com/search',
        ),
      ],
      isCustom: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create a default XSS template
  static FindingTemplate createXssTemplate() {
    return FindingTemplate(
      id: const Uuid().v4(),
      name: 'Cross-Site Scripting (XSS)',
      category: 'Web Application',
      descriptionTemplate: '''
## Vulnerability Description

A {{xss_type}} Cross-Site Scripting (XSS) vulnerability was discovered in {{application_name}} at {{location}}. User-supplied input is not properly sanitized before being rendered in the application, allowing an attacker to inject malicious JavaScript code.

## Impact

This vulnerability could allow an attacker to:
- Steal session cookies and tokens
- Perform actions on behalf of the victim
- Redirect users to malicious sites
- Deface the web page
- Capture keystrokes and sensitive data

## Proof of Concept

Payload: `{{payload}}`

When this payload is injected into {{parameter}}, the JavaScript executes in the victim's browser.
''',
      remediationTemplate: '''
## Remediation Steps

1. **Output Encoding**: Encode all user-supplied data before rendering:
   - HTML entity encoding for HTML context
   - JavaScript encoding for JavaScript context
   - URL encoding for URL context

2. **Content Security Policy**: Implement a strict CSP header to prevent inline script execution.

3. **Input Validation**: Validate and sanitize all user input on the server side.

4. **Use Security Libraries**: Utilize framework-provided functions for safe rendering (e.g., React's JSX, Angular's template binding).

## Example CSP Header
```
Content-Security-Policy: default-src 'self'; script-src 'self'; object-src 'none'
```
''',
      defaultSeverity: 'medium',
      defaultCvssScore: '6.1',
      defaultCweId: 'CWE-79',
      variables: [
        const TemplateVariable(
          name: 'application_name',
          label: 'Application Name',
          type: VariableType.text,
          required: true,
        ),
        const TemplateVariable(
          name: 'xss_type',
          label: 'XSS Type',
          type: VariableType.dropdown,
          required: true,
          options: ['Reflected', 'Stored', 'DOM-based'],
          defaultValue: 'Reflected',
        ),
        const TemplateVariable(
          name: 'location',
          label: 'Vulnerable Location',
          type: VariableType.text,
          required: true,
          placeholder: 'e.g., search results page',
        ),
        const TemplateVariable(
          name: 'parameter',
          label: 'Vulnerable Parameter',
          type: VariableType.text,
          required: true,
        ),
        const TemplateVariable(
          name: 'payload',
          label: 'XSS Payload',
          type: VariableType.text,
          required: true,
          defaultValue: '<script>alert(document.domain)</script>',
        ),
      ],
      isCustom: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
