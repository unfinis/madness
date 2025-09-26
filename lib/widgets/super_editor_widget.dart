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
  }


  void _onMarkdownChanged() {
    if (_isUpdating || !_showMarkdown) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _syncFromMarkdown();
    });
  }

  void _updateMarkdownController() {
    if (_isUpdating) return;

    _isUpdating = true;
    try {
      final markdown = serializeDocumentToMarkdown(_document);
      _markdownController.text = markdown;
    } catch (e) {
      debugPrint('Serialization error: $e');
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
        _document = newDocument;
        _createEditor();
      });
      _notifyChanges();
    } catch (e) {
      debugPrint('Markdown sync error: $e');
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
                  // Text formatting
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
                    icon: Icons.strikethrough_s,
                    tooltip: 'Strikethrough',
                    onPressed: _toggleStrikethrough,
                  ),
                  _buildToolbarButton(
                    icon: Icons.code,
                    tooltip: 'Inline Code',
                    onPressed: () => _toggleInlineCode(),
                  ),
                  _buildToolbarButton(
                    icon: Icons.link,
                    tooltip: 'Insert Link (Ctrl+K)',
                    onPressed: _showLinkDialog,
                  ),

                  const SizedBox(width: 8),

                  // Headers dropdown
                  _buildHeaderDropdown(theme),

                  const SizedBox(width: 8),

                  // Lists
                  _buildListDropdown(theme),

                  const SizedBox(width: 8),

                  // Block elements
                  _buildToolbarButton(
                    icon: Icons.format_quote,
                    tooltip: 'Quote',
                    onPressed: () => _insertMarkdown('\n> '),
                  ),
                  _buildToolbarButton(
                    icon: Icons.horizontal_rule,
                    tooltip: 'Horizontal Rule',
                    onPressed: () => _insertMarkdown('\n---\n'),
                  ),
                  _buildCodeDropdown(theme),
                  // Table tools dropdown
                  _buildTableDropdown(theme),
                  _buildToolbarButton(
                    icon: Icons.image,
                    tooltip: 'Insert Image',
                    onPressed: () => _insertMarkdown('![Alt text](image-url)'),
                  ),

                  const SizedBox(width: 8),

                  // Undo/Redo
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
        final prefix = '#' * level;
        _insertMarkdown('\n$prefix ');
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

  Widget _buildRichEditor(ThemeData theme) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(AppSpacing.md),
      child: SuperEditor(
        editor: _editor,
        focusNode: _focusNode,
        stylesheet: defaultStylesheet.copyWith(
          addRulesAfter: [
            // Fix text indentation issues
            StyleRule(
              BlockSelector.all,
              (doc, docNode) => {
                Styles.textStyle: theme.textTheme.bodyMedium!,
                Styles.padding: const CascadingPadding.all(0), // Remove default padding
              },
            ),
            // Specific styling for paragraphs
            StyleRule(
              const BlockSelector("paragraph"),
              (doc, docNode) => {
                Styles.textStyle: theme.textTheme.bodyMedium!,
                Styles.padding: const CascadingPadding.symmetric(vertical: 4), // Minimal vertical padding
              },
            ),
          ],
        ),
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
                    'Edit markdown directly. Changes sync to rich text automatically.',
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
    if (_showMarkdown) {
      // Save state for undo
      _saveUndoState();

      // Insert into markdown text field
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
    } else {
      // Switch to markdown mode and insert there
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });

      // Insert after a brief delay to ensure the markdown view is rendered
      Future.delayed(const Duration(milliseconds: 100), () {
        _insertMarkdown(markdown);
      });
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

  void _toggleFormatting(String startMark, String endMark, String placeholder) {
    if (_showMarkdown) {
      _toggleMarkdownFormatting(startMark, endMark, placeholder);
    } else {
      // Switch to markdown mode and apply formatting there
      setState(() {
        _showMarkdown = true;
        _updateMarkdownController();
      });

      // Apply formatting after a brief delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _toggleMarkdownFormatting(startMark, endMark, placeholder);
      });
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
  }

  // Undo/Redo functionality
  void _saveUndoState() {
    final currentText = _markdownController.text;

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

  // Inline code toggle
  void _toggleInlineCode() {
    _toggleFormatting('`', '`', 'code');
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
        _insertMarkdown('\n- ');
        break;
      case 'numbered_list':
        _insertMarkdown('\n1. ');
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