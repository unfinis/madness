# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter application called "Madness" built with Flutter SDK ^3.5.4 and Dart.

## Common Commands

### Running the Application
```bash
flutter run                  # Run on connected device/emulator
flutter run -d chrome        # Run in Chrome browser
flutter run -d macos         # Run on macOS desktop
```

### Development Commands
```bash
flutter analyze              # Run static analysis
flutter test                 # Run all tests
flutter test test/widget_test.dart  # Run specific test file
flutter pub get              # Install dependencies
flutter pub upgrade          # Upgrade dependencies
flutter clean                # Clean build artifacts
```

### Building
```bash
flutter build apk            # Build Android APK
flutter build ios            # Build iOS app
flutter build web            # Build web app
flutter build macos          # Build macOS app
flutter build windows        # Build Windows app
flutter build linux          # Build Linux app
```

## Project Structure

The application follows standard Flutter project structure:

- **lib/main.dart**: Entry point containing MyApp (root widget) and MyHomePage (stateful counter demo)
- **test/**: Widget tests using flutter_test package
- **pubspec.yaml**: Package dependencies and Flutter configuration
- **analysis_options.yaml**: Dart analyzer configuration with flutter_lints

## Platform Directories

- **android/**: Android-specific configuration and gradle files
- **ios/**: iOS-specific configuration and Xcode project
- **web/**: Web-specific assets and configuration
- **linux/**, **macos/**, **windows/**: Desktop platform configurations

## Dependencies

- flutter SDK
- cupertino_icons: ^1.0.8
- flutter_lints: ^4.0.0 (dev dependency)

## Responsive Design

The application supports responsive design with the following breakpoints:
- **Desktop**: ≥768px width (side navigation, multi-column layouts)
- **Tablet**: ≥600px width (adapted layouts)
- **Mobile**: <600px width (drawer navigation, stacked layouts)
- **Minimum width**: 320px (standard mobile minimum)

### Minimum Screen Size
- The app enforces a minimum width of 320px and height of 480px
- On extremely small screens, the app scales down and becomes scrollable
- This ensures usability across all device sizes

## Notes

- Material3 design system is enabled (useMaterial3: true)
- The project uses standard Flutter linting rules from flutter_lints package
- Uses Riverpod for state management with proper provider architecture