import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_spacing.dart';
import '../models/methodology_trigger_builder.dart';
import '../models/asset.dart';

class TriggerEditorDialog extends ConsumerStatefulWidget {
  final MethodologyTriggerDefinition? initialTrigger;
  final Function(MethodologyTriggerDefinition) onSave;

  const TriggerEditorDialog({
    super.key,
    this.initialTrigger,
    required this.onSave,
  });

  @override
  ConsumerState<TriggerEditorDialog> createState() => _TriggerEditorDialogState();
}

class _TriggerEditorDialogState extends ConsumerState<TriggerEditorDialog> {
  late TriggerExpression rootExpression;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _priority = 5;
  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    if (widget.initialTrigger != null) {
      _nameController.text = widget.initialTrigger!.name;
      _descriptionController.text = widget.initialTrigger!.description;
      _priority = widget.initialTrigger!.priority;
      _enabled = widget.initialTrigger!.enabled;
      rootExpression = _convertToExpression(widget.initialTrigger!);
    } else {
      rootExpression = TriggerExpression.empty();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  TriggerExpression _convertToExpression(MethodologyTriggerDefinition trigger) {
    // Convert the existing trigger to expression format
    if (trigger.conditionGroups.isEmpty) {
      return TriggerExpression.empty();
    }

    if (trigger.conditionGroups.length == 1) {
      return _convertGroupToExpression(trigger.conditionGroups.first);
    }

    // Multiple groups - create logical expression
    final expressions = trigger.conditionGroups
        .map((group) => _convertGroupToExpression(group))
        .toList();

    return TriggerExpression.logical(
      operator: trigger.groupLogicalOperator,
      expressions: expressions,
    );
  }

  TriggerExpression _convertGroupToExpression(TriggerGroup group) {
    if (group.conditions.isEmpty) {
      return TriggerExpression.empty();
    }

    if (group.conditions.length == 1) {
      return _convertConditionToExpression(group.conditions.first);
    }

    final expressions = group.conditions
        .map((condition) => _convertConditionToExpression(condition))
        .toList();

    return TriggerExpression.logical(
      operator: group.logicalOperator,
      expressions: expressions,
    );
  }

  TriggerExpression _convertConditionToExpression(TriggerCondition condition) {
    return TriggerExpression.condition(
      assetType: condition.assetType,
      property: condition.property,
      operator: condition.operator,
      value: condition.value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: AppSpacing.md),
            _buildTriggerInfo(),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: Row(
                children: [
                  // Left panel - Asset Browser
                  SizedBox(
                    width: 300,
                    child: _buildAssetBrowser(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  // Right panel - Expression Builder
                  Expanded(
                    child: _buildExpressionBuilder(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.build, color: Theme.of(context).primaryColor),
        const SizedBox(width: AppSpacing.sm),
        Text(
          'Trigger Editor',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTriggerInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trigger Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Trigger Name',
                      hintText: 'e.g., Windows SMB with disabled signing',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                SizedBox(
                  width: 100,
                  child: DropdownButtonFormField<int>(
                    value: _priority,
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(10, (i) => i + 1)
                        .map((priority) => DropdownMenuItem(
                              value: priority,
                              child: Text(priority.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _priority = value;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Switch(
                  value: _enabled,
                  onChanged: (value) {
                    setState(() {
                      _enabled = value;
                    });
                  },
                ),
                const Text('Enabled'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetBrowser() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              'Asset Types & Properties',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: AssetType.values.length,
              itemBuilder: (context, index) {
                final assetType = AssetType.values[index];
                return _buildAssetTypeExpansionTile(assetType);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssetTypeExpansionTile(AssetType assetType) {
    final properties = AssetPropertyDefinition.getPropertiesForAssetType(assetType);

    return ExpansionTile(
      leading: Icon(_getAssetTypeIcon(assetType)),
      title: Text(
        assetType.name.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: properties.map((property) {
        return Draggable<AssetPropertyDragData>(
          data: AssetPropertyDragData(
            assetType: assetType,
            property: property,
          ),
          feedback: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${assetType.name}.${property.name}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          child: ListTile(
            dense: true,
            title: Text(property.displayName),
            subtitle: Text(
              '${property.name} (${property.type.name})',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: _buildPropertyTypeIcon(property.type),
            onTap: () => _addPropertyCondition(assetType, property),
          ),
        );
      }).toList(),
    );
  }

  IconData _getAssetTypeIcon(AssetType assetType) {
    switch (assetType) {
      case AssetType.host:
        return Icons.computer;
      case AssetType.service:
        return Icons.settings_ethernet;
      case AssetType.credential:
        return Icons.key;
      case AssetType.networkSegment:
        return Icons.lan;
      case AssetType.domain:
        return Icons.domain;
      case AssetType.vulnerability:
        return Icons.bug_report;
      case AssetType.wireless_network:
        return Icons.wifi;
    }
  }

  Widget _buildPropertyTypeIcon(PropertyType type) {
    IconData icon;
    Color color;
    final colors = Theme.of(context).colorScheme;

    switch (type) {
      case PropertyType.string:
        icon = Icons.text_fields;
        color = colors.primary;
        break;
      case PropertyType.number:
        icon = Icons.numbers;
        color = colors.secondary;
        break;
      case PropertyType.boolean:
        icon = Icons.toggle_on;
        color = colors.tertiary;
        break;
      case PropertyType.list:
        icon = Icons.list;
        color = colors.primaryContainer;
        break;
    }

    return Icon(icon, size: 16, color: color);
  }

  Widget _buildExpressionBuilder() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Text(
                  'Trigger Expression',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                _buildOperatorButtons(),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildExpressionTree(rootExpression),
            ),
          ),
          const Divider(),
          _buildExpressionPreview(),
        ],
      ),
    );
  }

  Widget _buildOperatorButtons() {
    return Row(
      children: [
        _buildOperatorButton('AND', LogicalOperator.and),
        const SizedBox(width: AppSpacing.sm),
        _buildOperatorButton('OR', LogicalOperator.or),
        const SizedBox(width: AppSpacing.sm),
        _buildOperatorButton('NOT', LogicalOperator.not),
        const SizedBox(width: AppSpacing.sm),
        _buildOperatorButton('( )', LogicalOperator.group),
      ],
    );
  }

  Widget _buildOperatorButton(String label, LogicalOperator operator) {
    return Draggable<LogicalOperator>(
      data: operator,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      child: OutlinedButton(
        onPressed: () => _addLogicalOperator(operator),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildExpressionTree(TriggerExpression expression) {
    return DragTarget<Object>(
      onAccept: (data) {
        setState(() {
          if (data is AssetPropertyDragData) {
            _insertPropertyAt(expression, data);
          } else if (data is LogicalOperator) {
            _insertOperatorAt(expression, data);
          }
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          constraints: const BoxConstraints(minHeight: 200),
          child: expression.when(
            empty: () => _buildEmptyState(),
            condition: (assetType, property, operator, value) =>
                _buildConditionWidget(expression),
            logical: (operator, expressions) =>
                _buildLogicalWidget(expression),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor.withOpacity(0.5), width: 1.5),
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline, size: 48, color: Theme.of(context).hintColor),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Drag assets or operators here to build your trigger',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).hintColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Example: OPERATING_SYSTEM=WINDOWS HAS SERVICE=SMB',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).hintColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConditionWidget(TriggerExpression expression) {
    return expression.maybeWhen(
      condition: (assetType, property, operator, value) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.primaryContainer),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getAssetTypeIcon(assetType), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          assetType.name.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _buildConditionEditor(expression),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _removeExpression(expression),
              ),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildConditionEditor(TriggerExpression expression) {
    return expression.maybeWhen(
      condition: (assetType, property, operator, value) {
        final assetProperty = AssetPropertyDefinition.getProperty(assetType, property);

        return Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<String>(
                value: property,
                decoration: const InputDecoration(
                  labelText: 'Property',
                  border: OutlineInputBorder(),
                ),
                items: AssetPropertyDefinition.getPropertiesForAssetType(assetType)
                    .map((prop) => DropdownMenuItem(
                          value: prop.name,
                          child: Text(prop.displayName),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _updateCondition(expression, property: value);
                  }
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: DropdownButtonFormField<TriggerOperator>(
                value: operator,
                decoration: const InputDecoration(
                  labelText: 'Operator',
                  border: OutlineInputBorder(),
                ),
                items: _getAvailableOperators(assetProperty?.type ?? PropertyType.string)
                    .map((op) => DropdownMenuItem(
                          value: op,
                          child: Text(op.symbol),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _updateCondition(expression, operator: value);
                  }
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              flex: 2,
              child: _buildValueEditor(expression, assetProperty),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildValueEditor(TriggerExpression expression, AssetProperty? property) {
    if (property == null) return const SizedBox.shrink();

    return expression.maybeWhen(
      condition: (assetType, prop, operator, value) {
        // Handle unary operators (IS NULL, IS NOT NULL, EXISTS, NOT EXISTS)
        if (operator == TriggerOperator.isNull ||
            operator == TriggerOperator.isNotNull ||
            operator == TriggerOperator.exists ||
            operator == TriggerOperator.notExists) {
          return Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Theme.of(context).hintColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'No value required for ${operator.symbol}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ],
            ),
          );
        }

        switch (property.type) {
          case PropertyType.string:
            return _buildStringValueEditor(expression, property, value);
          case PropertyType.number:
            return _buildNumberValueEditor(expression, value);
          case PropertyType.boolean:
            return _buildBooleanValueEditor(expression, value);
          case PropertyType.list:
            return _buildListValueEditor(expression, property, value);
        }
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildStringValueEditor(TriggerExpression expression, AssetProperty property, TriggerValue value) {
    final currentValue = value.maybeWhen(
      string: (val) => val,
      orElse: () => '',
    );

    if (property.allowedValues?.isNotEmpty == true) {
      return DropdownButtonFormField<String>(
        value: property.allowedValues!.contains(currentValue) ? currentValue : null,
        decoration: const InputDecoration(
          labelText: 'Value',
          border: OutlineInputBorder(),
        ),
        items: property.allowedValues!.map((val) => DropdownMenuItem(
          value: val,
          child: Text(val),
        )).toList(),
        onChanged: (val) {
          if (val != null) {
            _updateCondition(expression, value: TriggerValue.string(val));
          }
        },
      );
    }

    return TextFormField(
      initialValue: currentValue,
      decoration: const InputDecoration(
        labelText: 'Value',
        border: OutlineInputBorder(),
      ),
      onChanged: (val) {
        _updateCondition(expression, value: TriggerValue.string(val));
      },
    );
  }

  Widget _buildNumberValueEditor(TriggerExpression expression, TriggerValue value) {
    final currentValue = value.maybeWhen(
      number: (val) => val.toString(),
      orElse: () => '',
    );

    return TextFormField(
      initialValue: currentValue,
      decoration: const InputDecoration(
        labelText: 'Value',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onChanged: (val) {
        final numValue = double.tryParse(val);
        if (numValue != null) {
          _updateCondition(expression, value: TriggerValue.number(numValue));
        }
      },
    );
  }

  Widget _buildBooleanValueEditor(TriggerExpression expression, TriggerValue value) {
    final currentValue = value.maybeWhen(
      boolean: (val) => val,
      orElse: () => false,
    );

    return DropdownButtonFormField<bool>(
      value: currentValue,
      decoration: const InputDecoration(
        labelText: 'Value',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: true, child: Text('True')),
        DropdownMenuItem(value: false, child: Text('False')),
      ],
      onChanged: (val) {
        if (val != null) {
          _updateCondition(expression, value: TriggerValue.boolean(val));
        }
      },
    );
  }

  Widget _buildListValueEditor(TriggerExpression expression, AssetProperty property, TriggerValue value) {
    final currentValues = value.maybeWhen(
      list: (vals) => vals.join('\n'),
      orElse: () => '',
    );

    return TextFormField(
      initialValue: currentValues,
      decoration: const InputDecoration(
        labelText: 'Values (one per line)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      onChanged: (val) {
        final values = val.split('\n').where((v) => v.trim().isNotEmpty).toList();
        _updateCondition(expression, value: TriggerValue.list(values));
      },
    );
  }

  Widget _buildLogicalWidget(TriggerExpression expression) {
    return expression.maybeWhen(
      logical: (operator, expressions) {
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.secondaryContainer),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      operator,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => _addExpressionToGroup(expression),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _removeExpression(expression),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...expressions.asMap().entries.map((entry) {
                final index = entry.key;
                final subExpr = entry.value;
                return Column(
                  children: [
                    if (index > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        child: Row(
                          children: [
                            const Expanded(child: Divider()),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                              child: Text(operator),
                            ),
                            const Expanded(child: Divider()),
                          ],
                        ),
                      ),
                    _buildExpressionTree(subExpr),
                  ],
                );
              }).toList(),
            ],
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }

  Widget _buildExpressionPreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Preview',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Text(
              _generateExpressionText(rootExpression),
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateExpressionText(TriggerExpression expression) {
    return expression.when(
      empty: () => 'No conditions defined',
      condition: (assetType, property, operator, value) {
        final valueText = value.when(
          string: (val) => val,
          number: (val) => val.toString(),
          boolean: (val) => val.toString().toUpperCase(),
          list: (vals) => '[${vals.join(', ')}]',
          isNull: () => 'NULL',
          notNull: () => 'NOT NULL',
        );

        return '${assetType.name.toUpperCase()}.${property.toUpperCase()} ${operator.symbol} $valueText';
      },
      logical: (operator, expressions) {
        if (expressions.isEmpty) return '';

        final expressionTexts = expressions
            .map((expr) => _generateExpressionText(expr))
            .where((text) => text.isNotEmpty)
            .toList();

        if (expressionTexts.isEmpty) return '';

        if (operator == 'NOT' && expressionTexts.length == 1) {
          return 'NOT (${expressionTexts.first})';
        }

        final joined = expressionTexts.join(' $operator ');
        return expressionTexts.length > 1 ? '($joined)' : joined;
      },
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: AppSpacing.sm),
        ElevatedButton.icon(
          onPressed: _saveTrigger,
          icon: const Icon(Icons.save),
          label: const Text('Save Trigger'),
        ),
      ],
    );
  }

  List<TriggerOperator> _getAvailableOperators(PropertyType type) {
    switch (type) {
      case PropertyType.string:
        return [
          TriggerOperator.equals,
          TriggerOperator.notEquals,
          TriggerOperator.contains,
          TriggerOperator.notContains,
          TriggerOperator.startsWith,
          TriggerOperator.endsWith,
          TriggerOperator.isNull,
          TriggerOperator.isNotNull,
        ];
      case PropertyType.number:
        return [
          TriggerOperator.equals,
          TriggerOperator.notEquals,
          TriggerOperator.greaterThan,
          TriggerOperator.lessThan,
          TriggerOperator.greaterThanOrEqual,
          TriggerOperator.lessThanOrEqual,
          TriggerOperator.isNull,
          TriggerOperator.isNotNull,
        ];
      case PropertyType.boolean:
        return [
          TriggerOperator.equals,
          TriggerOperator.notEquals,
          TriggerOperator.isNull,
          TriggerOperator.isNotNull,
        ];
      case PropertyType.list:
        return [
          TriggerOperator.contains,
          TriggerOperator.notContains,
          TriggerOperator.in_,
          TriggerOperator.notIn,
          TriggerOperator.isNull,
          TriggerOperator.isNotNull,
        ];
    }
  }

  void _addPropertyCondition(AssetType assetType, AssetProperty property) {
    final condition = TriggerExpression.condition(
      assetType: assetType,
      property: property.name,
      operator: _getDefaultOperator(property.type),
      value: _getDefaultValue(property.type),
    );

    setState(() {
      if (rootExpression.maybeWhen(empty: () => true, orElse: () => false)) {
        rootExpression = condition;
      } else {
        // Add to existing expression with AND
        rootExpression = TriggerExpression.logical(
          operator: 'AND',
          expressions: [rootExpression, condition],
        );
      }
    });
  }

  void _addLogicalOperator(LogicalOperator operator) {
    setState(() {
      if (rootExpression.maybeWhen(empty: () => true, orElse: () => false)) {
        // Can't add operator to empty expression
        return;
      }

      switch (operator) {
        case LogicalOperator.and:
        case LogicalOperator.or:
          rootExpression = TriggerExpression.logical(
            operator: operator.name.toUpperCase(),
            expressions: [rootExpression, TriggerExpression.empty()],
          );
          break;
        case LogicalOperator.not:
          rootExpression = TriggerExpression.logical(
            operator: 'NOT',
            expressions: [rootExpression],
          );
          break;
        case LogicalOperator.group:
          rootExpression = TriggerExpression.logical(
            operator: 'AND',
            expressions: [rootExpression],
          );
          break;
      }
    });
  }

  TriggerOperator _getDefaultOperator(PropertyType type) {
    switch (type) {
      case PropertyType.string:
      case PropertyType.number:
      case PropertyType.boolean:
        return TriggerOperator.equals;
      case PropertyType.list:
        return TriggerOperator.contains;
    }
  }

  TriggerValue _getDefaultValue(PropertyType type) {
    switch (type) {
      case PropertyType.string:
        return const TriggerValue.string('');
      case PropertyType.number:
        return const TriggerValue.number(0);
      case PropertyType.boolean:
        return const TriggerValue.boolean(false);
      case PropertyType.list:
        return const TriggerValue.list([]);
    }
  }

  void _insertPropertyAt(TriggerExpression target, AssetPropertyDragData data) {
    // Implementation for inserting property at specific location
  }

  void _insertOperatorAt(TriggerExpression target, LogicalOperator operator) {
    // Implementation for inserting operator at specific location
  }

  void _removeExpression(TriggerExpression expression) {
    setState(() {
      rootExpression = TriggerExpression.empty();
    });
  }

  void _addExpressionToGroup(TriggerExpression groupExpression) {
    // Implementation for adding expression to logical group
  }

  void _updateCondition(
    TriggerExpression expression, {
    String? property,
    TriggerOperator? operator,
    TriggerValue? value,
  }) {
    // Implementation for updating condition values
  }

  void _saveTrigger() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a trigger name')),
      );
      return;
    }

    final trigger = MethodologyTriggerDefinition(
      id: 'trigger_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text,
      description: _descriptionController.text,
      priority: _priority,
      enabled: _enabled,
      conditionGroups: _convertExpressionToGroups(rootExpression),
    );

    widget.onSave(trigger);
    Navigator.of(context).pop();
  }

  List<TriggerGroup> _convertExpressionToGroups(TriggerExpression expression) {
    // Implementation for converting expression tree back to condition groups
    return [];
  }
}

// Supporting classes for the trigger editor
class AssetPropertyDragData {
  final AssetType assetType;
  final AssetProperty property;

  AssetPropertyDragData({required this.assetType, required this.property});
}

enum LogicalOperator { and, or, not, group }

// Expression tree model for visual editing
abstract class TriggerExpression {
  const TriggerExpression();

  factory TriggerExpression.empty() = EmptyExpression;

  factory TriggerExpression.condition({
    required AssetType assetType,
    required String property,
    required TriggerOperator operator,
    required TriggerValue value,
  }) = ConditionExpression;

  factory TriggerExpression.logical({
    required String operator,
    required List<TriggerExpression> expressions,
  }) = LogicalExpression;

  T when<T>({
    required T Function() empty,
    required T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value) condition,
    required T Function(String operator, List<TriggerExpression> expressions) logical,
  });

  T maybeWhen<T>({
    T Function()? empty,
    T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value)? condition,
    T Function(String operator, List<TriggerExpression> expressions)? logical,
    required T Function() orElse,
  });
}

class EmptyExpression extends TriggerExpression {
  const EmptyExpression();

  @override
  T when<T>({
    required T Function() empty,
    required T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value) condition,
    required T Function(String operator, List<TriggerExpression> expressions) logical,
  }) => empty();

  @override
  T maybeWhen<T>({
    T Function()? empty,
    T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value)? condition,
    T Function(String operator, List<TriggerExpression> expressions)? logical,
    required T Function() orElse,
  }) => empty?.call() ?? orElse();
}

class ConditionExpression extends TriggerExpression {
  final AssetType assetType;
  final String property;
  final TriggerOperator operator;
  final TriggerValue value;

  const ConditionExpression({
    required this.assetType,
    required this.property,
    required this.operator,
    required this.value,
  });

  @override
  T when<T>({
    required T Function() empty,
    required T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value) condition,
    required T Function(String operator, List<TriggerExpression> expressions) logical,
  }) => condition(assetType, property, operator, value);

  @override
  T maybeWhen<T>({
    T Function()? empty,
    T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value)? condition,
    T Function(String operator, List<TriggerExpression> expressions)? logical,
    required T Function() orElse,
  }) => condition?.call(assetType, property, operator, value) ?? orElse();
}

class LogicalExpression extends TriggerExpression {
  final String operator;
  final List<TriggerExpression> expressions;

  const LogicalExpression({
    required this.operator,
    required this.expressions,
  });

  @override
  T when<T>({
    required T Function() empty,
    required T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value) condition,
    required T Function(String operator, List<TriggerExpression> expressions) logical,
  }) => logical(operator, expressions);

  @override
  T maybeWhen<T>({
    T Function()? empty,
    T Function(AssetType assetType, String property, TriggerOperator operator, TriggerValue value)? condition,
    T Function(String operator, List<TriggerExpression> expressions)? logical,
    required T Function() orElse,
  }) => logical?.call(operator, expressions) ?? orElse();
}