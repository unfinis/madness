import 'dart:async';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';
import '../models/asset.dart';
import '../models/methodology_trigger.dart';
import '../models/methodology.dart';
import 'methodology_service.dart';

class PropertyDrivenEngine {
  static final PropertyDrivenEngine _instance = PropertyDrivenEngine._internal();
  factory PropertyDrivenEngine() => _instance;
  PropertyDrivenEngine._internal();

  final _uuid = const Uuid();
  final MethodologyService _methodologyService = MethodologyService();

  // Asset storage
  final Map<String, List<Asset>> _projectAssets = {};

  // Trigger definitions loaded from methodologies
  final List<MethodologyTrigger> _triggers = [];

  // Trigger execution tracking
  final Map<String, Set<String>> _completedTriggers = {};  // projectId -> Set of dedup keys
  final Map<String, TriggerResult> _triggerResults = {};    // dedup key -> result

  // Pending triggers queue
  final Map<String, List<TriggeredMethodology>> _pendingTriggers = {};

  // Batch processing
  final Map<String, BatchedTrigger> _batchedTriggers = {};

  // Streams for reactive updates
  final StreamController<List<Asset>> _assetsController =
      StreamController<List<Asset>>.broadcast();
  final StreamController<List<TriggeredMethodology>> _triggersController =
      StreamController<List<TriggeredMethodology>>.broadcast();
  final StreamController<List<BatchedTrigger>> _batchesController =
      StreamController<List<BatchedTrigger>>.broadcast();

  Stream<List<Asset>> get assetsStream => _assetsController.stream;
  Stream<List<TriggeredMethodology>> get triggersStream => _triggersController.stream;
  Stream<List<BatchedTrigger>> get batchesStream => _batchesController.stream;

  Future<void> initialize() async {
    await _methodologyService.initialize();
    _loadTriggerDefinitions();
  }

  void _loadTriggerDefinitions() {
    // Load trigger definitions from methodology YAML files
    // This would parse the YAML files and create MethodologyTrigger objects
    // For now, we'll create some examples programmatically

    _triggers.addAll([
      // Network segment with NAC + credentials → Try NAC bypass with creds
      MethodologyTrigger(
        id: 'nac_cred_bypass',
        methodologyId: 'nac_credential_testing',
        name: 'NAC Credential Testing',
        description: 'Test credentials against NAC when both are present',
        assetType: AssetType.networkSegment,
        conditions: TriggerConditionGroup(
          operator: LogicalOperator.and,
          conditions: [
            const TriggerCondition(
              property: 'nac_enabled',
              operator: TriggerOperator.equals,
              value: true,
            ),
            const TriggerCondition(
              property: 'credentials_available',
              operator: TriggerOperator.greaterThan,
              value: 0,
            ),
            const TriggerCondition(
              property: 'access_level',
              operator: TriggerOperator.inList,
              value: ['blocked', 'limited'],
            ),
          ],
        ),
        priority: 90,
        batchCapable: true,
        batchCriteria: 'nac_type',
        deduplicationKeyTemplate: '{asset.id}:nac_cred:{hash}',
        individualCommand: 'test_nac_auth.sh -u {username} -p {password} -g {gateway}',
        tags: ['nac', 'credentials', 'bypass'],
        enabled: true,
      ),

      // Multiple web services discovered → Batch web enumeration
      MethodologyTrigger(
        id: 'web_enum_batch',
        methodologyId: 'web_enumeration',
        name: 'Batch Web Service Enumeration',
        description: 'Screenshot and enumerate all discovered web services',
        assetType: AssetType.networkSegment,
        conditions: const TriggerCondition(
          property: 'web_services.count',
          operator: TriggerOperator.greaterThan,
          value: 0,
        ),
        priority: 70,
        batchCapable: true,
        batchCriteria: 'network_segment',
        batchCommand: '''
eyewitness --web -f {targets_file} --no-prompt -d {output_dir}
parallel -j 4 "nikto -h {} -output {output_dir}/nikto_{#}.txt" :::: {targets_file}
''',
        deduplicationKeyTemplate: '{asset.id}:web_enum:{web_services.count}',
        tags: ['web', 'enumeration', 'batch'],
        enabled: true,
        maxBatchSize: 50,
      ),

      // SMB hosts + credentials → Credential testing
      MethodologyTrigger(
        id: 'smb_cred_test',
        methodologyId: 'smb_credential_testing',
        name: 'SMB Credential Testing',
        description: 'Test credentials against SMB hosts',
        assetType: AssetType.networkSegment,
        conditions: TriggerConditionGroup(
          operator: LogicalOperator.and,
          conditions: [
            const TriggerCondition(
              property: 'smb_hosts',
              operator: TriggerOperator.greaterThan,
              value: 0,
            ),
            const TriggerCondition(
              property: 'credentials_available',
              operator: TriggerOperator.exists,
            ),
          ],
        ),
        priority: 85,
        batchCapable: true,
        batchCommand: '''
for host in {smb_hosts}; do
  for cred in {credentials}; do
    smbclient -L //$host -U $cred 2>&1 | tee -a {output_file}
  done
done
''',
        deduplicationKeyTemplate: '{asset.id}:smb_cred:{credentials.hash}:{smb_hosts.hash}',
        tags: ['smb', 'credentials'],
        enabled: true,
      ),

      // Host with open RDP → RDP screenshot/enumeration
      MethodologyTrigger(
        id: 'rdp_enum',
        methodologyId: 'rdp_enumeration',
        name: 'RDP Enumeration',
        description: 'Enumerate and screenshot RDP services',
        assetType: AssetType.host,
        conditions: TriggerConditionGroup(
          operator: LogicalOperator.and,
          conditions: [
            const TriggerCondition(
              property: 'rdp_enabled',
              operator: TriggerOperator.equals,
              value: true,
            ),
            const TriggerCondition(
              property: 'open_ports',
              operator: TriggerOperator.contains,
              value: '3389',
            ),
          ],
        ),
        priority: 60,
        batchCapable: true,
        batchCriteria: 'network_segment',
        batchCommand: 'rdp-screenshot.py -f {hosts_file} -o {output_dir}',
        deduplicationKeyTemplate: '{asset.id}:rdp_enum',
        tags: ['rdp', 'enumeration'],
        enabled: true,
      ),

      // IPv6 enabled + IPv4 restrictions → IPv6 bypass attempt
      MethodologyTrigger(
        id: 'ipv6_bypass',
        methodologyId: 'ipv6_bypass',
        name: 'IPv6 Restriction Bypass',
        description: 'Attempt to bypass IPv4 restrictions using IPv6',
        assetType: AssetType.host,
        conditions: TriggerConditionGroup(
          operator: LogicalOperator.and,
          conditions: [
            const TriggerCondition(
              property: 'ipv6_address',
              operator: TriggerOperator.exists,
            ),
            const TriggerCondition(
              property: 'privilege_level',
              operator: TriggerOperator.equals,
              value: 'none',
            ),
          ],
        ),
        priority: 75,
        batchCapable: false,
        individualCommand: 'nmap -6 -sV {ipv6_address}',
        deduplicationKeyTemplate: '{asset.id}:ipv6_bypass',
        tags: ['ipv6', 'bypass'],
        enabled: true,
      ),
    ]);
  }

