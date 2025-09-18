import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/expense.dart';
import '../database/database.dart';
import 'database_provider.dart';

enum ExpenseFilter {
  all,
  billable,
  personal,
  thisMonth,
  lastMonth,
  travel,
  accommodation,
  food,
  equipment,
  other,
}

class ExpenseFilters {
  final Set<ExpenseFilter> activeFilters;
  final String searchQuery;

  ExpenseFilters({
    Set<ExpenseFilter>? activeFilters,
    this.searchQuery = '',
  }) : activeFilters = activeFilters ?? {ExpenseFilter.all};

  ExpenseFilters copyWith({
    Set<ExpenseFilter>? activeFilters,
    String? searchQuery,
  }) {
    return ExpenseFilters(
      activeFilters: activeFilters ?? this.activeFilters,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  bool get showAll => activeFilters.contains(ExpenseFilter.all);
  bool get showBillable => activeFilters.contains(ExpenseFilter.billable) || showAll;
  bool get showPersonal => activeFilters.contains(ExpenseFilter.personal) || showAll;
  bool get hasSearch => searchQuery.isNotEmpty;
}

class ExpenseNotifier extends StateNotifier<List<Expense>> {
  final MadnessDatabase _database;
  final String _projectId;

  ExpenseNotifier(this._database, this._projectId) : super([]) {
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final expenses = await _database.getAllExpenses(_projectId);
    state = expenses;
  }

  Future<void> addExpense(Expense expense) async {
    await _database.insertExpense(expense, _projectId);
    await _loadExpenses();
  }

  Future<void> updateExpense(Expense expense) async {
    await _database.updateExpense(expense, _projectId);
    await _loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _database.deleteExpense(id);
    await _loadExpenses();
  }
}

class ExpenseFiltersNotifier extends StateNotifier<ExpenseFilters> {
  ExpenseFiltersNotifier() : super(ExpenseFilters());

  void toggleFilter(ExpenseFilter filter) {
    final currentFilters = Set<ExpenseFilter>.from(state.activeFilters);
    
    if (filter == ExpenseFilter.all) {
      state = ExpenseFilters(activeFilters: {ExpenseFilter.all});
      return;
    }

    if (currentFilters.contains(filter)) {
      currentFilters.remove(filter);
      if (currentFilters.isEmpty) {
        currentFilters.add(ExpenseFilter.all);
      }
    } else {
      currentFilters.remove(ExpenseFilter.all);
      currentFilters.add(filter);
    }
    
    state = ExpenseFilters(activeFilters: currentFilters);
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void clearFilters() {
    state = ExpenseFilters();
  }
}

final expenseProvider = StateNotifierProvider.family<ExpenseNotifier, List<Expense>, String>((ref, projectId) {
  final database = ref.read(databaseProvider);
  return ExpenseNotifier(database, projectId);
});

final expenseFiltersProvider = StateNotifierProvider.family<ExpenseFiltersNotifier, ExpenseFilters, String>((ref, projectId) {
  return ExpenseFiltersNotifier();
});

final filteredExpensesProvider = Provider.family<List<Expense>, String>((ref, projectId) {
  final expenses = ref.watch(expenseProvider(projectId));
  final filters = ref.watch(expenseFiltersProvider(projectId));
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month, 1);
  final lastMonth = DateTime(now.year, now.month - 1, 1);

  var filtered = expenses.where((expense) {
    // Search filter
    if (filters.hasSearch) {
      final query = filters.searchQuery.toLowerCase();
      final matchesSearch = expense.description.toLowerCase().contains(query) ||
          (expense.notes?.toLowerCase().contains(query) ?? false) ||
          expense.amount.toString().contains(query) ||
          expense.type.displayName.toLowerCase().contains(query) ||
          expense.category.displayName.toLowerCase().contains(query);
      
      if (!matchesSearch) return false;
    }

    // Category filters
    if (filters.showAll) return true;

    bool matchesType = true;
    if (filters.activeFilters.contains(ExpenseFilter.billable)) {
      matchesType = expense.type == ExpenseType.billable;
    } else if (filters.activeFilters.contains(ExpenseFilter.personal)) {
      matchesType = expense.type == ExpenseType.personal;
    }

    bool matchesPeriod = true;
    if (filters.activeFilters.contains(ExpenseFilter.thisMonth)) {
      matchesPeriod = expense.date.isAfter(thisMonth);
    } else if (filters.activeFilters.contains(ExpenseFilter.lastMonth)) {
      matchesPeriod = expense.date.isAfter(lastMonth) && expense.date.isBefore(thisMonth);
    }

    bool matchesCategory = true;
    if (filters.activeFilters.contains(ExpenseFilter.travel)) {
      matchesCategory = expense.category == ExpenseCategory.travel;
    } else if (filters.activeFilters.contains(ExpenseFilter.accommodation)) {
      matchesCategory = expense.category == ExpenseCategory.accommodation;
    } else if (filters.activeFilters.contains(ExpenseFilter.food)) {
      matchesCategory = expense.category == ExpenseCategory.food;
    } else if (filters.activeFilters.contains(ExpenseFilter.equipment)) {
      matchesCategory = expense.category == ExpenseCategory.equipment;
    } else if (filters.activeFilters.contains(ExpenseFilter.other)) {
      matchesCategory = expense.category == ExpenseCategory.other;
    }

    return matchesType && matchesPeriod && matchesCategory;
  }).toList();

  // Sort by date (most recent first)
  filtered.sort((a, b) => b.date.compareTo(a.date));
  
  return filtered;
});

final expenseSummaryProvider = Provider.family<Map<String, double>, String>((ref, projectId) {
  final expenses = ref.watch(expenseProvider(projectId));
  final now = DateTime.now();
  final thisMonth = DateTime(now.year, now.month, 1);

  double totalAmount = 0;
  double billableAmount = 0;
  double personalAmount = 0;
  int thisMonthCount = 0;

  for (final expense in expenses) {
    totalAmount += expense.amount;
    
    if (expense.type == ExpenseType.billable) {
      billableAmount += expense.amount;
    } else {
      personalAmount += expense.amount;
    }

    if (expense.date.isAfter(thisMonth)) {
      thisMonthCount++;
    }
  }

  return {
    'total': totalAmount,
    'billable': billableAmount,
    'personal': personalAmount,
    'thisMonthCount': thisMonthCount.toDouble(),
  };
});