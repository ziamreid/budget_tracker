import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import '../models/ai_interaction_model.dart';
import 'package:uuid/uuid.dart';

class AppProvider extends ChangeNotifier {
  bool _isDark = true;
  int _currentIndex = 0;
  String _userName = 'Alex Rivera';
  bool _notificationsEnabled = true;
  bool _hapticEnabled = true;
  bool _isLoggedIn = false;

  bool get isDark => _isDark;

  /// Alias for settings UI.
  bool get isDarkMode => _isDark;
  int get currentIndex => _currentIndex;
  String get userName => _userName;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get hapticEnabled => _hapticEnabled;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login() async {
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }

  AppProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('isDark') ?? true;
    _userName = prefs.getString('userName') ?? _userName;
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    _hapticEnabled = prefs.getBool('haptic') ?? true;
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', _isDark);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    notifyListeners();
  }

  Future<void> toggleHaptic() async {
    _hapticEnabled = !_hapticEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('haptic', _hapticEnabled);
    notifyListeners();
  }

  void setIndex(int i) {
    _currentIndex = i;
    notifyListeners();
  }
}

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [
    TaskModel(
      title: 'Prepare Q2 presentation',
      subtitle: 'Slides, charts, exec summary',
      priority: TaskPriority.high,
      aiTag: 'AI Suggested',
      hasAiInsight: true,
      status: TaskStatus.inProgress,
    ),
    TaskModel(
      title: 'Review design system tokens',
      subtitle: 'Color, typography, spacing',
      priority: TaskPriority.medium,
      aiTag: 'Design',
      hasAiInsight: false,
      status: TaskStatus.todo,
    ),
    TaskModel(
      title: 'Send weekly team update',
      subtitle: 'Slack + email digest',
      priority: TaskPriority.low,
      status: TaskStatus.todo,
    ),
    TaskModel(
      title: 'Finalize API contract',
      subtitle: 'Authentication endpoints',
      priority: TaskPriority.high,
      aiTag: 'Engineering',
      hasAiInsight: true,
      status: TaskStatus.done,
    ),
    TaskModel(
      title: 'Plan user research sessions',
      subtitle: 'Schedule 5 interviews',
      priority: TaskPriority.medium,
      aiTag: 'Research',
      hasAiInsight: false,
      status: TaskStatus.todo,
    ),
    TaskModel(
      title: 'Update onboarding flow',
      subtitle: 'Incorporate feedback from beta',
      priority: TaskPriority.high,
      aiTag: 'AI Suggested',
      hasAiInsight: true,
      status: TaskStatus.todo,
    ),
  ];

  List<TaskModel> get tasks => List.unmodifiable(_tasks);

  List<TaskModel> get allTasks => List.unmodifiable(_tasks);

  /// Tasks surfaced on Home (no due-date field yet — show recent slice).
  List<TaskModel> get todayTasks => _tasks.take(8).toList();

  List<TaskModel> get todoTasks =>
      _tasks.where((t) => t.status == TaskStatus.todo).toList();
  List<TaskModel> get inProgressTasks =>
      _tasks.where((t) => t.status == TaskStatus.inProgress).toList();
  List<TaskModel> get doneTasks =>
      _tasks.where((t) => t.status == TaskStatus.done).toList();

  int get totalCount => _tasks.length;
  int get doneCount => doneTasks.length;

  /// Placeholder until tasks have due dates — show dot on some days for UX.
  bool hasTaskOnDay(DateTime day) {
    final hash = day.year * 400 + day.month * 31 + day.day;
    return hash % 5 == 0 && _tasks.isNotEmpty;
  }

  void addTask(TaskModel task) {
    _tasks.insert(0, task);
    notifyListeners();
  }

  void toggleDone(String id) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      final t = _tasks[idx];
      _tasks[idx] = t.copyWith(
        status: t.status == TaskStatus.done ? TaskStatus.todo : TaskStatus.done,
      );
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clearAll() {
    _tasks.clear();
    notifyListeners();
  }

  void updateTaskStatus(String id, TaskStatus status) {
    final idx = _tasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _tasks[idx] = _tasks[idx].copyWith(status: status);
      notifyListeners();
    }
  }
}

class AiProvider extends ChangeNotifier {
  final List<AiMessage> _messages = [
    AiMessage(
      content:
          'Hello! I\'m your digital concierge. How can I assist you today?',
      role: MessageRole.assistant,
    ),
  ];
  bool _isTyping = false;
  bool _isRecording = false;

  List<AiMessage> get messages => List.unmodifiable(_messages);
  bool get isTyping => _isTyping;
  bool get isRecording => _isRecording;

  final List<AiInteraction> _history = [
    AiInteraction(
      title: 'Project planning ideas',
      summary: 'Discussed Q2 roadmap and prioritization',
      category: 'Planning',
      messages: [
        AiMessage(
          content: 'Help me plan Q2 roadmap',
          role: MessageRole.user,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        AiMessage(
          content:
              'Sure! Let\'s start with your top priorities. What are the key outcomes you\'re targeting in Q2?',
          role: MessageRole.assistant,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    AiInteraction(
      title: 'Email draft assistance',
      summary: 'Drafted a stakeholder update email',
      category: 'Writing',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    AiInteraction(
      title: 'Meeting preparation',
      summary: 'Key talking points for board presentation',
      category: 'Planning',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  List<AiInteraction> get history => List.unmodifiable(_history);

  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    _messages.add(AiMessage(content: content, role: MessageRole.user));
    _isTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    final replies = [
      'Great question! Let me think about that for you. Based on your priorities, I\'d suggest focusing on the high-impact tasks first.',
      'I\'ve analyzed your request. Here are my recommendations to move forward efficiently.',
      'Understood. I can help you with that. Let\'s break it down into actionable steps.',
      'That\'s an interesting challenge. Here\'s a strategic approach that could work well for your situation.',
      'I\'ve looked at the context. My suggestion would be to start with the foundational elements before moving to the details.',
    ];
    final reply = replies[_messages.length % replies.length];

    _messages.add(AiMessage(content: reply, role: MessageRole.assistant));
    _isTyping = false;
    notifyListeners();
  }

  void setRecording(bool val) {
    _isRecording = val;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _messages.add(
      AiMessage(
        content:
            'Hello! I\'m your digital concierge. How can I assist you today?',
        role: MessageRole.assistant,
      ),
    );
    notifyListeners();
  }

  /// Clears chat and conversation history (settings / toolbar).
  void clearHistory() {
    _history.clear();
    clearChat();
  }
}
