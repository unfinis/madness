import '../models/asset.dart';
import '../models/trigger_evaluation.dart';

/// Advanced DSL parser for trigger condition expressions
/// Supports complex expressions like: "nac_enabled = true AND (credentials_available.length > 0 OR web_services.length > 0)"
class TriggerDslParser {

  /// Parse and evaluate a DSL expression against asset properties
  static TriggerConditionResult evaluateExpression(
    String expression,
    Map<String, PropertyValue> assetProperties,
  ) {
    final startTime = DateTime.now();
    final variables = <String, dynamic>{};
    final debugTrace = <String>[];

    try {
      debugTrace.add('Starting evaluation of: $expression');

      // Tokenize the expression
      final tokens = _tokenize(expression);
      debugTrace.add('Tokens: ${tokens.join(', ')}');

      // Parse tokens into an expression tree
      final parseResult = _parseTokens(tokens, assetProperties, variables, debugTrace);

      final executionTime = DateTime.now().difference(startTime).inMilliseconds;
      debugTrace.add('Evaluation completed in ${executionTime}ms');

      return TriggerConditionResult(
        expression: expression,
        result: parseResult,
        variables: variables,
        executionTimeMs: executionTime,
        debugTrace: debugTrace,
      );

    } catch (e) {
      final executionTime = DateTime.now().difference(startTime).inMilliseconds;
      debugTrace.add('Error during evaluation: $e');

      return TriggerConditionResult(
        expression: expression,
        result: false,
        variables: variables,
        executionTimeMs: executionTime,
        error: e.toString(),
        debugTrace: debugTrace,
      );
    }
  }

