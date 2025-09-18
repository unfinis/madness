import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/credential.dart';

class CredentialTableWidget extends StatelessWidget {
  final List<Credential> credentials;
  final Set<String> selectedCredentials;
  final Function(String, bool) onSelectionChanged;
  final Function(String, CredentialStatus) onCredentialTest;
  final Function(String) onCredentialEdit;
  final Function(String) onCredentialDelete;

  const CredentialTableWidget({
    super.key,
    required this.credentials,
    required this.selectedCredentials,
    required this.onSelectionChanged,
    required this.onCredentialTest,
    required this.onCredentialEdit,
    required this.onCredentialDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 80,
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainer,
          ),
          columns: [
            DataColumn(
              label: Checkbox(
                value: selectedCredentials.length == credentials.length && credentials.isNotEmpty,
                tristate: selectedCredentials.isNotEmpty && selectedCredentials.length < credentials.length,
                onChanged: (value) => _toggleSelectAll(value ?? false),
              ),
            ),
            const DataColumn(label: Text('Username')),
            const DataColumn(label: Text('Type')),
            const DataColumn(label: Text('Source')),
            const DataColumn(label: Text('Privilege')),
            const DataColumn(label: Text('Target')),
            const DataColumn(label: Text('Status')),
            const DataColumn(label: Text('Added')),
            const DataColumn(label: Text('Actions')),
          ],
          rows: credentials.map((credential) => _buildCredentialRow(context, credential)).toList(),
        ),
      ),
    );
  }

  DataRow _buildCredentialRow(BuildContext context, Credential credential) {
    final isSelected = selectedCredentials.contains(credential.id);
    final rowColor = credential.privilege.isCritical 
        ? Colors.red.withOpacity(0.1) 
        : null;

    return DataRow(
      selected: isSelected,
      color: rowColor != null ? WidgetStateProperty.all(rowColor) : null,
      cells: [
        DataCell(
          Checkbox(
            value: isSelected,
            onChanged: (value) => onSelectionChanged(credential.id, value ?? false),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                credential.username,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              if (credential.domain != null)
                Text(
                  credential.domain!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getTypeColor(credential.type).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _getTypeColor(credential.type).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(credential.type.icon, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  credential.type.displayName,
                  style: TextStyle(
                    color: _getTypeColor(credential.type),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              credential.source.displayName,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: credential.privilege.isCritical 
                  ? Colors.red.withOpacity(0.1)
                  : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: credential.privilege.isCritical 
                    ? Colors.red.withOpacity(0.3)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Text(
              credential.privilege.displayName,
              style: TextStyle(
                color: credential.privilege.isCritical 
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        DataCell(
          SelectableText(
            credential.target,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(credential.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _getStatusColor(credential.status).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(credential.status.icon, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  credential.status.displayName,
                  style: TextStyle(
                    color: _getStatusColor(credential.status),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat('MMM dd, yyyy').format(credential.dateAdded)),
              if (credential.lastTested != null)
                Text(
                  'Tested: ${DateFormat('MMM dd').format(credential.lastTested!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<CredentialStatus>(
                icon: const Icon(Icons.play_arrow, size: 18),
                tooltip: 'Test Credential',
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: CredentialStatus.valid,
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        const Text('Mark Valid'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: CredentialStatus.invalid,
                    child: Row(
                      children: [
                        Icon(Icons.cancel, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        const Text('Mark Invalid'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: CredentialStatus.untested,
                    child: Row(
                      children: [
                        Icon(Icons.help_outline, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        const Text('Mark Untested'),
                      ],
                    ),
                  ),
                ],
                onSelected: (status) => onCredentialTest(credential.id, status),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => onCredentialEdit(credential.id),
                icon: const Icon(Icons.edit, size: 18),
                tooltip: 'Edit Credential',
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  minimumSize: const Size(32, 32),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => onCredentialDelete(credential.id),
                icon: const Icon(Icons.delete, size: 18),
                tooltip: 'Delete Credential',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  padding: const EdgeInsets.all(4),
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getTypeColor(CredentialType type) {
    switch (type) {
      case CredentialType.user:
        return Colors.blue;
      case CredentialType.admin:
        return Colors.red;
      case CredentialType.service:
        return Colors.green;
      case CredentialType.hash:
        return Colors.purple;
    }
  }

  Color _getStatusColor(CredentialStatus status) {
    switch (status) {
      case CredentialStatus.valid:
        return Colors.green;
      case CredentialStatus.invalid:
        return Colors.red;
      case CredentialStatus.untested:
        return Colors.orange;
    }
  }

  void _toggleSelectAll(bool selectAll) {
    for (final credential in credentials) {
      onSelectionChanged(credential.id, selectAll);
    }
  }
}