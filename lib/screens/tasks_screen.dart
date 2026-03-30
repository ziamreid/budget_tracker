import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';
import 'add_task_sheet.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tasks = context.watch<TaskProvider>();

    return Container(
      color: colors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tasks',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${tasks.doneCount} of ${tasks.totalCount} completed',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  _AddButton(onTap: () => AddTaskSheet.show(context)),
                ],
              ),
            ),
            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: _ProgressBar(
                value: tasks.totalCount > 0
                    ? tasks.doneCount / tasks.totalCount
                    : 0,
                colors: colors,
              ),
            ),
            // Tabs with custom premium indicator
            _PremiumTabBar(
              controller: _tab,
              tabCount: 3,
              labels: [
                'To Do (${tasks.todoTasks.length})',
                'In Progress (${tasks.inProgressTasks.length})',
                'Done (${tasks.doneTasks.length})',
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _TaskList(tasks: tasks.todoTasks),
                  _TaskList(tasks: tasks.inProgressTasks),
                  _TaskList(tasks: tasks.doneTasks),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumTabBar extends StatefulWidget {
  final TabController controller;
  final int tabCount;
  final List<String> labels;

  const _PremiumTabBar({
    super.key,
    required this.controller,
    required this.tabCount,
    required this.labels,
  });

  @override
  State<_PremiumTabBar> createState() => _PremiumTabBarState();
}

class _PremiumTabBarState extends State<_PremiumTabBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnim;
  late Animation<double> _stretchAnim;
  late Animation<double> _fadeAnim;

  double _indicatorWidth = 0;
  double _indicatorX = 0;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );

    _stretchAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 60,
      ),
    ]).animate(_animController);

    _fadeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.0), weight: 70),
    ]).animate(_animController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateIndicator();
      widget.controller.addListener(_onTabChanged);
    });
  }

  void _onTabChanged() {
    if (widget.controller.indexIsChanging) {
      final newIndex = widget.controller.index;
      if (newIndex != _currentIndex &&
          newIndex >= 0 &&
          newIndex < widget.tabCount) {
        _animateToTab(newIndex);
      }
    }
  }

  void _animateToTab(int newIndex) {
    final oldIndex = _currentIndex;
    _currentIndex = newIndex;

    final oldX = _getTabX(oldIndex);
    final newX = _getTabX(newIndex);

    _indicatorX = oldX;
    _indicatorWidth = _getTabWidth(oldIndex);

    _animController.forward(from: 0).then((_) {
      setState(() {
        _indicatorX = newX;
        _indicatorWidth = _getTabWidth(newIndex);
      });
    });

    setState(() {});
  }

  double _getTabX(int index) {
    if (index < 0 || index >= widget.labels.length) return 0;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return 0;
    final width = box.size.width / widget.labels.length;
    return width * index;
  }

  double _getTabWidth(int index) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return 0;
    return box.size.width / widget.labels.length;
  }

  void _updateIndicator() {
    if (!mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;
    final width = box.size.width / widget.labels.length;
    setState(() {
      _indicatorWidth = width;
      _indicatorX = width * widget.controller.index;
      _currentIndex = widget.controller.index;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChanged);
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        final slideValue = _slideAnim.value;
        final stretchValue = _stretchAnim.value;
        final fadeValue = _fadeAnim.value;

        final currentX = _indicatorX;
        final targetX = _getTabX(_currentIndex);
        final animatedX = currentX + (targetX - currentX) * slideValue;

        final currentWidth = _indicatorWidth;
        final targetWidth = _getTabWidth(_currentIndex);
        final animatedWidth =
            currentWidth + (targetWidth - currentWidth) * slideValue;

        return Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              // Animated indicator
              Positioned(
                left: animatedX + 4,
                top: 4,
                child: Opacity(
                  opacity: fadeValue,
                  child: Container(
                    width: animatedWidth * stretchValue - 8,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.accentIndigo, AppTheme.accentViolet],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              // Tab labels
              Row(
                children: List.generate(widget.labels.length, (index) {
                  final isSelected = index == _currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        widget.controller.animateTo(index);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedOpacity(
                        opacity: isSelected ? 1.0 : 0.5,
                        duration: const Duration(milliseconds: 200),
                        child: Center(
                          child: Text(
                            widget.labels[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : colors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      final colors = context.appColors;
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 48,
              color: colors.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'No tasks here',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: colors.textMuted),
            ),
          ],
        ),
      );
    }
    final prov = context.read<TaskProvider>();
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      itemCount: tasks.length,
      itemBuilder: (_, i) {
        final t = tasks[i];
        return TaskCard(
          task: t,
          onToggle: () => prov.toggleDone(t.id),
          onDelete: () => prov.deleteTask(t.id),
        );
      },
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double value;
  final AppThemeData colors;
  const _ProgressBar({required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${(value * 100).toInt()}%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: colors.border,
            valueColor: const AlwaysStoppedAnimation(AppTheme.accentIndigo),
          ),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.accentIndigo, AppTheme.accentViolet],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
