import '../models/methodology.dart';

class CommandGenerator {
  String generateCommand(
    MethodologyStep step,
    Map<String, dynamic> context,
  ) {
    String command = step.command;

    command = _replaceVariables(command, context);

    for (final variant in step.commandVariants) {
      if (_evaluateCondition(variant.condition, context)) {
        command = _replaceVariables(variant.command, context);
        break;
      }
    }

    return command;
  }

  String _replaceVariables(String template, Map<String, dynamic> context) {
    String result = template;

    final variablePattern = RegExp(r'\{\{(\w+(?:\.\w+)*)\}\}');

    for (final match in variablePattern.allMatches(template)) {
      final fullMatch = match.group(0) ?? '';
      final variable = match.group(1) ?? '';

      final value = _getVariableValue(variable, context);
      result = result.replaceAll(fullMatch, value.toString());
    }

    final envPattern = RegExp(r'\$\{(\w+)\}');
    for (final match in envPattern.allMatches(result)) {
      final fullMatch = match.group(0) ?? '';
      final envVar = match.group(1) ?? '';

      if (context.containsKey('env') && context['env'] is Map) {
        final envValue = context['env'][envVar] ?? '';
        result = result.replaceAll(fullMatch, envValue.toString());
      }
    }

    return result;
  }

  dynamic _getVariableValue(String path, Map<String, dynamic> context) {
    final parts = path.split('.');
    dynamic current = context;

    for (final part in parts) {
      if (current is Map) {
        current = current[part];
      } else if (current == null) {
        return '<undefined>';
      }
    }

    if (current is List) {
      return current.join(',');
    }

    return current ?? '<undefined>';
  }

  bool _evaluateCondition(String condition, Map<String, dynamic> context) {
    if (condition.isEmpty) return false;

    if (condition.contains('==')) {
      final parts = condition.split('==');
      if (parts.length == 2) {
        final left = _evaluateExpression(parts[0].trim(), context);
        final right = _evaluateExpression(parts[1].trim(), context);
        return left.toString() == right.toString();
      }
    }

    if (condition.contains('!=')) {
      final parts = condition.split('!=');
      if (parts.length == 2) {
        final left = _evaluateExpression(parts[0].trim(), context);
        final right = _evaluateExpression(parts[1].trim(), context);
        return left.toString() != right.toString();
      }
    }

    if (condition.contains('exists')) {
      final variable = condition.replaceAll('exists', '').trim();
      final value = _getVariableValue(variable, context);
      return value != null && value != '<undefined>';
    }

    if (condition.contains('!exists')) {
      final variable = condition.replaceAll('!exists', '').trim();
      final value = _getVariableValue(variable, context);
      return value == null || value == '<undefined>';
    }

    if (condition.contains('contains')) {
      final parts = condition.split('contains');
      if (parts.length == 2) {
        final left = _evaluateExpression(parts[0].trim(), context);
        final right = _evaluateExpression(parts[1].trim(), context);
        return left.toString().contains(right.toString());
      }
    }

    return false;
  }

  dynamic _evaluateExpression(String expression, Map<String, dynamic> context) {
    expression = expression.trim();

    if (expression.startsWith('"') && expression.endsWith('"')) {
      return expression.substring(1, expression.length - 1);
    }

    if (expression.startsWith("'") && expression.endsWith("'")) {
      return expression.substring(1, expression.length - 1);
    }

    final numValue = num.tryParse(expression);
    if (numValue != null) {
      return numValue;
    }

    if (expression == 'true') return true;
    if (expression == 'false') return false;
    if (expression == 'null') return null;

    return _getVariableValue(expression, context);
  }

  List<String> generateCommandVariations(
    MethodologyStep step,
    List<Map<String, dynamic>> contexts,
  ) {
    final commands = <String>[];

    for (final context in contexts) {
      final command = generateCommand(step, context);
      if (!commands.contains(command)) {
        commands.add(command);
      }
    }

    return commands;
  }

