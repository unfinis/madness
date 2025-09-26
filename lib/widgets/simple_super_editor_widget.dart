import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:super_editor/super_editor.dart';
import 'package:super_editor_markdown/super_editor_markdown.dart';
import '../constants/app_spacing.dart';

/// A simpler Super Editor widget with basic functionality (fallback option)
class SimpleSuperEditorWidget extends StatefulWidget {
  final String initialMarkdown;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onMarkdownChanged;
  final bool readOnly;
  final double? height;
  final EdgeInsets? padding;
  final bool showToolbar;

  const SimpleSuperEditorWidget({
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
  State<SimpleSuperEditorWidget> createState() => _SimpleSuperEditorWidgetState();
}

class _SimpleSuperEditorWidgetState extends State<SimpleSuperEditorWidget> {
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

    _markdownController.addListener(_onMarkdownChanged);
  }

  void _initializeDocument() {
    if (widget.initialMarkdown.isNotEmpty) {
      try {
        _document = deserializeMarkdownToDocument(widget.initialMarkdown);
      } catch (e) {
        _document = MutableDocument(nodes: [
          ParagraphNode(
            id: Editor.createNodeId(),
            text: AttributedText(widget.initialMarkdown),
          ),
        ]);
      }
    } else {
      _document = MutableDocument(nodes: [
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(),
        ),
      ]);
    }
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
      child: Row(
        children: [
          // View toggle buttons
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
            onSelectionChanged: (Set<bool> selection) {
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

          // Action buttons based on current mode
          if (_showMarkdown) ...[
            IconButton(
              icon: const Icon(Icons.content_copy, size: 18),
              tooltip: 'Copy Markdown',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _markdownController.text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Markdown copied to clipboard')),
                );
              },
              visualDensity: VisualDensity.compact,
            ),
          ] else ...[
            // Basic rich text formatting buttons
            IconButton(
              icon: const Icon(Icons.format_bold, size: 18),
              tooltip: 'Bold',
              onPressed: () => _insertMarkdown('**text**'),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.format_italic, size: 18),
              tooltip: 'Italic',
              onPressed: () => _insertMarkdown('*text*'),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.title, size: 18),
              tooltip: 'Header',
              onPressed: () => _insertMarkdown('# '),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.format_list_bulleted, size: 18),
              tooltip: 'Bullet List',
              onPressed: () => _insertMarkdown('\n- '),
              visualDensity: VisualDensity.compact,
            ),
            IconButton(
              icon: const Icon(Icons.format_quote, size: 18),
              tooltip: 'Quote',
              onPressed: () => _insertMarkdown('\n> '),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
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
                Styles.padding: const CascadingPadding.all(0),
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
                    'Edit markdown directly. Changes auto-sync to rich text.',
                    style: theme.textTheme.bodySmall,
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
              style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
              decoration: InputDecoration(
                hintText: widget.hintText ?? 'Enter markdown...\n\n# Header\n**Bold**\n*Italic*\n- List\n> Quote\n`code`',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Simplified markdown insertion
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

      // Insert after a brief delay
      Future.delayed(const Duration(milliseconds: 100), () {
        _insertMarkdown(markdown);
      });
    }
  }
}