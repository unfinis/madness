import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/attack_plan_action.dart';
import '../constants/app_spacing.dart';

class AttackPlanActionDetailDialog extends StatefulWidget {
  final AttackPlanAction action;

  const AttackPlanActionDetailDialog({
    super.key,
    required this.action,
  });

  @override
  State<AttackPlanActionDetailDialog> createState() => _AttackPlanActionDetailDialogState();
}

class _AttackPlanActionDetailDialogState extends State<AttackPlanActionDetailDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
                      widget.action.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    widget.action.id,
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
                      color: _getStatusColor(widget.action.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.action.status.displayName,
                      style: TextStyle(
                        color: _getStatusColor(widget.action.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(widget.action.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      widget.action.priority.displayName,
                      style: TextStyle(
                        color: _getPriorityColor(widget.action.priority),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: _handleStartExecution,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(_getActionButtonText()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and ID (already in header, but could show more details)
          Text(
            'Objective',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.action.objective,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Status and priority
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Status',
                  widget.action.status.displayName,
                  icon: Icons.info,
                  color: _getStatusColor(widget.action.status),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildInfoCard(
                  'Priority',
                  widget.action.priority.displayName,
                  icon: Icons.flag,
                  color: _getPriorityColor(widget.action.priority),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Risk Level',
                  widget.action.riskLevel.displayName,
                  icon: Icons.warning,
                  color: _getRiskColor(widget.action.riskLevel),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _buildInfoCard(
                  'Triggers',
                  '${widget.action.triggerEvents.length} event(s)',
                  icon: Icons.flash_on,
                  color: Colors.orange,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Tags
          if (widget.action.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: widget.action.tags.map((tag) => Chip(
                label: Text(tag),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              )).toList(),
            ),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Metadata
          if (widget.action.metadata.isNotEmpty) ...[
            Text(
              'Metadata',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...widget.action.metadata.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: Text(entry.value.toString()),
                  ),
                ],
              ),
            )),
          ],
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
          // Risk level
          Row(
            children: [
              Icon(Icons.warning, color: _getRiskColor(widget.action.riskLevel)),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Risk Level: ${widget.action.riskLevel.displayName}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: _getRiskColor(widget.action.riskLevel),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Risks and mitigation
          if (widget.action.risks.isNotEmpty) ...[
            Text(
              'Risks and Mitigation',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            ...widget.action.risks.asMap().entries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          size: 16,
                          color: _getRiskColor(entry.value.severity),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: Text(
                            'Risk: ${entry.value.risk}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Mitigation: ${entry.value.mitigation}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            )),
            const SizedBox(height: AppSpacing.xl),
          ],

          // Procedure steps
          Text(
            'Procedure',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (widget.action.procedure.isEmpty)
            const Text('No procedure steps defined yet.')
          else
            ...widget.action.procedure.asMap().entries.map((entry) => Card(
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
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            entry.value.stepNumber.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            entry.value.description,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        if (!entry.value.mandatory)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Optional',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),

                    if (entry.value.command != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.value.command!,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: entry.value.command!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Command copied to clipboard')),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],

                    if (entry.value.expectedOutput != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Expected Output:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        entry.value.expectedOutput!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],

                    if (entry.value.notes != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info, size: 16, color: Colors.blue[600]),
                            const SizedBox(width: AppSpacing.xs),
                            Expanded(
                              child: Text(
                                entry.value.notes!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )),
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
          // Tools
          Text(
            'Tools',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (widget.action.tools.isEmpty)
            const Text('No tools specified.')
          else
            ...widget.action.tools.map((tool) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: Icon(
                  tool.required ? Icons.build : Icons.build_outlined,
                  color: tool.required ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  tool.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tool.description),
                    if (tool.installation != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Install: ${tool.installation}',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    if (tool.alternatives.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Alternatives: ${tool.alternatives.join(', ')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: tool.required
                  ? const Chip(
                      label: Text('Required'),
                      backgroundColor: Colors.orange,
                      labelStyle: TextStyle(color: Colors.white),
                    )
                  : const Chip(
                      label: Text('Optional'),
                      backgroundColor: Colors.grey,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
              ),
            )),

          const SizedBox(height: AppSpacing.xl),

          // Equipment
          Text(
            'Equipment',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (widget.action.equipment.isEmpty)
            const Text('No special equipment required.')
          else
            ...widget.action.equipment.map((equipment) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: Icon(
                  equipment.required ? Icons.hardware : Icons.hardware_outlined,
                  color: equipment.required ? Colors.orange : Colors.grey,
                ),
                title: Text(
                  equipment.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(equipment.description),
                    if (equipment.specifications != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Specifications: ${equipment.specifications}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
                trailing: equipment.required
                  ? const Chip(
                      label: Text('Required'),
                      backgroundColor: Colors.orange,
                      labelStyle: TextStyle(color: Colors.white),
                    )
                  : const Chip(
                      label: Text('Optional'),
                      backgroundColor: Colors.grey,
                      labelStyle: TextStyle(color: Colors.white),
                    ),
              ),
            )),

          const SizedBox(height: AppSpacing.xl),

          // References
          Text(
            'References',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          if (widget.action.references.isEmpty)
            const Text('No references provided.')
          else
            ...widget.action.references.map((reference) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: Icon(_getReferenceIcon(reference.type)),
                title: Text(
                  reference.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (reference.description != null)
                      Text(reference.description!),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      reference.url,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[600],
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                trailing: Chip(
                  label: Text(reference.type),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: TextStyle(color: Colors.blue[600]),
                ),
                onTap: () {
                  // TODO: Open URL
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening ${reference.url}')),
                  );
                },
              ),
            )),
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
          Row(
            children: [
              Text(
                'Trigger Events',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              if (widget.action.triggerEvents.length > 1) ...[
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Consolidated (${widget.action.triggerEvents.length} triggers)',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.action.triggerEvents.length > 1
                ? 'This action consolidates ${widget.action.triggerEvents.length} trigger events from different assets or conditions:'
                : 'This action was generated based on the following trigger event and asset conditions:',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (widget.action.triggerEvents.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text('No trigger events recorded.'),
              ),
            )
          else
            ...widget.action.triggerEvents.asMap().entries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.orange,
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Trigger: ${entry.value.triggerId}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(entry.value.confidence * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Asset info
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Asset: ${entry.value.assetName}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Row(
                            children: [
                              Text(
                                'Type: ${entry.value.assetType}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Text(
                                'ID: ${entry.value.assetId}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'monospace',
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Matched conditions
                    if (entry.value.matchedConditions.isNotEmpty) ...[
                      Text(
                        'Matched Conditions:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...entry.value.matchedConditions.entries.map((condition) => Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Text(
                              '${condition.key}: ',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Text(condition.value.toString()),
                            ),
                          ],
                        ),
                      )),
                    ],

                    // Extracted values
                    if (entry.value.extractedValues.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Extracted Values:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      ...entry.value.extractedValues.entries.map((extracted) => Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Text(
                              '${extracted.key}: ',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                              child: Text(
                                extracted.value.toString(),
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      'Evaluated: ${_formatDateTime(entry.value.evaluatedAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            )),
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
          Text(
            'Suggested Findings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Potential findings that may be discovered when executing this action:',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (widget.action.suggestedFindings.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text('No suggested findings defined.'),
              ),
            )
          else
            ...widget.action.suggestedFindings.map((finding) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.bug_report,
                          color: _getRiskColor(finding.severity),
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            finding.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getRiskColor(finding.severity).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            finding.severity.displayName,
                            style: TextStyle(
                              color: _getRiskColor(finding.severity),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      finding.description,
                      style: const TextStyle(fontSize: 14),
                    ),

                    if (finding.cvssScore != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          const Icon(Icons.assessment, size: 16),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            'CVSS Score: ${finding.cvssScore!.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (finding.category != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Chip(
                        label: Text(finding.category!),
                        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ],
                ),
              ),
            )),
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
          Row(
            children: [
              Icon(Icons.cleaning_services, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Cleanup Steps',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Steps required to clean up after executing this action:',
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: AppSpacing.lg),

          if (widget.action.cleanupSteps.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text('No cleanup steps required.'),
              ),
            )
          else
            ...widget.action.cleanupSteps.asMap().entries.map((entry) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.orange,
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            )),

          const SizedBox(height: AppSpacing.xl),

          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Important: Ensure all cleanup steps are completed to avoid leaving traces or causing issues for the client.',
                    style: TextStyle(
                      color: Colors.orange[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionTab() {
    final execution = widget.action.execution;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.play_circle, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Execution Tracking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _handleStartExecution,
                icon: const Icon(Icons.play_arrow),
                label: Text(_getActionButtonText()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          if (execution == null) ...[
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Icon(Icons.schedule, size: 48, color: Colors.grey),
                    SizedBox(height: AppSpacing.md),
                    Text(
                      'Not started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Click "Start Execution" to begin tracking execution of this action.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Execution info
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    'Started',
                    execution.startedAt != null ? _formatDateTime(execution.startedAt!) : 'Not started',
                    icon: Icons.play_arrow,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildInfoCard(
                    'Completed',
                    execution.completedAt != null ? _formatDateTime(execution.completedAt!) : 'In progress',
                    icon: Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.md),

            if (execution.executedBy != null)
              _buildInfoCard(
                'Executed By',
                execution.executedBy!,
                icon: Icons.person,
                color: Colors.purple,
              ),

            const SizedBox(height: AppSpacing.xl),

            // Commands executed
            if (execution.executedCommands.isNotEmpty) ...[
              Text(
                'Executed Commands',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...execution.executedCommands.asMap().entries.map((entry) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Row(
                    children: [
                      Text('${entry.key + 1}.'),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(fontFamily: 'monospace'),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Captured outputs
            if (execution.capturedOutputs.isNotEmpty) ...[
              Text(
                'Captured Outputs',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...execution.capturedOutputs.asMap().entries.map((entry) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Output ${entry.key + 1}:',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Notes
            if (execution.executionNotes != null) ...[
              Text(
                'Execution Notes',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Text(execution.executionNotes!),
                ),
              ),
            ],

            // Add execution controls
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _handleIngestOutput,
                    icon: const Icon(Icons.upload),
                    label: const Text('Ingest Output'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _handleAddEvidence,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Add Evidence'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, {required IconData icon, required Color color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ActionStatus status) {
    switch (status) {
      case ActionStatus.pending:
        return Colors.orange;
      case ActionStatus.inProgress:
        return Colors.blue;
      case ActionStatus.completed:
        return Colors.green;
      case ActionStatus.blocked:
        return Colors.red;
      case ActionStatus.skipped:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(ActionPriority priority) {
    switch (priority) {
      case ActionPriority.critical:
        return Colors.red;
      case ActionPriority.high:
        return Colors.orange;
      case ActionPriority.medium:
        return Colors.blue;
      case ActionPriority.low:
        return Colors.green;
    }
  }

  Color _getRiskColor(ActionRiskLevel risk) {
    switch (risk) {
      case ActionRiskLevel.minimal:
        return Colors.green;
      case ActionRiskLevel.low:
        return Colors.lightGreen;
      case ActionRiskLevel.medium:
        return Colors.orange;
      case ActionRiskLevel.high:
        return Colors.deepOrange;
      case ActionRiskLevel.critical:
        return Colors.red;
    }
  }

  IconData _getReferenceIcon(String type) {
    switch (type.toLowerCase()) {
      case 'documentation':
        return Icons.description;
      case 'blog':
        return Icons.article;
      case 'paper':
        return Icons.school;
      case 'video':
        return Icons.video_library;
      case 'tool':
        return Icons.build;
      default:
        return Icons.link;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _getActionButtonText() {
    switch (widget.action.status) {
      case ActionStatus.pending:
        return 'Start Execution';
      case ActionStatus.inProgress:
        return 'Continue';
      case ActionStatus.completed:
        return 'View Results';
      case ActionStatus.blocked:
        return 'Resolve';
      case ActionStatus.skipped:
        return 'Re-enable';
    }
  }

  void _handleStartExecution() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Execution tracking coming soon...')),
    );
  }

  void _handleIngestOutput() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Output ingestion coming soon...')),
    );
  }

  void _handleAddEvidence() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evidence management coming soon...')),
    );
  }
}