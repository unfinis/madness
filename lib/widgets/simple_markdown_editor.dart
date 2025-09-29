import 'package:flutter/material.dart';

class SimpleMarkdownEditor extends StatefulWidget {
  final String initialMarkdown;
  final ValueChanged<String>? onChanged;
  final String? placeholder;
  final bool readOnly;
  final double minHeight;
  final double maxHeight;
  final bool enableTables;

  const SimpleMarkdownEditor({
    super.key,
    this.initialMarkdown = '',
    this.onChanged,
    this.placeholder,
    this.readOnly = false,
    this.minHeight = 200,
    this.maxHeight = 600,
    this.enableTables = true,
  });

  @override
  State<SimpleMarkdownEditor> createState() => _SimpleMarkdownEditorState();
}

class _SimpleMarkdownEditorState extends State<SimpleMarkdownEditor> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMarkdown);
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
    widget.onChanged?.call(_controller.text);
  }

  void _insertText(String text) {
    final selection = _controller.selection;
    final currentText = _controller.text;
    final newText = currentText.substring(0, selection.start) +
        text +
        currentText.substring(selection.end);

    _controller.text = newText;
    _controller.selection = TextSelection.collapsed(
      offset: selection.start + text.length,
    );
  }

  void _wrapSelection(String before, String after) {
    final selection = _controller.selection;
    if (selection.start == selection.end) {
      _insertText('$before$after');
      _controller.selection = TextSelection.collapsed(
        offset: selection.start + before.length,
      );
    } else {
      final selectedText = _controller.text.substring(selection.start, selection.end);
      final newText = _controller.text.substring(0, selection.start) +
          before + selectedText + after +
          _controller.text.substring(selection.end);

      _controller.text = newText;
      _controller.selection = TextSelection(
        baseOffset: selection.start + before.length,
        extentOffset: selection.start + before.length + selectedText.length,
      );
    }
  }

  void _insertTable() {
    showDialog(
      context: context,
      builder: (context) => _TableInsertDialog(
        onTableCreated: (rows, cols) {
          final table = _generateMarkdownTable(rows, cols);
          _insertText('\n$table\n');
        },
      ),
    );
  }

  String _generateMarkdownTable(int rows, int cols) {
    final buffer = StringBuffer();

    // Header row
    buffer.write('| ');
    for (int i = 0; i < cols; i++) {
      buffer.write('Header ${i + 1}');
      if (i < cols - 1) buffer.write(' | ');
    }
    buffer.writeln(' |');

    // Separator row
    buffer.write('| ');
    for (int i = 0; i < cols; i++) {
      buffer.write('---');
      if (i < cols - 1) buffer.write(' | ');
    }
    buffer.writeln(' |');

    // Data rows
    for (int r = 0; r < rows - 1; r++) {
      buffer.write('| ');
      for (int c = 0; c < cols; c++) {
        buffer.write('Cell ${r + 1}-${c + 1}');
        if (c < cols - 1) buffer.write(' | ');
      }
      buffer.writeln(' |');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight,
        maxHeight: widget.maxHeight,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!widget.readOnly) _buildToolbar(theme),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                readOnly: widget.readOnly,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: const TextStyle(
                  fontFamily: 'Consolas', // Monospace font for markdown
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: widget.placeholder ?? 'Enter markdown text...\n\n**Bold**, *italic*, `code`\n\n# Heading\n## Subheading\n\n- List item\n- Another item\n\n[Link](url)',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontFamily: 'Consolas',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Wrap(
        spacing: 4,
        children: [
          _ToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold (**text**)',
            onPressed: () => _wrapSelection('**', '**'),
          ),
          _ToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic (*text*)',
            onPressed: () => _wrapSelection('*', '*'),
          ),
          _ToolbarButton(
            icon: Icons.code,
            tooltip: 'Inline Code (`code`)',
            onPressed: () => _wrapSelection('`', '`'),
          ),
          _ToolbarButton(
            icon: Icons.code_off,
            tooltip: 'Code Block',
            onPressed: () => _insertText('\n```\ncode\n```\n'),
          ),
          const SizedBox(width: 8),
          _ToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading (# text)',
            onPressed: () => _insertText('\n# Heading\n'),
          ),
          _ToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet List',
            onPressed: () => _insertText('\n- Item\n- Item\n'),
          ),
          _ToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered List',
            onPressed: () => _insertText('\n1. Item\n2. Item\n'),
          ),
          const SizedBox(width: 8),
          _ToolbarButton(
            icon: Icons.link,
            tooltip: 'Link ([text](url))',
            onPressed: () => _wrapSelection('[', '](url)'),
          ),
          _ToolbarButton(
            icon: Icons.format_quote,
            tooltip: 'Quote (> text)',
            onPressed: () => _insertText('\n> Quote\n'),
          ),
          if (widget.enableTables) ...[
            const SizedBox(width: 8),
            _ToolbarButton(
              icon: Icons.table_chart,
              tooltip: 'Insert Table',
              onPressed: _insertTable,
            ),
          ],
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _ToolbarButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        splashRadius: 16,
      ),
    );
  }
}

class _TableInsertDialog extends StatefulWidget {
  final Function(int rows, int cols) onTableCreated;

  const _TableInsertDialog({required this.onTableCreated});

  @override
  State<_TableInsertDialog> createState() => _TableInsertDialogState();
}

class _TableInsertDialogState extends State<_TableInsertDialog> {
  int _rows = 3;
  int _cols = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Table'),
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
                  onChanged: (value) => setState(() => _rows = value.toInt()),
                ),
              ),
              Text(_rows.toString()),
            ],
          ),
          Row(
            children: [
              const Text('Columns: '),
              Expanded(
                child: Slider(
                  value: _cols.toDouble(),
                  min: 2,
                  max: 6,
                  divisions: 4,
                  label: _cols.toString(),
                  onChanged: (value) => setState(() => _cols = value.toInt()),
                ),
              ),
              Text(_cols.toString()),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Preview: $_rows×$_cols table',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTableCreated(_rows, _cols);
            Navigator.of(context).pop();
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}