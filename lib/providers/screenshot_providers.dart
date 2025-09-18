import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/screenshot.dart';
import '../services/editor_history_service.dart';
import 'database_provider.dart';

// Screenshot providers using real database
final projectScreenshotsProvider = FutureProvider.family<List<Screenshot>, String>((ref, projectId) async {
  final database = ref.watch(databaseProvider);
  return await database.getAllScreenshots(projectId);
});

final screenshotProvider = FutureProvider.family<Screenshot?, String>((ref, screenshotId) async {
  final database = ref.watch(databaseProvider);
  return await database.getScreenshot(screenshotId);
});

// Editor history service provider
final editorHistoryProvider = Provider.family<EditorHistoryService, String>((ref, screenshotId) {
  return EditorHistoryService();
});