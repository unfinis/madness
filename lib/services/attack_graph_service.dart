import 'dart:async';
import 'package:uuid/uuid.dart';
import '../models/attack_graph.dart';
import '../models/assets.dart';
import 'attack_chain_service.dart';

/// Service for managing dynamic attack graphs and property-driven workflows
class AttackGraphService {
  static final AttackGraphService _instance = AttackGraphService._internal();
  factory AttackGraphService() => _instance;
  AttackGraphService._internal();

  final _uuid = const Uuid();

  // Store attack graphs by project
  final Map<String, AttackGraph> _projectGraphs = {};

  // Stream for reactive updates
  final StreamController<AttackGraph> _graphController =
      StreamController<AttackGraph>.broadcast();

  Stream<AttackGraph> get graphStream => _graphController.stream;

  /// Initialize the service
  Future<void> initialize() async {
    // Pre-load any saved graphs
  }

  /// Get attack graph for a project
  AttackGraph? getProjectGraph(String projectId) {
    return _projectGraphs[projectId];
  }

  /// Create a new attack graph for a project
  AttackGraph createProjectGraph(String projectId) {
    final graph = AttackGraph(
      projectId: projectId,
      nodes: [],
      edges: [],
      createdDate: DateTime.now(),
      lastUpdated: DateTime.now(),
    );

    _projectGraphs[projectId] = graph;
    _graphController.add(graph);
    return graph;
  }

  /// Add a network asset and generate initial attack path
  Future<AttackGraph> addNetworkAsset(
    String projectId,
    Asset networkAsset,
  ) async {
    var graph = _projectGraphs[projectId] ?? createProjectGraph(projectId);

    // Generate attack path template for network to domain admin
    final newNodes = AttackPathTemplates.networkToDomainAdminPath(projectId, networkAsset.id);
    final newEdges = AttackPathTemplates.networkToDomainAdminEdges(networkAsset.id);

    // Add new nodes and edges to the graph
    graph = graph.copyWith(
      nodes: [...graph.nodes, ...newNodes],
      edges: [...graph.edges, ...newEdges],
      lastUpdated: DateTime.now(),
    );

    _projectGraphs[projectId] = graph;
    _graphController.add(graph);

    return graph;
  }

  /// Update node status and trigger new workflows based on outputs
  Future<AttackGraph> updateNodeStatus(
    String projectId,
    String nodeId,
    AttackNodeStatus status, {
    String? executionResult,
    Map<String, dynamic>? discoveredData,
  }) async {
    var graph = _projectGraphs[projectId];
    if (graph == null) return createProjectGraph(projectId);

    // Find and update the node
    final nodeIndex = graph.nodes.indexWhere((n) => n.id == nodeId);
    if (nodeIndex == -1) return graph;

    final updatedNode = graph.nodes[nodeIndex].copyWith(
      status: status,
      completedDate: status == AttackNodeStatus.completed ? DateTime.now() : null,
      executionResult: executionResult,
    );

    final updatedNodes = List<AttackNode>.from(graph.nodes);
    updatedNodes[nodeIndex] = updatedNode;

    graph = graph.copyWith(
      nodes: updatedNodes,
      lastUpdated: DateTime.now(),
    );

    // If node completed successfully, process outputs and trigger new workflows
    if (status == AttackNodeStatus.completed && discoveredData != null) {
      graph = await _processNodeOutputs(graph, updatedNode, discoveredData);
    }

    _projectGraphs[projectId] = graph;
    _graphController.add(graph);

    return graph;
  }

  /// Process node outputs and trigger new methodology workflows
  Future<AttackGraph> _processNodeOutputs(
    AttackGraph graph,
    AttackNode completedNode,
    Map<String, dynamic> discoveredData,
  ) async {
    var updatedGraph = graph;

    // Process each output from the completed node
    for (final output in completedNode.outputs) {
      final newWorkflows = await _triggerWorkflowsForProperty(
        graph.projectId,
        output.assetType,
        output.propertyKey,
        discoveredData[output.propertyKey],
      );

      // Add new nodes and edges for triggered workflows
      if (newWorkflows.isNotEmpty) {
        final newNodes = <AttackNode>[];
        final newEdges = <AttackEdge>[];

        for (final workflow in newWorkflows) {
          final workflowNodes = await _generateWorkflowNodes(
            graph.projectId,
            workflow,
            output.assetId ?? '',
            discoveredData,
          );

          newNodes.addAll(workflowNodes);

          // Create edges from completed node to new workflow nodes
          for (final newNode in workflowNodes) {
            newEdges.add(AttackEdge(
              id: _uuid.v4(),
              sourceId: completedNode.id,
              targetId: newNode.id,
              type: EdgeType.prerequisite,
            ));
          }
        }

        updatedGraph = updatedGraph.copyWith(
          nodes: [...updatedGraph.nodes, ...newNodes],
          edges: [...updatedGraph.edges, ...newEdges],
          lastUpdated: DateTime.now(),
        );
      }
    }

    return updatedGraph;
  }

