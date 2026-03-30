import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:my_first_app/theme/app_theme.dart';
import 'package:flutter/widgets.dart' show AnimatedContainer, AnimatedBuilder;
import '../models/task_model.dart';

class TaskCard extends StatefulWidget {
  final TaskModel task;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const TaskCard({super.key, required this.task, this.onToggle, this.onDelete});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Color _priorityColor() {
    switch (widget.task.priority) {
      case TaskPriority.high:
        return AppTheme.accentRed;
      case TaskPriority.medium:
        return AppTheme.accentAmber;
      case TaskPriority.low:
        return AppTheme.accentGreen;
    }
  }

  void _handleTap() {
    _bounceController.forward().then((_) {
      _bounceController.reverse();
      widget.onToggle?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isDone = widget.task.status == TaskStatus.done;
    final priorityColor = _priorityColor();

    return Dismissible(
      key: Key(widget.task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => widget.onDelete?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              priorityColor.withValues(alpha: 0.0),
              priorityColor.withValues(alpha: 0.15),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: priorityColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: priorityColor,
            size: 22,
          ),
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _handleTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedBuilder(
          animation: _bounceController,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isDone
                          ? [
                              AppTheme.accentIndigo.withValues(alpha: 0.08),
                              AppTheme.primaryPurple.withValues(alpha: 0.12),
                            ]
                          : [
                              colors.card.withValues(alpha: 0.7),
                              colors.card.withValues(alpha: 0.5),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDone
                          ? AppTheme.accentIndigo.withValues(alpha: 0.4)
                          : colors.border.withValues(alpha: 0.5),
                      width: 1,
                    ),
                    boxShadow: isDone
                        ? [
                            BoxShadow(
                              color: AppTheme.accentIndigo.withValues(
                                alpha: 0.15,
                              ),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Glowing priority indicator
                        _GlowingPriorityDot(
                          color: isDone ? colors.textMuted : priorityColor,
                          isDone: isDone,
                        ),
                        const SizedBox(width: 14),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: AnimatedDefaultTextStyle(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.w600,
                                            decoration: isDone
                                                ? TextDecoration.lineThrough
                                                : null,
                                            color: isDone
                                                ? colors.textMuted
                                                : colors.textPrimary,
                                          ),
                                      child: Text(widget.task.title),
                                    ),
                                  ),
                                  if (widget.task.aiTag != null) ...[
                                    const SizedBox(width: 8),
                                    _FuturisticAiTag(label: widget.task.aiTag!),
                                  ],
                                ],
                              ),
                              if (widget.task.subtitle != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  widget.task.subtitle!,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: colors.textSecondary,
                                        fontWeight: FontWeight.w400,
                                      ),
                                ),
                              ],
                              if (widget.task.hasAiInsight && !isDone) ...[
                                const SizedBox(height: 12),
                                _FuturisticAiInsightBar(colors: colors),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Animated check button
                        _AnimatedCheckButton(isDone: isDone, onTap: _handleTap),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlowingPriorityDot extends StatelessWidget {
  final Color color;
  final bool isDone;

  const _GlowingPriorityDot({required this.color, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone ? color.withValues(alpha: 0.3) : color,
        boxShadow: isDone
            ? []
            : [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
      ),
    );
  }
}

class _AnimatedCheckButton extends StatefulWidget {
  final bool isDone;
  final VoidCallback onTap;

  const _AnimatedCheckButton({required this.isDone, required this.onTap});

  @override
  State<_AnimatedCheckButton> createState() => _AnimatedCheckButtonState();
}

class _AnimatedCheckButtonState extends State<_AnimatedCheckButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_controller);
    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    if (widget.isDone) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(_AnimatedCheckButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isDone && !oldWidget.isDone) {
      _controller.forward(from: 0);
    } else if (!widget.isDone && oldWidget.isDone) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isDone
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.accentIndigo, AppTheme.primaryPurple],
                      )
                    : null,
                color: widget.isDone ? null : Colors.transparent,
                border: Border.all(
                  color: widget.isDone
                      ? AppTheme.accentIndigo
                      : AppTheme.accentIndigo.withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: widget.isDone
                    ? [
                        BoxShadow(
                          color: AppTheme.accentIndigo.withValues(alpha: 0.4),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ]
                    : [],
              ),
              child: widget.isDone
                  ? Transform.scale(
                      scale: _checkAnimation.value,
                      child: const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          );
        },
      ),
    );
  }
}

class _FuturisticAiTag extends StatelessWidget {
  final String label;
  const _FuturisticAiTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentIndigo.withValues(alpha: 0.2),
            AppTheme.primaryPurple.withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentIndigo.withValues(alpha: 0.4),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentIndigo.withValues(alpha: 0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            size: 11,
            color: AppTheme.accentIndigo,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppTheme.accentIndigo,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FuturisticAiInsightBar extends StatelessWidget {
  final AppThemeData colors;
  const _FuturisticAiInsightBar({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accentIndigo.withValues(alpha: 0.1),
            AppTheme.primaryPurple.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentIndigo.withValues(alpha: 0.2),
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              size: 12,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            'AI insight available',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 10,
            color: colors.textMuted,
          ),
        ],
      ),
    );
  }
}
