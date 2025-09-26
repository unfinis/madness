import '../models/methodology_execution.dart';

/// Service for parsing command outputs and extracting structured data
class OutputParserService {
  static final OutputParserService _instance = OutputParserService._internal();
  factory OutputParserService() => _instance;
  OutputParserService._internal();

  /// Parse output based on the parser type
  Map<String, dynamic> parseOutput(String output, String parserType) {
    switch (parserType.toLowerCase()) {
      case 'nmap':
        return _parseNmapOutput(output);
      case 'arp-scan':
        return _parseArpScanOutput(output);
      case 'tcpdump':
        return _parseTcpdumpOutput(output);
      case 'responder':
        return _parseResponderOutput(output);
      case 'crackmapexec':
      case 'cme':
        return _parseCrackMapExecOutput(output);
      case 'enum4linux':
        return _parseEnum4LinuxOutput(output);
      case 'bloodhound':
        return _parseBloodHoundOutput(output);
      case 'hashcat':
        return _parseHashcatOutput(output);
      case 'mimikatz':
        return _parseMimikatzOutput(output);
      case 'smbclient':
        return _parseSmbClientOutput(output);
      case 'dns':
        return _parseDnsOutput(output);
      case 'sql':
        return _parseSqlOutput(output);
      default:
        return _parseGenericOutput(output);
    }
  }

  /// Convert parsed output to discovered assets
  List<DiscoveredAsset> extractAssets(Map<String, dynamic> parsedOutput, String parserType) {
    final assets = <DiscoveredAsset>[];

    switch (parserType.toLowerCase()) {
      case 'nmap':
        assets.addAll(_extractNmapAssets(parsedOutput));
        break;
      case 'arp-scan':
        assets.addAll(_extractArpScanAssets(parsedOutput));
        break;
      case 'tcpdump':
        assets.addAll(_extractTcpdumpAssets(parsedOutput));
        break;
      case 'responder':
        assets.addAll(_extractResponderAssets(parsedOutput));
        break;
      case 'crackmapexec':
        assets.addAll(_extractCmeAssets(parsedOutput));
        break;
      case 'enum4linux':
        assets.addAll(_extractEnum4LinuxAssets(parsedOutput));
        break;
      case 'hashcat':
        assets.addAll(_extractHashcatAssets(parsedOutput));
        break;
    }

    return assets;
  }

  /// Parse Nmap output
  Map<String, dynamic> _parseNmapOutput(String output) {
    final result = <String, dynamic>{
      'hosts': [],
      'services': {},
      'os_detection': {},
      'scan_stats': {}
    };

    // Parse hosts and ports
    final hostRegex = RegExp(r'Nmap scan report for ([\w\.-]+)\s*(?:\(([\d\.]+)\))?');
    final portRegex = RegExp(r'(\d+)/(tcp|udp)\s+(\w+)\s+(.+)');
    final osRegex = RegExp(r'OS details?: (.+)');

    String? currentHost;
    for (final line in output.split('\n')) {
      // Check for new host
      final hostMatch = hostRegex.firstMatch(line);
      if (hostMatch != null) {
        currentHost = hostMatch.group(2) ?? hostMatch.group(1)!;
        result['hosts'].add(currentHost);
        result['services'][currentHost] = [];
        continue;
      }

      // Parse ports for current host
      if (currentHost != null) {
        final portMatch = portRegex.firstMatch(line);
        if (portMatch != null) {
          result['services'][currentHost].add({
            'port': int.parse(portMatch.group(1)!),
            'protocol': portMatch.group(2),
            'state': portMatch.group(3),
            'service': portMatch.group(4)?.trim(),
          });
        }

        // Check for OS detection
        final osMatch = osRegex.firstMatch(line);
        if (osMatch != null) {
          result['os_detection'][currentHost] = osMatch.group(1);
        }
      }
    }

    // Extract SMB hosts, web servers, SQL servers
    result['smb_hosts'] = [];
    result['web_servers'] = [];
    result['sql_servers'] = [];
    result['domain_controllers'] = [];

    for (final entry in result['services'].entries) {
      final host = entry.key;
      final services = entry.value as List;

      // Check for SMB
      if (services.any((s) => [139, 445].contains(s['port']))) {
        result['smb_hosts'].add(host);
      }

      // Check for web services
      final webPorts = services
          .where((s) => [80, 443, 8080, 8443].contains(s['port']))
          .map((s) => s['port'])
          .toList();
      if (webPorts.isNotEmpty) {
        result['web_servers'].add({'ip': host, 'ports': webPorts});
      }

      // Check for SQL
      if (services.any((s) => [1433, 3306, 5432].contains(s['port']))) {
        result['sql_servers'].add(host);
      }

      // Check for domain controller indicators
      final dcPorts = [53, 88, 389, 636, 445, 464];
      final dcServiceCount = services.where((s) => dcPorts.contains(s['port'])).length;
      if (dcServiceCount >= 4) {
        result['domain_controllers'].add(host);
      }
    }

    return result;
  }

