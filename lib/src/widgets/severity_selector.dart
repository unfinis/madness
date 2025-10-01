import 'package:flutter/material.dart';
import '../models/finding.dart';

/// Dropdown selector for finding severity
class SeveritySelectorWidget extends StatelessWidget {
  final FindingSeverity severity;
  final ValueChanged<FindingSeverity> onChanged;

  const SeveritySelectorWidget({
    super.key,
    required this.severity,
    required this.onChanged,
  });

  Color _getSeverityColor(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.critical:
        return Colors.purple;
      case FindingSeverity.high:
        return Colors.red;
      case FindingSeverity.medium:
        return Colors.orange;
      case FindingSeverity.low:
        return Colors.yellow.shade700;
      case FindingSeverity.informational:
        return Colors.blue;
    }
  }

  IconData _getSeverityIcon(FindingSeverity severity) {
    switch (severity) {
      case FindingSeverity.critical:
        return Icons.warning;
      case FindingSeverity.high:
        return Icons.error;
      case FindingSeverity.medium:
        return Icons.report_problem;
      case FindingSeverity.low:
        return Icons.info;
      case FindingSeverity.informational:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<FindingSeverity>(
      value: severity,
      decoration: const InputDecoration(
        labelText: 'Severity',
        border: OutlineInputBorder(),
      ),
      items: FindingSeverity.values.map((sev) {
        return DropdownMenuItem(
          value: sev,
          child: Row(
            children: [
              Icon(
                _getSeverityIcon(sev),
                color: _getSeverityColor(sev),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(sev.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
