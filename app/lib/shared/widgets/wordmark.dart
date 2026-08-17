import 'package:flutter/material.dart';

/// docs/demo2.html `.logo-img` — 아이콘+"껄무새" 텍스트가 합쳐진 로고 렌더.
/// v1 처럼 아이콘과 픽셀 폰트 텍스트를 따로 조합하지 않고, 실제 로고 자산을
/// 그대로 쓴다.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.width = 112});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/wordmark.png',
      width: width,
      fit: BoxFit.contain,
    );
  }
}
