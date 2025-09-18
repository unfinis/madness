import 'package:flutter/material.dart';
import '../constants/responsive_breakpoints.dart';

class UnifiedSummaryWidget extends StatelessWidget {
  final String title;
  final List<SummaryItemData> items;
  final bool compact;
  final EdgeInsets? padding;

  const UnifiedSummaryWidget({
    super.key,
    required this.title,
    required this.items,
    this.compact = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = ResponsiveBreakpoints.isDesktop(screenWidth);
    
    return Card(
      child: Padding(
        padding: padding ?? EdgeInsets.all(compact ? 8.0 : (isDesktop ? 16.0 : 12.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!compact && title.isNotEmpty) ...[
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
            ],
            _buildResponsiveLayout(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.maxWidth;
        
        if (availableWidth > 1000) {
          return _buildGrid(context, _calculateGridColumns(availableWidth), 3.5);
        } else if (availableWidth > 600) {
          return _buildGrid(context, _calculateGridColumns(availableWidth), 2.8);
        } else if (availableWidth > 400) {
          return _buildGrid(context, 2, 3.0);
        } else {
          return _buildVerticalLayout(context);
        }
      },
    );
  }

  int _calculateGridColumns(double width) {
    if (items.length <= 2) return items.length;
    if (width > 1200) return (items.length > 4) ? 4 : items.length;
    if (width > 900) return (items.length > 3) ? 3 : items.length;
    return 2;
  }

  Widget _buildGrid(BuildContext context, int crossAxisCount, double childAspectRatio) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: compact ? 8 : 12,
        mainAxisSpacing: compact ? 8 : 12,
        childAspectRatio: compact ? 4.0 : childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildSummaryItem(context, items[index]),
    );
  }

  Widget _buildVerticalLayout(BuildContext context) {
    return Column(
      children: items.map((item) => Padding(
        padding: EdgeInsets.only(bottom: compact ? 8 : 12),
        child: _buildSummaryItem(context, item),
      )).toList(),
    );
  }

  Widget _buildSummaryItem(BuildContext context, SummaryItemData item) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.all(compact ? 6 : 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            item.color.withOpacity(0.08),
            item.color.withOpacity(0.03),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: item.color.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: item.color.withOpacity(0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(compact ? 3 : 4),
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                  size: compact ? 10 : 14,
                ),
              ),
              if (compact)
                Expanded(
                  child: Text(
                    item.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
          SizedBox(height: compact ? 3 : 6),
          Text(
            item.value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: item.color,
              fontSize: compact ? 12 : 16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          if (!compact) ...[
            const SizedBox(height: 2),
            Text(
              item.label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class SummaryItemData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const SummaryItemData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}