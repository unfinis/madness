import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology_detail.dart';
import '../models/methodology_trigger.dart';
import '../services/methodology_loader.dart' as loader;
import '../constants/app_spacing.dart';

class MethodologyTemplateEditorDialog extends ConsumerStatefulWidget {
  final MethodologyDetail? methodology;
  final loader.MethodologyTemplate? jsonMethodology;
  final bool isEditMode;
  final Function(MethodologyDetail)? onSave;

  const MethodologyTemplateEditorDialog({
    super.key,
    this.methodology,
    this.jsonMethodology,
    this.isEditMode = true,
    this.onSave,
  });

  @override
  ConsumerState<MethodologyTemplateEditorDialog> createState() =>
      _MethodologyTemplateEditorDialogState();
}

class _MethodologyTemplateEditorDialogState
    extends ConsumerState<MethodologyTemplateEditorDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late MethodologyDetail _currentMethodology;
  final List<MethodologyTrigger> _triggers = [];
  final List<String> _tags = [];
  String _riskLevel = 'medium';
  final List<String> _equipment = [];
  final List<Map<String, String>> _risksAndMitigations = [];
  final List<Map<String, String>> _troubleshootingSteps = [];

  final List<_MethodologyTab> _tabs = [
    _MethodologyTab(
      name: 'Overview',
      icon: Icons.info_outline,
    ),
    _MethodologyTab(
      name: 'Triggers',
      icon: Icons.flash_on,
    ),
    _MethodologyTab(
      name: 'Procedures',
      icon: Icons.list_alt,
    ),
    _MethodologyTab(
      name: 'Tools & Refs',
      icon: Icons.build,
    ),
    _MethodologyTab(
      name: 'Findings',
      icon: Icons.bug_report,
    ),
    _MethodologyTab(
      name: 'Cleanup',
      icon: Icons.cleaning_services,
    ),
    _MethodologyTab(
      name: 'Troubleshooting',
      icon: Icons.help_outline,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    if (widget.jsonMethodology != null) {
      // Initialize from JSON methodology
      _currentMethodology = _convertFromJsonMethodology(widget.jsonMethodology!);
      _initializeFromJsonMethodology(widget.jsonMethodology!);
    } else {
      _currentMethodology = widget.methodology ?? _createEmptyMethodology();

      // Initialize tags from metadata
      if (_currentMethodology.metadata['tags'] is List) {
        _tags.addAll((_currentMethodology.metadata['tags'] as List).cast<String>());
      }
      if (_currentMethodology.metadata['risk_level'] is String) {
        _riskLevel = _currentMethodology.metadata['risk_level'] as String;
      }
    }
  }

  void _initializeFromJsonMethodology(loader.MethodologyTemplate template) {
    // Initialize tags
    _tags.addAll(template.tags);

    // Initialize risk level
    _riskLevel = template.riskLevel;

    // Initialize equipment
    _equipment.addAll(template.equipment);

    // Initialize triggers (simplified for now)
    // TODO: Fix trigger model mapping
    // for (final trigger in template.triggers) {
    //   _triggers.add(...);
    // }

    // Initialize risks and mitigations from procedures
    for (final procedure in template.procedures) {
      for (final risk in procedure.risks) {
        _risksAndMitigations.add({
          'risk': risk.risk,
          'mitigation': risk.mitigation,
        });
      }
    }

    // Initialize troubleshooting
    for (final trouble in template.troubleshooting) {
      _troubleshootingSteps.add({
        'issue': trouble.issue,
        'solution': trouble.solution,
      });
    }
  }

  MethodologyDetail _convertFromJsonMethodology(loader.MethodologyTemplate template) {
    return MethodologyDetail(
      id: template.id,
      title: template.name,
      uniqueId: template.id,
      overview: template.description,
      purpose: template.overview.purpose,
      commands: [],
      cleanupSteps: [],
      commonIssues: [],
      relatedFindings: [],
      metadata: {
        'tags': template.tags,
        'risk_level': template.riskLevel,
        'version': template.version,
        'author': template.author,
        'workstream': template.workstream,
        'status': template.status,
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  MethodologyDetail _createEmptyMethodology() {
    return const MethodologyDetail(
      id: '',
      title: 'New Methodology',
      uniqueId: '',
      overview: '',
      purpose: '',
      commands: [],
      cleanupSteps: [],
      commonIssues: [],
      relatedFindings: [],
      metadata: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreen = MediaQuery.of(context).size.width > 1200;

    return Dialog(
      insetPadding: isFullScreen
          ? const EdgeInsets.all(40)
          : const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isFullScreen ? 1200 : double.infinity,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _buildTabBarView(),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.library_books,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditMode ? 'Edit Methodology Template' : 'View Methodology Template',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentMethodology.title.isNotEmpty
                      ? _currentMethodology.title
                      : 'New Methodology',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          if (_currentMethodology.uniqueId.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _currentMethodology.uniqueId,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelColor: Theme.of(context).primaryColor,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: _tabs.map((tab) => Tab(
          icon: Icon(tab.icon, size: 20),
          text: tab.name,
        )).toList(),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(),
        _buildTriggersTab(),
        _buildProceduresTab(),
        _buildToolsReferencesTab(),
        _buildFindingsTab(),
        _buildCleanupTab(),
        _buildTroubleshootingTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Basic Information'),
          const SizedBox(height: AppSpacing.md),

          // Title and ID Row
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  initialValue: _currentMethodology.title,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.title),
                  ),
                  enabled: widget.isEditMode,
                  onChanged: (value) {
                    setState(() {
                      _currentMethodology = _currentMethodology.copyWith(title: value);
                    });
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: TextFormField(
                  initialValue: _currentMethodology.uniqueId,
                  decoration: const InputDecoration(
                    labelText: 'ID',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.tag),
                  ),
                  enabled: widget.isEditMode,
                  onChanged: (value) {
                    setState(() {
                      _currentMethodology = _currentMethodology.copyWith(uniqueId: value);
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Objective/Overview
          TextFormField(
            initialValue: _currentMethodology.overview,
            decoration: const InputDecoration(
              labelText: 'Objective',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.flag),
            ),
            enabled: widget.isEditMode,
            maxLines: 3,
            onChanged: (value) {
              setState(() {
                _currentMethodology = _currentMethodology.copyWith(overview: value);
              });
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Purpose/Description
          TextFormField(
            initialValue: _currentMethodology.purpose,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
            enabled: widget.isEditMode,
            maxLines: 5,
            onChanged: (value) {
              setState(() {
                _currentMethodology = _currentMethodology.copyWith(purpose: value);
              });
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // Tags Section
          _buildSectionHeader('Tags & Classification'),
          const SizedBox(height: AppSpacing.md),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTagsSection(),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _riskLevel,
                  decoration: const InputDecoration(
                    labelText: 'Risk Level',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.warning),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'low', child: Text('Low')),
                    DropdownMenuItem(value: 'medium', child: Text('Medium')),
                    DropdownMenuItem(value: 'high', child: Text('High')),
                    DropdownMenuItem(value: 'critical', child: Text('Critical')),
                  ],
                  onChanged: widget.isEditMode ? (value) {
                    setState(() {
                      _riskLevel = value ?? 'medium';
                    });
                  } : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Stats Section
          _buildStatsSection(),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Tags:', style: TextStyle(fontWeight: FontWeight.w600)),
            if (widget.isEditMode) ...[
              const Spacer(),
              IconButton(
                onPressed: _showAddTagDialog,
                icon: const Icon(Icons.add),
                tooltip: 'Add Tag',
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _tags.isEmpty
              ? Text(
                  'No tags added',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                )
              : Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: _tags.map((tag) => _buildTagChip(tag)).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildTagChip(String tag) {
    return Chip(
      label: Text(tag),
      deleteIcon: widget.isEditMode ? const Icon(Icons.close, size: 16) : null,
      onDeleted: widget.isEditMode ? () {
        setState(() {
          _tags.remove(tag);
        });
      } : null,
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      side: BorderSide(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Template Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _buildStatChip('Triggers', _triggers.length, Icons.flash_on, Colors.orange),
              const SizedBox(width: AppSpacing.sm),
              _buildStatChip('Commands', _currentMethodology.commands.length, Icons.terminal, Colors.blue),
              const SizedBox(width: AppSpacing.sm),
              _buildStatChip('Cleanup', _currentMethodology.cleanupSteps.length, Icons.cleaning_services, Colors.green),
              const SizedBox(width: AppSpacing.sm),
              _buildStatChip('Findings', _currentMethodology.relatedFindings.length, Icons.bug_report, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggersTab() {
    return Column(
      children: [
        // JSON Methodology Triggers (if available)
        if (widget.jsonMethodology != null && widget.jsonMethodology!.triggers.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Theme.of(context).primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'JSON Methodology Triggers',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxHeight: 300),
            child: _buildJsonTriggersSection(),
          ),
        ],

        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.flash_on, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Trigger Conditions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: _addNewTrigger,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Trigger'),
                ),
            ],
          ),
        ),
        Expanded(
          child: _triggers.isEmpty
              ? _buildEmptyTriggersState()
              : _buildTriggersList(),
        ),
      ],
    );
  }

  Widget _buildEmptyTriggersState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flash_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Triggers Configured',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add trigger conditions to automatically activate this methodology',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isEditMode) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _addNewTrigger,
              icon: const Icon(Icons.add),
              label: const Text('Add First Trigger'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTriggersList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _triggers.length,
      itemBuilder: (context, index) {
        return _buildTriggerCard(_triggers[index], index);
      },
    );
  }

  Widget _buildTriggerCard(MethodologyTrigger trigger, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: trigger.enabled ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            trigger.enabled ? Icons.flash_on : Icons.flash_off,
            color: trigger.enabled ? Colors.green : Colors.grey,
          ),
        ),
        title: Text(
          trigger.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (trigger.description != null) ...[
              Text(trigger.description!),
              const SizedBox(height: 4),
            ],
            Row(
              children: [
                _buildTriggerBadge('Asset: ${trigger.assetType.name}', Colors.blue),
                const SizedBox(width: AppSpacing.sm),
                _buildTriggerBadge('Priority: ${trigger.priority}', Colors.orange),
                if (trigger.batchCapable) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _buildTriggerBadge('Batch', Colors.purple),
                ],
              ],
            ),
          ],
        ),
        trailing: widget.isEditMode
            ? PopupMenuButton<String>(
                onSelected: (action) => _handleTriggerAction(action, index),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'test', child: Text('Test')),
                  const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTriggerDetails(trigger),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTriggerDetails(MethodologyTrigger trigger) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Condition Logic:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            _formatTriggerCondition(trigger.conditions),
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        if (trigger.individualCommand != null) ...[
          Text(
            'Command Template:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              trigger.individualCommand!,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ],
    );
  }

  String _formatTriggerCondition(dynamic conditions) {
    // Simple formatting for now - would be enhanced with proper DSL parsing
    if (conditions is TriggerCondition) {
      return '${conditions.property} ${_operatorSymbol(conditions.operator)} ${conditions.value}';
    } else if (conditions is TriggerConditionGroup) {
      final conditionsStr = conditions.conditions
          .map((c) => _formatTriggerCondition(c))
          .join(' ${conditions.operator.name.toUpperCase()} ');
      return '($conditionsStr)';
    }
    return conditions.toString();
  }

  String _operatorSymbol(TriggerOperator op) {
    switch (op) {
      case TriggerOperator.equals:
        return '==';
      case TriggerOperator.notEquals:
        return '!=';
      case TriggerOperator.contains:
        return 'contains';
      case TriggerOperator.notContains:
        return '!contains';
      case TriggerOperator.exists:
        return 'exists';
      case TriggerOperator.notExists:
        return '!exists';
      case TriggerOperator.greaterThan:
        return '>';
      case TriggerOperator.lessThan:
        return '<';
      case TriggerOperator.inList:
        return 'in';
      case TriggerOperator.notInList:
        return '!in';
      case TriggerOperator.matches:
        return 'matches';
    }
  }

  Widget _buildProceduresTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Risk Rating Section
          _buildSectionHeader('Risk Rating', Icons.warning, 'Set the risk level for executing this methodology'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Level',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String>(
                  initialValue: _riskLevel,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Select risk level',
                  ),
                  items: [
                    DropdownMenuItem(value: 'low', child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        const Text('Low Risk'),
                      ],
                    )),
                    DropdownMenuItem(value: 'medium', child: Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        const Text('Medium Risk'),
                      ],
                    )),
                    DropdownMenuItem(value: 'high', child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        const Text('High Risk'),
                      ],
                    )),
                    DropdownMenuItem(value: 'critical', child: Row(
                      children: [
                        Icon(Icons.dangerous, color: Colors.red[800], size: 16),
                        const SizedBox(width: 8),
                        const Text('Critical Risk'),
                      ],
                    )),
                  ],
                  onChanged: widget.isEditMode ? (value) {
                    setState(() {
                      _riskLevel = value ?? 'medium';
                    });
                  } : null,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Risks and Mitigations Section
          _buildSectionHeader('Risks & Mitigations', Icons.security, 'Document potential risks and their mitigation steps'),
          const SizedBox(height: AppSpacing.sm),
          _buildRisksAndMitigationsSection(),

          const SizedBox(height: AppSpacing.lg),

          // JSON Methodology Procedures (if available)
          if (widget.jsonMethodology != null) ...[
            _buildSectionHeader('Methodology Procedures', Icons.list_alt, 'Procedures and commands from JSON methodology'),
            const SizedBox(height: AppSpacing.sm),
            _buildJsonProceduresSection(),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Commands Section
          _buildSectionHeader('Commands & Procedures', Icons.terminal, 'Step-by-step commands and procedures'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.terminal, color: Theme.of(context).primaryColor),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Commands',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (widget.isEditMode)
                        ElevatedButton.icon(
                          onPressed: _addNewCommand,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Command'),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: _currentMethodology.commands.isEmpty
                      ? _buildEmptyCommandsState()
                      : _buildCommandsList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJsonTriggersSection() {
    if (widget.jsonMethodology == null || widget.jsonMethodology!.triggers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: const Text('No triggers defined in methodology'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: widget.jsonMethodology!.triggers.length,
      itemBuilder: (context, index) {
        final trigger = widget.jsonMethodology!.triggers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      trigger.type == 'complex' ? Icons.settings : Icons.flash_on,
                      color: trigger.type == 'complex' ? Colors.orange : Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        trigger.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: trigger.type == 'complex' ? Colors.orange.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: trigger.type == 'complex' ? Colors.orange : Colors.blue,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        trigger.type.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: trigger.type == 'complex' ? Colors.orange[700] : Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  trigger.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (trigger.conditions != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Conditions:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trigger.conditions.toString(),
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (trigger.script != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.orange[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Script:',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          trigger.script!,
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJsonProceduresSection() {
    if (widget.jsonMethodology == null || widget.jsonMethodology!.procedures.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: const Text('No procedures defined in methodology'),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          for (final procedure in widget.jsonMethodology!.procedures) ...[
            ExpansionTile(
              title: Text(
                procedure.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                procedure.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              leading: Icon(
                Icons.play_arrow,
                color: _getRiskColor(procedure.riskLevel),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description
                      Text(
                        'Description:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(procedure.description),

                      // Risk Level
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Icon(
                            Icons.warning,
                            size: 16,
                            color: _getRiskColor(procedure.riskLevel),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Risk Level: ${procedure.riskLevel.toUpperCase()}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: _getRiskColor(procedure.riskLevel),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      // Commands
                      if (procedure.commands.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Commands:',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        for (final command in procedure.commands) ...[
                          Container(
                            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Theme.of(context).dividerColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.terminal, size: 16),
                                    const SizedBox(width: AppSpacing.sm),
                                    Text(
                                      command.tool,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (command.platforms != null)
                                      Wrap(
                                        spacing: 4,
                                        children: command.platforms!.map((platform) =>
                                          Chip(
                                            label: Text(platform),
                                            backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                            labelStyle: const TextStyle(fontSize: 10),
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          )
                                        ).toList(),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppSpacing.sm),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    command.command,
                                    style: const TextStyle(
                                      fontFamily: 'Courier',
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  command.description,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
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

  Widget _buildEmptyCommandsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.terminal,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Commands Defined',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add command procedures for this methodology',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isEditMode) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _addNewCommand,
              icon: const Icon(Icons.add),
              label: const Text('Add First Command'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCommandsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _currentMethodology.commands.length,
      itemBuilder: (context, index) {
        return _buildCommandCard(_currentMethodology.commands[index], index);
      },
    );
  }

  Widget _buildCommandCard(MethodologyCommand command, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getShellColor(command.defaultShell).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getShellIcon(command.defaultShell),
            color: _getShellColor(command.defaultShell),
          ),
        ),
        title: Text(
          command.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              command.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildTriggerBadge(command.defaultShell.displayName, _getShellColor(command.defaultShell)),
                const SizedBox(width: AppSpacing.sm),
                if (command.estimatedDuration != null)
                  _buildTriggerBadge('~${command.estimatedDuration!.inMinutes}m', Colors.grey),
              ],
            ),
          ],
        ),
        trailing: widget.isEditMode
            ? PopupMenuButton<String>(
                onSelected: (action) => _handleCommandAction(action, index),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                  const PopupMenuItem(value: 'test', child: Text('Test Syntax')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              )
            : null,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: _buildCommandDetails(command),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandDetails(MethodologyCommand command) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primary Command
        Text(
          'Primary Command:',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            command.primaryCommand,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
              color: Colors.green,
            ),
          ),
        ),

        // Variables
        if (command.variables.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Variables:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...command.variables.entries.map((entry) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '{${entry.key}}',
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(entry.value),
              ],
            ),
          )),
        ],

        // Prerequisites
        if (command.prerequisites.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            'Prerequisites:',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...command.prerequisites.map((prereq) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 14, color: Colors.orange),
                const SizedBox(width: AppSpacing.sm),
                Expanded(child: Text(prereq)),
              ],
            ),
          )),
        ],
      ],
    );
  }

  IconData _getShellIcon(ShellType shell) {
    switch (shell) {
      case ShellType.bash:
        return Icons.terminal;
      case ShellType.powershell:
        return Icons.code;
      case ShellType.cmd:
        return Icons.computer;
      case ShellType.python:
        return Icons.integration_instructions;
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
        return Colors.amber;
      case ShellType.ruby:
        return Colors.red;
      case ShellType.nodejs:
        return Colors.lightGreen;
    }
  }

  Widget _buildToolsReferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Equipment Section
          _buildSectionHeader('Equipment', Icons.hardware, 'Hardware and physical equipment required'),
          const SizedBox(height: AppSpacing.sm),
          _buildEquipmentSection(),

          const SizedBox(height: AppSpacing.lg),

          // Software Tools Section
          _buildSectionHeader('Required Tools', Icons.build, 'Software tools and utilities needed'),
          const SizedBox(height: AppSpacing.md),
          _buildToolsSection(),

          const SizedBox(height: AppSpacing.lg),

          // References Section
          _buildSectionHeader('References & Documentation', Icons.link, 'Relevant documentation and references'),
          const SizedBox(height: AppSpacing.md),
          _buildPlaceholderSection('References and documentation links will be listed here'),
        ],
      ),
    );
  }

  Widget _buildFindingsTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.bug_report, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Finding Templates',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: _addNewFinding,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Finding'),
                ),
            ],
          ),
        ),
        Expanded(
          child: _currentMethodology.relatedFindings.isEmpty
              ? _buildEmptyFindingsState()
              : _buildFindingsList(),
        ),
      ],
    );
  }

  Widget _buildEmptyFindingsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Finding Templates',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add finding templates that can be auto-generated from this methodology',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isEditMode) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _addNewFinding,
              icon: const Icon(Icons.add),
              label: const Text('Add Finding Template'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFindingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _currentMethodology.relatedFindings.length,
      itemBuilder: (context, index) {
        return _buildFindingCard(_currentMethodology.relatedFindings[index]);
      },
    );
  }

  Widget _buildFindingCard(RelatedFinding finding) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getSeverityColor(finding.severity).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.bug_report,
            color: _getSeverityColor(finding.severity),
          ),
        ),
        title: Text(finding.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              finding.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildTriggerBadge(finding.severity.displayName, _getSeverityColor(finding.severity)),
                if (finding.cveId != null) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _buildTriggerBadge(finding.cveId!, Colors.red),
                ],
              ],
            ),
          ],
        ),
        trailing: widget.isEditMode
            ? IconButton(
                onPressed: () => _editFinding(finding),
                icon: const Icon(Icons.edit),
              )
            : null,
      ),
    );
  }

  Color _getSeverityColor(FindingSeverity severity) {
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

  Widget _buildCleanupTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.cleaning_services, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Cleanup Procedures',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: _addNewCleanupStep,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Cleanup'),
                ),
            ],
          ),
        ),
        Expanded(
          child: _currentMethodology.cleanupSteps.isEmpty
              ? _buildEmptyCleanupState()
              : _buildCleanupList(),
        ),
      ],
    );
  }

  Widget _buildEmptyCleanupState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cleaning_services_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Cleanup Steps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add cleanup procedures to remove traces after methodology execution',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.isEditMode) ...[
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: _addNewCleanupStep,
              icon: const Icon(Icons.add),
              label: const Text('Add Cleanup Step'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCleanupList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _currentMethodology.cleanupSteps.length,
      itemBuilder: (context, index) {
        return _buildCleanupCard(_currentMethodology.cleanupSteps[index]);
      },
    );
  }

  Widget _buildCleanupCard(CleanupStep step) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getCleanupPriorityColor(step.priority).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            step.required ? Icons.warning : Icons.cleaning_services,
            color: _getCleanupPriorityColor(step.priority),
          ),
        ),
        title: Text(step.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildTriggerBadge(step.priority.displayName, _getCleanupPriorityColor(step.priority)),
                const SizedBox(width: AppSpacing.sm),
                _buildTriggerBadge(step.shell.displayName, _getShellColor(step.shell)),
                if (step.required) ...[
                  const SizedBox(width: AppSpacing.sm),
                  _buildTriggerBadge('Required', Colors.red),
                ],
              ],
            ),
          ],
        ),
        trailing: widget.isEditMode
            ? IconButton(
                onPressed: () => _editCleanupStep(step),
                icon: const Icon(Icons.edit),
              )
            : null,
        onTap: () => _showCleanupDetails(step),
      ),
    );
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

  Widget _buildSectionHeader(String title, [IconData? icon, String? description]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 4),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholderSection(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.construction,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          if (widget.isEditMode) ...[
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: _saveMethodology,
              child: const Text('Save Template'),
            ),
          ] else ...[
            const Spacer(),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ],
      ),
    );
  }

  // Event handlers
  void _addNewTrigger() {
    // TODO: Implement trigger creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trigger creation dialog coming soon')),
    );
  }

  void _addNewCommand() {
    // TODO: Implement command creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Command creation dialog coming soon')),
    );
  }

  void _addNewFinding() {
    // TODO: Implement finding template creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Finding template dialog coming soon')),
    );
  }

  void _addNewCleanupStep() {
    // TODO: Implement cleanup step creation dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleanup step dialog coming soon')),
    );
  }

  void _showAddTagDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _AddTagDialog(),
    );

    if (result != null && result.isNotEmpty && !_tags.contains(result)) {
      setState(() {
        _tags.add(result);
      });
    }
  }

  void _handleTriggerAction(String action, int index) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit trigger coming soon')),
        );
        break;
      case 'test':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test trigger coming soon')),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Duplicate trigger coming soon')),
        );
        break;
      case 'delete':
        setState(() {
          _triggers.removeAt(index);
        });
        break;
    }
  }

  void _handleCommandAction(String action, int index) {
    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit command coming soon')),
        );
        break;
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Duplicate command coming soon')),
        );
        break;
      case 'test':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test command coming soon')),
        );
        break;
      case 'delete':
        final commands = List<MethodologyCommand>.from(_currentMethodology.commands);
        commands.removeAt(index);
        setState(() {
          _currentMethodology = _currentMethodology.copyWith(commands: commands);
        });
        break;
    }
  }

  void _editFinding(RelatedFinding finding) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit finding coming soon')),
    );
  }

  void _editCleanupStep(CleanupStep step) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit cleanup step coming soon')),
    );
  }

  void _showCleanupDetails(CleanupStep step) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(step.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step.description),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Command:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                step.command,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  color: Colors.green,
                ),
              ),
            ),
          ],
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

  void _saveMethodology() {
    // Create updated metadata
    final updatedMetadata = Map<String, dynamic>.from(_currentMethodology.metadata);
    updatedMetadata['tags'] = _tags;
    updatedMetadata['risk_level'] = _riskLevel;
    updatedMetadata['triggers'] = _triggers.map((t) => t.toJson()).toList();

    final updatedMethodology = _currentMethodology.copyWith(
      metadata: updatedMetadata,
    );

    if (widget.onSave != null) {
      widget.onSave!(updatedMethodology);
    }

    Navigator.of(context).pop();
  }

  // Equipment Section Methods
  Widget _buildEquipmentSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Equipment Required',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: _addEquipmentItem,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Equipment'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_equipment.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Icon(Icons.hardware, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No equipment added yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ..._equipment.map((equipment) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(Icons.hardware),
                title: Text(equipment),
                trailing: widget.isEditMode ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeEquipmentItem(equipment),
                ) : null,
              ),
            )),
        ],
      ),
    );
  }

  // Risks and Mitigations Section Methods
  Widget _buildRisksAndMitigationsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Risks & Mitigation Steps',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: _addRiskMitigation,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Risk'),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_risksAndMitigations.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Icon(Icons.security, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No risks documented yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            ..._risksAndMitigations.map((risk) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ExpansionTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text(risk['risk'] ?? 'Unknown Risk'),
                subtitle: Text('Mitigation: ${risk['mitigation']?.substring(0, 50) ?? ''}${(risk['mitigation']?.length ?? 0) > 50 ? '...' : ''}'),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Risk Description:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(risk['risk'] ?? ''),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Mitigation Steps:',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(risk['mitigation'] ?? ''),
                        if (widget.isEditMode) ...[
                          const SizedBox(height: AppSpacing.sm),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _editRiskMitigation(risk),
                                icon: const Icon(Icons.edit, size: 16),
                                label: const Text('Edit'),
                              ),
                              TextButton.icon(
                                onPressed: () => _removeRiskMitigation(risk),
                                icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                label: const Text('Delete', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }

  // Troubleshooting Tab Method
  Widget _buildTroubleshootingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Troubleshooting Guide', Icons.help_outline, 'Common issues and their solutions'),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Common Issues & Solutions',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    if (widget.isEditMode)
                      ElevatedButton.icon(
                        onPressed: _addTroubleshootingStep,
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Issue'),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                if (_troubleshootingSteps.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children: [
                        Icon(Icons.help_outline, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'No troubleshooting steps added yet',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                else
                  ..._troubleshootingSteps.map((step) => Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ExpansionTile(
                      leading: const Icon(Icons.help, color: Colors.blue),
                      title: Text(step['issue'] ?? 'Unknown Issue'),
                      subtitle: Text('Solution: ${step['solution']?.substring(0, 50) ?? ''}${(step['solution']?.length ?? 0) > 50 ? '...' : ''}'),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Issue Description:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(step['issue'] ?? ''),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'Solution:',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(step['solution'] ?? ''),
                              if (widget.isEditMode) ...[
                                const SizedBox(height: AppSpacing.sm),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () => _editTroubleshootingStep(step),
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('Edit'),
                                    ),
                                    TextButton.icon(
                                      onPressed: () => _removeTroubleshootingStep(step),
                                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tools Section Methods
  Widget _buildToolsSection() {
    // Extract tools from JSON methodology procedures
    final Set<String> tools = <String>{};
    if (widget.jsonMethodology != null) {
      for (final procedure in widget.jsonMethodology!.procedures) {
        for (final command in procedure.commands) {
          tools.add(command.tool);
        }
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Software Tools',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (tools.isEmpty)
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Icon(Icons.build, size: 48, color: Colors.grey[400]),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'No tools found in methodology procedures',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: tools.map((tool) => _buildToolChip(tool)).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildToolChip(String tool) {
    // Get tool icon and color based on common penetration testing tools
    IconData icon;
    Color color;

    switch (tool.toLowerCase()) {
      case 'nmap':
        icon = Icons.radar;
        color = Colors.blue;
        break;
      case 'nikto':
        icon = Icons.web;
        color = Colors.orange;
        break;
      case 'sqlmap':
        icon = Icons.storage;
        color = Colors.red;
        break;
      case 'airmon-ng':
      case 'airodump-ng':
      case 'aireplay-ng':
        icon = Icons.wifi;
        color = Colors.green;
        break;
      case 'metasploit':
      case 'msfconsole':
        icon = Icons.bug_report;
        color = Colors.purple;
        break;
      case 'hydra':
      case 'medusa':
        icon = Icons.key;
        color = Colors.amber;
        break;
      case 'john':
      case 'hashcat':
        icon = Icons.lock;
        color = Colors.brown;
        break;
      case 'dirb':
      case 'dirbuster':
      case 'gobuster':
        icon = Icons.folder;
        color = Colors.teal;
        break;
      case 'burp':
      case 'burpsuite':
        icon = Icons.web_asset;
        color = Colors.deepOrange;
        break;
      case 'wireshark':
      case 'tcpdump':
        icon = Icons.network_check;
        color = Colors.indigo;
        break;
      case 'netcat':
      case 'nc':
        icon = Icons.link;
        color = Colors.cyan;
        break;
      case 'ssh':
        icon = Icons.terminal;
        color = Colors.green.shade700;
        break;
      case 'curl':
      case 'wget':
        icon = Icons.download;
        color = Colors.lightBlue;
        break;
      case 'python':
      case 'python3':
        icon = Icons.code;
        color = Colors.yellow.shade700;
        break;
      case 'bash':
      case 'sh':
        icon = Icons.terminal;
        color = Colors.green.shade800;
        break;
      case 'powershell':
        icon = Icons.computer;
        color = Colors.blue.shade700;
        break;
      case 'nmcli':
      case 'iwconfig':
        icon = Icons.settings_ethernet;
        color = Colors.grey.shade700;
        break;
      case 'dhclient':
        icon = Icons.network_wifi;
        color = Colors.lightGreen;
        break;
      case 'macchanger':
        icon = Icons.shuffle;
        color = Colors.deepPurple;
        break;
      case 'yersinia':
        icon = Icons.security;
        color = Colors.red.shade700;
        break;
      case 'ettercap':
        icon = Icons.router;
        color = Colors.pink;
        break;
      default:
        icon = Icons.build;
        color = Colors.grey;
    }

    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        tool,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // Action Methods
  void _addEquipmentItem() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _AddEquipmentDialog(),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _equipment.add(result);
      });
    }
  }

  void _removeEquipmentItem(String equipment) {
    setState(() {
      _equipment.remove(equipment);
    });
  }

  void _addRiskMitigation() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddRiskMitigationDialog(),
    );

    if (result != null) {
      setState(() {
        _risksAndMitigations.add(result);
      });
    }
  }

  void _editRiskMitigation(Map<String, String> risk) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddRiskMitigationDialog(initialRisk: risk),
    );

    if (result != null) {
      setState(() {
        final index = _risksAndMitigations.indexOf(risk);
        if (index != -1) {
          _risksAndMitigations[index] = result;
        }
      });
    }
  }

  void _removeRiskMitigation(Map<String, String> risk) {
    setState(() {
      _risksAndMitigations.remove(risk);
    });
  }

  void _addTroubleshootingStep() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddTroubleshootingDialog(),
    );

    if (result != null) {
      setState(() {
        _troubleshootingSteps.add(result);
      });
    }
  }

  void _editTroubleshootingStep(Map<String, String> step) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _AddTroubleshootingDialog(initialStep: step),
    );

    if (result != null) {
      setState(() {
        final index = _troubleshootingSteps.indexOf(step);
        if (index != -1) {
          _troubleshootingSteps[index] = result;
        }
      });
    }
  }

  void _removeTroubleshootingStep(Map<String, String> step) {
    setState(() {
      _troubleshootingSteps.remove(step);
    });
  }
}

