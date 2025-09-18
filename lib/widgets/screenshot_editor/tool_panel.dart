import 'package:flutter/material.dart';
import '../../models/editor_tool.dart';
import 'editor_constants.dart';

class ToolPanel extends StatelessWidget {
  final EditorTool selectedTool;
  final ValueChanged<EditorTool> onToolSelected;
  final bool isVerticalGuideMode;
  final VoidCallback? onGuideToolTapped;

  const ToolPanel({
    super.key,
    required this.selectedTool,
    required this.onToolSelected,
    this.isVerticalGuideMode = true,
    this.onGuideToolTapped,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Selection Tools
            _buildToolGroup(
              context,
              'Selection',
              [EditorTool.select, EditorTool.pan, EditorTool.crop, EditorTool.move],
            ),
            
            SizedBox(height: EditorConstants.spacingS),
            _buildDivider(theme),
            SizedBox(height: EditorConstants.spacingS),
            
            // Annotation Tools
            _buildToolGroup(
              context,
              'Annotations',
              [
                EditorTool.arrow,
                EditorTool.highlightRect,
                EditorTool.text,
                EditorTool.numberLabel,
                EditorTool.guide,
              ],
            ),
            
            SizedBox(height: EditorConstants.spacingS),
            _buildDivider(theme),
            SizedBox(height: EditorConstants.spacingS),
            
            // Redaction Tools
            _buildToolGroup(
              context,
              'Redaction',
              [
                EditorTool.redactBlackout,
                EditorTool.redactBlur,
                EditorTool.redactPixelate,
              ],
            ),
            
            SizedBox(height: EditorConstants.spacingM),
            _buildDivider(theme),
            SizedBox(height: EditorConstants.spacingM),
            
            // Auto-detect button
            _buildToolButton(
            context,
            icon: Icons.auto_awesome,
            tooltip: 'Auto-detect Sensitive Info',
            onPressed: () {
              // TODO: Implement auto-detection
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Auto-detection coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            backgroundColor: theme.colorScheme.tertiary,
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolGroup(
    BuildContext context,
    String label,
    List<EditorTool> tools,
  ) {
    return Column(
      children: tools
          .map((tool) => _buildToolButton(
                context,
                icon: _getToolIcon(tool),
                tooltip: _getToolTooltip(tool),
                isSelected: selectedTool == tool,
                onPressed: () => _handleToolPressed(tool),
              ))
          .toList(),
    );
  }

  Widget _buildToolButton(
    BuildContext context, {
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    bool isSelected = false,
    Color? backgroundColor,
  }) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: SizedBox(
        width: EditorConstants.toolButtonSize,
        height: EditorConstants.toolButtonSize,
        child: IconButton(
          onPressed: onPressed,
          icon: _buildToolIcon(icon),
          tooltip: tooltip,
          style: IconButton.styleFrom(
            backgroundColor: isSelected
                ? theme.colorScheme.primary
                : backgroundColor ?? theme.colorScheme.surface,
            foregroundColor: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(EditorConstants.borderRadiusM),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 1, // Keep thin divider
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: theme.colorScheme.outline.withOpacity(0.2),
    );
  }

  IconData _getToolIcon(EditorTool tool) {
    if (tool == EditorTool.guide) {
      // Always use horizontal_rule, but we'll rotate it for vertical guides in _buildToolIcon
      return Icons.horizontal_rule;
    }
    return tool.icon;
  }

  Widget _buildToolIcon(IconData icon) {
    // For guide tool, rotate the horizontal rule to make it vertical when in vertical mode
    if (icon == Icons.horizontal_rule && isVerticalGuideMode) {
      return Transform.rotate(
        angle: 1.5708, // 90 degrees in radians (π/2)
        child: Icon(
          icon,
          size: EditorConstants.toolButtonIconSize,
        ),
      );
    }
    
    return Icon(icon, size: EditorConstants.toolButtonIconSize);
  }

  String _getToolTooltip(EditorTool tool) {
    if (tool == EditorTool.guide) {
      final mode = isVerticalGuideMode ? 'Vertical' : 'Horizontal';
      return '$mode Guide (${tool.shortcut})';
    }
    return '${tool.displayName} (${tool.shortcut})';
  }

  void _handleToolPressed(EditorTool tool) {
    if (tool == EditorTool.guide && selectedTool == EditorTool.guide) {
      // If guide tool is already selected, toggle mode
      onGuideToolTapped?.call();
    } else {
      // Normal tool selection
      onToolSelected(tool);
    }
  }
}