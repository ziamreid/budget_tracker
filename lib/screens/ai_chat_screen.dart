import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/ai_interaction_card.dart';
import '../widgets/ai_detail_sheet.dart';
import '../widgets/recording_overlay.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _ctrl = TextEditingController();
  bool _isRecording = false;
  bool _isProcessing = false;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _isProcessing) return;
    _ctrl.clear();
    setState(() => _isProcessing = true);
    await context.read<AiProvider>().sendMessage(text);
    if (mounted) setState(() => _isProcessing = false);
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
      _isProcessing = true;
    });
    // Simulate processing
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<AiProvider>().sendMessage('[Voice transcription ready]');
        setState(() => _isProcessing = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRecording) {
      return RecordingOverlay(
        onCancel: () => setState(() => _isRecording = false),
      );
    }

    final colors = context.appColors;
    final ai = context.watch<AiProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppTheme.accentGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Ready to assist',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.read<AiProvider>().clearHistory(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: colors.border),
                      ),
                      child: Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // History list
            Expanded(
              child: ai.history.isEmpty
                  ? _EmptyState(colors: colors)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      reverse: true,
                      itemCount: ai.history.length,
                      itemBuilder: (_, i) {
                        final interaction =
                            ai.history[ai.history.length - 1 - i];
                        return AiInteractionCard(
                          interaction: interaction,
                          onTap: () => AiDetailSheet.show(context, interaction),
                        );
                      },
                    ),
            ),

            // Processing indicator
            if (_isProcessing)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.accentIndigo,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'AI is thinking...',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

            // Input bar
            _InputBar(
              controller: _ctrl,
              colors: colors,
              onSend: _sendMessage,
              onRecord: _toggleRecording,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final AppThemeData colors;
  const _EmptyState({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentIndigo, AppTheme.accentViolet],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Ask me anything',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Type a message or tap the mic',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colors.textSecondary),
          ),
          const SizedBox(height: 32),
          _SuggestionChips(),
        ],
      ),
    );
  }
}

class _SuggestionChips extends StatelessWidget {
  const _SuggestionChips();

  @override
  Widget build(BuildContext context) {
    final chips = [
      '📋 Summarize my tasks',
      '📅 What\'s on today?',
      '💡 Suggest priorities',
    ];
    final colors = context.appColors;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: chips.map((chip) {
        return GestureDetector(
          onTap: () {
            context.read<AiProvider>().sendMessage(chip);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: colors.card,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: colors.border),
            ),
            child: Text(
              chip,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final AppThemeData colors;
  final VoidCallback onSend;
  final VoidCallback onRecord;

  const _InputBar({
    required this.controller,
    required this.colors,
    required this.onSend,
    required this.onRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          // Mic button
          GestureDetector(
            onTap: onRecord,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Icon(
                Icons.mic_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Text field
          Expanded(
            child: TextField(
              controller: controller,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: colors.textPrimary),
              cursorColor: AppTheme.accentIndigo,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Message AI...',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: colors.textMuted),
                filled: true,
                fillColor: colors.card,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.accentIndigo,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Send button
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.accentIndigo, AppTheme.accentViolet],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.send_rounded,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
