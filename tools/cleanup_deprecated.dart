import 'dart:io';

/// Cleanup script for removing deprecated code from the trigger system
///
/// This script:
/// 1. Removes deprecated files
/// 2. Marks deprecated methods with @deprecated annotation
/// 3. Generates a report of changes
///
/// Usage: dart run tools/cleanup_deprecated.dart

void main() async {
  print('╔════════════════════════════════════════════╗');
  print('║  Trigger System Cleanup Script             ║');
  print('║  Removing deprecated code...               ║');
  print('╚════════════════════════════════════════════╝\n');

  var totalChanges = 0;

  // Files to remove entirely (if they exist)
  final filesToDelete = [
    'lib/services/trigger_implementation_fix.dart',
    'lib/services/property_driven_engine.dart',
  ];

  // Remove deprecated files
  print('📁 Checking for deprecated files...');
  for (final path in filesToDelete) {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
      print('   ✅ Deleted: $path');
      totalChanges++;
    } else {
      print('   ℹ️  Not found: $path');
    }
  }

  // Files with deprecated methods to mark
  final filesToClean = {
    'lib/services/smart_triggers.dart': [
      {
        'name': 'confidence',
        'reason': 'Moved to boolean matching with separate priority',
      },
      {
        'name': '_evaluatePropertyConditions',
        'reason': 'Replaced by new trigger_system evaluation',
      },
    ],
    'lib/services/trigger_evaluator.dart': [
      {
        'name': '_calculateConfidence',
        'reason': 'Confidence removed in favor of boolean matching',
      },
      {
        'name': '_calculatePriority',
        'reason': 'Replaced by ExecutionPrioritizer',
      },
    ],
  };

  // Mark deprecated methods (only if files exist)
  print('\n📝 Marking deprecated methods...');
  for (final entry in filesToClean.entries) {
    final file = File(entry.key);
    if (!await file.exists()) {
      print('   ℹ️  File not found: ${entry.key}');
      continue;
    }

    final changes = await _markDeprecatedMethods(file, entry.value);
    if (changes > 0) {
      print('   ✅ Updated: ${entry.key} ($changes changes)');
      totalChanges += changes;
    }
  }

  // Check for unused imports
  print('\n🔍 Checking for unused imports...');
  final unusedImports = await _findUnusedImports();
  if (unusedImports.isNotEmpty) {
    print('   Found ${unusedImports.length} files with potentially unused imports');
    for (final file in unusedImports) {
      print('   ⚠️  Check: $file');
    }
  }

  // Generate report
  print('\n' + '─' * 48);
  print('📊 Cleanup Summary:');
  print('   Total changes: $totalChanges');
  print('   Files deleted: ${filesToDelete.where((f) => !File(f).existsSync()).length}');
  print('   Files modified: ${filesToClean.length}');
  print('─' * 48);

  if (totalChanges > 0) {
    print('\n✨ Cleanup complete! Run analysis to verify:');
    print('   flutter analyze --no-fatal-warnings');
  } else {
    print('\n✅ No deprecated code found - codebase is clean!');
  }

  // Migration notes
  print('\n📚 Migration Notes:');
  print('   • Boolean matching: Use TriggerMatchResult.matched instead of confidence');
  print('   • Priority: Use ExecutionPrioritizer.calculatePriority()');
  print('   • History: Use ExecutionHistory for success tracking');
  print('   • Deduplication: Use TriggerDeduplication.generateKey()');
  print('');
}

/// Mark methods as deprecated in a file
Future<int> _markDeprecatedMethods(
  File file,
  List<Map<String, String>> methods,
) async {
  var content = await file.readAsString();
  var changes = 0;

  for (final method in methods) {
    final methodName = method['name']!;
    final reason = method['reason']!;

    // Skip if already marked as deprecated
    if (content.contains('@Deprecated') &&
        content.contains(methodName)) {
      continue;
    }

    // Pattern to find method declarations
    final patterns = [
      RegExp(r'(\s+)(static\s+)?(\w+)\s+' + RegExp.escape(methodName) + r'\s*\('),
      RegExp(r'(\s+)(Future<\w+>|Stream<\w+>)\s+' + RegExp.escape(methodName) + r'\s*\('),
    ];

    for (final pattern in patterns) {
      if (pattern.hasMatch(content)) {
        content = content.replaceAllMapped(pattern, (match) {
          final indent = match.group(1) ?? '';
          final rest = match.group(0)!.substring(indent.length);
          return '$indent@Deprecated(\'$reason\')\n$indent$rest';
        });
        changes++;
        break;
      }
    }
  }

  if (changes > 0) {
    await file.writeAsString(content);
  }

  return changes;
}

/// Find files with potentially unused imports
Future<List<String>> _findUnusedImports() async {
  final unusedImports = <String>[];
  final libDir = Directory('lib');

  if (!await libDir.exists()) {
    return unusedImports;
  }

  // Check for imports of deleted files
  final deletedImports = [
    'trigger_implementation_fix',
    'property_driven_engine',
  ];

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();

      for (final deleted in deletedImports) {
        if (content.contains("import '") &&
            content.contains('$deleted.dart')) {
          unusedImports.add(entity.path);
          break;
        }
      }
    }
  }

  return unusedImports;
}
