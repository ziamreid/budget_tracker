import 'package:flutter/material.dart';
import 'package:my_first_app/data/models/budget.dart';
import 'package:my_first_app/data/models/category.dart';
import 'package:my_first_app/data/models/transaction.dart';

class DummyData {
  DummyData._();

  static final List<BudgetCategory> categories = [
    const BudgetCategory(
      id: 'cat_salary',
      name: 'Salary',
      icon: Icons.account_balance_wallet,
      color: Color(0xFF10B981),
      type: TransactionType.income,
    ),
    const BudgetCategory(
      id: 'cat_freelance',
      name: 'Freelance',
      icon: Icons.laptop_mac,
      color: Color(0xFF06B6D4),
      type: TransactionType.income,
    ),
    const BudgetCategory(
      id: 'cat_investments',
      name: 'Investments',
      icon: Icons.trending_up,
      color: Color(0xFF8B5CF6),
      type: TransactionType.income,
    ),
    const BudgetCategory(
      id: 'cat_other_income',
      name: 'Other Income',
      icon: Icons.add_circle_outline,
      color: Color(0xFF14B8A6),
      type: TransactionType.income,
    ),
    const BudgetCategory(
      id: 'cat_food',
      name: 'Food & Dining',
      icon: Icons.restaurant,
      color: Color(0xFFF59E0B),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_groceries',
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: Color(0xFF84CC16),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_transport',
      name: 'Transport',
      icon: Icons.directions_car,
      color: Color(0xFF3B82F6),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_rent',
      name: 'Rent & Utilities',
      icon: Icons.home,
      color: Color(0xFF6366F1),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_entertainment',
      name: 'Entertainment',
      icon: Icons.movie,
      color: Color(0xFFEC4899),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_shopping',
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: Color(0xFFF43F5E),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_health',
      name: 'Health',
      icon: Icons.favorite,
      color: Color(0xFFEF4444),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_subscriptions',
      name: 'Subscriptions',
      icon: Icons.subscriptions,
      color: Color(0xFFA855F7),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_education',
      name: 'Education',
      icon: Icons.school,
      color: Color(0xFF0EA5E9),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_travel',
      name: 'Travel',
      icon: Icons.flight,
      color: Color(0xFF2DD4BF),
      type: TransactionType.expense,
    ),
    const BudgetCategory(
      id: 'cat_personal',
      name: 'Personal Care',
      icon: Icons.spa,
      color: Color(0xFFFB923C),
      type: TransactionType.expense,
    ),
  ];

  static BudgetCategory categoryById(String id) {
    return categories.firstWhere((c) => c.id == id);
  }

