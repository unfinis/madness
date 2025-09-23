import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';
import '../constants/app_spacing.dart';
import '../widgets/markdown_editor_widget.dart';

class EnhancedFindingDialog extends ConsumerStatefulWidget {
  final Finding? finding;
  final String projectId;

  const EnhancedFindingDialog({
    super.key,
    this.finding,
    required this.projectId,
  });

  @override
  ConsumerState<EnhancedFindingDialog> createState() => _EnhancedFindingDialogState();
}

class _EnhancedFindingDialogState extends ConsumerState<EnhancedFindingDialog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();

  // Controllers for basic fields
  late TextEditingController _titleController;
  late TextEditingController _cvssScoreController;
  late TextEditingController _cvssVectorController;
  late TextEditingController _executiveNoteController;

  // Markdown content controllers
  late String _descriptionMarkdown;
  late String _recommendationsMarkdown;

  // Lists for dynamic fields
  final List<TextEditingController> _furtherReadingControllers = [];
  final List<Map<String, TextEditingController>> _remediationCheckControllers = [];

  // Form state
  FindingSeverity _selectedSeverity = FindingSeverity.medium;
  bool _hasUnsavedChanges = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    // Initialize controllers with existing data or defaults
    _titleController = TextEditingController(text: widget.finding?.title ?? '');
    _cvssScoreController = TextEditingController(
      text: widget.finding?.cvssScore.toString() ?? '5.0',
    );
    _cvssVectorController = TextEditingController(
      text: widget.finding?.cvssVector ?? 'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:N',
    );
    _executiveNoteController = TextEditingController();

    // Initialize markdown content
    _descriptionMarkdown = widget.finding?.description ?? '';
    _recommendationsMarkdown = '';

    // Initialize severity
    _selectedSeverity = widget.finding?.severity ?? FindingSeverity.medium;

    // Initialize further reading if exists
    if (widget.finding?.furtherReading != null) {
      final items = widget.finding!.furtherReading!.split('\n');
      for (final item in items) {
        if (item.isNotEmpty) {
          _furtherReadingControllers.add(TextEditingController(text: item));
        }
      }
    }

    // Add empty controller for new item
    if (_furtherReadingControllers.isEmpty) {
      _furtherReadingControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _cvssScoreController.dispose();
    _cvssVectorController.dispose();
    _executiveNoteController.dispose();
    for (final controller in _furtherReadingControllers) {
      controller.dispose();
    }
    for (final check in _remediationCheckControllers) {
      check.values.forEach((controller) => controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _buildTabContent(),
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
        color: _getSeverityColor(_selectedSeverity).withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.bug_report,
            color: _getSeverityColor(_selectedSeverity),
            size: 32,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.finding == null ? 'Create New Finding' : 'Edit Finding',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.finding != null)
                  Text(
                    'ID: ${widget.finding!.id}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _handleClose,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabs: const [
        Tab(text: 'Basic Info'),
        Tab(text: 'Description'),
        Tab(text: 'Recommendations'),
        Tab(text: 'Executive Note'),
        Tab(text: 'References'),
        Tab(text: 'Remediation'),
      ],
    );
  }

  Widget _buildTabContent() {
    return Form(
      key: _formKey,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildBasicInfoTab(),
          _buildDescriptionTab(),
          _buildRecommendationsTab(),
          _buildExecutiveNoteTab(),
          _buildReferencesTab(),
          _buildRemediationTab(),
        ],
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Finding Title *',
              hintText: 'Enter a descriptive title for the finding',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Title is required';
              }
              return null;
            },
            onChanged: (_) => _hasUnsavedChanges = true,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Severity dropdown
          DropdownButtonFormField<FindingSeverity>(
            value: _selectedSeverity,
            decoration: const InputDecoration(
              labelText: 'Severity *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.warning),
            ),
            items: FindingSeverity.values.map((severity) {
              return DropdownMenuItem(
                value: severity,
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getSeverityColor(severity),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(severity.displayName),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedSeverity = value;
                  _updateCVSSFromSeverity(value);
                  _hasUnsavedChanges = true;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.lg),

          // CVSS Score and Vector row
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cvssScoreController,
                  decoration: const InputDecoration(
                    labelText: 'CVSS Score (0.0 - 10.0)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.score),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d{0,2}(\.\d{0,1})?')),
                  ],
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final score = double.tryParse(value);
                      if (score == null || score < 0 || score > 10) {
                        return 'Score must be between 0.0 and 10.0';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateSeverityFromCVSS(value);
                    _hasUnsavedChanges = true;
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              IconButton(
                icon: const Icon(Icons.calculate),
                tooltip: 'CVSS Calculator',
                onPressed: _openCVSSCalculator,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // CVSS Vector
          TextFormField(
            controller: _cvssVectorController,
            decoration: const InputDecoration(
              labelText: 'CVSS Vector',
              hintText: 'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:N/I:N/A:N',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.code),
            ),
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            onChanged: (_) => _hasUnsavedChanges = true,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Information cards
          _buildInfoCard(
            'Severity Guidelines',
            Icons.info,
            '''
Critical (9.0-10.0): Complete compromise of system confidentiality, integrity, or availability
High (7.0-8.9): Significant impact on confidentiality, integrity, or availability
Medium (4.0-6.9): Moderate impact requiring specific conditions
Low (0.1-3.9): Limited impact with significant interaction required
Informational (0.0): No direct security impact
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Finding Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Provide a detailed description of the vulnerability or finding. Use markdown for formatting.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: MarkdownEditorWidget(
              initialText: _descriptionMarkdown,
              hintText: '''Describe the finding in detail...

Example structure:
## Overview
Brief summary of the finding

## Technical Details
Detailed technical explanation

## Impact
Potential impact on the system or business

## Proof of Concept
Steps to reproduce or evidence
''',
              onChanged: (value) {
                _descriptionMarkdown = value;
                _hasUnsavedChanges = true;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remediation Recommendations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Provide detailed remediation steps and recommendations. Use markdown for formatting.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: MarkdownEditorWidget(
              initialText: _recommendationsMarkdown,
              hintText: '''Provide remediation recommendations...

Example structure:
## Short-term Remediation
1. Immediate actions to mitigate risk
2. Quick fixes or workarounds

## Long-term Remediation
- Permanent solution implementation
- Architecture changes if needed

## Additional Considerations
- Security best practices
- Monitoring recommendations
''',
              onChanged: (value) {
                _recommendationsMarkdown = value;
                _hasUnsavedChanges = true;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveNoteTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Executive Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Provide a high-level summary suitable for executive or non-technical stakeholders.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _executiveNoteController,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: '''Write a concise executive summary...

Focus on:
- Business impact
- Risk assessment
- High-level remediation timeline
- Resource requirements

Avoid technical jargon and implementation details.''',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _hasUnsavedChanges = true,
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoCard(
            'Executive Note Guidelines',
            Icons.business,
            '''
• Keep it concise (2-3 paragraphs)
• Focus on business impact and risk
• Use clear, non-technical language
• Include cost/benefit considerations
• Highlight urgency if applicable
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildReferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Further Reading & References',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Add links to relevant documentation, CVE entries, vendor advisories, etc.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          ..._furtherReadingControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Reference ${index + 1}',
                        hintText: 'Enter URL or reference',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.link),
                      ),
                      onChanged: (_) => _hasUnsavedChanges = true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        controller.dispose();
                        _furtherReadingControllers.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _furtherReadingControllers.add(TextEditingController());
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Reference'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoCard(
            'Common Reference Types',
            Icons.library_books,
            '''
• CVE Database: https://cve.mitre.org/
• NVD: https://nvd.nist.gov/
• OWASP: https://owasp.org/
• Vendor Security Bulletins
• Security Research Papers
• Exploit Database: https://www.exploit-db.com/
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildRemediationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Remediation Verification Checks',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Define specific checks to verify that remediation has been properly implemented.',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          const SizedBox(height: AppSpacing.md),
          ..._remediationCheckControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controllers = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Check ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              controllers.values.forEach((c) => c.dispose());
                              _remediationCheckControllers.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: controllers['title'],
                      decoration: const InputDecoration(
                        labelText: 'Check Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _hasUnsavedChanges = true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: controllers['description'],
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Check Description',
                        hintText: 'Describe how to verify this remediation step',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => _hasUnsavedChanges = true,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: controllers['command'],
                      decoration: const InputDecoration(
                        labelText: 'Verification Command (Optional)',
                        hintText: 'e.g., nmap -p 443 target.com',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                      onChanged: (_) => _hasUnsavedChanges = true,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _remediationCheckControllers.add({
                  'title': TextEditingController(),
                  'description': TextEditingController(),
                  'command': TextEditingController(),
                });
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Remediation Check'),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildInfoCard(
            'Effective Remediation Checks',
            Icons.checklist,
            '''
• Be specific and measurable
• Include exact commands or steps
• Define expected outcomes
• Consider automated verification
• Document rollback procedures
            ''',
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          // Severity indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getSeverityColor(_selectedSeverity).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _getSeverityColor(_selectedSeverity).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.warning,
                  size: 14,
                  color: _getSeverityColor(_selectedSeverity),
                ),
                const SizedBox(width: 4),
                Text(
                  _selectedSeverity.displayName.toUpperCase(),
                  style: TextStyle(
                    color: _getSeverityColor(_selectedSeverity),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // CVSS Score indicator
          if (_cvssScoreController.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Text(
                'CVSS: ${_cvssScoreController.text}',
                style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const Spacer(),
          // Action buttons
          TextButton(
            onPressed: _handleClose,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: AppSpacing.sm),
          ElevatedButton.icon(
            onPressed: _saveFinding,
            icon: const Icon(Icons.save),
            label: Text(widget.finding == null ? 'Create Finding' : 'Update Finding'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, String content) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content.trim(),
              style: TextStyle(fontSize: 12, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.critical:
        return Colors.red[900]!;
      case FindingSeverity.high:
        return Colors.red;
      case FindingSeverity.medium:
        return Colors.orange;
      case FindingSeverity.low:
        return Colors.yellow[700]!;
      case FindingSeverity.informational:
        return Colors.blue;
    }
  }

  void _updateSeverityFromCVSS(String cvssScore) {
    final score = double.tryParse(cvssScore);
    if (score != null) {
      setState(() {
        if (score >= 9.0) {
          _selectedSeverity = FindingSeverity.critical;
        } else if (score >= 7.0) {
          _selectedSeverity = FindingSeverity.high;
        } else if (score >= 4.0) {
          _selectedSeverity = FindingSeverity.medium;
        } else if (score > 0) {
          _selectedSeverity = FindingSeverity.low;
        } else {
          _selectedSeverity = FindingSeverity.informational;
        }
      });
    }
  }

  void _updateCVSSFromSeverity(FindingSeverity severity) {
    String score;
    switch (severity) {
      case FindingSeverity.critical:
        score = '9.5';
        break;
      case FindingSeverity.high:
        score = '7.5';
        break;
      case FindingSeverity.medium:
        score = '5.0';
        break;
      case FindingSeverity.low:
        score = '2.0';
        break;
      case FindingSeverity.informational:
        score = '0.0';
        break;
    }
    _cvssScoreController.text = score;
  }

  void _openCVSSCalculator() {
    // TODO: Implement CVSS calculator dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CVSS Calculator coming soon')),
    );
  }

  void _handleClose() {
    if (_hasUnsavedChanges) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text('You have unsaved changes. Are you sure you want to close?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Editing'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Discard Changes'),
            ),
          ],
        ),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _saveFinding() async {
    if (!_formKey.currentState!.validate()) {
      // Find the tab with validation error
      _tabController.animateTo(0);
      return;
    }

    // Compile further reading
    final furtherReading = _furtherReadingControllers
        .where((c) => c.text.isNotEmpty)
        .map((c) => c.text)
        .join('\n');

    // TODO: Compile remediation checks - need to add to Finding model
    // final remediationChecks = _remediationCheckControllers
    //     .where((check) => check['title']!.text.isNotEmpty)
    //     .map((check) => {
    //           'title': check['title']!.text,
    //           'description': check['description']!.text,
    //           'command': check['command']!.text,
    //         })
    //     .toList();

    final finding = Finding(
      id: widget.finding?.id ?? const Uuid().v4(),
      projectId: widget.projectId,
      title: _titleController.text,
      description: _descriptionMarkdown,
      cvssScore: double.tryParse(_cvssScoreController.text) ?? 0.0,
      cvssVector: _cvssVectorController.text.isEmpty ? null : _cvssVectorController.text,
      severity: _selectedSeverity,
      status: widget.finding?.status ?? FindingStatus.draft,
      furtherReading: furtherReading.isEmpty ? null : furtherReading,
      createdDate: widget.finding?.createdDate ?? DateTime.now(),
      updatedDate: DateTime.now(),
    );

    // Save the finding
    if (widget.finding == null) {
      await ref.read(findingProvider.notifier).createFinding(finding);
    } else {
      await ref.read(findingProvider.notifier).updateFinding(finding);
    }

    if (mounted) {
      Navigator.of(context).pop(finding);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.finding == null ? 'Finding created successfully' : 'Finding updated successfully'),
        ),
      );
    }
  }
}