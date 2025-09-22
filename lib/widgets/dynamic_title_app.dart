import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';

class DynamicTitleApp extends ConsumerWidget {
  final Widget child;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  const DynamicTitleApp({
    super.key,
    required this.child,
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(currentProjectProvider);

    String title = 'Madness';
    if (project != null && project.name.isNotEmpty) {
      title = 'Madness - ${project.name}';
    }

    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      home: Builder(
        builder: (context) {
          // This forces a rebuild when the title changes
          return child;
        },
      ),
    );
  }
}