  static final List<BudgetTransaction> transactions = [
    // Income - Current month
    BudgetTransaction(id: 't1', title: 'Monthly Salary', amount: 5200.00, categoryId: 'cat_salary', date: DateTime(2025, 3, 1)),
    BudgetTransaction(id: 't2', title: 'Freelance - Web Project', amount: 1200.00, categoryId: 'cat_freelance', date: DateTime(2025, 3, 5)),
    BudgetTransaction(id: 't3', title: 'Dividend Payout', amount: 85.50, categoryId: 'cat_investments', date: DateTime(2025, 3, 10)),
    BudgetTransaction(id: 't4', title: 'Side Gig - Consulting', amount: 450.00, categoryId: 'cat_freelance', date: DateTime(2025, 3, 12)),
    BudgetTransaction(id: 't5', title: 'Tax Refund', amount: 320.00, categoryId: 'cat_other_income', date: DateTime(2025, 3, 14)),
    // Expenses - Current month
    BudgetTransaction(id: 't6', title: 'Rent Payment', amount: -1450.00, categoryId: 'cat_rent', date: DateTime(2025, 3, 1)),
    BudgetTransaction(id: 't7', title: 'Electric Bill', amount: -89.00, categoryId: 'cat_rent', date: DateTime(2025, 3, 3)),
    BudgetTransaction(id: 't8', title: 'Whole Foods', amount: -127.45, categoryId: 'cat_groceries', date: DateTime(2025, 3, 2)),
    BudgetTransaction(id: 't9', title: 'Trader Joe\'s', amount: -68.32, categoryId: 'cat_groceries', date: DateTime(2025, 3, 6)),
    BudgetTransaction(id: 't10', title: 'Uber to Office', amount: -24.50, categoryId: 'cat_transport', date: DateTime(2025, 3, 4)),
    BudgetTransaction(id: 't11', title: 'Gas Station', amount: -52.00, categoryId: 'cat_transport', date: DateTime(2025, 3, 7)),
    BudgetTransaction(id: 't12', title: 'Netflix', amount: -15.99, categoryId: 'cat_subscriptions', date: DateTime(2025, 3, 8)),
    BudgetTransaction(id: 't13', title: 'Spotify', amount: -10.99, categoryId: 'cat_subscriptions', date: DateTime(2025, 3, 8)),
    BudgetTransaction(id: 't14', title: 'Lunch - Chipotle', amount: -14.20, categoryId: 'cat_food', date: DateTime(2025, 3, 4)),
    BudgetTransaction(id: 't15', title: 'Coffee Shop', amount: -6.50, categoryId: 'cat_food', date: DateTime(2025, 3, 5)),
    BudgetTransaction(id: 't16', title: 'Dinner - Italian Restaurant', amount: -67.80, categoryId: 'cat_food', date: DateTime(2025, 3, 9)),
    BudgetTransaction(id: 't17', title: 'Amazon - Headphones', amount: -129.99, categoryId: 'cat_shopping', date: DateTime(2025, 3, 5)),
    BudgetTransaction(id: 't18', title: 'Gym Membership', amount: -45.00, categoryId: 'cat_health', date: DateTime(2025, 3, 1)),
    BudgetTransaction(id: 't19', title: 'Pharmacy', amount: -28.50, categoryId: 'cat_health', date: DateTime(2025, 3, 11)),
    BudgetTransaction(id: 't20', title: 'Movie Tickets', amount: -32.00, categoryId: 'cat_entertainment', date: DateTime(2025, 3, 8)),
    BudgetTransaction(id: 't21', title: 'Concert Tickets', amount: -95.00, categoryId: 'cat_entertainment', date: DateTime(2025, 3, 13)),
    BudgetTransaction(id: 't22', title: 'Online Course - Udemy', amount: -24.99, categoryId: 'cat_education', date: DateTime(2025, 3, 10)),
    BudgetTransaction(id: 't23', title: 'Haircut', amount: -35.00, categoryId: 'cat_personal', date: DateTime(2025, 3, 12)),
    BudgetTransaction(id: 't24', title: 'Target - Household', amount: -78.45, categoryId: 'cat_shopping', date: DateTime(2025, 3, 11)),
    BudgetTransaction(id: 't25', title: 'Parking Downtown', amount: -18.00, categoryId: 'cat_transport', date: DateTime(2025, 3, 14)),
    // Previous month
    BudgetTransaction(id: 't26', title: 'Monthly Salary', amount: 5200.00, categoryId: 'cat_salary', date: DateTime(2025, 2, 1)),
    BudgetTransaction(id: 't27', title: 'Freelance', amount: 800.00, categoryId: 'cat_freelance', date: DateTime(2025, 2, 15)),
    BudgetTransaction(id: 't28', title: 'Rent', amount: -1450.00, categoryId: 'cat_rent', date: DateTime(2025, 2, 1)),
    BudgetTransaction(id: 't29', title: 'Groceries', amount: -312.00, categoryId: 'cat_groceries', date: DateTime(2025, 2, 3)),
    BudgetTransaction(id: 't30', title: 'Car Insurance', amount: -120.00, categoryId: 'cat_transport', date: DateTime(2025, 2, 5)),
    BudgetTransaction(id: 't31', title: 'Internet', amount: -65.00, categoryId: 'cat_rent', date: DateTime(2025, 2, 6)),
    BudgetTransaction(id: 't32', title: 'Restaurants', amount: -245.00, categoryId: 'cat_food', date: DateTime(2025, 2, 28)),
    BudgetTransaction(id: 't33', title: 'Spotify + Netflix', amount: -26.98, categoryId: 'cat_subscriptions', date: DateTime(2025, 2, 8)),
    BudgetTransaction(id: 't34', title: 'New Shoes', amount: -89.99, categoryId: 'cat_shopping', date: DateTime(2025, 2, 14)),
    BudgetTransaction(id: 't35', title: 'Dentist', amount: -150.00, categoryId: 'cat_health', date: DateTime(2025, 2, 20)),
    BudgetTransaction(id: 't36', title: 'Weekend Trip', amount: -380.00, categoryId: 'cat_travel', date: DateTime(2025, 2, 22)),
    // January
    BudgetTransaction(id: 't37', title: 'Salary', amount: 5200.00, categoryId: 'cat_salary', date: DateTime(2025, 1, 1)),
    BudgetTransaction(id: 't38', title: 'Bonus', amount: 1200.00, categoryId: 'cat_other_income', date: DateTime(2025, 1, 15)),
    BudgetTransaction(id: 't39', title: 'Rent', amount: -1450.00, categoryId: 'cat_rent', date: DateTime(2025, 1, 1)),
    BudgetTransaction(id: 't40', title: 'Groceries', amount: -289.00, categoryId: 'cat_groceries', date: DateTime(2025, 1, 4)),
    BudgetTransaction(id: 't41', title: 'New Year Party', amount: -120.00, categoryId: 'cat_entertainment', date: DateTime(2025, 1, 1)),
    BudgetTransaction(id: 't42', title: 'Books', amount: -45.00, categoryId: 'cat_education', date: DateTime(2025, 1, 10)),
    BudgetTransaction(id: 't43', title: 'Gym', amount: -45.00, categoryId: 'cat_health', date: DateTime(2025, 1, 1)),
    BudgetTransaction(id: 't44', title: 'Uber Eats', amount: -58.00, categoryId: 'cat_food', date: DateTime(2025, 1, 20)),
    BudgetTransaction(id: 't45', title: 'Phone Bill', amount: -72.00, categoryId: 'cat_rent', date: DateTime(2025, 1, 5)),
    BudgetTransaction(id: 't46', title: 'Coffee Monthly', amount: -95.00, categoryId: 'cat_food', date: DateTime(2025, 1, 31)),
    BudgetTransaction(id: 't47', title: 'YouTube Premium', amount: -11.99, categoryId: 'cat_subscriptions', date: DateTime(2025, 1, 8)),
    BudgetTransaction(id: 't48', title: 'Office Supplies', amount: -34.50, categoryId: 'cat_shopping', date: DateTime(2025, 1, 12)),
    BudgetTransaction(id: 't49', title: 'Bus Pass', amount: -75.00, categoryId: 'cat_transport', date: DateTime(2025, 1, 1)),
    BudgetTransaction(id: 't50', title: 'Skincare', amount: -42.00, categoryId: 'cat_personal', date: DateTime(2025, 1, 18)),
  ];

