import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/methodology_execution.dart';
import '../models/network_access.dart';
import 'methodology_service.dart';
import 'outcome_ingestion_service.dart';

/// Service for automatically generating attack chain steps based on asset discovery
class AttackChainService {
  static final AttackChainService _instance = AttackChainService._internal();
  factory AttackChainService() => _instance;
  AttackChainService._internal();

  final _uuid = const Uuid();
  final MethodologyService _methodologyService = MethodologyService();
  final OutcomeIngestionService _ingestionService = OutcomeIngestionService();

  // Store attack chain steps by project
  final Map<String, List<AttackChainStep>> _projectChains = {};

  // Store network access states by project
  final Map<String, List<NetworkAccessState>> _projectNetworks = {};

  // Stream for reactive updates
  final StreamController<List<AttackChainStep>> _chainController =
      StreamController<List<AttackChainStep>>.broadcast();
  final StreamController<List<NetworkAccessState>> _networkController =
      StreamController<List<NetworkAccessState>>.broadcast();

  Stream<List<AttackChainStep>> get chainStream => _chainController.stream;
  Stream<List<NetworkAccessState>> get networkStream => _networkController.stream;

  /// Initialize the service
  Future<void> initialize() async {
    await _methodologyService.initialize();
  }

  /// Automatically generate attack chain steps when assets are discovered
  Future<List<AttackChainStep>> generateStepsForAsset(
    String projectId,
    DiscoveredAsset asset,
  ) async {
    final generatedSteps = <AttackChainStep>[];

    // Get existing chain to avoid duplicates and determine next logical steps
    final existingChain = getProjectChain(projectId);
    final currentPhase = _determineCurrentPhase(existingChain);

    // Generate steps based on asset type and current phase
    switch (asset.type) {
      case AssetType.host:
        generatedSteps.addAll(_generateHostDiscoverySteps(projectId, asset, currentPhase));
        break;
      case AssetType.service:
        generatedSteps.addAll(_generateServiceSteps(projectId, asset, currentPhase));
        break;
      case AssetType.credential:
        generatedSteps.addAll(_generateCredentialSteps(projectId, asset, currentPhase));
        break;
      case AssetType.vulnerability:
        generatedSteps.addAll(_generateVulnerabilitySteps(projectId, asset, currentPhase));
        break;
      case AssetType.share:
        generatedSteps.addAll(_generateShareSteps(projectId, asset, currentPhase));
        break;
      default:
        generatedSteps.addAll(_generateGenericSteps(projectId, asset, currentPhase));
        break;
    }

    // Add steps to project chain
    _projectChains.putIfAbsent(projectId, () => []);
    _projectChains[projectId]!.addAll(generatedSteps);

    // Sort by priority and phase
    _projectChains[projectId]!.sort((a, b) {
      final phaseCompare = a.phase.index.compareTo(b.phase.index);
      if (phaseCompare != 0) return phaseCompare;
      return b.priority.compareTo(a.priority);
    });

    _chainController.add(_projectChains[projectId]!);
    return generatedSteps;
  }

