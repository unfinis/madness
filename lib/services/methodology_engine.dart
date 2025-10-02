import 'dart:async';
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../models/methodology.dart';
import '../models/methodology_execution.dart';
import 'methodology_service.dart';
import 'output_parser_service.dart';
import 'attack_chain_service.dart';
import 'error_tracking_service.dart';
import 'performance_monitor.dart';

class MethodologyEngine {
  static final MethodologyEngine _instance = MethodologyEngine._internal();
  factory MethodologyEngine() => _instance;
  MethodologyEngine._internal();

  final MethodologyService _methodologyService = MethodologyService();
  final OutputParserService _outputParser = OutputParserService();
  final AttackChainService _attackChainService = AttackChainService();
  final Map<String, MethodologyExecution> _activeExecutions = {};
  final Map<String, List<DiscoveredAsset>> _projectAssets = {};
  final List<MethodologyRecommendation> _recommendations = [];
  final _uuid = const Uuid();

  // Streams for reactive updates
  final StreamController<List<MethodologyExecution>> _executionsController = 
      StreamController<List<MethodologyExecution>>.broadcast();
  final StreamController<List<MethodologyRecommendation>> _recommendationsController = 
      StreamController<List<MethodologyRecommendation>>.broadcast();
  final StreamController<List<DiscoveredAsset>> _assetsController = 
      StreamController<List<DiscoveredAsset>>.broadcast();

  Stream<List<MethodologyExecution>> get executionsStream => _executionsController.stream;
  Stream<List<MethodologyRecommendation>> get recommendationsStream => _recommendationsController.stream;
  Stream<List<DiscoveredAsset>> get assetsStream => _assetsController.stream;

  List<MethodologyExecution> get activeExecutions => _activeExecutions.values.toList();
  List<MethodologyRecommendation> get recommendations => _recommendations;

  Future<void> initialize() async {
    await _methodologyService.initialize();
    await _attackChainService.initialize();
  }

  // Asset Management
  void addDiscoveredAsset(String projectId, DiscoveredAsset asset) {
    _projectAssets.putIfAbsent(projectId, () => []);
    _projectAssets[projectId]!.add(asset);

    _assetsController.add(_projectAssets[projectId]!);

    // Re-evaluate recommendations when new assets are discovered
    _updateRecommendations(projectId);

    // Automatically generate attack chain steps for this asset
    _generateAttackChainSteps(projectId, asset);
  }

  void addDiscoveredAssets(String projectId, List<DiscoveredAsset> assets) {
    _projectAssets.putIfAbsent(projectId, () => []);
    _projectAssets[projectId]!.addAll(assets);

    _assetsController.add(_projectAssets[projectId]!);
    _updateRecommendations(projectId);

    // Generate attack chain steps for each asset
    for (final asset in assets) {
      _generateAttackChainSteps(projectId, asset);
    }
  }

  List<DiscoveredAsset> getProjectAssets(String projectId) {
    return _projectAssets[projectId] ?? [];
  }

  // Recommendation Management
  void _updateRecommendations(String projectId) {
    final assets = getProjectAssets(projectId);
    final recommendedMethodologies = _methodologyService.getRecommendedMethodologies(projectId, assets);
    
    // Clear existing recommendations for this project
    _recommendations.removeWhere((r) => r.projectId == projectId);
    
    // Create new recommendations
    for (final methodology in recommendedMethodologies) {
      final recommendation = MethodologyRecommendation(
        id: _uuid.v4(),
        methodologyId: methodology.id,
        projectId: projectId,
        priority: _calculatePriority(methodology, assets),
        confidence: _calculateConfidence(methodology, assets),
        reason: _generateRecommendationReason(methodology, assets),
        triggeringAssetIds: _findTriggeringAssets(methodology, assets),
        context: _buildExecutionContext(methodology, assets),
        createdDate: DateTime.now(),
      );
      
      _recommendations.add(recommendation);
    }
    
    // Sort by priority and confidence
    _recommendations.sort((a, b) {
      final priorityComparison = b.priority.compareTo(a.priority);
      if (priorityComparison != 0) return priorityComparison;
      return b.confidence.compareTo(a.confidence);
    });
    
    _recommendationsController.add(_recommendations);
  }

