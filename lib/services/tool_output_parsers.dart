import 'dart:convert';
import '../models/assets.dart';

/// Base class for tool output parsers
abstract class ToolOutputParser {
  String get toolName;
  List<String> get supportedFormats; // e.g., ['json', 'xml', 'text']

  /// Parse tool output and extract asset information
  ParseResult parse(String output, {Map<String, dynamic>? context});

  /// Check if this parser can handle the given output
  bool canParse(String output);
}

/// Result of parsing tool output
class ParseResult {
  final bool success;
  final List<Asset> discoveredAssets;
  final List<AssetProperty> assetProperties;
  final List<ParsedFinding> findings;
  final Map<String, dynamic> metadata;
  final String? error;

  ParseResult({
    required this.success,
    this.discoveredAssets = const [],
    this.assetProperties = const [],
    this.findings = const [],
    this.metadata = const {},
    this.error,
  });

  factory ParseResult.failure(String error) {
    return ParseResult(success: false, error: error);
  }

  factory ParseResult.success({
    List<Asset>? assets,
    List<AssetProperty>? properties,
    List<ParsedFinding>? findings,
    Map<String, dynamic>? metadata,
  }) {
    return ParseResult(
      success: true,
      discoveredAssets: assets ?? [],
      assetProperties: properties ?? [],
      findings: findings ?? [],
      metadata: metadata ?? {},
    );
  }
}

/// Parsed asset property to be applied to an asset
class AssetProperty {
  final String assetId;
  final String propertyName;
  final AssetPropertyValue value;
  final DateTime discoveredAt;

  AssetProperty({
    required this.assetId,
    required this.propertyName,
    required this.value,
    required this.discoveredAt,
  });
}

/// Parsed finding from tool output
class ParsedFinding {
  final String title;
  final String description;
  final String severity; // low, medium, high, critical
  final String? cve;
  final Map<String, dynamic> evidence;
  final List<String> affectedAssets;

  ParsedFinding({
    required this.title,
    required this.description,
    required this.severity,
    this.cve,
    this.evidence = const {},
    this.affectedAssets = const [],
  });
}

/// Parser for Nmap XML output
class NmapXmlParser extends ToolOutputParser {
  @override
  String get toolName => 'nmap';

  @override
  List<String> get supportedFormats => ['xml'];

  @override
  bool canParse(String output) {
    return output.trim().startsWith('<?xml') &&
           output.contains('<nmaprun') &&
           output.contains('</nmaprun>');
  }