  /// Add a network segment with specific access scenario
  /// Returns both the generated steps and the network asset
  Future<({List<AttackChainStep> steps, DiscoveredAsset networkAsset})> addNetworkSegment(
    String projectId,
    String networkName,
    NetworkAccessState networkState,
  ) async {
    // Store network state
    _projectNetworks.putIfAbsent(projectId, () => []);
    _projectNetworks[projectId]!.add(networkState);
    _networkController.add(_projectNetworks[projectId]!);

    // Create a discovered asset for the network segment with dynamic properties
    final networkAsset = DiscoveredAsset(
      id: _uuid.v4(),
      projectId: projectId,
      type: AssetType.network,
      name: networkName,
      value: networkState.networkName,
      confidence: 1.0,
      discoveredDate: DateTime.now(),
      properties: _createNetworkAssetProperties(networkState),
    );

    // Add the network asset to the methodology engine so it appears on assets screen
    // We need access to the methodology engine, so we'll store this asset and let
    // the dialog handler add it to the engine

    // Generate attack steps based on network access state
    final generatedSteps = await _generateNetworkAccessSteps(projectId, networkState);

    // Add steps to project chain
    _projectChains.putIfAbsent(projectId, () => []);
    _projectChains[projectId]!.addAll(generatedSteps);

    // Sort by priority and phase
    _projectChains[projectId]!.sort((a, b) {
      final phaseCompare = a.phase.index.compareTo(b.phase.index);
      if (phaseCompare != 0) return phaseCompare;
      return b.priority.compareTo(a.priority);
    });

    _chainController.add(_projectChains[projectId]!);

    return (steps: generatedSteps, networkAsset: networkAsset);
  }

  /// Generate attack steps based on network access state
  Future<List<AttackChainStep>> _generateNetworkAccessSteps(
    String projectId,
    NetworkAccessState networkState,
  ) async {
    final steps = <AttackChainStep>[];

    switch (networkState.accessLevel) {
      case NetworkAccessLevel.physicalOnly:
        steps.addAll(_generatePhysicalOnlySteps(projectId, networkState));
        break;
      case NetworkAccessLevel.blocked:
        steps.addAll(_generateBlockedNetworkSteps(projectId, networkState));
        break;
      case NetworkAccessLevel.partialAccess:
        steps.addAll(_generatePartialAccessSteps(projectId, networkState));
        break;
      case NetworkAccessLevel.fullAccess:
        steps.addAll(_generateFullAccessSteps(projectId, networkState));
        break;
    }

    return steps;
  }

