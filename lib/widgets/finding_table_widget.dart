import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/finding.dart';
import '../providers/finding_provider.dart';
import '../constants/responsive_breakpoints.dart';

class FindingTableWidget extends ConsumerStatefulWidget {
  final Function(Finding)? onRowTap;
  final Function(Finding)? onRowDoubleTap;
  final Function(Finding)? onEdit;
  final Function(Finding)? onDelete;

  const FindingTableWidget({
    super.key,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  ConsumerState<FindingTableWidget> createState() => _FindingTableWidgetState();
}

class _FindingTableWidgetState extends ConsumerState<FindingTableWidget> {
  final Set<String> _selectedIds = {};
  bool _selectAll = false;

  @override
  Widget build(BuildContext context) {
    final findingState = ref.watch(findingProvider);
    final findings = findingState.filteredFindings;
    final sortConfig = findingState.sortConfig;

    if (findingState.isLoading) {
      return const Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (findingState.error != null) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading findings',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                findingState.error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (findings.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.search_off,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'No findings found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Try adjusting your search criteria or filters',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table header with bulk actions
          if (_selectedIds.isNotEmpty) _buildBulkActions(context),
          
          // Enhanced header section
          if (_selectedIds.isEmpty) _buildTableHeader(context),
          
          // Responsive table/card layout
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > ResponsiveBreakpoints.tablet) {
                return _buildDesktopTable(context, findings, sortConfig);
              } else {
                return _buildMobileCards(context, findings);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FF),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE0E0E0),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF667EEA),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.security,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Security Findings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF333333),
                  ),
                ),
                Text(
                  'Vulnerabilities and security issues discovered during assessment',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulkActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedIds.length} selected',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          TextButton.icon(
            icon: const Icon(Icons.check_circle),
            label: const Text('Mark Resolved'),
            onPressed: () => _bulkUpdateStatus(FindingStatus.resolved),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            icon: const Icon(Icons.cancel),
            label: const Text('Mark Active'),
            onPressed: () => _bulkUpdateStatus(FindingStatus.active),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            onPressed: _bulkDelete,
          ),
          const Spacer(),
          TextButton(
            onPressed: () {
              setState(() {
                _selectedIds.clear();
                _selectAll = false;
              });
            },
            child: const Text('Clear Selection'),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context, List<Finding> findings, FindingSortConfig sortConfig) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Theme(
          data: Theme.of(context).copyWith(
            dataTableTheme: DataTableThemeData(
              headingRowColor: MaterialStateProperty.all(const Color(0xFFF8F9FF)),
              dataRowColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return const Color(0xFFF0F2FF);
                }
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFFE8EBFF);
                }
                return Colors.white;
              }),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF333333),
              ),
              dataTextStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          ),
          child: DataTable(
            showCheckboxColumn: true,
            columnSpacing: 24,
            horizontalMargin: 16,
            headingRowHeight: 56,
            dataRowHeight: 72,
            columns: [
              DataColumn(
                label: Row(
                  children: [
                    const Text('Title'),
                    const SizedBox(width: 4),
                    Icon(
                      sortConfig.field == FindingSortField.title 
                        ? (sortConfig.direction == SortDirection.asc ? Icons.arrow_upward : Icons.arrow_downward)
                        : Icons.unfold_more,
                      size: 16,
                      color: const Color(0xFF667EEA),
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) => _updateSort(FindingSortField.title, ascending),
              ),
              DataColumn(
                label: Row(
                  children: [
                    const Text('Severity'),
                    const SizedBox(width: 4),
                    Icon(
                      sortConfig.field == FindingSortField.severity 
                        ? (sortConfig.direction == SortDirection.asc ? Icons.arrow_upward : Icons.arrow_downward)
                        : Icons.unfold_more,
                      size: 16,
                      color: const Color(0xFF667EEA),
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) => _updateSort(FindingSortField.severity, ascending),
              ),
              DataColumn(
                label: Row(
                  children: [
                    const Text('CVSS'),
                    const SizedBox(width: 4),
                    Icon(
                      sortConfig.field == FindingSortField.cvssScore 
                        ? (sortConfig.direction == SortDirection.asc ? Icons.arrow_upward : Icons.arrow_downward)
                        : Icons.unfold_more,
                      size: 16,
                      color: const Color(0xFF667EEA),
                    ),
                  ],
                ),
                numeric: true,
                onSort: (columnIndex, ascending) => _updateSort(FindingSortField.cvssScore, ascending),
              ),
              DataColumn(
                label: Row(
                  children: [
                    const Text('Status'),
                    const SizedBox(width: 4),
                    Icon(
                      sortConfig.field == FindingSortField.status 
                        ? (sortConfig.direction == SortDirection.asc ? Icons.arrow_upward : Icons.arrow_downward)
                        : Icons.unfold_more,
                      size: 16,
                      color: const Color(0xFF667EEA),
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) => _updateSort(FindingSortField.status, ascending),
              ),
              const DataColumn(
                label: Text('Components'),
              ),
              DataColumn(
                label: Row(
                  children: [
                    const Text('Updated'),
                    const SizedBox(width: 4),
                    Icon(
                      sortConfig.field == FindingSortField.updatedDate 
                        ? (sortConfig.direction == SortDirection.asc ? Icons.arrow_upward : Icons.arrow_downward)
                        : Icons.unfold_more,
                      size: 16,
                      color: const Color(0xFF667EEA),
                    ),
                  ],
                ),
                onSort: (columnIndex, ascending) => _updateSort(FindingSortField.updatedDate, ascending),
              ),
              const DataColumn(
                label: Text('Actions'),
              ),
            ],
        rows: findings.map((finding) {
          final isSelected = _selectedIds.contains(finding.id);
          return DataRow(
            selected: isSelected,
            onSelectChanged: (selected) => _toggleSelection(finding.id, selected ?? false),
            cells: [
              DataCell(
                GestureDetector(
                  onTap: () => widget.onRowTap?.call(finding),
                  onDoubleTap: () => widget.onRowDoubleTap?.call(finding),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            if (finding.isMainFinding) ...[
                              Icon(
                                Icons.account_tree,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                finding.title,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (finding.isMainFinding && finding.subFindings.isNotEmpty) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${finding.subFindings.length}',
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (finding.description.isNotEmpty)
                          Text(
                            finding.description,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              DataCell(_buildSeverityChip(finding.severity)),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: finding.severity.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    finding.cvssScore.toStringAsFixed(1),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: finding.severity.color,
                    ),
                  ),
                ),
              ),
              DataCell(_buildStatusChip(finding.status)),
              DataCell(
                Text(
                  finding.components.isEmpty ? '-' : '${finding.components.length} components',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              DataCell(
                Text(
                  _formatDate(finding.updatedDate),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      onPressed: () => widget.onEdit?.call(finding),
                      tooltip: 'Edit',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      onPressed: () => widget.onDelete?.call(finding),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileCards(BuildContext context, List<Finding> findings) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: findings.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: Color(0xFFE0E0E0),
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final finding = findings[index];
          final isSelected = _selectedIds.contains(finding.id);
          
          return Container(
            color: isSelected ? const Color(0xFFE8EBFF) : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16.0),
              leading: Checkbox(
                value: isSelected,
                onChanged: (selected) => _toggleSelection(finding.id, selected ?? false),
                activeColor: const Color(0xFF667EEA),
              ),
          title: Text(
            finding.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (finding.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  finding.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildSeverityChip(finding.severity),
                  const SizedBox(width: 8),
                  _buildStatusChip(finding.status),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: finding.severity.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'CVSS ${finding.cvssScore.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: finding.severity.color,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Updated ${_formatDate(finding.updatedDate)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: const Row(
                  children: [
                    Icon(Icons.edit, size: 16),
                    SizedBox(width: 8),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 16, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'edit') {
                widget.onEdit?.call(finding);
              } else if (value == 'delete') {
                widget.onDelete?.call(finding);
              }
            },
          ),
          onTap: () => widget.onRowTap?.call(finding),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeverityChip(FindingSeverity severity) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: severity.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: severity.color.withOpacity(0.3)),
      ),
      child: Text(
        severity.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: severity.color,
        ),
      ),
    );
  }

  Widget _buildStatusChip(FindingStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: status.color,
        ),
      ),
    );
  }

  void _toggleSelection(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
        _selectAll = false;
      }
    });
  }

  void _updateSort(FindingSortField field, bool ascending) {
    final newSortConfig = FindingSortConfig(
      field: field,
      direction: ascending ? SortDirection.asc : SortDirection.desc,
    );
    ref.read(findingProvider.notifier).updateSort(newSortConfig);
  }

  void _bulkUpdateStatus(FindingStatus status) {
    if (_selectedIds.isEmpty) return;
    
    ref.read(findingProvider.notifier).bulkUpdateFindings(
      _selectedIds.toList(),
      {'status': status.name},
    );
    
    setState(() {
      _selectedIds.clear();
      _selectAll = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Updated ${_selectedIds.length} findings to ${status.displayName}'),
      ),
    );
  }

  void _bulkDelete() {
    if (_selectedIds.isEmpty) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Findings'),
        content: Text('Are you sure you want to delete ${_selectedIds.length} findings? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              for (final id in _selectedIds) {
                ref.read(findingProvider.notifier).deleteFinding(id);
              }
              
              setState(() {
                _selectedIds.clear();
                _selectAll = false;
              });
              
              Navigator.of(context).pop();
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Deleted ${_selectedIds.length} findings'),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return 'Just now';
    }
  }
}