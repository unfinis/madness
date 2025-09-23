import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_spacing.dart';

/// A rich text editor widget with markdown support
class MarkdownEditorWidget extends StatefulWidget {
  final String initialText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final int? maxLines;

  const MarkdownEditorWidget({
    super.key,
    this.initialText = '',
    this.hintText,
    this.onChanged,
    this.readOnly = false,
    this.maxLines,
  });

  @override
  State<MarkdownEditorWidget> createState() => _MarkdownEditorWidgetState();
}

class _MarkdownEditorWidgetState extends State<MarkdownEditorWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _controller = TextEditingController(text: widget.initialText);

    // Tab controller listener for future use
    _tabController.addListener(() {
      setState(() {
        // Update UI when switching between edit and preview
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _insertMarkdown(String prefix, String suffix, {String defaultText = 'text'}) {
    final text = _controller.text;
    final selection = _controller.selection;

    if (selection.isCollapsed) {
      // No text selected, insert with default text
      final newText = '$prefix$defaultText$suffix';
      final insertPosition = selection.baseOffset;
      _controller.text = text.substring(0, insertPosition) + newText + text.substring(insertPosition);

      // Position cursor between prefix and suffix
      _controller.selection = TextSelection(
        baseOffset: insertPosition + prefix.length,
        extentOffset: insertPosition + prefix.length + defaultText.length,
      );
    } else {
      // Text selected, wrap with markdown
      final selectedText = text.substring(selection.start, selection.end);
      final newText = '$prefix$selectedText$suffix';
      _controller.text = text.substring(0, selection.start) + newText + text.substring(selection.end);

      // Keep the text selected
      _controller.selection = TextSelection(
        baseOffset: selection.start + prefix.length,
        extentOffset: selection.start + prefix.length + selectedText.length,
      );
    }

    widget.onChanged?.call(_controller.text);
  }

  Widget _buildToolbar() {
    if (widget.readOnly) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        children: [
          _buildToolbarButton(
            icon: Icons.format_bold,
            tooltip: 'Bold (Ctrl+B)',
            onPressed: () => _insertMarkdown('**', '**'),
          ),
          _buildToolbarButton(
            icon: Icons.format_italic,
            tooltip: 'Italic (Ctrl+I)',
            onPressed: () => _insertMarkdown('*', '*'),
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.title,
            tooltip: 'Heading',
            onPressed: () => _showHeadingMenu(),
          ),
          _buildToolbarButton(
            icon: Icons.link,
            tooltip: 'Link',
            onPressed: () => _insertLink(),
          ),
          _buildToolbarButton(
            icon: Icons.code,
            tooltip: 'Code Block',
            onPressed: () => _insertCodeBlock(),
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.format_list_bulleted,
            tooltip: 'Bullet List',
            onPressed: () => _insertMarkdown('- ', '', defaultText: 'list item'),
          ),
          _buildToolbarButton(
            icon: Icons.format_list_numbered,
            tooltip: 'Numbered List',
            onPressed: () => _insertMarkdown('1. ', '', defaultText: 'list item'),
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.table_chart,
            tooltip: 'Table',
            onPressed: () => _insertTable(),
          ),
          _buildToolbarButton(
            icon: Icons.image,
            tooltip: 'Image',
            onPressed: () => _insertImage(),
          ),
          const VerticalDivider(width: 1),
          _buildToolbarButton(
            icon: Icons.format_quote,
            tooltip: 'Quote',
            onPressed: () => _insertMarkdown('> ', '', defaultText: 'quote'),
          ),
          _buildToolbarButton(
            icon: Icons.horizontal_rule,
            tooltip: 'Horizontal Rule',
            onPressed: () => _insertMarkdown('\n---\n', ''),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
    );
  }

  void _showHeadingMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<int>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<int>(value: 1, child: Text('Heading 1')),
        const PopupMenuItem<int>(value: 2, child: Text('Heading 2')),
        const PopupMenuItem<int>(value: 3, child: Text('Heading 3')),
        const PopupMenuItem<int>(value: 4, child: Text('Heading 4')),
      ],
    ).then((value) {
      if (value != null) {
        final prefix = '#' * value + ' ';
        _insertMarkdown(prefix, '', defaultText: 'heading');
      }
    });
  }

  void _insertLink() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Link'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Link Text',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'URL',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
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
              _insertMarkdown('[', '](https://example.com)', defaultText: 'link text');
              Navigator.of(context).pop();
            },
            child: const Text('Insert'),
          ),
        ],
      ),
    );
  }

  void _insertCodeBlock() {
    showDialog(
      context: context,
      builder: (context) {
        String language = 'python';
        return AlertDialog(
          title: const Text('Insert Code Block'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: language,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: OutlineInputBorder(),
                ),
                items: ['python', 'bash', 'javascript', 'java', 'c++', 'sql', 'html', 'css']
                    .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                    .toList(),
                onChanged: (value) => language = value!,
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
                _insertMarkdown('\n```$language\n', '\n```\n', defaultText: '# code here');
                Navigator.of(context).pop();
              },
              child: const Text('Insert'),
            ),
          ],
        );
      },
    );
  }

  void _insertTable() {
    _insertMarkdown(
      '\n| Column 1 | Column 2 | Column 3 |\n|----------|----------|----------|\n| ',
      ' | Cell 2 | Cell 3 |\n',
      defaultText: 'Cell 1',
    );
  }

  void _insertImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insert Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Alt Text',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Image URL or Path',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {},
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
              _insertMarkdown('![', '](image.png)', defaultText: 'alt text');
              Navigator.of(context).pop();
            },
            child: const Text('Insert'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Edit'),
                Tab(text: 'Preview'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Edit tab
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: TextField(
                      controller: _controller,
                      readOnly: widget.readOnly,
                      maxLines: widget.maxLines,
                      decoration: InputDecoration(
                        hintText: widget.hintText ?? 'Enter text (Markdown supported)...',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(fontFamily: 'monospace'),
                      onChanged: widget.onChanged,
                    ),
                  ),
                  // Preview tab
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: SingleChildScrollView(
                      child: _buildMarkdownPreview(_controller.text),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkdownPreview(String text) {
    // Simple markdown preview - in production, use markdown_widget or flutter_markdown
    final lines = text.split('\n');
    final widgets = <Widget>[];

    for (final line in lines) {
      if (line.isEmpty) {
        widgets.add(const SizedBox(height: 8));
      } else if (line.startsWith('# ')) {
        widgets.add(Text(
          line.substring(2),
          style: Theme.of(context).textTheme.headlineLarge,
        ));
      } else if (line.startsWith('## ')) {
        widgets.add(Text(
          line.substring(3),
          style: Theme.of(context).textTheme.headlineMedium,
        ));
      } else if (line.startsWith('### ')) {
        widgets.add(Text(
          line.substring(4),
          style: Theme.of(context).textTheme.headlineSmall,
        ));
      } else if (line.startsWith('- ') || line.startsWith('* ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('• '),
              Expanded(child: Text(line.substring(2))),
            ],
          ),
        ));
      } else if (line.startsWith('> ')) {
        widgets.add(Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3,
              ),
            ),
            color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
          ),
          child: Text(line.substring(2)),
        ));
      } else if (line.startsWith('```')) {
        widgets.add(Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            line,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ));
      } else {
        widgets.add(Text(line));
      }
      widgets.add(const SizedBox(height: 4));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!widget.readOnly) _buildToolbar(),
        _buildEditor(),
      ],
    );
  }
}