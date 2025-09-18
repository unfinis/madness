import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/credential_provider.dart';
import 'unified_summary_widget.dart';

class CredentialSummaryWidget extends ConsumerWidget {
  final bool compact;
  
  const CredentialSummaryWidget({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(credentialSummaryProvider);
    final theme = Theme.of(context);
    
    final items = [
      SummaryItemData(
        label: 'Total Credentials',
        value: summary['totalCredentials']?.toString() ?? '0',
        icon: Icons.key_rounded,
        color: theme.colorScheme.primary,
      ),
      SummaryItemData(
        label: 'Valid',
        value: summary['validCredentials']?.toString() ?? '0',
        icon: Icons.check_circle_rounded,
        color: Colors.green,
      ),
      SummaryItemData(
        label: 'Admin Level',
        value: summary['adminCredentials']?.toString() ?? '0',
        icon: Icons.admin_panel_settings_rounded,
        color: Colors.red,
      ),
      SummaryItemData(
        label: 'Untested',
        value: summary['untestedCredentials']?.toString() ?? '0',
        icon: Icons.help_outline_rounded,
        color: Colors.orange,
      ),
    ];

    return UnifiedSummaryWidget(
      title: '',
      items: items,
      compact: compact,
    );
  }

}