  Map<String, dynamic> buildExecutionContext(
    Map<String, dynamic> triggerContext,
    Map<String, dynamic>? additionalParams,
  ) {
    final context = Map<String, dynamic>.from(triggerContext);

    if (additionalParams != null) {
      context.addAll(additionalParams);
    }

    // Extract asset information and create common placeholders
    if (context['asset'] is Map) {
      final asset = context['asset'] as Map;

      // Host/IP placeholders
      if (asset['host'] != null || asset['identifier'] != null || asset['name'] != null) {
        final hostValue = asset['host'] ?? asset['identifier'] ?? asset['name'];
        context['HOST'] = hostValue;
        context['TARGET'] = hostValue;
        context['target'] = hostValue; // lowercase variant
        context['host'] = hostValue; // lowercase variant
      }

      // Port placeholders
      if (asset['port'] != null) {
        context['PORT'] = asset['port'];
        context['port'] = asset['port'];
      }

      // Service placeholders
      if (asset['service'] != null || asset['service_name'] != null) {
        final serviceValue = asset['service'] ?? asset['service_name'];
        context['SERVICE'] = serviceValue;
        context['service'] = serviceValue;
      }

      // Protocol placeholder
      if (asset['protocol'] != null) {
        context['PROTOCOL'] = asset['protocol'];
        context['protocol'] = asset['protocol'];
      }

      // Network segment placeholders
      if (asset['subnet'] != null) {
        context['SUBNET'] = asset['subnet'];
        context['subnet'] = asset['subnet'];
      }

      // Credential placeholders
      if (asset['username'] != null) {
        context['USERNAME'] = asset['username'];
        context['username'] = asset['username'];
      }

      if (asset['password'] != null) {
        context['PASSWORD'] = asset['password'];
        context['password'] = asset['password'];
      }

      if (asset['domain'] != null) {
        context['DOMAIN'] = asset['domain'];
        context['domain'] = asset['domain'];
      }

      // Share-specific placeholders
      if (asset['share_name'] != null) {
        context['SHARE'] = asset['share_name'];
        context['share'] = asset['share_name'];
      }
    }

    // Handle credentials list
    if (context['credentials'] is List) {
      final creds = context['credentials'] as List;
      if (creds.isNotEmpty) {
        final firstCred = creds[0] as Map;
        context['CREDENTIAL_USER'] = firstCred['username'] ?? '';
        context['CREDENTIAL_PASS'] = firstCred['password'] ?? '';
        context['CREDENTIAL_DOMAIN'] = firstCred['domain'] ?? '';
        context['credential_user'] = firstCred['username'] ?? '';
        context['credential_pass'] = firstCred['password'] ?? '';
        context['credential_domain'] = firstCred['domain'] ?? '';
      }
    }

    // Add common environment variables
    context['TIMESTAMP'] = DateTime.now().toIso8601String();
    context['DATE'] = DateTime.now().toIso8601String().split('T')[0];
    context['INTERFACE'] = 'eth0'; // Default interface
    context['interface'] = 'eth0';

    // Add wordlists and common paths (can be configured per environment)
    context['WORDLIST_COMMON'] = '/usr/share/wordlists/common.txt';
    context['WORDLIST_USERS'] = '/usr/share/wordlists/users.txt';
    context['wordlist_common'] = '/usr/share/wordlists/common.txt';
    context['wordlist_users'] = '/usr/share/wordlists/users.txt';

    return context;
  }

  String sanitizeCommand(String command) {
    command = command.replaceAll(RegExp(r'[;&|]'), '');

    command = command.replaceAll(RegExp(r'\.\.'), '');

    command = command.replaceAll(RegExp(r'[`$()]'), '');

    return command.trim();
  }

  String formatCommandForDisplay(String command, {int maxLength = 80}) {
    if (command.length <= maxLength) {
      return command;
    }

    final lines = <String>[];
    final parts = command.split(' ');
    String currentLine = '';

    for (final part in parts) {
      if (currentLine.isEmpty) {
        currentLine = part;
      } else if ((currentLine.length + part.length + 1) <= maxLength) {
        currentLine += ' $part';
      } else {
        lines.add(currentLine);
        currentLine = '    $part';
      }
    }

    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return lines.join(' \\\n');
  }

  List<String> parseCommandOutput(
    String output,
    List<ExpectedOutput> expectedOutputs,
  ) {
    final messages = <String>[];

    for (final expected in expectedOutputs) {
      bool success = false;
      bool failure = false;

      for (final indicator in expected.successIndicators) {
        if (output.contains(indicator)) {
          success = true;
          messages.add('[SUCCESS] ${expected.type}: Success indicator found - $indicator');
        }
      }

      for (final indicator in expected.failureIndicators) {
        if (output.contains(indicator)) {
          failure = true;
          messages.add('[FAILURE] ${expected.type}: Failure indicator found - $indicator');
        }
      }

      if (!success && !failure) {
        messages.add('? ${expected.type}: No clear indicators found');
      }
    }

    return messages;
  }
}