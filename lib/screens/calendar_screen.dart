import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/theme/app_theme.dart';
import '../providers/app_provider.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedMonth = DateTime.now();

  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final last = DateTime(month.year, month.month + 1, 0);
    final leading = first.weekday % 7;
    return [
      ...List.generate(
          leading, (i) => first.subtract(Duration(days: leading - i))),
      ...List.generate(last.day, (i) => DateTime(month.year, month.month, i + 1)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final tasks = context.watch<TaskProvider>();
    final days = _daysInMonth(_focusedMonth);

    return Container(
      color: colors.background,
      child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                children: [
                  Text('Calendar',
                      style: Theme.of(context).textTheme.displaySmall),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() {
                      _focusedMonth = DateTime(
                          _focusedMonth.year, _focusedMonth.month - 1);
                    }),
                    child: Icon(Icons.chevron_left_rounded,
                        color: colors.textSecondary),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${_months[_focusedMonth.month - 1]} ${_focusedMonth.year}',
                      style: TextStyle(
                          color: colors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() {
                      _focusedMonth = DateTime(
                          _focusedMonth.year, _focusedMonth.month + 1);
                    }),
                    child: Icon(Icons.chevron_right_rounded,
                        color: colors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Day-of-week labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                    .map((d) => Expanded(
                          child: Center(
                            child: Text(d,
                                style: TextStyle(
                                    color: colors.textMuted,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Calendar grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: days.length,
                itemBuilder: (_, i) {
                  final day = days[i];
                  final isCurrentMonth =
                      day.month == _focusedMonth.month;
                  final isSelected = day.year == _selectedDay.year &&
                      day.month == _selectedDay.month &&
                      day.day == _selectedDay.day;
                  final isToday = day.year == DateTime.now().year &&
                      day.month == DateTime.now().month &&
                      day.day == DateTime.now().day;
                  final hasTask = tasks.hasTaskOnDay(day);

                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = day),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: isSelected
                              ? const LinearGradient(colors: [
                                  AppTheme.accentIndigo,
                                  AppTheme.accentViolet
                                ])
                              : null,
                          color: isToday && !isSelected
                              ? AppTheme.accentIndigo.withOpacity(0.1)
                              : null,
                          border: isToday && !isSelected
                              ? Border.all(
                                  color: AppTheme.accentIndigo.withOpacity(0.4),
                                  width: 1.5)
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected || isToday
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                color: isSelected
                                    ? Colors.white
                                    : isCurrentMonth
                                        ? colors.textPrimary
                                        : colors.textMuted,
                              ),
                            ),
                            if (hasTask && !isSelected)
                              Positioned(
                                bottom: 4,
                                child: Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: AppTheme.accentIndigo,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const Divider(height: 1),
            const SizedBox(height: 16),

            // Selected day tasks
            Expanded(
              child: _SelectedDayTasks(
                day: _selectedDay,
                tasks: tasks.tasksForDay(_selectedDay),
                colors: colors,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedDayTasks extends StatelessWidget {
  final DateTime day;
  final List tasks;
  final AppColors colors;

  const _SelectedDayTasks(
      {required this.day, required this.tasks, required this.colors});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('MMMM d, yyyy');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Row(
            children: [
              Text(fmt.format(day),
                  style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)),
              const Spacer(),
              if (tasks.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentIndigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${tasks.length} task${tasks.length > 1 ? 's' : ''}',
                      style: const TextStyle(
                          color: AppTheme.accentIndigo,
                          fontSize: 12,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
        if (tasks.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_available_rounded,
                      size: 40, color: colors.textMuted),
                  const SizedBox(height: 10),
                  Text('No tasks this day',
                      style: TextStyle(color: colors.textMuted)),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: tasks.length,
              itemBuilder: (_, i) {
                final t = tasks[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                              color: AppTheme.accentIndigo,
                              shape: BoxShape.circle)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(t.title,
                            style: TextStyle(
                                color: colors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