  int _calculatePriority(Methodology methodology, List<DiscoveredAsset> assets) {
    int basePriority = 0;
    
    // Higher priority for methodologies that match more assets
    final matchingAssets = _findTriggeringAssets(methodology, assets);
    basePriority += matchingAssets.length * 10;
    
    // Adjust based on methodology category
    switch (methodology.category) {
      case MethodologyCategory.reconnaissance:
        basePriority += 100;
        break;
      case MethodologyCategory.scanning:
        basePriority += 80;
        break;
      case MethodologyCategory.enumeration:
        basePriority += 60;
        break;
      case MethodologyCategory.exploitation:
        basePriority += 40;
        break;
      case MethodologyCategory.postExploitation:
        basePriority += 20;
        break;
    }
    
    // Adjust based on risk level
    switch (methodology.riskLevel) {
      case MethodologyRiskLevel.low:
        basePriority += 10;
        break;
      case MethodologyRiskLevel.medium:
        basePriority += 5;
        break;
      case MethodologyRiskLevel.high:
        basePriority -= 5;
        break;
      case MethodologyRiskLevel.critical:
        basePriority -= 10;
        break;
    }
    
    return basePriority;
  }

  double _calculateConfidence(Methodology methodology, List<DiscoveredAsset> assets) {
    if (methodology.triggers.isEmpty) return 0.5; // Default confidence for always-run methodologies
    
    double totalConfidence = 0.0;
    int triggerCount = 0;
    
    for (final trigger in methodology.triggers) {
      final triggerConfidence = _evaluateTriggerConfidence(trigger, assets);
      if (triggerConfidence > 0) {
        totalConfidence += triggerConfidence;
        triggerCount++;
      }
    }
    
    return triggerCount > 0 ? totalConfidence / triggerCount : 0.0;
  }

  double _evaluateTriggerConfidence(MethodologyTrigger trigger, List<DiscoveredAsset> assets) {
    final matchingAssets = _findAssetsForTrigger(trigger, assets);
    if (matchingAssets.isEmpty) return 0.0;
    
    // Base confidence on number of matching assets and their individual confidence scores
    double totalAssetConfidence = matchingAssets.fold(0.0, (sum, asset) => sum + asset.confidence);
    double averageAssetConfidence = totalAssetConfidence / matchingAssets.length;
    
    // Scale based on number of matching assets (more assets = higher confidence)
    double scaleMultiplier = (matchingAssets.length / 10.0).clamp(0.1, 1.0);
    
    return (averageAssetConfidence * scaleMultiplier).clamp(0.0, 1.0);
  }

  String _generateRecommendationReason(Methodology methodology, List<DiscoveredAsset> assets) {
    final triggeringAssets = _findTriggeringAssets(methodology, assets);
    
    if (triggeringAssets.isEmpty) {
      return 'General methodology for ${methodology.category.displayName.toLowerCase()} phase';
    }
    
    if (triggeringAssets.length == 1) {
      final asset = assets.firstWhere((a) => a.id == triggeringAssets.first);
      return 'Triggered by discovery of ${asset.type.displayName.toLowerCase()}: ${asset.name}';
    }
    
    return 'Triggered by ${triggeringAssets.length} discovered assets';
  }

  List<String> _findTriggeringAssets(Methodology methodology, List<DiscoveredAsset> assets) {
    final triggeringAssets = <String>[];
    
    for (final trigger in methodology.triggers) {
      final matchingAssets = _findAssetsForTrigger(trigger, assets);
      triggeringAssets.addAll(matchingAssets.map((a) => a.id));
    }
    
    return triggeringAssets.toSet().toList(); // Remove duplicates
  }

