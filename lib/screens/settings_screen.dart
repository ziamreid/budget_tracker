import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import 'package:my_first_app/providers/app_provider.dart';
import 'package:my_first_app/widgets/animated_button.dart';
import 'package:my_first_app/utils/page_transitions.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final app = context.watch<AppProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            Text('Settings', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 24),

            // Profile card
            _ProfileCard(colors: colors, name: app.userName),
            const SizedBox(height: 24),

            // Appearance
            _SectionHeader('Appearance', colors: colors),
            _SettingsTile(
              icon: Icons.dark_mode_rounded,
              iconColor: AppTheme.accentViolet,
              title: 'Dark Mode',
              trailing: Switch(
                value: app.isDarkMode,
                onChanged: (_) => app.toggleTheme(),
                activeColor: AppTheme.accentIndigo,
              ),
              colors: colors,
            ),
            const SizedBox(height: 20),

            // Notifications
            _SectionHeader('Notifications', colors: colors),
            _SettingsTile(
              icon: Icons.notifications_rounded,
              iconColor: AppTheme.accentAmber,
              title: 'Push Notifications',
              trailing: Switch(
                value: app.notificationsEnabled,
                onChanged: (_) => app.toggleNotifications(),
                activeColor: AppTheme.accentIndigo,
              ),
              colors: colors,
            ),
            _SettingsTile(
              icon: Icons.vibration_rounded,
              iconColor: AppTheme.accentGreen,
              title: 'Haptic Feedback',
              trailing: Switch(
                value: app.hapticEnabled,
                onChanged: (_) => app.toggleHaptic(),
                activeColor: AppTheme.accentIndigo,
              ),
              colors: colors,
            ),
            const SizedBox(height: 20),

            // AI Settings
            _SectionHeader('AI Assistant', colors: colors),
            _SettingsTile(
              icon: Icons.psychology_rounded,
              iconColor: AppTheme.accentIndigo,
              title: 'AI Model',
              subtitle: 'Gemini Pro',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colors.textMuted,
              ),
              colors: colors,
            ),
            _SettingsTile(
              icon: Icons.history_rounded,
              iconColor: AppTheme.accentTeal,
              title: 'Clear AI History',
              onTap: () => _confirmClear(context),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: colors.textMuted,
              ),
              colors: colors,
            ),
            const SizedBox(height: 20),

            // About
            _SectionHeader('About', colors: colors),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              iconColor: colors.textMuted,
              title: 'Version',
              subtitle: '1.0.0',
              trailing: null,
              colors: colors,
            ),
            _SettingsTile(
              icon: Icons.code_rounded,
              iconColor: colors.textMuted,
              title: 'Open Source',
              trailing: Icon(
                Icons.open_in_new_rounded,
                size: 16,
                color: colors.textMuted,
              ),
              colors: colors,
            ),

            const SizedBox(height: 32),
            _DangerZone(colors: colors, context: context),
          ],
        ),
      ),
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear AI History'),
        content: const Text(
          'This will delete all AI conversation history. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AiProvider>().clearHistory();
              Navigator.pop(context);
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppTheme.accentRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final AppThemeData colors;
  final String name;
  const _ProfileCard({required this.colors, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentIndigo.withOpacity(0.15),
            AppTheme.accentViolet.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentIndigo.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.accentIndigo, AppTheme.accentViolet],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: colors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Premium Account',
                style: TextStyle(color: colors.textSecondary, fontSize: 13),
              ),
            ],
          ),
          const Spacer(),
          Icon(Icons.edit_rounded, size: 18, color: colors.textMuted),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final AppThemeData colors;
  const _SectionHeader(this.title, {required this.colors});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: colors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final AppThemeData colors;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(color: colors.textMuted, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _DangerZone extends StatelessWidget {
  final AppThemeData colors;
  final BuildContext context;
  const _DangerZone({required this.colors, required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentRed.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.accentRed.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: TextStyle(
              color: AppTheme.accentRed,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          _AnimatedOutlinedButton(
            text: 'Clear All Tasks',
            onPressed: () => ctx.read<TaskProvider>().clearAll(),
          ),
          const SizedBox(height: 12),
          _AnimatedOutlinedButton(
            text: 'Logout',
            onPressed: () {
              ctx.read<AppProvider>().logout();
              Navigator.of(
                ctx,
              ).pushReplacement(SlideUpTransition(page: const LoginScreen()));
            },
          ),
        ],
      ),
    );
  }
}

class _AnimatedOutlinedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  const _AnimatedOutlinedButton({required this.text, required this.onPressed});

  @override
  State<_AnimatedOutlinedButton> createState() =>
      _AnimatedOutlinedButtonState();
}

class _AnimatedOutlinedButtonState extends State<_AnimatedOutlinedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        transformAlignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: _isPressed
              ? AppTheme.accentRed.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.accentRed.withOpacity(0.4),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: const TextStyle(
              color: AppTheme.accentRed,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
