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
    _tabController = TabController(length: 7, vsync: this);
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
                Tab(text: 'Overview'),
                Tab(text: 'Procedure'),
                Tab(text: 'Tools & References'),
                Tab(text: 'Trigger Context'),
                Tab(text: 'Findings'),
                Tab(text: 'Cleanup'),
                Tab(text: 'Execution'),
              ],
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(methodology),
                  _buildProcedureTab(methodology),
                  _buildToolsReferencesTab(methodology),
                  _buildTriggerContextTab(methodology),
                  _buildFindingsTab(methodology),
                  _buildCleanupTab(methodology),
                  _buildExecutionTab(methodology),
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

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = Colors.green;
        break;
      case 'intermediate':
        color = Colors.yellow[700]!;
        break;
      case 'advanced':
        color = Colors.orange;
        break;
      case 'expert':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
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

  Widget _buildProcedureTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Procedure Steps',
            Icons.list,
            Text(methodology.description),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Commands',
            Icons.code,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _extractCommands(methodology).map((command) =>
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SelectableText(
                    command,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                  ),
                )
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsReferencesTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Tools Required',
            Icons.build,
            _buildToolsList(methodology),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'References',
            Icons.link,
            _buildReferencesList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTriggerContextTab(MethodologyTemplate methodology) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: methodology.triggers.length,
      itemBuilder: (context, index) {
        final trigger = methodology.triggers[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.gps_fixed, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Trigger ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Type: ${trigger.type}'),
                const SizedBox(height: 8),
                Text('Conditions: ${trigger.conditions?.entries.map((e) => '${e.key}=${e.value}').join(', ') ?? 'None'}'),
                const SizedBox(height: 8),
                Text('Description: ${trigger.description}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFindingsTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Expected Findings',
            Icons.search,
            _buildExpectedFindings(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Output Analysis',
            Icons.analytics,
            Text('Review all command outputs for credentials, network information, vulnerabilities, and system details. Document all findings with appropriate risk levels and remediation recommendations.'),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanupTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Cleanup Steps',
            Icons.cleaning_services,
            _buildCleanupSteps(),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Reset Instructions',
            Icons.refresh,
            Text('1. Remove any temporary files created during execution\n2. Clear command history if sensitive commands were used\n3. Restore any modified configurations\n4. Verify no persistent network connections remain\n5. Document cleanup completion in engagement notes'),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutionTab(MethodologyTemplate methodology) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Execution Status',
            Icons.play_arrow,
            Text('Current execution status and progress will be displayed here.'),
          ),
          const SizedBox(height: 24),
          _buildSection(
            'Actions',
            Icons.settings,
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _executeMethodology,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Execute Methodology'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  label: const Text('Close'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildToolsList(MethodologyTemplate methodology) {
    final tools = _extractTools(methodology);
    if (tools.isEmpty) {
      return Text('Standard penetration testing tools: nmap, nikto, gobuster, burp suite, metasploit framework');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tools.map((tool) =>
        Chip(
          label: Text(tool),
          backgroundColor: Colors.blue.withOpacity(0.1),
          avatar: const Icon(Icons.build, size: 16),
        ),
      ).toList(),
    );
  }

  Widget _buildReferencesList() {
    return Column(
      children: [
        _buildReferenceCard(
          'MITRE ATT&CK Framework',
          'Comprehensive knowledge base of adversary tactics and techniques',
          'https://attack.mitre.org/',
          Icons.security,
        ),
        _buildReferenceCard(
          'OWASP Testing Guide',
          'Web application security testing methodology',
          'https://owasp.org/www-project-web-security-testing-guide/',
          Icons.web,
        ),
        _buildReferenceCard(
          'NIST Cybersecurity Framework',
          'Risk management and cybersecurity standards',
          'https://www.nist.gov/cyberframework',
          Icons.policy,
        ),
      ],
    );
  }

  Widget _buildReferenceCard(String title, String description, String url, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(description),
        trailing: const Icon(Icons.open_in_new),
        onTap: () {
          // TODO: Open URL
        },
      ),
    );
  }

  Widget _buildExpectedFindings() {
    return Column(
      children: [
        _buildFindingCard(
          'Credentials',
          'User accounts, passwords, API keys, or authentication tokens',
          Icons.key,
          Colors.orange,
        ),
        _buildFindingCard(
          'Network Information',
          'IP addresses, open ports, network topology, and service versions',
          Icons.network_check,
          Colors.blue,
        ),
        _buildFindingCard(
          'System Information',
          'Operating system details, installed software, and running processes',
          Icons.computer,
          Colors.green,
        ),
        _buildFindingCard(
          'Vulnerabilities',
          'Security weaknesses, misconfigurations, and potential exploits',
          Icons.bug_report,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildFindingCard(String title, String description, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildCleanupSteps() {
    return Column(
      children: [
        _buildCleanupItem('1. Remove Temporary Files', 'Delete any files created during methodology execution'),
        _buildCleanupItem('2. Clear Command History', 'Remove sensitive commands from shell history'),
        _buildCleanupItem('3. Close Network Connections', 'Terminate any persistent connections or tunnels'),
        _buildCleanupItem('4. Restore Configurations', 'Revert any system or application changes'),
        _buildCleanupItem('5. Document Results', 'Save findings and ensure proper documentation'),
      ],
    );
  }

  Widget _buildCleanupItem(String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.cleaning_services, color: Colors.orange),
        title: Text(title),
        subtitle: Text(description),
      ),
    );
  }

  List<String> _extractTools(MethodologyTemplate methodology) {
    final tools = <String>[];
    final description = methodology.description.toLowerCase();
    final name = methodology.name.toLowerCase();

    // Extract common tools based on methodology content
    final commonTools = {
      'nmap': ['nmap', 'port scan', 'network scan'],
      'nikto': ['nikto', 'web scan', 'vulnerability scan'],
      'gobuster': ['gobuster', 'directory', 'brute force'],
      'burp': ['burp', 'proxy', 'web application'],
      'metasploit': ['metasploit', 'exploit', 'payload'],
      'wireshark': ['wireshark', 'packet', 'network capture'],
      'sqlmap': ['sqlmap', 'sql injection'],
      'john': ['john', 'password', 'crack'],
      'hashcat': ['hashcat', 'hash', 'crack'],
      'hydra': ['hydra', 'brute force', 'login'],
    };

    for (final entry in commonTools.entries) {
      for (final keyword in entry.value) {
        if (description.contains(keyword) || name.contains(keyword)) {
          tools.add(entry.key);
          break;
        }
      }
    }

    return tools;
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