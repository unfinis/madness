import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../dialogs/add_expense_dialog.dart';

class ExpenseTableWidget extends ConsumerWidget {
  final List<Expense> expenses;
  final String projectId;

  const ExpenseTableWidget({
    super.key,
    required this.expenses,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (expenses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Text(
            'No expenses found',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final sortedExpenses = [...expenses]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            headingRowColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            ),
            columns: const [
              DataColumn(
                label: Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Type',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              DataColumn(
                label: Text(
                  'Amount',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
            rows: sortedExpenses.map((expense) {
              return DataRow(
                onSelectChanged: (_) => _editExpense(context, expense),
                cells: [
                  DataCell(
                    Text(DateFormat('MMM dd, yyyy').format(expense.date)),
                  ),
                  DataCell(
                    Container(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            expense.description,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (expense.notes != null && expense.notes!.isNotEmpty)
                            Text(
                              expense.notes!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(expense.category.icon),
                        const SizedBox(width: 4),
                        Text(expense.category.displayName),
                      ],
                    ),
                  ),
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: expense.type == ExpenseType.billable
                            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                            : Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: expense.type == ExpenseType.billable
                              ? Theme.of(context).colorScheme.secondary.withOpacity(0.3)
                              : Theme.of(context).colorScheme.tertiary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        expense.type.displayName,
                        style: TextStyle(
                          color: expense.type == ExpenseType.billable
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      '£${expense.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 18,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _editExpense(context, expense),
                          tooltip: 'Edit',
                          visualDensity: VisualDensity.compact,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () => _deleteExpense(context, ref, expense),
                          tooltip: 'Delete',
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _editExpense(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(expense: expense, projectId: projectId),
    );
  }

  void _deleteExpense(BuildContext context, WidgetRef ref, Expense expense) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text(
          'Are you sure you want to delete "${expense.description}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(expenseProvider(projectId).notifier).deleteExpense(expense.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Expense deleted successfully'),
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}