  /// Get workflows to trigger based on asset property discovery
  Future<List<String>> _triggerWorkflowsForProperty(
    String projectId,
    String assetType,
    String propertyKey,
    dynamic propertyValue,
  ) async {
    final workflows = <String>[];

    // TODO: Update to use comprehensive asset system
    // For now, return empty list to avoid compilation errors
    // This service needs to be updated to work with Asset properties

    // Skip property.triggerWorkflows since property is not defined anymore

    // Add conditional workflows based on property value
    if (propertyKey == 'domain_name' && propertyValue != null) {
      workflows.addAll(['responder_attack', 'ldap_enumeration', 'kerberos_attacks']);
    }

    if (propertyKey == 'smb_signing' && propertyValue == false) {
      workflows.add('smb_relay_attack');
    }

    if (propertyKey == 'ipv6_enabled' && propertyValue == true) {
      workflows.addAll(['mitm6_attack', 'ipv6_enumeration']);
    }

    if (propertyKey == 'captured_hashes' && propertyValue is List && propertyValue.isNotEmpty) {
      workflows.addAll(['hash_cracking', 'pass_the_hash', 'smb_relay_attack', 'ldap_relay_attack']);
    }

    return workflows.toSet().toList(); // Remove duplicates
  }

  /// Generate nodes for a specific workflow
  Future<List<AttackNode>> _generateWorkflowNodes(
    String projectId,
    String workflowType,
    String assetId,
    Map<String, dynamic> context,
  ) async {
    final nodes = <AttackNode>[];

    switch (workflowType) {
      case 'network_scanning':
        nodes.add(_createScanningNode(projectId, assetId, context));
        break;

      case 'responder_attack':
        nodes.add(_createResponderNode(projectId, assetId, context));
        break;

      case 'mitm6_attack':
        nodes.add(_createMitm6Node(projectId, assetId, context));
        break;

      case 'hash_cracking':
        nodes.add(_createHashCrackingNode(projectId, assetId, context));
        break;

      case 'smb_relay_attack':
        nodes.add(_createSmbRelayNode(projectId, assetId, context));
        break;

      case 'ldap_relay_attack':
        nodes.add(_createLdapRelayNode(projectId, assetId, context));
        break;

      case 'domain_enumeration':
        nodes.addAll(_createDomainEnumNodes(projectId, assetId, context));
        break;

      case 'service_enumeration':
        nodes.addAll(_createServiceEnumNodes(projectId, assetId, context));
        break;
    }

    return nodes;
  }

