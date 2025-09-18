import 'dart:typed_data';

/// Stub file saver for non-web platforms
Future<String> saveFileWeb(Uint8List imageData, String filename) async {
  throw UnsupportedError('Web file saving is not supported on this platform');
}