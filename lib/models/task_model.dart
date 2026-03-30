import 'package:uuid/uuid.dart';

enum TaskPriority { low, medium, high }
enum TaskStatus { todo, inProgress, done }

class TaskModel {
  final String id;
  final String title;
  final String? subtitle;
  final TaskPriority priority;
  TaskStatus status;
  final DateTime createdAt;
  final String? aiTag;
  final bool hasAiInsight;

  TaskModel({
    String? id,
    required this.title,
    this.subtitle,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.todo,
    DateTime? createdAt,
    this.aiTag,
    this.hasAiInsight = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  TaskModel copyWith({
    String? title,
    String? subtitle,
    TaskPriority? priority,
    TaskStatus? status,
    String? aiTag,
    bool? hasAiInsight,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt,
      aiTag: aiTag ?? this.aiTag,
      hasAiInsight: hasAiInsight ?? this.hasAiInsight,
    );
  }
}
