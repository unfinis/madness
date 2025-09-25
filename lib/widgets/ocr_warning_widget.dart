import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Reusable widget for displaying OCR-related warnings and errors
class OcrWarningWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color? color;
  final List<OcrWarningAction> actions;
  final bool showInstallLink;

  const OcrWarningWidget({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.warning_amber,
    this.color,
    this.actions = const [],
    this.showInstallLink = false,
  });

  /// Create a warning for when Tesseract is not installed
  factory OcrWarningWidget.tesseractNotInstalled() {
    return OcrWarningWidget(
      title: 'Tesseract OCR Not Found',
      message: 'Tesseract OCR is not installed or not found in PATH. OCR functionality will not work without it.',
      icon: Icons.error_outline,
      color: Colors.orange,
      showInstallLink: true,
      actions: [
        OcrWarningAction(
          label: 'Install Tesseract',
          icon: Icons.download,
          onPressed: () => _launchTesseractInstall(),
        ),
      ],
    );
  }

  /// Create a warning for when OCR fails
  factory OcrWarningWidget.ocrFailed(String error) {
    return OcrWarningWidget(
      title: 'OCR Processing Failed',
      message: 'Text recognition failed: $error',
      icon: Icons.error,
      color: Colors.red,
      actions: [
        OcrWarningAction(
          label: 'Retry',
          icon: Icons.refresh,
          onPressed: () {}, // Will be overridden by parent
        ),
      ],
    );
  }

  /// Create an info message for when OCR is unavailable on platform
  factory OcrWarningWidget.platformNotSupported() {
    return const OcrWarningWidget(
      title: 'OCR Not Supported',
      message: 'Text recognition is not available on this platform. Please use a mobile device or desktop with Tesseract installed.',
      icon: Icons.info_outline,
      color: Colors.blue,
    );
  }

  static Future<void> _launchTesseractInstall() async {
    const url = 'https://github.com/UB-Mannheim/tesseract/wiki';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final warningColor = color ?? theme.colorScheme.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: warningColor.withValues(alpha: 0.1),
        border: Border.all(color: warningColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: warningColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
          if (showInstallLink) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: TextButton.icon(
                onPressed: _launchTesseractInstall,
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Installation Guide'),
                style: TextButton.styleFrom(
                  foregroundColor: warningColor,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          ],
          if (actions.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: actions.map((action) => ElevatedButton.icon(
                onPressed: action.onPressed,
                icon: Icon(action.icon, size: 16),
                label: Text(action.label),
                style: ElevatedButton.styleFrom(
                  backgroundColor: warningColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

/// Action button for OCR warning widgets
class OcrWarningAction {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const OcrWarningAction({
    required this.label,
    required this.icon,
    this.onPressed,
  });
}

/// Extension to add warning color to ColorScheme
extension ColorSchemeExtension on ColorScheme {
  Color get warning => const Color(0xFFFF9800); // Orange warning color
}