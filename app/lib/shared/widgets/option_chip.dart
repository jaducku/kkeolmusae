import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// docs/demo2.html `.opt` — 라운드 아웃라인 칩. 선택 시 잉크로 채워진다.
/// [emphasisWhenSelected] 는 결과 화면의 종목 재선택 칩(`.opt.red.on`)에 쓰며,
/// 실제 색은 브랜드 그린이다 (레드는 도장에만 남겨둔다).
class OptionChip extends StatelessWidget {
  const OptionChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.emphasisWhenSelected = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool emphasisWhenSelected;

  @override
  Widget build(BuildContext context) {
    final fillColor = selected
        ? (emphasisWhenSelected ? AppColors.green : AppColors.ink)
        : AppColors.paper;
    final borderColor = selected ? fillColor : AppColors.border;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 130),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: borderColor),
          boxShadow: selected
              ? null
              : [BoxShadow(color: AppColors.ink.withValues(alpha: 0.05), blurRadius: 2, offset: const Offset(0, 1))],
        ),
        child: Text(
          label,
          style: selected ? AppTextStyles.optionSelected : AppTextStyles.option,
        ),
      ),
    );
  }
}
