import 'dart:html' as html;
import 'dart:typed_data';

/// Web-specific file saver implementation
Future<String> saveFileWeb(Uint8List imageData, String filename) async {
  try {
    // Create a blob and download link for web
    final blob = html.Blob([imageData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;
    
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
    
    return 'Downloaded: $filename';
  } catch (e) {
    throw Exception('Failed to save file: $e');
  }
}