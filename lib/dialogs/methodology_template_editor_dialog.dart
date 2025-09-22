import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology_detail.dart';
import '../models/methodology_trigger.dart';
import '../constants/app_spacing.dart';

class MethodologyTemplateEditorDialog extends ConsumerStatefulWidget {
  final MethodologyDetail? methodology;
  final bool isEditMode;
  final Function(MethodologyDetail)? onSave;

  const MethodologyTemplateEditorDialog({
    super.key,
    this.methodology,
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
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _currentMethodology = widget.methodology ?? _createEmptyMethodology();

    // Initialize tags from metadata
    if (_currentMethodology.metadata['tags'] is List) {
      _tags.addAll((_currentMethodology.metadata['tags'] as List).cast<String>());
    }
    if (_currentMethodology.metadata['risk_level'] is String) {
      _riskLevel = _currentMethodology.metadata['risk_level'] as String;
    }
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
                    color: Colors.white.withOpacity(0.9),
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
                color: Colors.white.withOpacity(0.2),
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
                  value: _riskLevel,
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
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
      side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.3)),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
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
            color: trigger.enabled ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
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
              Icon(Icons.list_alt, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Procedures & Commands',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (widget.isEditMode)
                ElevatedButton.icon(
                  onPressed: _addNewCommand,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Command'),
                ),
            ],
          ),
        ),
        Expanded(
          child: _currentMethodology.commands.isEmpty
              ? _buildEmptyCommandsState()
              : _buildCommandsList(),
        ),
      ],
    );
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
            color: _getShellColor(command.defaultShell).withOpacity(0.1),
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
                    color: Colors.blue.withOpacity(0.1),
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
          _buildSectionHeader('Required Tools'),
          const SizedBox(height: AppSpacing.md),
          _buildPlaceholderSection('Tool requirements will be listed here'),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionHeader('References & Documentation'),
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
            color: _getSeverityColor(finding.severity).withOpacity(0.1),
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
            color: _getCleanupPriorityColor(step.priority).withOpacity(0.1),
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

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_outlined,
            color: Theme.of(context).primaryColor,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              fontSize: 14,
            ),
          ),
        ],
      ),
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