/// Enhanced methodology model with detailed execution information
class MethodologyDetail {
  final String id;
  final String title;
  final String uniqueId;
  final String overview;
  final String purpose;
  final List<MethodologyCommand> commands;
  final List<CleanupStep> cleanupSteps;
  final List<CommonIssue> commonIssues;
  final List<RelatedFinding> relatedFindings;
  final Map<String, dynamic> metadata;

  const MethodologyDetail({
    required this.id,
    required this.title,
    required this.uniqueId,
    required this.overview,
    required this.purpose,
    this.commands = const [],
    this.cleanupSteps = const [],
    this.commonIssues = const [],
    this.relatedFindings = const [],
    this.metadata = const {},
  });

  MethodologyDetail copyWith({
    String? id,
    String? title,
    String? uniqueId,
    String? overview,
    String? purpose,
    List<MethodologyCommand>? commands,
    List<CleanupStep>? cleanupSteps,
    List<CommonIssue>? commonIssues,
    List<RelatedFinding>? relatedFindings,
    Map<String, dynamic>? metadata,
  }) {
    return MethodologyDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      uniqueId: uniqueId ?? this.uniqueId,
      overview: overview ?? this.overview,
      purpose: purpose ?? this.purpose,
      commands: commands ?? this.commands,
      cleanupSteps: cleanupSteps ?? this.cleanupSteps,
      commonIssues: commonIssues ?? this.commonIssues,
      relatedFindings: relatedFindings ?? this.relatedFindings,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Command information for methodology execution
class MethodologyCommand {
  final String id;
  final String title;
  final String description;
  final String primaryCommand;
  final List<AlternativeCommand> alternatives;
  final ShellType defaultShell;
  final DownloadMethod? downloadMethod;
  final Map<String, String> variables;
  final List<String> prerequisites;
  final String? expectedOutput;
  final Duration? estimatedDuration;

  const MethodologyCommand({
    required this.id,
    required this.title,
    required this.description,
    required this.primaryCommand,
    this.alternatives = const [],
    this.defaultShell = ShellType.bash,
    this.downloadMethod,
    this.variables = const {},
    this.prerequisites = const [],
    this.expectedOutput,
    this.estimatedDuration,
  });

  MethodologyCommand copyWith({
    String? id,
    String? title,
    String? description,
    String? primaryCommand,
    List<AlternativeCommand>? alternatives,
    ShellType? defaultShell,
    DownloadMethod? downloadMethod,
    Map<String, String>? variables,
    List<String>? prerequisites,
    String? expectedOutput,
    Duration? estimatedDuration,
  }) {
    return MethodologyCommand(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      primaryCommand: primaryCommand ?? this.primaryCommand,
      alternatives: alternatives ?? this.alternatives,
      defaultShell: defaultShell ?? this.defaultShell,
      downloadMethod: downloadMethod ?? this.downloadMethod,
      variables: variables ?? this.variables,
      prerequisites: prerequisites ?? this.prerequisites,
      expectedOutput: expectedOutput ?? this.expectedOutput,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
    );
  }

  /// Get command with variables substituted
  String getResolvedCommand(Map<String, String> context) {
    String resolved = primaryCommand;

    // Substitute variables from context first, then defaults
    final allVars = Map<String, String>.from(variables);
    allVars.addAll(context);

    for (final entry in allVars.entries) {
      resolved = resolved.replaceAll('{${entry.key}}', entry.value);
    }

    return resolved;
  }
}

/// Alternative command options
class AlternativeCommand {
  final String command;
  final String description;
  final ShellType shell;
  final String? reason; // Why you might use this alternative

  const AlternativeCommand({
    required this.command,
    required this.description,
    required this.shell,
    this.reason,
  });
}

/// Shell types for command execution
enum ShellType {
  bash,
  powershell,
  cmd,
  python,
  ruby,
  nodejs;

  String get displayName {
    switch (this) {
      case ShellType.bash:
        return 'Bash';
      case ShellType.powershell:
        return 'PowerShell';
      case ShellType.cmd:
        return 'Command Prompt';
      case ShellType.python:
        return 'Python';
      case ShellType.ruby:
        return 'Ruby';
      case ShellType.nodejs:
        return 'Node.js';
    }
  }

  String get extension {
    switch (this) {
      case ShellType.bash:
        return '.sh';
      case ShellType.powershell:
        return '.ps1';
      case ShellType.cmd:
        return '.bat';
      case ShellType.python:
        return '.py';
      case ShellType.ruby:
        return '.rb';
      case ShellType.nodejs:
        return '.js';
    }
  }
}

/// Download methods for obtaining tools/payloads
enum DownloadMethod {
  curl,
  wget,
  fetch,
  invokeWebRequest,
  certutil,
  bitsadmin,
  powershellDownload,
  python,
  manual;

  String get displayName {
    switch (this) {
      case DownloadMethod.curl:
        return 'cURL';
      case DownloadMethod.wget:
        return 'wget';
      case DownloadMethod.fetch:
        return 'fetch (JavaScript)';
      case DownloadMethod.invokeWebRequest:
        return 'Invoke-WebRequest';
      case DownloadMethod.certutil:
        return 'certutil';
      case DownloadMethod.bitsadmin:
        return 'bitsadmin';
      case DownloadMethod.powershellDownload:
        return 'PowerShell DownloadFile';
      case DownloadMethod.python:
        return 'Python requests';
      case DownloadMethod.manual:
        return 'Manual Download';
    }
  }

  String getDownloadCommand(String url, String outputPath) {
    switch (this) {
      case DownloadMethod.curl:
        return 'curl -o "$outputPath" "$url"';
      case DownloadMethod.wget:
        return 'wget -O "$outputPath" "$url"';
      case DownloadMethod.invokeWebRequest:
        return 'Invoke-WebRequest -Uri "$url" -OutFile "$outputPath"';
      case DownloadMethod.certutil:
        return 'certutil -urlcache -split -f "$url" "$outputPath"';
      case DownloadMethod.bitsadmin:
        return 'bitsadmin /transfer myDownloadJob /download /priority normal "$url" "$outputPath"';
      case DownloadMethod.powershellDownload:
        return '(New-Object Net.WebClient).DownloadFile("$url", "$outputPath")';
      case DownloadMethod.python:
        return 'python -c "import requests; open(\'$outputPath\', \'wb\').write(requests.get(\'$url\').content)"';
      default:
        return 'Manual download required from: $url';
    }
  }
}

/// Cleanup steps to perform after methodology execution
class CleanupStep {
  final String id;
  final String title;
  final String description;
  final String command;
  final ShellType shell;
  final CleanupPriority priority;
  final bool required;

  const CleanupStep({
    required this.id,
    required this.title,
    required this.description,
    required this.command,
    required this.shell,
    this.priority = CleanupPriority.medium,
    this.required = false,
  });
}

/// Priority levels for cleanup steps
enum CleanupPriority {
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case CleanupPriority.low:
        return 'Low';
      case CleanupPriority.medium:
        return 'Medium';
      case CleanupPriority.high:
        return 'High';
      case CleanupPriority.critical:
        return 'Critical';
    }
  }

