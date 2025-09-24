import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

/// A rich text editor widget using Flutter Quill with markdown support
class QuillRichEditorWidget extends StatefulWidget {
  final String initialText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onMarkdownChanged;
  final bool readOnly;
  final int? maxLines;
  final double? height;

  const QuillRichEditorWidget({
    super.key,
    this.initialText = '',
    this.hintText,
    this.onChanged,
    this.onMarkdownChanged,
    this.readOnly = false,
    this.maxLines,
    this.height = 300,
  });

  @override
  State<QuillRichEditorWidget> createState() => _QuillRichEditorWidgetState();
}

class _QuillRichEditorWidgetState extends State<QuillRichEditorWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late QuillController _quillController;
  late FocusNode _focusNode;
  late TextEditingController _markdownController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Rich, Markdown, Preview
    _focusNode = FocusNode();
    _markdownController = TextEditingController();

    // Initialize Quill controller with initial content
    _quillController = QuillController.basic();

    if (widget.initialText.isNotEmpty) {
      try {
        // Insert plain text into the document
        final document = Document()..insert(0, widget.initialText);
        _quillController = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
      } catch (e) {
        // If parsing fails, use basic controller and insert text
        _quillController = QuillController.basic();
        _quillController.document.insert(0, widget.initialText);
      }
    }

    // Initialize markdown content
    _markdownController.text = _convertToMarkdown();

    // Listen for changes
    _quillController.addListener(_onQuillTextChanged);
    _markdownController.addListener(_onMarkdownTextChanged);

    // Listen for tab changes to sync content
    _tabController.addListener(_onTabChanged);
  }

  void _onQuillTextChanged() {
    final text = _quillController.document.toPlainText();
    widget.onChanged?.call(text);

    // Convert to markdown if callback provided
    if (widget.onMarkdownChanged != null) {
      final markdown = _convertToMarkdown();
      widget.onMarkdownChanged?.call(markdown);
    }
  }

  void _onMarkdownTextChanged() {
    final markdown = _markdownController.text;
    widget.onMarkdownChanged?.call(markdown);

    // Convert markdown back to rich text
    _convertMarkdownToQuill(markdown);
    widget.onChanged?.call(markdown);
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        // Sync content when switching tabs
        if (_tabController.index == 1) {
          // Switching to markdown tab - update markdown from quill
          _markdownController.text = _convertToMarkdown();
        }
        // When switching to rich text tab, we'd convert markdown back to quill
        // but that's more complex, so for now we just keep them in sync
      });
    }
  }

  String _convertToMarkdown() {
    // Improved conversion from Quill Delta to Markdown
    final ops = _quillController.document.toDelta().toList();
    final buffer = StringBuffer();

    for (final op in ops) {
      if (op.data is String) {
        String text = op.data as String;

        // Handle newlines and special formatting
        if (text == '\n') {
          buffer.writeln();
          continue;
        }

        // Apply formatting based on attributes
        if (op.attributes != null) {
          final attrs = op.attributes!;

          // Headers
          if (attrs['header'] != null) {
            final level = attrs['header'] as int;
            if (level >= 1 && level <= 6) {
              text = '${'#' * level} $text';
            }
          }

          // Bold
          if (attrs['bold'] == true) {
            text = '**$text**';
          }

          // Italic
          if (attrs['italic'] == true) {
            text = '*$text*';
          }

          // Code
          if (attrs['code'] == true) {
            text = '`$text`';
          }

          // Strikethrough
          if (attrs['strike'] == true) {
            text = '~~$text~~';
          }

          // Code block
          if (attrs['code-block'] == true) {
            text = '```\n$text\n```';
          }

          // Lists
          if (attrs['list'] == 'bullet') {
            text = '- $text';
          } else if (attrs['list'] == 'ordered') {
            text = '1. $text';
          }

          // Blockquote
          if (attrs['blockquote'] == true) {
            text = '> $text';
          }
        }

        buffer.write(text);
      }
    }

    return buffer.toString();
  }

  void _convertMarkdownToQuill(String markdown) {
    // Simplified markdown to rich text conversion
    // For now, just insert the plain text - formatting conversion is complex

    // Temporarily remove listener to avoid infinite loop
    _quillController.removeListener(_onQuillTextChanged);

    try {
      // Clear the document and insert plain markdown text
      final length = _quillController.document.length;
      if (length > 1) {
        _quillController.replaceText(0, length - 1, '', null);
      }

      // Insert the markdown as plain text
      if (markdown.isNotEmpty) {
        _quillController.document.insert(0, markdown);
      }
    } finally {
      // Re-add the listener
      _quillController.addListener(_onQuillTextChanged);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _quillController.dispose();
    _focusNode.dispose();
    _markdownController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Column(
        children: [
          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Rich Text', icon: Icon(Icons.format_paint)),
                Tab(text: 'Markdown', icon: Icon(Icons.code)),
                Tab(text: 'Preview', icon: Icon(Icons.visibility)),
              ],
              labelStyle: theme.textTheme.bodySmall,
              unselectedLabelStyle: theme.textTheme.bodySmall,
              indicatorSize: TabBarIndicatorSize.tab,
            ),
          ),

          // Tab content
          SizedBox(
            height: widget.height,
            child: TabBarView(
              controller: _tabController,
              children: [
                // Rich text editor
                _buildRichTextEditor(theme),

                // Markdown editor
                _buildMarkdownEditor(theme),

                // Preview
                _buildPreview(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRichTextEditor(ThemeData theme) {
    return Column(
      children: [
        // Toolbar
        if (!widget.readOnly)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerLow,
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            child: QuillSimpleToolbar(
              controller: _quillController,
            ),
          ),

        // Editor
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: QuillEditor.basic(
              controller: _quillController,
              focusNode: _focusNode,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMarkdownEditor(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: _markdownController,
        maxLines: null,
        expands: true,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Write in markdown...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _buildPreview(ThemeData theme) {
    // Always show markdown content in preview for proper rendering
    final markdownContent = _markdownController.text.isNotEmpty
        ? _markdownController.text
        : _convertToMarkdown();

    return Container(
      padding: const EdgeInsets.all(12),
      child: markdownContent.isEmpty
          ? Center(
              child: Text(
                'No content to preview',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : Markdown(
              data: markdownContent,
              styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                p: theme.textTheme.bodyMedium,
                h1: theme.textTheme.headlineLarge,
                h2: theme.textTheme.headlineMedium,
                h3: theme.textTheme.headlineSmall,
                h4: theme.textTheme.titleLarge,
                h5: theme.textTheme.titleMedium,
                h6: theme.textTheme.titleSmall,
                code: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: 'monospace',
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
                codeblockDecoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              selectable: true,
            ),
    );
  }
}