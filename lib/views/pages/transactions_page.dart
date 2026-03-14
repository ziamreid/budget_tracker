import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/models/transaction.dart';
import 'package:my_first_app/views/pages/home_page.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/data/budget_provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _filter = 'all'; // all, income, expense
  int _selectedMonth = -1; // -1 = current

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final year = now.year;
    final month = _selectedMonth < 0 ? now.month : _selectedMonth;

    return Consumer<BudgetProvider>(
      builder: (context, provider, _) {
        var list = provider.transactionsForMonth(year, month);
        if (_filter == 'income') list = list.where((t) => t.amount > 0).toList();
        if (_filter == 'expense') list = list.where((t) => t.amount < 0).toList();

        return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: widget.embedded
          ? null
          : AppBar(
              title: const Text('Transactions'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
      body: Column(
        children: [
          _buildFilters(context, theme, isDark),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final t = list[index];
                return _TransactionListTile(transaction: t, provider: provider, isDark: isDark);
              },
            ),
          ),
        ],
      ),
    );
      },
    );
  }

  Widget _buildFilters(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _chip('All', _filter == 'all', () => setState(() => _filter = 'all'), isDark),
                const SizedBox(width: 8),
                _chip('Income', _filter == 'income', () => setState(() => _filter = 'income'), isDark),
                const SizedBox(width: 8),
                _chip('Expenses', _filter == 'expense', () => setState(() => _filter = 'expense'), isDark),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _monthChip('This month', _selectedMonth < 0, () => setState(() => _selectedMonth = -1), isDark),
                ...List.generate(3, (i) {
                  final d = DateTime(DateTime.now().year, DateTime.now().month - 1 - i, 1);
                  final isSelected = _selectedMonth == d.month;
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _monthChip(
                      DateFormat('MMM yyyy').format(d),
                      isSelected,
                      () => setState(() => _selectedMonth = d.month),
                      isDark,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool selected, VoidCallback onTap, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? KConstants.primary : (isDark ? KConstants.cardDark : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(20),
            border: selected ? null : Border.all(color: isDark ? Colors.white12 : Colors.black12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }

  Widget _monthChip(String label, bool selected, VoidCallback onTap, bool isDark) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? KConstants.primary.withValues(alpha: 0.2) : (isDark ? KConstants.cardDark : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: selected ? KConstants.primary : (isDark ? Colors.white70 : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}

class _TransactionListTile extends StatelessWidget {
  const _TransactionListTile({required this.transaction, required this.provider, required this.isDark});

  final BudgetTransaction transaction;
  final BudgetProvider provider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cat = provider.getCategoryById(transaction.categoryId);
    final isIncome = transaction.amount > 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? KConstants.cardDark : KConstants.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.06)) : null,
          boxShadow: isDark ? null : [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cat.color.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(cat.icon, size: 24, color: cat.color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cat.name} · ${DateFormat('MMM d, yyyy').format(transaction.date)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              '${isIncome ? '+' : '−'}${HomePage.formatMoney(transaction.amount)}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: isIncome ? KConstants.incomeGreen : KConstants.expenseRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
