/// Comprehensive validation rules library for consistent form validation
class ValidationRules {
  ValidationRules._();

  // ================== BASIC VALIDATION ==================

  /// Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Minimum length validation
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null) return null;
    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Maximum length validation
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null) return null;
    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }
    return null;
  }

  /// Length range validation
  static String? lengthRange(String? value, int minLength, int maxLength, [String? fieldName]) {
    if (value == null) return null;
    if (value.length < minLength || value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be between $minLength and $maxLength characters';
    }
    return null;
  }

  // ================== EMAIL VALIDATION ==================

  /// Email format validation
  static String? email(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return '${fieldName ?? 'Email'} is not valid';
    }
    return null;
  }

  /// Required email validation
  static String? requiredEmail(String? value, [String? fieldName]) {
    final requiredResult = required(value, fieldName);
    if (requiredResult != null) return requiredResult;
    return email(value, fieldName);
  }

  // ================== PASSWORD VALIDATION ==================

  /// Basic password validation (minimum 8 characters)
  static String? password(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    if (value.length < 8) {
      return '${fieldName ?? 'Password'} must be at least 8 characters';
    }
    return null;
  }

  /// Strong password validation
  static String? strongPassword(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final fieldDisplayName = fieldName ?? 'Password';

    if (value.length < 8) {
      return '$fieldDisplayName must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return '$fieldDisplayName must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return '$fieldDisplayName must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return '$fieldDisplayName must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return '$fieldDisplayName must contain at least one special character';
    }

    return null;
  }

  /// Password confirmation validation
  static String? confirmPassword(String? value, String? originalPassword, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    if (value != originalPassword) {
      return '${fieldName ?? 'Passwords'} do not match';
    }
    return null;
  }

  // ================== NUMERIC VALIDATION ==================

  /// Number validation
  static String? number(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }
    return null;
  }

  /// Integer validation
  static String? integer(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a valid integer';
    }
    return null;
  }

  /// Minimum value validation
  static String? minValue(String? value, double minValue, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final numValue = double.tryParse(value);
    if (numValue == null) return null;

    if (numValue < minValue) {
      return '${fieldName ?? 'This field'} must be at least $minValue';
    }
    return null;
  }

  /// Maximum value validation
  static String? maxValue(String? value, double maxValue, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final numValue = double.tryParse(value);
    if (numValue == null) return null;

    if (numValue > maxValue) {
      return '${fieldName ?? 'This field'} must not exceed $maxValue';
    }
    return null;
  }

  /// Value range validation
  static String? valueRange(String? value, double minValue, double maxValue, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final numValue = double.tryParse(value);
    if (numValue == null) return null;

    if (numValue < minValue || numValue > maxValue) {
      return '${fieldName ?? 'This field'} must be between $minValue and $maxValue';
    }
    return null;
  }

  // ================== NETWORK VALIDATION ==================

  /// URL validation
  static String? url(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final urlRegex = RegExp(
      r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return '${fieldName ?? 'URL'} is not valid';
    }
    return null;
  }

  /// IP address validation (IPv4)
  static String? ipAddress(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final ipRegex = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );

    if (!ipRegex.hasMatch(value)) {
      return '${fieldName ?? 'IP address'} is not valid';
    }
    return null;
  }

  /// IPv6 address validation
  static String? ipv6Address(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final ipv6Regex = RegExp(
      r'^(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$|^::1$|^::$',
    );

    if (!ipv6Regex.hasMatch(value)) {
      return '${fieldName ?? 'IPv6 address'} is not valid';
    }
    return null;
  }

  /// Domain name validation
  static String? domainName(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final domainRegex = RegExp(
      r'^(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)*[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$',
    );

    if (!domainRegex.hasMatch(value)) {
      return '${fieldName ?? 'Domain name'} is not valid';
    }
    return null;
  }

  /// Port number validation
  static String? port(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final portNumber = int.tryParse(value);
    if (portNumber == null || portNumber < 1 || portNumber > 65535) {
      return '${fieldName ?? 'Port'} must be between 1 and 65535';
    }
    return null;
  }

  // ================== SECURITY VALIDATION ==================

  /// Username validation (alphanumeric, underscore, hyphen)
  static String? username(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]{3,20}$');

    if (!usernameRegex.hasMatch(value)) {
      return '${fieldName ?? 'Username'} must be 3-20 characters and contain only letters, numbers, underscore, or hyphen';
    }
    return null;
  }

  /// Hash validation (common hash formats)
  static String? hash(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    // Common hash patterns (MD5, SHA1, SHA256, etc.)
    final hashRegex = RegExp(r'^[a-fA-F0-9]{32,128}$');

    if (!hashRegex.hasMatch(value)) {
      return '${fieldName ?? 'Hash'} is not a valid hash format';
    }
    return null;
  }

  /// Path validation (file/directory paths)
  static String? path(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) return null;

    // Basic path validation (Windows and Unix)
    final pathRegex = RegExp(r'^[a-zA-Z0-9\s\-_\./\\:]+$');

    if (!pathRegex.hasMatch(value) || value.contains('..')) {
      return '${fieldName ?? 'Path'} contains invalid characters';
    }
    return null;
  }

  // ================== DATE VALIDATION ==================

  /// Date range validation
  static String? dateRange(DateTime? value, DateTime? minDate, DateTime? maxDate, [String? fieldName]) {
    if (value == null) return null;

    if (minDate != null && value.isBefore(minDate)) {
      return '${fieldName ?? 'Date'} must be after ${_formatDate(minDate)}';
    }

    if (maxDate != null && value.isAfter(maxDate)) {
      return '${fieldName ?? 'Date'} must be before ${_formatDate(maxDate)}';
    }

    return null;
  }

  /// Future date validation
  static String? futureDate(DateTime? value, [String? fieldName]) {
    if (value == null) return null;

    if (value.isBefore(DateTime.now())) {
      return '${fieldName ?? 'Date'} must be in the future';
    }
    return null;
  }

  /// Past date validation
  static String? pastDate(DateTime? value, [String? fieldName]) {
    if (value == null) return null;

    if (value.isAfter(DateTime.now())) {
      return '${fieldName ?? 'Date'} must be in the past';
    }
    return null;
  }

  // ================== CUSTOM VALIDATION ==================

  /// Match pattern validation
  static String? pattern(String? value, RegExp pattern, String errorMessage) {
    if (value == null || value.isEmpty) return null;

    if (!pattern.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  /// Custom validation function
  static String? custom(String? value, bool Function(String?) validator, String errorMessage) {
    if (value == null) return null;

    if (!validator(value)) {
      return errorMessage;
    }
    return null;
  }

  // ================== COMPOSITE VALIDATORS ==================

  /// Combine multiple validators
  static String? Function(String?) combine(List<String? Function(String?)> validators) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Required field with additional validation
  static String? Function(String?) requiredAnd(String? Function(String?) validator, [String? fieldName]) {
    return combine([
      (value) => required(value, fieldName),
      validator,
    ]);
  }

  // ================== HELPER METHODS ==================

  static String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Validation utilities for common use cases
class ValidationUtils {
  ValidationUtils._();

  /// Create a validator for credential usernames
  static String? Function(String?) credentialUsername() {
    return ValidationRules.combine([
      (value) => ValidationRules.required(value, 'Username'),
      (value) => ValidationRules.minLength(value, 2, 'Username'),
      (value) => ValidationRules.maxLength(value, 100, 'Username'),
    ]);
  }

  /// Create a validator for targets (IP addresses, domains, or hostnames)
  static String? Function(String?) target() {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Target is required';
      }

      final trimmedValue = value.trim();

      // Try IP address validation first
      final ipResult = ValidationRules.ipAddress(trimmedValue);
      if (ipResult == null) return null;

      // Try domain name validation
      final domainResult = ValidationRules.domainName(trimmedValue);
      if (domainResult == null) return null;

      // If neither worked, it's invalid
      return 'Target must be a valid IP address or domain name';
    };
  }

  /// Create a validator for project names
  static String? Function(String?) projectName() {
    return ValidationRules.combine([
      (value) => ValidationRules.required(value, 'Project name'),
      (value) => ValidationRules.minLength(value, 3, 'Project name'),
      (value) => ValidationRules.maxLength(value, 100, 'Project name'),
      (value) => ValidationRules.pattern(
        value,
        RegExp(r'^[a-zA-Z0-9\s\-_\.]+$'),
        'Project name can only contain letters, numbers, spaces, hyphens, underscores, and periods',
      ),
    ]);
  }

  /// Create a validator for port ranges (e.g., "80,443,8080-8090")
  static String? Function(String?) portRange() {
    return (String? value) {
      if (value == null || value.trim().isEmpty) return null;

      final parts = value.split(',');
      for (final part in parts) {
        final trimmedPart = part.trim();

        if (trimmedPart.contains('-')) {
          // Range format (e.g., "8080-8090")
          final rangeParts = trimmedPart.split('-');
          if (rangeParts.length != 2) {
            return 'Invalid port range format';
          }

          final startResult = ValidationRules.port(rangeParts[0].trim());
          if (startResult != null) return startResult;

          final endResult = ValidationRules.port(rangeParts[1].trim());
          if (endResult != null) return endResult;

          final start = int.parse(rangeParts[0].trim());
          final end = int.parse(rangeParts[1].trim());
          if (start >= end) {
            return 'Port range start must be less than end';
          }
        } else {
          // Single port
          final portResult = ValidationRules.port(trimmedPart);
          if (portResult != null) return portResult;
        }
      }

      return null;
    };
  }
}