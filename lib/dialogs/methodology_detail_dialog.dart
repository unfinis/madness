import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology_detail.dart';
import '../services/attack_chain_service.dart';

class MethodologyDetailDialog extends ConsumerStatefulWidget {
  final AttackChainStep step;
  final MethodologyDetail? methodologyDetail;

  const MethodologyDetailDialog({
    super.key,
    required this.step,
    this.methodologyDetail,
  });

  @override
  ConsumerState<MethodologyDetailDialog> createState() => _MethodologyDetailDialogState();
}

class _MethodologyDetailDialogState extends ConsumerState<MethodologyDetailDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final Map<String, String> _commandVariables = {};
  MethodologyOutcome? _capturedOutcome;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final methodologyDetail = widget.methodologyDetail ?? _createSampleMethodology();

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStepIcon(widget.step.phase),
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.step.title,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Phase: ${widget.step.phase.displayName} • Priority: ${widget.step.priority}/10',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(icon: Icon(Icons.info), text: 'Methodology'),
                Tab(icon: Icon(Icons.terminal), text: 'Commands'),
                Tab(icon: Icon(Icons.cleaning_services), text: 'Cleanup'),
                Tab(icon: Icon(Icons.warning), text: 'Issues'),
                Tab(icon: Icon(Icons.search), text: 'Findings'),
                Tab(icon: Icon(Icons.assignment_turned_in), text: 'Outcome'),
              ],
            ),

            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMethodologyTab(methodologyDetail),
                  _buildCommandsTab(methodologyDetail),
                  _buildCleanupTab(methodologyDetail),
                  _buildIssuesTab(methodologyDetail),
                  _buildFindingsTab(methodologyDetail),
                  _buildOutcomeTab(methodologyDetail),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodologyTab(MethodologyDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Unique ID', detail.uniqueId, Icons.fingerprint),
          const SizedBox(height: 16),
          _buildInfoCard('Overview', detail.overview, Icons.description),
          const SizedBox(height: 16),
          _buildInfoCard('Purpose', detail.purpose, Icons.track_changes),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.schedule, color: Colors.blue[700]),
                      const SizedBox(width: 8),
                      Text(
                        'Execution Details',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatChip('Duration', '${widget.step.estimatedDuration.inMinutes} min', Icons.timer),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatChip('Commands', '${detail.commands.length}', Icons.terminal),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildStatChip('Cleanup', '${detail.cleanupSteps.length}', Icons.cleaning_services),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandsTab(MethodologyDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detail.commands.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.terminal, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No commands available for this methodology',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ...detail.commands.map((command) => _buildCommandCard(command)),
        ],
      ),
    );
  }

  Widget _buildCommandCard(MethodologyCommand command) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(
          _getShellIcon(command.defaultShell),
          color: _getShellColor(command.defaultShell),
        ),
        title: Text(
          command.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(command.description),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primary Command
                _buildCommandSection(
                  'Primary Command',
                  command.getResolvedCommand(_commandVariables),
                  command.defaultShell,
                ),

                // Prerequisites
                if (command.prerequisites.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildListSection('Prerequisites', command.prerequisites, Icons.check_circle_outline),
                ],

                // Variables
                if (command.variables.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildVariablesSection(command),
                ],

                // Download Method
                if (command.downloadMethod != null) ...[
                  const SizedBox(height: 16),
                  _buildDownloadSection(command.downloadMethod!),
                ],

                // Alternative Commands
                if (command.alternatives.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildAlternativesSection(command.alternatives),
                ],

                // Expected Output
                if (command.expectedOutput != null) ...[
                  const SizedBox(height: 16),
                  _buildCommandSection('Expected Output', command.expectedOutput!, null),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandSection(String title, String content, ShellType? shell) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (shell != null) ...[
              const SizedBox(width: 8),
              Chip(
                label: Text(shell.displayName),
                backgroundColor: _getShellColor(shell).withOpacity(0.2),
                labelStyle: TextStyle(color: _getShellColor(shell)),
              ),
            ],
            const Spacer(),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Command copied to clipboard')),
                );
              },
              icon: const Icon(Icons.copy),
              tooltip: 'Copy to clipboard',
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: SelectableText(
            content,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVariablesSection(MethodologyCommand command) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Variables',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...command.variables.entries.map((entry) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  '{${entry.key}}',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ),
              Expanded(
                child: TextFormField(
                  initialValue: _commandVariables[entry.key] ?? entry.value,
                  decoration: InputDecoration(
                    hintText: entry.value,
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _commandVariables[entry.key] = value;
                  },
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildDownloadSection(DownloadMethod method) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Download Method: ${method.displayName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Row(
            children: [
              Icon(Icons.download, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Expanded(
                child: Text(method.getDownloadCommand('{URL}', '{OUTPUT_PATH}')),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAlternativesSection(List<AlternativeCommand> alternatives) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alternative Commands',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...alternatives.map((alt) => Card(
          child: ListTile(
            leading: Icon(_getShellIcon(alt.shell)),
            title: Text(alt.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (alt.reason != null) Text('Reason: ${alt.reason}'),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SelectableText(
                    alt.command,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: alt.command));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alternative command copied')),
                );
              },
              icon: const Icon(Icons.copy),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildCleanupTab(MethodologyDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detail.cleanupSteps.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.cleaning_services, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No cleanup steps required for this methodology',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else ...[
            const Text(
              'Cleanup Steps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...detail.cleanupSteps.map((step) => _buildCleanupCard(step)),
          ],
        ],
      ),
    );
  }

  Widget _buildCleanupCard(CleanupStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getCleanupPriorityColor(step.priority).withOpacity(0.2),
          child: Icon(
            step.required ? Icons.error : Icons.info,
            color: _getCleanupPriorityColor(step.priority),
          ),
        ),
        title: Text(
          step.title,
          style: TextStyle(
            fontWeight: step.required ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.description),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(_getShellIcon(step.shell), size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SelectableText(
                      step.command,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Chip(
              label: Text(step.priority.displayName),
              backgroundColor: _getCleanupPriorityColor(step.priority).withOpacity(0.2),
            ),
            IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: step.command));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cleanup command copied')),
                );
              },
              icon: const Icon(Icons.copy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesTab(MethodologyDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detail.commonIssues.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.check_circle, size: 64, color: Colors.green[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No common issues documented for this methodology',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else ...[
            const Text(
              'Common Issues & Resolutions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...detail.commonIssues.map((issue) => _buildIssueCard(issue)),
          ],
        ],
      ),
    );
  }

  Widget _buildIssueCard(CommonIssue issue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getIssueSeverityColor(issue.severity).withOpacity(0.2),
          child: Icon(
            Icons.warning,
            color: _getIssueSeverityColor(issue.severity),
          ),
        ),
        title: Text(
          issue.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(issue.symptom),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description:',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(issue.description),
                if (issue.possibleCauses.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildListSection('Possible Causes', issue.possibleCauses, Icons.help_outline),
                ],
                if (issue.resolutions.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'Resolutions:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...issue.resolutions.map((resolution) => _buildResolutionCard(resolution)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionCard(Resolution resolution) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(resolution.description),
            if (resolution.command != null) ...[
              const SizedBox(height: 8),
              _buildCommandSection('Command', resolution.command!, resolution.shell),
            ],
            if (resolution.steps.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildListSection('Steps', resolution.steps, Icons.list),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFindingsTab(MethodologyDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Related Findings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addFinding,
                icon: const Icon(Icons.add),
                label: const Text('Add Finding'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (detail.relatedFindings.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.search, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No findings documented yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add findings as you discover them during execution',
                    style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  ),
                ],
              ),
            )
          else
            ...detail.relatedFindings.map((finding) => _buildFindingCard(finding)),
        ],
      ),
    );
  }

  Widget _buildFindingCard(RelatedFinding finding) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getFindingSeverityColor(finding.severity).withOpacity(0.2),
          child: Icon(
            Icons.bug_report,
            color: _getFindingSeverityColor(finding.severity),
          ),
        ),
        title: Text(finding.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(finding.description),
            if (finding.cveId != null) ...[
              const SizedBox(height: 4),
              Text('CVE: ${finding.cveId}', style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
            if (finding.affectedSystems.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('Affected: ${finding.affectedSystems.join(", ")}'),
            ],
          ],
        ),
        trailing: Chip(
          label: Text(finding.severity.displayName),
          backgroundColor: _getFindingSeverityColor(finding.severity).withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildOutcomeTab(MethodologyDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Capture Execution Outcome',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (_capturedOutcome == null)
            _buildOutcomeCapture()
          else
            _buildOutcomeDisplay(_capturedOutcome!),
        ],
      ),
    );
  }

  Widget _buildOutcomeCapture() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Record the outcome of executing this methodology:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Row(
              children: OutcomeStatus.values.map((status) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () => _captureOutcome(status),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getOutcomeStatusColor(status).withOpacity(0.2),
                      foregroundColor: _getOutcomeStatusColor(status),
                    ),
                    child: Text(status.displayName),
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutcomeDisplay(MethodologyOutcome outcome) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getOutcomeStatusIcon(outcome.status),
                  color: _getOutcomeStatusColor(outcome.status),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status: ${outcome.status.displayName}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getOutcomeStatusColor(outcome.status),
                  ),
                ),
                const Spacer(),
                Text(
                  'Executed: ${outcome.timestamp.toString().substring(0, 19)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (outcome.notes != null) ...[
              const SizedBox(height: 12),
              Text('Notes: ${outcome.notes}'),
            ],
            if (outcome.discoveredAssets.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Discovered Assets: ${outcome.discoveredAssets.join(", ")}'),
            ],
          ],
        ),
      ),
    );
  }

  // Helper methods for building UI components
  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(content),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(item)),
            ],
          ),
        )),
      ],
    );
  }

  // Helper methods for icons and colors
  IconData _getStepIcon(AttackChainPhase phase) {
    switch (phase) {
      case AttackChainPhase.reconnaissance:
        return Icons.search;
      case AttackChainPhase.initialAccess:
        return Icons.login;
      case AttackChainPhase.credentialAccess:
        return Icons.key;
      case AttackChainPhase.lateralMovement:
        return Icons.network_check;
      case AttackChainPhase.privilegeEscalation:
        return Icons.trending_up;
      case AttackChainPhase.persistence:
        return Icons.lock;
      case AttackChainPhase.domainAdmin:
        return Icons.admin_panel_settings;
    }
  }

  IconData _getShellIcon(ShellType shell) {
    switch (shell) {
      case ShellType.bash:
        return Icons.terminal;
      case ShellType.powershell:
        return Icons.power;
      case ShellType.cmd:
        return Icons.computer;
      case ShellType.python:
        return Icons.code;
      case ShellType.ruby:
        return Icons.diamond;
      case ShellType.nodejs:
        return Icons.javascript;
    }
  }

  Color _getShellColor(ShellType shell) {
    switch (shell) {
      case ShellType.bash:
        return Colors.green;
      case ShellType.powershell:
        return Colors.blue;
      case ShellType.cmd:
        return Colors.grey;
      case ShellType.python:
        return Colors.yellow[700]!;
      case ShellType.ruby:
        return Colors.red;
      case ShellType.nodejs:
        return Colors.green[700]!;
    }
  }

  Color _getCleanupPriorityColor(CleanupPriority priority) {
    switch (priority) {
      case CleanupPriority.low:
        return Colors.green;
      case CleanupPriority.medium:
        return Colors.orange;
      case CleanupPriority.high:
        return Colors.red;
      case CleanupPriority.critical:
        return Colors.purple;
    }
  }

  Color _getIssueSeverityColor(IssueSeverity severity) {
    switch (severity) {
      case IssueSeverity.low:
        return Colors.green;
      case IssueSeverity.medium:
        return Colors.orange;
      case IssueSeverity.high:
        return Colors.red;
      case IssueSeverity.critical:
        return Colors.purple;
    }
  }

  Color _getFindingSeverityColor(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.informational:
        return Colors.blue;
      case FindingSeverity.low:
        return Colors.green;
      case FindingSeverity.medium:
        return Colors.orange;
      case FindingSeverity.high:
        return Colors.red;
      case FindingSeverity.critical:
        return Colors.purple;
    }
  }

  Color _getOutcomeStatusColor(OutcomeStatus status) {
    switch (status) {
      case OutcomeStatus.success:
        return Colors.green;
      case OutcomeStatus.partial:
        return Colors.orange;
      case OutcomeStatus.failed:
        return Colors.red;
      case OutcomeStatus.skipped:
        return Colors.grey;
      case OutcomeStatus.blocked:
        return Colors.purple;
    }
  }

  IconData _getOutcomeStatusIcon(OutcomeStatus status) {
    switch (status) {
      case OutcomeStatus.success:
        return Icons.check_circle;
      case OutcomeStatus.partial:
        return Icons.incomplete_circle;
      case OutcomeStatus.failed:
        return Icons.error;
      case OutcomeStatus.skipped:
        return Icons.skip_next;
      case OutcomeStatus.blocked:
        return Icons.block;
    }
  }

  // Event handlers
  void _captureOutcome(OutcomeStatus status) {
    // This would typically show a dialog to capture more details
    // For now, just create a basic outcome
    setState(() {
      _capturedOutcome = MethodologyOutcome(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        methodologyId: widget.step.methodologyId,
        stepId: widget.step.id,
        timestamp: DateTime.now(),
        status: status,
      );
    });
  }

  void _addFinding() {
    // This would show a dialog to add a new finding
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Finding dialog - to be implemented')),
    );
  }

  // Create sample methodology for demonstration
  MethodologyDetail _createSampleMethodology() {
    return MethodologyDetail(
      id: widget.step.methodologyId,
      title: widget.step.title,
      uniqueId: 'METH-${widget.step.methodologyId.toUpperCase()}',
      overview: widget.step.description,
      purpose: 'This methodology helps achieve the objective by providing structured steps and commands.',
      commands: [
        MethodologyCommand(
          id: 'cmd1',
          title: 'Primary Execution',
          description: 'Main command to execute this methodology',
          primaryCommand: 'nmap -sV -sC {target_host}',
          variables: {'target_host': '192.168.1.1'},
          defaultShell: ShellType.bash,
          estimatedDuration: const Duration(minutes: 5),
          prerequisites: ['Network connectivity', 'Nmap installed'],
          expectedOutput: 'Port scan results with service versions',
        ),
      ],
      cleanupSteps: [
        CleanupStep(
          id: 'cleanup1',
          title: 'Clear scan cache',
          description: 'Remove temporary scan files',
          command: 'rm -f /tmp/nmap_scan_*',
          shell: ShellType.bash,
          priority: CleanupPriority.low,
        ),
      ],
      commonIssues: [
        CommonIssue(
          id: 'issue1',
          title: 'Permission Denied',
          description: 'Command fails due to insufficient privileges',
          symptom: 'Error: Permission denied',
          possibleCauses: ['Not running as root', 'Firewall blocking'],
          resolutions: [
            Resolution(
              description: 'Run with sudo',
              command: 'sudo {original_command}',
              shell: ShellType.bash,
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}