import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/models/category.dart';
import 'package:my_first_app/data/models/transaction.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/data/budget_provider.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  TransactionType _type = TransactionType.expense;
  BudgetCategory? _category;
  DateTime _date = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  List<BudgetCategory> _categoriesForType(BuildContext context) =>
      context.read<BudgetProvider>().categories.where((c) => c.type == _type).toList();

  @override
  void initState() {
    super.initState();
    // Delay setting default category until first build when provider is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final list = _categoriesForType(context);
      if (list.isNotEmpty) setState(() => _category = list.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add transaction'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _sectionLabel(theme, 'Type'),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _typeChip(
                    'Income',
                    TransactionType.income,
                    Icons.arrow_downward_rounded,
                    KConstants.incomeGreen,
                    isDark,
                    context,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _typeChip(
                    'Expense',
                    TransactionType.expense,
                    Icons.arrow_upward_rounded,
                    KConstants.expenseRed,
                    isDark,
                    context,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _sectionLabel(theme, 'Category'),
            const SizedBox(height: 8),
            DropdownButtonFormField<BudgetCategory>(
              value: _category,
              decoration: _inputDecoration(isDark),
              items: _categoriesForType(context)
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Row(
                          children: [
                            Icon(c.icon, size: 20, color: c.color),
                            const SizedBox(width: 10),
                            Text(c.name),
                          ],
                        ),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _category = v),
            ),
            const SizedBox(height: 20),
            _sectionLabel(theme, 'Title'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: _inputDecoration(isDark).copyWith(
                hintText: 'e.g. Grocery shopping',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter a title';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _sectionLabel(theme, 'Amount'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration(isDark).copyWith(
                hintText: '0.00',
                prefixText: '\$ ',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Enter amount';
                final n = double.tryParse(v.replaceAll(',', ''));
                if (n == null || n <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _sectionLabel(theme, 'Date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _date = picked);
              },
              borderRadius: BorderRadius.circular(14),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: isDark ? KConstants.cardDark : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.black12,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      DateFormat('EEEE, MMM d, yyyy').format(_date),
                      style: theme.textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _sectionLabel(theme, 'Note (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: _inputDecoration(isDark).copyWith(
                hintText: 'Add a note...',
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: KConstants.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _save,
                child: const Text('Save transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(ThemeData theme, String label) {
    return Text(
      label,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.brightness == Brightness.dark
            ? KConstants.textMutedDark
            : KConstants.textMutedLight,
      ),
    );
  }

  InputDecoration _inputDecoration(bool isDark) {
    return InputDecoration(
      filled: true,
      fillColor: isDark ? KConstants.cardDark : Colors.grey.shade100,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.white12 : Colors.black12,
        ),
      ),
    );
  }

  Widget _typeChip(
    String label,
    TransactionType type,
    IconData icon,
    Color color,
    bool isDark,
    BuildContext context,
  ) {
    final selected = _type == type;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() {
          _type = type;
          final list = _categoriesForType(context);
          _category = list.isNotEmpty ? list.first : null;
        }),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.2) : (isDark ? KConstants.cardDark : Colors.grey.shade100),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? color : (isDark ? Colors.white12 : Colors.black12),
              width: selected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: selected ? color : (isDark ? Colors.white70 : Colors.black54)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? color : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate() || _category == null) return;

    final amount = double.tryParse(_amountController.text.trim().replaceAll(',', '')) ?? 0;
    if (amount <= 0) return;

    final value = _type == TransactionType.income ? amount : -amount;
    final transaction = BudgetTransaction(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      amount: value,
      categoryId: _category!.id,
      date: DateTime(_date.year, _date.month, _date.day),
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    context.read<BudgetProvider>().addTransaction(transaction);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Transaction added'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: KConstants.primary,
        ),
      );
    }
  }
}
