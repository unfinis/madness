import 'package:flutter/material.dart';
import '../services/trigger_system/models/execution_decision.dart';
import '../widgets/trigger_system_ui/execution_decision_card.dart';
import '../widgets/trigger_system_ui/trigger_notifications.dart';

/// Screen displaying all trigger evaluations with filtering and actions
class TriggerEvaluationScreen extends StatefulWidget {
  final List<ExecutionDecision> decisions;
  final Map<String, String> methodologyNames;
  final Function(ExecutionDecision)? onExecute;
  final Function(ExecutionDecision)? onSkip;

  const TriggerEvaluationScreen({
    super.key,
    required this.decisions,
    required this.methodologyNames,
    this.onExecute,
    this.onSkip,
  });

  @override
  State<TriggerEvaluationScreen> createState() => _TriggerEvaluationScreenState();
}

class _TriggerEvaluationScreenState extends State<TriggerEvaluationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'priority'; // priority, name, status

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Group decisions by status
    final toExecute = widget.decisions.where((d) => d.shouldExecute).toList();
    final skipped = widget.decisions.where((d) => !d.shouldExecute).toList();
    final matched = widget.decisions.where((d) => d.match.matched).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trigger Evaluations'),
        actions: [
          // Sort dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort by',
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'priority',
                child: Text('Sort by Priority'),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Text('Sort by Name'),
              ),
              const PopupMenuItem(
                value: 'status',
                child: Text('Sort by Status'),
              ),
            ],
          ),
          // Execute all button
          if (toExecute.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.play_arrow),
              tooltip: 'Execute All',
              onPressed: () => _executeAll(toExecute),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'All (${widget.decisions.length})'),
            Tab(text: 'To Execute (${toExecute.length})'),
            Tab(text: 'Skipped (${skipped.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDecisionList(widget.decisions, 'No evaluations available'),
          _buildDecisionList(toExecute, 'No decisions to execute'),
          _buildDecisionList(skipped, 'No decisions skipped'),
        ],
      ),
      floatingActionButton: toExecute.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _executeAll(toExecute),
              icon: const Icon(Icons.play_arrow),
              label: Text('Execute ${toExecute.length}'),
            )
          : null,
    );
  }

  Widget _buildDecisionList(List<ExecutionDecision> decisions, String emptyMessage) {
    if (decisions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Sort decisions
    final sortedDecisions = _sortDecisions(List.from(decisions));

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: sortedDecisions.length,
      itemBuilder: (context, index) {
        final decision = sortedDecisions[index];
        final methodologyName = widget.methodologyNames[decision.match.triggerId] ??
                                'Unknown Methodology';

        return ExecutionDecisionCard(
          decision: decision,
          methodologyName: methodologyName,
          onExecute: widget.onExecute != null
              ? () => _handleExecute(decision)
              : null,
          onSkip: widget.onSkip != null
              ? () => _handleSkip(decision)
              : null,
        );
      },
    );
  }

  List<ExecutionDecision> _sortDecisions(List<ExecutionDecision> decisions) {
    switch (_sortBy) {
      case 'priority':
        decisions.sort((a, b) => b.priority.score.compareTo(a.priority.score));
        break;
      case 'name':
        decisions.sort((a, b) {
          final nameA = widget.methodologyNames[a.match.triggerId] ?? '';
          final nameB = widget.methodologyNames[b.match.triggerId] ?? '';
          return nameA.compareTo(nameB);
        });
        break;
      case 'status':
        decisions.sort((a, b) {
          if (a.shouldExecute == b.shouldExecute) {
            return b.priority.score.compareTo(a.priority.score);
          }
          return a.shouldExecute ? -1 : 1;
        });
        break;
    }
    return decisions;
  }

  void _handleExecute(ExecutionDecision decision) {
    final methodologyName = widget.methodologyNames[decision.match.triggerId] ??
                            'methodology';

    if (widget.onExecute != null) {
      widget.onExecute!(decision);
      TriggerNotifications.showExecutionStarted(context, methodologyName);
    }
  }

  void _handleSkip(ExecutionDecision decision) {
    if (widget.onSkip != null) {
      widget.onSkip!(decision);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Execution skipped'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _executeAll(List<ExecutionDecision> decisions) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Execute All'),
        content: Text(
          'Execute ${decisions.length} methodologies?\n\n'
          'This will run all pending executions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (widget.onExecute != null) {
                for (final decision in decisions) {
                  widget.onExecute!(decision);
                }
                TriggerNotifications.showEvaluationSummary(
                  context,
                  totalTriggers: widget.decisions.length,
                  matchedTriggers: widget.decisions.where((d) => d.match.matched).length,
                  decisionsToExecute: decisions.length,
                );
              }
            },
            child: const Text('Execute All'),
          ),
        ],
      ),
    );
  }
}
