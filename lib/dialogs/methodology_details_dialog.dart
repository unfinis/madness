import 'package:flutter/material.dart';
import '../services/methodology_loader.dart' as loader;
import '../constants/app_spacing.dart';

class MethodologyDetailsDialog extends StatefulWidget {
  final loader.MethodologyTemplate template;
  final bool canExecute;

  const MethodologyDetailsDialog({
    super.key,
    required this.template,
    this.canExecute = false,
  });

  @override
  State<MethodologyDetailsDialog> createState() => _MethodologyDetailsDialogState();
}

class _MethodologyDetailsDialogState extends State<MethodologyDetailsDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 900,
        height: 700,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.template.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.template.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      _buildInfoChip(
                        'Version: ${widget.template.version}',
                        Icons.history,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildInfoChip(
                        'Author: ${widget.template.author}',
                        Icons.person,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _buildInfoChip(
                        'Risk: ${widget.template.riskLevel}',
                        Icons.warning,
                        _getRiskColor(widget.template.riskLevel),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Triggers'),
                Tab(text: 'Procedures'),
                Tab(text: 'Findings'),
                Tab(text: 'Cleanup'),
                Tab(text: 'Troubleshooting'),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildTriggersTab(),
                  _buildProceduresTab(),
                  _buildFindingsTab(),
                  _buildCleanupTab(),
                  _buildTroubleshootingTab(),
                ],
              ),
            ),

            // Actions
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
                  ),
                  if (widget.canExecute) ...[
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // TODO: Execute methodology
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Execute'),
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

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _buildSection(
          'Purpose',
          widget.template.overview.purpose,
          Icons.gps_fixed,
        ),
        _buildSection(
          'Scope',
          widget.template.overview.scope,
          Icons.crop_free,
        ),
        _buildSection(
          'Prerequisites',
          widget.template.overview.prerequisites.join('\n'),
          Icons.checklist,
        ),
        if (widget.template.equipment.isNotEmpty)
          _buildSection(
            'Required Equipment',
            widget.template.equipment.join('\n'),
            Icons.construction,
          ),
        _buildSection(
          'Tags',
          widget.template.tags.join(', '),
          Icons.label,
        ),
      ],
    );
  }

  Widget _buildTriggersTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: widget.template.triggers.length,
      itemBuilder: (context, index) {
        final trigger = widget.template.triggers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        trigger.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                if (trigger.description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    trigger.description,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Conditions: ${_formatConditions(trigger.conditions)}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProceduresTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: widget.template.procedures.length,
      itemBuilder: (context, index) {
        final procedure = widget.template.procedures[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: ExpansionTile(
            title: Text(procedure.name),
            subtitle: Text(procedure.description),
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Commands:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ...procedure.commands.map((cmd) => Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        cmd.command,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFindingsTab() {
    if (widget.template.findings.isEmpty) {
      return const Center(
        child: Text('No findings defined'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: widget.template.findings.length,
      itemBuilder: (context, index) {
        final finding = widget.template.findings[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildSeverityBadge(finding.severity),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        finding.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(finding.description),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommendation:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        finding.recommendation,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCleanupTab() {
    if (widget.template.cleanup.isEmpty) {
      return const Center(
        child: Text('No cleanup steps defined'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: widget.template.cleanup.length,
      itemBuilder: (context, index) {
        final cleanup = widget.template.cleanup[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cleanup.description,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cleanup.command,
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTroubleshootingTab() {
    if (widget.template.troubleshooting.isEmpty) {
      return const Center(
        child: Text('No troubleshooting information'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: widget.template.troubleshooting.length,
      itemBuilder: (context, index) {
        final trouble = widget.template.troubleshooting[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.error_outline, size: 20, color: Colors.orange),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'Issue: ${trouble.issue}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 20, color: Colors.green),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text('Solution: ${trouble.solution}'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(content),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon, [Color? color]) {
    return Chip(
      label: Text(
        text,
        style: TextStyle(fontSize: 12, color: color),
      ),
      avatar: Icon(icon, size: 14, color: color),
      backgroundColor: (color ?? Colors.grey).withValues(alpha: 0.1),
    );
  }

  Widget _buildSeverityBadge(String severity) {
    Color color;
    switch (severity) {
      case 'info':
        color = Colors.blue;
        break;
      case 'low':
        color = Colors.green;
        break;
      case 'medium':
        color = Colors.orange;
        break;
      case 'high':
        color = Colors.red;
        break;
      case 'critical':
        color = Colors.purple;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        severity.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatConditions(dynamic conditions) {
    if (conditions == null) return 'None';
    if (conditions is Map) {
      return conditions.toString();
    }
    return conditions.toString();
  }
}