import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../dialogs/evidence_dialog.dart';

class AddExpenseDialog extends ConsumerStatefulWidget {
  final Expense? expense;
  final String projectId;

  const AddExpenseDialog({
    super.key,
    this.expense,
    required this.projectId,
  });

  @override
  ConsumerState<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends ConsumerState<AddExpenseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  ExpenseType _selectedType = ExpenseType.billable;
  ExpenseCategory _selectedCategory = ExpenseCategory.travel;
  DateTime _selectedDate = DateTime.now();
  List<EvidenceFile> _evidenceFiles = [];

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _descriptionController.text = widget.expense!.description;
      _amountController.text = widget.expense!.amount.toStringAsFixed(2);
      _notesController.text = widget.expense!.notes ?? '';
      _selectedType = widget.expense!.type;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
      _evidenceFiles = List.from(widget.expense!.evidenceFiles);
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    final screenHeight = MediaQuery.of(context).size.height;

    if (isDesktop) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: 600,
          constraints: BoxConstraints(
            maxHeight: screenHeight * 0.9,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: _buildDialogContent(context, isEditing, isDesktop),
        ),
      );
    } else {
      return Dialog.fullscreen(
        child: Scaffold(
          appBar: AppBar(
            title: Text(isEditing ? 'Edit Expense' : 'Add New Expense'),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDescriptionField(),
                  const SizedBox(height: 20),
                  
                  _buildAmountField(),
                  const SizedBox(height: 20),
                  
                  _buildDateField(),
                  const SizedBox(height: 20),
                  
                  _buildTypeDropdown(),
                  const SizedBox(height: 20),
                  
                  _buildCategoryDropdown(),
                  const SizedBox(height: 20),
                  
                  _buildNotesField(),
                  const SizedBox(height: 20),
                  
                  _buildEvidenceSection(),
                  const SizedBox(height: 32),
                  
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _saveExpense,
                      child: Text(isEditing ? 'Update Expense' : 'Add Expense'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDialogContent(BuildContext context, bool isEditing, bool isDesktop) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primaryContainer,
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.8),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isEditing ? Icons.edit_rounded : Icons.receipt_long_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Expense' : 'Add New Expense',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isEditing ? 'Update expense details' : 'Track a new business expense',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDescriptionField(),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(child: _buildAmountField()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDateField()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        Expanded(child: _buildTypeDropdown()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildCategoryDropdown()),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    _buildNotesField(),
                    const SizedBox(height: 20),
                    
                    _buildEvidenceSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: _saveExpense,
                child: Text(isEditing ? 'Update' : 'Add Expense'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description *',
        hintText: 'Enter expense description',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a description';
        }
        return null;
      },
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Amount (£) *',
        hintText: '0.00',
        border: OutlineInputBorder(),
        prefixText: '£ ',
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an amount';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Date *',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        ),
      ),
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<ExpenseType>(
      value: _selectedType,
      decoration: const InputDecoration(
        labelText: 'Type *',
        border: OutlineInputBorder(),
      ),
      items: ExpenseType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedType = value;
          });
        }
      },
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<ExpenseCategory>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(),
      ),
      items: ExpenseCategory.values.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Row(
            children: [
              Text(category.icon),
              const SizedBox(width: 8),
              Text(category.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      decoration: const InputDecoration(
        labelText: 'Notes',
        hintText: 'Additional notes (optional)',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  Widget _buildEvidenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Evidence',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _addEvidence,
          icon: const Icon(Icons.add_a_photo, size: 18),
          label: Text(_evidenceFiles.isEmpty ? 'Add Evidence' : 'Manage Evidence (${_evidenceFiles.length})'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
        if (_evidenceFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _evidenceFiles.map((evidence) => Chip(
              avatar: Text(evidence.type.icon),
              label: Text(
                evidence.fileName.length > 20 
                    ? '${evidence.fileName.substring(0, 17)}...' 
                    : evidence.fileName,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () {
                setState(() {
                  _evidenceFiles.removeWhere((e) => e.id == evidence.id);
                });
              },
            )).toList(),
          ),
        ],
      ],
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _addEvidence() async {
    await showDialog<void>(
      context: context,
      builder: (context) => EvidenceDialog(
        existingEvidence: _evidenceFiles,
        onEvidenceAdded: (evidenceList) {
          setState(() {
            _evidenceFiles = evidenceList;
          });
        },
      ),
    );
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: widget.expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        description: _descriptionController.text.trim(),
        amount: double.parse(_amountController.text),
        type: _selectedType,
        category: _selectedCategory,
        date: _selectedDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        evidenceFiles: _evidenceFiles,
      );

      if (widget.expense != null) {
        ref.read(expenseProvider(widget.projectId).notifier).updateExpense(expense);
      } else {
        ref.read(expenseProvider(widget.projectId).notifier).addExpense(expense);
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.expense != null ? 'Expense updated!' : 'Expense added!'),
        ),
      );
    }
  }
}