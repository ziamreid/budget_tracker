import 'package:flutter/material.dart';

enum TransactionType { income, expense }

class BudgetCategory {
  const BudgetCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final TransactionType type;

  BudgetCategory copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
    TransactionType? type,
  }) {
    return BudgetCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon.codePoint,
      'color': color.value,
      'type': type.index,
    };
  }

  factory BudgetCategory.fromMap(Map<String, dynamic> map) {
    return BudgetCategory(
      id: map['id'],
      name: map['name'],
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      color: Color(map['color']),
      type: TransactionType.values[map['type']],
    );
  }
}
