import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';
import '../constants/app_spacing.dart';

/// A robust Super Editor widget with markdown support
class SuperEditorWidget extends StatefulWidget {
  final String initialMarkdown;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onMarkdownChanged;
  final bool readOnly;
  final double? height;
  final EdgeInsets? padding;
  final bool showToolbar;

  const SuperEditorWidget({
    super.key,
    this.initialMarkdown = '',
    this.hintText,
    this.onChanged,
    this.onMarkdownChanged,
    this.readOnly = false,
    this.height = 300,
    this.padding,
    this.showToolbar = true,
  });

  @override
  State<SuperEditorWidget> createState() => _SuperEditorWidgetState();
}

class _SuperEditorWidgetState extends State<SuperEditorWidget> {
  late Editor _editor;
  late MutableDocument _document;
  late MutableDocumentComposer _composer;
  late FocusNode _focusNode;
  late TextEditingController _markdownController;

  bool _showMarkdown = false;
  bool _isUpdating = false;
  Timer? _debounceTimer;

  // Undo/Redo functionality
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  final int _maxUndoSteps = 50;

  // Auto-save functionality
  Timer? _autoSaveTimer;
  bool _hasUnsavedChanges = false;
  DateTime? _lastSaveTime;
  String _saveStatus = '';

  // Synchronization optimization
  Timer? _syncToMarkdownTimer;
  Timer? _syncFromMarkdownTimer;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _composer = MutableDocumentComposer();
    _markdownController = TextEditingController();

    _initializeDocument();
    _createEditor();
    _updateMarkdownController();

    // Listen for changes
    _markdownController.addListener(_onMarkdownChanged);

    // Initialize undo stack with initial content
    _saveUndoState();

