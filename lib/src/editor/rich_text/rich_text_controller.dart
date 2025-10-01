import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'markdown_converter.dart';

/// Controller for managing rich text editing state
class RichTextEditorController {
  final QuillController _controller;
  final MarkdownConverter _converter;

  RichTextEditorController({
    QuillController? controller,
    MarkdownConverter? converter,
  })  : _controller = controller ?? QuillController.basic(),
        _converter = converter ?? MarkdownConverter();

  QuillController get quillController => _controller;

  /// Load content from markdown string
  void loadFromMarkdown(String markdown) {
    final delta = _converter.markdownToDelta(markdown);
    _controller.document = Document.fromDelta(delta);
    _controller.moveCursorToEnd();
  }

  /// Convert current content to markdown
  String toMarkdown() {
    return _converter.deltaToMarkdown(_controller.document.toDelta());
  }

  /// Insert a table at the current cursor position
  void insertTable(int rows, int cols) {
    final tableData = List.generate(
      rows,
      (row) => List.generate(
        cols,
        (col) => row == 0 ? 'Header ${col + 1}' : 'Cell ${row}-${col}',
      ),
    );

    final tableMarkdown = _converter.generateMarkdownTable(tableData);
    final index = _controller.selection.baseOffset;
    _controller.document.insert(index, '\n$tableMarkdown\n');
    _controller.updateSelection(
      TextSelection.collapsed(offset: index + tableMarkdown.length + 2),
      ChangeSource.local,
    );
  }

  /// Insert an image at the current cursor position
  void insertImage(String imageId, String url, {String? alt}) {
    final index = _controller.selection.baseOffset;
    _controller.document.insert(
      index,
      BlockEmbed.image(url),
    );
    _controller.updateSelection(
      TextSelection.collapsed(offset: index + 1),
      ChangeSource.local,
    );
  }

  /// Insert a variable placeholder
  void insertVariable(String variableName) {
    final placeholder = '{{$variableName}}';
    final index = _controller.selection.baseOffset;
    _controller.document.insert(index, placeholder);
    _controller.updateSelection(
      TextSelection.collapsed(offset: index + placeholder.length),
      ChangeSource.local,
    );
  }

  /// Format selected text as bold
  void toggleBold() {
    _controller.formatSelection(Attribute.bold);
  }

  /// Format selected text as italic
  void toggleItalic() {
    _controller.formatSelection(Attribute.italic);
  }

  /// Format selected text as underline
  void toggleUnderline() {
    _controller.formatSelection(Attribute.underline);
  }

  /// Format selected text as code
  void toggleCode() {
    _controller.formatSelection(Attribute.inlineCode);
  }

  /// Set header level (1-6, or 0 to remove)
  void setHeaderLevel(int level) {
    if (level == 0) {
      _controller.formatSelection(Attribute.clone(Attribute.header, null));
    } else {
      _controller.formatSelection(Attribute.h1.copyWith(level: level));
    }
  }

  /// Toggle bullet list
  void toggleBulletList() {
    _controller.formatSelection(Attribute.ul);
  }

  /// Toggle numbered list
  void toggleNumberedList() {
    _controller.formatSelection(Attribute.ol);
  }

  /// Toggle blockquote
  void toggleBlockquote() {
    _controller.formatSelection(Attribute.blockQuote);
  }

  /// Insert a link
  void insertLink(String url) {
    _controller.formatSelection(Attribute.link.copyWith(value: url));
  }

  /// Clear all formatting
  void clearFormatting() {
    _controller.formatSelection(Attribute.clone(Attribute.bold, null));
    _controller.formatSelection(Attribute.clone(Attribute.italic, null));
    _controller.formatSelection(Attribute.clone(Attribute.underline, null));
    _controller.formatSelection(Attribute.clone(Attribute.inlineCode, null));
  }

  /// Check if current selection has bold formatting
  bool get isBold {
    return _controller
            .getSelectionStyle()
            .attributes[Attribute.bold.key]
            ?.value ==
        true;
  }

  /// Check if current selection has italic formatting
  bool get isItalic {
    return _controller
            .getSelectionStyle()
            .attributes[Attribute.italic.key]
            ?.value ==
        true;
  }

  /// Check if current selection has underline formatting
  bool get isUnderline {
    return _controller
            .getSelectionStyle()
            .attributes[Attribute.underline.key]
            ?.value ==
        true;
  }

  /// Check if current selection has code formatting
  bool get isCode {
    return _controller
            .getSelectionStyle()
            .attributes[Attribute.inlineCode.key]
            ?.value ==
        true;
  }

  /// Get current header level (0 if not a header)
  int get headerLevel {
    final value = _controller
        .getSelectionStyle()
        .attributes[Attribute.header.key]
        ?.value;
    return value is int ? value : 0;
  }

  /// Dispose resources
  void dispose() {
    _controller.dispose();
  }
}
