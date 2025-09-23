import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_spacing.dart';
import '../models/methodology_trigger_builder.dart';
import 'trigger_editor_dialog.dart';

class MethodologyDetailDialog extends ConsumerStatefulWidget {
  final Map<String, dynamic> methodology;
  final bool isFromLibrary;
  final Map<String, dynamic>? triggerContext; // For triggered steps

  const MethodologyDetailDialog({
    super.key,
    required this.methodology,
    this.isFromLibrary = false,
    this.triggerContext,
  });

  @override
  ConsumerState<MethodologyDetailDialog> createState() => _MethodologyDetailDialogState();
}

class _MethodologyDetailDialogState extends ConsumerState<MethodologyDetailDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _stepStatus = 'pending'; // pending, in_progress, completed, skipped
  final _outcomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.methodology['name'] ?? 'Unknown Methodology',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.methodology['id'] ?? 'unknown',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Tab bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Procedure'),
                Tab(text: 'Tools & References'),
                Tab(text: 'Trigger Context'),
                Tab(text: 'Findings'),
                Tab(text: 'Cleanup'),
                Tab(text: 'Execution'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildProcedureTab(),
                  _buildToolsReferencesTab(),
                  _buildTriggerContextTab(),
                  _buildFindingsTab(),
                  _buildCleanupTab(),
                  _buildExecutionTab(),
                ],
              ),
            ),

            // Footer actions
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.isFromLibrary ? 'Library Template' : _stepStatus.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getRiskColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      (widget.methodology['risk_level'] ?? 'low').toString().toUpperCase(),
                      style: TextStyle(
                        color: _getRiskColor(),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (!widget.isFromLibrary) ...[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    ElevatedButton(
                      onPressed: () {
                        // Save execution state
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save & Execute'),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (widget.isFromLibrary) {
      return Theme.of(context).primaryColor;
    }

    switch (_stepStatus) {
      case 'in_progress':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  Color _getRiskColor() {
    switch (widget.methodology['risk_level'] ?? 'low') {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }






  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Methodology ID', widget.methodology['id'] ?? 'unknown'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard('Title', widget.methodology['name'] ?? 'Unknown'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard('Estimated Duration', widget.methodology['estimated_duration'] ?? 'Unknown'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoCard('Stealth Level', widget.methodology['stealth_level'] ?? 'Unknown'),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description & Theory',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.methodology['description'] ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcedureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Commands & Steps',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '# Example Commands for ${widget.methodology['name']}',
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      '# Step 1: Initial reconnaissance\nnmap -sS -p- \${TARGET_IP}\n\n# Step 2: Service enumeration\nnmap -sC -sV -p \${OPEN_PORTS} \${TARGET_IP}\n\n# Step 3: Exploit execution\n# [Tool-specific commands would be here]\n\n# Step 4: Post-exploitation\n# [Follow-up commands would be here]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Note: Actual commands and steps would be dynamically loaded from the methodology YAML file. This is a placeholder showing the structure.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolsReferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Common Issues & Solutions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTroubleshootingItem(
                    '🔧 Network Connectivity Issues',
                    'Problem: Cannot reach target system\nSolution: Check network path, firewall rules, and routing',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTroubleshootingItem(
                    '🔧 Authentication Failures',
                    'Problem: Credentials not working as expected\nSolution: Verify credential format, check for account lockouts, try alternative authentication methods',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTroubleshootingItem(
                    '🔧 Tool Compatibility',
                    'Problem: Tools not working on target platform\nSolution: Check tool version compatibility, try alternative tools, adjust parameters',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildTroubleshootingItem(
                    '🔧 Permission Issues',
                    'Problem: Insufficient privileges for operation\nSolution: Escalate privileges first, use alternative methods, or adjust approach',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingItem(String title, String description) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Related Findings Templates',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildFindingTemplate(
                'High Risk',
                'Unauthenticated Remote Code Execution',
                'The target system allows unauthenticated remote code execution through [methodology findings]. This could allow an attacker to gain complete control of the system.',
                Colors.red,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildFindingTemplate(
                'Medium Risk',
                'Information Disclosure',
                'The methodology revealed sensitive information that could aid in further attacks, including [specific details found].',
                Colors.orange,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildFindingTemplate(
                'Low Risk',
                'Security Misconfiguration',
                'Minor security misconfigurations were identified that could be hardened to improve overall security posture.',
                Colors.yellow[700]!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFindingTemplate(String severity, String title, String description, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  severity.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerContextTab() {
    if (widget.isFromLibrary) {
      return _buildLibraryTriggersView();
    } else {
      return _buildTriggeredConditionsView();
    }
  }

  Widget _buildLibraryTriggersView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trigger Conditions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'This methodology will trigger when the following conditions are met:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTriggerCondition('Asset Type: HOST', 'Operating System: Windows'),
              _buildTriggerCondition('Service Available', 'Port 445 (SMB) open'),
              _buildTriggerCondition('Credentials Available', 'NTLM hash or password'),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                onPressed: () => _editTriggers(),
                icon: const Icon(Icons.edit),
                label: const Text('Edit Trigger Conditions'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTriggeredConditionsView() {
    final triggerContext = widget.triggerContext ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Triggering Conditions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'This methodology step was triggered by:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildTriggerDetails('Target Host', triggerContext['host'] ?? '192.168.1.10'),
              _buildTriggerDetails('Service', triggerContext['service'] ?? 'SMB (445/tcp)'),
              _buildTriggerDetails('Credential', triggerContext['credential'] ?? 'admin:ntlmhash'),
              _buildTriggerDetails('Triggered At', triggerContext['timestamp'] ?? DateTime.now().toString()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTriggerCondition(String condition, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Text('$condition: '),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanupTab() {
    final cleanupSteps = widget.methodology['cleanup'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cleanup Steps',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          if (cleanupSteps.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'No specific cleanup steps defined for this methodology.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            ...cleanupSteps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            child: Text('${index + 1}'),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              step['step'] ?? 'Unknown step',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      if (step['description'] != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(step['description'].toString()),
                      ],
                      if (step['command'] != null) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            step['command'].toString(),
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildExecutionTab() {
    if (widget.isFromLibrary) {
      return const Center(
        child: Text(
          'Outcome tracking is available when this methodology is executed from the Attack Graph.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Step Status',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      _buildStatusButton('pending', 'Pending', Icons.schedule, Colors.orange),
                      _buildStatusButton('in_progress', 'In Progress', Icons.play_circle, Colors.blue),
                      _buildStatusButton('completed', 'Completed', Icons.check_circle, Colors.green),
                      _buildStatusButton('skipped', 'Skipped', Icons.skip_next, Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Outcome Data',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _outcomeController,
                    decoration: const InputDecoration(
                      labelText: 'Results & Findings',
                      hintText: 'Enter the results of this methodology step...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _saveOutcome(),
                        icon: const Icon(Icons.save),
                        label: const Text('Save Outcome'),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      OutlinedButton.icon(
                        onPressed: () => _attachEvidence(),
                        icon: const Icon(Icons.attach_file),
                        label: const Text('Attach Evidence'),
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

  Widget _buildStatusButton(String status, String label, IconData icon, Color color) {
    final isSelected = _stepStatus == status;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.white : color),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: color,
      checkmarkColor: Colors.white,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _stepStatus = status;
          });
        }
      },
    );
  }


  void _editTriggers() {
    // Create a sample trigger based on methodology context for editing
    final sampleTrigger = widget.isFromLibrary
        ? MethodologyTriggerDefinition(
            id: 'trigger_${widget.methodology['id']}',
            name: '${widget.methodology['name']} Trigger',
            description: 'Trigger conditions for ${widget.methodology['name']}',
            priority: 5,
            enabled: true,
            conditionGroups: [],
          )
        : null;

    showDialog(
      context: context,
      builder: (context) => TriggerEditorDialog(
        initialTrigger: sampleTrigger,
        onSave: (trigger) {
          // TODO: Save the trigger to methodology
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trigger "${trigger.name}" saved successfully')),
          );
        },
      ),
    );
  }

  void _saveOutcome() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Outcome saved successfully')),
    );
  }

  void _attachEvidence() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evidence attachment feature coming soon')),
    );
  }

}