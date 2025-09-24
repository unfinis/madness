import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/editor_tool.dart';

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
            
            // Style Preset Dropdown
            _buildStylePresetDropdown(context, theme),
            const SizedBox(height: 12),
            
            // Tool-specific properties
            ..._buildToolProperties(context, theme),
            
            const SizedBox(height: 12),
            
            // Severity Presets
            if (selectedTool.isAnnotationTool) ...[
              Text(
                'Severity Presets',
                style: theme.textTheme.labelMedium,
              ),
              const SizedBox(height: 8),
              _buildSeverityPresets(context, theme),
            ],
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
      _buildColorPicker(
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
            child: TextField(
              controller: TextEditingController(
                text: (currentNumberLabelValue ?? settings['number'] ?? 1).toString(),
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
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
      _buildColorPicker(
        context,
        theme,
        'Text Color',
        toolConfig.primaryColor,
        (color) => onConfigChanged(toolConfig.copyWith(primaryColor: color)),
      ),
      
      const SizedBox(height: 8),
      
      // Background Color
      _buildColorPicker(
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
      _buildColorPicker(
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

  Widget _buildSeverityPresets(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildPresetButton(
            context,
            theme,
            'Critical',
            Colors.red,
            () => onConfigChanged(ToolConfig.criticalPreset(selectedTool)),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _buildPresetButton(
            context,
            theme,
            'High',
            Colors.orange,
            () => onConfigChanged(ToolConfig.highPreset(selectedTool)),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _buildPresetButton(
            context,
            theme,
            'Med',
            Colors.amber,
            () => onConfigChanged(ToolConfig.mediumPreset(selectedTool)),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _buildPresetButton(
            context,
            theme,
            'Low',
            Colors.green,
            () => onConfigChanged(ToolConfig.lowPreset(selectedTool)),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetButton(
    BuildContext context,
    ThemeData theme,
    String label,
    Color color,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 4),
        backgroundColor: color.withValues(alpha: 0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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

  Widget _buildColorPicker(
    BuildContext context,
    ThemeData theme,
    String label,
    Color currentColor,
    ValueChanged<Color> onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.labelMedium,
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () => _showColorPicker(context, currentColor, onChanged),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: currentColor == Colors.transparent ? Colors.white : currentColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
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
            child: GridView.builder(
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

  Widget _buildStylePresetDropdown(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Style Preset',
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: 'default',
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
          items: const [
            DropdownMenuItem(value: 'default', child: Text('Default')),
            DropdownMenuItem(value: 'highlight-red', child: Text('Highlight - Red')),
            DropdownMenuItem(value: 'highlight-yellow', child: Text('Highlight - Yellow')),
            DropdownMenuItem(value: 'professional', child: Text('Professional')),
            DropdownMenuItem(value: 'minimal', child: Text('Minimal')),
            DropdownMenuItem(value: 'custom', child: Text('Custom...')),
          ],
          onChanged: (value) {
            if (value != null) {
              _applyStylePreset(value);
            }
          },
        ),
      ],
    );
  }

  void _applyStylePreset(String preset) {
    ToolConfig newConfig;
    
    switch (preset) {
      case 'highlight-red':
        newConfig = toolConfig.copyWith(
          primaryColor: const Color(0xFFDC2626),
          strokeWidth: selectedTool == EditorTool.text ? 1.0 : 3.0,
        );
        break;
      case 'highlight-yellow':
        newConfig = toolConfig.copyWith(
          primaryColor: const Color(0xFFEAB308),
          strokeWidth: selectedTool == EditorTool.text ? 1.0 : 2.5,
        );
        break;
      case 'professional':
        newConfig = toolConfig.copyWith(
          primaryColor: const Color(0xFF1F2937),
          strokeWidth: selectedTool == EditorTool.text ? 1.0 : 2.0,
        );
        break;
      case 'minimal':
        newConfig = toolConfig.copyWith(
          primaryColor: const Color(0xFF6B7280),
          strokeWidth: selectedTool == EditorTool.text ? 1.0 : 1.5,
        );
        break;
      case 'default':
      default:
        newConfig = ToolConfig(tool: selectedTool);
        break;
    }
    
    onConfigChanged(newConfig);
  }
}