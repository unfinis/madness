import 'package:flutter/material.dart';

/// A sophisticated collapsible side panel widget that supports multiple display modes:
/// 
/// **Features:**
/// - **Split View Mode**: Both panels visible with individual collapse controls
/// - **Tabbed Mode**: Single panel with tab interface  
/// - **Auto-expansion**: When one panel collapses, the other expands to fill space
/// - **Resizable width**: Drag the left edge to resize panel width
/// - **Keyboard shortcuts**: F1 (Properties), F2 (Layers), F3 (Mode Toggle)
/// - **Smooth animations**: Transitions between states
/// 
/// **Usage:**
/// ```dart
/// CollapsibleSidePanel(
///   propertiesPanel: PropertiesWidget(),
///   layersPanel: LayersWidget(),
///   keyboardShortcuts: {'toggle_properties': 'F1', 'toggle_layers': 'F2'},
/// )
/// ```

enum PanelDisplayMode {
  splitView,  // Both panels visible in split layout
  tabbed,     // Tabbed interface
}

enum PanelState {
  expanded,
  collapsed,
}

class CollapsibleSidePanel extends StatefulWidget {
  final Widget propertiesPanel;
  final Widget layersPanel;
  final String propertiesTitle;
  final String layersTitle;
  final IconData propertiesIcon;
  final IconData layersIcon;
  final double width;
  final double minWidth;
  final double maxWidth;
  final PanelDisplayMode initialMode;
  final VoidCallback? onModeChanged;
  final Map<String, String>? keyboardShortcuts;

  const CollapsibleSidePanel({
    super.key,
    required this.propertiesPanel,
    required this.layersPanel,
    this.propertiesTitle = 'Properties',
    this.layersTitle = 'Layers',
    this.propertiesIcon = Icons.tune,
    this.layersIcon = Icons.layers,
    this.width = 280,
    this.minWidth = 200,
    this.maxWidth = 400,
    this.initialMode = PanelDisplayMode.splitView,
    this.onModeChanged,
    this.keyboardShortcuts,
  });

  @override
  State<CollapsibleSidePanel> createState() => CollapsibleSidePanelState();
}

