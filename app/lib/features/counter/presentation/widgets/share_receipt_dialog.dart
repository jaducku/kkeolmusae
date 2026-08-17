import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/barcode.dart';
import '../../../../shared/widgets/dashed_line.dart';
import '../../../../shared/widgets/ink_button.dart';
import '../../../../shared/widgets/parrot_figure.dart';
import '../../../../shared/widgets/receipt_paper.dart';
import '../../../condition_select/domain/investment_target.dart';
import '../../../result/domain/simulation_result.dart';

/// docs/demo2.html `#shareModal` — 공유용 미니 영수증 카드 (PRD 2.5).
/// 9:16/1:1 이미지 익스포트 전, 실제 공유될 카드의 모양을 미리 보여준다.
Future<void> showShareReceipt(
  BuildContext context, {
  required SimulationResult result,
  required InvestmentTarget target,
  required String objLabel,
}) {
  final gain = !result.isLoss;
  final gap = result.gap;
  final line = gain
      ? '나는 $objLabel(으)로\n${target.name} ${_won(gap)}어치를\n마셨습니다'
      : '${target.name} 안 사고\n$objLabel 사길 잘했습니다';

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: AppColors.ink.withValues(alpha: 0.72),
    transitionDuration: const Duration(milliseconds: 420),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ReceiptPaper(
                maxWidth: 270,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ParrotFigure(
                      mood: gain ? ParrotMood.lv2 : ParrotMood.relief,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text('후회영수증', textAlign: TextAlign.center, style: AppTextStyles.title.copyWith(fontSize: 18)),
                    const SizedBox(height: 10),
                    const DashedLine.hr(),
                    const SizedBox(height: 12),
                    Text(line, textAlign: TextAlign.center, style: AppTextStyles.label.copyWith(height: 1.7)),
                    const SizedBox(height: 12),
                    DashedLine.thin(color: AppColors.border),
                    const SizedBox(height: 10),
                    Text('놓 친 돈', textAlign: TextAlign.center, style: AppTextStyles.bigLabel),
                    Text(
                      '${gain ? '+' : ''}${_won(gap)}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bigNumber.copyWith(
                        fontSize: 26,
                        color: gain ? AppColors.stamp : AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Barcode(digits: _digitsFrom(gap), height: 32),
                    const SizedBox(height: 6),
                    Text('껄무새상회 · kkeolmusae.app', textAlign: TextAlign.center, style: AppTextStyles.fine),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 140,
                child: InkButton(label: '닫기', onPressed: () => Navigator.of(context).pop()),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      // 방금 아래로 찢겨 떨어진 조각이 그대로 눈앞에 날아와 내려앉는 느낌 —
      // 찢김 애니메이션의 낙하/회전 방향을 이어받아 살짝 기운 채 아래에서
      // 위로 떠오르며 정면을 향해 펴진다.
      final t = Curves.easeOutBack.transform(animation.value.clamp(0.0, 1.0));
      final fade = animation.value.clamp(0.0, 1.0);
      return Opacity(
        opacity: fade,
        child: Transform.translate(
          offset: Offset(0, (1 - t) * 64),
          child: Transform.rotate(
            angle: (1 - t) * -0.16,
            child: Transform.scale(
              scale: 0.9 + t * 0.1,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

String _won(double n) {
  final s = n.abs().round().toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
    buf.write(s[i]);
  }
  return '$buf원';
}

String _digitsFrom(double gap) {
  final digits = gap.abs().round().toString().replaceAll(RegExp(r'[^0-9]'), '');
  final padded = digits.padLeft(10, '8');
  return padded.substring(padded.length - 10);
}
