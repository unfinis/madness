import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding_template.dart';
import '../providers/template_provider.dart';

class TemplateSelectionDialog extends ConsumerStatefulWidget {
  const TemplateSelectionDialog({super.key});

  @override
  ConsumerState<TemplateSelectionDialog> createState() => _TemplateSelectionDialogState();
}

class _TemplateSelectionDialogState extends ConsumerState<TemplateSelectionDialog> {
  String _searchQuery = '';
  String? _selectedCategory;
  TemplateInfo? _selectedTemplate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final templatesAsync = ref.watch(templateProvider);
    final categories = ref.watch(templateCategoriesProvider);

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.document_scanner_outlined,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Select Finding Template',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and Filter
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search templates...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...categories.map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _selectedTemplate = null;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Template List
            Expanded(
              child: templatesAsync.when(
                data: (allTemplates) {
                  List<TemplateInfo> filteredTemplates = allTemplates;

                  // Apply category filter
                  if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
                    filteredTemplates = filteredTemplates
                        .where((t) => t.category == _selectedCategory)
                        .toList();
                  }

                  // Apply search filter
                  if (_searchQuery.isNotEmpty) {
                    final query = _searchQuery.toLowerCase();
                    filteredTemplates = filteredTemplates
                        .where((t) =>
                            t.title.toLowerCase().contains(query) ||
                            t.category.toLowerCase().contains(query))
                        .toList();
                  }

                  if (filteredTemplates.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 48,
                            color: theme.colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No templates found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try adjusting your search or category filter',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTemplates.length,
                    itemBuilder: (context, index) {
                      final template = filteredTemplates[index];
                      final isSelected = _selectedTemplate?.id == template.id;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        elevation: isSelected ? 2 : 0,
                        color: isSelected 
                            ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                            : null,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primaryContainer,
                            child: Text(
                              template.findingCount.toString(),
                              style: TextStyle(
                                color: isSelected
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            template.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  template.category,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${template.findingCount} finding${template.findingCount != 1 ? 's' : ''}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.outline,
                                ),
                              ),
                            ],
                          ),
                          trailing: isSelected 
                              ? Icon(
                                  Icons.check_circle,
                                  color: theme.colorScheme.primary,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedTemplate = template;
                            });
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load templates',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton.icon(
                        onPressed: () => ref.read(templateProvider.notifier).loadTemplateIndex(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 12),
                FilledButton.icon(
                  onPressed: _selectedTemplate != null
                      ? () => Navigator.of(context).pop(_selectedTemplate)
                      : null,
                  icon: const Icon(Icons.add),
                  label: const Text('Use Template'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Show template selection dialog
Future<TemplateInfo?> showTemplateSelectionDialog(BuildContext context) {
  return showDialog<TemplateInfo>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const TemplateSelectionDialog(),
  );
}