  /// Parse ARP scan output
  Map<String, dynamic> _parseArpScanOutput(String output) {
    final result = <String, dynamic>{
      'live_hosts': [],
      'live_hosts_count': 0,
      'subnet_density': 'low',
      'interesting_macs': []
    };

    final ipRegex = RegExp(r'([\d\.]+)\s+([\da-fA-F:]+)\s+(.+)?');

    for (final line in output.split('\n')) {
      final match = ipRegex.firstMatch(line);
      if (match != null) {
        final ip = match.group(1)!;
        final mac = match.group(2)!;
        final vendor = match.group(3)?.trim() ?? '';

        result['live_hosts'].add({
          'ip': ip,
          'mac': mac,
          'vendor': vendor
        });

        // Check for interesting vendors
        final interestingVendors = ['VMware', 'Cisco', 'Printer', 'Dell', 'HP'];
        if (interestingVendors.any((v) => vendor.contains(v))) {
          result['interesting_macs'].add({'mac': mac, 'vendor': vendor});
        }
      }
    }

    result['live_hosts_count'] = result['live_hosts'].length;

    // Determine subnet density
    final count = result['live_hosts_count'] as int;
    if (count > 100) {
      result['subnet_density'] = 'high';
    } else if (count > 20) {
      result['subnet_density'] = 'medium';
    } else {
      result['subnet_density'] = 'low';
    }

    return result;
  }

  /// Parse tcpdump output for broadcast protocols
  Map<String, dynamic> _parseTcpdumpOutput(String output) {
    final result = <String, dynamic>{
      'broadcast_protocols': <String>[],
      'domain_identified': null,
      'vlans_discovered': <int>[],
      'protocol_traffic': <String>[],
      'dc_indicators': <String>[],
      'hostnames_pattern': null
    };

    // Unique sets to avoid duplicates
    final protocols = <String>{};
    final vlans = <int>{};
    final traffic = <String>{};
    final hostnames = <String>[];

    for (final line in output.split('\n')) {
      // Check for LLMNR
      if (line.contains('LLMNR') || line.contains('5355')) {
        protocols.add('LLMNR');
      }

      // Check for NBT-NS
      if (line.contains('NBT-NS') || line.contains('137')) {
        protocols.add('NBT-NS');
      }

      // Check for mDNS
      if (line.contains('mDNS') || line.contains('5353')) {
        protocols.add('mDNS');
      }

      // Check for Browser protocol
      if (line.contains('Browser') || line.contains('138')) {
        protocols.add('Browser');
      }

      // Extract domain from LDAP/Kerberos traffic
      final domainMatch = RegExp(r'(?:LDAP|Kerberos).*?([A-Z]+(?:\.[A-Z]+)+)').firstMatch(line);
      if (domainMatch != null && result['domain_identified'] == null) {
        result['domain_identified'] = domainMatch.group(1);
      }

      // Extract VLAN tags
      final vlanMatch = RegExp(r'vlan (\d+)').firstMatch(line);
      if (vlanMatch != null) {
        vlans.add(int.parse(vlanMatch.group(1)!));
      }

      // Identify protocol traffic
      if (line.contains('SMB') || line.contains('445')) traffic.add('SMB');
      if (line.contains('HTTP') || line.contains(':80 ')) traffic.add('HTTP');
      if (line.contains('HTTPS') || line.contains(':443 ')) traffic.add('HTTPS');
      if (line.contains('LDAP') || line.contains('389')) traffic.add('LDAP');
      if (line.contains('RDP') || line.contains('3389')) traffic.add('RDP');

      // Extract hostnames
      final hostnameMatch = RegExp(r'((?:DESK|LAPTOP|SRV|DC|PC)-[\w]+)').firstMatch(line);
      if (hostnameMatch != null) {
        hostnames.add(hostnameMatch.group(1)!);
      }

      // DC indicators (NTP/DNS to specific IPs)
      if ((line.contains('NTP') || line.contains('DNS')) && line.contains('>')) {
        final ipMatch = RegExp(r'> ([\d\.]+)').firstMatch(line);
        if (ipMatch != null) {
          result['dc_indicators'].add(ipMatch.group(1)!);
        }
      }
    }

    result['broadcast_protocols'] = protocols.toList();
    result['vlans_discovered'] = vlans.toList();
    result['protocol_traffic'] = traffic.toList();

    // Determine hostname pattern
    if (hostnames.isNotEmpty) {
      if (hostnames.any((h) => h.startsWith('DESK'))) {
        result['hostnames_pattern'] = 'DESK-XXX';
      } else if (hostnames.any((h) => h.startsWith('LAPTOP'))) {
        result['hostnames_pattern'] = 'LAPTOP-XXX';
      }
    }

    return result;
  }

