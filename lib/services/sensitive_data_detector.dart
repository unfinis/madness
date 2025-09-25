import 'package:flutter/material.dart';

/// Represents a detected sensitive data match
class SensitiveDataMatch {
  final String text;
  final String category;
  final String description;
  final Rect bounds;
  final double confidence;

  const SensitiveDataMatch({
    required this.text,
    required this.category,
    required this.description,
    required this.bounds,
    required this.confidence,
  });

  @override
  String toString() => 'SensitiveDataMatch($category: $description)';
}

/// Configuration for sensitive data detection
class SensitiveDataDetectionConfig {
  final bool detectPasswords;
  final bool detectHashes;
  final bool detectTokens;
  final bool detectNetworkInfo;
  final bool detectFilesPaths;
  final bool detectCredentials;
  final bool detectCertificates;
  final double confidenceThreshold;
  final int paddingPixels;

  const SensitiveDataDetectionConfig({
    this.detectPasswords = true,
    this.detectHashes = true,
    this.detectTokens = true,
    this.detectNetworkInfo = true,
    this.detectFilesPaths = true,
    this.detectCredentials = true,
    this.detectCertificates = true,
    this.confidenceThreshold = 0.7,
    this.paddingPixels = 4,
  });
}

/// Service for detecting sensitive information in text
class SensitiveDataDetector {

  // NTLM and NTLMv2 hash patterns
  static final _ntlmHashPattern = RegExp(
    r'[a-fA-F0-9]{32}:[a-fA-F0-9]{32}|[a-fA-F0-9]{32}',
    caseSensitive: false,
  );

  // LM hash patterns
  static final _lmHashPattern = RegExp(
    r'[a-fA-F0-9]{32}',
    caseSensitive: false,
  );

  // SHA-1, SHA-256, SHA-512 patterns
  static final _sha1Pattern = RegExp(r'\b[a-fA-F0-9]{40}\b');
  static final _sha256Pattern = RegExp(r'\b[a-fA-F0-9]{64}\b');
  static final _sha512Pattern = RegExp(r'\b[a-fA-F0-9]{128}\b');

  // MD5 hash pattern
  static final _md5Pattern = RegExp(r'\b[a-fA-F0-9]{32}\b');

  // Password patterns in command outputs
  static final _passwordPatterns = [
    RegExp(r'password[:\s=]+[^\s\n]+', caseSensitive: false),
    RegExp(r'pass[:\s=]+[^\s\n]+', caseSensitive: false),
    RegExp(r'pwd[:\s=]+[^\s\n]+', caseSensitive: false),
    RegExp(r'-p\s+[^\s\n]+', caseSensitive: false), // -p password
    RegExp(r'--password[=\s]+[^\s\n]+', caseSensitive: false),
  ];

  // API keys and tokens
  static final _tokenPatterns = [
    RegExp(r'[Tt]oken[:\s=]+[A-Za-z0-9+/]{20,}={0,2}'), // Base64-like tokens
    RegExp(r'[Aa][Pp][Ii][_\s]?[Kk]ey[:\s=]+[A-Za-z0-9]{20,}'),
    RegExp(r'[Bb]earer\s+[A-Za-z0-9+/]{20,}={0,2}'),
    RegExp(r'[Aa]uthorization[:\s]+[A-Za-z0-9+/]{20,}={0,2}'),
  ];

  // Network information
  static final _networkPatterns = [
    RegExp(r'\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b'), // IP addresses
    RegExp(r'[Nn]etwork[:\s]+[^\s\n]+'),
    RegExp(r'[Ss]ubnet[:\s]+[^\s\n]+'),
    RegExp(r'[Gg]ateway[:\s]+[^\s\n]+'),
    RegExp(r'[Dd][Nn][Ss][:\s]+[^\s\n]+'),
  ];