  /// Steps for physical-only access (found network point but no logical connectivity)
  List<AttackChainStep> _generatePhysicalOnlySteps(
    String projectId,
    NetworkAccessState networkState,
  ) {
    final steps = <AttackChainStep>[];

    // Check what barriers we're dealing with
    for (final barrier in networkState.activeBarriers) {
      switch (barrier.type) {
        case NetworkBarrierType.noDhcp:
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.reconnaissance,
            title: 'Network Reconnaissance: ${networkState.networkName}',
            description: 'Analyze network to determine IP range and configuration',
            methodologyId: 'network_reconnaissance',
            priority: 9,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 15),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'barrier_type': 'no_dhcp',
              'connection_type': networkState.connectionType.name,
            },
          ));

          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.reconnaissance,
            title: 'Passive Network Analysis: ${networkState.networkName}',
            description: 'Listen for network traffic to identify IP ranges and hosts',
            methodologyId: 'passive_network_analysis',
            priority: 8,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 20),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'analysis_type': 'passive_listening',
            },
          ));

          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.initialAccess,
            title: 'Static IP Configuration: ${networkState.networkName}',
            description: 'Configure static IP to gain network access',
            methodologyId: 'static_ip_config',
            priority: 7,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 10),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'requires': 'network_analysis_results',
            },
          ));
          break;

        case NetworkBarrierType.dot1x:
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.reconnaissance,
            title: '802.1X Analysis: ${networkState.networkName}',
            description: 'Analyze 802.1X authentication requirements',
            methodologyId: 'dot1x_analysis',
            priority: 9,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 15),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'auth_type': '802.1x',
              'eap_method': networkState.accessDetails['eap_method'],
            },
          ));

          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.initialAccess,
            title: 'Certificate Extraction: ${networkState.networkName}',
            description: 'Attempt to extract or bypass certificate requirements',
            methodologyId: 'cert_extraction',
            priority: 6,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 30),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'cert_required': networkState.accessDetails['certificate_required'],
            },
          ));
          break;

        default:
          // Generic barrier analysis
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.reconnaissance,
            title: 'Barrier Analysis: ${barrier.type.displayName}',
            description: 'Analyze ${barrier.description.toLowerCase()}',
            methodologyId: 'barrier_analysis',
            priority: 7,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 10),
            createdDate: DateTime.now(),
            context: {
              'barrier_type': barrier.type.name,
              'barrier_severity': barrier.severity.name,
            },
          ));
      }
    }

    return steps;
  }

  /// Steps for blocked network access (connected but restricted)
  List<AttackChainStep> _generateBlockedNetworkSteps(
    String projectId,
    NetworkAccessState networkState,
  ) {
    final steps = <AttackChainStep>[];

    for (final barrier in networkState.activeBarriers) {
      switch (barrier.type) {
        case NetworkBarrierType.nac:
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.reconnaissance,
            title: 'NAC Analysis: ${networkState.networkName}',
            description: 'Analyze Network Access Control policies and bypass options',
            methodologyId: 'nac_analysis',
            priority: 9,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 20),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'nac_detected': true,
              'quarantine_vlan': networkState.accessDetails['quarantine_vlan'],
            },
          ));

          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.initialAccess,
            title: 'Device Registration Bypass: ${networkState.networkName}',
            description: 'Attempt to bypass NAC device registration requirements',
            methodologyId: 'nac_bypass',
            priority: 8,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 45),
            createdDate: DateTime.now(),
            context: {
              'bypass_methods': ['mac_spoofing', 'device_impersonation', 'certificate_injection'],
            },
          ));
          break;

        case NetworkBarrierType.captivePortal:
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.reconnaissance,
            title: 'Captive Portal Analysis: ${networkState.networkName}',
            description: 'Analyze captive portal for bypass opportunities',
            methodologyId: 'captive_portal_analysis',
            priority: 8,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 15),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'portal_type': 'web_based',
            },
          ));

          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.initialAccess,
            title: 'Portal Bypass: ${networkState.networkName}',
            description: 'Attempt DNS tunneling, MAC spoofing, or credential attacks',
            methodologyId: 'captive_portal_bypass',
            priority: 7,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 30),
            createdDate: DateTime.now(),
            context: {
              'bypass_methods': ['dns_tunneling', 'mac_spoofing', 'credential_guess'],
            },
          ));
          break;

        default:
          break;
      }
    }

    return steps;
  }

  /// Steps for partial network access (some restrictions)
  List<AttackChainStep> _generatePartialAccessSteps(
    String projectId,
    NetworkAccessState networkState,
  ) {
    final steps = <AttackChainStep>[];

    // Base reconnaissance for partial access
    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.reconnaissance,
      title: 'Limited Network Discovery: ${networkState.networkName}',
      description: 'Discover accessible hosts within network restrictions',
      methodologyId: 'limited_network_discovery',
      priority: 8,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 20),
      createdDate: DateTime.now(),
      context: {
        'network_name': networkState.networkName,
        'access_type': 'partial',
        'vlan_id': networkState.accessDetails['vlan_id'],
      },
    ));

    // Analyze remaining barriers
    for (final barrier in networkState.activeBarriers) {
      switch (barrier.type) {
        case NetworkBarrierType.vlanIsolation:
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.lateralMovement,
            title: 'VLAN Hopping: ${networkState.networkName}',
            description: 'Attempt to escape VLAN isolation restrictions',
            methodologyId: 'vlan_hopping',
            priority: 7,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 25),
            createdDate: DateTime.now(),
            context: {
              'current_vlan': networkState.accessDetails['vlan_id'],
              'hopping_methods': ['double_tagging', 'switch_spoofing'],
            },
          ));
          break;

        case NetworkBarrierType.firewallBlocking:
          steps.add(AttackChainStep(
            id: _uuid.v4(),
            projectId: projectId,
            phase: AttackChainPhase.initialAccess,
            title: 'Firewall Rule Analysis: ${networkState.networkName}',
            description: 'Map allowed traffic and find bypass opportunities',
            methodologyId: 'firewall_analysis',
            priority: 8,
            status: AttackChainStepStatus.pending,
            estimatedDuration: const Duration(minutes: 30),
            createdDate: DateTime.now(),
            context: {
              'network_name': networkState.networkName,
              'blocked_ports': 'outbound_internet',
            },
          ));
          break;

        default:
          break;
      }
    }

    return steps;
  }

  /// Steps for full network access (unrestricted)
  List<AttackChainStep> _generateFullAccessSteps(
    String projectId,
    NetworkAccessState networkState,
  ) {
    final steps = <AttackChainStep>[];

    // Standard reconnaissance for full access
    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.reconnaissance,
      title: 'Network Discovery: ${networkState.networkName}',
      description: 'Comprehensive discovery of network hosts and services',
      methodologyId: 'network_discovery',
      priority: 9,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 15),
      createdDate: DateTime.now(),
      context: {
        'network_name': networkState.networkName,
        'access_type': 'full',
        'dhcp_enabled': networkState.accessDetails['dhcp_available'],
      },
    ));

    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.reconnaissance,
      title: 'Service Enumeration: ${networkState.networkName}',
      description: 'Identify running services on discovered hosts',
      methodologyId: 'service_enumeration',
      priority: 8,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 20),
      createdDate: DateTime.now(),
      context: {
        'network_name': networkState.networkName,
        'scan_type': 'comprehensive',
      },
    ));

    return steps;
  }

  /// Get network states for a project
  List<NetworkAccessState> getProjectNetworks(String projectId) {
    return _projectNetworks[projectId] ?? [];
  }

  /// Update network access state (when barriers are bypassed)
  void updateNetworkAccess(String projectId, String networkId, NetworkAccessState newState) {
    final networks = _projectNetworks[projectId];
    if (networks != null) {
      final index = networks.indexWhere((n) => n.networkId == networkId);
      if (index != -1) {
        networks[index] = newState;
        _networkController.add(networks);

        // Generate new steps if access level improved
        _generateProgressionSteps(projectId, newState);
      }
    }
  }

  /// Generate steps when network access progresses
  Future<void> _generateProgressionSteps(String projectId, NetworkAccessState networkState) async {
    final newSteps = await _generateNetworkAccessSteps(projectId, networkState);

    if (newSteps.isNotEmpty) {
      _projectChains.putIfAbsent(projectId, () => []);
      _projectChains[projectId]!.addAll(newSteps);

      // Sort and update
      _projectChains[projectId]!.sort((a, b) {
        final phaseCompare = a.phase.index.compareTo(b.phase.index);
        if (phaseCompare != 0) return phaseCompare;
        return b.priority.compareTo(a.priority);
      });

      _chainController.add(_projectChains[projectId]!);
    }
  }

  /// Generate steps for host discovery
  List<AttackChainStep> _generateHostDiscoverySteps(
    String projectId,
    DiscoveredAsset asset,
    AttackChainPhase currentPhase,
  ) {
    final steps = <AttackChainStep>[];

    // If we're still in reconnaissance, suggest more discovery
    if (currentPhase == AttackChainPhase.reconnaissance) {
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.reconnaissance,
        title: 'Port Scan: ${asset.name}',
        description: 'Perform comprehensive port scan to identify running services',
        methodologyId: 'nmap_tcp_scan',
        targetAssetId: asset.id,
        priority: 8,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(minutes: 5),
        createdDate: DateTime.now(),
        context: {
          'target_host': asset.value,
          'scan_type': 'tcp_comprehensive',
        },
      ));
    }

    // Always suggest initial access if no services found yet
    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.initialAccess,
      title: 'Service Enumeration: ${asset.name}',
      description: 'Enumerate services and identify attack vectors',
      methodologyId: 'service_enumeration',
      targetAssetId: asset.id,
      priority: 7,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 10),
      createdDate: DateTime.now(),
      context: {
        'target_host': asset.value,
        'host_name': asset.name,
      },
    ));

    return steps;
  }

  /// Generate steps for service discovery
  List<AttackChainStep> _generateServiceSteps(
    String projectId,
    DiscoveredAsset asset,
    AttackChainPhase currentPhase,
  ) {
    final steps = <AttackChainStep>[];
    final serviceName = asset.name.toLowerCase();
    final port = asset.properties['port']?.toString();

    // Generate service-specific attack steps
    if (serviceName.contains('smb') || port == '445') {
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.initialAccess,
        title: 'SMB Enumeration: ${asset.name}',
        description: 'Enumerate SMB shares and check for null sessions',
        methodologyId: 'smb_enumeration',
        targetAssetId: asset.id,
        priority: 9,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(minutes: 8),
        createdDate: DateTime.now(),
        context: {
          'target_service': asset.value,
          'port': port,
          'service_name': serviceName,
        },
      ));
    }

    if (serviceName.contains('sql') || port == '1433') {
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.initialAccess,
        title: 'SQL Server Testing: ${asset.name}',
        description: 'Test for default credentials and misconfigurations',
        methodologyId: 'mssql_testing',
        targetAssetId: asset.id,
        priority: 8,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(minutes: 15),
        createdDate: DateTime.now(),
        context: {
          'target_service': asset.value,
          'port': port,
        },
      ));
    }

    if (serviceName.contains('ldap') || serviceName.contains('domain') || port == '389') {
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.initialAccess,
        title: 'LDAP Enumeration: ${asset.name}',
        description: 'Enumerate LDAP for domain information and users',
        methodologyId: 'ldap_enumeration',
        targetAssetId: asset.id,
        priority: 9,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(minutes: 10),
        createdDate: DateTime.now(),
        context: {
          'target_service': asset.value,
          'port': port,
        },
      ));

      // If this is a domain controller, suggest LLMNR poisoning
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.initialAccess,
        title: 'LLMNR/NBT-NS Poisoning',
        description: 'Attempt to capture authentication hashes via LLMNR poisoning',
        methodologyId: 'llmnr_poisoning',
        targetAssetId: asset.id,
        priority: 7,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(minutes: 30),
        createdDate: DateTime.now(),
        context: {
          'network_segment': asset.properties['network'] ?? 'unknown',
        },
      ));
    }

    return steps;
  }

  /// Generate steps for credential discovery
  List<AttackChainStep> _generateCredentialSteps(
    String projectId,
    DiscoveredAsset asset,
    AttackChainPhase currentPhase,
  ) {
    final steps = <AttackChainStep>[];
    final credentialType = asset.properties['type']?.toString() ?? 'unknown';

    // Always test credentials when found
    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.lateralMovement,
      title: 'Credential Testing: ${asset.name}',
      description: 'Test credentials across discovered services and hosts',
      methodologyId: 'credential_testing',
      targetAssetId: asset.id,
      priority: 9,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 15),
      createdDate: DateTime.now(),
      context: {
        'credential_type': credentialType,
        'username': asset.properties['username'],
        'domain': asset.properties['domain'],
      },
    ));

    // If it's a hash, suggest cracking
    if (credentialType.contains('hash') || credentialType.contains('ntlm')) {
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.initialAccess,
        title: 'Hash Cracking: ${asset.name}',
        description: 'Attempt to crack captured password hash',
        methodologyId: 'hash_cracking',
        targetAssetId: asset.id,
        priority: 8,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(hours: 2),
        createdDate: DateTime.now(),
        context: {
          'hash_type': credentialType,
          'hash_value': asset.value,
        },
      ));
    }

    // If it's an admin credential, suggest privilege escalation
    if (asset.name.toLowerCase().contains('admin') ||
        asset.properties['privilege_level'] == 'admin') {
      steps.add(AttackChainStep(
        id: _uuid.v4(),
        projectId: projectId,
        phase: AttackChainPhase.privilegeEscalation,
        title: 'Admin Access Validation: ${asset.name}',
        description: 'Validate and exploit administrative access',
        methodologyId: 'admin_access_validation',
        targetAssetId: asset.id,
        priority: 10,
        status: AttackChainStepStatus.pending,
        estimatedDuration: const Duration(minutes: 10),
        createdDate: DateTime.now(),
        context: {
          'privilege_level': 'administrator',
        },
      ));
    }

    return steps;
  }

  /// Generate steps for vulnerability discovery
  List<AttackChainStep> _generateVulnerabilitySteps(
    String projectId,
    DiscoveredAsset asset,
    AttackChainPhase currentPhase,
  ) {
    final steps = <AttackChainStep>[];
    final severity = asset.properties['severity']?.toString() ?? 'unknown';
    final cveId = asset.properties['cve_id']?.toString();

    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.initialAccess,
      title: 'Exploit ${asset.name}',
      description: 'Attempt to exploit discovered vulnerability for initial access',
      methodologyId: 'vulnerability_exploitation',
      targetAssetId: asset.id,
      priority: _getPriorityFromSeverity(severity),
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 20),
      createdDate: DateTime.now(),
      context: {
        'vulnerability': asset.name,
        'severity': severity,
        'cve_id': cveId,
        'target': asset.value,
      },
    ));

    return steps;
  }

  /// Generate steps for share discovery
  List<AttackChainStep> _generateShareSteps(
    String projectId,
    DiscoveredAsset asset,
    AttackChainPhase currentPhase,
  ) {
    final steps = <AttackChainStep>[];

    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.lateralMovement,
      title: 'Share Enumeration: ${asset.name}',
      description: 'Enumerate share contents for sensitive data and credentials',
      methodologyId: 'share_enumeration',
      targetAssetId: asset.id,
      priority: 7,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 15),
      createdDate: DateTime.now(),
      context: {
        'share_path': asset.value,
        'share_name': asset.name,
      },
    ));

    return steps;
  }

  /// Generate generic steps for other asset types
  List<AttackChainStep> _generateGenericSteps(
    String projectId,
    DiscoveredAsset asset,
    AttackChainPhase currentPhase,
  ) {
    final steps = <AttackChainStep>[];

    steps.add(AttackChainStep(
      id: _uuid.v4(),
      projectId: projectId,
      phase: AttackChainPhase.reconnaissance,
      title: 'Analyze ${asset.type.displayName}: ${asset.name}',
      description: 'Further analyze discovered asset for attack opportunities',
      methodologyId: 'generic_analysis',
      targetAssetId: asset.id,
      priority: 5,
      status: AttackChainStepStatus.pending,
      estimatedDuration: const Duration(minutes: 10),
      createdDate: DateTime.now(),
      context: {
        'asset_type': asset.type.name,
        'asset_value': asset.value,
      },
    ));

    return steps;
  }

  /// Determine current phase based on existing chain
  AttackChainPhase _determineCurrentPhase(List<AttackChainStep> existingChain) {
    if (existingChain.isEmpty) {
      return AttackChainPhase.reconnaissance;
    }

    // Find the highest phase that has been started
    AttackChainPhase currentPhase = AttackChainPhase.reconnaissance;
    for (final step in existingChain) {
      if (step.status != AttackChainStepStatus.pending &&
          step.phase.index > currentPhase.index) {
        currentPhase = step.phase;
      }
    }

    return currentPhase;
  }

  /// Get priority based on severity
  int _getPriorityFromSeverity(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return 10;
      case 'high':
        return 9;
      case 'medium':
        return 7;
      case 'low':
        return 5;
      default:
        return 6;
    }
  }

  /// Get attack chain for a project
  List<AttackChainStep> getProjectChain(String projectId) {
    return _projectChains[projectId] ?? [];
  }

  /// Update step status
  void updateStepStatus(String stepId, AttackChainStepStatus status, {String? notes}) {
    for (final chain in _projectChains.values) {
      final stepIndex = chain.indexWhere((step) => step.id == stepId);
      if (stepIndex != -1) {
        final updatedStep = chain[stepIndex].copyWith(
          status: status,
          completedDate: status == AttackChainStepStatus.completed ? DateTime.now() : null,
          notes: notes,
        );
        chain[stepIndex] = updatedStep;
        _chainController.add(chain);
        break;
      }
    }
  }

  /// Mark step as completed and generate follow-up steps
  Future<void> completeStep(String stepId, Map<String, dynamic> results) async {
    updateStepStatus(stepId, AttackChainStepStatus.completed);

    // Generate follow-up steps based on results
    // This would integrate with the ingestion service to process results
    // and generate new attack chain steps automatically
  }

  /// Clear chain for project
  void clearProjectChain(String projectId) {
    _projectChains.remove(projectId);
    _chainController.add([]);
  }

  /// Create dynamic asset properties based on network access state
  Map<String, dynamic> _createNetworkAssetProperties(NetworkAccessState networkState) {
    final properties = <String, dynamic>{
      // Basic network info
      'access_level': networkState.accessLevel.name,
      'connection_type': networkState.connectionType.name,
      'barriers': networkState.activeBarriers.map((b) => b.type.name).toList(),
      'scenario_difficulty': _calculateScenarioDifficulty(networkState),
    };

    // Add known properties from barriers
    for (final barrier in networkState.activeBarriers) {
      switch (barrier.type) {
        case NetworkBarrierType.noDhcp:
          properties['requires_static_ip'] = true;
          break;
        case NetworkBarrierType.nac:
          properties['nac_enabled'] = true;
          properties['nac_type'] = barrier.description.contains('Cisco') ? 'cisco_ise' : 'unknown';
          break;
        case NetworkBarrierType.captivePortal:
          properties['captive_portal_enabled'] = true;
          break;
        case NetworkBarrierType.dot1x:
          properties['dot1x_enabled'] = true;
          break;
        case NetworkBarrierType.macFiltering:
          properties['mac_filtering'] = true;
          break;
        case NetworkBarrierType.vlanIsolation:
          properties['vlan_isolation'] = true;
          break;
        case NetworkBarrierType.firewallBlocking:
          properties['firewall_restrictions'] = true;
          break;
        case NetworkBarrierType.certificateAuth:
          properties['certificate_auth_required'] = true;
          break;
        case NetworkBarrierType.unknown:
          properties['unknown_barrier'] = true;
          break;
      }
    }

    // Initialize empty properties that can be discovered later
    if (networkState.accessLevel != NetworkAccessLevel.physicalOnly) {
      properties['subnet'] = null; // To be discovered
      properties['gateway'] = null; // To be discovered
      properties['dns_servers'] = []; // To be populated
      properties['live_hosts'] = []; // To be populated from scanning
      properties['smb_hosts'] = []; // To be populated from service discovery
      properties['web_services'] = []; // To be populated from service discovery
      properties['domain_name'] = null; // To be discovered from enumeration
      properties['domain_controllers'] = []; // To be populated
      properties['ipv6_enabled'] = null; // To be discovered
      properties['smb_signing'] = null; // To be discovered
      properties['captured_hashes'] = []; // To be populated from attacks
      properties['cracked_passwords'] = []; // To be populated from cracking
      properties['service_accounts'] = []; // To be populated from enumeration
    }

    return properties;
  }

  String _calculateScenarioDifficulty(NetworkAccessState networkState) {
    if (networkState.accessLevel == NetworkAccessLevel.fullAccess) {
      return 'easy';
    }

    final barrierCount = networkState.activeBarriers.length;
    if (barrierCount == 0) return 'easy';
    if (barrierCount == 1) return 'medium';
    if (barrierCount == 2) return 'hard';
    return 'expert';
  }

  void dispose() {
    _chainController.close();
    _networkController.close();
  }
}

