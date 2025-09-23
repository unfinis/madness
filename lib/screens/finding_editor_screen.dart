import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/finding.dart';
import '../models/finding_template.dart';
import '../models/screenshot.dart';
import '../providers/finding_provider.dart';
import '../providers/projects_provider.dart';
import '../providers/template_provider.dart';
import '../providers/screenshot_providers.dart';
import '../widgets/cvss_calculator_dialog.dart';
import '../widgets/template_selection_dialog.dart';
import '../dialogs/add_component_dialog.dart';
import '../dialogs/add_link_dialog.dart';
import '../dialogs/screenshot_selection_dialog.dart';

class FindingEditorScreen extends ConsumerStatefulWidget {
  final Finding? finding;

  const FindingEditorScreen({
    super.key,
    this.finding,
  });

  @override
  ConsumerState<FindingEditorScreen> createState() => _FindingEditorScreenState();
}

class _FindingEditorScreenState extends ConsumerState<FindingEditorScreen>
    with TickerProviderStateMixin {
  
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  bool _hasUnsavedChanges = false;
  
  // Form controllers
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cvssScoreController;
  late TextEditingController _cvssVectorController;
  late TextEditingController _auditStepsController;
  late TextEditingController _automatedScriptController;
  late TextEditingController _furtherReadingController;
  late TextEditingController _verificationController;
  
  // Form state
  FindingSeverity _selectedSeverity = FindingSeverity.medium;
  FindingStatus _selectedStatus = FindingStatus.draft;
  List<FindingComponent> _components = [];
  List<FindingLink> _links = [];
  List<String> _screenshotIds = [];
  
  @override
  void initState() {
    super.initState();
    final isMainFinding = widget.finding?.isMainFinding ?? false;
    _tabController = TabController(length: isMainFinding ? 7 : 6, vsync: this);
    
    // Initialize controllers with existing data if editing
    final finding = widget.finding;
    _titleController = TextEditingController(text: finding?.title ?? '');
    _descriptionController = TextEditingController(text: finding?.description ?? '');
    _cvssScoreController = TextEditingController(text: finding?.cvssScore.toString() ?? '');
    _cvssVectorController = TextEditingController(text: finding?.cvssVector ?? '');
    _auditStepsController = TextEditingController(text: finding?.auditSteps ?? '');
    _automatedScriptController = TextEditingController(text: finding?.automatedScript ?? '');
    _furtherReadingController = TextEditingController(text: finding?.furtherReading ?? '');
    _verificationController = TextEditingController(text: finding?.verificationProcedure ?? '');
    
    if (finding != null) {
      _selectedSeverity = finding.severity;
      _selectedStatus = finding.status;
      _components = List.from(finding.components);
      _links = List.from(finding.links);
      _screenshotIds = List.from(finding.screenshotIds);
    }
    
    // Listen for changes
    _setupChangeListeners();
  }
  
  void _setupChangeListeners() {
    final controllers = [
      _titleController,
      _descriptionController,
      _cvssScoreController,
      _cvssVectorController,
      _auditStepsController,
      _automatedScriptController,
      _furtherReadingController,
      _verificationController,
    ];
    
    for (final controller in controllers) {
      controller.addListener(_markAsChanged);
    }
  }
  
  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _cvssScoreController.dispose();
    _cvssVectorController.dispose();
    _auditStepsController.dispose();
    _automatedScriptController.dispose();
    _furtherReadingController.dispose();
    _verificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.finding != null;
    
    return PopScope(
      canPop: !_hasUnsavedChanges,
      onPopInvoked: (didPop) async {
        if (!didPop && _hasUnsavedChanges) {
          final shouldPop = await _showDiscardDialog();
          if (shouldPop == true && context.mounted) {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: _buildAppBar(context, isEditing),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    const Tab(text: 'Basic Info'),
                    const Tab(text: 'Audit Steps'),
                    const Tab(text: 'Components'),
                    const Tab(text: 'References'),
                    const Tab(text: 'Screenshots'),
                    const Tab(text: 'Verification'),
                    if (widget.finding?.isMainFinding ?? false)
                      const Tab(text: 'Sub-Findings'),
                  ],
                ),
              ),
              
              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBasicInfoTab(),
                    _buildAuditStepsTab(),
                    _buildComponentsTab(),
                    _buildReferencesTab(),
                    _buildScreenshotsTab(),
                    _buildVerificationTab(),
                    if (widget.finding?.isMainFinding ?? false)
                      _buildSubFindingsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context, isEditing),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isEditing) {
    return AppBar(
      title: Row(
        children: [
          Text(isEditing ? 'Edit Finding' : 'New Finding'),
          if (_hasUnsavedChanges) ...[
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!isEditing) // Only show template button for new findings
          TextButton.icon(
            onPressed: _useTemplate,
            icon: const Icon(Icons.document_scanner_outlined),
            label: const Text('Use Template'),
          ),
        TextButton(
          onPressed: _hasUnsavedChanges ? _saveFinding : null,
          child: Text(
            'Save',
            style: TextStyle(
              color: _hasUnsavedChanges 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'e.g., SQL Injection in Login Form',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Title is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Description
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe the security issue in detail...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Description is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // CVSS Score and Calculator
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _cvssScoreController,
                  decoration: const InputDecoration(
                    labelText: 'CVSS Score',
                    hintText: 'e.g., 7.5',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'CVSS Score is required';
                    }
                    final score = double.tryParse(value);
                    if (score == null || score < 0 || score > 10) {
                      return 'Enter a valid score (0.0-10.0)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _updateSeverityFromScore();
                    _markAsChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _openCVSSCalculator,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Calculator'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // CVSS Vector
          TextFormField(
            controller: _cvssVectorController,
            decoration: const InputDecoration(
              labelText: 'CVSS Vector (Optional)',
              hintText: 'CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(fontFamily: 'monospace'),
          ),
          const SizedBox(height: 16),
          
          // Severity and Status
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<FindingSeverity>(
                  value: _selectedSeverity,
                  decoration: const InputDecoration(
                    labelText: 'Severity',
                    border: OutlineInputBorder(),
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
                              color: severity.color,
                              borderRadius: BorderRadius.circular(6),
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
                      });
                      _markAsChanged();
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<FindingStatus>(
                  value: _selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: FindingStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: status.color,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(status.displayName),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                      _markAsChanged();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuditStepsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audit Steps',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Step-by-step instructions for identifying and auditing this issue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _auditStepsController,
            decoration: const InputDecoration(
              hintText: 'Enter audit steps...\n\n1. Navigate to...\n2. Check for...\n3. Take screenshot...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 8,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Automated Script',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'PowerShell, bash, or other scripts to automatically check for this issue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _automatedScriptController,
            decoration: const InputDecoration(
              hintText: '# PowerShell script\nGet-Process | Where-Object...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            style: const TextStyle(fontFamily: 'monospace'),
            maxLines: 6,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Further Reading',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Additional information, remediation steps, or context.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _furtherReadingController,
            decoration: const InputDecoration(
              hintText: 'Enter additional information...',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Affected Components',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _addComponent,
                icon: const Icon(Icons.add),
                label: const Text('Add Component'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Components affected by this security finding.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          
          if (_components.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.computer,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No components added yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add components like URLs, hostnames, or services affected by this finding',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._components.asMap().entries.map((entry) {
              final index = entry.key;
              final component = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      component.type.displayName,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  title: Text(component.name),
                  subtitle: Text(component.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeComponent(index),
                  ),
                  onTap: () => _editComponent(index),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildReferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reference Links',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _addLink,
                icon: const Icon(Icons.add),
                label: const Text('Add Link'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'External references and documentation links.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          
          if (_links.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.link,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No links added yet',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add reference links to external documentation, advisories, or remediation guides',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ..._links.asMap().entries.map((entry) {
              final index = entry.key;
              final link = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.link),
                  title: Text(link.title),
                  subtitle: Text(
                    link.url,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeLink(index),
                  ),
                  onTap: () => _editLink(index),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildVerificationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verification Procedure',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Steps to verify that remediation has been successfully implemented.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _verificationController,
            decoration: const InputDecoration(
              hintText: 'Enter verification steps...\n\n1. Navigate to settings\n2. Verify configuration\n3. Test functionality\n4. Document results',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildScreenshotsTab() {
    final currentProject = ref.watch(currentProjectProvider);
    if (currentProject == null) return const SizedBox();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header section with better styling
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF667EEA),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.photo_camera,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Screenshots & Evidence',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF333333),
                        ),
                      ),
                      Text(
                        'Visual proof and evidence for this security finding',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ],
                  ),
                ),
                FilledButton.icon(
                  onPressed: _selectScreenshots,
                  icon: const Icon(Icons.add_photo_alternate, size: 18),
                  label: const Text('Add Screenshots'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF667EEA),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          if (_screenshotIds.isEmpty)
            _buildEmptyScreenshotsState()
          else
            _buildScreenshotGrid(),
        ],
      ),
    );
  }

  Widget _buildEmptyScreenshotsState() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFF667EEA),
          width: 3,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF8F9FF),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No screenshots added yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Click "Add Screenshots" to upload visual evidence\nSupports PNG, JPG, GIF • Multiple files supported',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF666666),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildScreenshotGrid() {
    final currentProject = ref.watch(currentProjectProvider);
    if (currentProject == null) return const SizedBox();
    
    return Consumer(
      builder: (context, ref, child) {
        final screenshotsAsync = ref.watch(projectScreenshotsProvider(currentProject.id));
        
        return screenshotsAsync.when(
          data: (screenshots) {
            final linkedScreenshots = screenshots
                .where((s) => _screenshotIds.contains(s.id))
                .toList();
                
            return LayoutBuilder(
              builder: (context, constraints) {
                // Responsive grid - matches wireframe behavior
                final crossAxisCount = constraints.maxWidth > 900 
                    ? 3 
                    : constraints.maxWidth > 600 
                        ? 2 
                        : 1;
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.3, // Slightly wider cards like wireframe
                  ),
                  itemCount: linkedScreenshots.length,
                  itemBuilder: (context, index) {
                    final screenshot = linkedScreenshots[index];
                    return _buildScreenshotCard(screenshot);
                  },
                );
              },
            );
          },
          loading: () => Container(
            padding: const EdgeInsets.all(32),
            child: const Center(child: CircularProgressIndicator()),
          ),
          error: (error, stackTrace) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Error loading screenshots: $error',
                    style: TextStyle(color: Colors.red.shade800),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildScreenshotCard(Screenshot screenshot) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFE0E0E0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail section
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildScreenshotThumbnail(screenshot),
                    
                    // Overlay actions
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.visibility, size: 16),
                              onPressed: () => _viewScreenshot(screenshot),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              color: Colors.white,
                              tooltip: 'View screenshot',
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () => _removeScreenshot(screenshot.id),
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(
                                minWidth: 32,
                                minHeight: 32,
                              ),
                              color: Colors.white,
                              tooltip: 'Remove screenshot',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Info section - matches wireframe styling
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and filename
                  Text(
                    screenshot.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description if available
                  if (screenshot.description.isNotEmpty) ...[
                    Text(
                      screenshot.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    Text(
                      'No caption provided',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF999999),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Metadata row
                  Row(
                    children: [
                      // Dimensions badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF667EEA).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${screenshot.width}×${screenshot.height}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF667EEA),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      // File size badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF28A745).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatFileSize(screenshot.fileSize),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF28A745),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  void _viewScreenshot(Screenshot screenshot) {
    // TODO: Implement screenshot viewer dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(screenshot.name),
        content: Text('Screenshot viewer not yet implemented'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScreenshotThumbnail(Screenshot screenshot) {
    final theme = Theme.of(context);
    final imagePath = screenshot.thumbnailPath ?? screenshot.originalPath;
    
    if (imagePath.isEmpty) {
      return Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      );
    }

    final file = File(imagePath);
    if (file.existsSync()) {
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.broken_image,
              size: 48,
              color: theme.colorScheme.error.withOpacity(0.5),
            ),
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            size: 32,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 4),
          Text(
            'Not found',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _selectScreenshots() async {
    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) return;
    
    final selectedIds = await showDialog<List<String>>(
      context: context,
      builder: (context) => ScreenshotSelectionDialog(
        projectId: currentProject.id,
        selectedScreenshotIds: _screenshotIds,
        allowMultipleSelection: true,
      ),
    );
    
    if (selectedIds != null) {
      setState(() {
        _screenshotIds = selectedIds;
        _markAsChanged();
      });
    }
  }
  
  void _removeScreenshot(String screenshotId) {
    setState(() {
      _screenshotIds.remove(screenshotId);
      _markAsChanged();
    });
  }

  Widget _buildSubFindingsTab() {
    final finding = widget.finding;
    if (finding == null || !finding.isMainFinding) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_tree,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Sub-Findings Hierarchy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${finding.subFindings.length} sub-findings',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This main finding was created from multiple sub-findings. View details below.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),

          if (finding.subFindings.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No sub-findings data available',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This finding may have been created manually rather than from a template',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          else
            ...finding.subFindings.asMap().entries.map((entry) {
              final index = entry.key;
              final subFinding = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: subFinding.severity.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: subFinding.severity.color.withOpacity(0.3)),
                    ),
                    child: Text(
                      subFinding.severity.displayName,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: subFinding.severity.color,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          subFinding.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: subFinding.severity.color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'CVSS ${subFinding.cvssScore.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: subFinding.severity.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: subFinding.description.isNotEmpty
                      ? Text(
                          subFinding.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        )
                      : null,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (subFinding.description.isNotEmpty) ...[
                            Text(
                              'Description',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subFinding.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          if (subFinding.checkSteps?.isNotEmpty == true) ...[
                            Text(
                              'Check Steps',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                subFinding.checkSteps!,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          if (subFinding.recommendation?.isNotEmpty == true) ...[
                            Text(
                              'Recommendation',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subFinding.recommendation!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          if (subFinding.verificationProcedure != null && subFinding.verificationProcedure!.isNotEmpty) ...[
                            Text(
                              'Verification',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subFinding.verificationProcedure!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                          ],
                          
                          if (subFinding.links.isNotEmpty) ...[
                            Text(
                              'Links',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...subFinding.links.map((link) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.link,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      link.title,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, bool isEditing) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
          TextButton(
            onPressed: () async {
              if (_hasUnsavedChanges) {
                final shouldDiscard = await _showDiscardDialog();
                if (shouldDiscard == true && context.mounted) {
                  Navigator.of(context).pop();
                }
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text('Cancel'),
          ),
          const Spacer(),
          FilledButton(
            onPressed: _hasUnsavedChanges ? _saveFinding : null,
            child: Text(isEditing ? 'Update Finding' : 'Create Finding'),
          ),
        ],
      ),
    );
  }

  void _updateSeverityFromScore() {
    final scoreText = _cvssScoreController.text;
    final score = double.tryParse(scoreText);
    if (score != null) {
      final newSeverity = FindingSeverity.fromScore(score);
      if (newSeverity != _selectedSeverity) {
        setState(() {
          _selectedSeverity = newSeverity;
        });
      }
    }
  }

  void _openCVSSCalculator() {
    showDialog(
      context: context,
      builder: (context) => CVSSCalculatorDialog(
        initialVector: _cvssVectorController.text,
        onCalculated: (score, vector) {
          setState(() {
            _cvssScoreController.text = score.toStringAsFixed(1);
            _cvssVectorController.text = vector;
            _selectedSeverity = FindingSeverity.fromScore(score);
          });
          _markAsChanged();
        },
      ),
    );
  }

  void _addComponent() async {
    final result = await showDialog<FindingComponent>(
      context: context,
      builder: (context) => const AddComponentDialog(),
    );
    
    if (result != null) {
      setState(() {
        _components.add(result);
      });
      _markAsChanged();
    }
  }

  void _editComponent(int index) async {
    final result = await showDialog<FindingComponent>(
      context: context,
      builder: (context) => AddComponentDialog(component: _components[index]),
    );
    
    if (result != null) {
      setState(() {
        _components[index] = result;
      });
      _markAsChanged();
    }
  }

  void _removeComponent(int index) {
    setState(() {
      _components.removeAt(index);
    });
    _markAsChanged();
  }

  void _addLink() async {
    final result = await showDialog<FindingLink>(
      context: context,
      builder: (context) => const AddLinkDialog(),
    );
    
    if (result != null) {
      setState(() {
        _links.add(result);
      });
      _markAsChanged();
    }
  }

  void _editLink(int index) async {
    final result = await showDialog<FindingLink>(
      context: context,
      builder: (context) => AddLinkDialog(link: _links[index]),
    );
    
    if (result != null) {
      setState(() {
        _links[index] = result;
      });
      _markAsChanged();
    }
  }

  void _removeLink(int index) {
    setState(() {
      _links.removeAt(index);
    });
    _markAsChanged();
  }

  Future<void> _useTemplate() async {
    try {
      // Show template selection dialog
      final selectedTemplate = await showTemplateSelectionDialog(context);
      if (selectedTemplate == null) return;

      // Ask user if they want to add all findings or just one
      final addAll = await _showTemplateOptionsDialog(selectedTemplate);
      if (addAll == null) return;

      // Load the template and create findings
      final templateNotifier = ref.read(templateProvider.notifier);
      final template = await templateNotifier.loadTemplateById(selectedTemplate.id);
      if (template == null) {
        throw Exception('Failed to load template');
      }

      if (addAll) {
        // Add all findings from template to the database
        final findings = template.toFindings();
        final currentProject = ref.read(currentProjectProvider);
        if (currentProject == null) {
          throw Exception('No project selected');
        }

        final findingProviderNotifier = ref.read(findingProvider.notifier);
        for (final finding in findings) {
          final updatedFinding = finding.copyWith(projectId: currentProject.id);
          await findingProviderNotifier.createFinding(updatedFinding);
        }

        // Show success message and close editor
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${findings.length} findings created from template "${template.title}"'),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
        }
      } else {
        // Let user select which finding to use for this editor
        final selectedSubFinding = await _showSubFindingSelectionDialog(template);
        if (selectedSubFinding == null) return;

        // Apply the selected sub-finding to the current form
        _applyTemplateToForm(selectedSubFinding, template);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Template "${selectedSubFinding.title}" applied'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error applying template: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<bool?> _showTemplateOptionsDialog(TemplateInfo templateInfo) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Use Template'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Template: ${templateInfo.title}'),
            const SizedBox(height: 8),
            Text('This template contains ${templateInfo.findingCount} findings.'),
            const SizedBox(height: 16),
            const Text('How would you like to use this template?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Use One Finding'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Add All Findings'),
          ),
        ],
      ),
    );
  }

  Future<SubFinding?> _showSubFindingSelectionDialog(FindingTemplate template) {
    return showDialog<SubFinding>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Finding'),
        content: SizedBox(
          width: 400,
          height: 300,
          child: ListView.builder(
            itemCount: template.subFindings.length,
            itemBuilder: (context, index) {
              final subFinding = template.subFindings[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getSeverityColor(subFinding.severity),
                  child: Text(
                    subFinding.severity.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(subFinding.title),
                subtitle: Text('CVSS: ${subFinding.cvssScore}'),
                onTap: () => Navigator.of(context).pop(subFinding),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red[900]!;
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow[700]!;
      case 'informational':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _applyTemplateToForm(SubFinding subFinding, FindingTemplate template) {
    setState(() {
      _titleController.text = subFinding.title;
      _descriptionController.text = subFinding.description;
      _cvssScoreController.text = subFinding.cvssScore.toString();
      _cvssVectorController.text = subFinding.cvssVector;
      _auditStepsController.text = subFinding.checkSteps;
      _verificationController.text = subFinding.verificationProcedure ?? '';
      
      // Apply recommendation to further reading
      _furtherReadingController.text = subFinding.recommendation;
      
      // Set severity based on the string value
      switch (subFinding.severity.toLowerCase()) {
        case 'critical':
          _selectedSeverity = FindingSeverity.critical;
          break;
        case 'high':
          _selectedSeverity = FindingSeverity.high;
          break;
        case 'medium':
          _selectedSeverity = FindingSeverity.medium;
          break;
        case 'low':
          _selectedSeverity = FindingSeverity.low;
          break;
        case 'informational':
        case 'info':
          _selectedSeverity = FindingSeverity.informational;
          break;
      }

      // Add links
      _links = List.from(subFinding.links);
      
      _hasUnsavedChanges = true;
    });
  }

  Future<void> _saveFinding() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final currentProject = ref.read(currentProjectProvider);
      if (currentProject == null) {
        throw Exception('No project selected');
      }

      final score = double.parse(_cvssScoreController.text);
      final finding = Finding(
        id: widget.finding?.id ?? '',
        projectId: currentProject.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        cvssScore: score,
        cvssVector: _cvssVectorController.text.trim().isEmpty 
            ? null 
            : _cvssVectorController.text.trim(),
        severity: _selectedSeverity,
        status: _selectedStatus,
        auditSteps: _auditStepsController.text.trim().isEmpty 
            ? null 
            : _auditStepsController.text.trim(),
        automatedScript: _automatedScriptController.text.trim().isEmpty 
            ? null 
            : _automatedScriptController.text.trim(),
        furtherReading: _furtherReadingController.text.trim().isEmpty 
            ? null 
            : _furtherReadingController.text.trim(),
        verificationProcedure: _verificationController.text.trim().isEmpty 
            ? null 
            : _verificationController.text.trim(),
        createdDate: widget.finding?.createdDate ?? DateTime.now(),
        updatedDate: DateTime.now(),
        components: _components,
        links: _links,
        screenshotIds: _screenshotIds,
      );

      final provider = ref.read(findingProvider.notifier);
      if (widget.finding == null) {
        await provider.createFinding(finding);
      } else {
        await provider.updateFinding(finding);
      }

      setState(() {
        _hasUnsavedChanges = false;
      });

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.finding == null 
                ? 'Finding created successfully' 
                : 'Finding updated successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving finding: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Changes?'),
        content: const Text('You have unsaved changes. Are you sure you want to discard them?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}