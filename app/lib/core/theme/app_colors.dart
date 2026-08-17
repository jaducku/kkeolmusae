import 'package:flutter/material.dart';

/// 껄무새상회 컬러 토큰 — docs/demo2.html (v2 리파인) 팔레트.
///
/// v1(demo.html)의 채도 높은 머스터드+순검정 대비는 "장난감스럽다"는
/// 피드백을 받아, 차분한 웜 스톤 뉴트럴 + 소프트 섀도로 톤을 낮췄다.
/// 레드(스탬프)는 이제 "후회의 순간"(도장·차액·재정산 선택)에만 쓰고,
/// 나머지 강조는 로고 그린이 맡는다.
abstract final class AppColors {
  static const Color desk = Color(0xFFECE9E1); // 차분한 웜 그레이 데스크
  static const Color paper = Color(0xFFFFFEFA); // 종이
  static const Color ink = Color(0xFF1C1917); // stone-900
  static const Color muted = Color(0xFF79746B); // stone-500
  static const Color border = Color(0xFFE7E4DC); // stone-200
  static const Color hoverBg = Color(0xFFF6F4EE);
  static const Color panelBg = Color(0xFFFAF8F3); // 수량 패널 배경
  static const Color chartBg = Color(0xFFFCFBF7);

  static const Color green = Color(0xFF2FA45B); // 로고 그린 — 주요 CTA
  static const Color greenDark = Color(0xFF237E46);
  static const Color stamp = Color(0xFFE0442E); // 인주 — 후회에만 사용

  static const Color deskNoteText = Color(0xFFA39D91);

  /// 손실(안도) 상태의 도장/포인트 컬러.
  static const Color relief = green;
}
