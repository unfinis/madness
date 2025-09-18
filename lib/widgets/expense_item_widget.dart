import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../dialogs/add_expense_dialog.dart';

class ExpenseItemWidget extends ConsumerWidget {
  final Expense expense;
  final String projectId;

  const ExpenseItemWidget({
    super.key,
    required this.expense,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateFormatter = DateFormat('MMM dd, yyyy');
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _editExpense(context, ref),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(isDesktop ? 16 : 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop)
                    _buildDesktopLayout(context, dateFormatter)
                  else
                    _buildMobileLayout(context, dateFormatter),
              
                  if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        expense.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Action buttons positioned at top-right
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () => _editExpense(context, ref),
                    tooltip: 'Edit expense',
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      size: 18,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () => _deleteExpense(context, ref),
                    tooltip: 'Delete expense',
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, DateFormat dateFormatter) {
    return Padding(
      padding: const EdgeInsets.only(right: 80), // Make space for action buttons
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getCategoryColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              expense.category.icon,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.description,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      expense.category.displayName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Text(' • '),
                    Text(
                      dateFormatter.format(expense.date),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (expense.hasEvidence) ...[
                      const Text(' • '),
                      _buildEvidenceIndicator(context),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '£${expense.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              _buildTypeChip(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, DateFormat dateFormatter) {
    return Padding(
      padding: const EdgeInsets.only(right: 80), // Make space for action buttons
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: _getCategoryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  expense.category.icon,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  expense.description,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '£${expense.amount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                expense.category.displayName,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Text(' • '),
              Text(
                dateFormatter.format(expense.date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              if (expense.hasEvidence) ...[
                const Text(' • '),
                _buildEvidenceIndicator(context),
              ],
              const Spacer(),
              _buildTypeChip(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 2,
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
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: expense.type == ExpenseType.billable
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.tertiary,
          fontWeight: FontWeight.w500,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildEvidenceIndicator(BuildContext context) {
    final evidenceCount = expense.evidenceFiles.length + (expense.receiptPath != null ? 1 : 0);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.attach_file,
            size: 10,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 2),
          Text(
            evidenceCount.toString(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (expense.category) {
      case ExpenseCategory.travel:
        return colorScheme.primary;
      case ExpenseCategory.accommodation:
        return colorScheme.secondary;
      case ExpenseCategory.food:
        return colorScheme.tertiary;
      case ExpenseCategory.equipment:
        return colorScheme.primaryContainer;
      case ExpenseCategory.other:
        return colorScheme.outline;
    }
  }

  void _showExpenseDetails(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(expense.description),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Amount', '£${expense.amount.toStringAsFixed(2)}'),
            _buildDetailRow('Type', expense.type.displayName),
            _buildDetailRow('Category', expense.category.displayName),
            _buildDetailRow('Date', DateFormat('MMM dd, yyyy HH:mm').format(expense.date)),
            if (expense.notes != null && expense.notes!.isNotEmpty)
              _buildDetailRow('Notes', expense.notes!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _editExpense(context, ref);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editExpense(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(expense: expense, projectId: projectId),
    );
  }

  void _deleteExpense(BuildContext context, WidgetRef ref) {
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}