  /// Parse Responder output for captured hashes
  Map<String, dynamic> _parseResponderOutput(String output) {
    final result = <String, dynamic>{
      'captured_hashes': [],
      'poisoning_success': false,
      'time_to_capture': null
    };

    final hashRegex = RegExp(r'\[([^\]]+)\].*?(NTLMv\d).*?([^:]+)::([^:]+):([a-fA-F0-9]+):([a-fA-F0-9]+)');
    final timeRegex = RegExp(r'(\d+)(?:m|min|minutes?)');

    for (final line in output.split('\n')) {
      final hashMatch = hashRegex.firstMatch(line);
      if (hashMatch != null) {
        result['captured_hashes'].add({
          'timestamp': hashMatch.group(1),
          'type': hashMatch.group(2),
          'user': '${hashMatch.group(4)}\\${hashMatch.group(3)}',
          'hash': '${hashMatch.group(5)}:${hashMatch.group(6)}',
        });
        result['poisoning_success'] = true;
      }

      // Extract time to capture
      if (line.contains('captured') || line.contains('obtained')) {
        final timeMatch = timeRegex.firstMatch(line);
        if (timeMatch != null) {
          result['time_to_capture'] = '${timeMatch.group(1)}min';
        }
      }
    }

    return result;
  }

  /// Parse CrackMapExec output
  Map<String, dynamic> _parseCrackMapExecOutput(String output) {
    final result = <String, dynamic>{
      'admin_access': {},
      'read_access': {},
      'no_access': [],
      'null_session_access': {},
      'shares_readable': {},
      'signing_required': {},
      'valid_credentials': []
    };

    final lines = output.split('\n');
    String? currentHost;

    for (final line in lines) {
      // Extract host IP
      final hostMatch = RegExp(r'([\d\.]+)\s+\d+').firstMatch(line);
      if (hostMatch != null) {
        currentHost = hostMatch.group(1);
      }

      if (currentHost == null) continue;

      // Check for admin access
      if (line.contains('(Pwn3d!)') || line.contains('Administrator')) {
        final userMatch = RegExp(r'([^\s]+)\\([^\s]+)').firstMatch(line);
        if (userMatch != null) {
          result['admin_access'][currentHost] = '${userMatch.group(1)}\\${userMatch.group(2)}';
        }
      }

      // Check for successful authentication
      if (line.contains('[+]') && line.contains('\\')) {
        final credMatch = RegExp(r'([^\s]+)\\([^\s]+):(.+?)(?:\s|$)').firstMatch(line);
        if (credMatch != null) {
          result['valid_credentials'].add({
            'domain': credMatch.group(1),
            'user': credMatch.group(2),
            'password': credMatch.group(3),
            'host': currentHost
          });
        }
      }

      // Check for shares
      final shareMatch = RegExp(r'SHARE\s+(\S+)\s+(\w+)').firstMatch(line);
      if (shareMatch != null) {
        final shareName = shareMatch.group(1)!;
        final permission = shareMatch.group(2)!;

        result['shares_readable'][currentHost] ??= {};
        result['shares_readable'][currentHost][shareName] = permission;

        if (shareName == 'IPC\$' && permission == 'READ') {
          result['null_session_access'][currentHost] ??= [];
          result['null_session_access'][currentHost].add(shareName);
        }
      }

      // Check SMB signing
      if (line.contains('signing:False')) {
        result['signing_required'][currentHost] = false;
      } else if (line.contains('signing:True')) {
        result['signing_required'][currentHost] = true;
      }

      // Check for access denied
      if (line.contains('[-]') && line.contains('ACCESS_DENIED')) {
        result['no_access'].add(currentHost);
      }
    }

    return result;
  }

