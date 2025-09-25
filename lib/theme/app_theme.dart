import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

/// Comprehensive theming system for the Madness application
class AppTheme {
  AppTheme._();

  // ================== COLOR SCHEMES ==================

  /// Light theme color scheme
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2),
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD1E7FF),
    onPrimaryContainer: Color(0xFF001D35),
    secondary: Color(0xFF535F70),
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD7E3F8),
    onSecondaryContainer: Color(0xFF101C2B),
    tertiary: Color(0xFF6B5778),
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFF2DAFF),
    onTertiaryContainer: Color(0xFF251431),
    error: Color(0xFFD32F2F),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    outline: Color(0xFF73777F),
    background: Color(0xFFFDFCFF),
    onBackground: Color(0xFF1A1C1E),
    surface: Color(0xFFFDFCFF),
    onSurface: Color(0xFF1A1C1E),
    onSurfaceVariant: Color(0xFF43474E),
    inverseSurface: Color(0xFF2F3133),
    onInverseSurface: Color(0xFFF1F0F4),
    inversePrimary: Color(0xFFA0CAFD),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceContainer: Color(0xFFF3F4F9),
    surfaceContainerHighest: Color(0xFFE6E7EC),
  );

  /// Dark theme color scheme
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFA0CAFD),
    onPrimary: Color(0xFF003258),
    primaryContainer: Color(0xFF004A77),
    onPrimaryContainer: Color(0xFFD1E7FF),
    secondary: Color(0xFFBBC7DB),
    onSecondary: Color(0xFF253140),
    secondaryContainer: Color(0xFF3B4858),
    onSecondaryContainer: Color(0xFFD7E3F8),
    tertiary: Color(0xFFD5BEE4),
    onTertiary: Color(0xFF3B2948),
    tertiaryContainer: Color(0xFF523F5F),
    onTertiaryContainer: Color(0xFFF2DAFF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    outline: Color(0xFF8D9199),
    background: Color(0xFF111318),
    onBackground: Color(0xFFE2E2E6),
    surface: Color(0xFF111318),
    onSurface: Color(0xFFE2E2E6),
    onSurfaceVariant: Color(0xFFC3C7CF),
    inverseSurface: Color(0xFFE2E2E6),
    onInverseSurface: Color(0xFF2F3133),
    inversePrimary: Color(0xFF1976D2),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceContainer: Color(0xFF1D1F23),
    surfaceContainerHighest: Color(0xFF282A2E),
  );

  // ================== THEME DATA ==================

  /// Light theme configuration
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    fontFamily: 'Segoe UI',
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: _lightColorScheme.surface,
      foregroundColor: _lightColorScheme.onSurface,
      titleTextStyle: _lightTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: _lightColorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: _lightColorScheme.onSurface,
        size: AppSizes.iconLG,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      color: _lightColorScheme.surface,
      shadowColor: _lightColorScheme.shadow.withValues(alpha: 0.1),
    ),

    // Button Themes
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        elevation: 2,
        textStyle: _lightTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        side: BorderSide(
          color: _lightColorScheme.outline.withValues(alpha: 0.5),
        ),
        textStyle: _lightTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        textStyle: _lightTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // FAB Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightColorScheme.surfaceContainer.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(color: _lightColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(
          color: _lightColorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(
          color: _lightColorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(color: _lightColorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(
          color: _lightColorScheme.error,
          width: 2,
        ),
      ),
      labelStyle: _lightTextTheme.bodyMedium?.copyWith(
        color: _lightColorScheme.onSurfaceVariant,
      ),
      helperStyle: _lightTextTheme.bodySmall?.copyWith(
        color: _lightColorScheme.onSurfaceVariant,
      ),
      errorStyle: _lightTextTheme.bodySmall?.copyWith(
        color: _lightColorScheme.error,
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: AppSpacing.cardPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      tileColor: _lightColorScheme.surface,
      selectedTileColor: _lightColorScheme.primaryContainer,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: _lightColorScheme.surfaceContainer,
      selectedColor: _lightColorScheme.primaryContainer,
      deleteIconColor: _lightColorScheme.onSurfaceVariant,
      labelStyle: _lightTextTheme.bodySmall?.copyWith(
        color: _lightColorScheme.onSurface,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 4),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: _lightColorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
      ),
      titleTextStyle: _lightTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: _lightColorScheme.onSurface,
      ),
      contentTextStyle: _lightTextTheme.bodyMedium?.copyWith(
        color: _lightColorScheme.onSurfaceVariant,
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _lightColorScheme.inverseSurface,
      contentTextStyle: _lightTextTheme.bodyMedium?.copyWith(
        color: _lightColorScheme.onInverseSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 4,
    ),

    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(
        _lightColorScheme.surfaceContainer,
      ),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _lightColorScheme.primaryContainer.withValues(alpha: 0.3);
        }
        return null;
      }),
      dividerThickness: 1,
      horizontalMargin: AppSpacing.lg,
      columnSpacing: AppSpacing.xl,
      headingTextStyle: _lightTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: _lightColorScheme.onSurface,
      ),
      dataTextStyle: _lightTextTheme.bodyMedium?.copyWith(
        color: _lightColorScheme.onSurface,
      ),
    ),

    // Navigation Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _lightColorScheme.surface,
      elevation: 3,
      height: 72,
      labelTextStyle: WidgetStateProperty.all(
        _lightTextTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textTheme: _lightTextTheme,
  );

  /// Dark theme configuration
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    fontFamily: 'Segoe UI',
    visualDensity: VisualDensity.adaptivePlatformDensity,

    // App Bar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: _darkColorScheme.surface,
      foregroundColor: _darkColorScheme.onSurface,
      titleTextStyle: _darkTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: _darkColorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: _darkColorScheme.onSurface,
        size: AppSizes.iconLG,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      color: _darkColorScheme.surface,
      shadowColor: _darkColorScheme.shadow.withValues(alpha: 0.2),
    ),

    // Button Themes (similar to light theme but with dark colors)
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        elevation: 2,
        textStyle: _darkTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        side: BorderSide(
          color: _darkColorScheme.outline.withValues(alpha: 0.5),
        ),
        textStyle: _darkTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 48),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
        ),
        textStyle: _darkTextTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // FAB Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkColorScheme.surfaceContainer.withValues(alpha: 0.3),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(color: _darkColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(
          color: _darkColorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(
          color: _darkColorScheme.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(color: _darkColorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
        borderSide: BorderSide(
          color: _darkColorScheme.error,
          width: 2,
        ),
      ),
      labelStyle: _darkTextTheme.bodyMedium?.copyWith(
        color: _darkColorScheme.onSurfaceVariant,
      ),
      helperStyle: _darkTextTheme.bodySmall?.copyWith(
        color: _darkColorScheme.onSurfaceVariant,
      ),
      errorStyle: _darkTextTheme.bodySmall?.copyWith(
        color: _darkColorScheme.error,
      ),
    ),

    // List Tile Theme
    listTileTheme: ListTileThemeData(
      contentPadding: AppSpacing.cardPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      tileColor: _darkColorScheme.surface,
      selectedTileColor: _darkColorScheme.primaryContainer,
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: _darkColorScheme.surfaceContainer,
      selectedColor: _darkColorScheme.primaryContainer,
      deleteIconColor: _darkColorScheme.onSurfaceVariant,
      labelStyle: _darkTextTheme.bodySmall?.copyWith(
        color: _darkColorScheme.onSurface,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.chipRadius * 4),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: _darkColorScheme.surface,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.dialogRadius),
      ),
      titleTextStyle: _darkTextTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: _darkColorScheme.onSurface,
      ),
      contentTextStyle: _darkTextTheme.bodyMedium?.copyWith(
        color: _darkColorScheme.onSurfaceVariant,
      ),
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _darkColorScheme.inverseSurface,
      contentTextStyle: _darkTextTheme.bodyMedium?.copyWith(
        color: _darkColorScheme.onInverseSurface,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 6,
    ),

    // Data Table Theme
    dataTableTheme: DataTableThemeData(
      headingRowColor: WidgetStateProperty.all(
        _darkColorScheme.surfaceContainer,
      ),
      dataRowColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _darkColorScheme.primaryContainer.withValues(alpha: 0.3);
        }
        return null;
      }),
      dividerThickness: 1,
      horizontalMargin: AppSpacing.lg,
      columnSpacing: AppSpacing.xl,
      headingTextStyle: _darkTextTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: _darkColorScheme.onSurface,
      ),
      dataTextStyle: _darkTextTheme.bodyMedium?.copyWith(
        color: _darkColorScheme.onSurface,
      ),
    ),

    // Navigation Theme
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkColorScheme.surface,
      elevation: 4,
      height: 72,
      labelTextStyle: WidgetStateProperty.all(
        _darkTextTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    textTheme: _darkTextTheme,
  );

  // ================== TEXT THEMES ==================

  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: Color(0xFF1A1C1E),
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1C1E),
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1C1E),
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1C1E),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1C1E),
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1C1E),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFF1A1C1E),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFF1A1C1E),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1A1C1E),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFF1A1C1E),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFF1A1C1E),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFF43474E),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFF1A1C1E),
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF43474E),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFF43474E),
    ),
  );

  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.25,
      color: Color(0xFFE2E2E6),
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE2E2E6),
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE2E2E6),
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE2E2E6),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE2E2E6),
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE2E2E6),
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      color: Color(0xFFE2E2E6),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.15,
      color: Color(0xFFE2E2E6),
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFE2E2E6),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Color(0xFFE2E2E6),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
      color: Color(0xFFE2E2E6),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
      color: Color(0xFFC3C7CF),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
      color: Color(0xFFE2E2E6),
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFFC3C7CF),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: Color(0xFFC3C7CF),
    ),
  );

  // ================== THEME EXTENSIONS ==================

  /// Get theme-appropriate colors for status indicators
  static Color getStatusColor(BuildContext context, String status) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'active':
        return Colors.green;
      case 'warning':
      case 'pending':
        return Colors.orange;
      case 'error':
      case 'failed':
      case 'inactive':
        return colorScheme.error;
      case 'info':
      case 'processing':
        return colorScheme.primary;
      default:
        return colorScheme.outline;
    }
  }

  /// Get semantic colors for different contexts
  static Color getSemanticColor(BuildContext context, SemanticColor color) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (color) {
      case SemanticColor.success:
        return Colors.green;
      case SemanticColor.warning:
        return Colors.orange;
      case SemanticColor.error:
        return colorScheme.error;
      case SemanticColor.info:
        return colorScheme.primary;
      case SemanticColor.neutral:
        return colorScheme.outline;
    }
  }

  /// Check if current theme is dark
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get appropriate text color for background
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}

/// Semantic color enumeration
enum SemanticColor {
  success,
  warning,
  error,
  info,
  neutral,
}

/// Theme mode enumeration for settings
enum AppThemeMode {
  light,
  dark,
  system,
}

/// Theme extensions for additional customization
extension AppThemeExtension on ThemeData {
  /// Get shadow color with appropriate opacity
  Color get shadowColor => colorScheme.shadow.withValues(
    alpha: brightness == Brightness.light ? 0.1 : 0.2,
  );

  /// Get card elevation based on theme
  double get cardElevation => brightness == Brightness.light ? 2 : 4;

  /// Get dialog elevation based on theme
  double get dialogElevation => brightness == Brightness.light ? 8 : 12;
}