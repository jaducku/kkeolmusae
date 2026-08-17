import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// 종이를 손으로 잡고 아래로 "쫘아악" 찢어내리는 연출.
/// ① 살짝 버티듯 흔들리다(저항) ② 오른쪽 위 한 점에 매달린 채 왼쪽부터
/// 실제로 찢어지는 톱니선이 자라나며 통째로 젖혀지고(경첩처럼) ③ 다 찢어지면
/// 완전히 떨어져 나가 아래로 떨어진다. 원래 있던 자리엔 톱니 절취선이 남은
/// 데스크색 구멍이 드러난다.
class RipDown extends StatelessWidget {
  const RipDown({super.key, required this.progress, required this.child});

  /// 0→1 원본 컨트롤러 값 (내부에서 흔들림/찢김/낙하 구간을 알아서 나눈다).
  final double progress;
  final Widget child;

  static const double _shakeEnd = 0.16;
  static const double _peelEnd = 0.62;
  static const double _maxPeelAngle = 0.46;

  @override
  Widget build(BuildContext context) {
    final raw = progress.clamp(0.0, 1.0);

    var shakeX = 0.0;
    if (raw < _shakeEnd) {
      final sp = raw / _shakeEnd;
      shakeX = math.sin(sp * math.pi * 3.2) * (1 - sp) * 6;
    }

    var peelP = 0.0;
    if (raw >= _shakeEnd) {
      final span = (math.min(raw, _peelEnd) - _shakeEnd) / (_peelEnd - _shakeEnd);
      peelP = Curves.easeIn.transform(span.clamp(0.0, 1.0));
    }

    var releaseP = 0.0;
    if (raw > _peelEnd) {
      releaseP = Curves.easeIn.transform(((raw - _peelEnd) / (1 - _peelEnd)).clamp(0.0, 1.0));
    }

    final angle = -peelP * _maxPeelAngle - releaseP * 0.3;
    final dy = peelP * 14 + releaseP * 280;
    final dx = shakeX - releaseP * 22;
    final opacity = 1 - releaseP;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(child: _RipHole()),
        Transform.translate(
          offset: Offset(dx, dy),
          child: Transform.rotate(
            angle: angle,
            alignment: Alignment.topRight,
            child: Opacity(
              opacity: opacity,
              child: CustomPaint(
                foregroundPainter: _TearLinePainter(tearP: peelP),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 찢기는 톱니선이 왼쪽부터 오른쪽(경첩 쪽)으로 자라나며, 이미 찢어진
/// 끄트머리 근처엔 종이 보풀 같은 작은 점을 흩뿌려 실감을 더한다.
class _TearLinePainter extends CustomPainter {
  _TearLinePainter({required this.tearP});
  final double tearP;

  static const double _tooth = 15;
  static const double _jag = 8;

  @override
  void paint(Canvas canvas, Size size) {
    if (tearP <= 0) return;
    final tearX = size.width * tearP;

    final path = Path()..moveTo(0, 0);
    var x = 0.0;
    var toggle = false;
    while (x < tearX) {
      x = math.min(x + _tooth / 2, tearX);
      toggle = !toggle;
      path.lineTo(x, toggle ? _jag : 0);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.ink.withValues(alpha: 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );

    if (tearP < 1) {
      final rand = math.Random((tearX * 131).toInt());
      for (var i = 0; i < 4; i++) {
        final fx = (tearX - rand.nextDouble() * 12).clamp(0.0, size.width);
        final fy = rand.nextDouble() * (_jag + 3);
        canvas.drawCircle(
          Offset(fx, fy),
          0.9,
          Paint()..color = AppColors.ink.withValues(alpha: 0.32),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TearLinePainter oldDelegate) => oldDelegate.tearP != tearP;
}

class _RipHole extends StatelessWidget {
  const _RipHole();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RipHolePainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _RipHolePainter extends CustomPainter {
  static const double _tooth = 14;
  static const double _jag = 6;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = AppColors.desk);

    final path = Path()..moveTo(0, 0);
    var x = 0.0;
    var toggle = false;
    while (x < size.width) {
      x = (x + _tooth / 2).clamp(0, size.width);
      toggle = !toggle;
      path.lineTo(x, toggle ? _jag : 0);
    }
    path.lineTo(size.width, 0);

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.ink.withValues(alpha: 0.14)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _RipHolePainter oldDelegate) => false;
}
