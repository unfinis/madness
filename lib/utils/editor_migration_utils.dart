import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:markdown_quill/markdown_quill.dart';

/// Utility class for migrating content between different editor formats
class EditorMigrationUtils {
  /// Converts SuperEditor markdown content to Quill Delta format
  static Delta markdownToDelta(String markdown) {
    if (markdown.isEmpty) {
      return Delta()..insert('\n');
    }

    try {
      final converter = MarkdownToDelta();
      return converter.convert(markdown);
    } catch (e) {
      // If conversion fails, create a simple text delta
      print('Error converting markdown to delta: $e');
      return Delta()..insert(markdown)..insert('\n');
    }
  }

  /// Converts Quill Delta to markdown format
  static String deltaToMarkdown(Delta delta) {
    try {
      final converter = DeltaToMarkdown();
      return converter.convert(delta);
    } catch (e) {
      print('Error converting delta to markdown: $e');
      // Fallback to plain text
      final buffer = StringBuffer();
      for (final op in delta.toList()) {
        if (op.key == 'insert') {
          buffer.write(op.data);
        }
      }
      return buffer.toString();
    }
  }

  /// Converts existing SuperEditor JSON content to Quill Delta
  /// This handles cases where content might be stored in SuperEditor's internal format
  static Delta convertSuperEditorToQuill(dynamic content) {
    if (content == null) {
      return Delta()..insert('\n');
    }

    // If it's already a string (markdown), convert it
    if (content is String) {
      return markdownToDelta(content);
    }

    // If it's JSON data from SuperEditor
    if (content is Map<String, dynamic>) {
      try {
        // Try to extract text content from SuperEditor format
        final textContent = _extractTextFromSuperEditorJson(content);
        return markdownToDelta(textContent);
      } catch (e) {
        print('Error converting SuperEditor JSON: $e');
        return Delta()..insert(content.toString())..insert('\n');
      }
    }

    // Fallback
    return Delta()..insert(content.toString())..insert('\n');
  }

  /// Helper to extract text from SuperEditor JSON structure
  static String _extractTextFromSuperEditorJson(Map<String, dynamic> json) {
    final buffer = StringBuffer();

    // SuperEditor stores documents as nodes
    if (json.containsKey('nodes')) {
      final nodes = json['nodes'] as List;
      for (final node in nodes) {
        if (node is Map<String, dynamic>) {
          // Extract text from different node types
          if (node.containsKey('text')) {
            final text = node['text'];
            if (text is Map && text.containsKey('text')) {
              buffer.writeln(text['text']);
            } else if (text is String) {
              buffer.writeln(text);
            }
          }
          // Handle other node types (headers, lists, etc.)
          if (node['type'] == 'header' && node.containsKey('text')) {
            final level = node['level'] ?? 1;
            final headerPrefix = '#' * level;
            buffer.write('$headerPrefix ');
            if (node['text'] is Map && node['text'].containsKey('text')) {
              buffer.writeln(node['text']['text']);
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  /// Batch migrate a list of markdown strings to Delta format
  static List<Delta> batchMarkdownToDelta(List<String> markdownList) {
    return markdownList.map((md) => markdownToDelta(md)).toList();
  }

  /// Validates if a string is valid markdown
  static bool isValidMarkdown(String content) {
    try {
      final converter = MarkdownToDelta();
      converter.convert(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Sanitizes markdown content for safe conversion
  static String sanitizeMarkdown(String markdown) {
    // Remove potentially problematic characters
    String sanitized = markdown
        .replaceAll('\u0000', '') // Null characters
        .replaceAll('\u200B', '') // Zero-width space
        .replaceAll('\u200C', '') // Zero-width non-joiner
        .replaceAll('\u200D', '') // Zero-width joiner
        .replaceAll('\uFEFF', ''); // Zero-width no-break space

    // Ensure proper line endings
    sanitized = sanitized.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // Fix common markdown issues
    sanitized = _fixMarkdownTables(sanitized);
    sanitized = _fixMarkdownLists(sanitized);

    return sanitized;
  }

  /// Fixes markdown table formatting
  static String _fixMarkdownTables(String markdown) {
    final lines = markdown.split('\n');
    final fixed = <String>[];
    bool inTable = false;

    for (final line in lines) {
      if (line.contains('|')) {
        // Ensure table rows have proper formatting
        String fixedLine = line.trim();
        if (!fixedLine.startsWith('|')) {
          fixedLine = '| $fixedLine';
        }
        if (!fixedLine.endsWith('|')) {
          fixedLine = '$fixedLine |';
        }
        fixed.add(fixedLine);
        inTable = true;
      } else if (inTable && line.trim().isEmpty) {
        fixed.add('');
        inTable = false;
      } else {
        fixed.add(line);
        inTable = false;
      }
    }

    return fixed.join('\n');
  }

  /// Fixes markdown list formatting
  static String _fixMarkdownLists(String markdown) {
    final lines = markdown.split('\n');
    final fixed = <String>[];

    for (final line in lines) {
      String fixedLine = line;

      // Fix unordered lists
      if (line.trimLeft().startsWith('*') && !line.trimLeft().startsWith('**')) {
        final indent = line.indexOf('*');
        final content = line.substring(indent + 1).trimLeft();
        fixedLine = '${' ' * indent}* $content';
      }

      // Fix ordered lists
      final orderedListMatch = RegExp(r'^(\s*)(\d+)\.(.*)$').firstMatch(line);
      if (orderedListMatch != null) {
        final indent = orderedListMatch.group(1) ?? '';
        final number = orderedListMatch.group(2) ?? '1';
        final content = orderedListMatch.group(3)?.trimLeft() ?? '';
        fixedLine = '$indent$number. $content';
      }

      fixed.add(fixedLine);
    }

    return fixed.join('\n');
  }

  /// Creates a migration report for debugging
  static Map<String, dynamic> createMigrationReport(String originalContent) {
    final sanitized = sanitizeMarkdown(originalContent);
    Delta? delta;
    String? markdown;
    String? error;

    try {
      delta = markdownToDelta(sanitized);
      markdown = deltaToMarkdown(delta);
    } catch (e) {
      error = e.toString();
    }

    return {
      'original_length': originalContent.length,
      'sanitized_length': sanitized.length,
      'has_tables': originalContent.contains('|'),
      'has_lists': originalContent.contains('*') || RegExp(r'\d+\.').hasMatch(originalContent),
      'has_code_blocks': originalContent.contains('```'),
      'conversion_successful': error == null,
      'error': error,
      'delta_operations': delta?.toList().length,
      'roundtrip_match': markdown == sanitized,
    };
  }
}