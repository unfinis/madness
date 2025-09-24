/// Unified responsive breakpoints for filter components
class FilterBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double desktop = 1440;
  static const double wide = 1920;

  /// Check if screen width is mobile
  static bool isMobile(double width) => width < mobile;

  /// Check if screen width is tablet
  static bool isTablet(double width) => width >= mobile && width < desktop;

  /// Check if screen width is desktop
  static bool isDesktop(double width) => width >= desktop;

  /// Check if screen width is wide desktop
  static bool isWide(double width) => width >= wide;

  /// Get responsive spacing based on screen width
  static double getSpacing(double width) {
    if (isMobile(width)) return 12.0;
    if (isTablet(width)) return 16.0;
    return 20.0;
  }

  /// Get responsive margin based on screen width
  static double getMargin(double width) {
    if (isMobile(width)) return 16.0;
    if (isTablet(width)) return 20.0;
    return 24.0;
  }

  /// Get search bar height based on screen width
  static double getSearchHeight(double width) {
    return isMobile(width) ? 48.0 : 44.0;
  }

  /// Get filter chip height based on screen width
  static double getChipHeight(double width) {
    return isMobile(width) ? 36.0 : 32.0;
  }
}