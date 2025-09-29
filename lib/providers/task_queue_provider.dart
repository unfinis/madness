import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import '../models/scope.dart';
import '../models/credential.dart';
import '../services/trigger_evaluator.dart';
import 'methodology_provider.dart';
import 'projects_provider.dart';
import 'scope_provider.dart';
import 'credential_provider.dart';

class TaskInstance {
  final String id;
  final String methodologyId;
  final String methodologyName;
  final List<TriggerInstance> triggers;
  final TaskStatus status;
  final int completedCount;
  final DateTime createdDate;
  final DateTime? completedDate;

  const TaskInstance({
    required this.id,
    required this.methodologyId,
    required this.methodologyName,
    required this.triggers,
    required this.status,
    required this.completedCount,
    required this.createdDate,
    this.completedDate,
  });

  TaskInstance copyWith({
    String? id,
    String? methodologyId,
    String? methodologyName,
    List<TriggerInstance>? triggers,
    TaskStatus? status,
    int? completedCount,
    DateTime? createdDate,
    DateTime? completedDate,
  }) {
    return TaskInstance(
      id: id ?? this.id,
      methodologyId: methodologyId ?? this.methodologyId,
      methodologyName: methodologyName ?? this.methodologyName,
      triggers: triggers ?? this.triggers,
      status: status ?? this.status,
      completedCount: completedCount ?? this.completedCount,
      createdDate: createdDate ?? this.createdDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}

class TriggerInstance {
  final String id;
  final String triggerId;
  final Map<String, dynamic> context;
  final TriggerStatus status;
  final String? output;
  final Map<String, dynamic>? parsedResults;
  final DateTime? executedDate;

  const TriggerInstance({
    required this.id,
    required this.triggerId,
    required this.context,
    required this.status,
    this.output,
    this.parsedResults,
    this.executedDate,
  });

  TriggerInstance copyWith({
    String? id,
    String? triggerId,
    Map<String, dynamic>? context,
    TriggerStatus? status,
    String? output,
    Map<String, dynamic>? parsedResults,
    DateTime? executedDate,
  }) {
    return TriggerInstance(
      id: id ?? this.id,
      triggerId: triggerId ?? this.triggerId,
      context: context ?? this.context,
      status: status ?? this.status,
      output: output ?? this.output,
      parsedResults: parsedResults ?? this.parsedResults,
      executedDate: executedDate ?? this.executedDate,
    );
  }
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  failed,
  cancelled,
}

enum TriggerStatus {
  pending,
  running,
  completed,
  failed,
  skipped,
}

class TaskQueueState {
  final List<TaskInstance> tasks;
  final bool isLoading;
  final String? error;

  const TaskQueueState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
  });

