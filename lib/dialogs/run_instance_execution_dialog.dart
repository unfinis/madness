import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology_detail.dart';
import '../models/methodology_trigger.dart';
import '../models/asset.dart';
import '../constants/app_spacing.dart';

class RunInstanceExecutionDialog extends ConsumerStatefulWidget {
  final TriggeredMethodology triggeredMethodology;
  final MethodologyDetail methodologyTemplate;
  final Asset targetAsset;
  final Function(RunInstanceOutcome)? onComplete;

  const RunInstanceExecutionDialog({
    super.key,
    required this.triggeredMethodology,
    required this.methodologyTemplate,
    required this.targetAsset,
    this.onComplete,
  });

  @override
  ConsumerState<RunInstanceExecutionDialog> createState() =>
      _RunInstanceExecutionDialogState();
}

class _RunInstanceExecutionDialogState
    extends ConsumerState<RunInstanceExecutionDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _currentStatus = 'pending';
  final List<CommandOutput> _commandOutputs = [];
  final List<EvidenceFile> _evidenceFiles = [];
  final List<String> _generatedFindings = [];
  String _notes = '';

  final List<_RunInstanceTab> _tabs = [
    _RunInstanceTab(
      name: 'Overview',
      icon: Icons.info_outline,
    ),
    _RunInstanceTab(
      name: 'Execution',
      icon: Icons.play_circle_outline,
    ),
    _RunInstanceTab(
      name: 'Evidence',
      icon: Icons.folder_open,
    ),
    _RunInstanceTab(
      name: 'Findings',
      icon: Icons.bug_report,
    ),
    _RunInstanceTab(
      name: 'History',
      icon: Icons.history,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _currentStatus = widget.triggeredMethodology.status ?? 'pending';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        color: _getStatusColor(_currentStatus),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(_currentStatus),
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.methodologyTemplate.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Target: ${widget.targetAsset.name}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentStatus.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.triggeredMethodology.id,
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
        _buildExecutionTab(),
        _buildEvidenceTab(),
        _buildFindingsTab(),
        _buildHistoryTab(),
      ],
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Run Information'),
          const SizedBox(height: AppSpacing.md),
          _buildInfoGrid(),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionHeader('Trigger Context'),
          const SizedBox(height: AppSpacing.md),
          _buildTriggerContext(),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionHeader('Asset Information'),
          const SizedBox(height: AppSpacing.md),
          _buildAssetInfo(),

          const SizedBox(height: AppSpacing.xl),

          _buildSectionHeader('Methodology Overview'),
          const SizedBox(height: AppSpacing.md),
          _buildMethodologyOverview(),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildInfoItem('Run ID', widget.triggeredMethodology.id)),
              Expanded(child: _buildInfoItem('Status', _currentStatus.toUpperCase())),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildInfoItem('Priority', widget.triggeredMethodology.priority.toString())),
              Expanded(child: _buildInfoItem('Triggered', _formatDateTime(widget.triggeredMethodology.triggeredAt))),
            ],
          ),
          if (_currentStatus == 'executing' || _currentStatus == 'completed') ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                if (widget.triggeredMethodology.executedAt != null)
                  Expanded(child: _buildInfoItem('Started', _formatDateTime(widget.triggeredMethodology.executedAt!))),
                if (widget.triggeredMethodology.completedAt != null)
                  Expanded(child: _buildInfoItem('Completed', _formatDateTime(widget.triggeredMethodology.completedAt!))),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTriggerContext() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flash_on, color: Colors.blue, size: 16),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Triggered by: ${widget.triggeredMethodology.triggerId}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          if (widget.triggeredMethodology.variables.isNotEmpty) ...[
            Text(
              'Extracted Variables:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...widget.triggeredMethodology.variables.entries.map((entry) => Padding(
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
                      entry.key,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildAssetInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_getAssetTypeIcon(widget.targetAsset.type), color: Colors.green, size: 16),
              const SizedBox(width: AppSpacing.sm),
              Text(
                '${widget.targetAsset.name} (${widget.targetAsset.type.name})',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          if (widget.targetAsset.description != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.targetAsset.description!,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
          if (widget.targetAsset.properties.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Properties:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...widget.targetAsset.properties.entries.take(5).map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Text(
                    '${entry.key}:',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _formatPropertyValue(entry.value),
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            )),
            if (widget.targetAsset.properties.length > 5)
              Text(
                '... and ${widget.targetAsset.properties.length - 5} more properties',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildMethodologyOverview() {
    return Container(
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
            widget.methodologyTemplate.overview,
            style: const TextStyle(fontSize: 14),
          ),
          if (widget.methodologyTemplate.purpose.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Purpose:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.methodologyTemplate.purpose,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExecutionTab() {
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
              Icon(Icons.terminal, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Command Execution',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_currentStatus == 'pending')
                ElevatedButton.icon(
                  onPressed: _startExecution,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start Execution'),
                )
              else if (_currentStatus == 'executing')
                ElevatedButton.icon(
                  onPressed: _markComplete,
                  icon: const Icon(Icons.check),
                  label: const Text('Mark Complete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
            ],
          ),
        ),
        Expanded(
          child: widget.methodologyTemplate.commands.isEmpty
              ? _buildNoCommandsState()
              : _buildCommandsList(),
        ),
      ],
    );
  }

  Widget _buildNoCommandsState() {
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
            'This methodology template has no commands to execute',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCommandsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: widget.methodologyTemplate.commands.length,
      itemBuilder: (context, index) {
        return _buildCommandCard(widget.methodologyTemplate.commands[index], index);
      },
    );
  }

  Widget _buildCommandCard(MethodologyCommand command, int index) {
    final resolvedCommand = _resolveCommand(command);

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
        subtitle: Text(
          command.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Command Preview
                Text(
                  'Command Preview:',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        resolvedCommand,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _copyCommand(resolvedCommand),
                            icon: const Icon(Icons.copy, size: 16),
                            label: const Text('Copy'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          if (widget.triggeredMethodology.batchAssets != null &&
                              widget.triggeredMethodology.batchAssets!.length > 1)
                            ElevatedButton.icon(
                              onPressed: () => _copyBatchCommand(command),
                              icon: const Icon(Icons.copy_all, size: 16),
                              label: const Text('Copy Loop'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

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
                        Expanded(child: Text(prereq, style: const TextStyle(fontSize: 12))),
                      ],
                    ),
                  )),
                ],

                // Expected Output
                if (command.expectedOutput != null) ...[
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Expected Output:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      command.expectedOutput!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceTab() {
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
              Icon(Icons.folder_open, color: Theme.of(context).primaryColor),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Evidence Collection',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _uploadEvidence,
                icon: const Icon(Icons.upload),
                label: const Text('Upload File'),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton.icon(
                onPressed: _pasteOutput,
                icon: const Icon(Icons.paste),
                label: const Text('Paste Output'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _evidenceFiles.isEmpty
              ? _buildNoEvidenceState()
              : _buildEvidenceList(),
        ),
      ],
    );
  }

  Widget _buildNoEvidenceState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No Evidence Collected',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Upload files or paste command outputs to document your findings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _uploadEvidence,
                icon: const Icon(Icons.upload),
                label: const Text('Upload File'),
              ),
              const SizedBox(width: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: _pasteOutput,
                icon: const Icon(Icons.paste),
                label: const Text('Paste Output'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _evidenceFiles.length,
      itemBuilder: (context, index) {
        return _buildEvidenceCard(_evidenceFiles[index]);
      },
    );
  }

  Widget _buildEvidenceCard(EvidenceFile evidence) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getEvidenceTypeColor(evidence.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getEvidenceTypeIcon(evidence.type),
            color: _getEvidenceTypeColor(evidence.type),
          ),
        ),
        title: Text(evidence.filename),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${evidence.type} • ${_formatFileSize(evidence.size)}'),
            const SizedBox(height: 4),
            Text(
              'Uploaded: ${_formatDateTime(evidence.uploadedAt)}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleEvidenceAction(action, evidence),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'view', child: Text('View')),
            const PopupMenuItem(value: 'download', child: Text('Download')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
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
                'Generated Findings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _generateFindings,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Auto-Generate'),
              ),
              const SizedBox(width: AppSpacing.sm),
              ElevatedButton.icon(
                onPressed: _addManualFinding,
                icon: const Icon(Icons.add),
                label: const Text('Add Finding'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _generatedFindings.isEmpty
              ? _buildNoFindingsState()
              : _buildFindingsList(),
        ),
      ],
    );
  }

  Widget _buildNoFindingsState() {
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
            'No Findings Generated',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Findings will be automatically generated based on command outputs and evidence',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton.icon(
            onPressed: _generateFindings,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('Generate Findings'),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _generatedFindings.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(_generatedFindings[index]),
          ),
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return _buildPlaceholderTab('History', 'Execution history will be shown here');
  }

  Widget _buildPlaceholderTab(String title, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
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
          if (_currentStatus == 'pending' || _currentStatus == 'executing') ...[
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: AppSpacing.md),
            if (_currentStatus == 'pending')
              ElevatedButton(
                onPressed: _startExecution,
                child: const Text('Start Execution'),
              )
            else
              ElevatedButton(
                onPressed: _markComplete,
                child: const Text('Mark Complete'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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

  // Helper methods
  String _resolveCommand(MethodologyCommand command) {
    var resolved = command.primaryCommand;

    // Replace with variables from triggered methodology
    for (final entry in widget.triggeredMethodology.variables.entries) {
      resolved = resolved.replaceAll('{${entry.key}}', entry.value.toString());
    }

    // Replace with command variables
    for (final entry in command.variables.entries) {
      resolved = resolved.replaceAll('{${entry.key}}', entry.value);
    }

    return resolved;
  }

  IconData _getAssetTypeIcon(AssetType type) {
    switch (type) {
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.cloud;
      case AssetType.networkSegment:
        return Icons.network_wifi;
      default:
        return Icons.device_unknown;
    }
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

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.schedule;
      case 'executing':
        return Icons.play_circle;
      case 'completed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'skipped':
        return Icons.skip_next;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'executing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'skipped':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getEvidenceTypeIcon(String type) {
    switch (type) {
      case 'file':
        return Icons.insert_drive_file;
      case 'screenshot':
        return Icons.image;
      case 'output':
        return Icons.terminal;
      case 'json':
        return Icons.data_object;
      default:
        return Icons.description;
    }
  }

  Color _getEvidenceTypeColor(String type) {
    switch (type) {
      case 'file':
        return Colors.blue;
      case 'screenshot':
        return Colors.green;
      case 'output':
        return Colors.orange;
      case 'json':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatPropertyValue(PropertyValue value) {
    return value.when(
      string: (v) => v,
      integer: (v) => v.toString(),
      boolean: (v) => v.toString(),
      stringList: (v) => v.join(', '),
      map: (v) => v.toString(),
      objectList: (v) => '${v.length} item(s)',
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  // Event handlers
  void _startExecution() {
    setState(() {
      _currentStatus = 'executing';
    });
    // Switch to execution tab
    _tabController.animateTo(1);
  }

  void _markComplete() {
    setState(() {
      _currentStatus = 'completed';
    });

    final outcome = RunInstanceOutcome(
      id: 'outcome-${DateTime.now().millisecondsSinceEpoch}',
      runId: widget.triggeredMethodology.id,
      status: _currentStatus,
      notes: _notes,
      evidenceFiles: _evidenceFiles,
      findings: _generatedFindings,
      completedAt: DateTime.now(),
    );

    if (widget.onComplete != null) {
      widget.onComplete!(outcome);
    }
  }

  void _copyCommand(String command) {
    Clipboard.setData(ClipboardData(text: command));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Command copied to clipboard')),
    );
  }

  void _copyBatchCommand(MethodologyCommand command) {
    // Generate batch command for multiple targets
    final batchAssets = widget.triggeredMethodology.batchAssets ?? [widget.targetAsset];
    final targets = batchAssets.map((asset) => asset.name).join(' ');

    final batchCommand = '''# Batch execution for ${batchAssets.length} targets
for target in $targets; do
    ${_resolveCommand(command).replaceAll(widget.targetAsset.name, '\$target')}
done''';

    Clipboard.setData(ClipboardData(text: batchCommand));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Batch command copied to clipboard')),
    );
  }

  void _uploadEvidence() {
    // TODO: Implement file picker and upload
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File upload coming soon')),
    );
  }

  void _pasteOutput() {
    // TODO: Implement paste output dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paste output dialog coming soon')),
    );
  }

  void _generateFindings() {
    // TODO: Implement automatic finding generation
    setState(() {
      _generatedFindings.add('Auto-generated finding based on execution results');
    });
  }

  void _addManualFinding() {
    // TODO: Implement manual finding creation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manual finding creation coming soon')),
    );
  }

  void _handleEvidenceAction(String action, EvidenceFile evidence) {
    switch (action) {
      case 'view':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('View evidence coming soon')),
        );
        break;
      case 'download':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download evidence coming soon')),
        );
        break;
      case 'delete':
        setState(() {
          _evidenceFiles.remove(evidence);
        });
        break;
    }
  }
}

// Supporting classes
class _RunInstanceTab {
  final String name;
  final IconData icon;

  _RunInstanceTab({
    required this.name,
    required this.icon,
  });
}

class CommandOutput {
  final String commandId;
  final String output;
  final String? errorOutput;
  final DateTime timestamp;
  final Duration executionTime;

  CommandOutput({
    required this.commandId,
    required this.output,
    this.errorOutput,
    required this.timestamp,
    required this.executionTime,
  });
}

class EvidenceFile {
  final String id;
  final String filename;
  final String type;
  final int size;
  final DateTime uploadedAt;
  final String? content;

  EvidenceFile({
    required this.id,
    required this.filename,
    required this.type,
    required this.size,
    required this.uploadedAt,
    this.content,
  });
}

class RunInstanceOutcome {
  final String id;
  final String runId;
  final String status;
  final String notes;
  final List<EvidenceFile> evidenceFiles;
  final List<String> findings;
  final DateTime completedAt;

  RunInstanceOutcome({
    required this.id,
    required this.runId,
    required this.status,
    required this.notes,
    required this.evidenceFiles,
    required this.findings,
    required this.completedAt,
  });
}