  @override
  ParseResult parse(String output, {Map<String, dynamic>? context}) {
    try {
      final assets = <Asset>[];
      final properties = <AssetProperty>[];
      final findings = <ParsedFinding>[];

      // Basic XML parsing (would use proper XML parser in production)
      final hostRegex = RegExp(r'<host[^>]*>.*?</host>', dotAll: true);
      final hosts = hostRegex.allMatches(output);

      for (final hostMatch in hosts) {
        final hostXml = hostMatch.group(0)!;

        // Extract IP address
        final ipRegex = RegExp(r'<address addr="([^"]+)" addrtype="ipv4"');
        final ipMatch = ipRegex.firstMatch(hostXml);
        if (ipMatch == null) continue;

        final ipAddress = ipMatch.group(1)!;

        // Extract hostname if available
        String? hostname;
        final hostnameRegex = RegExp(r'<hostname name="([^"]+)"');
        final hostnameMatch = hostnameRegex.firstMatch(hostXml);
        if (hostnameMatch != null) {
          hostname = hostnameMatch.group(1);
        }

        // Extract OS information
        String? osInfo;
        final osRegex = RegExp(r'<osmatch name="([^"]+)"');
        final osMatch = osRegex.firstMatch(hostXml);
        if (osMatch != null) {
          osInfo = osMatch.group(1);
        }

        // Create host asset
        final hostAsset = Asset(
          id: 'host-${ipAddress.replaceAll('.', '-')}',
          projectId: context?['projectId'] ?? '',
          name: hostname ?? ipAddress,
          type: AssetType.host,
          parentAssetIds: [],
          childAssetIds: [],
          relatedAssetIds: [],
          properties: {
            'ip_address': AssetPropertyValue.string(ipAddress),
            if (hostname != null) 'hostname': AssetPropertyValue.string(hostname),
            if (osInfo != null) 'operating_system': AssetPropertyValue.string(osInfo),
            'discovery_method': AssetPropertyValue.string('nmap'),
          },
          discoveryStatus: AssetDiscoveryStatus.discovered,
          discoveredAt: DateTime.now(),
          completedTriggers: [],
          triggerResults: {},
          tags: const ['nmap-discovered'],
        );

        assets.add(hostAsset);

        // Extract ports and services
        final portRegex = RegExp(r'<port protocol="([^"]+)" portid="([^"]+)"[^>]*>(.*?)</port>', dotAll: true);
        final ports = portRegex.allMatches(hostXml);

        for (final portMatch in ports) {
          final protocol = portMatch.group(1)!;
          final portId = portMatch.group(2)!;
          final portXml = portMatch.group(3)!;

          // Check if port is open
          if (!portXml.contains('state="open"')) continue;

          // Extract service information
          String? serviceName;
          String? serviceVersion;
          final serviceRegex = RegExp(r'<service name="([^"]*)"(?:[^>]*version="([^"]*)")?');
          final serviceMatch = serviceRegex.firstMatch(portXml);
          if (serviceMatch != null) {
            serviceName = serviceMatch.group(1);
            serviceVersion = serviceMatch.group(2);
          }

          // Create service asset
          final serviceAsset = Asset(
            id: 'service-${ipAddress.replaceAll('.', '-')}-$protocol-$portId',
            projectId: context?['projectId'] ?? '',
            name: '${serviceName ?? 'Unknown'} on $ipAddress:$portId',
            type: AssetType.service,
            parentAssetIds: [hostAsset.id],
            childAssetIds: [],
            relatedAssetIds: [],
            properties: {
              'host_ip': AssetPropertyValue.string(ipAddress),
              'port': AssetPropertyValue.integer(int.parse(portId)),
              'protocol': AssetPropertyValue.string(protocol),
              if (serviceName != null) 'service_name': AssetPropertyValue.string(serviceName),
              if (serviceVersion != null) 'service_version': AssetPropertyValue.string(serviceVersion),
              'state': AssetPropertyValue.string('open'),
              'discovery_method': AssetPropertyValue.string('nmap'),
            },
            discoveryStatus: AssetDiscoveryStatus.discovered,
            discoveredAt: DateTime.now(),
            completedTriggers: [],
            triggerResults: {},
            tags: const ['nmap-discovered'],
          );

          assets.add(serviceAsset);

          // Check for potential security issues
          if (_isKnownVulnerableService(serviceName, serviceVersion)) {
            findings.add(ParsedFinding(
              title: 'Potentially Vulnerable Service Detected',
              description: 'Service $serviceName ${serviceVersion ?? ''} on $ipAddress:$portId may have known vulnerabilities',
              severity: 'medium',
              evidence: {
                'service': serviceName,
                'version': serviceVersion,
                'port': portId,
                'host': ipAddress,
              },
              affectedAssets: [serviceAsset.id],
            ));
          }
        }
      }

      return ParseResult.success(
        assets: assets,
        properties: properties,
        findings: findings,
        metadata: {
          'parser': 'nmap_xml',
          'parsed_hosts': assets.where((a) => a.type == AssetType.host).length,
          'parsed_services': assets.where((a) => a.type == AssetType.service).length,
        },
      );
    } catch (e) {
      return ParseResult.failure('Failed to parse Nmap XML: $e');
    }
  }

  bool _isKnownVulnerableService(String? serviceName, String? version) {
    if (serviceName == null) return false;

    // Simple vulnerability checks (would be more comprehensive in production)
    final vulnerableServices = {
      'ssh': ['OpenSSH 7.4', 'OpenSSH 6.6'],
      'http': ['Apache 2.2', 'nginx 1.0'],
      'smb': ['Samba 3.x', 'Samba 4.0'],
    };

    final knownVulnerable = vulnerableServices[serviceName.toLowerCase()];
    if (knownVulnerable != null && version != null) {
      return knownVulnerable.any((vuln) => version.contains(vuln));
    }

    return false;
  }
}