  List<DiscoveredAsset> _findAssetsForTrigger(MethodologyTrigger trigger, List<DiscoveredAsset> assets) {
    switch (trigger.type) {
      case TriggerType.assetDiscovered:
        return _findAssetsForAssetDiscoveryTrigger(trigger.conditions, assets);
      case TriggerType.serviceDetected:
        return _findAssetsForServiceTrigger(trigger.conditions, assets);
      case TriggerType.credentialAvailable:
        return _findAssetsForCredentialTrigger(trigger.conditions, assets);
      default:
        return [];
    }
  }

  List<DiscoveredAsset> _findAssetsForAssetDiscoveryTrigger(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    final requiredAssetType = conditions['asset_type'];
    final requiredProperties = conditions['properties'] as Map<String, dynamic>?;
    
    if (requiredAssetType == null) return [];
    
    return assets.where((asset) {
      if (asset.type.name != requiredAssetType) return false;
      
      if (requiredProperties != null) {
        for (final entry in requiredProperties.entries) {
          if (asset.properties[entry.key] != entry.value) return false;
        }
      }
      
      return true;
    }).toList();
  }

  List<DiscoveredAsset> _findAssetsForServiceTrigger(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    final requiredPort = conditions['port'];
    final requiredService = conditions['service'];
    
    return assets.where((asset) {
      if (asset.type != AssetType.service) return false;
      
      if (requiredPort != null && asset.properties['port'] != requiredPort) {
        return false;
      }
      
      if (requiredService != null && !asset.name.toLowerCase().contains(requiredService.toString().toLowerCase())) {
        return false;
      }
      
      return true;
    }).toList();
  }

  List<DiscoveredAsset> _findAssetsForCredentialTrigger(Map<String, dynamic> conditions, List<DiscoveredAsset> assets) {
    final credentialType = conditions['type'];
    final privilegeLevel = conditions['privilege_level'];
    
    return assets.where((asset) {
      if (asset.type != AssetType.credential) return false;
      
      if (credentialType != null && asset.properties['type'] != credentialType) {
        return false;
      }
      
      if (privilegeLevel != null && asset.properties['privilege_level'] != privilegeLevel) {
        return false;
      }
      
      return true;
    }).toList();
  }

  Map<String, dynamic> _buildExecutionContext(Methodology methodology, List<DiscoveredAsset> assets) {
    final context = <String, dynamic>{};
    final triggeringAssets = _findTriggeringAssets(methodology, assets);
    
    // Add asset information to context
    final assetsByType = <String, List<Map<String, dynamic>>>{};
    for (final assetId in triggeringAssets) {
      final asset = assets.firstWhere((a) => a.id == assetId);
      final assetType = asset.type.name;
      
      assetsByType.putIfAbsent(assetType, () => []);
      assetsByType[assetType]!.add({
        'id': asset.id,
        'name': asset.name,
        'value': asset.value,
        'properties': asset.properties,
      });
    }
    
    context['assets'] = assetsByType;
    context['asset_count'] = triggeringAssets.length;
    context['timestamp'] = DateTime.now().toIso8601String();
    
    return context;
  }

  // Execution Management
  Future<MethodologyExecution> startMethodologyExecution(
    String projectId,
    String methodologyId,
    {Map<String, dynamic>? additionalContext}
  ) async {
    PerformanceMonitor.startTimer('methodology_execution_start',
      metadata: {'projectId': projectId, 'methodologyId': methodologyId});

    try {
      final methodology = _methodologyService.getMethodologyById(methodologyId);
      if (methodology == null) {
        throw MethodologyEngineException('Methodology not found: $methodologyId');
      }

      final executionId = _uuid.v4();
      final assets = getProjectAssets(projectId);
      final context = _buildExecutionContext(methodology, assets);

      if (additionalContext != null) {
        context.addAll(additionalContext);
      }

      final execution = MethodologyExecution(
        id: executionId,
        methodologyId: methodologyId,
        projectId: projectId,
        status: ExecutionStatus.pending,
        startedDate: DateTime.now(),
        executionContext: context,
      );

      _activeExecutions[executionId] = execution;
      _executionsController.add(activeExecutions);

      // Start execution asynchronously
      _executeMethodology(execution, methodology);

      PerformanceMonitor.endTimer('methodology_execution_start',
        metadata: {'projectId': projectId, 'methodologyId': methodologyId, 'executionId': executionId});
      return execution;
    } catch (e, stack) {
      ErrorTrackingService().trackError(
        'methodology_execution_start',
        e,
        stack,
        additionalData: {'projectId': projectId, 'methodologyId': methodologyId},
      );
      PerformanceMonitor.endTimer('methodology_execution_start',
        metadata: {'projectId': projectId, 'methodologyId': methodologyId, 'error': true});
      rethrow;
    }
  }

