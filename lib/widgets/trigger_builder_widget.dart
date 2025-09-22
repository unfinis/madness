import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/methodology_trigger_builder.dart';
import '../models/asset.dart';
import '../constants/app_spacing.dart';

class TriggerBuilderWidget extends ConsumerStatefulWidget {
  final MethodologyTriggerDefinition? initialTrigger;
  final Function(MethodologyTriggerDefinition) onTriggerChanged;

  const TriggerBuilderWidget({
    super.key,
    this.initialTrigger,
    required this.onTriggerChanged,
  });

  @override
  ConsumerState<TriggerBuilderWidget> createState() => _TriggerBuilderWidgetState();
}

class _TriggerBuilderWidgetState extends ConsumerState<TriggerBuilderWidget> {
  late MethodologyTriggerDefinition currentTrigger;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentTrigger = widget.initialTrigger ?? MethodologyTriggerDefinition.empty();
    _nameController.text = currentTrigger.name;
    _descriptionController.text = currentTrigger.description;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTrigger() {
    currentTrigger = currentTrigger.copyWith(
      name: _nameController.text,
      description: _descriptionController.text,
    );
    widget.onTriggerChanged(currentTrigger);
  }

  void _addConditionGroup() {
    setState(() {
      currentTrigger = currentTrigger.copyWith(
        conditionGroups: [
          ...currentTrigger.conditionGroups,
          TriggerGroup.empty(),
        ],
      );
    });
    _updateTrigger();
  }

  void _removeConditionGroup(int index) {
    setState(() {
      final groups = List<TriggerGroup>.from(currentTrigger.conditionGroups);
      groups.removeAt(index);
      currentTrigger = currentTrigger.copyWith(conditionGroups: groups);
    });
    _updateTrigger();
  }

