import 'package:flutter/material.dart';

class ImportMethodologyDialog extends StatelessWidget {
  const ImportMethodologyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.upload),
          SizedBox(width: 12),
          Text('Import Methodology Template'),
        ],
      ),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Import methodology templates from various sources:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            
            _buildImportOption(
              context,
              icon: Icons.security,
              title: 'OWASP Testing Guide',
              description: 'Comprehensive web application security testing methodologies',
              onTap: () => _showComingSoon(context, 'OWASP Testing Guide'),
            ),
            
            const SizedBox(height: 12),
            
            _buildImportOption(
              context,
              icon: Icons.policy,
              title: 'NIST Cybersecurity Framework',
              description: 'Standards-based cybersecurity risk management framework',
              onTap: () => _showComingSoon(context, 'NIST Framework'),
            ),
            
            const SizedBox(height: 12),
            
            _buildImportOption(
              context,
              icon: Icons.assessment,
              title: 'PTES Standard',
              description: 'Penetration Testing Execution Standard methodologies',
              onTap: () => _showComingSoon(context, 'PTES Standard'),
            ),
            
            const SizedBox(height: 12),
            
            _buildImportOption(
              context,
              icon: Icons.folder_open,
              title: 'Custom Templates',
              description: 'Import your saved methodology templates',
              onTap: () => _showComingSoon(context, 'Custom Templates'),
            ),
            
            const SizedBox(height: 12),
            
            _buildImportOption(
              context,
              icon: Icons.business,
              title: 'Industry-Specific',
              description: 'Financial, healthcare, and other industry templates',
              onTap: () => _showComingSoon(context, 'Industry-Specific Templates'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  Widget _buildImportOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String featureName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$featureName Import'),
        content: Text(
          'This feature is coming soon!\n\n'
          'The $featureName import functionality will allow you to:\n'
          '• Browse and select from pre-defined methodologies\n'
          '• Import custom YAML methodology files\n'
          '• Configure methodology parameters\n'
          '• Preview methodology steps before import\n'
          '• Merge with existing methodologies',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}