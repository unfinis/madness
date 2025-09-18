import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database.dart';

// Shared database provider for all other providers to use
final databaseProvider = Provider<MadnessDatabase>((ref) {
  return MadnessDatabase();
});