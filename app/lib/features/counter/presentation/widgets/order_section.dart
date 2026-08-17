import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/dashed_line.dart';
import '../../../../shared/widgets/ink_button.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../consumption_input/application/consumption_selection_provider.dart';
import '../../../consumption_input/domain/spending_preset.dart';
import 'item_row.dart';

/// docs/demo2.html `#secOrder` — 주 문 내 역.
class OrderSection extends ConsumerWidget {
  const OrderSection({super.key, required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(consumptionSelectionProvider);
    final monthlyTotal = ref.watch(monthlyTotalProvider);
    final notifier = ref.read(consumptionSelectionProvider.notifier);
    final hasSelection = selection.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader('주 문 내 역'),
        const SizedBox(height: 10),
        Text(
          '※ 평소 새는 돈을 주문하듯 골라주세요',
          textAlign: TextAlign.center,
          style: AppTextStyles.fine,
        ),
        const SizedBox(height: 8),
        ...kSpendingPresets.asMap().entries.map((entry) {
          final preset = entry.value;
          final current = selection[preset.id];
          return ItemRow(
            preset: preset,
            selected: current != null,
            selection: current,
            showTopDivider: entry.key > 0,
            onTap: () => notifier.toggle(preset),
            onAmountChanged: (amount) => notifier.updateAmount(preset.id, amount),
            onCountChanged: (count) => notifier.updateCount(preset.id, count),
            onCustomLabelChanged: (label) => notifier.updateCustomLabel(preset.id, label),
          );
        }),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text('월 합계', style: AppTextStyles.label),
            DottedLeader(color: AppColors.border),
            Text('${monthlyTotal.toStringAsFixed(0)}원', style: AppTextStyles.sumAmount),
          ],
        ),
        const SizedBox(height: 16),
        InkButton(
          label: '주문 넣기',
          onPressed: hasSelection ? onSubmit : null,
        ),
      ],
    );
  }
}
