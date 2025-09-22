import '../services/attack_chain_service.dart';
import 'assets.dart';

/// Dynamic attack graph that represents non-linear attack paths
class AttackGraph {
  final String projectId;
  final List<AttackNode> nodes;
  final List<AttackEdge> edges;
  final DateTime createdDate;
  final DateTime lastUpdated;

  const AttackGraph({
    required this.projectId,
    required this.nodes,
    required this.edges,
    required this.createdDate,
    required this.lastUpdated,
  });

  AttackGraph copyWith({
    String? projectId,
    List<AttackNode>? nodes,
    List<AttackEdge>? edges,
    DateTime? createdDate,
    DateTime? lastUpdated,
  }) {
    return AttackGraph(
      projectId: projectId ?? this.projectId,
      nodes: nodes ?? this.nodes,
      edges: edges ?? this.edges,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Get all nodes that are currently executable (all dependencies met)
  List<AttackNode> getExecutableNodes() {
    return nodes.where((node) {
      if (node.status != AttackNodeStatus.pending) return false;

      // Check if all dependencies are completed
      final dependencies = edges.where((edge) => edge.targetId == node.id);
      return dependencies.every((dep) {
        final sourceNode = nodes.firstWhere((n) => n.id == dep.sourceId);
        return sourceNode.status == AttackNodeStatus.completed;
      });
    }).toList();
  }

  /// Get all completed nodes
  List<AttackNode> getCompletedNodes() {
    return nodes.where((node) => node.status == AttackNodeStatus.completed).toList();
  }

  /// Get next recommended nodes based on completed nodes and asset properties
  List<AttackNode> getRecommendedNodes() {
    final executable = getExecutableNodes();

    // Sort by priority and potential impact
    executable.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.potentialImpact.compareTo(a.potentialImpact);
    });

    return executable.take(5).toList(); // Top 5 recommendations
  }
}

/// Individual node in the attack graph
class AttackNode {
  final String id;
  final String projectId;
  final String title;
  final String description;
  final String methodologyId;
  final AttackNodeStatus status;
  final AttackChainPhase phase;
  final int priority;
  final double potentialImpact; // 0.0 to 1.0
  final Duration estimatedDuration;
  final List<AssetPropertyRequirement> requirements;
  final List<AssetPropertyOutput> outputs;
  final Map<String, dynamic> context;
  final DateTime createdDate;
  final DateTime? completedDate;
  final String? executionResult;

  const AttackNode({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.methodologyId,
    this.status = AttackNodeStatus.pending,
    required this.phase,
    this.priority = 5,
    this.potentialImpact = 0.5,
    required this.estimatedDuration,
    this.requirements = const [],
    this.outputs = const [],
    this.context = const {},
    required this.createdDate,
    this.completedDate,
    this.executionResult,
  });

  AttackNode copyWith({
    String? id,
    String? projectId,
    String? title,
    String? description,
    String? methodologyId,
    AttackNodeStatus? status,
    AttackChainPhase? phase,
    int? priority,
    double? potentialImpact,
    Duration? estimatedDuration,
    List<AssetPropertyRequirement>? requirements,
    List<AssetPropertyOutput>? outputs,
    Map<String, dynamic>? context,
    DateTime? createdDate,
    DateTime? completedDate,
    String? executionResult,
  }) {
    return AttackNode(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      methodologyId: methodologyId ?? this.methodologyId,
      status: status ?? this.status,
      phase: phase ?? this.phase,
      priority: priority ?? this.priority,
      potentialImpact: potentialImpact ?? this.potentialImpact,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      requirements: requirements ?? this.requirements,
      outputs: outputs ?? this.outputs,
      context: context ?? this.context,
      createdDate: createdDate ?? this.createdDate,
      completedDate: completedDate ?? this.completedDate,
      executionResult: executionResult ?? this.executionResult,
    );
  }