  /// Parse enum4linux output
  Map<String, dynamic> _parseEnum4LinuxOutput(String output) {
    final result = <String, dynamic>{
      'domain_name': null,
      'domain_sid': null,
      'users': [],
      'groups': [],
      'shares': [],
      'password_policy': {},
      'os_info': {}
    };

    final lines = output.split('\n');
    String section = '';

    for (final line in lines) {
      // Identify sections
      if (line.contains('Domain Name:')) {
        final match = RegExp(r'Domain Name:\s*(.+)').firstMatch(line);
        if (match != null) result['domain_name'] = match.group(1)?.trim();
      }

      if (line.contains('Domain SID:')) {
        final match = RegExp(r'Domain SID:\s*(.+)').firstMatch(line);
        if (match != null) result['domain_sid'] = match.group(1)?.trim();
      }

      // Parse users
      if (line.contains('user:[') || line.contains('User:')) {
        final userMatch = RegExp(r'(?:user:\[|User:\s*)([^\]]+)').firstMatch(line);
        if (userMatch != null) {
          result['users'].add(userMatch.group(1)?.trim());
        }
      }

      // Parse groups
      if (line.contains('group:[') || line.contains('Group:')) {
        final groupMatch = RegExp(r'(?:group:\[|Group:\s*)([^\]]+)').firstMatch(line);
        if (groupMatch != null) {
          result['groups'].add(groupMatch.group(1)?.trim());
        }
      }

      // Parse shares
      if (line.contains('Sharename') && line.contains('Type')) {
        section = 'shares';
      } else if (section == 'shares' && line.trim().isNotEmpty) {
        final shareMatch = RegExp(r'(\S+)\s+(\S+)\s*(.*)').firstMatch(line);
        if (shareMatch != null) {
          result['shares'].add({
            'name': shareMatch.group(1),
            'type': shareMatch.group(2),
            'comment': shareMatch.group(3)?.trim() ?? ''
          });
        }
      }

      // Parse password policy
      if (line.contains('Minimum password length:')) {
        final match = RegExp(r':\s*(\d+)').firstMatch(line);
        if (match != null) {
          result['password_policy']['min_length'] = int.parse(match.group(1)!);
        }
      }
      if (line.contains('Password history length:')) {
        final match = RegExp(r':\s*(\d+)').firstMatch(line);
        if (match != null) {
          result['password_policy']['history_length'] = int.parse(match.group(1)!);
        }
      }
    }

    return result;
  }

  /// Parse BloodHound output
  Map<String, dynamic> _parseBloodHoundOutput(String output) {
    final result = <String, dynamic>{
      'bloodhound_completed': false,
      'total_users': 0,
      'total_computers': 0,
      'total_groups': 0,
      'attack_paths_found': [],
      'high_value_targets': []
    };

    // Parse SharpHound collection output
    if (output.contains('Enumeration finished') || output.contains('completed successfully')) {
      result['bloodhound_completed'] = true;
    }

    // Extract statistics
    final userMatch = RegExp(r'(\d+)\s*(?:users?|Users?)').firstMatch(output);
    if (userMatch != null) {
      result['total_users'] = int.parse(userMatch.group(1)!);
    }

    final computerMatch = RegExp(r'(\d+)\s*(?:computers?|Computers?)').firstMatch(output);
    if (computerMatch != null) {
      result['total_computers'] = int.parse(computerMatch.group(1)!);
    }

    final groupMatch = RegExp(r'(\d+)\s*(?:groups?|Groups?)').firstMatch(output);
    if (groupMatch != null) {
      result['total_groups'] = int.parse(groupMatch.group(1)!);
    }

    // Parse attack paths (simplified - in reality would parse JSON)
    if (output.contains('Path found') || output.contains('->')) {
      // This would normally parse the actual path data
      result['attack_paths_found'].add({
        'from': 'current_user',
        'to': 'Domain Admins',
        'steps': ['Computer1', 'Group1', 'User1']
      });
    }

    // Extract high value targets
    final hvtRegex = RegExp(r'High Value:\s*([^\n]+)');
    for (final match in hvtRegex.allMatches(output)) {
      result['high_value_targets'].add(match.group(1)?.trim());
    }

    return result;
  }