  TaskQueueState copyWith({
    List<TaskInstance>? tasks,
    bool? isLoading,
    String? error,
  }) {
    return TaskQueueState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TaskQueueNotifier extends StateNotifier<TaskQueueState> {
  final Ref ref;
  final _uuid = const Uuid();
  // TriggerEvaluator only has static methods, no need for instance
  final Map<String, Set<String>> _processedTriggers = {};

  TaskQueueNotifier(this.ref) : super(const TaskQueueState()) {
    _initialize();
  }

  void _initialize() {
    final projectId = ref.read(currentProjectProvider)?.id;
    if (projectId == null) return;

    ref.listen(scopeProvider, (previous, next) {
      _evaluateTriggersFromScopeChanges(previous, next, projectId);
    });

    ref.listen(credentialProvider, (previous, next) {
      _evaluateTriggersFromCredentialChanges(previous, next, projectId);
    });

    ref.listen(methodologyProvider(projectId), (previous, next) {
      _evaluateTriggersFromAssetChanges(previous?.discoveredAssets, next.discoveredAssets, projectId);
    });
  }

  void _evaluateTriggersFromScopeChanges(
    List<ScopeSegment>? previous,
    List<ScopeSegment> next,
    String projectId,
  ) {
    final previousItems = previous ?? [];
    final currentItems = next;

    if (previousItems.length == currentItems.length) {
      return;
    }

    final assets = _convertScopeItemsToAssets(currentItems);
    _evaluateAllTriggers(assets, projectId);
  }

  void _evaluateTriggersFromCredentialChanges(
    List<Credential>? previous,
    List<Credential> next,
    String projectId,
  ) {
    final previousCreds = previous ?? [];
    final currentCreds = next;

    if (previousCreds.length == currentCreds.length) {
      return;
    }

    final assets = _convertCredentialsToAssets(currentCreds);
    _evaluateAllTriggers(assets, projectId);
  }

  void _evaluateTriggersFromAssetChanges(
    List<DiscoveredAsset>? previous,
    List<DiscoveredAsset> current,
    String projectId,
  ) {
    if ((previous?.length ?? 0) == current.length) {
      return;
    }

    final assets = _convertDiscoveredAssetsToMaps(current);
    _evaluateAllTriggers(assets, projectId);
  }

  void _evaluateAllTriggers(List<Map<String, dynamic>> assets, String projectId) {
    final methodologies = _getAvailableMethodologies(projectId);

    for (final methodology in methodologies) {
      for (final trigger in methodology.triggers) {
        final matches = TriggerEvaluator.findMatchingAssets(trigger, assets);

        for (final match in matches) {
          _createOrUpdateTask(methodology, trigger, match);
        }
      }
    }
  }

  void _createOrUpdateTask(
    Methodology methodology,
    MethodologyTrigger trigger,
    Map<String, dynamic> context,
  ) {
    final signature = _generateTriggerSignature(methodology.id, trigger.id, context);

    final signatureSet = _processedTriggers.putIfAbsent(methodology.id, () => {});

    if (trigger.deduplication.strategy == 'signature_based') {
      if (signatureSet.contains(signature)) {
        return;
      }
    }

    if (trigger.deduplication.maxExecutions != null) {
      final executionCount = signatureSet.where((s) => s.startsWith('${methodology.id}_${trigger.id}')).length;
      if (executionCount >= trigger.deduplication.maxExecutions!) {
        return;
      }
    }

    final existingTaskIndex = state.tasks.indexWhere((t) => t.methodologyId == methodology.id);

    if (existingTaskIndex >= 0) {
      final existingTask = state.tasks[existingTaskIndex];

      final existingTriggerIds = existingTask.triggers.map((t) => '${t.triggerId}_${t.context.toString()}').toSet();
      final newTriggerId = '${trigger.id}_${context.toString()}';

      if (!existingTriggerIds.contains(newTriggerId)) {
        final newTrigger = TriggerInstance(
          id: _uuid.v4(),
          triggerId: trigger.id,
          context: context,
          status: TriggerStatus.pending,
        );

        final updatedTriggers = [...existingTask.triggers, newTrigger];
        final updatedTask = existingTask.copyWith(triggers: updatedTriggers);

        final updatedTasks = [...state.tasks];
        updatedTasks[existingTaskIndex] = updatedTask;

        state = state.copyWith(tasks: updatedTasks);
        signatureSet.add(signature);
      }
    } else {
      final newTrigger = TriggerInstance(
        id: _uuid.v4(),
        triggerId: trigger.id,
        context: context,
        status: TriggerStatus.pending,
      );

      final newTask = TaskInstance(
        id: _uuid.v4(),
        methodologyId: methodology.id,
        methodologyName: methodology.name,
        triggers: [newTrigger],
        status: TaskStatus.pending,
        completedCount: 0,
        createdDate: DateTime.now(),
      );

      state = state.copyWith(tasks: [...state.tasks, newTask]);
      signatureSet.add(signature);
    }
  }

  String _generateTriggerSignature(
    String methodologyId,
    String triggerId,
    Map<String, dynamic> context,
  ) {
    final parts = [methodologyId, triggerId];

    if (context.containsKey('host')) {
      parts.add(context['host'].toString());
    }
    if (context.containsKey('asset_id')) {
      parts.add(context['asset_id'].toString());
    }
    if (context.containsKey('credential_id')) {
      parts.add(context['credential_id'].toString());
    }

    return parts.join('_');
  }

  void executeTrigger(String taskId, String triggerId) {
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex < 0) return;

    final task = state.tasks[taskIndex];
    final triggerIndex = task.triggers.indexWhere((t) => t.id == triggerId);
    if (triggerIndex < 0) return;

    final trigger = task.triggers[triggerIndex];
    final updatedTrigger = trigger.copyWith(
      status: TriggerStatus.running,
      executedDate: DateTime.now(),
    );

    final updatedTriggers = [...task.triggers];
    updatedTriggers[triggerIndex] = updatedTrigger;

    final updatedTask = task.copyWith(
      triggers: updatedTriggers,
      status: TaskStatus.inProgress,
    );

    final updatedTasks = [...state.tasks];
    updatedTasks[taskIndex] = updatedTask;

    state = state.copyWith(tasks: updatedTasks);
  }

  void completeWithOutput(String taskId, String triggerId, String output) {
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex < 0) return;

    final task = state.tasks[taskIndex];
    final triggerIndex = task.triggers.indexWhere((t) => t.id == triggerId);
    if (triggerIndex < 0) return;

    final trigger = task.triggers[triggerIndex];
    final parsedResults = _parseOutput(output);

    final updatedTrigger = trigger.copyWith(
      status: TriggerStatus.completed,
      output: output,
      parsedResults: parsedResults,
    );

    final updatedTriggers = [...task.triggers];
    updatedTriggers[triggerIndex] = updatedTrigger;

    final completedCount = updatedTriggers.where((t) => t.status == TriggerStatus.completed).length;
    final allCompleted = updatedTriggers.every((t) =>
      t.status == TriggerStatus.completed || t.status == TriggerStatus.skipped
    );

    final updatedTask = task.copyWith(
      triggers: updatedTriggers,
      completedCount: completedCount,
      status: allCompleted ? TaskStatus.completed : task.status,
      completedDate: allCompleted ? DateTime.now() : null,
    );

    final updatedTasks = [...state.tasks];
    updatedTasks[taskIndex] = updatedTask;

    state = state.copyWith(tasks: updatedTasks);

    if (parsedResults.isNotEmpty) {
      _updateAssetsWithResults(parsedResults);
    }
  }