  /// Check if this node can be executed based on asset properties
  bool canExecute(List<Asset> assets) {
    return requirements.every((req) => req.isSatisfied(assets));
  }
}

enum AttackNodeStatus {
  pending,
  inProgress,
  completed,
  failed,
  skipped,
  blocked,
}

/// Edge connecting two nodes (dependency relationship)
class AttackEdge {
  final String id;
  final String sourceId; // prerequisite node
  final String targetId; // dependent node
  final EdgeType type;
  final bool isRequired; // false for optional dependencies
  final String? condition; // condition that must be met

  const AttackEdge({
    required this.id,
    required this.sourceId,
    required this.targetId,
    this.type = EdgeType.prerequisite,
    this.isRequired = true,
    this.condition,
  });
}

enum EdgeType {
  prerequisite, // must complete source before target
  alternative, // either source OR target can be done
  conditional, // target only if condition is met
  parallel, // can be done in parallel
}

/// Asset property requirement for executing a node
class AssetPropertyRequirement {
  final String assetType; // 'network', 'host', 'service', etc.
  final String propertyKey;
  final PropertyRequirementType type;
  final dynamic expectedValue;
  final String? assetId; // specific asset ID, null for any asset of type

  const AssetPropertyRequirement({
    required this.assetType,
    required this.propertyKey,
    required this.type,
    this.expectedValue,
    this.assetId,
  });

  /// Check if this requirement is satisfied by current assets
  bool isSatisfied(List<Asset> assets) {
    final relevantAssets = assetId != null
        ? assets.where((a) => a.id == assetId)
        : assets.where((a) => a.type.name == assetType);

    for (final asset in relevantAssets) {
      final property = asset.properties[propertyKey];
      if (property == null) continue;

      switch (type) {
        case PropertyRequirementType.exists:
          return true;
        case PropertyRequirementType.equals:
          return property.when(
            string: (v) => v == expectedValue,
            integer: (v) => v == expectedValue,
            double: (v) => v == expectedValue,
            boolean: (v) => v == expectedValue,
            stringList: (v) => v.contains(expectedValue),
            dateTime: (v) => v == expectedValue,
            map: (v) => v[expectedValue] != null,
            objectList: (v) => v.any((obj) => obj == expectedValue),
          );
        case PropertyRequirementType.notEmpty:
          return property.when(
            string: (v) => v.isNotEmpty,
            integer: (v) => v != 0,
            double: (v) => v != 0.0,
            boolean: (v) => v,
            stringList: (v) => v.isNotEmpty,
            dateTime: (v) => true,
            map: (v) => v.isNotEmpty,
            objectList: (v) => v.isNotEmpty,
          );
        case PropertyRequirementType.contains:
          return property.when(
            string: (v) => v.contains(expectedValue.toString()),
            integer: (v) => v.toString().contains(expectedValue.toString()),
            double: (v) => v.toString().contains(expectedValue.toString()),
            boolean: (v) => false,
            stringList: (v) => v.contains(expectedValue),
            dateTime: (v) => v.toString().contains(expectedValue.toString()),
            map: (v) => v.containsKey(expectedValue) || v.containsValue(expectedValue),
            objectList: (v) => v.any((obj) => obj.toString().contains(expectedValue.toString())),
          );
      }
    }

    return false;
  }
}

enum PropertyRequirementType {
  exists, // property just needs to exist
  equals, // property must equal specific value
  notEmpty, // property must not be empty/null
  contains, // property must contain specific value
}

/// Asset property that will be set when node completes
class AssetPropertyOutput {
  final String assetType;
  final String propertyKey;
  final dynamic value;
  final String? assetId;

  const AssetPropertyOutput({
    required this.assetType,
    required this.propertyKey,
    required this.value,
    this.assetId,
  });
}

