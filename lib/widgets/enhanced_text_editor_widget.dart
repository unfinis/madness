import 'package:flutter/material.dart';

class EnhancedTextEditorWidget extends StatefulWidget {
  final String initialText;
  final String placeholder;
  final double minHeight;
  final Function(String)? onChanged;
  final bool enableMarkdown;
  final bool showToolbar;

  const EnhancedTextEditorWidget({
    super.key,
    required this.initialText,
    this.placeholder = 'Start typing...',
    this.minHeight = 200,
    this.onChanged,
    this.enableMarkdown = true,
    this.showToolbar = true,
  });

  @override
  State<EnhancedTextEditorWidget> createState() => _EnhancedTextEditorWidgetState();
}

class _EnhancedTextEditorWidgetState extends State<EnhancedTextEditorWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isBold = false;
  bool _isItalic = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _focusNode = FocusNode();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          if (widget.showToolbar) _buildToolbar(),
          Expanded(
            child: _buildEditor(),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: Wrap(
        spacing: 4,
        children: [
          _buildToolbarButton(
            icon: Icons.format_bold,
            isActive: _isBold,
            onPressed: () => _insertMarkdown('**', '**'),
            tooltip: 'Bold',
          ),
          _buildToolbarButton(
            icon: Icons.format_italic,
            isActive: _isItalic,
            onPressed: () => _insertMarkdown('*', '*'),
            tooltip: 'Italic',
          ),
          _buildToolbarButton(
            icon: Icons.format_underlined,
            onPressed: () => _insertMarkdown('<u>', '</u>'),
            tooltip: 'Underline',
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            onPressed: () => _insertListItem('- '),
            tooltip: 'Bullet List',
          ),
          _buildToolbarButton(
            icon: Icons.format_list_numbered,
            onPressed: () => _insertListItem('1. '),
            tooltip: 'Numbered List',
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.format_quote,
            onPressed: () => _insertLinePrefix('> '),
            tooltip: 'Quote',
          ),
          _buildToolbarButton(
            icon: Icons.code,
            onPressed: () => _insertMarkdown('`', '`'),
            tooltip: 'Inline Code',
          ),
          _buildToolbarButton(
            icon: Icons.code_off,
            onPressed: () => _insertCodeBlock(),
            tooltip: 'Code Block',
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.link,
            onPressed: () => _insertLink(),
            tooltip: 'Insert Link',
          ),
          _buildToolbarButton(
            icon: Icons.table_chart,
            onPressed: () => _insertTable(),
            tooltip: 'Insert Table',
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.title,
            onPressed: () => _insertLinePrefix('# '),
            tooltip: 'Heading 1',
          ),
          _buildToolbarButton(
            icon: Icons.text_fields,
            onPressed: () => _insertLinePrefix('## '),
            tooltip: 'Heading 2',
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
                : null,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      constraints: BoxConstraints(minHeight: widget.minHeight - (widget.showToolbar ? 50 : 0)),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          fontFamily: 'monospace',
        ),
        decoration: InputDecoration(
          hintText: widget.placeholder,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
      ),
    );
  }

  void _insertMarkdown(String prefix, String suffix) {
    final text = _controller.text;
    final selection = _controller.selection;

    if (selection.isValid) {
      final selectedText = selection.textInside(text);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );

      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + prefix.length + selectedText.length + suffix.length,
        ),
      );
    } else {
      final cursorPos = selection.baseOffset;
      final newText = text.substring(0, cursorPos) +
          prefix + suffix +
          text.substring(cursorPos);

      _controller.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: cursorPos + prefix.length,
        ),
      );
    }

    _focusNode.requestFocus();
  }

  void _insertLinePrefix(String prefix) {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPos = selection.baseOffset;

    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1) + 1;

    final newText = text.substring(0, lineStart) +
        prefix +
        text.substring(lineStart);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: cursorPos + prefix.length,
      ),
    );

    _focusNode.requestFocus();
  }

  void _insertListItem(String prefix) {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPos = selection.baseOffset;

    // Find the start of the current line
    int lineStart = text.lastIndexOf('\n', cursorPos - 1) + 1;

    final newText = text.substring(0, lineStart) +
        prefix +
        text.substring(lineStart);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: cursorPos + prefix.length,
      ),
    );

    _focusNode.requestFocus();
  }

  void _insertCodeBlock() {
    _insertMarkdown('\n```\n', '\n```\n');
  }

  void _insertLink() {
    _insertMarkdown('[', '](https://)');
  }

  void _insertTable() {
    final tableText = '''
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
''';

    final text = _controller.text;
    final selection = _controller.selection;
    final cursorPos = selection.baseOffset;

    final newText = text.substring(0, cursorPos) +
        tableText +
        text.substring(cursorPos);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: cursorPos + tableText.length,
      ),
    );

    _focusNode.requestFocus();
  }
}