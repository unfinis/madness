import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:uuid/uuid.dart';
import '../models/finding.dart';
import '../models/finding_template.dart';
import '../widgets/severity_selector.dart';
import 'rich_text/rich_text_controller.dart';
import 'toolbar/editor_toolbar.dart';
import 'table/table_editor_dialog.dart';
import 'image/image_picker_widget.dart';
import 'variables/variable_picker_dialog.dart';

/// Main finding editor widget
class FindingEditorWidget extends ConsumerStatefulWidget {
  final Finding? initialFinding;
  final FindingTemplate? template;
  final Function(Finding) onSave;
  final VoidCallback? onCancel;

  const FindingEditorWidget({
    super.key,
    this.initialFinding,
    this.template,
    required this.onSave,
    this.onCancel,
  });

  @override
  ConsumerState<FindingEditorWidget> createState() =>
      _FindingEditorWidgetState();
}

class _FindingEditorWidgetState extends ConsumerState<FindingEditorWidget>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _titleController;
  late final TextEditingController _cvssController;
  late final TextEditingController _cweController;
  late final TextEditingController _affectedSystemsController;

  late final RichTextEditorController _descriptionController;
  late final RichTextEditorController _remediationController;
  late final RichTextEditorController _referencesController;

  late FindingSeverity _severity;
  late FindingStatus _status;
  late TabController _tabController;
  late String _findingId;

  final List<String> _imageIds = [];
  final Map<String, String> _variables = {};

  @override
  void initState() {
    super.initState();

    _findingId = widget.initialFinding?.id ?? const Uuid().v4();
    _severity = widget.initialFinding?.severity ??
        _parseSeverity(widget.template?.defaultSeverity) ??
        FindingSeverity.medium;
    _status = widget.initialFinding?.status ?? FindingStatus.draft;

    _titleController = TextEditingController(
      text: widget.initialFinding?.title ?? widget.template?.name ?? '',
    );
    _cvssController = TextEditingController(
      text: widget.initialFinding?.cvssScore ??
          widget.template?.defaultCvssScore ??
          '',
    );
    _cweController = TextEditingController(
      text: widget.initialFinding?.cweId ?? widget.template?.defaultCweId ?? '',
    );
    _affectedSystemsController = TextEditingController(
      text: widget.initialFinding?.affectedSystems ?? '',
    );

    _descriptionController = RichTextEditorController();
    _remediationController = RichTextEditorController();
    _referencesController = RichTextEditorController();

    // Load content
    if (widget.initialFinding != null) {
      _descriptionController
          .loadFromMarkdown(widget.initialFinding!.description);
      if (widget.initialFinding!.remediation != null) {
        _remediationController
            .loadFromMarkdown(widget.initialFinding!.remediation!);
      }
      if (widget.initialFinding!.references != null) {
        _referencesController
            .loadFromMarkdown(widget.initialFinding!.references!);
      }
      _imageIds.addAll(widget.initialFinding!.imageIds);
      _variables.addAll(widget.initialFinding!.variables);
    } else if (widget.template != null) {
      _descriptionController
          .loadFromMarkdown(widget.template!.descriptionTemplate);
      _remediationController
          .loadFromMarkdown(widget.template!.remediationTemplate);
      // Initialize variables from template
      for (final variable in widget.template!.variables) {
        _variables[variable.name] = variable.defaultValue ?? '';
      }
    }

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _cvssController.dispose();
    _cweController.dispose();
    _affectedSystemsController.dispose();
    _descriptionController.dispose();
    _remediationController.dispose();
    _referencesController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  FindingSeverity? _parseSeverity(String? severity) {
    if (severity == null) return null;
    return FindingSeverity.values
        .where((s) => s.name.toLowerCase() == severity.toLowerCase())
        .firstOrNull;
  }

  void _handleSave() {
    final finding = Finding(
      id: _findingId,
      title: _titleController.text,
      description: _descriptionController.toMarkdown(),
      severity: _severity,
      createdAt: widget.initialFinding?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
      cvssScore: _cvssController.text.isNotEmpty ? _cvssController.text : null,
      cweId: _cweController.text.isNotEmpty ? _cweController.text : null,
      affectedSystems: _affectedSystemsController.text.isNotEmpty
          ? _affectedSystemsController.text
          : null,
      remediation: _remediationController.toMarkdown(),
      references: _referencesController.toMarkdown(),
      templateId: widget.template?.id,
      imageIds: _imageIds,
      variables: _variables,
      status: _status,
    );

    widget.onSave(finding);
  }

  Future<void> _handleInsertTable(RichTextEditorController controller) async {
    final result = await showDialog<List<List<String>>>(
      context: context,
      builder: (context) => const TableEditorDialog(),
    );

    if (result != null && result.isNotEmpty) {
      controller.insertTable(result.length, result[0].length);
    }
  }

  Future<void> _handleInsertImage(RichTextEditorController controller) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const ImagePickerWidget(),
    );

    if (result != null) {
      final imageId = result['id'] as String;
      final imageUrl = result['url'] as String;
      _imageIds.add(imageId);
      controller.insertImage(imageId, imageUrl);
    }
  }

  Future<void> _handleInsertVariable(RichTextEditorController controller) async {
    if (widget.template == null) return;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => VariablePickerDialog(
        variables: widget.template!.variables,
        currentValues: _variables,
      ),
    );

    if (result != null) {
      controller.insertVariable(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialFinding == null
            ? 'New Finding'
            : 'Edit Finding'),
        actions: [
          TextButton(
            onPressed: widget.onCancel,
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: _titleController.text.isEmpty ? null : _handleSave,
            child: const Text('Save'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Basic info section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Finding Title',
                    border: OutlineInputBorder(),
                    hintText: 'Enter a descriptive title',
                  ),
                  style: theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: SeveritySelectorWidget(
                        severity: _severity,
                        onChanged: (value) => setState(() => _severity = value),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _cvssController,
                        decoration: const InputDecoration(
                          labelText: 'CVSS Score',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., 7.5',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _cweController,
                        decoration: const InputDecoration(
                          labelText: 'CWE ID',
                          border: OutlineInputBorder(),
                          hintText: 'e.g., CWE-79',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _affectedSystemsController,
                  decoration: const InputDecoration(
                    labelText: 'Affected Systems',
                    border: OutlineInputBorder(),
                    hintText: 'Systems or components affected',
                  ),
                ),
              ],
            ),
          ),

          // Tabbed content editors
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Remediation'),
              Tab(text: 'References'),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEditorTab(_descriptionController),
                _buildEditorTab(_remediationController),
                _buildEditorTab(_referencesController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorTab(RichTextEditorController controller) {
    return Column(
      children: [
        EditorToolbar(
          controller: controller.quillController,
          onInsertTable: () => _handleInsertTable(controller),
          onInsertImage: () => _handleInsertImage(controller),
          onInsertVariable: widget.template != null
              ? () => _handleInsertVariable(controller)
              : null,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: QuillEditor.basic(
              controller: controller.quillController,
            ),
          ),
        ),
      ],
    );
  }
}
