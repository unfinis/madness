import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'dart:convert';

class QuillRichEditorWidget extends StatefulWidget {
  final String initialContent;
  final String placeholder;
  final double minHeight;
  final Function(String)? onChanged;
  final bool showToolbar;

  const QuillRichEditorWidget({
    super.key,
    required this.initialContent,
    this.placeholder = 'Start typing...',
    this.minHeight = 200,
    this.onChanged,
    this.showToolbar = true,
  });

  @override
  State<QuillRichEditorWidget> createState() => _QuillRichEditorWidgetState();
}

class _QuillRichEditorWidgetState extends State<QuillRichEditorWidget> {
  late QuillController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    // Initialize with content
    Document document;
    if (widget.initialContent.isNotEmpty) {
      try {
        // Try to parse as Quill Delta JSON
        final List<dynamic> deltaJson = jsonDecode(widget.initialContent);
        document = Document.fromJson(deltaJson);
      } catch (e) {
        // If not JSON, treat as plain text
        document = Document()..insert(0, widget.initialContent);
      }
    } else {
      document = Document()..insert(0, widget.placeholder);
    }

    _controller = QuillController(
      document: document,
      selection: const TextSelection.collapsed(offset: 0),
    );

    _controller.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onContentChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (widget.onChanged != null) {
      // Convert to JSON for storage
      final deltaJson = jsonEncode(_controller.document.toDelta().toJson());
      widget.onChanged!(deltaJson);
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      ),
      child: QuillSimpleToolbar(
        controller: _controller,
        config: const QuillSimpleToolbarConfig(
          showAlignmentButtons: true,
          showBackgroundColorButton: false,
          showClearFormat: true,
          showCodeBlock: true,
          showColorButton: true,
          showDirection: false,
          showDividers: true,
          showFontFamily: false,
          showFontSize: true,
          showHeaderStyle: true,
          showIndent: true,
          showInlineCode: true,
          showLink: true,
          showListBullets: true,
          showListCheck: true,
          showListNumbers: true,
          showQuote: true,
          showRedo: true,
          showSearchButton: false,
          showSmallButton: false,
          showStrikeThrough: true,
          showSubscript: false,
          showSuperscript: false,
          showUnderLineButton: true,
          showUndo: true,
        ),
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight - (widget.showToolbar ? 60 : 0),
      ),
      child: QuillEditor.basic(
        controller: _controller,
        focusNode: _focusNode,
        config: QuillEditorConfig(
          placeholder: widget.placeholder,
          padding: const EdgeInsets.all(16),
          autoFocus: false,
          expands: false,
          scrollable: true,
          showCursor: true,
          paintCursorAboveText: true,
          enableInteractiveSelection: true,
          minHeight: widget.minHeight - (widget.showToolbar ? 60 : 0),
          maxHeight: null,
        ),
      ),
    );
  }

  // Helper method to convert plain text to Quill format
  String convertTextToQuill(String text) {
    final document = Document()..insert(0, text);
    return jsonEncode(document.toDelta().toJson());
  }

  // Helper method to convert Quill format to plain text
  String convertQuillToText(String quillJson) {
    try {
      final List<dynamic> deltaJson = jsonDecode(quillJson);
      final document = Document.fromJson(deltaJson);
      return document.toPlainText();
    } catch (e) {
      return quillJson; // Return as-is if not valid JSON
    }
  }
}