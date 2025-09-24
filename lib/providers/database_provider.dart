import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

// Singleton database instance
MadnessDatabase? _databaseInstance;

// Shared database provider for all other providers to use
final databaseProvider = Provider<MadnessDatabase>((ref) {
  // Keep the provider alive to prevent multiple instances
  ref.keepAlive();

  // Return singleton instance
  return _databaseInstance ??= MadnessDatabase();
});