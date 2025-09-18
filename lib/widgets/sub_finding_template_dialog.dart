import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding_template.dart';
import '../models/finding.dart';
import '../models/screenshot.dart';
import '../providers/template_provider.dart';
import '../providers/projects_provider.dart';
import '../providers/finding_provider.dart';
import '../providers/database_provider.dart';
import 'sub_finding_selection_widget.dart';

class SubFindingTemplateDialog extends ConsumerStatefulWidget {
  const SubFindingTemplateDialog({super.key});

  @override
  ConsumerState<SubFindingTemplateDialog> createState() => _SubFindingTemplateDialogState();
}

class _SubFindingTemplateDialogState extends ConsumerState<SubFindingTemplateDialog> {
  TemplateInfo? _selectedTemplate;
  FindingTemplate? _loadedTemplate;
  Set<int> _selectedSubFindings = {};
  bool _isLoading = false;
  String? _error;

  Future<void> _loadTemplate(TemplateInfo templateInfo) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _selectedSubFindings.clear();
    });

    try {
      final templateNotifier = ref.read(templateProvider.notifier);
      final template = await templateNotifier.loadTemplateById(templateInfo.id);
      
      if (template != null) {
        setState(() {
          _loadedTemplate = template;
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load template';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _applyTemplate() async {
    if (_selectedTemplate == null || _loadedTemplate == null || _selectedSubFindings.isEmpty) {
      return;
    }

    final currentProject = ref.read(currentProjectProvider);
    if (currentProject == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No project selected')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final templateNotifier = ref.read(templateProvider.notifier);
      final template = await templateNotifier.loadTemplateById(_selectedTemplate!.id);
      if (template == null) {
        throw Exception('Failed to load template');
      }

      // Get selected sub-findings
      final selectedSubFindings = _selectedSubFindings
          .map((index) => template.subFindings[index])
          .toList();

      // Calculate overall CVSS score (use highest score like wireframe)
      double overallScore = selectedSubFindings
          .map((sf) => sf.cvssScore)
          .reduce((a, b) => a > b ? a : b);

      // Use the CVSS vector from the highest scoring sub-finding
      String? overallVector;
      for (final sf in selectedSubFindings) {
        if (sf.cvssScore == overallScore) {
          overallVector = sf.cvssVector;
          break;
        }
      }

      // Build merged description - like wireframe does
      final descriptionBuffer = StringBuffer();
      
      // Add base description if available
      if (template.baseDescription != null && template.baseDescription!.isNotEmpty) {
        descriptionBuffer.writeln(template.baseDescription);
        descriptionBuffer.writeln();
      }

      // Add each sub-finding as a section (like wireframe)
      for (final subFinding in selectedSubFindings) {
        descriptionBuffer.writeln('## ${subFinding.title}');
        descriptionBuffer.writeln();
        descriptionBuffer.writeln(subFinding.description);
        descriptionBuffer.writeln();
      }

      // Build merged audit steps
      final auditStepsBuffer = StringBuffer();
      for (int i = 0; i < selectedSubFindings.length; i++) {
        final subFinding = selectedSubFindings[i];
        auditStepsBuffer.writeln('### ${i + 1}. ${subFinding.title}');
        auditStepsBuffer.writeln();
        auditStepsBuffer.writeln(subFinding.checkSteps);
        if (i < selectedSubFindings.length - 1) {
          auditStepsBuffer.writeln();
        }
      }

      // Build merged recommendations 
      final recommendationsBuffer = StringBuffer();
      for (final subFinding in selectedSubFindings) {
        recommendationsBuffer.writeln('**${subFinding.title}:**');
        recommendationsBuffer.writeln(subFinding.recommendation);
        recommendationsBuffer.writeln();
      }

      // Build merged verification procedures
      final verificationBuffer = StringBuffer();
      for (final subFinding in selectedSubFindings) {
        if (subFinding.verificationProcedure != null && subFinding.verificationProcedure!.isNotEmpty) {
          verificationBuffer.writeln('**${subFinding.title}:**');
          verificationBuffer.writeln(subFinding.verificationProcedure);
          verificationBuffer.writeln();
        }
      }

      // Collect all links from sub-findings
      final allLinks = <FindingLink>[];
      for (final subFinding in selectedSubFindings) {
        allLinks.addAll(subFinding.links);
      }

      // Create screenshot placeholders for the finding
      final screenshotIds = <String>[];
      for (final subFinding in selectedSubFindings) {
        for (final placeholder in subFinding.screenshotPlaceholders) {
          final screenshotId = 'SCR-${DateTime.now().millisecondsSinceEpoch}-${screenshotIds.length}';
          
          // Create placeholder screenshot
          final placeholderScreenshot = Screenshot(
            id: screenshotId,
            projectId: currentProject.id,
            name: '${subFinding.title} - ${placeholder.caption}',
            description: 'Placeholder for ${subFinding.title}',
            caption: placeholder.caption,
            instructions: placeholder.steps,
            originalPath: '', // Empty for placeholder
            editedPath: null,
            thumbnailPath: null,
            width: 0,
            height: 0,
            fileSize: 0,
            fileFormat: 'placeholder',
            captureDate: DateTime.now(),
            createdDate: DateTime.now(),
            modifiedDate: DateTime.now(),
            category: 'other', // Default category for template placeholders
            tags: {template.title, subFinding.title},
            hasRedactions: false,
            isProcessed: false,
            isPlaceholder: true, // Mark as placeholder
            metadata: {
              'placeholder': true,
              'template_id': template.id,
              'sub_finding_id': subFinding.id,
              'template_generated': true,
            },
            layers: [],
          );

          // Save placeholder screenshot
          final database = ref.read(databaseProvider);
          await database.insertScreenshot(placeholderScreenshot, currentProject.id);
          screenshotIds.add(screenshotId);
        }
      }

      // Create the merged finding - NOT a hierarchical main finding, just a regular finding with merged content
      final mergedFinding = Finding(
        id: '', // Will be generated when saved
        projectId: currentProject.id,
        title: template.title, // Use template title like wireframe
        description: descriptionBuffer.toString().trim(),
        cvssScore: overallScore,
        cvssVector: overallVector,
        severity: FindingSeverity.fromScore(overallScore),
        status: FindingStatus.draft,
        auditSteps: auditStepsBuffer.toString().trim(),
        furtherReading: recommendationsBuffer.toString().trim(),
        verificationProcedure: verificationBuffer.toString().trim().isEmpty 
            ? null 
            : verificationBuffer.toString().trim(),
        createdDate: DateTime.now(),
        updatedDate: DateTime.now(),
        isMainFinding: false, // This is just a regular finding, not hierarchical
        parentFindingId: null,
        subFindings: const [], // No sub-findings stored, content is merged
        components: [],
        links: allLinks,
        screenshotIds: screenshotIds,
      );

      final findingProviderNotifier = ref.read(findingProvider.notifier);
      await findingProviderNotifier.createFinding(mergedFinding);

      if (mounted) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Template applied! ${selectedSubFindings.length} sub-findings merged into "${template.title}"${screenshotIds.isNotEmpty ? ' with ${screenshotIds.length} placeholder screenshots' : ''}',
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templatesAsync = ref.watch(templateProvider);

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.account_tree_outlined,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Create Finding from Template',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Content
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Template list (left panel)
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Templates',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: templatesAsync.when(
                              data: (templates) => ListView.builder(
                                itemCount: templates.length,
                                itemBuilder: (context, index) {
                                  final template = templates[index];
                                  final isSelected = _selectedTemplate?.id == template.id;

                                  return Card(
                                    elevation: isSelected ? 2 : 0,
                                    color: isSelected
                                        ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                                        : null,
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: isSelected
                                            ? theme.colorScheme.primary
                                            : theme.colorScheme.primaryContainer,
                                        child: Text(
                                          template.findingCount.toString(),
                                          style: TextStyle(
                                            color: isSelected
                                                ? theme.colorScheme.onPrimary
                                                : theme.colorScheme.onPrimaryContainer,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      title: Text(template.title),
                                      subtitle: Text(template.category),
                                      trailing: isSelected
                                          ? Icon(
                                              Icons.check_circle,
                                              color: theme.colorScheme.primary,
                                            )
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          _selectedTemplate = template;
                                        });
                                        _loadTemplate(template);
                                      },
                                    ),
                                  );
                                },
                              ),
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (error, _) => Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.error_outline,
                                      size: 48,
                                      color: theme.colorScheme.error,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Failed to load templates',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.error,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Sub-finding selection (right panel)
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _loadedTemplate != null
                          ? SubFindingSelectionWidget(
                              template: _loadedTemplate!,
                              initialSelection: _selectedSubFindings,
                              onSelectionChanged: (selection) {
                                setState(() {
                                  _selectedSubFindings = selection;
                                });
                              },
                            )
                          : _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : _error != null
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: theme.colorScheme.error,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            _error!,
                                            style: theme.textTheme.bodyMedium?.copyWith(
                                              color: theme.colorScheme.error,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.touch_app_outlined,
                                            size: 48,
                                            color: theme.colorScheme.outline,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Select a template to view sub-findings',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              color: theme.colorScheme.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _selectedSubFindings.isNotEmpty && !_isLoading
                      ? _applyTemplate
                      : null,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.add),
                  label: Text(
                    _isLoading
                        ? 'Applying...'
                        : 'Apply Template (${_selectedSubFindings.length} sub-findings)',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Show sub-finding template dialog
Future<bool?> showSubFindingTemplateDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const SubFindingTemplateDialog(),
  );
}