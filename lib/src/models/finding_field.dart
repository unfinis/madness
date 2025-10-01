/// Metadata for finding fields used in forms and validation
class FindingFieldMetadata {
  final String name;
  final String label;
  final bool required;
  final String? helpText;
  final int? maxLength;

  const FindingFieldMetadata({
    required this.name,
    required this.label,
    this.required = false,
    this.helpText,
    this.maxLength,
  });
}

/// Common finding field definitions
class FindingFields {
  static const title = FindingFieldMetadata(
    name: 'title',
    label: 'Finding Title',
    required: true,
    helpText: 'A concise, descriptive title for the finding',
    maxLength: 200,
  );

  static const description = FindingFieldMetadata(
    name: 'description',
    label: 'Description',
    required: true,
    helpText: 'Detailed description of the security finding',
  );

  static const severity = FindingFieldMetadata(
    name: 'severity',
    label: 'Severity',
    required: true,
    helpText: 'Risk level of the finding',
  );

  static const cvssScore = FindingFieldMetadata(
    name: 'cvssScore',
    label: 'CVSS Score',
    helpText: 'Common Vulnerability Scoring System score (e.g., CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)',
  );

  static const cweId = FindingFieldMetadata(
    name: 'cweId',
    label: 'CWE ID',
    helpText: 'Common Weakness Enumeration identifier (e.g., CWE-79)',
  );

  static const affectedSystems = FindingFieldMetadata(
    name: 'affectedSystems',
    label: 'Affected Systems',
    helpText: 'Systems, applications, or components affected by this finding',
  );

  static const remediation = FindingFieldMetadata(
    name: 'remediation',
    label: 'Remediation',
    helpText: 'Steps to fix or mitigate the finding',
  );

  static const references = FindingFieldMetadata(
    name: 'references',
    label: 'References',
    helpText: 'Links to relevant documentation, CVEs, or resources',
  );

  static const allFields = [
    title,
    description,
    severity,
    cvssScore,
    cweId,
    affectedSystems,
    remediation,
    references,
  ];
}
