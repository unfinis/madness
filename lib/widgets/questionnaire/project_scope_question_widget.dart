/// Project scope confirmation widget with interactive elements checklist
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/projects_provider.dart';
import '../../constants/app_spacing.dart';
import 'question_widget_base.dart';

class ProjectScopeQuestionWidget extends QuestionWidgetBase {
  const ProjectScopeQuestionWidget({
    super.key,
    required super.question,
    required super.answer,
    required super.onAnswerChanged,
  });

  @override
  QuestionWidgetBaseState<ProjectScopeQuestionWidget> createState() => _ProjectScopeQuestionWidgetState();
}

class _ProjectScopeQuestionWidgetState extends QuestionWidgetBaseState<ProjectScopeQuestionWidget> {
  Map<String, bool> _scopeElements = {};
  Map<String, List<String>> _scopeItems = {};
  final Map<String, TextEditingController> _itemControllers = {};

  // Standard scope elements with icons and descriptions
  static const Map<String, Map<String, dynamic>> _standardElements = {
    'internal_network': {
      'name': 'Internal Network',
      'icon': Icons.router,
      'description': 'Internal network infrastructure testing',
      'defaultItems': ['Domain Controllers', 'File Servers', 'Database Servers', 'Workstations'],
    },
    'external_infrastructure': {
      'name': 'External Infrastructure',
      'icon': Icons.public,
      'description': 'Internet-facing systems and services',
      'defaultItems': ['Web Servers', 'Mail Servers', 'DNS Servers', 'Public APIs'],
    },
    'web_applications': {
      'name': 'Web Applications',
      'icon': Icons.web,
      'description': 'Web application security testing',
      'defaultItems': ['Customer Portal', 'Admin Interface', 'API Endpoints', 'Mobile App Backend'],
    },
    'mobile_app': {
      'name': 'Mobile Applications',
      'icon': Icons.phone_android,
      'description': 'Mobile application security assessment',
      'defaultItems': ['iOS App', 'Android App', 'Mobile API', 'Device Storage'],
    },
    'wireless': {
      'name': 'Wireless Assessment',
      'icon': Icons.wifi,
      'description': 'Wireless network security testing',
      'defaultItems': ['WiFi Networks', 'Bluetooth', 'Guest Networks', 'IoT Devices'],
    },
    'physical': {
      'name': 'Physical Security',
      'icon': Icons.security,
      'description': 'Physical security controls assessment',
      'defaultItems': ['Access Controls', 'CCTV', 'Badge Systems', 'Facility Security'],
    },
    'social': {
      'name': 'Social Engineering',
      'icon': Icons.people,
      'description': 'Human factor security testing',
      'defaultItems': ['Phishing Campaigns', 'Vishing', 'Physical Pretexting', 'USB Drops'],
    },
    'code_review': {
      'name': 'Code Review',
      'icon': Icons.code,
      'description': 'Source code security analysis',
      'defaultItems': ['Application Source', 'Configuration Files', 'Dependencies', 'CI/CD Pipeline'],
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeScopeFromProject();
  }

  @override
  void dispose() {
    for (final controller in _itemControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeScopeFromProject() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final project = ProviderScope.containerOf(context).read(currentProjectProvider);
      if (project != null) {
        setState(() {
          _scopeElements = Map<String, bool>.from(project.assessmentScope);
          // Initialize default scope items for enabled elements
          for (final entry in _scopeElements.entries) {
            if (entry.value) {
              final elementData = _standardElements[entry.key];
              if (elementData != null) {
                _scopeItems[entry.key] = List<String>.from(elementData['defaultItems'] as List<String>);
              }
            }
          }
        });
      } else {
        // Initialize with standard elements if no project
        setState(() {
          _scopeElements = Map.fromEntries(
            _standardElements.keys.map((key) => MapEntry(key, false)),
          );
        });
      }
    });
  }

