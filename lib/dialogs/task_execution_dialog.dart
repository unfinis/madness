import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_queue_provider.dart';
import '../providers/methodology_provider.dart';
import '../providers/projects_provider.dart';
import '../services/command_generator.dart';
import '../models/methodology.dart';
import '../constants/app_spacing.dart';
import '../widgets/common/trigger_widgets.dart';
import '../theme/app_decorations.dart';

class TaskExecutionDialog extends ConsumerStatefulWidget {
  final TaskInstance task;

  const TaskExecutionDialog({
    super.key,
    required this.task,
  });

  @override
  ConsumerState<TaskExecutionDialog> createState() => _TaskExecutionDialogState();
}

class _TaskExecutionDialogState extends ConsumerState<TaskExecutionDialog> {
  TriggerInstance? _selectedTrigger;
  MethodologyStep? _selectedStep;
  String _generatedCommand = '';
  final TextEditingController _outputController = TextEditingController();
  final CommandGenerator _commandGenerator = CommandGenerator();
  bool _isExecuting = false;

  @override
  void initState() {
    super.initState();
    _selectedTrigger = widget.task.triggers.firstWhere(
      (t) => t.status == TriggerStatus.pending,
      orElse: () => widget.task.triggers.first,
    );
    _generateCommand();
  }

  @override
  void dispose() {
    _outputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 800,
        constraints: const BoxConstraints(maxHeight: 700),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTriggerSelection(),
                    const SizedBox(height: AppSpacing.md),
                    _buildStepSelection(),
                    const SizedBox(height: AppSpacing.md),
                    _buildCommandSection(),
                    const SizedBox(height: AppSpacing.md),
                    _buildOutputSection(),
                  ],
                ),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.info().copyWith(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.play_circle,
            color: Theme.of(context).primaryColor,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Execute Task',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.task.methodologyName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Trigger',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: widget.task.triggers.map((trigger) {
              final isSelected = _selectedTrigger?.id == trigger.id;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedTrigger = trigger;
                    _generateCommand();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppDecorations.selected(primaryColor: Theme.of(context).primaryColor).color
                        : null,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      TriggerStatusIcon(status: trigger.status),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              TriggerDisplayUtils.getText(trigger),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Status: ${TriggerDisplayUtils.getStatusText(trigger.status)}',
                              style: AppTextStyles.muted(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStepSelection() {
    final methodology = _getMethodology();
    if (methodology == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Step',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<MethodologyStep>(
          initialValue: _selectedStep,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Choose a step to execute',
          ),
          items: methodology.steps.map((step) {
            return DropdownMenuItem(
              value: step,
              child: Text('${step.orderIndex + 1}. ${step.name}'),
            );
          }).toList(),
          onChanged: (step) {
            setState(() {
              _selectedStep = step;
              _generateCommand();
            });
          },
        ),
      ],
    );
  }

  Widget _buildCommandSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Generated Command',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: _generatedCommand.isNotEmpty
                  ? () => _copyCommand()
                  : null,
              tooltip: 'Copy Command',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _generateCommand(),
              tooltip: 'Regenerate Command',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: AppDecorations.neutral(),
          child: _generatedCommand.isNotEmpty
              ? SelectableText(
                  _generatedCommand,
                  style: AppTextStyles.code(fontSize: 14),
                )
              : const Text(
                  'Select a trigger and step to generate command',
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildOutputSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Command Output',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _outputController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste the command output here...',
                alignLabelWithHint: true,
              ),
              style: AppTextStyles.code(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          if (_selectedTrigger?.status == TriggerStatus.pending)
            ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: Text(_isExecuting ? 'Executing...' : 'Execute'),
              onPressed: _isExecuting ? null : _executeTrigger,
            ),
          const SizedBox(width: AppSpacing.sm),
          OutlinedButton.icon(
            icon: const Icon(Icons.skip_next),
            label: const Text('Skip'),
            onPressed: _skipTrigger,
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: AppSpacing.sm),
          ElevatedButton(
            onPressed: _outputController.text.isNotEmpty
                ? _completeWithOutput
                : null,
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }


  Methodology? _getMethodology() {
    final projectId = ref.read(currentProjectProvider)?.id;
    if (projectId == null) return null;

    final methodologyState = ref.read(methodologyProvider(projectId));
    try {
      return methodologyState.availableMethodologies
          .firstWhere((m) => m.id == widget.task.methodologyId);
    } catch (e) {
      return null;
    }
  }

  void _generateCommand() {
    if (_selectedTrigger == null || _selectedStep == null) {
      setState(() {
        _generatedCommand = '';
      });
      return;
    }

    final context = _commandGenerator.buildExecutionContext(
      _selectedTrigger!.context,
      {},
    );

    final command = _commandGenerator.generateCommand(_selectedStep!, context);

    setState(() {
      _generatedCommand = command;
    });
  }

  void _copyCommand() {
    if (_generatedCommand.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _generatedCommand));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Command copied to clipboard')),
      );
    }
  }

  void _executeTrigger() async {
    if (_selectedTrigger == null) return;

    setState(() {
      _isExecuting = true;
    });

    try {
      // Execute the entire task via the task queue provider
      await ref.read(taskQueueProvider.notifier).executeTask(widget.task.id);

      if (mounted) {
        setState(() {
          _isExecuting = false;
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task executed successfully')),
        );

        // Update the trigger status to completed
        _selectedTrigger = _selectedTrigger!.copyWith(status: TriggerStatus.completed);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExecuting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Execution failed: $e')),
        );

        // Update the trigger status to failed
        _selectedTrigger = _selectedTrigger!.copyWith(status: TriggerStatus.failed);
      }
    }
  }

  void _skipTrigger() {
    if (_selectedTrigger == null) return;

    ref.read(taskQueueProvider.notifier).skipTrigger(
      widget.task.id,
      _selectedTrigger!.id,
    );

    Navigator.of(context).pop();
  }

  void _completeWithOutput() {
    if (_selectedTrigger == null || _outputController.text.isEmpty) return;

    try {
      // Update the trigger with output and mark as completed
      ref.read(taskQueueProvider.notifier).completeTriggerWithOutput(
        widget.task.id,
        _selectedTrigger!.id,
        _outputController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task completed with output')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error completing task: $e')),
      );
    }

    Navigator.of(context).pop();
  }
}