/// Parser for Masscan JSON output
class MasscanJsonParser extends ToolOutputParser {
  @override
  String get toolName => 'masscan';

  @override
  List<String> get supportedFormats => ['json'];

  @override
  bool canParse(String output) {
    try {
      final decoded = jsonDecode(output);
      return decoded is List &&
             decoded.isNotEmpty &&
             decoded.first is Map &&
             decoded.first.containsKey('ip') &&
             decoded.first.containsKey('ports');
    } catch (e) {
      return false;
    }
  }

  @override
  ParseResult parse(String output, {Map<String, dynamic>? context}) {
    try {
      final decoded = jsonDecode(output) as List;
      final assets = <Asset>[];
      final hostAssets = <String, Asset>{};

      for (final entry in decoded) {
        if (entry is! Map<String, dynamic>) continue;

        final ip = entry['ip'] as String?;
        final ports = entry['ports'] as List?;
        if (ip == null || ports == null) continue;

        // Create or get host asset
        final hostId = 'host-${ip.replaceAll('.', '-')}';
        if (!hostAssets.containsKey(hostId)) {
          hostAssets[hostId] = Asset(
            id: hostId,
            projectId: context?['projectId'] ?? '',
            name: ip,
            type: AssetType.host,
            parentAssetIds: [],
            childAssetIds: [],
            relatedAssetIds: [],
            properties: {
              'ip_address': AssetPropertyValue.string(ip),
              'discovery_method': AssetPropertyValue.string('masscan'),
            },
            discoveryStatus: AssetDiscoveryStatus.discovered,
            discoveredAt: DateTime.now(),
            completedTriggers: [],
            triggerResults: {},
            tags: const ['masscan-discovered'],
          );
        }

        // Process ports
        for (final portEntry in ports) {
          if (portEntry is! Map<String, dynamic>) continue;

          final port = portEntry['port'] as int?;
          final protocol = portEntry['proto'] as String?;
          final status = portEntry['status'] as String?;

          if (port == null || protocol == null || status != 'open') continue;

          final serviceAsset = Asset(
            id: 'service-${ip.replaceAll('.', '-')}-$protocol-$port',
            projectId: context?['projectId'] ?? '',
            name: 'Port $port/$protocol on $ip',
            type: AssetType.service,
            parentAssetIds: [hostId],
            childAssetIds: [],
            relatedAssetIds: [],
            properties: {
              'host_ip': AssetPropertyValue.string(ip),
              'port': AssetPropertyValue.integer(port),
              'protocol': AssetPropertyValue.string(protocol),
              'state': AssetPropertyValue.string('open'),
              'discovery_method': AssetPropertyValue.string('masscan'),
            },
            discoveryStatus: AssetDiscoveryStatus.discovered,
            discoveredAt: DateTime.now(),
            completedTriggers: [],
            triggerResults: {},
            tags: const ['masscan-discovered'],
          );

          assets.add(serviceAsset);
        }
      }

      assets.addAll(hostAssets.values);

      return ParseResult.success(
        assets: assets,
        metadata: {
          'parser': 'masscan_json',
          'parsed_hosts': hostAssets.length,
          'parsed_services': assets.where((a) => a.type == AssetType.service).length,
        },
      );
    } catch (e) {
      return ParseResult.failure('Failed to parse Masscan JSON: $e');
    }
  }
}

/// Parser for Gobuster directory enumeration output
class GobusterParser extends ToolOutputParser {
  @override
  String get toolName => 'gobuster';

  @override
  List<String> get supportedFormats => ['text'];

  @override
  bool canParse(String output) {
    return output.contains('Status:') &&
           (output.contains('dir') || output.contains('dns') || output.contains('vhost'));
  }