  void _updateConditionGroup(int index, TriggerGroup group) {
    setState(() {
      final groups = List<TriggerGroup>.from(currentTrigger.conditionGroups);
      groups[index] = group;
      currentTrigger = currentTrigger.copyWith(conditionGroups: groups);
    });
    _updateTrigger();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTriggerInfo(),
        const SizedBox(height: AppSpacing.lg),
        _buildTriggerPreview(),
        const SizedBox(height: AppSpacing.lg),
        _buildConditionGroups(),
        const SizedBox(height: AppSpacing.md),
        _buildAddGroupButton(),
        const SizedBox(height: AppSpacing.lg),
        _buildTemplateSection(),
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Trigger Name',
                hintText: 'e.g., SMB Credential Attack',
              ),
              onChanged: (_) => _updateTrigger(),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Describe when this trigger should activate',
              ),
              maxLines: 2,
              onChanged: (_) => _updateTrigger(),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Text('Priority: '),
                DropdownButton<int>(
                  value: currentTrigger.priority,
                  items: List.generate(10, (i) => i + 1)
                      .map((priority) => DropdownMenuItem(
                            value: priority,
                            child: Text(priority.toString()),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        currentTrigger = currentTrigger.copyWith(priority: value);
                      });
                      _updateTrigger();
                    }
                  },
                ),
                const SizedBox(width: AppSpacing.lg),
                Text('Enabled: '),
                Switch(
                  value: currentTrigger.enabled,
                  onChanged: (value) {
                    setState(() {
                      currentTrigger = currentTrigger.copyWith(enabled: value);
                    });
                    _updateTrigger();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTriggerPreview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trigger Preview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                _generateTriggerPreview(),
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateTriggerPreview() {
    if (currentTrigger.conditionGroups.isEmpty) {
      return 'ON [no conditions defined]';
    }

    final groupTexts = currentTrigger.conditionGroups.map((group) {
      final conditionTexts = group.conditions.map((condition) {
        final valueText = condition.value.when(
          string: (value) => value,
          number: (value) => value.toString(),
          boolean: (value) => value.toString(),
          list: (values) => '[${values.join(', ')}]',
          isNull: () => 'NULL',
          notNull: () => 'NOT NULL',
        );

        return '${condition.property} ${condition.operator.name.toUpperCase()} $valueText';
      }).join(' ${group.logicalOperator} ');

      return group.conditions.length > 1 ? '($conditionTexts)' : conditionTexts;
    }).join(' ${currentTrigger.groupLogicalOperator} ');

    return 'ON $groupTexts';
  }

  Widget _buildConditionGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trigger Conditions',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        if (currentTrigger.conditionGroups.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No conditions defined',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Click "Add Condition Group" to start building your trigger',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ...currentTrigger.conditionGroups.asMap().entries.map((entry) {
            final index = entry.key;
            final group = entry.value;
            return Column(
              children: [
                if (index > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                          child: DropdownButton<String>(
                            value: currentTrigger.groupLogicalOperator,
                            items: ['AND', 'OR'].map((op) => DropdownMenuItem(
                              value: op,
                              child: Text(op),
                            )).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  currentTrigger = currentTrigger.copyWith(
                                    groupLogicalOperator: value,
                                  );
                                });
                                _updateTrigger();
                              }
                            },
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                _buildConditionGroup(index, group),
              ],
            );
          }).toList(),
      ],
    );
  }

  Widget _buildConditionGroup(int groupIndex, TriggerGroup group) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Condition Group ${groupIndex + 1}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _removeConditionGroup(groupIndex),
                  tooltip: 'Remove group',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ...group.conditions.asMap().entries.map((entry) {
              final condIndex = entry.key;
              final condition = entry.value;
              return Column(
                children: [
                  if (condIndex > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      child: Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            child: DropdownButton<String>(
                              value: group.logicalOperator,
                              items: ['AND', 'OR'].map((op) => DropdownMenuItem(
                                value: op,
                                child: Text(op),
                              )).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  final updatedGroup = group.copyWith(logicalOperator: value);
                                  _updateConditionGroup(groupIndex, updatedGroup);
                                }
                              },
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                    ),
                  _buildCondition(groupIndex, condIndex, condition),
                ],
              );
            }).toList(),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: () => _addCondition(groupIndex),
              icon: const Icon(Icons.add),
              label: const Text('Add Condition'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCondition(int groupIndex, int condIndex, TriggerCondition condition) {
    final assetProperties = AssetPropertyDefinition.getPropertiesForAssetType(condition.assetType);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Condition ${condIndex + 1}'),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => _removeCondition(groupIndex, condIndex),
                tooltip: 'Remove condition',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<AssetType>(
                  value: condition.assetType,
                  decoration: const InputDecoration(labelText: 'Asset Type'),
                  items: AssetType.values.map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toUpperCase()),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateCondition(groupIndex, condIndex, condition.copyWith(
                        assetType: value,
                        property: AssetPropertyDefinition.getPropertiesForAssetType(value).first.name,
                      ));
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: condition.property,
                  decoration: const InputDecoration(labelText: 'Property'),
                  items: assetProperties.map((prop) => DropdownMenuItem(
                    value: prop.name,
                    child: Text(prop.displayName),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateCondition(groupIndex, condIndex, condition.copyWith(property: value));
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<TriggerOperator>(
                  value: condition.operator,
                  decoration: const InputDecoration(labelText: 'Operator'),
                  items: TriggerOperator.values.map((op) => DropdownMenuItem(
                    value: op,
                    child: Text(op.symbol),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _updateCondition(groupIndex, condIndex, condition.copyWith(operator: value));
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          _buildValueInput(groupIndex, condIndex, condition),
        ],
      ),
    );
  }

  Widget _buildValueInput(int groupIndex, int condIndex, TriggerCondition condition) {
    final property = AssetPropertyDefinition.getPropertiesForAssetType(condition.assetType)
        .firstWhere((p) => p.name == condition.property);

    if (condition.operator == TriggerOperator.isNull || condition.operator == TriggerOperator.isNotNull) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text('No value required for ${condition.operator.symbol} operator'),
      );
    }

    switch (property.type) {
      case PropertyType.string:
        return _buildStringValueInput(groupIndex, condIndex, condition, property);
      case PropertyType.number:
        return _buildNumberValueInput(groupIndex, condIndex, condition);
      case PropertyType.boolean:
        return _buildBooleanValueInput(groupIndex, condIndex, condition);
      case PropertyType.list:
        return _buildListValueInput(groupIndex, condIndex, condition, property);
    }
  }

  Widget _buildStringValueInput(int groupIndex, int condIndex, TriggerCondition condition, AssetProperty property) {
    final currentValue = condition.value.maybeWhen(
      string: (value) => value,
      orElse: () => '',
    );

    if (property.allowedValues?.isNotEmpty == true) {
      return DropdownButtonFormField<String>(
        value: property.allowedValues!.contains(currentValue) ? currentValue : null,
        decoration: const InputDecoration(labelText: 'Value'),
        items: [
          const DropdownMenuItem(value: null, child: Text('-- Select Value --')),
          ...property.allowedValues!.map((value) => DropdownMenuItem(
            value: value,
            child: Text(value),
          )),
        ],
        onChanged: (value) {
          if (value != null) {
            _updateCondition(groupIndex, condIndex, condition.copyWith(
              value: TriggerValue.string(value),
            ));
          }
        },
      );
    }

    return TextFormField(
      initialValue: currentValue,
      decoration: const InputDecoration(labelText: 'Value'),
      onChanged: (value) {
        _updateCondition(groupIndex, condIndex, condition.copyWith(
          value: TriggerValue.string(value),
        ));
      },
    );
  }

  Widget _buildNumberValueInput(int groupIndex, int condIndex, TriggerCondition condition) {
    final currentValue = condition.value.maybeWhen(
      number: (value) => value.toString(),
      orElse: () => '',
    );

    return TextFormField(
      initialValue: currentValue,
      decoration: const InputDecoration(labelText: 'Value'),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final numValue = double.tryParse(value);
        if (numValue != null) {
          _updateCondition(groupIndex, condIndex, condition.copyWith(
            value: TriggerValue.number(numValue),
          ));
        }
      },
    );
  }

  Widget _buildBooleanValueInput(int groupIndex, int condIndex, TriggerCondition condition) {
    final currentValue = condition.value.maybeWhen(
      boolean: (value) => value,
      orElse: () => false,
    );

    return DropdownButtonFormField<bool>(
      value: currentValue,
      decoration: const InputDecoration(labelText: 'Value'),
      items: const [
        DropdownMenuItem(value: true, child: Text('True')),
        DropdownMenuItem(value: false, child: Text('False')),
      ],
      onChanged: (value) {
        if (value != null) {
          _updateCondition(groupIndex, condIndex, condition.copyWith(
            value: TriggerValue.boolean(value),
          ));
        }
      },
    );
  }

  Widget _buildListValueInput(int groupIndex, int condIndex, TriggerCondition condition, AssetProperty property) {
    final currentValues = condition.value.maybeWhen(
      list: (values) => values,
      orElse: () => <String>[],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Values (one per line):'),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: currentValues.join('\n'),
          decoration: const InputDecoration(
            hintText: 'Enter values, one per line',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          onChanged: (value) {
            final values = value.split('\n').where((v) => v.trim().isNotEmpty).toList();
            _updateCondition(groupIndex, condIndex, condition.copyWith(
              value: TriggerValue.list(values),
            ));
          },
        ),
      ],
    );
  }

  void _addCondition(int groupIndex) {
    final group = currentTrigger.conditionGroups[groupIndex];
    final updatedGroup = group.copyWith(
      conditions: [
        ...group.conditions,
        TriggerCondition(
          id: 'condition_${DateTime.now().millisecondsSinceEpoch}',
          assetType: AssetType.host,
          property: 'hostname',
          operator: TriggerOperator.equals,
          value: const TriggerValue.string(''),
        ),
      ],
    );
    _updateConditionGroup(groupIndex, updatedGroup);
  }

  void _removeCondition(int groupIndex, int condIndex) {
    final group = currentTrigger.conditionGroups[groupIndex];
    final conditions = List<TriggerCondition>.from(group.conditions);
    conditions.removeAt(condIndex);
    final updatedGroup = group.copyWith(conditions: conditions);
    _updateConditionGroup(groupIndex, updatedGroup);
  }

  void _updateCondition(int groupIndex, int condIndex, TriggerCondition condition) {
    final group = currentTrigger.conditionGroups[groupIndex];
    final conditions = List<TriggerCondition>.from(group.conditions);
    conditions[condIndex] = condition;
    final updatedGroup = group.copyWith(conditions: conditions);
    _updateConditionGroup(groupIndex, updatedGroup);
  }

  Widget _buildAddGroupButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _addConditionGroup,
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('Add Condition Group'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Templates',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: TriggerTemplate.getAllTemplates().map((template) {
                return ActionChip(
                  label: Text(template.name),
                  onPressed: () => _applyTemplate(template),
                  tooltip: template.description,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _applyTemplate(TriggerTemplate template) {
    setState(() {
      currentTrigger = template.trigger.copyWith(
        id: currentTrigger.id,
        name: _nameController.text.isEmpty ? template.name : _nameController.text,
        description: _descriptionController.text.isEmpty ? template.description : _descriptionController.text,
        priority: currentTrigger.priority,
        enabled: currentTrigger.enabled,
      );
      _nameController.text = currentTrigger.name;
      _descriptionController.text = currentTrigger.description;
    });
    _updateTrigger();
  }
}