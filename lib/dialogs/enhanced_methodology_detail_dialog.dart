import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/methodology_loader.dart';

class EnhancedMethodologyDetailDialog extends ConsumerStatefulWidget {
  final MethodologyTemplate methodology;

  const EnhancedMethodologyDetailDialog({
    super.key,
    required this.methodology,
  });

  @override
  ConsumerState<EnhancedMethodologyDetailDialog> createState() => _EnhancedMethodologyDetailDialogState();
}

class _EnhancedMethodologyDetailDialogState extends ConsumerState<EnhancedMethodologyDetailDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final methodology = widget.methodology;

    return Dialog(
      child: Container(
        width: 900,
        height: 700,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    _getCategoryColor(methodology).withOpacity(0.1),
                    _getCategoryColor(methodology).withOpacity(0.05),
                  ],
                ),
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  // Category Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(methodology).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(methodology),
                      color: _getCategoryColor(methodology),
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title and info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                methodology.name,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            _buildDifficultyBadge(_getDifficulty(methodology)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          methodology.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildInfoChip(
                              Icons.gps_fixed,
                              '${methodology.triggers.length} triggers',
                              Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              Icons.schedule,
                              _getEstimatedTime(methodology),
                              Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            _buildInfoChip(
                              Icons.security,
                              _getRiskLevel(methodology),
                              _getRiskColor(methodology),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Action buttons
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        tooltip: 'Close',
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _executeMethodology,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Execute'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getCategoryColor(methodology),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.info), text: 'Overview'),
                Tab(icon: Icon(Icons.gps_fixed), text: 'Triggers'),
                Tab(icon: Icon(Icons.code), text: 'Commands'),
                Tab(icon: Icon(Icons.help), text: 'Documentation'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(methodology),
                  _buildTriggersTab(methodology),
                  _buildCommandsTab(methodology),
                  _buildDocumentationTab(methodology),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Triggers',
                  '${methodology.triggers.length}',
                  Icons.gps_fixed,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Commands',
                  '${_getCommandCount(methodology)}',
                  Icons.terminal,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Priority',
                  'P${_getPriority(methodology)}',
                  Icons.flag,
                  _getPriorityColor(methodology),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Prerequisites
          _buildSection(
            'Prerequisites',
            Icons.checklist,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_getPrerequisites(methodology).isEmpty)
                  Text(
                    'No specific prerequisites required',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                else
                  ..._getPrerequisites(methodology).map((prereq) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(child: Text(prereq)),
                      ],
                    ),
                  )),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Target Assets
          _buildSection(
            'Target Asset Types',
            Icons.track_changes,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _getTargetAssetTypes(methodology).map((assetType) => Chip(
                label: Text(assetType),
                avatar: Icon(_getAssetTypeIcon(assetType), size: 16),
                backgroundColor: Colors.blue.withOpacity(0.1),
              )).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Expected Outcomes
          _buildSection(
            'Expected Outcomes',
            Icons.insights,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getExpectedOutcomes(methodology).map((outcome) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.arrow_right, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(child: Text(outcome)),
                  ],
                ),
              )).toList(),
            ),
          ),

          const SizedBox(height: 24),

          // Tags
          if (methodology.tags.isNotEmpty)
            _buildSection(
              'Tags',
              Icons.label,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: methodology.tags.map((tag) => Chip(
                  label: Text(tag),
                  backgroundColor: Colors.grey.withOpacity(0.1),
                )).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTriggersTab(MethodologyTemplate methodology) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: methodology.triggers.length,
      itemBuilder: (context, index) {
        final trigger = methodology.triggers[index];
        return _buildTriggerCard(trigger, index);
      },
    );
  }

  Widget _buildTriggerCard(dynamic trigger, int index) {
    // Handle MethodologyTrigger from loader service
    String condition = 'No condition';
    int priority = 5;
    String description = 'No description';

    if (trigger is MethodologyTrigger) {
      condition = trigger.conditions?.toString() ?? trigger.description;
      priority = trigger.conditions?['priority'] as int? ?? 5;
      description = trigger.description;
    } else if (trigger is Map<String, dynamic>) {
      condition = trigger['condition'] as String? ?? 'No condition';
      priority = trigger['priority'] as int? ?? 5;
      description = trigger['description'] as String? ?? 'No description';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getPriorityColor(null, priority: priority).withOpacity(0.1),
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: _getPriorityColor(null, priority: priority),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text('Trigger ${index + 1}'),
        subtitle: Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getPriorityColor(null, priority: priority).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'P$priority',
            style: TextStyle(
              color: _getPriorityColor(null, priority: priority),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Condition:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
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
                    condition,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => _copyToClipboard(condition),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Copy'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandsTab(MethodologyTemplate methodology) {
    final commands = _extractCommands(methodology);

    return commands.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.terminal, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'No commands defined',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This methodology uses dynamic command generation',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: commands.length,
            itemBuilder: (context, index) {
              final command = commands[index];
              return _buildCommandCard(command, index);
            },
          );
  }

  Widget _buildCommandCard(String command, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.terminal, color: Colors.green[600]),
                const SizedBox(width: 8),
                Text(
                  'Command ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _copyToClipboard(command),
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Copy'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
              ),
              child: SelectableText(
                command,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.green,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentationTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Description',
            Icons.description,
            Text(methodology.description),
          ),

          const SizedBox(height: 24),

          _buildSection(
            'Methodology Details',
            Icons.info,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Name', methodology.name),
                _buildDetailRow('Created', methodology.created.toString().substring(0, 16)),
                _buildDetailRow('Version', methodology.version),
                _buildDetailRow('Author', methodology.author),
                _buildDetailRow('Category', _getCategory(methodology)),
                _buildDetailRow('Difficulty', _getDifficulty(methodology)),
                _buildDetailRow('Risk Level', _getRiskLevel(methodology)),
              ],
            ),
          ),

          const SizedBox(height: 24),

          if (methodology.tags.isNotEmpty)
            _buildSection(
              'Technical Details',
              Icons.settings,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'This methodology contains ${methodology.triggers.length} triggers that will be evaluated against your assets. '
                    'When triggered, it will execute a series of commands to achieve the methodology objectives.',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tags: ${methodology.tags.join(', ')}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey[700]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    String emoji;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = Colors.green;
        emoji = '🟢';
        break;
      case 'intermediate':
        color = Colors.yellow[700]!;
        emoji = '🟡';
        break;
      case 'advanced':
        color = Colors.orange;
        emoji = '🟠';
        break;
      case 'expert':
        color = Colors.red;
        emoji = '🔴';
        break;
      default:
        color = Colors.grey;
        emoji = '⚪';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji),
          const SizedBox(width: 4),
          Text(
            difficulty.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getCategoryColor(MethodologyTemplate methodology) {
    final category = _getCategory(methodology).toLowerCase();
    switch (category) {
      case 'reconnaissance': return Colors.blue;
      case 'initial_access': return Colors.orange;
      case 'persistence': return Colors.green;
      case 'privilege_escalation': return Colors.red;
      case 'credential_access': return Colors.purple;
      case 'lateral_movement': return Colors.indigo;
      case 'collection': return Colors.brown;
      case 'exfiltration': return Colors.pink;
      default: return Colors.grey;
    }
  }

  IconData _getCategoryIcon(MethodologyTemplate methodology) {
    final category = _getCategory(methodology).toLowerCase();
    switch (category) {
      case 'reconnaissance': return Icons.search;
      case 'initial_access': return Icons.login;
      case 'persistence': return Icons.anchor;
      case 'privilege_escalation': return Icons.trending_up;
      case 'credential_access': return Icons.key;
      case 'lateral_movement': return Icons.swap_horiz;
      case 'collection': return Icons.folder;
      case 'exfiltration': return Icons.upload;
      default: return Icons.code;
    }
  }

  String _getCategory(MethodologyTemplate methodology) {
    for (final tag in methodology.tags) {
      if (['reconnaissance', 'initial_access', 'persistence', 'privilege_escalation',
           'credential_access', 'lateral_movement', 'collection', 'exfiltration'].contains(tag.toLowerCase())) {
        return tag;
      }
    }
    return 'Other';
  }

  String _getDifficulty(MethodologyTemplate methodology) {
    final triggerCount = methodology.triggers.length;
    if (triggerCount <= 2) return 'Beginner';
    if (triggerCount <= 5) return 'Intermediate';
    if (triggerCount <= 8) return 'Advanced';
    return 'Expert';
  }

  String _getRiskLevel(MethodologyTemplate methodology) {
    final priority = _getPriority(methodology);
    if (priority <= 2) return 'High';
    if (priority <= 5) return 'Medium';
    return 'Low';
  }

  Color _getRiskColor(MethodologyTemplate methodology) {
    switch (_getRiskLevel(methodology)) {
      case 'High': return Colors.red;
      case 'Medium': return Colors.orange;
      case 'Low': return Colors.green;
      default: return Colors.grey;
    }
  }

  int _getPriority(MethodologyTemplate methodology) {
    if (methodology.triggers.isNotEmpty) {
      final firstTrigger = methodology.triggers.first;
      // Try to extract priority from conditions
      final conditions = firstTrigger.conditions;
      if (conditions != null && conditions.containsKey('priority')) {
        return conditions['priority'] as int? ?? 5;
      }
    }
    return 5;
  }

  Color _getPriorityColor(MethodologyTemplate? methodology, {int? priority}) {
    final p = priority ?? _getPriority(methodology!);
    if (p <= 2) return Colors.red;
    if (p <= 5) return Colors.orange;
    return Colors.green;
  }

  String _getEstimatedTime(MethodologyTemplate methodology) {
    final triggerCount = methodology.triggers.length;
    final commandCount = _getCommandCount(methodology);
    final totalComplexity = triggerCount + commandCount;

    if (totalComplexity <= 3) return '< 5 min';
    if (totalComplexity <= 8) return '5-15 min';
    if (totalComplexity <= 15) return '15-30 min';
    return '> 30 min';
  }

  int _getCommandCount(MethodologyTemplate methodology) {
    return _extractCommands(methodology).length;
  }

  List<String> _getPrerequisites(MethodologyTemplate methodology) {
    // Extract from methodology or infer based on triggers
    return [
      'Target asset must be accessible',
      'Appropriate permissions required',
      'Network connectivity to target',
    ];
  }

  List<String> _getTargetAssetTypes(MethodologyTemplate methodology) {
    // Extract from triggers or infer
    return ['Host', 'Service', 'Network Segment'];
  }

  List<String> _getExpectedOutcomes(MethodologyTemplate methodology) {
    // Extract based on methodology type
    final name = methodology.name.toLowerCase();
    if (name.contains('scan') || name.contains('enum')) {
      return ['Service discovery', 'Open ports identified', 'Service versions detected'];
    } else if (name.contains('cred') || name.contains('auth')) {
      return ['Valid credentials obtained', 'Authentication bypass', 'Privilege information'];
    } else if (name.contains('exploit')) {
      return ['Remote code execution', 'System compromise', 'Elevated privileges'];
    }

    return ['Information gathered', 'Assets discovered', 'Security status assessed'];
  }

  List<String> _extractCommands(MethodologyTemplate methodology) {
    // Extract commands from procedures
    final commands = <String>[];

    // Check procedures for commands
    for (final procedure in methodology.procedures) {
      for (final command in procedure.commands) {
        if (command.command.isNotEmpty) {
          commands.add(command.command);
        }
      }
    }

    return commands;
  }

  IconData _getAssetTypeIcon(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'host': return Icons.computer;
      case 'service': return Icons.web;
      case 'network': return Icons.router;
      case 'credential': return Icons.key;
      default: return Icons.device_unknown;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  void _executeMethodology() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Executing methodology: ${widget.methodology.name}'),
        action: SnackBarAction(
          label: 'View Progress',
          onPressed: () {
            // Navigate to execution monitor
          },
        ),
      ),
    );
  }
}