  @override
  Widget buildQuestionContent(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.checklist,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                AppSpacing.hGapMD,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Scope Confirmation',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Review and confirm engagement elements and scope items',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSummaryStats(context),
              ],
            ),
          ),

          // Scope Elements
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Assessment Elements',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppSpacing.vGapMD,
                
                // Elements grid
                ..._buildElementsList(context),
                
                AppSpacing.vGapLG,
                
                // Confirm button
                Center(
                  child: FilledButton.icon(
                    onPressed: _hasSelectedElements() ? _confirmScope : null,
                    icon: const Icon(Icons.check),
                    label: const Text('Confirm Scope'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStats(BuildContext context) {
    final theme = Theme.of(context);
    final selectedCount = _scopeElements.values.where((v) => v).length;
    final totalItems = _scopeItems.values.fold<int>(0, (sum, items) => sum + items.length);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$selectedCount',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Elements',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$totalItems Items',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildElementsList(BuildContext context) {
    return _standardElements.entries.map((entry) {
      return _buildElementCard(context, entry.key, entry.value);
    }).toList();
  }

  Widget _buildElementCard(BuildContext context, String elementKey, Map<String, dynamic> elementData) {
    final theme = Theme.of(context);
    final isSelected = _scopeElements[elementKey] ?? false;
    final items = _scopeItems[elementKey] ?? <String>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected
            ? theme.colorScheme.primaryContainer.withOpacity(0.5)
            : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Element header
          CheckboxListTile(
            value: isSelected,
            onChanged: (value) => _toggleElement(elementKey, value ?? false),
            title: Row(
              children: [
                Icon(
                  elementData['icon'] as IconData,
                  size: 20,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                AppSpacing.hGapSM,
                Text(
                  elementData['name'] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              elementData['description'] as String,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            secondary: isSelected
                ? Chip(
                    label: Text('${items.length}'),
                    backgroundColor: theme.colorScheme.primary,
                    labelStyle: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          
          // Scope items (when selected)
          if (isSelected) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Scope Items:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _addScopeItem(elementKey),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add Item'),
                        style: TextButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGapSM,
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: items.map((item) => _buildScopeItemChip(context, elementKey, item)).toList(),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScopeItemChip(BuildContext context, String elementKey, String item) {
    final theme = Theme.of(context);
    
    return Chip(
      label: Text(item),
      backgroundColor: theme.colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: theme.colorScheme.onSecondaryContainer,
        fontSize: 12,
      ),
      deleteIcon: Icon(
        Icons.close,
        size: 16,
        color: theme.colorScheme.onSecondaryContainer,
      ),
      onDeleted: () => _removeScopeItem(elementKey, item),
    );
  }

  void _toggleElement(String elementKey, bool enabled) {
    setState(() {
      _scopeElements[elementKey] = enabled;
      
      if (enabled) {
        // Add default scope items if enabled
        final elementData = _standardElements[elementKey];
        if (elementData != null) {
          _scopeItems[elementKey] = List<String>.from(elementData['defaultItems'] as List<String>);
        }
      } else {
        // Remove scope items if disabled
        _scopeItems.remove(elementKey);
      }
      
      _updateAnswer();
    });
  }

  void _addScopeItem(String elementKey) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Scope Item'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Item Name',
            hintText: 'Enter scope item...',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final itemName = controller.text.trim();
              if (itemName.isNotEmpty) {
                setState(() {
                  _scopeItems[elementKey] = [...(_scopeItems[elementKey] ?? []), itemName];
                  _updateAnswer();
                });
              }
              Navigator.of(context).pop();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removeScopeItem(String elementKey, String item) {
    setState(() {
      _scopeItems[elementKey]?.remove(item);
      _updateAnswer();
    });
  }

  bool _hasSelectedElements() {
    return _scopeElements.values.any((selected) => selected);
  }

  void _confirmScope() {
    updateAnswer({
      'elements': _scopeElements,
      'scopeItems': _scopeItems,
      'confirmed': true,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  void _updateAnswer() {
    updateAnswer({
      'elements': _scopeElements,
      'scopeItems': _scopeItems,
      'confirmed': false,
    });
  }
}