  // Asset management
  Future<void> addAsset(Asset asset) async {
    _projectAssets.putIfAbsent(asset.projectId, () => []).add(asset);
    _assetsController.add(_projectAssets[asset.projectId]!);

    // Check for new triggers
    await _evaluateTriggersForAsset(asset);
  }

  Future<void> updateAsset(Asset asset) async {
    final assets = _projectAssets[asset.projectId] ?? [];
    final index = assets.indexWhere((a) => a.id == asset.id);

    if (index >= 0) {
      final oldAsset = assets[index];
      assets[index] = asset;
      _assetsController.add(assets);

      // Check if property changes trigger new methodologies
      if (_hasSignificantPropertyChanges(oldAsset, asset)) {
        await _evaluateTriggersForAsset(asset);
      }
    }
  }

  bool _hasSignificantPropertyChanges(Asset oldAsset, Asset newAsset) {
    // Check if any trigger-relevant properties changed
    final relevantProps = [
      'nac_enabled', 'credentials_available', 'web_services',
      'smb_hosts', 'access_level', 'rdp_enabled', 'ipv6_address'
    ];

    for (final prop in relevantProps) {
      if (oldAsset.properties[prop] != newAsset.properties[prop]) {
        return true;
      }
    }
    return false;
  }

  // Trigger evaluation
  Future<void> _evaluateTriggersForAsset(Asset asset) async {
    final projectTriggers = _pendingTriggers.putIfAbsent(asset.projectId, () => []);

    for (final trigger in _triggers) {
      // Check if trigger applies to this asset type
      if (trigger.assetType != asset.type) continue;

      // Check if trigger conditions are met
      if (!TriggerEvaluator.evaluate(trigger.conditions, asset.properties)) continue;

      // Generate deduplication key
      final variables = _extractVariables(asset, trigger);
      final dedupKey = DeduplicationKeyGenerator.generate(
        trigger.deduplicationKeyTemplate,
        asset,
        trigger,
        variables,
      );

      // Check if already completed
      if (_hasCompletedTrigger(asset.projectId, dedupKey)) continue;

      // Check if already triggered
      if (projectTriggers.any((t) => t.deduplicationKey == dedupKey)) continue;

      // Create triggered methodology
      final triggered = TriggeredMethodology(
        id: _uuid.v4(),
        methodologyId: trigger.methodologyId,
        triggerId: trigger.id,
        asset: asset,
        deduplicationKey: dedupKey,
        variables: variables,
        command: _resolveCommand(trigger.individualCommand, variables),
        triggeredAt: DateTime.now(),
        priority: trigger.priority,
        status: 'pending',
      );

      projectTriggers.add(triggered);
    }

    // Process batching
    _processBatching(asset.projectId);

    // Notify listeners
    _triggersController.add(projectTriggers);
  }

