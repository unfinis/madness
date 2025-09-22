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

    if (context['asset'] is Map) {
      final asset = context['asset'] as Map;

      if (asset['host'] != null) {
        context['HOST'] = asset['host'];
        context['TARGET'] = asset['host'];
      }

      if (asset['port'] != null) {
        context['PORT'] = asset['port'];
      }

      if (asset['service'] != null) {
        context['SERVICE'] = asset['service'];
      }

      if (asset['username'] != null) {
        context['USERNAME'] = asset['username'];
      }

      if (asset['password'] != null) {
        context['PASSWORD'] = asset['password'];
      }

      if (asset['domain'] != null) {
        context['DOMAIN'] = asset['domain'];
      }
    }

    if (context['credentials'] is List) {
      final creds = context['credentials'] as List;
      if (creds.isNotEmpty) {
        final firstCred = creds[0] as Map;
        context['CREDENTIAL_USER'] = firstCred['username'] ?? '';
        context['CREDENTIAL_PASS'] = firstCred['password'] ?? '';
        context['CREDENTIAL_DOMAIN'] = firstCred['domain'] ?? '';
      }
    }

    context['TIMESTAMP'] = DateTime.now().toIso8601String();
    context['DATE'] = DateTime.now().toIso8601String().split('T')[0];

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
          messages.add('✓ ${expected.type}: Success indicator found - $indicator');
        }
      }

      for (final indicator in expected.failureIndicators) {
        if (output.contains(indicator)) {
          failure = true;
          messages.add('✗ ${expected.type}: Failure indicator found - $indicator');
        }
      }

      if (!success && !failure) {
        messages.add('? ${expected.type}: No clear indicators found');
      }
    }

    return messages;
  }
}