  /// Parse Hashcat output
  Map<String, dynamic> _parseHashcatOutput(String output) {
    final result = <String, dynamic>{
      'cracked_credentials': [],
      'uncracked_hashes': [],
      'crack_time': null,
      'crack_rate': null
    };

    // Parse cracked hashes
    final crackedRegex = RegExp(r'([a-fA-F0-9]{32}):(.+)');
    for (final line in output.split('\n')) {
      final match = crackedRegex.firstMatch(line);
      if (match != null) {
        result['cracked_credentials'].add({
          'hash': match.group(1),
          'password': match.group(2),
          'from_hash': true
        });
      }

      // Extract time
      if (line.contains('Time.Started') || line.contains('Time.Estimated')) {
        final timeMatch = RegExp(r'(\d+)m').firstMatch(line);
        if (timeMatch != null) {
          result['crack_time'] = '${timeMatch.group(1)}min';
        }
      }

      // Extract crack rate
      if (line.contains('Speed')) {
        final speedMatch = RegExp(r'(\d+(?:\.\d+)?)\s*([kMG]?H/s)').firstMatch(line);
        if (speedMatch != null) {
          result['crack_rate'] = '${speedMatch.group(1)} ${speedMatch.group(2)}';
        }
      }
    }

    return result;
  }

  /// Parse Mimikatz output
  Map<String, dynamic> _parseMimikatzOutput(String output) {
    final result = <String, dynamic>{
      'credentials': [],
      'tickets': [],
      'hashes': [],
      'extraction_method': null
    };

    String? currentUser;
    String? currentDomain;

    for (final line in output.split('\n')) {
      // Parse username
      if (line.contains('Username :')) {
        final match = RegExp(r'Username\s*:\s*(.+)').firstMatch(line);
        if (match != null) currentUser = match.group(1)?.trim();
      }

      // Parse domain
      if (line.contains('Domain   :')) {
        final match = RegExp(r'Domain\s*:\s*(.+)').firstMatch(line);
        if (match != null) currentDomain = match.group(1)?.trim();
      }

      // Parse passwords
      if (line.contains('Password :') && !line.contains('(null)')) {
        final match = RegExp(r'Password\s*:\s*(.+)').firstMatch(line);
        if (match != null && currentUser != null && currentDomain != null) {
          result['credentials'].add({
            'user': '$currentDomain\\$currentUser',
            'password': match.group(1)?.trim(),
            'type': 'cleartext'
          });
        }
      }

      // Parse NTLM hashes
      if (line.contains('NTLM     :')) {
        final match = RegExp(r'NTLM\s*:\s*([a-fA-F0-9]{32})').firstMatch(line);
        if (match != null && currentUser != null && currentDomain != null) {
          result['hashes'].add({
            'user': '$currentDomain\\$currentUser',
            'ntlm': match.group(1),
            'type': 'ntlm'
          });
        }
      }

      // Detect extraction method
      if (line.contains('sekurlsa::')) {
        result['extraction_method'] = 'lsass_dump';
      } else if (line.contains('token::')) {
        result['extraction_method'] = 'token_manipulation';
      }
    }

    return result;
  }

