import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RecordingOverlay extends StatefulWidget {
  final VoidCallback onCancel;

  const RecordingOverlay({super.key, required this.onCancel});

  @override
  State<RecordingOverlay> createState() => _RecordingOverlayState();
}

class _RecordingOverlayState extends State<RecordingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late List<AnimationController> _rippleControllers;
  late AnimationController _dragController;
  late AnimationController _dismissController;

  double _dragOffset = 0;
  bool _hasTriggeredHaptic = false;

  static const double _dismissThreshold = 120.0;
  static const double _resistanceFactor = 0.6;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _rippleControllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      )..repeat();
    });

    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _dismissController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    for (final c in _rippleControllers) {
      c.dispose();
    }
    _dragController.dispose();
    _dismissController.dispose();
    super.dispose();
  }

  void _onDragStart(DragStartDetails details) {
    _dragController.stop();
    setState(() {
      _hasTriggeredHaptic = false;
    });
  }

  void _onDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (details.delta.dy > 0) {
        _dragOffset += details.delta.dy * _resistanceFactor;
        _dragOffset = _dragOffset.clamp(0, 400);

        if (_dragOffset >= _dismissThreshold && !_hasTriggeredHaptic) {
          HapticFeedback.mediumImpact();
          _hasTriggeredHaptic = true;
        }
      }
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragOffset >= _dismissThreshold) {
      // Continue dismiss with spring-like bounce
      _dismissController
          .animateTo(
            1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
          )
          .then((_) {
            widget.onCancel();
          });
    } else {
      // Spring back to original position
      _animateSpringBack();
    }
  }

  void _animateSpringBack() {
    final startOffset = _dragOffset;
    final startTime = DateTime.now();
    const duration = Duration(milliseconds: 400);

    void animate() {
      final elapsed = DateTime.now().difference(startTime);
      final t = (elapsed.inMilliseconds / duration.inMilliseconds).clamp(
        0.0,
        1.0,
      );

      // Spring-like curve (overshoot and settle)
      final springT = Curves.elasticOut.transform(t);
      final newOffset = startOffset * (1 - springT);

      if (t < 1.0) {
        setState(() {
          _dragOffset = newOffset;
        });
        Future.delayed(const Duration(milliseconds: 16), animate);
      } else {
        setState(() {
          _dragOffset = 0;
        });
      }
    }

    animate();
  }

  double get _progress => (_dragOffset / _dismissThreshold).clamp(0.0, 1.0);

  double get _screenOpacity => 1.0 - (_progress * 0.3);
  double get _cardScale => 1.0 - (_progress * 0.05);
  double get _glowIntensity => 0.5 * (1.0 - _progress);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AnimatedBuilder(
      animation: Listenable.merge([_dismissController]),
      builder: (context, child) {
        final dismissProgress = _dismissController.value;
        final dismissOffset = Curves.easeOut.transform(dismissProgress) * 400;

        return Opacity(
          opacity: 1.0 - dismissProgress,
          child: Transform.translate(
            offset: Offset(0, _dragOffset + dismissOffset),
            child: Transform.scale(
              scale: _cardScale - (dismissProgress * 0.1),
              child: GestureDetector(
                onVerticalDragStart: _onDragStart,
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragEnd: _onDragEnd,
                child: Material(
                  color: Colors.transparent,
                  child: Opacity(
                    opacity: _screenOpacity,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFF0B0F1A), Color(0xFF151933)],
                        ),
                      ),
                      child: Stack(
                        children: [
                          CustomPaint(
                            painter: _DottedGridPainter(),
                            size: MediaQuery.of(context).size,
                          ),
                          Center(
                            child: Container(
                              width: 280,
                              height: 340,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.3),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 24,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          'VOICE AI ACTIVE',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 3,
                                          ),
                                        ),
                                        Text(
                                          'Listening...',
                                          style: textTheme.headlineMedium
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(
                                          width: 160,
                                          height: 160,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              ...List.generate(3, (index) {
                                                return AnimatedBuilder(
                                                  animation:
                                                      _rippleControllers[index],
                                                  builder: (context, child) {
                                                    final progress =
                                                        _rippleControllers[index]
                                                            .value;
                                                    final delay = index * 0.3;
                                                    final adjustedProgress =
                                                        ((progress + delay) %
                                                        1.0);
                                                    final rippleScale =
                                                        1 +
                                                        adjustedProgress * 0.8;
                                                    final rippleOpacity =
                                                        (1 - adjustedProgress) *
                                                        0.6;
                                                    final dynamicScale =
                                                        rippleScale -
                                                        (_progress * 0.1);
                                                    final dynamicOpacity =
                                                        rippleOpacity *
                                                        (1.0 - _progress * 0.5);

                                                    return Transform.scale(
                                                      scale: dynamicScale,
                                                      child: Opacity(
                                                        opacity: dynamicOpacity
                                                            .clamp(0.0, 0.6),
                                                        child: Container(
                                                          width: 140,
                                                          height: 140,
                                                          decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Color.lerp(
                                                                const Color(
                                                                  0xFF7C3AED,
                                                                ),
                                                                Colors
                                                                    .grey
                                                                    .shade600,
                                                                _progress,
                                                              )!,
                                                              width: 2,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }),
                                              AnimatedBuilder(
                                                animation: _pulseController,
                                                builder: (context, child) {
                                                  final pulseScale =
                                                      1.0 +
                                                      (_pulseController.value *
                                                          0.05);
                                                  final dynamicScale =
                                                      pulseScale -
                                                      (_progress * 0.05);

                                                  return Transform.scale(
                                                    scale: dynamicScale,
                                                    child: Container(
                                                      width: 140,
                                                      height: 140,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        gradient:
                                                            const LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                Color(
                                                                  0xFF7C3AED,
                                                                ),
                                                                Color(
                                                                  0xFF6366F1,
                                                                ),
                                                              ],
                                                            ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Color.lerp(
                                                                  const Color(
                                                                    0xFF7C3AED,
                                                                  ).withValues(
                                                                    alpha: 0.5,
                                                                  ),
                                                                  Colors
                                                                      .grey
                                                                      .shade800,
                                                                  _progress,
                                                                )!.withValues(
                                                                  alpha:
                                                                      _glowIntensity,
                                                                ),
                                                            blurRadius:
                                                                30 -
                                                                (_progress *
                                                                    20),
                                                            spreadRadius:
                                                                5 -
                                                                (_progress * 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: const Icon(
                                                        Icons.mic_rounded,
                                                        color: Colors.white,
                                                        size: 56,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        AnimatedOpacity(
                                          opacity: 1.0 - _progress,
                                          duration: const Duration(
                                            milliseconds: 100,
                                          ),
                                          child: Column(
                                            children: [
                                              Transform.translate(
                                                offset: Offset(
                                                  0,
                                                  _progress * 10,
                                                ),
                                                child: Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: Colors.white
                                                      .withValues(alpha: 0.4),
                                                  size: 24,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'SWIPE DOWN TO CANCEL',
                                                style: textTheme.bodySmall
                                                    ?.copyWith(
                                                      color: Colors.white
                                                          .withValues(
                                                            alpha: 0.4,
                                                          ),
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 1.5,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DottedGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;

    const spacing = 30.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