  @override
  ParseResult parse(String output, {Map<String, dynamic>? context}) {
    try {
      final assets = <Asset>[];
      final properties = <AssetProperty>[];
      final findings = <ParsedFinding>[];

      final lines = output.split('\n');
      final webPaths = <String>[];

      for (final line in lines) {
        final trimmed = line.trim();
        if (!trimmed.contains('Status:')) continue;

        // Parse gobuster output line: /path (Status: 200) [Size: 1234]
        final pathRegex = RegExp(r'^([^\s]+)\s+\(Status:\s+(\d+)\)(?:\s+\[Size:\s+(\d+)\])?');
        final match = pathRegex.firstMatch(trimmed);
        if (match == null) continue;

        final path = match.group(1)!;
        final statusCode = int.parse(match.group(2)!);
        final size = match.group(3) != null ? int.parse(match.group(3)!) : null;

        if (statusCode >= 200 && statusCode < 400) {
          webPaths.add(path);

          // Check for interesting findings
          if (_isInterestingPath(path)) {
            findings.add(ParsedFinding(
              title: 'Interesting Web Path Discovered',
              description: 'Found potentially interesting web path: $path',
              severity: _getPathSeverity(path),
              evidence: {
                'path': path,
                'status_code': statusCode,
                'size': size,
                'discovery_method': 'gobuster',
              },
              affectedAssets: [],
            ));
          }
        }
      }

      // If we have a target URL context, update that asset
      final targetUrl = context?['target_url'] as String?;
      if (targetUrl != null && webPaths.isNotEmpty) {
        final hostFromUrl = Uri.tryParse(targetUrl)?.host;
        if (hostFromUrl != null) {
          properties.add(AssetProperty(
            assetId: 'host-${hostFromUrl.replaceAll('.', '-')}',
            propertyName: 'discovered_web_paths',
            value: AssetPropertyValue.stringList(webPaths),
            discoveredAt: DateTime.now(),
          ));
        }
      }

      return ParseResult.success(
        assets: assets,
        properties: properties,
        findings: findings,
        metadata: {
          'parser': 'gobuster',
          'discovered_paths': webPaths.length,
          'interesting_findings': findings.length,
        },
      );
    } catch (e) {
      return ParseResult.failure('Failed to parse Gobuster output: $e');
    }
  }

  bool _isInterestingPath(String path) {
    final interestingPaths = [
      '/admin', '/administrator', '/wp-admin', '/phpmyadmin',
      '/config', '/configuration', '/settings',
      '/backup', '/backups', '/old', '/test',
      '/git', '/.git', '/svn', '/.svn',
      '/api', '/api/v1', '/api/v2',
      '/login', '/signin', '/auth',
      '/debug', '/dev', '/development',
    ];

    return interestingPaths.any((interesting) =>
        path.toLowerCase().contains(interesting.toLowerCase()));
  }

  String _getPathSeverity(String path) {
    final highRiskPaths = ['/admin', '/phpmyadmin', '/.git', '/config'];
    final mediumRiskPaths = ['/backup', '/test', '/api', '/debug'];

    if (highRiskPaths.any((risk) => path.toLowerCase().contains(risk))) {
      return 'high';
    } else if (mediumRiskPaths.any((risk) => path.toLowerCase().contains(risk))) {
      return 'medium';
    }
    return 'low';
  }
}

/// Parser for Nikto vulnerability scanner output
class NiktoParser extends ToolOutputParser {
  @override
  String get toolName => 'nikto';

  @override
  List<String> get supportedFormats => ['text', 'json'];

  @override
  bool canParse(String output) {
    return (output.contains('- Nikto v') || output.contains('"vulnerabilities"')) &&
           (output.contains('Target IP:') || output.contains('"target"'));
  }

  @override
  ParseResult parse(String output, {Map<String, dynamic>? context}) {
    try {
      final findings = <ParsedFinding>[];

      // Try JSON format first
      if (output.trim().startsWith('{')) {
        return _parseJsonFormat(output, context);
      }

      // Parse text format
      final lines = output.split('\n');
      String? currentTarget;

      for (final line in lines) {
        final trimmed = line.trim();

        // Extract target
        if (trimmed.startsWith('+ Target IP:')) {
          final targetRegex = RegExp(r'Target IP:\s+([^\s]+)');
          final match = targetRegex.firstMatch(trimmed);
          if (match != null) {
            currentTarget = match.group(1);
          }
          continue;
        }

        // Parse findings
        if (trimmed.startsWith('+') && currentTarget != null) {
          final finding = _parseTextFinding(trimmed, currentTarget);
          if (finding != null) {
            findings.add(finding);
          }
        }
      }

      return ParseResult.success(
        findings: findings,
        metadata: {
          'parser': 'nikto',
          'target': currentTarget,
          'findings_count': findings.length,
        },
      );
    } catch (e) {
      return ParseResult.failure('Failed to parse Nikto output: $e');
    }
  }

