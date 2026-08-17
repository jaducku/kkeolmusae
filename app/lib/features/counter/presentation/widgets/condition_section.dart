import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_line.dart';
import '../../../../shared/widgets/ink_button.dart';
import '../../../../shared/widgets/option_chip.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../condition_select/application/simulation_condition_provider.dart';
import '../../../condition_select/domain/investment_target.dart';

/// docs/demo2.html `#secCond` — 정 산 조 건.
class ConditionSection extends ConsumerWidget {
  const ConditionSection({super.key, required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final condition = ref.watch(simulationConditionProvider);
    final notifier = ref.read(simulationConditionProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const DashedLine.hr(),
        const SizedBox(height: 14),
        const SectionHeader('정 산 조 건'),
        const SizedBox(height: 14),
        Text('회한 기간', style: AppTextStyles.fine),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: SimulationPeriod.values.map((period) {
            return OptionChip(
              label: period.label,
              selected: condition.period == period,
              onTap: () => notifier.selectPeriod(period),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Text('그 돈으로 샀다면 (환생 종목)', style: AppTextStyles.fine),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: kInvestmentTargets.map((target) {
            return OptionChip(
              label: target.name,
              selected: condition.target.id == target.id,
              onTap: () => notifier.selectTarget(target),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        InkButton(label: '후회 정산 시작', emphasis: true, onPressed: onSubmit),
      ],
    );
  }
}
