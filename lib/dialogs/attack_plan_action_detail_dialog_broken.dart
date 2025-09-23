import 'package:flutter/material.dart';
import '../models/attack_plan_action.dart';
import '../constants/app_spacing.dart';
import 'shared/base_detail_dialog.dart';

class AttackPlanActionDetailDialog extends BaseDetailDialog {
  final AttackPlanAction action;

  const AttackPlanActionDetailDialog({
    super.key,
    required this.action,
  });

  @override
  State<AttackPlanActionDetailDialog> createState() => _AttackPlanActionDetailDialogState();
}

class _AttackPlanActionDetailDialogState extends BaseDetailDialogState<AttackPlanActionDetailDialog> {

  @override
  int getTabCount() => 7;

  @override
  String getTitle() => widget.action.title ?? 'Attack Plan Action';

  @override
  String getSubtitle() => 'ID: ${widget.action.id}';

  @override
  Color getHeaderColor() => Theme.of(context).primaryColor;

  @override
  List<Tab> getTabs() => const [
    Tab(text: 'Overview'),
    Tab(text: 'Procedure'),
    Tab(text: 'Tools & References'),
    Tab(text: 'Trigger Context'),
    Tab(text: 'Findings'),
    Tab(text: 'Cleanup'),
    Tab(text: 'Execution'),
  ];

  @override
  List<Widget> getTabViews() => [
    _buildOverviewTab(),
    _buildProcedureTab(),
    _buildToolsReferencesTab(),
    _buildTriggerContextTab(),
    _buildFindingsTab(),
    _buildCleanupTab(),
    _buildExecutionTab(),
  ];

