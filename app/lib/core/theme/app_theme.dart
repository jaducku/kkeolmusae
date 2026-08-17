import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// docs/demo2.html 을 따르는 라이트 전용 테마 — 라운드 코너 + 소프트 섀도.
abstract final class AppTheme {
  static ThemeData get receipt {
    final base = ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      fontFamily: 'Pretendard',
      scaffoldBackgroundColor: AppColors.desk,
      colorScheme: const ColorScheme.light(
        surface: AppColors.paper,
        primary: AppColors.ink,
        secondary: AppColors.green,
        error: AppColors.stamp,
        onSurface: AppColors.ink,
        onPrimary: AppColors.paper,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.paper,
          disabledBackgroundColor: AppColors.ink.withValues(alpha: 0.22),
          disabledForegroundColor: AppColors.paper,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
          textStyle: AppTextStyles.buttonLabel,
        ),
      ),
    );
  }
}
