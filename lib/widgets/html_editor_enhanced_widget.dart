import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

class HtmlEditorEnhancedWidget extends StatefulWidget {
  final String initialHtml;
  final String placeholder;
  final double minHeight;
  final Function(String)? onChanged;
  final bool enableTables;
  final bool showToolbar;

  const HtmlEditorEnhancedWidget({
    super.key,
    required this.initialHtml,
    this.placeholder = 'Start typing...',
    this.minHeight = 200,
    this.onChanged,
    this.enableTables = true,
    this.showToolbar = true,
  });

  @override
  State<HtmlEditorEnhancedWidget> createState() => _HtmlEditorEnhancedWidgetState();
}

class _HtmlEditorEnhancedWidgetState extends State<HtmlEditorEnhancedWidget> {
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
          initialText: widget.initialHtml,
          shouldEnsureVisible: true,
          autoAdjustHeight: false,
          adjustHeightForKeyboard: false,
          characterLimit: null,
          darkMode: false,
          disableContextMenu: false,
          mobileLongPressDuration: const Duration(milliseconds: 500),
        ),
        htmlToolbarOptions: HtmlToolbarOptions(
          toolbarPosition: ToolbarPosition.aboveEditor,
          toolbarType: ToolbarType.nativeExpandable,
          defaultToolbarButtons: [
            const StyleButtons(),
            const FontSettingButtons(fontName: false),
            const ColorButtons(),
            const ListButtons(listStyles: false),
            const ParagraphButtons(textDirection: false, lineHeight: false, caseConverter: false),
            InsertButtons(
              video: false,
              audio: false,
              table: widget.enableTables,
              hr: false,
              otherFile: false,
            ),
            const OtherButtons(
              help: false,
              codeview: false,
              fullscreen: false,
            ),
          ],
        ),
        otherOptions: OtherOptions(
          height: widget.minHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        inAppWebViewOptions: InAppWebViewOptions(
          javaScriptEnabled: true,
          allowsInlineMediaPlayback: true,
          allowsBackForwardNavigationGestures: false,
          useOnLoadResource: false,
          useShouldOverrideUrlLoading: false,
          mediaPlaybackRequiresUserGesture: false,
          allowFileAccessFromFileURLs: true,
          allowUniversalAccessFromFileURLs: true,
          verticalScrollBarEnabled: true,
          horizontalScrollBarEnabled: true,
          transparentBackground: false,
          supportZoom: false,
          disableDefaultErrorPage: true,
        ),
        callbacks: Callbacks(
          onChangeContent: (String? changed) {
            try {
              if (widget.onChanged != null && changed != null) {
                widget.onChanged!(changed);
              }
            } catch (e) {
              // Silently handle content change errors
              print('HTML Editor content change error: $e');
            }
          },
          onInit: () {
            try {
              // Editor initialized successfully
              print('HTML Editor initialized');
            } catch (e) {
              print('HTML Editor initialization error: $e');
            }
          },
          onFocus: () {
            // Editor focused
          },
          onBlur: () {
            // Editor lost focus
          },
        ),
        plugins: [
          // Add plugins here if needed
        ],
      ),
    );
  }


  @override
  void dispose() {
    controller.clear();
    super.dispose();
  }
}