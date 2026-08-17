import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// docs/demo2.html `.receipt` — 감열지 영수증 카드.
/// v1 의 하드 오프셋 섀도 대신 부드러운 다층 섀도로 차분하게.
class ReceiptPaper extends StatelessWidget {
  const ReceiptPaper({
    super.key,
    required this.child,
    this.maxWidth = 384,
    this.padding = const EdgeInsets.fromLTRB(22, 24, 22, 28),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: AppColors.ink.withValues(alpha: 0.06), blurRadius: 2, offset: const Offset(0, 1)),
            BoxShadow(color: AppColors.ink.withValues(alpha: 0.18), blurRadius: 32, spreadRadius: -8, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _TornEdge(flip: false),
            ColoredBox(
              color: AppColors.paper,
              child: Padding(padding: padding, child: child),
            ),
            const _TornEdge(flip: true),
          ],
        ),
      ),
    );
  }
}

class _TornEdge extends StatelessWidget {
  const _TornEdge({required this.flip});

  final bool flip;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 11),
      painter: _TornEdgePainter(flip: flip),
    );
  }
}

class _TornEdgePainter extends CustomPainter {
  _TornEdgePainter({required this.flip});

  final bool flip;
  static const double _tooth = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.paper;
    final path = Path();
    final count = (size.width / _tooth).ceil() + 1;

    if (!flip) {
      path.moveTo(0, size.height);
      for (var i = 0; i <= count; i++) {
        final x = i * _tooth;
        path.lineTo(x + _tooth / 2, 0);
        path.lineTo(x + _tooth, size.height);
      }
      path.lineTo(size.width, size.height);
      path.close();
    } else {
      path.moveTo(0, 0);
      for (var i = 0; i <= count; i++) {
        final x = i * _tooth;
        path.lineTo(x + _tooth / 2, size.height);
        path.lineTo(x + _tooth, 0);
      }
      path.lineTo(size.width, 0);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TornEdgePainter oldDelegate) => false;
}

/// 데스크 배경 (v2: 텍스처 없이 플랫한 웜 뉴트럴로 정리).
class DeskBackground extends StatelessWidget {
  const DeskBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppColors.desk, child: child);
  }
}
