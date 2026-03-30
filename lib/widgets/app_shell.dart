import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import 'package:my_first_app/providers/app_provider.dart';
import 'package:my_first_app/screens/tasks_screen.dart';
import 'package:my_first_app/screens/ai_chat_screen.dart';
import 'package:my_first_app/screens/notes_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>
    with SingleTickerProviderStateMixin {
  late AnimationController _indicatorController;
  late Animation<double> _indicatorAnimation;
  int _currentIndex = 1;

  final List<_NavItem> _navItems = const [
    _NavItem(
      icon: Icons.note_alt_outlined,
      activeIcon: Icons.note_alt_rounded,
      label: 'Notes',
    ),
    _NavItem(
      icon: Icons.task_alt_outlined,
      activeIcon: Icons.task_alt_rounded,
      label: 'Tasks',
    ),
    _NavItem(
      icon: Icons.chat_bubble_outline_rounded,
      activeIcon: Icons.chat_bubble_rounded,
      label: 'Chat',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _indicatorController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorAnimation = CurvedAnimation(
      parent: _indicatorController,
      curve: Curves.easeInOutCubic,
    );
    _indicatorController.forward();
  }

  @override
  void dispose() {
    _indicatorController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      context.read<AppProvider>().setIndex(index);
      _indicatorController.reset();
      _indicatorController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: const [NotesScreen(), TasksScreen(), AiChatScreen()],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: Center(
              child: _GlassNavBar(
                items: _navItems,
                currentIndex: _currentIndex,
                indicatorAnimation: _indicatorAnimation,
                onTap: _onNavTap,
                colors: colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class _GlassNavBar extends StatelessWidget {
  final List<_NavItem> items;
  final int currentIndex;
  final Animation<double> indicatorAnimation;
  final Function(int) onTap;
  final AppThemeData colors;

  const _GlassNavBar({
    required this.items,
    required this.currentIndex,
    required this.indicatorAnimation,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentIndigo.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 0,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isActive = index == currentIndex;

              return _NavPill(
                item: item,
                isActive: isActive,
                index: index,
                currentIndex: currentIndex,
                indicatorAnimation: indicatorAnimation,
                onTap: () => onTap(index),
                colors: colors,
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavPill extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final int index;
  final int currentIndex;
  final Animation<double> indicatorAnimation;
  final VoidCallback onTap;
  final AppThemeData colors;

  const _NavPill({
    required this.item,
    required this.isActive,
    required this.index,
    required this.currentIndex,
    required this.indicatorAnimation,
    required this.onTap,
    required this.colors,
  });

  @override
  State<_NavPill> createState() => _NavPillState();
}

class _NavPillState extends State<_NavPill>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _scaleController.forward(),
      onTapUp: (_) {
        _scaleController.reverse();
        widget.onTap();
      },
      onTapCancel: () => _scaleController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOutCubic,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(
                horizontal: widget.isActive ? 20 : 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: widget.isActive
                    ? AppTheme.accentIndigo.withOpacity(
                        0.2 + (_glowAnimation.value * 0.1),
                      )
                    : Colors.transparent,
                boxShadow: widget.isActive
                    ? [
                        BoxShadow(
                          color: AppTheme.accentIndigo.withOpacity(
                            0.3 * _glowAnimation.value,
                          ),
                          blurRadius: 20,
                          spreadRadius: 0,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      widget.isActive
                          ? widget.item.activeIcon
                          : widget.item.icon,
                      key: ValueKey(widget.isActive),
                      color: widget.isActive
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      size: 22,
                    ),
                  ),
                  if (widget.isActive) ...[
                    const SizedBox(width: 8),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: Text(
                        widget.item.label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
