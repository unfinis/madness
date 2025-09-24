import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';

class CommonSummaryWidget extends StatelessWidget {
  final String? title;
  final List<SummaryItem> items;
  final bool compact;

  const CommonSummaryWidget({
    super.key,
    this.title,
    required this.items,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: compact ? AppSpacing.listPadding : AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: compact 
                  ? Theme.of(context).textTheme.compactTitle
                  : Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              compact ? AppSpacing.vGapMD : AppSpacing.vGapLG,
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                
                if (availableWidth > 1200) {
                  // Very wide desktop: 4 items per row
                  return _buildGrid(4);
                } else if (availableWidth > 900) {
                  // Wide desktop: 3 items per row
                  return _buildGrid(3);
                } else if (availableWidth > 600) {
                  // Desktop/tablet: 2 items per row
                  return _buildGrid(2);
                } else {
                  // Mobile: 1 item per row
                  return _buildColumn();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(int crossAxisCount) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 3,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildSummaryCard(context, items[index]),
    );
  }

  Widget _buildColumn() {
    return Builder(
      builder: (context) => Column(
        children: items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.lg),
          child: _buildSummaryCard(context, item),
        )).toList(),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, SummaryItem item) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: item.color?.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.cardRadius),
        border: Border.all(
          color: item.color?.withValues(alpha: 0.3) ?? Colors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              if (item.icon != null) ...[
                Icon(
                  item.icon,
                  color: item.color,
                  size: AppSizes.iconLG,
                ),
                AppSpacing.hGapSM,
              ],
              Expanded(
                child: Text(
                  item.value,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: item.color,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          AppSpacing.vGapXS,
          Text(
            item.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class SummaryItem {
  final String value;
  final String label;
  final Color? color;
  final IconData? icon;

  SummaryItem({
    required this.value,
    required this.label,
    this.color,
    this.icon,
  });
}