class _MethodologyTab {
  final String name;
  final IconData icon;

  _MethodologyTab({
    required this.name,
    required this.icon,
  });
}

class _AddTagDialog extends StatefulWidget {
  @override
  State<_AddTagDialog> createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<_AddTagDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Tag'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Tag name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            Navigator.of(context).pop(value);
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Equipment Dialog
class _AddEquipmentDialog extends StatefulWidget {
  final String? initialEquipment;

  const _AddEquipmentDialog({this.initialEquipment});

  @override
  State<_AddEquipmentDialog> createState() => _AddEquipmentDialogState();
}

class _AddEquipmentDialogState extends State<_AddEquipmentDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialEquipment ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialEquipment != null ? 'Edit Equipment' : 'Add Equipment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Equipment Name',
              hintText: 'e.g., WiFi Card, USB Drive, Network Cable',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.of(context).pop(_controller.text);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Risk Mitigation Dialog
class _AddRiskMitigationDialog extends StatefulWidget {
  final Map<String, String>? initialRisk;

  const _AddRiskMitigationDialog({this.initialRisk});

  @override
  State<_AddRiskMitigationDialog> createState() => _AddRiskMitigationDialogState();
}

class _AddRiskMitigationDialogState extends State<_AddRiskMitigationDialog> {
  late TextEditingController _riskController;
  late TextEditingController _mitigationController;

