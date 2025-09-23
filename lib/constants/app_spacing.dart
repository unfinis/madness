import 'package:flutter/material.dart';

class AppSpacing {
  // Base spacing units
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
  static const double huge = 64.0;

  // Common EdgeInsets
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);
  static const EdgeInsets contentPadding = EdgeInsets.all(xl);
  static const EdgeInsets listPadding = EdgeInsets.all(sm);
  static const EdgeInsets dialogPadding = EdgeInsets.all(xl);
  static const EdgeInsets dialogHeaderPadding = EdgeInsets.all(lg);
  static const EdgeInsets dialogContentPadding = EdgeInsets.all(xl);
  static const EdgeInsets dialogActionsPadding = EdgeInsets.all(lg);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: md, vertical: xs);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(horizontal: sm, vertical: xs);

  // Common SizedBox widgets
  static const Widget gapXS = SizedBox(height: xs, width: xs);
  static const Widget gapSM = SizedBox(height: sm, width: sm);
  static const Widget gapMD = SizedBox(height: md, width: md);
  static const Widget gapLG = SizedBox(height: lg, width: lg);
  static const Widget gapXL = SizedBox(height: xl, width: xl);
  static const Widget gapXXL = SizedBox(height: xxl, width: xxl);

  // Vertical gaps
  static const Widget vGapXS = SizedBox(height: xs);
  static const Widget vGapSM = SizedBox(height: sm);
  static const Widget vGapMD = SizedBox(height: md);
  static const Widget vGapLG = SizedBox(height: lg);
  static const Widget vGapXL = SizedBox(height: xl);
  static const Widget vGapXXL = SizedBox(height: xxl);

  // Horizontal gaps
  static const Widget hGapXS = SizedBox(width: xs);
  static const Widget hGapSM = SizedBox(width: sm);
  static const Widget hGapMD = SizedBox(width: md);
  static const Widget hGapLG = SizedBox(width: lg);
  static const Widget hGapXL = SizedBox(width: xl);
  static const Widget hGapXXL = SizedBox(width: xxl);
}

class AppSizes {
  // Icon sizes
  static const double iconXS = 12.0;
  static const double iconSM = 16.0;
  static const double iconMD = 20.0;
  static const double iconLG = 24.0;
  static const double iconXL = 32.0;
  static const double huge = 64.0;

  // Common widget constraints
  static const double cardMinHeight = 80.0;
  static const double cardMaxHeight = 120.0;
  static const double cardCompactMinHeight = 70.0;
  static const double cardCompactMaxHeight = 90.0;

  // Border radius - Updated for dialog system
  static const double buttonRadius = 12.0; // Updated from 8.0
  static const double cardRadius = 12.0;
  static const double chipRadius = 4.0;
  static const double dialogRadius = 16.0; // Updated from 12.0
  static const double fieldRadius = 12.0; // New for form fields

  // Dialog specific sizes
  static const double dialogHeaderHeight = 80.0;
  static const double dialogActionHeight = 72.0;
  static const double dialogMinWidth = 320.0;
  static const double dialogMaxWidth = 1200.0;
}

extension ThemeTextStyles on TextTheme {
  TextStyle get captionSmall => bodySmall!.copyWith(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
  );
  
  TextStyle get captionMedium => bodySmall!.copyWith(
    fontSize: 11.0,
    fontWeight: FontWeight.w500,
  );
  
  TextStyle get compactTitle => titleMedium!.copyWith(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
  );
  
  TextStyle get compactBody => bodyMedium!.copyWith(
    fontSize: 12.0,
  );
}