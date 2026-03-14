class Budget {
  const Budget({
    required this.id,
    required this.categoryId,
    required this.limit,
    required this.period,
    required this.spent,
  });

  final String id;
  final String categoryId;
  final double limit;
  final String period; // 'monthly', 'weekly'
  final double spent;

  double get remaining => (limit - spent).clamp(0, double.infinity);
  double get progress => limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
  bool get isOverBudget => spent >= limit;

  Budget copyWith({
    String? id,
    String? categoryId,
    double? limit,
    String? period,
    double? spent,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      limit: limit ?? this.limit,
      period: period ?? this.period,
      spent: spent ?? this.spent,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'budgetLimit': limit,
      'period': period,
      'spent': spent,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      categoryId: map['categoryId'],
      limit: map['budgetLimit'],
      period: map['period'],
      spent: map['spent'],
    );
  }
}
