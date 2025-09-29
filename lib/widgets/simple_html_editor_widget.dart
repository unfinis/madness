import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class SimpleHtmlEditorWidget extends StatefulWidget {
  final String initialHtml;
  final String placeholder;
  final double minHeight;
  final Function(String)? onChanged;
  final bool enableTables;

  const SimpleHtmlEditorWidget({
    super.key,
    required this.initialHtml,
    this.placeholder = 'Start typing...',
    this.minHeight = 200,
    this.onChanged,
    this.enableTables = true,
  });

  @override
  State<SimpleHtmlEditorWidget> createState() => _SimpleHtmlEditorWidgetState();
}

class _SimpleHtmlEditorWidgetState extends State<SimpleHtmlEditorWidget> {
  late HtmlEditorController controller;

  @override
  void initState() {
    super.initState();
    controller = HtmlEditorController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.minHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(4),
      ),
      child: HtmlEditor(
        controller: controller,
        htmlEditorOptions: HtmlEditorOptions(
          hint: widget.placeholder,
          initialText: widget.initialHtml.isEmpty ? '<p>${widget.placeholder}</p>' : widget.initialHtml,
          shouldEnsureVisible: false,
          autoAdjustHeight: false,
          adjustHeightForKeyboard: false,
          characterLimit: null,
          darkMode: false,
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarPosition: ToolbarPosition.aboveEditor,
          toolbarType: ToolbarType.nativeScrollable,
          defaultToolbarButtons: [
            const StyleButtons(style: false),
            const FontSettingButtons(
              fontName: false,
              fontSizeUnit: false,
            ),
            const ColorButtons(),
            const ListButtons(listStyles: false),
            const ParagraphButtons(
              textDirection: false,
              lineHeight: false,
              caseConverter: false,
              alignLeft: true,
              alignCenter: true,
              alignRight: true,
              alignJustify: false,
            ),
            const InsertButtons(
              link: true,
              picture: false,
              video: false,
              audio: false,
              table: true,
              hr: true,
              otherFile: false,
            ),
            const OtherButtons(
              help: false,
              codeview: false,
              fullscreen: false,
            ),
          ],
          toolbarItemHeight: 50,
        ),
        otherOptions: OtherOptions(
          height: widget.minHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        callbacks: Callbacks(
          onChangeContent: (String? content) {
            if (widget.onChanged != null && content != null) {
              // Clean up the content
              String cleanContent = content
                  .replaceAll('<p><br></p>', '')
                  .replaceAll('<div><br></div>', '')
                  .trim();

              if (cleanContent.isNotEmpty && cleanContent != '<p>${widget.placeholder}</p>') {
                widget.onChanged!(cleanContent);
              }
            }
          },
          onInit: () {
            // Simple HTML Editor initialized
          },
        ),
        plugins: [
          // Keep plugins minimal for Windows compatibility
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}