  void skipTrigger(String taskId, String triggerId) {
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex < 0) return;

    final task = state.tasks[taskIndex];
    final triggerIndex = task.triggers.indexWhere((t) => t.id == triggerId);
    if (triggerIndex < 0) return;

    final trigger = task.triggers[triggerIndex];
    final updatedTrigger = trigger.copyWith(status: TriggerStatus.skipped);

    final updatedTriggers = [...task.triggers];
    updatedTriggers[triggerIndex] = updatedTrigger;

    final allCompleted = updatedTriggers.every((t) =>
      t.status == TriggerStatus.completed || t.status == TriggerStatus.skipped
    );

    final updatedTask = task.copyWith(
      triggers: updatedTriggers,
      status: allCompleted ? TaskStatus.completed : task.status,
      completedDate: allCompleted ? DateTime.now() : null,
    );

    final updatedTasks = [...state.tasks];
    updatedTasks[taskIndex] = updatedTask;

    state = state.copyWith(tasks: updatedTasks);
  }

  void addTask(TaskInstance task) {
    final updatedTasks = [...state.tasks, task];
    state = state.copyWith(tasks: updatedTasks);
  }

  void removeTask(String taskId) {
    final updatedTasks = state.tasks.where((t) => t.id != taskId).toList();
    state = state.copyWith(tasks: updatedTasks);
  }

  void clearCompletedTasks() {
    final updatedTasks = state.tasks.where((t) => t.status != TaskStatus.completed).toList();
    state = state.copyWith(tasks: updatedTasks);
  }

  /// Execute a complete task - runs the methodology
  Future<void> executeTask(String taskId) async {
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = state.tasks[taskIndex];
    final projectId = ref.read(currentProjectProvider)?.id;
    if (projectId == null) return;

    try {
      // Update task status to running
      _updateTaskStatus(taskId, TaskStatus.inProgress);

      // Get the methodology
      final methodology = _getMethodologyById(task.methodologyId, projectId);
      if (methodology == null) {
        throw Exception('Methodology not found: ${task.methodologyId}');
      }

      // Execute via methodology engine
      final methodologyNotifier = ref.read(methodologyProvider(projectId).notifier);

      // Start methodology execution with trigger context
      final triggerContext = task.triggers.isNotEmpty
          ? task.triggers.first.context
          : <String, dynamic>{};

      await methodologyNotifier.startMethodology(
        methodology.id,
        additionalContext: triggerContext,
      );

      // Mark task as completed
      _updateTaskStatus(taskId, TaskStatus.completed);

    } catch (e) {
      print('Error executing task $taskId: $e');
      _updateTaskStatus(taskId, TaskStatus.failed);
      rethrow;
    }
  }

  /// Update task status
  void _updateTaskStatus(String taskId, TaskStatus newStatus) {
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = state.tasks[taskIndex];
    final updatedTask = task.copyWith(
      status: newStatus,
      completedDate: newStatus == TaskStatus.completed ? DateTime.now() : null,
    );

    final updatedTasks = [...state.tasks];
    updatedTasks[taskIndex] = updatedTask;

    state = state.copyWith(tasks: updatedTasks);
  }

  /// Complete a specific trigger with output
  void completeTriggerWithOutput(String taskId, String triggerId, String output) {
    final taskIndex = state.tasks.indexWhere((t) => t.id == taskId);
    if (taskIndex == -1) return;

    final task = state.tasks[taskIndex];
    final triggerIndex = task.triggers.indexWhere((t) => t.id == triggerId);
    if (triggerIndex == -1) return;

    // Parse output for useful information
    final parsedResults = _parseOutput(output);

    // Update trigger with output and results
    final updatedTrigger = task.triggers[triggerIndex].copyWith(
      status: TriggerStatus.completed,
      output: output,
      parsedResults: parsedResults,
      executedDate: DateTime.now(),
    );

    // Update triggers list
    final updatedTriggers = [...task.triggers];
    updatedTriggers[triggerIndex] = updatedTrigger;

    // Check if all triggers are completed
    final allCompleted = updatedTriggers.every((t) =>
        t.status == TriggerStatus.completed ||
        t.status == TriggerStatus.skipped ||
        t.status == TriggerStatus.failed
    );

    // Update task
    final updatedTask = task.copyWith(
      triggers: updatedTriggers,
      status: allCompleted ? TaskStatus.completed : task.status,
      completedDate: allCompleted ? DateTime.now() : null,
      completedCount: updatedTriggers.where((t) => t.status == TriggerStatus.completed).length,
    );

    final updatedTasks = [...state.tasks];
    updatedTasks[taskIndex] = updatedTask;

    state = state.copyWith(tasks: updatedTasks);

    // Update assets with parsed results
    if (parsedResults.isNotEmpty) {
      _updateAssetsWithResults(parsedResults);
    }
  }

  Map<String, dynamic> _parseOutput(String output) {
    final results = <String, dynamic>{};

    // Parse different tool outputs
    if (output.contains('Nmap scan report')) {
      results.addAll(_parseNmapOutput(output));
    } else if (output.contains('[*] Responder')) {
      results.addAll(_parseResponderOutput(output));
    } else if (output.contains('SMB')) {
      results.addAll(_parseSmbOutput(output));
    } else if (output.contains('crackmapexec') || output.contains('CME')) {
      results.addAll(_parseCrackmapexecOutput(output));
    } else {
      // Fallback to generic parsing
      results.addAll(_parseGenericOutput(output));
    }

    return results;
  }

  Map<String, dynamic> _parseNmapOutput(String output) {
    final results = <String, dynamic>{};
    final List<String> discoveredHosts = [];
    final List<Map<String, dynamic>> services = [];

    // Parse: "Nmap scan report for 192.168.1.100"
    final hostRegex = RegExp(r'Nmap scan report for ([\d\.]+)');
    for (final match in hostRegex.allMatches(output)) {
      discoveredHosts.add(match.group(1)!);
    }

    // Parse open ports: "445/tcp open microsoft-ds"
    final portRegex = RegExp(r'(\d+)/(tcp|udp)\s+open\s+(\S+)(?:\s+(.+))?');
    for (final match in portRegex.allMatches(output)) {
      services.add({
        'port': int.parse(match.group(1)!),
        'protocol': match.group(2),
        'service': match.group(3),
        'version': match.group(4) ?? '',
      });
    }

    if (discoveredHosts.isNotEmpty) {
      results['discovered_hosts'] = discoveredHosts;
    }
    if (services.isNotEmpty) {
      results['discovered_services'] = services;
    }

    return results;
  }

  Map<String, dynamic> _parseResponderOutput(String output) {
    final results = <String, dynamic>{};
    final List<Map<String, dynamic>> capturedCreds = [];

    // Parse captured hashes - look for NTLM responses
    final ntlmRegex = RegExp(r'\[SMB\] NTLMv2-SSP Username : (.+)');
    final hashRegex = RegExp(r'\[SMB\] NTLMv2-SSP Hash\s+: (.+)');

    final usernames = ntlmRegex.allMatches(output).map((m) => m.group(1)?.trim()).toList();
    final hashes = hashRegex.allMatches(output).map((m) => m.group(1)?.trim()).toList();

    for (int i = 0; i < usernames.length && i < hashes.length; i++) {
      if (usernames[i] != null && hashes[i] != null) {
        capturedCreds.add({
          'type': 'ntlmv2',
          'username': usernames[i],
          'hash': hashes[i],
          'domain': usernames[i]!.contains('\\') ? usernames[i]!.split('\\')[0] : '',
        });
      }
    }

    if (capturedCreds.isNotEmpty) {
      results['captured_credentials'] = capturedCreds;
    }

    return results;
  }

  Map<String, dynamic> _parseSmbOutput(String output) {
    final results = <String, dynamic>{};
    final List<Map<String, dynamic>> smbShares = [];

    // Parse SMB shares
    final shareRegex = RegExp(r'(\S+)\s+(Disk|IPC|Printer)\s+(.*)');
    for (final match in shareRegex.allMatches(output)) {
      smbShares.add({
        'name': match.group(1),
        'type': match.group(2),
        'description': match.group(3)?.trim() ?? '',
      });
    }

    if (smbShares.isNotEmpty) {
      results['discovered_shares'] = smbShares;
    }

    return results;
  }

  Map<String, dynamic> _parseCrackmapexecOutput(String output) {
    final results = <String, dynamic>{};
    final List<Map<String, dynamic>> credentials = [];

    // Parse successful authentications
    final authRegex = RegExp(r'(\d+\.\d+\.\d+\.\d+):(\d+)\s+(\S+)\s+\[(\+|\-)\]\s+(.+)');
    for (final match in authRegex.allMatches(output)) {
      final status = match.group(4) == '+' ? 'success' : 'failed';
      if (status == 'success') {
        credentials.add({
          'host': match.group(1),
          'port': int.tryParse(match.group(2) ?? '') ?? 445,
          'protocol': match.group(3),
          'status': status,
          'details': match.group(5),
        });
      }
    }

    if (credentials.isNotEmpty) {
      results['verified_credentials'] = credentials;
    }

    return results;
  }

  Map<String, dynamic> _parseGenericOutput(String output) {
    final results = <String, dynamic>{};

    // Generic IP address extraction
    final ipPattern = RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b');
    final ips = ipPattern.allMatches(output).map((m) => m.group(0)).toList();
    if (ips.isNotEmpty) {
      results['discovered_ips'] = ips.toSet().toList(); // Remove duplicates
    }

    // Generic port pattern
    final portPattern = RegExp(r'(\d+)/(?:tcp|udp)\s+open\s+(\S+)');
    final ports = <Map<String, dynamic>>[];
    for (final match in portPattern.allMatches(output)) {
      ports.add({
        'port': int.tryParse(match.group(1) ?? '') ?? 0,
        'service': match.group(2),
      });
    }
    if (ports.isNotEmpty) {
      results['discovered_services'] = ports;
    }

    // Generic hash extraction
    final hashPattern = RegExp(r'\b[a-fA-F0-9]{32}\b|\b[a-fA-F0-9]{40}\b|\b[a-fA-F0-9]{64}\b');
    final hashes = hashPattern.allMatches(output).map((m) => m.group(0)).toList();
    if (hashes.isNotEmpty) {
      results['discovered_hashes'] = hashes.toSet().toList();
    }

    return results;
  }

  void _updateAssetsWithResults(Map<String, dynamic> results) {
    final projectId = ref.read(currentProjectProvider)?.id;
    if (projectId == null) return;

    final methodologyNotifier = ref.read(methodologyProvider(projectId).notifier);

    // Create assets from discovered hosts
    if (results.containsKey('discovered_hosts')) {
      for (final host in results['discovered_hosts'] as List) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.host,
          name: 'Host $host',
          value: host,
          properties: {
            'source': 'nmap_scan',
            'host': host,
            'ip_address': host,
          },
          discoveredDate: DateTime.now(),
          confidence: 0.95,
        ));
      }
    }

    // Create assets from generic discovered IPs (fallback)
    if (results.containsKey('discovered_ips')) {
      for (final ip in results['discovered_ips']) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.host,
          name: 'Discovered Host',
          value: ip,
          properties: {
            'source': 'generic_parsing',
            'host': ip,
            'ip_address': ip,
          },
          discoveredDate: DateTime.now(),
          confidence: 0.8,
        ));
      }
    }

    // Create assets from discovered services
    if (results.containsKey('discovered_services')) {
      for (final service in results['discovered_services']) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.service,
          name: service['service'] ?? 'Unknown Service',
          value: '${service['port']}/${service['service']}',
          properties: {
            'source': 'port_scan',
            'port': service['port'],
            'protocol': service['protocol'] ?? 'tcp',
            'service_name': service['service'],
            'version': service['version'] ?? '',
            ...service,
          },
          discoveredDate: DateTime.now(),
          confidence: 0.9,
        ));
      }
    }

    // Create assets from captured credentials
    if (results.containsKey('captured_credentials')) {
      for (final cred in results['captured_credentials'] as List) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.credential,
          name: 'Captured: ${cred['username']}',
          value: cred['username'],
          properties: {
            'source': 'responder',
            'type': cred['type'],
            'username': cred['username'],
            'hash': cred['hash'],
            'domain': cred['domain'],
            'verified': false,
            ...cred,
          },
          discoveredDate: DateTime.now(),
          confidence: 0.95,
        ));
      }
    }

    // Create assets from verified credentials
    if (results.containsKey('verified_credentials')) {
      for (final cred in results['verified_credentials'] as List) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.credential,
          name: 'Verified Access: ${cred['host']}',
          value: '${cred['host']}:${cred['port']}',
          properties: {
            'source': 'crackmapexec',
            'host': cred['host'],
            'port': cred['port'],
            'protocol': cred['protocol'],
            'status': cred['status'],
            'details': cred['details'],
            'verified': true,
            ...cred,
          },
          discoveredDate: DateTime.now(),
          confidence: 1.0,
        ));
      }
    }

    // Create assets from SMB shares
    if (results.containsKey('discovered_shares')) {
      for (final share in results['discovered_shares'] as List) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.service,
          name: 'SMB Share: ${share['name']}',
          value: share['name'],
          properties: {
            'source': 'smb_enumeration',
            'share_name': share['name'],
            'share_type': share['type'],
            'description': share['description'],
            'protocol': 'smb',
            ...share,
          },
          discoveredDate: DateTime.now(),
          confidence: 0.9,
        ));
      }
    }

    // Create assets from discovered hashes
    if (results.containsKey('discovered_hashes')) {
      for (final hash in results['discovered_hashes']) {
        methodologyNotifier.addDiscoveredAsset(DiscoveredAsset(
          id: _uuid.v4(),
          projectId: projectId,
          type: AssetType.credential,
          name: 'Hash Found',
          value: hash,
          properties: {
            'source': 'hash_extraction',
            'hash_value': hash,
            'hash_length': hash.length,
            'verified': false,
          },
          discoveredDate: DateTime.now(),
          confidence: 0.7,
        ));
      }
    }
  }

  List<Methodology> _getAvailableMethodologies(String projectId) {
    final methodologyState = ref.read(methodologyProvider(projectId));
    return methodologyState.availableMethodologies;
  }

  // Get methodology by ID
  Methodology? _getMethodologyById(String methodologyId, String projectId) {
    final methodologies = _getAvailableMethodologies(projectId);
    try {
      return methodologies.firstWhere((m) => m.id == methodologyId);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> _convertScopeItemsToAssets(List<dynamic> scopeItems) {
    final List<Map<String, dynamic>> assets = [];

    for (final segment in scopeItems) {
      if (segment is ScopeSegment) {
        for (final item in segment.items) {
          assets.add({
            'id': item.id,
            'type': 'host',
            'host': item.target,
            'network': segment.type.name,
            'in_scope': segment.status == ScopeSegmentStatus.active,
          });
        }
      }
    }

    return assets;
  }

  List<Map<String, dynamic>> _convertCredentialsToAssets(List<dynamic> credentials) {
    return credentials.map((cred) {
      if (cred is Credential) {
        return {
          'id': cred.id,
          'type': 'credential',
          'credential_type': cred.type.name,
          'username': cred.username,
          'domain': cred.domain ?? '',
          'host': cred.target,
        };
      }
      return <String, dynamic>{};
    }).toList();
  }

  List<Map<String, dynamic>> _convertDiscoveredAssetsToMaps(List<DiscoveredAsset> assets) {
    return assets.map((asset) {
      return {
        'id': asset.id,
        'type': asset.type.name,
        'identifier': asset.value,
        'metadata': asset.properties,
        'confidence': asset.confidence,
      };
    }).toList();
  }
}

final taskQueueProvider = StateNotifierProvider<TaskQueueNotifier, TaskQueueState>((ref) {
  return TaskQueueNotifier(ref);
});

final pendingTasksProvider = Provider<List<TaskInstance>>((ref) {
  final tasks = ref.watch(taskQueueProvider).tasks;
  return tasks.where((t) => t.status == TaskStatus.pending).toList();
});

final activeTasksProvider = Provider<List<TaskInstance>>((ref) {
  final tasks = ref.watch(taskQueueProvider).tasks;
  return tasks.where((t) => t.status == TaskStatus.inProgress).toList();
});

final completedTasksProvider = Provider<List<TaskInstance>>((ref) {
  final tasks = ref.watch(taskQueueProvider).tasks;
  return tasks.where((t) => t.status == TaskStatus.completed).toList();
});