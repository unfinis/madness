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
              icon: const Icon(Icons.help_outline),
              onPressed: () => _showInstructions(),
              tooltip: 'Show Instructions',
            ),
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
        if (_generatedCommand.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '💡 Copy the command above, run it in your terminal, then paste the complete output below.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOutputSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Command Output',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.lightbulb_outline),
                onPressed: () => _showExampleOutput(),
                tooltip: 'Show Example Output',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: TextField(
              controller: _outputController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: _getOutputHintText(),
                alignLabelWithHint: true,
                helperText: 'Paste the complete output from your terminal here',
                helperMaxLines: 2,
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

  void _showInstructions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Execution Instructions'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How to execute methodology commands:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text('1. 📋 Copy the generated command'),
              const Text('2. 🖥️ Run it in your terminal/command line'),
              const Text('3. ⌚ Wait for the command to complete'),
              const Text('4. 📄 Copy the complete output'),
              const Text('5. 📝 Paste the output in the text field below'),
              const Text('6. ✅ Click "Complete" to save results'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚠️ Important:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('• Include ALL output, not just part of it'),
                    Text('• Copy any error messages too'),
                    Text('• Don\'t modify the output before pasting'),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _showExampleOutput() {
    final exampleOutput = _getExampleForCommand(_generatedCommand);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Example Output Format'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expected output format for this command:',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SelectableText(
                    exampleOutput,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '💡 Your actual output may vary, but should follow a similar format.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _getOutputHintText() {
    if (_generatedCommand.contains('nmap')) {
      return 'Paste nmap scan results here...\nExample: Nmap scan report for 192.168.1.10';
    } else if (_generatedCommand.contains('responder')) {
      return 'Paste Responder output here...\nLook for captured hashes and usernames';
    } else if (_generatedCommand.contains('crackmapexec')) {
      return 'Paste CrackMapExec output here...\nLook for [+] success indicators';
    } else {
      return 'Paste the complete command output here...';
    }
  }

  String _getExampleForCommand(String command) {
    if (command.contains('nmap')) {
      return '''Starting Nmap 7.80 ( https://nmap.org )
Nmap scan report for 192.168.1.10
Host is up (0.00050s latency).
PORT     STATE SERVICE      VERSION
22/tcp   open  ssh          OpenSSH 8.0
80/tcp   open  http         Apache httpd 2.4.41
139/tcp  open  netbios-ssn  Samba smbd 4.6.2
445/tcp  open  microsoft-ds Samba smbd 4.6.2

Nmap scan report for 192.168.1.20
Host is up (0.00075s latency).
PORT     STATE SERVICE
80/tcp   open  http
443/tcp  open  https

Nmap done: 256 IP addresses (2 hosts up) scanned in 5.23 seconds''';
    } else if (command.contains('responder')) {
      return '''[+] Listening for events...
[*] Responder is in analyze mode. No NBT-NS, LLMNR, MDNS requests will be poisoned.
[SMB] NTLMv2-SSP Client   : 192.168.1.100
[SMB] NTLMv2-SSP Username : CORP\\johnsmith
[SMB] NTLMv2-SSP Hash     : johnsmith::CORP:1122334455667788:A1B2C3D4E5F6G7H8I9J0:response
[*] Skipping previously captured hash for CORP\\johnsmith''';
    } else if (command.contains('crackmapexec')) {
      return '''SMB         192.168.1.10    445    DC01             [*] Windows 10.0 Build 17763 x64 (name:DC01) (domain:CORP) (signing:True) (SMBv1:False)
SMB         192.168.1.10    445    DC01             [+] CORP\\administrator:Password123 (Pwn3d!)
SMB         192.168.1.20    445    WEB01            [*] Windows Server 2019 Build 17763 x64 (name:WEB01) (domain:CORP) (signing:False) (SMBv1:False)
SMB         192.168.1.20    445    WEB01            [+] CORP\\administrator:Password123''';
    } else {
      return '''Example command output would appear here.
The format depends on the specific tool being used.
Include all output text, error messages, and status indicators.

Common patterns to look for:
- IP addresses: 192.168.1.100
- Ports: 80/tcp, 443/tcp
- Services: http, ssh, smb
- Success indicators: [+], SUCCESS, OPEN
- Failure indicators: [-], FAILED, CLOSED''';
    }
  }
}