import 'package:flutter/material.dart';
import '../../models/finding_template.dart';

/// Dialog for selecting and inserting template variables
class VariablePickerDialog extends StatelessWidget {
  final List<TemplateVariable> variables;
  final Map<String, String> currentValues;

  const VariablePickerDialog({
    super.key,
    required this.variables,
    required this.currentValues,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Insert Variable'),
      content: SizedBox(
        width: 400,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: variables.length,
          itemBuilder: (context, index) {
            final variable = variables[index];
            return Card(
              child: ListTile(
                leading: Icon(
                  _getIconForType(variable.type),
                  color: theme.colorScheme.primary,
                ),
                title: Text(variable.label),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('{{${variable.name}}}'),
                    if (variable.placeholder != null)
                      Text(
                        variable.placeholder!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (currentValues[variable.name]?.isNotEmpty == true)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Current: ${currentValues[variable.name]}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                  ],
                ),
                trailing: variable.required
                    ? Chip(
                        label: const Text('Required'),
                        backgroundColor: theme.colorScheme.errorContainer,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onErrorContainer,
                          fontSize: 10,
                        ),
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(variable.name),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  IconData _getIconForType(VariableType type) {
    switch (type) {
      case VariableType.text:
        return Icons.text_fields;
      case VariableType.multiline:
        return Icons.notes;
      case VariableType.number:
        return Icons.numbers;
      case VariableType.date:
        return Icons.calendar_today;
      case VariableType.dropdown:
        return Icons.arrow_drop_down;
      case VariableType.ipAddress:
        return Icons.computer;
      case VariableType.url:
        return Icons.link;
    }
  }
}
