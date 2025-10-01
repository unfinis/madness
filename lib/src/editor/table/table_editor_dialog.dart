import 'package:flutter/material.dart';

/// Dialog for creating and editing tables
class TableEditorDialog extends StatefulWidget {
  final List<List<String>>? initialData;

  const TableEditorDialog({
    super.key,
    this.initialData,
  });

  @override
  State<TableEditorDialog> createState() => _TableEditorDialogState();
}

class _TableEditorDialogState extends State<TableEditorDialog> {
  late List<List<TextEditingController>> _controllers;
  late int _rows;
  late int _cols;

  @override
  void initState() {
    super.initState();

    if (widget.initialData != null && widget.initialData!.isNotEmpty) {
      _rows = widget.initialData!.length;
      _cols = widget.initialData![0].length;
      _controllers = widget.initialData!
          .map((row) =>
              row.map((cell) => TextEditingController(text: cell)).toList())
          .toList();
    } else {
      _rows = 3;
      _cols = 3;
      _controllers = List.generate(
        _rows,
        (row) => List.generate(
          _cols,
          (col) => TextEditingController(
            text: row == 0 ? 'Header ${col + 1}' : '',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    for (final row in _controllers) {
      for (final controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      _controllers.add(
        List.generate(_cols, (_) => TextEditingController()),
      );
      _rows++;
    });
  }

  void _addColumn() {
    setState(() {
      for (final row in _controllers) {
        row.add(TextEditingController());
      }
      _cols++;
    });
  }

  void _removeRow(int index) {
    if (_rows <= 1) return;
    setState(() {
      for (final controller in _controllers[index]) {
        controller.dispose();
      }
      _controllers.removeAt(index);
      _rows--;
    });
  }

  void _removeColumn(int index) {
    if (_cols <= 1) return;
    setState(() {
      for (final row in _controllers) {
        row[index].dispose();
        row.removeAt(index);
      }
      _cols--;
    });
  }

  List<List<String>> _getData() {
    return _controllers
        .map((row) => row.map((controller) => controller.text).toList())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Table Editor'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            // Toolbar
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Row',
                  onPressed: _addRow,
                ),
                IconButton(
                  icon: const Icon(Icons.view_column),
                  tooltip: 'Add Column',
                  onPressed: _addColumn,
                ),
                const Spacer(),
                Text('$_rows × $_cols', style: theme.textTheme.bodySmall),
              ],
            ),
            const Divider(),

            // Table grid
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(
                      color: theme.colorScheme.outline,
                    ),
                    defaultColumnWidth: const IntrinsicColumnWidth(
                      flex: 1.0,
                    ),
                    children: [
                      for (var row = 0; row < _rows; row++)
                        TableRow(
                          decoration: row == 0
                              ? BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                )
                              : null,
                          children: [
                            for (var col = 0; col < _cols; col++)
                              _TableCell(
                                controller: _controllers[row][col],
                                isHeader: row == 0,
                                onRemoveRow:
                                    _rows > 1 && col == 0
                                        ? () => _removeRow(row)
                                        : null,
                                onRemoveColumn:
                                    _cols > 1 && row == 0
                                        ? () => _removeColumn(col)
                                        : null,
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_getData()),
          child: const Text('Insert'),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final TextEditingController controller;
  final bool isHeader;
  final VoidCallback? onRemoveRow;
  final VoidCallback? onRemoveColumn;

  const _TableCell({
    required this.controller,
    required this.isHeader,
    this.onRemoveRow,
    this.onRemoveColumn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 100,
        minHeight: 40,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              maxLines: null,
            ),
          ),
          if (onRemoveRow != null)
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                onPressed: onRemoveRow,
                tooltip: 'Remove row',
              ),
            ),
          if (onRemoveColumn != null)
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, size: 16),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                onPressed: onRemoveColumn,
                tooltip: 'Remove column',
              ),
            ),
        ],
      ),
    );
  }
}