  static final List<Budget> budgets = [
    const Budget(id: 'b1', categoryId: 'cat_groceries', limit: 500.0, period: 'monthly', spent: 323.77),
    const Budget(id: 'b2', categoryId: 'cat_food', limit: 300.0, period: 'monthly', spent: 88.50),
    const Budget(id: 'b3', categoryId: 'cat_transport', limit: 200.0, period: 'monthly', spent: 94.50),
    const Budget(id: 'b4', categoryId: 'cat_entertainment', limit: 150.0, period: 'monthly', spent: 127.00),
    const Budget(id: 'b5', categoryId: 'cat_shopping', limit: 250.0, period: 'monthly', spent: 208.44),
    const Budget(id: 'b6', categoryId: 'cat_subscriptions', limit: 80.0, period: 'monthly', spent: 26.98),
  ];

  static double get totalIncome {
    return transactions.where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
  }

  static double get totalExpense {
    return transactions.where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  static double get balance => totalIncome - totalExpense;

  static List<BudgetTransaction> transactionsForMonth(int year, int month) {
    return transactions.where((t) => t.date.year == year && t.date.month == month).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<BudgetTransaction> transactionsForMonthFrom(List<BudgetTransaction> list, int year, int month) {
    return list.where((t) => t.date.year == year && t.date.month == month).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<BudgetTransaction> recentTransactions({int limit = 10}) {
    final sorted = List<BudgetTransaction>.from(transactions)..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  static List<BudgetTransaction> recentTransactionsFrom(List<BudgetTransaction> list, {int limit = 10}) {
    final sorted = List<BudgetTransaction>.from(list)..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }

  static double incomeForMonth(int year, int month) {
    return transactionsForMonth(year, month).where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
  }

  static double incomeForMonthFrom(List<BudgetTransaction> list, int year, int month) {
    return transactionsForMonthFrom(list, year, month).where((t) => t.amount > 0).fold(0.0, (sum, t) => sum + t.amount);
  }

  static double expenseForMonth(int year, int month) {
    return transactionsForMonth(year, month).where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  static double expenseForMonthFrom(List<BudgetTransaction> list, int year, int month) {
    return transactionsForMonthFrom(list, year, month).where((t) => t.amount < 0).fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  static Map<String, double> expenseByCategoryForMonth(int year, int month) {
    final map = <String, double>{};
    for (final t in transactionsForMonth(year, month)) {
      if (t.amount < 0) {
        map[t.categoryId] = (map[t.categoryId] ?? 0) + t.amount.abs();
      }
    }
    return map;
  }

  static Map<String, double> expenseByCategoryForMonthFrom(List<BudgetTransaction> list, int year, int month) {
    final map = <String, double>{};
    for (final t in transactionsForMonthFrom(list, year, month)) {
      if (t.amount < 0) {
        map[t.categoryId] = (map[t.categoryId] ?? 0) + t.amount.abs();
      }
    }
    return map;
  }
}