/// Represents a step in the attack chain
class AttackChainStep {
  final String id;
  final String projectId;
  final AttackChainPhase phase;
  final String title;
  final String description;
  final String methodologyId;
  final String? targetAssetId;
  final int priority;
  final AttackChainStepStatus status;
  final Duration estimatedDuration;
  final DateTime createdDate;
  final DateTime? completedDate;
  final Map<String, dynamic> context;
  final String? notes;

  const AttackChainStep({
    required this.id,
    required this.projectId,
    required this.phase,
    required this.title,
    required this.description,
    required this.methodologyId,
    this.targetAssetId,
    required this.priority,
    required this.status,
    required this.estimatedDuration,
    required this.createdDate,
    this.completedDate,
    this.context = const {},
    this.notes,
  });

  AttackChainStep copyWith({
    String? id,
    String? projectId,
    AttackChainPhase? phase,
    String? title,
    String? description,
    String? methodologyId,
    String? targetAssetId,
    int? priority,
    AttackChainStepStatus? status,
    Duration? estimatedDuration,
    DateTime? createdDate,
    DateTime? completedDate,
    Map<String, dynamic>? context,
    String? notes,
  }) {
    return AttackChainStep(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      phase: phase ?? this.phase,
      title: title ?? this.title,
      description: description ?? this.description,
      methodologyId: methodologyId ?? this.methodologyId,
      targetAssetId: targetAssetId ?? this.targetAssetId,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      createdDate: createdDate ?? this.createdDate,
      completedDate: completedDate ?? this.completedDate,
      context: context ?? this.context,
      notes: notes ?? this.notes,
    );
  }
}

