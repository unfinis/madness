/// Utility class for converting between HTML and Markdown formats
/// Specifically designed for penetration testing documentation needs
class HtmlMarkdownConverter {
  /// Converts HTML content to Markdown format
  static String htmlToMarkdown(String html) {
    if (html.isEmpty) return '';

    String markdown = html
        // Remove HTML tags that don't have markdown equivalents
        .replaceAll(RegExp(r'</?div[^>]*>'), '')
        .replaceAll(RegExp(r'</?span[^>]*>'), '')
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'</?p[^>]*>'), '\n')

        // Headers (preserve hierarchy)
        .replaceAll(RegExp(r'<h1[^>]*>(.*?)</h1>', dotAll: true), '# \$1\n\n')
        .replaceAll(RegExp(r'<h2[^>]*>(.*?)</h2>', dotAll: true), '## \$1\n\n')
        .replaceAll(RegExp(r'<h3[^>]*>(.*?)</h3>', dotAll: true), '### \$1\n\n')
        .replaceAll(RegExp(r'<h4[^>]*>(.*?)</h4>', dotAll: true), '#### \$1\n\n')
        .replaceAll(RegExp(r'<h5[^>]*>(.*?)</h5>', dotAll: true), '##### \$1\n\n')
        .replaceAll(RegExp(r'<h6[^>]*>(.*?)</h6>', dotAll: true), '###### \$1\n\n')

        // Text formatting
        .replaceAll(RegExp(r'<strong[^>]*>(.*?)</strong>', dotAll: true), '**\$1**')
        .replaceAll(RegExp(r'<b[^>]*>(.*?)</b>', dotAll: true), '**\$1**')
        .replaceAll(RegExp(r'<em[^>]*>(.*?)</em>', dotAll: true), '*\$1*')
        .replaceAll(RegExp(r'<i[^>]*>(.*?)</i>', dotAll: true), '*\$1*')
        .replaceAll(RegExp(r'<u[^>]*>(.*?)</u>', dotAll: true), '_\$1_')
        .replaceAll(RegExp(r'<del[^>]*>(.*?)</del>', dotAll: true), '~~\$1~~')
        .replaceAll(RegExp(r'<s[^>]*>(.*?)</s>', dotAll: true), '~~\$1~~')

        // Code formatting
        .replaceAll(RegExp(r'<code[^>]*>(.*?)</code>', dotAll: true), '`\$1`')
        .replaceAll(RegExp(r'<pre[^>]*><code[^>]*>(.*?)</code></pre>', dotAll: true), '```\n\$1\n```')
        .replaceAll(RegExp(r'<pre[^>]*>(.*?)</pre>', dotAll: true), '```\n\$1\n```')

        // Links
        .replaceAll(RegExp(r'<a[^>]*href="([^"]*)"[^>]*>(.*?)</a>', dotAll: true), '[\$2](\$1)')

        // Lists (preserve nesting)
        .replaceAll(RegExp(r'<ul[^>]*>'), '')
        .replaceAll(RegExp(r'</ul>'), '')
        .replaceAll(RegExp(r'<ol[^>]*>'), '')
        .replaceAll(RegExp(r'</ol>'), '')
        .replaceAll(RegExp(r'<li[^>]*>(.*?)</li>', dotAll: true), '* \$1\n')

        // Blockquotes
        .replaceAll(RegExp(r'<blockquote[^>]*>(.*?)</blockquote>', dotAll: true), '> \$1\n')

        // Horizontal rules
        .replaceAll(RegExp(r'<hr[^>]*>'), '\n---\n');

    // Handle tables (convert to markdown tables)
    markdown = _convertHtmlTablesToMarkdown(markdown);

    // Clean up extra whitespace and HTML entities
    markdown = markdown
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'&nbsp;'), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'&quot;'), '"')
        .replaceAll(RegExp(r'&#39;'), "'")
        .trim();

    return markdown;
  }

  /// Converts Markdown content to HTML format
  static String markdownToHtml(String markdown) {
    if (markdown.isEmpty) return '';

    String html = markdown
        // Headers (convert in reverse order to avoid conflicts)
        .replaceAll(RegExp(r'^###### (.+)$', multiLine: true), '<h6>\$1</h6>')
        .replaceAll(RegExp(r'^##### (.+)$', multiLine: true), '<h5>\$1</h5>')
        .replaceAll(RegExp(r'^#### (.+)$', multiLine: true), '<h4>\$1</h4>')
        .replaceAll(RegExp(r'^### (.+)$', multiLine: true), '<h3>\$1</h3>')
        .replaceAll(RegExp(r'^## (.+)$', multiLine: true), '<h2>\$1</h2>')
        .replaceAll(RegExp(r'^# (.+)$', multiLine: true), '<h1>\$1</h1>')

        // Code blocks (must come before inline code)
        .replaceAll(RegExp(r'```(\w+)?\n(.*?)\n```', dotAll: true), '<pre><code>\$2</code></pre>')
        .replaceAll(RegExp(r'```\n(.*?)\n```', dotAll: true), '<pre><code>\$1</code></pre>')

        // Text formatting
        .replaceAll(RegExp(r'\*\*(.+?)\*\*'), '<strong>\$1</strong>')
        .replaceAll(RegExp(r'__(.+?)__'), '<strong>\$1</strong>')
        .replaceAll(RegExp(r'\*(.+?)\*'), '<em>\$1</em>')
        .replaceAll(RegExp(r'_(.+?)_'), '<em>\$1</em>')
        .replaceAll(RegExp(r'~~(.+?)~~'), '<del>\$1</del>')
        .replaceAll(RegExp(r'`(.+?)`'), '<code>\$1</code>')

        // Links and images
        .replaceAll(RegExp(r'!\[([^\]]*)\]\(([^)]+)\)'), '<img src="\$2" alt="\$1" />')
        .replaceAll(RegExp(r'\[([^\]]+)\]\(([^)]+)\)'), '<a href="\$2">\$1</a>')

        // Blockquotes
        .replaceAll(RegExp(r'^> (.+)$', multiLine: true), '<blockquote>\$1</blockquote>')

        // Horizontal rules
        .replaceAll(RegExp(r'^---+$', multiLine: true), '<hr>')

        // Lists (unordered)
        .replaceAll(RegExp(r'^[\*\-\+] (.+)$', multiLine: true), '<li>\$1</li>')

        // Lists (ordered)
        .replaceAll(RegExp(r'^\d+\. (.+)$', multiLine: true), '<li>\$1</li>')

        // Line breaks
        .replaceAll('\n\n', '</p><p>')
        .replaceAll('\n', '<br>');

    // Convert markdown tables to HTML tables
    html = _convertMarkdownTablesToHtml(html);

    // Wrap consecutive list items in ul/ol tags
    html = _wrapListItems(html);

    // Wrap in paragraphs if needed
    if (!html.startsWith('<') && html.isNotEmpty) {
      html = '<p>$html</p>';
    }

    return html;
  }

  /// Converts HTML tables to markdown table format
  static String _convertHtmlTablesToMarkdown(String html) {
    return html.replaceAllMapped(
      RegExp(r'<table[^>]*>(.*?)</table>', dotAll: true),
      (match) {
        final tableContent = match.group(1) ?? '';
        final rows = <String>[];

        // Extract table rows
        final rowMatches = RegExp(r'<tr[^>]*>(.*?)</tr>', dotAll: true).allMatches(tableContent);
        bool isFirstRow = true;
        bool hasHeaderRow = tableContent.contains('<th');

        for (final rowMatch in rowMatches) {
          final rowContent = rowMatch.group(1) ?? '';
          final cells = <String>[];

          // Extract cells (th or td)
          final cellMatches = RegExp(r'<t[hd][^>]*>(.*?)</t[hd]>', dotAll: true).allMatches(rowContent);
          for (final cellMatch in cellMatches) {
            final cellContent = (cellMatch.group(1) ?? '')
                .replaceAll(RegExp(r'<[^>]*>'), '')
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim();
            cells.add(cellContent);
          }

          if (cells.isNotEmpty) {
            rows.add('| ${cells.join(' | ')} |');

            // Add separator row after header row
            if (isFirstRow && hasHeaderRow) {
              rows.add('| ${cells.map((_) => '---').join(' | ')} |');
            }
            isFirstRow = false;
          }
        }

        return rows.join('\n') + '\n';
      },
    );
  }

  /// Converts markdown tables to HTML table format with security-focused styling
  static String _convertMarkdownTablesToHtml(String markdown) {
    return markdown.replaceAllMapped(
      RegExp(r'\|(.+)\|\n\|[-\s\|]+\|\n((?:\|.+\|\n?)*)', multiLine: true),
      (match) {
        final headerRow = match.group(1) ?? '';
        final dataRows = match.group(2) ?? '';

        final headerCells = headerRow.split('|')
            .map((cell) => cell.trim())
            .where((cell) => cell.isNotEmpty)
            .toList();

        final dataRowsList = dataRows.split('\n')
            .where((row) => row.trim().isNotEmpty && row.contains('|'))
            .toList();

        final buffer = StringBuffer();

        // Security-focused table styling
        buffer.writeln('<table border="1" style="border-collapse: collapse; width: 100%; margin: 10px 0; font-family: \'Segoe UI\', Tahoma, Geneva, Verdana, sans-serif;">');

        // Header with security-themed styling
        if (headerCells.isNotEmpty) {
          buffer.writeln('<thead>');
          buffer.writeln('<tr style="background-color: #2c3e50; color: white;">');
          for (final cell in headerCells) {
            buffer.writeln('<th style="padding: 12px 8px; text-align: left; font-weight: 600; border: 1px solid #34495e;">${_escapeHtml(cell)}</th>');
          }
          buffer.writeln('</tr>');
          buffer.writeln('</thead>');
        }

        // Body with alternating row colors for readability
        if (dataRowsList.isNotEmpty) {
          buffer.writeln('<tbody>');
          for (int i = 0; i < dataRowsList.length; i++) {
            final row = dataRowsList[i];
            final cells = row.split('|')
                .map((cell) => cell.trim())
                .where((cell) => cell.isNotEmpty)
                .toList();

            if (cells.isNotEmpty) {
              final bgColor = i.isEven ? '#f8f9fa' : '#ffffff';
              buffer.writeln('<tr style="background-color: $bgColor;">');
              for (final cell in cells) {
                // Check for security severity indicators
                final cellStyle = _getSecurityCellStyle(cell);
                buffer.writeln('<td style="padding: 10px 8px; border: 1px solid #dee2e6; $cellStyle">${_escapeHtml(cell)}</td>');
              }
              buffer.writeln('</tr>');
            }
          }
          buffer.writeln('</tbody>');
        }

        buffer.writeln('</table>');
        return buffer.toString();
      },
    );
  }

  /// Gets appropriate styling for security-related table cells
  static String _getSecurityCellStyle(String cellContent) {
    final content = cellContent.toLowerCase();

    // Security severity styling
    if (content.contains('critical') || content.contains('high')) {
      return 'background-color: #fee; color: #c53030; font-weight: 600;';
    } else if (content.contains('medium')) {
      return 'background-color: #fff3cd; color: #b45309; font-weight: 600;';
    } else if (content.contains('low')) {
      return 'background-color: #d1ecf1; color: #0c5460; font-weight: 600;';
    } else if (content.contains('info') || content.contains('informational')) {
      return 'background-color: #e2e3e5; color: #495057; font-weight: 600;';
    }

    // Status indicators
    if (content.contains('vulnerable') || content.contains('exploitable')) {
      return 'background-color: #f8d7da; color: #721c24; font-weight: 500;';
    } else if (content.contains('patched') || content.contains('fixed')) {
      return 'background-color: #d4edda; color: #155724; font-weight: 500;';
    }

    return '';
  }

  /// Wraps consecutive list items in appropriate ul/ol tags
  static String _wrapListItems(String html) {
    // Wrap unordered list items
    html = html.replaceAllMapped(
      RegExp(r'(<li>.*?</li>(?:\s*<br>\s*<li>.*?</li>)*)', dotAll: true),
      (match) => '<ul>${match.group(0)?.replaceAll('<br>', '')}</ul>',
    );

    return html;
  }

  /// Escapes HTML entities to prevent XSS in user content
  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  /// Batch converts multiple markdown strings to HTML
  static List<String> batchMarkdownToHtml(List<String> markdownList) {
    return markdownList.map((md) => markdownToHtml(md)).toList();
  }

  /// Batch converts multiple HTML strings to markdown
  static List<String> batchHtmlToMarkdown(List<String> htmlList) {
    return htmlList.map((html) => htmlToMarkdown(html)).toList();
  }

  /// Creates a migration report for debugging conversions
  static Map<String, dynamic> createConversionReport(String originalContent, String contentType) {
    String converted;
    String roundTrip;
    String? error;

    try {
      if (contentType.toLowerCase() == 'markdown') {
        converted = markdownToHtml(originalContent);
        roundTrip = htmlToMarkdown(converted);
      } else {
        converted = htmlToMarkdown(originalContent);
        roundTrip = markdownToHtml(converted);
      }
    } catch (e) {
      error = e.toString();
      converted = '';
      roundTrip = '';
    }

    return {
      'original_type': contentType,
      'original_length': originalContent.length,
      'converted_length': converted.length,
      'has_tables': originalContent.contains('table') || originalContent.contains('|'),
      'has_lists': originalContent.contains('<li>') || originalContent.contains('*') || RegExp(r'\d+\.').hasMatch(originalContent),
      'has_formatting': originalContent.contains('<strong>') || originalContent.contains('**'),
      'conversion_successful': error == null,
      'error': error,
      'round_trip_similarity': _calculateSimilarity(originalContent, roundTrip),
    };
  }

  /// Calculates similarity percentage between two strings
  static double _calculateSimilarity(String str1, String str2) {
    if (str1 == str2) return 100.0;
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    final longer = str1.length > str2.length ? str1 : str2;
    final shorter = str1.length > str2.length ? str2 : str1;

    if (longer.isEmpty) return 100.0;

    final editDistance = _levenshteinDistance(str1, str2);
    return ((longer.length - editDistance) / longer.length) * 100;
  }

  /// Calculates Levenshtein distance between two strings
  static int _levenshteinDistance(String str1, String str2) {
    final len1 = str1.length;
    final len2 = str2.length;

    final matrix = List.generate(len1 + 1, (i) => List.filled(len2 + 1, 0));

    for (int i = 0; i <= len1; i++) {
      matrix[i][0] = i;
    }
    for (int j = 0; j <= len2; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= len1; i++) {
      for (int j = 1; j <= len2; j++) {
        final cost = str1[i - 1] == str2[j - 1] ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1,      // deletion
          matrix[i][j - 1] + 1,      // insertion
          matrix[i - 1][j - 1] + cost // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[len1][len2];
  }
}