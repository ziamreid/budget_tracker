import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/models/transaction.dart';
import 'package:my_first_app/views/pages/transactions_page.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/data/budget_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final now = DateTime.now();
        final monthIncome = provider.incomeForMonth(now.year, now.month);
        final monthExpense = provider.expenseForMonth(now.year, now.month);
        final balance = monthIncome - monthExpense;
        final categorySpending = provider.expenseByCategoryForMonth(now.year, now.month);
        final recent = provider.transactions.take(8).toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(theme, isDark),
              const SizedBox(height: 24),
              _buildBalanceCard(context, theme, isDark, balance, monthIncome, monthExpense),
              const SizedBox(height: 28),
              _buildSectionTitle(context, 'Spending by category', onSeeAll: () => _openTransactions(context)),
              const SizedBox(height: 14),
              _buildCategoryChart(context, theme, provider, isDark, categorySpending),
              const SizedBox(height: 28),
              _buildSectionTitle(context, 'Recent transactions', onSeeAll: () => _openTransactions(context)),
              const SizedBox(height: 14),
              _buildRecentList(context, theme, provider, isDark, recent),
              const SizedBox(height: 28),
              _buildBudgetsPreview(context, theme, provider, isDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGreeting(ThemeData theme, bool isDark) {
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: theme.textTheme.titleMedium?.copyWith(
            color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your financial overview',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.2,
            fontSize: 26,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(BuildContext context, ThemeData theme, bool isDark, double balance, double income, double expense) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark ? KConstants.balanceGradientColors : KConstants.balanceGradientColorsLight,
    );

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: KConstants.primary.withValues(alpha: isDark ? 0.25 : 0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Gradient background
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(gradient: gradient),
              ),
            ),
            // Subtle radial glow
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CURRENT BALANCE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          DateFormat('MMM yyyy').format(DateTime.now()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    (balance < 0 ? '− ' : '') + formatMoney(balance),
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      height: 1.1,
                      color: balance >= 0 ? Colors.white : const Color(0xFFFF6B6B),
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: _balanceMiniCard(
                          'Income',
                          income,
                          Icons.south_west_rounded,
                          const Color(0xFFA7F3D0),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _balanceMiniCard(
                          'Expenses',
                          expense,
                          Icons.north_east_rounded,
                          const Color(0xFFFECACA),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceMiniCard(String label, double value, IconData icon, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            formatMoney(value),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, {VoidCallback? onSeeAll}) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: KConstants.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            style: TextButton.styleFrom(
              foregroundColor: KConstants.primary,
            ),
            child: const Text('See all'),
          ),
      ],
    );
  }

  Widget _buildCategoryChart(BuildContext context, ThemeData theme, BudgetProvider provider, bool isDark, Map<String, double> categorySpending) {
    if (categorySpending.isEmpty) {
      return Container(
        height: 180,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: 0.03) : Colors.black.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Text(
          'No spending this month',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
          ),
        ),
      );
    }

    final entries = categorySpending.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final total = entries.fold<double>(0, (s, e) => s + e.value);
    final top = entries.take(6).toList();
    final colors = [
      KConstants.primary,
      const Color(0xFFF59E0B),
      const Color(0xFFEC4899),
      const Color(0xFF6366F1),
      const Color(0xFF06B6D4),
      const Color(0xFF84CC16),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? KConstants.cardDark : KConstants.cardLight,
        borderRadius: BorderRadius.circular(22),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.06)) : null,
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 140,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 36,
                  sections: List.generate(
                    top.length,
                    (i) => PieChartSectionData(
                      value: top[i].value,
                      color: colors[i % colors.length],
                      radius: 24,
                      showTitle: false,
                    ),
                  ),
                ),
                duration: const Duration(milliseconds: 400),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                top.length,
                (i) {
                  final cat = provider.getCategoryById(top[i].key);
                  final pct = total > 0 ? (top[i].value / total * 100) : 0.0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: colors[i % colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cat.name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${pct.toStringAsFixed(0)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentList(BuildContext context, ThemeData theme, BudgetProvider provider, bool isDark, List<BudgetTransaction> recent) {
    return Column(
      children: recent.map((t) => _TransactionTile(transaction: t, provider: provider, isDark: isDark)).toList(),
    );
  }

  Widget _buildBudgetsPreview(BuildContext context, ThemeData theme, BudgetProvider provider, bool isDark) {
    final budgets = provider.budgets.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 22,
              decoration: BoxDecoration(
                color: KConstants.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Budget goals',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...budgets.map((b) {
          final cat = provider.getCategoryById(b.categoryId);
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Container(
              padding: const EdgeInsets.all(18),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: cat.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(cat.icon, size: 20, color: cat.color),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          cat.name,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        '${formatMoney(b.spent)} / ${formatMoney(b.limit)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: b.isOverBudget ? KConstants.expenseRed : (isDark ? KConstants.textMutedDark : KConstants.textMutedLight),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: b.progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        b.isOverBudget ? KConstants.expenseRed : KConstants.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  void _openTransactions(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const TransactionsPage()),
    );
  }

  static String formatMoney(double value) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: value.truncateToDouble() == value ? 0 : 2).format(value.abs());
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.transaction, required this.provider, required this.isDark});

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
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, yyyy').format(transaction.date),
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
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

