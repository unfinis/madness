import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import 'unified_summary_widget.dart';

class ExpenseSummaryWidget extends ConsumerWidget {
  final String projectId;
  final bool compact;
  
  const ExpenseSummaryWidget({
    super.key,
    required this.projectId,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(expenseSummaryProvider(projectId));
    final theme = Theme.of(context);
    
    final items = [
      SummaryItemData(
        label: 'Total Amount',
        value: '£${summary['total']!.toStringAsFixed(2)}',
        icon: Icons.account_balance_wallet,
        color: theme.colorScheme.primary,
      ),
      SummaryItemData(
        label: 'Billable',
        value: '£${summary['billable']!.toStringAsFixed(2)}',
        icon: Icons.business,
        color: theme.colorScheme.secondary,
      ),
      SummaryItemData(
        label: 'Personal',
        value: '£${summary['personal']!.toStringAsFixed(2)}',
        icon: Icons.person,
        color: theme.colorScheme.tertiary,
      ),
      SummaryItemData(
        label: 'This Month',
        value: summary['thisMonthCount']!.toInt().toString(),
        icon: Icons.calendar_month,
        color: theme.colorScheme.primaryContainer,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '',
      items: items,
      compact: compact,
    );
  }

}