  /// Parse SMBClient output
  Map<String, dynamic> _parseSmbClientOutput(String output) {
    final result = <String, dynamic>{
      'shares': [],
      'files': [],
      'accessible': false
    };

    for (final line in output.split('\n')) {
      // Parse share listing
      if (line.contains('Disk') || line.contains('IPC')) {
        final shareMatch = RegExp(r'(\S+)\s+(Disk|IPC|Printer)').firstMatch(line);
        if (shareMatch != null) {
          result['shares'].add({
            'name': shareMatch.group(1),
            'type': shareMatch.group(2)
          });
          result['accessible'] = true;
        }
      }

      // Parse files
      if (line.contains('.txt') || line.contains('.xml') || line.contains('.config')) {
        final fileMatch = RegExp(r'(\S+\.\w+)\s+[AN]?\s+(\d+)').firstMatch(line);
        if (fileMatch != null) {
          result['files'].add({
            'name': fileMatch.group(1),
            'size': int.parse(fileMatch.group(2)!)
          });
        }
      }
    }

    return result;
  }

  /// Parse DNS enumeration output
  Map<String, dynamic> _parseDnsOutput(String output) {
    final result = <String, dynamic>{
      'domain_controllers': [],
      'dns_hostnames': {},
      'zone_transfer': 'denied',
      'srv_records': []
    };

    for (final line in output.split('\n')) {
      // Check for successful zone transfer
      if (line.contains('Transfer succeeded') || line.contains('AXFR')) {
        result['zone_transfer'] = 'success';
      }

      // Parse A records
      final aRecordMatch = RegExp(r'(\S+)\s+(?:IN\s+)?A\s+([\d\.]+)').firstMatch(line);
      if (aRecordMatch != null) {
        final hostname = aRecordMatch.group(1)!;
        final ip = aRecordMatch.group(2)!;
        result['dns_hostnames'][ip] = hostname;

        // Check if it's a DC
        if (hostname.toLowerCase().contains('dc') ||
            hostname.toLowerCase().contains('domain')) {
          result['domain_controllers'].add(ip);
        }
      }

      // Parse SRV records
      if (line.contains('_ldap._tcp') || line.contains('_kerberos._tcp')) {
        final srvMatch = RegExp(r'(_\w+\._tcp)').firstMatch(line);
        if (srvMatch != null) {
          result['srv_records'].add(srvMatch.group(1));
        }
      }
    }

    return result;
  }

  /// Parse SQL output
  Map<String, dynamic> _parseSqlOutput(String output) {
    final result = <String, dynamic>{
      'sql_access_level': {},
      'sql_features': {},
      'sql_version': null,
      'databases': [],
      'sql_users': []
    };

    // Parse SQL version
    final versionMatch = RegExp(r'(?:Microsoft SQL Server|MySQL|PostgreSQL)\s*([\d\.]+)').firstMatch(output);
    if (versionMatch != null) {
      result['sql_version'] = versionMatch.group(0);
    }

    // Check xp_cmdshell status
    if (output.contains('xp_cmdshell') && output.contains('enabled')) {
      result['sql_features']['xp_cmdshell'] = 'enabled';
    } else if (output.contains('xp_cmdshell') && output.contains('disabled')) {
      result['sql_features']['xp_cmdshell'] = 'disabled';
    }

    // Check CLR status
    if (output.contains('clr_enabled') && output.contains('1')) {
      result['sql_features']['clr_enabled'] = true;
    } else if (output.contains('clr_enabled') && output.contains('0')) {
      result['sql_features']['clr_enabled'] = false;
    }

    // Parse database names
    final dbRegex = RegExp(r'(?:Database|DATABASE):\s*(\S+)');
    for (final match in dbRegex.allMatches(output)) {
      result['databases'].add(match.group(1));
    }

    // Parse SQL users and privileges
    if (output.contains('sysadmin')) {
      result['sql_access_level']['current_user'] = 'sysadmin';
    } else if (output.contains('db_owner')) {
      result['sql_access_level']['current_user'] = 'db_owner';
    } else if (output.contains('db_reader')) {
      result['sql_access_level']['current_user'] = 'db_reader';
    }

    return result;
  }

