import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/attack_chain_service.dart';
import '../services/methodology_engine.dart';
import 'methodology_provider.dart';
import 'projects_provider.dart';

/// Provider for attack chain service
final attackChainServiceProvider = Provider<AttackChainService>((ref) {
  return AttackChainService();
});

/// Attack chain state for a project
final attackChainProvider = StreamProvider.family<List<AttackChainStep>, String>((ref, projectId) {
  final engine = ref.read(methodologyEngineProvider);
  return engine.attackChainStream.map((steps) =>
    steps.where((step) => step.projectId == projectId).toList()
  );
});

/// Attack chain statistics provider
final attackChainStatsProvider = Provider.family<AttackChainStats, String>((ref, projectId) {
  final chainAsync = ref.watch(attackChainProvider(projectId));

  return chainAsync.when(
    data: (chain) => AttackChainStats.fromSteps(chain),
    loading: () => const AttackChainStats.empty(),
    error: (_, __) => const AttackChainStats.empty(),
  );
});

/// Current phase provider
final currentPhaseProvider = Provider.family<AttackChainPhase?, String>((ref, projectId) {
  final chainAsync = ref.watch(attackChainProvider(projectId));

  return chainAsync.when(
    data: (chain) {
      if (chain.isEmpty) return null;

      // Find the highest phase that has been started
      AttackChainPhase? currentPhase;
      for (final step in chain) {
        if (step.status != AttackChainStepStatus.pending) {
          if (currentPhase == null || step.phase.index > currentPhase.index) {
            currentPhase = step.phase;
          }
        }
      }

      return currentPhase ?? AttackChainPhase.reconnaissance;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Steps by phase provider
final stepsByPhaseProvider = Provider.family<Map<AttackChainPhase, List<AttackChainStep>>, String>((ref, projectId) {
  final chainAsync = ref.watch(attackChainProvider(projectId));

  return chainAsync.when(
    data: (chain) {
      final stepsByPhase = <AttackChainPhase, List<AttackChainStep>>{};

      for (final phase in AttackChainPhase.values) {
        stepsByPhase[phase] = chain.where((step) => step.phase == phase).toList();
        // Sort by priority within each phase
        stepsByPhase[phase]!.sort((a, b) => b.priority.compareTo(a.priority));
      }

      return stepsByPhase;
    },
    loading: () => <AttackChainPhase, List<AttackChainStep>>{},
    error: (_, __) => <AttackChainPhase, List<AttackChainStep>>{},
  );
});

/// Next recommended steps provider
final nextRecommendedStepsProvider = Provider.family<List<AttackChainStep>, String>((ref, projectId) {
  final stepsByPhase = ref.watch(stepsByPhaseProvider(projectId));
  final currentPhase = ref.watch(currentPhaseProvider(projectId));

  if (currentPhase == null) {
    // If no current phase, return reconnaissance steps
    return stepsByPhase[AttackChainPhase.reconnaissance]?.take(3).toList() ?? [];
  }

  // Get pending steps from current phase
  final currentPhaseSteps = stepsByPhase[currentPhase]
      ?.where((step) => step.status == AttackChainStepStatus.pending)
      .take(2)
      .toList() ?? [];

  // If current phase has pending steps, return those
  if (currentPhaseSteps.isNotEmpty) {
    return currentPhaseSteps;
  }

  // Otherwise, get steps from next phase
  final nextPhaseIndex = currentPhase.index + 1;
  if (nextPhaseIndex < AttackChainPhase.values.length) {
    final nextPhase = AttackChainPhase.values[nextPhaseIndex];
    return stepsByPhase[nextPhase]?.take(3).toList() ?? [];
  }

  return [];
});

/// Attack chain statistics
class AttackChainStats {
  final int totalSteps;
  final int pendingSteps;
  final int completedSteps;
  final int failedSteps;
  final double completionPercentage;
  final AttackChainPhase? currentPhase;
  final Map<AttackChainPhase, int> stepsByPhase;
  final Duration estimatedTimeRemaining;

  const AttackChainStats({
    required this.totalSteps,
    required this.pendingSteps,
    required this.completedSteps,
    required this.failedSteps,
    required this.completionPercentage,
    this.currentPhase,
    required this.stepsByPhase,
    required this.estimatedTimeRemaining,
  });

  const AttackChainStats.empty()
      : totalSteps = 0,
        pendingSteps = 0,
        completedSteps = 0,
        failedSteps = 0,
        completionPercentage = 0.0,
        currentPhase = null,
        stepsByPhase = const {},
        estimatedTimeRemaining = Duration.zero;

  factory AttackChainStats.fromSteps(List<AttackChainStep> steps) {
    if (steps.isEmpty) return const AttackChainStats.empty();

    int pending = 0;
    int completed = 0;
    int failed = 0;

    final stepsByPhase = <AttackChainPhase, int>{};
    Duration totalEstimatedTime = Duration.zero;

    for (final step in steps) {
      // Count by status
      switch (step.status) {
        case AttackChainStepStatus.pending:
          pending++;
          totalEstimatedTime += step.estimatedDuration;
          break;
        case AttackChainStepStatus.inProgress:
          pending++; // Count in-progress as pending for stats
          totalEstimatedTime += step.estimatedDuration;
          break;
        case AttackChainStepStatus.completed:
          completed++;
          break;
        case AttackChainStepStatus.failed:
          failed++;
          break;
        case AttackChainStepStatus.skipped:
          completed++; // Count skipped as completed
          break;
      }

      // Count by phase
      stepsByPhase[step.phase] = (stepsByPhase[step.phase] ?? 0) + 1;
    }

    final total = steps.length;
    final completionPercentage = total > 0 ? (completed / total) : 0.0;

    // Determine current phase
    AttackChainPhase? currentPhase;
    for (final step in steps) {
      if (step.status != AttackChainStepStatus.pending) {
        if (currentPhase == null || step.phase.index > currentPhase.index) {
          currentPhase = step.phase;
        }
      }
    }

    return AttackChainStats(
      totalSteps: total,
      pendingSteps: pending,
      completedSteps: completed,
      failedSteps: failed,
      completionPercentage: completionPercentage,
      currentPhase: currentPhase,
      stepsByPhase: stepsByPhase,
      estimatedTimeRemaining: totalEstimatedTime,
    );
  }
}