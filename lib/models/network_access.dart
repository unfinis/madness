/// Enhanced network access tracking for realistic penetration testing scenarios
class NetworkAccessState {
  final String networkId;
  final String networkName;
  final NetworkAccessLevel accessLevel;
  final NetworkConnectionType connectionType;
  final List<NetworkBarrier> barriers;
  final Map<String, dynamic> accessDetails;
  final DateTime discoveredDate;
  final DateTime? accessAchievedDate;

  const NetworkAccessState({
    required this.networkId,
    required this.networkName,
    required this.accessLevel,
    required this.connectionType,
    this.barriers = const [],
    this.accessDetails = const {},
    required this.discoveredDate,
    this.accessAchievedDate,
  });

  NetworkAccessState copyWith({
    String? networkId,
    String? networkName,
    NetworkAccessLevel? accessLevel,
    NetworkConnectionType? connectionType,
    List<NetworkBarrier>? barriers,
    Map<String, dynamic>? accessDetails,
    DateTime? discoveredDate,
    DateTime? accessAchievedDate,
  }) {
    return NetworkAccessState(
      networkId: networkId ?? this.networkId,
      networkName: networkName ?? this.networkName,
      accessLevel: accessLevel ?? this.accessLevel,
      connectionType: connectionType ?? this.connectionType,
      barriers: barriers ?? this.barriers,
      accessDetails: accessDetails ?? this.accessDetails,
      discoveredDate: discoveredDate ?? this.discoveredDate,
      accessAchievedDate: accessAchievedDate ?? this.accessAchievedDate,
    );
  }

  bool get hasFullAccess => accessLevel == NetworkAccessLevel.fullAccess;
  bool get hasPartialAccess => accessLevel == NetworkAccessLevel.partialAccess || hasFullAccess;
  bool get isBlocked => accessLevel == NetworkAccessLevel.blocked;
  bool get needsConfiguration => accessLevel == NetworkAccessLevel.physicalOnly;

  List<NetworkBarrier> get activeBarriers => barriers.where((b) => !b.bypassed).toList();
  List<NetworkBarrier> get bypassedBarriers => barriers.where((b) => b.bypassed).toList();
}

/// Network access levels representing progression from discovery to full access
enum NetworkAccessLevel {
  /// Physical access only - found a network port/WiFi but no logical access
  physicalOnly,

  /// Blocked - connected but no traffic allowed (NAC blocking, captive portal, etc.)
  blocked,

  /// Limited access - some traffic allowed but restricted (VLAN isolation, etc.)
  partialAccess,

  /// Full network access - can communicate freely
  fullAccess;

  String get displayName {
    switch (this) {
      case NetworkAccessLevel.physicalOnly:
        return 'Physical Only';
      case NetworkAccessLevel.blocked:
        return 'Blocked';
      case NetworkAccessLevel.partialAccess:
        return 'Partial Access';
      case NetworkAccessLevel.fullAccess:
        return 'Full Access';
    }
  }

  String get description {
    switch (this) {
      case NetworkAccessLevel.physicalOnly:
        return 'Found network point but no logical connectivity';
      case NetworkAccessLevel.blocked:
        return 'Connected but traffic blocked by security controls';
      case NetworkAccessLevel.partialAccess:
        return 'Limited network access with some restrictions';
      case NetworkAccessLevel.fullAccess:
        return 'Unrestricted network access achieved';
    }
  }
}

/// Type of network connection available
enum NetworkConnectionType {
  /// Wired Ethernet connection
  ethernet,

  /// Wireless WiFi connection
  wifi,

  /// USB/Mobile device connection
  usb,

  /// VPN or remote access
  vpn,

  /// Unknown or other connection type
  unknown;

  String get displayName {
    switch (this) {
      case NetworkConnectionType.ethernet:
        return 'Ethernet';
      case NetworkConnectionType.wifi:
        return 'WiFi';
      case NetworkConnectionType.usb:
        return 'USB';
      case NetworkConnectionType.vpn:
        return 'VPN';
      case NetworkConnectionType.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case NetworkConnectionType.ethernet:
        return 'Wired network connection';
      case NetworkConnectionType.wifi:
        return 'Wireless network connection';
      case NetworkConnectionType.usb:
        return 'USB device or mobile connection';
      case NetworkConnectionType.vpn:
        return 'VPN or remote access connection';
      case NetworkConnectionType.unknown:
        return 'Unknown connection type';
    }
  }
}

