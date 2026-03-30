import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import 'package:my_first_app/providers/app_provider.dart';
import 'package:my_first_app/screens/settings_screen.dart';

/// Premium navigation drawer with hero header and glass-style menu rows.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final app = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      width: 300,
      backgroundColor: colors.surface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero header ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(22, 20, 22, 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          AppTheme.accentIndigo.withValues(alpha: 0.35),
                          AppTheme.darkBg,
                          AppTheme.accentViolet.withValues(alpha: 0.2),
                        ]
                      : [
                          AppTheme.accentIndigo.withValues(alpha: 0.12),
                          colors.surface,
                          AppTheme.accentTeal.withValues(alpha: 0.08),
                        ],
                  stops: const [0.0, 0.45, 1.0],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.accentIndigo,
                              AppTheme.accentViolet,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentIndigo.withValues(alpha: 0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.accentGreen.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.accentGreen.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.circle, size: 8, color: AppTheme.accentGreen),
                            const SizedBox(width: 6),
                            Text(
                              'Live',
                              style: TextStyle(
                                color: AppTheme.accentGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppTheme.accentIndigo,
                        AppTheme.accentViolet,
                        AppTheme.accentTeal,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'Digital Concierge',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI-powered task manager & personal assistant',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: colors.card.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: colors.border),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_rounded, color: colors.textMuted, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                app.userName,
                                style: TextStyle(
                                  color: colors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Signed in',
                                style: TextStyle(
                                  color: colors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.verified_rounded, color: AppTheme.accentIndigo, size: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Nav items ───────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                children: [
                  _DrawerTile(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    gradient: const [AppTheme.accentIndigo, AppTheme.accentViolet],
                    selected: app.currentIndex == 0,
                    onTap: () {
                      context.read<AppProvider>().setIndex(0);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.task_alt_rounded,
                    label: 'Tasks',
                    gradient: const [AppTheme.accentTeal, AppTheme.accentIndigo],
                    selected: app.currentIndex == 1,
                    onTap: () {
                      context.read<AppProvider>().setIndex(1);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.calendar_month_rounded,
                    label: 'Calendar',
                    gradient: const [AppTheme.accentAmber, Color(0xFFF97316)],
                    selected: app.currentIndex == 2,
                    onTap: () {
                      context.read<AppProvider>().setIndex(2);
                      Navigator.pop(context);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.psychology_rounded,
                    label: 'AI Assistant',
                    gradient: const [AppTheme.accentViolet, AppTheme.accentIndigo],
                    selected: app.currentIndex == 3,
                    onTap: () {
                      context.read<AppProvider>().setIndex(3);
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    child: Divider(color: colors.border, height: 1),
                  ),
                  _DrawerTile(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    gradient: const [
                      AppTheme.darkTextMuted,
                      AppTheme.lightTextMuted,
                    ],
                    selected: false,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Footer ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.border),
                      color: colors.card,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 18, color: colors.textMuted),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Version 1.0.0 · Made with Flutter',
                            style: TextStyle(color: colors.textMuted, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final bool selected;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final accent = gradient.first;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        accent.withValues(alpha: 0.22),
                        gradient.length > 1
                            ? gradient[1].withValues(alpha: 0.12)
                            : accent.withValues(alpha: 0.08),
                      ],
                    )
                  : null,
              border: Border.all(
                color: selected ? accent.withValues(alpha: 0.45) : colors.border.withValues(alpha: 0.6),
                width: selected ? 1.5 : 1,
              ),
              color: selected ? null : colors.card.withValues(alpha: 0.5),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: gradient.map((c) => c.withValues(alpha: 0.25)).toList(),
                    ),
                  ),
                  child: Icon(icon, color: accent, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                if (selected)
                  Icon(Icons.chevron_right_rounded, color: accent, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