  /// Tokenize an expression into components
  static List<String> _tokenize(String expression) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];

      if (char == '"' || char == "'") {
        inQuotes = !inQuotes;
        buffer.write(char);
      } else if (inQuotes) {
        buffer.write(char);
      } else if (char == ' ' || char == '\t') {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
      } else if (_isOperatorChar(char)) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }

        // Handle multi-character operators
        if (i + 1 < expression.length) {
          final twoChar = expression.substring(i, i + 2);
          if (_isTwoCharOperator(twoChar)) {
            tokens.add(twoChar);
            i++; // Skip next character
            continue;
          }
        }

        tokens.add(char);
      } else {
        buffer.write(char);
      }
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }

    return tokens;
  }

  /// Check if character is part of an operator
  static bool _isOperatorChar(String char) {
    return ['=', '!', '<', '>', '(', ')', '&', '|'].contains(char);
  }

  /// Check if string is a two-character operator
  static bool _isTwoCharOperator(String str) {
    return ['==', '!=', '<=', '>=', '&&', '||'].contains(str);
  }

  /// Parse tokens into a boolean result
  static bool _parseTokens(
    List<String> tokens,
    Map<String, PropertyValue> assetProperties,
    Map<String, dynamic> variables,
    List<String> debugTrace,
  ) {
    if (tokens.isEmpty) return false;

    // Handle parentheses first
    tokens = _resolveParentheses(tokens, assetProperties, variables, debugTrace);

    // Process AND/OR operations
    return _processLogicalOperators(tokens, assetProperties, variables, debugTrace);
  }

  /// Resolve expressions in parentheses
  static List<String> _resolveParentheses(
    List<String> tokens,
    Map<String, PropertyValue> assetProperties,
    Map<String, dynamic> variables,
    List<String> debugTrace,
  ) {
    final result = <String>[];
    int i = 0;

    while (i < tokens.length) {
      if (tokens[i] == '(') {
        // Find matching closing parenthesis
        int depth = 1;
        int start = i + 1;
        int end = start;

        for (int j = start; j < tokens.length; j++) {
          if (tokens[j] == '(') depth++;
          if (tokens[j] == ')') depth--;
          if (depth == 0) {
            end = j;
            break;
          }
        }

        if (depth != 0) {
          throw Exception('Unmatched parentheses in expression');
        }

        // Recursively evaluate the expression inside parentheses
        final innerTokens = tokens.sublist(start, end);
        final innerResult = _processLogicalOperators(innerTokens, assetProperties, variables, debugTrace);

        result.add(innerResult.toString());
        debugTrace.add('Resolved parentheses: (${innerTokens.join(' ')}) = $innerResult');

        i = end + 1;
      } else {
        result.add(tokens[i]);
        i++;
      }
    }

    return result;
  }

  /// Process AND/OR logical operators
  static bool _processLogicalOperators(
    List<String> tokens,
    Map<String, PropertyValue> assetProperties,
    Map<String, dynamic> variables,
    List<String> debugTrace,
  ) {
    // Convert OR operations first (lower precedence)
    for (int i = 1; i < tokens.length - 1; i += 2) {
      if (tokens[i] == 'OR' || tokens[i] == '||') {
        final left = _processAndOperations(tokens.sublist(0, i), assetProperties, variables, debugTrace);
        final right = _processLogicalOperators(tokens.sublist(i + 1), assetProperties, variables, debugTrace);
        final result = left || right;

        debugTrace.add('OR operation: $left || $right = $result');
        return result;
      }
    }

    // If no OR operations, process AND operations
    return _processAndOperations(tokens, assetProperties, variables, debugTrace);
  }

  /// Process AND logical operators
  static bool _processAndOperations(
    List<String> tokens,
    Map<String, PropertyValue> assetProperties,
    Map<String, dynamic> variables,
    List<String> debugTrace,
  ) {
    final conditions = <bool>[];

    for (int i = 0; i < tokens.length; i += 2) {
      if (i + 2 < tokens.length) {
        // Single condition: property operator value
        final property = tokens[i];
        final operator = tokens[i + 1];
        final value = tokens[i + 2];

        final conditionResult = _evaluateCondition(property, operator, value, assetProperties, variables, debugTrace);
        conditions.add(conditionResult);

        // Skip the AND operator if present
        if (i + 3 < tokens.length && (tokens[i + 3] == 'AND' || tokens[i + 3] == '&&')) {
          i += 2; // Skip to next condition (the loop will add 2 more)
        }
      } else if (tokens[i] == 'true') {
        conditions.add(true);
      } else if (tokens[i] == 'false') {
        conditions.add(false);
      } else {
        // Single property existence check
        final exists = assetProperties.containsKey(tokens[i]);
        variables[tokens[i]] = exists;
        conditions.add(exists);
        debugTrace.add('Property existence check: ${tokens[i]} = $exists');
      }
    }

    final result = conditions.every((c) => c);
    debugTrace.add('AND operation result: ${conditions.join(' && ')} = $result');
    return result;
  }

  /// Evaluate a single condition
  static bool _evaluateCondition(
    String property,
    String operator,
    String value,
    Map<String, PropertyValue> assetProperties,
    Map<String, dynamic> variables,
    List<String> debugTrace,
  ) {
    // Handle property with dot notation (e.g., credentials_available.length)
    final propertyParts = property.split('.');
    final baseProp = propertyParts[0];
    final assetProperty = assetProperties[baseProp];

    if (assetProperty == null) {
      variables[property] = null;
      final result = operator == '!=' || operator == 'not_exists';
      debugTrace.add('Property $property not found, result: $result');
      return result;
    }

    dynamic actualValue = assetProperty.when(
      string: (v) => v,
      integer: (v) => v,
      boolean: (v) => v,
      stringList: (v) => v,
      map: (v) => v,
      objectList: (v) => v,
    );

    // Handle property access (e.g., .length, .contains())
    if (propertyParts.length > 1) {
      for (int i = 1; i < propertyParts.length; i++) {
        final accessor = propertyParts[i];

        if (accessor == 'length') {
          if (actualValue is List) {
            actualValue = actualValue.length;
          } else if (actualValue is Map) {
            actualValue = actualValue.length;
          } else if (actualValue is String) {
            actualValue = actualValue.length;
          } else {
            actualValue = 0;
          }
        } else if (accessor.startsWith('contains(') && accessor.endsWith(')')) {
          final searchValue = accessor.substring(9, accessor.length - 1).replaceAll('"', '').replaceAll("'", '');
          if (actualValue is List) {
            actualValue = actualValue.contains(searchValue);
          } else if (actualValue is String) {
            actualValue = actualValue.contains(searchValue);
          } else {
            actualValue = false;
          }
        }
      }
    }

    variables[property] = actualValue;

    // Parse the expected value
    dynamic expectedValue = _parseValue(value);

    // Perform the comparison
    bool result = false;
    switch (operator) {
      case '=' :
      case '==':
        result = actualValue == expectedValue;
        break;
      case '!=':
        result = actualValue != expectedValue;
        break;
      case '>':
        result = (actualValue is num && expectedValue is num) ? actualValue > expectedValue : false;
        break;
      case '<':
        result = (actualValue is num && expectedValue is num) ? actualValue < expectedValue : false;
        break;
      case '>=':
        result = (actualValue is num && expectedValue is num) ? actualValue >= expectedValue : false;
        break;
      case '<=':
        result = (actualValue is num && expectedValue is num) ? actualValue <= expectedValue : false;
        break;
      case 'contains':
        if (actualValue is String && expectedValue is String) {
          result = actualValue.contains(expectedValue);
        } else if (actualValue is List) {
          result = actualValue.contains(expectedValue);
        }
        break;
      case 'exists':
        result = actualValue != null;
        break;
      case 'not_exists':
        result = actualValue == null;
        break;
      default:
        debugTrace.add('Unknown operator: $operator');
        result = false;
    }

    debugTrace.add('Condition: $property ($actualValue) $operator $expectedValue = $result');
    return result;
  }

  /// Parse a string value to appropriate type
  static dynamic _parseValue(String value) {
    // Remove quotes
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      return value.substring(1, value.length - 1);
    }

    // Try to parse as number
    if (RegExp(r'^\d+$').hasMatch(value)) {
      return int.tryParse(value) ?? value;
    }

    if (RegExp(r'^\d+\.\d+$').hasMatch(value)) {
      return double.tryParse(value) ?? value;
    }

    // Parse boolean
    if (value.toLowerCase() == 'true') return true;
    if (value.toLowerCase() == 'false') return false;

    // Return as string
    return value;
  }
}

/// Helper class for building common trigger expressions
class TriggerExpressionBuilder {
  static String assetHasProperty(String property) {
    return '$property exists';
  }

  static String assetPropertyEquals(String property, dynamic value) {
    return '$property = $value';
  }

  static String assetPropertyContains(String property, String value) {
    return '$property contains "$value"';
  }

  static String assetListNotEmpty(String listProperty) {
    return '$listProperty.length > 0';
  }

  static String andCondition(String left, String right) {
    return '($left) AND ($right)';
  }

  static String orCondition(String left, String right) {
    return '($left) OR ($right)';
  }

  static String nacEnabledWithCredentials() {
    return andCondition(
      assetPropertyEquals('nac_enabled', true),
      assetListNotEmpty('credentials_available'),
    );
  }

  static String webServicesAvailable() {
    return assetListNotEmpty('web_services');
  }

  static String hostWithOpenPorts() {
    return assetListNotEmpty('open_ports');
  }

  static String credentialsForDomain(String domain) {
    return 'credentials_available.contains("$domain")';
  }
}