    // Initialize auto-save
    _startAutoSave();
  }

  void _initializeDocument() {
    if (widget.initialMarkdown.isNotEmpty) {
      try {
        _document = deserializeMarkdownToDocument(widget.initialMarkdown);
      } catch (e) {
        debugPrint('Markdown parse error: $e');
        _document = _createEmptyDocument();
      }
    } else {
      _document = _createEmptyDocument();
    }
  }

  MutableDocument _createEmptyDocument() {
    return MutableDocument(nodes: [
      ParagraphNode(
        id: Editor.createNodeId(),
        text: AttributedText(),
      ),
    ]);
  }

  void _createEditor() {
    _editor = createDefaultDocumentEditor(
      document: _document,
      composer: _composer,
    );

    // Ensure the composer has a valid selection to prevent null pointer exceptions
    if (_composer.selection == null && _document.nodeCount > 0) {
      final firstNode = _document.getNodeAt(0);
      if (firstNode != null) {
        final initialPosition = DocumentPosition(
          nodeId: firstNode.id,
          nodePosition: firstNode is TextNode
            ? const TextNodePosition(offset: 0)
            : firstNode.beginningPosition,
        );

        _composer.setSelectionWithReason(
          DocumentSelection.collapsed(position: initialPosition),
          SelectionReason.userInteraction,
        );
      }
    }
  }


  void _onMarkdownChanged() {
    if (_isUpdating || !_showMarkdown) return;

    // Use the optimized synchronization method with proper batching
    _scheduleSyncFromMarkdown();
  }

  void _updateMarkdownController() {
    if (_isUpdating) return;

    _isUpdating = true;
    try {
      // Add null safety check for document
      if (_document.nodeCount == 0) {
        _markdownController.text = '';
        return;
      }

      final markdown = serializeDocumentToMarkdown(_document);
      _markdownController.text = markdown;
    } catch (e) {
      debugPrint('Serialization error: $e');
      // Fallback to empty content on error
      _markdownController.text = '';
    } finally {
      _isUpdating = false;
    }
  }

  void _syncFromMarkdown() {
    if (_isUpdating) return;

    _isUpdating = true;
    try {
      final newDocument = deserializeMarkdownToDocument(_markdownController.text);

      setState(() {
        // Replace the entire document with the new parsed document
        _document = newDocument;
        // Recreate the editor with the new document
        _createEditor();
      });

      _notifyChanges();
    } catch (e) {
      debugPrint('Markdown sync error: $e');
      // If parsing fails, create a minimal document with the raw text
      setState(() {
        _document = MutableDocument(nodes: [
          ParagraphNode(
            id: Editor.createNodeId(),
            text: AttributedText(_markdownController.text),
          ),
        ]);
        _createEditor();
      });
    } finally {
      _isUpdating = false;
    }
  }

  void _notifyChanges() {
    if (widget.onMarkdownChanged != null) {
      try {
        final markdown = serializeDocumentToMarkdown(_document);
        widget.onMarkdownChanged!(markdown);
      } catch (e) {
        debugPrint('Notification error: $e');
      }
    }

    if (widget.onChanged != null) {
      final plainText = _getPlainText();
      widget.onChanged!(plainText);
    }
  }

  String _getPlainText() {
    final buffer = StringBuffer();
    for (int i = 0; i < _document.nodeCount; i++) {
      final node = _document.getNodeAt(i);
      if (node is TextNode) {
        buffer.write(node.text.toPlainText());
        if (i < _document.nodeCount - 1) {
          buffer.write('\n');
        }
      }
    }
    return buffer.toString();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _autoSaveTimer?.cancel();
    _syncToMarkdownTimer?.cancel();
    _syncFromMarkdownTimer?.cancel();
    _focusNode.dispose();
    _markdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      onKeyEvent: _handleKeyEvent,
      child: Card(
        elevation: 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showToolbar && !widget.readOnly) _buildToolbar(theme),
            Flexible(
              child: SizedBox(
                height: widget.height,
                child: _showMarkdown ? _buildMarkdownEditor(theme) : _buildRichEditor(theme),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // View toggle
          Row(
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: false,
                    label: Text('Rich Text'),
                    icon: Icon(Icons.edit, size: 16),
                  ),
                  ButtonSegment(
                    value: true,
                    label: Text('Markdown'),
                    icon: Icon(Icons.code, size: 16),
                  ),
                ],
                selected: {_showMarkdown},
                onSelectionChanged: (selection) {
                  setState(() {
                    _showMarkdown = selection.first;
                    if (_showMarkdown) {
                      _updateMarkdownController();
                    }
                  });
                },
                style: SegmentedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
              ),

              // Auto-save status indicator
              if (_saveStatus.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _hasUnsavedChanges
                        ? theme.colorScheme.error.withValues(alpha: 0.2)
                        : theme.colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _hasUnsavedChanges ? Icons.edit : Icons.check,
                        size: 12,
                        color: _hasUnsavedChanges
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _saveStatus,
                        style: TextStyle(
                          fontSize: 10,
                          color: _hasUnsavedChanges
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],

              const Spacer(),
              if (_showMarkdown) ...[
                IconButton(
                  icon: const Icon(Icons.content_copy, size: 18),
                  tooltip: 'Copy Markdown',
                  onPressed: _copyMarkdown,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.list_alt, size: 18),
                  tooltip: 'Document Outline',
                  onPressed: _showDocumentOutline,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.search, size: 18),
                  tooltip: 'Find & Replace (Ctrl+F)',
                  onPressed: _showFindReplaceDialog,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.analytics, size: 18),
                  tooltip: 'Document Statistics',
                  onPressed: _showDocumentStatistics,
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  icon: const Icon(Icons.save, size: 18),
                  tooltip: 'Save (Ctrl+S)',
                  onPressed: _forceSave,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),

          // Rich text formatting buttons (only show when not in markdown mode)
          if (!_showMarkdown) ...[
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Text Style Group
                  _buildToolbarGroup('Text Style', [
                    _buildToolbarButton(
                      icon: Icons.format_bold,
                      tooltip: 'Bold (Ctrl+B)',
                      onPressed: _toggleBold,
                    ),
                    _buildToolbarButton(
                      icon: Icons.format_italic,
                      tooltip: 'Italic (Ctrl+I)',
                      onPressed: _toggleItalic,
                    ),
                    _buildToolbarButton(
                      icon: Icons.format_underlined,
                      tooltip: 'Underline (Ctrl+U)',
                      onPressed: _toggleUnderline,
                    ),
                    _buildToolbarButton(
                      icon: Icons.strikethrough_s,
                      tooltip: 'Strikethrough',
                      onPressed: _toggleStrikethrough,
                    ),
                    _buildToolbarButton(
                      icon: Icons.superscript,
                      tooltip: 'Superscript',
                      onPressed: _toggleSuperscript,
                    ),
                    _buildToolbarButton(
                      icon: Icons.subscript,
                      tooltip: 'Subscript',
                      onPressed: _toggleSubscript,
                    ),
                    _buildToolbarButton(
                      icon: Icons.highlight,
                      tooltip: 'Highlight',
                      onPressed: _toggleHighlight,
                    ),
                  ]),

                  const SizedBox(width: 12),

                  // Code & Links Group
                  _buildToolbarGroup('Code & Links', [
                    _buildToolbarButton(
                      icon: Icons.code,
                      tooltip: 'Inline Code (Ctrl+`)',
                      onPressed: () => _toggleInlineCode(),
                    ),
                    _buildToolbarButton(
                      icon: Icons.link,
                      tooltip: 'Insert Link (Ctrl+K)',
                      onPressed: _showLinkDialog,
                    ),
                    _buildToolbarButton(
                      icon: Icons.image,
                      tooltip: 'Insert Image (Ctrl+Shift+I)',
                      onPressed: _showImageDialog,
                    ),
                  ]),

                  const SizedBox(width: 12),

                  // Structure Group
                  _buildToolbarGroup('Structure', [
                    _buildHeaderDropdown(theme),
                    _buildListDropdown(theme),
                    _buildAlignmentDropdown(theme),
                  ]),

                  const SizedBox(width: 12),

                  // Block Elements Group
                  _buildToolbarGroup('Blocks', [
                    _buildToolbarButton(
                      icon: Icons.format_quote,
                      tooltip: 'Quote Block (Ctrl+Shift+Q)',
                      onPressed: () => _insertQuoteBlock(),
                    ),
                    _buildCodeDropdown(theme),
                    _buildTableDropdown(theme),
                    _buildToolbarButton(
                      icon: Icons.horizontal_rule,
                      tooltip: 'Horizontal Rule',
                      onPressed: () => _insertHorizontalRule(),
                    ),
                  ]),

                  const SizedBox(width: 12),

                  // Advanced Tools Group
                  _buildToolbarGroup('Tools', [
                    _buildToolbarButton(
                      icon: Icons.format_clear,
                      tooltip: 'Clear Formatting (Ctrl+\\)',
                      onPressed: _clearFormatting,
                    ),
                    _buildFindReplaceButton(theme),
                    _buildToolbarButton(
                      icon: Icons.analytics,
                      tooltip: 'Document Statistics',
                      onPressed: _showDocumentStats,
                    ),
                  ]),

                  const SizedBox(width: 12),

                  // History Group
                  _buildToolbarGroup('History', [
                    _buildToolbarButton(
                      icon: Icons.undo,
                      tooltip: 'Undo (Ctrl+Z)',
                      onPressed: _canUndo() ? _undo : null,
                    ),
                    _buildToolbarButton(
                      icon: Icons.redo,
                      tooltip: 'Redo (Ctrl+Y)',
                      onPressed: _canRedo() ? _redo : null,
                    ),
                  ]),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderDropdown(ThemeData theme) {
    return PopupMenuButton<int>(
      tooltip: 'Headers',
      itemBuilder: (context) => [
        const PopupMenuItem(value: 1, child: Text('# Header 1')),
        const PopupMenuItem(value: 2, child: Text('## Header 2')),
        const PopupMenuItem(value: 3, child: Text('### Header 3')),
        const PopupMenuItem(value: 4, child: Text('#### Header 4')),
        const PopupMenuItem(value: 5, child: Text('##### Header 5')),
        const PopupMenuItem(value: 6, child: Text('###### Header 6')),
      ],
      onSelected: (level) {
        _insertRichTextHeader(level);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.title, size: 18),
            Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTableDropdown(ThemeData theme) {
    return PopupMenuButton<String>(
      tooltip: 'Table Tools',
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'insert_table',
          child: ListTile(
            leading: Icon(Icons.table_chart),
            title: Text('Insert Table'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'custom_table',
          child: ListTile(
            leading: Icon(Icons.grid_on),
            title: Text('Custom Table...'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'add_row',
          child: ListTile(
            leading: Icon(Icons.table_rows),
            title: Text('Add Row'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'add_column',
          child: ListTile(
            leading: Icon(Icons.view_column),
            title: Text('Add Column'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete_row',
          child: ListTile(
            leading: Icon(Icons.remove_circle_outline),
            title: Text('Delete Row'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'delete_column',
          child: ListTile(
            leading: Icon(Icons.remove_circle_outline),
            title: Text('Delete Column'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'format_table',
          child: ListTile(
            leading: Icon(Icons.format_align_center),
            title: Text('Format Table'),
            dense: true,
          ),
        ),
      ],
      onSelected: (value) => _handleTableAction(value),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.table_chart, size: 18),
            Icon(Icons.arrow_drop_down, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeDropdown(ThemeData theme) {
    return PopupMenuButton<String>(
      tooltip: 'Code',
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'inline_code',
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text('Inline Code'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_block_plain',
          child: ListTile(
            leading: Icon(Icons.code_off),
            title: Text('Code Block (Plain)'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'code_bash',
          child: ListTile(
            leading: Icon(Icons.terminal),
            title: Text('Bash/Shell'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_python',
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text('Python'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_javascript',
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text('JavaScript'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_json',
          child: ListTile(
            leading: Icon(Icons.data_object),
            title: Text('JSON'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_xml',
          child: ListTile(
            leading: Icon(Icons.code),
            title: Text('XML/HTML'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_sql',
          child: ListTile(
            leading: Icon(Icons.storage),
            title: Text('SQL'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_yaml',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('YAML'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_powershell',
          child: ListTile(
            leading: Icon(Icons.terminal),
            title: Text('PowerShell'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'code_custom',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Custom Language...'),
            dense: true,
          ),
        ),
      ],
      onSelected: (value) => _handleCodeAction(value),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.code_rounded, size: 20),
      ),
    );
  }

  Widget _buildListDropdown(ThemeData theme) {
    return PopupMenuButton<String>(
      tooltip: 'Lists',
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'bullet_list',
          child: ListTile(
            leading: Icon(Icons.format_list_bulleted),
            title: Text('Bullet List'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'numbered_list',
          child: ListTile(
            leading: Icon(Icons.format_list_numbered),
            title: Text('Numbered List'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'indent_list',
          child: ListTile(
            leading: Icon(Icons.format_indent_increase),
            title: Text('Increase Indent'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'outdent_list',
          child: ListTile(
            leading: Icon(Icons.format_indent_decrease),
            title: Text('Decrease Indent'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'checklist',
          child: ListTile(
            leading: Icon(Icons.check_box_outlined),
            title: Text('Checklist'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'convert_to_bullet',
          child: ListTile(
            leading: Icon(Icons.circle),
            title: Text('Convert to Bullets'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'convert_to_numbered',
          child: ListTile(
            leading: Icon(Icons.looks_one),
            title: Text('Convert to Numbers'),
            dense: true,
          ),
        ),
      ],
      onSelected: (value) => _handleListAction(value),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.format_list_bulleted, size: 20),
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: IconButton(
        icon: Icon(icon, size: 18),
        tooltip: tooltip,
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          padding: const EdgeInsets.all(8),
        ),
      ),
    );
  }

  Widget _buildToolbarGroup(String label, List<Widget> children) {
    return IntrinsicWidth(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(7),
                  topRight: Radius.circular(7),
                ),
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Wrap(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignmentDropdown(ThemeData theme) {
    return PopupMenuButton<String>(
      tooltip: 'Text Alignment',
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'left',
          child: ListTile(
            leading: Icon(Icons.format_align_left),
            title: Text('Left Align'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'center',
          child: ListTile(
            leading: Icon(Icons.format_align_center),
            title: Text('Center Align'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'right',
          child: ListTile(
            leading: Icon(Icons.format_align_right),
            title: Text('Right Align'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'justify',
          child: ListTile(
            leading: Icon(Icons.format_align_justify),
            title: Text('Justify'),
            dense: true,
          ),
        ),
      ],
      onSelected: (value) => _handleAlignmentAction(value),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.format_align_left, size: 20),
      ),
    );
  }

  Widget _buildFindReplaceButton(ThemeData theme) {
    return _buildToolbarButton(
      icon: Icons.search,
      tooltip: 'Find & Replace (Ctrl+F)',
      onPressed: () => _showFindReplaceDialog(),
    );
  }

  Widget _buildRichEditor(ThemeData theme) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info panel for rich text view
          if (_hasTablesInContent()) ...[
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tables display as markdown text in rich text mode. Switch to "Markdown" view to see formatted tables.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.visibility, size: 16, color: theme.colorScheme.primary),
                    tooltip: 'Switch to Markdown view',
                    onPressed: () {
                      setState(() {
                        _showMarkdown = true;
                        _updateMarkdownController();
                      });
                    },
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: SuperEditor(
              editor: _editor,
              focusNode: _focusNode,
              stylesheet: _buildCustomStylesheet(theme),
              componentBuilders: [
                ...defaultComponentBuilders,
              ],
              gestureMode: DocumentGestureMode.mouse,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkdownEditor(ThemeData theme) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Edit markdown directly. Tables & code blocks display properly here. Changes sync to rich text automatically.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: _markdownController,
              maxLines: null,
              expands: true,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
              ),
              decoration: InputDecoration(
                hintText: widget.hintText ?? _getMarkdownHintText(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasTablesInContent() {
    try {
      final markdown = serializeDocumentToMarkdown(_document);
      // Check for markdown table pattern
      return RegExp(r'\|.*\|.*\n\|[-:]*\|').hasMatch(markdown);
    } catch (e) {
      return false;
    }
  }

  String _getMarkdownHintText() {
    return '''Enter markdown here...

# Header 1
## Header 2
### Header 3

**Bold text**
*Italic text*
`inline code`

- Bullet point
- Another bullet
  - Nested bullet

1. Numbered item
2. Another item

> Blockquote

```
Code block
```

| Column 1 | Column 2 |
|----------|----------|
| Cell 1   | Cell 2   |

![Alt text](image-url)''';
  }

  // Simplified toolbar actions - insert markdown directly
  void _insertMarkdown(String markdown) {
    _saveUndoState();

    if (_showMarkdown) {
      // Insert directly into markdown text field
      final controller = _markdownController;
      final currentText = controller.text;
      final selection = controller.selection;

      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        markdown,
      );

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + markdown.length,
        ),
      );

      // Sync the changes to rich text
      _syncFromMarkdown();
    } else {
      // Update markdown representation first, then add the new content
      _updateMarkdownController();
      final currentMarkdown = _markdownController.text;

      // Add the markdown at the end or at cursor position if we can determine it
      final newMarkdown = currentMarkdown.isEmpty
          ? markdown.trim()
          : '$currentMarkdown\n${markdown.trim()}';

      _markdownController.text = newMarkdown;

      // Sync back to rich text
      _syncFromMarkdown();

      // Optionally switch to markdown mode to show the insertion
      if (markdown.contains('\n') || markdown.length > 50) {
        setState(() {
          _showMarkdown = true;
        });
      }
    }
  }

  void _insertTable() {
    const tableMarkdown = '''
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
''';
    _insertMarkdown(tableMarkdown);
  }

  void _copyMarkdown() {
    Clipboard.setData(ClipboardData(text: _markdownController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Markdown copied to clipboard')),
    );
  }

  void _showDocumentOutline() async {
    final text = _markdownController.text;
    final headers = _extractHeaders(text);

    if (headers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No headers found in document')),
      );
      return;
    }

    await showDialog(
      context: context,
      builder: (context) => _DocumentOutlineDialog(
        headers: headers,
        onHeaderTap: (headerInfo) {
          Navigator.of(context).pop();
          _jumpToHeader(headerInfo);
        },
      ),
    );
  }

  List<HeaderInfo> _extractHeaders(String text) {
    final headers = <HeaderInfo>[];
    final lines = text.split('\n');
    int lineNumber = 0;
    int charPosition = 0;

    for (final line in lines) {
      lineNumber++;
      final trimmed = line.trim();

      // Match markdown headers (# ## ### #### ##### ######)
      final headerMatch = RegExp(r'^(#{1,6})\s+(.+)$').firstMatch(trimmed);
      if (headerMatch != null) {
        final level = headerMatch.group(1)!.length;
        final title = headerMatch.group(2)!.trim();

        headers.add(HeaderInfo(
          level: level,
          title: title,
          lineNumber: lineNumber,
          charPosition: charPosition,
        ));
      }

      charPosition += line.length + 1; // +1 for newline
    }

    return headers;
  }

  void _jumpToHeader(HeaderInfo header) {
    // Switch to markdown view if not already there
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });

      // Use a short delay to ensure the view has updated
      Future.delayed(const Duration(milliseconds: 150), () {
        _jumpToHeaderPosition(header);
      });
    } else {
      _jumpToHeaderPosition(header);
    }
  }

  void _jumpToHeaderPosition(HeaderInfo header) {
    final controller = _markdownController;

    // Position cursor at the beginning of the header line
    controller.selection = TextSelection.collapsed(
      offset: math.min(header.charPosition, controller.text.length),
    );

    // Show a brief highlight effect
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Jumped to: ${header.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Find and Replace functionality
  void _showFindReplaceDialog({bool showReplace = false}) async {
    // Switch to markdown mode for find/replace operations
    if (!_showMarkdown) {
      _updateMarkdownController();
      setState(() {
        _showMarkdown = true;
      });
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => _FindReplaceDialog(
        controller: _markdownController,
        showReplace: showReplace,
        onReplace: (findText, replaceText, replaceAll) {
          _performReplace(findText, replaceText, replaceAll);
        },
      ),
    );
  }

  void _performReplace(String findText, String replaceText, bool replaceAll) {
    if (findText.isEmpty) return;

    _saveUndoState();

    final controller = _markdownController;
    final text = controller.text;

    if (replaceAll) {
      // Replace all occurrences
      final newText = text.replaceAll(findText, replaceText);
      if (newText != text) {
        controller.text = newText;
        _syncFromMarkdown();

        final count = text.split(findText).length - 1;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Replaced $count occurrences')),
        );
      }
    } else {
      // Replace current selection or first occurrence
      final selection = controller.selection;
      final selectedText = selection.isValid
          ? text.substring(selection.start, selection.end)
          : '';

      if (selectedText == findText) {
        // Replace selected text
        final newText = text.replaceRange(selection.start, selection.end, replaceText);
        controller.text = newText;
        controller.selection = TextSelection.collapsed(
          offset: selection.start + replaceText.length,
        );
        _syncFromMarkdown();
      } else {
        // Find and replace first occurrence
        final index = text.indexOf(findText);
        if (index != -1) {
          final newText = text.replaceFirst(findText, replaceText);
          controller.text = newText;
          controller.selection = TextSelection(
            baseOffset: index,
            extentOffset: index + replaceText.length,
          );
          _syncFromMarkdown();
        }
      }
    }
  }

  // Document Statistics
  void _showDocumentStatistics() {
    _updateMarkdownController();
    final stats = _calculateDocumentStats(_markdownController.text);

    showDialog(
      context: context,
      builder: (context) => _DocumentStatisticsDialog(stats: stats),
    );
  }

  DocumentStats _calculateDocumentStats(String text) {
    // Basic text statistics
    final trimmedText = text.trim();
    final characters = text.length;
    final charactersNoSpaces = text.replaceAll(RegExp(r'\s'), '').length;

    // Word count (split by whitespace, filter empty)
    final words = trimmedText.isEmpty
        ? <String>[]
        : trimmedText.split(RegExp(r'\s+'))
            .where((word) => word.isNotEmpty)
            .toList();
    final wordCount = words.length;

    // Paragraph count (split by double newlines)
    final paragraphs = trimmedText.isEmpty
        ? 0
        : trimmedText.split(RegExp(r'\n\s*\n')).length;

    // Line count
    final lines = text.isEmpty ? 0 : text.split('\n').length;

    // Sentence count (approximate - split by sentence ending punctuation)
    final sentences = trimmedText.isEmpty
        ? 0
        : trimmedText.split(RegExp(r'[.!?]+\s+')).length;

    // Reading time estimate (200 words per minute average)
    final readingMinutes = (wordCount / 200).ceil();

    // Markdown specific stats
    final headers = _extractHeaders(text);
    final headerCount = headers.length;

    // Code blocks
    final codeBlockMatches = RegExp(r'```[\s\S]*?```').allMatches(text);
    final codeBlockCount = codeBlockMatches.length;

    // Inline code
    final inlineCodeMatches = RegExp(r'`[^`]+`').allMatches(text);
    final inlineCodeCount = inlineCodeMatches.length;

    // Links
    final linkMatches = RegExp(r'\[([^\]]+)\]\(([^)]+)\)').allMatches(text);
    final linkCount = linkMatches.length;

    // Images
    final imageMatches = RegExp(r'!\[([^\]]*)\]\(([^)]+)\)').allMatches(text);
    final imageCount = imageMatches.length;

    // Lists (bullet and numbered)
    final bulletPoints = text.split('\n')
        .where((line) => line.trim().startsWith('- ') || line.trim().startsWith('* '))
        .length;
    final numberedPoints = text.split('\n')
        .where((line) => RegExp(r'^\s*\d+\.\s').hasMatch(line))
        .length;
    final totalListItems = bulletPoints + numberedPoints;

    // Tables
    final tableRows = text.split('\n')
        .where((line) => line.trim().startsWith('|') && line.trim().endsWith('|'))
        .length;

    // Approximate table count (header + separator + data rows)
    final tableCount = tableRows > 0 ? (tableRows / 3).ceil() : 0;

    return DocumentStats(
      characters: characters,
      charactersNoSpaces: charactersNoSpaces,
      words: wordCount,
      sentences: sentences,
      paragraphs: paragraphs,
      lines: lines,
      readingMinutes: readingMinutes,
      headers: headerCount,
      codeBlocks: codeBlockCount,
      inlineCode: inlineCodeCount,
      links: linkCount,
      images: imageCount,
      listItems: totalListItems,
      tables: tableCount,
    );
  }

  // Auto-save functionality
  void _startAutoSave() {
    _autoSaveTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_hasUnsavedChanges) {
        _performAutoSave();
      }
    });

    // Set initial status
    setState(() {
      _saveStatus = 'Auto-save enabled';
      _hasUnsavedChanges = false;
    });

    // Clear status after a few seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted && !_hasUnsavedChanges) {
        setState(() {
          _saveStatus = '';
        });
      }
    });
  }

  void _markAsChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
        _saveStatus = 'Unsaved changes';
      });
    }
  }

  void _performAutoSave() async {
    if (!_hasUnsavedChanges) return;

    setState(() {
      _saveStatus = 'Saving...';
    });

    // Simulate save operation (replace with actual save logic)
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real app, you would save to file system, cloud, etc.
    final markdown = _markdownController.text;
    if (widget.onMarkdownChanged != null) {
      widget.onMarkdownChanged!(markdown);
    }

    final now = DateTime.now();
    setState(() {
      _hasUnsavedChanges = false;
      _lastSaveTime = now;
      _saveStatus = 'Saved ${_formatSaveTime(now)}';
    });

    // Clear save status after a few seconds
    Timer(const Duration(seconds: 3), () {
      if (mounted && !_hasUnsavedChanges) {
        setState(() {
          _saveStatus = '';
        });
      }
    });
  }

  void _forceSave() {
    _hasUnsavedChanges = true; // Force save even if no changes detected
    _performAutoSave();
  }

  String _formatSaveTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inSeconds < 60) {
      return 'just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  // Advanced Super Editor Features
  Stylesheet _buildCustomStylesheet(ThemeData theme) {
    return defaultStylesheet.copyWith(
      addRulesAfter: [
        // Enhanced paragraph styling
        StyleRule(
          const BlockSelector("paragraph"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.bodyMedium!.copyWith(
              height: 1.6, // Better line spacing for reading
            ),
            Styles.padding: const CascadingPadding.symmetric(vertical: 4),
          },
        ),

        // Custom header styling with better hierarchy
        StyleRule(
          const BlockSelector("header1"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
            Styles.padding: const CascadingPadding.only(top: 24, bottom: 12),
          },
        ),

        StyleRule(
          const BlockSelector("header2"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
            Styles.padding: const CascadingPadding.only(top: 20, bottom: 10),
          },
        ),

        StyleRule(
          const BlockSelector("header3"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.w600,
            ),
            Styles.padding: const CascadingPadding.only(top: 16, bottom: 8),
          },
        ),

        // Enhanced blockquote styling
        StyleRule(
          const BlockSelector("blockquote"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.bodyMedium!.copyWith(
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            Styles.padding: const CascadingPadding.only(left: 16, top: 8, bottom: 8),
            // Border would be added via custom component if available
          },
        ),

        // Code block styling
        StyleRule(
          const BlockSelector("code"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.bodyMedium!.copyWith(
              fontFamily: 'monospace',
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            Styles.padding: const CascadingPadding.all(12),
          },
        ),

        // List item styling
        StyleRule(
          const BlockSelector("listItem"),
          (doc, docNode) => {
            Styles.textStyle: theme.textTheme.bodyMedium!,
            Styles.padding: const CascadingPadding.only(left: 24, bottom: 4),
          },
        ),
      ],
    );
  }


  // Enhanced keyboard shortcut system
  Map<LogicalKeySet, VoidCallback> _buildKeyboardShortcuts() {
    return {
      // Text formatting shortcuts
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB): _toggleBold,
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI): _toggleItalic,
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyS): _toggleStrikethrough,

      // Document shortcuts
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyS): _forceSave,
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyF): () => _showFindReplaceDialog(),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyH): () => _showFindReplaceDialog(showReplace: true),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyK): _showLinkDialog,

      // Header shortcuts
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit1): () => _insertRichTextHeader(1),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit2): () => _insertRichTextHeader(2),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit3): () => _insertRichTextHeader(3),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.digit4): () => _insertRichTextHeader(4),

      // List shortcuts
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.digit8): () => _insertRichTextList('unordered'),
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.digit7): () => _insertRichTextList('ordered'),

      // Undo/Redo
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyZ): _undo,
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyY): _redo,
      LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.shift, LogicalKeyboardKey.keyZ): _redo,
    };
  }

  // Optimized synchronization methods
  void _scheduleSyncToMarkdown() {
    // Cancel any pending sync to avoid redundant updates
    _syncToMarkdownTimer?.cancel();

    // Schedule sync with a slight delay to batch rapid changes
    _syncToMarkdownTimer = Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        _updateMarkdownController();
      }
    });
  }

  void _scheduleSyncFromMarkdown() {
    // Cancel any pending sync to avoid redundant updates
    _syncFromMarkdownTimer?.cancel();

    // Schedule sync with a slight delay to batch rapid changes
    _syncFromMarkdownTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) {
        _syncFromMarkdown();
      }
    });
  }


  // Smart text formatting methods that work with selections
  void _toggleBold() {
    _toggleFormatting('**', '**', 'Bold text');
  }

  void _toggleItalic() {
    _toggleFormatting('*', '*', 'Italic text');
  }

  void _toggleStrikethrough() {
    _toggleFormatting('~~', '~~', 'Strikethrough text');
  }

  void _toggleUnderline() {
    _toggleFormatting('<u>', '</u>', 'Underlined text');
  }

  void _toggleSuperscript() {
    _toggleFormatting('<sup>', '</sup>', 'Superscript');
  }

  void _toggleSubscript() {
    _toggleFormatting('<sub>', '</sub>', 'Subscript');
  }

  void _toggleHighlight() {
    _toggleFormatting('==', '==', 'Highlighted text');
  }

  void _toggleInlineCode() {
    _toggleFormatting('`', '`', 'code');
  }

  void _toggleFormatting(String startMark, String endMark, String placeholder) {
    if (_showMarkdown) {
      _toggleMarkdownFormatting(startMark, endMark, placeholder);
    } else {
      _toggleRichTextFormatting(startMark, endMark);
    }
  }

  void _toggleRichTextFormatting(String startMark, String endMark) {
    // Enhanced null safety checks
    if (_document.nodeCount == 0) {
      debugPrint('Document is empty, cannot apply formatting');
      return;
    }

    final selection = _composer.selection;
    if (selection == null) {
      // Create a default selection at the beginning of the document
      final firstNode = _document.getNodeAt(0);
      if (firstNode == null) return;

      try {
        final initialPosition = DocumentPosition(
          nodeId: firstNode.id,
          nodePosition: firstNode is TextNode
            ? const TextNodePosition(offset: 0)
            : firstNode.beginningPosition,
        );

        _composer.setSelectionWithReason(
          DocumentSelection.collapsed(position: initialPosition),
          SelectionReason.userInteraction,
        );
      } catch (e) {
        debugPrint('Failed to create selection: $e');
      }
      return; // Let the user click to create a selection first
    }

    // Validate selection positions exist in document
    try {
      final baseNode = _document.getNodeById(selection.base.nodeId);
      final extentNode = _document.getNodeById(selection.extent.nodeId);
      if (baseNode == null || extentNode == null) {
        debugPrint('Selection references non-existent nodes');
        return;
      }
    } catch (e) {
      debugPrint('Invalid selection: $e');
      return;
    }

    _saveUndoState();

    // Map markdown syntax to Super Editor attributions
    Attribution? attribution;
    if (startMark == '**') {
      attribution = boldAttribution;
    } else if (startMark == '*') {
      attribution = italicsAttribution;
    } else if (startMark == '~~') {
      attribution = strikethroughAttribution;
    } else if (startMark == '`') {
      attribution = codeAttribution;
    }

    if (attribution != null) {
      try {
        // Use the correct Super Editor command with proper request format
        _editor.execute([
          ToggleTextAttributionsRequest(
            documentRange: selection,
            attributions: {attribution},
          ),
        ]);

        // Update markdown representation after the rich text change (optimized timing)
        _scheduleSyncToMarkdown();
      } catch (e) {
        debugPrint('Rich text formatting error: $e');
        // Fallback to markdown mode if the command fails
        _updateMarkdownController();
        setState(() {
          _showMarkdown = true;
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          _toggleMarkdownFormatting(startMark, endMark, 'text');
        });
      }
    }
  }

  void _toggleMarkdownFormatting(String startMark, String endMark, String placeholder) {
    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    // Save state for undo
    _saveUndoState();

    if (!selection.isValid) {
      // No selection, insert template at cursor
      final insertText = '$startMark$placeholder$endMark';
      final newText = text.replaceRange(selection.start, selection.end, insertText);

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: selection.start + startMark.length,
          extentOffset: selection.start + startMark.length + placeholder.length,
        ),
      );
      return;
    }

    final selectedText = text.substring(selection.start, selection.end);

    // Check if text is already formatted
    if (selectedText.startsWith(startMark) && selectedText.endsWith(endMark)) {
      // Remove formatting
      final unformattedText = selectedText.substring(
        startMark.length,
        selectedText.length - endMark.length,
      );

      final newText = text.replaceRange(selection.start, selection.end, unformattedText);

      controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection(
          baseOffset: selection.start,
          extentOffset: selection.start + unformattedText.length,
        ),
      );
    } else {
      // Check if formatting surrounds the selection
      final beforeStart = selection.start >= startMark.length ?
          text.substring(selection.start - startMark.length, selection.start) : '';
      final afterEnd = selection.end + endMark.length <= text.length ?
          text.substring(selection.end, selection.end + endMark.length) : '';

      if (beforeStart == startMark && afterEnd == endMark) {
        // Remove surrounding formatting
        final newText = text.replaceRange(selection.end, selection.end + endMark.length, '') // Remove end mark first
            .replaceRange(selection.start - startMark.length, selection.start, ''); // Then start mark

        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: selection.start - startMark.length,
            extentOffset: selection.end - startMark.length,
          ),
        );
      } else {
        // Add formatting around selection
        final formattedText = '$startMark$selectedText$endMark';
        final newText = text.replaceRange(selection.start, selection.end, formattedText);

        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection(
            baseOffset: selection.start + startMark.length,
            extentOffset: selection.end + startMark.length,
          ),
        );
      }
    }

    // Always sync changes back to rich text
    _syncFromMarkdown();
  }

  // Undo/Redo functionality
  void _saveUndoState() {
    final currentText = _markdownController.text;

    // Mark as changed when saving undo state
    _markAsChanged();

    // Don't save if text hasn't changed
    if (_undoStack.isNotEmpty && _undoStack.last == currentText) {
      return;
    }

    _undoStack.add(currentText);

    // Limit undo stack size
    if (_undoStack.length > _maxUndoSteps) {
      _undoStack.removeAt(0);
    }

    // Clear redo stack when new action is performed
    _redoStack.clear();
  }

  bool _canUndo() => _undoStack.length > 1;
  bool _canRedo() => _redoStack.isNotEmpty;

  void _undo() {
    if (!_canUndo()) return;

    final currentText = _markdownController.text;
    _redoStack.add(currentText);

    final previousText = _undoStack.removeLast();

    _isUpdating = true;
    _markdownController.text = previousText;
    _isUpdating = false;

    // Trigger sync to rich text
    _syncFromMarkdown();
  }

  void _redo() {
    if (!_canRedo()) return;

    final currentText = _markdownController.text;
    _undoStack.add(currentText);

    final nextText = _redoStack.removeLast();

    _isUpdating = true;
    _markdownController.text = nextText;
    _isUpdating = false;

    // Trigger sync to rich text
    _syncFromMarkdown();
  }

  // Handle keyboard shortcuts
  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final isCtrlPressed = event.logicalKey == LogicalKeyboardKey.controlLeft ||
          event.logicalKey == LogicalKeyboardKey.controlRight ||
          HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlLeft) ||
          HardwareKeyboard.instance.logicalKeysPressed.contains(LogicalKeyboardKey.controlRight);

      if (isCtrlPressed) {
        if (event.logicalKey == LogicalKeyboardKey.keyZ) {
          _undo();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyY) {
          _redo();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyB) {
          _toggleBold();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyI) {
          _toggleItalic();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyK) {
          _showLinkDialog();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyF) {
          _showFindReplaceDialog();
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyH) {
          _showFindReplaceDialog(showReplace: true);
          return KeyEventResult.handled;
        } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
          _forceSave();
          return KeyEventResult.handled;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  // Link insertion dialog
  void _showLinkDialog() async {
    final controller = _markdownController;
    final selection = controller.selection;

    // Get selected text if any
    String initialText = '';
    if (_showMarkdown && selection.isValid) {
      initialText = controller.text.substring(selection.start, selection.end);
    }

    // Check clipboard for URL
    String initialUrl = '';
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final clipboardText = clipboardData?.text ?? '';
      if (clipboardText.isNotEmpty && (clipboardText.startsWith('http://') || clipboardText.startsWith('https://'))) {
        initialUrl = clipboardText;
      }
    } catch (e) {
      // Ignore clipboard errors
    }

    if (!mounted) return;

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => _LinkDialog(
        initialText: initialText,
        initialUrl: initialUrl,
      ),
    );

    if (result != null) {
      final text = result['text'] ?? '';
      final url = result['url'] ?? '';
      final linkMarkdown = '[$text]($url)';

      if (_showMarkdown) {
        _saveUndoState();

        final newText = controller.text.replaceRange(
          selection.start,
          selection.end,
          linkMarkdown,
        );

        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: selection.start + linkMarkdown.length,
          ),
        );
      } else {
        _insertMarkdown(linkMarkdown);
      }
    }
  }


  // Enhanced block formatting methods
  void _insertQuoteBlock() {
    // For now, use markdown insertion which syncs properly
    // Super Editor's blockquote API needs more investigation
    _insertMarkdown('\n> ');
  }

  void _insertHorizontalRule() {
    // Use markdown insertion for now
    _insertMarkdown('\n---\n');
  }

  void _clearFormatting() {
    // Clear all formatting from selected text
    final selection = _composer.selection;
    if (selection == null) return;

    _saveUndoState();

    try {
      // Clear all text attributions from selection
      _editor.execute([
        RemoveTextAttributionsRequest(
          documentRange: selection,
          attributions: {
            boldAttribution,
            italicsAttribution,
            strikethroughAttribution,
            underlineAttribution,
            codeAttribution,
          },
        ),
      ]);
      _scheduleSyncToMarkdown();
    } catch (e) {
      debugPrint('Failed to clear formatting: $e');
      // Fallback to markdown mode
      _updateMarkdownController();
      setState(() {
        _showMarkdown = true;
      });
    }
  }

  void _showImageDialog() {
    showDialog(
      context: context,
      builder: (context) => _ImageInsertDialog(
        onInsert: (url, altText) {
          _insertMarkdown('![$altText]($url)');
        },
      ),
    );
  }

  void _showDocumentStats() {
    final markdown = serializeDocumentToMarkdown(_document);
    final stats = _calculateDocumentStats(markdown);

    showDialog(
      context: context,
      builder: (context) => _DocumentStatisticsDialog(
        stats: stats,
      ),
    );
  }

  // Rich text header insertion
  void _insertRichTextHeader(int level) {
    // Use markdown insertion which will sync to rich text
    final headerMarkdown = '\n${'#' * level} ';
    _insertMarkdown(headerMarkdown);
  }

  // Rich text list insertion (with fallback to markdown)
  void _insertRichTextList(String listType) {
    // For now, use markdown approach since the advanced commands need more research
    // This still provides rich text synchronization through our existing system
    final listMarkdown = listType == 'unordered' ? '- ' : '1. ';
    _insertMarkdown('\n$listMarkdown');
  }

  // Code action handler
  void _handleCodeAction(String action) {
    switch (action) {
      case 'inline_code':
        _toggleInlineCode();
        break;
      case 'code_block_plain':
        _insertCodeBlock();
        break;
      case 'code_bash':
        _insertCodeBlock('bash');
        break;
      case 'code_python':
        _insertCodeBlock('python');
        break;
      case 'code_javascript':
        _insertCodeBlock('javascript');
        break;
      case 'code_json':
        _insertCodeBlock('json');
        break;
      case 'code_xml':
        _insertCodeBlock('xml');
        break;
      case 'code_sql':
        _insertCodeBlock('sql');
        break;
      case 'code_yaml':
        _insertCodeBlock('yaml');
        break;
      case 'code_powershell':
        _insertCodeBlock('powershell');
        break;
      case 'code_custom':
        _showCustomCodeDialog();
        break;
    }
  }

  void _insertCodeBlock([String? language]) {
    final langSuffix = language != null ? language : '';
    final codeBlock = '\n```$langSuffix\nYour code here\n```\n';
    _insertMarkdown(codeBlock);
  }

  void _showCustomCodeDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom Language'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Language name (e.g. rust, go, c++)',
            hintText: 'Enter language identifier',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Insert'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      _insertCodeBlock(result);
    }
    controller.dispose();
  }

  // List action handler
  void _handleListAction(String action) {
    switch (action) {
      case 'bullet_list':
        _insertRichTextList('unordered');
        break;
      case 'numbered_list':
        _insertRichTextList('ordered');
        break;
      case 'indent_list':
        _indentCurrentLine();
        break;
      case 'outdent_list':
        _outdentCurrentLine();
        break;
      case 'checklist':
        _insertMarkdown('\n- [ ] ');
        break;
      case 'convert_to_bullet':
        _convertListType('bullet');
        break;
      case 'convert_to_numbered':
        _convertListType('numbered');
        break;
    }
  }

  void _handleAlignmentAction(String alignment) {
    // For now, implement basic HTML-style alignment in markdown
    // This could be enhanced with custom CSS or Super Editor styling
    String alignmentTag;
    switch (alignment) {
      case 'left':
        alignmentTag = '<div align="left">\n\n</div>';
        break;
      case 'center':
        alignmentTag = '<div align="center">\n\n</div>';
        break;
      case 'right':
        alignmentTag = '<div align="right">\n\n</div>';
        break;
      case 'justify':
        alignmentTag = '<div align="justify">\n\n</div>';
        break;
      default:
        return;
    }
    _insertMarkdown(alignmentTag);
  }

  void _indentCurrentLine() {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _indentCurrentLine();
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    _saveUndoState();

    // Find the current line
    final lines = text.split('\n');
    int currentLineIndex = 0;
    int charCount = 0;

    for (int i = 0; i < lines.length; i++) {
      if (charCount + lines[i].length >= selection.start) {
        currentLineIndex = i;
        break;
      }
      charCount += lines[i].length + 1; // +1 for newline
    }

    String currentLine = lines[currentLineIndex];

    // Check if it's already a list item
    if (currentLine.trim().startsWith('- ') ||
        currentLine.trim().startsWith('* ') ||
        RegExp(r'^\s*\d+\.\s').hasMatch(currentLine.trim()) ||
        currentLine.trim().startsWith('- [ ]') ||
        currentLine.trim().startsWith('- [x]')) {
      // Add two spaces at the beginning for indentation
      lines[currentLineIndex] = '  $currentLine';
    } else {
      // Convert to indented bullet point
      final trimmed = currentLine.trim();
      final leadingSpaces = currentLine.length - currentLine.trimLeft().length;
      lines[currentLineIndex] = '  ' + ' ' * leadingSpaces + '- $trimmed';
    }

    final newText = lines.join('\n');
    controller.text = newText;

    // Restore cursor position (approximately)
    controller.selection = TextSelection.collapsed(
      offset: math.min(selection.start + 2, newText.length),
    );
  }

  void _outdentCurrentLine() {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _outdentCurrentLine();
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    if (!selection.isValid) return;

    _saveUndoState();

    // Find the current line
    final lines = text.split('\n');
    int currentLineIndex = 0;
    int charCount = 0;

    for (int i = 0; i < lines.length; i++) {
      if (charCount + lines[i].length >= selection.start) {
        currentLineIndex = i;
        break;
      }
      charCount += lines[i].length + 1; // +1 for newline
    }

    String currentLine = lines[currentLineIndex];

    // Remove two spaces from the beginning if they exist
    if (currentLine.startsWith('  ')) {
      lines[currentLineIndex] = currentLine.substring(2);

      final newText = lines.join('\n');
      controller.text = newText;

      // Restore cursor position (approximately)
      controller.selection = TextSelection.collapsed(
        offset: math.max(selection.start - 2, 0),
      );
    } else if (currentLine.trim().startsWith('- ') ||
               currentLine.trim().startsWith('* ') ||
               RegExp(r'^\s*\d+\.\s').hasMatch(currentLine.trim()) ||
               currentLine.trim().startsWith('- [ ]') ||
               currentLine.trim().startsWith('- [x]')) {
      // Convert to plain text
      final trimmed = currentLine.trim();
      String content = '';

      if (trimmed.startsWith('- ')) {
        content = trimmed.substring(2);
      } else if (trimmed.startsWith('* ')) {
        content = trimmed.substring(2);
      } else if (trimmed.startsWith('- [ ] ')) {
        content = trimmed.substring(6);
      } else if (trimmed.startsWith('- [x] ')) {
        content = trimmed.substring(6);
      } else if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) {
        content = trimmed.replaceFirst(RegExp(r'^\d+\.\s'), '');
      }

      lines[currentLineIndex] = content;

      final newText = lines.join('\n');
      controller.text = newText;
    }
  }

  void _convertListType(String type) {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _convertListType(type);
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    _saveUndoState();

    final lines = text.split('\n');
    bool hasChanges = false;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();

      if (trimmed.startsWith('- ') ||
          trimmed.startsWith('* ') ||
          RegExp(r'^\d+\.\s').hasMatch(trimmed)) {

        final leadingSpaces = line.length - line.trimLeft().length;
        String content = '';

        if (trimmed.startsWith('- ')) {
          content = trimmed.substring(2);
        } else if (trimmed.startsWith('* ')) {
          content = trimmed.substring(2);
        } else if (RegExp(r'^\d+\.\s').hasMatch(trimmed)) {
          content = trimmed.replaceFirst(RegExp(r'^\d+\.\s'), '');
        }

        if (type == 'bullet') {
          lines[i] = ' ' * leadingSpaces + '- $content';
        } else if (type == 'numbered') {
          lines[i] = ' ' * leadingSpaces + '1. $content';
        }

        hasChanges = true;
      }
    }

    if (hasChanges) {
      controller.text = lines.join('\n');
      controller.selection = selection;
    }
  }

  // Table action handler
  void _handleTableAction(String action) {
    switch (action) {
      case 'insert_table':
        _insertTable();
        break;
      case 'custom_table':
        _showCustomTableDialog();
        break;
      case 'add_row':
        _addTableRow();
        break;
      case 'add_column':
        _addTableColumn();
        break;
      case 'delete_row':
        _deleteTableRow();
        break;
      case 'delete_column':
        _deleteTableColumn();
        break;
      case 'format_table':
        _showTableFormatDialog();
        break;
    }
  }

  // Advanced table management functions
  void _addTableRow() {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _addTableRow();
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    // Find the table the cursor is in
    final tableInfo = _findTableAtCursor(text, selection.start);
    if (tableInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cursor must be inside a table to add a row')),
      );
      return;
    }

    _saveUndoState();

    // Create new row with empty cells
    final newRow = '| ${List.filled(tableInfo.columnCount, ' ').join(' | ')} |';

    // Insert the new row after the current row
    final lines = text.split('\n');
    final insertIndex = tableInfo.currentRowIndex + 1;

    if (insertIndex < lines.length) {
      lines.insert(insertIndex, newRow);
    } else {
      lines.add(newRow);
    }

    final newText = lines.join('\n');
    controller.text = newText;

    // Position cursor in first cell of new row
    final newCursorPos = _getTableCellPosition(newText, insertIndex, 0);
    controller.selection = TextSelection.collapsed(offset: newCursorPos);
  }

  void _addTableColumn() {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _addTableColumn();
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    final tableInfo = _findTableAtCursor(text, selection.start);
    if (tableInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cursor must be inside a table to add a column')),
      );
      return;
    }

    _saveUndoState();

    final lines = text.split('\n');
    final updatedLines = <String>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (i >= tableInfo.startRowIndex && i <= tableInfo.endRowIndex) {
        // This is a table row, add a column
        if (i == tableInfo.startRowIndex + 1) {
          // Header separator row
          updatedLines.add('$line-----------|');
        } else {
          // Regular row
          updatedLines.add('$line |');
        }
      } else {
        updatedLines.add(line);
      }
    }

    controller.text = updatedLines.join('\n');
  }

  void _deleteTableRow() {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _deleteTableRow();
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    final tableInfo = _findTableAtCursor(text, selection.start);
    if (tableInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cursor must be inside a table to delete a row')),
      );
      return;
    }

    if (tableInfo.endRowIndex - tableInfo.startRowIndex <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete row - table must have at least one data row')),
      );
      return;
    }

    _saveUndoState();

    final lines = text.split('\n');

    // Don't allow deleting header or separator row
    if (tableInfo.currentRowIndex <= tableInfo.startRowIndex + 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot delete header or separator row')),
      );
      return;
    }

    lines.removeAt(tableInfo.currentRowIndex);
    controller.text = lines.join('\n');
  }

  void _deleteTableColumn() {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _deleteTableColumn();
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    final tableInfo = _findTableAtCursor(text, selection.start);
    if (tableInfo == null || tableInfo.columnCount <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Table must have at least one column')),
      );
      return;
    }

    _saveUndoState();

    final lines = text.split('\n');
    final currentColumn = _getCurrentColumn(lines[tableInfo.currentRowIndex], selection.start);
    final updatedLines = <String>[];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (i >= tableInfo.startRowIndex && i <= tableInfo.endRowIndex) {
        final cells = line.split('|').map((cell) => cell.trim()).toList();
        if (cells.length > currentColumn + 1) {
          cells.removeAt(currentColumn + 1); // +1 because first element is empty due to leading |
          updatedLines.add('| ${cells.skip(1).join(' | ')} |'); // skip first empty element
        } else {
          updatedLines.add(line);
        }
      } else {
        updatedLines.add(line);
      }
    }

    controller.text = updatedLines.join('\n');
  }

  void _showCustomTableDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _CustomTableDialog(),
    );

    if (result != null) {
      final rows = result['rows'] as int;
      final columns = result['columns'] as int;
      final hasHeader = result['hasHeader'] as bool;
      final alignment = result['alignment'] as String;

      _insertCustomTable(rows, columns, hasHeader, alignment);
    }
  }

  void _insertCustomTable(int rows, int columns, bool hasHeader, String alignment) {
    final alignmentChar = alignment == 'center' ? ':---:' :
                         alignment == 'right' ? '---:' : '---';

    final headerRow = '| ${List.filled(columns, hasHeader ? 'Header' : 'Cell').join(' | ')} |';
    final separatorRow = '| ${List.filled(columns, alignmentChar).join(' | ')} |';
    final dataRows = List.generate(
      hasHeader ? rows - 1 : rows,
      (index) => '| ${List.filled(columns, 'Cell').join(' | ')} |',
    );

    final tableMarkdown = [
      '',
      headerRow,
      separatorRow,
      ...dataRows,
      '',
    ].join('\n');

    _insertMarkdown(tableMarkdown);
  }

  void _showTableFormatDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const _TableFormatDialog(),
    );

    if (result != null) {
      _formatTable(result);
    }
  }

  void _formatTable(String alignment) {
    if (!_showMarkdown) {
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });
      Future.delayed(const Duration(milliseconds: 100), () {
        _formatTable(alignment);
      });
      return;
    }

    final controller = _markdownController;
    final text = controller.text;
    final selection = controller.selection;

    final tableInfo = _findTableAtCursor(text, selection.start);
    if (tableInfo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cursor must be inside a table to format it')),
      );
      return;
    }

    _saveUndoState();

    final alignmentChar = alignment == 'center' ? ':---:' :
                         alignment == 'right' ? '---:' : '---';

    final lines = text.split('\n');

    // Update separator row
    final separatorRowIndex = tableInfo.startRowIndex + 1;
    final cells = lines[tableInfo.startRowIndex].split('|')
        .map((cell) => cell.trim())
        .where((cell) => cell.isNotEmpty)
        .length;

    lines[separatorRowIndex] = '| ${List.filled(cells, alignmentChar).join(' | ')} |';

    controller.text = lines.join('\n');
  }

  // Helper functions for table management
  TableInfo? _findTableAtCursor(String text, int cursorPosition) {
    final lines = text.split('\n');
    int charCount = 0;
    int currentRowIndex = -1;

    // Find which line the cursor is on
    for (int i = 0; i < lines.length; i++) {
      final lineLength = lines[i].length + 1; // +1 for newline
      if (charCount + lineLength > cursorPosition) {
        currentRowIndex = i;
        break;
      }
      charCount += lineLength;
    }

    if (currentRowIndex == -1) return null;

    // Check if current line is a table row
    if (!lines[currentRowIndex].trim().startsWith('|') ||
        !lines[currentRowIndex].trim().endsWith('|')) {
      return null;
    }

    // Find table boundaries
    int startRowIndex = currentRowIndex;
    int endRowIndex = currentRowIndex;

    // Find start of table
    for (int i = currentRowIndex - 1; i >= 0; i--) {
      if (lines[i].trim().startsWith('|') && lines[i].trim().endsWith('|')) {
        startRowIndex = i;
      } else {
        break;
      }
    }

    // Find end of table
    for (int i = currentRowIndex + 1; i < lines.length; i++) {
      if (lines[i].trim().startsWith('|') && lines[i].trim().endsWith('|')) {
        endRowIndex = i;
      } else {
        break;
      }
    }

    // Count columns
    final headerCells = lines[startRowIndex].split('|')
        .map((cell) => cell.trim())
        .where((cell) => cell.isNotEmpty);

    return TableInfo(
      startRowIndex: startRowIndex,
      endRowIndex: endRowIndex,
      currentRowIndex: currentRowIndex,
      columnCount: headerCells.length,
    );
  }

  int _getCurrentColumn(String tableRow, int cursorPosition) {
    // This is a simplified implementation
    final beforeCursor = tableRow.substring(0, math.min(cursorPosition, tableRow.length));
    return beforeCursor.split('|').length - 2; // -2 because of leading | and 0-based index
  }

  int _getTableCellPosition(String text, int rowIndex, int columnIndex) {
    final lines = text.split('\n');
    if (rowIndex >= lines.length) return text.length;

    final line = lines[rowIndex];
    final cells = line.split('|');

    if (columnIndex >= cells.length - 1) return text.length;

    // Calculate position of the start of the desired cell
    int position = 0;
    for (int i = 0; i < rowIndex; i++) {
      position += lines[i].length + 1; // +1 for newline
    }

    // Add position within the row to get to the desired column
    for (int i = 0; i <= columnIndex; i++) {
      position += cells[i].length + 1; // +1 for |
    }

    return position + 1; // +1 to position cursor after the |
  }
}

