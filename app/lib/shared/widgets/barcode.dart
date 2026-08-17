import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// docs/demo2.html `.barcode` — 영수증 하단 장식용 바코드.
///
/// 반복 패턴을 흉내만 내던 v1과 달리, [digits] 를 실제 **Code 39** 규격으로
/// 인코딩해 굵기가 진짜 문자 정보에서 나오도록 한다 (시작/끝 `*` 가드바 포함).
class Barcode extends StatelessWidget {
  const Barcode({super.key, required this.digits, this.height = 40});

  final String digits;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(painter: _Code39Painter(digits: digits)),
        ),
        const SizedBox(height: 8),
        Text(
          digits.split('').join(' '),
          style: AppTextStyles.barcodeDigits,
        ),
      ],
    );
  }
}

/// Code 39 문자셋 (0-9, `*` 시작/종료 가드) — 막대 5개·공백 4개, 9칸을
/// N(좁음)/W(넓음)로 표현한다.
const Map<String, String> _kCode39Patterns = {
  '0': 'NNNWWNWNN',
  '1': 'WNNWNNNNW',
  '2': 'NNWWNNNNW',
  '3': 'WNWWNNNNN',
  '4': 'NNNWWNNNW',
  '5': 'WNNWWNNNN',
  '6': 'NNWWWNNNN',
  '7': 'NNNWNNWNW',
  '8': 'WNNWNNWNN',
  '9': 'NNWWNNWNN',
  '*': 'NNNWNWNWN',
};

class _Code39Painter extends CustomPainter {
  _Code39Painter({required this.digits});

  final String digits;
  static const double _wideRatio = 2.4;
  static const double _interCharGap = 1; // 좁은 공백 1칸

  @override
  void paint(Canvas canvas, Size size) {
    final code = '*${digits.replaceAll(RegExp(r'[^0-9]'), '')}*';
    final chars = code.split('').map((c) => _kCode39Patterns[c] ?? _kCode39Patterns['0']!).toList();

    var totalUnits = 0.0;
    for (final pattern in chars) {
      for (final e in pattern.split('')) {
        totalUnits += e == 'W' ? _wideRatio : 1;
      }
    }
    totalUnits += _interCharGap * (chars.length - 1);
    if (totalUnits <= 0) return;

    final unit = size.width / totalUnits;
    final paint = Paint()..color = AppColors.ink;

    var x = 0.0;
    for (var ci = 0; ci < chars.length; ci++) {
      final elements = chars[ci].split('');
      for (var i = 0; i < elements.length; i++) {
        final w = (elements[i] == 'W' ? _wideRatio : 1) * unit;
        final isBar = i.isEven; // 0,2,4,6,8 = 막대 / 1,3,5,7 = 공백
        if (isBar) {
          canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
        }
        x += w;
      }
      if (ci != chars.length - 1) x += _interCharGap * unit;
    }
  }

  @override
  bool shouldRepaint(covariant _Code39Painter oldDelegate) => oldDelegate.digits != digits;
}