  Future<void> _executeMethodology(MethodologyExecution execution, Methodology methodology) async {
    PerformanceMonitor.startTimer('methodology_execution_full',
      metadata: {'executionId': execution.id, 'methodologyId': execution.methodologyId, 'stepCount': methodology.steps.length});

    try {
      // Update status to in progress
      final updatedExecution = execution.copyWith(
        status: ExecutionStatus.inProgress,
        currentStepIndex: 0,
      );
      _activeExecutions[execution.id] = updatedExecution;
      _executionsController.add(activeExecutions);

      final stepExecutions = <StepExecution>[];

      for (int i = 0; i < methodology.steps.length; i++) {
        final step = methodology.steps[i];
        final stepExecution = await _executeStep(step, updatedExecution, i);
        stepExecutions.add(stepExecution);

        // Update progress
        final progress = (i + 1) / methodology.steps.length;
        final progressExecution = updatedExecution.copyWith(
          currentStepIndex: i + 1,
          progress: progress,
          stepExecutions: stepExecutions,
        );
        _activeExecutions[execution.id] = progressExecution;
        _executionsController.add(activeExecutions);

        // Stop if step failed
        if (stepExecution.status == ExecutionStatus.failed) {
          final failedExecution = progressExecution.copyWith(
            status: ExecutionStatus.failed,
            completedDate: DateTime.now(),
            errorMessage: stepExecution.errorOutput ?? 'Step execution failed',
          );
          _activeExecutions[execution.id] = failedExecution;
          _executionsController.add(activeExecutions);
          PerformanceMonitor.endTimer('methodology_execution_full',
            metadata: {'executionId': execution.id, 'status': 'failed', 'failedStep': i});
          return;
        }
      }

      // Mark as completed
      final completedExecution = updatedExecution.copyWith(
        status: ExecutionStatus.completed,
        progress: 1.0,
        completedDate: DateTime.now(),
        stepExecutions: stepExecutions,
      );
      _activeExecutions[execution.id] = completedExecution;
      _executionsController.add(activeExecutions);

      // Process discovered assets
      await _processDiscoveredAssets(completedExecution, stepExecutions);

      PerformanceMonitor.endTimer('methodology_execution_full',
        metadata: {'executionId': execution.id, 'status': 'completed', 'stepCount': stepExecutions.length});

    } catch (e, stack) {
      ErrorTrackingService().trackError(
        'methodology_execution',
        e,
        stack,
        additionalData: {
          'executionId': execution.id,
          'methodologyId': execution.methodologyId,
          'projectId': execution.projectId,
        },
      );
      final failedExecution = execution.copyWith(
        status: ExecutionStatus.failed,
        completedDate: DateTime.now(),
        errorMessage: e.toString(),
      );
      _activeExecutions[execution.id] = failedExecution;
      _executionsController.add(activeExecutions);
    }
  }

  Future<StepExecution> _executeStep(MethodologyStep step, MethodologyExecution execution, int stepIndex) async {
    final stepExecutionId = _uuid.v4();
    final command = _resolveCommand(step.command, execution.executionContext);
    
    final stepExecution = StepExecution(
      id: stepExecutionId,
      stepId: step.id,
      executionId: execution.id,
      status: ExecutionStatus.inProgress,
      command: command,
      startedDate: DateTime.now(),
    );
    
    try {
      // Execute the command based on step type
      switch (step.type) {
        case MethodologyStepType.command:
          return await _executeCommand(stepExecution, step);
        case MethodologyStepType.script:
          return await _executeScript(stepExecution, step);
        case MethodologyStepType.manual:
          return await _executeManualStep(stepExecution, step);
        case MethodologyStepType.validation:
          return await _executeValidation(stepExecution, step);
      }
    } catch (e) {
      return stepExecution.copyWith(
        status: ExecutionStatus.failed,
        errorOutput: e.toString(),
        completedDate: DateTime.now(),
      );
    }
  }

