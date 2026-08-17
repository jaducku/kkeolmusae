import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/dashed_line.dart';
import '../../../shared/widgets/ink_button.dart';
import '../../../shared/widgets/receipt_paper.dart';
import '../../../shared/widgets/wordmark.dart';

/// PRD 2.1 — 스킵 가능한 1화면 온보딩. docs/demo2.html 톤에 맞춰
/// "영수증 발급기 전원 버튼"처럼 연출한다.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeskBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: ReceiptPaper(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: Wordmark(width: 120)),
                    const SizedBox(height: 6),
                    Text('후회 영수증 발급기 · 24시간 영업', textAlign: TextAlign.center, style: AppTextStyles.subtitle),
                    const SizedBox(height: 20),
                    const DashedLine.hr(),
                    const SizedBox(height: 20),
                    Text(
                      '당신의 커피값,\n주식이었다면?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.itemName.copyWith(fontSize: 20, height: 1.4),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '어서 와… 후회할 준비 됐어? 🦜',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subtitle,
                    ),
                    const SizedBox(height: 24),
                    InkButton(
                      label: '발급기 시작',
                      emphasis: true,
                      onPressed: () => context.go(AppRoutes.counter),
                    ),
                    TextLinkButton(
                      label: '건너뛰기',
                      onPressed: () => context.go(AppRoutes.counter),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
