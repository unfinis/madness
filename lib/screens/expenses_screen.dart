import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../widgets/expense_item_widget.dart';
import '../widgets/expense_table_widget.dart';
import '../widgets/expense_filters_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../dialogs/add_expense_dialog.dart';
import '../dialogs/export_dialog.dart';
import '../services/import_export_service.dart';
import '../services/evidence_export_service.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  final String projectId;
  
  const ExpensesScreen({
    super.key,
    required this.projectId,
  });

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  bool _useTableView = false;
  final _importExportService = ImportExportService();
  final _evidenceExportService = EvidenceExportService();
  bool _isExporting = false;
  bool _isImporting = false;
  bool _isExportingEvidence = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = ref.watch(filteredExpensesProvider(widget.projectId));
    final screenWidth = MediaQuery.of(context).size.width;

    
    // Auto-enable table view on very wide screens
    final shouldShowTableToggle = screenWidth > 1000;
    if (screenWidth > 1400 && !_useTableView) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _useTableView = true;
          });
        }
      });
    }
    
    return ScreenWrapper(
      children: [
        _buildExpensesStatsBar(context, widget.projectId),
        SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Responsive button layout with view toggle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            if (constraints.maxWidth > 600) {
                              return Row(
                                children: [
                                  if (shouldShowTableToggle) ...[
                                    SegmentedButton<bool>(
                                      segments: const [
                                        ButtonSegment<bool>(
                                          value: false,
                                          icon: Icon(Icons.view_agenda, size: 16),
                                          label: Text('Cards'),
                                        ),
                                        ButtonSegment<bool>(
                                          value: true,
                                          icon: Icon(Icons.table_rows, size: 16),
                                          label: Text('Table'),
                                        ),
                                      ],
                                      selected: {_useTableView},
                                      onSelectionChanged: (selection) {
                                        setState(() {
                                          _useTableView = selection.first;
                                        });
                                      },
                                      style: SegmentedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    const Spacer(),
                                  ] else
                                    const Spacer(),
                                  ..._buildActionButtons(context),
                                ],
                              );
                            } else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (shouldShowTableToggle) ...[
                                    SegmentedButton<bool>(
                                      segments: const [
                                        ButtonSegment<bool>(
                                          value: false,
                                          icon: Icon(Icons.view_agenda, size: 16),
                                        ),
                                        ButtonSegment<bool>(
                                          value: true,
                                          icon: Icon(Icons.table_rows, size: 16),
                                        ),
                                      ],
                                      selected: {_useTableView},
                                      onSelectionChanged: (selection) {
                                        setState(() {
                                          _useTableView = selection.first;
                                        });
                                      },
                                      style: SegmentedButton.styleFrom(
                                        visualDensity: VisualDensity.compact,
                                      ),
                                    ),
                                    SizedBox(height: CommonLayoutWidgets.compactSpacing),
                                  ],
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _buildActionButtons(context),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: CommonLayoutWidgets.sectionSpacing),
                    
                    ExpenseFiltersWidget(
                      searchController: _searchController,
                      projectId: widget.projectId,
                    ),
                    SizedBox(height: CommonLayoutWidgets.sectionSpacing),
                    
                    if (filteredExpenses.isEmpty)
                      CommonStateWidgets.noData(
                        itemName: 'expenses',
                        icon: Icons.receipt_long_outlined,
                        onCreate: () => _showAddExpenseDialog(context),
                        createButtonText: 'Add First Expense',
                      )
                    else if (_useTableView && shouldShowTableToggle)
                      ExpenseTableWidget(expenses: filteredExpenses, projectId: widget.projectId)
                    else
                      _buildExpensesList(filteredExpenses),
                  ],
                ),
        ),
      ],
    );
  }


  List<Widget> _buildActionButtons(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth * 0.3; // Approximate available width for buttons
    
    if (availableWidth > 350) {
      // Wide enough: All buttons in a row with labels
      return [
        OutlinedButton.icon(
          onPressed: _isExporting ? null : () => _exportExpenses(context),
          icon: _isExporting 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download, size: 18),
          label: Text(_isExporting ? 'Exporting...' : 'Export'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: _isImporting ? null : () => _importExpenses(context),
          icon: _isImporting 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload, size: 18),
          label: Text(_isImporting ? 'Importing...' : 'Import'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: _isExportingEvidence ? null : () => _exportEvidence(context),
          icon: _isExportingEvidence 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.folder_zip, size: 18),
          label: Text(_isExportingEvidence ? 'Exporting...' : 'Export Evidence'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddExpenseDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else if (availableWidth > 250) {
      // Medium width: Icon buttons with tooltips + Add button
      return [
        IconButton.outlined(
          onPressed: _isExporting ? null : () => _exportExpenses(context),
          icon: _isExporting 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download, size: 18),
          tooltip: _isExporting ? 'Exporting...' : 'Export',
        ),
        const SizedBox(width: 4),
        IconButton.outlined(
          onPressed: _isImporting ? null : () => _importExpenses(context),
          icon: _isImporting 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.upload, size: 18),
          tooltip: _isImporting ? 'Importing...' : 'Import',
        ),
        const SizedBox(width: 4),
        IconButton.outlined(
          onPressed: _isExportingEvidence ? null : () => _exportEvidence(context),
          icon: _isExportingEvidence 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.folder_zip, size: 18),
          tooltip: _isExportingEvidence ? 'Exporting Evidence...' : 'Export Evidence',
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: () => _showAddExpenseDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ];
    } else {
      // Very narrow: Just essential buttons
      return [
        IconButton.outlined(
          onPressed: _isExporting ? null : () => _exportExpenses(context),
          icon: _isExporting 
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.download, size: 18),
          tooltip: _isExporting ? 'Exporting...' : 'Export',
        ),
        const SizedBox(width: 4),
        FilledButton.icon(
          onPressed: () => _showAddExpenseDialog(context),
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
        ),
      ];
    }
  }

  Widget _buildExpensesList(List<Expense> expenses) {
    final sortedExpenses = [...expenses]
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      children: sortedExpenses.asMap().entries.map((entry) {
        final index = entry.key;
        final expense = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < sortedExpenses.length - 1 ? 12 : 0),
          child: ExpenseItemWidget(expense: expense, projectId: widget.projectId),
        );
      }).toList(),
    );
  }

  void _showAddExpenseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddExpenseDialog(projectId: widget.projectId),
    );
  }

  void _exportExpenses(BuildContext context) async {
    final filteredExpenses = ref.read(filteredExpensesProvider(widget.projectId));
    
    if (filteredExpenses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No expenses to export'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ExportDialog(
        totalExpenses: filteredExpenses.length,
        onExport: () {},
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _isExporting = true;
      });

      try {
        final filePath = await _importExportService.exportExpenses(
          filteredExpenses,
          result['format'] as ExportFormat,
          customFileName: result['fileName'] as String?,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Expenses exported successfully to $filePath'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              action: SnackBarAction(
                label: 'OK',
                onPressed: () {},
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Export failed: ${e.toString()}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isExporting = false;
          });
        }
      }
    }
  }

  void _importExpenses(BuildContext context) async {
    setState(() {
      _isImporting = true;
    });

    try {
      final expenses = await _importExportService.importExpenses();
      
      if (expenses != null && expenses.isNotEmpty && mounted) {
        final expenseNotifier = ref.read(expenseProvider(widget.projectId).notifier);
        
        // Add imported expenses
        for (final expense in expenses) {
          expenseNotifier.addExpense(expense);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully imported ${expenses.length} expense${expenses.length == 1 ? '' : 's'}'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No expenses were imported'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Import failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  void _exportEvidence(BuildContext context) async {
    final filteredExpenses = ref.read(filteredExpensesProvider(widget.projectId));
    
    // Check if there are any expenses with evidence
    final expensesWithEvidence = filteredExpenses.where((expense) => expense.hasEvidence).toList();
    
    if (expensesWithEvidence.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('No evidence files found to export'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
      return;
    }

    setState(() {
      _isExportingEvidence = true;
    });

    try {
      final filePath = await _evidenceExportService.exportAllEvidence(expensesWithEvidence);

      if (mounted && filePath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Evidence exported successfully to $filePath'),
            backgroundColor: Theme.of(context).colorScheme.primary,
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Evidence export failed: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isExportingEvidence = false;
        });
      }
    }
  }

  Widget _buildExpensesStatsBar(BuildContext context, String projectId) {
    final expenses = ref.watch(filteredExpensesProvider(projectId));
    final stats = _calculateExpenseStats(expenses);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildStatChip('Total', stats.total, Icons.receipt, Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Billable', stats.billable, Icons.monetization_on, Colors.green),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Personal', stats.personal, Icons.person, Colors.blue),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Travel', stats.travel, Icons.flight, Colors.orange),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Accommodation', stats.accommodation, Icons.hotel, Colors.purple),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Food', stats.food, Icons.restaurant, Colors.red),
            const SizedBox(width: AppSpacing.sm),
            _buildStatChip('Equipment', stats.equipment, Icons.devices, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, int count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              '$label: $count',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 11,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  ExpenseStats _calculateExpenseStats(List<Expense> expenses) {
    final billable = expenses.where((e) => e.type == ExpenseType.billable).length;
    final personal = expenses.where((e) => e.type == ExpenseType.personal).length;
    final travel = expenses.where((e) => e.category == ExpenseCategory.travel).length;
    final accommodation = expenses.where((e) => e.category == ExpenseCategory.accommodation).length;
    final food = expenses.where((e) => e.category == ExpenseCategory.food).length;
    final equipment = expenses.where((e) => e.category == ExpenseCategory.equipment).length;

    return ExpenseStats(
      total: expenses.length,
      billable: billable,
      personal: personal,
      travel: travel,
      accommodation: accommodation,
      food: food,
      equipment: equipment,
    );
  }
}

class ExpenseStats {
  final int total;
  final int billable;
  final int personal;
  final int travel;
  final int accommodation;
  final int food;
  final int equipment;

  ExpenseStats({
    required this.total,
    required this.billable,
    required this.personal,
    required this.travel,
    required this.accommodation,
    required this.food,
    required this.equipment,
  });
}