import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/task_model.dart';
import '../widgets/recording_overlay.dart';
import 'ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isRecording = false;

  void _startRecording() {
    setState(() => _isRecording = true);
  }

  void _stopRecording() {
    setState(() => _isRecording = false);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AiChatScreen()));
  }

  void _cancelRecording() {
    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tasks = context.watch<TaskProvider>();
    final app = context.watch<AppProvider>();

    final urgentTasks = tasks.allTasks
        .where((t) => t.priority == TaskPriority.high)
        .toList();

    return Scaffold(
      backgroundColor: colors.bg,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 100),
            children: [
              // Header: Logo & Title
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://i.pravatar.cc/150?u=concierge',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'The Digital Concierge',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.auto_awesome_outlined,
                    color: colors.textPrimary,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Greeting
              Text(
                'Almost there,\n${app.userName}.',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your morning summary is ready.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),

              // Smart Insight Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C2D),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'SMART INSIGHT',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppTheme.accentIndigo.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'You have ${urgentTasks.length} priority tasks today. Start with your meeting with Sarah?',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.textPrimary,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentIndigo,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Yes, open details',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Maybe later',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: colors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Focus Area Section
              Row(
                children: [
                  Text(
                    'Focus Area',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Focus Task Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppTheme.accentIndigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Meeting with Sarah',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: colors.textMuted),
                  ],
                ),
              ),
            ],
          ),

          // Voice / Floating Action Button
          Positioned(
            bottom: 30,
            right: 24,
            child: GestureDetector(
              onTap: _startRecording,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [AppTheme.accentIndigo, AppTheme.accentViolet],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accentIndigo.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.mic_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),

          // Recording Overlay
          if (_isRecording) RecordingOverlay(onCancel: _cancelRecording),
        ],
      ),
    );
  }
}
