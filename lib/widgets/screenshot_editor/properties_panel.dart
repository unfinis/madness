import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/editor_tool.dart';
import '../../models/tool_preset.dart';

class PropertiesPanel extends StatelessWidget {
  final EditorTool selectedTool;
  final ToolConfig toolConfig;
  final ValueChanged<ToolConfig> onConfigChanged;
  final String? selectedLayerId;
  final int? currentNumberLabelValue;
  final ValueChanged<int>? onNumberLabelValueChanged;

  const PropertiesPanel({
    super.key,
    required this.selectedTool,
    required this.toolConfig,
    required this.onConfigChanged,
    this.selectedLayerId,
    this.currentNumberLabelValue,
    this.onNumberLabelValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Text(
              'Properties',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildToolSection(context, theme),
                  if (selectedLayerId != null) ...[
                    const SizedBox(height: 16),
                    _buildLayerSection(context, theme),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(selectedTool.icon, size: 16),
                const SizedBox(width: 8),
                Text(
                  selectedTool.displayName,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Tool Presets (only for tools that support them)
            if (ToolPresetManager.toolSupportsPresets(selectedTool)) ...[
              Text(
                'Presets',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              _buildToolPresets(context, theme),
              const SizedBox(height: 12),
            ],

            // Tool-specific properties
            ..._buildToolProperties(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildLayerSection(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Layer Properties',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // Opacity Slider
            _buildSlider(
              context,
              theme,
              'Opacity',
              toolConfig.opacity,
              0.0,
              1.0,
              (value) => onConfigChanged(toolConfig.copyWith(opacity: value)),
            ),
            
            const SizedBox(height: 8),
            
            // Blend Mode
            _buildDropdown<BlendMode>(
              context,
              theme,
              'Blend Mode',
              BlendMode.srcOver,
              [
                BlendMode.srcOver,
                BlendMode.multiply,
                BlendMode.overlay,
                BlendMode.screen,
                BlendMode.darken,
                BlendMode.lighten,
              ],
              (value) => {
                // TODO: Implement blend mode change
              },
              (mode) => mode.toString().split('.').last,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildToolProperties(BuildContext context, ThemeData theme) {
    switch (selectedTool) {
      case EditorTool.arrow:
        return _buildArrowToolProperties(context, theme);

      case EditorTool.highlightRect:
        return _buildVectorToolProperties(context, theme);

      case EditorTool.text:
        return _buildTextToolProperties(context, theme);

      case EditorTool.numberLabel:
        return _buildNumberLabelProperties(context, theme);

      case EditorTool.redactBlackout:
        return _buildBlackoutProperties(context, theme);

      case EditorTool.redactBlur:
        return _buildBlurProperties(context, theme);

      case EditorTool.redactPixelate:
        return _buildPixelateProperties(context, theme);

      default:
        return [];
    }
  }

  List<Widget> _buildVectorToolProperties(BuildContext context, ThemeData theme) {
    final settings = toolConfig.toolSpecificSettings;
    final bool hasFill = settings['hasFill'] ?? false; // Default to no fill
    final bool hasStroke = settings['hasStroke'] ?? true; // Default to stroke
    
    return [
      // Fill Color (with None option)
      _buildColorPickerWithNone(
        context,
        theme,
        'Fill Color',
        hasFill ? (toolConfig.secondaryColor != Colors.transparent 
            ? toolConfig.secondaryColor 
            : (selectedTool == EditorTool.highlightRect 
                ? const Color(0x88FFFF00) // Default yellow for highlights
                : toolConfig.primaryColor.withValues(alpha: 0.3))) : null,
        (color) => onConfigChanged(
          toolConfig.copyWith(
            secondaryColor: color ?? Colors.transparent,
            toolSpecificSettings: {
              ...settings,
              'hasFill': color != null,
            },
          ),
        ),
      ),
      const SizedBox(height: 12),
      
      // Stroke Color (with None option)
      _buildColorPickerWithNone(
        context,
        theme,
        'Stroke Color',
        hasStroke ? toolConfig.primaryColor : null,
        (color) => onConfigChanged(
          toolConfig.copyWith(
            primaryColor: color ?? Colors.red, // Default color when re-enabling
            toolSpecificSettings: {
              ...settings,
              'hasStroke': color != null,
            },
          ),
        ),
      ),
      const SizedBox(height: 12),
      
      // Stroke Width (only show if stroke is enabled)
      if (hasStroke) ...[
        _buildSlider(
          context,
          theme,
          'Stroke Width',
          toolConfig.strokeWidth,
          0.5,
          10.0,
          (value) => onConfigChanged(toolConfig.copyWith(strokeWidth: value)),
        ),
      ],
    ];
  }

  List<Widget> _buildTextToolProperties(BuildContext context, ThemeData theme) {
    final settings = toolConfig.toolSpecificSettings;

    return [
      // Text Color
      _buildEnhancedColorPicker(
        context,
        theme,
        'Text Color',
        toolConfig.primaryColor,
        (color) => onConfigChanged(toolConfig.copyWith(primaryColor: color)),
      ),
      
      const SizedBox(height: 8),
      
      // Font Size
      _buildSlider(
        context,
        theme,
        'Font Size',
        settings['fontSize'] ?? 16.0,
        8.0,
        48.0,
        (value) => onConfigChanged(
          toolConfig.copyWith(
            toolSpecificSettings: {
              ...settings,
              'fontSize': value,
            },
          ),
        ),
      ),
      
      const SizedBox(height: 8),
      
      // Font Weight
      Row(
        children: [
          Expanded(
            child: CheckboxListTile(
              title: const Text('Bold'),
              value: settings['bold'] ?? false,
              onChanged: (value) => onConfigChanged(
                toolConfig.copyWith(
                  toolSpecificSettings: {
                    ...settings,
                    'bold': value ?? false,
                  },
                ),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
          Expanded(
            child: CheckboxListTile(
              title: const Text('Italic'),
              value: settings['italic'] ?? false,
              onChanged: (value) => onConfigChanged(
                toolConfig.copyWith(
                  toolSpecificSettings: {
                    ...settings,
                    'italic': value ?? false,
                  },
                ),
              ),
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
          ),
        ],
      ),
    ];
  }

  List<Widget> _buildNumberLabelProperties(BuildContext context, ThemeData theme) {
    final settings = toolConfig.toolSpecificSettings;
    
    return [
      // Current Number Display and Input
      Row(
        children: [
          Text(
            'Next Number',
            style: theme.textTheme.labelMedium,
          ),
          const Spacer(),
          Container(
            width: 80,
            height: 36,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: TextField(
                controller: TextEditingController(
                  text: (currentNumberLabelValue ?? settings['number'] ?? 1).toString(),
                ),
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                onSubmitted: (value) {
                  final number = int.tryParse(value) ?? 1;
                  onNumberLabelValueChanged?.call(number);
                },
              ),
            ),
          ),
        ],
      ),
      
      const SizedBox(height: 8),
      
      // Reset Button
      OutlinedButton.icon(
        onPressed: () {
          onNumberLabelValueChanged?.call(1);
        },
        icon: const Icon(Icons.refresh, size: 16),
        label: const Text('Reset to 1'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 36),
        ),
      ),
      
      const SizedBox(height: 12),
      
      const Divider(),
      
      const SizedBox(height: 12),
      
      // Text Color
      _buildEnhancedColorPicker(
        context,
        theme,
        'Text Color',
        toolConfig.primaryColor,
        (color) => onConfigChanged(toolConfig.copyWith(primaryColor: color)),
      ),

      const SizedBox(height: 8),

      // Background Color
      _buildEnhancedColorPicker(
        context,
        theme,
        'Background',
        toolConfig.secondaryColor,
        (color) => onConfigChanged(toolConfig.copyWith(secondaryColor: color)),
      ),
      
      const SizedBox(height: 8),
      
      // Circle Size
      _buildSlider(
        context,
        theme,
        'Circle Size',
        settings['circleRadius'] ?? 16.0,
        10.0,
        30.0,
        (value) => onConfigChanged(
          toolConfig.copyWith(
            toolSpecificSettings: {
              ...settings,
              'circleRadius': value,
            },
          ),
        ),
      ),
      
      const SizedBox(height: 8),
      
      // Font Size
      _buildSlider(
        context,
        theme,
        'Font Size',
        settings['fontSize'] ?? 16.0,
        8.0,
        24.0,
        (value) => onConfigChanged(
          toolConfig.copyWith(
            toolSpecificSettings: {
              ...settings,
              'fontSize': value,
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildBlackoutProperties(BuildContext context, ThemeData theme) {
    return [
      _buildEnhancedColorPicker(
        context,
        theme,
        'Color',
        toolConfig.primaryColor,
        (color) => onConfigChanged(toolConfig.copyWith(primaryColor: color)),
      ),
    ];
  }

  List<Widget> _buildBlurProperties(BuildContext context, ThemeData theme) {
    final settings = toolConfig.toolSpecificSettings;
    
    return [
      _buildSlider(
        context,
        theme,
        'Blur Radius',
        settings['blurRadius'] ?? 10.0,
        1.0,
        50.0,
        (value) => onConfigChanged(
          toolConfig.copyWith(
            toolSpecificSettings: {
              ...settings,
              'blurRadius': value,
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPixelateProperties(BuildContext context, ThemeData theme) {
    final settings = toolConfig.toolSpecificSettings;

    return [
      _buildSlider(
        context,
        theme,
        'Pixel Size',
        (settings['pixelSize'] ?? 20).toDouble(),
        5.0,
        50.0,
        (value) => onConfigChanged(
          toolConfig.copyWith(
            toolSpecificSettings: {
              ...settings,
              'pixelSize': value.round(),
            },
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildArrowToolProperties(BuildContext context, ThemeData theme) {
    return [
      // Arrow Color
      _buildEnhancedColorPicker(
        context,
        theme,
        'Arrow Color',
        toolConfig.primaryColor,
        (color) => onConfigChanged(toolConfig.copyWith(primaryColor: color)),
      ),

      const SizedBox(height: 12),

      // Arrow Width
      _buildSlider(
        context,
        theme,
        'Arrow Width',
        toolConfig.strokeWidth,
        0.5,
        10.0,
        (value) => onConfigChanged(toolConfig.copyWith(strokeWidth: value)),
      ),
    ];
  }

  /// Gets the current preset ID based on current tool config
  String? _getCurrentPresetId(List<ToolPreset> presets) {
    // Try to find a preset that matches the current config
    for (final preset in presets) {
      if (_configsMatch(preset.config, toolConfig)) {
        return preset.id;
      }
    }
    return null; // No matching preset found
  }

  /// Checks if two configs are essentially the same for preset matching
  bool _configsMatch(ToolConfig a, ToolConfig b) {
    // Compare primary properties
    if (a.tool != b.tool) return false;
    if (a.primaryColor != b.primaryColor) return false;
    if (a.secondaryColor != b.secondaryColor) return false;
    if ((a.strokeWidth - b.strokeWidth).abs() > 0.1) return false;

    // Compare tool-specific settings for key properties
    final aSettings = a.toolSpecificSettings;
    final bSettings = b.toolSpecificSettings;

    // Check fill/stroke settings for vector tools
    if (aSettings['hasFill'] != bSettings['hasFill']) return false;
    if (aSettings['hasStroke'] != bSettings['hasStroke']) return false;

    return true;
  }

  Widget _buildToolPresets(BuildContext context, ThemeData theme) {
    final presets = ToolPresetManager.getPresetsForTool(selectedTool);
    final currentPresetId = _getCurrentPresetId(presets);

    if (presets.length <= 4) {
      // Use button layout for 4 or fewer presets
      return Row(
        children: presets.map((preset) {
          final isLast = preset == presets.last;
          final isSelected = preset.id == currentPresetId;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 4),
              child: _buildPresetButton(
                context,
                theme,
                preset.name,
                preset.previewColor ?? theme.colorScheme.primary,
                () => onConfigChanged(preset.config),
                isSelected: isSelected,
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Use dropdown for many presets
      return _buildPresetDropdown(context, theme, presets, currentPresetId);
    }
  }

  Widget _buildPresetDropdown(BuildContext context, ThemeData theme, List<ToolPreset> presets, String? currentPresetId) {
    if (presets.isEmpty) {
      return const SizedBox.shrink(); // Return empty widget if no presets
    }

    return DropdownButtonFormField<String>(
      initialValue: currentPresetId ?? presets.first.id,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surface,
      ),
      items: presets.map((preset) {
        return DropdownMenuItem(
          value: preset.id,
          child: Row(
            children: [
              if (preset.previewColor != null) ...[
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: preset.previewColor,
                    borderRadius: BorderRadius.circular(2),
                    border: Border.all(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Text(preset.name),
            ],
          ),
        );
      }).toList(),
      onChanged: (presetId) {
        if (presetId != null) {
          final preset = presets.firstWhere((p) => p.id == presetId);
          onConfigChanged(preset.config);
        }
      },
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    ThemeData theme,
    String label,
    Color color,
    VoidCallback onPressed, {
    bool isSelected = false,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4),
        backgroundColor: isSelected
          ? color.withValues(alpha: 0.2)
          : color.withValues(alpha: 0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: isSelected ? color : color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildColorPickerWithNone(
    BuildContext context,
    ThemeData theme,
    String label,
    Color? currentColor, // Nullable for "None" option
    ValueChanged<Color?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // None button
              GestureDetector(
                onTap: () => onChanged(null),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: currentColor == null ? theme.colorScheme.primary : theme.colorScheme.outline,
                      width: currentColor == null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      // Background circle to show "None"
                      Center(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      // Diagonal line through it
                      Center(
                        child: Container(
                          width: 24,
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(1),
                          ),
                          transform: Matrix4.rotationZ(-0.785398), // -45 degrees
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Color options
              ...([
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.black,
                Colors.white,
              ].map((color) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: GestureDetector(
                  onTap: () => onChanged(color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: currentColor == color ? theme.colorScheme.primary : theme.colorScheme.outline,
                        width: currentColor == color ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: color == Colors.white ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ) : null,
                  ),
                ),
              ))),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildSlider(
    BuildContext context,
    ThemeData theme,
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium,
            ),
            const Spacer(),
            Text(
              value.toStringAsFixed(1),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>(
    BuildContext context,
    ThemeData theme,
    String label,
    T value,
    List<T> options,
    ValueChanged<T?> onChanged,
    String Function(T) displayText,
  ) {
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium,
        ),
        const Spacer(),
        DropdownButton<T>(
          value: value,
          items: options.map((option) {
            return DropdownMenuItem<T>(
              value: option,
              child: Text(displayText(option)),
            );
          }).toList(),
          onChanged: onChanged,
          underline: Container(),
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  void _showColorPicker(
    BuildContext context,
    Color currentColor,
    ValueChanged<Color> onChanged,
  ) {
    // Simple color picker with predefined colors
    final colors = [
      Colors.transparent, // None option
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.black,
      Colors.white,
      Colors.grey,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Color'),
          content: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    final color = colors[index];
                    final isTransparent = color == Colors.transparent;
                    return GestureDetector(
                      onTap: () {
                        onChanged(color);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isTransparent ? Colors.white : color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.outline,
                            width: color == currentColor ? 3 : 1,
                          ),
                        ),
                        child: isTransparent
                            ? Icon(
                                Icons.close,
                                size: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showAdvancedColorPicker(context, currentColor, onChanged);
                    },
                    icon: const Icon(Icons.palette),
                    label: const Text('More Colors...'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showAdvancedColorPicker(
    BuildContext context,
    Color currentColor,
    ValueChanged<Color> onChanged,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return _AdvancedColorPickerDialog(
          initialColor: currentColor,
          onColorChanged: onChanged,
        );
      },
    );
  }

  Widget _buildEnhancedColorPicker(
    BuildContext context,
    ThemeData theme,
    String label,
    Color currentColor,
    ValueChanged<Color> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Current color display/picker
              GestureDetector(
                onTap: () => _showColorPicker(context, currentColor, onChanged),
                child: Container(
                  width: 40,
                  height: 32,
                  decoration: BoxDecoration(
                    color: currentColor == Colors.transparent ? Colors.white : currentColor,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  child: currentColor == Colors.transparent
                      ? Icon(
                          Icons.close,
                          size: 16,
                          color: theme.colorScheme.onSurface,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              // Quick color options
              ...([
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.black,
                Colors.white,
              ].map((color) => Padding(
                padding: const EdgeInsets.only(right: 4),
                child: GestureDetector(
                  onTap: () => onChanged(color),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      border: Border.all(
                        color: currentColor == color ? theme.colorScheme.primary : theme.colorScheme.outline,
                        width: currentColor == color ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: color == Colors.white ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ) : null,
                  ),
                ),
              ))),
            ],
          ),
        ),
      ],
    );
  }

}

class _AdvancedColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const _AdvancedColorPickerDialog({
    required this.initialColor,
    required this.onColorChanged,
  });

  @override
  State<_AdvancedColorPickerDialog> createState() => _AdvancedColorPickerDialogState();
}

class _AdvancedColorPickerDialogState extends State<_AdvancedColorPickerDialog> {
  late Color _currentColor;
  late double _hue;
  late double _saturation;
  late double _lightness;
  late int _red;
  late int _green;
  late int _blue;
  late int _alpha;

  final TextEditingController _hexController = TextEditingController();
  final TextEditingController _redController = TextEditingController();
  final TextEditingController _greenController = TextEditingController();
  final TextEditingController _blueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    _updateFromColor(_currentColor);
  }

  void _updateFromColor(Color color) {
    _red = (color.r * 255.0).round() & 0xff;
    _green = (color.g * 255.0).round() & 0xff;
    _blue = (color.b * 255.0).round() & 0xff;
    _alpha = (color.a * 255.0).round() & 0xff;

    final hsl = HSLColor.fromColor(color);
    _hue = hsl.hue;
    _saturation = hsl.saturation;
    _lightness = hsl.lightness;

    _hexController.text = '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    _redController.text = _red.toString();
    _greenController.text = _green.toString();
    _blueController.text = _blue.toString();
  }

  void _updateFromHSL() {
    final hslColor = HSLColor.fromAHSL(_alpha / 255.0, _hue, _saturation, _lightness);
    _currentColor = hslColor.toColor();
    _red = (_currentColor.r * 255.0).round() & 0xff;
    _green = (_currentColor.g * 255.0).round() & 0xff;
    _blue = (_currentColor.b * 255.0).round() & 0xff;
    _hexController.text = '#${_currentColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    _redController.text = _red.toString();
    _greenController.text = _green.toString();
    _blueController.text = _blue.toString();
  }

  void _updateFromRGB() {
    _currentColor = Color.fromARGB(_alpha, _red, _green, _blue);
    final hsl = HSLColor.fromColor(_currentColor);
    _hue = hsl.hue;
    _saturation = hsl.saturation;
    _lightness = hsl.lightness;
    _hexController.text = '#${_currentColor.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }

  void _updateFromHex(String hex) {
    try {
      if (hex.startsWith('#')) hex = hex.substring(1);
      if (hex.length == 6) hex = 'FF$hex';
      final value = int.parse(hex, radix: 16);
      _currentColor = Color(value);
      _updateFromColor(_currentColor);
    } catch (e) {
      // Invalid hex, ignore
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Advanced Color Picker'),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Color preview
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: _currentColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.colorScheme.outline),
              ),
            ),
            const SizedBox(height: 16),

            // Hue slider
            _buildHueSlider(theme),
            const SizedBox(height: 8),

            // Saturation slider
            _buildSlider(
              'Saturation',
              _saturation,
              0.0,
              1.0,
              (value) => setState(() {
                _saturation = value;
                _updateFromHSL();
              }),
              theme,
            ),
            const SizedBox(height: 8),

            // Lightness slider
            _buildSlider(
              'Lightness',
              _lightness,
              0.0,
              1.0,
              (value) => setState(() {
                _lightness = value;
                _updateFromHSL();
              }),
              theme,
            ),
            const SizedBox(height: 16),

            // RGB inputs
            Row(
              children: [
                Expanded(
                  child: _buildNumberField('R', _redController, 0, 255, (value) {
                    _red = value;
                    _updateFromRGB();
                  }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildNumberField('G', _greenController, 0, 255, (value) {
                    _green = value;
                    _updateFromRGB();
                  }),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildNumberField('B', _blueController, 0, 255, (value) {
                    _blue = value;
                    _updateFromRGB();
                  }),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Hex input
            TextField(
              controller: _hexController,
              decoration: const InputDecoration(
                labelText: 'Hex',
                border: OutlineInputBorder(),
                prefixText: '#',
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onChanged: (value) {
                setState(() {
                  _updateFromHex(value);
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onColorChanged(_currentColor);
            Navigator.of(context).pop();
          },
          child: const Text('Select'),
        ),
      ],
    );
  }

  Widget _buildHueSlider(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hue', style: theme.textTheme.labelMedium),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 20,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _hue,
            min: 0,
            max: 360,
            onChanged: (value) => setState(() {
              _hue = value;
              _updateFromHSL();
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
    ThemeData theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: theme.textTheme.labelMedium),
            const Spacer(),
            Text('${(value * 100).round()}%', style: theme.textTheme.bodySmall),
          ],
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildNumberField(
    String label,
    TextEditingController controller,
    int min,
    int max,
    ValueChanged<int> onChanged,
  ) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      onChanged: (value) {
        final intValue = int.tryParse(value);
        if (intValue != null && intValue >= min && intValue <= max) {
          setState(() {
            onChanged(intValue);
          });
        }
      },
    );
  }
}