class CollapsibleSidePanelState extends State<CollapsibleSidePanel>
    with TickerProviderStateMixin {
  late PanelDisplayMode _displayMode;
  PanelState _propertiesState = PanelState.expanded;
  PanelState _layersState = PanelState.expanded;
  int _selectedTabIndex = 0;
  double _panelWidth = 280;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _displayMode = widget.initialMode;
    _panelWidth = widget.width;
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isPropertiesCollapsed => _propertiesState == PanelState.collapsed;
  bool get _isLayersCollapsed => _layersState == PanelState.collapsed;
  bool get _bothCollapsed => _isPropertiesCollapsed && _isLayersCollapsed;
  bool get _isTabMode => _displayMode == PanelDisplayMode.tabbed;

  // Public methods for external control
  void togglePropertiesPanel() => _togglePropertiesPanel();
  void toggleLayersPanel() => _toggleLayersPanel();
  void toggleDisplayMode() => _toggleDisplayMode();

  void _togglePropertiesPanel() {
    setState(() {
      if (_isTabMode) {
        _selectedTabIndex = 0;
      } else {
        _propertiesState = _isPropertiesCollapsed 
            ? PanelState.expanded 
            : PanelState.collapsed;
        
        // If both panels are collapsed, expand layers
        if (_bothCollapsed) {
          _layersState = PanelState.expanded;
        }
      }
    });
  }

  void _toggleLayersPanel() {
    setState(() {
      if (_isTabMode) {
        _selectedTabIndex = 1;
      } else {
        _layersState = _isLayersCollapsed 
            ? PanelState.expanded 
            : PanelState.collapsed;
        
        // If both panels are collapsed, expand properties
        if (_bothCollapsed) {
          _propertiesState = PanelState.expanded;
        }
      }
    });
  }

  void _toggleDisplayMode() {
    setState(() {
      _displayMode = _displayMode == PanelDisplayMode.splitView
          ? PanelDisplayMode.tabbed
          : PanelDisplayMode.splitView;
      
      // Reset panel states when switching modes
      if (_displayMode == PanelDisplayMode.tabbed) {
        _propertiesState = PanelState.expanded;
        _layersState = PanelState.expanded;
        _selectedTabIndex = 0;
      }
    });
    widget.onModeChanged?.call();
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          if (_isTabMode) ...[
            // Tab mode: show tab buttons
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      title: widget.propertiesTitle,
                      icon: widget.propertiesIcon,
                      isSelected: _selectedTabIndex == 0,
                      onTap: () => setState(() => _selectedTabIndex = 0),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: _buildTabButton(
                      title: widget.layersTitle,
                      icon: widget.layersIcon,
                      isSelected: _selectedTabIndex == 1,
                      onTap: () => setState(() => _selectedTabIndex = 1),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            // Split mode: show panel toggles
            _buildPanelToggle(
              title: widget.propertiesTitle,
              icon: widget.propertiesIcon,
              isCollapsed: _isPropertiesCollapsed,
              onTap: _togglePropertiesPanel,
            ),
            const Spacer(),
            _buildPanelToggle(
              title: widget.layersTitle,
              icon: widget.layersIcon,
              isCollapsed: _isLayersCollapsed,
              onTap: _toggleLayersPanel,
            ),
          ],
          const SizedBox(width: 8),
          // Mode toggle button
          Tooltip(
            message: _isTabMode 
                ? 'Switch to Split View${widget.keyboardShortcuts?['toggle_mode'] != null ? ' (${widget.keyboardShortcuts!['toggle_mode']})' : ''}'
                : 'Switch to Tabs${widget.keyboardShortcuts?['toggle_mode'] != null ? ' (${widget.keyboardShortcuts!['toggle_mode']})' : ''}',
            child: IconButton(
              onPressed: _toggleDisplayMode,
              icon: Icon(_isTabMode ? Icons.view_column : Icons.tab),
              iconSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isSelected
                  ? theme.colorScheme.primary
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanelToggle({
    required String title,
    required IconData icon,
    required bool isCollapsed,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isCollapsed
              ? Colors.transparent
              : theme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isCollapsed
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isCollapsed
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : theme.colorScheme.primary,
                fontWeight: isCollapsed ? FontWeight.normal : FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              isCollapsed ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              size: 14,
              color: isCollapsed
                  ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                  : theme.colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitContent() {
    if (_bothCollapsed) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    List<Widget> children = [];

    if (!_isPropertiesCollapsed) {
      children.add(
        Expanded(
          flex: _isLayersCollapsed ? 1 : 2,
          child: widget.propertiesPanel,
        ),
      );
    }

    if (!_isPropertiesCollapsed && !_isLayersCollapsed) {
      children.add(
        Container(
          height: 1,
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      );
    }

    if (!_isLayersCollapsed) {
      children.add(
        Expanded(
          flex: _isPropertiesCollapsed ? 1 : 3,
          child: widget.layersPanel,
        ),
      );
    }

    return Column(children: children);
  }

  Widget _buildTabbedContent() {
    return IndexedStack(
      index: _selectedTabIndex,
      children: [
        widget.propertiesPanel,
        widget.layersPanel,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Row(
          children: [
            // Resize handle
            if (!_bothCollapsed)
              _buildResizeHandle(theme),
            
            // Panel content
            Container(
              width: _bothCollapsed ? 48 : _panelWidth,
              color: theme.colorScheme.surfaceContainer,
              child: _bothCollapsed
                  ? _buildCollapsedIndicator()
                  : Column(
                      children: [
                        _buildHeader(),
                        Expanded(
                          child: _isTabMode
                              ? _buildTabbedContent()
                              : _buildSplitContent(),
                        ),
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResizeHandle(ThemeData theme) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _panelWidth = (_panelWidth - details.delta.dx)
                .clamp(widget.minWidth, widget.maxWidth);
          });
        },
        child: Container(
          width: 4,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 1,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedIndicator() {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: 48,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Tooltip(
            message: 'Show ${widget.propertiesTitle}${widget.keyboardShortcuts?['toggle_properties'] != null ? ' (${widget.keyboardShortcuts!['toggle_properties']})' : ''}',
            child: IconButton(
              onPressed: _togglePropertiesPanel,
              icon: Icon(widget.propertiesIcon),
              iconSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Tooltip(
            message: 'Show ${widget.layersTitle}${widget.keyboardShortcuts?['toggle_layers'] != null ? ' (${widget.keyboardShortcuts!['toggle_layers']})' : ''}',
            child: IconButton(
              onPressed: _toggleLayersPanel,
              icon: Icon(widget.layersIcon),
              iconSize: 20,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 24,
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 8),
          IconButton(
            onPressed: _toggleDisplayMode,
            icon: Icon(_isTabMode ? Icons.view_column : Icons.tab),
            tooltip: _isTabMode ? 'Switch to Split View' : 'Switch to Tabs',
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}