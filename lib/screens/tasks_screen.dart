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
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tasks',
                            style: Theme.of(context).textTheme.displaySmall),
                        const SizedBox(height: 4),
                        Text(
                          '${tasks.doneCount} of ${tasks.totalCount} completed',
                          style: TextStyle(
                              color: colors.textSecondary, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  _AddButton(
                    onTap: () => AddTaskSheet.show(context),
                  ),
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
                  colors: colors),
            ),
            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: TabBar(
                controller: _tab,
                indicatorColor: AppTheme.accentIndigo,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: AppTheme.accentIndigo,
                unselectedLabelColor: colors.textMuted,
                labelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600),
                tabs: [
                  Tab(text: 'To Do (${tasks.todoTasks.length})'),
                  Tab(text: 'In Progress (${tasks.inProgressTasks.length})'),
                  Tab(text: 'Done (${tasks.doneTasks.length})'),
                ],
              ),
            ),
            const Divider(height: 1),
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
    );
  }
}

class _TaskList extends StatelessWidget {
  final List<TaskModel> tasks;
  const _TaskList({required this.tasks});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline_rounded,
                size: 48, color: context.appColors.textMuted),
            const SizedBox(height: 12),
            Text('No tasks here',
                style: TextStyle(color: context.appColors.textMuted)),
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
  final AppColors colors;
  const _ProgressBar({required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('${(value * 100).toInt()}%',
            style: TextStyle(
                fontSize: 12,
                color: colors.textMuted,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 6,
            backgroundColor: colors.border,
            valueColor:
                const AlwaysStoppedAnimation(AppTheme.accentIndigo),
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
              colors: [AppTheme.accentIndigo, AppTheme.accentViolet]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
      ),
    );
  }
}