  AttackNode _createScanningNode(String projectId, String assetId, Map<String, dynamic> context) {
    return AttackNode(
      id: _uuid.v4(),
      projectId: projectId,
      title: 'Network Scanning: ${context['subnet'] ?? 'Target Network'}',
      description: 'Comprehensive network scan for hosts and services',
      methodologyId: 'network_scanning',
      phase: AttackChainPhase.reconnaissance,
      priority: 8,
      potentialImpact: 0.6,
      estimatedDuration: Duration(minutes: 30),
      requirements: [
        AssetPropertyRequirement(
          assetType: 'network',
          propertyKey: 'subnet',
          type: PropertyRequirementType.notEmpty,
          assetId: assetId,
        ),
      ],
      outputs: [
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'live_hosts',
          value: '{discovered_hosts}',
          assetId: assetId,
        ),
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'open_ports',
          value: '{discovered_ports}',
          assetId: assetId,
        ),
      ],
      context: context,
      createdDate: DateTime.now(),
    );
  }

  AttackNode _createResponderNode(String projectId, String assetId, Map<String, dynamic> context) {
    return AttackNode(
      id: _uuid.v4(),
      projectId: projectId,
      title: 'Responder Attack: ${context['domain_name'] ?? 'AD Domain'}',
      description: 'Capture NTLM hashes using Responder tool',
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
          assetId: assetId,
        ),
      ],
      outputs: [
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'captured_hashes',
          value: '{ntlm_hashes}',
          assetId: assetId,
        ),
      ],
      context: context,
      createdDate: DateTime.now(),
    );
  }

  AttackNode _createMitm6Node(String projectId, String assetId, Map<String, dynamic> context) {
    return AttackNode(
      id: _uuid.v4(),
      projectId: projectId,
      title: 'mitm6 IPv6 Attack',
      description: 'DHCPv6 spoofing and WPAD abuse via IPv6',
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
          assetId: assetId,
        ),
      ],
      outputs: [
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'captured_hashes',
          value: '{ipv6_hashes}',
          assetId: assetId,
        ),
      ],
      context: context,
      createdDate: DateTime.now(),
    );
  }

  AttackNode _createHashCrackingNode(String projectId, String assetId, Map<String, dynamic> context) {
    return AttackNode(
      id: _uuid.v4(),
      projectId: projectId,
      title: 'Hash Cracking',
      description: 'Crack captured NTLM hashes offline',
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
          assetId: assetId,
        ),
      ],
      outputs: [
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'cracked_passwords',
          value: '{cracked_passwords}',
          assetId: assetId,
        ),
      ],
      context: context,
      createdDate: DateTime.now(),
    );
  }

  AttackNode _createSmbRelayNode(String projectId, String assetId, Map<String, dynamic> context) {
    return AttackNode(
      id: _uuid.v4(),
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
          assetId: assetId,
        ),
        AssetPropertyRequirement(
          assetType: 'network',
          propertyKey: 'captured_hashes',
          type: PropertyRequirementType.notEmpty,
          assetId: assetId,
        ),
      ],
      outputs: [
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'admin_access',
          value: true,
          assetId: assetId,
        ),
      ],
      context: context,
      createdDate: DateTime.now(),
    );
  }

  AttackNode _createLdapRelayNode(String projectId, String assetId, Map<String, dynamic> context) {
    return AttackNode(
      id: _uuid.v4(),
      projectId: projectId,
      title: 'LDAP Relay Attack',
      description: 'Relay NTLM authentication to LDAP for domain escalation',
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
          assetId: assetId,
        ),
        AssetPropertyRequirement(
          assetType: 'network',
          propertyKey: 'captured_hashes',
          type: PropertyRequirementType.notEmpty,
          assetId: assetId,
        ),
      ],
      outputs: [
        AssetPropertyOutput(
          assetType: 'network',
          propertyKey: 'domain_admin_access',
          value: true,
          assetId: assetId,
        ),
      ],
      context: context,
      createdDate: DateTime.now(),
    );
  }

  List<AttackNode> _createDomainEnumNodes(String projectId, String assetId, Map<String, dynamic> context) {
    return [
      AttackNode(
        id: _uuid.v4(),
        projectId: projectId,
        title: 'Domain Controller Discovery',
        description: 'Identify and enumerate domain controllers',
        methodologyId: 'dc_discovery',
        phase: AttackChainPhase.reconnaissance,
        priority: 8,
        potentialImpact: 0.6,
        estimatedDuration: Duration(minutes: 15),
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'domain_controllers',
            value: '{domain_controllers}',
            assetId: assetId,
          ),
        ],
        context: context,
        createdDate: DateTime.now(),
      ),
      AttackNode(
        id: _uuid.v4(),
        projectId: projectId,
        title: 'LDAP Enumeration',
        description: 'Enumerate Active Directory via LDAP',
        methodologyId: 'ldap_enumeration',
        phase: AttackChainPhase.reconnaissance,
        priority: 7,
        potentialImpact: 0.7,
        estimatedDuration: Duration(minutes: 30),
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'service_accounts',
            value: '{service_accounts}',
            assetId: assetId,
          ),
        ],
        context: context,
        createdDate: DateTime.now(),
      ),
    ];
  }

  List<AttackNode> _createServiceEnumNodes(String projectId, String assetId, Map<String, dynamic> context) {
    return [
      AttackNode(
        id: _uuid.v4(),
        projectId: projectId,
        title: 'SMB Enumeration',
        description: 'Enumerate SMB shares and security settings',
        methodologyId: 'smb_enumeration',
        phase: AttackChainPhase.reconnaissance,
        priority: 7,
        potentialImpact: 0.5,
        estimatedDuration: Duration(minutes: 20),
        outputs: [
          AssetPropertyOutput(
            assetType: 'network',
            propertyKey: 'smb_signing',
            value: '{smb_signing_status}',
            assetId: assetId,
          ),
        ],
        context: context,
        createdDate: DateTime.now(),
      ),
    ];
  }

  /// Get next recommended attack nodes based on current asset state
  List<AttackNode> getRecommendedAttacks(String projectId, List<Asset> assets) {
    final graph = _projectGraphs[projectId];
    if (graph == null) return [];

    final executable = graph.nodes.where((node) {
      if (node.status != AttackNodeStatus.pending) return false;
      return node.canExecute(assets);
    }).toList();

    // Sort by priority and potential impact
    executable.sort((a, b) {
      final priorityCompare = b.priority.compareTo(a.priority);
      if (priorityCompare != 0) return priorityCompare;
      return b.potentialImpact.compareTo(a.potentialImpact);
    });

    return executable.take(5).toList();
  }

  /// Get attack graph visualization data
  Map<String, dynamic> getGraphVisualization(String projectId) {
    final graph = _projectGraphs[projectId];
    if (graph == null) return {};

    return {
      'nodes': graph.nodes.map((node) => {
        'id': node.id,
        'title': node.title,
        'phase': node.phase.name,
        'status': node.status.name,
        'priority': node.priority,
        'impact': node.potentialImpact,
        'canExecute': node.requirements.every((req) => true), // Simplified for visualization
      }).toList(),
      'edges': graph.edges.map((edge) => {
        'source': edge.sourceId,
        'target': edge.targetId,
        'type': edge.type.name,
        'required': edge.isRequired,
      }).toList(),
    };
  }
}