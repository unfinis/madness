import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/scope.dart';
import '../providers/scope_provider.dart';
import '../dialogs/add_scope_item_dialog.dart';

class ScopeSegmentCardWidget extends ConsumerStatefulWidget {
  final ScopeSegment segment;

  const ScopeSegmentCardWidget({
    super.key,
    required this.segment,
  });

  @override
  ConsumerState<ScopeSegmentCardWidget> createState() => _ScopeSegmentCardWidgetState();
}

class _ScopeSegmentCardWidgetState extends ConsumerState<ScopeSegmentCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          _buildSegmentHeader(),
          if (_isExpanded) _buildItemsTable(),
        ],
      ),
    );
  }

  Widget _buildSegmentHeader() {
    final statusColor = _getStatusColor(widget.segment.status);
    final typeColor = _getTypeColor(widget.segment.type);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: typeColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.segment.type.icon, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      widget.segment.type.displayName,
                      style: TextStyle(
                        color: typeColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(widget.segment.status.icon, style: const TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      widget.segment.status.displayName,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _buildActionButtons(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.segment.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (widget.segment.description != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.segment.description!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (widget.segment.startDate != null) ...[
                Icon(
                  Icons.schedule_rounded,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  'Started: ${DateFormat('dd/MM/yyyy').format(widget.segment.startDate!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
              ],
              Icon(
                Icons.list_alt_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                '${widget.segment.totalItemsCount} items',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                ),
                label: Text(_isExpanded ? 'Hide Items' : 'Show Items'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => _addItemToSegment(),
          icon: const Icon(Icons.add_rounded),
          tooltip: 'Add Item',
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
            padding: const EdgeInsets.all(8),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => _editSegment(),
          icon: const Icon(Icons.edit_rounded),
          tooltip: 'Edit Segment',
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            padding: const EdgeInsets.all(8),
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () => _deleteSegment(),
          icon: const Icon(Icons.delete_rounded),
          tooltip: 'Delete Segment',
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer,
            foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
            padding: const EdgeInsets.all(8),
          ),
        ),
      ],
    );
  }

  Widget _buildItemsTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          if (widget.segment.items.isEmpty)
            _buildEmptyItemsState()
          else
            _buildItemsList(),
        ],
      ),
    );
  }

  Widget _buildEmptyItemsState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No scope items yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to define the testing scope for this segment',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _addItemToSegment(),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add First Item'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width - 80,
        ),
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.surfaceContainer,
          ),
          columns: const [
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Target')),
            DataColumn(label: Text('Description')),
            DataColumn(label: Text('Date Added')),
            DataColumn(label: Text('Actions')),
          ],
          rows: widget.segment.items.map((item) => _buildItemRow(item)).toList(),
        ),
      ),
    );
  }

  DataRow _buildItemRow(ScopeItem item) {
    final itemTypeColor = _getItemTypeColor(item.type);
    
    return DataRow(
      cells: [
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: itemTypeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: itemTypeColor.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(item.type.icon, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text(
                  item.type.displayName,
                  style: TextStyle(
                    color: itemTypeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          SelectableText(
            item.target,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        DataCell(
          Text(
            item.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Text(DateFormat('dd/MM/yyyy').format(item.dateAdded)),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.type == ScopeItemType.url) ...[
                IconButton(
                  onPressed: () => _testScopeItem(item),
                  icon: const Icon(Icons.link_rounded),
                  tooltip: 'Test URL',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              if (item.type == ScopeItemType.domain) ...[
                IconButton(
                  onPressed: () => _scanScopeItem(item),
                  icon: const Icon(Icons.search_rounded),
                  tooltip: 'Scan Domain',
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.red.withOpacity(0.1),
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.all(4),
                    minimumSize: const Size(32, 32),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              IconButton(
                onPressed: () => _editScopeItem(item),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Edit Item',
                style: IconButton.styleFrom(
                  padding: const EdgeInsets.all(4),
                  minimumSize: const Size(32, 32),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                onPressed: () => _deleteScopeItem(item),
                icon: const Icon(Icons.delete_rounded),
                tooltip: 'Delete Item',
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.errorContainer,
                  foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                  padding: const EdgeInsets.all(4),
                  minimumSize: const Size(32, 32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(ScopeSegmentStatus status) {
    switch (status) {
      case ScopeSegmentStatus.active:
        return Colors.green;
      case ScopeSegmentStatus.planned:
        return Colors.orange;
      case ScopeSegmentStatus.completed:
        return Colors.blue;
      case ScopeSegmentStatus.onHold:
        return Colors.grey;
    }
  }

  Color _getTypeColor(ScopeSegmentType type) {
    switch (type) {
      case ScopeSegmentType.external:
        return Theme.of(context).colorScheme.primary;
      case ScopeSegmentType.internal:
        return Theme.of(context).colorScheme.secondary;
      case ScopeSegmentType.webapp:
        return Theme.of(context).colorScheme.tertiary;
      case ScopeSegmentType.wireless:
        return Colors.purple;
      case ScopeSegmentType.mobile:
        return Colors.indigo;
      case ScopeSegmentType.api:
        return Colors.cyan;
      case ScopeSegmentType.cloud:
        return Colors.lightBlue;
      case ScopeSegmentType.activeDirectory:
        return Colors.deepOrange;
      case ScopeSegmentType.iot:
        return Colors.teal;
    }
  }

  Color _getItemTypeColor(ScopeItemType type) {
    switch (type) {
      case ScopeItemType.url:
        return Colors.blue;
      case ScopeItemType.domain:
        return Colors.green;
      case ScopeItemType.ipRange:
        return Colors.orange;
      case ScopeItemType.host:
        return Colors.purple;
      case ScopeItemType.network:
        return Colors.teal;
    }
  }

  void _addItemToSegment() {
    showDialog(
      context: context,
      builder: (context) => AddScopeItemDialog(
        segmentId: widget.segment.id,
        segmentTitle: widget.segment.title,
      ),
    );
  }

  void _editSegment() {
    // TODO: Implement edit segment dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit segment dialog not yet implemented')),
    );
  }

  void _deleteSegment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Segment'),
        content: Text('Are you sure you want to delete "${widget.segment.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(scopeProvider.notifier).deleteSegment(widget.segment.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Segment deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _testScopeItem(ScopeItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Testing ${item.target}...')),
    );
  }

  void _scanScopeItem(ScopeItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Scanning ${item.target}...')),
    );
  }

  void _editScopeItem(ScopeItem item) {
    // TODO: Implement edit item dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit item dialog not yet implemented')),
    );
  }

  void _deleteScopeItem(ScopeItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.target}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(scopeProvider.notifier).deleteItemFromSegment(widget.segment.id, item.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Item deleted successfully')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}