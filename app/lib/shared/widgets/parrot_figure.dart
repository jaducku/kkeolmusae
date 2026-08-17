import 'package:flutter/material.dart';

/// docs/demo2.html `.parrot-fig` 리액션 단계 (PRD §4.3).
enum ParrotMood { lv1, lv2, lv3, lv4, relief }

/// assets/images/mascot_icon.png 를 단계별로 흔들거나(tilt/shiver),
/// 드러눕히거나(lv3), 흑백으로 띄워 보낸다(lv4).
class ParrotFigure extends StatefulWidget {
  const ParrotFigure({super.key, required this.mood, this.size = 46});

  final ParrotMood mood;
  final double size;

  @override
  State<ParrotFigure> createState() => _ParrotFigureState();
}

class _ParrotFigureState extends State<ParrotFigure> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _durationFor(widget.mood),
  )..repeat(reverse: true);

  static Duration _durationFor(ParrotMood mood) => switch (mood) {
        ParrotMood.lv1 => const Duration(milliseconds: 900),
        ParrotMood.lv2 => const Duration(milliseconds: 200),
        ParrotMood.lv3 => const Duration(milliseconds: 900),
        ParrotMood.lv4 => const Duration(milliseconds: 1300),
        ParrotMood.relief => const Duration(milliseconds: 1400),
      };

  @override
  void didUpdateWidget(covariant ParrotFigure oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) {
      _controller.duration = _durationFor(widget.mood);
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/mascot_icon.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        switch (widget.mood) {
          case ParrotMood.lv1:
            return Transform.rotate(angle: _lerpAngle(-0.105, 0.105), child: child);
          case ParrotMood.lv2:
            return Transform.translate(
              offset: Offset(_lerp(-1.5, 1.5), 0),
              child: child,
            );
          case ParrotMood.lv3:
            return Transform.rotate(angle: 2.0, child: child); // 눕는다 (~115deg)
          case ParrotMood.lv4:
            return Opacity(
              opacity: 0.5,
              child: Transform.translate(
                offset: Offset(0, _lerp(0, -9)),
                child: ColorFiltered(
                  colorFilter: const ColorFilter.matrix(<double>[
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: child,
                ),
              ),
            );
          case ParrotMood.relief:
            return Transform.rotate(angle: _lerpAngle(-0.1, 0.1), child: child);
        }
      },
      child: image,
    );
  }

  double _lerp(double from, double to) => from + (to - from) * _controller.value;

  double _lerpAngle(double from, double to) => _lerp(from, to);
}