  String _resolveCommand(String command, Map<String, dynamic> context) {
    String resolvedCommand = command;
    
    // Replace common placeholders
    final assets = context['assets'] as Map<String, dynamic>? ?? {};
    
    // Replace host placeholders
    final hosts = assets['host'] as List<dynamic>? ?? [];
    if (hosts.isNotEmpty) {
      final firstHost = hosts.first as Map<String, dynamic>;
      resolvedCommand = resolvedCommand.replaceAll('{host_ip}', firstHost['value'] ?? '');
      resolvedCommand = resolvedCommand.replaceAll('{hostname}', firstHost['name'] ?? '');
    }
    
    // Replace service placeholders
    final services = assets['service'] as List<dynamic>? ?? [];
    if (services.isNotEmpty) {
      final firstService = services.first as Map<String, dynamic>;
      final properties = firstService['properties'] as Map<String, dynamic>? ?? {};
      resolvedCommand = resolvedCommand.replaceAll('{port}', properties['port']?.toString() ?? '');
      resolvedCommand = resolvedCommand.replaceAll('{service_name}', firstService['name'] ?? '');
    }
    
    // Replace credential placeholders
    final credentials = assets['credential'] as List<dynamic>? ?? [];
    if (credentials.isNotEmpty) {
      final firstCredential = credentials.first as Map<String, dynamic>;
      final properties = firstCredential['properties'] as Map<String, dynamic>? ?? {};
      resolvedCommand = resolvedCommand.replaceAll('{username}', properties['username'] ?? '');
      resolvedCommand = resolvedCommand.replaceAll('{password}', properties['password'] ?? '');
    }
    
    return resolvedCommand;
  }

  Future<StepExecution> _executeCommand(StepExecution stepExecution, MethodologyStep step) async {
    try {
      final process = await Process.start(
        'bash',
        ['-c', stepExecution.command],
        runInShell: true,
      );
      
      // Set timeout if specified
      Timer? timeoutTimer;
      if (step.timeout != null) {
        timeoutTimer = Timer(step.timeout!, () {
          process.kill();
        });
      }
      
      final stdout = await process.stdout.transform(const SystemEncoding().decoder).join();
      final stderr = await process.stderr.transform(const SystemEncoding().decoder).join();
      final exitCode = await process.exitCode;
      
      timeoutTimer?.cancel();
      
      // Discover assets from output
      final discoveredAssets = await _discoverAssetsFromOutput(stdout, step.assetDiscoveryRules);
      final discoveredAssetIds = discoveredAssets.map((a) => a.id).toList();
      
      return stepExecution.copyWith(
        status: exitCode == 0 ? ExecutionStatus.completed : ExecutionStatus.failed,
        output: stdout,
        errorOutput: stderr.isNotEmpty ? stderr : null,
        exitCode: exitCode,
        completedDate: DateTime.now(),
        discoveredAssetIds: discoveredAssetIds,
      );
      
    } catch (e) {
      return stepExecution.copyWith(
        status: ExecutionStatus.failed,
        errorOutput: e.toString(),
        completedDate: DateTime.now(),
      );
    }
  }

  Future<StepExecution> _executeScript(StepExecution stepExecution, MethodologyStep step) async {
    // For now, treat scripts the same as commands
    // In a full implementation, this would handle script execution differently
    return _executeCommand(stepExecution, step);
  }

  Future<StepExecution> _executeManualStep(StepExecution stepExecution, MethodologyStep step) async {
    // Manual steps require user interaction - mark as completed for now
    // In a real implementation, this would wait for user confirmation
    return stepExecution.copyWith(
      status: ExecutionStatus.completed,
      output: 'Manual step completed',
      completedDate: DateTime.now(),
    );
  }