  /// Generic output parser for unrecognized types
  Map<String, dynamic> _parseGenericOutput(String output) {
    final result = <String, dynamic>{
      'raw_output': output,
      'lines': output.split('\n').length,
      'success_indicators': [],
      'error_indicators': [],
      'extracted_ips': [],
      'extracted_domains': []
    };

    // Look for common success indicators
    final successPatterns = ['Success', 'Complete', 'Found', 'OK', '[+]'];
    for (final pattern in successPatterns) {
      if (output.contains(pattern)) {
        result['success_indicators'].add(pattern);
      }
    }

    // Look for common error indicators
    final errorPatterns = ['Error', 'Failed', 'Denied', '[-]', 'Exception'];
    for (final pattern in errorPatterns) {
      if (output.contains(pattern)) {
        result['error_indicators'].add(pattern);
      }
    }

    // Extract IPs
    final ipRegex = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
    for (final match in ipRegex.allMatches(output)) {
      result['extracted_ips'].add(match.group(0));
    }

    // Extract domains
    final domainRegex = RegExp(r'\b(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}\b');
    for (final match in domainRegex.allMatches(output)) {
      result['extracted_domains'].add(match.group(0));
    }

    return result;
  }

  /// Extract Nmap assets
  List<DiscoveredAsset> _extractNmapAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    // Add host assets
    for (final host in parsed['hosts'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'host_$host',
        projectId: '',
        name: 'Host $host',
        value: host,
        type: AssetType.host,
        discoveredDate: DateTime.now(),
        properties: {
          'ip': host,
          'os': parsed['os_detection']?[host],
        },
      ));