  @override
  void initState() {
    super.initState();
    _riskController = TextEditingController(text: widget.initialRisk?['risk'] ?? '');
    _mitigationController = TextEditingController(text: widget.initialRisk?['mitigation'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialRisk != null ? 'Edit Risk & Mitigation' : 'Add Risk & Mitigation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _riskController,
            decoration: const InputDecoration(
              labelText: 'Risk Description',
              hintText: 'e.g., System may crash, Database corruption',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _mitigationController,
            decoration: const InputDecoration(
              labelText: 'Mitigation Steps',
              hintText: 'Steps to prevent or minimize the risk',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_riskController.text.isNotEmpty && _mitigationController.text.isNotEmpty) {
              Navigator.of(context).pop({
                'risk': _riskController.text,
                'mitigation': _mitigationController.text,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Troubleshooting Dialog
class _AddTroubleshootingDialog extends StatefulWidget {
  final Map<String, String>? initialStep;

  const _AddTroubleshootingDialog({this.initialStep});

  @override
  State<_AddTroubleshootingDialog> createState() => _AddTroubleshootingDialogState();
}

class _AddTroubleshootingDialogState extends State<_AddTroubleshootingDialog> {
  late TextEditingController _issueController;
  late TextEditingController _solutionController;

  @override
  void initState() {
    super.initState();
    _issueController = TextEditingController(text: widget.initialStep?['issue'] ?? '');
    _solutionController = TextEditingController(text: widget.initialStep?['solution'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialStep != null ? 'Edit Troubleshooting Step' : 'Add Troubleshooting Step'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _issueController,
            decoration: const InputDecoration(
              labelText: 'Issue Description',
              hintText: 'e.g., Command fails with permission error',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _solutionController,
            decoration: const InputDecoration(
              labelText: 'Solution Steps',
              hintText: 'Steps to resolve the issue',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_issueController.text.isNotEmpty && _solutionController.text.isNotEmpty) {
              Navigator.of(context).pop({
                'issue': _issueController.text,
                'solution': _solutionController.text,
              });
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
