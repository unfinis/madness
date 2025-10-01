import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:madness/finding_editor.dart';
import 'package:uuid/uuid.dart';

/// Example usage of the Finding Editor Library
///
/// This demonstrates:
/// 1. Creating a new finding from scratch
/// 2. Editing an existing finding
/// 3. Using templates
/// 4. Exporting findings
/// 5. Managing hierarchies

void main() {
  runApp(
    const ProviderScope(
      child: FindingEditorExampleApp(),
    ),
  );
}

class FindingEditorExampleApp extends StatelessWidget {
  const FindingEditorExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finding Editor Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      home: const FindingListScreen(),
    );
  }
}

class FindingListScreen extends ConsumerWidget {
  const FindingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(findingRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Findings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Templates',
            onPressed: () => _showTemplates(context, ref),
          ),
        ],
      ),
      body: FutureBuilder<List<Finding>>(
        future: repository.getAllFindings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final findings = snapshot.data ?? [];

          if (findings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No findings yet'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _createNewFinding(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Finding'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: findings.length,
            itemBuilder: (context, index) {
              final finding = findings[index];
              return FindingCard(
                finding: finding,
                onTap: () => _editFinding(context, ref, finding),
                onDelete: () => _deleteFinding(context, ref, finding),
                onExport: () => _exportFinding(context, ref, finding),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewFinding(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _createNewFinding(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: FindingEditorWidget(
            onSave: (finding) async {
              final repo = ref.read(findingRepositoryProvider);
              await repo.saveFinding(finding);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Finding saved')),
                );
              }
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  void _editFinding(BuildContext context, WidgetRef ref, Finding finding) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: FindingEditorWidget(
            initialFinding: finding,
            onSave: (updated) async {
              final repo = ref.read(findingRepositoryProvider);
              await repo.saveFinding(updated);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Finding updated')),
                );
              }
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteFinding(
      BuildContext context, WidgetRef ref, Finding finding) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Finding'),
        content: Text('Delete "${finding.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(findingRepositoryProvider);
      await repo.deleteFinding(finding.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Finding deleted')),
        );
      }
    }
  }

  Future<void> _exportFinding(
      BuildContext context, WidgetRef ref, Finding finding) async {
    final format = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Export Format'),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('markdown'),
            child: const Text('Markdown'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('html'),
            child: const Text('HTML'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.of(context).pop('json'),
            child: const Text('JSON'),
          ),
        ],
      ),
    );

    if (format != null) {
      final exporter = FindingExporter();
      String exported;

      switch (format) {
        case 'markdown':
          exported = await exporter.exportToMarkdown(finding);
          break;
        case 'html':
          exported = await exporter.exportToHtml(finding);
          break;
        case 'json':
          exported = await exporter.exportToJson(finding);
          break;
        default:
          return;
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exported as $format'),
            content: SingleChildScrollView(
              child: SelectableText(exported),
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
    }
  }

  void _showTemplates(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TemplatePicker(
          onTemplateSelected: (template) {
            Navigator.of(context).pop();
            _createFromTemplate(context, ref, template);
          },
        ),
      ),
    );
  }

  void _createFromTemplate(
      BuildContext context, WidgetRef ref, FindingTemplate template) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: FindingEditorWidget(
            template: template,
            onSave: (finding) async {
              final repo = ref.read(findingRepositoryProvider);
              await repo.saveFinding(finding);
              if (context.mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Finding created from template')),
                );
              }
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        ),
      ),
    );
  }
}

class FindingCard extends StatelessWidget {
  final Finding finding;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onExport;

  const FindingCard({
    super.key,
    required this.finding,
    required this.onTap,
    required this.onDelete,
    required this.onExport,
  });

  Color _getSeverityColor() {
    switch (finding.severity) {
      case FindingSeverity.critical:
        return Colors.purple;
      case FindingSeverity.high:
        return Colors.red;
      case FindingSeverity.medium:
        return Colors.orange;
      case FindingSeverity.low:
        return Colors.yellow.shade700;
      case FindingSeverity.informational:
        return Colors.blue;
    }
  }

  IconData _getSeverityIcon() {
    switch (finding.severity) {
      case FindingSeverity.critical:
        return Icons.warning;
      case FindingSeverity.high:
        return Icons.error;
      case FindingSeverity.medium:
        return Icons.report_problem;
      case FindingSeverity.low:
        return Icons.info;
      case FindingSeverity.informational:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSeverityIcon(),
                    color: _getSeverityColor(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      finding.title,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      finding.severity.displayName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                finding.description.split('\n').first,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  if (finding.cvssScore != null) ...[
                    Icon(Icons.speed, size: 16, color: theme.colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      'CVSS: ${finding.cvssScore}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  if (finding.cweId != null) ...[
                    Icon(Icons.bug_report, size: 16, color: theme.colorScheme.outline),
                    const SizedBox(width: 4),
                    Text(
                      finding.cweId!,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 16),
                  ],
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.file_download, size: 20),
                    onPressed: onExport,
                    tooltip: 'Export',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: onDelete,
                    tooltip: 'Delete',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Example: Initialize with sample templates
Future<void> initializeSampleTemplates(WidgetRef ref) async {
  final repo = ref.read(templateRepositoryProvider);

  // Check if templates already exist
  final existing = await repo.getAllTemplates();
  if (existing.isNotEmpty) return;

  // Add SQL Injection template
  final sqlTemplate = TemplateManager.createSqlInjectionTemplate();
  await repo.saveTemplate(sqlTemplate);

  // Add XSS template
  final xssTemplate = TemplateManager.createXssTemplate();
  await repo.saveTemplate(xssTemplate);
}
