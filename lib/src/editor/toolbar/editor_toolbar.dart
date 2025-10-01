import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Custom toolbar for the finding editor
class EditorToolbar extends StatelessWidget {
  final QuillController controller;
  final VoidCallback? onInsertTable;
  final VoidCallback? onInsertImage;
  final VoidCallback? onInsertVariable;
  final VoidCallback? onInsertLink;

  const EditorToolbar({
    super.key,
    required this.controller,
    this.onInsertTable,
    this.onInsertImage,
    this.onInsertVariable,
    this.onInsertLink,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            // Text formatting
            _ToolbarSection(
              children: [
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.bold,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.format_bold,
                  ),
                ),
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.italic,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.format_italic,
                  ),
                ),
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.underline,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.format_underlined,
                  ),
                ),
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.inlineCode,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.code,
                  ),
                ),
              ],
            ),

            _ToolbarDivider(),

            // Headers
            _ToolbarSection(
              children: [
                QuillToolbarSelectHeaderStyleDropdownButton(
                  controller: controller,
                  options: const QuillToolbarSelectHeaderStyleDropdownButtonOptions(),
                ),
              ],
            ),

            _ToolbarDivider(),

            // Lists and quotes
            _ToolbarSection(
              children: [
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.ul,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.format_list_bulleted,
                  ),
                ),
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.ol,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.format_list_numbered,
                  ),
                ),
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.blockQuote,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.format_quote,
                  ),
                ),
                QuillToolbarToggleStyleButton(
                  attribute: Attribute.codeBlock,
                  controller: controller,
                  options: const QuillToolbarToggleStyleButtonOptions(
                    iconData: Icons.code_outlined,
                  ),
                ),
              ],
            ),

            _ToolbarDivider(),

            // Custom inserts
            _ToolbarSection(
              children: [
                if (onInsertLink != null)
                  QuillToolbarLinkStyleButton(
                    controller: controller,
                    options: const QuillToolbarLinkStyleButtonOptions(),
                  ),
                if (onInsertTable != null)
                  IconButton(
                    icon: const Icon(Icons.table_chart),
                    tooltip: 'Insert Table',
                    onPressed: onInsertTable,
                    iconSize: 20,
                  ),
                if (onInsertImage != null)
                  IconButton(
                    icon: const Icon(Icons.image),
                    tooltip: 'Insert Image',
                    onPressed: onInsertImage,
                    iconSize: 20,
                  ),
                if (onInsertVariable != null)
                  IconButton(
                    icon: const Icon(Icons.code_off),
                    tooltip: 'Insert Variable',
                    onPressed: onInsertVariable,
                    iconSize: 20,
                  ),
              ],
            ),

            _ToolbarDivider(),

            // Clear formatting
            _ToolbarSection(
              children: [
                QuillToolbarClearFormatButton(
                  controller: controller,
                  options: const QuillToolbarClearFormatButtonOptions(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarSection extends StatelessWidget {
  final List<Widget> children;

  const _ToolbarSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class _ToolbarDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}
