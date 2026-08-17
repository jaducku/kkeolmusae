import 'package:flutter/material.dart';

/// docs/demo.html 의 `.hr`(점선 구분선), `.item` 하단 점선, `.dots`
/// (라벨↔금액 사이 리더 점선)을 모두 이 위젯 하나로 그린다.
class DashedLine extends StatelessWidget {
  const DashedLine({
    super.key,
    this.color = Colors.black,
    this.thickness = 1,
    this.dashWidth = 5,
    this.gapWidth = 4,
  });

  final Color color;
  final double thickness;
  final double dashWidth;
  final double gapWidth;

  /// docs/demo2.html `.hr` — 옅은 대시 (v2: 컬러를 낮춰 차분하게)
  const DashedLine.hr({super.key, this.color = const Color(0xFFD8D4CA)})
      : thickness = 1.5,
        dashWidth = 6,
        gapWidth = 5;

  /// `.hr.thin`
  const DashedLine.thin({super.key, required this.color})
      : thickness = 1,
        dashWidth = 5,
        gapWidth = 4;

  /// 항목 사이 아주 촘촘한 점선 (`border-bottom:1px dotted`)
  const DashedLine.dotted({super.key, required this.color})
      : thickness = 1,
        dashWidth = 1.4,
        gapWidth = 2.6;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: thickness,
      width: double.infinity,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color,
          thickness: thickness,
          dashWidth: dashWidth,
          gapWidth: gapWidth,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dashWidth,
    required this.gapWidth,
  });

  final Color color;
  final double thickness;
  final double dashWidth;
  final double gapWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness;
    final step = dashWidth + gapWidth;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset((x + dashWidth).clamp(0, size.width), size.height / 2),
        paint,
      );
      x += step;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.thickness != thickness ||
      oldDelegate.dashWidth != dashWidth ||
      oldDelegate.gapWidth != gapWidth;
}

/// 라벨과 금액 사이를 잇는 점선 리더 (`.sum-row .dots`, `.kv .dots`).
class DottedLeader extends StatelessWidget {
  const DottedLeader({super.key, this.color = const Color(0xFFCFCBC1)});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: DashedLine.dotted(color: color),
      ),
    );
  }
}
