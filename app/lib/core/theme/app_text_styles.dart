import 'package:flutter/material.dart';
import 'app_colors.dart';

/// docs/demo2.html 활자 토큰 — 픽셀 폰트(DungGeunMo)는 "숫자·라벨" 포인트에만
/// 쓰고, 실제로 읽는 본문(아이템명·버튼·설명)은 Pretendard 로 넘긴다.
/// v1 은 전부 픽셀 폰트라 가독성이 떨어지고 촌스러워 보였다는 피드백을 반영.
abstract final class AppTextStyles {
  static const String _mono = 'DungGeunMo';
  static const String _sans = 'Pretendard';

  // ---- 포인트(mono) ----
  static const TextStyle shopLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 11.5,
    fontWeight: FontWeight.w500,
    color: AppColors.deskNoteText,
    letterSpacing: 2.76,
  );

  /// 공유 카드 등 별도 타이틀 문구가 필요할 때만 쓴다 (헤더는 [Wordmark] 사용).
  static const TextStyle title = TextStyle(
    fontFamily: _mono,
    fontSize: 21,
    color: AppColors.ink,
    letterSpacing: 5.46,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _mono,
    fontSize: 11,
    color: AppColors.muted,
    letterSpacing: 0.55,
    height: 1.5,
  );

  static const TextStyle sectionHead = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    color: AppColors.ink,
    letterSpacing: 1.82,
  );

  static const TextStyle fine = TextStyle(
    fontFamily: _sans,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: Color(0xFFA8A29E),
    height: 1.75,
    letterSpacing: 0.1,
  );

  static const TextStyle kvKey = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    color: AppColors.muted,
  );

  static const TextStyle kvValue = TextStyle(
    fontFamily: _mono,
    fontSize: 13,
    color: AppColors.ink,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle bigLabel = TextStyle(
    fontFamily: _mono,
    fontSize: 11,
    color: AppColors.muted,
    letterSpacing: 2.64,
  );

  static const TextStyle bigNumber = TextStyle(
    fontFamily: _mono,
    fontSize: 36,
    color: AppColors.ink,
    fontFeatures: [FontFeature.tabularFigures()],
    height: 1.1,
  );

  static const TextStyle diffGain = TextStyle(
    fontFamily: _mono,
    fontSize: 14,
    color: AppColors.stamp,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle diffLoss = TextStyle(
    fontFamily: _mono,
    fontSize: 14,
    color: AppColors.muted,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle barcodeDigits = TextStyle(
    fontFamily: _mono,
    fontSize: 10,
    color: AppColors.muted,
    letterSpacing: 5,
  );

  static const TextStyle qtyValue = TextStyle(
    fontFamily: _mono,
    fontSize: 14,
    color: AppColors.ink,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  // ---- 본문(sans) ----
  static const TextStyle itemName = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
    letterSpacing: -0.15,
  );

  static const TextStyle itemNameSelected = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.greenDark,
    letterSpacing: -0.15,
  );

  static const TextStyle itemPrice = TextStyle(
    fontFamily: _mono,
    fontSize: 11.5,
    color: AppColors.muted,
  );

  static const TextStyle qtyLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.muted,
    letterSpacing: 0.2,
  );

  static const TextStyle qtySub = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    color: AppColors.muted,
    height: 1.5,
  );

  static const TextStyle qtySubStrong = TextStyle(
    fontFamily: _sans,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    color: AppColors.greenDark,
    height: 1.5,
  );

  static const TextStyle sumAmount = TextStyle(
    fontFamily: _mono,
    fontSize: 17,
    color: AppColors.ink,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle mascotSay = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
    letterSpacing: -0.15,
    height: 1.4,
  );

  static const TextStyle mascotConv = TextStyle(
    fontFamily: _sans,
    fontSize: 12.5,
    color: AppColors.muted,
    height: 1.65,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontFamily: _sans,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.paper,
    letterSpacing: -0.15,
  );

  static const TextStyle textLink = TextStyle(
    fontFamily: _sans,
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.muted,
  );

  static const TextStyle option = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle optionSelected = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.paper,
  );

  static const TextStyle chip = TextStyle(
    fontFamily: _sans,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  static const TextStyle chipSelected = TextStyle(
    fontFamily: _sans,
    fontSize: 12.5,
    fontWeight: FontWeight.w600,
    color: AppColors.paper,
  );

  static const TextStyle label = TextStyle(
    fontFamily: _sans,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );
}
