import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/contact_provider.dart';
import 'unified_summary_widget.dart';

class ContactSummaryWidget extends ConsumerWidget {
  final String projectId;
  final bool compact;
  
  const ContactSummaryWidget({super.key, required this.projectId, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(contactSummaryProvider(projectId));
    final theme = Theme.of(context);
    
    final items = [
      SummaryItemData(
        label: 'Total Contacts',
        value: summary['total']!.toString(),
        icon: Icons.people,
        color: theme.colorScheme.primary,
      ),
      SummaryItemData(
        label: 'Emergency',
        value: summary['emergency']!.toString(),
        icon: Icons.emergency,
        color: theme.colorScheme.error,
      ),
      SummaryItemData(
        label: 'Technical',
        value: summary['technical']!.toString(),
        icon: Icons.engineering,
        color: theme.colorScheme.secondary,
      ),
      SummaryItemData(
        label: 'Report Recipients',
        value: summary['reportRecipients']!.toString(),
        icon: Icons.report,
        color: theme.colorScheme.tertiary,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '',
      items: items,
      compact: compact,
    );
  }

}