  @override
  List<Widget> getStatusBadges() => [
    buildStatusChip(widget.action.status.displayName),
    const SizedBox(width: AppSpacing.sm),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Text(
        'ID: ${widget.action.id}',
        style: TextStyle(
          color: Colors.blue,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ];

  @override
  List<Widget> getActionButtons() => [
    if (widget.action.status == 'pending') ...[
      ElevatedButton.icon(
        onPressed: _executeAction,
        icon: const Icon(Icons.play_arrow, size: 16),
        label: const Text('Execute'),
      ),
      const SizedBox(width: AppSpacing.sm),
    ],
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Close'),
    ),
  ];

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildInfoCard(
            'Action Summary',
            widget.action.objective,
            icon: Icons.info,
          ),
          const SizedBox(height: AppSpacing.lg),
          buildInfoCard(
            'Methodology',
            widget.action.methodologyId ?? 'Unknown',
            icon: Icons.library_books,
          ),
          const SizedBox(height: AppSpacing.lg),
          buildInfoCard(
            'Priority Level',
            widget.action.priority?.toString() ?? 'Not set',
            icon: Icons.priority_high,
          ),
          const SizedBox(height: AppSpacing.lg),
          if (widget.action.estimatedDuration != null)
            buildInfoCard(
              'Estimated Duration',
              widget.action.estimatedDuration!,
              icon: Icons.schedule,
            ),
        ],
      ),
    );
  }

  Widget _buildProcedureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            'Execution Steps',
            Icons.list_alt,
            widget.action.steps?.isNotEmpty == true
                ? Column(
                    children: widget.action.steps!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                            child: Text('${index + 1}'),
                          ),
                          title: Text(step.name ?? 'Step ${index + 1}'),
                          subtitle: step.description != null
                              ? Text(step.description!)
                              : null,
                          trailing: buildStatusChip(step.status ?? 'pending'),
                        ),
                      );
                    }).toList(),
                  )
                : buildEmptyState('No execution steps defined'),
          ),
          if (widget.action.commands?.isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.lg),
            buildSection(
              'Commands',
              Icons.terminal,
              Column(
                children: widget.action.commands!.map((command) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: buildCodeBlock(command, language: 'bash'),
                  ),
                ).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToolsReferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            'Required Tools',
            Icons.build,
            widget.action.requiredTools?.isNotEmpty == true
                ? Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.action.requiredTools!.map((tool) =>
                      Chip(
                        label: Text(tool),
                        backgroundColor: Colors.blue.withOpacity(0.1),
                      ),
                    ).toList(),
                  )
                : buildEmptyState('No specific tools required'),
          ),
          const SizedBox(height: AppSpacing.lg),
          buildSection(
            'References',
            Icons.link,
            widget.action.references?.isNotEmpty == true
                ? Column(
                    children: widget.action.references!.map((ref) =>
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: const Icon(Icons.link),
                          title: Text(ref['title'] ?? 'Reference'),
                          subtitle: ref['url'] != null ? Text(ref['url']) : null,
                          trailing: const Icon(Icons.open_in_new),
                          onTap: () {
                            // TODO: Open URL
                          },
                        ),
                      ),
                    ).toList(),
                  )
                : buildEmptyState('No external references'),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerContextTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            'Trigger Conditions',
            Icons.gps_fixed,
            widget.action.triggerConditions?.isNotEmpty == true
                ? Column(
                    children: widget.action.triggerConditions!.entries.map((entry) =>
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(entry.key),
                          subtitle: Text(entry.value.toString()),
                          leading: const Icon(Icons.check_circle_outline),
                        ),
                      ),
                    ).toList(),
                  )
                : buildEmptyState('No trigger conditions specified'),
          ),
          const SizedBox(height: AppSpacing.lg),
          buildSection(
            'Asset Context',
            Icons.inventory,
            widget.action.targetAssets?.isNotEmpty == true
                ? Column(
                    children: widget.action.targetAssets!.map((asset) =>
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(asset['name'] ?? 'Asset'),
                          subtitle: Text(asset['type'] ?? 'Unknown type'),
                          leading: const Icon(Icons.device_hub),
                        ),
                      ),
                    ).toList(),
                  )
                : buildEmptyState('No target assets specified'),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            'Expected Findings',
            Icons.search,
            widget.action.expectedFindings?.isNotEmpty == true
                ? Column(
                    children: widget.action.expectedFindings!.map((finding) =>
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                finding['type'] ?? 'Finding',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (finding['description'] != null) ...[
                                const SizedBox(height: 4),
                                Text(finding['description']),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ).toList(),
                  )
                : buildEmptyState('No expected findings documented'),
          ),
          const SizedBox(height: AppSpacing.lg),
          buildSection(
            'Actual Results',
            Icons.analytics,
            widget.action.results?.isNotEmpty == true
                ? Column(
                    children: widget.action.results!.map((result) =>
                      buildCodeBlock(result.toString(), language: 'output'),
                    ).toList(),
                  )
                : buildEmptyState('No results available yet'),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanupTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            'Cleanup Steps',
            Icons.cleaning_services,
            widget.action.cleanupSteps?.isNotEmpty == true
                ? Column(
                    children: widget.action.cleanupSteps!.asMap().entries.map((entry) {
                      final index = entry.key;
                      final step = entry.value;
                      return Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.orange.withOpacity(0.2),
                            child: Text('${index + 1}'),
                          ),
                          title: Text(step),
                          leading: const Icon(Icons.clear),
                        ),
                      );
                    }).toList(),
                  )
                : buildEmptyState('No cleanup steps required'),
          ),
          const SizedBox(height: AppSpacing.lg),
          buildSection(
            'Artifact Removal',
            Icons.delete_sweep,
            widget.action.artifactsToRemove?.isNotEmpty == true
                ? Column(
                    children: widget.action.artifactsToRemove!.map((artifact) =>
                      Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: ListTile(
                          title: Text(artifact),
                          leading: const Icon(Icons.delete_outline),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // TODO: Remove artifact
                            },
                          ),
                        ),
                      ),
                    ).toList(),
                  )
                : buildEmptyState('No artifacts to remove'),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSection(
            'Execution Status',
            Icons.play_arrow,
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Status: '),
                        buildStatusChip(widget.action.status),
                      ],
                    ),
                    if (widget.action.startTime != null) ...[
                      const SizedBox(height: 8),
                      Text('Started: ${widget.action.startTime}'),
                    ],
                    if (widget.action.endTime != null) ...[
                      const SizedBox(height: 8),
                      Text('Completed: ${widget.action.endTime}'),
                    ],
                    if (widget.action.duration != null) ...[
                      const SizedBox(height: 8),
                      Text('Duration: ${widget.action.duration}'),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          buildSection(
            'Output Log',
            Icons.terminal,
            widget.action.output?.isNotEmpty == true
                ? buildCodeBlock(widget.action.output!, language: 'log')
                : buildEmptyState('No execution output available'),
          ),
          const SizedBox(height: AppSpacing.lg),
          buildSection(
            'Actions',
            Icons.settings,
            Row(
              children: [
                if (widget.action.status == 'pending')
                  ElevatedButton.icon(
                    onPressed: _executeAction,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Execute Action'),
                  ),
                if (widget.action.status == 'in_progress')
                  ElevatedButton.icon(
                    onPressed: _stopAction,
                    icon: const Icon(Icons.stop),
                    label: const Text('Stop Execution'),
                  ),
                if (widget.action.status == 'completed')
                  ElevatedButton.icon(
                    onPressed: _restartAction,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Re-execute'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _executeAction() {
    // TODO: Implement action execution
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Executing: ${widget.action.title}')),
    );
  }

  void _stopAction() {
    // TODO: Implement action stopping
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Stopping execution...')),
    );
  }

  void _restartAction() {
    // TODO: Implement action restart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Re-executing: ${widget.action.title}')),
    );
  }
}