  // File paths that might contain sensitive info
  static final _sensitivePathPatterns = [
    RegExp(r'/etc/passwd\b'),
    RegExp(r'/etc/shadow\b'),
    RegExp(r'\.ssh/id_rsa\b'),
    RegExp(r'\.ssh/id_dsa\b'),
    RegExp(r'\.ssh/id_ecdsa\b'),
    RegExp(r'\.ssh/id_ed25519\b'),
    RegExp(r'\.aws/credentials\b'),
    RegExp(r'\.env\b'),
    RegExp(r'config\.ini\b'),
    RegExp(r'web\.config\b'),
    RegExp(r'\.htpasswd\b'),
    RegExp(r'database\.yml\b'),
  ];

  // Credential formats
  static final _credentialPatterns = [
    RegExp(r'[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}:[^\s\n]+'), // email:password
    RegExp(r'[A-Za-z0-9._\\-]+\\[A-Za-z0-9._-]+:[^\s\n]+'), // domain\user:password
    RegExp(r'[Uu]ser[:\s=]+[^\s\n]+'),
    RegExp(r'[Uu]sername[:\s=]+[^\s\n]+'),
  ];

  // Certificate patterns
  static final _certificatePatterns = [
    RegExp(r'-----BEGIN [A-Z\s]+ KEY-----'),
    RegExp(r'-----BEGIN CERTIFICATE-----'),
    RegExp(r'-----BEGIN RSA PRIVATE KEY-----'),
    RegExp(r'-----BEGIN DSA PRIVATE KEY-----'),
    RegExp(r'-----BEGIN EC PRIVATE KEY-----'),
    RegExp(r'-----BEGIN OPENSSH PRIVATE KEY-----'),
  ];

  /// Detect sensitive data in the provided text
  static List<SensitiveDataMatch> detectSensitiveData(
    String text,
    Map<String, Rect> textBounds, {
    SensitiveDataDetectionConfig config = const SensitiveDataDetectionConfig(),
  }) {
    final matches = <SensitiveDataMatch>[];

    if (config.detectHashes) {
      matches.addAll(_detectHashes(text, textBounds, config));
    }

    if (config.detectPasswords) {
      matches.addAll(_detectPasswords(text, textBounds, config));
    }

    if (config.detectTokens) {
      matches.addAll(_detectTokens(text, textBounds, config));
    }

    if (config.detectNetworkInfo) {
      matches.addAll(_detectNetworkInfo(text, textBounds, config));
    }

    if (config.detectFilesPaths) {
      matches.addAll(_detectSensitivePaths(text, textBounds, config));
    }

    if (config.detectCredentials) {
      matches.addAll(_detectCredentials(text, textBounds, config));
    }

    if (config.detectCertificates) {
      matches.addAll(_detectCertificates(text, textBounds, config));
    }

    // Filter by confidence threshold
    return matches.where((match) => match.confidence >= config.confidenceThreshold).toList();
  }

  static List<SensitiveDataMatch> _detectHashes(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    // NTLM/NTLMv2 hashes
    for (final match in _ntlmHashPattern.allMatches(text)) {
      final matchedText = match.group(0)!;
      final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
      if (bounds != null) {
        matches.add(SensitiveDataMatch(
          text: matchedText,
          category: 'Hash',
          description: 'NTLM/NTLMv2 Hash',
          bounds: bounds,
          confidence: 0.9,
        ));
      }
    }

    // SHA hashes
    for (final match in _sha256Pattern.allMatches(text)) {
      final matchedText = match.group(0)!;
      final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
      if (bounds != null) {
        matches.add(SensitiveDataMatch(
          text: matchedText,
          category: 'Hash',
          description: 'SHA-256 Hash',
          bounds: bounds,
          confidence: 0.85,
        ));
      }
    }

    // MD5 hashes (lower confidence as they're more common)
    for (final match in _md5Pattern.allMatches(text)) {
      final matchedText = match.group(0)!;
      final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
      if (bounds != null) {
        matches.add(SensitiveDataMatch(
          text: matchedText,
          category: 'Hash',
          description: 'MD5 Hash',
          bounds: bounds,
          confidence: 0.7,
        ));
      }
    }

    return matches;
  }