      // Add service assets for this host
      final services = parsed['services']?[host] ?? [];
      for (final service in services) {
        assets.add(DiscoveredAsset(
          id: 'service_${host}_${service['port']}',
          projectId: '',
          name: '${service['service']} on $host:${service['port']}',
          value: '$host:${service['port']}',
          type: AssetType.service,
          discoveredDate: DateTime.now(),
          properties: {
            'host': host,
            'port': service['port'],
            'protocol': service['protocol'],
            'service': service['service'],
            'state': service['state'],
          },
        ));
      }
    }

    // Add SMB hosts as specific assets
    for (final smbHost in parsed['smb_hosts'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'smb_$smbHost',
        projectId: '',
        name: 'SMB Service on $smbHost',
        value: smbHost,
        type: AssetType.service,
        discoveredDate: DateTime.now(),
        properties: {
          'host': smbHost,
          'service_type': 'SMB',
          'ports': [139, 445],
        },
      ));
    }

    // Add domain controllers
    for (final dc in parsed['domain_controllers'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'dc_$dc',
        name: 'Domain Controller $dc',
        value: dc,
        type: AssetType.host,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'ip': dc,
          'role': 'domain_controller',
          'high_value': true,
        },
      ));
    }

    return assets;
  }

  /// Extract ARP scan assets
  List<DiscoveredAsset> _extractArpScanAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    for (final host in parsed['live_hosts'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'arp_${host['ip']}',
        name: 'Host ${host['ip']}',
        value: host['ip'],
        type: AssetType.host,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'ip': host['ip'],
          'mac': host['mac'],
          'vendor': host['vendor'],
          'discovery_method': 'arp',
        },
      ));
    }

    // Add network statistics as an asset
    assets.add(DiscoveredAsset(
      id: 'network_stats',
      name: 'Network Statistics',
      value: 'subnet_scan',
      type: AssetType.other,
      discoveredDate: DateTime.now(),
      projectId: '',
      properties: {
        'live_hosts_count': parsed['live_hosts_count'],
        'subnet_density': parsed['subnet_density'],
      },
    ));

    return assets;
  }

  /// Extract tcpdump assets
  List<DiscoveredAsset> _extractTcpdumpAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    // Add broadcast protocols as assets
    for (final protocol in parsed['broadcast_protocols'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'broadcast_$protocol',
        name: '$protocol Protocol',
        value: protocol,
        type: AssetType.vulnerability,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'protocol': protocol,
          'exploitable': true,
          'attack_vector': 'poisoning',
        },
      ));
    }

    // Add domain as an asset
    if (parsed['domain_identified'] != null) {
      assets.add(DiscoveredAsset(
        id: 'domain_${parsed['domain_identified']}',
        name: 'Domain ${parsed['domain_identified']}',
        value: parsed['domain_identified'],
        type: AssetType.domain,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'domain_name': parsed['domain_identified'],
          'discovery_method': 'passive',
        },
      ));
    }

    // Add VLANs
    for (final vlan in parsed['vlans_discovered'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'vlan_$vlan',
        name: 'VLAN $vlan',
        value: vlan.toString(),
        type: AssetType.network,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'vlan_id': vlan,
        },
      ));
    }

    return assets;
  }

  /// Extract Responder assets
  List<DiscoveredAsset> _extractResponderAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    for (final hash in parsed['captured_hashes'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'hash_${hash['user']}',
        name: 'Captured Hash for ${hash['user']}',
        value: hash['hash'],
        type: AssetType.credential,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'user': hash['user'],
          'hash_type': hash['type'],
          'hash': hash['hash'],
          'captured_via': 'LLMNR/NBT-NS poisoning',
          'needs_cracking': true,
        },
      ));
    }

    return assets;
  }

  /// Extract CrackMapExec assets
  List<DiscoveredAsset> _extractCmeAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    // Add admin access credentials
    for (final entry in (parsed['admin_access'] as Map? ?? {}).entries) {
      assets.add(DiscoveredAsset(
        id: 'admin_${entry.key}_${entry.value}',
        name: 'Admin Access to ${entry.key}',
        value: entry.value,
        type: AssetType.credential,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'host': entry.key,
          'user': entry.value,
          'access_level': 'administrator',
          'verified': true,
        },
      ));
    }

    // Add discovered shares
    for (final entry in (parsed['shares_readable'] as Map? ?? {}).entries) {
      final host = entry.key;
      final shares = entry.value as Map;

      for (final share in shares.entries) {
        assets.add(DiscoveredAsset(
          id: 'share_${host}_${share.key}',
          name: 'Share \\\\$host\\${share.key}',
          value: '\\\\$host\\${share.key}',
          type: AssetType.share,
            discoveredDate: DateTime.now(),
          projectId: '',
          properties: {
            'host': host,
            'share_name': share.key,
            'permission': share.value,
            'accessible': true,
          },
        ));
      }
    }

    // Add valid credentials
    for (final cred in parsed['valid_credentials'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'cred_${cred['user']}_${cred['host']}',
        name: 'Credential ${cred['domain']}\\${cred['user']}',
        value: '${cred['domain']}\\${cred['user']}',
        type: AssetType.credential,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'domain': cred['domain'],
          'username': cred['user'],
          'password': cred['password'],
          'host': cred['host'],
          'verified': true,
        },
      ));
    }

    return assets;
  }

  /// Extract enum4linux assets
  List<DiscoveredAsset> _extractEnum4LinuxAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    // Add discovered users
    for (final user in parsed['users'] ?? []) {
      assets.add(DiscoveredAsset(
        id: 'user_$user',
        name: 'User $user',
        value: user,
        type: AssetType.user,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'username': user,
          'enumerated_via': 'SMB',
        },
      ));
    }

    // Add domain information
    if (parsed['domain_name'] != null) {
      assets.add(DiscoveredAsset(
        id: 'domain_info',
        name: 'Domain ${parsed['domain_name']}',
        value: parsed['domain_name'],
        type: AssetType.domain,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'domain_name': parsed['domain_name'],
          'domain_sid': parsed['domain_sid'],
        },
      ));
    }

    // Add password policy
    if (parsed['password_policy']?.isNotEmpty == true) {
      assets.add(DiscoveredAsset(
        id: 'password_policy',
        name: 'Password Policy',
        value: 'policy',
        type: AssetType.other,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: parsed['password_policy'],
      ));
    }

    return assets;
  }

  /// Extract Hashcat assets
  List<DiscoveredAsset> _extractHashcatAssets(Map<String, dynamic> parsed) {
    final assets = <DiscoveredAsset>[];

    for (final cred in parsed['cracked_credentials'] ?? []) {
      // Parse user from hash if available
      String user = 'unknown';
      if (cred['hash'] != null) {
        // In a real scenario, we'd match this hash to the original user
        user = cred['user'] ?? 'unknown';
      }

      assets.add(DiscoveredAsset(
        id: 'cracked_${cred['hash']}',
        name: 'Cracked Password for $user',
        value: cred['password'],
        type: AssetType.credential,
        discoveredDate: DateTime.now(),
        projectId: '',
        properties: {
          'username': user,
          'password': cred['password'],
          'from_hash': true,
          'crack_time': parsed['crack_time'],
          'verified': false, // Needs to be tested
        },
      ));
    }

    return assets;
  }
}