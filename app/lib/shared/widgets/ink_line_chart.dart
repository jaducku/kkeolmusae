import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// docs/demo.html `#chart` — 소비 누적선(점선) 위로 투자 가치선(실선)이
/// 왼쪽에서 오른쪽으로 그려지는 잉크 차트.
class InkLineChart extends StatefulWidget {
  const InkLineChart({
    super.key,
    required this.spentPoints,
    required this.valuePoints,
    this.height = 110,
  });

  final List<double> spentPoints;
  final List<double> valuePoints;
  final double height;

  @override
  State<InkLineChart> createState() => _InkLineChartState();
}

class _InkLineChartState extends State<InkLineChart> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..forward();

  @override
  void didUpdateWidget(covariant InkLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valuePoints != widget.valuePoints) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _ChartPainter(
            spentPoints: widget.spentPoints,
            valuePoints: widget.valuePoints,
            progress: Curves.easeOut.transform(_controller.value),
          ),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.spentPoints,
    required this.valuePoints,
    required this.progress,
  });

  final List<double> spentPoints;
  final List<double> valuePoints;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (valuePoints.length < 2) return;
    const pad = 6.0;
    final maxV = [...spentPoints, ...valuePoints].reduce((a, b) => a > b ? a : b) * 1.05;
    final maxVSafe = maxV <= 0 ? 1.0 : maxV;

    double px(int i, int len) => pad + (size.width - 2 * pad) * i / (len - 1);
    double py(double v) => size.height - pad - (size.height - 2 * pad) * v / maxVSafe;

    Path buildPath(List<double> pts) {
      final path = Path();
      for (var i = 0; i < pts.length; i++) {
        final x = px(i, pts.length);
        final y = py(pts[i]);
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      return path;
    }

    final spentPaint = Paint()
      ..color = AppColors.ink.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    _drawDashedPath(canvas, buildPath(spentPoints), spentPaint);

    final valuePath = buildPath(valuePoints);
    final metrics = valuePath.computeMetrics().toList();
    final valuePaint = Paint()
      ..color = AppColors.ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    for (final metric in metrics) {
      final extractLength = metric.length * progress;
      canvas.drawPath(metric.extractPath(0, extractLength), valuePaint);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 4.0;
    const gapWidth = 3.5;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = (distance + dashWidth).clamp(0, metric.length);
        canvas.drawPath(metric.extractPath(distance, next.toDouble()), paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.valuePoints != valuePoints ||
      oldDelegate.spentPoints != spentPoints;
}