  static List<SensitiveDataMatch> _detectPasswords(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    for (final pattern in _passwordPatterns) {
      for (final match in pattern.allMatches(text)) {
        final matchedText = match.group(0)!;
        final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
        if (bounds != null) {
          matches.add(SensitiveDataMatch(
            text: matchedText,
            category: 'Password',
            description: 'Password in Command Output',
            bounds: bounds,
            confidence: 0.8,
          ));
        }
      }
    }

    return matches;
  }

  static List<SensitiveDataMatch> _detectTokens(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    for (final pattern in _tokenPatterns) {
      for (final match in pattern.allMatches(text)) {
        final matchedText = match.group(0)!;
        final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
        if (bounds != null) {
          matches.add(SensitiveDataMatch(
            text: matchedText,
            category: 'Token',
            description: 'API Token/Key',
            bounds: bounds,
            confidence: 0.85,
          ));
        }
      }
    }

    return matches;
  }

  static List<SensitiveDataMatch> _detectNetworkInfo(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    for (final pattern in _networkPatterns) {
      for (final match in pattern.allMatches(text)) {
        final matchedText = match.group(0)!;
        final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
        if (bounds != null) {
          matches.add(SensitiveDataMatch(
            text: matchedText,
            category: 'Network',
            description: 'Network Information',
            bounds: bounds,
            confidence: 0.75,
          ));
        }
      }
    }

    return matches;
  }

  static List<SensitiveDataMatch> _detectSensitivePaths(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    for (final pattern in _sensitivePathPatterns) {
      for (final match in pattern.allMatches(text)) {
        final matchedText = match.group(0)!;
        final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
        if (bounds != null) {
          matches.add(SensitiveDataMatch(
            text: matchedText,
            category: 'FilePath',
            description: 'Sensitive File Path',
            bounds: bounds,
            confidence: 0.9,
          ));
        }
      }
    }

    return matches;
  }

  static List<SensitiveDataMatch> _detectCredentials(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    for (final pattern in _credentialPatterns) {
      for (final match in pattern.allMatches(text)) {
        final matchedText = match.group(0)!;
        final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
        if (bounds != null) {
          matches.add(SensitiveDataMatch(
            text: matchedText,
            category: 'Credentials',
            description: 'User Credentials',
            bounds: bounds,
            confidence: 0.8,
          ));
        }
      }
    }

    return matches;
  }

  static List<SensitiveDataMatch> _detectCertificates(
    String text,
    Map<String, Rect> textBounds,
    SensitiveDataDetectionConfig config,
  ) {
    final matches = <SensitiveDataMatch>[];

    for (final pattern in _certificatePatterns) {
      for (final match in pattern.allMatches(text)) {
        final matchedText = match.group(0)!;
        final bounds = _getTextBounds(matchedText, textBounds, config.paddingPixels);
        if (bounds != null) {
          matches.add(SensitiveDataMatch(
            text: matchedText,
            category: 'Certificate',
            description: 'Private Key/Certificate',
            bounds: bounds,
            confidence: 0.95,
          ));
        }
      }
    }

    return matches;
  }

  /// Helper to get text bounds with padding
  static Rect? _getTextBounds(String text, Map<String, Rect> textBounds, int padding) {
    final bounds = textBounds[text];
    if (bounds == null) return null;

    return Rect.fromLTRB(
      bounds.left - padding,
      bounds.top - padding,
      bounds.right + padding,
      bounds.bottom + padding,
    );
  }

  /// Get all available detection categories
  static List<String> get availableCategories => [
        'Hash',
        'Password',
        'Token',
        'Network',
        'FilePath',
        'Credentials',
        'Certificate',
      ];

  /// Get description for a category
  static String getCategoryDescription(String category) {
    switch (category) {
      case 'Hash':
        return 'Password hashes (NTLM, SHA, MD5)';
      case 'Password':
        return 'Passwords in command outputs';
      case 'Token':
        return 'API tokens and keys';
      case 'Network':
        return 'IP addresses and network info';
      case 'FilePath':
        return 'Sensitive file paths';
      case 'Credentials':
        return 'User credentials and accounts';
      case 'Certificate':
        return 'Private keys and certificates';
      default:
        return 'Unknown category';
    }
  }
}