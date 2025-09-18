import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_shell.dart';
import 'constants/responsive_breakpoints.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MadnessApp(),
    ),
  );
}

class MadnessApp extends StatelessWidget {
  const MadnessApp({super.key});

  // Use responsive breakpoints constants

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Madness - Penetration Testing Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          space: 1,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
        ),
        dividerTheme: const DividerThemeData(
          thickness: 1,
          space: 1,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MinimumSizeWrapper(child: AppShell()),
    );
  }
}

class MinimumSizeWrapper extends StatelessWidget {
  final Widget child;
  
  const MinimumSizeWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Get current screen size
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        
        // Calculate scale factor if screen is too small
        double scaleX = 1.0;
        double scaleY = 1.0;
        
        if (screenWidth < ResponsiveBreakpoints.minWidth) {
          scaleX = screenWidth / ResponsiveBreakpoints.minWidth;
        }
        
        if (screenHeight < ResponsiveBreakpoints.minHeight) {
          scaleY = screenHeight / ResponsiveBreakpoints.minHeight;
        }
        
        // Use the smaller scale factor to maintain aspect ratio
        final scale = scaleX < scaleY ? scaleX : scaleY;
        
        // If screen is too small, apply scaling and scrolling
        if (scale < 1.0) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: ResponsiveBreakpoints.minWidth,
                  height: ResponsiveBreakpoints.minHeight,
                  child: child,
                ),
              ),
            ),
          );
        }
        
        // Screen is large enough, return child as-is
        return child;
      },
    );
  }
}