/// Network barriers that prevent or limit access
class NetworkBarrier {
  final String id;
  final NetworkBarrierType type;
  final String description;
  final NetworkBarrierSeverity severity;
  final bool bypassed;
  final DateTime? bypassedDate;
  final String? bypassMethod;
  final Map<String, dynamic> details;

  const NetworkBarrier({
    required this.id,
    required this.type,
    required this.description,
    required this.severity,
    this.bypassed = false,
    this.bypassedDate,
    this.bypassMethod,
    this.details = const {},
  });

  NetworkBarrier copyWith({
    String? id,
    NetworkBarrierType? type,
    String? description,
    NetworkBarrierSeverity? severity,
    bool? bypassed,
    DateTime? bypassedDate,
    String? bypassMethod,
    Map<String, dynamic>? details,
  }) {
    return NetworkBarrier(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      bypassed: bypassed ?? this.bypassed,
      bypassedDate: bypassedDate ?? this.bypassedDate,
      bypassMethod: bypassMethod ?? this.bypassMethod,
      details: details ?? this.details,
    );
  }
}

/// Types of network barriers
enum NetworkBarrierType {
  /// Network Access Control (NAC) - requires device registration/compliance
  nac,

  /// Captive portal - web-based authentication required
  captivePortal,

  /// 802.1X authentication required
  dot1x,

  /// DHCP not available - static IP configuration required
  noDhcp,

  /// VLAN isolation - limited network segmentation
  vlanIsolation,

  /// Firewall blocking - traffic filtered
  firewallBlocking,

  /// MAC address filtering
  macFiltering,

  /// Certificate-based authentication
  certificateAuth,

  /// Unknown or custom barrier
  unknown;

  String get displayName {
    switch (this) {
      case NetworkBarrierType.nac:
        return 'NAC (Network Access Control)';
      case NetworkBarrierType.captivePortal:
        return 'Captive Portal';
      case NetworkBarrierType.dot1x:
        return '802.1X Authentication';
      case NetworkBarrierType.noDhcp:
        return 'No DHCP Available';
      case NetworkBarrierType.vlanIsolation:
        return 'VLAN Isolation';
      case NetworkBarrierType.firewallBlocking:
        return 'Firewall Blocking';
      case NetworkBarrierType.macFiltering:
        return 'MAC Address Filtering';
      case NetworkBarrierType.certificateAuth:
        return 'Certificate Authentication';
      case NetworkBarrierType.unknown:
        return 'Unknown Barrier';
    }
  }
}

/// Severity of network barriers
enum NetworkBarrierSeverity {
  /// Low severity - easy to bypass
  low,

  /// Medium severity - requires some effort to bypass
  medium,

  /// High severity - difficult to bypass, may require specific tools/knowledge
  high,

  /// Critical severity - very difficult to bypass, may require insider access
  critical;

  String get displayName {
    switch (this) {
      case NetworkBarrierSeverity.low:
        return 'Low';
      case NetworkBarrierSeverity.medium:
        return 'Medium';
      case NetworkBarrierSeverity.high:
        return 'High';
      case NetworkBarrierSeverity.critical:
        return 'Critical';
    }
  }
}

/// Common network access scenarios with predefined barriers
class NetworkAccessScenarios {
  /// Scenario 1: Connected with DHCP - full access immediately
  static NetworkAccessState dhcpAccess(String networkName) {
    return NetworkAccessState(
      networkId: 'net_${DateTime.now().millisecondsSinceEpoch}',
      networkName: networkName,
      accessLevel: NetworkAccessLevel.fullAccess,
      connectionType: NetworkConnectionType.ethernet,
      barriers: [],
      accessDetails: {
        'ip_assigned': true,
        'dhcp_available': true,
        'gateway_reachable': true,
      },
      discoveredDate: DateTime.now(),
      accessAchievedDate: DateTime.now(),
    );
  }