// Table information class
class TableInfo {
  final int startRowIndex;
  final int endRowIndex;
  final int currentRowIndex;
  final int columnCount;

  TableInfo({
    required this.startRowIndex,
    required this.endRowIndex,
    required this.currentRowIndex,
    required this.columnCount,
  });
}

// Custom Table Dialog
class _CustomTableDialog extends StatefulWidget {
  const _CustomTableDialog();

  @override
  State<_CustomTableDialog> createState() => _CustomTableDialogState();
}

class _CustomTableDialogState extends State<_CustomTableDialog> {
  int _rows = 3;
  int _columns = 3;
  bool _hasHeader = true;
  String _alignment = 'left';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Custom Table'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('Rows: '),
              Expanded(
                child: Slider(
                  value: _rows.toDouble(),
                  min: 2,
                  max: 10,
                  divisions: 8,
                  label: _rows.toString(),
                  onChanged: (value) => setState(() => _rows = value.round()),
                ),
              ),
              Text('$_rows'),
            ],
          ),
          Row(
            children: [
              const Text('Columns: '),
              Expanded(
                child: Slider(
                  value: _columns.toDouble(),
                  min: 2,
                  max: 8,
                  divisions: 6,
                  label: _columns.toString(),
                  onChanged: (value) => setState(() => _columns = value.round()),
                ),
              ),
              Text('$_columns'),
            ],
          ),
          SwitchListTile(
            title: const Text('Include Header Row'),
            value: _hasHeader,
            onChanged: (value) => setState(() => _hasHeader = value),
          ),
          const SizedBox(height: 8),
          const Text('Column Alignment:'),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'left', label: Text('Left')),
              ButtonSegment(value: 'center', label: Text('Center')),
              ButtonSegment(value: 'right', label: Text('Right')),
            ],
            selected: {_alignment},
            onSelectionChanged: (selection) => setState(() => _alignment = selection.first),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop({
            'rows': _rows,
            'columns': _columns,
            'hasHeader': _hasHeader,
            'alignment': _alignment,
          }),
          child: const Text('Create'),
        ),
      ],
    );
  }
}