  Map<String, dynamic> _extractVariables(Asset asset, MethodologyTrigger trigger) {
    final variables = <String, dynamic>{};

    // Extract common variables
    variables['asset_id'] = asset.id;
    variables['asset_name'] = asset.name;

    // Extract property-based variables
    asset.properties.forEach((key, value) {
      value.when(
        string: (v) => variables[key] = v,
        integer: (v) => variables[key] = v,
        boolean: (v) => variables[key] = v,
        stringList: (v) {
          variables[key] = v;
          variables['${key}_list'] = v.join(',');
          variables['${key}_count'] = v.length;
        },
        map: (v) => variables[key] = v,
        objectList: (v) {
          variables[key] = v;
          variables['${key}_count'] = v.length;
          // Extract specific fields for common objects
          if (key == 'web_services') {
            variables['web_services_urls'] = v.map((s) =>
              '${s['ssl'] == true ? 'https' : 'http'}://${s['host']}:${s['port']}'
            ).toList();
          }
          if (key == 'credentials_available') {
            variables['credentials'] = v.map((c) => '${c['username']}:${c['password'] ?? c['hash']}').toList();
          }
        },
      );
    });

    return variables;
  }

  String? _resolveCommand(String? template, Map<String, dynamic> variables) {
    if (template == null) return null;

    var command = template;
    variables.forEach((key, value) {
      command = command.replaceAll('{$key}', value.toString());
    });

    return command;
  }

  // Batching
  void _processBatching(String projectId) {
    final triggers = _pendingTriggers[projectId] ?? [];

    // Group batchable triggers
    final batchGroups = <String, List<TriggeredMethodology>>{};

    for (final trigger in triggers.where((t) => t.status == 'pending')) {
      final triggerDef = _triggers.firstWhereOrNull((td) => td.id == trigger.triggerId);
      if (triggerDef == null || !triggerDef.batchCapable) continue;

      final batchKey = '${triggerDef.methodologyId}:${triggerDef.batchCriteria}';
      batchGroups.putIfAbsent(batchKey, () => []).add(trigger);
    }

    // Create batched triggers
    batchGroups.forEach((key, group) {
      if (group.length < 2) return;  // Don't batch single items

      final triggerDef = _triggers.firstWhere((td) => td.id == group.first.triggerId);

      // Check max batch size
      final batches = <List<TriggeredMethodology>>[];
      if (triggerDef.maxBatchSize != null && group.length > triggerDef.maxBatchSize!) {
        // Split into multiple batches
        for (var i = 0; i < group.length; i += triggerDef.maxBatchSize!) {
          final end = (i + triggerDef.maxBatchSize!).clamp(0, group.length);
          batches.add(group.sublist(i, end));
        }
      } else {
        batches.add(group);
      }

      for (final batch in batches) {
        final batchId = _uuid.v4();

        // Mark individual triggers as part of batch
        for (final trigger in batch) {
          trigger = trigger.copyWith(
            isPartOfBatch: true,
            batchId: batchId,
            batchAssets: batch.map((t) => t.asset).toList(),
          );
        }

        // Create batch variables
        final batchVariables = _createBatchVariables(batch);

        final batchedTrigger = BatchedTrigger(
          id: batchId,
          methodologyId: triggerDef.methodologyId,
          triggers: batch,
          batchCommand: _resolveCommand(triggerDef.batchCommand ?? '', batchVariables) ?? '',
          batchVariables: batchVariables,
          priority: triggerDef.priority,
        );

        _batchedTriggers[batchId] = batchedTrigger;
      }
    });

    _batchesController.add(_batchedTriggers.values.toList());
  }

