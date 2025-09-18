class ResponsiveBreakpoints {
  // Screen width breakpoints
  static const double desktop = 768.0;
  static const double narrowDesktop = 900.0; // For better desktop experience
  static const double tablet = 600.0;
  static const double mobile = 0.0;
  
  // Minimum supported screen size
  static const double minWidth = 400.0;
  static const double minHeight = 480.0;
  
  // Helper methods for easy usage
  static bool isDesktop(double width) => width >= desktop;
  static bool isNarrowDesktop(double width) => width >= desktop && width < narrowDesktop;
  static bool isWideDesktop(double width) => width >= narrowDesktop;
  static bool isTablet(double width) => width >= tablet && width < desktop;
  static bool isMobile(double width) => width < tablet;
  
  // Get layout type as enum
  static DeviceType getDeviceType(double width) {
    if (width >= narrowDesktop) return DeviceType.wideDesktop;
    if (width >= desktop) return DeviceType.narrowDesktop;
    if (width >= tablet) return DeviceType.tablet;
    return DeviceType.mobile;
  }
}

enum DeviceType {
  wideDesktop,
  narrowDesktop,
  tablet,
  mobile,
}