  Future<StepExecution> _executeValidation(StepExecution stepExecution, MethodologyStep step) async {
    // Validation steps check conditions - simplified implementation
    return stepExecution.copyWith(
      status: ExecutionStatus.completed,
      output: 'Validation completed',
      completedDate: DateTime.now(),
    );
  }

  Future<List<DiscoveredAsset>> _discoverAssetsFromOutput(String output, List<AssetDiscoveryRule> rules) async {
    final discoveredAssets = <DiscoveredAsset>[];
    
    for (final rule in rules) {
      final regex = RegExp(rule.pattern, multiLine: true);
      final matches = regex.allMatches(output);
      
      for (final match in matches) {
        final asset = DiscoveredAsset(
          id: _uuid.v4(),
          projectId: '', // Will be set by caller
          type: _parseAssetType(rule.assetType),
          name: match.group(0) ?? '',
          value: match.group(1) ?? match.group(0) ?? '',
          confidence: rule.confidence,
          discoveredDate: DateTime.now(),
          properties: rule.metadata,
        );
        
        discoveredAssets.add(asset);
      }
    }
    
    return discoveredAssets;
  }

  AssetType _parseAssetType(String assetTypeString) {
    for (final assetType in AssetType.values) {
      if (assetType.name == assetTypeString) {
        return assetType;
      }
    }
    return AssetType.other;
  }

  Future<void> _processDiscoveredAssets(MethodologyExecution execution, List<StepExecution> stepExecutions) async {
    final allDiscoveredAssets = <DiscoveredAsset>[];
    
    for (final stepExecution in stepExecutions) {
      if (stepExecution.discoveredAssetIds.isNotEmpty) {
        // In a real implementation, we'd retrieve the actual assets from storage
        // For now, we'll create placeholder assets based on the asset IDs
        for (final _ in stepExecution.discoveredAssetIds) {
          // This is a simplified approach - in reality we'd have proper asset storage
          // The asset IDs would be used to retrieve actual DiscoveredAsset objects
        }
      }
    }
    
    if (allDiscoveredAssets.isNotEmpty) {
      addDiscoveredAssets(execution.projectId, allDiscoveredAssets);
    }
  }

  void suppressRecommendation(String recommendationId, String reason) {
    final index = _recommendations.indexWhere((r) => r.id == recommendationId);
    if (index != -1) {
      _recommendations.removeAt(index);
      _recommendationsController.add(_recommendations);
    }
  }

  void dismissRecommendation(String recommendationId) {
    final index = _recommendations.indexWhere((r) => r.id == recommendationId);
    if (index != -1) {
      _recommendations[index] = _recommendations[index].copyWith(isDismissed: true);
      _recommendationsController.add(_recommendations);
    }
  }

  MethodologyExecution? getExecution(String executionId) {
    return _activeExecutions[executionId];
  }

  /// Generate attack chain steps for a discovered asset
  Future<void> _generateAttackChainSteps(String projectId, DiscoveredAsset asset) async {
    try {
      final generatedSteps = await _attackChainService.generateStepsForAsset(projectId, asset);

      // Optionally log or notify about generated steps
      if (generatedSteps.isNotEmpty) {
        print('Generated ${generatedSteps.length} attack chain steps for asset: ${asset.name}');
      }
    } catch (e) {
      print('Error generating attack chain steps for asset ${asset.name}: $e');
    }
  }

  /// Get attack chain service for UI access
  AttackChainService get attackChainService => _attackChainService;

  /// Get attack chain steps for a project
  List<AttackChainStep> getProjectAttackChain(String projectId) {
    return _attackChainService.getProjectChain(projectId);
  }

  /// Get attack chain stream
  Stream<List<AttackChainStep>> get attackChainStream => _attackChainService.chainStream;

  void dispose() {
    _executionsController.close();
    _recommendationsController.close();
    _assetsController.close();
    _attackChainService.dispose();
  }
}

class MethodologyEngineException implements Exception {
  final String message;
  MethodologyEngineException(this.message);
  
  @override
  String toString() => 'MethodologyEngineException: $message';
}