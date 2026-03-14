import 'package:flutter/material.dart';
import 'package:my_first_app/data/constants.dart';
import 'package:my_first_app/data/notifiers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key, required this.title});

  final String title;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          Text(
            'Preferences',
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<bool>(
            valueListenable: isDarkModeNotifier,
            builder: (context, isDarkMode, _) {
              return _SettingsTile(
                icon: Icons.dark_mode_rounded,
                title: 'Dark mode',
                subtitle: isDarkMode ? 'On' : 'Off',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) async {
                    isDarkModeNotifier.value = value;
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool(KConstants.themeModeKey, value);
                  },
                  activeThumbColor: KConstants.primary,
                ),
                isDark: isDark,
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'About',
            style: theme.textTheme.labelLarge?.copyWith(
              color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          _SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'Version',
            subtitle: '1.0.0',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.verified_user_rounded,
            title: 'Privacy',
            subtitle: 'Your data stays on device',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.isDark,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? KConstants.cardDark : KConstants.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: isDark ? Border.all(color: Colors.white.withValues(alpha: 0.06)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: KConstants.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: KConstants.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? KConstants.textMutedDark : KConstants.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