  Map<String, dynamic> _createBatchVariables(List<TriggeredMethodology> triggers) {
    final variables = <String, dynamic>{};

    // Combine variables from all triggers
    final allHosts = <String>[];
    final allCredentials = <String>[];
    final allWebServices = <String>[];

    for (final trigger in triggers) {
      final vars = trigger.variables;

      if (vars['ip_address'] != null) {
        allHosts.add(vars['ip_address'] as String);
      }
      if (vars['smb_hosts'] != null) {
        allHosts.addAll(vars['smb_hosts'] as List<String>);
      }
      if (vars['credentials'] != null) {
        allCredentials.addAll(vars['credentials'] as List<String>);
      }
      if (vars['web_services_urls'] != null) {
        allWebServices.addAll(vars['web_services_urls'] as List<String>);
      }
    }

    variables['all_hosts'] = allHosts;
    variables['hosts_file'] = '/tmp/hosts_${DateTime.now().millisecondsSinceEpoch}.txt';
    variables['all_credentials'] = allCredentials;
    variables['all_web_services'] = allWebServices;
    variables['targets_file'] = '/tmp/targets_${DateTime.now().millisecondsSinceEpoch}.txt';
    variables['output_dir'] = '/tmp/batch_${DateTime.now().millisecondsSinceEpoch}';

    return variables;
  }

  // Trigger completion tracking
  bool _hasCompletedTrigger(String projectId, String dedupKey) {
    return _completedTriggers[projectId]?.contains(dedupKey) ?? false;
  }

  void markTriggerCompleted(String projectId, String dedupKey, TriggerResult result) {
    _completedTriggers.putIfAbsent(projectId, () => {}).add(dedupKey);
    _triggerResults[dedupKey] = result;

    // Update asset with result
    final assets = _projectAssets[projectId] ?? [];
    final trigger = _pendingTriggers[projectId]?.firstWhereOrNull(
      (t) => t.deduplicationKey == dedupKey
    );

    if (trigger != null) {
      final asset = assets.firstWhereOrNull((a) => a.id == trigger.asset.id);
      if (asset != null) {
        final updatedAsset = asset.markTriggerCompleted(dedupKey, result);
        updateAsset(updatedAsset);
      }
    }
  }

  // Get triggers for project
  List<TriggeredMethodology> getPendingTriggers(String projectId) {
    return _pendingTriggers[projectId]?.where((t) => t.status == 'pending').toList() ?? [];
  }

  List<BatchedTrigger> getBatchedTriggers(String projectId) {
    return _batchedTriggers.values
        .where((b) => b.triggers.any((t) => t.asset.projectId == projectId))
        .toList();
  }

  // Execute a trigger
  Future<TriggerResult> executeTrigger(TriggeredMethodology trigger) async {
    // This would actually execute the command
    // For now, we'll simulate it
    try {
      // Mark as executing
      trigger = trigger.copyWith(
        status: 'executing',
        executedAt: DateTime.now(),
      );

      // Simulate execution
      await Future.delayed(const Duration(seconds: 2));

      // Create result
      final result = TriggerResult(
        methodologyId: trigger.methodologyId,
        executedAt: DateTime.now(),
        success: true,
        output: 'Simulated execution output',
        propertyUpdates: {
          'last_tested': PropertyValue.string(DateTime.now().toIso8601String()),
        },
      );

      // Mark as completed
      trigger = trigger.copyWith(
        status: 'completed',
        completedAt: DateTime.now(),
      );

      markTriggerCompleted(trigger.asset.projectId, trigger.deduplicationKey, result);

      return result;
    } catch (e) {
      final result = TriggerResult(
        methodologyId: trigger.methodologyId,
        executedAt: DateTime.now(),
        success: false,
        error: e.toString(),
      );

      trigger = trigger.copyWith(
        status: 'failed',
        completedAt: DateTime.now(),
      );

      return result;
    }
  }

  // Execute a batch
  Future<List<TriggerResult>> executeBatch(BatchedTrigger batch) async {
    final results = <TriggerResult>[];

    try {
      // Execute batch command
      // In reality, this would run the actual command
      await Future.delayed(const Duration(seconds: 5));

      // Mark all triggers as completed
      for (final trigger in batch.triggers) {
        final result = TriggerResult(
          methodologyId: trigger.methodologyId,
          executedAt: DateTime.now(),
          success: true,
          output: 'Batch execution successful',
        );

        markTriggerCompleted(
          trigger.asset.projectId,
          trigger.deduplicationKey,
          result,
        );

        results.add(result);
      }
    } catch (e) {
      // Handle batch failure
      for (final trigger in batch.triggers) {
        final result = TriggerResult(
          methodologyId: trigger.methodologyId,
          executedAt: DateTime.now(),
          success: false,
          error: 'Batch execution failed: $e',
        );
        results.add(result);
      }
    }

    return results;
  }
}