/// Attack chain phases
enum AttackChainPhase {
  reconnaissance,
  initialAccess,
  credentialAccess,
  lateralMovement,
  privilegeEscalation,
  persistence,
  domainAdmin;

  String get displayName {
    switch (this) {
      case AttackChainPhase.reconnaissance:
        return 'Reconnaissance';
      case AttackChainPhase.initialAccess:
        return 'Initial Access';
      case AttackChainPhase.credentialAccess:
        return 'Credential Access';
      case AttackChainPhase.lateralMovement:
        return 'Lateral Movement';
      case AttackChainPhase.privilegeEscalation:
        return 'Privilege Escalation';
      case AttackChainPhase.persistence:
        return 'Persistence';
      case AttackChainPhase.domainAdmin:
        return 'Domain Admin';
    }
  }

  String get description {
    switch (this) {
      case AttackChainPhase.reconnaissance:
        return 'Gather information about the target environment';
      case AttackChainPhase.initialAccess:
        return 'Establish initial foothold in the target network';
      case AttackChainPhase.credentialAccess:
        return 'Obtain credentials for authentication';
      case AttackChainPhase.lateralMovement:
        return 'Move through the network to access additional systems';
      case AttackChainPhase.privilegeEscalation:
        return 'Escalate privileges to gain higher-level access';
      case AttackChainPhase.persistence:
        return 'Maintain presence in the environment';
      case AttackChainPhase.domainAdmin:
        return 'Achieve domain administrator level access';
    }
  }
}

/// Status of attack chain steps
enum AttackChainStepStatus {
  pending,
  inProgress,
  completed,
  failed,
  skipped;

  String get displayName {
    switch (this) {
      case AttackChainStepStatus.pending:
        return 'Pending';
      case AttackChainStepStatus.inProgress:
        return 'In Progress';
      case AttackChainStepStatus.completed:
        return 'Completed';
      case AttackChainStepStatus.failed:
        return 'Failed';
      case AttackChainStepStatus.skipped:
        return 'Skipped';
    }
  }
}