  /// Scenario 2: Static IP only - no DHCP available
  static NetworkAccessState staticIpOnly(String networkName) {
    return NetworkAccessState(
      networkId: 'net_${DateTime.now().millisecondsSinceEpoch}',
      networkName: networkName,
      accessLevel: NetworkAccessLevel.physicalOnly,
      connectionType: NetworkConnectionType.ethernet,
      barriers: [
        NetworkBarrier(
          id: 'barrier_no_dhcp',
          type: NetworkBarrierType.noDhcp,
          description: 'DHCP not available - static IP configuration required',
          severity: NetworkBarrierSeverity.medium,
        ),
      ],
      accessDetails: {
        'ip_assigned': false,
        'dhcp_available': false,
        'link_detected': true,
      },
      discoveredDate: DateTime.now(),
    );
  }

  /// Scenario 3: NAC blocking access
  static NetworkAccessState nacBlocked(String networkName) {
    return NetworkAccessState(
      networkId: 'net_${DateTime.now().millisecondsSinceEpoch}',
      networkName: networkName,
      accessLevel: NetworkAccessLevel.blocked,
      connectionType: NetworkConnectionType.ethernet,
      barriers: [
        NetworkBarrier(
          id: 'barrier_nac',
          type: NetworkBarrierType.nac,
          description: 'Network Access Control blocking unregistered device',
          severity: NetworkBarrierSeverity.high,
        ),
      ],
      accessDetails: {
        'ip_assigned': true,
        'dhcp_available': true,
        'nac_detected': true,
        'quarantine_vlan': true,
      },
      discoveredDate: DateTime.now(),
    );
  }

  /// Scenario 4: WiFi with captive portal
  static NetworkAccessState captivePortal(String networkName) {
    return NetworkAccessState(
      networkId: 'net_${DateTime.now().millisecondsSinceEpoch}',
      networkName: networkName,
      accessLevel: NetworkAccessLevel.blocked,
      connectionType: NetworkConnectionType.wifi,
      barriers: [
        NetworkBarrier(
          id: 'barrier_captive',
          type: NetworkBarrierType.captivePortal,
          description: 'Captive portal requiring authentication',
          severity: NetworkBarrierSeverity.medium,
        ),
      ],
      accessDetails: {
        'ip_assigned': true,
        'wifi_connected': true,
        'captive_portal_detected': true,
        'internet_blocked': true,
      },
      discoveredDate: DateTime.now(),
    );
  }

  /// Scenario 5: 802.1X authentication required
  static NetworkAccessState dot1xAuth(String networkName) {
    return NetworkAccessState(
      networkId: 'net_${DateTime.now().millisecondsSinceEpoch}',
      networkName: networkName,
      accessLevel: NetworkAccessLevel.physicalOnly,
      connectionType: NetworkConnectionType.ethernet,
      barriers: [
        NetworkBarrier(
          id: 'barrier_dot1x',
          type: NetworkBarrierType.dot1x,
          description: '802.1X authentication required for network access',
          severity: NetworkBarrierSeverity.high,
        ),
      ],
      accessDetails: {
        'link_detected': true,
        'dot1x_detected': true,
        'eap_method': 'EAP-TLS',
        'certificate_required': true,
      },
      discoveredDate: DateTime.now(),
    );
  }

  /// Scenario 6: Multiple barriers (realistic complex environment)
  static NetworkAccessState multipleBarriers(String networkName) {
    return NetworkAccessState(
      networkId: 'net_${DateTime.now().millisecondsSinceEpoch}',
      networkName: networkName,
      accessLevel: NetworkAccessLevel.partialAccess,
      connectionType: NetworkConnectionType.ethernet,
      barriers: [
        NetworkBarrier(
          id: 'barrier_mac_filter',
          type: NetworkBarrierType.macFiltering,
          description: 'MAC address filtering active',
          severity: NetworkBarrierSeverity.low,
          bypassed: true,
          bypassedDate: DateTime.now().subtract(const Duration(hours: 1)),
          bypassMethod: 'MAC spoofing',
        ),
        NetworkBarrier(
          id: 'barrier_vlan_isolation',
          type: NetworkBarrierType.vlanIsolation,
          description: 'VLAN isolation limiting network access',
          severity: NetworkBarrierSeverity.medium,
        ),
        NetworkBarrier(
          id: 'barrier_firewall',
          type: NetworkBarrierType.firewallBlocking,
          description: 'Firewall blocking most outbound connections',
          severity: NetworkBarrierSeverity.high,
        ),
      ],
      accessDetails: {
        'ip_assigned': true,
        'vlan_id': '100',
        'limited_connectivity': true,
        'internal_access_only': true,
      },
      discoveredDate: DateTime.now(),
    );
  }
}