class BudgetTransaction {
  const BudgetTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.categoryId,
    required this.date,
    this.note,
  });

  final String id;
  final String title;
  final double amount;
  final String categoryId;
  final DateTime date;
  final String? note;

  bool get isIncome => amount > 0;
  bool get isExpense => amount < 0;

  BudgetTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? categoryId,
    DateTime? date,
    String? note,
  }) {
    return BudgetTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'categoryId': categoryId,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory BudgetTransaction.fromMap(Map<String, dynamic> map) {
    return BudgetTransaction(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      categoryId: map['categoryId'],
      date: DateTime.parse(map['date']),
      note: map['note'],
    );
  }
}
