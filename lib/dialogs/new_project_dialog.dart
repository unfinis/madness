import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';

class NewProjectDialog extends ConsumerStatefulWidget {
  const NewProjectDialog({super.key});

  @override
  ConsumerState<NewProjectDialog> createState() => _NewProjectDialogState();
}

class _NewProjectDialogState extends ConsumerState<NewProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _projectNameController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _contactEmailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _projectRefController = TextEditingController();
  
  String _selectedProjectType = 'Internal Network Assessment';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  bool _includePhysicalAccess = false;
  bool _includeRemoteAccess = false;
  bool _includeWirelessAssessment = false;
  bool _includeSocialEngineering = false;
  
  final List<String> _projectTypes = [
    'Internal Network Assessment',
    'External Network Assessment',
    'Web Application Assessment',
    'Mobile Application Assessment',
    'Wireless Assessment',
    'Social Engineering Assessment',
    'Physical Assessment',
    'Red Team Exercise',
    'Vulnerability Assessment',
    'Compliance Assessment',
  ];

  @override
  void initState() {
    super.initState();
    _projectNameController.addListener(_generateProjectRef);
  }

  void _generateProjectRef() {
    final projectName = _projectNameController.text;
    if (projectName.isNotEmpty) {
      final typePrefix = _getTypePrefix(_selectedProjectType);
      final year = DateTime.now().year;
      final randomNum = (DateTime.now().millisecondsSinceEpoch % 900) + 100;
      final projectRef = '$typePrefix-$year-$randomNum';
      _projectRefController.text = projectRef;
    } else {
      _projectRefController.clear();
    }
  }

  String _getTypePrefix(String projectType) {
    switch (projectType) {
      case 'Internal Network Assessment':
        return 'INA';
      case 'External Network Assessment':
        return 'ENA';
      case 'Web Application Assessment':
        return 'WEB';
      case 'Mobile Application Assessment':
        return 'MOB';
      case 'Wireless Assessment':
        return 'WLS';
      case 'Social Engineering Assessment':
        return 'SOC';
      case 'Physical Assessment':
        return 'PHY';
      case 'Red Team Exercise':
        return 'RED';
      case 'Vulnerability Assessment':
        return 'VUL';
      case 'Compliance Assessment':
        return 'COM';
      default:
        return 'PRJ';
    }
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _clientNameController.dispose();
    _contactPersonController.dispose();
    _contactEmailController.dispose();
    _descriptionController.dispose();
    _projectRefController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Create New Project',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Name and Reference
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _projectNameController,
                              decoration: InputDecoration(
                                labelText: 'Project Name *',
                                hintText: 'Enter project name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a project name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _projectRefController,
                              decoration: InputDecoration(
                                labelText: 'Project Reference',
                                hintText: 'Auto-generated',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
                                filled: true,
                              ),
                              readOnly: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Client Details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _clientNameController,
                              decoration: InputDecoration(
                                labelText: 'Client Name *',
                                hintText: 'Client company name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter client name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedProjectType,
                              decoration: InputDecoration(
                                labelText: 'Project Type *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: _projectTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type, style: const TextStyle(fontSize: 14)),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedProjectType = value!;
                                  _generateProjectRef();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Contact Details
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _contactPersonController,
                              decoration: InputDecoration(
                                labelText: 'Contact Person',
                                hintText: 'Primary contact name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _contactEmailController,
                              decoration: InputDecoration(
                                labelText: 'Contact Email',
                                hintText: 'contact@client.com',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Date Range
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Start Date *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _startDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _startDate = date;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'End Date *',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate,
                                    firstDate: _startDate,
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      _endDate = date;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const Icon(Icons.calendar_today, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      TextFormField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Project Description',
                          hintText: 'Brief description of the engagement scope and objectives',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      
                      // Assessment Scope
                      Text(
                        'Assessment Scope',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        title: const Text('Physical Access Assessment'),
                        subtitle: const Text('On-site physical security testing'),
                        value: _includePhysicalAccess,
                        onChanged: (value) {
                          setState(() {
                            _includePhysicalAccess = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Remote Access Assessment'),
                        subtitle: const Text('VPN, RDP, and remote service testing'),
                        value: _includeRemoteAccess,
                        onChanged: (value) {
                          setState(() {
                            _includeRemoteAccess = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Wireless Assessment'),
                        subtitle: const Text('Wi-Fi and wireless infrastructure testing'),
                        value: _includeWirelessAssessment,
                        onChanged: (value) {
                          setState(() {
                            _includeWirelessAssessment = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      CheckboxListTile(
                        title: const Text('Social Engineering'),
                        subtitle: const Text('Phishing and social engineering campaigns'),
                        value: _includeSocialEngineering,
                        onChanged: (value) {
                          setState(() {
                            _includeSocialEngineering = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(color: theme.dividerColor),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _createProject();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Create Project'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createProject() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Create the project
      final project = await ref.read(projectsProvider.notifier).createProject(
        name: _projectNameController.text,
        clientName: _clientNameController.text,
        projectType: _selectedProjectType,
        startDate: _startDate,
        endDate: _endDate,
        contactPerson: _contactPersonController.text.isNotEmpty 
            ? _contactPersonController.text 
            : null,
        contactEmail: _contactEmailController.text.isNotEmpty 
            ? _contactEmailController.text 
            : null,
        description: _descriptionController.text.isNotEmpty 
            ? _descriptionController.text 
            : null,
        assessmentScope: {
          'physicalAccess': _includePhysicalAccess,
          'remoteAccess': _includeRemoteAccess,
          'wirelessAssessment': _includeWirelessAssessment,
          'socialEngineering': _includeSocialEngineering,
        },
      );

      // Set as current project
      await ref.read(currentProjectProvider.notifier).setCurrentProject(project);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Close the project dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Project "${project.name}" created successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();
      
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating project: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }
}