  String get description {
    switch (this) {
      case CleanupPriority.low:
        return 'Optional cleanup - nice to have';
      case CleanupPriority.medium:
        return 'Recommended cleanup';
      case CleanupPriority.high:
        return 'Important cleanup - should be done';
      case CleanupPriority.critical:
        return 'Critical cleanup - must be done';
    }
  }
}

/// Common issues and their resolutions
class CommonIssue {
  final String id;
  final String title;
  final String description;
  final String symptom;
  final List<String> possibleCauses;
  final List<Resolution> resolutions;
  final IssueSeverity severity;

  const CommonIssue({
    required this.id,
    required this.title,
    required this.description,
    required this.symptom,
    this.possibleCauses = const [],
    this.resolutions = const [],
    this.severity = IssueSeverity.medium,
  });
}

/// Resolution for a common issue
class Resolution {
  final String description;
  final String? command;
  final ShellType? shell;
  final List<String> steps;

  const Resolution({
    required this.description,
    this.command,
    this.shell,
    this.steps = const [],
  });
}

/// Severity levels for issues
enum IssueSeverity {
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case IssueSeverity.low:
        return 'Low';
      case IssueSeverity.medium:
        return 'Medium';
      case IssueSeverity.high:
        return 'High';
      case IssueSeverity.critical:
        return 'Critical';
    }
  }
}

/// Related findings that can be documented
class RelatedFinding {
  final String id;
  final String title;
  final String description;
  final FindingSeverity severity;
  final String? cveId;
  final List<String> affectedSystems;

  const RelatedFinding({
    required this.id,
    required this.title,
    required this.description,
    this.severity = FindingSeverity.informational,
    this.cveId,
    this.affectedSystems = const [],
  });
}

/// Severity levels for findings
enum FindingSeverity {
  informational,
  low,
  medium,
  high,
  critical;

  String get displayName {
    switch (this) {
      case FindingSeverity.informational:
        return 'Informational';
      case FindingSeverity.low:
        return 'Low';
      case FindingSeverity.medium:
        return 'Medium';
      case FindingSeverity.high:
        return 'High';
      case FindingSeverity.critical:
        return 'Critical';
    }
  }
}

/// Outcome capture for methodology execution
class MethodologyOutcome {
  final String id;
  final String methodologyId;
  final String stepId;
  final DateTime timestamp;
  final OutcomeStatus status;
  final String? output;
  final String? errorOutput;
  final Duration? executionTime;
  final Map<String, dynamic> capturedData;
  final List<String> discoveredAssets;
  final String? notes;

  const MethodologyOutcome({
    required this.id,
    required this.methodologyId,
    required this.stepId,
    required this.timestamp,
    required this.status,
    this.output,
    this.errorOutput,
    this.executionTime,
    this.capturedData = const {},
    this.discoveredAssets = const [],
    this.notes,
  });
}

/// Status of methodology outcome
enum OutcomeStatus {
  success,
  partial,
  failed,
  skipped,
  blocked;

  String get displayName {
    switch (this) {
      case OutcomeStatus.success:
        return 'Success';
      case OutcomeStatus.partial:
        return 'Partial Success';
      case OutcomeStatus.failed:
        return 'Failed';
      case OutcomeStatus.skipped:
        return 'Skipped';
      case OutcomeStatus.blocked:
        return 'Blocked';
    }
  }
}