/// Pre-defined attack paths for common scenarios
class AttackPathTemplates {
  /// Network segment to Domain Admin attack path
  static List<AttackNode> networkToDomainAdminPath(String projectId, String networkAssetId) {
    return [
      // 1. Network Discovery
      AttackNode(
        id: 'network-discovery-$networkAssetId',
        projectId: projectId,
        title: 'Network Discovery',
        description: 'Discover network range and configuration',
        methodologyId: 'network_discovery',
        phase: AttackChainPhase.reconnaissance,
        priority: 10,
        potentialImpact: 0.3,
        estimatedDuration: Duration(minutes: 15),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'access_level',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'subnet',
            value: '{discovered_subnet}',
            assetId: networkAssetId,
          ),
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'gateway',
            value: '{discovered_gateway}',
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 2. Host Discovery
      AttackNode(
        id: 'host-discovery-$networkAssetId',
        projectId: projectId,
        title: 'Host Discovery',
        description: 'Scan network for live hosts',
        methodologyId: 'host_discovery',
        phase: AttackChainPhase.reconnaissance,
        priority: 9,
        potentialImpact: 0.4,
        estimatedDuration: Duration(minutes: 20),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'subnet',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'live_hosts',
            value: '{discovered_hosts}',
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 3. Service Discovery
      AttackNode(
        id: 'service-discovery-$networkAssetId',
        projectId: projectId,
        title: 'Service Discovery',
        description: 'Enumerate services on discovered hosts',
        methodologyId: 'service_discovery',
        phase: AttackChainPhase.reconnaissance,
        priority: 8,
        potentialImpact: 0.5,
        estimatedDuration: Duration(minutes: 30),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'live_hosts',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'smb_hosts',
            value: '{smb_hosts}',
            assetId: networkAssetId,
          ),
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'web_services',
            value: '{web_services}',
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 4. Responder Attack (if domain detected)
      AttackNode(
        id: 'responder-attack-$networkAssetId',
        projectId: projectId,
        title: 'Responder Attack',
        description: 'Capture NTLM hashes using Responder',
        methodologyId: 'responder_attack',
        phase: AttackChainPhase.credentialAccess,
        priority: 9,
        potentialImpact: 0.8,
        estimatedDuration: Duration(hours: 2),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'domain_name',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'captured_hashes',
            value: '{ntlm_hashes}',
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 5. mitm6 Attack (if IPv6 enabled)
      AttackNode(
        id: 'mitm6-attack-$networkAssetId',
        projectId: projectId,
        title: 'mitm6 Attack',
        description: 'IPv6 DHCPv6 spoofing attack',
        methodologyId: 'mitm6_attack',
        phase: AttackChainPhase.credentialAccess,
        priority: 8,
        potentialImpact: 0.9,
        estimatedDuration: Duration(hours: 1),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'ipv6_enabled',
            type: PropertyRequirementType.equals,
            expectedValue: true,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'captured_hashes',
            value: '{ipv6_hashes}',
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 6. Hash Cracking
      AttackNode(
        id: 'hash-cracking-$networkAssetId',
        projectId: projectId,
        title: 'Hash Cracking',
        description: 'Crack captured NTLM hashes',
        methodologyId: 'hash_cracking',
        phase: AttackChainPhase.credentialAccess,
        priority: 7,
        potentialImpact: 0.7,
        estimatedDuration: Duration(hours: 4),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'captured_hashes',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'cracked_passwords',
            value: '{cracked_passwords}',
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 7. SMB Relay Attack (if SMB signing disabled)
      AttackNode(
        id: 'smb-relay-$networkAssetId',
        projectId: projectId,
        title: 'SMB Relay Attack',
        description: 'Relay NTLM authentication to SMB services',
        methodologyId: 'smb_relay_attack',
        phase: AttackChainPhase.lateralMovement,
        priority: 9,
        potentialImpact: 0.9,
        estimatedDuration: Duration(minutes: 30),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'smb_signing',
            type: PropertyRequirementType.equals,
            expectedValue: false,
            assetId: networkAssetId,
          ),
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'captured_hashes',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'admin_access',
            value: true,
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),

      // 8. LDAP Relay Attack
      AttackNode(
        id: 'ldap-relay-$networkAssetId',
        projectId: projectId,
        title: 'LDAP Relay Attack',
        description: 'Relay NTLM authentication to LDAP/LDAPS',
        methodologyId: 'ldap_relay_attack',
        phase: AttackChainPhase.persistence,
        priority: 10,
        potentialImpact: 1.0,
        estimatedDuration: Duration(minutes: 45),
        requirements: [
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'domain_controllers',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
          AssetPropertyRequirement(
            assetType: 'network',
            propertyKey: 'captured_hashes',
            type: PropertyRequirementType.notEmpty,
            assetId: networkAssetId,
          ),
        ],
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'domain_admin_access',
            value: true,
            assetId: networkAssetId,
          ),
        ],
        createdDate: DateTime.now(),
      ),
    ];
  }

  /// Create edges for the network to domain admin path
  static List<AttackEdge> networkToDomainAdminEdges(String networkAssetId) {
    return [
      // Network Discovery -> Host Discovery
      AttackEdge(
        id: 'edge-1-$networkAssetId',
        sourceId: 'network-discovery-$networkAssetId',
        targetId: 'host-discovery-$networkAssetId',
        type: EdgeType.prerequisite,
      ),

      // Host Discovery -> Service Discovery
      AttackEdge(
        id: 'edge-2-$networkAssetId',
        sourceId: 'host-discovery-$networkAssetId',
        targetId: 'service-discovery-$networkAssetId',
        type: EdgeType.prerequisite,
      ),

      // Service Discovery -> Responder (parallel with mitm6)
      AttackEdge(
        id: 'edge-3-$networkAssetId',
        sourceId: 'service-discovery-$networkAssetId',
        targetId: 'responder-attack-$networkAssetId',
        type: EdgeType.parallel,
      ),

      // Service Discovery -> mitm6 (parallel with Responder)
      AttackEdge(
        id: 'edge-4-$networkAssetId',
        sourceId: 'service-discovery-$networkAssetId',
        targetId: 'mitm6-attack-$networkAssetId',
        type: EdgeType.parallel,
      ),

      // Both Responder and mitm6 -> Hash Cracking (either one can feed into cracking)
      AttackEdge(
        id: 'edge-5-$networkAssetId',
        sourceId: 'responder-attack-$networkAssetId',
        targetId: 'hash-cracking-$networkAssetId',
        type: EdgeType.alternative,
      ),
      AttackEdge(
        id: 'edge-6-$networkAssetId',
        sourceId: 'mitm6-attack-$networkAssetId',
        targetId: 'hash-cracking-$networkAssetId',
        type: EdgeType.alternative,
      ),

      // Captured hashes -> SMB Relay (parallel with LDAP Relay)
      AttackEdge(
        id: 'edge-7-$networkAssetId',
        sourceId: 'responder-attack-$networkAssetId',
        targetId: 'smb-relay-$networkAssetId',
        type: EdgeType.conditional,
        condition: 'smb_signing_disabled',
      ),
      AttackEdge(
        id: 'edge-8-$networkAssetId',
        sourceId: 'mitm6-attack-$networkAssetId',
        targetId: 'smb-relay-$networkAssetId',
        type: EdgeType.conditional,
        condition: 'smb_signing_disabled',
      ),

      // Captured hashes -> LDAP Relay (parallel with SMB Relay)
      AttackEdge(
        id: 'edge-9-$networkAssetId',
        sourceId: 'responder-attack-$networkAssetId',
        targetId: 'ldap-relay-$networkAssetId',
        type: EdgeType.parallel,
      ),
      AttackEdge(
        id: 'edge-10-$networkAssetId',
        sourceId: 'mitm6-attack-$networkAssetId',
        targetId: 'ldap-relay-$networkAssetId',
        type: EdgeType.parallel,
      ),
    ];
  }
}