// Table Format Dialog
class _TableFormatDialog extends StatelessWidget {
  const _TableFormatDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Format Table'),
      content: const Text('Choose column alignment for the table:'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('left'),
          child: const Text('Left'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('center'),
          child: const Text('Center'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop('right'),
          child: const Text('Right'),
        ),
      ],
    );
  }
}

// Header information class
class HeaderInfo {
  final int level;
  final String title;
  final int lineNumber;
  final int charPosition;

  const HeaderInfo({
    required this.level,
    required this.title,
    required this.lineNumber,
    required this.charPosition,
  });
}

// Document Outline Dialog
class _DocumentOutlineDialog extends StatelessWidget {
  final List<HeaderInfo> headers;
  final Function(HeaderInfo) onHeaderTap;

  const _DocumentOutlineDialog({
    required this.headers,
    required this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Document Outline'),
      content: SizedBox(
        width: double.maxFinite,
        height: 400,
        child: ListView.builder(
          itemCount: headers.length,
          itemBuilder: (context, index) {
            final header = headers[index];
            return ListTile(
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                child: Text(
                  'H${header.level}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              title: Text(
                header.title,
                style: TextStyle(
                  fontSize: 16 - (header.level * 0.5), // Smaller text for deeper headers
                  fontWeight: header.level <= 2 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text('Line ${header.lineNumber}'),
              contentPadding: EdgeInsets.only(
                left: 16.0 + (header.level - 1) * 16.0, // Indent based on header level
                right: 16.0,
              ),
              onTap: () => onHeaderTap(header),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

// Document Statistics class
class DocumentStats {
  final int characters;
  final int charactersNoSpaces;
  final int words;
  final int sentences;
  final int paragraphs;
  final int lines;
  final int readingMinutes;
  final int headers;
  final int codeBlocks;
  final int inlineCode;
  final int links;
  final int images;
  final int listItems;
  final int tables;

  const DocumentStats({
    required this.characters,
    required this.charactersNoSpaces,
    required this.words,
    required this.sentences,
    required this.paragraphs,
    required this.lines,
    required this.readingMinutes,
    required this.headers,
    required this.codeBlocks,
    required this.inlineCode,
    required this.links,
    required this.images,
    required this.listItems,
    required this.tables,
  });
}

// Document Statistics Dialog
class _DocumentStatisticsDialog extends StatelessWidget {
  final DocumentStats stats;

  const _DocumentStatisticsDialog({required this.stats});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildStatItem(String label, String value, {IconData? icon}) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
            ],
            Expanded(child: Text(label)),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      );
    }

    return AlertDialog(
      title: const Text('Document Statistics'),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Text Statistics',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(),
            buildStatItem('Words', '${stats.words}', icon: Icons.text_fields),
            buildStatItem('Characters', '${stats.characters}', icon: Icons.abc),
            buildStatItem('Characters (no spaces)', '${stats.charactersNoSpaces}'),
            buildStatItem('Sentences', '${stats.sentences}', icon: Icons.circle),
            buildStatItem('Paragraphs', '${stats.paragraphs}', icon: Icons.view_agenda),
            buildStatItem('Lines', '${stats.lines}', icon: Icons.format_align_left),
            buildStatItem(
              'Reading time',
              '${stats.readingMinutes} min${stats.readingMinutes == 1 ? '' : 's'}',
              icon: Icons.schedule,
            ),

            const SizedBox(height: 16),

            Text(
              'Markdown Elements',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Divider(),
            buildStatItem('Headers', '${stats.headers}', icon: Icons.title),
            buildStatItem('Code blocks', '${stats.codeBlocks}', icon: Icons.code),
            buildStatItem('Inline code', '${stats.inlineCode}', icon: Icons.code),
            buildStatItem('Links', '${stats.links}', icon: Icons.link),
            buildStatItem('Images', '${stats.images}', icon: Icons.image),
            buildStatItem('List items', '${stats.listItems}', icon: Icons.list),
            buildStatItem('Tables', '${stats.tables}', icon: Icons.table_chart),

            if (stats.words > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reading time based on 200 words/minute average',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}

// Find Replace Dialog
class _FindReplaceDialog extends StatefulWidget {
  final TextEditingController controller;
  final bool showReplace;
  final Function(String findText, String replaceText, bool replaceAll) onReplace;

  const _FindReplaceDialog({
    required this.controller,
    required this.showReplace,
    required this.onReplace,
  });

  @override
  State<_FindReplaceDialog> createState() => _FindReplaceDialogState();
}

class _FindReplaceDialogState extends State<_FindReplaceDialog> {
  late TextEditingController _findController;
  late TextEditingController _replaceController;
  bool _caseSensitive = false;
  bool _wholeWord = false;
  int _currentMatchIndex = -1;
  int _totalMatches = 0;
  List<int> _matchPositions = [];

  @override
  void initState() {
    super.initState();
    _findController = TextEditingController();
    _replaceController = TextEditingController();
    _findController.addListener(_updateMatches);
  }

  @override
  void dispose() {
    _findController.dispose();
    _replaceController.dispose();
    super.dispose();
  }

  void _updateMatches() {
    final findText = _findController.text;
    final docText = widget.controller.text;

    if (findText.isEmpty) {
      setState(() {
        _matchPositions.clear();
        _totalMatches = 0;
        _currentMatchIndex = -1;
      });
      return;
    }

    final searchText = _caseSensitive ? docText : docText.toLowerCase();
    final searchPattern = _caseSensitive ? findText : findText.toLowerCase();

    _matchPositions.clear();
    int startIndex = 0;

    while (true) {
      int index = searchText.indexOf(searchPattern, startIndex);
      if (index == -1) break;

      if (_wholeWord) {
        // Check if it's a whole word
        bool isWholeWord = true;
        if (index > 0 && RegExp(r'\w').hasMatch(docText[index - 1])) {
          isWholeWord = false;
        }
        if (index + searchPattern.length < docText.length &&
            RegExp(r'\w').hasMatch(docText[index + searchPattern.length])) {
          isWholeWord = false;
        }
        if (isWholeWord) {
          _matchPositions.add(index);
        }
      } else {
        _matchPositions.add(index);
      }

      startIndex = index + 1;
    }

    setState(() {
      _totalMatches = _matchPositions.length;
      _currentMatchIndex = _totalMatches > 0 ? 0 : -1;
    });

    if (_totalMatches > 0) {
      _highlightMatch(0);
    }
  }

  void _highlightMatch(int matchIndex) {
    if (matchIndex < 0 || matchIndex >= _matchPositions.length) return;

    final position = _matchPositions[matchIndex];
    final findText = _findController.text;

    widget.controller.selection = TextSelection(
      baseOffset: position,
      extentOffset: position + findText.length,
    );

    setState(() {
      _currentMatchIndex = matchIndex;
    });
  }

  void _findNext() {
    if (_totalMatches == 0) return;
    final nextIndex = (_currentMatchIndex + 1) % _totalMatches;
    _highlightMatch(nextIndex);
  }

  void _findPrevious() {
    if (_totalMatches == 0) return;
    final prevIndex = (_currentMatchIndex - 1 + _totalMatches) % _totalMatches;
    _highlightMatch(prevIndex);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.showReplace ? 'Find & Replace' : 'Find'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Find field
            TextField(
              controller: _findController,
              decoration: InputDecoration(
                labelText: 'Find',
                hintText: 'Enter text to find...',
                suffixText: _totalMatches > 0 ? '${_currentMatchIndex + 1}/$_totalMatches' : '',
              ),
              autofocus: true,
            ),

            const SizedBox(height: 8),

            // Replace field (if shown)
            if (widget.showReplace) ...[
              TextField(
                controller: _replaceController,
                decoration: const InputDecoration(
                  labelText: 'Replace with',
                  hintText: 'Enter replacement text...',
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Options
            Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Case sensitive', style: TextStyle(fontSize: 12)),
                    value: _caseSensitive,
                    onChanged: (value) {
                      setState(() {
                        _caseSensitive = value ?? false;
                      });
                      _updateMatches();
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: CheckboxListTile(
                    title: const Text('Whole word', style: TextStyle(fontSize: 12)),
                    value: _wholeWord,
                    onChanged: (value) {
                      setState(() {
                        _wholeWord = value ?? false;
                      });
                      _updateMatches();
                    },
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Navigation buttons
            Row(
              children: [
                IconButton(
                  onPressed: _totalMatches > 0 ? _findPrevious : null,
                  icon: const Icon(Icons.keyboard_arrow_up),
                  tooltip: 'Previous',
                ),
                IconButton(
                  onPressed: _totalMatches > 0 ? _findNext : null,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  tooltip: 'Next',
                ),
                const Spacer(),
                Text(
                  _totalMatches == 0
                      ? (_findController.text.isEmpty ? '' : 'No matches')
                      : '$_totalMatches matches found',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        if (widget.showReplace) ...[
          TextButton(
            onPressed: _totalMatches > 0
                ? () {
                    widget.onReplace(_findController.text, _replaceController.text, false);
                    _updateMatches();
                  }
                : null,
            child: const Text('Replace'),
          ),
          TextButton(
            onPressed: _totalMatches > 0
                ? () {
                    widget.onReplace(_findController.text, _replaceController.text, true);
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text('Replace All'),
          ),
        ],
      ],
    );
  }
}

// Link Dialog Widget
class _LinkDialog extends StatefulWidget {
  final String initialText;
  final String initialUrl;

  const _LinkDialog({
    required this.initialText,
    required this.initialUrl,
  });

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  late TextEditingController _textController;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.initialText);
    _urlController = TextEditingController(text: widget.initialUrl);
  }

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Insert Link'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Display Text',
              hintText: 'Click here',
            ),
            autofocus: widget.initialText.isEmpty,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _urlController,
            decoration: const InputDecoration(
              labelText: 'URL',
              hintText: 'https://example.com',
            ),
            autofocus: widget.initialText.isNotEmpty,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Icon(Icons.preview, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Preview: [${_textController.text.isEmpty ? 'Display Text' : _textController.text}](${_urlController.text.isEmpty ? 'URL' : _urlController.text})',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_textController.text.isEmpty || _urlController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter both display text and URL')),
              );
              return;
            }

            Navigator.of(context).pop({
              'text': _textController.text,
              'url': _urlController.text,
            });
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}

// Enhanced Image Insert Dialog
class _ImageInsertDialog extends StatefulWidget {
  final Function(String url, String altText) onInsert;

  const _ImageInsertDialog({
    required this.onInsert,
  });

  @override
  State<_ImageInsertDialog> createState() => _ImageInsertDialogState();
}

class _ImageInsertDialogState extends State<_ImageInsertDialog> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _altController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _imageSource = 'url'; // 'url', 'file'

  @override
  void dispose() {
    _urlController.dispose();
    _altController.dispose();
    _titleController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Image'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image source selection
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'url',
                  label: Text('URL'),
                  icon: Icon(Icons.link),
                ),
                ButtonSegment(
                  value: 'file',
                  label: Text('File'),
                  icon: Icon(Icons.file_upload),
                ),
              ],
              selected: {_imageSource},
              onSelectionChanged: (Set<String> selection) {
                setState(() {
                  _imageSource = selection.first;
                });
              },
            ),

            const SizedBox(height: 16),

            if (_imageSource == 'url') ...[
              TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL *',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload, size: 48),
                    const SizedBox(height: 8),
                    const Text('File upload not implemented'),
                    const SizedBox(height: 4),
                    Text(
                      'Please use URL option for now',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            TextField(
              controller: _altController,
              decoration: const InputDecoration(
                labelText: 'Alt Text *',
                hintText: 'Descriptive text for accessibility',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title (Optional)',
                hintText: 'Tooltip text on hover',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _widthController,
                    decoration: const InputDecoration(
                      labelText: 'Width (Optional)',
                      hintText: '300px or 50%',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _heightController,
                    decoration: const InputDecoration(
                      labelText: 'Height (Optional)',
                      hintText: '200px or auto',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_imageSource == 'url' && _urlController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter an image URL')),
              );
              return;
            }

            if (_altController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter alt text for accessibility')),
              );
              return;
            }

            widget.onInsert(_urlController.text, _altController.text);
            Navigator.of(context).pop();
          },
          child: const Text('Insert Image'),
        ),
      ],
    );
  }
}