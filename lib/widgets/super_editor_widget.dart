import 'dart:async';
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

    return Card(
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
                    onPressed: () => _insertMarkdown('**text**'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.format_italic,
                    tooltip: 'Italic (Ctrl+I)',
                    onPressed: () => _insertMarkdown('*text*'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.code,
                    tooltip: 'Inline Code',
                    onPressed: () => _insertMarkdown('`code`'),
                  ),

                  const SizedBox(width: 8),

                  // Headers dropdown
                  _buildHeaderDropdown(theme),

                  const SizedBox(width: 8),

                  // Lists
                  _buildToolbarButton(
                    icon: Icons.format_list_bulleted,
                    tooltip: 'Bullet List',
                    onPressed: () => _insertMarkdown('\n- '),
                  ),
                  _buildToolbarButton(
                    icon: Icons.format_list_numbered,
                    tooltip: 'Numbered List',
                    onPressed: () => _insertMarkdown('\n1. '),
                  ),

                  const SizedBox(width: 8),

                  // Block elements
                  _buildToolbarButton(
                    icon: Icons.format_quote,
                    tooltip: 'Quote',
                    onPressed: () => _insertMarkdown('\n> '),
                  ),
                  _buildToolbarButton(
                    icon: Icons.code_rounded,
                    tooltip: 'Code Block',
                    onPressed: () => _insertMarkdown('\n```\ncode\n```\n'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.table_chart,
                    tooltip: 'Table',
                    onPressed: _insertTable,
                  ),
                  _buildToolbarButton(
                    icon: Icons.image,
                    tooltip: 'Insert Image',
                    onPressed: () => _insertMarkdown('![Alt text](image-url)'),
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

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
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
}