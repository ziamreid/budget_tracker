import 'package:flutter/material.dart';
import 'package:my_first_app/data/database_helper.dart';
import 'package:my_first_app/data/models/budget.dart';
import 'package:my_first_app/data/models/category.dart';
import 'package:my_first_app/data/models/transaction.dart';
import 'package:my_first_app/data/dummy_data.dart';
import 'package:uuid/uuid.dart';

class BudgetProvider extends ChangeNotifier {
  List<BudgetCategory> _categories = [];
  List<BudgetTransaction> _transactions = [];
  List<Budget> _budgets = [];

  bool _isLoading = true;

  List<BudgetCategory> get categories => _categories;
  List<BudgetTransaction> get transactions => _transactions;
  List<Budget> get budgets => _budgets;
  bool get isLoading => _isLoading;

  BudgetProvider() {
    _initData();
  }

  Future<void> _initData() async {
    _isLoading = true;
    notifyListeners();

    // Load from DB
    _categories = await DatabaseHelper.instance.getCategories();
    _transactions = await DatabaseHelper.instance.getTransactions();
    _budgets = await DatabaseHelper.instance.getBudgets();

    // If DB is empty, seed it with dummy data for the first time
    if (_categories.isEmpty && _transactions.isEmpty) {
      for (var cat in DummyData.categories) {
        await DatabaseHelper.instance.insertCategory(cat);
      }
      for (var trans in DummyData.transactions) {
        await DatabaseHelper.instance.insertTransaction(trans);
      }
      for (var budget in DummyData.budgets) {
        await DatabaseHelper.instance.insertOrUpdateBudget(budget);
      }

      _categories = await DatabaseHelper.instance.getCategories();
      _transactions = await DatabaseHelper.instance.getTransactions();
      _budgets = await DatabaseHelper.instance.getBudgets();
    }

    _sortTransactions();
    _isLoading = false;
    notifyListeners();
  }

  void _sortTransactions() {
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  Future<void> addTransaction(BudgetTransaction transaction) async {
    await DatabaseHelper.instance.insertTransaction(transaction);
    _transactions.add(transaction);
    _sortTransactions();
    notifyListeners();
  }

  Future<void> deleteTransaction(String id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  Future<void> addCategory(BudgetCategory category) async {
    await DatabaseHelper.instance.insertCategory(category);
    _categories.add(category);
    notifyListeners();
  }

  BudgetCategory getCategoryById(String id) {
    return _categories.firstWhere((c) => c.id == id,
        orElse: () => _categories.first);
  }

  // Analytics Helpers
  double get totalIncome {
    return _transactions.where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalExpense {
    return _transactions.where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  double get balance => totalIncome - totalExpense;

  List<BudgetTransaction> transactionsForMonth(int year, int month) {
    return _transactions.where((t) => t.date.year == year && t.date.month == month).toList();
  }

  double incomeForMonth(int year, int month) {
    return transactionsForMonth(year, month).where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
  }

  double expenseForMonth(int year, int month) {
    return transactionsForMonth(year, month).where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  Map<String, double> expenseByCategoryForMonth(int year, int month) {
    final map = <String, double>{};
    for (final t in transactionsForMonth(year, month)) {
      if (t.amount < 0) {
        map[t.categoryId] = (map[t.categoryId] ?? 0) + t.amount.abs();
      }
    }
    return map;
  }
}
