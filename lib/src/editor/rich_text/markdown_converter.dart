import 'dart:convert';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:markdown/markdown.dart' as md;

/// Converter between Markdown strings and Quill Delta format
class MarkdownConverter {
  /// Convert markdown string to Quill Delta format
  Delta markdownToDelta(String markdown) {
    final delta = Delta();

    if (markdown.isEmpty) {
      return delta;
    }

    // Parse markdown to HTML first
    final document = md.Document(
      extensionSet: md.ExtensionSet.gitHubFlavored,
      encodeHtml: false,
    );
    final nodes = document.parseLines(markdown.split('\n'));

    // Convert nodes to Delta operations
    for (final node in nodes) {
      _convertNodeToDelta(node, delta);
    }

    return delta;
  }

  /// Convert Quill Delta to markdown string
  String deltaToMarkdown(Delta delta) {
    final buffer = StringBuffer();

    for (final op in delta.toList()) {
      if (op.data is String) {
        final text = op.data as String;
        final attributes = op.attributes;

        if (attributes == null || attributes.isEmpty) {
          buffer.write(text);
        } else {
          buffer.write(_applyMarkdownFormatting(text, attributes));
        }
      } else if (op.data is Map) {
        // Handle embeds (images, etc.)
        final embed = op.data as Map;
        if (embed.containsKey('image')) {
          buffer.write('![${embed['alt'] ?? ''}](${embed['image']})');
        }
      }
    }

    return buffer.toString();
  }

  /// Parse markdown table and return structured data
  List<List<String>> parseMarkdownTable(String tableMarkdown) {
    final lines = tableMarkdown.trim().split('\n');
    final rows = <List<String>>[];

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Skip separator line (e.g., |---|---|)
      if (line.contains('---')) continue;

      // Parse table row
      if (line.startsWith('|') && line.endsWith('|')) {
        final cells = line
            .substring(1, line.length - 1)
            .split('|')
            .map((cell) => cell.trim())
            .toList();
        rows.add(cells);
      }
    }

    return rows;
  }

  /// Generate markdown table from data
  String generateMarkdownTable(List<List<String>> data) {
    if (data.isEmpty) return '';

    final buffer = StringBuffer();
    final colCount = data[0].length;

    // Header row
    buffer.write('| ${data[0].join(' | ')} |\n');

    // Separator row
    buffer.write('|${List.filled(colCount, '---').join('|')}|\n');

    // Data rows
    for (var i = 1; i < data.length; i++) {
      buffer.write('| ${data[i].join(' | ')} |\n');
    }

    return buffer.toString();
  }

  void _convertNodeToDelta(md.Node node, Delta delta) {
    if (node is md.Element) {
      switch (node.tag) {
        case 'h1':
          _addTextWithAttributes(
              delta, node.textContent, {'header': 1});
          delta.insert('\n');
          break;
        case 'h2':
          _addTextWithAttributes(
              delta, node.textContent, {'header': 2});
          delta.insert('\n');
          break;
        case 'h3':
          _addTextWithAttributes(
              delta, node.textContent, {'header': 3});
          delta.insert('\n');
          break;
        case 'h4':
          _addTextWithAttributes(
              delta, node.textContent, {'header': 4});
          delta.insert('\n');
          break;
        case 'p':
          _convertInlineNodes(node, delta);
          delta.insert('\n');
          break;
        case 'strong':
          _addTextWithAttributes(
              delta, node.textContent, {'bold': true});
          break;
        case 'em':
          _addTextWithAttributes(
              delta, node.textContent, {'italic': true});
          break;
        case 'code':
          _addTextWithAttributes(
              delta, node.textContent, {'code': true});
          break;
        case 'ul':
          for (final child in node.children ?? []) {
            if (child is md.Element && child.tag == 'li') {
              _convertInlineNodes(child, delta);
              delta.insert('\n', {'list': 'bullet'});
            }
          }
          break;
        case 'ol':
          for (final child in node.children ?? []) {
            if (child is md.Element && child.tag == 'li') {
              _convertInlineNodes(child, delta);
              delta.insert('\n', {'list': 'ordered'});
            }
          }
          break;
        case 'blockquote':
          for (final child in node.children ?? []) {
            _convertNodeToDelta(child, delta);
          }
          break;
        case 'pre':
          final code = node.textContent;
          delta.insert(code);
          delta.insert('\n', {'code-block': true});
          break;
        case 'a':
          final href = node.attributes['href'] ?? '';
          _addTextWithAttributes(
              delta, node.textContent, {'link': href});
          break;
        case 'img':
          final src = node.attributes['src'] ?? '';
          final alt = node.attributes['alt'] ?? '';
          delta.insert({'image': src, 'alt': alt});
          delta.insert('\n');
          break;
        default:
          for (final child in node.children ?? []) {
            _convertNodeToDelta(child, delta);
          }
      }
    } else if (node is md.Text) {
      delta.insert(node.text);
    }
  }

  void _convertInlineNodes(md.Element element, Delta delta) {
    for (final child in element.children ?? []) {
      if (child is md.Text) {
        delta.insert(child.text);
      } else if (child is md.Element) {
        switch (child.tag) {
          case 'strong':
            _addTextWithAttributes(
                delta, child.textContent, {'bold': true});
            break;
          case 'em':
            _addTextWithAttributes(
                delta, child.textContent, {'italic': true});
            break;
          case 'code':
            _addTextWithAttributes(
                delta, child.textContent, {'code': true});
            break;
          case 'a':
            final href = child.attributes['href'] ?? '';
            _addTextWithAttributes(
                delta, child.textContent, {'link': href});
            break;
          default:
            _convertInlineNodes(child, delta);
        }
      }
    }
  }

  void _addTextWithAttributes(
      Delta delta, String text, Map<String, dynamic> attributes) {
    if (text.isNotEmpty) {
      delta.insert(text, attributes);
    }
  }

  String _applyMarkdownFormatting(
      String text, Map<String, dynamic> attributes) {
    var formatted = text;

    if (attributes['bold'] == true) {
      formatted = '**$formatted**';
    }
    if (attributes['italic'] == true) {
      formatted = '_${formatted}_';
    }
    if (attributes['code'] == true) {
      formatted = '`$formatted`';
    }
    if (attributes.containsKey('link')) {
      formatted = '[$formatted](${attributes['link']})';
    }
    if (attributes.containsKey('header')) {
      final level = attributes['header'] as int;
      formatted = '${'#' * level} $formatted';
    }

    return formatted;
  }
}

extension on md.Node {
  String get textContent {
    if (this is md.Text) {
      return (this as md.Text).text;
    } else if (this is md.Element) {
      final element = this as md.Element;
      return element.children
              ?.map((child) => child.textContent)
              .join() ??
          '';
    }
    return '';
  }
}