  ParseResult _parseJsonFormat(String output, Map<String, dynamic>? context) {
    try {
      final decoded = jsonDecode(output) as Map<String, dynamic>;
      final vulnerabilities = decoded['vulnerabilities'] as List? ?? [];
      final target = decoded['target'] as String?;

      final findings = vulnerabilities.map((vuln) {
        final vulnMap = vuln as Map<String, dynamic>;
        return ParsedFinding(
          title: vulnMap['id'] as String? ?? 'Unknown Vulnerability',
          description: vulnMap['msg'] as String? ?? 'No description available',
          severity: _mapNiktoSeverity(vulnMap['osvdb'] as String?),
          evidence: {
            'nikto_id': vulnMap['id'],
            'osvdb': vulnMap['osvdb'],
            'method': vulnMap['method'],
            'url': vulnMap['url'],
          },
          affectedAssets: [],
        );
      }).toList();

      return ParseResult.success(
        findings: findings,
        metadata: {
          'parser': 'nikto_json',
          'target': target,
          'findings_count': findings.length,
        },
      );
    } catch (e) {
      return ParseResult.failure('Failed to parse Nikto JSON: $e');
    }
  }

  ParsedFinding? _parseTextFinding(String line, String target) {
    // Simple parsing of Nikto text output
    final parts = line.substring(1).split(':');
    if (parts.length < 2) return null;

    final title = parts[0].trim();
    final description = parts.sublist(1).join(':').trim();

    return ParsedFinding(
      title: title.isNotEmpty ? title : 'Nikto Finding',
      description: description,
      severity: _inferSeverityFromDescription(description),
      evidence: {
        'target': target,
        'raw_output': line,
      },
      affectedAssets: [],
    );
  }

  String _mapNiktoSeverity(String? osvdb) {
    // Map based on OSVDB ID (simplified)
    if (osvdb == null) return 'low';
    final id = int.tryParse(osvdb) ?? 0;

    if (id > 50000) return 'high';
    if (id > 20000) return 'medium';
    return 'low';
  }

  String _inferSeverityFromDescription(String description) {
    final lower = description.toLowerCase();

    if (lower.contains('admin') || lower.contains('password') ||
        lower.contains('sql injection') || lower.contains('remote code')) {
      return 'high';
    } else if (lower.contains('disclosure') || lower.contains('unauthorized') ||
               lower.contains('directory listing')) {
      return 'medium';
    }
    return 'low';
  }
}

/// Registry of all available parsers
class ToolOutputParserRegistry {
  static final List<ToolOutputParser> _parsers = [
    NmapXmlParser(),
    MasscanJsonParser(),
    GobusterParser(),
    NiktoParser(),
  ];

  /// Get all available parsers
  static List<ToolOutputParser> get allParsers => List.unmodifiable(_parsers);

  /// Find parsers that can handle the given output
  static List<ToolOutputParser> findParsers(String output) {
    return _parsers.where((parser) => parser.canParse(output)).toList();
  }

  /// Get parser by tool name
  static ToolOutputParser? getParserByTool(String toolName) {
    try {
      return _parsers.firstWhere((parser) =>
          parser.toolName.toLowerCase() == toolName.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  /// Parse output with the best matching parser
  static ParseResult parseOutput(String output, {Map<String, dynamic>? context}) {
    final parsers = findParsers(output);

    if (parsers.isEmpty) {
      return ParseResult.failure('No parser found for this output format');
    }

    // Try the first matching parser
    return parsers.first.parse(output, context: context);
  }

  /// Register a custom parser
  static void registerParser(ToolOutputParser parser) {
    _parsers.add(parser);
  }
}