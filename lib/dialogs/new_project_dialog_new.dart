import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../widgets/dialogs/dialog_system.dart';
import '../widgets/dialogs/dialog_components.dart';
import '../widgets/dialogs/dialog_utils.dart';
import '../constants/app_spacing.dart';

class NewProjectDialog extends StandardDialog {
  const NewProjectDialog({super.key})
      : super(
          title: 'Create New Project',
          subtitle: 'Set up a new penetration testing project',
          icon: Icons.add_box_rounded,
          size: DialogSize.large,
          maxHeight: 800,
        );

  @override
  List<Widget> buildContent(BuildContext context) {
    return [
      const _NewProjectForm(),
    ];
  }
}

class _NewProjectForm extends ConsumerStatefulWidget {
  const _NewProjectForm();

  @override
  ConsumerState<_NewProjectForm> createState() => _NewProjectFormState();
}

class _NewProjectFormState extends ConsumerState<_NewProjectForm> {
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
  bool _isSubmitting = false;

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
  Widget build(BuildContext context) {
    return DialogUtils.withKeyboardShortcuts(
      onEscape: () => Navigator.of(context).pop(),
      onEnter: () => _createProject(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Information Section
            DialogComponents.buildFormSection(
              context: context,
              title: 'Project Information',
              icon: Icons.info_rounded,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: DialogComponents.buildTextField(
                        context: context,
                        label: 'Project Name',
                        controller: _projectNameController,
                        hintText: 'Enter project name',
                        prefixIcon: Icons.folder_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a project name';
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.hGapLG,
                    Expanded(
                      child: DialogComponents.buildTextField(
                        context: context,
                        label: 'Project Reference',
                        controller: _projectRefController,
                        hintText: 'Auto-generated',
                        prefixIcon: Icons.tag_rounded,
                        readOnly: true,
                        helperText: 'Automatically generated based on project name and type',
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapLG,
                Row(
                  children: [
                    Expanded(
                      child: DialogComponents.buildTextField(
                        context: context,
                        label: 'Client Name',
                        controller: _clientNameController,
                        hintText: 'Client company name',
                        prefixIcon: Icons.business_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter client name';
                          }
                          return null;
                        },
                      ),
                    ),
                    AppSpacing.hGapLG,
                    Expanded(
                      child: DialogComponents.buildDropdownField<String>(
                        context: context,
                        label: 'Project Type',
                        value: _selectedProjectType,
                        items: _projectTypes,
                        prefixIcon: Icons.assessment_rounded,
                        itemBuilder: (type) => Text(type, style: const TextStyle(fontSize: 14)),
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
                AppSpacing.vGapLG,
                DialogComponents.buildTextField(
                  context: context,
                  label: 'Project Description',
                  controller: _descriptionController,
                  hintText: 'Brief description of the engagement scope and objectives',
                  prefixIcon: Icons.description_rounded,
                  maxLines: 3,
                  minLines: 2,
                ),
              ],
            ),

            AppSpacing.vGapXL,

            // Client Contact Section
            DialogComponents.buildFormSection(
              context: context,
              title: 'Client Contact Information',
              icon: Icons.contact_phone_rounded,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DialogComponents.buildTextField(
                        context: context,
                        label: 'Contact Person',
                        controller: _contactPersonController,
                        hintText: 'Primary contact name',
                        prefixIcon: Icons.person_rounded,
                      ),
                    ),
                    AppSpacing.hGapLG,
                    Expanded(
                      child: DialogComponents.buildTextField(
                        context: context,
                        label: 'Contact Email',
                        controller: _contactEmailController,
                        hintText: 'contact@client.com',
                        prefixIcon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),

            AppSpacing.vGapXL,

            // Project Timeline Section
            DialogComponents.buildFormSection(
              context: context,
              title: 'Project Timeline',
              icon: Icons.schedule_rounded,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DialogComponents.buildDateField(
                        context: context,
                        label: 'Start Date',
                        selectedDate: _startDate,
                        onDateSelected: (date) {
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                              // Ensure end date is after start date
                              if (_endDate.isBefore(_startDate)) {
                                _endDate = _startDate.add(const Duration(days: 30));
                              }
                            });
                          }
                        },
                        firstDate: DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                    ),
                    AppSpacing.hGapLG,
                    Expanded(
                      child: DialogComponents.buildDateField(
                        context: context,
                        label: 'End Date',
                        selectedDate: _endDate,
                        onDateSelected: (date) {
                          if (date != null) {
                            setState(() {
                              _endDate = date;
                            });
                          }
                        },
                        firstDate: _startDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      ),
                    ),
                  ],
                ),
                AppSpacing.vGapMD,
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppSizes.cardRadius),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: AppSizes.iconMD,
                      ),
                      AppSpacing.hGapSM,
                      Expanded(
                        child: Text(
                          'Duration: ${_endDate.difference(_startDate).inDays + 1} days',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            AppSpacing.vGapXL,

            // Assessment Scope Section
            DialogComponents.buildFormSection(
              context: context,
              title: 'Assessment Scope',
              icon: Icons.checklist_rounded,
              children: [
                _buildScopeCheckbox(
                  title: 'Physical Access Assessment',
                  subtitle: 'On-site physical security testing',
                  value: _includePhysicalAccess,
                  onChanged: (value) => setState(() => _includePhysicalAccess = value ?? false),
                  icon: Icons.security_rounded,
                ),
                AppSpacing.vGapSM,
                _buildScopeCheckbox(
                  title: 'Remote Access Assessment',
                  subtitle: 'VPN, RDP, and remote service testing',
                  value: _includeRemoteAccess,
                  onChanged: (value) => setState(() => _includeRemoteAccess = value ?? false),
                  icon: Icons.vpn_key_rounded,
                ),
                AppSpacing.vGapSM,
                _buildScopeCheckbox(
                  title: 'Wireless Assessment',
                  subtitle: 'Wi-Fi and wireless infrastructure testing',
                  value: _includeWirelessAssessment,
                  onChanged: (value) => setState(() => _includeWirelessAssessment = value ?? false),
                  icon: Icons.wifi_rounded,
                ),
                AppSpacing.vGapSM,
                _buildScopeCheckbox(
                  title: 'Social Engineering',
                  subtitle: 'Phishing and social engineering campaigns',
                  value: _includeSocialEngineering,
                  onChanged: (value) => setState(() => _includeSocialEngineering = value ?? false),
                  icon: Icons.psychology_rounded,
                ),
              ],
            ),

            AppSpacing.vGapXL,

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: DialogComponents.buildSecondaryButton(
                    context: context,
                    text: 'Cancel',
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    icon: Icons.close_rounded,
                  ),
                ),
                AppSpacing.hGapLG,
                Expanded(
                  child: DialogComponents.buildPrimaryButton(
                    context: context,
                    text: 'Create Project',
                    onPressed: _isSubmitting ? null : _createProject,
                    icon: Icons.add_rounded,
                    isLoading: _isSubmitting,
                    loadingText: 'Creating...',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScopeCheckbox({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: value
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Theme.of(context).colorScheme.surfaceContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: value
              ? Theme.of(context).colorScheme.primary.withOpacity(0.5)
              : Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Icon(
              icon,
              size: AppSizes.iconMD,
              color: value
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            AppSpacing.hGapSM,
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: value
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(left: AppSizes.iconMD + AppSpacing.sm),
          child: Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        ),
      ),
    );
  }

  void _createProject() async {
    if (!_formKey.currentState?.validate() ?? false) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Show loading feedback
      DialogUtils.triggerHapticFeedback(HapticFeedbackType.medium);

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

      if (mounted) {
        // Announce success to screen readers
        DialogUtils.announceToScreenReader(
          context,
          'Project ${project.name} created successfully',
        );

        Navigator.of(context).pop();

        // Show success feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: AppSizes.iconMD),
                AppSpacing.hGapSM,
                Expanded(child: Text('Project "${project.name}" created successfully')),
              ],
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
            ),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () {
                // TODO: Navigate to project dashboard
              },
            ),
          ),
        );

        DialogUtils.triggerHapticFeedback(HapticFeedbackType.light);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        DialogUtils.announceToScreenReader(
          context,
          'Error creating project: ${e.toString()}',
          assertiveness: Assertiveness.assertive,
        );

        await DialogUtils.showErrorDialog(
          context: context,
          title: 'Project Creation Failed',
          message: 'Unable to create the project. Please try again.',
          details: e.toString(),
          onRetry: _createProject,
        );

        DialogUtils.triggerHapticFeedback(HapticFeedbackType.heavy);
      }
    }
  }
}

// Convenience function to show the dialog
Future<void> showNewProjectDialog(BuildContext context) {
  return showStandardDialog(
    context: context,
    dialog: const NewProjectDialog(),
    animationType: DialogAnimationType.scaleAndFade,
  );
}