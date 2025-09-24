import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

/// A data class representing a perspective/tab
class PerspectiveTab {
  final String name;
  final IconData icon;
  final Widget content;

  const PerspectiveTab({
    required this.name,
    required this.icon,
    required this.content,
  });
}

/// A reusable widget that creates tabbed perspectives for data organization
class PerspectiveTabView extends StatefulWidget {
  final List<PerspectiveTab> tabs;
  final Widget? header; // Optional header content above tabs (like stats bar)
  final Widget? filters; // Optional filter section

  const PerspectiveTabView({
    super.key,
    required this.tabs,
    this.header,
    this.filters,
  });

  @override
  State<PerspectiveTabView> createState() => _PerspectiveTabViewState();
}

class _PerspectiveTabViewState extends State<PerspectiveTabView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Optional header (stats, summary, etc.)
          if (widget.header != null) ...[
            widget.header!,
            const Divider(height: 1),
          ],

          // Optional filters
          if (widget.filters != null) ...[
            widget.filters!,
            const Divider(height: 1),
          ],

          // Tab bar
          Material(
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: widget.tabs.map((tab) => Tab(
                icon: Icon(tab.icon),
                text: tab.name,
              )).toList(),
            ),
          ),
          const Divider(height: 1),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: widget.tabs.map((tab) => tab.content).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

/// A standardized empty state widget for perspective tabs
class PerspectiveEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const PerspectiveEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            const SizedBox(height: AppSpacing.lg),
            IconButton.filled(
              onPressed: onAction,
              icon: const Icon(Icons.add),
              tooltip: actionLabel,
              iconSize: 32,
            ),
          ],
        ],
      ),
    );
  }
}