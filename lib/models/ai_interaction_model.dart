import 'package:uuid/uuid.dart';

enum MessageRole { user, assistant }

class AiMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  AiMessage({
    String? id,
    required this.content,
    required this.role,
    DateTime? timestamp,
  })  : id = id ?? const Uuid().v4(),
        timestamp = timestamp ?? DateTime.now();
}

class AiInteraction {
  final String id;
  final String title;
  final String summary;
  final List<AiMessage> messages;
  final DateTime createdAt;
  final String category;

  AiInteraction({
    String? id,
    required this.title,
    required this.summary,
    List<AiMessage>? messages,
    DateTime? createdAt,
    this.category = 'General',
  })  : id = id ?? const Uuid().v4(),
        messages = messages ?? [],
        createdAt = createdAt ?? DateTime.now();
}
